/* [AX Lab] 신규 파일 (2026-07-23): AS 통합 워크스페이스 로직
   - list.jsp 3분할(목록/상세/처리정보) 화면 전용.
   - 기존 엔드포인트 재사용: getAswsKpi.do(상단 KPI), getAsInfo.do(상세), getAwsList.do(답변),
     awsProc.do(답변등록), form.do(전체편집).
   - 모든 콜백은 common.ajaxCall(datas,url,'콜백명') 규칙상 전역 함수여야 한다. */

var asws = { asNo:'', cnAsNo:'', rowMap:{}, curRow:null };

/* ===== 컬럼 접기/펼치기 ===== */
function asws_toggleCol(w){
	var g = document.getElementById('asGrid');
	var c = document.getElementById('col-'+w);
	if(!g || !c) return;
	var collapsed = c.classList.toggle('is-collapsed');
	g.classList.toggle(w+'-collapsed', collapsed);
}

/* ===== 상태코드 -> 뱃지 클래스 ===== */
function asws_stClass(code){
	code = asws_nvl(code,'');
	if(code=='C001') return 'recv';
	if(code=='C005') return 'done';
	if(code=='C006') return 'cancel';
	if(code=='C003') return 'hold';
	return 'prog';
}
function asws_nvl(v, d){ return (v==null || typeof v=='undefined') ? (d||'') : v; }
function asws_fmtDt(v){
	v = asws_nvl(v,'');
	if(v.length==8 && typeof makeDate=='function') return makeDate(v,'-');
	return v || '-';
}

/* ===== KPI ===== */
/* [AX Lab] 수정 시작 (2026-07-28 AX Lab): 상단 KPI를 "나에게 배정된 건" 기준 6종으로 표시.
   신규 전용 URL은 MenuAuthFilter 권한목록 미등록으로 403 차단되므로, 권한 있는 getAsList.do 응답에
   KPI(data.kpi)를 동봉해 받는다. asws_makeKpi 는 list.jsp 의 setAsList(data) 에서 호출된다. */
function asws_makeKpi(data){
	var k = (data && data.kpi) ? data.kpi : {};
	asws_setText('kpi-today',   Number(asws_nvl(k.KPI1,0)));  // 오늘 나에게 배정된 접수 건수(접수일=오늘)
	asws_setText('kpi-recv',    Number(asws_nvl(k.KPI2,0)));  // 현재 나에게 배정된 미처리 건수(완료/철회 제외)
	asws_setText('kpi-urgent',  Number(asws_nvl(k.KPI3,0)));  // 현재 나에게 배정된 긴급 건수
	asws_setText('kpi-duetoday',Number(asws_nvl(k.KPI4,0)));  // 처리예정일이 오늘인 건수
	asws_setText('kpi-overdue', Number(asws_nvl(k.KPI5,0)));  // 처리예정일 지난 건수
	asws_setText('kpi-donetoday',Number(asws_nvl(k.KPI6,0))); // 오늘 처리완료한 건수

	/* [AX Lab] 수정 시작 (2026-07-28 AX Lab): KPI가 접힌 상태에서도 핵심 수치를 요약 배지로 노출 */
	asws_setText('kpi-recv-mini',    Number(asws_nvl(k.KPI2,0)));
	asws_setText('kpi-urgent-mini',  Number(asws_nvl(k.KPI3,0)));
	asws_setText('kpi-duetoday-mini',Number(asws_nvl(k.KPI4,0)));
	asws_setText('kpi-overdue-mini', Number(asws_nvl(k.KPI5,0)));
	/* [AX Lab] 수정 끝 */
}
/* [AX Lab] 수정 끝 */
function asws_setText(id, v){ var el=document.getElementById(id); if(el) el.innerHTML = v; }

/* [AX Lab] 수정 시작 (2026-07-28 AX Lab): KPI 카드 영역 접기/펼치기.
   UI: 제목 좌측 화살표(kpi-chev)가 CSS 회전으로 상태 표시, 별도 버튼 텍스트 없음.
   [AX Lab] 수정 (2026-07-28 AX Lab): 화면 진입 시 "항상 접힘"으로 고정.
   기존에는 접힘여부를 localStorage 에 저장해 유지했는데, 사용자가 한 번 펼치면 그 뒤로는
   새로고침/재방문해도 계속 펼쳐진 상태로 열려 KPI 카드가 목록을 아래로 밀어냈다.
   → localStorage 저장/복원을 제거. 펼침은 지금 보고 있는 화면에서만 유효하며, 다시 들어오면 접힘이다.
   (접힌 상태에서도 핵심 수치는 kpi-summary 요약으로 계속 보이므로 정보 손실은 없다.) */
var ASWS_KPI_COLLAPSE_KEY = 'asws_kpi_collapsed';	/* 과거 저장값 정리용으로만 남겨둔 키 */

function asws_updateKpiToggleText(collapsed){ /* 화살표 전환 방식으로 변경 후 텍스트 갱신 불필요 — 안전하게 유지 */ }

function asws_toggleKpi(){
	var wrap = document.getElementById('asKpiWrap');
	if(!wrap) return;
	var collapsed = wrap.classList.toggle('collapsed');
	asws_updateKpiToggleText(collapsed);
}

function asws_initKpiCollapse(){
	var wrap = document.getElementById('asKpiWrap');
	if(!wrap) return;
	/* 이전 버전에서 저장해 둔 펼침상태가 남아 있어도 더 이상 쓰지 않으므로 정리한다. */
	try{ localStorage.removeItem(ASWS_KPI_COLLAPSE_KEY); }catch(e){}
	wrap.classList.add('collapsed');	/* 진입 시 항상 접힘 */
	asws_updateKpiToggleText(true);
}
/* [AX Lab] 수정 끝 */
/* [AX Lab] 수정 끝 */

/* ===== 목록 행 클릭 -> 상세/처리정보 로드 ===== */
function asws_openDetail(asNo, cnAsNo){
	if(asws_nvl(asNo,'')=='') return;
	asws.asNo = asNo;
	asws.cnAsNo = asws_nvl(cnAsNo,'');
	asws.curRow = asws.rowMap[asNo] || null;

	$('#asList tr').removeClass('on');
	$('#asList tr[data-asno="'+asNo+'"]').addClass('on');

	$('#pinlabel').text(asNo);
	$('#asDetail').html('<div class="empty">불러오는 중...</div>');
	$('#asRecord').html('<div class="none" style="padding:14px">불러오는 중...</div>');

	var pt = (asws.cnAsNo!=='') ? 'subUpdate' : 'update';
	common.ajaxCall({ as_no:asNo, cn_as_no:asws.cnAsNo, pageType:pt }, '/ad/as/getAsInfo.do', 'asws_renderDetailRecord');
	common.ajaxCall({ as_no:asNo, page:'1' }, '/ad/as/getAwsList.do', 'asws_renderThread');
}

/* ===== COL2 상세 + COL3 처리정보 ===== */
function asws_renderDetailRecord(data){
	var vo  = (typeof data.resultVO != 'undefined' && data.resultVO) ? data.resultVO : {};
	var row = asws.curRow || {};
	var hist = (typeof data.asHistList != 'undefined' && data.asHistList) ? data.asHistList : [];

	var stCode = asws_nvl(row.proc_status, vo.proc_status);
	var stNm   = asws_nvl(row.proc_status_nm, '-');
	var client = '['+asws_nvl(row.cust_code, asws_nvl(vo.cust_code,''))+']'+asws_nvl(row.cust_kor_name,'');
	var callContent = asws_nvl(vo.call_content, asws_nvl(row.call_content,''));
	var applyNm = asws_nvl(vo.apply_nm,'');
	var acceptWhen = asws_fmtDt(asws_nvl(vo.accept_dt, row.accept_dt)) + ' ' + asws_nvl(vo.accept_time,'');

	/* ---- COL2 상세 ---- */
	var titleTxt = callContent ? callContent.split('\n')[0] : ('접수번호 '+asws.asNo);
	if(titleTxt.length>60) titleTxt = titleTxt.substr(0,60)+'...';

	var html = ''
	+ '<div class="dtop">'
	+   '<div><div class="dtitle">'+asws_esc(titleTxt)+'</div>'
	+     '<div class="dmeta">'+asws_esc(client)+' · 접수 '+asws_fmtDt(asws_nvl(vo.accept_dt,row.accept_dt))+' · 담당 '+asws_esc(asws_nvl(row.emp_nm,'-'))+' · 접수번호 '+asws_esc(asws.asNo)+'</div></div>'
	+   '<span class="st '+asws_stClass(stCode)+'">'+asws_esc(stNm)+'</span>'
	+ '</div>';

	// 문의유형/시스템 키워드
	var kws=[];
	if(asws_nvl(row.request_type_nm,'')!='') kws.push(row.request_type_nm);
	if(asws_nvl(row.service_cate_nm,'')!='') kws.push(row.service_cate_nm);
	if(asws_nvl(row.inquiry_type_nm,'')!='') kws.push(row.inquiry_type_nm);
	if(kws.length){
		html += '<div class="kw">';
		for(var k=0;k<kws.length;k++) html += '<span># '+asws_esc(kws[k])+'</span>';
		html += '</div>';
	}

	// 요청(고객) 말풍선 + 답변 스레드 자리
	html += '<div class="thread" id="asThread">'
	     +  '<div class="bubble cust"><div class="bhd"><span class="bname">'+asws_esc(applyNm||'요청')+'</span><span class="btime">'+asws_esc(acceptWhen)+'</span></div>'
	     +  '<div class="btxt">'+asws_esc(callContent||'(요청 내용 없음)')+'</div></div>'
	     +  '<div class="none" style="padding:6px 2px">답변 불러오는 중...</div>'
	     +  '</div>';

	// 인라인 답변 등록 (기존 awsProc.do)
	html += '<div class="reply">'
	     +  '<textarea id="asReplyText" placeholder="고객에게 노출되는 답변 내용을 작성해주세요."></textarea>'
	     +  '<div class="rbar"><span class="hint">고객 노출 · 답변 등록</span>'
	     +  '<button type="button" class="send" onclick="asws_saveAnswer();">답변 등록</button></div>'
	     +  '</div>';

	// AI 영역 (추후 제공)
	html += '<div class="aiblock"><div class="ahd">AI 추천 <span class="soon">추후 제공</span></div>'
	     +  '<div class="adesc">유사 사례 · 관련 공지 · 운영정보 요약 · 답변 초안 기능이 이 영역에 제공될 예정입니다.</div></div>';

	$('#asDetail').html(html);

	/* ---- COL3 처리정보 ---- */
	var priority = asws_nvl(row.priority,'')=='Y' ? '★ 우선' : '-';
	var grade = asws_nvl(row.inportance_nm,'-');
	var gradeCls = (asws_nvl(row.inportance,'')=='C001') ? 'v grade-b' : 'v';
	var sysType = asws_nvl(row.service_cate_nm,'-') + (asws_nvl(row.inquiry_type_nm,'')!='' ? ' / '+row.inquiry_type_nm : '');
	var completeDt = (stCode=='C005') ? asws_nvl(row.as_complete_dt,'-') : '-';
	var stateDate = asws_nvl(row.star_state_date,'-'); if(stateDate.length>10) stateDate=stateDate.substr(0,10);
	var star = asws_stars(row.star_state);
	var applyTel = asws_nvl(vo.apply_tel,'-');

	var rec = ''
	+ '<div class="action-card">'
	+   '<div class="field"><label>현재 처리상태 / 담당자</label>'
	+     '<div class="row"><span class="st '+asws_stClass(stCode)+'">'+asws_esc(stNm)+'</span>'
	+     '<span style="font-size:12.5px;color:var(--ink-2);font-weight:600;">'+asws_esc(asws_nvl(row.emp_nm,'-'))+'</span></div>'
	+   '</div>'
	+   '<a href="javascript:asws_openFull();" class="openfull">상세페이지에서 처리 · 상태 · 담당자 변경 →</a>'
	+ '</div>';

	rec += '<div class="rgroup"><div class="rgtitle">접수정보</div>'
	+ asws_kv('접수번호', asws.asNo)
	+ asws_kv('우선처', priority)
	+ asws_kv('연결된 AS', asws_nvl(row.as_no_link_count,'0')+'건')
	+ asws_kv('접수경로', asws_nvl(vo.accept_route,'-'))
	+ asws_kv('처리예정일', asws_fmtDt(asws_nvl(row.proc_dt, vo.proc_dt)))
	+ asws_kv('문의유형', asws_nvl(row.request_type_nm,'-'))
	+ asws_kv('시스템유형', sysType)
	+ asws_kvc('중요도', grade, gradeCls)
	+ '</div>';

	rec += '<div class="rgroup"><div class="rgtitle">고객사정보</div>'
	+ asws_kv('고객사코드', asws_nvl(row.cust_code, asws_nvl(vo.cust_code,'-')))
	+ asws_kv('거래처명', asws_nvl(row.cust_kor_name,'-'))
	+ asws_kv('신청자', applyNm||'-')
	+ asws_kv('연락처', applyTel)
	+ '</div>';

	rec += '<div class="rgroup"><div class="rgtitle">처리내역</div>'
	+ asws_kv('처리담당자', asws_nvl(row.emp_nm,'-'))
	+ asws_kv('작업시간', asws_nvl(vo.work_time,'-'))
	+ asws_kv('원인유형', asws_nvl(row.cause_type_nm,'-'))
	+ asws_kv('조치유형', asws_nvl(row.action_type_nm,'-'))
	+ asws_kv('처리완료일', completeDt)
	+ asws_kv('검수일', stateDate)
	+ asws_kv('고객평가', star)
	+ '</div>';

	// 조치내용
	var actionContent = asws_nvl(row.action_content,'');
	rec += '<div class="rgroup"><div class="rgtitle">조치내용</div>'
	+ '<div class="btxt" style="font-size:12px;color:var(--ink-2);white-space:pre-line;">'+(actionContent? asws_esc(actionContent) : '<span class="none">조치내용 없음</span>')+'</div></div>';

	// 과거 상담이력
	rec += '<div class="rgroup"><div class="rgtitle">처리 이력</div>';
	if(hist && hist.length){
		for(var h=0;h<hist.length;h++){
			var hi = hist[h];
			var t = asws_nvl(hi.proc_status_nm, asws_nvl(hi.PROC_STATUS_NM,'상태 변경'));
			var regNm = asws_nvl(hi.reg_nm, asws_nvl(hi.REG_NM,''));
			var regDt = asws_nvl(hi.reg_date, asws_nvl(hi.REG_DATE,''));
			var act = asws_nvl(hi.action_content, asws_nvl(hi.ACTION_CONTENT,''));
			rec += '<div class="histitem"><div class="ht">'+asws_esc(t)+'</div>'
			     + '<div class="hm">'+asws_esc(regNm)+(regNm&&regDt?' · ':'')+asws_esc(regDt)+(act? '\n'+asws_esc(act):'')+'</div></div>';
		}
	}else{
		rec += '<div class="none">처리 이력이 없습니다.</div>';
	}
	rec += '</div>';

	$('#asRecord').html(rec);
}

function asws_kv(k,v){ return '<div class="kv"><span class="k">'+asws_esc(k)+'</span><span class="v">'+asws_esc(asws_nvl(v,'-'))+'</span></div>'; }
function asws_kvc(k,v,cls){ return '<div class="kv"><span class="k">'+asws_esc(k)+'</span><span class="'+cls+'">'+asws_esc(asws_nvl(v,'-'))+'</span></div>'; }
function asws_stars(n){
	n = Number(asws_nvl(n,0));
	if(n<1||n>5) return '-';
	var full='★★★★★'.substr(0,n), empty='☆☆☆☆☆'.substr(0,5-n);
	return full+empty;
}

/* ===== 답변 스레드 ===== */
function asws_renderThread(data){
	var box = document.getElementById('asThread');
	if(!box) return;
	var list = (typeof data.resultList != 'undefined' && data.resultList) ? data.resultList : [];

	// 요청(고객) 말풍선은 유지하고, 그 아래 답변만 다시 그림
	var first = box.querySelector('.bubble');
	box.innerHTML = '';
	if(first) box.appendChild(first);

	if(!list.length){
		var n = document.createElement('div');
		n.className='none'; n.style.padding='6px 2px'; n.textContent='등록된 답변이 없습니다.';
		box.appendChild(n);
		return;
	}
	for(var i=0;i<list.length;i++){
		var it = list[i];
		var who = (asws_nvl(it.w_gubun,'')=='U') ? 'cust' : '';
		var b = document.createElement('div');
		b.className = 'bubble '+who;
		b.innerHTML = '<div class="bhd"><span class="bname">'+asws_esc(asws_nvl(it.emp_nm,'-'))+'</span>'
		            + '<span class="btime">'+asws_esc(asws_nvl(it.w_date,''))+'</span></div>'
		            + '<div class="btxt">'+asws_esc(asws_nvl(it.w_content,''))+'</div>';
		box.appendChild(b);
	}
}

/* ===== 인라인 답변 등록 (기존 awsProc.do / answerForm 재사용) ===== */
function asws_saveAnswer(){
	if(asws_nvl(asws.asNo,'')==''){ alert('먼저 목록에서 접수건을 선택해주세요.'); return; }
	var content = $('#asReplyText').val();
	if(typeof common!='undefined' && common.isEmpty ? common.isEmpty(content) : (!content || content.replace(/\s/g,'')=='')){
		alert('답변 내용을 입력해 주세요.'); return;
	}
	var f = document.answerForm;
	f.w_content.value = content;
	f.as_no.value = asws.asNo;
	f.pageType.value = 'insert';

	try{ $('#awsFrame').remove(); }catch(e){}
	var frame = $('<iframe id="awsFrame" name="awsFrame" style="width:0;height:0;display:none;"></iframe>');
	frame.appendTo('body');

	f.method = 'post';
	f.target = 'awsFrame';
	f.action = '/ad/as/awsProc.do';
	f.submit();
}
/* awsProc.do 응답은 parent.awsProcReturn(resultCode) 를 호출한다.
   awsProcReturn 은 기존 팝업과 공유되므로 list.jsp 에서 통합 정의한다. */

/* ===== 전체 편집(상세페이지) ===== */
function asws_openFull(){
	if(asws_nvl(asws.asNo,'')==''){ alert('먼저 목록에서 접수건을 선택해주세요.'); return; }
	var pt = (asws.cnAsNo!=='') ? 'subUpdate' : 'update';
	var url = '/ad/as/form.do?pageType='+pt+'&as_no='+encodeURIComponent(asws.asNo);
	if(asws.cnAsNo!=='') url += '&cn_as_no='+encodeURIComponent(asws.cnAsNo);
	location.href = url;
}

/* ===== HTML escape ===== */
function asws_esc(s){
	s = asws_nvl(s,'');
	return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}

/* =====================================================================
 * [AX Lab] 고급 동적 검색구분 엔진 (2026-07-24)
 *  - 검색구분(select) 을 고르면 타입에 맞는 값 UI(키워드/셀렉트/날짜/거래처모달) 를 렌더한다.
 *  - '+ 조건 추가' 로 행 추가 / '−' 로 행 삭제.
 *  - 같은 항목 2개 이상 = AND 누적. 단, 셀렉트형/거래처는 등호(=) 특성상 중복이 무의미하므로
 *    이미 사용된 항목은 다른 행의 검색구분에서 비활성화하여 중복 추가를 막는다. (asws_advIsSingleUse)
 *  - 폼 정렬 유지를 위해 모든 행은 adv_field / adv_value / adv_value2 를 각각 1개씩 제출한다.
 * ===================================================================== */

/* 검색구분 카탈로그 (key = 쿼리 화이트리스트 키, cg/pc = 공통코드 그룹/부모코드) */
/* [AX Lab] 수정 시작 (2026-07-28 AX Lab): 거래처 조건을 원본 화면과 동일한 "모달 조회" 방식으로 되돌린다.
   기존(리뉴얼 직후): 거래처명 / 거래처코드 를 각각 keyword 로 두어 직접 타이핑 → LIKE 부분일치 검색.
   문제: 원본 화면은 거래처 조회 모달(#div1)에서 거래처를 "골라야" 했고(오타/동명이인 방지),
         쿼리도 cust_kor_name / cust_code 정확일치(=) 조건이었다. 현업이 쓰던 흐름과 달라짐.
   → CUST_KOR_NAME / CUST_CODE 두 항목을 'CUST'(type:'cust') 한 항목으로 통합하고,
     값 UI 는 읽기전용 입력 2개 + [조회] 버튼(기존 showCustLayer 모달 재사용) 으로 렌더한다.
     전송 파라미터도 원본과 동일한 cust_kor_name / cust_code 를 그대로 사용하므로
     쿼리(egov-as-query.xml)와 컨트롤러는 수정하지 않는다.
   ※ 구버전 북마크(adv_field=CUST_KOR_NAME 등)로 들어와도 쿼리의 해당 when 분기는 그대로 남아 있어
     조회 결과는 정상이며, 화면에서는 검색구분이 미선택으로 표시된다. */
var ASWS_ADV_CATALOG = [
	{ key:'AS_NO',         label:'접수번호',      type:'keyword' },
	{ key:'CUST',          label:'거래처명/코드', type:'cust' },
	{ key:'EMP_NM',        label:'처리담당자명',  type:'keyword' },
	{ key:'DEPT',          label:'부서명/코드',   type:'keyword' },
	{ key:'REQUEST_TYPE',  label:'문의유형',      type:'select', cg:'AS',     pc:'CD07' },
	{ key:'SERVICE_CATE',  label:'시스템유형',    type:'select', cg:'AS',     pc:'CD03' },
	{ key:'CAUSE_TYPE',    label:'원인유형',      type:'select', cg:'AS',     pc:'CD05' },
	{ key:'ACTION_TYPE',   label:'조치유형',      type:'select', cg:'AS',     pc:'CD06' },
	{ key:'INPORTANCE',    label:'중요도',        type:'select', cg:'AS',     pc:'CD04' },
	{ key:'PART_TYPE',     label:'파트',          type:'select', cg:'COMMON', pc:'CD13' },
	{ key:'ACCEPT_ROUTE',  label:'접수경로',      type:'select', cg:'AS',     pc:'CD02' },
	{ key:'PROC_DT',       label:'처리예정일',    type:'date' },
	{ key:'COMPLETE_DT',   label:'처리완료일',    type:'date' }
];

function asws_advMeta(key){
	for(var i=0;i<ASWS_ADV_CATALOG.length;i++){ if(ASWS_ADV_CATALOG[i].key===key) return ASWS_ADV_CATALOG[i]; }
	return null;
}

/* 공통코드 동기 로더 (그룹|부모코드 캐시) */
var ASWS_CODE_CACHE = {};
function asws_loadCodes(cg, pc){
	var k = cg+'|'+pc;
	if(ASWS_CODE_CACHE[k]) return ASWS_CODE_CACHE[k];
	var out = [];
	try{
		$.ajax({
			type:'POST', url:'/comm/getCode.do', dataType:'json', async:false,
			data:{ code_group:cg, p_code:pc },
			success:function(d){
				var l = (d && d.resultList) ? d.resultList : [];
				for(var i=0;i<l.length;i++){ out.push({ code:asws_nvl(l[i].code,''), name:asws_nvl(l[i].code_name,'') }); }
			}
		});
	}catch(e){}
	ASWS_CODE_CACHE[k] = out;
	return out;
}

/* YYYYMMDD -> yy/mm/dd (datepicker 표시용) */
function asws_fmtDateInput(v){
	v = (''+asws_nvl(v,'')).replace(/[^0-9]/g,'');
	if(v.length===8) return v.substr(0,4)+'/'+v.substr(4,2)+'/'+v.substr(6,2);
	return v;
}

/* [AX Lab] 수정 시작 (2026-07-28 AX Lab): 중복 추가가 무의미한(1회만 쓸 수 있는) 타입 판정.
   - select : 등호(=) 조건이라 같은 항목을 2개 걸면 결과가 없거나 의미가 없다.
   - cust   : 정확일치(=) 조건 + 값 UI 가 고정 id(cust_kor_name/cust_code)를 쓰는 기존 모달 콜백
              (makeCustInfo)에 의존하므로 화면에 1개만 존재해야 한다. */
function asws_advIsSingleUse(type){ return type==='select' || type==='cust'; }
/* [AX Lab] 수정 끝 */

/* 이미 사용 중인 1회성 검색구분 키 목록 (중복 방지용) */
function asws_advUsedSelectKeys(exceptRowEl){
	var used = {};
	$('#advRows .adv-row').each(function(){
		if(exceptRowEl && this===exceptRowEl) return;
		var f = $(this).find('.adv-field').val();
		var m = asws_advMeta(f);
		if(m && asws_advIsSingleUse(m.type)) used[f] = true;
	});
	return used;
}

/* 검색구분 select 옵션 HTML (1회성 항목의 중복은 disabled) */
function asws_advFieldOptions(selectedKey, rowEl){
	var used = asws_advUsedSelectKeys(rowEl);
	var h = '<option value="">검색구분 선택</option>';
	for(var i=0;i<ASWS_ADV_CATALOG.length;i++){
		var c = ASWS_ADV_CATALOG[i];
		var dis = (asws_advIsSingleUse(c.type) && used[c.key] && c.key!==selectedKey) ? ' disabled' : '';
		var sel = (c.key===selectedKey) ? ' selected' : '';
		h += '<option value="'+c.key+'"'+dis+sel+'>'+asws_esc(c.label)+'</option>';
	}
	return h;
}

/* 모든 행의 검색구분 옵션 재계산(중복 disabled 갱신) */
function asws_advRefreshFieldOptions(){
	$('#advRows .adv-row').each(function(){
		var $f = $(this).find('.adv-field');
		var cur = $f.val();
		$f.html(asws_advFieldOptions(cur, this));
		$f.val(cur);
	});
}

/* 값 UI 렌더 (미선택/keyword/select/cust/date). adv_value, adv_value2 는 항상 각 1개씩 제출 */
function asws_advRenderVal($row, field, value, value2){
	var $val = $row.find('.adv-val');
	var m = asws_advMeta(field);
	value = asws_nvl(value,''); value2 = asws_nvl(value2,'');

	if(!m){
		$val.html('<input type="hidden" name="adv_value" value=""><input type="hidden" name="adv_value2" value="">');
		return;
	}
	if(m.type==='keyword'){
		$val.html('<input type="text" class="adv-input" name="adv_value" placeholder="키워드 입력">'
		        + '<input type="hidden" name="adv_value2" value="">');
		$val.find('input[name=adv_value]').val(value);

	}else if(m.type==='select'){
		var opts = asws_loadCodes(m.cg, m.pc);
		var h = '<select class="adv-input" name="adv_value" title="'+asws_esc(m.label)+' 선택"><option value="">전체선택</option>';
		for(var i=0;i<opts.length;i++){ h += '<option value="'+asws_esc(opts[i].code)+'">'+asws_esc(opts[i].name)+'</option>'; }
		h += '</select><input type="hidden" name="adv_value2" value="">';
		$val.html(h);
		$val.find('select[name=adv_value]').val(value);

	/* [AX Lab] 수정 시작 (2026-07-28 AX Lab): 거래처 조건 = 기존 거래처 조회 모달(#div1) 방식.
	   - 직접 입력을 막고(readonly) [조회] 버튼 또는 입력칸 클릭으로 모달을 띄운다. (원본 화면과 동일)
	   - 전송 파라미터는 원본과 같은 cust_kor_name / cust_code → 쿼리의 기존 정확일치 조건을 그대로 사용.
	   - id 를 cust_kor_name / cust_code 로 두는 이유: 모달에서 거래처를 고르면
	     list.jsp 의 기존 콜백 makeCustInfo() 가 이 id 에 값을 넣는다(원본 흐름 그대로 재사용).
	     CUST 항목은 1행만 추가 가능하므로(asws_advIsSingleUse) id 중복은 발생하지 않는다.
	   - 값을 비우려면 행의 [−] 버튼으로 조건을 삭제하면 된다(원본의 [초기화] 역할).
	   - adv_value / adv_value2 는 빈 hidden 으로 함께 보낸다. 값 전달용이 아니라
	     adv_field / adv_value / adv_value2 배열의 "인덱스 정렬"을 깨지 않기 위한 자리표시자다. */
	}else if(m.type==='cust'){
		$val.html('<input type="text" class="adv-input adv-cust-nm" id="cust_kor_name" name="cust_kor_name" title="거래처명" placeholder="거래처 조회" readonly onclick="showCustLayer();">'
		        + '<input type="text" class="adv-input adv-cust-cd" id="cust_code" name="cust_code" title="거래처코드" placeholder="코드" readonly onclick="showCustLayer();">'
		        + '<button type="button" class="btn-s adv-cust-btn" onclick="showCustLayer();" title="거래처 조회 팝업 열기">조회</button>'
		        + '<input type="hidden" name="adv_value" value=""><input type="hidden" name="adv_value2" value="">');
		$val.find('#cust_kor_name').val(value);
		$val.find('#cust_code').val(value2);
	/* [AX Lab] 수정 끝 */

	}else if(m.type==='date'){
		$val.html('<input type="text" class="adv-input adv-date" name="adv_value" title="시작일">'
		        + '<span class="dwave">~</span>'
		        + '<input type="text" class="adv-input adv-date" name="adv_value2" title="종료일">');
		var $s = $val.find('input[name=adv_value]');
		var $e = $val.find('input[name=adv_value2]');
		try{ $s.datepicker(datepicker); $e.datepicker(datepicker); }catch(e){}
		$s.val(value  ? value  : $.datepicker.formatDate('yy/mm/dd', new Date()));
		$e.val(value2 ? value2 : $.datepicker.formatDate('yy/mm/dd', new Date()));
	}
}

/* [AX Lab] 수정 시작 (2026-07-28 AX Lab): '퇴사자만' 체크박스는 처리담당자명(EMP_NM) 조건이 있을 때만 노출.
   이 체크박스는 쿼리에서 IN_TB.RETIRE_DATE IS NOT NULL (= 처리담당자의 퇴사일이 있는 건) 으로 동작하므로
   처리담당자 조건과 함께 쓸 때만 의미가 있다. 단독으로 켜면 "퇴사자 담당 건 전체"가 나와
   사용자가 의도를 알기 어려운 조회결과가 됐다.
   → EMP_NM 행이 없으면 숨기고, 숨길 때는 체크도 해제해서 "보이지 않는 조건"이 남지 않게 한다. */
function asws_advSyncRetireChk(){
	var wrap = document.getElementById('advRetireWrap');
	if(!wrap) return;
	var hasEmp = false;
	$('#advRows .adv-row').each(function(){
		if($(this).find('.adv-field').val() === 'EMP_NM') hasEmp = true;
	});
	if(hasEmp){
		wrap.style.display = '';
	}else{
		wrap.style.display = 'none';
		$('#search_type17').prop('checked', false);
	}
}
/* [AX Lab] 수정 끝 */

/* [AX Lab] 수정 시작 (2026-07-28 AX Lab): 고급필터가 접혀 있어도 적용중인 조건 개수를 '고급' 칩 배지로 노출.
   필터 영역을 컴팩트하게 줄이면서 조건이 숨겨져 "왜 이 결과인지" 모르게 되는 문제를 막는다. */
function asws_advUpdateCount(){
	/* [AX Lab] 수정 시작 (2026-07-28 AX Lab): 개수를 세기 전에 '퇴사자만' 노출/체크상태를 먼저 정리한다.
	   (행 추가/삭제/변경 시 반드시 호출되는 함수라 여기에 두면 호출 누락이 생기지 않는다) */
	asws_advSyncRetireChk();
	/* [AX Lab] 수정 끝 */
	var badge = document.getElementById('advCnt');
	if(!badge) return;
	var n = 0;
	$('#advRows .adv-row').each(function(){
		if(asws_nvl($(this).find('.adv-field').val(),'') !== '') n++;
	});
	/* [AX Lab] 삭제 (2026-07-28 AX Lab): '처리완료 외 상태' 체크박스가 처리상태 기본 체크로 대체되어 제거됨.
	   search_type13 은 hidden(value='N')으로만 남아 있어 고급조건 개수에서 세지 않는다.
	if($('#search_type13').is(':checked')) n++;
	*/
	if($('#search_type17').is(':checked')) n++;
	badge.innerHTML = n;
	badge.style.display = (n > 0) ? '' : 'none';
}
/* [AX Lab] 수정 끝 */

/* 행 추가 */
function asws_advAddRow(field, value, value2){
	field = asws_nvl(field,''); value = asws_nvl(value,''); value2 = asws_nvl(value2,'');
	var $row = $('<div class="adv-row"></div>');
	var $field = $('<select class="adv-field" name="adv_field" title="검색구분"></select>');
	$field.html(asws_advFieldOptions(field, $row[0]));
	var $val = $('<span class="adv-val"></span>');
	var $del = $('<button type="button" class="adv-del" title="조건 삭제">&#8722;</button>');

	/* [AX Lab] 수정 시작 (2026-07-28 AX Lab): 행 추가/삭제/변경 시 '고급' 칩 배지 개수 갱신 */
	$del.on('click', function(){ $row.remove(); asws_advRefreshFieldOptions(); asws_advUpdateCount(); });
	$field.on('change', function(){ asws_advRenderVal($row, this.value, '', ''); asws_advRefreshFieldOptions(); asws_advUpdateCount(); });

	$row.append($field).append($val).append($del);
	$('#advRows').append($row);
	asws_advRenderVal($row, field, value, value2);
	asws_advRefreshFieldOptions();
	asws_advUpdateCount();
	/* [AX Lab] 수정 끝 */
	return $row;
}

/* 전체 비우기 */
function asws_advClear(){ $('#advRows').empty(); asws_advUpdateCount(); /* [AX Lab] (2026-07-28) 배지 초기화 */ }

/* 리로드 후 저장된 고급조건 복원 (ASWS_ADV_INIT) */
function asws_advInit(){
	asws_advClear();
	var init = (typeof ASWS_ADV_INIT !== 'undefined' && ASWS_ADV_INIT) ? ASWS_ADV_INIT : [];
	for(var i=0;i<init.length;i++){
		var it = init[i] || {};
		var f  = asws_nvl(it.field,'');
		var m  = asws_advMeta(f);
		var v  = asws_nvl(it.value,'');
		var v2 = asws_nvl(it.value2,'');
		if(m && m.type==='date'){ v = asws_fmtDateInput(v); v2 = asws_fmtDateInput(v2); }
		asws_advAddRow(f, v, v2);
	}
	/* [AX Lab] 수정 시작 (2026-07-28 AX Lab): 거래처 조건 행 복원.
	   거래처 행은 원본과 동일한 파라미터(cust_kor_name/cust_code)로 전송되어 adv_* 배열에 담기지 않으므로
	   ASWS_ADV_INIT 에는 들어오지 않는다. list.jsp 의 #advCustInit data 속성(vo 값)으로 별도 복원한다. */
	var $ci = $('#advCustInit');
	if($ci.length){
		var ciNm = asws_nvl($ci.attr('data-name'), '');
		var ciCd = asws_nvl($ci.attr('data-code'), '');
		if(ciNm !== '' || ciCd !== '') asws_advAddRow('CUST', ciNm, ciCd);
	}
	/* [AX Lab] 수정 끝 */
	/* [AX Lab] 수정 시작 (2026-07-28 AX Lab): 복원 후 배지 갱신 + 체크박스형 고급조건 변경 감지
	   (2026-07-28 수정: search_type13 은 체크박스 → hidden 으로 바뀌어 감지 대상에서 제외) */
	asws_advUpdateCount();
	$('#search_type17').off('change.aswsAdvCnt').on('change.aswsAdvCnt', asws_advUpdateCount);
	/* [AX Lab] 수정 끝 */
}

/* 고급필터 패널 토글 */
/* [AX Lab] 수정 시작 (2026-07-28 AX Lab): 고급필터 펼침상태를 검색 후에도 유지.
   원인: 검색(getAsList)은 listFrm 을 /ad/as/list.do 로 재요청해 화면을 처음부터 다시 그린다.
        고급필터 패널은 기본이 '접힘' 이고, 예전에는 "복원된 고급조건이 1건 이상일 때만" 펼쳤다.
        그래서 ① 조건을 넣지 않고 열어만 둔 경우 ② 값이 비어 서버에서 버려진 행만 있는 경우
        ③ '퇴사자만' 체크만 한 경우 에는 검색할 때마다 패널이 닫혀, 조건을 손볼 때 매번 다시 열어야 했다.
   해결: 펼침/접힘을 사용자의 명시적 선택으로 보고 sessionStorage 에 저장한 뒤 재요청 후 복원한다.
        단, "메뉴로 새로 들어온 첫 진입"에서는 복원하지 않고 저장값을 지운다. 첫 화면부터 고급필터가
        펼쳐져 있으면 정작 중요한 목록이 아래로 밀리기 때문이다(KPI 영역을 항상 접힘으로 고정한 것과 동일한 이유).
        첫 진입 판별은 기존 마커인 search_type13(검색 시 'N' 전송)을 재사용한다. */
var ASWS_ADV_OPEN_KEY = 'asws_adv_open';

function asws_advToggle(){
	var b = document.getElementById('advToggle');
	var body = document.getElementById('advBody');
	if(!b || !body) return;
	var open = b.classList.toggle('open');
	if(open) body.classList.add('open'); else body.classList.remove('open');
	try{ sessionStorage.setItem(ASWS_ADV_OPEN_KEY, open ? 'Y' : 'N'); }catch(e){}
}

/* 검색 후 고급필터 펼침상태 복원. asws_advInit() 이후에 호출해야 한다.
   isFirstEntry : 메뉴로 새로 들어온 첫 진입인지 (list.jsp 의 ASWS_IS_FIRST_ENTRY) */
function asws_advRestoreOpen(isFirstEntry){
	var b = document.getElementById('advToggle');
	if(!b) return;
	var saved = null;
	if(isFirstEntry){
		try{ sessionStorage.removeItem(ASWS_ADV_OPEN_KEY); }catch(e){}
	}else{
		try{ saved = sessionStorage.getItem(ASWS_ADV_OPEN_KEY); }catch(e){}
	}
	var open;
	if(saved === 'Y' || saved === 'N'){
		open = (saved === 'Y');
	}else{
		open = ($('#advRows .adv-row').length > 0);	/* 저장값 없음(첫 진입 등): 복원된 조건이 있으면 펼침 */
	}
	if(open !== b.classList.contains('open')) asws_advToggle();
}
/* [AX Lab] 수정 끝 */

/* =====================================================================
 * [AX Lab] 수정 시작 (2026-07-29 AX Lab): A/S 목록 컬럼 개편 부가기능
 *   1) 우측 가로스크롤 셀 렌더 헬퍼 (asws_cell / asws_cell_txt)
 *   2) 헤더 클릭 정렬 (asws_sortBind / asws_sortClick / asws_sortSync / asws_sortInit)
 *   3) 목록 넓게 보기 (asws_toggleListWide / asws_restoreListWide)
 *   4) 문의내용 호버 전문 툴팁 (asws_tipBind / asws_tipShow / asws_tipHide)
 * ===================================================================== */

/* ---- 1) 우측 컬럼 셀 ------------------------------------------------
   값이 비면 '-' 로 보여 빈칸과 구분하고, 잘린 값은 title 로 전체를 확인할 수 있게 한다.
   말줄임 처리를 위해 내부 div(.ct)로 한 번 감싼다. td 에는 overflow 말줄임이 잘 먹지 않는다. */
function asws_cell(v){
	return '<td class="ctxt">'+asws_cell_txt(v)+'</td>';
}
function asws_cell_txt(v){
	v = asws_nvl(v, '');
	var t = (v === '' || v === null) ? '-' : v;
	return '<div class="ct" title="'+asws_esc(v)+'">'+asws_esc(t)+'</div>';
}

/* ---- 2) 헤더 클릭 정렬 ----------------------------------------------
   동작: 미정렬 -> 오름(ASC) -> 내림(DESC) -> 오름 ... 순환. (해제 상태는 두지 않는다.
         "정렬을 풀고 싶다"는 요구보다 "반대로 보고 싶다"는 요구가 압도적으로 많기 때문)
   조회 방식: 페이지 리로드(폼 submit)가 아니라 makeListData() 의 ajax 로 다시 그린다.
             리로드하면 고급필터 펼침/선택행/스크롤 위치가 모두 초기화되어 체감이 나쁘다.
   ※ 정렬을 바꾸면 페이지 구성이 통째로 달라지므로 반드시 1페이지로 되돌린다.
   ※ 서버는 sort_col 을 화이트리스트(AdAsController.AS_SORT_COLS)로 검증하므로, 여기서 보내는 키는
     반드시 그 목록에 있어야 한다. 없으면 조용히 기본정렬(AS_NO DESC)로 처리된다. */
function asws_sortBind(){
	var thead = document.querySelector('#asWorkspace table.aslist thead');
	if(!thead || thead.getAttribute('data-sortbound') === 'Y') return;
	thead.setAttribute('data-sortbound', 'Y');
	thead.addEventListener('click', function(e){
		var th = e.target.closest ? e.target.closest('th.srt') : null;
		if(!th || !thead.contains(th)) return;
		asws_sortClick(th.getAttribute('data-sort'));
	});
}

function asws_sortClick(key){
	key = asws_nvl(key, '');
	if(key === '') return;

	var colEl = document.getElementById('sort_col');
	var dirEl = document.getElementById('sort_dir');
	if(!colEl || !dirEl) return;

	// 같은 컬럼을 다시 누르면 방향만 뒤집고, 다른 컬럼이면 오름차순부터 시작한다.
	var dir = (colEl.value === key && dirEl.value === 'ASC') ? 'DESC' : 'ASC';
	colEl.value = key;
	dirEl.value = dir;

	var pageEl = document.getElementById('page');
	if(pageEl) pageEl.value = '1';

	/* 처리상태 멀티셀렉트는 화면 위젯(SumoSelect)의 선택값이 hidden(#procSelect)에 반영돼 있어야 필터가 유지된다.
	   검색/페이징(list.jsp getAsList)이 하는 것과 동일한 동기화를 정렬에서도 해 준다.
	   ※ 위젯 초기화 전에 호출될 수 있으므로 방어적으로 감싼다. 이 경우 hidden 의 기존 값이 그대로 쓰인다. */
	try{
		if(typeof procSelect !== 'undefined' && procSelect && procSelect.sumo){
			var pe = document.getElementById('procSelect');
			if(pe) pe.value = procSelect.sumo.getSelStr();
		}
	}catch(e){}

	asws_sortSync();
	if(typeof makeListData === 'function') makeListData();
}

/* 현재 정렬 상태를 헤더 화살표에 반영 */
function asws_sortSync(){
	var colEl = document.getElementById('sort_col');
	var dirEl = document.getElementById('sort_dir');
	var col = colEl ? asws_nvl(colEl.value, '') : '';
	var dir = dirEl ? asws_nvl(dirEl.value, '') : '';

	var ths = document.querySelectorAll('#asWorkspace table.aslist thead th.srt');
	for(var i=0; i<ths.length; i++){
		var th = ths[i];
		th.classList.remove('srt-asc', 'srt-desc');
		if(col !== '' && th.getAttribute('data-sort') === col){
			th.classList.add(dir === 'ASC' ? 'srt-asc' : 'srt-desc');
		}
	}
}

/* 화면 진입/검색 리로드 직후 1회 호출 (list.jsp initForm) */
function asws_sortInit(){
	asws_sortBind();
	asws_sortSync();
}

/* ---- 3) 목록 넓게 보기 ----------------------------------------------
   COL2/COL3 을 숨겨 목록을 화면 전체폭으로 쓴다. 우측 34컬럼을 훑을 때 사용한다.
   검색/페이징은 폼 submit 으로 화면을 다시 그리므로 sessionStorage 로 상태를 넘긴다.
   (고급필터 펼침상태와 동일한 방식 - ASWS_ADV_OPEN_KEY 참고) */
var ASWS_LIST_WIDE_KEY = 'asws_list_wide';

function asws_toggleListWide(){
	var g = document.getElementById('asGrid');
	if(!g) return;
	var wide = g.classList.toggle('list-wide');

	/* 목록이 접힌 상태에서 넓게 보기를 켜면 "전체폭인데 내용이 안 보이는" 상태가 되므로 함께 펼친다. */
	if(wide){
		var c1 = document.getElementById('col-c1');
		if(c1 && c1.classList.contains('is-collapsed')) asws_toggleCol('c1');
	}

	asws_syncListWideBtn(wide);
	try{ sessionStorage.setItem(ASWS_LIST_WIDE_KEY, wide ? 'Y' : 'N'); }catch(e){}
}

function asws_syncListWideBtn(wide){
	var b = document.getElementById('listWideBtn');
	if(!b) return;
	b.classList.toggle('on', wide);
	b.innerHTML = wide ? '\u2194 원래대로' : '\u2194 넓게 보기';
	b.title = wide ? '3분할 화면(문의 상세 · 접수/처리 정보)으로 돌아갑니다' : '목록을 화면 전체폭으로 넓혀 우측 컬럼을 봅니다';
}

/* isFirstEntry : 메뉴로 새로 들어온 첫 진입이면 기본 3분할로 시작한다.
   (첫 화면부터 상세 패널이 사라져 있으면 "상세가 왜 안 보이지" 하는 혼란이 생긴다) */
function asws_restoreListWide(isFirstEntry){
	var saved = null;
	if(isFirstEntry){
		try{ sessionStorage.removeItem(ASWS_LIST_WIDE_KEY); }catch(e){}
	}else{
		try{ saved = sessionStorage.getItem(ASWS_LIST_WIDE_KEY); }catch(e){}
	}
	var g = document.getElementById('asGrid');
	if(!g) return;
	var wide = (saved === 'Y');
	g.classList.toggle('list-wide', wide);
	asws_syncListWideBtn(wide);
}

/* ---- 4) 문의내용 호버 툴팁 ------------------------------------------
   목록의 문의내용 칸은 제목 1줄 + 본문 1줄로 잘리므로, 마우스를 올리면 요청내용 전문과 조치내용을
   합쳐 보여준다. 원문은 행 렌더 시 td[data-full] 에 실려 있다(list.jsp setAsList).
   툴팁 요소는 body 직속에 만든다. 목록을 감싼 .tscroll 이 overflow:auto 라 그 안에 넣으면 잘린다. */
var asws_tipEl = null;

function asws_tipBind(){
	var tb = document.getElementById('asList');
	if(!tb || tb.getAttribute('data-tipbound') === 'Y') return;
	tb.setAttribute('data-tipbound', 'Y');

	/* mouseover/mouseout 은 버블링되므로 ajax 로 행을 다시 그려도 재바인딩이 필요 없다. */
	tb.addEventListener('mouseover', function(e){
		var td = e.target.closest ? e.target.closest('td[data-full]') : null;
		if(!td || !tb.contains(td)) return;
		if(asws_tipEl && asws_tipEl.__owner === td) return;	/* 같은 셀 안에서의 이동은 무시 */
		asws_tipShow(td);
	});
	tb.addEventListener('mouseout', function(e){
		var td = e.target.closest ? e.target.closest('td[data-full]') : null;
		if(!td) return;
		/* 셀 내부 자식 요소로 이동한 것뿐이라면 닫지 않는다. */
		var to = e.relatedTarget;
		if(to && td.contains(to)) return;
		asws_tipHide();
	});
	/* 스크롤하면 좌표가 어긋나므로 그냥 닫는다. */
	var sc = document.querySelector('#asWorkspace .tscroll');
	if(sc) sc.addEventListener('scroll', asws_tipHide);
	window.addEventListener('scroll', asws_tipHide, true);
}

function asws_tipShow(td){
	var txt = asws_nvl(td.getAttribute('data-full'), '').replace(/\s+$/, '');
	if(txt === '') return;

	asws_tipHide();
	asws_tipEl = document.createElement('div');
	asws_tipEl.className = 'asws-tip';
	asws_tipEl.textContent = txt;
	asws_tipEl.__owner = td;
	document.body.appendChild(asws_tipEl);

	/* 셀 오른쪽에 붙이되, 화면 밖으로 나가면 왼쪽/위쪽으로 접어 넣는다. */
	var r = td.getBoundingClientRect();
	var w = asws_tipEl.offsetWidth, h = asws_tipEl.offsetHeight;
	var vw = document.documentElement.clientWidth, vh = document.documentElement.clientHeight;

	var left = r.right + 10;
	if(left + w > vw - 8) left = Math.max(8, r.left - w - 10);

	var top = r.top;
	if(top + h > vh - 8) top = Math.max(8, vh - h - 8);

	asws_tipEl.style.left = left + 'px';
	asws_tipEl.style.top  = top + 'px';
}

function asws_tipHide(){
	if(asws_tipEl && asws_tipEl.parentNode) asws_tipEl.parentNode.removeChild(asws_tipEl);
	asws_tipEl = null;
}
/* [AX Lab] 수정 끝 */
