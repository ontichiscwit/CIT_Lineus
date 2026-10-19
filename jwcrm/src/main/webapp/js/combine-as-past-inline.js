/* =============================================================================
 * [AX Lab] 신규 파일 (2026-10-12): AS 통합화면 - 연관 이력 / 과거 상담이력 "그 자리에서 펼쳐 보기"
 * -----------------------------------------------------------------------------
 * 문제
 *   COL3 의 [연관 이력](combine-as-keyword.js) 과 [과거 상담이력](combine-as-thread.js) 항목을
 *   누르면 caws_pastOpen() → asws_openDetail() 로 "지금 보고 있던 접수건"이 통째로 그 건으로
 *   바뀌었다. 상담원은 참고로 과거 건을 잠깐 보고 싶었을 뿐인데 보던 문의가 사라지고,
 *   돌아오려면 COL1 목록에서 다시 찾아 눌러야 했다.
 *
 * 해결
 *   항목을 누르면 그 항목 "바로 아래"에 과거 건의 내용(문의 전문 · 첨부 · 고객/담당자 답변 ·
 *   조치이력)을 펼쳐 보여 준다. 현재 선택한 접수건(COL2 타임라인 / COL3 접수처리정보)은
 *   그대로 둔다. 같은 항목을 다시 누르거나 [×] 를 누르면 접힌다.
 *   예전처럼 그 건으로 완전히 넘어가고 싶으면 펼친 패널의 [이 건으로 이동] 을 누른다
 *   (= 기존 caws_pastOpen 그대로).
 *
 * 전역 접두어는 cpi_ (Combine as Past Inline) 로 통일한다.
 *
 * 조회
 *   기존 /ad/as/getAsInfo.do (pageType=update|subUpdate) 를 그대로 쓴다. asDAO.getAsInfo 는
 *   순수 SELECT 라 부작용이 없고, 응답에 awsList(답변)·asHistList(조치이력)·attachList(첨부)가
 *   이미 동봉된다(AdAsController.getAsInfo 2026-07-30 확장분).
 *   ★ 신규 URL 을 만들지 않는 이유는 다른 combine-as-*.js 머리말과 같다
 *     (MenuAuthFilter.isAccept() 완전일치 → 신규 /ad/as/*.do 는 403).
 *   ★ common.ajaxCall 은 동기(async:false)라 응답까지 화면이 멈춘다. $.ajax async 로 호출한다.
 *
 * 기존 파일 변경점 (grep "[AX Lab]" + "2026-10-12")
 *   - combine-as-thread.js  caws_setPast()  : 항목 onclick → cpi_toggle(this, …) (미로드 시 caws_pastOpen 폴백)
 *   - combine-as-keyword.js ckw_listHtml()  : 항목 onclick → cpi_toggle(this, …) (동일 폴백)
 *   - list.jsp : 이 파일 / combine-as-past-inline.css 로드 추가
 *   caws_pastOpen() 자체는 손대지 않았다. 상위접수번호 링크와 [이 건으로 이동] 이 계속 쓴다.
 *
 * 다시 그려질 때
 *   #cawsPastList(기간/검색) · #ckwBox(칩 선택) · #asRecord(필드 편집) 가 다시 그려지면 패널 DOM 이
 *   같이 사라진다. 열어 둔 접수번호를 기억해 두고, 같은 항목이 다시 그려지면(data-cpi 속성)
 *   패널을 도로 꽂는다(cpi_remount). 접수건 자체가 바뀌면(caws_renderAll) 상태와 캐시를 비운다.
 *
 * 의존 : jQuery, combine-as.js(asws_stClass), combine-as-thread.js(caws_* 유틸 / caws_filesHtml),
 *        combine-as-keyword.js(ckw_render 를 감싼다 — 없어도 동작은 한다)
 *        list.jsp 에서 위 세 파일보다 "뒤에" 로드할 것.
 * ========================================================================== */

/* ===== 상태 ===== */
var cpi = {
	asNo:'', cn:'',		/* 펼쳐 둔 과거 건 (비어 있으면 닫힘) */
	src:'',				/* 어느 목록에서 열었나 : ckw(연관 이력) | past(과거 상담이력) */
	status:'idle',		/* idle | loading | ok | fail */
	data:null,
	errMsg:'',
	seq:0,				/* 응답 역전 방지용 요청 일련번호 */
	cache:{},			/* as_no → getAsInfo 응답. 현재 접수건이 바뀌면 비운다 */
	main:''				/* 캐시가 유효한 "현재 접수건" 번호 */
};

var CPI_URL = '/ad/as/getAsInfo.do';

/* ===== 유틸 ===== */
function cpi_nvl(v, d){ return (v==null || typeof v=='undefined' || v==='') ? (typeof d=='undefined' ? '' : d) : v; }
function cpi_esc(s){
	if(typeof caws_esc === 'function') return caws_esc(s);
	return String(cpi_nvl(s,'')).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;').replace(/'/g,'&#39;');
}
function cpi_el(id){ return document.getElementById(id); }
function cpi_date(v){ return (typeof caws_date === 'function') ? caws_date(v) : cpi_nvl(v,'-'); }
function cpi_time(v){ return (typeof caws_time === 'function') ? caws_time(v) : ''; }
function cpi_stamp(v){ return (typeof caws_stamp === 'function') ? caws_stamp(v) : cpi_nvl(v,''); }
function cpi_ts(v){ return (typeof caws_ts === 'function') ? caws_ts(v) : 0; }
function cpi_codeNm(pc, code){
	if(cpi_nvl(code,'') === '') return '';
	if(typeof caws_codeNm !== 'function') return String(code);
	var nm = caws_codeNm('AS', pc, code);
	return (nm === '-') ? '' : nm;
}
function cpi_stClass(code){ return (typeof asws_stClass === 'function') ? asws_stClass(cpi_nvl(code,'')) : ''; }
function cpi_files(list){ return (typeof caws_filesHtml === 'function' && list && list.length) ? caws_filesHtml(list, -1) : ''; }

/* 항목 버튼이 들어 있는 스크롤 목록(.ckw-list / .caws-pastlist).
   패널이 열려 있는 동안 이 목록의 max-height 를 풀어(CSS .cpi-expanded) 스크롤이 COL3 전체로 가게 한다.
   260~300px 상자 안에서 과거 건 전문을 읽게 하면 이중 스크롤이 되어 불편하다. */
function cpi_scroller(el){
	while(el && el !== document.body){
		if(el.classList && (el.classList.contains('ckw-list') || el.classList.contains('caws-pastlist'))) return el;
		el = el.parentNode;
	}
	return null;
}

/* =============================================================================
 * 1) 열기 / 닫기
 * ========================================================================== */
/**
 * 연관 이력 / 과거 상담이력 항목 클릭.
 * @param btn    클릭한 항목 버튼(.ckw-it / .caws-pit). 이 바로 아래에 패널을 꽂는다.
 * @param asNo   과거 건 접수번호
 * @param cnAsNo 상위 접수번호(하위작업이면 값이 있다) — getAsInfo 의 pageType 결정에만 쓴다
 */
function cpi_toggle(btn, asNo, cnAsNo){
	asNo = cpi_nvl(asNo,''); cnAsNo = cpi_nvl(cnAsNo,'');
	if(asNo === '') return;

	/* 같은 항목을 다시 누르면 닫기만 한다 */
	var same = (cpi.asNo === asNo && !!cpi_el('cpiPanel'));
	cpi_close();
	if(same) return;

	cpi.asNo = asNo;
	cpi.cn   = cnAsNo;
	cpi.src  = (btn && btn.classList && btn.classList.contains('ckw-it')) ? 'ckw' : 'past';
	cpi_attach(btn);
	cpi_load(asNo, cnAsNo);
}

/* 버튼 바로 뒤(형제)에 패널을 만든다.
   ★ 버튼 "안"에 넣지 않는다. <button> 안의 클릭은 전부 버튼 onclick 으로 올라가서
     패널 안의 [다운로드]·[닫기] 를 누를 때마다 토글이 같이 걸린다. */
function cpi_attach(btn){
	if(!btn || !btn.parentNode) return null;
	var p = document.createElement('div');
	p.id = 'cpiPanel';
	p.className = 'cpi-panel';
	p.innerHTML = cpi_html();
	btn.classList.add('cpi-on');
	btn.parentNode.insertBefore(p, btn.nextSibling);
	var sc = cpi_scroller(btn);
	if(sc) sc.classList.add('cpi-expanded');
	return p;
}

function cpi_close(){
	var p = cpi_el('cpiPanel');
	if(p){
		var sc = cpi_scroller(p);
		if(sc) sc.classList.remove('cpi-expanded');
		if(p.parentNode) p.parentNode.removeChild(p);
	}
	var on = document.querySelectorAll('#asWorkspace .cpi-on');
	for(var i=0; i<on.length; i++) on[i].classList.remove('cpi-on');
	cpi.asNo = ''; cpi.cn = ''; cpi.src = '';
	cpi.status = 'idle'; cpi.data = null; cpi.errMsg = '';
	cpi.seq++;				/* 아직 안 돌아온 응답은 버린다 */
}

/* 접수건이 바뀌었을 때 : 패널을 닫고 캐시도 비운다.
   (캐시를 남겨 두면 [이 건으로 이동] → 수정 → 원래 건으로 복귀 → 다시 펼쳤을 때 옛 내용이 보인다) */
function cpi_reset(){
	cpi_close();
	cpi.cache = {};
}

/* [AX Lab] 수정 시작 (2026-10-12 AX Lab): [이 건으로 이동]은 통합 AS 화면 새 탭에서 해당 건을 선택한다 */
function cpi_go(){
	var a = cpi.asNo, c = cpi.cn;
	if(a === '') return;
	var url = '/ad/as/list.do?as_no=' + encodeURIComponent(a);
	if(c !== '') url += '&cn_as_no=' + encodeURIComponent(c);
	var opened = window.open(url, '_blank', 'noopener');
	if(opened) opened.opener = null;
	cpi_close();
}
/* [AX Lab] 수정 끝 */

/* =============================================================================
 * 2) 조회 (기존 getAsInfo.do 무수정 재사용)
 * ========================================================================== */
function cpi_load(asNo, cn){
	var c = cpi.cache[asNo];
	if(c){ cpi.status = 'ok'; cpi.data = c; cpi_paint(); return; }

	cpi.status = 'loading';
	cpi_paint();

	var my = ++cpi.seq;
	$.ajax({
		type     : 'POST',
		url      : CPI_URL,
		dataType : 'json',
		async    : true,
		timeout  : 30000,
		data     : { as_no:asNo, cn_as_no:cn, pageType:(cn !== '' ? 'subUpdate' : 'update') },
		success  : function(d){
			if(my !== cpi.seq || cpi.asNo !== asNo) return;		/* 그 사이 닫았거나 다른 항목을 열었다 */
			if(!d || !d.resultVO){
				cpi.status = 'fail';
				cpi.errMsg = '접수건 정보를 찾을 수 없습니다.';
				cpi_paint();
				return;
			}
			cpi.cache[asNo] = d;
			cpi.data   = d;
			cpi.status = 'ok';
			cpi_paint();
		},
		error : function(xhr, textStatus){
			if(my !== cpi.seq || cpi.asNo !== asNo) return;
			cpi.status = 'fail';
			cpi.errMsg = (textStatus === 'timeout')
			           ? '조회가 오래 걸려 중단했습니다.'
			           : '내용을 불러오지 못했습니다.' + (xhr && xhr.status ? ' (HTTP '+xhr.status+')' : '');
			cpi_paint();
		}
	});
}

function cpi_paint(){
	var p = cpi_el('cpiPanel');
	if(!p) return;
	p.innerHTML = cpi_html();
	/* 목록 아래쪽 항목을 열었을 때 패널이 COL3 스크롤 밖에 있으면 보이도록 끌어온다 */
	if(cpi.status === 'ok' || cpi.status === 'fail'){
		try{ p.scrollIntoView({ block:'nearest', behavior:'smooth' }); }
		catch(e){ try{ p.scrollIntoView(false); }catch(e2){} }
	}
}

/* =============================================================================
 * 3) 렌더
 * ========================================================================== */
function cpi_html(){
	var h = ''
	+ '<div class="cpi-hd">'
	+   '<span class="cpi-tit">과거 건 미리보기</span>'
	+   '<span class="cpi-no">' + cpi_esc(cpi.asNo) + '</span>'
	+   '<span class="cpi-sp"></span>'
	/* [AX Lab] 수정 시작 (2026-10-12 AX Lab): 현재 AS를 유지하고 통합 AS 화면 새 탭에서 과거 접수건 선택 */
	+   '<button type="button" class="caws-minib" onclick="cpi_go();" title="통합 AS 화면을 새 탭으로 열어 이 접수건을 선택합니다">이 건으로 이동</button>'
	/* [AX Lab] 수정 끝 */
	+   '<button type="button" class="caws-minib cpi-x" onclick="cpi_close();" title="닫기">&#215;</button>'
	+ '</div>';

	if(cpi.status === 'loading'){
		return h + '<div class="cpi-none"><span class="cpi-spin"></span>내용을 불러오는 중&hellip;</div>';
	}
	if(cpi.status === 'fail'){
		return h + '<div class="cpi-none err">' + cpi_esc(cpi.errMsg)
		         + ' <button type="button" class="caws-minib" onclick="cpi_retry();">다시 시도</button></div>';
	}
	if(cpi.status !== 'ok' || !cpi.data) return h;

	var d  = cpi.data, vo = d.resultVO || {};
	var files1 = d.attachList  || [];		/* 접수 첨부 */
	var files2 = d.attachList2 || [];		/* 처리 첨부 */

	/* ---- 요약 줄 : 접수일시 · 상태 · 담당자 · 문의유형 · 시스템 · 완료일 ---- */
	var when = cpi_date(cpi_nvl(vo.accept_dt,''));
	var tm   = cpi_time(cpi_nvl(vo.accept_time,''));
	if(tm !== '') when += ' ' + tm;
	var stNm  = cpi_codeNm('CD01', vo.proc_status);
	var reqNm = cpi_codeNm('CD07', vo.request_type);
	/* [AX Lab] 수정 시작 (2026-10-19 AX Lab): 서버가 제공한 시스템유형 명칭을 우선 사용하고 코드 조회는 폴백으로 유지 */
	var sysNm = cpi_nvl(vo.service_cate_nm,'');
	if(sysNm === '' && cpi_nvl(vo.service_cate,'') !== '') sysNm = cpi_codeNm('CD03', vo.service_cate);
	if(cpi_nvl(vo.inquiry_type,'') !== ''){
		var sub = cpi_nvl(vo.inquiry_type_nm,'');
		if(sub === '') sub = cpi_codeNm(cpi_nvl(vo.service_cate,''), vo.inquiry_type);
		if(sub !== '') sysNm += (sysNm !== '' ? ' / ' : '') + sub;
	}
	/* [AX Lab] 수정 끝 */
	var doneDt = cpi_date(cpi_nvl(vo.complete_dt,''));

	h += '<div class="cpi-meta">'
	  +    '<span class="cpi-when">' + cpi_esc(when) + '</span>'
	  +    (stNm !== '' ? '<span class="st ' + cpi_stClass(vo.proc_status) + '">' + cpi_esc(stNm) + '</span>' : '')
	  +    '<span class="cpi-mi"><em>담당</em>' + cpi_esc(cpi_nvl(vo.assign_nm, cpi_nvl(vo.assign_id,'-'))) + '</span>'
	  +    (reqNm !== '' ? '<span class="cpi-mi"><em>문의유형</em>' + cpi_esc(reqNm) + '</span>' : '')
	/* [AX Lab] 수정 시작 (2026-10-19 AX Lab): 목록과 같은 명칭으로 시스템유형 표시 */
	  +    (sysNm !== '' ? '<span class="cpi-mi"><em>시스템유형</em>' + cpi_esc(sysNm) + '</span>' : '')
	/* [AX Lab] 수정 끝 */
	  +    (doneDt !== '' && doneDt !== '-' ? '<span class="cpi-mi"><em>완료</em>' + cpi_esc(doneDt) + '</span>' : '')
	  +  '</div>';

	/* ---- 문의 내용 (전문) ---- */
	var q = cpi_nvl(vo.call_content,'');
	var applyNm = cpi_nvl(vo.rl_apply_nm, cpi_nvl(vo.apply_nm,''));
	h += '<div class="cpi-sec">'
	  +    '<div class="cpi-sl">문의 내용' + (applyNm !== '' ? '<em>' + cpi_esc(applyNm) + '</em>' : '') + '</div>'
	  +    '<div class="cpi-txt">' + (q !== '' ? cpi_esc(q) : '<span class="none">요청내용 없음</span>') + '</div>'
	  +    cpi_files(files1)
	  +  '</div>';

	/* ---- 답변 · 조치이력 : 시간순 한 줄기 (caws_buildEvents 와 같은 필드를 읽는다) ---- */
	var evs = cpi_events(d);
	h += '<div class="cpi-sec">'
	  +    '<div class="cpi-sl">답변 · 조치<em>' + evs.length + '건</em></div>';
	if(!evs.length){
		h += '<div class="cpi-none">답변·조치 이력이 없습니다.</div>';
	}else{
		for(var i=0; i<evs.length; i++){
			var e = evs[i];
			h += '<div class="cpi-ev k-' + e.kind + '">'
			  +    '<div class="cpi-evh">'
			  +      '<i class="cpi-lb">' + cpi_esc(e.label) + '</i>'
			  +      '<b>' + cpi_esc(e.who) + '</b>'
			  +      '<span class="cpi-evw">' + cpi_esc(e.when) + '</span>'
			  +      (e.status !== '' ? '<span class="st ' + cpi_stClass(e.statusCode) + '">' + cpi_esc(e.status) + '</span>' : '')
			  +    '</div>'
			  +    (e.sub !== '' ? '<div class="cpi-evs">' + cpi_esc(e.sub) + '</div>' : '')
			  +    (e.text !== '' ? '<div class="cpi-txt">' + cpi_esc(e.text) + '</div>' : '')
			  +    cpi_files(e.files)
			  +  '</div>';
		}
	}
	h += '</div>';

	/* ---- 처리 첨부(처리완료사항의 파일)는 있을 때만 ---- */
	if(files2.length){
		h += '<div class="cpi-sec"><div class="cpi-sl">처리 첨부<em>' + files2.length + '</em></div>' + cpi_files(files2) + '</div>';
	}
	return h;
}

/* getAsInfo 응답의 awsList(답변) + asHistList(조치이력)를 시간 오름차순으로 합친다.
   필드 해석은 combine-as-thread.js 의 caws_buildEvents() 와 동일하게 맞췄다
   (W_GUBUN U=고객/A=직원, 이관 코멘트 접두어 CAWS_TR_PREFIX, 조치이력은 SEQ 오름차순). */
function cpi_events(d){
	var out = [], i;
	var aws  = d.awsList    || [];
	var hist = (d.asHistList || []).slice(0).sort(function(x, y){
		return Number(cpi_nvl(x.seq,0)) - Number(cpi_nvl(y.seq,0));
	});
	var prefix = (typeof CAWS_TR_PREFIX !== 'undefined') ? CAWS_TR_PREFIX : '[이관] ';

	for(i=0; i<aws.length; i++){
		var a = aws[i], isCust = (cpi_nvl(a.w_gubun,'') === 'U');
		out.push({
			kind: isCust ? 'cust' : 'staff',
			label: isCust ? '고객' : '담당자',
			who:  cpi_nvl(a.emp_nm,'') || (isCust ? '고객' : '담당자'),
			when: cpi_stamp(a.w_date),
			ts:   cpi_ts(a.w_date), ord:out.length,
			status:'', statusCode:'', sub:'',
			text: cpi_nvl(a.w_content,''),
			files:(a.amap && a.amap.attachList) ? a.amap.attachList : []
		});
	}
	for(i=0; i<hist.length; i++){
		var hi  = hist[i];
		var raw = cpi_nvl(hi.action_content,'');
		var tr  = (raw.indexOf(prefix) === 0);
		var subs = [];
		var acc = cpi_nvl(hi.emp_nm, cpi_nvl(hi.acceptor,''));
		if(acc !== '') subs.push('담당 ' + acc);
		var pd = cpi_date(cpi_nvl(hi.proc_dt,''));
		if(pd !== '' && pd !== '-') subs.push('처리예정 ' + pd);
		if(cpi_nvl(hi.inportance,'') !== '') subs.push('중요도 ' + hi.inportance);	/* getAsHistList 는 CODE_NAME 이 담겨 온다 */
		out.push({
			kind: 'act',
			label: tr ? '이관' : '조치',
			who:  cpi_nvl(hi.reg_nm,'-'),
			when: cpi_stamp(hi.reg_date),
			ts:   cpi_ts(hi.reg_date), ord:out.length,
			status: cpi_nvl(hi.proc_status_nm,''), statusCode: cpi_nvl(hi.proc_status,''),
			sub:  subs.join(' · '),
			text: tr ? raw.substr(prefix.length) : raw,
			files:(hi.amap && hi.amap.attachList) ? hi.amap.attachList : []
		});
	}
	out.sort(function(x, y){ return (x.ts - y.ts) || (x.ord - y.ord); });
	return out;
}

function cpi_retry(){
	if(cpi.asNo === '') return;
	delete cpi.cache[cpi.asNo];
	cpi_load(cpi.asNo, cpi.cn);
}

/* =============================================================================
 * 4) 다시 그려졌을 때 도로 꽂기
 * -----------------------------------------------------------------------------
 * 항목 버튼에 data-cpi="접수번호" 가 있다(두 목록의 마크업에 넣어 두었다). 열어 둔 번호와
 * 같은 버튼이 "원래 열었던 목록"에 다시 그려지면 그 아래에 패널을 다시 만든다.
 * 같은 과거 건이 연관 이력과 과거 상담이력 양쪽에 뜨는 일이 흔해서, 어느 쪽에서 열었는지(src)로
 * 가른다. 안 그러면 위쪽 목록 하나를 눌렀는데 아래 목록에도 패널이 생긴다.
 * ========================================================================== */
function cpi_remount(){
	if(cpi.asNo === '' || cpi_el('cpiPanel')) return;
	var cls = (cpi.src === 'ckw') ? '.ckw-it' : '.caws-pit';
	var btn = document.querySelector('#asRecord ' + cls + '[data-cpi="' + cpi.asNo + '"]');
	if(!btn) return;
	cpi_attach(btn);
}

/* =============================================================================
 * 5) 기존 함수 래핑 (combine-as-keyword.js / combine-as-ai.js 와 같은 방식)
 *   - caws_renderAll (앞) : 접수건이 바뀌었으면 상태·캐시 초기화. 같은 건 재조회(답변 등록 후)면 유지.
 *                           ★ "앞"에서 해야 한다. 원본 안에서 caws_setPast 가 먼저 돌아 옛 패널을
 *                             새 건의 목록에 꽂았다가 다시 떼는 헛걸음을 막는다.
 *   - caws_clear          : 선택 해제 → 초기화
 *   - caws_setPast        : 과거 상담이력 목록이 다시 그려짐 → 도로 꽂기
 *   - ckw_render          : 연관 이력 블록이 다시 그려짐 → 도로 꽂기
 *   - caws_renderRecord   : #asRecord 전체가 다시 그려짐(필드 편집 열기/닫기 등). 과거 상담이력 목록은
 *                           caws_pastHtml() 이 caws.past 상태로 동기 복원하므로 caws_setPast 를 거치지 않는다
 *                           → 여기서도 도로 꽂는다. setTimeout(0) 은 keyword.js 의 ckw_remount 와 같은 이유
 *                           (원본 렌더 흐름이 끝난 뒤에 붙인다).
 *   (함수 선언은 전역 객체의 속성이라 재대입이 기존 호출부에 그대로 보인다)
 * ========================================================================== */
(function(){
	function wrap(name, before, after){
		if(typeof window[name] !== 'function') return;
		var _o = window[name];
		window[name] = function(){
			if(before){ try{ before.apply(this, arguments); }catch(e){} }
			var r = _o.apply(this, arguments);
			if(after){ try{ after.apply(this, arguments); }catch(e){} }
			return r;
		};
	}
	wrap('caws_renderAll', function(){
		var now = (typeof asws !== 'undefined' && asws) ? cpi_nvl(asws.asNo,'') : '';
		if(now !== cpi.main){ cpi_reset(); cpi.main = now; }
	}, null);
	wrap('caws_clear',   null, function(){ cpi_reset(); cpi.main = ''; });
	wrap('caws_setPast', null, function(){ cpi_remount(); });
	wrap('ckw_render',   null, function(){ cpi_remount(); });
	wrap('caws_renderRecord', null, function(){ setTimeout(function(){ cpi_remount(); }, 0); });
})();
