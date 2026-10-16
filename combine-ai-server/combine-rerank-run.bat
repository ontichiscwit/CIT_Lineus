@echo off
chcp 65001 >nul
rem [AX Lab] AS 통합화면 AI 추천 Cross-Encoder 재정렬 서버 — AI/Ollama PC 전용
rem   최초 실행은 모델 다운로드가 필요하다. 운영 중에는 Hugging Face 로컬 캐시를 재사용한다.
rem   다른 PC의 추천 서버가 접속해야 하므로 기본 HOST는 0.0.0.0이다.
setlocal
cd /d "%~dp0"
set HOST=%1
if "%HOST%"=="" set HOST=0.0.0.0
if "%COMBINE_RERANK_API_KEY%"=="" set COMBINE_RERANK_API_KEY=dev-key
if "%COMBINE_RERANK_MODEL%"=="" set COMBINE_RERANK_MODEL=BAAI/bge-reranker-v2-m3

if not exist ".venv-rerank\Scripts\python.exe" (
    echo [combine-rerank] 전용 가상환경 생성 중...
    where py >nul 2>nul && (py -3 -m venv .venv-rerank) || (python -m venv .venv-rerank)
    if errorlevel 1 ( echo [오류] Python 3.9+를 찾지 못했습니다. & pause & exit /b 1 )
    ".venv-rerank\Scripts\python.exe" -m pip install --quiet --upgrade pip
    ".venv-rerank\Scripts\python.exe" -m pip install -r combine-rerank-requirements.txt
    if errorlevel 1 ( echo [오류] 의존성 설치 실패. 프록시/인터넷 및 CUDA용 torch 설치 여부를 확인하세요. & pause & exit /b 1 )
)

set PYTHONIOENCODING=utf-8
set PYTHONUNBUFFERED=1
echo [combine-rerank] 기동: http://%HOST%:8766  모델: %COMBINE_RERANK_MODEL%
".venv-rerank\Scripts\python.exe" combine-rerank-server.py --host %HOST% --port 8766
pause
