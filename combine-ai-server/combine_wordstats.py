# -*- coding: utf-8 -*-
"""
[AX Lab] 신규 파일 (2026-10-16 AX Lab): AS 통합화면 AI 추천 — 추천 근거 칩의 '형식어' 판정 + 재촉 문의 판정

왜 필요한가
  겹친 단어(match_terms) 칩에 "안녕", "연락", "담당자", "퇴근" 처럼 문의 내용과 상관없는 말이 섞였다.
  사람이 금지어 목록을 늘리는 방식은 새 말이 나올 때마다 뒤처지므로, 색인에 들어 있는 과거 문의(Tier2
  question_text)에서 단어마다 다음 두 가지를 **자동으로** 재서 판정한다 (2026-10-16 실측으로 기준 결정).

  1) 인사·맺음말 위치  : 문의 글의 맨 앞/맨 끝에 몰려 나오는 말 (평균 가장자리 거리 ≤ 0.10)
       안녕 0.037 · 수고 0.043 · 긴급 0.071 · 감사 0.093  ↔  삭제 0.269 · 오류 0.268 · 처방 0.226
  2) 재촉 문의 쏠림    : topic='처리현황독촉'(재문의·연락 요청) 문의에 통계적으로 몰리는 말
       표본이 72건뿐이라 단순 배율은 우연에 흔들린다(0건인 '경과기록지'도 3.4배). 그래서 Wilson 하한(90%)이
       기준 비율의 2배 이상이고 재촉 문의에 3번 이상 나온 말만 고른다.
       → 담당자 · 전화번호 · 처리 · 진행 · 전화 · 신청 · 연락 · 상황 · 답변 · 어제 · 월요일 · 지연
         (미수 · 서버 · 경과기록지 같은 업무 용어는 걸리지 않는다)
  드문 말(문서 20건 미만 — 퇴근·휴무)은 통계로 판단할 수 없으므로 **같은 문장**을 본다:
  그 문장에 형식어가 있고 업무 용어(서비스구분·문제유형에 쏠리는 말)가 하나도 없으면 형식어로 본다.
  ("담당자분 내일 휴무고, 퇴근 전에 연락 달라" → 휴무·퇴근 제외 / "시술확인서 작성 부탁" → 시술확인서 유지)

  재촉 문의 판정(follow_up): 새 문의와 가장 가까운 과거 문의 10건 중 재촉 문의가 2건 이상이면 재촉으로 본다.
  재촉 문의는 전체의 0.6% 라 10건 중 2건이면 평소의 30배다. 실측: 연락 요청·재문의 문장 11개 중 8개 탐지,
  일반 실제 문의 40건 중 오탐 0건.

동작 원칙
  - 화면 표시(칩·안내)에만 쓴다. 검색·재정렬·점수는 바꾸지 않는다.
  - 통계는 기동 후 백그라운드에서 한 번 계산(약 1분)하고 data/combine_wordstats.json 에 저장한다.
    색인 built_at 이 같으면 다음 기동 때 파일을 그대로 읽는다. 준비 전에는 형식어 거르기 없이 기존대로 동작한다.
  - 저장 형식은 JSON (사람이 열어 어떤 말이 왜 형식어인지 볼 수 있다).
"""
import json
import math
import os
import re
import threading
import time
from collections import Counter, defaultdict
from pathlib import Path

import numpy as np

import combine_morph

NAG_TOPIC = "처리현황독촉"
MIN_DF = 20             # 이보다 드문 말은 통계로 판정하지 않는다 (문장 맥락으로 판정)
EDGE_MIN_N = 25         # 위치 판정에 필요한 최소 등장 문서 수
EDGE_MAX = 0.10         # 평균 가장자리 거리 (0 = 맨 앞/맨 끝, 0.5 = 한가운데)
EDGE_MIN_LEN = 40       # 이보다 짧은 문의는 위치를 재지 않는다 (짧으면 모든 말이 가장자리)
NAG_MIN_HITS = 3
NAG_MIN_RATIO = 2.0
WILSON_Z = 1.645
CONTENT_SVC_KL = 0.08   # 서비스구분 쏠림 (원무·진료·청구 …)
CONTENT_TOPIC_KL = 0.15  # 문제유형 쏠림 (시스템오류·수가심사청구 …)
FOLLOW_K = 10
FOLLOW_MIN = 2
MIN_DOCS = 1000         # 이보다 작은 색인에서는 통계를 내지 않는다
CACHE_VERSION = 1

_lock = threading.Lock()
_state = {"key": None, "words": None, "building": False, "error": None, "built_at": None}


def _kl(counts, n, prior, total):
    """단어가 나온 문서들의 분류 분포 ↔ 전체 분포 (사전 비율로 평활한 KL)."""
    K = len(prior)
    out = 0.0
    for c, gc in prior.items():
        q = gc / total
        p = (counts.get(c, 0) + q * K) / (n + K)
        out += p * math.log(p / q)
    return out


def _wilson_low(x, n, z=WILSON_Z):
    p = x / n
    return (p + z * z / (2 * n) - z * math.sqrt(p * (1 - p) / n + z * z / (4 * n * n))) / (1 + z * z / n)


def build(meta):
    """index.meta → {단어: {"c": "f"(형식어)|"c"(업무 용어)|"n"(중립), "df", "why"}}. Kiwi 준비 후 호출."""
    docs = [r for r in meta.values() if r.get("tier") == 2 and (r.get("question_text") or "").strip()]
    df, nag = Counter(), Counter()
    edge = defaultdict(list)
    svc, top = defaultdict(Counter), defaultdict(Counter)
    svc_all, top_all = Counter(), Counter()
    for r in docs:
        q = r["question_text"][:1500]
        toks = combine_morph.nouns(q)
        if toks is None:
            raise RuntimeError("Kiwi 준비 전")
        s, t, is_nag = r.get("service_cate"), r.get("topic"), r.get("topic") == NAG_TOPIC
        if s:
            svc_all[s] += 1
        if t:
            top_all[t] += 1
        seen = set()
        for w, start in toks:
            if len(w) < 2 or w in seen:
                continue
            seen.add(w)
            df[w] += 1
            nag[w] += is_nag
            if s:
                svc[w][s] += 1
            if t:
                top[w][t] += 1
            if len(q) >= EDGE_MIN_LEN:
                r_ = (start + len(w) / 2) / len(q)
                edge[w].append(min(r_, 1 - r_))
    n_docs, n_nag = len(docs), sum(1 for r in docs if r.get("topic") == NAG_TOPIC)
    p0 = (n_nag / n_docs) if n_docs and n_nag else None
    n_svc, n_top = sum(svc_all.values()), sum(top_all.values())
    words = {}
    for w, n in df.items():
        if n < MIN_DF:
            continue
        e = edge.get(w) or []
        e_mean = sum(e) / len(e) if len(e) >= EDGE_MIN_N else None
        ratio = (_wilson_low(nag[w], n) / p0) if p0 and nag[w] >= NAG_MIN_HITS else 0.0
        ks = _kl(svc[w], sum(svc[w].values()), svc_all, n_svc) if n_svc else 0.0
        kt = _kl(top[w], sum(top[w].values()), top_all, n_top) if n_top else 0.0
        if e_mean is not None and e_mean <= EDGE_MAX:
            c, why = "f", f"글 맨 앞/끝에 몰림 (평균 가장자리 거리 {e_mean:.3f})"
        elif ratio >= NAG_MIN_RATIO:
            c, why = "f", f"재촉 문의에 몰림 (Wilson 하한 {ratio:.1f}배, {nag[w]}/{n}건)"
        elif ks >= CONTENT_SVC_KL or kt >= CONTENT_TOPIC_KL:
            c, why = "c", f"업무 쏠림 (서비스구분 {ks:.2f} · 문제유형 {kt:.2f})"
        else:
            c, why = "n", ""
        words[w] = {"c": c, "df": n, "why": why} if why else {"c": c, "df": n}
    return words


def _cache_path():
    """combine_recommend.OUT_DIR 와 같은 규칙 (순환 import 를 피하려고 여기서 다시 계산)."""
    return Path(os.getenv("COMBINE_DATA_DIR", Path(__file__).resolve().parent / "data")) / "combine_wordstats.json"


def _run(index, path):
    try:
        key = f"v{CACHE_VERSION}|{index.built_at}"
        words = None
        try:
            if path.exists():
                d = json.loads(path.read_text(encoding="utf-8"))
                if d.get("key") == key:
                    words = d["words"]
        except Exception:
            words = None
        if words is None:
            while not combine_morph.status()["ready"]:
                if not combine_morph.status()["available"] or combine_morph.status()["error"]:
                    raise RuntimeError("Kiwi 사용 불가 — 형식어 거르기 없이 동작")
                time.sleep(0.5)
            t0 = time.time()
            words = build(index.meta)
            try:
                path.write_text(json.dumps({"key": key, "built": time.strftime("%Y-%m-%d %H:%M:%S"),
                                            "elapsed_s": round(time.time() - t0, 1), "words": words},
                                           ensure_ascii=False, indent=0), encoding="utf-8")
            except Exception:
                pass                                    # 저장 실패해도 메모리 값으로 동작
        with _lock:
            _state.update(key=key, words=words, building=False, error=None, built_at=index.built_at)
    except Exception as e:
        with _lock:
            _state.update(building=False, error=str(e)[:200], built_at=index.built_at)   # 같은 색인으로 재시도 반복 방지


def warmup(index, wait=False):
    """색인 기준 단어 통계를 백그라운드로 준비한다. 같은 built_at 으로 이미 준비됐거나 준비 중이면 넘어간다."""
    if index is None or not getattr(index, "meta", None) or getattr(index, "built_at", None) is None:
        return
    if len(index.meta) < MIN_DOCS:
        return                                          # 표본이 적으면 통계가 무의미 (테스트용 가짜 색인 포함)
    with _lock:
        if _state["building"] or _state["built_at"] == index.built_at:
            return
        _state["building"] = True
    t = threading.Thread(target=_run, args=(index, _cache_path()), name="combine-wordstats", daemon=True)
    t.start()
    if wait:
        t.join()


def status():
    with _lock:
        w = _state["words"]
        return {"ready": w is not None, "words": len(w) if w else 0,
                "formal": sum(1 for v in w.values() if v["c"] == "f") if w else 0, "error": _state["error"]}


def word_class(s):
    """'f' 형식어 · 'c' 업무 용어 · 'n' 중립 · None 드문 말/모름 (통계 준비 전이면 항상 None)."""
    w = _state["words"]
    if not w or not s:
        return None
    v = w.get(s) or w.get(s.lower())
    return v["c"] if v else None


def unit_class(parts):
    """명사 덩어리 [(조각, 품사), ...] 의 분류. 덩어리 자체 통계가 없으면 조각으로 판단한다.
    영문·숫자가 섞인 덩어리(BIXOLON · D/C오더)나 업무 용어 조각이 든 합성어(시술확인서)는 업무 용어로 본다."""
    whole = "".join(p[0] for p in parts)
    c = word_class(whole)
    if c:
        return c
    if any(tag in ("SL", "SH") for _f, tag in parts) or (
            any(tag == "SN" for _f, tag in parts) and any("가" <= ch <= "힣" for ch in whole)):
        return "c"
    cs = [word_class(f) for f, _t in parts if len(f) >= 2]
    if "c" in cs:
        return "c"
    if cs and all(x == "f" for x in cs):
        return "f"
    if len(cs) > 1 and any(cs):
        return "c"              # 두 글자 이상 명사가 붙은 합성어는 그 자체가 구체적인 업무 표현인 경우가 많다 (재+문의는 해당 없음)
    return None if not any(cs) else (cs[0] if len(cs) == 1 else "n")


def judge(sent_units):
    """combine_morph.units(q, with_sentence=True) → (형식어 덩어리 문자열 집합(소문자), 내용 없는 문의 여부).

    - 통계상 형식어인 덩어리는 항상 형식어.
    - 중립·드문 말은 같은 문장에 형식어가 있고 업무 용어가 없으면 형식어 (퇴근·휴무·내일).
    - 내용 없는 문의 = 형식어가 하나 이상 있고, 형식어로 판정되지 않은 덩어리가 하나도 없다.
    통계 준비 전이거나 Kiwi 결과가 없으면 (빈 집합, False).
    """
    if not sent_units or _state["words"] is None:
        return set(), False
    by_sent = defaultdict(list)
    for s, parts in sent_units:
        whole = "".join(p[0] for p in parts)
        if not re.search(r"[가-힣A-Za-z]", whole):
            continue                                    # 숫자·기호뿐인 덩어리(4시 → 4)는 내용도 형식도 아니다
        by_sent[s].append((whole, unit_class(parts)))
    formal, rest = set(), 0
    for items in by_sent.values():
        has_f = any(c == "f" for _w, c in items)
        has_c = any(c == "c" for _w, c in items)
        for w, c in items:
            if c == "f" or (has_f and not has_c and c in ("n", None)):
                formal.add(w.lower())
            elif len(w) >= 2:
                rest += 1
    return formal, bool(formal) and rest == 0


def follow_up(index, qvec, exclude_as_no=()):
    """가장 가까운 과거 문의(Tier2) FOLLOW_K 건 중 재촉 문의(topic=처리현황독촉) 건수."""
    try:
        nag = getattr(index, "_cw_nag", None)
        if nag is None:
            nag = np.asarray([index.meta[d].get("topic") == NAG_TOPIC for d in index.doc_ids])
            index._cw_nag = nag                        # 색인 객체는 읽기 전용이라 객체별로 한 번만 만든다
        mask = index.tiers == 2
        if exclude_as_no:
            mask = mask & ~np.isin(index.as_nos, list(exclude_as_no))
        if not nag.any() or not mask.any():
            return 0
        s = np.where(mask, index.vectors @ np.asarray(qvec, dtype=np.float32), -np.inf)
        k = min(FOLLOW_K, int(mask.sum()))
        top = np.argpartition(-s, k - 1)[:k]
        return int(nag[top].sum())
    except Exception:
        return 0
