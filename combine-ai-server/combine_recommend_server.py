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
  GET  /health → {"status":"ok","index":{...},"live":{...},"embed":{...}}

  [AX Lab] 2026-10-19 AI 문장 다듬기 (combine_polish.py)
  POST /api/polish
  X-Api-Key: <키>
  {"text": "<상담원이 작성 중인 답변 초안>", "tone": "polite|brief|typo", "as_no": "..."}
  200 {"result":"000","text":"<다듬은 글>","tone":"polite","model":"gemma4:26b","elapsed_ms":4200,"warnings":[]}
  400 잘못된 요청 · 401 키 불일치 · 503 {"result":"503","message":"polish unavailable: ..."} (LLM 장애·비활성)

실행:  run.bat                                   (Windows — 가상환경 생성·의존성 설치·기동까지)
       python combine_recommend_server.py --host 127.0.0.1 --port 8765
환경변수: COMBINE_API_KEY · COMBINE_OLLAMA_HOST · COMBINE_EMBED_MODEL · COMBINE_DATA_DIR · COMBINE_LIVE_POLL_SEC  (README.md 참조)

[AX Lab] 2026-10-15 준실시간 반영: 색인은 기동 후에도 combine_live_index.IndexKeeper 가 data/ 를 감시해
  (1) 배치가 새 combine_index.npz 를 배포하면 재기동 없이 다시 읽고, (2) analysis/combine_live.py 가 data/combine_live.jsonl 에
  쓴 종결 건 델타를 수 초 안에 반영한다. /health 의 "live" 로 상태를 본다.
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
# [AX Lab] 수정 (2026-10-21 AX Lab): .env(메일 비밀번호 등)를 가장 먼저 읽는다 — 아래 모듈들이 import 시점에 환경변수를 읽기 때문
import combine_env  # noqa: E402
_ENV_LOADED = combine_env.load()
# [AX Lab] 수정 시작 (2026-10-15 AX Lab): 원격 재정렬 상태를 health에 함께 제공한다.
from combine_recommend import (LocalIndex, Recommender, OUT_DIR, index_info,  # noqa: E402,F401
                               ping_rerank, rerank_status)
# [AX Lab] 수정 끝
from combine_recommend import RERANK_URL, RERANK_ENABLED  # noqa: E402  [AX Lab] 2026-10-21 AI PC 연결 감시 대상
import combine_ailink  # noqa: E402  [AX Lab] 2026-10-21 AI PC 연결 감시 (끊김/복구 로그 · 관리자 메일 · 응답 ai_link)
from combine_embed_client import OLLAMA_HOST, EMBED_MODEL, ping  # noqa: E402
import combine_morph  # noqa: E402  [AX Lab] 2026-10-16 /health 의 morph 상태
import combine_wordstats  # noqa: E402  [AX Lab] 2026-10-16 /health 의 wordstats 상태 · 기동 시 통계 준비
import combine_polish  # noqa: E402  [AX Lab] 2026-10-19 AI 문장 다듬기 (/api/polish · /health 의 polish 상태 · 기동 시 워밍업)
# [AX Lab] 수정 (2026-10-15 AX Lab): 준실시간 반영 — 색인 핫리로드·라이브 델타 적용 스레드
from combine_live_index import IndexKeeper  # noqa: E402

API_KEY = os.getenv("COMBINE_API_KEY", "dev-key")
MAX_BODY = 64 * 1024
MAX_QUERY = 4000


class Handler(BaseHTTPRequestHandler):
    server_version = "CombineRecommend/0.1"
    rec: Recommender = None   # set in main
    keeper: IndexKeeper = None  # [AX Lab] 2026-10-15 set in main

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
                               # [AX Lab] 수정 (2026-10-15 AX Lab): 라이브 반영 상태(live_*)·동기화기 상태(live) 추가
                               "index": index_info(idx),
                               "live": self.keeper.status() if self.keeper else None,
                               "embed": {"host": OLLAMA_HOST, "model": EMBED_MODEL, "ok": ok, "message": msg},
                               # [AX Lab] 수정 (2026-10-15 AX Lab): 장애여도 기존 검색으로 폴백하므로 전체 status는 유지
                               "rerank": rerank_status(),
                               # [AX Lab] 수정 (2026-10-16 AX Lab): 겹친 단어 형태소 분석(Kiwi) 준비 상태. 준비 전·미설치면 규칙 방식
                               "morph": combine_morph.status(),
                               # [AX Lab] 수정 (2026-10-16 AX Lab): 칩 형식어 통계 준비 상태. 준비 전이면 거르기 없이 동작
                               "wordstats": combine_wordstats.status(),
                               # [AX Lab] 수정 (2026-10-19 AX Lab): 문장 다듬기 LLM 상태 (ready · last_error · avg_ms). 장애여도 추천은 영향 없음
                               "polish": combine_polish.status(),
                               # [AX Lab] 수정 (2026-10-21 AX Lab): AI PC 연결 감시 (대상별 state · since · last_error · 메일 설정)
                               "ai_link": combine_ailink.status()})
        self._json(404, {"result": "404", "message": "not found"})

    def do_POST(self):
        # [AX Lab] 수정 시작 (2026-10-19 AX Lab): /api/polish 분기 추가. 인증·본문 파싱은 추천과 공유한다.
        if self.path not in ("/api/recommend", "/api/polish"):
            return self._json(404, {"result": "404", "message": "not found"})
        # [AX Lab] 수정 끝
        if self.headers.get("X-Api-Key") != API_KEY:
            return self._json(401, {"result": "401", "message": "invalid api key"})
        try:
            n = int(self.headers.get("Content-Length") or 0)
            if n <= 0 or n > MAX_BODY:
                return self._json(400, {"result": "400", "message": "bad content length"})
            req = json.loads(self.rfile.read(n).decode("utf-8"))
        except Exception:
            return self._json(400, {"result": "400", "message": "invalid json"})

        # [AX Lab] 수정 시작 (2026-10-19 AX Lab): AI 문장 다듬기. ThreadingHTTPServer 라 LLM 생성이 길어도 추천 요청을 막지 않는다.
        if self.path == "/api/polish":
            return self._polish(req)
        # [AX Lab] 수정 끝

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
        # [AX Lab] 수정 시작 (2026-10-21 AX Lab): 503 에 원인(reason)과 AI PC 연결 상태(ai_link)를 실어 화면이 'AI PC 연결 끊김' 을 구분하게 한다.
        except combine_ailink.AiPcDown:
            return self._json(503, {"result": "503", "reason": "ai_pc_down", "message": "embedding unavailable: ai pc down",
                                    "ai_link": combine_ailink.snapshot()})
        except Exception as e:  # 임베딩 서버 장애 등
            traceback.print_exc()
            return self._json(503, {"result": "503", "message": f"embedding unavailable: {type(e).__name__}",
                                    "reason": "ai_pc_down" if combine_ailink.is_down("ollama") else "embed_error",
                                    "ai_link": combine_ailink.snapshot()})
        # [AX Lab] 수정 끝
        self._json(200 if res["result"] == "000" else 400, res)

    # [AX Lab] 수정 시작 (2026-10-19 AX Lab): AI 문장 다듬기 처리. 본문은 로그에 남기지 않는다(길이·톤·소요시간만).
    def _polish(self, req):
        text = req.get("text") or ""
        tone = req.get("tone") or "polite"
        as_no = str(req.get("as_no") or "")
        try:
            res = combine_polish.polish(text, tone)
        except combine_polish.PolishError as e:
            sys.stderr.write("polish fail as_no=%s tone=%s len=%d code=%s\n" % (as_no, tone, len(text), e.code))
            if e.code == "bad_request":
                return self._json(400, {"result": "400", "message": str(e)})
            # [AX Lab] 수정 (2026-10-21 AX Lab): 원인(reason)·AI PC 연결 상태(ai_link) 추가
            down = e.code == "ai_pc_down" or combine_ailink.is_down("ollama")
            return self._json(503, {"result": "503", "message": "polish unavailable: %s" % e.code,
                                    "reason": "ai_pc_down" if down else e.code, "ai_link": combine_ailink.snapshot()})
        except Exception as e:  # 예상 밖 오류 — 추천 쪽과 같이 503
            traceback.print_exc()
            return self._json(503, {"result": "503", "message": "polish unavailable: %s" % type(e).__name__,
                                    "reason": type(e).__name__, "ai_link": combine_ailink.snapshot()})
        sys.stderr.write("polish ok as_no=%s tone=%s len=%d->%d %dms%s\n" % (
            as_no, res["tone"], res["in_len"], res["out_len"], res["elapsed_ms"],
            (" warnings=%s" % ",".join(res["warnings"])) if res["warnings"] else ""))
        res.pop("lost", None)   # 되돌리지 못한 링크 원문 — 본문 조각이므로 응답에만 두지 않고 지운다 (warnings 로 충분)
        res["ai_link"] = combine_ailink.snapshot()   # [AX Lab] 2026-10-21
        return self._json(200, res)
    # [AX Lab] 수정 끝


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--host", default="127.0.0.1", help="같은 PC 의 CRM 만 받으면 127.0.0.1, 다른 PC 도 받으면 0.0.0.0")
    ap.add_argument("--port", type=int, default=8765)
    args = ap.parse_args()
    log = lambda m: print(m, file=sys.stderr, flush=True)  # noqa: E731
    if _ENV_LOADED:   # [AX Lab] 2026-10-21 값은 찍지 않는다 (비밀번호)
        log(f".env 적용 · {', '.join(_ENV_LOADED)}")

    if not (OUT_DIR / "combine_index.npz").exists():
        log(f"[오류] 색인 파일이 없습니다: {OUT_DIR / 'combine_index.npz'}  (README '데이터' 참조)")
        sys.exit(2)
    t = time.time()
    # [AX Lab] 수정 시작 (2026-10-15 AX Lab): 준실시간 반영 — 색인 적재를 IndexKeeper 에 맡기고(기본 색인 + 라이브 델타),
    #   이후 파일 변경을 감시해 재기동 없이 Recommender.index 를 교체한다. 기존 LocalIndex() 직접 적재는 keeper.load() 안에 있다.
    Handler.rec = Recommender(None)
    Handler.keeper = IndexKeeper(Handler.rec, OUT_DIR)
    idx, n_live = Handler.keeper.load()
    log(f"index loaded in {time.time() - t:.1f}s · {len(idx.doc_ids)} docs · model {idx.model} · built {idx.built_at} · {OUT_DIR}"
        + (f" · 라이브 델타 {n_live}건 반영" if n_live else ""))
    Handler.keeper.start()
    # [AX Lab] 수정 끝
    # [AX Lab] 수정 (2026-10-16 AX Lab): 겹친 단어용 Kiwi 백그라운드 적재 (사용자 사전 = 동의어 + 색인 화면명/프로그램명)
    combine_morph.warmup(combine_morph.domain_words(idx.meta))
    combine_wordstats.warmup(idx)   # [AX Lab] 2026-10-16 형식어 통계 (캐시 있으면 즉시, 없으면 Kiwi 적재 후 약 1분)
    if idx.model != EMBED_MODEL:
        log(f"[오류] 색인 모델({idx.model}) 과 질의 임베딩 모델({EMBED_MODEL}) 이 다릅니다. COMBINE_EMBED_MODEL 을 맞추거나 색인을 다시 만드세요.")
        sys.exit(2)
    ok, msg = ping()
    log(("embedding ok · " if ok else "[경고] embedding 연결 실패 — 요청 시 503 으로 응답합니다 · ") + msg)
    # [AX Lab] 수정 시작 (2026-10-15 AX Lab): 원격 재정렬은 선택적 향상 기능 — 장애 시 기존 하이브리드로 폴백.
    rr_ok, rr_msg = ping_rerank()
    log(("rerank ok · " if rr_ok else "[경고] rerank 연결 실패 — 기존 하이브리드로 동작합니다 · ") + rr_msg)
    # [AX Lab] 수정 끝
    # [AX Lab] 수정 (2026-10-21 AX Lab): AI PC 연결 감시 시작 — 30초 점검, 끊김/복구 시 로그 + 관리자 메일
    combine_ailink.start(ollama_host=OLLAMA_HOST,
                         ollama_models=[EMBED_MODEL] + ([combine_polish.POLISH_MODEL] if combine_polish.POLISH_ENABLED else []),
                         rerank_health_url=RERANK_URL.rsplit("/api/rerank", 1)[0] + "/health",
                         rerank_enabled=RERANK_ENABLED, log=log)
    # [AX Lab] 수정 (2026-10-19 AX Lab): 문장 다듬기 모델 워밍업(백그라운드). 26B 모델 첫 적재가 수 초라 첫 사용자가 기다리지 않게 한다.
    combine_polish.warmup(log)
    log(f"listening on http://{args.host}:{args.port}  (X-Api-Key={'***' if API_KEY != 'dev-key' else 'dev-key'})")
    ThreadingHTTPServer((args.host, args.port), Handler).serve_forever()


if __name__ == "__main__":
    main()
