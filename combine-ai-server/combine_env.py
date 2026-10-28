# -*- coding: utf-8 -*-
"""
[AX Lab] 신규 파일 (2026-10-21 AX Lab): combine-ai-server/.env 읽기 (표준 라이브러리만 — python-dotenv 불필요)

비밀번호(COMBINE_ALERT_SMTP_PASSWORD 등)를 매번 터미널에 치지 않도록 이 폴더의 .env 에 둔다.
.env 는 루트 .gitignore 에 걸려 git 에 올라가지 않는다. 형식은 .env.example 참조.

  - KEY=VALUE 한 줄에 하나. # 으로 시작하는 줄과 빈 줄은 무시. 값의 앞뒤 따옴표(' 또는 ")는 벗긴다.
  - 이미 환경변수로 설정된 값이 있으면 덮어쓰지 않는다 (터미널에서 set 한 값이 우선).
  - 다른 모듈이 import 시점에 os.getenv 로 설정을 읽으므로, 서버가 가장 먼저 load() 를 불러야 한다.
"""
import os
from pathlib import Path

ENV_PATH = Path(__file__).resolve().parent / ".env"


def load(path=ENV_PATH):
    """읽어서 os.environ 에 넣은 키 목록. 파일이 없으면 빈 목록."""
    path = Path(path)
    if not path.is_file():
        return []
    loaded = []
    for raw in path.read_text(encoding="utf-8-sig").splitlines():
        line = raw.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        key, value = key.strip(), value.strip()
        if key.startswith("export "):
            key = key[len("export "):].strip()
        if len(value) >= 2 and value[0] == value[-1] and value[0] in "'\"":
            value = value[1:-1]
        if key and key not in os.environ:
            os.environ[key] = value
            loaded.append(key)
    return loaded
