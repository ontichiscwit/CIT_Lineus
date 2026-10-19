# -*- coding: utf-8 -*-
"""
[AX Lab] AS 통합화면 AI 추천 — bge-m3 임베딩 호출 (Ollama)

적재(analysis/combine_embed.py) 와 조회(combine_recommend.py) 가 같은 함수로 같은 모델을 호출해야
문서 벡터와 질의 벡터가 같은 공간에 놓인다. 그래서 여기 한 곳에 둔다.

설정 (환경변수)
  COMBINE_OLLAMA_HOST   Ollama 주소.  기본 http://192.168.19.141:11434 (사내 Ollama PC)
  COMBINE_EMBED_MODEL   임베딩 모델.  기본 bge-m3  (색인을 만든 모델과 반드시 같아야 한다 — 서버 기동 시 검사)

표준 라이브러리 + numpy 만 쓴다.
"""
import json
import os
import time
import urllib.request

import numpy as np

OLLAMA_HOST = os.getenv("COMBINE_OLLAMA_HOST", "http://192.168.19.141:11434").rstrip("/")
EMBED_MODEL = os.getenv("COMBINE_EMBED_MODEL", "bge-m3")
EMBED_DIM = 1024
MAX_CHARS = 6000       # bge-m3 8k 토큰 한도 안쪽. 문의/답변 99% 가 이 아래


def embed_texts(texts, host=OLLAMA_HOST, model=EMBED_MODEL, batch=32, log=None, timeout=300, retries=4):
    """텍스트 목록 → L2 정규화된 float32 행렬 (N × 1024). 실패 시 지수 백오프 후 RuntimeError."""
    out = []
    for i in range(0, len(texts), batch):
        chunk = [(t or "-")[:MAX_CHARS] for t in texts[i:i + batch]]
        body = json.dumps({"model": model, "input": chunk, "truncate": True}).encode("utf-8")
        req = urllib.request.Request(f"{host}/api/embed", data=body, headers={"Content-Type": "application/json"})
        last = None
        for attempt in range(retries):
            try:
                d = json.loads(urllib.request.urlopen(req, timeout=timeout).read())
                out.extend(d["embeddings"])
                break
            except Exception as e:  # noqa
                last = e
                time.sleep(2 * (attempt + 1))
        else:
            raise RuntimeError(f"임베딩 실패 batch {i}: {last!r}")
        if log and (i // batch) % 25 == 0:
            log(f"  embed {i + len(chunk)}/{len(texts)}")
    m = np.asarray(out, dtype=np.float32)
    n = np.linalg.norm(m, axis=1, keepdims=True)
    n[n == 0] = 1
    return m / n


def embed_one(text, host=OLLAMA_HOST, model=EMBED_MODEL):
    """질의 1건. 조회 경로용 — 재시도 1회·짧은 타임아웃 (CRM 쪽 readTimeout 2.5초 안에 답해야 한다)."""
    return embed_texts([text], host=host, model=model, timeout=20, retries=1)[0]


def ping(host=OLLAMA_HOST, model=EMBED_MODEL):
    """기동 점검용. (성공 여부, 메시지)"""
    try:
        v = embed_one("ping", host=host, model=model)
        return True, f"{host} {model} dim={len(v)}"
    except Exception as e:  # noqa
        return False, f"{host} {model}: {type(e).__name__} {e}"
