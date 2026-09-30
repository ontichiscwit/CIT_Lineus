--------------------------------------------------------------------------------
-- [AX Lab] 라인어스 문의/답변 분석 - ③ 연결 건 추출 (2026-07-30)
--
-- 목적 : "N건으로 접수했습니다"형 답변의 실제 처리 내용을 복원하기 위해
--        접수 건 간 연결 관계(부모→자식)와 연결 건의 질문/조치내용을 추출
--        - CN_AS_NO   : 자식 건이 갖고 있는 부모(원) 접수번호
--        - AS_NO_LINK : 건에 직접 연결된 접수번호
-- 실행 : 조회 전용. CSV(UTF-8)로 내보내기 → linked_cases.csv 로 저장
-- 주의 : 부모 건이 분석 기간 안에 있으면 자식 건은 기간 밖이어도 포함되도록
--        기간 조건을 "부모 건" 기준으로만 건다.
-- 기간 : 00_params.sql 에서 정의한다. 01번과 자동으로 동일해지므로 여기서 고치지 말 것.
--------------------------------------------------------------------------------
@@00_params.sql

SELECT
    L.PARENT_AS_NO                                                 /* 원 접수번호(질문 건) */
  , L.LINK_TYPE                                                    /* 연결 유형 */
  , L.LINKED_AS_NO                                                 /* 연결된 접수번호(처리 건) */
  , C.ACCEPT_DT                                    AS LINKED_ACCEPT_DT
  , C.COMPLETE_DT                                  AS LINKED_COMPLETE_DT
  , C.PROC_STATUS                                  AS LINKED_PROC_STATUS
  , (SELECT Z.CODE_NAME FROM CRM_CODE_DETAIL Z
      WHERE Z.CODE_GROUP = 'AS' AND Z.P_CODE = 'CD01' AND Z.CODE = C.PROC_STATUS)
                                                   AS LINKED_PROC_STATUS_NM
  , (SELECT Z.CODE_NAME FROM CRM_CODE_DETAIL Z
      WHERE Z.CODE_GROUP = 'AS' AND Z.P_CODE = 'CD07' AND Z.CODE = C.REQUEST_TYPE)
                                                   AS LINKED_REQUEST_TYPE_NM
  , (SELECT Z.CODE_NAME FROM CRM_CODE_DETAIL Z
      WHERE Z.CODE_GROUP = 'AS' AND Z.P_CODE = 'CD06' AND Z.CODE = C.ACTION_TYPE)
                                                   AS LINKED_ACTION_TYPE_NM
  , C.CALL_CONTENT                                 AS LINKED_CALL_CONTENT   /* 연결 건 요청내용 */
  , C.ACTION_CONTENT                               AS LINKED_ACTION_CONTENT /* 연결 건 조치내용 */
FROM (
        /* 자식 건 → 부모 건 (연관접수) */
        SELECT X.CN_AS_NO AS PARENT_AS_NO
             , X.AS_NO    AS LINKED_AS_NO
             , 'CN_AS_NO' AS LINK_TYPE
          FROM CRM_AS_MGT X
         WHERE X.CN_AS_NO IS NOT NULL
           AND NVL(X.DEL_YN, 'N') <> 'Y'
        UNION
        /* 건에 직접 걸린 연결 접수번호 */
        SELECT X.AS_NO      AS PARENT_AS_NO
             , X.AS_NO_LINK AS LINKED_AS_NO
             , 'AS_NO_LINK' AS LINK_TYPE
          FROM CRM_AS_MGT X
         WHERE X.AS_NO_LINK IS NOT NULL
           AND NVL(X.DEL_YN, 'N') <> 'Y'
     ) L
   , CRM_AS_MGT C
   , CRM_AS_MGT P
WHERE C.AS_NO = L.LINKED_AS_NO
  AND NVL(C.DEL_YN, 'N') <> 'Y'
  AND P.AS_NO = L.PARENT_AS_NO
  AND NVL(P.DEL_YN, 'N') <> 'Y'
  /* ▼ 부모(질문) 건 기준 분석 기간 : 값은 00_params.sql 에서만 수정할 것
     ※ 자식 건(C)에는 기간·ACCEPT_DT 가드를 걸지 않는다. 자식은 기간 밖이거나
        ACCEPT_DT 가 비어 있어도 처리 내용 복원에 필요하므로 그대로 포함한다. */
  AND P.ACCEPT_DT IS NOT NULL
  AND LENGTH(P.ACCEPT_DT) = 8
  AND P.ACCEPT_DT BETWEEN '&START_DT' AND '&END_DT'
ORDER BY L.PARENT_AS_NO, L.LINKED_AS_NO
;
