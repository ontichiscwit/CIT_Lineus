<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
  [AX Lab] 신규 파일 (2026-07-30): AS 통합화면 모달 5종 마크업
  ─────────────────────────────────────────────────────────────────────────────
  list.jsp 에서 <jsp:include> 로 불러 쓴다. 반드시 #asWorkspace "안쪽"에 include 해야 한다.
  (combine-as-thread.css 의 모든 셀렉터가 #asWorkspace 하위로 스코핑되어 있고, CSS 변수도 거기서 상속받는다)

  ★ 입력요소에 name 속성을 주지 않는 이유
    #asWorkspace 는 <form name="listFrm"> 안에 있다. name 을 주면 목록조회
    (listFrm.serialize() → getAsList.do) 파라미터에 모달 값이 섞여 들어가 검색결과가 바뀐다.
    그래서 여기서는 id 만 부여하고, 서버 전송 데이터는 combine-as-thread.js 에서 객체로 조립한다.

  ★ 위치는 position:fixed 이므로 폼 안에 있어도 화면 중앙에 정상 표시된다.
  ★ 표시/숨김은 style.display 를 JS(caws_openModal / caws_closeModal)가 직접 제어한다.
    (열림 판정에 [style*="flex"] 셀렉터를 쓰므로 클래스 토글 방식으로 바꾸지 말 것)
--%>

<%-- 공통 딤 : 클릭하면 열려 있는 모달을 모두 닫는다 --%>
<div class="caws-dim" id="cawsDim" style="display:none;" onclick="caws_closeAll();"></div>

<%-- ============================================================
     4-1. 첨부 미리보기 라이트박스 (이미지 img / PDF iframe)
     서버 호출 없이 CRM_ATTACH_MGT.ATTACH_PATH(/upload/...) 를 직접 참조한다.
     정적 경로가 서비스되지 않는 환경에서는 JS 의 onerror 가 안내문으로 대체한다.
     ============================================================ --%>
<div class="caws-lb" id="cawsLb" style="display:none;">
  <div class="caws-mh">
    <h3>첨부 미리보기</h3>
    <span class="caws-msub" id="cawsLbNm"></span>
    <button type="button" class="caws-mx" onclick="caws_closeModal('cawsLb');" title="닫기 (ESC)">&times;</button>
  </div>
  <div class="caws-lbb" id="cawsLbBody"></div>
  <div class="caws-lbnav">
    <button type="button" class="btn-s" id="cawsLbPrev" onclick="caws_lbMove(-1);">&#9666; 이전</button>
    <button type="button" class="btn-s" id="cawsLbNext" onclick="caws_lbMove(1);">다음 &#9656;</button>
    <span class="caws-lbpos" id="cawsLbPos"></span>
    <div class="caws-sp"></div>
    <button type="button" class="btn-s primary" onclick="caws_lbDown();">다운로드</button>
  </div>
</div>

<%-- ============================================================
     4-2. AI 문장 다듬기 (★ 화면만 / 실제 호출은 caws_aiPolish 목업)
     ※ 상태변경 모달(cawsStatus)과 이관 모달(cawsTransfer)은 처리 탭으로 통합되어 제거됨.
        (2026-07-31 AX Lab)
     ============================================================ --%>
<div class="caws-modal wide" id="cawsAi" style="display:none;">
  <div class="caws-mh">
    <h3>AI 문장 다듬기</h3>
    <span class="caws-aibadge">시범 기능</span>
    <button type="button" class="caws-mx" onclick="caws_closeModal('cawsAi');" title="닫기 (ESC)">&times;</button>
  </div>
  <div class="caws-mb">
    <div class="caws-aitone">
      <button type="button" class="caws-pchip on" data-tone="polite" onclick="caws_aiTone('polite');">정중하게</button>
      <button type="button" class="caws-pchip" data-tone="brief"  onclick="caws_aiTone('brief');">간결하게</button>
      <button type="button" class="caws-pchip" data-tone="typo"   onclick="caws_aiTone('typo');">오탈자만</button>
      <div class="caws-sp"></div>
      <button type="button" class="btn-s primary" onclick="caws_aiRun();">문장 다듬기</button>
    </div>
    <div class="caws-fld">
      <label>원문 (작성 중인 내용)</label>
      <div class="caws-aiout" id="cawsAiSrc" style="background:var(--surface-1); border-color:var(--line);"></div>
    </div>
    <div class="caws-fld">
      <label>다듬은 결과</label>
      <div class="caws-aiout wait" id="cawsAiOut"></div>
    </div>
    <div class="caws-mnote">AI 연동 전이라 현재는 기본 문장 정리 규칙으로 예시 결과를 보여줍니다. 내용은 반드시 직접 확인 후 사용해주세요.</div>
  </div>
  <div class="caws-mf">
    <div class="caws-sp"></div>
    <button type="button" class="btn-s" onclick="caws_closeModal('cawsAi');">취소</button>
    <button type="button" class="btn-s primary" onclick="caws_aiApply();">이 문장으로 교체</button>
  </div>
</div>

<%-- ============================================================
     4-3. 게시물 링크 삽입
     본문에 '공지사항(12345)' 같은 토큰을 텍스트로 넣고, 타임라인 렌더 시 링크로 변환한다.
     존재확인 URL(/ad/board/getNotice*exist.do) 도 MenuAuthFilter 대상이라
     게시판 메뉴 권한이 없으면 403 이 난다. 그때는 검증만 건너뛰고 삽입은 허용한다.
     ============================================================ --%>
<div class="caws-modal" id="cawsLink" style="display:none;">
  <div class="caws-mh">
    <h3>게시물 링크 삽입</h3>
    <button type="button" class="caws-mx" onclick="caws_closeModal('cawsLink');" title="닫기 (ESC)">&times;</button>
  </div>
  <div class="caws-mb">
    <div class="caws-fld">
      <label>게시판 종류</label>
      <select id="cawsLnGbn"></select>
    </div>
    <div class="caws-fld">
      <label>게시물 번호<span class="caws-req">*</span></label>
      <div class="caws-frow">
        <input type="text" id="cawsLnNum" maxlength="10" placeholder="숫자만 입력" style="flex:1;"
               oninput="this.value=this.value.replace(/[^0-9]/g,'');" />
        <button type="button" class="btn-s" onclick="caws_checkLink();">존재 확인</button>
      </div>
      <div class="caws-mnote" id="cawsLnMsg"></div>
    </div>
    <div class="caws-mnote">본문에는 <b>공지사항(12345)</b> 형태의 텍스트로 삽입되고, 타임라인에서 클릭 가능한 링크로 표시됩니다.</div>
  </div>
  <div class="caws-mf">
    <div class="caws-sp"></div>
    <button type="button" class="btn-s" onclick="caws_closeModal('cawsLink');">취소</button>
    <button type="button" class="btn-s primary" onclick="caws_insertLink();">삽입</button>
  </div>
</div>
