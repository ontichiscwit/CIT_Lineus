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
  - [AX Lab] 2026-10-16 관련 없는 후보는 칸을 채우지 않는다 (0~5건):
    재정렬 성공 시 재정렬 원점수 < RERANK_MIN_SCORE 또는 재정렬 상위 N 밖이면 제외, 재정렬 장애 시 코사인 < FALLBACK_MIN_SIM 제외
  - [AX Lab] 2026-10-16 추천 근거: 최종 항목에 match_terms(겹친 단어) · match_reason(업무분류/화면/문의유형 일치) 를 붙인다
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
import threading
import time
import urllib.request
from pathlib import Path

import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parent))
from combine_textprep import mask_regex, parse_question        # noqa: E402  1겹 마스킹 · 접수 템플릿 제거/프로그램명·화면명 추출
from combine_embed_client import embed_one, OLLAMA_HOST, EMBED_MODEL  # noqa: E402
from combine_lexical import BM25Index, surface_words           # noqa: E402  어휘 검색 · [AX Lab] 2026-10-16 겹친 단어
from combine_synonyms import expand as expand_synonyms         # noqa: E402  [AX Lab] 2026-10-12 질의 도메인 동의어 확장
import combine_morph                                           # noqa: E402  [AX Lab] 2026-10-16 겹친 단어 형태소 분석 (Kiwi)
from combine_morph import units as morph_units                 # noqa: E402

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
# [AX Lab] 수정 시작 (2026-10-15 AX Lab): 원격 Cross-Encoder 재정렬.
#   무거운 모델은 Ollama가 있는 AI PC의 별도 서버에서 실행한다. 연결 장애/지연 시 기존 점수식을 그대로 써서
#   CRM의 2.5초 제한과 추천 기능 가용성을 보호한다. 한 번 실패하면 짧은 회로 차단으로 매 요청의 timeout 누적을 막는다.
RERANK_ENABLED = os.getenv("COMBINE_RERANK_ENABLED", "Y").upper() not in ("N", "NO", "FALSE", "0")
RERANK_URL = os.getenv("COMBINE_RERANK_URL", "http://192.168.19.141:8766/api/rerank")
RERANK_API_KEY = os.getenv("COMBINE_RERANK_API_KEY", "dev-key")
RERANK_TOP = max(1, min(int(os.getenv("COMBINE_RERANK_TOP", "20")), 20))
RERANK_TIMEOUT = max(0.1, int(os.getenv("COMBINE_RERANK_TIMEOUT_MS", "900")) / 1000.0)
RERANK_RETRY_AFTER = 30.0
W_RERANK, W_HYBRID_R, W_PROD_R, W_TIER_R, W_QUAL_R = 0.35, 0.30, 0.15, 0.10, 0.10
# [AX Lab] 수정 시작 (2026-10-16 AX Lab): 관련 없는 후보는 칸을 채우지 않고 뺀다 (항상 5건 → 0~5건).
#   relevance·rerank_score 는 후보 안 min-max 상대값이라 무관해도 1위가 높게 나온다. 절대 기준은
#   Cross-Encoder 원점수(logit)만 쓸 만하다. 실측(2026-10-16, 기존 색인, 질의 48건):
#   도메인 밖 질의(회의실 예약·점심 메뉴·프린터 토너·엑셀 피벗·주차 등록) 노출 후보 전부 ≤ -2.5,
#   Tier2 자기질의의 무관 후보(배달서비스공제조합 계약처코드 -5.13, 자동감면해제 -5.16 등) 대부분 < -2,
#   -2 ~ 0 구간은 관련 사례가 많다(위조직검사 FM→PH 변경 -0.42, CP 양식 -1.25, KISA 고유식별정보 -1.26).
#   같은 질의에서 코사인은 무관 후보도 0.55~0.61 이라 코사인만으로는 가를 수 없다 → 재정렬 장애 시에만 코사인으로 거른다.
RERANK_MIN_SCORE = float(os.getenv("COMBINE_RERANK_MIN_SCORE", "-2.0"))
FALLBACK_MIN_SIM = float(os.getenv("COMBINE_FALLBACK_MIN_SIM", "0.55"))
# [AX Lab] 수정 끝
_RERANK_LOCK = threading.Lock()
_RERANK_STATUS = {
    "enabled": RERANK_ENABLED, "url": RERANK_URL, "last_ok": None, "last_error": None,
    "fallbacks": 0, "disabled_until": 0.0,
}
# [AX Lab] 수정 끝
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


# [AX Lab] 수정 시작 (2026-10-15 AX Lab): 원격 재정렬 호출·상태.
def _set_rerank_status(*, ok, error=None):
    with _RERANK_LOCK:
        if ok:
            _RERANK_STATUS["last_ok"] = int(time.time())
            _RERANK_STATUS["last_error"] = None
            _RERANK_STATUS["disabled_until"] = 0.0
        else:
            _RERANK_STATUS["last_error"] = error
            _RERANK_STATUS["fallbacks"] += 1
            _RERANK_STATUS["disabled_until"] = time.time() + RERANK_RETRY_AFTER


def rerank_status():
    with _RERANK_LOCK:
        status = dict(_RERANK_STATUS)
    status["circuit_open"] = bool(status["disabled_until"] > time.time())
    status.pop("disabled_until", None)
    return status


def ping_rerank():
    """재정렬 서버 health 확인. 추천 요청 경로의 폴백 횟수에는 포함하지 않는다."""
    if not RERANK_ENABLED:
        return False, "disabled"
    health_url = RERANK_URL.rsplit("/api/rerank", 1)[0] + "/health"
    try:
        data = json.loads(urllib.request.urlopen(health_url, timeout=RERANK_TIMEOUT).read().decode("utf-8"))
        if data.get("status") != "ok":
            raise RuntimeError("health not ok")
        with _RERANK_LOCK:
            _RERANK_STATUS["last_ok"] = int(time.time())
            _RERANK_STATUS["last_error"] = None
            _RERANK_STATUS["disabled_until"] = 0.0
        return True, f"{data.get('model', '')} {data.get('device', '')}".strip()
    except Exception as exc:
        with _RERANK_LOCK:
            _RERANK_STATUS["last_error"] = type(exc).__name__
            _RERANK_STATUS["disabled_until"] = time.time() + RERANK_RETRY_AFTER
        return False, type(exc).__name__


def rerank_texts(query, documents):
    """마스킹된 질의와 상위 후보 본문을 원격 Cross-Encoder로 평가한다. 실패하면 예외를 내고 호출자가 폴백한다."""
    with _RERANK_LOCK:
        if _RERANK_STATUS["disabled_until"] > time.time():
            raise RuntimeError("rerank circuit open")
    body = json.dumps({"query": query, "documents": documents}, ensure_ascii=False).encode("utf-8")
    req = urllib.request.Request(
        RERANK_URL, data=body,
        headers={"Content-Type": "application/json", "X-Api-Key": RERANK_API_KEY},
    )
    try:
        data = json.loads(urllib.request.urlopen(req, timeout=RERANK_TIMEOUT).read().decode("utf-8"))
        scores = data.get("scores")
        if data.get("result") != "000" or not isinstance(scores, list) or len(scores) != len(documents):
            raise RuntimeError("invalid rerank response")
        values = [float(value) for value in scores]
        _set_rerank_status(ok=True)
        return values
    except Exception as exc:
        _set_rerank_status(ok=False, error=type(exc).__name__)
        raise


def _normalize_rerank(scores):
    if not scores:
        return []
    lo, hi = min(scores), max(scores)
    if hi <= lo:
        return [0.5] * len(scores)
    return [(value - lo) / (hi - lo) for value in scores]
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
    return product_match_detail(q, d)[0]


# [AX Lab] 수정 시작 (2026-10-16 AX Lab): 추천 근거 표시 — 점수와 함께 "왜 일치로 봤는지" 라벨을 돌려준다.
#   기존 product_match 의 판정 순서·점수는 그대로 이 함수로 옮겼다 (product_match 는 점수만 꺼내 쓴다).
def product_match_detail(q, d):
    qs, ds = _norm(q.get("service_cate")), _norm(d.get("service_cate"))
    if qs and ds:
        if qs == ds:
            return 1.0, "같은 업무분류"
        # service_cate 가 다르면 화면이 같을 수 없다 — 단, 큐레이션 Tier1 라벨은 LLM 추정이라 0.3 만 깎는다
        return (0.0 if d.get("tier") == 2 else 0.3), None
    qp = {_norm(q.get("program_nm")), _norm(q.get("screen_nm"))} - {""}
    dp = {_norm(d.get("program_nm")), _norm(d.get("screen_nm"))} - {""}
    if qp and dp and (qp & dp):
        return 1.0, "같은 프로그램·화면"
    qi, di = _norm(q.get("inquiry_type")), _norm(d.get("inquiry_type"))
    if qi and di and qi == di:
        return 0.6, "같은 문의유형"
    return 0.0, None


MATCH_MAX = 4           # 항목당 보여 줄 겹친 단어 수
MATCH_MIN_IDF = 1.5     # 문서 약 20% 이상에 나오는 흔한 말("문의", "확인" 등)은 근거로 보여 주지 않는다
# 화면 표시용으로 떼어 내는 조사·하다/되다 어미 (긴 것부터). 한 글자 조사는 명사 끝 글자와 헷갈리기 쉬운 것
# (도: 만족도 · 로: 매크로 · 의: 주치의 · 고: 교통사고)은 넣지 않았다. '과'는 부서명(진료과·원무과)만 예외로 둔다.
_MATCH_SUFFIX = sorted("""
되었습니다 하였습니다 했습니다 했는데 하는데 되는데 합니다 됩니다 하셔서 되어서 해서 되어 되지 되고 되면 되는 된다
하면 하고 하는 하여 해도 해야 하게 한다 했다 에서는 으로는 이라고 라고 이라 에서 으로 에게 까지 부터 처럼 이나 에는 에도
된 한 함 됨 되 를 을 는 은 이 가 에 과 와 시
""".split(), key=len, reverse=True)
_MATCH_KEEP = re.compile(r"(?:진료|원무|약제|간호|검사|행정|전산|영상의학|재활의학|가정의학|진단검사의학)과$")
# IDF 는 높아도 문의 문장에 습관처럼 붙는 말 ("사진과 같이", "첨부 드립니다", "확인 부탁")
_MATCH_KO_STOP = {"같이", "첨부", "관련", "부탁", "경우", "현재", "다시", "계속", "해당", "요청", "내용", "부분",
                  "지금", "혹시", "아래", "다음", "이번", "오늘", "어제", "바로", "항상", "자꾸", "전화"}
# 떼고 나서도 이런 말로 끝나면 서술어라 근거로 보여 주지 않는다 (나옵니다 · 뜬다고 · 바랍니다 …)
_MATCH_PREDICATE = re.compile(r"(?:니다|어요|아요|해요|세요|네요|까요|나요|는데|다고|달라고)$")
_MATCH_EN_STOP = {"the", "and", "for", "not", "you", "are", "was", "can", "its"}


def _match_stem(s):
    """'처방이라고' → '처방', '전송되지' → '전송'. 떼고 남는 말이 두 글자 미만이면 떼지 않는다."""
    if _MATCH_KEEP.search(s):
        return s
    for suf in _MATCH_SUFFIX:
        if s.endswith(suf) and len(s) - len(suf) >= 2:
            return s[:-len(suf)]
    return s


def match_terms(q_lex, synonyms, doc_text, idf, q_units=None):
    """질의의 말 중 후보 본문(embed_text — BM25 가 보는 본문)에 실제로 들어 있는 것 → [{"term", "synonym"}].

    드문 말(IDF 큰 것) 순으로 MATCH_MAX 개, 서로 포함 관계인 말은 긴 쪽 하나만.
    synonym=True 는 질의에 없고 동의어 확장(combine_synonyms)으로 덧붙인 말이 걸렸다는 뜻이다.
    벡터 검색·재정렬은 문장 뜻으로 판단하므로 이 목록이 비어 있어도 추천될 수 있다 (화면에는 '뜻으로 찾음').
    q_units: combine_morph.units(q_lex) 결과 (요청당 한 번 계산해 넘긴다). None 이면 여기서 구하고,
             Kiwi 가 준비 전이거나 False 를 주면 어절 규칙 방식(_match_terms_rule)으로 계산한다.
    """
    if q_units is None:
        q_units = morph_units(q_lex)
    if q_units is None or q_units is False:
        return _match_terms_rule(q_lex, synonyms, doc_text, idf)
    # [AX Lab] 수정 시작 (2026-10-16 AX Lab): Kiwi 명사 덩어리 기준 (combine_morph 참조)
    #   "시술확인서" 처럼 붙어 있던 명사는 한 덩어리로, "신규및"·"신규오더시" 는 명사만 남긴다.
    #   덩어리 전체가 본문에 없으면 그 안의 더 짧은 연속 조각(신규오더 → 신규)을 긴 것부터 찾는다.
    text = (doc_text or "").lower()
    flat = re.sub(r"\s+", "", text)
    syn = set((synonyms or "").split())
    found = {}
    for parts in q_units:
        whole = "".join(p[0] for p in parts)
        taken = []
        spans = sorted(((i, j) for i in range(len(parts)) for j in range(i + 1, len(parts) + 1)),
                       key=lambda ij: (ij[0] - ij[1], ij[0]))
        for i, j in spans:
            if parts[i][1] == "J" or parts[j - 1][1] == "J" or any(i < b and a < j for a, b in taken):
                continue
            s = "".join(p[0] for p in parts[i:j])
            if not _match_present(s, text, flat):
                continue
            taken.append((i, j))
            key = s.lower()
            # 덩어리 자체가 BM25 사전에 없으면(D/C오더) 안의 가장 드문 조각 기준
            weight = (idf.get(key) or idf.get(key[:2])
                      or max((idf.get(p[0].lower()) or 0.0 for p in parts[i:j] if len(p[0]) >= 2), default=0.0))
            if weight < MATCH_MIN_IDF:
                continue
            if key not in found or weight > found[key][0]:
                found[key] = (weight, s in syn or whole in syn, s)
    return _match_pick(found)


def _match_present(s, text, flat):
    """표시할 만한 말이고 본문에 들어 있는가."""
    if s.isdigit() or s in _MATCH_KO_STOP:
        return False
    if re.fullmatch(r"[A-Za-z]+", s):
        sl = s.lower()
        if len(sl) < (2 if s.isupper() else 3) or sl in _MATCH_EN_STOP:
            return False
        return re.search(r"(?<![a-z])" + re.escape(sl) + r"(?![a-z])", text) is not None
    if len(s) < 2:
        return False
    return s.lower() in flat


def _match_pick(found):
    out = []
    for key, (_w, is_syn, s) in sorted(found.items(), key=lambda kv: -kv[1][0]):
        if any(key in o["term"].lower() for o in out):
            continue
        shorter = next((o for o in out if o["term"].lower() in key), None)
        if shorter:
            shorter.update(term=s, synonym=is_syn)
            continue
        out.append({"term": s, "synonym": is_syn})
        if len(out) >= MATCH_MAX:
            break
    return out
# [AX Lab] 수정 끝


def _match_terms_rule(q_lex, synonyms, doc_text, idf):
    """Kiwi 없이 어절 규칙으로 계산 (폴백). 질의 어절의 앞부분 중 본문에 있는 가장 긴 것에서 조사·어미를 뗀다."""
    text = (doc_text or "").lower()
    syn = set((synonyms or "").split())
    found = {}
    for w in surface_words(q_lex):
        if w.isdigit():
            continue                                    # 날짜·번호 조각은 근거로 의미가 없다
        if "가" <= w[0] <= "힣":
            s = next((w[:n] for n in range(len(w), 1, -1) if w[:n] in text), None)
            if s:
                s = _match_stem(s)
                if _MATCH_PREDICATE.search(s) or s in _MATCH_KO_STOP:
                    continue
        else:
            wl = w.lower()
            # 영문은 대문자 약어(DUR·EMR·TA)는 두 글자부터, 그 외는 세 글자부터 ('it's' 의 it 같은 조각 제외)
            ok_len = len(wl) >= (2 if w.isupper() else 3)
            s = w if ok_len and wl not in _MATCH_EN_STOP and re.search(r"(?<![a-z])" + re.escape(wl) + r"(?![a-z])", text) else None
        if not s:
            continue
        key = s.lower()
        weight = idf.get(key) or idf.get(key[:2]) or 0.0
        if weight < MATCH_MIN_IDF:
            continue
        if key not in found or weight > found[key][0]:
            found[key] = (weight, w in syn, s)
    return _match_pick(found)
# [AX Lab] 수정 끝


def score(rel, pm, tier, quality, rerank=None):
    """rel 은 후보 집합 안에서 0~1 로 정규화된 하이브리드 관련도 (search_hybrid 의 relevance)."""
    # [AX Lab] 수정 시작 (2026-10-15 AX Lab): 재정렬 성공 요청만 Cross-Encoder 점수를 반영한다.
    #   rerank=None 은 장애/비활성 경로이며 기존 산식을 한 글자도 바꾸지 않는다.
    if rerank is not None:
        return (W_RERANK * rerank + W_HYBRID_R * rel + W_PROD_R * pm
                + W_TIER_R * TIER_WEIGHT.get(tier, 0.5) + W_QUAL_R * float(quality or 0))
    # [AX Lab] 수정 끝
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
    def __init__(self, index, embed_fn=None, rerank_fn=None):
        self.index = index
        self.embed_fn = embed_fn or embed_one
        # [AX Lab] 수정 (2026-10-15 AX Lab): 테스트에서는 가짜 함수를 주입하고, 운영은 환경변수로 켜고 끈다.
        self.rerank_fn = rerank_fn if rerank_fn is not None else (rerank_texts if RERANK_ENABLED else None)
        # [AX Lab] 수정 (2026-10-16 AX Lab): Kiwi 적재(약 4초)는 백그라운드. 끝나기 전 요청은 규칙 방식으로 겹친 단어를 낸다.
        #   서버는 Recommender(None) 뒤에 색인을 읽으므로 거기서(combine_recommend_server.main) 따로 부른다.
        if index is not None:
            combine_morph.warmup(combine_morph.domain_words(getattr(index, "meta", None)))

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
        # [AX Lab] 수정 시작 (2026-10-15 AX Lab): 하이브리드 상위 후보만 원격 Cross-Encoder로 정밀 재정렬.
        #   원격 서버가 느리거나 실패하면 rerank_by_doc을 비워 아래 기존 score 산식으로 즉시 폴백한다.
        rerank_by_doc = {}
        rerank_raw_by_doc = {}      # [AX Lab] 2026-10-16 거르기 기준용 원점수(logit)
        if self.rerank_fn and cands:
            rerank_cands = cands[:RERANK_TOP]
            rerank_docs = []
            for doc_id, _sim, _lex, _rel in rerank_cands:
                doc = index.get(doc_id)
                rerank_docs.append((doc.get("embed_text") or "\n".join(
                    str(doc.get(key) or "") for key in ("title", "question_text", "answer_text")
                ))[:6000])
            try:
                rerank_raw = self.rerank_fn(q_text, rerank_docs)
                if len(rerank_raw) != len(rerank_cands):
                    raise ValueError("rerank score count mismatch")
                rerank_by_doc = {
                    rerank_cands[i][0]: value for i, value in enumerate(_normalize_rerank(rerank_raw))
                }
                rerank_raw_by_doc = {rerank_cands[i][0]: float(value) for i, value in enumerate(rerank_raw)}
            except Exception:
                rerank_by_doc = {}
                rerank_raw_by_doc = {}
        # [AX Lab] 수정 끝
        # 호출자가 안 준 프로그램명/화면명은 질의 템플릿에서 뽑은 값으로 채운다 (product_match 폴백용)
        qmeta = {"service_cate": service_cate, "inquiry_type": inquiry_type,
                 "program_nm": program_nm or qm.get("program_nm"), "screen_nm": screen_nm or qm.get("screen_nm")}
        ranked = []
        for doc_id, sim, lex, rel in cands:
            # [AX Lab] 수정 시작 (2026-10-16 AX Lab): 관련 없는 후보 제외.
            #   재정렬 성공 요청은 재정렬을 거친 상위 N 중 원점수 ≥ RERANK_MIN_SCORE 만 남긴다 — 상위 N 밖 후보는
            #   검증되지 않은 채 Tier1 최소 보장·빈칸 채우기로 끼어들던 것(점심 메뉴 질의에 '미수회입' 등)이라 뺀다.
            #   재정렬 장애·비활성이면 코사인 < FALLBACK_MIN_SIM 만 뺀다. 이후 compose 의 모든 규칙은 남은 후보 안에서만 돈다.
            if rerank_by_doc:
                raw = rerank_raw_by_doc.get(doc_id)
                if raw is None or raw < RERANK_MIN_SCORE:
                    continue
            elif sim < FALLBACK_MIN_SIM:
                continue
            # [AX Lab] 수정 끝
            d = index.get(doc_id)
            pm, pm_label = product_match_detail(qmeta, d)      # [AX Lab] 2026-10-16 라벨은 추천 근거 표시용
            rr = rerank_by_doc.get(doc_id, 0.0) if rerank_by_doc else None
            item = {**self._item(d), "semantic_sim": round(sim, 4), "lexical_score": round(lex, 2),
                    "relevance": round(rel, 4), "product_match": pm, "match_reason": pm_label,
                    # [AX Lab] 2026-10-12: 절대 코사인 기준 확신도 (relevance 는 후보 안 상대값이라 항상 상위가 100%)
                    "confidence": confidence_of(sim),
                    "score": round(score(rel, pm, d["tier"], d["quality_score"], rr), 4)}
            # [AX Lab] 수정 (2026-10-15 AX Lab): 구 서버 계약을 깨지 않는 선택 필드.
            if rr is not None:
                item["rerank_score"] = round(rr, 4)
                item["rerank_raw"] = round(rerank_raw_by_doc[doc_id], 3)   # [AX Lab] 2026-10-16 임계 재조정용
            ranked.append(item)
        ranked.sort(key=lambda c: -c["score"])
        items = compose(ranked, top_k)
        # [AX Lab] 수정 (2026-10-16 AX Lab): 최종 항목에만 "겹친 단어" 계산 (항목당 수 ms 미만)
        idf = getattr(getattr(index, "lexical", None), "idf", None) or {}
        q_units = morph_units(q_lex)                        # [AX Lab] 2026-10-16 질의 형태소 분석은 요청당 1회
        if q_units is None:
            q_units = False
        for it in items:
            it.pop("product_match", None)
            d = index.get(it["doc_id"])
            body = d.get("embed_text") or " ".join(str(d.get(k) or "") for k in ("title", "question_text", "answer_text"))
            it["match_terms"] = match_terms(q_lex, qm.get("synonyms"), body, idf, q_units)
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
        if "rerank_raw" in it:      # [AX Lab] 2026-10-16
            line += f" rr={it['rerank_raw']:.2f}"
        if it.get("match_terms") or it.get("match_reason"):     # [AX Lab] 2026-10-16 추천 근거
            line += " | " + " ".join(m["term"] + ("(동의어)" if m["synonym"] else "") for m in it.get("match_terms") or [])
            line += f" [{it['match_reason']}]" if it.get("match_reason") else ""
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
    combine_morph.warmup(wait=True)     # [AX Lab] 2026-10-16 CLI 는 Kiwi 적재를 기다린다 (겹친 단어를 Kiwi 기준으로 보이게)
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
