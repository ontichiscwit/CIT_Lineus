/* [AX Lab] 신규 파일 (2026-07-31): AS 통합화면 - 접수 등록 모달 (신규작업 / 복사 / 하위작업)
   ─────────────────────────────────────────────────────────────────────────────
   기존에는 목록 상단의 [신규작업]/[복사]/[하위작업] 버튼과 통합화면의 [+ 하위작업] 버튼이
   전체 상세페이지(/ad/as/form.do)로 "이동"했다. 이 파일은 그 세 가지 등록 작업을
   통합화면을 떠나지 않고 모달(#cawsRegist, combine-as-modal.jsp)에서 처리한다.

   전역 접두어는 cafm_ (Combine As ForM) 으로 통일한다.
   combine-as.js(asws_) / combine-as-thread.js(caws_) 다음에 로드되어야 하며(list.jsp 참고),
   아래 기존 헬퍼를 재사용한다:
     caws_nvl / caws_esc / caws_html / caws_openModal / caws_closeModal
     caws_codeOptions / caws_codeNm / asws_loadCodes  (공통코드, 동기 캐시)
     caws_taskVal2 / caws_worker                      (문의유형 VAL2 / 최소부하 담당자, 동기)

   ★ 설계 제약 (combine-as-thread.js 상단 주석과 동일)
   ① 신규 URL 금지(MenuAuthFilter). 저장은 원본 form.jsp 와 완전히 동일한 기존 URL
      /ad/as/proc.do (pageType=insert/subInsert, multipart) 를 재사용한다.
      → 채번(getMaxSeq/getMaxSubSeq), 하위작업 등록 시 부모건 상태 재계산, SMS 발송 등
        서버 부수 로직이 전부 proc.do 안에 있으므로 서버는 한 줄도 수정하지 않는다.
      조회도 전부 기존 URL: getAsInfo / getCustList / getCustInfo / getCustInfo2 /
      getCustEmpList / getEmpInfo / getTaskType / getWorker / getAsEmpList.
   ② 모달 마크업은 <form name="listFrm"> 안(#asWorkspace)에 있으므로 입력요소에 name 을 주지
      않는다(목록조회 파라미터 오염 방지). 서버 전송용 hidden 과 첨부 input 은 body 직속의
      별도 폼(#cafmForm, multipart)에 JS 로 만들어 숨은 iframe 으로 제출한다.
      (HTML 은 폼 중첩이 불가해 listFrm 안에 <form> 을 두면 브라우저가 태그를 버린다)
   ③ proc.do 응답은 parent.procReturn(...) 을 "고정" 호출한다. list.jsp 에는 procReturn 이
      이미 일괄처리용으로 정의되어 있어 그대로 두면 엉뚱한 알림이 뜬다.
      → 제출 직전에 window.procReturn 을 cafm_procReturn 으로 잠시 바꿔치기하고
        응답 처리 후 반드시 원복한다. (cafm_save / cafm_procReturn / cafm_submitFail)

   ★ 원본(ad/as/form.jsp)과의 규칙 일치
   - 신규/하위작업 등록은 처리상태 '접수(C001)' 로만 등록된다. (원본 chgProcStatus 강제 규칙)
   - 중요도 기본 C002(일반), 접수경로 기본 C002. (원본 document.ready 기본값)
   - 문의유형 VAL2='Y'(시스템성)면 시스템(대/소) 필수 + 선택 완료 시 최소부하 담당자 자동배정,
     VAL2!='Y' 면 시스템유형 없이 문의유형만으로 자동배정. C011 은 시스템(대) P010 고정.
     (원본 getTaskType/setTaskType/setWorker 흐름. 시스템(소) 선택 후 배정도 동일)
   - 복사(insertcopy)는 원본 makeInitViewInsertCopy 와 동일하게
     "접수경로 + 고객사 + 신청자(이름/ID/연락처)" 만 복사한다. (문의유형·요청내용은 복사 안 함)
   - 하위작업(subInsert)은 원본 initView(subInsert) 와 동일하게 부모 건의
     접수경로/고객사/신청자/SMS/실명/문의·시스템유형/요청내용을 승계한다.
   - 필수값 검증은 원본 goSave 의 insert 분기 검증과 동일한 항목·순서·문구를 따른다.
   ───────────────────────────────────────────────────────────────────────────── */

/* ===== 상태 ===== */
var cafm = {
	mode: 'insert',		/* insert(신규) | copy(복사) | sub(하위작업) */
	srcNo: '',			/* copy: 원본 접수번호 / sub: 상위 접수번호 */
	pref: null,			/* 프리필용 getAsInfo resultVO */
	cust: null,			/* 선택된 고객사 {code,nm,seq,addr,post,tel,his, a,b,c,d(HIS 버전코드)} */
	sms: '',			/* SMS수신동의 'Y' | 'N' | '' */
	val2: '',			/* 문의유형 VAL2 ('Y'=시스템성 유형) */
	version: '',		/* 버전정보 코드 (시스템(대)에 대응하는 고객사 HIS 버전) */
	assignId: '', assignNm: '', assignAuto: false,
	fileSeq: 0,			/* 첨부 슬롯 이름 채번 (uploadFile_n) */
	custPage: 1, empPage: 1,
	_waiting: false,	/* proc.do 제출 후 procReturn 대기 중 */
	_prevProcReturn: null,
	_tmp: null			/* 동기 ajax 콜백 임시 저장소 */
};

/* 거래처/신청자 검색 목록의 페이지당 행수 (서버 PagingVO 기본값과 동일) */
var CAFM_PAGE_ROWS = 10;
/* 첨부 최대 개수 (화면 제한. 통합화면 답변 첨부와 동일 정책) */
var CAFM_MAX_FILES = 5;

/* ===== 유틸 ===== */
function cafm_el(id){ return document.getElementById(id); }
function cafm_v(id){ var e = cafm_el(id); return e ? String(e.value || '') : ''; }
function cafm_sv(id, v){ var e = cafm_el(id); if(e) e.value = caws_nvl(v, ''); }

/* =============================================================================
 * 1) 진입점 — 목록 상단 버튼 3개(list.jsp) + 통합화면 [+ 하위작업](combine-as-thread.js)
 * ========================================================================== */
/* [신규작업] */
function cafm_openInsert(){
	cafm_open('insert', '');
}

/* [복사] — 원본 goInsertCopy 와 동일한 선택 검증 */
function cafm_openCopy(){
	var cnt = 0, chkVal = '';
	$("input[name=chk]:checked").each(function(){ cnt++; chkVal = $(this).val(); });
	if(cnt === 0){ alert('복사할 A/S를 선택하여 주십시오.'); return; }
	if(cnt > 1){ alert('A/S를 하나만 선택하여 주십시오.'); return; }
	cafm_open('copy', chkVal.split('@')[0]);
}

/* [하위작업] — 원본 goForm('subInsert') 와 동일한 선택 검증
   (1건만 / 이미 하위건이면 불가 / 다른 접수건과 연결(AS_NO_LINK)돼 있으면 불가) */
function cafm_openSub(){
	var cnt = 0, chkVal = '', linked = false;
	$("input[name=chk]:checked").each(function(){
		cnt++;
		chkVal = $(this).val();
		var lk = $(this).data('as-no-link');
		if(lk && lk !== '') linked = true;
	});
	if(cnt === 0){ alert('상위 작업을 선택해 주세요.'); return; }
	if(cnt > 1){ alert('하위작업은 하나의 접수건만 선택할 수 있습니다.'); return; }
	if(chkVal.split('@')[1] !== ''){ alert('해당 건에서는 하위작업을 생성할 수 없습니다.'); return; }
	if(linked){ alert('이미 다른 접수건과 연결되어있어 하위작업 등록이 불가능합니다.'); return; }
	cafm_open('sub', chkVal.split('@')[0]);
}

/* 통합화면 COL3 의 [+ 하위작업] 버튼용 (combine-as-thread.js caws_subCreate 에서 호출).
   현재 보고 있는 건의 vo 로 목록 버튼과 같은 조건을 검증한다. */
function cafm_openSubFor(asNo){
	if(caws_nvl(asNo, '') === '') return;
	var vo = (typeof caws != 'undefined' && caws.vo) ? caws.vo : {};
	if(caws_nvl(vo.cn_as_no, '') !== ''){ alert('해당 건에서는 하위작업을 생성할 수 없습니다.'); return; }
	if(caws_nvl(vo.as_no_link, '') !== ''){ alert('이미 다른 접수건과 연결되어있어 하위작업 등록이 불가능합니다.'); return; }
	cafm_open('sub', asNo);
}

/* =============================================================================
 * 2) 모달 열기 / 초기화 / 프리필
 * ========================================================================== */
function cafm_open(mode, srcNo){
	cafm.mode = mode;
	cafm.srcNo = caws_nvl(srcNo, '');
	cafm.pref = null; cafm.cust = null;
	cafm.sms = ''; cafm.val2 = ''; cafm.version = '';
	cafm.assignId = ''; cafm.assignNm = ''; cafm.assignAuto = false;
	cafm.custPage = 1; cafm.empPage = 1;
	cafm._waiting = false;
	cafm_clearFiles();

	/* 타이틀/부제 */
	var t = '신규 접수 등록', sub = '';
	if(mode === 'copy'){ t = '접수 복사 등록'; sub = '원본 ' + cafm.srcNo + ' 의 고객사·신청자 정보를 복사했습니다'; }
	if(mode === 'sub'){ t = '하위작업 등록'; sub = '상위 접수번호 ' + cafm.srcNo; }
	caws_html('cafmTitle', caws_esc(t));
	caws_html('cafmSub', caws_esc(sub));

	/* 공통코드 select (원본 document.ready 와 동일한 코드그룹/기본값) */
	var route = cafm_el('cafmRoute');
	if(route) route.innerHTML = caws_codeOptions('AS', 'CD02', 'C002', '선택');	/* 접수경로, 기본 C002 */
	var grade = cafm_el('cafmGrade');
	if(grade) grade.innerHTML = caws_codeOptions('AS', 'CD04', 'C002', '선택');	/* 중요도, 기본 C002(일반) */
	var req = cafm_el('cafmReq');
	if(req){
		req.innerHTML = caws_codeOptions('AS', 'CD07', '', '선택');				/* 문의유형 */
		/* 원본 신규 화면과 동일: 관리자 직접등록에서는 '기타문의(C999)' 를 고를 수 없다.
		   (하위작업은 부모 값 승계가 필요할 수 있어 원본 initView 와 동일하게 남겨둔다) */
		if(mode !== 'sub'){
			var o = req.querySelector('option[value="C999"]');
			if(o) o.parentNode.removeChild(o);
		}
	}
	cafm_sysReset(true);

	/* 입력값 초기화 */
	cafm_sv('cafmVer', '');
	cafm_sv('cafmApplyNm', ''); cafm_sv('cafmApplyId', '');
	var an = cafm_el('cafmApplyNm');
	if(an){ an.readOnly = true; an.placeholder = '이름'; }
	cafm_sv('cafmRlNm', '');
	cafm_sv('cafmTel1', ''); cafm_sv('cafmTel2', ''); cafm_sv('cafmTel3', '');
	cafm_sv('cafmContent', ''); cafm_cntUpd();
	cafm_smsSync();
	cafm_setCustView();
	cafm_fillAssign([]);
	caws_html('cafmAssignMsg', '');

	/* 검색 패널 접기 */
	var cp = cafm_el('cafmCustPanel'); if(cp) cp.style.display = 'none';
	var ep = cafm_el('cafmEmpPanel'); if(ep) ep.style.display = 'none';

	/* 고객사 [조회] 는 신규에서만 노출.
	   (원본도 insertcopy/subInsert 화면에서는 고객사 변경이 불가능하다 — form.jsp 3200행 분기) */
	var cb = cafm_el('cafmCustBtn');
	if(cb) cb.style.display = (mode === 'insert') ? '' : 'none';

	var sbtn = cafm_el('cafmSaveBtn');
	if(sbtn){ sbtn.disabled = false; sbtn.innerHTML = '등록'; }

	if(mode !== 'insert') cafm_prefill();

	caws_openModal('cawsRegist');
}

function cafm_close(){
	cafm_clearFiles();
	caws_closeModal('cawsRegist');
}

/* 복사/하위작업 프리필 — 원본 makeInitViewInsertCopy(복사) / makeInitView-subInsert(하위) 와 동일 범위 */
function cafm_prefill(){
	cafm.pref = null;
	common.ajaxCall({ as_no: cafm.srcNo }, '/ad/as/getAsInfo.do', 'cafm_prefReturn');	/* 동기 */
	var vo = cafm.pref || {};

	/* 접수경로 */
	if(caws_nvl(vo.accept_route, '') !== '') cafm_sv('cafmRoute', vo.accept_route);

	/* 고객사 (변경 불가) — 부가정보/HIS 버전코드는 getCustInfo2 로 채운다 (원본 makeCustInfo 동일) */
	if(caws_nvl(vo.cust_code, '') !== ''){
		common.ajaxCall({ cust_code: vo.cust_code }, '/ad/member/getCustInfo2.do', 'cafm_custInfoReturn');	/* 동기 */
		if(cafm.cust && caws_nvl(cafm.cust.code, '') === '') cafm.cust.code = vo.cust_code;
		if(!cafm.cust){
			cafm.cust = { code: vo.cust_code, nm: caws_nvl(vo.cust_kor_name, ''), seq: '',
			              addr: '', post: '', tel: '', his: '', a: '', b: '', c: '', d: '' };
		}
		cafm_setCustView();
	}

	/* A/S 신청자 */
	cafm_sv('cafmApplyNm', caws_nvl(vo.apply_nm, ''));
	cafm_sv('cafmApplyId', caws_nvl(vo.apply_id, ''));
	cafm_setTel(caws_nvl(vo.apply_tel, ''));

	if(cafm.mode !== 'sub') return;

	/* --- 이하 하위작업 전용 승계 (원본 initView(subInsert) 동일) --- */
	cafm_sv('cafmRlNm', caws_nvl(vo.rl_apply_nm, ''));
	var sms = caws_nvl(vo.send_sms, '');
	cafm.sms = (sms === 'Y') ? 'Y' : (sms === 'N' ? 'N' : '');
	cafm_smsSync();
	cafm_sv('cafmContent', caws_nvl(vo.call_content, ''));
	cafm_cntUpd();

	/* 문의유형/시스템유형 승계 → 담당자 자동배정까지 원본과 동일한 체인으로 태운다 */
	var rt = caws_nvl(vo.request_type, '');
	if(rt !== ''){
		cafm_sv('cafmReq', rt);
		cafm_reqChange();
		if(cafm.val2 === 'Y' && caws_nvl(vo.service_cate, '') !== ''){
			cafm_sv('cafmCate', vo.service_cate);
			cafm_cateChange();
			if(caws_nvl(vo.inquiry_type, '') !== ''){
				cafm_sv('cafmInq', vo.inquiry_type);
				cafm_inqChange();
			}
		}
	}
}
function cafm_prefReturn(data){
	cafm.pref = (data && data.resultVO) ? data.resultVO : {};
}

/* 연락처 문자열을 3칸으로 나눈다 ('-' 포함/미포함 모두 — 원본 makeInitView 동일) */
function cafm_setTel(tel){
	tel = caws_nvl(tel, '');
	var t1 = '', t2 = '', t3 = '';
	if(tel !== ''){
		if(tel.indexOf('-') >= 0){
			var p = tel.split('-');
			t1 = caws_nvl(p[0], ''); t2 = caws_nvl(p[1], ''); t3 = caws_nvl(p[2], '');
		}else{
			t1 = tel.substr(0, 3); t2 = tel.substr(3, 4); t3 = tel.substr(7);
		}
	}
	cafm_sv('cafmTel1', t1); cafm_sv('cafmTel2', t2); cafm_sv('cafmTel3', t3);
}

/* =============================================================================
 * 3) 고객사 조회 (원본 showCustLayer/custList/setValue/makeCustInfo 의 모달 내장판)
 * ========================================================================== */
function cafm_custToggle(){
	var p = cafm_el('cafmCustPanel');
	if(!p) return;
	var open = (p.style.display === 'none');
	p.style.display = open ? '' : 'none';
	if(open){
		cafm_sv('cafmCustKw', '');
		cafm_custSearch(1);
		var k = cafm_el('cafmCustKw');
		if(k) k.focus();
	}
}
function cafm_custSearch(page){
	cafm.custPage = page || 1;
	common.ajaxCall({ page: cafm.custPage, search_text: cafm_v('cafmCustKw') },
		'/ad/member/getCustList.do', 'cafm_custListReturn');
}
function cafm_custListReturn(data){
	var list = (data && data.resultList) ? data.resultList : [];
	var s = '';
	for(var i = 0; i < list.length; i++){
		var d = list[i];
		s += '<tr onclick="cafm_custPick(\'' + caws_esc(caws_nvl(d.seq, '')) + '\');">'
		  +    '<td>' + caws_esc(caws_nvl(d.cust_kor_name, '')) + ' [' + caws_esc(caws_nvl(d.crm_code, '')) + ']</td>'
		  +    '<td>' + caws_esc(caws_nvl(d.ceo, '')) + '</td>'
		  +    '<td>' + caws_esc(caws_nvl(d.cust_address, '')) + '</td>'
		  +  '</tr>';
	}
	if(s === '') s = '<tr><td colspan="3" class="cafm-none">조회된 거래처가 없습니다.</td></tr>';
	caws_html('cafmCustList',
		'<table><thead><tr><th>기관명</th><th>대표자</th><th>주소</th></tr></thead><tbody>' + s + '</tbody></table>');
	cafm_pager('cafmCustPager', cafm.custPage, list.length, 'cafm_custSearch');
}
function cafm_custPick(seq){
	common.ajaxCall({ seq: seq }, '/ad/member/getCustInfo.do', 'cafm_custInfoReturn');	/* 동기 */
	var p = cafm_el('cafmCustPanel');
	if(p) p.style.display = 'none';
	/* 원본 setValue 와 동일: 고객사가 바뀌면 신청자 ID/연락처 초기화 (이름은 유지) */
	cafm_sv('cafmApplyId', '');
	cafm_sv('cafmTel1', ''); cafm_sv('cafmTel2', ''); cafm_sv('cafmTel3', '');
	/* 원본 showCustLayer 와 동일: 문의유형/시스템유형/버전정보 초기화 (고객사에 종속된 값이므로) */
	cafm_sv('cafmReq', '');
	cafm_reqChange();
}
/* getCustInfo.do(검색 선택) / getCustInfo2.do(프리필) 공용 콜백 — 원본 makeCustInfo 와 동일 필드 */
function cafm_custInfoReturn(data){
	var r = (data && data.resultVO) ? data.resultVO : null;
	if(!r) return;
	cafm.cust = {
		code: caws_nvl(r.erp_code, caws_nvl(r.cust_code, '')),
		nm:   caws_nvl(r.cust_kor_name, ''),
		seq:  caws_nvl(r.seq, ''),
		addr: caws_nvl(r.cust_address, ''),
		post: caws_nvl(r.zip_code, ''),
		tel:  caws_nvl(r.tel_no, ''),
		his:  caws_nvl(r.his_treat_name, ''),
		/* HIS 버전코드 4종 — 시스템(대) 선택 시 버전정보 표시에 쓴다 (원본 a/b/c/d 전역과 동일) */
		a: caws_nvl(r.his_basic_code, ''),		/* 기초 (P002 / CUST CD04) */
		b: caws_nvl(r.his_treat_code, ''),		/* 진료 (P004 / CUST CD05) */
		c: caws_nvl(r.his_work_code, ''),		/* 원무 (P003 / CUST CD06) */
		d: caws_nvl(r.his_claim_code, '')		/* 청구 (P006 / CUST CD07) */
	};
	cafm_setCustView();
}
function cafm_setCustView(){
	var c = cafm.cust;
	cafm_sv('cafmCustNm', c ? c.nm : '');
	cafm_sv('cafmCustCd', c ? c.code : '');
	var info = '';
	if(c){
		var parts = [];
		if(c.addr !== '') parts.push(c.addr + (c.post !== '' ? ' (' + c.post + ')' : ''));
		if(c.tel !== '') parts.push('연락처 ' + c.tel);
		if(c.his !== '') parts.push('HIS 진료 ' + c.his);
		info = parts.join(' · ');
	}
	caws_html('cafmCustInfo', caws_esc(info));
}

/* 검색 목록 간이 페이저 (이전/다음. 결과가 페이지당 행수보다 적으면 마지막 페이지로 본다) */
function cafm_pager(id, page, rows, fn){
	var s = '<button type="button" class="btn-s"' + (page <= 1 ? ' disabled' : '')
	      + ' onclick="' + fn + '(' + (page - 1) + ');">&#9666; 이전</button>'
	      + '<span>' + page + ' 페이지</span>'
	      + '<button type="button" class="btn-s"' + (rows < CAFM_PAGE_ROWS ? ' disabled' : '')
	      + ' onclick="' + fn + '(' + (page + 1) + ');">다음 &#9656;</button>';
	caws_html(id, s);
}

/* =============================================================================
 * 4) A/S 신청자 조회/직접입력 (원본 showEmpLayer/empList/setValueEmp/btnEmpField)
 * ========================================================================== */
function cafm_empToggle(){
	if(!cafm.cust || cafm.cust.code === ''){ alert('고객사 정보를 조회해 주세요.'); return; }
	var p = cafm_el('cafmEmpPanel');
	if(!p) return;
	var open = (p.style.display === 'none');
	p.style.display = open ? '' : 'none';
	if(open){
		cafm_sv('cafmEmpKw', '');
		cafm_empSearch(1);
		var k = cafm_el('cafmEmpKw');
		if(k) k.focus();
	}
}
function cafm_empSearch(page){
	cafm.empPage = page || 1;
	common.ajaxCall({ page: cafm.empPage, cust_code: cafm.cust.code, search_text: cafm_v('cafmEmpKw') },
		'/ad/member/getCustEmpList.do', 'cafm_empListReturn');
}
function cafm_empListReturn(data){
	var list = (data && data.resultList) ? data.resultList : [];
	var s = '';
	for(var i = 0; i < list.length; i++){
		var d = list[i];
		s += '<tr onclick="cafm_empPick(\'' + caws_esc(caws_nvl(d.emp_id, '')) + '\');">'
		  +    '<td>' + caws_esc(caws_nvl(d.emp_name, '')) + '</td>'
		  +    '<td>' + caws_esc(caws_nvl(d.emp_id, '')) + '</td>'
		  +    '<td>' + caws_esc(caws_nvl(d.tel_no, '')) + '</td>'
		  +  '</tr>';
	}
	if(s === '') s = '<tr><td colspan="3" class="cafm-none">조회된 신청자가 없습니다. [직접입력] 을 이용하세요.</td></tr>';
	caws_html('cafmEmpList',
		'<table><thead><tr><th>이름</th><th>아이디</th><th>연락처</th></tr></thead><tbody>' + s + '</tbody></table>');
	cafm_pager('cafmEmpPager', cafm.empPage, list.length, 'cafm_empSearch');
}
function cafm_empPick(empId){
	common.ajaxCall({ emp_id: empId }, '/ad/member/getEmpInfo.do', 'cafm_empInfoReturn');	/* 동기 */
	var p = cafm_el('cafmEmpPanel');
	if(p) p.style.display = 'none';
}
function cafm_empInfoReturn(data){
	var r = (data && data.resultVO) ? data.resultVO : null;
	if(!r) return;
	var an = cafm_el('cafmApplyNm');
	if(an){ an.readOnly = true; an.placeholder = '이름'; }
	cafm_sv('cafmApplyNm', caws_nvl(r.emp_name, ''));
	cafm_sv('cafmApplyId', caws_nvl(r.emp_id, ''));
	cafm_setTel(caws_nvl(r.tel_no, ''));
}
/* 직접입력 — 원본 btnEmpField 와 동일 (이름만 직접 입력, 아이디는 비움) */
function cafm_empManual(){
	if(!cafm.cust || cafm.cust.code === ''){ alert('고객사를 조회해 주세요.'); return; }
	var p = cafm_el('cafmEmpPanel');
	if(p) p.style.display = 'none';
	var an = cafm_el('cafmApplyNm');
	if(an){ an.readOnly = false; an.value = ''; an.placeholder = '이름을 입력하세요'; an.focus(); }
	cafm_sv('cafmApplyId', '');
}

/* SMS 수신동의 칩 토글 (radio 는 name 이 필요해 listFrm 오염 위험 → 칩 버튼으로 대체) */
function cafm_sms(v){ cafm.sms = v; cafm_smsSync(); }
function cafm_smsSync(){
	var y = cafm_el('cafmSmsY'), n = cafm_el('cafmSmsN');
	if(y) y.classList.toggle('on', cafm.sms === 'Y');
	if(n) n.classList.toggle('on', cafm.sms === 'N');
}

/* =============================================================================
 * 5) 문의유형 → 시스템(대/소) → 버전정보 → 담당자 자동배정
 *    (원본 getTaskType / setTaskType / setService_cate / getInquiry_type / setWorker)
 * ========================================================================== */
function cafm_sysReset(disable){
	var c = cafm_el('cafmCate'), q = cafm_el('cafmInq');
	if(c){ c.innerHTML = '<option value="">선택</option>'; c.disabled = !!disable; }
	if(q){ q.innerHTML = '<option value="">선택</option>'; q.disabled = !!disable; }
	cafm.version = '';
	cafm_sv('cafmVer', '');
}

function cafm_reqChange(){
	var rt = cafm_v('cafmReq');
	/* 원본 getTaskType: 거래처를 먼저 조회해야 문의유형을 고를 수 있다 */
	if(rt !== '' && (!cafm.cust || cafm.cust.code === '')){
		alert('고객사를 먼저 조회해 주세요.');
		cafm_sv('cafmReq', '');
		rt = '';
	}
	cafm.val2 = '';
	cafm_sysReset(true);
	cafm_setAssign('', '', false);
	cafm_fillAssign([]);
	if(rt === '') return;

	cafm.val2 = caws_taskVal2(rt);	/* getTaskType.do 동기 조회 (combine-as-thread.js 헬퍼 재사용) */

	if(cafm.val2 === 'Y'){
		/* 시스템성 유형: 시스템(대/소)을 골라야 자동배정된다 */
		var c = cafm_el('cafmCate');
		if(c){
			c.innerHTML = caws_codeOptions('AS', 'CD03', '', '선택');
			if(rt === 'C011'){
				/* 원본 setTaskType: C011 은 시스템(대) P010 고정 */
				c.value = 'P010';
				c.disabled = true;
				cafm_cateChange();
			}else{
				/* 원본 setTaskType: C011 이 아니면 P010 선택 불가 */
				var p = c.querySelector('option[value="P010"]');
				if(p) p.parentNode.removeChild(p);
				c.disabled = false;
			}
		}
	}else{
		/* 비시스템 유형: 시스템유형 없이 문의유형만으로 즉시 자동배정 (원본 setTaskType else 분기) */
		cafm_resolveWorker();
	}
}

function cafm_cateChange(){
	var sc = cafm_v('cafmCate');
	var q = cafm_el('cafmInq');
	if(q){ q.innerHTML = '<option value="">선택</option>'; q.disabled = (sc === ''); }
	cafm_setAssign('', '', false);
	cafm_fillAssign([]);
	cafm.version = '';
	cafm_sv('cafmVer', '');
	if(sc === '') return;

	/* 시스템(소) 목록 = AS 그룹의 '시스템(대) 코드' 하위 코드 (원본 setService_cate 동일) */
	if(q){
		var list = asws_loadCodes('AS', sc);
		var s = '<option value="">선택</option>';
		for(var i = 0; i < list.length; i++){
			/* 원본 신규 화면: '기타(P008)-기타(C999)' 조합은 선택 불가 */
			if(sc === 'P008' && list[i].code === 'C999' && cafm.mode !== 'sub') continue;
			s += '<option value="' + caws_esc(list[i].code) + '">' + caws_esc(list[i].name) + '</option>';
		}
		q.innerHTML = s;
	}

	/* 버전정보 — 고객사의 HIS 버전코드를 시스템(대)에 맞춰 표시 (원본 setService_cate 동일 매핑) */
	var c = cafm.cust || {};
	var map = { P002: { v: c.a, pc: 'CD04' }, P004: { v: c.b, pc: 'CD05' },
	            P003: { v: c.c, pc: 'CD06' }, P006: { v: c.d, pc: 'CD07' } };
	if(map[sc] && caws_nvl(map[sc].v, '') !== ''){
		cafm.version = map[sc].v;
		cafm_sv('cafmVer', caws_codeNm('CUST', map[sc].pc, map[sc].v));
	}
}

function cafm_inqChange(){
	if(cafm_v('cafmInq') === ''){
		cafm_setAssign('', '', false);
		cafm_fillAssign([]);
		return;
	}
	cafm_resolveWorker();
}

/* 최소부하 담당자 자동배정 + 담당자 후보 목록 로드
   (원본 setWorker + getEmpList/makeEmpList2. 신규 등록은 항상 '접수' 상태라 C005 예외는 해당 없음) */
function cafm_resolveWorker(){
	var rt = cafm_v('cafmReq'), sc = cafm_v('cafmCate'), iq = cafm_v('cafmInq');
	var params;
	if(cafm.val2 === 'Y'){
		if(sc === '' || iq === '') return;
		params = { request_type: rt, service_cate: sc, inquiry_type: iq, val2: cafm.val2 };
	}else{
		params = { request_type: rt, val2: cafm.val2 };
	}
	var w = caws_worker(params);	/* getWorker.do 동기 조회 (combine-as-thread.js 헬퍼 재사용) */
	if(w && caws_nvl(w.wk_emp_no, '') !== ''){
		cafm_setAssign(w.wk_emp_no, caws_nvl(w.wk_emp_nm, ''), true);
	}else{
		cafm_setAssign('', '', false);
	}
	/* 담당자 후보 목록 (원본 getAsEmpList) — 자동배정 결과가 없어도 직접 고를 수 있게 항상 채운다 */
	cafm._tmp = null;
	common.ajaxCall({ request_type: rt, service_cate: sc, inquiry_type: iq, val2: cafm.val2, assign_id: cafm.assignId },
		'/ad/as/getAsEmpList.do', 'cafm_empCandReturn');	/* 동기 */
	cafm_fillAssign(cafm._tmp || []);
}
function cafm_empCandReturn(data){
	cafm._tmp = (data && data.resultList) ? data.resultList : [];
}
function cafm_setAssign(id, nm, auto){
	cafm.assignId = caws_nvl(id, '');
	cafm.assignNm = caws_nvl(nm, '');
	cafm.assignAuto = !!auto;
	caws_html('cafmAssignMsg', auto ? caws_esc(nm) + ' 님이 자동배정되었습니다. (변경 가능)' : '');
}
function cafm_fillAssign(list){
	var sel = cafm_el('cafmAssign');
	if(!sel) return;
	var s = '<option value="">담당자 선택</option>', has = false;
	for(var i = 0; i < list.length; i++){
		var no = caws_nvl(list[i].emp_no, ''), nm = caws_nvl(list[i].emp_nm, '');
		if(no === cafm.assignId) has = true;
		s += '<option value="' + caws_esc(no) + '">' + caws_esc(nm) + '</option>';
	}
	/* 자동배정된 담당자가 후보 목록에 없으면 옵션으로 추가해 값이 유실되지 않게 한다 */
	if(!has && cafm.assignId !== ''){
		s += '<option value="' + caws_esc(cafm.assignId) + '">' + caws_esc(cafm.assignNm) + '</option>';
	}
	sel.innerHTML = s;
	sel.value = cafm.assignId;
}
function cafm_assignChange(){
	var sel = cafm_el('cafmAssign');
	if(!sel) return;
	var nm = (sel.selectedIndex >= 0 && sel.value !== '') ? sel.options[sel.selectedIndex].text : '';
	cafm_setAssign(sel.value, nm, false);
}

/* 요청내용 글자수 (원본과 동일 1000자 제한) */
function cafm_cntUpd(){
	var ta = cafm_el('cafmContent');
	if(!ta) return;
	if(ta.value.length > 1000) ta.value = ta.value.substring(0, 1000);
	caws_html('cafmCnt', String(ta.value.length));
}

/* =============================================================================
 * 6) 첨부파일 — body 직속 hidden 폼(#cafmForm) 안에 input 슬롯을 만든다.
 *    서버(AsServiceImpl.insertAsInfo/insertAsCnInfo)는 파라미터명이 "uploadFile_숫자" 인
 *    파일을 접수 첨부로 저장하고 숫자를 ATTACH_ORD 로 쓴다. (원본 form.jsp 와 동일한 이름 규칙)
 * ========================================================================== */
function cafm_form(){
	var f = document.getElementById('cafmForm');
	if(!f){
		f = document.createElement('form');
		f.id = 'cafmForm';
		f.method = 'post';
		f.style.display = 'none';
		f.setAttribute('enctype', 'multipart/form-data');
		f.setAttribute('accept-charset', 'UTF-8');
		document.body.appendChild(f);
	}
	return f;
}
function cafm_slotBox(){
	var f = cafm_form();
	var box = document.getElementById('cafmFileSlots');
	if(!box){
		box = document.createElement('div');
		box.id = 'cafmFileSlots';
		f.appendChild(box);
	}
	return box;
}
function cafm_slots(){
	return cafm_slotBox().querySelectorAll('input[type=file]');
}
function cafm_pickFile(){
	if(cafm_slots().length >= CAFM_MAX_FILES){
		alert('첨부는 최대 ' + CAFM_MAX_FILES + '개까지 가능합니다.');
		return;
	}
	var inp = document.createElement('input');
	inp.type = 'file';
	inp.name = 'uploadFile_' + (cafm.fileSeq++);
	inp.onchange = cafm_thumbs;
	cafm_slotBox().appendChild(inp);
	inp.click();
}
function cafm_delFile(name){
	var s = cafm_slots();
	for(var i = 0; i < s.length; i++){
		if(s[i].name === name){ s[i].parentNode.removeChild(s[i]); break; }
	}
	cafm_thumbs();
}
function cafm_clearFiles(){
	var b = document.getElementById('cafmFileSlots');
	if(b) b.innerHTML = '';
	cafm.fileSeq = 0;
	cafm_thumbs();
}
/* 첨부 썸네일 (통합화면 답변 첨부의 caws_renderThumbs 와 동일한 표현) */
function cafm_thumbs(){
	var wrap = cafm_el('cafmThumbs');
	if(!wrap) return;
	var slots = cafm_slots(), s = '';
	for(var i = 0; i < slots.length; i++){
		var fl = slots[i].files;
		if(!fl || !fl.length) continue;		/* 선택 취소된 빈 슬롯. 서버도 size 0 은 건너뛴다 */
		var f = fl[0];
		var thumb;
		if(typeof caws_isImg === 'function' && caws_isImg(f.name) && typeof URL != 'undefined' && URL.createObjectURL){
			thumb = '<img src="' + URL.createObjectURL(f) + '" alt="" />';
		}else{
			var ext = (typeof caws_ext === 'function') ? caws_ext(f.name) : '';
			thumb = '<span class="caws-tico">' + caws_esc(ext || 'file') + '</span>';
		}
		s += '<span class="caws-thumb">' + thumb
		  +   '<span class="caws-tnm" title="' + caws_esc(f.name) + '">' + caws_esc(f.name) + '</span>'
		  +   '<button type="button" class="caws-tdel" title="첨부 제거" onclick="cafm_delFile(\'' + slots[i].name + '\');">&times;</button>'
		  + '</span>';
	}
	wrap.innerHTML = s;
}

/* =============================================================================
 * 7) 저장 — 검증(원본 goSave insert 분기 동일) → /ad/as/proc.do 멀티파트 제출(숨은 iframe)
 * ========================================================================== */
function cafm_save(){
	/* ---- 필수값 검증 : 원본 form.jsp goSave 와 동일한 항목/순서/문구 ---- */
	if(cafm_v('cafmRoute') === ''){ alert('접수 경로를 선택하세요.'); return; }
	if(!cafm.cust || cafm.cust.code === ''){ alert('고객사 정보를 조회해 주세요.'); return; }
	if(cafm_v('cafmApplyNm') === ''){ alert('A/S 신청자 이름을 입력하세요.'); return; }
	if(cafm_v('cafmRlNm') === ''){ alert('A/S 신청자 이름을 입력하세요.'); return; }
	if(cafm.sms === ''){ alert('SMS수신동의여부를 선택하세요.'); return; }
	if(cafm.sms === 'Y' && (cafm_v('cafmTel1') === '' || cafm_v('cafmTel2') === '' || cafm_v('cafmTel3') === '')){
		alert('SMS 수신 전화번호를 입력해 주세요.');
		return;
	}
	var rt = cafm_v('cafmReq');
	if(rt === ''){ alert('문의유형을 선택하세요.'); return; }
	if(cafm.val2 === 'Y'){
		if(cafm_v('cafmCate') === ''){ alert('시스템(대)를 선택하세요.'); return; }
		if(cafm_v('cafmInq') === ''){ alert('시스템(소)를 선택하세요.'); return; }
	}
	if(cafm_v('cafmGrade') === ''){ alert('중요도를 선택하세요.'); return; }
	if(cafm_v('cafmAssign') === ''){ alert('담당자 선택은 필수입니다.'); return; }

	if(!confirm(cafm.mode === 'sub' ? '하위작업을 등록하시겠습니까?' : '접수를 등록하시겠습니까?')) return;

	var tel = '';
	if(cafm_v('cafmTel1') !== '' || cafm_v('cafmTel2') !== '' || cafm_v('cafmTel3') !== ''){
		tel = cafm_v('cafmTel1') + '-' + cafm_v('cafmTel2') + '-' + cafm_v('cafmTel3');
	}

	/* 전송 파라미터 — 원본 procFrm 이 proc.do 로 보내던 것과 동일한 이름.
	   접수일자/시간(accept_dt/time)과 접수번호 채번은 서버(insertAsInfo/proc.do)가 직접 세팅한다. */
	var p = {
		pageType:     (cafm.mode === 'sub') ? 'subInsert' : 'insert',
		as_no:        (cafm.mode === 'sub') ? cafm.srcNo : '',		/* subInsert: 부모 접수번호 (서버가 CN_AS_NO 로 옮김) */
		cn_as_no:     '',
		accept_route: cafm_v('cafmRoute'),
		cust_code:    cafm.cust.code,
		apply_nm:     cafm_v('cafmApplyNm'),
		apply_id:     cafm_v('cafmApplyId'),
		apply_tel:    tel,
		rl_apply_nm:  cafm_v('cafmRlNm'),
		send_sms:     cafm.sms,
		request_type: rt,
		service_cate: (cafm.val2 === 'Y') ? cafm_v('cafmCate') : '',
		inquiry_type: (cafm.val2 === 'Y') ? cafm_v('cafmInq') : '',
		version_info: cafm.version,
		call_content: cafm_v('cafmContent'),
		proc_status:  'C001',		/* 원본 규칙: 신규/하위작업 등록은 '접수' 상태로만 등록 (chgProcStatus) */
		inportance:   cafm_v('cafmGrade'),
		assign_id:    cafm_v('cafmAssign'),
		as_no_link:   '',
		save_gubun:   ''
	};

	var f = cafm_form();
	var old = document.getElementById('cafmParams');
	if(old) old.parentNode.removeChild(old);
	var box = document.createElement('div');
	box.id = 'cafmParams';
	for(var k in p){
		if(!p.hasOwnProperty(k)) continue;
		var inp = document.createElement('input');
		inp.type = 'hidden';
		inp.name = k;
		inp.value = p[k];
		box.appendChild(inp);
	}
	f.appendChild(box);

	try{ $('#cafmFrame').remove(); }catch(e){}
	$('<iframe id="cafmFrame" name="cafmFrame" style="width:0;height:0;display:none;"></iframe>').appendTo('body');

	/* ★ proc.do 응답은 parent.procReturn(...) 을 고정 호출한다 (파일 상단 제약 ③).
	   제출 직전에 잠시 우리 콜백으로 바꿔치기하고, 응답 처리 후 반드시 원복한다. */
	cafm._prevProcReturn = window.procReturn;
	window.procReturn = cafm_procReturn;
	cafm._waiting = true;

	var btn = cafm_el('cafmSaveBtn');
	if(btn){ btn.disabled = true; btn.innerHTML = '등록 중...'; }

	var fr = document.getElementById('cafmFrame');
	fr.onload = function(){
		/* 새로 만든 iframe 은 제출 응답보다 먼저 초기 빈 문서(about:blank)의 load 가
		   발화할 수 있다. 실제 응답(/ad/as/proc.do) 로드만 오류 판정 대상으로 삼는다. */
		var url = '';
		try{ url = fr.contentWindow.location.href; }catch(e){ url = 'x'; }
		if(url === '' || url === 'about:blank') return;
		/* 정상 응답이면 iframe 파싱 중 procReturn 이 먼저 실행되고 onload 가 온다.
		   그래도 _waiting 이면 서버 오류 페이지 등으로 콜백이 실행되지 않은 것이다. */
		setTimeout(function(){ if(cafm._waiting) cafm_submitFail(); }, 400);
	};

	f.target = 'cafmFrame';
	f.action = '/ad/as/proc.do';
	f.submit();
}

function cafm_submitFail(){
	cafm._waiting = false;
	if(cafm._prevProcReturn){ window.procReturn = cafm._prevProcReturn; cafm._prevProcReturn = null; }
	var btn = cafm_el('cafmSaveBtn');
	if(btn){ btn.disabled = false; btn.innerHTML = '등록'; }
	alert('처리도중 오류가 발생했습니다.');
}

/* proc.do 응답 콜백. 원본 form.jsp procReturn(gubun, as_no, page_type, cn_as_no, save_gubun) 시그니처 */
function cafm_procReturn(gubun, as_no, pageType, cn_as_no, save_gubun){
	cafm._waiting = false;
	if(cafm._prevProcReturn){ window.procReturn = cafm._prevProcReturn; cafm._prevProcReturn = null; }
	var btn = cafm_el('cafmSaveBtn');
	if(btn){ btn.disabled = false; btn.innerHTML = '등록'; }

	if(gubun !== 'success'){
		alert('처리도중 오류가 발생했습니다.');
		return;
	}

	alert('정상적으로 등록되었습니다.\n접수번호 : ' + caws_nvl(as_no, ''));
	cafm_clearFiles();
	caws_closeModal('cawsRegist');

	/* 목록 재조회 후 방금 등록한 건을 통합화면(COL2/COL3)에 바로 연다.
	   (현재 검색조건에 걸리지 않아 목록에 없더라도 상세는 정상 조회된다) */
	if(typeof makeListData === 'function') makeListData();
	if(typeof asws_openDetail === 'function' && caws_nvl(as_no, '') !== ''){
		asws_openDetail(as_no, (pageType === 'subInsert') ? caws_nvl(cn_as_no, '') : '');
	}
}
