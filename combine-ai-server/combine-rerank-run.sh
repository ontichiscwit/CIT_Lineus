#!/bin/bash
# [AX Lab] AS 통합화면 AI 추천 Cross-Encoder 재정렬 서버 — macOS AI/Ollama PC 전용 (combine-rerank-run.bat 의 macOS판)
#   최초 실행은 모델 다운로드가 필요하다. 운영 중에는 Hugging Face 로컬 캐시(~/.cache/huggingface)를 재사용한다.
#   다른 PC의 추천 서버가 접속해야 하므로 기본 HOST는 0.0.0.0이다.
#   Apple Silicon이면 MPS(GPU)를 자동 사용한다. 백그라운드 실행 예:
#     nohup ./combine-rerank-run.sh 0.0.0.0 > combine-rerank.log 2>&1 &
set -e
cd "$(dirname "$0")"
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

HOST="${1:-0.0.0.0}"
export COMBINE_RERANK_API_KEY="${COMBINE_RERANK_API_KEY:-dev-key}"
export COMBINE_RERANK_MODEL="${COMBINE_RERANK_MODEL:-BAAI/bge-reranker-v2-m3}"
# MPS 미지원 연산이 있으면 CPU로 대체 실행해 기동 실패를 막는다.
export PYTORCH_ENABLE_MPS_FALLBACK=1

if [ ! -x ".venv-rerank/bin/python" ]; then
    echo "[combine-rerank] 전용 가상환경 생성 중..."
    if ! command -v python3 >/dev/null 2>&1; then
        echo "[오류] Python 3.9+를 찾지 못했습니다. (brew install python)"; exit 1
    fi
    python3 -m venv .venv-rerank
    .venv-rerank/bin/python -m pip install --quiet --upgrade pip
    if ! .venv-rerank/bin/python -m pip install -r combine-rerank-requirements.txt; then
        rm -rf .venv-rerank
        echo "[오류] 의존성 설치 실패. 인터넷/프록시를 확인하세요."; exit 1
    fi
fi

export PYTHONIOENCODING=utf-8
export PYTHONUNBUFFERED=1
echo "[combine-rerank] 기동: http://${HOST}:8766  모델: ${COMBINE_RERANK_MODEL}"
exec .venv-rerank/bin/python combine-rerank-server.py --host "$HOST" --port 8766
