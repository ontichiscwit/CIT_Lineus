# -*- coding: utf-8 -*-
"""
[AX Lab] 신규 파일 (2026-10-12 AX Lab): AS 통합화면 AI 추천 — 질의 도메인 동의어 확장

왜 필요한가
  병원 현장 문의와 상담원 답변·매뉴얼은 같은 것을 다른 말로 부른다.
  테스터 테스트3 (20260530013) : 문의 "산재 청구 심사 → 산재 지사 선택란 항목 없음"  ↔
                                   정답 "기초코드관리 > [기관조합/보험거래처코드] 산재조합 등록 (매뉴얼 p.14)"
  겹치는 어절이 0 이라 BM25 가 0 이고 bge-m3 코사인도 0.36~0.45 라 후보 60건에 들지 못했다.
  질의 뒤에 "산재조합 보험회사 등록" 을 붙이면 정답 문서군이 1~3위로 올라오는 것을 확인했다(2026-10-12).

어떻게 쓰나
  expand(q_text) → (dense 에 덧붙일 문구, lexical 에 덧붙일 문구)
  - dense : 의미가 같은 "다른 명사"(현장어 ↔ 시스템어)만. 임베딩 질의를 크게 흔들지 않도록 짧게.
  - lexical: 표기 변형(매뉴얼/메뉴얼, 엑셀/excel, HiraBroker/히라브로커)까지. BM25 에만 들어간다.
  규칙은 "질의에 이 표현이 있으면 이 표현을 덧붙인다" 한 줄짜리라 현업이 표를 보고 늘릴 수 있다.
  질의에 이미 들어 있는 단어는 덧붙이지 않는다 (중복 가중 방지).

주의
  - 색인(문서) 쪽에는 적용하지 않는다. 문서는 상담원 표현 그대로 두고 질의만 문서 쪽 어휘로 끌어온다.
    따라서 이 파일을 고쳐도 색인 재생성은 필요 없다.
  - 너무 일반적인 말("오류", "안됨")은 넣지 않는다. 모든 문서에 있는 단어는 BM25 에서 가중치가 0 에 가깝고
    dense 를 흐리기만 한다.
"""
import re

# (질의 매치 정규식, dense 덧붙임, lexical 덧붙임)
# dense 가 None 이면 lexical 에만 덧붙인다.
RULES = [
    # --- 보험/청구 쪽 현장어 ↔ 시스템어
    (re.compile(r"산재(?!조합)"),                       "산재조합 기관조합 보험회사 등록",     "산재조합 기관조합 보험거래처코드 보험회사"),
    (re.compile(r"산재\s*조합"),                        "기관조합 보험거래처코드 등록",        "기관조합 보험거래처코드 보험회사"),
    (re.compile(r"(?:산재|조합|보험)\s*지사|승인\s*지사"), "산재조합 지사 등록",                 "산재조합 지사 보험거래처코드"),
    (re.compile(r"보험\s*(?:사|회사)"),                 "보험 거래처코드",                    "보험거래처코드 기관조합"),
    (re.compile(r"자보|자동차\s*보험"),                  "자동차보험 자보",                    "자동차보험 자보 보험거래처코드"),
    (re.compile(r"심평원|심사평가원|HIRA\b", re.I),      None,                                 "심평원 심사평가원 HIRA"),
    (re.compile(r"건보공단|건강보험공단|공단"),           None,                                 "공단 건강보험공단"),
    (re.compile(r"히라\s*브로커|hira\s*broker", re.I),   "HiraBroker",                         "HiraBroker 히라브로커 브로커"),
    (re.compile(r"HiraBroker", re.I),                   None,                                 "히라브로커 브로커"),
    # --- 프로그램/화면 명칭 변형
    (re.compile(r"마약\s*류?(?!투약)"),                  "마약류투약정보조회",                  "마약류투약정보조회 마약류"),
    (re.compile(r"이\s*폼|e-?form", re.I),              None,                                 "이폼 e-form eform 전자서식"),
    (re.compile(r"DUR\b", re.I),                        None,                                 "DUR 의약품안전사용서비스 점검"),
    (re.compile(r"처방전\s*출력|처방전\s*인쇄"),          None,                                 "처방전출력 처방전 출력 인쇄"),
    (re.compile(r"재발행|재인쇄|다시\s*출력"),            None,                                 "재출력 재발행 재인쇄"),
    # --- 표기 변형 (lexical 전용)
    (re.compile(r"메뉴얼|메뉴월|manual", re.I),          None,                                 "매뉴얼 메뉴얼"),
    (re.compile(r"매뉴얼"),                             None,                                 "메뉴얼"),
    (re.compile(r"엑셀|excel", re.I),                   None,                                 "엑셀 excel 엑셀파일"),
    (re.compile(r"팝업\s*창|알림\s*창"),                  None,                                 "팝업"),
    (re.compile(r"공인\s*인증서|공동\s*인증서|인증서"),    None,                                 "인증서 공동인증서 공인인증서"),
]


def _missing_words(words, text_norm):
    """질의에 이미 있는 어절은 빼고 덧붙일 것만 남긴다."""
    out = []
    for w in words.split():
        if re.sub(r"\s+", "", w).lower() not in text_norm:
            out.append(w)
    return out


def expand(q_text):
    """질의 본문 → (dense 덧붙임 문구, lexical 덧붙임 문구). 해당 규칙이 없으면 둘 다 빈 문자열."""
    text = q_text or ""
    norm = re.sub(r"\s+", "", text).lower()
    dense, lexical = [], []
    for pattern, d_add, l_add in RULES:
        if not pattern.search(text):
            continue
        if d_add:
            dense += [w for w in _missing_words(d_add, norm) if w not in dense]
        if l_add:
            lexical += [w for w in _missing_words(l_add, norm) if w not in lexical]
    return " ".join(dense), " ".join(lexical)


if __name__ == "__main__":
    import sys
    q = " ".join(sys.argv[1:]) or "산재 청구 심사 -> 일반내역 -> 산재 지사 선택란 (서산지사) 항목 없음"
    d, l = expand(q)
    print("Q      :", q)
    print("dense  :", d)
    print("lexical:", l)
