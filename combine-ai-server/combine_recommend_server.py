# -*- coding: utf-8 -*-
"""
[AX Lab] AS 통합화면 AI 추천 — /api/recommend 서버 (설계서 §6 계약 그대로)

CRM(WAS) 과 같은 PC 또는 같은 망에 띄운다. CRM 의 `combine-ai.properties` 가 이 서버를 가리킨다.
계약(요청/응답/인증/오류)은 나중의 AWS 운영 `/api/recommend` 와 동일하므로, 이관 시 CRM 은 URL 과 키만 바꾼다.

  POST /api/recommend
  X-Api-Key: <키>                                ← 환경변수 COMBINE_API_KEY (기본 dev-key)
  {"query": "...", "as_no": "...", "exclude_as_no": [...], "service_cate": "...", "inquiry_type": "...",
   "request_type": "...", "program_nm": "...", "screen_nm": "...", "top_k": 5, "tiers": [1,2,3]}

  200 {"result":"000","elapsed_ms":123,"items":[...]}      (§6 응답)
  400 {"result":"400","message":"..."}                      잘못된 요청
  401 {"result":"401","message":"invalid api key"}
  503 {"result":"503","message":"embedding unavailable"}    Ollama 다운 등
  GET  /health → {"status":"ok","index":{...},"embed":{...}}

실행:  run.bat                                   (Windows — 가상환경 생성·의존성 설치·기동까지)
       python combine_recommend_server.py --host 127.0.0.1 --port 8765
환경변수: COMBINE_API_KEY · COMBINE_OLLAMA_HOST · COMBINE_EMBED_MODEL · COMBINE_DATA_DIR  (README.md 참조)
"""
import argparse
import json
import os
import sys
import time
import traceback
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from combine_recommend import LocalIndex, Recommender, OUT_DIR  # noqa: E402
from combine_embed_client import OLLAMA_HOST, EMBED_MODEL, ping  # noqa: E402

API_KEY = os.getenv("COMBINE_API_KEY", "dev-key")
MAX_BODY = 64 * 1024
MAX_QUERY = 4000


class Handler(BaseHTTPRequestHandler):
    server_version = "CombineRecommend/0.1"
    rec: Recommender = None   # set in main

    def log_message(self, fmt, *args):   # 질의 본문은 절대 로그에 남기지 않는다 (§9 3-1)
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
        if self.path == "/health":
            idx = self.rec.index
            ok, msg = ping()          # 임베딩 서버까지 살아 있어야 'ok' — CRM 쪽 503 원인을 여기서 바로 가른다
            return self._json(200 if ok else 503,
                              {"status": "ok" if ok else "embed_down",
                               "index": {"model": idx.model, "built_at": idx.built_at, "size": len(idx.doc_ids)},
                               "embed": {"host": OLLAMA_HOST, "model": EMBED_MODEL, "ok": ok, "message": msg}})
        self._json(404, {"result": "404", "message": "not found"})

    def do_POST(self):
        if self.path != "/api/recommend":
            return self._json(404, {"result": "404", "message": "not found"})
        if self.headers.get("X-Api-Key") != API_KEY:
            return self._json(401, {"result": "401", "message": "invalid api key"})
        try:
            n = int(self.headers.get("Content-Length") or 0)
            if n <= 0 or n > MAX_BODY:
                return self._json(400, {"result": "400", "message": "bad content length"})
            req = json.loads(self.rfile.read(n).decode("utf-8"))
        except Exception:
            return self._json(400, {"result": "400", "message": "invalid json"})

        query = (req.get("query") or "").strip()
        if not query:
            return self._json(400, {"result": "400", "message": "query required"})
        try:
            top_k = max(1, min(int(req.get("top_k") or 5), 10))
            tiers = tuple(int(t) for t in (req.get("tiers") or [1, 2, 3])) or (1, 2, 3)
            excl = [str(x) for x in (req.get("exclude_as_no") or []) if x]
        except Exception:
            return self._json(400, {"result": "400", "message": "invalid parameters"})

        try:
            res = self.rec.recommend(query[:MAX_QUERY], as_no=req.get("as_no"), exclude_as_no=excl,
                                     service_cate=req.get("service_cate"), inquiry_type=req.get("inquiry_type"),
                                     request_type=req.get("request_type"), program_nm=req.get("program_nm"),
                                     screen_nm=req.get("screen_nm"), top_k=top_k, tiers=tiers)
        except Exception as e:  # 임베딩 서버 장애 등
            traceback.print_exc()
            return self._json(503, {"result": "503", "message": f"embedding unavailable: {type(e).__name__}"})
        self._json(200 if res["result"] == "000" else 400, res)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--host", default="127.0.0.1", help="같은 PC 의 CRM 만 받으면 127.0.0.1, 다른 PC 도 받으면 0.0.0.0")
    ap.add_argument("--port", type=int, default=8765)
    args = ap.parse_args()
    log = lambda m: print(m, file=sys.stderr, flush=True)  # noqa: E731

    if not (OUT_DIR / "combine_index.npz").exists():
        log(f"[오류] 색인 파일이 없습니다: {OUT_DIR / 'combine_index.npz'}  (README '데이터' 참조)")
        sys.exit(2)
    t = time.time()
    Handler.rec = Recommender(LocalIndex())
    idx = Handler.rec.index
    log(f"index loaded in {time.time() - t:.1f}s · {len(idx.doc_ids)} docs · model {idx.model} · built {idx.built_at} · {OUT_DIR}")
    if idx.model != EMBED_MODEL:
        log(f"[오류] 색인 모델({idx.model}) 과 질의 임베딩 모델({EMBED_MODEL}) 이 다릅니다. COMBINE_EMBED_MODEL 을 맞추거나 색인을 다시 만드세요.")
        sys.exit(2)
    ok, msg = ping()
    log(("embedding ok · " if ok else "[경고] embedding 연결 실패 — 요청 시 503 으로 응답합니다 · ") + msg)
    log(f"listening on http://{args.host}:{args.port}  (X-Api-Key={'***' if API_KEY != 'dev-key' else 'dev-key'})")
    ThreadingHTTPServer((args.host, args.port), Handler).serve_forever()


if __name__ == "__main__":
    main()
