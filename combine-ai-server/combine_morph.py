# -*- coding: utf-8 -*-
"""
[AX Lab] 신규 파일 (2026-10-16 AX Lab): AS 통합화면 AI 추천 — 추천 근거(겹친 단어) 표시용 형태소 분석 (Kiwi)

왜 필요한가
  띄어쓰기로 자른 어절을 규칙으로 다듬는 방식은 두 방향 모두 틀린다.
    - 덜 자름  : "신규및"(신규 + 및), "신규오더시"(신규오더 + 시), "사진과"(사진 + 과)
    - 더 자름  : 맞춤법대로 "시술 확인서" 로 띄우면 화면에서 쓰는 문서 이름 "시술확인서" 가 두 단어가 된다
  그래서 기준을 "맞춤법상 단어" 가 아니라 "업무에서 한 뜻으로 쓰는 덩어리" 로 잡는다:
    Kiwi 로 품사를 나눈 뒤 **원문에서 붙어 있던 명사들은 다시 하나로 붙이고**(시술+확인서 → 시술확인서),
    명사가 아닌 것(및 · 조사 · 어미 · 같이 · 빠른)과 끝에 붙은 의존명사(시 · 후 · 때 · 분)는 떼어 낸다.
  업무 용어(동의어 사전 · 화면명/프로그램명)는 사용자 사전에 넣어 Kiwi 가 잘못 쪼개지 않게 한다.

왜 Kiwi 인가 (2026-10-16 비교)
  - pip 한 줄 설치, Windows 휠 제공, Java·C++ 빌드 불필요 (Mecab-ko 는 Windows 에서 사전 빌드가 번거롭고,
    KoNLPy 의 Okt·Komoran·Hannanum 은 Java(JVM) 가 필요하다).
  - 띄어쓰기 오류에 강하다 ("신규및" → 신규/NNG + 및/MAG). 상담 문의는 띄어쓰기가 불규칙하다.
  - 토큰마다 원문 위치(start·len)를 주므로 "붙어 있던 명사" 를 정확히 다시 붙일 수 있다.
  - 사용자 사전(add_user_word)을 코드에서 바로 넣을 수 있다.
  - 실측: 모델 적재 약 4초(기동 시 1회, 백그라운드), 문장당 약 0.8ms — 추천 응답 시간에 영향 없음.

동작 원칙
  - 화면 표시(match_terms) 에만 쓴다. 검색(BM25 어절+2-gram) 과 색인은 바꾸지 않는다 → 색인 재생성 불필요.
  - 적재가 끝나기 전이거나 kiwipiepy 가 없으면 units() 가 None 을 돌려주고, 호출 쪽은 기존 규칙 방식으로 동작한다.
"""
import re
import threading
from collections import Counter

try:
    from kiwipiepy import Kiwi
except Exception:                       # 미설치 PC 에서도 추천 서버는 떠야 한다 (규칙 방식으로 폴백)
    Kiwi = None

_MASK_TOKEN = re.compile(r"\[(?:이름|등록번호|전화번호|주민번호|이메일|내선|환자명)\]")
_NOUNISH = {"NNG", "NNP", "NNB", "XSN", "XPN", "XR", "SL", "SN", "SH"}
_JOINER = {"/", "-", "_", "."}          # D/C오더 · CI-EMR 처럼 명사 사이에 붙은 기호는 덩어리 안에 둔다
# 덩어리 앞뒤에 붙으면 떼는 말: 의존명사·시점 명사·접미사 (신규오더시 · 작성후 · 환자분 · 입원중)
_EDGE_TRIM = {"시", "후", "전", "중", "때", "등", "분", "들", "간", "내", "별", "용", "상", "측", "쪽", "것", "수", "적"}
_HANGUL_WORD = re.compile(r"^[가-힣]{3,12}$")
# 일반 국어 사전만으로는 Kiwi 가 헷갈리는 짧은 병원 전산 용어 (예: 문장 첫머리 "D/C오더" → C + 이오 + 더 로 오분석)
SEED_WORDS = ["오더", "차트", "수가", "원무", "병동", "서식", "팝업", "라벨", "바코드", "프린터", "처방전", "확인서", "소견서"]

_lock = threading.Lock()
_state = {"kiwi": None, "split": {}, "loading": False, "error": None, "user_words": 0}


def domain_words(index_meta=None, extra=()):
    """사용자 사전 후보: 동의어 사전의 용어 + 색인 화면명/프로그램명 중 여러 문서에 반복되는 한글 용어.

    화면명·프로그램명은 자유 입력이라("자격조회 안됩니다") 공백·기호로 나눈 3~12자 순한글 조각 중
    3건 이상 문서에 나온 것만 쓰고, 적재 시(_load) 명사로만 이뤄진 말인지 한 번 더 거른다.
    """
    words = set()
    try:
        from combine_synonyms import RULES
        for _pat, d_add, l_add in RULES:
            for w in f"{d_add or ''} {l_add or ''}".split():
                if _HANGUL_WORD.match(w):
                    words.add(w)
    except Exception:
        pass
    if index_meta:
        c = Counter()
        for r in index_meta.values():
            for k in ("program_nm", "screen_nm"):
                for w in set(re.split(r"[^가-힣]+", r.get(k) or "")):
                    if _HANGUL_WORD.match(w):
                        c[w] += 1
        words.update(w for w, n in c.items() if n >= 3)
    words.update(w for w in extra if _HANGUL_WORD.match(w))
    words.update(SEED_WORDS)
    return sorted(words)


def _load(words):
    try:
        k = Kiwi()
        # 화면명·프로그램명은 자유 입력이라 "오류가"·"합니다" 같은 조각이 섞인다. 기본 분석으로 명사로만 이뤄진 말만
        # 사전에 넣는다 (사전에 들어가면 그 말 전체가 명사로 취급돼 조사·어미가 칩에 붙는다).
        # 사전 단어는 문장 속에서 한 토큰이 되므로, 기본 분석 결과(외래접수수납 → 외래/접수/수납)를 기억해 뒀다가
        # units() 에서 다시 펼친다. 그래야 자료에 "외래접수" 만 있어도 그 조각을 찾을 수 있다.
        split = {}
        for w in set(SEED_WORDS) | set(words):
            toks = k.tokenize(w)
            nounish = all(t.tag in _NOUNISH for t in toks)
            if w in SEED_WORDS or nounish:
                parts = [(w[t.start:t.start + t.len], t.tag) for t in toks]
                ok = nounish and len(parts) > 1 and "".join(p[0] for p in parts) == w
                split[w] = parts if ok else None
        for w in split:
            k.add_user_word(w, "NNP", 0.0)
        k.tokenize("워밍업")
        with _lock:
            _state.update(kiwi=k, split=split, loading=False, user_words=len(split))
    except Exception as e:              # 모델 파일 손상 등 — 규칙 방식으로 계속 동작
        with _lock:
            _state.update(loading=False, error=str(e)[:200])


def warmup(words=None, wait=False):
    """Kiwi 를 백그라운드로 적재한다 (약 4초). 이미 적재했거나 적재 중이면 아무 것도 하지 않는다.
    words 를 안 주면 동의어 사전 + SEED_WORDS 만 사용자 사전에 넣는다."""
    if words is None:
        words = domain_words()
    if Kiwi is None:
        return False
    with _lock:
        if _state["kiwi"] is not None or _state["loading"]:
            start = False
        else:
            _state["loading"] = True
            start = True
    if start:
        t = threading.Thread(target=_load, args=(list(words),), name="combine-kiwi", daemon=True)
        t.start()
        if wait:
            t.join()
    elif wait:
        while True:
            with _lock:
                if not _state["loading"]:
                    break
            threading.Event().wait(0.05)
    return _state["kiwi"] is not None


def status():
    with _lock:
        return {"available": Kiwi is not None, "ready": _state["kiwi"] is not None,
                "user_words": _state["user_words"], "error": _state["error"]}


def units(text):
    """문장 → 명사 덩어리 목록. 각 덩어리는 [(표시 문자열, 품사), ...] 조각 리스트 (붙어 있던 명사 순서대로).

    Kiwi 가 준비되지 않았으면 None (호출 쪽이 규칙 방식으로 폴백).
    """
    k, split = _state["kiwi"], _state["split"]
    if k is None:
        return None
    text = _MASK_TOKEN.sub(" ", text or "")
    with _lock:                         # Kiwi 객체 공유 — 문장당 1ms 미만이라 직렬화해도 지연 없음
        toks = k.tokenize(text)
    out, cur, end = [], [], -1
    for t in toks:
        form = text[t.start:t.start + t.len]
        joiner = t.tag in ("SP", "SO", "SW") and t.form in _JOINER
        if (t.tag in _NOUNISH or (joiner and cur)) and (not cur or t.start == end):
            cur += split.get(form) or [(form, "J" if joiner else t.tag)]
        else:
            if cur:
                out.append(cur)
            cur = (split.get(form) or [(form, t.tag)]) if t.tag in _NOUNISH else []
        end = t.start + t.len
    if cur:
        out.append(cur)
    return [p for p in (_trim(u) for u in out) if p]


def _trim(parts):
    # 끝의 접미사는 떼지 않는다 (오/NNG+류/XSN = 오류 · 마약+류 = 마약류). 떼는 접미사는 _EDGE_TRIM 의 분·들·적뿐.
    while parts and (parts[-1][1] in ("J", "NNB") or parts[-1][0] in _EDGE_TRIM):
        parts = parts[:-1]
    while parts and (parts[0][1] in ("J", "NNB", "XSN") or parts[0][0] in _EDGE_TRIM):
        parts = parts[1:]
    return parts
