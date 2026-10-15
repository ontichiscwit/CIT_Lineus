# -*- coding: utf-8 -*-
"""
[AX Lab] AS 통합화면 AI 추천 — 추천 엔진 (설계서 §6 요청/응답 · §7-3 랭킹)

이 모듈은 저장소(로컬 npz / 나중의 pgvector)와 무관한 순수 랭킹 로직 + 로컬 인덱스 구현을 담는다.
AWS 이관 시 Django `gpt/views_recommend.py` 는 이 파일의 `Recommender.recommend()` 를 그대로 호출하고,
`LocalIndex` 만 `rag_cases` 를 읽는 구현으로 바꾸면 된다.

점수 (§7-3, 2026-10-06 하이브리드 개정)
  relevance = ALPHA * dense_norm + (1 - ALPHA) * lexical_norm          # 후보 집합 안에서 각각 0~1 로 정규화
  score     = 0.55 * relevance + 0.20 * product_match + 0.15 * tier_weight + 0.10 * quality_score
  dense     : bge-m3 코사인. 이 코퍼스에서는 상위 60건이 0.63~0.70 에 몰려 절대값을 그대로 쓰면 ±0.02 차이뿐이라
              tier/quality 가 순위를 결정해 버린다 → 후보 집합 min-max 로 펴서 쓴다.
  lexical   : BM25 (combine_lexical.py, 어절+2-gram). "마약류투약정보조회" 같은 희귀 결정 용어를 살린다.
  product_match : service_cate 일치 1.0 / 없으면 program_nm·screen_nm 일치 1.0 / inquiry_type 일치 0.6 / 그 외 0
  tier_weight   : Tier1 1.0, Tier2 0.7, Tier3 0.5
구성 규칙 (§7-3 Tier 최소 노출)
  - 상위 5건 중 Tier1 최소 1건 (relevance ≥ TIER1_FLOOR 인 Tier1 이 있을 때만)
  - 상위 5건 중 Tier2 최대 3건
  - 같은 topic + 같은 service_cate 조합은 최대 2건
  - exclude_as_no[] (자신·부모·자식·연결건) 제외, dense 코사인 < MIN_SIM 은 제외
질의 전처리 (§9 3-1 + 2026-10-06)
  - combine_textprep.parse_question 으로 접수 템플릿(라벨·안내문)을 벗기고 프로그램명/화면명을 메타로 뽑는다.
    CRM 은 CALL_CONTENT 원문을 그대로 보내면 된다 — 전처리 규칙은 적재 쪽과 공용 모듈(combine_textprep) 한 곳에서만 관리한다.
  - combine_textprep.mask_regex (1겹) 적용 후 임베딩. 질의는 저장하지 않는다 (로그·캐시 위생).
  - 어휘 질의에는 프로그램명·화면명을 덧붙인다 (가장 강한 어휘 신호).

데이터
  data/combine_index.npz · data/combine_unified.jsonl  (환경변수 COMBINE_DATA_DIR 로 위치 변경 가능)
  두 파일은 analysis/combine_embed.py 가 함께 만들어 여기로 복사한다. 건수가 다르면 기동 시 assert 로 멈춘다.

CLI (패키지 폴더에서)
  python combine_recommend.py "수납 취소가 안됩니다" --service-cate 원무
  python combine_recommend.py --as-no 20260323050          # 인덱스 안의 Tier2 문의로 자기제외 검색
  python combine_recommend.py --sample 20 --seed 1         # 눈 검증용 무작위 20건
"""
import argparse
import json
import os
import random
import re
import sys
import time
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parent))
from combine_textprep import mask_regex, parse_question        # noqa: E402  1겹 마스킹 · 접수 템플릿 제거/프로그램명·화면명 추출
from combine_embed_client import embed_one, OLLAMA_HOST, EMBED_MODEL  # noqa: E402
from combine_lexical import BM25Index                          # noqa: E402  어휘 검색
from combine_synonyms import expand as expand_synonyms         # noqa: E402  [AX Lab] 2026-10-12 질의 도메인 동의어 확장

BASE_DIR = Path(__file__).resolve().parent
# 색인 데이터 위치. 기본은 이 패키지의 data/ (analysis/combine_embed.py 가 색인을 만들고 여기로 복사한다).
OUT_DIR = Path(os.getenv("COMBINE_DATA_DIR", BASE_DIR / "data"))

W_SEM, W_PROD, W_TIER, W_QUAL = 0.55, 0.20, 0.15, 0.10
TIER_WEIGHT = {1: 1.0, 2: 0.7, 3: 0.5}
TIER_LABEL = {1: "표준답변", 2: "과거사례", 3: "공지"}
ALPHA = 0.5             # relevance = ALPHA*dense_norm + (1-ALPHA)*lexical_norm (평가셋으로 재조정)
MIN_SIM = 0.35          # dense 코사인이 이 아래면 무관으로 보고 후보에서 제외
TIER1_FLOOR = 0.35      # Tier1 최소 보장을 발동시키는 relevance 하한
REL_FLOOR = 0.30        # 이 아래 relevance 는 어떤 규칙으로도 노출하지 않는다 (후보 집합 정규화 기준)
TIER2_CAP = 3           # 1차 선발 상한. 칸이 남으면 풀린다 (compose 참조)
DUP_CAP = 2
CANDIDATES = 60         # dense 상위 N ∪ lexical 상위 N 을 후보 집합으로 삼아 재랭킹
# [AX Lab] 수정 시작 (2026-10-12 AX Lab): 절대 확신도.
#   relevance 는 후보 집합 안 min-max 라 "그나마 가장 가까운 것" 도 항상 100% 로 보인다 (테스터 테스트3 에서 전부 무관한데
#   관련도 80~100% 로 표시). 그래서 bge-m3 절대 코사인으로 high/mid/low 를 따로 내려 화면이 '확신 낮음' 을 표시하게 한다.
#   실측(2026-10-12, 기존 색인): Tier2 자기질의 150건의 상위 1건 코사인 p10 0.638 / p50 0.717,
#   도메인 밖 무관 질의("회의실 예약", "점심 메뉴", "프린터 토너", "엑셀 피벗") 의 상위 1건은 0.52~0.57,
#   테스터 테스트3 의 무관 결과(동의어 확장 전) 상위 1건은 0.548 → high ≥ 0.62, low < 0.58 로 잡는다.
CONF_HIGH_SIM = 0.62
CONF_LOW_SIM = 0.58


def confidence_of(sim):
    if sim >= CONF_HIGH_SIM:
        return "high"
    if sim >= CONF_LOW_SIM:
        return "mid"
    return "low"
# [AX Lab] 수정 끝


# ---------------------------------------------------------------- 인덱스
class LocalIndex:
    """combine_index.npz + combine_unified.jsonl 를 메모리에 올린 인덱스.

    객체 자체는 만들어진 뒤 바뀌지 않는다(읽기 전용). 라이브 델타(§7-2 준실시간)는 apply_live() 가
    델타를 반영한 **새 객체**를 돌려주고, 서버는 Recommender.index 참조를 통째로 바꿔 끼운다.
    그래서 요청 처리 중인 스레드는 끝까지 자기가 잡은 객체를 보고, 잠금이 필요 없다.
    """

    def __init__(self, out_dir=OUT_DIR):
        z = np.load(out_dir / "combine_index.npz", allow_pickle=False)
        self.vectors = z["vectors"]
        self.doc_ids = list(z["doc_ids"])
        self.model = str(z["model"])
        self.built_at = str(z["built_at"])
        self.meta = {}
        for line in (out_dir / "combine_unified.jsonl").open(encoding="utf-8"):
            r = json.loads(line)
            self.meta[r["doc_id"]] = r
        assert len(self.meta) == len(self.doc_ids), "unified 와 index 건수 불일치 — combine_embed.py 재실행"
        # [AX Lab] 수정 시작 (2026-10-15 AX Lab): 준실시간 반영 — 라이브 델타 적용 상태를 들고 다닌다
        self.live_upserts = 0       # 이 객체에 반영된 라이브 upsert 누계 (기본 색인 재적재 시 0 부터)
        self.live_deletes = 0
        self.live_last_ts = None    # 마지막으로 반영한 델타의 ts (combine_live.py 가 기록한 처리 시각)
        self._finalize()

    def _finalize(self):
        """doc_ids/vectors/meta 가 확정된 뒤 파생 배열과 어휘 색인을 만든다 (생성·델타 적용 공통)."""
        # [AX Lab] 수정 끝
        self.tiers = np.asarray([self.meta[d]["tier"] for d in self.doc_ids], dtype=np.int8)
        self.as_nos = np.asarray([self.meta[d].get("as_no") or "" for d in self.doc_ids])
        # 어휘 색인 — 임베딩에 쓴 것과 같은 embed_text 로 만든다 (dense/lexical 이 같은 본문을 본다)
        self.lexical = BM25Index([self.meta[d].get("embed_text") or "" for d in self.doc_ids])

    # [AX Lab] 수정 시작 (2026-10-15 AX Lab): 준실시간 반영 — 라이브 델타(upsert/delete) 를 적용한 새 인덱스
    def apply_live(self, entries):
        """analysis/combine_live.py 가 data/combine_live.jsonl 에 쓴 델타를 반영한 **새** LocalIndex 를 돌려준다.

        entries: [{"op": "upsert", "doc_id", "ts", "record": {통합 스키마 레코드}, "vector": [1024 floats]}
                  | {"op": "delete", "doc_id", "ts"}]  (파일에 적힌 순서대로 적용한다 — 같은 doc_id 는 마지막 것이 이긴다)
        - upsert 는 doc_id 가 있으면 벡터·본문을 교체, 없으면 끝에 추가한다.
        - delete 는 doc_id 가 없으면 무시한다 (색인에 없던 건이 게이트 탈락한 경우).
        - 벡터는 길이 검사 후 L2 정규화한다 (코사인 = 내적 전제).
        BM25 는 전량 재생성한다 (11.7천 건 3.5초 — 백그라운드 스레드에서 하므로 요청 지연에는 영향 없음).
        """
        if not entries:
            return self
        dim = self.vectors.shape[1]
        pos = {d: i for i, d in enumerate(self.doc_ids)}
        vectors = self.vectors.copy()
        doc_ids = list(self.doc_ids)
        meta = dict(self.meta)
        add_ids, add_vecs, drop = [], [], set()
        n_up = n_del = 0
        last_ts = self.live_last_ts
        for e in entries:
            op, doc_id = e.get("op"), e.get("doc_id")
            if not doc_id:
                continue
            last_ts = e.get("ts") or last_ts
            if op == "upsert":
                rec, vec = e.get("record") or {}, e.get("vector")
                if rec.get("doc_id") != doc_id or not isinstance(vec, list) or len(vec) != dim or "tier" not in rec:
                    continue                                      # 깨진 줄은 건너뛴다 (파일 끝 부분 기록 중 등)
                v = np.asarray(vec, dtype=np.float32)
                n = float(np.linalg.norm(v)) or 1.0
                v /= n
                meta[doc_id] = rec
                if doc_id in pos:
                    vectors[pos[doc_id]] = v
                    drop.discard(doc_id)
                elif doc_id in add_ids:
                    add_vecs[add_ids.index(doc_id)] = v
                else:
                    add_ids.append(doc_id)
                    add_vecs.append(v)
                n_up += 1
            elif op == "delete":
                if doc_id in pos:
                    drop.add(doc_id)
                    n_del += 1
                elif doc_id in add_ids:
                    i = add_ids.index(doc_id)
                    add_ids.pop(i); add_vecs.pop(i)
                    n_del += 1
                meta.pop(doc_id, None)
        if drop:
            keep = np.asarray([d not in drop for d in doc_ids])
            vectors = vectors[keep]
            doc_ids = [d for d in doc_ids if d not in drop]
        if add_ids:
            vectors = np.vstack([vectors, np.stack(add_vecs)]) if len(doc_ids) else np.stack(add_vecs)
            doc_ids += add_ids
        new = LocalIndex.__new__(LocalIndex)
        new.vectors, new.doc_ids, new.meta = vectors, doc_ids, meta
        new.model, new.built_at = self.model, self.built_at
        new.live_upserts, new.live_deletes = self.live_upserts + n_up, self.live_deletes + n_del
        new.live_last_ts = last_ts
        new._finalize()
        return new
    # [AX Lab] 수정 끝

    def _mask(self, tiers, exclude_as_no):
        mask = np.isin(self.tiers, list(tiers))
        if exclude_as_no:
            mask &= ~np.isin(self.as_nos, list(exclude_as_no))
        return mask

    @staticmethod
    def _topk(scores, mask, k, floor):
        s = np.where(mask, scores, -np.inf)
        k = min(k, int(mask.sum()))
        if k <= 0:
            return np.asarray([], dtype=int)
        idx = np.argpartition(-s, k - 1)[:k]
        idx = idx[np.argsort(-s[idx])]
        return idx[s[idx] > floor]

    def search(self, qvec, tiers, exclude_as_no, k):
        """dense 단독 검색 → [(doc_id, cosine)]. 비교·디버그용으로 남겨 둔다."""
        mask = self._mask(tiers, exclude_as_no)
        sims = self.vectors @ qvec
        return [(self.doc_ids[i], float(sims[i])) for i in self._topk(sims, mask, k, -1.0)]

    def search_hybrid(self, qvec, q_lex, tiers, exclude_as_no, k, alpha=ALPHA, min_sim=MIN_SIM):
        """dense 상위 k ∪ lexical 상위 k 를 후보로 모아 각 점수를 후보 안에서 min-max 정규화해 섞는다.

        반환: [(doc_id, cosine, lexical_raw, relevance)]  relevance 내림차순.
        - cosine < min_sim 인 문서는 어휘 점수가 있어도 제외한다 (의미적으로 무관한 단어 일치 방지).
        - 어휘 점수가 0 인 문서(질의 단어가 하나도 없음)는 lexical_norm 0 으로 들어간다.
        """
        mask = self._mask(tiers, exclude_as_no)
        sims = self.vectors @ qvec
        lex = self.lexical.scores(q_lex)
        cand = np.union1d(self._topk(sims, mask, k, min_sim), self._topk(lex, mask, k, 0.0))
        cand = cand[sims[cand] >= min_sim]
        if cand.size == 0:
            return []
        d, l = sims[cand], lex[cand]
        d_n = (d - d.min()) / (d.max() - d.min()) if d.max() > d.min() else np.ones_like(d)
        l_n = l / l.max() if l.max() > 0 else np.zeros_like(l)
        rel = alpha * d_n + (1 - alpha) * l_n
        order = np.argsort(-rel)
        return [(self.doc_ids[cand[i]], float(d[i]), float(l[i]), float(rel[i])) for i in order]

    def get(self, doc_id):
        return self.meta[doc_id]


# [AX Lab] 수정 시작 (2026-10-15 AX Lab): 응답·/health 공용 색인 정보 (라이브 반영 상태 포함)
def index_info(index):
    return {"model": index.model, "built_at": index.built_at, "size": len(index.doc_ids),
            "live_upserts": getattr(index, "live_upserts", 0), "live_deletes": getattr(index, "live_deletes", 0),
            "live_last_ts": getattr(index, "live_last_ts", None)}
# [AX Lab] 수정 끝


# ---------------------------------------------------------------- 랭킹
def _norm(s):
    return re.sub(r"\s+", "", (s or "")).lower()


def product_match(q, d):
    """현재 문의(q) 와 후보(d) 의 제품/업무 일치도. service_cate 우선, program/screen 폴백 (§7-3)."""
    qs, ds = _norm(q.get("service_cate")), _norm(d.get("service_cate"))
    if qs and ds:
        if qs == ds:
            return 1.0
        # service_cate 가 다르면 화면이 같을 수 없다 — 단, 큐레이션 Tier1 라벨은 LLM 추정이라 0.3 만 깎는다
        return 0.0 if d.get("tier") == 2 else 0.3
    qp = {_norm(q.get("program_nm")), _norm(q.get("screen_nm"))} - {""}
    dp = {_norm(d.get("program_nm")), _norm(d.get("screen_nm"))} - {""}
    if qp and dp and (qp & dp):
        return 1.0
    qi, di = _norm(q.get("inquiry_type")), _norm(d.get("inquiry_type"))
    if qi and di and qi == di:
        return 0.6
    return 0.0


def score(rel, pm, tier, quality):
    """rel 은 후보 집합 안에서 0~1 로 정규화된 하이브리드 관련도 (search_hybrid 의 relevance)."""
    return W_SEM * rel + W_PROD * pm + W_TIER * TIER_WEIGHT.get(tier, 0.5) + W_QUAL * float(quality or 0)


def prepare_query(raw):
    """CRM 이 보낸 CALL_CONTENT 원문 → (임베딩용 본문, 어휘 질의, 추출 메타).

    1) parse_question: 접수 템플릿(프로그램명/화면명/발생일시/환자등록번호 라벨, 안내문) 제거 + 메타 추출
    2) mask_regex    : 1겹 정규식 마스킹 (§9 3-1). 결과는 저장·로그하지 않는다.
    템플릿이 없는 자유 서술이면 1) 은 안내문만 지우고 그대로 둔다.
    """
    body, meta = parse_question(raw or "")
    body = body or (raw or "")
    q_text = mask_regex(body)[0].strip()
    names = " ".join(v for v in (meta.get("program_nm"), meta.get("screen_nm")) if v)
    # [AX Lab] 수정 시작 (2026-10-12 AX Lab): 도메인 동의어 확장 (combine_synonyms.RULES).
    #   현장어(산재 지사) ↔ 시스템어(산재조합/보험거래처코드) 격차로 정답이 후보에도 못 들던 문제. 질의에만 적용한다.
    syn_dense, syn_lex = expand_synonyms(q_text + " " + names)
    if syn_dense:
        q_text = q_text + "\n" + syn_dense
    q_lex = " ".join(x for x in (q_text, names, syn_lex) if x).strip()
    meta = dict(meta, synonyms=(syn_dense + " " + syn_lex).strip())
    # [AX Lab] 수정 끝
    return q_text, q_lex, meta


def compose(ranked, top_k):
    """점수순 후보 → Tier 최소 노출·상한·중복 억제 적용 (§7-3).

    relevance < REL_FLOOR 인 후보는 어떤 규칙으로도 노출하지 않는다 — 후보가 9천 건 중 60건이라
    Tier2 상한에 걸리면 '그나마 남은' 무관한 Tier1/Tier3 가 5번째 칸을 채우던 문제(2026-10-06) 방지.
    Tier2 상한은 1차 선발에서만 적용하고, 그래도 칸이 남으면 상한을 풀어 관련도 순으로 채운다(연성 상한).
    """
    ranked = [c for c in ranked if c.get("relevance", 1.0) >= REL_FLOOR]
    chosen, dup = [], {}
    t2 = 0
    for c in ranked:
        if len(chosen) >= top_k:
            break
        if c["tier"] == 2 and t2 >= TIER2_CAP:
            continue
        key = (c.get("topic") or "", c.get("service_cate") or "")
        if key != ("", "") and dup.get(key, 0) >= DUP_CAP:
            continue
        chosen.append(c)
        dup[key] = dup.get(key, 0) + 1
        t2 += c["tier"] == 2
    if len(chosen) < top_k:                               # 연성 상한 — Tier2 상한만 풀고 중복 억제는 유지
        for c in ranked:
            if len(chosen) >= top_k:
                break
            if c in chosen:
                continue
            key = (c.get("topic") or "", c.get("service_cate") or "")
            if key != ("", "") and dup.get(key, 0) >= DUP_CAP:
                continue
            chosen.append(c)
            dup[key] = dup.get(key, 0) + 1
        chosen.sort(key=lambda c: -c["score"])
    # Tier1 최소 1건 보장
    if top_k >= 3 and not any(c["tier"] == 1 for c in chosen):
        best_t1 = next((c for c in ranked if c["tier"] == 1 and c["relevance"] >= TIER1_FLOOR and c not in chosen), None)
        if best_t1:
            if len(chosen) >= top_k:
                # 가장 점수 낮은 비-Tier1 을 빼고 넣는다
                drop = min((c for c in chosen if c["tier"] != 1), key=lambda c: c["score"], default=None)
                if drop:
                    chosen.remove(drop)
            chosen.append(best_t1)
            chosen.sort(key=lambda c: -c["score"])
    return chosen[:top_k]


class Recommender:
    def __init__(self, index, embed_fn=None):
        self.index = index
        self.embed_fn = embed_fn or embed_one

    def recommend(self, query, *, as_no=None, exclude_as_no=None, service_cate=None, inquiry_type=None,
                  request_type=None, program_nm=None, screen_nm=None, top_k=5, tiers=(1, 2, 3)):
        t0 = time.time()
        q_text, q_lex, qm = prepare_query(query)             # 템플릿 제거 → 1겹 마스킹. 저장 안 함
        if not q_text:
            return {"result": "400", "message": "query 가 비어 있습니다", "items": [], "elapsed_ms": 0}
        excl = set(x for x in (exclude_as_no or []) if x)
        if as_no:
            excl.add(str(as_no))
        # [AX Lab] 수정 (2026-10-15 AX Lab): 준실시간 반영 — 처리 도중 self.index 가 새 객체로 바뀌어도
        #   이 요청은 처음 잡은 객체만 본다 (search 결과 doc_id 를 get() 에서 못 찾는 일 방지)
        index = self.index
        qvec = self.embed_fn(q_text)
        cands = index.search_hybrid(qvec, q_lex, tiers, excl, CANDIDATES)
        # 호출자가 안 준 프로그램명/화면명은 질의 템플릿에서 뽑은 값으로 채운다 (product_match 폴백용)
        qmeta = {"service_cate": service_cate, "inquiry_type": inquiry_type,
                 "program_nm": program_nm or qm.get("program_nm"), "screen_nm": screen_nm or qm.get("screen_nm")}
        ranked = []
        for doc_id, sim, lex, rel in cands:
            d = index.get(doc_id)
            pm = product_match(qmeta, d)
            ranked.append({**self._item(d), "semantic_sim": round(sim, 4), "lexical_score": round(lex, 2),
                           "relevance": round(rel, 4), "product_match": pm,
                           # [AX Lab] 2026-10-12: 절대 코사인 기준 확신도 (relevance 는 후보 안 상대값이라 항상 상위가 100%)
                           "confidence": confidence_of(sim),
                           "score": round(score(rel, pm, d["tier"], d["quality_score"]), 4)})
        ranked.sort(key=lambda c: -c["score"])
        items = compose(ranked, top_k)
        for it in items:
            it.pop("product_match", None)
        # [AX Lab] 수정 시작 (2026-10-12 AX Lab): 결과 전체 확신도 = 노출 항목 중 가장 높은 절대 코사인 기준
        best_sim = max((it["semantic_sim"] for it in items), default=0.0)
        # [AX Lab] 수정 끝
        return {"result": "000", "elapsed_ms": int((time.time() - t0) * 1000), "items": items,
                "confidence": confidence_of(best_sim), "best_sim": round(best_sim, 4),
                "index": index_info(index)}

    @staticmethod
    def _item(d):
        """API 응답 항목 (§6). cust_code/cust_nm 은 애초에 인덱스에 없다."""
        return {
            "doc_id": d["doc_id"], "tier": d["tier"], "tier_label": TIER_LABEL[d["tier"]], "source_type": d["source_type"],
            "title": d["title"], "answer_text": d["answer_text"], "answer_html": d["answer_html"],
            "internal_note": d.get("internal_note"), "topic": d.get("topic"), "resolution": d.get("resolution"),
            "service_cate": d.get("service_cate"), "program_nm": d.get("program_nm"), "screen_nm": d.get("screen_nm"),
            "deep_link": d.get("deep_link"), "attached_file": d.get("attached_file") or [],
            "occurred_at": d.get("occurred_at"), "quality_score": d.get("quality_score"),
            # §6 표 밖의 보조 필드 — CRM 화면(combine-as-ai.js)이 쓴다.
            #  as_no        : Tier2 '원본 접수건 열기' (doc_id 파싱 대신 명시)
            #  question_text: Tier2 '원 문의 보기' (마스킹 완료 텍스트 — combine_cases_masked 기준)
            #  public_link  : Tier3 고객용 라인어스 게시물 주소 (답변에 안내용으로 붙일 수 있게)
            "as_no": d.get("as_no"), "question_text": d.get("question_text"), "public_link": d.get("public_link"),
        }


# ---------------------------------------------------------------- CLI
def _print(res, show_body=False):
    print(f"result={res['result']} elapsed={res.get('elapsed_ms')}ms confidence={res.get('confidence')} best_sim={res.get('best_sim')}")
    for i, it in enumerate(res["items"], 1):
        line = (f" {i}. [{it['tier_label']}] {it['title'][:44]:44} rel={it['relevance']:.2f} "
                f"(cos={it['semantic_sim']:.3f} bm25={it['lexical_score']:.1f} {it.get('confidence', '')}) score={it['score']:.3f}")
        if it.get("service_cate"):
            line += f" · {it['service_cate']}"
        if it.get("topic"):
            line += f" · {it['topic']}"
        print(line)
        if show_body:
            print("      " + (it["answer_text"] or "")[:200].replace("\n", " / "))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("query", nargs="?")
    ap.add_argument("--as-no", help="인덱스 안의 Tier2 문의를 질의로 사용 (자기 제외)")
    ap.add_argument("--service-cate"); ap.add_argument("--inquiry-type")
    ap.add_argument("--top-k", type=int, default=5)
    ap.add_argument("--tiers", default="1,2,3")
    ap.add_argument("--sample", type=int, default=0, help="Tier2 무작위 N건을 질의로 눈 검증")
    ap.add_argument("--seed", type=int, default=1)
    ap.add_argument("--body", action="store_true")
    args = ap.parse_args()

    idx = LocalIndex()
    rec = Recommender(idx)
    tiers = tuple(int(t) for t in args.tiers.split(","))

    if args.sample:
        rng = random.Random(args.seed)
        t2 = [d for d in idx.doc_ids if idx.meta[d]["tier"] == 2 and len(idx.meta[d]["question_text"]) >= 30]
        for doc_id in rng.sample(t2, args.sample):
            m = idx.meta[doc_id]
            print("\n" + "=" * 100)
            print(f"[질의 {m['as_no']}] {m['service_cate'] or '-'} / {m['inquiry_type'] or '-'} / {m['topic'] or '-'}")
            print("  Q:", m["question_text"][:220].replace("\n", " / "))
            print("  A:", (m["answer_text"] or "")[:160].replace("\n", " / "))
            res = rec.recommend(m["question_text"], as_no=m["as_no"], service_cate=m["service_cate"],
                                inquiry_type=m["inquiry_type"], program_nm=m["program_nm"], screen_nm=m["screen_nm"],
                                top_k=args.top_k, tiers=tiers)
            _print(res, args.body)
        return

    if args.as_no:
        m = idx.meta[f"AS-{args.as_no}"]
        print("Q:", m["question_text"][:300])
        res = rec.recommend(m["question_text"], as_no=m["as_no"], service_cate=m["service_cate"],
                            inquiry_type=m["inquiry_type"], program_nm=m["program_nm"], screen_nm=m["screen_nm"],
                            top_k=args.top_k, tiers=tiers)
    else:
        if not args.query:
            ap.error("query 또는 --as-no 또는 --sample 이 필요합니다")
        res = rec.recommend(args.query, service_cate=args.service_cate, inquiry_type=args.inquiry_type,
                            top_k=args.top_k, tiers=tiers)
    _print(res, args.body)


if __name__ == "__main__":
    main()
