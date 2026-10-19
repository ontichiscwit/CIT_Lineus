--------------------------------------------------------------------------------
-- [AX Lab] 라인어스 문의/답변 분석 - ② 대화 스레드 추출 (2026-07-30)
--
-- 목적 : 접수 건별 대화 스레드(고객/상담원 메시지) 전체를 행 단위로 추출
--        스레드 텍스트 조립은 Python(analysis/build_dataset.py)에서 수행
--        (LISTAGG 4000바이트 제한 회피 목적)
-- 실행 : 조회 전용. CSV(UTF-8)로 내보내기 → answers.csv 로 저장
-- 기간 : 00_params.sql 에서 정의한다. 01번과 자동으로 동일해지므로 여기서 고치지 말 것.
--------------------------------------------------------------------------------
@@00_params.sql

SELECT
    W.AS_NO                                                        /* 접수번호 */
  , W.SEQ                                                          /* 메시지 순번 */
  , W.W_GUBUN                                                      /* U:고객 / A:상담원 */
  , CASE W.W_GUBUN WHEN 'U' THEN '고객'
                   WHEN 'A' THEN '상담원'
                   ELSE W.W_GUBUN END                AS SPEAKER
  , TO_CHAR(W.W_DATE, 'YYYY-MM-DD HH24:MI:SS')      AS W_DATE      /* 작성시각 */
  , W.W_CONTENT                                                    /* 메시지 내용 */
FROM CRM_AS_MGT_ANSWER W
   , CRM_AS_MGT A
WHERE W.AS_NO = A.AS_NO
  AND NVL(A.DEL_YN, 'N') <> 'Y'
  /* ▼ 분석 대상 기간 : 값은 00_params.sql 에서만 수정할 것 (01번과 동일 조건 유지) */
  AND A.ACCEPT_DT IS NOT NULL
  AND LENGTH(A.ACCEPT_DT) = 8
  AND A.ACCEPT_DT BETWEEN '&START_DT' AND '&END_DT'
ORDER BY W.AS_NO, W.W_DATE, W.SEQ
;
