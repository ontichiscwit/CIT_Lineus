# -*- coding: utf-8 -*-
"""
[AX Lab] AS 통합화면 AI 추천 — 어휘(BM25) 검색 (설계서 §7-3 하이브리드, 2026-10-06 추가)

왜 필요한가
  bge-m3 밀집 벡터만 쓰면 이 코퍼스에서 상위 60건의 코사인이 0.63~0.70 에 몰려 후보를 거의 구분하지 못하고,
  "마약류투약정보조회" 처럼 9,221건 중 7건에만 나오는 결정적 용어를 살리지 못한다(실측: 2026-10-06 하이브리드 시제품).
  그래서 어휘 점수를 함께 섞는다. 형태소 분석기 없이 돌아가야 하므로(사내 PC·EC2 모두 추가 설치 없음)
  한글은 어절 + 문자 2-gram, 영문·숫자는 소문자 단어로 토큰화한다.

AWS 이관
  pgvector 쪽에서도 같은 클래스를 그대로 쓴다 — 서버 기동 시 rag_cases 의 embed_text 9천여 건을 읽어
  메모리에 색인하면 2초 안팎이다(PostgreSQL tsvector 는 한글 형태소 지원이 없어 쓰지 않는다).
  질의·문서 토큰화가 같아야 하므로 tokenize() 는 이 파일 밖에서 재구현하지 말 것.
"""
import math
import re
from collections import Counter, defaultdict

import numpy as np

_TOK = re.compile(r"[가-힣]+|[A-Za-z]+|\d+")
_MASK_TOKEN = re.compile(r"\[(?:이름|등록번호|전화번호|주민번호|이메일|내선|환자명)\]")


def tokenize(text):
    """한글 어절 + (3자 이상 어절의) 문자 2-gram, 영문/숫자 소문자. 마스킹 토큰은 버린다."""
    text = _MASK_TOKEN.sub(" ", text or "")
    out = []
    for w in _TOK.findall(text):
        if "가" <= w[0] <= "힣":
            out.append(w)
            if len(w) >= 3:
                out.extend(w[i:i + 2] for i in range(len(w) - 1))
        elif w.isdigit():
            if 2 <= len(w) <= 4:      # 연도·코드 조각 정도만. 긴 숫자는 등록번호·접수번호 잔재
                out.append(w)
        else:
            out.append(w.lower())
    return out


class BM25Index:
    """순수 파이썬 BM25 (Okapi). 문서 순서는 호출자가 준 리스트 순서를 그대로 유지한다."""

    def __init__(self, texts, k1=1.2, b=0.75):
        self.k1, self.b = k1, b
        self.N = len(texts)
        self.dl = np.zeros(self.N, dtype=np.float32)
        df = Counter()
        self.post = defaultdict(list)
        for i, t in enumerate(texts):
            c = Counter(tokenize(t))
            self.dl[i] = sum(c.values())
            df.update(c.keys())
            for tok, f in c.items():
                self.post[tok].append((i, f))
        self.avgdl = float(self.dl.mean()) if self.N else 1.0
        self.idf = {t: math.log(1.0 + (self.N - n + 0.5) / (n + 0.5)) for t, n in df.items()}

    def scores(self, query):
        """질의에 대한 전체 문서 BM25 점수 벡터 (길이 N). 토큰은 중복 제거."""
        s = np.zeros(self.N, dtype=np.float32)
        for tok in set(tokenize(query)):
            idf = self.idf.get(tok)
            if not idf:
                continue
            for i, f in self.post[tok]:
                s[i] += idf * f * (self.k1 + 1) / (f + self.k1 * (1 - self.b + self.b * self.dl[i] / self.avgdl))
        return s
