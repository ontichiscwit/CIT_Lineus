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
  COMBINE_ALERT_RETRY_MIN       기본 5    — 끊김 메일 자체가 실패하면 이 간격(분)으로 다시 시도한다
"""
import json
import html
import os
import smtplib
import socket
import sys
import textwrap
import threading
import time
import urllib.request
from email.header import Header
from email.mime.multipart import MIMEMultipart
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
# [AX Lab] 수정 시작 (2026-10-23 AX Lab): 실패한 끊김 메일 재시도 간격. 발송 성공 전에는 복구 메일 대상이라고 간주하지 않는다.
ALERT_RETRY_SEC = max(1, int(os.getenv("COMBINE_ALERT_RETRY_MIN", "5"))) * 60
# [AX Lab] 수정 끝

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
                    "last_check": None, "last_ok": None, "last_error": None, "alerted_at": None,
                    # [AX Lab] 수정 (2026-10-23 AX Lab): SMTP 실패 시 재시도 시각을 제어한다.
                    "alert_attempt_at": None}


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
            # [AX Lab] 수정 시작 (2026-10-23 AX Lab): 끊김 메일이 실제 성공하지 않았으면 5분마다 재시도한다.
            elif t["state"] == "down":
                if (t["alerted_at"] is None and _mail_enabled()
                        and (not t["alert_attempt_at"] or now - t["alert_attempt_at"] >= ALERT_RETRY_SEC)):
                    event = ("retry", now - t["since"], False)
                elif REPEAT_SEC and t["alerted_at"] and now - t["alerted_at"] >= REPEAT_SEC:
                    event = ("repeat", now - t["since"], False)
            # [AX Lab] 수정 끝
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
# [AX Lab] 수정 시작 (2026-10-23 AX Lab): 장애 오류와 다른 AI 서비스를 함께 보고 메일에 예상 원인·판단 근거를 제공한다.
def _mail_enabled():
    return bool(_CFG["mailer"] is not None or (MAIL_TO and SMTP_PASSWORD))


def _probe_other(name):
    """같은 AI PC의 다른 서비스를 부작용 없이 1회 확인한다. 원인 추정용이며 상태 카운트는 바꾸지 않는다."""
    other = "rerank" if name == "ollama" else "ollama"
    with _LOCK:
        t = _T.get(other)
        if not t or not t["enabled"]:
            return other, None, "감시 대상이 꺼져 있어 확인하지 못함"
        fn = t["check"]
    try:
        ok, err = fn()
        return other, bool(ok), str(err or "")
    except Exception as e:
        return other, False, "%s: %s" % (type(e).__name__, e)


def _is_transport_error(error):
    low = str(error or "").lower()
    return any(x in low for x in (
        "connectionrefused", "connection refused", "10061", "연결하지 못했",
        "timeout", "timed out", "10060", "시간이 초과",
        "no route", "network is unreachable", "host is unreachable", "10051", "10064", "10065",
        "connectionreset", "connection reset", "connectionaborted", "10053", "10054",
    ))


def _diagnose(name, error):
    """(예상 원인, 판단 근거). 단정하지 않고 운영자가 확인할 우선순위를 제시한다."""
    raw = str(error or "알 수 없는 오류")
    low = raw.lower()
    other, other_ok, other_error = _probe_other(name)
    other_label = "재정렬 서버" if other == "rerank" else "Ollama"

    if "모델 없음:" in raw:
        missing = raw.split("모델 없음:", 1)[1].strip()
        return (f"AI PC의 Ollama에 필요한 모델({missing})이 없거나 모델명이 설정과 다를 가능성이 큽니다.",
                f"Ollama /api/tags는 응답했지만 필수 모델 확인에 실패했습니다. {other_label} 확인 결과: "
                + ("정상" if other_ok else (other_error or "확인 불가")))
    if "401" in low or "403" in low:
        return ("서비스 인증 정보 또는 접근 권한 설정이 맞지 않을 가능성이 큽니다.",
                f"HTTP 인증/권한 오류가 감지되었습니다: {raw}")
    if "404" in low:
        return ("점검 URL 또는 서비스 경로가 변경되었을 가능성이 큽니다.",
                f"대상 서버가 HTTP 404를 반환했습니다: {raw}")
    if "jsondecode" in low or "expecting value" in low:
        return ("대상 포트에 다른 서비스가 떠 있거나 서비스가 비정상 응답을 반환했을 가능성이 큽니다.",
                f"상태 응답을 JSON으로 해석하지 못했습니다: {raw}")

    refused = any(x in low for x in ("connectionrefused", "connection refused", "10061", "연결하지 못했"))
    timeout = any(x in low for x in ("timeout", "timed out", "10060", "시간이 초과"))
    unreachable = any(x in low for x in ("no route", "network is unreachable", "host is unreachable", "10051", "10064", "10065"))
    reset = any(x in low for x in ("connectionreset", "connection reset", "connectionaborted", "10053", "10054"))

    if other_ok is False and _is_transport_error(other_error) and (timeout or unreachable or refused):
        return ("AI PC 전원 꺼짐·절전, 네트워크 단절 또는 공통 방화벽 문제일 가능성이 큽니다.",
                f"{LABEL[name]}와 {other_label}가 모두 응답하지 않습니다. 현재 오류: {raw} / 다른 서비스: {other_error}")
    if other_ok:
        if refused:
            return (f"AI PC와 네트워크는 살아 있지만 {LABEL[name]} 프로세스가 중지됐거나 해당 포트를 열지 못한 가능성이 큽니다.",
                    f"같은 PC의 {other_label}는 정상이나 대상 연결이 거부되었습니다: {raw}")
        if timeout:
            return (f"{LABEL[name]} 프로세스가 멈췄거나 해당 포트만 방화벽에 막힌 가능성이 큽니다.",
                    f"같은 PC의 {other_label}는 정상이지만 대상 응답 시간이 초과되었습니다: {raw}")
        if reset:
            return (f"{LABEL[name]} 재시작·비정상 종료 또는 중간 보안 프로그램에 의한 연결 종료 가능성이 있습니다.",
                    f"같은 PC의 {other_label}는 정상이나 연결 도중 강제로 종료되었습니다: {raw}")
        return (f"AI PC 전체가 아니라 {LABEL[name]} 자체의 상태·설정 문제일 가능성이 큽니다.",
                f"같은 PC의 {other_label}는 정상입니다. 대상 오류: {raw}")
    if other_ok is False and not _is_transport_error(other_error):
        return ("AI PC 네트워크는 살아 있지만 두 서비스가 각각 비정상 상태일 가능성이 큽니다.",
                f"{other_label} 포트는 응답했으나 상태 점검에 실패했습니다: {other_error} / 대상 오류: {raw}")
    if timeout or unreachable:
        return ("AI PC 전원·절전·네트워크 또는 방화벽 상태를 우선 확인해야 합니다.",
                f"대상에 도달하지 못했으며 다른 서비스도 정상 여부를 확인하지 못했습니다: {raw}")
    if refused:
        return (f"{LABEL[name]} 프로세스가 실행되지 않았거나 수신 포트가 열리지 않았을 가능성이 큽니다.",
                f"대상 연결이 거부되었습니다: {raw}")
    if reset:
        return ("서비스 재시작·비정상 종료 또는 네트워크 보안 프로그램이 연결을 중단했을 가능성이 있습니다.",
                f"연결 도중 강제로 종료되었습니다: {raw}")
    return ("서비스 상태 또는 네트워크를 추가 확인해야 합니다. 현재 오류만으로 원인을 한 가지로 단정할 수 없습니다.",
            f"감지 오류: {raw} / {other_label}: {other_error or '확인 불가'}")
# [AX Lab] 수정 끝


# [AX Lab] 수정 시작 (2026-10-23 AX Lab): 그룹웨어가 긴 한글 문장을 글자 중간에서 자르지 않도록 공백 기준으로 줄을 나눈다.
def _mail_paragraph(title, value, width=46):
    wrapped = textwrap.wrap(str(value or "-"), width=width, break_long_words=False, break_on_hyphens=False) or ["-"]
    return [title] + ["  " + line for line in wrapped]
# [AX Lab] 수정 끝


# [AX Lab] 수정 시작 (2026-10-23 AX Lab): 끊김·복구 메일의 안내문과 소제목을 HTML 볼드체로 표시한다.
_MAIL_BOLD_HEADINGS = {"마지막 오류", "예상 원인", "판단 근거", "영향", "확인 순서"}
_MAIL_BOLD_FIELDS = {"대상", "주소", "감지 서버", "시각", "끊긴 시각"}


def _html_body(body):
    rows = []
    first_text = True
    for raw in body.splitlines():
        stripped = raw.strip()
        if not stripped:
            rows.append('<div style="height:10px"></div>')
            continue
        safe = html.escape(stripped)
        if first_text:
            rows.append(f'<div style="margin-bottom:12px"><strong>{safe}</strong></div>')
            first_text = False
            continue
        if stripped in _MAIL_BOLD_HEADINGS:
            rows.append(f'<div style="margin-top:12px;margin-bottom:4px"><strong>{safe}</strong></div>')
            continue
        if ":" in stripped:
            label, value = stripped.split(":", 1)
            if label.strip() in _MAIL_BOLD_FIELDS:
                rows.append(f'<div><strong>{html.escape(label.strip())}</strong> : {html.escape(value.strip())}</div>')
                continue
        indent = "padding-left:18px;" if raw.startswith("  ") else ""
        rows.append(f'<div style="{indent}">{safe}</div>')
    return ('<!doctype html><html><body style="font-family:Arial,Malgun Gothic,sans-serif;'
            'font-size:14px;line-height:1.55;color:#222">' + "".join(rows) + "</body></html>")
# [AX Lab] 수정 끝


def _on_event(name, t, kind, duration, was_alerted):
    host = socket.gethostname()
    if kind == "down":
        subject = f"[AX Lab][AI PC 연결 끊김] {LABEL[name]}"
        lead = "AI PC 와의 연결이 끊겼습니다."
    elif kind == "retry":
        subject = f"[AX Lab][AI PC 연결 끊김] {LABEL[name]}"
        lead = f"AI PC 와의 연결이 {_dur(duration)} 째 끊겨 있습니다. 이전 끊김 메일 발송이 실패하여 다시 시도합니다."
    elif kind == "repeat":
        subject = f"[AX Lab][AI PC 연결 끊김 계속 — {_dur(duration)}] {LABEL[name]}"
        lead = f"AI PC 와의 연결이 {_dur(duration)} 째 끊겨 있습니다."
    else:
        _log(f"{name} 복구 · {t['target']} · 끊김 {_dur(duration)}")
        if not was_alerted:
            return
        subject = f"[AX Lab][AI PC 연결 복구] {LABEL[name]}"
        lead = f"AI PC 연결이 복구되었습니다. (끊김 {_dur(duration)})"
    # [AX Lab] 수정 시작 (2026-10-23 AX Lab): 끊김 로그와 메일에 예상 원인·판단 근거를 함께 남긴다.
    if kind != "up":
        cause, evidence = _diagnose(name, t["last_error"])
        if kind == "down":
            _log(f"{name} 끊김 · {t['target']} · {t['last_error']} — 예상 원인: {cause}")
        elif kind == "retry":
            _log(f"{name} 끊김 메일 재시도 · {_dur(duration)} 경과 · 예상 원인: {cause}")
        else:
            _log(f"{name} 끊김 계속 · {_dur(duration)} 경과 · {t['last_error']} — 예상 원인: {cause}")
    else:
        cause, evidence = None, None
    # [AX Lab] 수정 끝
    lines = [
        lead, "",
        f"대상      : {LABEL[name]}",
        f"주소      : {t['target']}",
        f"감지 서버 : {host} (CRM PC 추천 서버)",
        f"시각      : {_ts(_now())}",
        f"끊긴 시각 : {_ts(t['since']) if kind != 'up' else _ts(_now() - duration)}",
    ]
    if kind != "up":
        # [AX Lab] 수정 시작 (2026-10-23 AX Lab): 장애 메일에서 원인 추정과 근거를 문장 중간 잘림 없이 확인한다.
        lines += [""]
        lines += _mail_paragraph("마지막 오류", t["last_error"])
        lines += _mail_paragraph("예상 원인", cause)
        lines += _mail_paragraph("판단 근거", evidence)
        lines += _mail_paragraph("영향", IMPACT[name])
        # [AX Lab] 수정 끝
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
    # [AX Lab] 수정 시작 (2026-10-23 AX Lab): SMTP 결과를 확인한 뒤에만 발송 성공 시각을 기록한다.
    # 비동기 데몬 스레드가 프로세스 종료 때 사라져 끊김 메일만 유실되는 일을 막기 위해 상태 감시 스레드에서 완료까지 기다린다.
    if not _mail_enabled():
        return
    if kind in ("down", "retry", "repeat"):
        with _LOCK:
            if name in _T:
                _T[name]["alert_attempt_at"] = _now()
    mailer = _CFG["mailer"] or send_mail
    sent = _safe_send(mailer, subject, body)
    if sent and kind in ("down", "retry", "repeat"):
        with _LOCK:
            if name in _T and _T[name]["state"] == "down":
                _T[name]["alerted_at"] = _now()
    # [AX Lab] 수정 끝


def _safe_send(mailer, subject, body):
    try:
        return mailer(subject, body) is not False
    except Exception as e:
        _log(f"메일 발송 실패 · {type(e).__name__}: {e}")
        return False


def send_mail(subject, body):
    if not MAIL_TO:
        return False
    if not SMTP_PASSWORD:
        _log("메일 미발송 — COMBINE_ALERT_SMTP_PASSWORD 미설정 (알림 내용은 위 로그 참조)")
        return False
    # [AX Lab] 수정 시작 (2026-10-23 AX Lab): 텍스트 호환 본문과 소제목 볼드체 HTML 본문을 함께 보낸다.
    msg = MIMEMultipart("alternative")
    msg.attach(MIMEText(body, "plain", "utf-8"))
    msg.attach(MIMEText(_html_body(body), "html", "utf-8"))
    # [AX Lab] 수정 끝
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
    return True


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
