# [AX Lab] 원본 경로: combine-ai-server/combine_ailink.py (백업 2026-10-23)
# -*- coding: utf-8 -*-
"""
[AX Lab] 신규 파일 (2026-10-21 AX Lab): AI PC(Mac, 192.168.19.141) 연결 감시 — 끊김/복구 로그 · 관리자 메일 · 화면 표시용 상태

추천 서버(CRM PC)는 AI PC 의 두 서비스에 기대고 있다.
  ollama : Ollama :11434 — AI 추천 질의 임베딩(bge-m3) · AI 문장 다듬기(gemma4)
  rerank : 재정렬 서버 :8766 — AI 추천 순위 재채점(Cross-Encoder). 끊겨도 추천은 기존 점수식으로 계속된다
예전에는 AI PC 가 끊겨도 화면에는 "AI 추천 서버 응답 지연(903)" 처럼 CRM PC 쪽 문제와 같은 문구만 떴고(임베딩이 20초를
기다리는 동안 CRM 2.5초 제한이 먼저 끝남), 재정렬 장애는 아무 표시가 없었다. 원인을 아는 곳은 이 서버뿐이므로 여기서 상태를 관리한다.

  - 백그라운드 스레드가 INTERVAL 초마다 가벼운 점검을 한다 (Ollama GET /api/tags — 모델을 올리지 않음, 재정렬 GET /health).
  - 실제 요청이 성공하면 report(ok) 로 바로 반영하고, 실패하면 suspect() 로 가벼운 점검을 즉시 한 번 더 돌린다.
    실제 요청 실패를 그대로 세지 않는 이유: 26B 모델 생성이 길어 타임아웃 난 것까지 '끊김' 으로 세면 오탐 메일이 나간다.
  - 연속 DOWN_AFTER 회 실패하면 '끊김', 1회 성공하면 '복구'. 바뀌는 순간에만 로그 1줄 + 관리자 메일.
  - 끊김 동안 is_down('ollama') 이 True 이면 호출부가 20초를 기다리지 않고 바로 실패한다(빠른 실패) → CRM 이 지연(903)이 아니라
    'AI PC 연결 끊김' 으로 구분해 표시할 수 있다. 회복은 백그라운드 점검이 확인한다.

환경변수
  COMBINE_AILINK_INTERVAL_SEC   기본 30   — 점검 간격. 0 이면 백그라운드 점검 끔 (실제 요청 결과로만 판정)
  COMBINE_AILINK_DOWN_AFTER     기본 2    — 연속 실패 몇 번이면 끊김으로 볼지 (순간 지연 오탐 방지)
  COMBINE_ALERT_MAIL_TO         기본 hyerin.yu@cwit.co.kr — 쉼표로 여러 명. 비우면 메일 끔
  COMBINE_ALERT_SMTP_HOST       기본 gw.cwit.co.kr — 사내 그룹웨어 메일 서버 (RPA 가 웹으로 메일을 보내는 그 그룹웨어. 사내망 전용)
                                  CRM egov-com-servlet.xml 의 smtp.worksmobile.com 은 2026-10-21 시험에서 로그인이 거절돼 쓰지 않는다
  COMBINE_ALERT_SMTP_PORT       기본 25 — 그룹웨어는 25 만 열려 있다(AUTH LOGIN/PLAIN, TLS 없음)
  COMBINE_ALERT_SMTP_SECURITY   기본 포트로 결정 — 465=ssl, 587=starttls, 그 외 none
  COMBINE_ALERT_SMTP_USER       기본 25022 — 그룹웨어 로그인 ID(사번)
  COMBINE_ALERT_MAIL_FROM       기본 hyerin.yu@cwit.co.kr — 보내는 주소 (로그인 ID 가 메일 주소가 아니어서 따로 둔다)
  COMBINE_ALERT_SMTP_PASSWORD   기본 없음 — 없으면 메일을 보내지 않고 로그에만 남긴다 (비밀번호를 파일에 두지 않는다)
  COMBINE_ALERT_REPEAT_MIN      기본 180  — 끊김이 계속되면 이 간격(분)으로 다시 알린다. 0 이면 재알림 없음
"""
import json
import os
import smtplib
import socket
import sys
import threading
import time
import urllib.request
from email.header import Header
from email.mime.text import MIMEText
from email.utils import formataddr, formatdate

INTERVAL = max(0, int(os.getenv("COMBINE_AILINK_INTERVAL_SEC", "30")))
DOWN_AFTER = max(1, int(os.getenv("COMBINE_AILINK_DOWN_AFTER", "2")))
CHECK_TIMEOUT = 3.0

MAIL_TO = [a.strip() for a in os.getenv("COMBINE_ALERT_MAIL_TO", "hyerin.yu@cwit.co.kr").split(",") if a.strip()]
SMTP_HOST = os.getenv("COMBINE_ALERT_SMTP_HOST", "gw.cwit.co.kr")
SMTP_PORT = int(os.getenv("COMBINE_ALERT_SMTP_PORT", "25"))
SMTP_SECURITY = os.getenv("COMBINE_ALERT_SMTP_SECURITY", "").lower() or {465: "ssl", 587: "starttls"}.get(SMTP_PORT, "none")
SMTP_USER = os.getenv("COMBINE_ALERT_SMTP_USER", "25022")
MAIL_FROM = os.getenv("COMBINE_ALERT_MAIL_FROM", "hyerin.yu@cwit.co.kr")
SMTP_PASSWORD = os.getenv("COMBINE_ALERT_SMTP_PASSWORD", "")
REPEAT_SEC = max(0, int(os.getenv("COMBINE_ALERT_REPEAT_MIN", "180"))) * 60

LABEL = {"ollama": "Ollama (AI 추천 임베딩 · AI 문장 다듬기)", "rerank": "재정렬 서버 (AI 추천 순위 재채점)"}
IMPACT = {
    "ollama": "AI 추천이 응답하지 못하고, AI 문장 다듬기는 브라우저 기본 규칙으로 대체됩니다.",
    "rerank": "AI 추천은 계속 나오지만 AI 재채점 없이 기본 점수식으로 정렬됩니다.",
}

_LOCK = threading.Lock()
_T = {}                 # name -> 상태 dict
_CFG = {"started": False, "log": None, "mailer": None}


def _now():
    return time.time()


def _ts(t):
    return time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(t)) if t else "-"


def _dur(sec):
    sec = int(max(0, sec))
    h, m, s = sec // 3600, sec % 3600 // 60, sec % 60
    return (f"{h}시간 " if h else "") + (f"{m}분 " if h or m else "") + f"{s}초"


def _log(msg):
    fn = _CFG["log"] or (lambda m: print(m, file=sys.stderr, flush=True))
    fn(time.strftime("%H:%M:%S ") + "[ai-link] " + msg)


# ----------------------------------------------------------------------------- 점검 함수
def _check_ollama(host, models):
    """Ollama 가 떠 있고 필요한 모델이 설치돼 있는지. (ok, error)"""
    data = json.loads(urllib.request.urlopen(host + "/api/tags", timeout=CHECK_TIMEOUT).read().decode("utf-8"))
    have = {str(m.get("name") or m.get("model") or "") for m in data.get("models") or []}
    missing = [m for m in models if m and m not in have and (":" in m or m + ":latest" not in have)]
    if missing:
        return False, "모델 없음: " + ", ".join(missing)
    return True, None


def _check_rerank(health_url):
    data = json.loads(urllib.request.urlopen(health_url, timeout=CHECK_TIMEOUT).read().decode("utf-8"))
    if data.get("status") != "ok":
        return False, "health status=%s" % data.get("status")
    return True, None


# ----------------------------------------------------------------------------- 상태
def register(name, check_fn, target, enabled=True):
    """감시 대상 등록. check_fn() → (ok, error) 또는 예외. target 은 메일·로그에 보일 주소."""
    with _LOCK:
        _T[name] = {"check": check_fn, "target": target, "enabled": bool(enabled),
                    "state": "unknown" if enabled else "off", "since": _now(), "fails": 0,
                    "last_check": None, "last_ok": None, "last_error": None, "alerted_at": None}


def report(name, ok, error=None):
    """점검 또는 실제 요청 결과 반영. 상태가 바뀌면 로그·메일."""
    event = None
    with _LOCK:
        t = _T.get(name)
        if not t or not t["enabled"]:
            return
        now = _now()
        t["last_check"] = now
        if ok:
            t["fails"] = 0
            t["last_ok"] = now
            t["last_error"] = None
            if t["state"] != "ok":
                prev, down_for = t["state"], now - t["since"]
                t["state"], t["since"] = "ok", now
                if prev == "down":
                    event = ("up", down_for, t["alerted_at"] is not None)
                    t["alerted_at"] = None
        else:
            t["fails"] += 1
            t["last_error"] = str(error or "error")[:200]
            if t["state"] != "down" and t["fails"] >= DOWN_AFTER:
                t["state"], t["since"] = "down", now
                event = ("down", 0, False)
            elif t["state"] == "down" and REPEAT_SEC and t["alerted_at"] and now - t["alerted_at"] >= REPEAT_SEC:
                event = ("repeat", now - t["since"], False)
        snap = dict(t)
    if event:
        _on_event(name, snap, *event)


class AiPcDown(Exception):
    """끊김 상태라 호출하지 않고 바로 실패 (빠른 실패)."""


def suspect(name):
    """실제 요청 실패 — 점검을 즉시 1회 백그라운드로 돌린다 (이미 도는 중이면 생략)."""
    with _LOCK:
        t = _T.get(name)
        if not t or not t["enabled"] or t.get("probing"):
            return
        t["probing"] = True

    def run():
        try:
            check_now(name)
        finally:
            with _LOCK:
                t["probing"] = False
    threading.Thread(target=run, name="ailink-probe", daemon=True).start()


def ensure_up(name):
    """끊김이면 AiPcDown. 호출부가 긴 타임아웃을 기다리지 않게 한다."""
    if is_down(name):
        raise AiPcDown(name)


def is_down(name):
    with _LOCK:
        t = _T.get(name)
        return bool(t and t["enabled"] and t["state"] == "down")


def snapshot():
    """화면용 요약 — 추천/다듬기 응답의 ai_link. 상태값: ok | down | off | unknown"""
    with _LOCK:
        out = {name: t["state"] for name, t in _T.items()}
        downs = [t["since"] for t in _T.values() if t["state"] == "down"]
    if downs:
        out["down_since"] = _ts(min(downs))
    return out


def status():
    """/health 용 상세."""
    with _LOCK:
        items = {name: {"state": t["state"], "target": t["target"], "since": _ts(t["since"]),
                        "last_check": _ts(t["last_check"]), "last_ok": _ts(t["last_ok"]),
                        "last_error": t["last_error"], "fails": t["fails"]} for name, t in _T.items()}
    return {"interval_sec": INTERVAL, "down_after": DOWN_AFTER,
            "mail": {"to": MAIL_TO, "enabled": bool(MAIL_TO and SMTP_PASSWORD)}, "targets": items}


def check_now(name=None):
    """등록된 점검을 즉시 1회 실행 (기동 시·백그라운드 루프)."""
    with _LOCK:
        names = [n for n, t in _T.items() if t["enabled"] and (name is None or n == name)]
    for n in names:
        with _LOCK:
            fn = _T[n]["check"]
        try:
            ok, err = fn()
        except Exception as e:  # 연결 거부·타임아웃·JSON 오류 모두 실패
            ok, err = False, "%s: %s" % (type(e).__name__, e)
        report(n, ok, err)


# ----------------------------------------------------------------------------- 알림
def _on_event(name, t, kind, duration, was_alerted):
    host = socket.gethostname()
    if kind == "down":
        _log(f"{name} 끊김 · {t['target']} · {t['last_error']} — {IMPACT[name]}")
        subject = f"[AX Lab][AI PC 연결 끊김] {LABEL[name]}"
        lead = "AI PC 와의 연결이 끊겼습니다."
    elif kind == "repeat":
        _log(f"{name} 끊김 계속 · {_dur(duration)} 경과 · {t['last_error']}")
        subject = f"[AX Lab][AI PC 연결 끊김 계속 — {_dur(duration)}] {LABEL[name]}"
        lead = f"AI PC 와의 연결이 {_dur(duration)} 째 끊겨 있습니다."
    else:
        _log(f"{name} 복구 · {t['target']} · 끊김 {_dur(duration)}")
        if not was_alerted:
            return
        subject = f"[AX Lab][AI PC 연결 복구] {LABEL[name]}"
        lead = f"AI PC 연결이 복구되었습니다. (끊김 {_dur(duration)})"
    lines = [
        lead, "",
        f"대상      : {LABEL[name]}",
        f"주소      : {t['target']}",
        f"감지 서버 : {host} (CRM PC 추천 서버)",
        f"시각      : {_ts(_now())}",
        f"끊긴 시각 : {_ts(t['since']) if kind != 'up' else _ts(_now() - duration)}",
    ]
    if kind != "up":
        lines += [f"마지막 오류: {t['last_error'] or '-'}", f"영향      : {IMPACT[name]}"]
    body = "\n".join(lines + [
        "",
        "확인 순서",
        "  1) AI PC(Mac) 전원·네트워크 확인 — ping 192.168.19.141",
        "  2) Ollama: curl http://192.168.19.141:11434/api/tags  (ollama serve 실행 여부)",
        "  3) 재정렬: curl http://192.168.19.141:8766/health  (launchctl kickstart -k gui/$(id -u)/com.axlab.combine-rerank)",
        "  4) 추천 서버 상태: curl http://127.0.0.1:8765/health  의 ai_link",
        "",
        "이 메일은 combine-ai-server(combine_ailink.py) 가 자동 발송했습니다.",
    ])
    if kind in ("down", "repeat"):
        with _LOCK:
            if name in _T:
                _T[name]["alerted_at"] = _now()
    mailer = _CFG["mailer"] or send_mail
    threading.Thread(target=_safe_send, args=(mailer, subject, body), name="ailink-mail", daemon=True).start()


def _safe_send(mailer, subject, body):
    try:
        mailer(subject, body)
    except Exception as e:
        _log(f"메일 발송 실패 · {type(e).__name__}: {e}")


def send_mail(subject, body):
    if not MAIL_TO:
        return
    if not SMTP_PASSWORD:
        _log("메일 미발송 — COMBINE_ALERT_SMTP_PASSWORD 미설정 (알림 내용은 위 로그 참조)")
        return
    msg = MIMEText(body, "plain", "utf-8")
    msg["Subject"] = Header(subject, "utf-8")
    msg["From"] = formataddr((str(Header("AX Lab AI 서버", "utf-8")), MAIL_FROM))
    msg["To"] = ", ".join(MAIL_TO)
    msg["Date"] = formatdate(localtime=True)
    smtp_cls = smtplib.SMTP_SSL if SMTP_SECURITY == "ssl" else smtplib.SMTP
    with smtp_cls(SMTP_HOST, SMTP_PORT, timeout=15) as s:
        if SMTP_SECURITY == "starttls":
            s.starttls()
        s.login(SMTP_USER, SMTP_PASSWORD)
        s.sendmail(MAIL_FROM, MAIL_TO, msg.as_string())
    _log(f"메일 발송 · {', '.join(MAIL_TO)} · {subject}")


# ----------------------------------------------------------------------------- 기동
def start(*, ollama_host, ollama_models, rerank_health_url, rerank_enabled, log=None, mailer=None):
    """추천 서버 기동 시 1회. 대상 등록 → 즉시 1회 점검 → 백그라운드 루프."""
    _CFG["log"], _CFG["mailer"] = log, mailer
    register("ollama", lambda: _check_ollama(ollama_host, ollama_models), ollama_host)
    register("rerank", lambda: _check_rerank(rerank_health_url), rerank_health_url, enabled=rerank_enabled)
    if not (MAIL_TO and SMTP_PASSWORD):
        _log("관리자 메일 꺼짐 — COMBINE_ALERT_SMTP_PASSWORD 미설정 (끊김/복구는 로그에만)" if MAIL_TO
             else "관리자 메일 꺼짐 — COMBINE_ALERT_MAIL_TO 비어 있음")
    for _ in range(DOWN_AFTER):          # 기동 직후 끊겨 있으면 바로 끊김으로 판정·알림
        check_now()
        if not any(t["state"] == "unknown" for t in _T.values()):
            break
    if INTERVAL and not _CFG["started"]:
        _CFG["started"] = True

        def loop():
            while True:
                time.sleep(INTERVAL)
                check_now()
        threading.Thread(target=loop, name="ailink-monitor", daemon=True).start()
