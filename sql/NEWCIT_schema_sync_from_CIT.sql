--------------------------------------------------------------------------------
-- [AX Lab] NEWCIT 스키마 동기화 스크립트 (원본 CIT 기준)  작성: 2026-07-29 AX Lab
--------------------------------------------------------------------------------
-- 목적 : NEWCIT(복제본)이 구버전 CIT 스키마로 만들어져, 현재 앱이 요구하는 컬럼/뷰가
--        일부 없어 A/S 목록 조회 시 ORA-00904(부적절한 식별자)로 항상 0건이 되는 문제 해결.
--        (데이터는 26만건 정상 존재. 스키마 컬럼만 누락된 상태였음.)
--
-- 원본(소스)  : 192.168.16.212:1521  SID=CIT      (운영, 284,620건)  ← 컬럼/뷰 보유
-- 대상(타깃)  : 192.168.16.212:1521  SERVICE=NEWCIT (복제, 262,615건) ← 아래 객체 누락
-- 접속 계정   : lineus (비밀번호는 별도 관리)
--
-- ★ 반드시 NEWCIT 에만 실행할 것. 운영 CIT 에는 실행하지 말 것. ★
--
-- 안전성 : 아래 ALTER 는 모두 "NULL 허용 + DEFAULT 없음" 컬럼 추가라 기존 데이터 손실이 없고,
--          Oracle 에서 메타데이터 변경만 일어나 즉시 완료됩니다(테이블 재작성 없음).
--
-- 전체 스키마 diff 결과(CIT 144테이블 vs NEWCIT 139테이블):
--   - 컬럼 누락 : CRM_AS_MGT 13개 + CRM_EMP_MGT 1개 = 총 14개 (그 외 테이블은 컬럼 누락 없음)
--   - 뷰 누락   : VW_AS_MGT, VW_AS_REPORT, VW_CUST_ADDON_REPORT (리포트/통계 화면용)
--   - 앱과 무관하여 제외 : AS_TEMP(임시), CRM_AS_MGT_251015(2025-10-15 백업본)
--------------------------------------------------------------------------------

--==============================================================================
-- 1) CRM_AS_MGT : 누락 컬럼 13개 추가  (A/S 목록/상세 화면 필수)
--==============================================================================
ALTER TABLE CRM_AS_MGT ADD (
    AS_NO_LINK        VARCHAR2(4000 BYTE),   -- 하위작업 연결 AS_NO 목록(콤마구분)
    TEL_CONFIRM       CHAR(1 BYTE),          -- 전화확인 완료 여부
    TEL_ABSENCE       CHAR(1 BYTE),          -- 전화 부재중 여부
    TEL_ABSENCE_CNT   NUMBER(3),             -- 전화 부재중 횟수
    CHATBOT_ID        NUMBER,                -- 챗봇 상담내역 ID
    PROC_GUBUN        VARCHAR2(100 BYTE),    -- 처리구분(코드 CD09)
    PROC_BUILD_INFO   VARCHAR2(1000 BYTE),   -- 빌드순번
    PROC_TEST_INFO    VARCHAR2(1000 BYTE),   -- 개발처리서(테스트케이스)
    PROC_PROCESS_SP   VARCHAR2(300 BYTE),    -- 프로세스정의서
    PROC_SCREEN_SP    VARCHAR2(300 BYTE),    -- 화면정의서
    PROC_TABLE_SP     VARCHAR2(300 BYTE),    -- 테이블정의서
    PROC_FUNCTION_SP  VARCHAR2(300 BYTE),    -- 기능분해도
    PROC_INTERFACE_SP VARCHAR2(300 BYTE)     -- 인터페이스정의서
);

--==============================================================================
-- 2) CRM_EMP_MGT : 누락 컬럼 1개 추가  (담당자 부서명)
--==============================================================================
ALTER TABLE CRM_EMP_MGT ADD (
    DEPT_NM VARCHAR2(100 BYTE)               -- 부서명
);

COMMIT;

--==============================================================================
-- 3) 누락 뷰 3개 생성 (리포트/통계 화면용) — 컬럼 추가 이후 실행되어야 함
--    (VW_AS_MGT 는 위에서 추가한 CHATBOT_ID 컬럼을 참조함)
--==============================================================================
CREATE OR REPLACE VIEW VW_AS_MGT AS
SELECT AS_NO, CHATBOT_ID, REG_DATE
  FROM CRM_AS_MGT
 WHERE 1=1
   AND DEL_YN IS NULL
 ORDER BY AS_NO DESC;

CREATE OR REPLACE VIEW VW_AS_REPORT AS
SELECT COALESCE(SUBSTR(A.ACCEPT_DT, 1, 6), '') AS YYYYMM,
       B.CRM_CODE AS HOS_CODE,
       B.CUST_KOR_NAME,
       A.CAUSE_TYPE AS CAUSE_TYPE_CODE,
       (SELECT CODE_NAME FROM CRM_CODE_DETAIL WHERE 1=1 AND CODE_GROUP = 'AS' AND P_CODE = 'CD05' AND CODE = A.CAUSE_TYPE) CAUSE_TYPE_NAME,
       A.PROC_STATUS AS PROC_STATUS_CODE,
       (SELECT CODE_NAME FROM CRM_CODE_DETAIL WHERE 1=1 AND CODE_GROUP = 'AS' AND P_CODE = 'CD01' AND CODE = A.PROC_STATUS) PROC_STATUS_NAME,
       COUNT(*) AS AS_COUNT
  FROM CRM_AS_MGT A
  LEFT OUTER JOIN CRM_CUST_MGT B
    ON A.CUST_CODE = B.CRM_CODE
 WHERE 1=1
   AND A.DEL_YN IS NULL
   AND A.PROC_STATUS IN ('C001', 'C004','C005','C006')
 GROUP BY B.CRM_CODE, B.CUST_KOR_NAME, A.CAUSE_TYPE, SUBSTR(A.ACCEPT_DT, 1, 6), A.PROC_STATUS
 ORDER BY SUBSTR(A.ACCEPT_DT, 1, 6) DESC, B.CRM_CODE, B.CUST_KOR_NAME, A.CAUSE_TYPE, A.PROC_STATUS;

CREATE OR REPLACE VIEW VW_CUST_ADDON_REPORT AS
SELECT T7.SEQ AS CUST_CD
     , T7.CRM_CODE AS HOS_CODE
     , T7.CUST_KOR_NAME AS CUST_KOR_NAME
     , T4.BASE_CD_NM AS ITEM_GRP1_NM
     , T3.ITEM_NM
     , T1.ISSUE_DT
     , SUM(T2.SUPP_WON_AMT) AS SUPP_WON_AMT
     , SUM(T2.VAT_WON_AMT) AS VAT_WON_AMT
     , SUM(T2.SUPP_WON_AMT) + SUM(T2.VAT_WON_AMT) AS TOTAL_AMT
  FROM KYERP.TB_SD_TAX_BILL_MST T1
     , KYERP.TB_SD_TAX_BILL_DTL T2
     , KYERP.TB_CM_ITEM_MST     T3
     , KYERP.TB_CM_CODE_DTL     T4
     , KYERP.TB_SD_SALES_ORDER_MST T6
     , CRM_CUST_MGT T7
 WHERE 1=1
   AND T1.TAX_BILL_NUMB = T2.TAX_BILL_NUMB
   AND T3.ITEM_CD = T2.ITEM_CD
   AND T4.BASE_CD_GRP = 'CM0004'
   AND T4.LANG_CD = 'KO'
   AND T4.BASE_CD = T3.ITEM_GRP1
   AND T1.SALE_TYPE = '00001'
   AND T3.ITEM_GRP1 = '00002'
   AND T1.RECV_CUST_CD = T7.CUST_CODE
   AND T6.ORDER_NUMB = T2.ORDER_NUMB
   AND T6.ORDER_NUMB NOT IN ( 'DO201710310035','DO201802280014','DO201711300012','DO201711300014'
                            , 'DO201711300011','DO201711300013','DO201710310034','DO201802280016'
                            , 'DO201805020108','DO201802280015' )
 GROUP BY T7.SEQ, T7.CRM_CODE, T7.CUST_KOR_NAME, T1.ISSUE_DT, T4.BASE_CD_NM, T2.ITEM_CD, T3.ITEM_NM
 ORDER BY T7.SEQ, T1.ISSUE_DT DESC;

--==============================================================================
-- 4) 검증 (실행 후 확인)
--==============================================================================
-- (a) 컬럼 14개가 모두 생겼는지
-- SELECT TABLE_NAME, COLUMN_NAME FROM USER_TAB_COLUMNS
--  WHERE (TABLE_NAME='CRM_AS_MGT' AND COLUMN_NAME IN
--         ('AS_NO_LINK','TEL_CONFIRM','TEL_ABSENCE','TEL_ABSENCE_CNT','CHATBOT_ID','PROC_GUBUN',
--          'PROC_BUILD_INFO','PROC_TEST_INFO','PROC_PROCESS_SP','PROC_SCREEN_SP','PROC_TABLE_SP',
--          'PROC_FUNCTION_SP','PROC_INTERFACE_SP'))
--     OR (TABLE_NAME='CRM_EMP_MGT' AND COLUMN_NAME='DEPT_NM')
--  ORDER BY TABLE_NAME, COLUMN_NAME;
--
-- (b) A/S 목록 카운트가 정상 반환되는지 (전체 + 2020~2026 → 약 16만건 기대)
-- SELECT COUNT(*) FROM CRM_AS_MGT A INNER JOIN CRM_CUST_MGT B ON A.CUST_CODE=B.CRM_CODE
--  WHERE A.DEL_YN IS NULL AND A.ACCEPT_DT BETWEEN '20200101' AND '20260728';

--==============================================================================
-- 5) 롤백(원복) — 필요 시에만
--==============================================================================
-- ALTER TABLE CRM_AS_MGT DROP (AS_NO_LINK, TEL_CONFIRM, TEL_ABSENCE, TEL_ABSENCE_CNT, CHATBOT_ID,
--     PROC_GUBUN, PROC_BUILD_INFO, PROC_TEST_INFO, PROC_PROCESS_SP, PROC_SCREEN_SP,
--     PROC_TABLE_SP, PROC_FUNCTION_SP, PROC_INTERFACE_SP);
-- ALTER TABLE CRM_EMP_MGT DROP (DEPT_NM);
-- DROP VIEW VW_AS_MGT; DROP VIEW VW_AS_REPORT; DROP VIEW VW_CUST_ADDON_REPORT;
--------------------------------------------------------------------------------
