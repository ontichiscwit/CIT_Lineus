--------------------------------------------------------------------------------
-- [AX Lab] 라인어스 문의/답변 분석 - ① 접수 건 마스터 추출 (2026-07-30)
--
-- 목적 : 접수 건(질문) 1건 = 1행인 분석용 마스터 데이터셋 추출
-- 대상 : CRM_AS_MGT (삭제 건 제외)
-- 실행 : 조회 전용. SQL Developer 등에서 실행 후 CSV(UTF-8)로 내보내기
--        → 파일명 cases.csv 로 저장 (analysis/build_dataset.py 입력)
-- 주의 : 개인정보 최소화를 위해 신청자 이름/연락처(APPLY_NM, APPLY_TEL 등)는
--        의도적으로 제외했음. 거래처명(회사명)만 포함.
-- 기간 : 하단 WHERE 절의 기간은 00_params.sql 에서 정의한다. 이 파일에서 고치지 말 것.
--------------------------------------------------------------------------------
@@00_params.sql

SELECT
    A.AS_NO                                                                          /* 접수번호 */
  , A.CN_AS_NO                                                                       /* 연관(부모) 접수번호 */
  , A.AS_NO_LINK                                                                     /* 연결된 접수번호 */
  , A.ACCEPT_DT                                                                      /* 접수일자 YYYYMMDD */
  , A.ACCEPT_TIME                                                                    /* 접수시간 */
  , TO_CHAR(A.REG_DATE, 'YYYY-MM-DD HH24:MI:SS')                    AS REG_DATE      /* 등록시각(타임스탬프) */
  , A.COMPLETE_DT                                                                    /* 처리완료일자 */
  , A.ACCEPT_ROUTE
  , (SELECT Z.CODE_NAME FROM CRM_CODE_DETAIL Z
      WHERE Z.CODE_GROUP = 'AS' AND Z.P_CODE = 'CD02' AND Z.CODE = A.ACCEPT_ROUTE)
                                                                    AS ACCEPT_ROUTE_NM /* 접수경로 */
  , A.REQUEST_TYPE
  , (SELECT Z.CODE_NAME FROM CRM_CODE_DETAIL Z
      WHERE Z.CODE_GROUP = 'AS' AND Z.P_CODE = 'CD07' AND Z.CODE = A.REQUEST_TYPE)
                                                                    AS REQUEST_TYPE_NM /* 문의유형 */
  , A.SERVICE_CATE
  , (SELECT Z.CODE_NAME FROM CRM_CODE_DETAIL Z
      WHERE Z.CODE_GROUP = 'AS' AND Z.P_CODE = 'CD03' AND Z.CODE = A.SERVICE_CATE)
                                                                    AS SERVICE_CATE_NM /* 시스템(대) */
  , A.INQUIRY_TYPE
  , (SELECT Z.CODE_NAME FROM CRM_CODE_DETAIL Z
      WHERE Z.CODE_GROUP = 'AS' AND Z.P_CODE = A.SERVICE_CATE AND Z.CODE = A.INQUIRY_TYPE)
                                                                    AS INQUIRY_TYPE_NM /* 시스템(소) */
  , A.CAUSE_TYPE
  , (SELECT Z.CODE_NAME FROM CRM_CODE_DETAIL Z
      WHERE Z.CODE_GROUP = 'AS' AND Z.P_CODE = 'CD05' AND Z.CODE = A.CAUSE_TYPE)
                                                                    AS CAUSE_TYPE_NM /* 원인유형 */
  , A.ACTION_TYPE
  , (SELECT Z.CODE_NAME FROM CRM_CODE_DETAIL Z
      WHERE Z.CODE_GROUP = 'AS' AND Z.P_CODE = 'CD06' AND Z.CODE = A.ACTION_TYPE)
                                                                    AS ACTION_TYPE_NM /* 조치유형 */
  , A.INPORTANCE
  , (SELECT Z.CODE_NAME FROM CRM_CODE_DETAIL Z
      WHERE Z.CODE_GROUP = 'AS' AND Z.P_CODE = 'CD04' AND Z.CODE = A.INPORTANCE)
                                                                    AS INPORTANCE_NM /* 중요도 */
  , A.PROC_STATUS
  , (SELECT Z.CODE_NAME FROM CRM_CODE_DETAIL Z
      WHERE Z.CODE_GROUP = 'AS' AND Z.P_CODE = 'CD01' AND Z.CODE = A.PROC_STATUS)
                                                                    AS PROC_STATUS_NM /* 처리상태 */
  , A.PROC_GUBUN
  , (SELECT Z.CODE_NAME FROM CRM_CODE_DETAIL Z
      WHERE Z.CODE_GROUP = 'AS' AND Z.P_CODE = 'CD09' AND Z.CODE = A.PROC_GUBUN)
                                                                    AS PROC_GUBUN_NM /* 처리구분 */
  , A.CUST_CODE
  , (SELECT C.CUST_KOR_NAME FROM CRM_CUST_MGT C WHERE C.CRM_CODE = A.CUST_CODE)
                                                                    AS CUST_NM       /* 거래처명 */
  , A.CALL_CONTENT                                                                   /* 질문(요청내용) 본문 */
  , A.ACTION_CONTENT                                                                 /* 조치처리의견(최종) */
  , A.STAR_STATE                                                                     /* 고객평가 별점 */
  , A.STAR_CONTENT                                                                   /* 고객평가 의견 */
  , A.CHATBOT_ID                                                                     /* 챗봇상담 연계 ID */
  /* ---------- 스레드 지표 (행별 서브쿼리 대신 집계 조인: 성능) ---------- */
  , NVL(W.MSG_TOTAL_CNT, 0)                                         AS MSG_TOTAL_CNT /* 스레드 메시지 수 */
  , NVL(W.MSG_CUST_CNT, 0)                                          AS MSG_CUST_CNT  /* 고객 메시지 수 */
  , NVL(W.MSG_AGENT_CNT, 0)                                         AS MSG_AGENT_CNT /* 상담원 메시지 수 */
  , TO_CHAR(W.FIRST_AGENT_DATE, 'YYYY-MM-DD HH24:MI:SS')            AS FIRST_AGENT_ANSWER_DT /* 첫 상담원 답변시각 */
  , ROUND((W.FIRST_AGENT_DATE - A.REG_DATE) * 24, 1)                AS FIRST_ANSWER_HOURS /* 접수→첫답변 시간(h) */
  /* ---------- 연결 건 지표 ---------- */
  , NVL(CH.CHILD_CASE_CNT, 0)                                       AS CHILD_CASE_CNT /* 이 건에서 파생된 접수 수 */
FROM CRM_AS_MGT A
   /* 스레드 집계: CRM_AS_MGT_ANSWER 를 한 번만 읽음 */
   LEFT JOIN (
        SELECT AS_NO
             , COUNT(*)                                        AS MSG_TOTAL_CNT
             , SUM(CASE WHEN W_GUBUN = 'U' THEN 1 ELSE 0 END)  AS MSG_CUST_CNT
             , SUM(CASE WHEN W_GUBUN = 'A' THEN 1 ELSE 0 END)  AS MSG_AGENT_CNT
             , MIN(CASE WHEN W_GUBUN = 'A' THEN W_DATE END)    AS FIRST_AGENT_DATE
          FROM CRM_AS_MGT_ANSWER
         GROUP BY AS_NO
   ) W ON W.AS_NO = A.AS_NO
   /* 파생 건 집계: CRM_AS_MGT 를 한 번만 읽음 (CN_AS_NO 인덱스 없어도 1회 스캔) */
   LEFT JOIN (
        SELECT CN_AS_NO
             , COUNT(*) AS CHILD_CASE_CNT
          FROM CRM_AS_MGT
         WHERE CN_AS_NO IS NOT NULL
           AND NVL(DEL_YN, 'N') <> 'Y'
         GROUP BY CN_AS_NO
   ) CH ON CH.CN_AS_NO = A.AS_NO
WHERE NVL(A.DEL_YN, 'N') <> 'Y'
  /* ▼ 분석 대상 기간 : 값은 00_params.sql 에서만 수정할 것 */
  /* ACCEPT_DT 는 VARCHAR2 이고 NULL·비정상 길이 값이 섞여 있다.
     (운영 쿼리 egov-stat-query.xml / egov-main-query.xml 도 동일 가드를 사용)
     문자열 BETWEEN 비교 전에 8자리 여부를 반드시 확인한다.
     이 가드로 제외되는 건수는 05_profiling.sql 의 P0 으로 확인할 것. */
  AND A.ACCEPT_DT IS NOT NULL
  AND LENGTH(A.ACCEPT_DT) = 8
  AND A.ACCEPT_DT BETWEEN '&START_DT' AND '&END_DT'
ORDER BY A.AS_NO
;
