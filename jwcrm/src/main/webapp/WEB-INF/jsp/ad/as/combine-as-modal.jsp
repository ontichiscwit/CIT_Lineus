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

<%-- [AX Lab] 수정 시작 (2026-10-19 AX Lab): 일반 이미지 첨부 전용 미리보기 뷰어로 범위 제한 --%>
<%-- ============================================================
     4-1. 첨부 미리보기 라이트박스 (일반 이미지 img)
     /comm/fileDown.do?inline=Y 로 이미지를 스트리밍하여 저장창 없이 표시한다.
     로컬 물리파일이 없으면 서버의 운영 첨부 폴백을 사용하고, 실패 시 JS 안내문으로 대체한다.
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
<%-- [AX Lab] 수정 끝 --%>

<%-- ============================================================
     4-2. AI 문장 다듬기
     ※ 상태변경 모달(cawsStatus)과 이관 모달(cawsTransfer)은 처리 탭으로 통합되어 제거됨.
        (2026-07-31 AX Lab)
     [AX Lab] 수정 (2026-10-19 AX Lab): 화면 목업 → 실제 AI 연동 (combine-as-thread.js 섹션 7 참고).
       - 배지(#cawsAiBadge)·안내문(#cawsAiNote)은 결과 출처(AI / 기본 규칙 폴백)에 따라 JS 가 바꿔 쓴다.
       - 실행 버튼(#cawsAiRunBtn)은 진행 중 비활성. 닫기는 caws_closeAi() — 진행 중 요청을 취소(응답 무시)한다.
       - 원문/결과 영역은 단어 단위 비교 결과(<del>/<ins>)를 그린다.
     ============================================================ --%>
<div class="caws-modal wide" id="cawsAi" style="display:none;">
  <div class="caws-mh">
    <h3>AI 문장 다듬기</h3>
    <span class="caws-aibadge" id="cawsAiBadge" style="display:none;"></span>
    <button type="button" class="caws-mx" onclick="caws_closeAi();" title="닫기 (ESC)">&times;</button>
  </div>
  <div class="caws-mb">
    <div class="caws-aitone">
      <button type="button" class="caws-pchip on" data-tone="polite" onclick="caws_aiTone('polite');" title="격식 있는 존댓말로 바꾸고, 없으면 인사말·맺음말을 넣습니다">정중하게</button>
      <button type="button" class="caws-pchip" data-tone="brief"  onclick="caws_aiTone('brief');" title="뜻과 절차·숫자는 그대로 두고 군더더기만 줄입니다">간결하게</button>
      <button type="button" class="caws-pchip" data-tone="typo"   onclick="caws_aiTone('typo');" title="맞춤법·띄어쓰기·오타·문장부호만 고칩니다 (문체 유지)">오탈자만</button>
      <div class="caws-sp"></div>
      <button type="button" class="btn-s primary" id="cawsAiRunBtn" onclick="caws_aiRun();">문장 다듬기</button>
    </div>
    <div class="caws-fld">
      <label>원문 (작성 중인 내용)</label>
      <div class="caws-aiout caws-aisrc" id="cawsAiSrc"></div>
    </div>
    <div class="caws-fld">
      <%-- [AX Lab] 수정 (2026-10-21 AX Lab): 결과 출처 문구(#cawsAiMeta — 예: AI(gemma4:26b)가 0.8초 만에 다듬은 결과입니다)를 제목 옆에 표시 --%>
      <label>다듬은 결과 <span class="caws-aimeta" id="cawsAiMeta"></span></label>
      <div class="caws-aiout wait" id="cawsAiOut"></div>
    </div>
    <div class="caws-mnote caws-ainote" id="cawsAiNote">AI가 다듬은 결과는 반드시 직접 확인 후 사용해주세요.</div>
  </div>
  <div class="caws-mf">
    <div class="caws-sp"></div>
    <button type="button" class="btn-s" onclick="caws_closeAi();">취소</button>
    <button type="button" class="btn-s primary" onclick="caws_aiApply();">이 문장으로 교체</button>
  </div>
</div>

<%-- ============================================================
     4-3. 게시물 링크 삽입
     본문에 '공지사항(12345)' 같은 토큰을 텍스트로 넣고, 타임라인 렌더 시 링크로 변환한다.
     게시물 목록은 권한 등록된 /ad/as/getAsInfo.do의 pageType 분기로 조회한다.
     ============================================================ --%>
<div class="caws-modal caws-link-modal" id="cawsLink" style="display:none;">
  <div class="caws-mh">
    <h3>게시물 링크 삽입</h3>
    <button type="button" class="caws-mx" onclick="caws_closeModal('cawsLink');" title="닫기 (ESC)">&times;</button>
  </div>
  <div class="caws-mb">
    <%-- [AX Lab] 수정 시작 (2026-10-17 AX Lab): 번호 직접입력/존재확인을 게시물 선택 목록으로 변경 --%>
    <div class="caws-fld">
      <label>게시판 종류</label>
      <select id="cawsLnGbn" onchange="caws_linkLoad(1);"></select>
    </div>
    <%-- [AX Lab] 수정 시작 (2026-10-17 AX Lab): 게시물번호/제목/내용/작성자 통합검색 --%>
    <div class="caws-link-search">
      <input type="text" id="cawsLnSearch" maxlength="100"
             placeholder="게시물번호, 제목, 내용, 작성자 검색"
             onkeydown="if(event.keyCode===13){caws_linkSearch();return false;}" />
      <button type="button" class="btn-s" onclick="caws_linkSearch();">검색</button>
      <button type="button" class="btn-s" onclick="caws_linkClearSearch();">초기화</button>
    </div>
    <%-- [AX Lab] 수정 끝 --%>
    <div class="caws-link-list" role="region" aria-label="게시물 목록" tabindex="0">
      <table>
        <colgroup>
          <col class="caws-link-no" />
          <col class="caws-link-date" />
          <col />
          <col class="caws-link-writer" />
        </colgroup>
        <thead>
          <tr>
            <th scope="col">게시물번호</th>
            <th scope="col">작성일</th>
            <th scope="col">제목</th>
            <th scope="col">작성자</th>
          </tr>
        </thead>
        <tbody id="cawsLnList">
          <tr><td colspan="4" class="caws-link-empty">게시물을 불러오는 중입니다.</td></tr>
        </tbody>
      </table>
    </div>
    <div class="caws-link-nav">
      <span class="caws-link-count" id="cawsLnCount"></span>
      <div class="caws-link-pages" id="cawsLnPages"></div>
    </div>
    <div class="caws-mnote" id="cawsLnMsg">목록에서 본문에 연결할 게시물을 선택해주세요.</div>
    <%-- [AX Lab] 수정 끝 --%>
  </div>
  <div class="caws-mf">
    <div class="caws-sp"></div>
    <button type="button" class="btn-s" onclick="caws_closeModal('cawsLink');">취소</button>
    <button type="button" class="btn-s primary" id="cawsLnInsert" onclick="caws_insertLink();" disabled="disabled">삽입</button>
  </div>
</div>

<%-- [AX Lab] 수정 시작 (2026-10-17 AX Lab): 게시물 본문 미리보기 팝업 --%>
<div class="caws-modal wide caws-link-preview" id="cawsLinkPreview" style="display:none;">
  <div class="caws-mh">
    <h3>게시물 미리보기</h3>
    <span class="caws-msub" id="cawsLnPvBoard"></span>
    <button type="button" class="caws-mx" onclick="caws_closeModal('cawsLinkPreview');" title="닫기 (ESC)">&times;</button>
  </div>
  <div class="caws-mb">
    <div class="caws-link-preview-meta">
      <span><b>게시물번호</b><em id="cawsLnPvNum">-</em></span>
      <span><b>작성일</b><em id="cawsLnPvDate">-</em></span>
      <span><b>작성자</b><em id="cawsLnPvWriter">-</em></span>
    </div>
    <div class="caws-link-preview-title" id="cawsLnPvTitle">게시물을 불러오는 중입니다.</div>
    <div class="caws-link-preview-content" id="cawsLnPvContent"></div>
  </div>
  <div class="caws-mf">
    <div class="caws-sp"></div>
    <button type="button" class="btn-s" onclick="caws_closeModal('cawsLinkPreview');">닫기</button>
    <button type="button" class="btn-s primary" id="cawsLnPvInsert" onclick="caws_linkPreviewInsert();" disabled="disabled">이 게시물 삽입</button>
  </div>
</div>
<%-- [AX Lab] 수정 끝 --%>

<%-- ============================================================
     4-4. 접수 등록 모달 (신규작업 / 복사 / 하위작업) — combine-as-form.js (cafm_*)
     [AX Lab] 추가 (2026-07-31 AX Lab)
     기존에는 목록 상단 [신규작업]/[복사]/[하위작업] 버튼이 전체 상세페이지(/ad/as/form.do)로
     이동했지만, 이제 이 모달에서 페이지 이동 없이 바로 등록한다.
     저장은 원본 화면과 동일한 기존 URL /ad/as/proc.do (pageType=insert/subInsert) 를
     재사용하므로 서버 수정·신규 메뉴권한 등록이 필요 없다.
     ★ 여기 입력요소에도 name 을 주지 않는다(listFrm 오염 방지 — 파일 상단 주석 참고).
       서버 전송용 hidden 과 첨부파일 input 은 combine-as-form.js 가 body 직속의
       별도 폼(#cafmForm, multipart)에 만들어 숨은 iframe 으로 제출한다.
     ★ 텍스트 입력의 Enter 는 listFrm 암묵 제출을 막기 위해 return false 로 흡수한다.
     ============================================================ --%>
<div class="caws-modal cafm" id="cawsRegist" style="display:none;">
  <div class="caws-mh">
    <h3 id="cafmTitle">신규 접수 등록</h3>
    <span class="caws-msub" id="cafmSub"></span>
    <button type="button" class="caws-mx" onclick="cafm_close();" title="닫기">&times;</button>
  </div>
  <div class="caws-mb">

    <%-- 접수경로 / 중요도 --%>
    <div class="cafm-grid">
      <div class="caws-fld">
        <label>접수 경로<span class="caws-req">*</span></label>
        <select id="cafmRoute" title="접수 경로 선택"></select>
      </div>
      <div class="caws-fld">
        <label>중요도<span class="caws-req">*</span></label>
        <select id="cafmGrade" title="중요도 선택"></select>
      </div>
    </div>

    <%-- 고객사 (신규만 [조회] 가능, 복사/하위작업은 원본과 동일하게 변경 불가) --%>
    <div class="caws-fld">
      <label>고객사<span class="caws-req">*</span></label>
      <div class="caws-frow">
        <input type="text" id="cafmCustNm" readonly class="caws-ro" placeholder="고객사를 조회해주세요" style="flex:1; min-width:0;" title="고객사 명" />
        <input type="text" id="cafmCustCd" readonly class="caws-ro" placeholder="코드" style="width:110px; flex:0 0 auto;" title="고객사 코드" />
        <button type="button" class="btn-s" id="cafmCustBtn" onclick="cafm_custToggle();">조회</button>
      </div>
      <div class="cafm-pick" id="cafmCustPanel" style="display:none;">
        <div class="caws-frow">
          <input type="text" id="cafmCustKw" placeholder="기관명 검색" style="flex:1; min-width:0;" title="기관명 검색"
                 onkeydown="if(event.keyCode===13){cafm_custSearch(1);return false;}" />
          <button type="button" class="btn-s" onclick="cafm_custSearch(1);">검색</button>
          <%-- [AX Lab] 수정 시작 (2026-10-14 AX Lab): 고객사 조회 패널 닫기 버튼 추가 --%>
          <button type="button" class="btn-s" onclick="cafm_custToggle();">닫기</button>
          <%-- [AX Lab] 수정 끝 --%>
        </div>
        <div class="cafm-list" id="cafmCustList"></div>
        <div class="cafm-pgr" id="cafmCustPager"></div>
      </div>
      <div class="caws-mnote" id="cafmCustInfo"></div>
    </div>

    <%-- A/S 신청자 --%>
    <div class="caws-fld">
      <label>A/S 신청자<span class="caws-req">*</span></label>
      <div class="caws-frow">
        <%-- [AX Lab] 수정 시작 (2026-10-14 AX Lab): 신청자 이름 미선택 시 공란 표시 --%>
        <input type="text" id="cafmApplyNm" readonly placeholder="" style="width:130px; flex:0 0 auto;" title="A/S 신청자 이름" />
        <%-- [AX Lab] 수정 끝 --%>
        <input type="text" id="cafmApplyId" readonly placeholder="아이디" style="width:150px; flex:0 0 auto;" title="A/S 신청자 아이디" />
        <button type="button" class="btn-s" onclick="cafm_empToggle();" title="고객사 회원 중에서 선택합니다">조회</button>
        <button type="button" class="btn-s" onclick="cafm_empManual();" title="회원이 아닌 신청자의 이름을 직접 입력합니다">직접입력</button>
      </div>
      <div class="cafm-pick" id="cafmEmpPanel" style="display:none;">
        <div class="caws-frow">
          <input type="text" id="cafmEmpKw" placeholder="이름 검색" style="flex:1; min-width:0;" title="신청자 이름 검색"
                 onkeydown="if(event.keyCode===13){cafm_empSearch(1);return false;}" />
          <button type="button" class="btn-s" onclick="cafm_empSearch(1);">검색</button>
          <%-- [AX Lab] 수정 시작 (2026-10-14 AX Lab): 신청자 ID 조회 패널 닫기 버튼 추가 --%>
          <button type="button" class="btn-s" onclick="cafm_empToggle();">닫기</button>
          <%-- [AX Lab] 수정 끝 --%>
        </div>
        <div class="cafm-list" id="cafmEmpList"></div>
        <div class="cafm-pgr" id="cafmEmpPager"></div>
      </div>
    </div>

    <%-- 실명 / 연락처 --%>
    <div class="cafm-grid">
      <div class="caws-fld">
        <label>A/S 신청자 이름(실명)<span class="caws-req">*</span></label>
        <input type="text" id="cafmRlNm" title="A/S 신청자 이름(실명) 입력" />
      </div>
      <div class="caws-fld">
        <label>A/S 신청자 연락처</label>
        <div class="caws-frow" style="flex-wrap:nowrap;">
          <input type="text" id="cafmTel1" maxlength="4" class="cafm-tel" title="연락처 첫자리" />
          <span>-</span>
          <input type="text" id="cafmTel2" maxlength="4" class="cafm-tel" title="연락처 가운데자리" />
          <span>-</span>
          <input type="text" id="cafmTel3" maxlength="4" class="cafm-tel" title="연락처 끝자리" />
        </div>
      </div>
    </div>

    <%-- SMS 수신동의 (radio 는 name 이 필요해 listFrm 오염 위험 → 칩 버튼) --%>
    <div class="caws-fld">
      <label>SMS 수신동의여부<span class="caws-req">*</span></label>
      <div class="caws-frow">
        <button type="button" class="caws-pchip" id="cafmSmsY" onclick="cafm_sms('Y');">동의</button>
        <button type="button" class="caws-pchip" id="cafmSmsN" onclick="cafm_sms('N');">미동의</button>
      </div>
    </div>

    <%-- 문의유형 / 버전정보 / 시스템(대/소) --%>
    <div class="cafm-grid">
      <div class="caws-fld">
        <label>문의유형<span class="caws-req">*</span></label>
        <select id="cafmReq" title="문의유형 선택" onchange="cafm_reqChange();"></select>
      </div>
      <div class="caws-fld">
        <label>버전 정보</label>
        <input type="text" id="cafmVer" readonly class="caws-ro" title="버전 정보 (고객사 HIS 버전)" />
      </div>
      <div class="caws-fld">
        <label>시스템(대)</label>
        <select id="cafmCate" title="시스템(대) 선택" onchange="cafm_cateChange();"></select>
      </div>
      <div class="caws-fld">
        <label>시스템(소)</label>
        <select id="cafmInq" title="시스템(소) 선택" onchange="cafm_inqChange();"></select>
      </div>
    </div>

    <%-- 배정담당자 (문의유형/시스템유형 선택 시 최소부하 담당자 자동배정 — 변경 가능) --%>
    <div class="caws-fld">
      <label>배정담당자<span class="caws-req">*</span></label>
      <div class="caws-frow">
        <select id="cafmAssign" style="width:200px; flex:0 0 auto;" title="배정담당자 선택" onchange="cafm_assignChange();">
          <option value="">담당자 선택</option>
        </select>
        <span class="cafm-assign-msg" id="cafmAssignMsg"></span>
      </div>
    </div>

    <%-- 요청내용 --%>
    <div class="caws-fld">
      <label>요청 내용 <span style="color:var(--blue); font-weight:600;">(고객에게 공개되는 내용입니다)</span></label>
      <textarea id="cafmContent" title="요청 내용 입력" oninput="cafm_cntUpd();"></textarea>
      <div class="caws-mnote"><span id="cafmCnt">0</span> / 1000자</div>
    </div>

    <%-- 첨부파일 --%>
    <div class="caws-fld">
      <label>첨부파일</label>
      <button type="button" class="btn-s" onclick="cafm_pickFile();">+ 파일 첨부</button>
      <div class="caws-thumbs" id="cafmThumbs"></div>
    </div>

    <div class="caws-mnote">저장 시 처리상태는 '접수' 로 등록되며, 접수일시는 저장 시각으로 자동 기록됩니다.
      상태 변경·답변 등록 등 이후 처리는 이 화면(타임라인/접수처리정보)에서 이어서 하시면 됩니다.</div>
  </div>
  <div class="caws-mf">
    <div class="caws-sp"></div>
    <button type="button" class="btn-s" onclick="cafm_close();">취소</button>
    <button type="button" class="btn-s primary" id="cafmSaveBtn" onclick="cafm_save();">등록</button>
  </div>
</div>
