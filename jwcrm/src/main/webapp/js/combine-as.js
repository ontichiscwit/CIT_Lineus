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
   접힘 상태는 localStorage 에 저장해 재방문/새로고침 시에도 유지한다.
   기본 상태: 접힘 (localStorage 에 명시적으로 '0'이 저장된 경우에만 펼침 유지).
   UI: 제목 좌측 화살표(kpi-chev)가 CSS 회전으로 상태 표시, 별도 버튼 텍스트 없음. */
var ASWS_KPI_COLLAPSE_KEY = 'asws_kpi_collapsed';

function asws_updateKpiToggleText(collapsed){ /* 화살표 전환 방식으로 변경 후 텍스트 갱신 불필요 — 안전하게 유지 */ }

function asws_toggleKpi(){
	var wrap = document.getElementById('asKpiWrap');
	if(!wrap) return;
	var collapsed = wrap.classList.toggle('collapsed');
	asws_updateKpiToggleText(collapsed);
	try{ localStorage.setItem(ASWS_KPI_COLLAPSE_KEY, collapsed ? '1' : '0'); }catch(e){}
}

function asws_initKpiCollapse(){
	var wrap = document.getElementById('asKpiWrap');
	if(!wrap) return;
	var saved = null;
	try{ saved = localStorage.getItem(ASWS_KPI_COLLAPSE_KEY); }catch(e){}
	var collapsed = (saved !== '0'); // 기본값: 접힘 (펼침을 명시적으로 선택했을 때만 펼침 유지)
	if(collapsed) wrap.classList.add('collapsed');
	asws_updateKpiToggleText(collapsed);
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
 *  - 검색구분(select) 을 고르면 타입에 맞는 값 UI(키워드/셀렉트/날짜) 를 렌더한다.
 *  - '+ 조건 추가' 로 행 추가 / '−' 로 행 삭제.
 *  - 같은 항목 2개 이상 = AND 누적. 단, 셀렉트형은 등호(=) 특성상 중복이 무의미하므로
 *    이미 사용된 셀렉트 항목은 다른 행의 검색구분에서 비활성화하여 중복 추가를 막는다.
 *  - 폼 정렬 유지를 위해 모든 행은 adv_field / adv_value / adv_value2 를 각각 1개씩 제출한다.
 * ===================================================================== */

/* 검색구분 카탈로그 (key = 쿼리 화이트리스트 키, cg/pc = 공통코드 그룹/부모코드) */
var ASWS_ADV_CATALOG = [
	{ key:'AS_NO',         label:'접수번호',      type:'keyword' },
	{ key:'CUST_KOR_NAME', label:'거래처명',      type:'keyword' },
	{ key:'CUST_CODE',     label:'거래처코드',    type:'keyword' },
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

/* 이미 사용 중인 셀렉트형 검색구분 키 목록 (중복 방지용) */
function asws_advUsedSelectKeys(exceptRowEl){
	var used = {};
	$('#advRows .adv-row').each(function(){
		if(exceptRowEl && this===exceptRowEl) return;
		var f = $(this).find('.adv-field').val();
		var m = asws_advMeta(f);
		if(m && m.type==='select') used[f] = true;
	});
	return used;
}

/* 검색구분 select 옵션 HTML (셀렉트형 중복은 disabled) */
function asws_advFieldOptions(selectedKey, rowEl){
	var used = asws_advUsedSelectKeys(rowEl);
	var h = '<option value="">검색구분 선택</option>';
	for(var i=0;i<ASWS_ADV_CATALOG.length;i++){
		var c = ASWS_ADV_CATALOG[i];
		var dis = (c.type==='select' && used[c.key] && c.key!==selectedKey) ? ' disabled' : '';
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

/* 값 UI 렌더 (미선택/keyword/select/date). name 은 항상 adv_value, adv_value2 유지 */
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

/* [AX Lab] 수정 시작 (2026-07-28 AX Lab): 고급필터가 접혀 있어도 적용중인 조건 개수를 '고급' 칩 배지로 노출.
   필터 영역을 컴팩트하게 줄이면서 조건이 숨겨져 "왜 이 결과인지" 모르게 되는 문제를 막는다. */
function asws_advUpdateCount(){
	var badge = document.getElementById('advCnt');
	if(!badge) return;
	var n = 0;
	$('#advRows .adv-row').each(function(){
		if(asws_nvl($(this).find('.adv-field').val(),'') !== '') n++;
	});
	if($('#search_type13').is(':checked')) n++;
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
	/* [AX Lab] 수정 시작 (2026-07-28 AX Lab): 복원 후 배지 갱신 + 체크박스형 고급조건 변경 감지 */
	asws_advUpdateCount();
	$('#search_type13, #search_type17').off('change.aswsAdvCnt').on('change.aswsAdvCnt', asws_advUpdateCount);
	/* [AX Lab] 수정 끝 */
}

/* 고급필터 패널 토글 */
function asws_advToggle(){
	var b = document.getElementById('advToggle');
	var body = document.getElementById('advBody');
	if(!b || !body) return;
	var open = b.classList.toggle('open');
	if(open) body.classList.add('open'); else body.classList.remove('open');
}
