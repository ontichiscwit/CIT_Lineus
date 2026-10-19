# -*- coding: utf-8 -*-
"""
[AX Lab] AS 통합화면 AI 추천 — 텍스트 전처리 공용 규칙 (적재 파이프라인 · 추천 서버 공용)

이 파일 한 곳에만 둔다.
  - 접수 템플릿 파싱 `parse_question()`    : "0. 챗봇요약 / 1. 프로그램명 / 2. 화면명 / …" 라벨을 버리고 값만 남기며
                                            프로그램명·화면명을 메타로 뺀다. 안내문·플레이스홀더·중복 문장 제거 포함.
  - 1겹 정규식 마스킹 `mask_regex()`       : 환자명(한글·로마자)·등록번호 관용 표기. (마스킹 텍스트, 잡은 토큰) 반환.

왜 공용인가
  적재 시 문서에 적용한 규칙과 조회 시 질의에 적용하는 규칙이 다르면 같은 문장이 다른 벡터가 된다.
  `analysis/combine_preprocess.py`(적재) 와 `combine_recommend.py`(조회) 가 모두 여기서 import 한다.
  이 파일을 고치면 색인(combine_embed.py) 도 다시 만들어야 일관성이 유지된다.

이 파일은 표준 라이브러리만 쓴다 (re 뿐).
"""
import re

# ---------------------------------------------------------------- 템플릿 파싱
# 실측 라벨: 0.챗봇요약 1.프로그램명 2.화면명 3.환자등록번호 4.발생일시 5.내용
# 번호와 공백이 불규칙하다('3.환자등록번호' 는 점 뒤 공백 없음).
TPL_FIELD_RE = re.compile(
    r"^[ \t]*\d+[ \t]*\.[ \t]*(챗봇요약|프로그램명|화면명|환자등록번호|발생일시|내용)[ \t]*:(.*)$",
    re.M,
)

# 값이 들어와도 의미가 없는 플레이스홀더. 챗봇요약 상위 3개가 전부 이 유형이다.
PLACEHOLDER_VALUES = {
    "", "-", ".", "없음", "해당없음",
    "문의하실 내용을 입력해주시기 바랍니다.",
    "문의하실 내용이 없습니다.",
    "문의 내용이 없습니다.",
    "문의하신 내용이 없습니다.",
}
# 플레이스홀더가 본문 "앞에 붙은 채" 실제 내용이 이어지는 경우 (예: "문의하실 내용을 입력해주시기 바랍니다. 의무기록을 열면 먹통이됩니다")
PLACEHOLDER_PREFIX_RE = re.compile(
    r"^(?:\s*(?:문의하실\s*내용을\s*입력해\s*주시기\s*바랍니다|문의하실\s*내용이\s*없습니다|문의\s*내용이\s*없습니다|문의하신\s*내용이\s*없습니다)[.!]?\s*)+"
)
# 템플릿이 한 줄로 눌려 들어오면 "0. 챗봇요약 : 0. 챗봇요약 : 문의하실 내용이 없습니다. 실제문의…" 처럼 라벨이 값 안에 중첩된다.
NESTED_LABEL_RE = re.compile(
    r"^(?:\s*(?:\d+\s*\.\s*)?(?:챗봇\s*요약|내용)\s*[:：]\s*|\s*\(\s*챗봇\s*요약\s*\)\s*|\s*0\.\s*)+"
)


def strip_leading_noise(value):
    """중첩 라벨 ↔ 플레이스홀더가 번갈아 붙어 있어도 모두 걷어낼 때까지 반복한다."""
    prev = None
    while prev != value:
        prev = value
        value = NESTED_LABEL_RE.sub("", value)
        value = PLACEHOLDER_PREFIX_RE.sub("", value)
        value = value.strip()
    return value


SENT_END_RE = re.compile(r"(?<=[.?!~。])\s+")
LINE_TWICE_RE = re.compile(r"^(.{4,}?)\s+\1$")


def dedupe_sentences(text):
    """한 줄 안에서 같은 문장이 그대로 반복되는 문의를 정리한다.

    챗봇 접수 경로는 '챗봇요약'과 '내용' 필드에 같은 문장이 복사돼 한 줄로 합쳐지는 경우가 있어
    10자 이상 완전 동일 문장만 두 번째부터 버린다.
    """
    out_lines = []
    for line in text.splitlines():
        # 문장부호가 전혀 없이 같은 구절이 두 번 붙은 줄("오더 삭제 문의 오더 삭제 문의")은 통째로 한 번으로 줄인다.
        line = LINE_TWICE_RE.sub(r"\1", line.strip())
        seen, kept = set(), []
        for s in SENT_END_RE.split(line):
            key = re.sub(r"\s+", "", s)
            if len(key) >= 10 and key in seen:
                continue
            seen.add(key)
            kept.append(s)
        out_lines.append(" ".join(kept).strip())
    return "\n".join(out_lines)


# 접수 양식 고정 안내문 (문의 9,959건 / 1,589건에 등장)
NOTICE_RE = [
    re.compile(r"※\s*요청\s*내용이\s*구체적이지\s*않을\s*경우.*$", re.M),
    re.compile(r"※\s*요청\s*내용을\s*조금\s*더\s*구체적으로.*$", re.M),
    re.compile(r"\(\s*첨부파일이\s*있으면\s*신속한\s*처리가\s*가능합니다\.?\s*\)"),
    re.compile(r"실제\s*처리를\s*위해\s*문의내용은\s*필수조건입니다\.?"),
]

# 등록번호는 자리수가 가변이고 라벨 없이 본문에 섞여 나오기도 한다.
PATIENT_NO_RE = [
    (re.compile(r"((?:환자)?\s*등록번호\s*[:：]?\s*)\d{4,10}"), r"\1[등록번호]"),
    (re.compile(r"(차트번호\s*[:：]?\s*)\d{4,10}"), r"\1[등록번호]"),
    (re.compile(r"(내선(?:번호)?\s*[:：]?\s*)\d{3,5}\s*번?"), r"\1[내선]"),
]


def clean_ws(text):
    text = re.sub(r"[ \t]+", " ", text)
    text = re.sub(r"\n[ \t]*\n[ \t]*\n+", "\n\n", text)
    text = re.sub(r"^[ \t]*\n", "", text)
    return text.strip()


def mask_extra(text):
    """라벨이 붙은 등록번호·차트번호·내선번호를 마스킹한다."""
    for pattern, repl in PATIENT_NO_RE:
        text = pattern.sub(repl, text)
    return text


def parse_question(raw):
    """문의 원문을 (본문, 메타) 로 분리한다.

    템플릿이 있으면 라벨을 버리고 값만 남기며, 프로그램명/화면명은 메타로 뺀다.
    템플릿이 없는 자유 서술 문의(챗봇 외 경로)는 안내문만 제거해 그대로 쓴다.
    """
    meta = {"program_nm": "", "screen_nm": "", "occurred_raw": ""}
    text = raw or ""
    for pattern in NOTICE_RE:
        text = pattern.sub("", text)

    body_parts = []
    free_parts = []
    current = None   # 여러 줄에 걸친 필드 값을 이어 붙이기 위한 상태
    buffer = []

    def flush():
        if current is None:
            return
        value = clean_ws(" ".join(buffer))
        if value in PLACEHOLDER_VALUES:
            return
        value = strip_leading_noise(value)
        if not value or value in PLACEHOLDER_VALUES:
            return
        if current == "프로그램명":
            meta["program_nm"] = value
        elif current == "화면명":
            meta["screen_nm"] = value
        elif current == "발생일시":
            meta["occurred_raw"] = value
        elif current == "환자등록번호":
            pass                      # 값 자체를 버린다
        else:                          # 챗봇요약 / 내용
            body_parts.append(value)

    for line in text.splitlines():
        matched = TPL_FIELD_RE.match(line)
        if matched:
            flush()
            current = matched.group(1)
            buffer = [matched.group(2).strip()]
        elif current is not None:
            buffer.append(line.strip())
        elif line.strip():
            free_parts.append(line.strip())
    flush()

    if not body_parts and not free_parts:
        return "", meta
    body = clean_ws("\n".join(strip_leading_noise(p) for p in free_parts + body_parts))
    body = strip_leading_noise(body)
    body = dedupe_sentences(body)
    return mask_extra(body), meta


# ---------------------------------------------------------------- 1겹 정규식 마스킹
# 상위 120개 성씨 (인구 99% 커버)
SURNAMES = set("김이박최정강조윤장임한오서신권황안송류전홍고문양손배백허유남심노하곽성차주우구나민진지엄채원천방공현함변염여추도소석선설마길연위표명기반왕금옥육인맹제모탁국용")
STOP_NAMES = {"환자분", "담당자", "선생님", "원장님", "간호사", "관리자", "사용자", "보호자", "고객님",
              "한글명", "영문명", "차장님", "부장님", "과장님", "팀장님", "실장님", "대리님", "주임님",
              "사장님", "교수님", "기사님", "약사님", "담당님"}
# 마지막 글자가 동사 활용형이면 이름이 아니다 ("진료본 환자", "변경할 환자")
VERB_TAIL = set("본할된한신는던을를의에가이로와과도만서고며면")

RE_A = re.compile(r"(?<![가-힣\d])(\d{4,10})[ \t]+([가-힣])([가-힣]{1,3})(님|[ \t]*환자분?|[ \t]*님)?(?![가-힣])")
RE_B = re.compile(r"(?<![가-힣])([가-힣])([가-힣]{1,2})(님|[ \t]?환자분|[ \t]?환자님|[ \t]환자)(?![가-힣])")
RE_C = re.compile(r"(수진자명|환자명|환자\s*이름|성명)[ \t]*[:：]?[ \t]*([가-힣])([가-힣]{1,3})(?![가-힣])")
RE_D = re.compile(r"(?<![가-힣])([가-힣])([가-힣]{1,2})\((\d{3,10})\)(님|환자분?)?")   # 김효정(10180)님
# 조치내용에 적힌 운영 SQL — where ptno = '00031023' / MALEPTNO = '…'(배우자). RECEIPTNO(영수번호)는 제외.
RE_E = re.compile(r"(?<![a-z])((?:male|female)?ptno\s*=\s*')(\d{3,12})(')", re.I)
# LLM 실패 시 안전장치 — 환자번호가 수십 개 나열된 문의는 출력이 잘려 JSON 파싱이 깨진다
RE_FALLBACK_NUM = re.compile(r"(?<![\d\-./:\[])\d{6,10}(?![\d\-./:\]])")
# 외국인 환자 로마자 실명 — "이름 LUONG THI HONG 환자", "TSELMEG BATBAYAR 환자분". 2~4단어 영문.
_LATIN_WORDS = r"[A-Z][A-Za-z]{1,14}(?:[ \t]+[A-Z][A-Za-z]{1,14}){1,3}"
RE_F1 = re.compile(r"((?:이름|성명|환자명|수진자명)[ \t]*[:：]?[ \t]*)(" + _LATIN_WORDS + r")(?![A-Za-z])")
RE_F2 = re.compile(r"(?<![A-Za-z])(" + _LATIN_WORDS + r")([ \t]*환자(?:분|님)?)(?!구분|명|번호|등록|정보|조회|목록|리스트|차트|수[가-힣]?)")
# 로마자 단어 묶음 중 이름이 아닌 것 — 제품/SQL/의학 약어. 하나라도 포함되면 이름으로 보지 않는다.
LATIN_STOP = set("""AS ON IN OR AND NOT NULL SELECT FROM WHERE SET UPDATE DELETE INSERT INTO VALUES TABLE ALTER MODIFY
EMR OCS PACS DUR CRM HIS PC USB IP ID PW OS CT MRI EDI HIRA API URL PDF EXCEL ERROR DLL DB SQL LIST OP
BIXOLON SLP ONTIC NIMS KEY FORM AGENT NAME CARD ADMIN HISTORY BUILD LT RT BOTH HAND KNEE AP PA CERVICAL EX
PTNO SNAME BIRTHDAY DEPTCODE NAMEK IVF MASTER SERIES TPZ""".split())
# 로마자 2단어 이상이 들어 있는지 (적재 파이프라인의 2겹 캐시 무효화 판정에 쓴다)
RE_LATIN_ANY = re.compile(r"(?<![A-Za-z])" + _LATIN_WORDS + r"(?![A-Za-z])")


def _is_latin_name(s):
    words = s.split()
    if any(w.upper() in LATIN_STOP for w in words):
        return False
    return len("".join(words)) >= 5


def _is_name(surname, rest):
    name = surname + rest
    if surname not in SURNAMES or name in STOP_NAMES:
        return False
    if len(rest) == 1 and rest in VERB_TAIL:          # "이고", "추가됨" 류 2글자 오탐 차단
        return False
    if rest[-1] in VERB_TAIL and len(name) == 3:
        return False
    return True


def mask_regex(text):
    """1겹. 관용 표기를 정규식으로 마스킹한다. (마스킹된 텍스트, 잡은 토큰 목록)"""
    hits = []

    def a(m):
        if _is_name(m.group(2), m.group(3)):
            hits.append(m.group(2) + m.group(3))
            return "[등록번호] [환자명]" + (m.group(4) or "")
        return m.group(0)

    def b(m):
        if _is_name(m.group(1), m.group(2)) and (m.group(1) + m.group(2) + m.group(3).strip()) not in STOP_NAMES:
            hits.append(m.group(1) + m.group(2))
            return "[환자명]" + m.group(3)
        return m.group(0)

    def c(m):
        if _is_name(m.group(2), m.group(3)):
            hits.append(m.group(2) + m.group(3))
            return m.group(1) + " [환자명]"
        return m.group(0)

    def d(m):
        if _is_name(m.group(1), m.group(2)):
            hits.append(m.group(1) + m.group(2))
            return "[환자명]([등록번호])" + (m.group(4) or "")
        return m.group(0)

    def e(m):
        hits.append(m.group(2))
        return m.group(1) + "[등록번호]" + m.group(3)

    def f1(m):
        if _is_latin_name(m.group(2)):
            hits.append(m.group(2))
            return m.group(1) + "[환자명]"
        return m.group(0)

    def f2(m):
        if _is_latin_name(m.group(1)):
            hits.append(m.group(1))
            return "[환자명]" + m.group(2)
        return m.group(0)

    text = RE_A.sub(a, text)
    text = RE_D.sub(d, text)
    text = RE_C.sub(c, text)
    text = RE_B.sub(b, text)
    text = RE_E.sub(e, text)
    text = RE_F1.sub(f1, text)
    text = RE_F2.sub(f2, text)
    return text, hits
