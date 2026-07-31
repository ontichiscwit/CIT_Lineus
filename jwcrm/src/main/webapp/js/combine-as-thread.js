/* [AX Lab] 신규 파일 (2026-07-30): AS 통합화면 - 통합 타임라인 / 작성영역 / 모달 / 아코디언 / 과거이력
   ─────────────────────────────────────────────────────────────────────────────
   기존 combine-as.js(접두어 asws_)를 건드리지 않고 "추가"만 하는 파일이다.
   전역 접두어는 caws_ (Combine As WorkSpace thread) 로 통일한다.

   ★ 설계를 지배하는 제약 3가지
   ① 신규 URL 금지. MenuAuthFilter.isAccept() 가 세션 acceptUrlList 와 완전일치 비교만 하므로
      DB 메뉴권한에 없는 신규 /ad/as/*.do 는 무조건 403 이다.
      → 모든 신규 동작은 [기존 URL + 새 pageType] 으로 붙인다.
   ② 이관 전용 저장구조가 없다. CRM_AS_MGT_HIST 에 "이관 전 담당자"/"이관 코멘트" 컬럼이 없다.
      → ACTION_CONTENT 앞에 CAWS_TR_PREFIX 를 붙여 저장하고, 화면에서 떼어 표시한다.
        "이관 전 담당자"는 직전 이력행의 ACCEPTOR 로 유추한다. (caws_buildEvents 참고)
   ③ AI 연동 코드가 프로젝트에 0건. 화면만 만들고 호출부는 caws_aiPolish() 한 곳에 격리한다.

   ★ #asWorkspace 는 <form name="listFrm"> 안에 있다.
      그래서 이 화면이 새로 그리는 입력요소에는 name 을 주지 않는다(id 만 준다).
      name 을 주면 목록조회(listFrm.serialize())에 파라미터가 섞여 들어간다.
      단, 첨부파일 input 은 예외로 answerForm(멀티파트) 안에 name="uploadFileN" 으로 만든다.
   ───────────────────────────────────────────────────────────────────────────── */

/* ===== 상태 ===== */
var caws = {
	asNo:'', cnAsNo:'',
	vo:null, row:null,
	aws:[], hist:[], attach1:[], attach2:[],
	events:[],
	tab:'all',			/* 타임라인 필터탭 : all | talk | act | tr */
	ctab:'ans',			/* 작성영역 (고객 답변만 남음 — act 탭은 COL3 처리 패널로 이동) */
	fileSeq:0,			/* 첨부 슬롯 이름 채번용 (uploadFile{n}) */
	lb:{ list:[], idx:0 },
	past:{ quick:'1w', list:[] },
	emp:{ list:[], sel:'', selNm:'' },	/* 구 이관모달용 - 하위호환 유지 */
	act:{ empList:[], assignId:'', assignNm:'' },	/* 담당자 이관 팝오버 상태 */
	/* [AX Lab] 수정 시작 (2026-07-31 AX Lab): 필드 단위 클릭 즉시 수정(click-to-edit).
	   그룹 [편집] 버튼 → 폼 방식 대신, 값을 클릭하면 그 자리에서 바로 입력 컨트롤로 바뀐다.
	   fld = 현재 편집 중인 필드 키 (한 번에 한 필드만 편집).
	   ─ 단순 필드 : vo 필드명 그대로 (accept_route / rl_apply_nm / inportance / proc_dt ...)
	   ─ 특수 키   : 'systype'(시스템 대/소 쌍) / 'proc_status'(상태+메모 팝오버) / 'assign'(담당자+메모 팝오버) */
	fld: '',
	/* 접수처리정보 부가 데이터 — 원본 form.jsp 와 동일하게 별도 조회로 채운다 (caws_loadExtras 참고)
	   cnAsList  : 연관접수번호(하위작업) 목록  ← /ad/as/getCnAsList.do
	   custInfo  : 고객사 부가정보(HIS 진료/주소/연락처) ← /ad/member/getCustInfo2.do */
	cnAsList: [],
	custInfo: null,
	/* [AX Lab] 수정 끝 */
	ai:{ target:'', src:'', out:'', tone:'polite' }
};

/* 이관 코멘트 식별 접두어. AdAsController.ASWS_TRANSFER_PREFIX 와 반드시 같아야 한다. */
var CAWS_TR_PREFIX = '[이관] ';

/* 첨부 최대 개수. awsProc.do 는 uploadFile* 로 시작하는 파라미터를 모두 처리하므로 서버 제약은 아니고,
   화면에서 한 번에 올릴 수 있는 개수를 제한하는 값이다. */
var CAWS_MAX_FILES = 5;

var CAWS_IMG_EXT = ['jpg','jpeg','png','gif','bmp','webp','svg'];
var CAWS_PDF_EXT = ['pdf'];

/* COL3 아코디언 펼침상태 저장키 (asws_restoreListWide 와 동일한 sessionStorage 패턴) */
var CAWS_ACC_KEY = 'caws_acc_open';
/* 상세 넓게 보기 저장키 */
var CAWS_DW_KEY = 'caws_detail_wide';
/* 하단 작성영역 펼침상태 저장키. 기본은 "접힘" 이다 (타임라인 높이 확보) */
var CAWS_CP_KEY = 'caws_compose_open';

/* 게시판 종류 카탈로그.
   notice/form.jsp 의 본문 링크 규칙을 그대로 이식했다. (토큰 텍스트 / board_gbn / 상세 URL)
   ※ 공지사항만 본문에 적는 번호가 NOTICE_NUM 이라 SEQ 로 변환(getNoticenum.do)해야 이동된다.
     나머지 게시판은 본문 번호가 곧 SEQ 다. (notice/form.jsp faqlistDetail / noticelistDetail 비교) */
var CAWS_BOARDS = [
	{ gbn:'0000', token:'공지사항',   label:'공지사항',       url:'/ad/notice/form.do',   numConv:true,  exist:'/ad/board/getNoticeexist.do' },
	{ gbn:'0001', token:'상담사례',   label:'상담사례(FAQ)',  url:'/ad/faq/form.do',      numConv:false, exist:'/ad/board/getFaqexist.do' },
	{ gbn:'0002', token:'다운로드',   label:'다운로드',       url:'/ad/down/form.do',     numConv:false, exist:'/ad/board/getDownexist.do' },
	{ gbn:'0005', token:'마약류보고', label:'마약류보고',     url:'/ad/drugfaq/form.do',  numConv:false, exist:'/ad/board/getDrugfaqexist.do' },
	{ gbn:'0006', token:'동영상',     label:'동영상',         url:'/ad/videofaq/form.do', numConv:false, exist:'/ad/board/getVideofaqexist.do' }
];

/* ===== 유틸 ===== */
function caws_nvl(v, d){ return (v==null || typeof v=='undefined' || v==='') ? (typeof d=='undefined' ? '' : d) : v; }
function caws_esc(s){
	return String(caws_nvl(s,'')).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;').replace(/'/g,'&#39;');
}
function caws_el(id){ return document.getElementById(id); }
function caws_html(id, h){ var e = caws_el(id); if(e) e.innerHTML = h; }

/* 어떤 형식으로 내려와도 정렬 가능한 숫자키(yyyyMMddHHmmss)로 바꾼다.
   ★ CRM_AS_MGT_HIST.REG_DATE / CRM_AS_MGT_ANSWER.W_DATE 는 Oracle DATE 컬럼이고
     AsVO 의 필드는 String 이라, JDBC 드라이버가 주는 문자열 형식(NLS 의존)을 화면에서 확신할 수 없다.
     그래서 숫자만 뽑아 쓰고, 연도가 2자리로 오는 경우(26/07/30)에 대비해 '20' 을 앞에 붙인다.
     두 컬럼 모두 같은 경로로 변환되므로 상대적인 시간 순서는 형식과 무관하게 항상 맞다. */
function caws_ts(v){
	var s = String(caws_nvl(v,'')).replace(/[^0-9]/g,'');
	if(s === '') return 0;
	if(!/^(19|20)\d{2}/.test(s)) s = '20' + s;
	if(s.length > 14) s = s.substr(0,14);
	while(s.length < 14) s += '0';
	return Number(s);
}
/* 화면 표시용 : 2026-07-30 14:30 */
function caws_stamp(v){
	var raw = caws_nvl(v,'');
	var s = String(raw).replace(/[^0-9]/g,'');
	if(s === '') return '';
	if(!/^(19|20)\d{2}/.test(s)) s = '20' + s;
	if(s.length < 8) return raw;
	var out = s.substr(0,4)+'-'+s.substr(4,2)+'-'+s.substr(6,2);
	if(s.length >= 12) out += ' ' + s.substr(8,2)+':'+s.substr(10,2);
	return out;
}
/* yyyyMMdd -> yyyy-MM-dd */
function caws_date(v){
	var s = String(caws_nvl(v,'')).replace(/[^0-9]/g,'');
	if(s.length === 8) return s.substr(0,4)+'-'+s.substr(4,2)+'-'+s.substr(6,2);
	return caws_nvl(v,'-');
}
/* yyyyMMdd -> yyyy/MM/dd (datepicker 표시형식) */
function caws_dateSlash(v){
	var s = String(caws_nvl(v,'')).replace(/[^0-9]/g,'');
	if(s.length === 8) return s.substr(0,4)+'/'+s.substr(4,2)+'/'+s.substr(6,2);
	return '';
}
/* HHmm(ss) -> HH:mm */
function caws_time(v){
	var s = String(caws_nvl(v,'')).replace(/[^0-9]/g,'');
	if(s.length >= 4) return s.substr(0,2)+':'+s.substr(2,2);
	return '';
}
/* 오늘 기준 offset 일의 yyyy/MM/dd */
function caws_dayOffset(days){
	var d = new Date();
	d.setDate(d.getDate() + days);
	var m = ('0'+(d.getMonth()+1)).slice(-2), dd = ('0'+d.getDate()).slice(-2);
	return d.getFullYear()+'/'+m+'/'+dd;
}
function caws_ext(nm){
	nm = String(caws_nvl(nm,''));
	var i = nm.lastIndexOf('.');
	return (i < 0) ? '' : nm.substr(i+1).toLowerCase();
}
function caws_isImg(nm){ return CAWS_IMG_EXT.indexOf(caws_ext(nm)) >= 0; }
function caws_isPdf(nm){ return CAWS_PDF_EXT.indexOf(caws_ext(nm)) >= 0; }

/* 첨부 정적 URL. CRM_ATTACH_MGT.ATTACH_PATH 가 웹 상대경로(/upload/...)라 별도 API 없이 바로 참조한다.
   (같은 방식의 선례: fr/videofaq/form.jsp 의 <video src="'+attach_path+attach_save_nm+'">)
   경로가 환경에 따라 서비스되지 않을 수도 있어 미리보기에는 onerror 대체표시를 반드시 함께 둔다. */
function caws_fileUrl(f){
	var p = caws_nvl(f.attach_path, caws_nvl(f.ATTACH_PATH,''));
	var n = caws_nvl(f.attach_save_nm, caws_nvl(f.ATTACH_SAVE_NM,''));
	if(p === '' || n === '') return '';
	if(p.charAt(p.length-1) !== '/') p += '/';
	return encodeURI(p + n);
}
function caws_fileNm(f){ return caws_nvl(f.attach_ori_nm, caws_nvl(f.ATTACH_ORI_NM,'첨부파일')); }
function caws_fileSeq(f){ return caws_nvl(f.attach_seq, caws_nvl(f.ATTACH_SEQ,'0')); }
function caws_fileOrd(f){ return caws_nvl(f.attach_ord, caws_nvl(f.ATTACH_ORD,'0')); }

/* ===== 진입점 : getAsInfo.do 응답 렌더 =====
   combine-as.js 의 asws_renderDetailRecord() 가 이 함수로 위임한다.
   응답에는 resultVO / attachList(접수첨부) / attachList2(처리첨부) / awsList(답변) / asHistList(조치이력) 가 있다.
   (awsList 와 조치이력 첨부는 AdAsController.getAsInfo 에서 동봉하도록 확장했다) */
function caws_renderAll(data){
	data = data || {};
	caws.asNo   = caws_nvl(asws.asNo,'');
	caws.cnAsNo = caws_nvl(asws.cnAsNo,'');
	caws.vo     = data.resultVO || {};
	caws.row    = (typeof asws != 'undefined' && asws.curRow) ? asws.curRow : {};
	caws.aws    = data.awsList || [];
	caws.hist   = data.asHistList || [];
	caws.attach1 = data.attachList  || [];
	caws.attach2 = data.attachList2 || [];
	caws.act.empList = [];		/* 담당자 이관 팝오버 목록은 건마다 새로 로드 */
	caws.fld = '';				/* [AX Lab] 수정 (2026-07-31 AX Lab): 필드 편집상태는 건이 바뀌면 항상 초기화 */

	caws.events = caws_buildEvents();

	/* [AX Lab] 수정 (2026-07-31 AX Lab): 연관접수번호/고객사 부가정보를 렌더 전에 조회.
	   common.ajaxCall 이 동기(async:false)라 caws_renderRecord 시점에는 데이터가 채워져 있다. */
	caws_loadExtras();

	caws_renderHead();
	caws_renderTimeline();
	caws_renderCompose();
	caws_renderRecord();
	caws_pastReset();
}

/* =============================================================================
 * [AX Lab] 신규 (2026-07-31 AX Lab): 접수처리정보 부가 데이터 조회
 * -----------------------------------------------------------------------------
 * 원본 form.jsp(makeInitView)도 getAsInfo 외에 아래 두 조회를 따로 호출해서 채운다.
 *  ① 연관접수번호(하위작업) 목록 : /ad/as/getCnAsList.do
 *     - 하위 건을 보고 있으면 부모(cn_as_no) 기준으로 형제 목록을 가져온다(form.jsp 동일).
 *  ② 고객사 부가정보(HIS 진료/주소/우편번호/연락처) : /ad/member/getCustInfo2.do
 *     - CRM_AS_MGT 에는 없는 CRM_CUST_MGT 쪽 값이라 getAsInfo 로는 못 가져온다.
 * 두 URL 모두 form.jsp 가 쓰던 기존 URL 재사용이라 신규 권한 등록이 필요 없다.
 * ========================================================================== */
function caws_loadExtras(){
	caws.cnAsList = [];
	caws.custInfo = null;
	if(caws_nvl(caws.asNo,'') === '') return;

	var vo = caws.vo || {};
	var parentNo = caws_nvl(vo.cn_as_no, caws_nvl(caws.cnAsNo, caws.asNo));
	common.ajaxCall({ as_no: parentNo }, '/ad/as/getCnAsList.do', 'caws_cnAsReturn');

	var custCode = caws_nvl(vo.cust_code,'');
	if(custCode !== '') common.ajaxCall({ cust_code: custCode }, '/ad/member/getCustInfo2.do', 'caws_custInfoReturn');
}
function caws_cnAsReturn(data){
	caws.cnAsList = (data && data.resultList) ? data.resultList : [];
}
function caws_custInfoReturn(data){
	caws.custInfo = (data && data.resultVO) ? data.resultVO : null;
}

/* '하위작업 생성' — 원본(form.jsp btnInitCnAs)과 동일하게 하위작업 작성 화면으로 이동한다 */
function caws_subCreate(){
	if(caws_nvl(caws.asNo,'') === '') return;
	if(!confirm('하위작업을 생성하시겠습니까?\n하위작업 작성 화면(전체 상세 페이지)으로 이동합니다.')) return;
	location.href = '/ad/as/form.do?pageType=subInsert&as_no='+encodeURIComponent(caws.asNo);
}

/* 연관접수번호 select 에서 고른 건을 페이지 이동 없이 이 화면(COL2/COL3)으로 갈아끼운다 */
function caws_cnAsOpen(){
	var sel = caws_el('cawsCnAsSel');
	var no = sel ? String(sel.value||'') : '';
	if(no === ''){ alert('연관접수번호를 선택해주세요.'); return; }
	var cn = '';
	for(var i=0; i<(caws.cnAsList||[]).length; i++){
		if(caws_nvl(caws.cnAsList[i].as_no,'') === no){ cn = caws_nvl(caws.cnAsList[i].cn_as_no,''); break; }
	}
	asws_openDetail(no, cn);
}

/* 선택 해제/조회 0건일 때 3영역을 한 번에 비운다. (list.jsp setAsList 에서 호출) */
function caws_clear(msg){
	msg = caws_nvl(msg,'왼쪽 목록에서 접수건을 선택하세요.');
	caws.asNo = ''; caws.events = [];
	caws_html('asDetailHead','');
	caws_html('asDetail','<div class="empty">'+caws_esc(msg)+'</div>');
	caws_html('asCompose','');
	caws_html('asRecord','<div class="none" style="padding:14px">'+caws_esc(msg)+'</div>');
	caws_clearFiles();
}

/* =============================================================================
 * 1) 타임라인 데이터 머지  (문의 / 고객답변 / 직원답변 / 조치이력 / 이관)
 * -----------------------------------------------------------------------------
 * ★ 이관 이벤트 어댑터는 이 함수 한 곳에만 있다.
 *   추후 CRM_AS_MGT_HIST 에 HIST_TYPE / FROM_ASSIGN_ID / TRANSFER_COMMENT 컬럼이 추가되면
 *   아래 "이관 감지" 블록만 그 컬럼을 읽도록 바꾸면 되고 렌더 코드는 손대지 않아도 된다.
 * ========================================================================== */
function caws_buildEvents(){
	var vo = caws.vo || {}, row = caws.row || {}, out = [];
	var ord = 0;

	/* --- 문의(최초) : CRM_AS_MGT.CALL_CONTENT --- */
	var acceptDt = caws_nvl(vo.accept_dt, caws_nvl(row.accept_dt,''));
	var acceptTm = caws_nvl(vo.accept_time,'');
	var custNm   = caws_nvl(row.cust_kor_name, caws_nvl(vo.cust_kor_name,''));
	var applyNm  = caws_nvl(vo.apply_nm, caws_nvl(vo.rl_apply_nm,''));
	out.push({
		kind:'q', grp:'talk', ord:ord++,
		ts:   caws_ts(acceptDt + acceptTm),
		who:  applyNm || '고객',
		sub:  custNm,
		when: caws_date(acceptDt) + (caws_time(acceptTm) ? ' ' + caws_time(acceptTm) : ''),
		text: caws_nvl(vo.call_content, caws_nvl(row.call_content,'')),
		files: caws.attach1
	});

	/* --- 답변 : CRM_AS_MGT_ANSWER (W_GUBUN U=고객 / A=직원) --- */
	for(var i=0; i<caws.aws.length; i++){
		var a = caws.aws[i];
		var isCust = (caws_nvl(a.w_gubun,'') === 'U');
		out.push({
			kind: isCust ? 'cust' : 'staff', grp:'talk', ord:ord++,
			ts:   caws_ts(a.w_date),
			who:  caws_nvl(a.emp_nm,'') || (isCust ? '고객' : '담당자'),
			when: caws_stamp(a.w_date),
			/* getAwsList 쿼리는 W_CONTENT 를 가공 없이 주므로 줄바꿈을 그대로 살려 pre-line 으로 표시한다. */
			text: caws_nvl(a.w_content,''),
			files: (a.amap && a.amap.attachList) ? a.amap.attachList : []
		});
	}

	/* --- 조치이력 + 이관 감지 : CRM_AS_MGT_HIST ---
	   getAsHistList 는 SEQ DESC 로 내려오므로, 이관 감지를 위해 SEQ 오름차순(=시간 오름차순)으로 다시 정렬한다.
	   SEQ 는 MAX_AS_HIST_NO 시퀀스라 단조증가하므로 REG_DATE 형식과 무관하게 순서가 정확하다. */
	var hist = caws.hist.slice(0).sort(function(x, y){
		return Number(caws_nvl(x.seq,0)) - Number(caws_nvl(y.seq,0));
	});

	var prevAcc = null, prevAccNm = '';
	for(var h=0; h<hist.length; h++){
		var hi   = hist[h];
		var acc  = caws_nvl(hi.acceptor,'');
		var accNm = caws_nvl(hi.emp_nm,'');
		var raw  = caws_nvl(hi.action_content,'');
		var ts   = caws_ts(hi.reg_date);
		var files = (hi.amap && hi.amap.attachList) ? hi.amap.attachList : [];

		/* 이관 코멘트 접두어 판별 */
		var hasPrefix = (raw.indexOf(CAWS_TR_PREFIX) === 0);
		var comment   = hasPrefix ? raw.substr(CAWS_TR_PREFIX.length) : raw;

		/* 인수자(ACCEPTOR)가 직전 이력행과 달라졌으면 그 사이에 이관이 있었다는 뜻.
		   첫 행은 비교대상이 없으므로 "최초 배정"으로 보고 이관으로 취급하지 않는다. */
		var moved = (prevAcc !== null && acc !== prevAcc);

		if(moved){
			out.push({
				kind:'tr', grp:'tr', ord:ord++,
				ts: ts,
				from: prevAccNm || prevAcc || '(미지정)',
				to:   accNm || acc || '(미지정)',
				when: caws_stamp(hi.reg_date),
				by:   caws_nvl(hi.reg_nm,''),
				/* 접두어가 없는 과거 데이터는 코멘트를 이관 코멘트로 단정할 수 없으므로 담당자 변경 사실만 표시한다. */
				text: hasPrefix ? comment : ''
			});
		}

		/* 접두어가 붙은 이관 전용 행은 위 이관 라인으로 이미 표현했으므로 조치 카드를 중복 생성하지 않는다. */
		if(!(moved && hasPrefix)){
			out.push({
				kind:'act', grp:'act', ord:ord++,
				ts: ts,
				who:  caws_nvl(hi.reg_nm,'-'),
				when: caws_stamp(hi.reg_date),
				procDt: caws_date(hi.proc_dt),
				acceptor: accNm || acc,
				status: caws_nvl(hi.proc_status_nm,''),
				/* getAsHistList 의 INPORTANCE 는 코드가 아니라 CODE_NAME 이 담겨 온다(쿼리 서브쿼리 별칭) */
				grade: caws_nvl(hi.inportance,''),
				text: comment,
				files: files,
				seq: caws_nvl(hi.seq,'')
			});
		}

		prevAcc = acc; prevAccNm = accNm;
	}

	/* 시간 오름차순. 같은 시각이면 만든 순서(ord)를 유지해 안정 정렬이 되게 한다.
	   (Array.prototype.sort 는 구형 엔진에서 불안정 정렬이라 ord 비교가 필요하다) */
	out.sort(function(x, y){ return (x.ts - y.ts) || (x.ord - y.ord); });
	return out;
}

function caws_counts(){
	var c = { all:0, talk:0, act:0, tr:0 };
	for(var i=0; i<caws.events.length; i++){
		c.all++;
		c[caws.events[i].grp]++;
	}
	return c;
}

/* =============================================================================
 * 2) COL2 고정 헤더 + 액션바 + 필터탭
 * ========================================================================== */
/* 목록행(row)이 없을 때도 헤더/상세가 '-' 로만 보이지 않도록 값을 단계적으로 찾는다.
   ★ row 가 비는 경우: 과거 상담이력에서 목록(COL1)에 없는 건을 클릭했을 때.
     이때는 getAsInfo 응답(vo)의 코드값을 공통코드 명칭으로 직접 변환해 쓴다. */
function caws_stCode(){ return caws_nvl((caws.row||{}).proc_status, caws_nvl((caws.vo||{}).proc_status,'')); }
function caws_stNm(){
	var row = caws.row || {};
	if(caws_nvl(row.proc_status_nm,'') !== '') return row.proc_status_nm;
	return caws_codeNm('AS','CD01', caws_stCode());
}
function caws_gradeCode(){ return caws_nvl((caws.row||{}).inportance, caws_nvl((caws.vo||{}).inportance,'')); }
function caws_gradeNm(){
	var row = caws.row || {};
	if(caws_nvl(row.inportance_nm,'') !== '') return row.inportance_nm;
	return caws_codeNm('AS','CD04', caws_gradeCode());
}
/* 담당자명 : 목록행에는 emp_nm, getAsInfo 에는 assign_nm 으로 온다. */
function caws_empNm(){ return caws_nvl((caws.row||{}).emp_nm, caws_nvl((caws.vo||{}).assign_nm,'-')); }

function caws_renderHead(){
	var vo = caws.vo || {}, row = caws.row || {};
	var stCode = caws_stCode();
	var stNm   = caws_stNm();
	var custNm = caws_nvl(row.cust_kor_name, caws_nvl(vo.cust_kor_name,'-'));
	var applyNm = caws_nvl(vo.apply_nm, caws_nvl(vo.rl_apply_nm,'-'));
	var acceptDt = caws_nvl(vo.accept_dt, caws_nvl(row.accept_dt,''));
	var acceptTm = caws_time(caws_nvl(vo.accept_time,''));
	var gradeNm = caws_gradeNm();
	if(gradeNm === '-') gradeNm = '';			/* 중요도 미지정이면 칩을 아예 그리지 않는다 */
	var gradeCls = (caws_gradeCode() === 'C001') ? 'grade emc' : 'grade';
	var empNm = caws_empNm();
	var c = caws_counts();

	var h = ''
	+ '<div class="caws-h1">'
	+   '<div class="caws-h1l">'
	+     '<div class="caws-title" title="'+caws_esc(custNm)+'">'+caws_esc(caws.asNo)+' · '+caws_esc(custNm)+'</div>'
	+     '<div class="caws-meta">신청자 '+caws_esc(applyNm)+' · 접수 '+caws_esc(caws_date(acceptDt))+(acceptTm ? ' '+caws_esc(acceptTm) : '')+' · 담당 '+caws_esc(empNm)+'</div>'
	+   '</div>'
	+   '<div class="caws-hbadge">'
	+     (gradeNm ? '<span class="'+gradeCls+'" title="중요도">'+caws_esc(gradeNm)+'</span>' : '')
	+     '<span class="st '+asws_stClass(stCode)+'">'+caws_esc(stNm)+'</span>'
	+   '</div>'
	+ '</div>'
	+ '<div class="caws-acts">'
	+   '<button type="button" class="btn-s primary" onclick="caws_focusAct();" title="조치내용(처리 이력)을 작성합니다. 처리상태를 함께 바꿀 수도 있습니다">처리 작성</button>'
	+   '<div class="caws-sp"></div>'
	+   '<button type="button" class="btn-s" onclick="asws_openFull();" title="접수처리정보의 값은 오른쪽 패널에서 클릭해 바로 수정할 수 있고, 그 외 항목은 전체 상세 페이지에서 수정합니다">전체 상세 페이지</button>'
	+ '</div>'
	+ '<div class="caws-tabs">'
	+   caws_tabBtn('all',  '전체',      c.all)
	+   caws_tabBtn('talk', '문의·답변', c.talk)
	+   caws_tabBtn('act',  '조치',      c.act)
	+   caws_tabBtn('tr',   '이관',      c.tr)
	+ '</div>';

	caws_html('asDetailHead', h);
}

function caws_tabBtn(key, label, cnt){
	return '<button type="button" class="caws-tab'+(caws.tab===key ? ' on' : '')+'" onclick="caws_tab(\''+key+'\');">'
	     + caws_esc(label) + '<b>' + Number(cnt||0) + '</b></button>';
}

/* 탭 전환은 재조회 없이 CSS 클래스로 show/hide 만 한다. */
function caws_tab(key){
	caws.tab = key;
	var tabs = document.querySelectorAll('#asDetailHead .caws-tab');
	for(var i=0; i<tabs.length; i++) tabs[i].classList.remove('on');
	var idx = ['all','talk','act','tr'].indexOf(key);
	if(idx >= 0 && tabs[idx]) tabs[idx].classList.add('on');

	var evs = document.querySelectorAll('#asDetail .caws-ev');
	for(var j=0; j<evs.length; j++){
		var g = evs[j].getAttribute('data-grp');
		evs[j].classList.toggle('hide', !(key === 'all' || key === g));
	}
	caws_syncEmpty();
}

/* 필터 결과가 0건이면 안내문을 보여준다. */
function caws_syncEmpty(){
	var box = caws_el('asDetail');
	if(!box) return;
	var vis = box.querySelectorAll('.caws-ev:not(.hide)').length;
	var msg = caws_el('cawsTlEmpty');
	if(msg) msg.style.display = (vis === 0) ? 'block' : 'none';
}

/* =============================================================================
 * 3) COL2 통합 타임라인 렌더
 * ========================================================================== */
function caws_renderTimeline(){
	if(!caws.events.length){
		caws_html('asDetail', '<div class="empty">표시할 내용이 없습니다.</div>');
		return;
	}

	/* 문의(kind:'q') → AI 추천 → 나머지(조치/답변/이관) 순으로 단일 스크롤 영역에 표시.
	   모두 같은 #asDetail 안에서 위에서 아래로 스크롤해 읽는다. */
	var s = '<div class="caws-tl">';
	var aiDone = false;
	for(var i=0; i<caws.events.length; i++){
		s += caws_evHtml(caws.events[i], i);
		if(!aiDone && caws.events[i].kind === 'q'){ s += caws_aiHintHtml(); aiDone = true; }
	}
	/* CALL_CONTENT 가 비어 문의 이벤트가 없는 예외 데이터에도 AI 블록은 표시한다 */
	if(!aiDone) s += caws_aiHintHtml();
	s += '</div>'
	  +  '<div class="caws-pempty" id="cawsTlEmpty" style="display:none;">이 탭에 해당하는 내용이 없습니다.</div>';
	caws_html('asDetail', s);

	caws_tab(caws.tab);
	/* 최신 글이 보이도록 히스토리 영역을 맨 아래로 */
	var box = caws_el('asDetail');
	if(box) box.scrollTop = box.scrollHeight;
}

/* 문의 고정 구간(#asDetailInq) 아래에 붙는 'AI 추천' 안내 블록.
   스타일은 combine-as.css 393~397행 .aiblock 그대로 쓴다.
   ★ 필터탭(전체/문의·답변/조치/이관)의 show/hide 는 #asDetail 안의 .caws-ev 에만 적용되므로
     이 블록은 어떤 탭에서도 항상 보인다.
   ※ 실제 AI 기능이 붙으면 여기에 [유사 사례 / 관련 공지 / 답변 초안] 목록을 렌더하면 된다.
     작성 중 문장을 다듬는 기능은 이미 작성영역 툴바의 caws_aiPolish() 로 분리돼 있다. */
function caws_aiHintHtml(){
	return '<div class="aiblock">'
	     +   '<div class="ahd">AI 추천 <span class="soon">추후 제공</span></div>'
	     +   '<div class="adesc">유사 사례 · 관련 공지 · 운영정보 요약 · 답변 초안 기능이 이 영역에 제공될 예정입니다.<br>'
	     +     '작성 중인 문장 다듬기는 아래 작성영역의 [AI 문장 다듬기] 버튼에서 미리 사용해볼 수 있습니다.</div>'
	     + '</div>';
}

function caws_evHtml(ev, idx){
	if(ev.kind === 'tr') return caws_trHtml(ev, idx);

	/* 정렬 : 문의·고객답변은 좌측, 직원답변은 우측, 조치는 전체폭 */
	var align = (ev.kind === 'staff') ? 'al-r' : (ev.kind === 'act' ? 'al-c' : 'al-l');
	var label = { q:'문의', cust:'고객 답변', staff:'답변(고객 노출)', act:'조치' }[ev.kind];

	var s = '<div class="caws-ev t-'+ev.kind+' '+align+'" data-grp="'+ev.grp+'"><div class="caws-bub">'
	      + '<div class="caws-bhd">'
	      + '<span class="caws-blabel">'+caws_esc(label)+'</span>'
	      + (ev.kind === 'act' ? '<span class="caws-blabel" title="고객에게 보이지 않는 내부 기록입니다">내부용</span>' : '')
	      + '<span class="caws-bname">'+caws_esc(caws_nvl(ev.who,'-'))+'</span>'
	      + (ev.sub ? '<span class="caws-btime" style="margin-left:0;">'+caws_esc(ev.sub)+'</span>' : '')
	      + '<span class="caws-btime">'+caws_esc(caws_nvl(ev.when,''))+'</span>'
	      /* [AX Lab] 수정 시작 (2026-07-31 AX Lab): 요청내용(call_content) 수정을 COL3 접수처리정보에서
	         이 문의 버블로 이동. (접수처리정보 영역에서는 요청내용을 더 이상 표시하지 않는다) */
	      + (ev.kind === 'q' && caws_nvl(caws.asNo,'') !== ''
	          ? '<button type="button" class="caws-minib" onclick="caws_qEdit();" title="요청내용을 이 자리에서 바로 수정합니다">수정</button>' : '')
	      /* [AX Lab] 수정 끝 */
	      + '</div>';

	/* 조치이력 메타 : 처리일자 / 인수자 / 처리상태 / 중요도 */
	if(ev.kind === 'act'){
		var kv = '';
		if(ev.procDt   && ev.procDt !== '-') kv += '<span class="caws-kvi">처리일자<b>'+caws_esc(ev.procDt)+'</b></span>';
		if(ev.acceptor)                      kv += '<span class="caws-kvi">인수자<b>'+caws_esc(ev.acceptor)+'</b></span>';
		if(ev.status)                        kv += '<span class="caws-kvi">처리상태<b>'+caws_esc(ev.status)+'</b></span>';
		if(ev.grade)                         kv += '<span class="caws-kvi">중요도<b>'+caws_esc(ev.grade)+'</b></span>';
		if(kv) s += '<div class="caws-kvs">'+kv+'</div>';
	}

	var body = caws_nvl(ev.text,'');
	/* [AX Lab] 수정 (2026-07-31 AX Lab): 문의 버블 본문에는 인라인 수정(caws_qEdit)이 갈아끼울 id 를 준다 */
	s += '<div class="caws-btxt"'+(ev.kind === 'q' ? ' id="cawsQBody"' : '')+'>'+(body ? caws_linkify(body) : '<span class="none">내용 없음</span>')+'</div>'
	  +  caws_filesHtml(ev.files, idx)
	  +  '</div></div>';
	return s;
}

/* [AX Lab] 수정 시작 (2026-07-31 AX Lab): 문의(요청내용) 버블 인라인 수정.
   접수처리정보(COL3)의 요청내용 행을 없애면서, 가운데 타임라인의 문의 버블에서 직접 고치게 한다.
   저장은 COL3 필드수정과 동일한 histProc.do(pageType=saveInquiry)를 쓰되,
   문의유형/시스템유형은 현재 값을 그대로 실어 요청내용만 바뀌게 한다. */
function caws_qEdit(){
	var box = caws_el('cawsQBody');
	if(!box || caws_el('cawsQTa')) return;		/* 이미 편집 중이면 무시 */
	box.innerHTML = '<textarea id="cawsQTa" class="caws-ta caws-fta" oninput="caws_autoGrow(this);"'
	 + ' onkeydown="if(event.keyCode===27)caws_qCancel();"></textarea>'
	 + '<div class="caws-cbar" style="margin-top:6px;">'
	 +   '<button type="button" class="btn-s" onclick="caws_qCancel();">취소</button>'
	 +   '<span class="caws-sp"></span>'
	 +   '<button type="button" class="caws-send act" onclick="caws_qSave();">저장</button>'
	 + '</div>';
	var ta = caws_el('cawsQTa');
	if(ta){
		/* innerHTML 주입 대신 value 로 넣어 따옴표/태그 escape 문제를 원천 차단한다 */
		ta.value = caws_nvl((caws.vo||{}).call_content,'');
		caws_autoGrow(ta);
		try{ ta.focus(); }catch(e){}
	}
}
function caws_qCancel(){ caws_renderTimeline(); }
function caws_qSave(){
	var ta = caws_el('cawsQTa');
	if(!ta) return;
	var v = String(ta.value||'').trim();
	if(v === ''){ alert('요청내용을 입력해주세요.'); ta.focus(); return; }
	var vo = caws.vo || {};
	if(v === caws_nvl(vo.call_content,'')){ caws_qCancel(); return; }	/* 미변경 = 조용히 닫기 */
	common.ajaxCall({
		as_no: caws.asNo,
		pageType: 'saveInquiry',
		request_type: caws_nvl(vo.request_type,''),
		service_cate: caws_nvl(vo.service_cate,''),
		inquiry_type: caws_nvl(vo.inquiry_type,''),
		call_content: v
	}, '/ad/as/histProc.do', 'caws_fldReturn');
}
/* [AX Lab] 수정 끝 */

/* 이관 : 버블이 아닌 얇은 시스템 라인 (홍길동 → 김철수 + 코멘트) */
function caws_trHtml(ev, idx){
	var s = '<div class="caws-ev t-tr al-c" data-grp="tr"><div class="caws-bub">'
	      + '<div class="caws-trhd">'
	      + '<span class="caws-trico">&#8644;</span>담당자 이관'
	      + '<span class="caws-trwho">'+caws_esc(ev.from)+'</span>'
	      + '<span class="caws-trar">&rarr;</span>'
	      + '<span class="caws-trwho">'+caws_esc(ev.to)+'</span>'
	      + (ev.by ? '<span class="caws-btime" style="margin-left:0;">처리 '+caws_esc(ev.by)+'</span>' : '')
	      + '<span class="caws-btime">'+caws_esc(caws_nvl(ev.when,''))+'</span>'
	      + '</div>';
	if(caws_nvl(ev.text,'') !== '') s += '<div class="caws-trcm">'+caws_linkify(ev.text)+'</div>';
	s += '</div></div>';
	return s;
}

/* 본문의 게시물 토큰(예: 공지사항(12345))을 클릭 가능한 링크로 바꾼다.
   ※ 반드시 escape 를 먼저 해서 본문의 <,> 가 태그로 해석되지 않게 한 뒤 링크만 주입한다. */
function caws_linkify(text){
	var out = caws_esc(text);
	for(var i=0; i<CAWS_BOARDS.length; i++){
		var b = CAWS_BOARDS[i];
		var re = new RegExp(b.token + '\\((\\d+)\\)', 'g');
		out = out.replace(re, (function(bb){
			return function(m, num){
				return '<span class="caws-bl" title="'+bb.label+' '+num+'번 게시물을 새 창으로 엽니다" '
				     + 'onclick="caws_goBoard(\''+bb.gbn+'\',\''+num+'\');">'+bb.token+'('+num+')</span>';
			};
		})(b));
	}
	return out;
}

/* =============================================================================
 * 4) 첨부 chip + 라이트박스 미리보기
 * ========================================================================== */
function caws_filesHtml(files, evIdx){
	if(!files || !files.length) return '';
	var s = '<div class="caws-files">';
	for(var i=0; i<files.length; i++){
		var f = files[i];
		var nm = caws_fileNm(f);
		var ext = caws_ext(nm) || 'file';
		var can = (caws_isImg(nm) || caws_isPdf(nm)) && caws_fileUrl(f) !== '';
		s += '<span class="caws-file">'
		  +    '<span class="caws-fext">'+caws_esc(ext)+'</span>'
		  +    '<span class="caws-fnm" title="'+caws_esc(nm)+'">'+caws_esc(nm)+'</span>'
		  +    (can
		        ? '<button type="button" class="caws-fbtn" onclick="caws_preview('+evIdx+','+i+');">미리보기</button>'
		        : '<button type="button" class="caws-fbtn" disabled title="이 확장자는 브라우저에서 미리볼 수 없습니다">미리보기</button>')
		  +    '<button type="button" class="caws-fbtn dl" onclick="fileDown(\''+caws_fileSeq(f)+'\',\''+caws_fileOrd(f)+'\');">다운로드</button>'
		  +  '</span>';
	}
	return s + '</div>';
}

/* 같은 버블의 미리보기 가능한 첨부만 모아 라이트박스 목록으로 쓴다(좌우 이동 대상). */
function caws_preview(evIdx, fileIdx){
	var ev = caws.events[evIdx];
	if(!ev || !ev.files) return;

	var list = [], start = 0;
	for(var i=0; i<ev.files.length; i++){
		var f = ev.files[i];
		var nm = caws_fileNm(f);
		if(!(caws_isImg(nm) || caws_isPdf(nm))) continue;
		if(caws_fileUrl(f) === '') continue;
		if(i === fileIdx) start = list.length;
		list.push({ nm:nm, url:caws_fileUrl(f), seq:caws_fileSeq(f), ord:caws_fileOrd(f) });
	}
	if(!list.length){ alert('미리볼 수 있는 첨부가 없습니다.'); return; }

	caws.lb.list = list;
	caws.lb.idx = start;
	caws_lbShow();
	caws_openModal('cawsLb');
}

function caws_lbShow(){
	var it = caws.lb.list[caws.lb.idx];
	if(!it) return;
	var body = '';
	if(caws_isPdf(it.nm)){
		body = '<iframe src="'+it.url+'"></iframe>';
	}else{
		/* 정적 경로(/upload/...)가 서비스되지 않는 환경(업로드 물리경로가 웹루트 밖)에 대비해
		   onerror 로 안내문으로 바꾼다. 인라인에 긴 HTML 문자열을 넣으면 따옴표 이스케이프가
		   깨지기 쉬워 함수 호출(caws_lbFail)로 분리했다. */
		body = '<img src="'+it.url+'" alt="'+caws_esc(it.nm)+'" onerror="caws_lbFail();" />';
	}
	caws_html('cawsLbBody', body);
	caws_html('cawsLbNm', caws_esc(it.nm));
	caws_html('cawsLbPos', (caws.lb.idx+1) + ' / ' + caws.lb.list.length);
	var pv = caws_el('cawsLbPrev'), nx = caws_el('cawsLbNext');
	if(pv) pv.disabled = (caws.lb.idx <= 0);
	if(nx) nx.disabled = (caws.lb.idx >= caws.lb.list.length - 1);
}
/* 미리보기 실패(정적경로 미서비스 / 파일 없음) 시 안내로 대체. 다운로드는 계속 가능하다. */
function caws_lbFail(){
	caws_html('cawsLbBody', '<div class="caws-lbmsg">이 첨부는 브라우저에서 직접 열 수 없습니다.<br>아래 [다운로드] 버튼을 이용해주세요.</div>');
}
function caws_lbMove(d){
	var n = caws.lb.idx + d;
	if(n < 0 || n >= caws.lb.list.length) return;
	caws.lb.idx = n;
	caws_lbShow();
}
function caws_lbDown(){
	var it = caws.lb.list[caws.lb.idx];
	if(it) fileDown(it.seq, it.ord);
}

/* =============================================================================
 * 5) COL2 하단 작성영역 (고객 답변 전용)
 * -----------------------------------------------------------------------------
 * '처리' 탭(처리상태·담당자·조치메모)은 COL3 처리상태사항의 클릭 팝오버로 이동됐다.
 * (caws_fldOpen('proc_status') / caws_popStatusSave 참고)
 * ========================================================================== */
function caws_renderCompose(){
	var open = caws_composeOpen();
	var h = ''
	+ '<div class="caws-ctabs">'
	+   '<span class="caws-ctab on" style="cursor:default; pointer-events:none;">고객 답변</span>'
	+   '<span class="caws-cdraft" id="cawsDraftTag">작성 중</span>'
	+   '<div class="caws-sp"></div>'
	+   '<button type="button" class="caws-cfold" id="cawsFoldBtn" onclick="caws_toggleCompose();" '
	+     'title="작성영역을 접으면 그만큼 위쪽 타임라인이 넓어집니다">'
	+     '<span class="caws-cchev">&#9662;</span><span id="cawsFoldTxt">'+(open ? '접기' : '작성하기')+'</span>'
	+   '</button>'
	+ '</div>'
	+ '<div class="caws-cbody">'
	+   '<div class="caws-cnote ans">이 글은 고객에게 그대로 노출됩니다.</div>'
	+   '<div class="caws-tools">'
	+     '<button type="button" class="btn-s" onclick="caws_openAi();" title="작성 중인 문장을 다듬습니다">AI 문장 다듬기</button>'
	+     '<button type="button" class="btn-s" onclick="caws_openLink();" title="본문에 게시물 링크를 삽입합니다">게시물 링크</button>'
	+     '<button type="button" class="btn-s" onclick="caws_pickFile();" title="파일을 선택합니다 (최대 '+CAWS_MAX_FILES+'개)">파일 첨부</button>'
	+     '<div class="caws-sp"></div>'
	+   '</div>'
	+   '<div class="caws-drop" id="cawsDrop">'
	+     '<textarea class="caws-ta" id="cawsText" oninput="caws_autoGrow(this);" placeholder="고객에게 보낼 답변 내용을 입력하세요. 파일을 이 영역에 끌어다 놓으면 첨부됩니다."></textarea>'
	+   '</div>'
	+   '<div class="caws-thumbs" id="cawsThumbs"></div>'
	+   '<div class="caws-cbar">'
	+     '<span class="caws-chint">등록 시 고객에게 알림이 발송될 수 있습니다.</span>'
	+     '<button type="button" class="caws-send" onclick="caws_send();">답변 등록</button>'
	+   '</div>'
	+ '</div>';

	caws_html('asCompose', h);
	var comp = caws_el('asCompose');
	if(comp) comp.classList.toggle('off', !open);
	caws_bindDrop();
	caws_renderThumbs();
}

/* ---- 담당자 검색 (담당자 이관 팝오버에서 사용) ---------------------------- */
function caws_actEmpLoaded(data){
	caws.act.empList = (data && data.resultList) ? data.resultList : [];
	caws_actEmpFilter();
}
function caws_actEmpFilter(){
	var kwEl = caws_el('cawsActEmpKw');
	var kw = kwEl ? String(kwEl.value||'').trim() : '';
	var list = caws_el('cawsActEmpList');
	if(!list) return;
	var curId = caws_nvl((caws.vo||{}).assign_id, caws_nvl((caws.row||{}).assign_id,''));
	var s = '', n = 0;
	for(var i=0; i<caws.act.empList.length; i++){
		var e = caws.act.empList[i];
		var no = caws_nvl(e.emp_no,''), nm = caws_nvl(e.emp_nm,'');
		if(kw !== '' && nm.indexOf(kw) < 0 && no.indexOf(kw) < 0) continue;
		n++;
		/* ★ 이름을 onclick 인자로 넘기지 않는 이유: esc 된 &#39; 가 HTML 파싱 후 ' 로 복원되어 스크립트가 깨진다. */
		s += '<button type="button" class="caws-empit'+(caws.act.assignId === no ? ' on' : '')+'" '
		  +  'onclick="caws_actSelEmp(\''+caws_esc(no)+'\');">'
		  +  '<span class="caws-enm">'+caws_esc(nm)+'</span>'
		  +  '<span class="caws-edp">'+caws_esc(no)+'</span>'
		  +  (no === curId ? '<span class="caws-ecur">현재 담당</span>' : '')
		  +  '</button>';
	}
	if(n === 0) s = '<div class="caws-pempty">'+(kw !== '' ? '검색 결과 없음' : '담당 가능한 직원 없음')+'</div>';
	list.innerHTML = s;
}
function caws_actSelEmp(no){
	for(var i=0; i<caws.act.empList.length; i++){
		if(caws.act.empList[i].emp_no === no){
			caws.act.assignId = no;
			caws.act.assignNm = caws_nvl(caws.act.empList[i].emp_nm,'');
			break;
		}
	}
	var selNm = caws_el('cawsActSelNm');
	if(selNm) selNm.innerHTML = caws_esc(caws.act.assignNm);
	caws_actEmpFilter();		/* 목록 재렌더해서 선택 강조(on 클래스) 업데이트 */
}

/* =============================================================================
 * 5.5) 접수처리정보 — 필드 단위 클릭 즉시 수정 (click-to-edit)
 * -----------------------------------------------------------------------------
 * [AX Lab] 신규 (2026-07-31 AX Lab)
 * 값을 클릭하면 그 자리가 입력 컨트롤로 바뀌고, 저장되면 다시 읽기모드로 돌아간다.
 *  · select / date  : 값을 고르는 순간 저장
 *  · text / textarea: Enter(입력창) 또는 포커스 아웃 시 저장, Esc 취소
 *  · checkbox       : 항상 활성화, 체크 토글 즉시 저장
 *  · 처리상태/담당자 : 팝오버(조치내용 메모 필수) — 이력 기록 규칙 유지 (pageType=saveAction)
 * 저장은 모두 histProc.do 의 새 pageType(saveAccept/saveCust/saveInquiry/saveDone/
 * saveDoneDt/saveProcExtra) 으로 나가며, 원본 화면(form.jsp)이 이력을 남기지 않는
 * 필드는 여기서도 이력 없이 마스터만 갱신한다.
 * 성공 시 별도 알림 없이 목록/상세를 재조회해 바뀐 값으로 확인시킨다.
 * ========================================================================== */

/* select 로 편집하는 필드의 공통코드 매핑 (vo 필드명 = 편집 키) */
var CAWS_FLD_SEL = {
	accept_route: { cg:'AS', pc:'CD02' },	/* 접수경로 */
	request_type: { cg:'AS', pc:'CD07' },	/* 문의유형 */
	inportance:   { cg:'AS', pc:'CD04' },	/* 중요도   */
	cause_type:   { cg:'AS', pc:'CD05' },	/* 원인유형 */
	action_type:  { cg:'AS', pc:'CD06' },	/* 조치유형 */
	proc_gubun:   { cg:'AS', pc:'CD09' }	/* 처리구분 */
};
/* datepicker 로 편집하는 필드 (yyyymmdd 보관) */
var CAWS_FLD_DATE = { proc_dt:true, complete_dt:true };

/* ---- 편집 시작 / 취소 ---------------------------------------------------- */
function caws_fldOpen(key){
	if(caws_nvl(caws.asNo,'') === '') return;
	/* 문의유형·시스템유형은 원본 화면과 동일하게 관리자 권한 담당자만 변경 가능 */
	if((key === 'request_type' || key === 'systype') && caws_nvl((caws.vo||{}).as_admin,'') !== 'Y'){
		alert('문의유형·시스템유형은 관리자 권한이 있는 담당자만 변경할 수 있습니다.');
		return;
	}
	caws.fld = key;
	caws_renderRecord();	/* 렌더 마지막에 caws_fldInit() 가 컨트롤을 초기화/포커스한다 */
}
function caws_fldCancel(){
	caws.fld = '';
	caws_renderRecord();
}

/* ---- 키/포커스 공통 핸들러 ------------------------------------------------
   편집 확정/취소 시 caws.fld 를 먼저 비우므로, re-render 로 컨트롤이 사라지며
   뒤늦게 blur 가 한 번 더 떠도 (caws.fld !== key) 가드로 무시된다. */
function caws_fldKey(ev, key){
	if(ev.keyCode === 27){ caws_fldCancel(); return; }
	if(ev.keyCode === 13 && ev.target && ev.target.tagName !== 'TEXTAREA'){
		if(ev.preventDefault) ev.preventDefault();
		caws_fldCommit(key);
	}
}
function caws_fldBlur(key){		/* text/textarea: 포커스 아웃 = 저장 */
	if(caws.fld !== key) return;
	caws_fldCommit(key);
}
function caws_fldBlurCancel(key){	/* select: 고르지 않고 포커스 아웃 = 취소 */
	if(caws.fld !== key) return;
	caws.fld = '';
	caws_renderRecord();
}

/* ---- 편집 확정 → 저장 ----------------------------------------------------- */
function caws_fldCommit(key){
	if(caws.fld !== key) return;
	var el = caws_el('cawsFldIn');
	if(!el) return;
	var v = String(el.value||'').trim();
	var isSel = (el.tagName === 'SELECT');
	caws.fld = '';
	if(CAWS_FLD_DATE[key] || key === 'proc_time') v = v.replace(/[^0-9]/g,'');
	if(isSel && v === ''){ caws_renderRecord(); return; }		/* '선택' 그대로 = 취소 */
	if(v === caws_fldCur(key)){ caws_renderRecord(); return; }	/* 미변경 = 조용히 닫기 */
	caws_fldSave(key, v);
}
/* 현재 저장된 값 (미변경 비교용 — 날짜는 숫자만 남겨 비교) */
function caws_fldCur(key){
	var v = caws_nvl((caws.vo||{})[key],'');
	if(CAWS_FLD_DATE[key]) v = String(v).replace(/[^0-9]/g,'');
	return String(v);
}

/* 필드 키 → 그룹 payload 조립 후 저장.
   같은 UPDATE 쿼리가 그룹 컬럼을 전부 SET 하므로, 편집한 필드 외에는
   현재 vo 값을 그대로 실어 다른 컬럼이 지워지지 않게 한다. */
function caws_fldSave(key, v){
	var vo = caws.vo || {};
	var d = { as_no: caws.asNo };
	if(key === 'accept_route'){
		d.pageType = 'saveAccept';
		d.accept_route = v;
	} else if(key === 'rl_apply_nm' || key === 'apply_tel' || key === 'send_sms'){
		d.pageType = 'saveCust';
		d.rl_apply_nm = (key === 'rl_apply_nm') ? v : caws_nvl(vo.rl_apply_nm,'');
		d.apply_tel   = (key === 'apply_tel')   ? v : caws_nvl(vo.apply_tel,'');
		d.send_sms    = (key === 'send_sms')    ? v : caws_nvl(vo.send_sms,'');
	} else if(key === 'request_type'){
		/* [AX Lab] 수정 시작 (2026-07-31 AX Lab): 문의유형 변경은 원본 화면과 동일하게
		   처리담당자 자동배정(getTaskType → getWorker)까지 이어져야 해서 전용 커밋 함수로 위임한다.
		   (요청내용(call_content) 수정은 COL2 문의 버블의 caws_qSave 로 이동) */
		caws_inquiryCommit(v, null, null);
		return;
		/* [AX Lab] 수정 끝 */
	} else if(key === 'inportance'){
		d.pageType = 'saveProcExtra';
		d.inportance = v;
		d.tel_confirm = caws_nvl(vo.tel_confirm,'');
		d.tel_absence = caws_nvl(vo.tel_absence,'');
		d.tel_absence_cnt = caws_nvl(vo.tel_absence_cnt,'');
	} else if(key === 'proc_dt' || key === 'proc_time' || key === 'cause_type'
	       || key === 'action_type' || key === 'work_time' || key === 'complete_dt'){
		d.pageType = 'saveDone';
		d.proc_dt     = (key === 'proc_dt')     ? v : caws_nvl(vo.proc_dt,'');
		d.proc_time   = (key === 'proc_time')   ? v : caws_nvl(vo.proc_time,'');
		d.cause_type  = (key === 'cause_type')  ? v : caws_nvl(vo.cause_type,'');
		d.action_type = (key === 'action_type') ? v : caws_nvl(vo.action_type,'');
		d.work_time   = (key === 'work_time')   ? v : caws_nvl(vo.work_time,'');
		d.complete_dt = (key === 'complete_dt') ? v : caws_nvl(vo.complete_dt,'');
		/* [AX Lab] 수정 시작 (2026-07-31 AX Lab): 원본 setProcGrade 규칙 —
		   [처리상태 처리완료(C005) + 조치유형 개발(C001)/프로그램 수정(C002)] 조합을 벗어나는
		   조치유형으로 바뀌면 처리완료 상세(처리구분/빌드순번/정의서)를 비운다.
		   저장 성공 후 caws_fldReturn 에서 caws_devClearSend() 로 실행한다. */
		if(key === 'action_type'
		   && !(caws_stCode() === 'C005' && (v === 'C001' || v === 'C002'))
		   && caws_devHasData()){
			caws._devClear = true;
		}
		/* [AX Lab] 수정 끝 */
	} else if(key === 'proc_gubun' || key === 'proc_build_info' || key === 'proc_test_info'
	       || key === 'proc_process_sp' || key === 'proc_screen_sp' || key === 'proc_table_sp'
	       || key === 'proc_function_sp' || key === 'proc_interface_sp'){
		d.pageType = 'saveDoneDt';
		d.proc_gubun        = (key === 'proc_gubun')        ? v : caws_nvl(vo.proc_gubun,'');
		d.proc_build_info   = (key === 'proc_build_info')   ? v : caws_nvl(vo.proc_build_info,'');
		d.proc_test_info    = (key === 'proc_test_info')    ? v : caws_nvl(vo.proc_test_info,'');
		d.proc_process_sp   = (key === 'proc_process_sp')   ? v : caws_nvl(vo.proc_process_sp,'');
		d.proc_screen_sp    = (key === 'proc_screen_sp')    ? v : caws_nvl(vo.proc_screen_sp,'');
		d.proc_table_sp     = (key === 'proc_table_sp')     ? v : caws_nvl(vo.proc_table_sp,'');
		d.proc_function_sp  = (key === 'proc_function_sp')  ? v : caws_nvl(vo.proc_function_sp,'');
		d.proc_interface_sp = (key === 'proc_interface_sp') ? v : caws_nvl(vo.proc_interface_sp,'');
	} else {
		caws_renderRecord();
		return;
	}
	common.ajaxCall(d, '/ad/as/histProc.do', 'caws_fldReturn');
}
function caws_fldReturn(data){
	var code = (data && typeof data.returnCode != 'undefined') ? data.returnCode : '';
	caws.fld = '';
	/* [AX Lab] 수정 시작 (2026-07-31 AX Lab): 처리완료 상세 초기화 예약 플래그를 소비한다.
	   (조치유형 변경으로 개발항목 노출조건을 벗어난 경우 — caws_fldSave 참고) */
	var devClear = (caws._devClear === true);
	caws._devClear = false;
	/* [AX Lab] 수정 끝 */
	if(code !== '000'){ alert('저장 중 오류가 발생했습니다.'); caws_renderRecord(); return; }
	/* [AX Lab] 수정 (2026-07-31 AX Lab): 원본 setProcGrade 와 동일하게 조건 이탈 시 상세값을 비운다 */
	if(devClear) caws_devClearSend();
	caws_reload(true);	/* 성공은 알림 없이 값 갱신으로 확인 (목록 표기도 함께 갱신) */
}

/* ---- 인라인 컨트롤 빌더 --------------------------------------------------- */
function caws_fldSelHtml(key){
	return '<select id="cawsFldIn" class="caws-fin"'
	 + ' onchange="caws_fldCommit(\''+key+'\');" onblur="caws_fldBlurCancel(\''+key+'\');"'
	 + ' onkeydown="caws_fldKey(event,\''+key+'\');"></select>';
}
function caws_fldTxtHtml(key, val, ph){
	return '<input type="text" id="cawsFldIn" class="caws-fin" value="'+caws_esc(caws_nvl(val,''))+'"'
	 + (caws_nvl(ph,'') !== '' ? ' placeholder="'+caws_esc(ph)+'"' : '')
	 + ' onblur="caws_fldBlur(\''+key+'\');" onkeydown="caws_fldKey(event,\''+key+'\');" />';
}
function caws_fldDateHtml(key){
	/* 값 세팅·datepicker 부착은 caws_fldInit 에서. 날짜는 달력에서 고르는 순간 저장된다. */
	return '<input type="text" id="cawsFldIn" class="caws-fin" readonly placeholder="YYYY/MM/DD"'
	 + ' onkeydown="caws_fldKey(event,\''+key+'\');" />';
}
function caws_fldTaHtml(key, val){
	return '<textarea id="cawsFldIn" class="caws-ta caws-fta" oninput="caws_autoGrow(this);"'
	 + ' onblur="caws_fldBlur(\''+key+'\');" onkeydown="caws_fldKey(event,\''+key+'\');">'
	 + caws_esc(caws_nvl(val,'')) + '</textarea>'
	 + '<div class="caws-mnote">다른 곳을 클릭하면 저장 · Esc 취소</div>';
}

/* ---- 편집 가능 kv 행 ------------------------------------------------------
   caws.fld === key 이면 인라인 컨트롤을, 아니면 클릭 가능한 값을 그린다.
   disp 는 이미 escape 된 HTML 문자열을 받는다. */
function caws_ekv(key, label, disp, ctrlHtml, tip){
	if(caws.fld === key){
		return '<div class="kv caws-fe"><span class="k">'+caws_esc(label)+'</span>'
		 + '<span class="v caws-fev">'+ctrlHtml+'</span></div>';
	}
	return '<div class="kv"><span class="k">'+caws_esc(label)+'</span>'
	 + '<span class="v caws-fv" onclick="caws_fldOpen(\''+key+'\');" title="'+caws_esc(caws_nvl(tip,'클릭하여 바로 수정'))+'">'
	 + disp + '</span></div>';
}

/* ---- 렌더 직후 컨트롤 초기화 (renderRecord 마지막에서 호출) ---------------- */
function caws_fldInit(){
	var key = caws_nvl(caws.fld,'');
	if(key === '') return;
	if(key === 'systype'){ caws_pairInit(); return; }
	if(key === 'proc_status'){ caws_popStatusInit(); return; }
	if(key === 'assign'){ caws_popAssignInit(); return; }
	var el = caws_el('cawsFldIn');
	if(!el) return;
	var vo = caws.vo || {};
	if(CAWS_FLD_SEL[key]){
		el.innerHTML = caws_codeOptions(CAWS_FLD_SEL[key].cg, CAWS_FLD_SEL[key].pc, caws_nvl(vo[key],''), '선택');
	} else if(key === 'send_sms'){
		var cur = caws_nvl(vo.send_sms,'');
		el.innerHTML = '<option value=""'+(cur === '' ? ' selected' : '')+'>미지정</option>'
		 + '<option value="Y"'+(cur === 'Y' ? ' selected' : '')+'>동의</option>'
		 + '<option value="N"'+(cur === 'N' ? ' selected' : '')+'>미동의</option>';
	}
	if(CAWS_FLD_DATE[key]){
		el.value = caws_dateSlash(caws_nvl(vo[key],''));
		try{
			$('#cawsFldIn').datepicker({
				dateFormat:'yy/mm/dd', changeMonth:true, changeYear:true,
				onSelect:(function(k){ return function(){ caws_fldCommit(k); }; })(key)
			});
			$('#cawsFldIn').datepicker('show');
		}catch(e){}
	}
	if(el.tagName === 'TEXTAREA') caws_autoGrow(el);
	try{
		el.focus();
		if(el.tagName === 'INPUT' && !el.readOnly && el.select) el.select();
	}catch(e){}
}

/* ---- 시스템(대)/(소) 쌍 편집 ('systype') -----------------------------------
   (대)를 바꾸면 (소) 목록이 그 대분류로 다시 채워지고, (소)까지 고르면 저장된다. */
function caws_pairHtml(){
	return '<div class="caws-frow">'
	 + '<select id="cawsFldCate" class="caws-fin caws-fgrow" onchange="caws_pairCateChange();" onkeydown="if(event.keyCode===27)caws_fldCancel();"></select>'
	 + '<select id="cawsFldSub" class="caws-fin caws-fgrow" onchange="caws_pairCommit();" onkeydown="if(event.keyCode===27)caws_fldCancel();"></select>'
	 + '<button type="button" class="caws-fx" onclick="caws_fldCancel();" title="취소">&times;</button>'
	 + '</div>'
	 + '<div class="caws-mnote">시스템(소)까지 선택하면 저장됩니다. ※ 버전정보는 원본 등록화면에서 관리되는 값이라 여기서는 바뀌지 않습니다.</div>';
}
function caws_pairInit(){
	var vo = caws.vo || {};
	var cate = caws_el('cawsFldCate');
	if(cate) cate.innerHTML = caws_codeOptions('AS','CD03', caws_nvl(vo.service_cate,''), '선택');
	caws_pairFillSub(caws_nvl(vo.service_cate,''), caws_nvl(vo.inquiry_type,''));
	if(cate) try{ cate.focus(); }catch(e){}
}
function caws_pairFillSub(serviceCate, sel){
	var sub = caws_el('cawsFldSub');
	if(!sub) return;
	serviceCate = caws_nvl(serviceCate,'');
	if(serviceCate === ''){
		sub.innerHTML = '<option value="">시스템(대) 먼저</option>';
		return;
	}
	sub.innerHTML = caws_codeOptions('AS', serviceCate, caws_nvl(sel,''), '선택');
}
function caws_pairCateChange(){
	var cate = caws_el('cawsFldCate');
	caws_pairFillSub(cate ? cate.value : '', '');
}
function caws_pairCommit(){
	if(caws.fld !== 'systype') return;
	var vo = caws.vo || {};
	var cate = caws_el('cawsFldCate'), sub = caws_el('cawsFldSub');
	var cv = cate ? String(cate.value||'') : '';
	var sv = sub ? String(sub.value||'') : '';
	if(cv === '' || sv === '') return;	/* 둘 다 골라야 저장 */
	caws.fld = '';
	if(cv === caws_nvl(vo.service_cate,'') && sv === caws_nvl(vo.inquiry_type,'')){
		caws_renderRecord();	/* 미변경 = 조용히 닫기 */
		return;
	}
	/* [AX Lab] 수정 시작 (2026-07-31 AX Lab): 시스템유형 변경도 원본(getInquiry_type)과 동일하게
	   처리담당자 자동배정으로 이어지도록 전용 커밋 함수로 위임한다. */
	caws_inquiryCommit(null, cv, sv);
	/* [AX Lab] 수정 끝 */
}

/* =============================================================================
 * [AX Lab] 수정 시작 (2026-07-31 AX Lab)
 * 5.6) 문의유형/시스템유형 변경 커밋 + 처리담당자 자동배정
 * -----------------------------------------------------------------------------
 * 원본 운영화면(ad/as/form.jsp)의 자동배정 로직을 그대로 옮겼다.
 *  ① 문의유형 변경 → getTaskType.do 로 해당 코드(AS/CD07)의 VAL2 조회.
 *     - VAL2 != 'Y' (시스템과 무관한 유형) : 시스템유형(대/소)을 비우고
 *       getWorker.do(문의유형) 로 자동배정. (원본 getRequestType 의 else 분기와 동일)
 *     - VAL2 == 'Y' (시스템성 유형) : 시스템(소)까지 있어야 getWorker.do(문의유형+시스템 대/소).
 *       C011 은 원본 setTaskType 과 동일하게 시스템(대)를 P010 으로 고정한다.
 *  ② getWorker 쿼리는 CRM_OPERATE_MGT 에서 USE_YN='Y'·MASTER_YN='Y' 담당자 중
 *     WK_COUNT(배정건수)가 가장 적은 1명을 준다(최소부하 배정). 기존 URL 무수정 재사용.
 *  ③ 원본 setWorker 와 동일하게 처리상태가 처리완료(C005)면 자동배정하지 않는다.
 *  ④ 배정 반영은 기존 saveAction(pageType) 경로를 재사용해 담당자 변경 이력([이관] 접두어)이
 *     남게 하고, 인계메모에는 자동배정 사유를 자동 기입한다.
 *     (신규 접수 insert 시에만 수행되는 WK_COUNT+1(updateAsWkCount)은 원본 update 흐름에도
 *      없으므로 여기서도 하지 않는다)
 * ========================================================================== */
function caws_inquiryCommit(reqType, cate, inq){
	var vo = caws.vo || {};
	var rt = (reqType !== null) ? reqType : caws_nvl(vo.request_type,'');
	var sc = (cate    !== null) ? cate    : caws_nvl(vo.service_cate,'');
	var iq = (inq     !== null) ? inq     : caws_nvl(vo.inquiry_type,'');

	/* 문의유형이 비어 있는 과거 데이터는 VAL2 판정이 불가하므로
	   시스템유형을 건드리지 않고 값 그대로 저장만 한다(자동배정도 생략) */
	var val2 = caws_taskVal2(rt);
	if(rt !== '' && val2 !== 'Y'){
		sc = ''; iq = '';		/* 원본은 시스템유형을 비활성화하고 비운다 */
	} else if(rt === 'C011' && sc !== 'P010'){
		sc = 'P010'; iq = '';	/* C011 은 시스템(대) P010 고정. 소분류는 다시 골라야 한다 */
	}

	/* 자동배정 대상 조회 — 처리완료 건은 배정하지 않는다(원본 setWorker 동일) */
	caws._autoAssign = null;
	if(rt !== '' && caws_stCode() !== 'C005'){
		var w = null;
		if(val2 !== 'Y'){
			w = caws_worker({ request_type: rt, val2: val2 });
		} else if(sc !== '' && iq !== ''){
			w = caws_worker({ request_type: rt, service_cate: sc, inquiry_type: iq, val2: val2 });
		}
		if(w && caws_nvl(w.wk_emp_no,'') !== '' && w.wk_emp_no !== caws_nvl(vo.assign_id,'')){
			caws._autoAssign = { id: w.wk_emp_no, nm: caws_nvl(w.wk_emp_nm,'') };
		}
	}

	common.ajaxCall({
		as_no: caws.asNo,
		pageType: 'saveInquiry',
		request_type: rt,
		service_cate: sc,
		inquiry_type: iq,
		call_content: caws_nvl(vo.call_content,'')
	}, '/ad/as/histProc.do', 'caws_inqReturn');
}
/* saveInquiry 저장 콜백 — 성공하면 예약된 자동배정을 이어서 실행한 뒤 재조회한다 */
function caws_inqReturn(data){
	var code = (data && typeof data.returnCode != 'undefined') ? data.returnCode : '';
	caws.fld = '';
	var w = caws._autoAssign;
	caws._autoAssign = null;
	if(code !== '000'){ alert('저장 중 오류가 발생했습니다.'); caws_renderRecord(); return; }
	if(w){
		caws._autoAssignNm = w.nm;
		common.ajaxCall({
			as_no: caws.asNo,
			pageType: 'saveAction',
			proc_status: '',	/* 상태는 바꾸지 않음(빈 값 = 유지) */
			proc_dt: '',
			assign_id: w.id,
			action_content: '문의유형/시스템유형 변경에 따른 처리담당자 자동배정'
		}, '/ad/as/histProc.do', 'caws_autoAssignReturn');
	}
	caws_reload(true);
}
function caws_autoAssignReturn(data){
	var code = (data && typeof data.returnCode != 'undefined') ? data.returnCode : '';
	var nm = caws_nvl(caws._autoAssignNm,'');
	caws._autoAssignNm = '';
	if(code !== '000'){
		alert('처리담당자 자동배정 중 오류가 발생했습니다.\n담당자를 직접 확인해주세요.');
		return;
	}
	alert('문의유형/시스템유형 변경에 따라 처리담당자가 '+(nm !== '' ? '\''+nm+'\' 님으로 ' : '')+'자동배정되었습니다.');
}

/* getTaskType.do : 문의유형 코드(AS/CD07)의 VAL2 ('Y'=시스템성 유형). 동기 호출 후 값을 반환한다 */
function caws_taskVal2(reqType){
	caws._tmpVal2 = '';
	if(caws_nvl(reqType,'') === '') return '';
	common.ajaxCall({ request_type: reqType }, '/ad/as/getTaskType.do', 'caws_taskTypeReturn');
	return caws._tmpVal2;
}
function caws_taskTypeReturn(data){
	var r = (data && data.resultList) ? data.resultList : null;
	caws._tmpVal2 = r ? caws_nvl(r.val2,'') : '';
}
/* getWorker.do : 최소부하 담당자 1명. 동기 호출 후 {wk_emp_no, wk_emp_nm} 를 반환한다 */
function caws_worker(params){
	caws._tmpWorker = null;
	common.ajaxCall(params, '/ad/as/getWorker.do', 'caws_workerReturn');
	return caws._tmpWorker;
}
function caws_workerReturn(data){
	caws._tmpWorker = (data && data.resultList) ? data.resultList : null;
}

/* -----------------------------------------------------------------------------
 * 처리완료 상세(개발 항목) 조건부 노출 보조 — 원본 setProcGrade 규칙.
 * [처리상태 처리완료(C005) + 조치유형 개발(C001)/프로그램 수정(C002)] 일 때만
 * '처리완료 상세' 그룹을 노출하고, 조건을 벗어나면 원본과 동일하게 값 자체를 비운다.
 * -------------------------------------------------------------------------- */
var CAWS_DEV_FLDS = ['proc_gubun','proc_build_info','proc_test_info','proc_process_sp',
                     'proc_screen_sp','proc_table_sp','proc_function_sp','proc_interface_sp'];
function caws_devOn(){
	var at = caws_nvl((caws.vo||{}).action_type,'');
	return caws_stCode() === 'C005' && (at === 'C001' || at === 'C002');
}
function caws_devHasData(){
	var vo = caws.vo || {};
	for(var i=0; i<CAWS_DEV_FLDS.length; i++){
		if(caws_nvl(vo[CAWS_DEV_FLDS[i]],'') !== '') return true;
	}
	return false;
}
/* 조건 이탈 시 처리완료 상세 컬럼을 전부 비운다 (기존 saveDoneDt 경로 재사용) */
function caws_devClearSend(){
	var d = { as_no: caws.asNo, pageType: 'saveDoneDt' };
	for(var i=0; i<CAWS_DEV_FLDS.length; i++) d[CAWS_DEV_FLDS[i]] = '';
	common.ajaxCall(d, '/ad/as/histProc.do', 'caws_devClearReturn');
}
function caws_devClearReturn(data){
	var code = (data && typeof data.returnCode != 'undefined') ? data.returnCode : '';
	if(code !== '000') alert('처리완료 상세 항목 초기화 중 오류가 발생했습니다.');
}
/* [AX Lab] 수정 끝 */

/* ---- 처리상태 팝오버 ('proc_status') ---------------------------------------
   처리상태 변경은 CRM_AS_MGT_HIST 이력이 남는 업무 규칙이 있어(원본 form.jsp 동일)
   조치내용 메모를 필수로 받는 팝오버로 처리한다. 상태를 바꾸지 않고 메모만 남겨도 된다. */
function caws_popStatusHtml(){
	return '<div class="caws-pop">'
	 + '<label class="caws-aclb">처리상태 변경</label>'
	 + '<select id="cawsPopStatus" class="caws-acsel"></select>'
	 + '<label class="caws-aclb" style="margin-top:7px;">조치내용 / 인계메모 <span class="caws-req">*</span></label>'
	 + '<textarea class="caws-ta caws-fta" id="cawsPopMemo" oninput="caws_autoGrow(this);"'
	 +   ' onkeydown="if(event.keyCode===27)caws_fldCancel();"'
	 +   ' placeholder="처리 이력에 남을 조치내용을 입력하세요. (상태를 바꾸지 않고 메모만 남겨도 됩니다)"></textarea>'
	 + '<div class="caws-cbar" style="margin-top:7px;">'
	 +   '<button type="button" class="btn-s" onclick="caws_fldCancel();">취소</button>'
	 +   '<span class="caws-sp"></span>'
	 +   '<button type="button" class="caws-send act" onclick="caws_popStatusSave();">저장</button>'
	 + '</div>'
	 + '</div>';
}
function caws_popStatusInit(){
	var sel = caws_el('cawsPopStatus');
	if(sel) sel.innerHTML = caws_codeOptions('AS','CD01', caws_stCode(), '');
	var ta = caws_el('cawsPopMemo');
	if(ta){ caws_autoGrow(ta); try{ ta.focus(); }catch(e){} }
}
function caws_popStatusSave(){
	var ta = caws_el('cawsPopMemo');
	var comment = ta ? String(ta.value||'').trim() : '';
	if(comment === ''){ alert('조치내용을 입력해주세요.'); if(ta) ta.focus(); return; }
	var sel = caws_el('cawsPopStatus');
	/* [AX Lab] 수정 시작 (2026-07-31 AX Lab): 처리완료(C005)가 아닌 상태로 바뀌면
	   원본 setProcGrade 와 동일하게 처리완료 상세(개발 항목)를 비운다. (저장 성공 후 실행) */
	var newSt = sel ? String(sel.value||'') : '';
	var at = caws_nvl((caws.vo||{}).action_type,'');
	caws._devClear = (newSt !== '' && newSt !== 'C005'
	                  && (at === 'C001' || at === 'C002') && caws_devHasData());
	/* [AX Lab] 수정 끝 */
	common.ajaxCall({
		as_no: caws.asNo,
		pageType: 'saveAction',
		proc_status: sel ? String(sel.value||'') : '',
		proc_dt: '',
		assign_id: '',		/* 담당자는 여기서 바꾸지 않음(빈 값 = 유지) */
		action_content: comment
	}, '/ad/as/histProc.do', 'caws_histReturn');
}

/* ---- 처리담당자 팝오버 ('assign') ------------------------------------------
   담당자 이관도 이력이 남는 업무 규칙이 있어 인계메모를 필수로 받는다. */
function caws_popAssignHtml(){
	return '<div class="caws-pop">'
	 + '<label class="caws-aclb">배정담당자 <span class="caws-actselnm" id="cawsActSelNm"></span></label>'
	 + '<input type="text" id="cawsActEmpKw" class="caws-fin caws-fwide" placeholder="이름/사번 검색"'
	 +   ' onkeyup="caws_actEmpFilter();" onkeydown="if(event.keyCode===27)caws_fldCancel();" />'
	 + '<div class="caws-emplist" id="cawsActEmpList" style="margin-top:5px;">불러오는 중...</div>'
	 + '<label class="caws-aclb" style="margin-top:7px;">조치내용 / 인계메모 <span class="caws-req">*</span></label>'
	 + '<textarea class="caws-ta caws-fta" id="cawsPopMemo" oninput="caws_autoGrow(this);"'
	 +   ' onkeydown="if(event.keyCode===27)caws_fldCancel();"'
	 +   ' placeholder="담당자 이관 사유 등 인계메모를 입력하세요."></textarea>'
	 + '<div class="caws-cbar" style="margin-top:7px;">'
	 +   '<button type="button" class="btn-s" onclick="caws_fldCancel();">취소</button>'
	 +   '<span class="caws-sp"></span>'
	 +   '<button type="button" class="caws-send act" onclick="caws_popAssignSave();">저장</button>'
	 + '</div>'
	 + '</div>';
}
function caws_popAssignInit(){
	caws.act.assignId = caws_nvl((caws.vo||{}).assign_id, caws_nvl((caws.row||{}).assign_id,''));
	caws.act.assignNm = caws_empNm();
	var selNm = caws_el('cawsActSelNm');
	if(selNm) selNm.innerHTML = caws_esc(caws.act.assignNm);
	/* 담당자 목록 — 이미 로드됐으면 재사용, 없으면 새로 요청 */
	if(caws.act.empList.length > 0){
		caws_actEmpFilter();
	} else {
		common.ajaxCall({ as_no:caws.asNo, assign_id:caws.act.assignId }, '/ad/as/getAsEmpList.do', 'caws_actEmpLoaded');
	}
	var kw = caws_el('cawsActEmpKw');
	if(kw) try{ kw.focus(); }catch(e){}
}
function caws_popAssignSave(){
	var ta = caws_el('cawsPopMemo');
	var comment = ta ? String(ta.value||'').trim() : '';
	if(comment === ''){ alert('조치내용(인계메모)을 입력해주세요.'); if(ta) ta.focus(); return; }
	if(caws_nvl(caws.act.assignId,'') === ''){ alert('배정할 담당자를 선택해주세요.'); return; }
	common.ajaxCall({
		as_no: caws.asNo,
		pageType: 'saveAction',
		proc_status: '',	/* 상태는 여기서 바꾸지 않음(빈 값 = 유지) */
		proc_dt: '',
		assign_id: caws_nvl(caws.act.assignId,''),
		action_content: comment
	}, '/ad/as/histProc.do', 'caws_histReturn');
}

/* ---- 전화확인 / 전화부재중 (항상 활성 체크박스, 토글 즉시 저장) -------------- */
function caws_telRowHtml(vo){
	return '<div class="kv"><span class="k">전화확인</span><span class="v">'
	 +  '<label class="caws-ck"><input type="checkbox" id="cawsTelConfirm" onchange="caws_telSave();"'
	 +   (caws_nvl(vo.tel_confirm,'') === 'Y' ? ' checked' : '') + ' /> 완료</label>'
	 + '</span></div>'
	 + '<div class="kv"><span class="k">전화 부재중</span><span class="v caws-telv">'
	 +  '<label class="caws-ck"><input type="checkbox" id="cawsTelAbsence" onchange="caws_telSave();"'
	 +   (caws_nvl(vo.tel_absence,'') === 'Y' ? ' checked' : '') + ' /> 부재중</label>'
	 +  '<input type="text" id="cawsTelAbsenceCnt" class="caws-fin caws-fcnt" value="'+caws_esc(caws_nvl(vo.tel_absence_cnt,'0'))+'"'
	 +   ' onblur="caws_telSave();" onkeydown="if(event.keyCode===13)caws_telSave();" />회'
	 + '</span></div>';
}
function caws_telSave(){
	var vo = caws.vo || {};
	var tc = caws_el('cawsTelConfirm'), ta = caws_el('cawsTelAbsence'), cnt = caws_el('cawsTelAbsenceCnt');
	var nv = {
		tel_confirm: (tc && tc.checked) ? 'Y' : 'N',
		tel_absence: (ta && ta.checked) ? 'Y' : 'N',
		tel_absence_cnt: cnt ? String(cnt.value||'').replace(/[^0-9]/g,'') : '0'
	};
	if(nv.tel_absence_cnt === '') nv.tel_absence_cnt = '0';
	/* 미변경이면 저장하지 않는다 (체크박스 change + 횟수 blur 중복 호출 방지) */
	var curTc = (caws_nvl(vo.tel_confirm,'') === 'Y') ? 'Y' : 'N';
	var curTa = (caws_nvl(vo.tel_absence,'') === 'Y') ? 'Y' : 'N';
	var curCnt = String(caws_nvl(vo.tel_absence_cnt,'0'));
	if(nv.tel_confirm === curTc && nv.tel_absence === curTa && nv.tel_absence_cnt === curCnt) return;
	common.ajaxCall({
		as_no: caws.asNo,
		pageType: 'saveProcExtra',
		inportance: caws_nvl(vo.inportance,''),
		tel_confirm: nv.tel_confirm,
		tel_absence: nv.tel_absence,
		tel_absence_cnt: nv.tel_absence_cnt
	}, '/ad/as/histProc.do', 'caws_fldReturn');
}

/* ---- 접기/펼치기 -------------------------------------------------------- */
function caws_composeOpen(){
	/* 기본값은 접힘. 펼쳐진 작성영역이 약 190px 을 먹어 타임라인이 그만큼 잘리기 때문이다. */
	try{ return sessionStorage.getItem(CAWS_CP_KEY) === '1'; }catch(e){ return false; }
}
/* ★ 여기서 caws_renderCompose() 를 다시 부르지 않는다.
   innerHTML 을 새로 만들면 작성 중이던 textarea 내용과 첨부 썸네일이 전부 날아간다.
   그래서 클래스와 버튼 라벨만 바꾼다. */
function caws_toggleCompose(){
	var comp = caws_el('asCompose');
	if(!comp) return;
	var open = comp.classList.contains('off');		/* 접혀 있었으면 이제 펼친다 */

	/* 타임라인 높이가 바뀌면 스크롤 위치가 밀린다. 맨 아래(최신)를 보고 있었다면
	   토글 후에도 맨 아래를 유지해 방금 읽던 글이 사라지지 않게 한다. */
	var box = caws_el('asDetail');
	var atEnd = box ? (box.scrollHeight - box.scrollTop - box.clientHeight < 24) : false;

	comp.classList.toggle('off', !open);
	try{ sessionStorage.setItem(CAWS_CP_KEY, open ? '1' : '0'); }catch(e){}
	if(box && atEnd) box.scrollTop = box.scrollHeight;

	var txt = caws_el('cawsFoldTxt');
	if(txt) txt.innerHTML = open ? '접기' : '작성하기';

	if(open){
		var ta = caws_el('cawsText');
		if(ta){ caws_autoGrow(ta); ta.focus(); }
	}else{
		caws_syncDraftTag();							/* 접을 때 '작성 중' 표시 갱신 */
	}
}
function caws_openCompose(){
	var comp = caws_el('asCompose');
	if(comp && comp.classList.contains('off')) caws_toggleCompose();
}
/* 접힌 상태에서 작성 중인 글/첨부가 있으면 탭 줄에 '작성 중' 배지를 띄운다.
   (접었다는 사실 때문에 쓰던 글을 잊고 다른 건으로 넘어가는 것을 막는다) */
function caws_syncDraftTag(){
	var tag = caws_el('cawsDraftTag');
	if(!tag) return;
	var ta = caws_el('cawsText');
	var hasTxt = ta && String(ta.value||'').replace(/\s/g,'') !== '';
	var hasFile = caws_slots().length > 0;
	tag.classList.toggle('show', !!(hasTxt || hasFile));
}
/* 입력량에 맞춰 textarea 높이를 늘린다. min 52px ~ max 200px (CSS 와 같은 값). */
function caws_autoGrow(el){
	if(!el) return;
	el.style.height = 'auto';
	var h = Math.min(200, Math.max(52, el.scrollHeight));
	el.style.height = h + 'px';
}

function caws_ctab(t){
	/* '처리' 요청이 오면 COL3 의 처리상태 팝오버(조치내용 작성)를 연다. */
	if(t === 'act'){ caws_focusAct(); return; }
	/* 'ans' : 작성영역 펼치고 포커스 */
	caws_openCompose();
	var ta = caws_el('cawsText');
	if(ta){ caws_autoGrow(ta); ta.focus(); }
}

/* '처리 작성' 버튼 → 처리상태 팝오버를 연다 (조치내용만 남기고 상태를 안 바꿔도 됨).
   proc 아코디언이 닫혀 있으면 먼저 펼친다(팝오버가 눈에 띄어야 하기 때문). */
function caws_focusAct(){
	if(caws_nvl(caws.asNo,'') === ''){ alert('먼저 목록에서 접수건을 선택해주세요.'); return; }
	try{
		var s = sessionStorage.getItem(CAWS_ACC_KEY);
		var st = s ? JSON.parse(s) : {};
		if(st.proc === false){
			st.proc = true;
			sessionStorage.setItem(CAWS_ACC_KEY, JSON.stringify(st));
		}
	}catch(e){}
	caws_fldOpen('proc_status');
}

/* ---- 드래그&드롭 첨부 ---------------------------------------------------- */
function caws_bindDrop(){
	var z = caws_el('cawsDrop');
	if(!z) return;

	z.addEventListener('dragover', function(e){ e.preventDefault(); z.classList.add('on'); });
	z.addEventListener('dragleave', function(e){
		/* 자식 요소로 이동한 것뿐이면 해제하지 않는다. */
		if(e.relatedTarget && z.contains(e.relatedTarget)) return;
		z.classList.remove('on');
	});
	z.addEventListener('drop', function(e){
		e.preventDefault();
		z.classList.remove('on');
		var dt = e.dataTransfer;
		if(dt && dt.files && dt.files.length) caws_addDropFiles(dt.files);
	});
}

/* 첨부 input 은 answerForm(멀티파트) 안에 만든다.
   ★ 파일 1개당 input 1개가 필요하다. 서버(CommonFileServiceImpl.uploadFormFile)는
     mpRequest.getFileNames() 로 파라미터명을 훑고 이름당 getFile() 로 1개만 꺼내므로,
     같은 name 에 여러 파일을 넣으면 1개만 저장된다. 그래서 uploadFile1..N 으로 이름을 나눈다.
     (awsProc.do 는 attach_tag_name.startsWith("uploadFile") 로 받으므로 서버 수정이 필요 없다) */
function caws_slotBox(){
	var f = document.answerForm;
	if(!f) return null;
	var box = caws_el('cawsFileSlots');
	if(!box){
		box = document.createElement('div');
		box.id = 'cawsFileSlots';
		box.style.display = 'none';
		f.appendChild(box);
	}
	return box;
}
function caws_slots(){
	var box = caws_slotBox();
	return box ? box.querySelectorAll('input[type=file]') : [];
}
function caws_newSlot(){
	var box = caws_slotBox();
	if(!box) return null;
	if(caws_slots().length >= CAWS_MAX_FILES) return null;
	caws.fileSeq++;
	var inp = document.createElement('input');
	inp.type = 'file';
	inp.name = 'uploadFile' + caws.fileSeq;
	inp.onchange = caws_renderThumbs;
	box.appendChild(inp);
	return inp;
}
function caws_pickFile(){
	var inp = caws_newSlot();
	if(!inp){ alert('첨부는 최대 ' + CAWS_MAX_FILES + '개까지 가능합니다.'); return; }
	inp.click();
}
function caws_addDropFiles(list){
	/* input.files 에 파일을 넣으려면 DataTransfer 생성자가 필요하다(Chrome/Edge/Firefox 지원).
	   미지원 브라우저에서는 [파일 첨부] 버튼(네이티브 선택)만 쓰도록 안내한다. */
	if(typeof DataTransfer === 'undefined'){
		alert('이 브라우저는 드래그&드롭 첨부를 지원하지 않습니다.\n[파일 첨부] 버튼을 이용해주세요.');
		return;
	}
	for(var i=0; i<list.length; i++){
		var slot = caws_newSlot();
		if(!slot){ alert('첨부는 최대 ' + CAWS_MAX_FILES + '개까지 가능합니다.'); break; }
		try{
			var dt = new DataTransfer();
			dt.items.add(list[i]);
			slot.files = dt.files;
		}catch(e){
			slot.parentNode.removeChild(slot);
			alert('이 브라우저는 드래그&드롭 첨부를 지원하지 않습니다.\n[파일 첨부] 버튼을 이용해주세요.');
			break;
		}
	}
	caws_renderThumbs();
}
function caws_delFile(name){
	var slots = caws_slots();
	for(var i=0; i<slots.length; i++){
		if(slots[i].name === name){ slots[i].parentNode.removeChild(slots[i]); break; }
	}
	caws_renderThumbs();
}
function caws_clearFiles(){
	var box = caws_el('cawsFileSlots');
	if(box) box.innerHTML = '';
	caws.fileSeq = 0;
	caws_renderThumbs();
}
/* 전송 전 썸네일 + 개별 삭제 */
function caws_renderThumbs(){
	var wrap = caws_el('cawsThumbs');
	if(!wrap) return;
	var slots = caws_slots(), s = '';
	for(var i=0; i<slots.length; i++){
		var fl = slots[i].files;
		if(!fl || !fl.length) continue;			/* 선택 취소된 빈 슬롯. 서버도 size 0 은 건너뛴다 */
		var f = fl[0];
		var thumb = '';
		if(caws_isImg(f.name) && typeof URL != 'undefined' && URL.createObjectURL){
			thumb = '<img src="'+URL.createObjectURL(f)+'" alt="" />';
		}else{
			thumb = '<span class="caws-tico">'+caws_esc(caws_ext(f.name) || 'file')+'</span>';
		}
		s += '<span class="caws-thumb">'+thumb
		  +   '<span class="caws-tnm" title="'+caws_esc(f.name)+'">'+caws_esc(f.name)+'</span>'
		  +   '<button type="button" class="caws-tdel" title="첨부 제거" onclick="caws_delFile(\''+slots[i].name+'\');">&times;</button>'
		  + '</span>';
	}
	wrap.innerHTML = s;
	caws_syncDraftTag();
}

/* ---- 전송 ---------------------------------------------------------------- */
function caws_send(){
	if(caws_nvl(caws.asNo,'') === ''){ alert('먼저 목록에서 접수건을 선택해주세요.'); return; }
	var ta = caws_el('cawsText');
	var txt = ta ? ta.value : '';
	if(caws_nvl(txt,'').replace(/\s/g,'') === ''){
		alert('답변 내용을 입력해 주세요.');
		if(ta) ta.focus();
		return;
	}

	/* 고객 답변 : 기존 answerForm(멀티파트) + 숨은 iframe 방식을 그대로 쓴다.
	   응답 JSP 가 parent.awsProcReturn(resultCode) 를 호출한다. (list.jsp 에서 caws_afterAnswer 로 연결) */
	var f = document.answerForm;
	if(!f){ alert('답변 등록 폼을 찾을 수 없습니다.'); return; }
	f.w_content.value = txt;
	f.as_no.value = caws.asNo;
	f.pageType.value = 'insert';

	try{ $('#awsFrame').remove(); }catch(e){}
	$('<iframe id="awsFrame" name="awsFrame" style="width:0;height:0;display:none;"></iframe>').appendTo('body');

	f.method = 'post';
	f.target = 'awsFrame';
	f.action = '/ad/as/awsProc.do';
	f.submit();
}

/* histProc.do 공통 콜백 (처리상태/담당자 팝오버 저장 — 이력이 남는 저장이라 알림을 띄운다) */
function caws_histReturn(data){
	var code = (data && typeof data.returnCode != 'undefined') ? data.returnCode : '';
	/* [AX Lab] 수정 시작 (2026-07-31 AX Lab): 처리완료 상세 초기화 예약 플래그 소비
	   (처리완료 → 다른 상태 변경 시. caws_popStatusSave 참고) */
	var devClear = (caws._devClear === true);
	caws._devClear = false;
	if(code !== '000'){ alert('처리도중 오류가 발생했습니다.'); return; }
	if(devClear) caws_devClearSend();
	/* [AX Lab] 수정 끝 */
	alert('정상처리 되었습니다.');
	caws_closeAll();
	caws.fld = '';		/* 저장 후 팝오버 닫기 (목록·상세 재조회 전에 먼저 닫아야 read 모드로 렌더됨) */
	caws_reload(true);
}

/* 답변 등록 성공 후 (list.jsp awsProcReturn 에서 호출) */
function caws_afterAnswer(){
	var ta = caws_el('cawsText');
	if(ta) ta.value = '';
	caws_clearFiles();
	caws_reload(false);
}

/* 현재 건을 다시 조회해 타임라인/상세를 갱신한다.
   withList=true 면 목록도 다시 그린다(상태·담당자가 바뀌어 목록 표시가 달라지는 경우). */
function caws_reload(withList){
	if(caws_nvl(caws.asNo,'') === '') return;
	if(withList && typeof makeListData === 'function'){
		/* 목록 재조회는 setAsList 에서 첫 행을 자동 선택하므로, 현재 보고 있던 건을 다시 열어준다. */
		var keepNo = caws.asNo, keepCn = caws.cnAsNo;
		makeListData();
		asws_openDetail(keepNo, keepCn);
		return;
	}
	asws_openDetail(caws.asNo, caws.cnAsNo);
}

/* =============================================================================
 * 6) 모달 공통
 * ========================================================================== */
function caws_openModal(id){
	var dim = caws_el('cawsDim'), m = caws_el(id);
	if(dim) dim.style.display = 'block';
	if(m) m.style.display = 'flex';
}
function caws_closeModal(id){
	var m = caws_el(id);
	if(m) m.style.display = 'none';
	/* 열려 있는 모달이 더 없으면 딤도 내린다. */
	var any = document.querySelectorAll('#asWorkspace .caws-modal[style*="flex"], #asWorkspace .caws-lb[style*="flex"]').length;
	if(!any){ var dim = caws_el('cawsDim'); if(dim) dim.style.display = 'none'; }
}
function caws_closeAll(){
	var ms = document.querySelectorAll('#asWorkspace .caws-modal, #asWorkspace .caws-lb');
	for(var i=0; i<ms.length; i++) ms[i].style.display = 'none';
	var dim = caws_el('cawsDim');
	if(dim) dim.style.display = 'none';
}

/* select 옵션 만들기 (공통코드) */
function caws_codeOptions(cg, pc, sel, placeholder){
	var list = asws_loadCodes(cg, pc);
	var s = (placeholder ? '<option value="">'+caws_esc(placeholder)+'</option>' : '');
	for(var i=0; i<list.length; i++){
		s += '<option value="'+caws_esc(list[i].code)+'"'+(list[i].code === sel ? ' selected' : '')+'>'
		  +  caws_esc(list[i].name)+'</option>';
	}
	return s;
}

/* =============================================================================
 * 7) AI 문장 다듬기 모달 (★ 화면만)
 * ========================================================================== */
function caws_openAi(){
	var ta = caws_el('cawsText');
	var src = ta ? ta.value : '';
	if(caws_nvl(src,'').replace(/\s/g,'') === ''){
		alert('다듬을 문장을 먼저 작성해주세요.'); if(ta) ta.focus(); return;
	}
	caws.ai.src = src;
	caws.ai.out = '';
	caws_html('cawsAiSrc', caws_esc(src));
	caws_html('cawsAiOut', '<span class="none">아래 톤을 고르고 [문장 다듬기] 를 누르세요.</span>');
	caws_syncAiTone();
	caws_openModal('cawsAi');
}
function caws_aiTone(t){ caws.ai.tone = t; caws_syncAiTone(); }
function caws_syncAiTone(){
	var btns = document.querySelectorAll('#cawsAi .caws-aitone .caws-pchip');
	for(var i=0; i<btns.length; i++){
		btns[i].classList.toggle('on', btns[i].getAttribute('data-tone') === caws.ai.tone);
	}
}
function caws_aiRun(){
	var out = caws_el('cawsAiOut');
	if(out){ out.className = 'caws-aiout wait'; out.innerHTML = '문장을 다듬고 있습니다...'; }
	caws_aiPolish(caws.ai.src, caws.ai.tone, function(text){
		caws.ai.out = text;
		var o = caws_el('cawsAiOut');
		if(o){ o.className = 'caws-aiout'; o.innerHTML = caws_esc(text); }
	});
}
function caws_aiApply(){
	if(caws_nvl(caws.ai.out,'') === ''){ alert('먼저 [문장 다듬기] 를 실행해주세요.'); return; }
	var ta = caws_el('cawsText');
	if(ta){ ta.value = caws.ai.out; caws_autoGrow(ta); ta.focus(); }
	caws_closeModal('cawsAi');
}

/* ★★★ AI 호출부 격리 지점 ★★★
   TODO: 프로젝트에 AI/LLM 연동이 도입되면 이 함수 "내부만" 교체한다.
         (예: common.ajaxCall({text:text, tone:tone}, '<AI 엔드포인트>', '<콜백>'))
         화면(caws_openAi / caws_aiRun / caws_aiApply)은 손대지 않아도 되도록
         [입력 text, 톤 tone, 콜백 cb(결과문자열)] 계약만 지키면 된다.
         ※ 신규 URL 은 MenuAuthFilter 에 걸리므로, 실제 연동 시에도 기존 URL + pageType 방식을
           쓸지 메뉴권한(CRM_ROLE_PROG)에 URL 을 등록할지 먼저 정해야 한다.
   지금은 서버 호출 없이 화면 확인용 목업 결과를 만든다. */
function caws_aiPolish(text, tone, cb){
	var t = String(caws_nvl(text,''));
	var out = t;

	if(tone === 'brief'){
		/* 간결하게 : 빈 줄/중복 공백 정리 + 군더더기 표현 제거 */
		out = t.replace(/[ \t]+/g,' ').replace(/\n{2,}/g,'\n').replace(/(그래서|그러니까|일단|좀)\s*/g,'').trim();
	}else if(tone === 'typo'){
		/* 오탈자만 : 공백/문장부호 정리 (실제 교정은 AI 연동 후) */
		out = t.replace(/[ \t]+/g,' ').replace(/\s+([.,!?])/g,'$1').replace(/([.,!?])(?=[^\s.,!?])/g,'$1 ').trim();
	}else{
		/* 정중하게 : 반말/구어 종결을 격식체로 바꾸고 인사말을 덧붙인다. */
		out = t.replace(/[ \t]+/g,' ').trim()
		       .replace(/했어요?\./g,'하였습니다.').replace(/했어\b/g,'하였습니다')
		       .replace(/해요\./g,'합니다.').replace(/해줘\b/g,'해주시기 바랍니다')
		       .replace(/됐어요?\./g,'되었습니다.').replace(/줄게\b/g,'드리겠습니다')
		       .replace(/^\s*/,'안녕하세요. 문의 주신 내용 확인하였습니다.\n\n');
		if(!/(습니다|입니다)[.!]?\s*$/.test(out)) out += '\n\n추가로 궁금한 점이 있으시면 언제든 문의해주시기 바랍니다.';
		else out += '\n\n추가로 궁금한 점이 있으시면 언제든 문의해주시기 바랍니다.';
	}

	if(typeof cb === 'function') cb(out);
}

/* =============================================================================
 * 10) 게시물 링크 삽입 모달
 * -----------------------------------------------------------------------------
 * 본문에는 notice/form.jsp 와 같은 토큰(예: 공지사항(12345))을 텍스트로 넣고,
 * 타임라인 렌더 시 caws_linkify() 가 정규식으로 클릭 가능한 링크로 바꾼다.
 * ========================================================================== */
function caws_openLink(){
	var s = '';
	for(var i=0; i<CAWS_BOARDS.length; i++){
		s += '<option value="'+CAWS_BOARDS[i].gbn+'">'+caws_esc(CAWS_BOARDS[i].label)+'</option>';
	}
	caws_html('cawsLnGbn', s);
	var num = caws_el('cawsLnNum'); if(num) num.value = '';
	caws_html('cawsLnMsg', '');
	caws_openModal('cawsLink');
	if(num) num.focus();
}
function caws_board(gbn){
	for(var i=0; i<CAWS_BOARDS.length; i++){ if(CAWS_BOARDS[i].gbn === gbn) return CAWS_BOARDS[i]; }
	return null;
}
/* 존재 확인. 게시판 메뉴 권한이 없으면 이 URL 도 403 이 되므로 실패해도 링크 삽입은 막지 않는다. */
function caws_checkLink(){
	var g = caws_el('cawsLnGbn'), n = caws_el('cawsLnNum');
	var b = caws_board(g ? g.value : '');
	var num = n ? String(n.value||'').replace(/[^0-9]/g,'') : '';
	if(!b || num === ''){ caws_html('cawsLnMsg','게시물 번호를 입력해주세요.'); return; }

	$.ajax({
		type:'POST', url:b.exist, dataType:'json', async:false, data:{ seq:num },
		success:function(d){
			var l = (d && d.resultList) ? d.resultList : [];
			var cnt = (l.length && typeof l[0].CNT != 'undefined') ? Number(l[0].CNT) : 0;
			caws_html('cawsLnMsg', cnt > 0
				? b.label + ' ' + num + '번 게시물을 찾았습니다.'
				: b.label + ' ' + num + '번 게시물을 찾을 수 없습니다. 번호를 확인해주세요.');
		},
		error:function(){
			/* 403(게시판 메뉴 권한 없음) 등. 검증만 건너뛰고 삽입은 허용한다. */
			caws_html('cawsLnMsg', '존재 확인 권한이 없어 검증을 건너뜁니다. 번호를 직접 확인해주세요.');
		}
	});
}
function caws_insertLink(){
	var g = caws_el('cawsLnGbn'), n = caws_el('cawsLnNum');
	var b = caws_board(g ? g.value : '');
	var num = n ? String(n.value||'').replace(/[^0-9]/g,'') : '';
	if(!b || num === ''){ alert('게시물 번호를 입력해주세요.'); if(n) n.focus(); return; }

	var token = b.token + '(' + num + ')';
	var ta = caws_el('cawsText');
	if(ta){
		/* 커서 위치에 삽입 (없으면 끝에 덧붙임) */
		var p = (typeof ta.selectionStart === 'number') ? ta.selectionStart : ta.value.length;
		var q = (typeof ta.selectionEnd === 'number') ? ta.selectionEnd : p;
		ta.value = ta.value.substring(0, p) + token + ta.value.substring(q);
		var pos = p + token.length;
		caws_autoGrow(ta);
		ta.focus();
		try{ ta.setSelectionRange(pos, pos); }catch(e){}
	}
	caws_closeModal('cawsLink');
}
/* 본문 링크 클릭 → 해당 게시판 상세를 새 창으로 연다.
   notice/form.jsp 의 noticelistDetail / faqlistDetail 이동방식을 그대로 옮겼다.
   ※ 공지사항만 본문 번호가 NOTICE_NUM 이라 getNoticenum.do 로 SEQ 변환이 필요하다. */
function caws_goBoard(gbn, num){
	var b = caws_board(gbn);
	if(!b) return;
	var seq = num;

	if(b.numConv){
		var ok = false;
		$.ajax({
			type:'POST', url:'/ad/board/getNoticenum.do', dataType:'json', async:false, data:{ seq:num },
			success:function(d){
				var l = (d && d.resultList) ? d.resultList : [];
				if(l.length && typeof l[0].SEQ != 'undefined'){ seq = l[0].SEQ; ok = true; }
			},
			error:function(){}
		});
		if(!ok){ alert('공지사항(' + num + ') 을 열 수 없습니다.\n게시물이 없거나 게시판 조회 권한이 없습니다.'); return; }
	}

	/* 전용 폼을 즉석에서 만들어 새 창으로 POST 한다.
	   (목록 폼 listFrm 의 action/target 을 건드리면 이후 검색·페이징이 깨진다) */
	try{ $('#cawsBoardFrm').remove(); }catch(e){}
	var f = $('<form id="cawsBoardFrm" method="post" target="_blank"></form>');
	f.attr('action', b.url);
	f.append('<input type="hidden" name="pageType" value="update" />');
	f.append('<input type="hidden" name="seq" value="'+caws_esc(seq)+'" />');
	f.append('<input type="hidden" name="board_gbn" value="'+b.gbn+'" />');
	f.append('<input type="hidden" name="page" value="1" />');
	f.appendTo('body');
	f.submit();
}

/* =============================================================================
 * 11) COL3 : 아코디언 상세정보
 * -----------------------------------------------------------------------------
 * 기존 asws_renderDetailRecord() 의 .rgroup 을 헤더 클릭 토글로 바꾼 것이다.
 * '처리 이력' 그룹은 COL2 타임라인으로 통합했으므로 여기서 제거한다(중복 제거).
 * 펼침상태는 sessionStorage 에 저장해 다른 건을 골라도 유지한다.
 * ========================================================================== */
function caws_accOpen(){
	/* [AX Lab] 수정 (2026-07-31 AX Lab): 문의유형정보(inquiry) 그룹을 접수정보(accept)에 통합해 제거.
	   기본값 : 접수정보 / 고객사정보 / 처리상태사항 펼침, 처리완료 관련 접힘 */
	var def = { accept:1, cust:1, proc:1, done:0, donedt:0 };
	try{
		var raw = sessionStorage.getItem(CAWS_ACC_KEY);
		if(raw){
			var st = JSON.parse(raw);
			/* [AX Lab] 수정 (2026-07-31 AX Lab): 세션에 저장된 값에 없는 키만 기본값으로 채워
			   하위호환을 유지한다. (통합으로 제거된 inquiry 키가 남아 있어도 렌더에서 참조하지 않아 무해) */
			for(var k in def){ if(typeof st[k] === 'undefined') st[k] = def[k]; }
			return st;
		}
	}catch(e){}
	return def;
}
function caws_accToggle(key){
	var st = caws_accOpen();
	st[key] = st[key] ? 0 : 1;
	try{ sessionStorage.setItem(CAWS_ACC_KEY, JSON.stringify(st)); }catch(e){}
	var el = caws_el('cawsAcc_'+key);
	if(el) el.classList.toggle('off', !st[key]);
}
/* 접힌 상태에서도 핵심 값을 알 수 있게 헤더 우측에 요약을 붙인다. */
function caws_accBox(key, title, summary, body, st){
	return '<div class="caws-acc'+(st[key] ? '' : ' off')+'" id="cawsAcc_'+key+'">'
	     +   '<button type="button" class="caws-acch" onclick="caws_accToggle(\''+key+'\');">'
	     +     '<span class="caws-achev">&#9662;</span>'+caws_esc(title)
	     +     (summary ? '<span class="caws-asum">'+caws_esc(summary)+'</span>' : '')
	     +   '</button>'
	     +   '<div class="caws-accb">'+body+'</div>'
	     + '</div>';
}
function caws_kv(k, v){
	return '<div class="kv"><span class="k">'+caws_esc(k)+'</span><span class="v">'+caws_esc(caws_nvl(v,'-'))+'</span></div>';
}
/* 코드값을 공통코드 명칭으로 바꾼다. 목록행(row)에 *_nm 이 없는 항목(접수경로/처리구분)에 쓴다. */
function caws_codeNm(cg, pc, code){
	code = caws_nvl(code,'');
	if(code === '') return '-';
	var list = asws_loadCodes(cg, pc);
	for(var i=0; i<list.length; i++){ if(list[i].code === code) return list[i].name; }
	return code;
}

/* [AX Lab] 수정 시작 (2026-07-31 AX Lab): 접수처리정보를 필드 단위 클릭 즉시 수정으로 렌더.
   수정 가능한 값은 caws_ekv(클릭 → 인라인 컨트롤)로, 조회 전용 값은 기존 caws_kv 로 그린다. */
/* 연관접수번호(하위작업) 행 — 목록이 있으면 select + [열기], 없으면 '-' */
function caws_cnAsRowHtml(){
	var list = caws.cnAsList || [];
	var opts = '', n = 0;
	for(var i=0; i<list.length; i++){
		var no = caws_nvl(list[i].as_no,'');
		if(no === '' || no === caws.asNo) continue;	/* 자기 자신은 제외 */
		n++;
		opts += '<option value="'+caws_esc(no)+'">'+caws_esc(no)+'</option>';
	}
	if(n === 0) return caws_kv('연관접수번호', '-');
	return '<div class="kv"><span class="k">연관접수번호</span><span class="v caws-telv">'
	 + '<select id="cawsCnAsSel" class="caws-fin caws-fnav" title="하위작업(연관 접수건) 선택"><option value="">선택 ('+n+'건)</option>'+opts+'</select>'
	 + '<button type="button" class="caws-minib" onclick="caws_cnAsOpen();" title="선택한 접수건을 이 화면에서 엽니다">열기</button>'
	 + '</span></div>';
}
function caws_renderRecord(){
	var vo = caws.vo || {}, row = caws.row || {};
	var st = caws_accOpen();
	var stCode = caws_stCode();
	var stNm   = caws_stNm();
	var empNm  = caws_empNm();
	/* 시스템유형(대/소)은 목록행에만 명칭이 있다. row 가 없으면 대분류만 공통코드로 변환한다.
	   (소분류는 P_CODE 가 대분류 코드라 조회 파라미터가 건마다 달라 캐시 이점이 없어 생략) */
	var sysType = (caws_nvl(row.service_cate_nm,'') !== '')
	            ? (row.service_cate_nm + (caws_nvl(row.inquiry_type_nm,'') !== '' ? ' / '+row.inquiry_type_nm : ''))
	            : caws_codeNm('AS','CD03', caws_nvl(vo.service_cate,''));
	/* 처리완료일 — 이제 클릭해서 직접 고칠 수 있는 필드라, 상태와 무관하게 저장된 값을 그대로 보여준다. */
	var completeDt = (caws_nvl(vo.complete_dt,'') !== '')
	               ? caws_date(vo.complete_dt)
	               : caws_nvl(row.as_complete_dt,'-');
	if(completeDt === '') completeDt = '-';
	var stateDate = caws_nvl(row.star_state_date,'-');
	if(stateDate.length > 10) stateDate = stateDate.substr(0,10);
	var isAdmin = (caws_nvl(vo.as_admin,'') === 'Y');
	var admTip = '문의유형·시스템유형은 관리자 권한 담당자만 변경할 수 있습니다';
	var acceptRouteNm = caws_codeNm('AS','CD02', caws_nvl(vo.accept_route,''));
	var reqTypeNm = (caws_nvl(row.request_type_nm,'') !== '') ? row.request_type_nm : caws_codeNm('AS','CD07', caws_nvl(vo.request_type,''));

	/* --- 접수정보 : 접수경로만 편집 가능(나머지는 이력성 값이라 조회 전용)
	   + 하위작업 생성 / 상위접수번호 / 연관접수번호 (원본 form.jsp 접수정보와 동일 구성) --- */
	var parentNo = caws_nvl(vo.cn_as_no, caws_nvl(caws.cnAsNo,''));
	var b1 = '<div class="kv"><span class="k">접수번호</span><span class="v">'+caws_esc(caws.asNo)
	   +   (parentNo === '' && caws_nvl(caws.asNo,'') !== ''
	       ? ' <button type="button" class="caws-minib" onclick="caws_subCreate();" title="이 건의 하위작업(연관 접수건)을 생성합니다. 하위작업 작성 화면으로 이동합니다">+ 하위작업</button>' : '')
	   + '</span></div>'
	   + (parentNo !== ''
	       ? '<div class="kv"><span class="k">상위접수번호</span><span class="v link caws-lnk" onclick="caws_pastOpen(\''+caws_esc(parentNo)+'\',\'\');" title="상위 접수건을 이 화면에서 엽니다">'+caws_esc(parentNo)+'</span></div>' : '')
	   + caws_cnAsRowHtml()
	   + caws_kv('연결된 AS', caws_nvl(row.as_no_link_count,'0')+'건')
	   + caws_kv('우선처', (caws_nvl(row.priority,'') === 'Y') ? '★ 우선' : '-')
	   + caws_kv('챗봇ID', caws_nvl(vo.chatbot_id,'-'))
	   + caws_ekv('accept_route', '접수경로', caws_esc(acceptRouteNm), caws_fldSelHtml('accept_route'))
	   + caws_kv('접수일시', caws_date(caws_nvl(vo.accept_dt, caws_nvl(row.accept_dt,''))) + (caws_time(caws_nvl(vo.accept_time,'')) ? ' '+caws_time(vo.accept_time) : ''));
	/* [AX Lab] 수정 시작 (2026-07-31 AX Lab): 문의유형정보 그룹을 접수정보에 통합.
	   문의유형/시스템유형/버전정보를 이 박스로 옮기고, 요청내용은 가운데(COL2) 문의 버블에서
	   보여주고 수정(caws_qEdit)하므로 접수처리정보 영역에서는 제거한다.
	   ※ 버전정보는 원본화면에서 시스템(대) 선택에 연동해 자동 계산되는 파생값이라 조회 전용.
	   ※ 일반 담당자(as_admin != 'Y')는 원본 화면과 동일하게 문의유형/시스템유형을 바꿀 수 없다. */
	b1 += (isAdmin
	     ? caws_ekv('request_type', '문의유형', caws_esc(reqTypeNm), caws_fldSelHtml('request_type'))
	     : '<div class="kv"><span class="k">문의유형</span><span class="v" title="'+admTip+'">'+caws_esc(reqTypeNm)+'</span></div>')
	   + (!isAdmin
	     ? '<div class="kv"><span class="k">시스템유형</span><span class="v" title="'+admTip+'">'+caws_esc(sysType)+'</span></div>'
	     : (caws.fld === 'systype'
	       ? '<div class="kv caws-fe" style="display:block;"><span class="k">시스템유형</span><div class="caws-feb">'+caws_pairHtml()+'</div></div>'
	       : '<div class="kv"><span class="k">시스템유형</span><span class="v caws-fv" onclick="caws_fldOpen(\'systype\');" title="클릭하여 바로 수정">'+caws_esc(sysType)+'</span></div>'))
	   + caws_kv('버전정보', caws_nvl(vo.version_info,'-'));
	/* [AX Lab] 수정 끝 */

	/* --- 고객사정보 : 실신청자/연락처/SMS수신동의만 편집 가능
	   (고객사명·코드/신청자ID·이름은 원본 화면에서도 조회 모달로만 바꿀 수 있어 조회 전용 유지)
	   HIS 진료/주소/고객사 연락처는 CRM_CUST_MGT 쪽 값이라 caws.custInfo(getCustInfo2.do)에서 채운다 --- */
	var ci = caws.custInfo || {};
	var custAddr = caws_nvl(ci.cust_address,'');
	if(custAddr !== '' && caws_nvl(ci.zip_code,'') !== '') custAddr += ' ('+ci.zip_code+')';
	var smsDisp = (caws_nvl(vo.send_sms,'') === 'Y') ? '동의' : ((caws_nvl(vo.send_sms,'') === 'N') ? '미동의' : '-');
	var b2 = caws_kv('고객사코드', caws_nvl(row.cust_code, caws_nvl(vo.cust_code,'-')))
	   + caws_kv('거래처명', caws_nvl(row.cust_kor_name,'-'))
	   + caws_kv('HIS 진료', caws_nvl(ci.his_treat_name,'-'))
	   + caws_kv('고객사 주소', (custAddr !== '') ? custAddr : '-')
	   + caws_kv('고객사 연락처', caws_nvl(ci.tel_no,'-'))
	   + caws_kv('신청자', caws_nvl(vo.apply_nm,'-'))
	   + caws_kv('신청자 아이디', caws_nvl(vo.apply_id,'-'))
	   + caws_ekv('rl_apply_nm', '실신청자', caws_esc(caws_nvl(vo.rl_apply_nm,'-')), caws_fldTxtHtml('rl_apply_nm', caws_nvl(vo.rl_apply_nm,''), ''))
	   + caws_ekv('apply_tel', '연락처', caws_esc(caws_nvl(vo.apply_tel,'-')), caws_fldTxtHtml('apply_tel', caws_nvl(vo.apply_tel,''), '숫자만 입력'))
	   + caws_ekv('send_sms', 'SMS수신동의', caws_esc(smsDisp), caws_fldSelHtml('send_sms'))
	   + caws_kv('거래상태', caws_nvl(row.deal_code_nm,'-'));

	/* [AX Lab] 수정 (2026-07-31 AX Lab): '문의유형정보' 별도 그룹(b6) 제거 —
	   문의유형/시스템유형/버전정보는 위 접수정보(b1)로 통합, 요청내용은 COL2 문의 버블로 이동. */

	/* --- 처리상태사항 : 처리상태/담당자(이력 팝오버) + 중요도/전화확인/전화부재중(즉시 저장) --- */
	var b3 = '<div class="kv"><span class="k">현재 처리상태</span>'
	   +   '<span class="v caws-fv" onclick="caws_fldOpen(\'proc_status\');" title="클릭하여 처리상태 변경·조치내용 작성 (이력에 기록됩니다)">'
	   +     '<span class="st '+asws_stClass(stCode)+'">'+caws_esc(stNm)+'</span></span></div>'
	   + (caws.fld === 'proc_status' ? caws_popStatusHtml() : '')
	   + '<div class="kv"><span class="k">처리담당자</span>'
	   +   '<span class="v caws-fv" onclick="caws_fldOpen(\'assign\');" title="클릭하여 담당자 이관 (인계메모 필수)">'+caws_esc(empNm)+'</span></div>'
	   + (caws.fld === 'assign' ? caws_popAssignHtml() : '')
	   + (caws.fld === 'inportance'
	     ? '<div class="kv caws-fe"><span class="k">중요도</span><span class="v caws-fev">'+caws_fldSelHtml('inportance')+'</span></div>'
	     : '<div class="kv"><span class="k">중요도</span><span class="'+((caws_gradeCode() === 'C001') ? 'v grade-b' : 'v')+' caws-fv" onclick="caws_fldOpen(\'inportance\');" title="클릭하여 바로 수정">'+caws_esc(caws_gradeNm())+'</span></div>')
	   + caws_telRowHtml(vo);

	/* --- 처리완료사항 : 처리예정일자/시각·원인유형·조치유형·작업시간·처리완료일자 --- */
	var procDtDisp = caws_date(caws_nvl(vo.proc_dt,''));
	if(procDtDisp === '') procDtDisp = '-';
	var procTimeDisp = caws_time(caws_nvl(vo.proc_time,''));
	if(procTimeDisp === '') procTimeDisp = '-';
	var causeNm  = (caws_nvl(row.cause_type_nm,'') !== '') ? row.cause_type_nm : caws_codeNm('AS','CD05', caws_nvl(vo.cause_type,''));
	var actionNm = (caws_nvl(row.action_type_nm,'') !== '') ? row.action_type_nm : caws_codeNm('AS','CD06', caws_nvl(vo.action_type,''));
	var b4 = caws_ekv('proc_dt', '처리예정일자', caws_esc(procDtDisp), caws_fldDateHtml('proc_dt'), '클릭하여 달력에서 선택')
	   + caws_ekv('proc_time', '예정시각(HHmm)', caws_esc(procTimeDisp), caws_fldTxtHtml('proc_time', caws_nvl(vo.proc_time,''), '예: 1430'))
	   + caws_ekv('cause_type', '원인유형', caws_esc(causeNm), caws_fldSelHtml('cause_type'))
	   + caws_ekv('action_type', '조치유형', caws_esc(actionNm), caws_fldSelHtml('action_type'))
	   + caws_ekv('work_time', '작업시간(Hour)', caws_esc(caws_nvl(vo.work_time,'-')), caws_fldTxtHtml('work_time', caws_nvl(vo.work_time,''), '예: 2.5'))
	   + caws_ekv('complete_dt', '처리완료일', caws_esc(completeDt), caws_fldDateHtml('complete_dt'), '클릭하여 달력에서 선택')
	   + caws_kv('검수일', stateDate)
	   + caws_kv('고객평가', asws_stars(caws_nvl(row.star_state, caws_nvl(vo.star_state,''))))
	   + (caws_nvl(vo.star_content,'') !== ''
	      ? '<div class="caws-btxt" style="font-size:12px;margin-top:5px;">'+caws_esc(vo.star_content)+'</div>' : '')
	   + caws_filesHtml(caws.attach2, -1);

	/* --- 처리완료 상세 : 처리구분/빌드순번/각종 정의서(개발팀 참고용) ---
	   [AX Lab] 수정 시작 (2026-07-31 AX Lab): 원본 setProcGrade 노출 로직 반영 —
	   처리상태 처리완료(C005) + 조치유형 개발(C001)/프로그램 수정(C002)일 때만 그룹을 노출한다. */
	var devOn = caws_devOn();
	var b5 = '';
	if(devOn){
		b5 = caws_ekv('proc_gubun', '처리구분', caws_esc(caws_codeNm('AS','CD09', caws_nvl(vo.proc_gubun,''))), caws_fldSelHtml('proc_gubun'))
		   + caws_ekv('proc_build_info',   '빌드순번',          caws_esc(caws_nvl(vo.proc_build_info,'-')),   caws_fldTxtHtml('proc_build_info',   caws_nvl(vo.proc_build_info,''), ''))
		   + caws_ekv('proc_test_info',    '테스트 정보',       caws_esc(caws_nvl(vo.proc_test_info,'-')),    caws_fldTxtHtml('proc_test_info',    caws_nvl(vo.proc_test_info,''), ''))
		   + caws_ekv('proc_process_sp',   '프로세스 정의서',   caws_esc(caws_nvl(vo.proc_process_sp,'-')),   caws_fldTxtHtml('proc_process_sp',   caws_nvl(vo.proc_process_sp,''), ''))
		   + caws_ekv('proc_screen_sp',    '화면 정의서',       caws_esc(caws_nvl(vo.proc_screen_sp,'-')),    caws_fldTxtHtml('proc_screen_sp',    caws_nvl(vo.proc_screen_sp,''), ''))
		   + caws_ekv('proc_table_sp',     '테이블 정의서',     caws_esc(caws_nvl(vo.proc_table_sp,'-')),     caws_fldTxtHtml('proc_table_sp',     caws_nvl(vo.proc_table_sp,''), ''))
		   + caws_ekv('proc_function_sp',  '기능 정의서',       caws_esc(caws_nvl(vo.proc_function_sp,'-')),  caws_fldTxtHtml('proc_function_sp',  caws_nvl(vo.proc_function_sp,''), ''))
		   + caws_ekv('proc_interface_sp', '인터페이스 정의서', caws_esc(caws_nvl(vo.proc_interface_sp,'-')), caws_fldTxtHtml('proc_interface_sp', caws_nvl(vo.proc_interface_sp,''), ''));
	}

	/* 접수정보 헤더 요약은 통합된 문의유형·시스템유형을 우선 보여준다(없으면 접수경로) */
	var rec = caws_accBox('accept',  '접수정보',
	          (reqTypeNm !== '-' ? reqTypeNm + (sysType !== '-' ? ' · '+sysType : '')
	                             : (acceptRouteNm !== '-' ? acceptRouteNm : '')), b1, st)
	        + caws_accBox('cust',    '고객사정보',     caws_nvl(row.cust_kor_name,''),   b2, st)
	        + caws_accBox('proc',    '처리상태사항',   stNm + ' · ' + empNm,             b3, st)
	        + caws_accBox('done',    '처리완료사항',   (completeDt !== '-' ? completeDt : '미완료'), b4, st)
	        + (devOn ? caws_accBox('donedt', '처리완료 상세', caws_nvl(vo.proc_build_info,''), b5, st) : '')
	        + caws_pastHtml();
	/* [AX Lab] 수정 끝 */

	caws_html('asRecord', rec);

	/* 편집 중인 필드가 있으면 컨트롤 초기화(옵션 채우기·datepicker 부착·포커스) */
	caws_fldInit();
	/* 처리상태/담당자 팝오버는 폼이 길어서 화면에 들어오도록 스크롤해준다 */
	if(caws.fld === 'proc_status' || caws.fld === 'assign'){
		var procEl = caws_el('cawsAcc_proc');
		if(procEl) setTimeout(function(){ procEl.scrollIntoView({ behavior:'smooth', block:'nearest' }); }, 50);
	}
}
/* [AX Lab] 수정 끝 */

/* =============================================================================
 * 12) COL3 : 과거 상담이력  (getAsList.do 무수정 재사용)
 * -----------------------------------------------------------------------------
 * 같은 거래처(cust_code)의 접수건을 기간·키워드로 조회한다.
 * ★ procSelect 를 빈 문자열로 보내면 서버가 procSelectArray = [""] 로 만들고
 *   normalizeNullArray() 가 "" 를 돌려주므로 처리상태 IN 조건이 아예 붙지 않는다(= 전체 상태).
 *   반대로 값을 잘못 채우면 IN ('') 이 되어 0건이 나오므로 빈 값을 유지해야 한다.
 * ========================================================================== */
function caws_pastHtml(){
	return '<div class="caws-past" style="margin-top:8px;">'
	+ '<div class="caws-pasth">'
	+   '<span class="caws-ptitle">과거 상담이력</span>'
	+   '<span class="caws-pcnt" id="cawsPastCnt"></span>'
	+ '</div>'
	+ '<div class="caws-pastf">'
	+   '<div class="caws-prow">'
	+     '<input type="text" id="cawsPastS" class="caws-pdt" readonly placeholder="시작일" />'
	+     '<span class="caws-pwave">~</span>'
	+     '<input type="text" id="cawsPastE" class="caws-pdt" readonly placeholder="종료일" />'
	+   '</div>'
	+   '<div class="caws-prow">'
	+     caws_pastChip('1w','1주') + caws_pastChip('1m','1개월') + caws_pastChip('3m','3개월') + caws_pastChip('all','전체')
	+   '</div>'
	+   '<div class="caws-prow">'
	+     '<input type="text" id="cawsPastKw" class="caws-pkw" placeholder="요청내용 검색" onkeydown="if(event.keyCode==13){caws_pastSearch();return false;}" />'
	+     '<button type="button" class="caws-pchip" onclick="caws_pastSearch();">검색</button>'
	+   '</div>'
	+ '</div>'
	+ '<div class="caws-pastlist" id="cawsPastList"><div class="caws-pempty">불러오는 중...</div></div>'
	+ '</div>';
}
function caws_pastChip(key, label){
	return '<button type="button" class="caws-pchip'+(caws.past.quick===key ? ' on' : '')+'" '
	     + 'data-q="'+key+'" onclick="caws_pastQuick(\''+key+'\');">'+label+'</button>';
}

/* 상세를 새로 그린 직후 호출. 기본 기간(오늘-7일 ~ 오늘)으로 초기화하고 조회한다. */
function caws_pastReset(){
	caws.past.quick = '1w';
	caws_pastApplyRange('1w');
	try{
		$('#cawsPastS, #cawsPastE').datepicker({ dateFormat:'yy/mm/dd', changeMonth:true, changeYear:true });
	}catch(e){}
	caws_pastSearch();
}
function caws_pastApplyRange(key){
	var s = caws_el('cawsPastS'), e = caws_el('cawsPastE');
	if(!s || !e) return;
	e.value = caws_dayOffset(0);
	if(key === '1w')      s.value = caws_dayOffset(-7);
	else if(key === '1m') s.value = caws_dayOffset(-30);
	else if(key === '3m') s.value = caws_dayOffset(-90);
	else { s.value = ''; e.value = ''; }		/* 전체 : 기간조건 미적용 */
}
function caws_pastQuick(key){
	caws.past.quick = key;
	var chips = document.querySelectorAll('#asRecord .caws-pastf .caws-pchip[data-q]');
	for(var i=0; i<chips.length; i++) chips[i].classList.toggle('on', chips[i].getAttribute('data-q') === key);
	caws_pastApplyRange(key);
	caws_pastSearch();
}
function caws_pastSearch(){
	var custCode = caws_nvl((caws.row||{}).cust_code, caws_nvl((caws.vo||{}).cust_code,''));
	if(custCode === ''){
		caws_html('cawsPastList', '<div class="caws-pempty">거래처 정보가 없어 과거이력을 조회할 수 없습니다.</div>');
		return;
	}
	var s = caws_el('cawsPastS'), e = caws_el('cawsPastE'), kw = caws_el('cawsPastKw');
	var sv = s ? String(s.value||'') : '', ev = e ? String(e.value||'') : '';

	caws_html('cawsPastList', '<div class="caws-pempty">불러오는 중...</div>');
	common.ajaxCall({
		cust_code: custCode,
		search_type10: (sv !== '' && ev !== '') ? 'Y' : '',	/* 기간조건 사용여부 */
		search_start: sv,
		search_end: ev,
		search_text: kw ? String(kw.value||'') : '',
		procSelect: '',					/* 빈 값 = 처리상태 전체 (위 주석 참고) */
		asGubunFlag: '1',				/* 1 = 전체 (2 는 나의 A/S 로 담당자 필터가 붙는다) */
		page: '1',
		pageSize: '50'
	}, '/ad/as/getAsList.do', 'caws_setPast');
}
function caws_setPast(data){
	var list = (data && data.resultList) ? data.resultList : [];
	caws.past.list = list;

	var s = '', n = 0;
	for(var i=0; i<list.length; i++){
		var it = list[i];
		var no = caws_nvl(it.as_no,'');
		if(no === caws.asNo) continue;					/* 지금 보고 있는 건은 제외 */
		n++;
		var txt = caws_nvl(it.call_content,'');
		s += '<button type="button" class="caws-pit" onclick="caws_pastOpen(\''+caws_esc(no)+'\',\''+caws_esc(caws_nvl(it.cn_as_no,''))+'\');">'
		  +    '<div class="caws-pith">'
		  +      '<span class="caws-pdate">'+caws_esc(caws_date(it.accept_dt))+'</span>'
		  +      '<span class="st '+asws_stClass(caws_nvl(it.proc_status,''))+'">'+caws_esc(caws_nvl(it.proc_status_nm,'-'))+'</span>'
		  +      '<span class="caws-pno">'+caws_esc(no)+'</span>'
		  +    '</div>'
		  +    '<div class="caws-ptxt">'+(txt ? caws_esc(txt) : '<span class="none">요청내용 없음</span>')+'</div>'
		  +  '</button>';
	}
	caws_html('cawsPastCnt', n + '건');
	caws_html('cawsPastList', n ? s : '<div class="caws-pempty">해당 기간에 다른 상담이력이 없습니다.</div>');
}
/* 과거이력 클릭 : 페이지 이동 없이 COL2/COL3 를 그 건으로 갈아끼운다.
   목록(COL1)에 없는 건일 수도 있어 asws.curRow 가 비게 되는데, 그때는 getAsInfo 응답값만으로 그린다. */
function caws_pastOpen(asNo, cnAsNo){
	if(caws_nvl(asNo,'') === '') return;
	asws_openDetail(asNo, cnAsNo);
}

/* =============================================================================
 * 13) 상세 넓게 보기 (COL1 을 rail 로 접고 COL2 확장)
 * -----------------------------------------------------------------------------
 * 기존 asws_toggleListWide()(목록 넓게보기)의 반대 개념이다. 두 모드는 동시에 켜질 수 없다.
 * ========================================================================== */
function caws_toggleDetailWide(){
	var grid = caws_el('asGrid');
	if(!grid) return;
	var on = grid.classList.toggle('detail-wide');

	/* 목록 넓게보기가 켜져 있으면 끈다(같은 grid-template-columns 를 다투므로 동시 사용 불가).
	   ★ asws_toggleListWide() 를 호출하지 않고 클래스를 직접 지우는 이유:
	     그 함수는 켤 때 이쪽을 다시 끄도록 되어 있어 서로 호출하면 두 모드가 모두 꺼진다. */
	if(on && grid.classList.contains('list-wide')){
		grid.classList.remove('list-wide');
		try{ sessionStorage.setItem('asws_list_wide', 'N'); }catch(e){}
		if(typeof asws_syncListWideBtn === 'function') asws_syncListWideBtn(false);
	}
	try{ sessionStorage.setItem(CAWS_DW_KEY, on ? '1' : '0'); }catch(e){}
	var btn = caws_el('cawsDwBtn');
	if(btn) btn.innerHTML = on ? '기본 보기' : '상세 넓게 보기';
}
function caws_restoreDetailWide(){
	var on = false;
	try{ on = (sessionStorage.getItem(CAWS_DW_KEY) === '1'); }catch(e){}
	if(!on) return;
	var grid = caws_el('asGrid');
	if(!grid) return;
	/* 목록 넓게보기가 이미 복원돼 있으면 그쪽을 존중한다(두 모드 동시 적용 불가). */
	if(grid.classList.contains('list-wide')) return;
	grid.classList.add('detail-wide');
	var btn = caws_el('cawsDwBtn');
	if(btn) btn.innerHTML = '기본 보기';
}

/* =============================================================================
 * [AX Lab] 수정 시작 (2026-07-31 AX Lab)
 * 14) 3분할 컬럼 폭 마우스 드래그 리사이즈
 * -----------------------------------------------------------------------------
 * 컬럼 사이 gap(10px) 위치에 핸들(.caws-rz)을 JS 로 만들어 얹고, 드래그하면
 * #asGrid 인라인의 --caws-c1/c2/c3 변수(fr)를 갱신한다. CSS 쪽 var 체인은
 * combine-as-thread.css 의 grid-template-columns 재선언 주석 참고.
 *   - fr 단위를 유지하므로 창 크기가 바뀌어도 조절한 "비율"이 유지된다.
 *   - 접기(c1/c3-collapsed)·목록/상세 넓게보기 모드에서는 CSS 가 핸들을 숨긴다.
 *   - 더블클릭 : 기본 폭으로 복원. 조절값은 sessionStorage 에 저장(다른 상태키와 동일 패턴).
 * ========================================================================== */
var CAWS_RZ_KEY = 'caws_col_fr';
/* 기본 폭. combine-as-thread.css 의 grid-template-columns 기본값과 반드시 같아야 한다. */
var CAWS_RZ_DEF = { c1:1.45, c2:2.1, c3:0.9 };
/* 드래그 시 각 컬럼이 이보다 좁아지지 않게 막는 px 최소폭 */
var CAWS_RZ_MIN = { c1:300, c2:340, c3:230 };

caws.rz = { c1:CAWS_RZ_DEF.c1, c2:CAWS_RZ_DEF.c2, c3:CAWS_RZ_DEF.c3 };

function caws_rzApply(){
	var g = caws_el('asGrid');
	if(!g) return;
	g.style.setProperty('--caws-c1', caws.rz.c1.toFixed(4) + 'fr');
	g.style.setProperty('--caws-c2', caws.rz.c2.toFixed(4) + 'fr');
	g.style.setProperty('--caws-c3', caws.rz.c3.toFixed(4) + 'fr');
}

/* 핸들을 항상 "컬럼 오른쪽 경계의 gap" 위에 겹쳐 둔다.
   폭이 바뀌는 모든 경우(드래그/접기 transition/창 크기)는 ResizeObserver 가 다시 불러준다. */
function caws_rzPos(){
	var c1 = caws_el('col-c1'), c2 = caws_el('col-c2');
	var h1 = caws_el('cawsRz1'), h2 = caws_el('cawsRz2');
	if(h1 && c1) h1.style.left = (c1.offsetLeft + c1.offsetWidth) + 'px';
	if(h2 && c2) h2.style.left = (c2.offsetLeft + c2.offsetWidth) + 'px';
}

function caws_rzSave(){
	try{ sessionStorage.setItem(CAWS_RZ_KEY, JSON.stringify(caws.rz)); }catch(e){}
}

/* 더블클릭 : 기본 폭 복원 (인라인 변수를 지워 CSS 기본값으로 되돌린다) */
function caws_rzReset(){
	caws.rz = { c1:CAWS_RZ_DEF.c1, c2:CAWS_RZ_DEF.c2, c3:CAWS_RZ_DEF.c3 };
	var g = caws_el('asGrid');
	if(g){
		g.style.removeProperty('--caws-c1');
		g.style.removeProperty('--caws-c2');
		g.style.removeProperty('--caws-c3');
	}
	try{ sessionStorage.removeItem(CAWS_RZ_KEY); }catch(e){}
	caws_rzPos();
}

/* n=1 : 목록|문의내용 경계, n=2 : 문의내용|접수처리정보 경계.
   드래그 시작 시점의 [fr값, px폭] 스냅샷으로 fr/px 환산계수를 구해,
   경계 양옆 두 컬럼의 fr 만 주고받는다(반대쪽 컬럼 폭은 변하지 않는다). */
function caws_rzDown(e, n){
	e.preventDefault();
	var g = caws_el('asGrid');
	var a = caws_el(n === 1 ? 'col-c1' : 'col-c2');
	var b = caws_el(n === 1 ? 'col-c2' : 'col-c3');
	var h = caws_el('cawsRz' + n);
	if(!g || !a || !b) return;
	var ka = (n === 1 ? 'c1' : 'c2'), kb = (n === 1 ? 'c2' : 'c3');
	var pxa = a.getBoundingClientRect().width;
	var pxb = b.getBoundingClientRect().width;
	if(pxa + pxb <= 0) return;
	var fa = caws.rz[ka], fb = caws.rz[kb];
	var fpp = (fa + fb) / (pxa + pxb);		/* px 1개당 fr */
	var x0 = e.clientX;

	g.classList.add('caws-rzing');			/* grid transition(.22s) 차단 */
	if(h) h.classList.add('on');
	document.body.style.cursor = 'col-resize';
	document.body.style.userSelect = 'none';

	function mv(ev){
		var dx = ev.clientX - x0;
		if(pxa + dx < CAWS_RZ_MIN[ka]) dx = CAWS_RZ_MIN[ka] - pxa;
		if(pxb - dx < CAWS_RZ_MIN[kb]) dx = pxb - CAWS_RZ_MIN[kb];
		caws.rz[ka] = fa + dx * fpp;
		caws.rz[kb] = fb - dx * fpp;
		caws_rzApply();
		if(!window.ResizeObserver) caws_rzPos();
	}
	function up(){
		document.removeEventListener('mousemove', mv);
		document.removeEventListener('mouseup', up);
		g.classList.remove('caws-rzing');
		if(h) h.classList.remove('on');
		document.body.style.cursor = '';
		document.body.style.userSelect = '';
		caws_rzSave();
		caws_rzPos();
	}
	document.addEventListener('mousemove', mv);
	document.addEventListener('mouseup', up);
}

function caws_rzInit(){
	var g = caws_el('asGrid');
	if(!g || caws_el('cawsRz1')) return;

	/* 저장된 폭 복원 */
	var st = null;
	try{ st = JSON.parse(sessionStorage.getItem(CAWS_RZ_KEY) || 'null'); }catch(e){}
	if(st && +st.c1 > 0 && +st.c2 > 0 && +st.c3 > 0){
		caws.rz = { c1:+st.c1, c2:+st.c2, c3:+st.c3 };
		caws_rzApply();
	}

	/* 핸들 2개 생성 (absolute 라 grid 트랙에 끼지 않는다) */
	for(var n = 1; n <= 2; n++){
		var h = document.createElement('div');
		h.className = 'caws-rz rz' + n;
		h.id = 'cawsRz' + n;
		h.title = '드래그: 폭 조절 / 더블클릭: 기본 폭';
		h.addEventListener('mousedown', (function(no){ return function(e){ caws_rzDown(e, no); }; })(n));
		h.addEventListener('dblclick', caws_rzReset);
		g.appendChild(h);
	}
	caws_rzPos();

	/* 폭이 바뀌는 모든 경로(드래그/접기·넓게보기 transition/창 크기)에서 핸들 위치 동기화 */
	if(window.ResizeObserver){
		var ro = new ResizeObserver(caws_rzPos);
		ro.observe(caws_el('col-c1'));
		ro.observe(caws_el('col-c2'));
		ro.observe(caws_el('col-c3'));
	}else{
		window.addEventListener('resize', caws_rzPos);
	}
}

/* 이 스크립트는 #asGrid 마크업보다 먼저 로드되므로(list.jsp 참고) DOM ready 에 초기화 */
$(function(){ caws_rzInit(); });
/* [AX Lab] 수정 끝 */

/* ESC 로 열려 있는 모달을 닫는다. */
$(document).on('keydown', function(e){
	if(e.keyCode !== 27) return;
	var any = document.querySelectorAll('#asWorkspace .caws-modal[style*="flex"], #asWorkspace .caws-lb[style*="flex"]').length;
	if(any) caws_closeAll();
});
