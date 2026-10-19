--------------------------------------------------------------------------------
-- [AX Lab] 라인어스 문의/답변 분석 - ⑤ 기초 프로파일링 (2026-07-30)
--
-- 목적 : LLM 분류 이전에 SQL만으로 뽑을 수 있는 기초 통계 모음
--        (임원 보고서의 뼈대 숫자). 쿼리별로 블록 선택 후 개별 실행.
-- 실행 : 조회 전용
-- 공통 : 분석 기간은 00_params.sql 에서만 수정한다.
--        블록 단위(Ctrl+Enter)로 돌릴 경우, 아래 @@00_params.sql 줄을
--        세션에서 한 번 먼저 실행해야 기간 변수가 채워진다.
--        (안 하면 SQL Developer 가 값을 입력하라고 물어본다)
--------------------------------------------------------------------------------
@@00_params.sql

--------------------------------------------------------------------------------
-- P0. ACCEPT_DT 품질 점검  ※ 다른 쿼리보다 먼저 실행할 것
--     목적 : 01~04 추출 SQL 이 "8자리 정상 ACCEPT_DT" 건만 대상으로 하므로,
--            여기서 제외되는 건이 몇 건인지 = 분석 모수에서 빠지는 건이 몇 건인지 확인한다.
--     판단 : '4.정상' 외 비율이 무시할 수준이면 현행 유지,
--            유의미하면 REG_DATE 대체(아래 P0-1 참고)를 검토한다.
--     주의 : 이 쿼리만은 기간 조건을 걸지 않는다(전체 모수를 봐야 하므로).
--------------------------------------------------------------------------------
SELECT T.DT_QUALITY
     , COUNT(*)                                                AS CASE_CNT
     , ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER (), 2)        AS RATIO_PCT
     , SUM(CASE WHEN T.REG_DATE IS NOT NULL THEN 1 ELSE 0 END) AS REG_DATE_EXISTS_CNT
     , MIN(T.ACCEPT_DT)                                        AS SAMPLE_MIN
     , MAX(T.ACCEPT_DT)                                        AS SAMPLE_MAX
FROM (
        SELECT A.ACCEPT_DT
             , A.REG_DATE
             , CASE WHEN A.ACCEPT_DT IS NULL                      THEN '1.NULL'
                    WHEN LENGTH(A.ACCEPT_DT) <> 8                 THEN '2.길이가 8이 아님'
                    WHEN NOT REGEXP_LIKE(A.ACCEPT_DT, '^[0-9]{8}$') THEN '3.숫자 아닌 문자 포함'
                    ELSE '4.정상(YYYYMMDD)' END AS DT_QUALITY
          FROM CRM_AS_MGT A
         WHERE NVL(A.DEL_YN, 'N') <> 'Y'
     ) T
GROUP BY T.DT_QUALITY
ORDER BY T.DT_QUALITY
;

--------------------------------------------------------------------------------
-- P0-1. 복구 가능 건수
--       ACCEPT_DT 가 비정상인 건 중, REG_DATE(등록시각) 기준으로는
--       분석 기간 안에 들어오는 건이 몇 건인지 센다.
--       이 숫자가 크면 01~04 의 기간 조건을 REG_DATE 대체 방식으로 바꿔
--       빠진 모수를 되살릴 필요가 있다.
--------------------------------------------------------------------------------
SELECT COUNT(*) AS RECOVERABLE_CNT
FROM CRM_AS_MGT A
WHERE NVL(A.DEL_YN, 'N') <> 'Y'
  AND (A.ACCEPT_DT IS NULL OR LENGTH(A.ACCEPT_DT) <> 8)
  AND A.REG_DATE >= TO_DATE('&START_DT', 'YYYYMMDD')
  AND A.REG_DATE <  TO_DATE('&END_DT', 'YYYYMMDD') + 1
;

--------------------------------------------------------------------------------
-- P1. 월별 접수량 추이
--------------------------------------------------------------------------------
SELECT SUBSTR(A.ACCEPT_DT, 1, 6) AS YYYYMM
     , COUNT(*)                  AS CASE_CNT
FROM CRM_AS_MGT A
WHERE NVL(A.DEL_YN, 'N') <> 'Y'
  AND A.ACCEPT_DT IS NOT NULL AND LENGTH(A.ACCEPT_DT) = 8
  AND A.ACCEPT_DT BETWEEN '&START_DT' AND '&END_DT'
GROUP BY SUBSTR(A.ACCEPT_DT, 1, 6)
ORDER BY YYYYMM
;

--------------------------------------------------------------------------------
-- P2. 접수경로별 분포 (라인어스 앱 / 전화 / 챗봇 등 채널 비중)
--------------------------------------------------------------------------------
SELECT NVL((SELECT Z.CODE_NAME FROM CRM_CODE_DETAIL Z
             WHERE Z.CODE_GROUP = 'AS' AND Z.P_CODE = 'CD02' AND Z.CODE = A.ACCEPT_ROUTE), '(미입력)') AS ACCEPT_ROUTE_NM
     , COUNT(*)                                            AS CASE_CNT
     , ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER (), 1)    AS RATIO_PCT
FROM CRM_AS_MGT A
WHERE NVL(A.DEL_YN, 'N') <> 'Y'
  AND A.ACCEPT_DT IS NOT NULL AND LENGTH(A.ACCEPT_DT) = 8
  AND A.ACCEPT_DT BETWEEN '&START_DT' AND '&END_DT'
GROUP BY A.ACCEPT_ROUTE
ORDER BY CASE_CNT DESC
;

--------------------------------------------------------------------------------
-- P3. 기존 분류코드 입력률 점검 (NULL/미입력 비율)
--     → 기존 분류체계가 분석에 쓸만한지 판단하는 근거
--------------------------------------------------------------------------------
SELECT COUNT(*)                                                         AS TOTAL_CNT
     , ROUND(SUM(CASE WHEN A.REQUEST_TYPE IS NULL THEN 1 ELSE 0 END) * 100 / COUNT(*), 1) AS REQUEST_TYPE_NULL_PCT
     , ROUND(SUM(CASE WHEN A.SERVICE_CATE IS NULL THEN 1 ELSE 0 END) * 100 / COUNT(*), 1) AS SERVICE_CATE_NULL_PCT
     , ROUND(SUM(CASE WHEN A.INQUIRY_TYPE IS NULL THEN 1 ELSE 0 END) * 100 / COUNT(*), 1) AS INQUIRY_TYPE_NULL_PCT
     , ROUND(SUM(CASE WHEN A.CAUSE_TYPE   IS NULL THEN 1 ELSE 0 END) * 100 / COUNT(*), 1) AS CAUSE_TYPE_NULL_PCT
     , ROUND(SUM(CASE WHEN A.ACTION_TYPE  IS NULL THEN 1 ELSE 0 END) * 100 / COUNT(*), 1) AS ACTION_TYPE_NULL_PCT
     , ROUND(SUM(CASE WHEN A.INPORTANCE   IS NULL THEN 1 ELSE 0 END) * 100 / COUNT(*), 1) AS INPORTANCE_NULL_PCT
FROM CRM_AS_MGT A
WHERE NVL(A.DEL_YN, 'N') <> 'Y'
  AND A.ACCEPT_DT IS NOT NULL AND LENGTH(A.ACCEPT_DT) = 8
  AND A.ACCEPT_DT BETWEEN '&START_DT' AND '&END_DT'
;

--------------------------------------------------------------------------------
-- P4. 문의유형(REQUEST_TYPE) 분포 - '기타' 쏠림 여부 확인
--------------------------------------------------------------------------------
SELECT NVL((SELECT Z.CODE_NAME FROM CRM_CODE_DETAIL Z
             WHERE Z.CODE_GROUP = 'AS' AND Z.P_CODE = 'CD07' AND Z.CODE = A.REQUEST_TYPE), '(미입력)') AS REQUEST_TYPE_NM
     , COUNT(*)                                            AS CASE_CNT
     , ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER (), 1)    AS RATIO_PCT
FROM CRM_AS_MGT A
WHERE NVL(A.DEL_YN, 'N') <> 'Y'
  AND A.ACCEPT_DT IS NOT NULL AND LENGTH(A.ACCEPT_DT) = 8
  AND A.ACCEPT_DT BETWEEN '&START_DT' AND '&END_DT'
GROUP BY A.REQUEST_TYPE
ORDER BY CASE_CNT DESC
;

--------------------------------------------------------------------------------
-- P5. 시스템(대분류)별 분포
--------------------------------------------------------------------------------
SELECT NVL((SELECT Z.CODE_NAME FROM CRM_CODE_DETAIL Z
             WHERE Z.CODE_GROUP = 'AS' AND Z.P_CODE = 'CD03' AND Z.CODE = A.SERVICE_CATE), '(미입력)') AS SERVICE_CATE_NM
     , COUNT(*)                                            AS CASE_CNT
     , ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER (), 1)    AS RATIO_PCT
FROM CRM_AS_MGT A
WHERE NVL(A.DEL_YN, 'N') <> 'Y'
  AND A.ACCEPT_DT IS NOT NULL AND LENGTH(A.ACCEPT_DT) = 8
  AND A.ACCEPT_DT BETWEEN '&START_DT' AND '&END_DT'
GROUP BY A.SERVICE_CATE
ORDER BY CASE_CNT DESC
;

--------------------------------------------------------------------------------
-- P6. 처리상태 분포 (미처리 적체 확인)
--------------------------------------------------------------------------------
SELECT NVL((SELECT Z.CODE_NAME FROM CRM_CODE_DETAIL Z
             WHERE Z.CODE_GROUP = 'AS' AND Z.P_CODE = 'CD01' AND Z.CODE = A.PROC_STATUS), '(미입력)') AS PROC_STATUS_NM
     , COUNT(*)                                            AS CASE_CNT
     , ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER (), 1)    AS RATIO_PCT
FROM CRM_AS_MGT A
WHERE NVL(A.DEL_YN, 'N') <> 'Y'
  AND A.ACCEPT_DT IS NOT NULL AND LENGTH(A.ACCEPT_DT) = 8
  AND A.ACCEPT_DT BETWEEN '&START_DT' AND '&END_DT'
GROUP BY A.PROC_STATUS
ORDER BY CASE_CNT DESC
;

--------------------------------------------------------------------------------
-- P7. 첫 상담원 답변까지 소요시간(시간 단위) - 월별 평균/중앙값
--------------------------------------------------------------------------------
SELECT SUBSTR(T.ACCEPT_DT, 1, 6)                              AS YYYYMM
     , COUNT(*)                                               AS ANSWERED_CNT
     , ROUND(AVG(T.FIRST_ANSWER_HOURS), 1)                    AS AVG_HOURS
     , ROUND(MEDIAN(T.FIRST_ANSWER_HOURS), 1)                 AS MEDIAN_HOURS
FROM (
        SELECT A.AS_NO
             , A.ACCEPT_DT
             , (SELECT (MIN(W.W_DATE) - A.REG_DATE) * 24
                  FROM CRM_AS_MGT_ANSWER W
                 WHERE W.AS_NO = A.AS_NO AND W.W_GUBUN = 'A') AS FIRST_ANSWER_HOURS
          FROM CRM_AS_MGT A
         WHERE NVL(A.DEL_YN, 'N') <> 'Y'
           AND A.ACCEPT_DT IS NOT NULL AND LENGTH(A.ACCEPT_DT) = 8
           AND A.ACCEPT_DT BETWEEN '&START_DT' AND '&END_DT'
     ) T
WHERE T.FIRST_ANSWER_HOURS IS NOT NULL
GROUP BY SUBSTR(T.ACCEPT_DT, 1, 6)
ORDER BY YYYYMM
;

--------------------------------------------------------------------------------
-- P8. 무응답(상담원 스레드 답변 0건) 비율
--     ※ 스레드 답변이 없어도 조치내용(ACTION_CONTENT)으로 처리됐을 수 있으므로
--       조치내용 유무를 나눠서 본다
--------------------------------------------------------------------------------
SELECT CASE WHEN T.MSG_AGENT_CNT > 0 THEN '1.스레드 답변 있음'
            WHEN T.ACTION_CONTENT IS NOT NULL THEN '2.스레드 답변 없음/조치내용 있음'
            ELSE '3.스레드 답변·조치내용 모두 없음' END       AS ANSWER_STATUS
     , COUNT(*)                                               AS CASE_CNT
     , ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER (), 1)       AS RATIO_PCT
FROM (
        SELECT A.AS_NO
             , A.ACTION_CONTENT
             , (SELECT COUNT(*) FROM CRM_AS_MGT_ANSWER W
                 WHERE W.AS_NO = A.AS_NO AND W.W_GUBUN = 'A') AS MSG_AGENT_CNT
          FROM CRM_AS_MGT A
         WHERE NVL(A.DEL_YN, 'N') <> 'Y'
           AND A.ACCEPT_DT IS NOT NULL AND LENGTH(A.ACCEPT_DT) = 8
           AND A.ACCEPT_DT BETWEEN '&START_DT' AND '&END_DT'
     ) T
GROUP BY CASE WHEN T.MSG_AGENT_CNT > 0 THEN '1.스레드 답변 있음'
              WHEN T.ACTION_CONTENT IS NOT NULL THEN '2.스레드 답변 없음/조치내용 있음'
              ELSE '3.스레드 답변·조치내용 모두 없음' END
ORDER BY ANSWER_STATUS
;

--------------------------------------------------------------------------------
-- P9. 접수 전환율 - 파생(자식) 접수가 생긴 건의 비율
--     "N건으로 접수했습니다"형 대응이 얼마나 되는지의 1차 근사치
--------------------------------------------------------------------------------
SELECT CASE WHEN T.CHILD_CNT > 0 THEN '파생 접수 있음' ELSE '파생 접수 없음' END AS LINK_STATUS
     , COUNT(*)                                               AS CASE_CNT
     , ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER (), 1)       AS RATIO_PCT
FROM (
        SELECT A.AS_NO
             , (SELECT COUNT(*) FROM CRM_AS_MGT Z
                 WHERE Z.CN_AS_NO = A.AS_NO AND NVL(Z.DEL_YN, 'N') <> 'Y') AS CHILD_CNT
          FROM CRM_AS_MGT A
         WHERE NVL(A.DEL_YN, 'N') <> 'Y'
           AND A.ACCEPT_DT IS NOT NULL AND LENGTH(A.ACCEPT_DT) = 8
           AND A.ACCEPT_DT BETWEEN '&START_DT' AND '&END_DT'
     ) T
GROUP BY CASE WHEN T.CHILD_CNT > 0 THEN '파생 접수 있음' ELSE '파생 접수 없음' END
;

--------------------------------------------------------------------------------
-- P10. 고객 별점 분포 및 문의유형별 평균 별점 (만족도 병목 탐색)
--------------------------------------------------------------------------------
SELECT NVL((SELECT Z.CODE_NAME FROM CRM_CODE_DETAIL Z
             WHERE Z.CODE_GROUP = 'AS' AND Z.P_CODE = 'CD07' AND Z.CODE = A.REQUEST_TYPE), '(미입력)') AS REQUEST_TYPE_NM
     , COUNT(*)                                               AS RATED_CNT
     , ROUND(AVG(TO_NUMBER(A.STAR_STATE)), 2)                 AS AVG_STAR
FROM CRM_AS_MGT A
WHERE NVL(A.DEL_YN, 'N') <> 'Y'
  AND A.ACCEPT_DT IS NOT NULL AND LENGTH(A.ACCEPT_DT) = 8
  AND A.ACCEPT_DT BETWEEN '&START_DT' AND '&END_DT'
  AND A.STAR_STATE IS NOT NULL
GROUP BY A.REQUEST_TYPE
ORDER BY RATED_CNT DESC
;
