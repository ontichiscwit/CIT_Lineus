# combine-ai-server — AS 통합화면 「AI 추천」 추천 API 서버

`[AX Lab]` AS 통합화면(`/ad/as/list.do`) 의 「AI 추천」 버튼이 호출하는 추천 API 입니다.
CRM(Java, `CombineAsAiClient`) 이 이 서버에 문의 원문을 보내면, 표준답변(Tier1) · 과거 AS 사례(Tier2) · 공지(Tier3) 중 관련 높은 5건을 돌려줍니다.

**CRM 과 별도 프로세스**이므로 CRM 을 띄우는 PC/서버마다 이 서버도 함께 떠 있어야 합니다. 안 떠 있으면 CRM 화면에는
"AI 추천 서버 응답이 지연되어 건너뛰었습니다 [다시 시도]" 가 뜨고 나머지 화면은 정상 동작합니다(조용한 실패).

설계서: `mdfile/AS통합화면_AI추천_통합설계.md` (§6 API 계약, §7-3 랭킹, §13 AWS 이관)

---

## 1. 폴더 구성

| 파일 | 역할 |
|---|---|
| `run.bat` | **Windows 기동 스크립트.** 처음 실행 시 `.venv` 생성 + `numpy` 설치, 이후엔 서버만 기동 |
| `combine_recommend_server.py` | HTTP 서버 — `POST /api/recommend`, `GET /health` |
| `combine_recommend.py` | 추천 엔진 — 하이브리드(밀집 bge-m3 + BM25) 검색, §7-3 점수·구성 규칙, 질의 전처리 |
| `combine_lexical.py` | BM25 어휘 색인 (한글 어절 + 2-gram, 형태소 분석기 불필요) |
| `combine_textprep.py` | 접수 템플릿 파싱 · 1겹 정규식 마스킹 — **적재 파이프라인(`analysis/`) 과 공용** |
| `combine_embed_client.py` | Ollama `bge-m3` 임베딩 호출 — 적재와 공용 |
| `data/combine_index.npz` | 문서 벡터 9,221 × 1024 (float32, L2 정규화) + doc_id |
| `data/combine_unified.jsonl` | 문서 본문·메타 (마스킹 완료. `cust_code`/`cust_nm` 없음) |
| `requirements.txt` | `numpy` 하나 |

## 2. 필요 환경

| 항목 | 값 |
|---|---|
| Python | 3.9 이상 (Windows 는 python.org 설치본, PATH 에 `python` 또는 `py`) |
| 패키지 | `numpy` (그 외 전부 표준 라이브러리) |
| 메모리 | 약 300 MB (벡터 38 MB + 본문 + BM25 색인) |
| 네트워크 | **사내 Ollama PC `192.168.19.141:11434` 에 접속 가능해야 함** — 질의 임베딩(`bge-m3`) 을 거기서 한다. 문서 벡터는 `data/` 에 있어 Ollama 는 질의 1건 임베딩에만 쓰인다 |
| 포트 | 8765 (CRM `combine-ai.properties` 의 `combine.ai.url` 과 맞출 것) |

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

```
curl http://127.0.0.1:8765/health
→ {"status":"ok","index":{...},"embed":{"ok":true,...}}        status 가 embed_down 이면 Ollama 연결 문제
```

CRM 쪽 설정(`jwcrm/src/main/resources/combine-ai.properties`) 은 기본값이 `http://127.0.0.1:8765/api/recommend` / `dev-key` 라서
**같은 PC 에서 CRM 과 이 서버를 같이 띄우면 추가 설정 없이** 동작합니다. CRM 은 재컴파일·재기동 불필요(서버만 띄우면 다음 호출부터 성공).

### 다른 PC 의 CRM 이 이 서버를 쓰게 하려면

1. `run.bat 0.0.0.0` 으로 기동 (모든 인터페이스 바인딩)
2. Windows 방화벽에서 TCP 8765 인바운드 허용
3. CRM 기동 시 `-Dcombine.ai.url=http://<이 PC IP>:8765/api/recommend` 주입 (또는 properties 수정)

### 환경변수 (선택)

| 변수 | 기본값 | 설명 |
|---|---|---|
| `COMBINE_API_KEY` | `dev-key` | `X-Api-Key` 검증 키. 운영에서는 반드시 바꾸고 CRM 쪽 `combine.ai.key` 와 맞춘다 (파일에 평문으로 두지 말 것) |
| `COMBINE_OLLAMA_HOST` | `http://192.168.19.141:11434` | 임베딩 Ollama 주소 |
| `COMBINE_EMBED_MODEL` | `bge-m3` | 색인을 만든 모델과 같아야 한다. 다르면 기동 시 멈춘다 |
| `COMBINE_DATA_DIR` | `./data` | 색인 파일 위치 |

## 4. 데이터 (색인) 갱신

`data/` 의 두 파일은 **`analysis/` 적재 파이프라인**(AX Lab 개발 PC, git 미포함) 이 만듭니다.

```
combine_preprocess → combine_pii_llm(2겹 마스킹) → combine_chatbot_extract → combine_unified → combine_embed
```

`analysis/combine_embed.py` 가 마지막에 `combine_index.npz` + `combine_unified.jsonl` 을 이 폴더의 `data/` 로 복사합니다.
갱신 후 서버를 재기동하면 반영됩니다. 두 파일은 **항상 같은 실행에서 나온 쌍**이어야 합니다(건수 불일치 시 기동 실패).

- 전처리 규칙(`combine_textprep.py`) 을 바꾸면 질의와 문서가 다르게 처리되므로 색인도 다시 만들어야 합니다.
- 증분 적재(새 AS 건 추가) 는 AWS 이관(§7-2, §13) 에서 `rag_cases` 테이블로 옮기며 구현합니다. 현재 로컬 패키지는 전량 교체 방식입니다.

## 5. API 계약 (요약 — 상세는 설계서 §6)

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

200 {"result":"000","elapsed_ms":300,"items":[{ doc_id, tier, tier_label, title, answer_text, answer_html,
      relevance(0~1, 화면 표시용), semantic_sim(코사인 원값), lexical_score(BM25 원값), score,
      service_cate, program_nm, screen_nm, topic, resolution, deep_link, public_link, attached_file[],
      occurred_at('YYYY-MM'), quality_score, internal_note, as_no, question_text }, ...]}
400 잘못된 요청 · 401 키 불일치 · 503 임베딩 서버 장애
```

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

CRM 로그: `[AX Lab] AI 추천 호출 as_no=… result=… elapsed=…ms queryLen=…` (질의 본문은 남기지 않음)

## 7. 끄기 / 롤백

- 이 서버만 끄면 CRM 은 903 으로 조용히 실패하고 나머지 기능은 영향 없다.
- CRM 에서 버튼 자체를 숨기려면 `combine.ai.enabled=N` (재기동 필요).
