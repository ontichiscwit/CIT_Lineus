# -*- coding: utf-8 -*-
"""
[AX Lab] AS 통합화면 AI 추천 — Cross-Encoder 재정렬 서버

AI/Ollama PC에서 별도 프로세스로 실행한다. CRM PC의 경량 추천 서버는 하이브리드
상위 후보만 이 서버로 보내며, 이 서버가 중단되어도 기존 하이브리드 순위로 폴백한다.

환경변수
  COMBINE_RERANK_API_KEY    API 키 (기본 dev-key)
  COMBINE_RERANK_MODEL      Hugging Face 모델 (기본 BAAI/bge-reranker-v2-m3)
  COMBINE_RERANK_DEVICE     auto/cuda/mps/cpu (기본 auto: cuda → mps(Apple Silicon) → cpu)
  COMBINE_RERANK_MAX_LENGTH 토큰 상한 (기본 1024)

실행
  Windows: combine-rerank-run.bat 0.0.0.0
  macOS  : ./combine-rerank-run.sh 0.0.0.0
"""
import argparse
import json
import os
import sys
import threading
import time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

import torch
from transformers import AutoModelForSequenceClassification, AutoTokenizer


API_KEY = os.getenv("COMBINE_RERANK_API_KEY", "dev-key")
MODEL_NAME = os.getenv("COMBINE_RERANK_MODEL", "BAAI/bge-reranker-v2-m3")
DEVICE_SETTING = os.getenv("COMBINE_RERANK_DEVICE", "auto").strip().lower()
MAX_LENGTH = max(128, min(int(os.getenv("COMBINE_RERANK_MAX_LENGTH", "1024")), 8192))
MAX_BODY = 512 * 1024
MAX_QUERY_CHARS = 6000
MAX_DOC_CHARS = 6000
MAX_DOCUMENTS = 20


def _mps_available():
    return getattr(torch.backends, "mps", None) is not None and torch.backends.mps.is_available()


def _device():
    if DEVICE_SETTING == "auto":
        if torch.cuda.is_available():
            return "cuda"
        return "mps" if _mps_available() else "cpu"
    if DEVICE_SETTING not in ("cuda", "mps", "cpu"):
        raise ValueError("COMBINE_RERANK_DEVICE must be auto, cuda, mps or cpu")
    if DEVICE_SETTING == "cuda" and not torch.cuda.is_available():
        raise RuntimeError("CUDA를 요청했지만 torch.cuda.is_available()가 false입니다")
    if DEVICE_SETTING == "mps" and not _mps_available():
        raise RuntimeError("MPS를 요청했지만 torch.backends.mps.is_available()가 false입니다")
    return DEVICE_SETTING


class Reranker:
    def __init__(self):
        self.device = _device()
        dtype = torch.float16 if self.device == "cuda" else torch.float32
        self.tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME)
        self.model = AutoModelForSequenceClassification.from_pretrained(
            MODEL_NAME, trust_remote_code=True, dtype=dtype
        ).to(self.device)
        self.model.eval()
        self.lock = threading.Lock()

    def score(self, query, documents):
        pairs = [[query, text] for text in documents]
        with self.lock, torch.inference_mode():
            inputs = self.tokenizer(
                pairs, padding=True, truncation=True, max_length=MAX_LENGTH, return_tensors="pt"
            )
            inputs = {key: value.to(self.device) for key, value in inputs.items()}
            logits = self.model(**inputs, return_dict=True).logits.view(-1).float().cpu()
        return [float(value) for value in logits]


class Handler(BaseHTTPRequestHandler):
    server_version = "CombineRerank/0.1"
    reranker = None

    def log_message(self, fmt, *args):
        # 질의와 문서 본문은 요청 경로·로그에 포함하지 않는다.
        sys.stderr.write("%s - %s\n" % (self.address_string(), fmt % args))

    def _json(self, status, obj):
        body = json.dumps(obj, ensure_ascii=False).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        if self.path != "/health":
            return self._json(404, {"result": "404", "message": "not found"})
        return self._json(200, {
            "status": "ok",
            "model": MODEL_NAME,
            "device": self.reranker.device,
            "max_documents": MAX_DOCUMENTS,
            "max_length": MAX_LENGTH,
        })

    def do_POST(self):
        if self.path != "/api/rerank":
            return self._json(404, {"result": "404", "message": "not found"})
        if self.headers.get("X-Api-Key") != API_KEY:
            return self._json(401, {"result": "401", "message": "invalid api key"})
        try:
            size = int(self.headers.get("Content-Length") or 0)
            if size <= 0 or size > MAX_BODY:
                return self._json(400, {"result": "400", "message": "bad content length"})
            req = json.loads(self.rfile.read(size).decode("utf-8"))
            query = str(req.get("query") or "").strip()[:MAX_QUERY_CHARS]
            raw_docs = req.get("documents")
            if not query or not isinstance(raw_docs, list) or not raw_docs:
                return self._json(400, {"result": "400", "message": "query and documents required"})
            if len(raw_docs) > MAX_DOCUMENTS:
                return self._json(400, {"result": "400", "message": "too many documents"})
            documents = [str(text or "-")[:MAX_DOC_CHARS] for text in raw_docs]
        except Exception:
            return self._json(400, {"result": "400", "message": "invalid json"})

        started = time.time()
        try:
            scores = self.reranker.score(query, documents)
        except Exception as exc:
            # 본문이나 모델 내부 예외 메시지는 반환하지 않는다.
            sys.stderr.write(f"rerank failed: {type(exc).__name__}\n")
            return self._json(503, {"result": "503", "message": "rerank unavailable"})
        return self._json(200, {
            "result": "000",
            "model": MODEL_NAME,
            "scores": scores,
            "elapsed_ms": int((time.time() - started) * 1000),
        })


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=8766)
    args = parser.parse_args()

    started = time.time()
    print(f"loading reranker · {MODEL_NAME}", file=sys.stderr, flush=True)
    Handler.reranker = Reranker()
    # 첫 요청의 CUDA 커널·메모리 준비 비용을 기동 시 지불한다.
    Handler.reranker.score("진료비 수납 취소", ["진료비 수납을 취소하는 방법"])
    print(
        f"reranker ready in {time.time() - started:.1f}s · device {Handler.reranker.device} · "
        f"http://{args.host}:{args.port}",
        file=sys.stderr,
        flush=True,
    )
    ThreadingHTTPServer((args.host, args.port), Handler).serve_forever()


if __name__ == "__main__":
    main()
