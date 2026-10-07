-- [AX Lab] AS 통합화면 AI 추천 — rag_cases (설계서 §4 / §7-2)
-- 생성: combine_embed.py. 실행은 AWS 이관 단계에서 수동으로 한다. 기존 rag_chunks 는 손대지 않는다.
CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE IF NOT EXISTS rag_cases (
    doc_id         TEXT PRIMARY KEY,                  -- QNA-{rag_id} | AS-{as_no} | BRD-{rag_id}
    tier           SMALLINT NOT NULL,                 -- 1 표준답변 / 2 과거사례 / 3 공지·게시판
    source_type    TEXT NOT NULL,                     -- curated_qna | as_case | notice | download | faq_video
    title          TEXT NOT NULL,
    program_nm     TEXT,
    screen_nm      TEXT,
    question_text  TEXT,
    answer_text    TEXT,
    answer_html    TEXT,                              -- 화이트리스트 정제 완료 HTML (§8-5)
    internal_note  TEXT,
    topic          TEXT,
    resolution     TEXT,
    answer_style   TEXT,
    service_cate   TEXT,
    inquiry_type   TEXT,
    quality_score  NUMERIC(4,3) NOT NULL DEFAULT 1.0,
    occurred_at    CHAR(7),                           -- 'YYYY-MM' (월까지만, §9)
    deep_link      TEXT,                              -- 관리자 화면 경로. NULL 가능 (Tier1 약 54%)
    public_link    TEXT,
    attached_file  TEXT[],
    as_no          TEXT,                              -- Tier2 전용 (exclude_as_no 필터용)
    embed_text     TEXT NOT NULL,
    embedding      vector(1024) NOT NULL,      -- bge-m3
    embed_model    TEXT NOT NULL DEFAULT 'bge-m3',
    updated_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);
-- cust_code / cust_nm 은 저장하지 않는다 (API 미포함 원칙 §9 를 저장 단계에서 보장)

CREATE INDEX IF NOT EXISTS rag_cases_tier_idx ON rag_cases (tier);
CREATE INDEX IF NOT EXISTS rag_cases_as_no_idx ON rag_cases (as_no);
-- 9천 건 규모에서는 순차 스캔으로 충분. 10만 건을 넘기면 HNSW 를 고려한다.
-- CREATE INDEX rag_cases_embedding_idx ON rag_cases USING hnsw (embedding vector_cosine_ops);
