# combine-ai-server — AS 통합화면 「AI 추천」 추천 API 서버

`[AX Lab]` AS 통합화면(`/ad/as/list.do`) 의 「AI 추천」 버튼이 호출하는 추천 API 입니다.
CRM(Java, `CombineAsAiClient`) 이 이 서버에 문의 원문을 보내면, 표준답변(Tier1) · 과거 AS 사례(Tier2) · 공지(Tier3) 중 관련 높은 5건을 돌려줍니다.

**CRM 과 별도 프로세스**이므로 CRM 을 띄우는 PC/서버마다 이 서버도 함께 떠 있어야 합니다. 안 떠 있으면 CRM 화면에는
"AI 추천 서버 응답이 지연되어 건너뛰었습니다 [다시 시도]" 가 뜨고 나머지 화면은 정상 동작합니다(조용한 실패).

설계서: `mdfile/AS통합화면_AI추천_통합설계.md` (§6 API 계약, §7-3 랭킹, §13 AWS 이관)

---

## 1. 폴더 구성
<!-- [AX Lab] 수정 시작 (2026-10-15 AX Lab): 원격 Cross-Encoder 재정렬 구성 파일 추가 -->
| 파일 | 역할 |
|---|---|
| `run.bat` | **Windows 기동 스크립트.** 처음 실행 시 `.venv` 생성 + `numpy` 설치, 이후엔 서버만 기동 |
| `combine_recommend_server.py` | HTTP 서버 — `POST /api/recommend`, `GET /health` |
| `combine_recommend.py` | 추천 엔진 — 하이브리드(밀집 bge-m3 + BM25) 검색, §7-3 점수·구성 규칙, 질의 전처리 |
| `combine_lexical.py` | BM25 어휘 색인 (한글 어절 + 2-gram, 형태소 분석기 불필요) |
| `combine_textprep.py` | 접수 템플릿 파싱 · 첨부 상투어 제거 · 1겹 정규식 마스킹 — **적재 파이프라인(`analysis/`) 과 공용** |
| `combine_morph.py` | **추천 근거(겹친 단어) 표시용 형태소 분석** — Kiwi로 명사 덩어리 추출, 사용자 사전(동의어·화면명). 화면 표시 전용, 미설치 시 규칙 방식 폴백 (2026-10-16) |
| `combine_wordstats.py` | **칩 형식어 판정 + 재촉 문의 판정** — 색인의 과거 문의에서 단어별 위치·재촉 문의 쏠림을 자동 계산(약 1분, `data/combine_wordstats.json` 캐시). 화면 표시 전용 (2026-10-16) |
| `combine_synonyms.py` | 질의 도메인 동의어 확장 (현장어 ↔ 시스템어, 예: 산재 지사 → 산재조합/보험거래처코드). **질의에만** 적용, 색인 재생성 불필요 (2026-10-12) |
| `combine_embed_client.py` | Ollama `bge-m3` 임베딩 호출 — 적재와 공용 |
| `combine_live_index.py` | **색인 준실시간 반영** (2026-10-15) — 백그라운드 스레드가 `data/` 를 30초마다 보고 ① 배치가 새 색인을 배포하면 재기동 없이 다시 읽고 ② `data/combine_live.jsonl` 의 델타(종결 건 upsert/delete) 를 메모리 색인에 반영 |
| `combine-rerank-server.py` | **AI PC 전용** Cross-Encoder 재정렬 API (`POST /api/rerank`, `GET /health`) |
| `combine-rerank-run.bat` | AI PC 전용 `.venv-rerank` 생성·모델 설치·재정렬 서버 기동 |
| `combine-rerank-run.sh` | 위 bat의 **macOS판** (현재 AI PC `192.168.19.141`은 macOS, Apple Silicon MPS 사용) (2026-10-16) |
| `combine-rerank-launchd.plist` | macOS 재정렬 서버 자동 기동·재기동용 LaunchAgent (2026-10-16) |
| `combine-rerank-requirements.txt` | AI PC 전용 PyTorch/Transformers 의존성. CRM PC의 경량 `requirements.txt`와 분리 |
| `combine-rerank-test.py` | 모델·네트워크 없이 순위 반영과 장애 폴백을 검증하는 회귀 테스트 |
| `data/combine_index.npz` | 문서 벡터 11,720 × 1024 (float32, L2 정규화) + doc_id — **기본 색인** (git 커밋) |
| `data/combine_unified.jsonl` | 문서 본문·메타 (마스킹 완료. `cust_code`/`cust_nm` 없음) — 기본 색인 (git 커밋) |
| `data/combine_live.jsonl` | 라이브 델타 — `analysis/combine_live.py` 가 append, 배치가 비움 (git 제외) |
| `data/combine_live_state.json` | 동기화기 상태(워터마크·마지막 폴링·오류) — `/health` 의 `live.sync` 로 노출 (git 제외) |
| `data/combine_wordstats.json` | 단어 통계 캐시 (JSON — 단어별 분류 `f`형식어/`c`업무/`n`중립 · 문서 수 · 형식어 사유). 기본 색인 `built_at` 이 바뀌면 자동 재계산. 지워도 다음 기동 때 다시 만든다 (2026-10-16) |
| `requirements.txt` | `numpy` 하나 |
<!-- [AX Lab] 수정 끝 -->

## 2. 필요 환경

<!-- [AX Lab] 수정 시작 (2026-10-15 AX Lab): 재정렬 서버 네트워크·포트 추가 -->
| 항목 | 값 |
|---|---|
| Python | 3.9 이상 (Windows 는 python.org 설치본, PATH 에 `python` 또는 `py`) |
| 패키지 | `numpy` (그 외 전부 표준 라이브러리) |
| 메모리 | 약 300 MB (벡터 38 MB + 본문 + BM25 색인) |
| 네트워크 | **사내 AI PC `192.168.19.141` 에 접속 가능해야 함** — `11434`는 질의 임베딩, `8766`은 선택적 Cross-Encoder 재정렬에 사용 |
| 포트 | 추천 서버 8765 (CRM 연결), AI PC 재정렬 서버 8766 |
<!-- [AX Lab] 수정 끝 -->

## 3. 실행

```
combine-ai-server\run.bat
```

기동 로그 예:

```
index loaded in 2.3s · 9221 docs · model bge-m3 · built 2026-10-06 15:47:35 · ...\combine-ai-server\data
embedding ok · http://192.168.19.141:11434 bge-m3 dim=1024
listening on http://127.0.0.1:8765  (X-Api-Key=dev-key)
```

확인:

<!-- [AX Lab] 수정 시작 (2026-10-15 AX Lab): health 재정렬 상태 추가 -->
```
curl http://127.0.0.1:8765/health
→ {"status":"ok","index":{...},"live":{...},"embed":{"ok":true,...},"rerank":{"enabled":true,"last_ok":...,"fallbacks":0,"circuit_open":false},"morph":{"available":true,"ready":true,"user_words":327,"error":null},"wordstats":{"ready":true,"words":774,"formal":18,"error":null}}
   status 가 embed_down 이면 Ollama 연결 문제 · index.built_at 이 배치 시각과 다르면 아직 재적재 전(30초 대기) · live.sync 가 null 이면 동기화기 미기동
```
<!-- [AX Lab] 수정 끝 -->

CRM 쪽 설정(`jwcrm/src/main/resources/combine-ai.properties`) 은 기본값이 `http://127.0.0.1:8765/api/recommend` / `dev-key` 라서
**같은 PC 에서 CRM 과 이 서버를 같이 띄우면 추가 설정 없이** 동작합니다. CRM 은 재컴파일·재기동 불필요(서버만 띄우면 다음 호출부터 성공).

<!-- [AX Lab] 수정 시작 (2026-10-15 AX Lab): AI PC 재정렬 서버 설치·운영 -->
### AI PC 재정렬 서버

Ollama가 실행 중인 AI PC에서 저장소의 `combine-ai-server` 폴더를 배포한 뒤 실행합니다.

```
set COMBINE_RERANK_API_KEY=<운영 키>
combine-rerank-run.bat 0.0.0.0
curl http://127.0.0.1:8766/health
```

최초 실행은 `BAAI/bge-reranker-v2-m3` 모델을 내려받아 시간이 걸립니다. GPU가 있으면 CUDA(Windows)·MPS(Apple Silicon)를 자동 사용하고,
없으면 CPU로 실행되지만 상위 20건 처리 시간이 0.9초를 넘을 수 있으므로 운영 전 실측해야 합니다. 추천 서버와 재정렬 서버의
`COMBINE_RERANK_API_KEY`는 같아야 하며 Windows 방화벽에서 추천 서버 IP에만 TCP 8766을 허용합니다.

<!-- [AX Lab] 수정 시작 (2026-10-16 AX Lab): 실제 AI PC(192.168.19.141)는 macOS — Mac 배포·자동 기동 절차 추가 -->
#### macOS AI PC (현재 운영: `192.168.19.141`, Apple M3 Ultra, 계정 `axlab`)

git 저장소 전체는 필요 없습니다. `combine-rerank-server.py` · `combine-rerank-requirements.txt` · `combine-rerank-run.sh` ·
`combine-rerank-launchd.plist` 4개만 `~/workspace/combine-ai-server/` 에 두면 됩니다.

```
scp combine-rerank-server.py combine-rerank-requirements.txt combine-rerank-run.sh combine-rerank-launchd.plist axlab@192.168.19.141:~/workspace/combine-ai-server/
# Mac에서 (Windows에서 복사했으면 CRLF → LF 변환 필요)
cd ~/workspace/combine-ai-server && perl -pi -e 's/\r\n?/\n/' combine-rerank-* && chmod +x combine-rerank-run.sh
./combine-rerank-run.sh 0.0.0.0          # 최초 1회: .venv-rerank 생성·torch 설치·모델 다운로드 후 포그라운드 기동
```

상시 운영은 launchd(LaunchAgent)로 띄웁니다. 로그인 시 자동 기동, 비정상 종료 시 자동 재기동되며 로그는 `combine-rerank.log` 입니다.

```
cp combine-rerank-launchd.plist ~/Library/LaunchAgents/com.axlab.combine-rerank.plist
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.axlab.combine-rerank.plist   # 등록·기동
launchctl kickstart -k gui/$(id -u)/com.axlab.combine-rerank                             # 코드 교체 후 재기동
launchctl bootout gui/$(id -u)/com.axlab.combine-rerank                                  # 중지·해제
```

운영 키는 plist의 `EnvironmentVariables` → `COMBINE_RERANK_API_KEY` 에 넣고 다시 등록합니다. macOS 방화벽은 현재 꺼져 있습니다.
LaunchAgent는 `axlab` 로그인 세션이 있어야 뜨므로 Mac 재부팅 후 자동 로그인이 켜져 있어야 합니다.
실측(2026-10-16, MPS): 평균 600자 문서 20건 약 0.3초, 1024토큰 꽉 찬 문서 20건 약 0.8초. 실제 색인 문서는 평균 276자(p99 898자)라 0.9초 제한 안쪽입니다.
<!-- [AX Lab] 수정 끝 -->

추천 흐름은 `bge-m3 + BM25 후보 검색 → 상위 20건 Cross-Encoder → 업무/자료유형/품질 결합`입니다. 재정렬 성공 시 최종 점수는
`재정렬 35% + 하이브리드 관련도 30% + 업무 일치 15% + 자료 유형 10% + 품질 10%`입니다. 재정렬 서버가 중단되거나
0.9초 안에 답하지 않으면 요청을 실패시키지 않고 기존 산식으로 즉시 폴백하며, 30초 동안 재호출을 쉬어 지연 누적을 막습니다.
<!-- [AX Lab] 수정 끝 -->

### 다른 PC 의 CRM 이 이 서버를 쓰게 하려면

1. `run.bat 0.0.0.0` 으로 기동 (모든 인터페이스 바인딩)
2. Windows 방화벽에서 TCP 8765 인바운드 허용
3. CRM 기동 시 `-Dcombine.ai.url=http://<이 PC IP>:8765/api/recommend` 주입 (또는 properties 수정)

### 환경변수 (선택)
<!-- [AX Lab] 수정 시작 (2026-10-15 AX Lab): 재정렬 클라이언트 설정 추가 -->
| 변수 | 기본값 | 설명 |
|---|---|---|
| `COMBINE_API_KEY` | `dev-key` | `X-Api-Key` 검증 키. 운영에서는 반드시 바꾸고 CRM 쪽 `combine.ai.key` 와 맞춘다 (파일에 평문으로 두지 말 것) |
| `COMBINE_OLLAMA_HOST` | `http://192.168.19.141:11434` | 임베딩 Ollama 주소 |
| `COMBINE_EMBED_MODEL` | `bge-m3` | 색인을 만든 모델과 같아야 한다. 다르면 기동 시 멈춘다 |
| `COMBINE_DATA_DIR` | `./data` | 색인 파일 위치 |
| `COMBINE_LIVE_POLL_SEC` | `30` | `data/` 변경 감시 간격(초). `0` 이면 감시 끔 (기동 시 1회 적재만, 예전 동작) |
| `COMBINE_RERANK_ENABLED` | `Y` | `N`이면 재정렬 호출 없이 기존 하이브리드 순위만 사용 |
| `COMBINE_RERANK_URL` | `http://192.168.19.141:8766/api/rerank` | AI PC 재정렬 API |
| `COMBINE_RERANK_API_KEY` | `dev-key` | 재정렬 서버 키와 일치시킬 것 |
| `COMBINE_RERANK_TOP` | `20` | 재정렬할 하이브리드 상위 후보 수(최대 20) |
| `COMBINE_RERANK_TIMEOUT_MS` | `900` | 재정렬 제한 시간. 초과 시 기존 순위로 폴백 |
<!-- [AX Lab] 수정 끝 -->
<!-- [AX Lab] 수정 시작 (2026-10-16 AX Lab): 관련 없는 추천 제외 임계 -->
| `COMBINE_RERANK_MIN_SCORE` | `-2.0` | 재정렬 원점수(logit)가 이 값 미만인 후보는 추천하지 않음. 재정렬 상위 N 밖 후보도 제외. 아주 낮게(`-99`) 두면 사실상 끔 |
| `COMBINE_FALLBACK_MIN_SIM` | `0.55` | 재정렬 장애·비활성 시 코사인이 이 값 미만인 후보는 추천하지 않음 |
<!-- [AX Lab] 수정 끝 -->

## 4. 데이터 (색인) 갱신

`data/` 의 두 파일은 **`analysis/` 적재 파이프라인**(AX Lab 개발 PC, git 미포함) 이 만듭니다.

```
extract(DB) → build_dataset → 라벨(final_results) → combine_preprocess → combine_pii_llm(2겹 마스킹)
 → combine_chatbot_extract → combine_unified → combine_embed
```

`analysis/combine_embed.py` 가 마지막에 `combine_index.npz` + `combine_unified.jsonl` 을 이 폴더의 `data/` 로 복사합니다.
**떠 있는 서버는 30초 안에 자동으로 다시 읽습니다**(2026-10-15, `combine_live_index.py`). 두 파일은 **항상 같은 실행에서 나온 쌍**이어야
합니다 — 복사 도중(npz 는 새것, jsonl 은 옛것) 읽으면 건수 불일치로 그 틱은 실패하고 다음 틱에 다시 시도하므로 서비스는 기존 색인으로 계속됩니다.

### 두 층 구조 — 기본 색인(배치) + 라이브 델타(준실시간)

| 층 | 만드는 것 | 주기 | 반영 지연 |
|---|---|---|---|
| 기본 색인 `combine_index.npz` + `combine_unified.jsonl` | `analysis/combine_refresh.py` (주기 배치, 아래) | 주 1회 권장 | 배치 종료 후 30초 |
| 라이브 델타 `combine_live.jsonl` | `analysis/combine_live.py` (`analysis/run_live.bat`, 상시) | 5분 폴링 | 종결 후 **5~10분** |

왜 두 층인가: 종결 건 하나가 추천 후보가 되려면 라벨(LLM) → 게이트 → PII 2겹 마스킹(LLM) → 임베딩을 거쳐야 해서 질의 시점에 DB 를
직접 볼 수 없습니다. 그래서 변경분만 5분마다 같은 파이프라인으로 처리해 델타로 쌓고, 배치가 주 1회 전체를 다시 만들어 델타를 흡수합니다.

### 준실시간 동기화기 (2026-10-15 추가 — `analysis/combine_live.py`)

```
cd analysis
run_live.bat                                   # = python combine_live.py --loop   (5분 간격 상시)
python combine_live.py --once                  # 한 사이클만
python combine_live.py --once --since "2026-10-12 16:00"   # 워터마크 직접 지정 (첫 기동·복구)
python combine_live.py --as-no 20261007020     # 특정 건만 강제 처리 (시험)
```

- 변경 감지: `CRM_AS_MGT.UPT_DATE/REG_DATE` ∪ `CRM_AS_MGT_ANSWER.W_DATE` ∪ `CRM_AS_MGT_HIST.REG_DATE` 세 곳 (상담원 답변은 `UPT_DATE` 를
  올리지 않아 — 완료건 20% 가 그렇다 — 마스터만 보면 놓칩니다). 각 조회 0.1초 미만. 윈도 상한은 DB `SYSDATE - 5분`(디바운스).
- 바뀐 접수번호만 01/02/04 추출 SQL 로 다시 읽고(기간 조건 → `AS_NO IN`), 배치와 **같은 함수**로 라벨·게이트·마스킹·통합·임베딩합니다.
  라벨/PII/임베딩 결과는 배치와 같은 캐시 파일에 쌓이므로 다음 배치에서 비용이 다시 들지 않습니다.
- 게이트를 통과하면 `upsert`, 색인에 있던 건이 이번 변경으로 탈락(또는 삭제)하면 `delete` 를 델타 파일에 씁니다. 서버는 30초 안에 반영.
- 배치가 도는 동안(`analysis/out/combine_refresh.lock`) 은 쉬고, 배치가 끝나면 배치가 되돌려 둔 워터마크(추출 시작 - 30분)부터 이어받습니다.
- 실패(Ollama 다운 등) 한 사이클은 워터마크를 전진시키지 않고 다음 사이클에 같은 윈도를 다시 봅니다. 라벨 실패 건은 `pending_retry` 로 재시도.
- 상태 확인: `curl http://127.0.0.1:8765/health` 의 `live.sync.last_poll_at` 이 10분 넘게 멈춰 있으면 동기화기가 죽은 것. 로그 `analysis/out/combine_live.log`.
- 전제: 동기화기를 띄우는 PC 가 **Oracle 과 Ollama 양쪽**에 닿아야 합니다 (프로젝트 루트 `.venv` — `oracledb`·`pandas`·`openai` 필요, Oracle 은 thick 모드라 클라이언트 설치본 필요).

### 주기 갱신 (2026-10-12 추가 — `analysis/combine_refresh.py`)

색인은 **추출 시점의 스냅샷**입니다. 10-06 색인은 2026-07-30 까지의 접수분이라, 테스터가 9~10월 접수건으로 검증했을 때
기대답변(예: `20260915090`)이 색인에 없어 전부 X 가 났습니다. 그래서 전 단계를 한 번에 돌리는 갱신 스크립트를 두었습니다.

```
cd analysis
..\.venv\Scripts\python.exe combine_refresh.py --start 20250601 --end 20261231 --redo-stale --workers 3
```

- 기존 산출물(라벨·PII 검출·임베딩) 은 캐시로 재사용하므로 **신규·변경 건만 비용**이 듭니다.
  실측: 신규 9,529건 → 약 1시간 (사내 Ollama `gemma4:26b` 라벨 ~25% · 규칙 처리 ~75%, 임베딩 `bge-m3`). OpenAI 키 불필요.
- `--redo-stale` : 접수 뒤 답변이 붙어 내용이 바뀐 건(무응답→답변 생김 등)을 다시 라벨링합니다. 주기 갱신 때 항상 켜세요.
- 권장 주기: 주 1회(설계서 §7-2). 끝나면 **떠 있는 서버가 30초 안에 자동 반영**합니다(재기동 불필요, 2026-10-15). 배치는 라이브 델타 파일을
  비우고 동기화기 워터마크를 되돌려 두므로 동기화기는 손대지 않아도 됩니다.
- 전제: 복제 DB(`setup-local.config.ps1`) 접속 + Ollama PC `192.168.19.141` 가동.

### 규칙 변경 시

- 전처리 규칙(`combine_textprep.py`) 을 바꾸면 질의와 문서가 다르게 처리되므로 색인도 다시 만들어야 합니다 (`combine_refresh.py --from-stage 4`).
- 동의어 규칙(`combine_synonyms.py`) 은 질의에만 적용되므로 서버 재기동만 하면 됩니다.
- 게이트 예외(`analysis/combine_preprocess.py` 의 `CONCRETE_REF_RE`) : 80자 미만이라도 "매뉴얼 p.N" · "[메뉴]-[메뉴]" · "A > B > C" 같은
  구체 참조가 있으면 적재합니다 (2026-10-12. 테스터 기대답변 `20250617092` "매뉴얼 p.14 [1-8-1 산재조합 등록] 참고" 47자가 이 예외로 들어옴).
- AWS 이관(§13) 시에는 같은 파이프라인을 `rag_cases` UPSERT 로 옮깁니다.

## 5. API 계약 (요약 — 상세는 설계서 §6)

<!-- [AX Lab] 수정 시작 (2026-10-15 AX Lab): 선택적 rerank_score 응답 필드 추가 -->
```
POST /api/recommend
X-Api-Key: dev-key
Content-Type: application/json
{
  "query": "<CALL_CONTENT 원문 그대로 — 접수 템플릿·안내문 포함해도 됨. 서버가 벗긴다>",
  "as_no": "20260730123", "exclude_as_no": ["20260730123", "..."],
  "service_cate": "진료", "inquiry_type": "진료 업무", "request_type": "",
  "program_nm": "", "screen_nm": "",          ← 비우면 질의 템플릿에서 추출한 값으로 채움
  "top_k": 5, "tiers": [1, 2, 3]
}

200 {"result":"000","elapsed_ms":300,"confidence":"high|mid|low","best_sim":0.69,
     "follow_up":false, "follow_up_detail":{"nag_near":0,"near_k":10,"content_free":false},   ← 재촉·연락 요청 문의 (2026-10-16)
     "items":[{ doc_id, tier, tier_label, title, answer_text, answer_html,
      relevance(0~1, 후보 안 상대값 — 화면 표시용), semantic_sim(코사인 원값), lexical_score(BM25 원값), score,
      rerank_score(재정렬 성공 시에만 0~1), rerank_raw(재정렬 성공 시에만 원점수 logit — 2026-10-16),
      match_terms[{term, synonym}](겹친 단어 — 2026-10-16), match_reason("같은 업무분류"|"같은 프로그램·화면"|"같은 문의유형"|null),
      confidence(high/mid/low — 절대 코사인 기준),
      service_cate, program_nm, screen_nm, topic, resolution, deep_link, public_link, attached_file[],
      occurred_at('YYYY-MM'), quality_score, internal_note, as_no, question_text }, ...]}
400 잘못된 요청 · 401 키 불일치 · 503 임베딩 서버 장애
```
<!-- [AX Lab] 수정 끝 -->

`confidence` (2026-10-12 추가): `relevance` 는 후보 60건 안에서 min-max 한 값이라 전부 무관한 결과여도 1위는 항상 100% 로 보입니다.
그래서 bge-m3 절대 코사인으로 `high ≥ 0.62 / mid / low < 0.58` 을 따로 내려줍니다 (임계는 `combine_recommend.py` 의 `CONF_*_SIM`,
실측 근거는 그 주석 참조). CRM 화면은 항목별 `confidence` 를 씁니다. (2026-10-16부터 Java 프록시가 응답 상단 필드도 그대로 넘깁니다 — 아래 `follow_up` 참조)
<!-- [AX Lab] 수정 시작 (2026-10-15 AX Lab): low 사용자 표시 정책 -->
CRM 화면은 `low`를 오류나 실패로 단정하지 않습니다. 상대값인 관련도 퍼센트 대신 `참고 사례`로 표시하고,
전부 low이면 “직접 일치하는 답변 대신 유사한 업무 사례”라는 중립 안내와 함께 목록을 그대로 제공합니다.
<!-- [AX Lab] 수정 끝 -->
<!-- [AX Lab] 수정 시작 (2026-10-16 AX Lab): 관련 없는 추천 제외 -->
**건수는 0~`top_k`건입니다** (2026-10-16). 예전에는 무관한 후보로도 항상 5칸을 채웠습니다(`relevance`·`rerank_score` 가 후보 안 상대값이라
무관해도 1위가 높게 나옴). 이제 재정렬 성공 시 원점수 `rerank_raw < COMBINE_RERANK_MIN_SCORE(-2.0)` 이거나 재정렬 상위 N 밖인 후보,
재정렬 장애 시 코사인 `< COMBINE_FALLBACK_MIN_SIM(0.55)` 인 후보는 Tier1 최소 보장을 포함한 어떤 규칙으로도 노출하지 않습니다.
실측(질의 48건): 도메인 밖 질의 노출 후보는 전부 원점수 ≤ -2.5, 관련 사례는 대부분 ≥ -2 였고 코사인으로는 둘이 0.55~0.61 에서 겹쳤습니다.
CRM 화면은 0건이면 버튼 건수를 흐리게 표시하고 "관련도가 충분한 사례가 없어 추천하지 않았습니다"로 안내합니다.
임계를 다시 맞출 때는 CLI(`python combine_recommend.py "질의"`) 출력의 `rr=` 값을 봅니다.
<!-- [AX Lab] 수정 끝 -->
<!-- [AX Lab] 수정 시작 (2026-10-16 AX Lab): 추천 근거(겹친 단어) -->
**추천 근거** (2026-10-16): 최종 항목마다 `match_terms`(문의와 그 자료의 `embed_text` 에 함께 들어 있는 말, 드문 말 순 최대 4개)와
`match_reason`(업무분류·프로그램/화면·문의유형 일치)을 붙입니다. 형태소 분석기가 없어 질의 어절의 앞부분 중 본문에 있는 가장 긴 것을 고르고
흔한 조사·하다/되다 어미를 떼어 표시합니다("진단서를" → "진단서", "전송되지" → "전송"). 문서 20% 이상에 나오는 흔한 말(IDF < 1.5 — "문의"·"확인" 등)과
서술어("나옵니다"·"뜬다고")는 뺍니다. `synonym=true` 는 질의에 없고 동의어 확장(`combine_synonyms.py`)으로 덧붙인 말이 걸렸다는 뜻입니다.
이것은 **단어 검색 쪽 근거**일 뿐이고 순위는 재정렬(문장 뜻)을 함께 보므로, 목록이 비어도 추천될 수 있습니다(화면 표시 '뜻으로 찾음').
CRM 화면은 목록에 칩 3개, 상세 패널 "겹친 단어" 줄에 4개까지 보여 주고, 동의어는 `≈` 를 붙여 주황색으로 구분합니다. CLI 출력은 `| 단어 … [일치 사유]`.
<!-- [AX Lab] 수정 (2026-10-19 AX Lab): 일치 사유 칩 화면 미표시 -->
`match_reason`("같은 업무분류" 등)은 2026-10-19부터 **CRM 화면에 표시하지 않습니다**(`combine-as-ai.js` 의 한 줄 주석 처리). 접수 시 고른 서비스구분 코드가
같은지만 보는 값이라 근거 칩으로는 정보가 적고(Tier2 의 약 21% 는 서비스구분 미입력), 응답 필드·점수 산식(`product_match` 15%)·CLI 출력은 그대로입니다.
<!-- [AX Lab] 수정 끝 -->
<!-- [AX Lab] 수정 시작 (2026-10-16 AX Lab): 겹친 단어 형태소 분석기(Kiwi) -->
**겹친 단어의 단어 자르기 — Kiwi** (2026-10-16, `combine_morph.py`): 위의 어절 규칙은 "신규및"(신규+및)처럼 덜 자르거나,
맞춤법대로 띄우면 "시술확인서"(서식 이름)를 "시술 확인서"로 더 자르는 문제가 있어 형태소 분석기 [Kiwi](https://github.com/bab2min/kiwipiepy)로 바꿨습니다.
품사를 나눈 뒤 **원문에서 붙어 있던 명사(NNG/NNP/SL 등)는 다시 한 덩어리로** 붙이고, 조사·어미·부사와 끝의 의존명사(시·후·때·중·분)는 뗍니다.
본문에 덩어리 전체가 없으면 그 안의 더 짧은 연속 조각을 긴 것부터 찾습니다(신규오더 → 신규).
- 사용자 사전: 동의어 사전 용어 + 색인 화면명/프로그램명 중 3건 이상 문서에 나오고 명사로만 이뤄진 3~12자 한글(약 330개) + `SEED_WORDS`("오더" 등 — 없으면 "D/C오더"를 C+이오+더로 오분석).
- Kiwi를 고른 이유: `pip` 한 줄 설치(Windows 휠, Java·빌드 불필요 — Mecab-ko는 Windows 빌드, KoNLPy는 JVM 필요), 띄어쓰기 오류에 강함,
  토큰마다 원문 위치를 줘서 "붙어 있던 명사"를 정확히 재결합 가능, 사용자 사전을 코드에서 바로 추가.
- 비용: 기동 시 모델 적재 약 4초(백그라운드 스레드), 문장당 약 1ms. 요청당 질의 1회만 분석합니다.
- 화면 표시에만 씁니다. 검색(BM25)·색인은 그대로라 **색인 재생성 불필요**. Kiwi 적재 전이거나 `kiwipiepy` 미설치면 어절 규칙으로 자동 폴백합니다.
  상태는 `GET /health` 의 `morph` (`ready`, `user_words`, `error`). `run.bat` 은 기존 가상환경에 `kiwipiepy` 가 없으면 설치를 시도합니다(실패해도 기동).
<!-- [AX Lab] 수정 끝 -->
<!-- [AX Lab] 수정 시작 (2026-10-16 AX Lab): 칩 형식어 거르기 · 동의어 통째로만 · 재촉 문의 -->
**칩에서 형식어 빼기** (2026-10-16, `combine_wordstats.py`): "안녕"·"연락"·"담당자"·"퇴근"처럼 문의 내용과 무관한 말이 칩에 섞이던 문제.
금지어 목록을 손으로 늘리지 않고, 색인의 Tier2 과거 문의(`question_text`)에서 단어마다 두 가지를 재서 **자동으로** 형식어를 정합니다.
- 인사·맺음말 위치: 글 맨 앞/끝에 몰리는 말(평균 가장자리 거리 ≤ 0.10, 25건 이상) — 안녕 0.037 · 수고 0.043 · 긴급 0.071 · 감사 0.093 (삭제·오류·처방은 0.22~0.27).
- 재촉 문의 쏠림: `topic=처리현황독촉` 문의(72건)에 몰리는 말. 표본이 작아 단순 배율은 우연에 흔들리므로(0건인 '경과기록지'도 3.4배)
  Wilson 하한(90%)이 기준 비율의 2배 이상이고 3건 이상 나온 말만 — 담당자 · 전화(번호) · 연락 · 답변 · 처리 · 진행 · 상황 · 신청 · 어제 · 월요일 · 지연.
- 드문 말(문서 20건 미만 — 퇴근·휴무)은 통계를 믿을 수 없으므로 **같은 문장**을 봅니다. 형식어가 있고 업무 용어(서비스구분·문제유형에 쏠리는 말,
  영문, 업무 조각이 든 합성어)가 없는 문장의 말은 형식어로 봅니다. "퇴근 전에 연락 부탁" → 퇴근 제외 / "시술확인서 연락 부탁" → 시술확인서 유지.
- 실측(실제 문의 40건 + 연락 요청 문장 17개): 빠진 칩 연락 21 · 담당자 14 · 답변 7 · 통화 4 · 긴급 3 · 접수번호 2 · 상황 1, 업무 칩은 빠진 것 없음.
- 따져 본 다른 방법: IDF(안녕도 드문 말이라 실패), 단어 벡터 분류(수고·회사를 업무어로, 삭제·변경을 형식어로 오판), 문의에서 단어를 지웠을 때의
  의미 변화(원외약국·환경설정값 같은 정상 칩까지 지움) — 모두 버렸습니다.
- 통계는 기동 후 백그라운드에서 계산(약 1분, Kiwi 적재 후)하고 `data/combine_wordstats.json` 에 저장해 다음 기동부터는 즉시 읽습니다.
  준비 전에는 거르기 없이 기존대로 동작합니다. 상태는 `/health` 의 `wordstats`.

**동의어 칩은 통째로만** (2026-10-16): 동의어 "보험회사" 의 조각 "회사" 가 `≈ 회사` 로 뜨던 문제. 동의어는 문의에도 사전에도 없는 조각을
근거로 보여 주지 않습니다. 칩 순서도 **문의에 있던 말 먼저, 동의어(≈)는 뒤**로 바꿨습니다.

**재촉·연락 요청 문의** (2026-10-16): `follow_up=true` 는 "연락 달라", "재문의 드립니다" 처럼 앞선 접수를 재촉하는 문의라는 뜻입니다.
판정: 질의 벡터와 가장 가까운 Tier2 문의 10건(자기·연결건 제외) 중 `처리현황독촉` 이 2건 이상(`nag_near` — 전체의 0.6% 라 평소의 30배), 또는
문의에 형식어만 있고 업무 내용이 없음(`content_free`). 실측: 연락 요청·재문의 문장 11개 중 8개 탐지, 일반 실제 문의 40건 오탐 0건.
CRM 화면은 이때 「문의 내용 키워드 · 연관 이력」 블록을 접수·처리 정보 맨 위로 올리고 안내 한 줄을 붙입니다(`combine-as-ai.js`).
**이 필드가 화면까지 가려면 CRM Java 3개 파일(`CombineAsAiClient`·`CombineAsAiVO`·`CombineAsAiServiceImpl`) 재컴파일·WAS 재기동이 필요합니다**
(그 전에는 필드가 걸러져 기존 화면 그대로).
<!-- [AX Lab] 수정 끝 -->

응답에는 고객사 식별 정보(`cust_code`/`cust_nm`) 가 들어가지 않습니다. 질의는 1겹 정규식 마스킹 후 임베딩하며 **저장·로그하지 않습니다**(접속 로그에도 본문 없음).

## 6. 장애 시 확인 순서

| CRM 화면 메시지 | 코드 | 원인 | 조치 |
|---|---|---|---|
| AI 추천 서버 응답이 지연되어 건너뛰었습니다 [다시 시도] | 903 | **이 서버가 안 떠 있음**(연결 대기 후 타임아웃) 또는 2.5초 안에 응답 못 함 | `run.bat` 기동 → `/health` 확인 → Ollama 지연이면 `embed.message` 확인 |
| AI 추천을 불러오지 못했습니다. (904) | 904 | 연결 거부 — 포트/주소 불일치 | `combine.ai.url` 과 서버 포트 비교 |
| AI 추천을 불러오지 못했습니다. (905) | 905 | HTTP 401/503 | 401: 키 불일치 · 503: Ollama 다운 (`/health` 의 `embed.ok`) |
| AI 추천을 불러오지 못했습니다. (906) | 906 | 응답 JSON 파싱 실패 | 서버 버전 불일치 — 패키지 최신본으로 |
| AI 추천 서버가 설정되지 않았습니다 | 902 | `combine.ai.url` 비어 있음 | properties 확인 |
| 서버에 AI 추천 모듈이 아직 반영되지 않았습니다 | 900 | CRM Java 가 구버전 (응답에 `result` 없음) | `mvn compile` + WAS 재기동 |
| 추후 제공 (플레이스홀더) | 901 | `combine.ai.enabled=N` | 의도적 비활성 |

<!-- [AX Lab] 수정 시작 (2026-10-15 AX Lab): 재정렬 장애 확인 -->
`/health`의 `rerank.last_error`가 있고 `circuit_open=true`이면 원격 재정렬 장애입니다. 추천 자체는 기존 하이브리드로 정상 응답합니다.
AI PC의 `http://127.0.0.1:8766/health`, 방화벽, 양쪽 API 키를 확인합니다. `fallbacks`는 요청 처리 중 폴백한 누계입니다.
<!-- [AX Lab] 수정 끝 -->

CRM 로그: `[AX Lab] AI 추천 호출 as_no=… result=… elapsed=…ms queryLen=…` (질의 본문은 남기지 않음)

## 7. 끄기 / 롤백

- 이 서버만 끄면 CRM 은 903 으로 조용히 실패하고 나머지 기능은 영향 없다.
- CRM 에서 버튼 자체를 숨기려면 `combine.ai.enabled=N` (재기동 필요).
<!-- [AX Lab] 수정 (2026-10-15 AX Lab): 재정렬만 끄려면 추천 서버에 `COMBINE_RERANK_ENABLED=N`을 설정하고 재기동한다. -->
