# -*- coding: utf-8 -*-
"""
[AX Lab] 신규 파일 (2026-10-15 AX Lab): AS 통합화면 AI 추천 — 색인 준실시간 반영 (설계서 §7-2 "준실시간")

왜 필요한가
  추천 서버는 기동 때 data/combine_index.npz + combine_unified.jsonl 을 한 번 메모리에 올리고 끝이었다.
  그래서 (1) 주기 배치(combine_refresh.py)가 색인을 다시 만들어도 재기동 전엔 반영되지 않았고,
  (2) 종결된 AS 건이 추천 후보가 되기까지 다음 배치(주 1회)를 기다려야 했다.

하는 일 (서버 안 백그라운드 스레드 IndexKeeper · 기본 30초 간격 · 요청 처리와 무관)
  ① 기본 색인 핫리로드 : data/combine_index.npz 의 (mtime, size) 가 바뀌면 LocalIndex 를 다시 읽는다.
     combine_embed.py 가 npz → jsonl 순으로 두 파일을 복사하므로 그 사이에 읽으면 건수 불일치 assert 가 난다
     → 실패는 로그만 남기고 다음 틱에 다시 시도한다 (성공할 때까지 기존 색인으로 계속 응답).
  ② 라이브 델타 적용   : data/combine_live.jsonl 에 analysis/combine_live.py 가 append 한 upsert/delete 줄을
     마지막으로 읽은 바이트 오프셋 뒤부터 읽어 LocalIndex.apply_live() 로 새 색인을 만들고 Recommender.index 를 바꿔 끼운다.
     - 줄 끝(\\n) 까지 온 완전한 줄만 소비한다 (상대 프로세스가 쓰는 도중의 반쪽 줄은 다음 틱에).
     - 파일이 줄어들었으면(배치가 비움) 기본 색인부터 다시 읽고 처음부터 재적용한다.
  ③ 상태 노출         : status() 를 /health 가 돌려준다. data/combine_live_state.json (combine_live.py 가 쓰는
     워터마크·마지막 폴링 시각) 도 함께 실어 "동기화기가 살아 있는지" 를 한 곳에서 본다.

파일 계약 (analysis/combine_live.py ↔ 이 모듈)
  data/combine_live.jsonl       한 줄 = {"op":"upsert","doc_id":"AS-…","ts":"YYYY-MM-DD HH:MM:SS","record":{…§4 통합 스키마…},"vector":[1024 floats]}
                                      | {"op":"delete","doc_id":"AS-…","ts":"…"}
  data/combine_live_state.json  {"watermark": "…", "last_poll_at": "…", "last_error": …}  (읽기만 한다)
  두 파일은 git 커밋 대상이 아니다 (.gitignore). 배치(combine_refresh.py) 가 새 기본 색인을 배포한 뒤 비운다.

환경변수  COMBINE_LIVE_POLL_SEC (기본 30) · 0 이면 감시를 끈다 (기동 시 1회 적재만).
"""
import json
import os
import sys
import threading
import time
import traceback
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from combine_recommend import LocalIndex, index_info  # noqa: E402

LIVE_FILE = "combine_live.jsonl"
STATE_FILE = "combine_live_state.json"
POLL_SEC = int(os.getenv("COMBINE_LIVE_POLL_SEC", "30"))


def _log(msg):
    print(time.strftime("%H:%M:%S ") + "[live] " + str(msg), file=sys.stderr, flush=True)


def read_live_entries(path, offset=0):
    """offset 바이트 뒤의 완전한 줄만 파싱해 (entries, new_offset) 을 돌려준다. 파일이 없으면 ([], 0)."""
    if not path.exists():
        return [], 0
    with path.open("rb") as f:
        f.seek(offset)
        buf = f.read()
    end = buf.rfind(b"\n")
    if end < 0:
        return [], offset
    entries = []
    for raw in buf[:end].split(b"\n"):
        raw = raw.strip()
        if not raw:
            continue
        try:
            e = json.loads(raw.decode("utf-8"))
        except (ValueError, UnicodeDecodeError):
            continue                                   # 깨진 줄은 버린다 (쓰는 쪽이 비정상 종료한 흔적)
        if isinstance(e, dict) and e.get("op") in ("upsert", "delete") and e.get("doc_id"):
            entries.append(e)
    return entries, offset + end + 1


def _sig(path):
    try:
        st = path.stat()
        return (st.st_mtime_ns, st.st_size)
    except OSError:
        return None


class IndexKeeper(threading.Thread):
    """Recommender.index 를 최신 상태로 유지하는 데몬 스레드. start() 전에 load() 를 한 번 불러 초기 색인을 만든다."""

    def __init__(self, recommender, data_dir, poll_sec=POLL_SEC):
        super().__init__(name="combine-live-index", daemon=True)
        self.rec = recommender
        self.data_dir = Path(data_dir)
        self.poll_sec = poll_sec
        self.npz = self.data_dir / "combine_index.npz"
        self.live = self.data_dir / LIVE_FILE
        self.state = self.data_dir / STATE_FILE
        self.base_sig = None
        self.live_offset = 0
        self.last_apply_at = None
        self.last_error = None
        self.reloads = 0
        self._lock = threading.Lock()                  # tick() 재진입 방지 (기동 시 load 와 스레드 틱)

    # ------------------------------------------------------------ 적재
    def load(self):
        """기본 색인을 읽고 라이브 파일 전체를 재적용한다. 실패하면 예외 (기존 색인 유지는 호출자 몫)."""
        base_sig = _sig(self.npz)
        idx = LocalIndex(self.data_dir)
        entries, off = read_live_entries(self.live, 0)
        if entries:
            idx = idx.apply_live(entries)
        self.rec.index = idx                           # 참조 교체 — 원자적
        self.base_sig, self.live_offset = base_sig, off
        self.last_apply_at = time.strftime("%Y-%m-%d %H:%M:%S")
        self.reloads += 1
        return idx, len(entries)

    def tick(self):
        with self._lock:
            if _sig(self.npz) != self.base_sig:
                idx, n = self.load()
                _log(f"기본 색인 재적재 · {len(idx.doc_ids)} docs · built {idx.built_at} · 라이브 재적용 {n}건")
                return
            size = self.live.stat().st_size if self.live.exists() else 0
            if size < self.live_offset:               # 배치가 비웠다 → 기본부터 다시
                idx, n = self.load()
                _log(f"라이브 파일 초기화 감지 → 재적재 · 라이브 재적용 {n}건")
                return
            if size == self.live_offset:
                return
            entries, off = read_live_entries(self.live, self.live_offset)
            if not entries:
                return
            new = self.rec.index.apply_live(entries)
            self.rec.index = new
            self.live_offset = off
            self.last_apply_at = time.strftime("%Y-%m-%d %H:%M:%S")
            ups = sum(1 for e in entries if e["op"] == "upsert")
            _log(f"라이브 델타 적용 upsert {ups} · delete {len(entries) - ups} · 현재 {len(new.doc_ids)} docs")

    def run(self):
        if self.poll_sec <= 0:
            _log("감시 꺼짐 (COMBINE_LIVE_POLL_SEC=0)")
            return
        _log(f"감시 시작 · {self.poll_sec}초 간격 · {self.live}")
        while True:
            time.sleep(self.poll_sec)
            try:
                self.tick()
                self.last_error = None
            except Exception as e:  # noqa: BLE001 — 색인 교체 실패는 다음 틱에 재시도, 서비스는 기존 색인으로 계속
                self.last_error = f"{type(e).__name__}: {e}"
                _log(f"[경고] 반영 실패, 다음 틱에 재시도: {self.last_error}")
                traceback.print_exc()

    # ------------------------------------------------------------ 상태
    def status(self):
        sync = None
        try:
            if self.state.exists():
                sync = json.loads(self.state.read_text(encoding="utf-8"))
        except (OSError, ValueError):
            sync = {"error": "state 파일 파싱 실패"}
        return {"poll_sec": self.poll_sec, "live_file": str(self.live), "live_bytes_applied": self.live_offset,
                "last_apply_at": self.last_apply_at, "reloads": self.reloads, "last_error": self.last_error,
                "index": index_info(self.rec.index), "sync": sync}
