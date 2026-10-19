--------------------------------------------------------------------------------
-- [AX Lab] 라인어스 문의/답변 분석 - ④ 처리이력 추출 (2026-07-30)
--
-- 목적 : 접수 건별 처리이력(상태 변화 + 작업처리의견)을 추출
--        상담원 스레드 답변 외에 "실제로 어떤 조치를 했는지"가
--        CRM_AS_MGT_HIST.ACTION_CONTENT 에 남는 경우가 많으므로 함께 수집
-- 실행 : 조회 전용. CSV(UTF-8)로 내보내기 → hist.csv 로 저장
-- 기간 : 00_params.sql 에서 정의한다. 01번과 자동으로 동일해지므로 여기서 고치지 말 것.
--------------------------------------------------------------------------------
@@00_params.sql

SELECT
    H.AS_NO                                                        /* 접수번호 */
  , H.SEQ                                                          /* 이력 순번 */
  , TO_CHAR(H.REG_DATE, 'YYYY-MM-DD HH24:MI:SS')   AS REG_DATE     /* 이력 등록시각 */
  , H.PROC_DT                                                      /* 처리일자 */
  , H.PROC_STATUS
  , (SELECT Z.CODE_NAME FROM CRM_CODE_DETAIL Z
      WHERE Z.CODE_GROUP = 'AS' AND Z.P_CODE = 'CD01' AND Z.CODE = H.PROC_STATUS)
                                                   AS PROC_STATUS_NM /* 처리상태 */
  , H.ACTION_CONTENT                                               /* 작업처리의견 */
FROM CRM_AS_MGT_HIST H
   , CRM_AS_MGT A
WHERE H.AS_NO = A.AS_NO
  AND NVL(A.DEL_YN, 'N') <> 'Y'
  /* ▼ 분석 대상 기간 : 값은 00_params.sql 에서만 수정할 것 (01번과 동일 조건 유지) */
  AND A.ACCEPT_DT IS NOT NULL
  AND LENGTH(A.ACCEPT_DT) = 8
  AND A.ACCEPT_DT BETWEEN '&START_DT' AND '&END_DT'
ORDER BY H.AS_NO, H.SEQ
;
