@echo off
chcp 65001 >nul
rem (이 파일은 UTF-8 로 저장돼 있다. 위 chcp 가 한글 메시지를 깨지지 않게 한다)
rem [AX Lab] AS 통합화면 AI 추천 서버 — Windows 기동 스크립트
rem   처음 한 번: 이 폴더 안에 .venv 를 만들고 numpy 를 설치한다 (python 3.9 이상 필요, PATH 에 python 또는 py 가 있어야 함)
rem   이후      : 서버만 띄운다.  CRM(combine-ai.properties) 은 http://127.0.0.1:8765/api/recommend 를 바라본다.
rem   종료      : 이 창에서 Ctrl+C
rem   다른 PC 의 CRM 도 받으려면:  run.bat 0.0.0.0
setlocal
cd /d "%~dp0"
set HOST=%1
if "%HOST%"=="" set HOST=127.0.0.1
if "%COMBINE_API_KEY%"=="" set COMBINE_API_KEY=dev-key

if not exist ".venv\Scripts\python.exe" (
    echo [combine-ai-server] 가상환경 생성 중...
    where py >nul 2>nul && (py -3 -m venv .venv) || (python -m venv .venv)
    if errorlevel 1 ( echo [오류] python 을 찾지 못했습니다. Python 3.9+ 를 설치하고 다시 실행하세요. & pause & exit /b 1 )
    ".venv\Scripts\python.exe" -m pip install --quiet --upgrade pip
    ".venv\Scripts\python.exe" -m pip install --quiet -r requirements.txt
    if errorlevel 1 ( echo [오류] 의존성 설치 실패. 사내 프록시/인터넷 연결을 확인하세요. & pause & exit /b 1 )
)

set PYTHONIOENCODING=utf-8
set PYTHONUNBUFFERED=1
echo [combine-ai-server] 기동: http://%HOST%:8765   (Ollama: %COMBINE_OLLAMA_HOST% / 기본 192.168.19.141)
".venv\Scripts\python.exe" combine_recommend_server.py --host %HOST% --port 8765
pause
