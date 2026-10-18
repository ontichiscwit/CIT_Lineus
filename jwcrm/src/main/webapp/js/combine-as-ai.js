/* =============================================================================
 * [AX Lab] 신규 파일 (2026-10-06): AS 통합화면 - AI 추천 (유사 상담사례 / 과거사례 / 공지)
 * -----------------------------------------------------------------------------
 * 설계서 : mdfile/AS통합화면_AI추천_통합설계.md  §6(API) §8(UI) §9(보안)
 * 접두어 : cai_ (Combine As aI)
 *
 * 화면 구성 (§8-3 2단 구성)
 *   1단 팝오버(285px) = 추천 "목록"만. 문의 카드 우측 상단 [✦ AI 추천 N] 버튼을 누르면 열린다.
 *                        combine-as-thread.js 의 caws_aiRecommendHtml()/caws_aiToggle() 이 이 파일의
 *                        cai_buttonHtml()/cai_toggle() 로 위임한다. 이 파일이 없으면 기존 플레이스홀더 그대로.
 *   2단 COL3 상세      = 목록 항목 클릭 → #asRecord 맨 위에 #caiBox 를 꽂아 본문(answer_html)을 보여준다.
 *   3단 넓게 보기      = 상세 헤더 [넓게] → 기존 asws_toggleCol('c1') 로 COL1 을 접어 COL3 를 698px 로 넓힌다.
 *
 * 호출 (§8-9)
 *   caws_renderAll() 직후 비동기로 /ad/as/getAsInfo.do?pageType=aiRecommend 를 1회 호출한다.
 *   - 기존 URL 재사용 : MenuAuthFilter 완전일치 권한 때문에 신규 URL 은 403 (combine-as-thread.js 상단 제약 ①)
 *   - 동기 common.ajaxCall 을 쓰지 않는다 : 추천은 최대 2.5s 가 걸릴 수 있어 화면을 멈추면 안 된다.
 *   - 같은 as_no 결과는 메모리에 캐시해 재진입 시 재호출하지 않는다(§6 실패 처리 '재진입').
 *   - 실패(result != 000) 는 조용히 플레이스홀더(추후 제공)로 돌아간다. 알림을 띄우지 않는다.
 *
 * 보안 (§8-5 / §9)
 *   - answer_html 은 서버(챗봇)가 화이트리스트(p br ul ol li strong em code)로 정제한 HTML 이다 → innerHTML 로만.
 *   - answer_text 는 textarea 값으로만 쓴다(답변 초안 삽입). 역으로 쓰지 않는다.
 *   - 그 외 모든 문자열(title/topic/파일명 …)은 caws_esc 로 이스케이프한다.
 *   - 응답에는 cust_code / cust_nm 이 없다. 화면도 거래처를 표시하지 않는다.
 *
 * 기존 파일과의 관계
 *   - combine-as-thread.js : caws_aiRecommendHtml / caws_aiToggle 2곳만 위임 분기 추가([AX Lab] 마커).
 *   - combine-as-keyword.js : 같은 #asRecord 를 쓰지만 그쪽은 .caws-past "위", 이쪽은 #asRecord "맨 위"라 겹치지 않는다.
 *   - caws_renderRecord() 가 #asRecord 를 통째로 다시 그리므로 keyword.js 와 같은 방식으로 감싸 다시 꽂는다.
 * ========================================================================== */

var cai = {
	asNo:'',                 /* 지금 추천을 보고 있는 접수번호 */
	status:'idle',           /* idle | loading | ok | fail */
	items:[],
	result:'',
	cache:{},                /* as_no → {status, items, result} */
	sel:-1,                  /* COL3 상세에 열린 항목 index (-1 = 닫힘) */
	seq:0,                   /* 응답 순서 꼬임 방지용 요청 일련번호 */
	fu:null                  /* [AX Lab] 2026-10-16 재촉·연락 요청 문의 판정 {on, nag, k, empty} (구 서버면 null) */
};

var CAI_URL = '/ad/as/getAsInfo.do';
var CAI_TIER = { 1:{ cls:'t1', label:'표준답변' }, 2:{ cls:'t2', label:'과거사례' }, 3:{ cls:'t3', label:'공지' } };

/* ===== 유틸 ===== */
function cai_esc(s){ return (typeof caws_esc === 'function') ? caws_esc(s) : String(s == null ? '' : s).replace(/[&<>"']/g, function(c){ return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]; }); }
function cai_nvl(v, d){ return (v == null || v === '') ? (typeof d == 'undefined' ? '' : d) : v; }
function cai_el(id){ return document.getElementById(id); }
function cai_pct(v){ v = Number(v || 0); return Math.round(v * 100) + '%'; }
/* 관련도 표시값 — 하이브리드 relevance(후보 안 0~1) 우선, 구 응답이면 코사인(semantic_sim).
 * bge-m3 코사인은 상위 5건이 전부 63~70% 로 몰려 사용자에게 차이를 못 보여 주던 문제(2026-10-06). */
function cai_relLabel(it){ var v = (it.relevance != null) ? it.relevance : it.semantic_sim; return '관련도 ' + cai_pct(v); }
/* [AX Lab] 수정 시작 (2026-10-12 AX Lab): 확신도 표시.
 * [AX Lab] 수정 (2026-10-15 AX Lab): low 를 실패/경고처럼 보이는 "확신 낮음"으로 노출하지 않는다.
 * relevance 는 후보 안 상대값이라 low 에서 높은 퍼센트와 경고가 동시에 보일 수 있으므로 퍼센트를 숨기고
 * 검토 가능한 "참고 사례"로 안내한다. 구 서버 응답(confidence 없음)은 기존 표시 그대로 유지한다. */
function cai_conf(it){ return (it && it.confidence) ? String(it.confidence) : ''; }
function cai_metaLabel(it){
	if(cai_conf(it) === 'low') return '<i class="cai-low" title="직접 일치하는 답변 대신 유사한 업무 사례를 함께 보여드립니다">참고 사례</i>';
	return cai_relLabel(it);
}
function cai_allLow(items){
	if(!items || !items.length) return false;
	for(var i=0; i<items.length; i++){ if(cai_conf(items[i]) !== 'low') return false; }
	return true;
}
/* [AX Lab] 수정 끝 */
/* [AX Lab] 수정 시작 (2026-10-16 AX Lab): 추천 근거 — 서버가 준 겹친 단어(match_terms) · 일치 사유(match_reason).
 * 겹친 단어는 문의와 이 자료에 함께 들어 있는 말(단어 검색 근거)이고, 순위는 문장 뜻(재정렬)을 함께 보고 정한다.
 * 겹친 단어가 없으면 문장 뜻으로만 찾은 것 → '뜻으로 찾음'. 구 서버 응답(두 필드 모두 없음)이면 아무것도 그리지 않는다. */
function cai_whyHtml(it, max){
	if(!it || (typeof it.match_terms === 'undefined' && typeof it.match_reason === 'undefined')) return '';
	var terms = it.match_terms || [], h = '';
	for(var i=0; i<terms.length && i<max; i++){
		var m = terms[i] || {};
		if(m.synonym) h += '<i class="cai-kw syn" title="문의에 없던 말 — 같은 뜻의 다른 표현(동의어)으로 찾았습니다">≈ ' + cai_esc(m.term) + '</i>';
		else          h += '<i class="cai-kw">' + cai_esc(m.term) + '</i>';
	}
	if(!terms.length) h += '<i class="cai-kw sem" title="겹치는 단어 없이 문장 뜻이 비슷해 추천되었습니다">뜻으로 찾음</i>';
	if(it.match_reason) h += '<i class="cai-kw rsn">' + cai_esc(it.match_reason) + '</i>';
	return h;
}
/* [AX Lab] 수정 끝 */
function cai_tier(it){ return CAI_TIER[Number(it && it.tier)] || { cls:'t0', label:'추천' }; }
function cai_fileName(url){
	var s = String(url || '').split('?')[0].split('#')[0];
	var n = s.substring(s.lastIndexOf('/') + 1);
	try{ n = decodeURIComponent(n); }catch(e){}
	return n || s;
}
function cai_fileExt(url){
	var n = cai_fileName(url); var i = n.lastIndexOf('.');
	return i > 0 ? n.substring(i + 1).toLowerCase() : '';
}
function cai_isImg(url){ return ['png','jpg','jpeg','gif','bmp','webp'].indexOf(cai_fileExt(url)) >= 0; }

/* [AX Lab] 수정 시작 (2026-10-16 AX Lab): 과거사례 색인 답변이 적재 길이 제한으로 잘린 경우 원본 답변 전문 보충
 * 추천 색인은 검색용 스냅샷이라 과거 데이터 일부의 answer_text가 문장 중간에서 끝날 수 있다.
 * [AX Lab] 수정 (2026-10-17 AX Lab): 전처리된 색인 본문과 원문이 불일치하면 최신 직원 답변을 사용한다.
 * Tier2 항목을 열거나 초안에 넣을 때 기존 getAsInfo.do로 원본 답변목록을 읽고, 색인 본문과 앞부분이 정확히
 * 일치하는 직원 답변을 우선 사용한다. 색인 전처리·마스킹 때문에 일치하지 않으면 해당 접수건의 최신 직원
 * 답변(자동등록 계정 88888 제외)을 사용한다. 원본 접수번호로 다시 조회한 결과만 쓰므로 다른 건과 섞이지 않는다. */
function cai_caseNo(it){
	var no = cai_nvl(it && it.as_no, '');
	if(no === '' && String(it && it.doc_id || '').indexOf('AS-') === 0) no = String(it.doc_id).substring(3);
	return no;
}
function cai_answerText(v){ return String(cai_nvl(v, '')).replace(/\r/g, '').trim(); }
/* DB 원문과 색인 생성본은 줄바꿈·탭·연속 공백이 달라질 수 있으므로 답변 식별 때만 공백을 제거해 비교한다.
 * 화면/초안에는 아래 비교용 문자열이 아니라 DB 원문(full)을 그대로 사용한다. */
function cai_matchText(v){ return cai_answerText(v).replace(/[\s\u00a0]+/g, ''); }
function cai_findFullAnswer(it, list){
	var seed = cai_matchText(it && it.answer_text);
	if(seed === '') return '';
	var best = '', latest = '', latestSeq = -1;
	for(var i=0; i<(list || []).length; i++){
		var a = list[i] || {};
		if(String(cai_nvl(a.w_gubun, '')).toUpperCase() !== 'A') continue;
		if(String(cai_nvl(a.w_id, '')) === '88888') continue;
		var full = cai_answerText(a.w_content);
		if(full === '') continue;
		var seq = parseInt(cai_nvl(a.seq, i), 10);
		if(isNaN(seq)) seq = i;
		if(seq >= latestSeq){ latestSeq = seq; latest = full; }
		var fullMatch = cai_matchText(full);
		if(fullMatch.length > seed.length && fullMatch.indexOf(seed) === 0 && full.length > best.length) best = full;
	}
	return best || latest;
}
function cai_loadFullAnswer(idx, done){
	var it = cai.items[idx];
	if(!it || Number(it.tier) !== 2 || cai_caseNo(it) === ''){
		if(done) done(false);
		return;
	}
	if(it._fullState === 'done' || it._fullState === 'fail'){
		if(done) done(false);
		return;
	}
	if(!it._fullWait) it._fullWait = [];
	if(done) it._fullWait.push(done);
	if(it._fullState === 'loading') return;
	it._fullState = 'loading';

	function finish(changed, state){
		it._fullState = state;
		var wait = it._fullWait || [];
		it._fullWait = [];
		for(var i=0; i<wait.length; i++){ try{ wait[i](changed); }catch(e){} }
	}
	$.ajax({
		type:'POST', url:CAI_URL, dataType:'json', async:true,
		data:{ as_no:cai_caseNo(it), pageType:'update' },
		success:function(data){
			var full = cai_findFullAnswer(it, data && data.awsList);
			var changed = full !== '';
			if(changed){
				it.answer_text = full;
				it.answer_html = '';		/* DB 원문은 HTML이 아니므로 화면에서 반드시 이스케이프 경로를 탄다 */
			}
			finish(changed, 'done');
		},
		error:function(){ finish(false, 'fail'); }
	});
}
/* [AX Lab] 수정 끝 */

/* =============================================================================
 * 1) 조회
 * ========================================================================== */
function cai_load(asNo){
	asNo = cai_nvl(asNo, '');
	cai.asNo = asNo;
	cai.sel = -1;
	cai.fu = null;		/* [AX Lab] 2026-10-16 */
	cai_unmount();
	if(asNo === ''){ cai.status = 'idle'; cai.items = []; cai_syncButton(); return; }

	var c = cai.cache[asNo];
	/* [AX Lab] 수정 (2026-10-16 AX Lab): 재촉 판정도 캐시에서 복원. 키워드 블록이 그려진 뒤(setTimeout) 위로 옮긴다 */
	if(c){ cai.status = c.status; cai.items = c.items; cai.result = c.result; cai.fu = c.fu || null; cai_syncButton(); cai_fuLater(); return; }

	cai.status = 'loading'; cai.items = []; cai.result = '';
	cai_syncButton();

	var mySeq = ++cai.seq;
	$.ajax({
		type:'POST', url:CAI_URL, dataType:'json', async:true,
		data:{ as_no:asNo, pageType:'aiRecommend' },
		success:function(data){
			if(mySeq !== cai.seq || cai.asNo !== asNo) return;		/* 그 사이 다른 건을 열었다 */
			var ok = data && String(data.result) === '000';
			var items = (ok && data.items) ? data.items : [];
			cai.status = ok ? 'ok' : 'fail';
			cai.items = items;
			/* result 키 자체가 없으면 서버가 pageType=aiRecommend 분기를 모르는 것 — 즉 CombineAsAi* 클래스가
			 * 아직 컴파일/배포되지 않아 일반 getAsInfo 응답(resultVO…)이 돌아온 경우다. 900 으로 구분한다. */
			cai.result = (data && data.result != null) ? String(data.result) : '900';
			cai.fu = ok ? cai_fuOf(data) : null;	/* [AX Lab] 2026-10-16 */
			cai.cache[asNo] = { status:cai.status, items:items, result:cai.result, fu:cai.fu };
			cai_syncButton();
			cai_fuApply();							/* [AX Lab] 2026-10-16 응답 시점엔 키워드 블록이 이미 그려져 있다 */
		},
		error:function(xhr){
			if(mySeq !== cai.seq || cai.asNo !== asNo) return;
			cai.status = 'fail'; cai.items = []; cai.result = 'HTTP ' + (xhr ? xhr.status : '');
			/* 네트워크 오류는 캐시하지 않는다 — 다음 진입 때 다시 시도한다 */
			cai_syncButton();
		}
	});
}

/* =============================================================================
 * 2) 버튼 + 팝오버 (문의 카드 우측 상단)  — caws_aiRecommendHtml() 이 위임
 * ========================================================================== */
function cai_buttonHtml(){
	return '<span class="caws-aiwrap cai-wrap" id="caiWrap">'
	     +   '<button type="button" class="caws-aibtn" id="caiBtn" aria-expanded="false" onclick="cai_toggle(this,event);" title="AI 추천 보기">'
	     +     '<span class="caws-aiico" aria-hidden="true">✦</span> AI 추천 ' + cai_countHtml() + '<span class="caws-aicaret">⌄</span>'
	     +   '</button>'
	     +   '<span class="caws-aipop cai-pop" id="caiPop" onclick="if(event)event.stopPropagation();">' + cai_popHtml() + '</span>'
	     + '</span>';
}
function cai_countHtml(){
	if(cai.status === 'loading') return '<b class="cai-cnt cai-ld" title="검색 중"><span class="asws-spin cai-spin"></span></b>';
	/* [AX Lab] 수정 (2026-10-16 AX Lab): 서버가 관련 없는 후보를 빼므로 건수가 0~5로 달라진다. 0건은 흐린 색으로 */
	if(cai.status === 'ok')      return '<b class="cai-cnt' + (cai.items.length ? '' : ' cai-na') + '">' + cai.items.length + '</b>';
	return '<b class="cai-cnt cai-na">-</b>';
}
function cai_popHtml(){
	var h = '';
	if(cai.status === 'loading'){
		h += '<span class="caws-aiphd"><strong><span class="caws-aiico">✦</span> AI 추천</strong><em class="cai-tag">검색 중</em></span>';
		for(var i=0; i<3; i++) h += '<span class="cai-skel"><i></i><span><b></b><small></small></span></span>';
		return h;
	}
	if(cai.status === 'ok'){
		/* [AX Lab] 수정 (2026-10-15 AX Lab): 전부 low여도 목록은 유지하되 중립적인 참고 사례로 안내한다 */
		var allLow = cai_allLow(cai.items);
		h += '<span class="caws-aiphd"><strong><span class="caws-aiico">✦</span> AI 추천</strong><em class="cai-tag' + (allLow ? ' ref' : ' on') + '">' + (allLow ? '참고 사례 ' : '') + cai.items.length + '건</em></span>';
		if(!cai.items.length && cai.fu && cai.fu.on){ h += cai_fuPopHtml(); return h; }	/* [AX Lab] 2026-10-16 */
		if(!cai.items.length){
			h += '<span class="cai-empty">문의 내용과 관련도가 충분한 사례가 없어 추천하지 않았습니다.</span>';	/* [AX Lab] 2026-10-16 문구: 관련 없는 후보 제외 */
			return h;
		}
		if(cai.fu && cai.fu.on) h += cai_fuPopHtml();	/* [AX Lab] 2026-10-16 재촉·연락 요청 문의 안내 */
		if(allLow) h += '<span class="cai-lownote">직접 일치하는 답변 대신 유사한 업무 사례를 함께 보여드립니다. 내용을 확인한 후 활용해주세요.</span>';
		for(var j=0; j<cai.items.length; j++){
			var it = cai.items[j], t = cai_tier(it);
			var files = (it.attached_file && it.attached_file.length) ? ' · <span class="cai-clip" title="첨부 ' + it.attached_file.length + '개">&#128206;' + it.attached_file.length + '</span>' : '';
			var when = cai_nvl(it.occurred_at, '');
			var why = cai_whyHtml(it, 3);	/* [AX Lab] 2026-10-16 추천 근거 */
			h += '<button type="button" class="cai-item' + (j === cai.sel ? ' on' : '') + (cai_conf(it) === 'low' ? ' refc' : '') + '" onclick="cai_open(' + j + ', event);" title="' + cai_esc(it.title) + '">'
			   +   '<i class="cai-tier ' + t.cls + '">' + t.label + '</i>'
			   +   '<span><b>' + cai_esc(it.title) + '</b>'
			   +   '<small>' + cai_metaLabel(it) + (when ? ' · ' + cai_esc(when) : '') + files + '</small>'	/* [AX Lab] 2026-10-12 cai_relLabel → cai_metaLabel */
			   +   (why ? '<span class="cai-why">' + why + '</span>' : '') + '</span>'
			   + '</button>';
		}
		h += '<span class="cai-foot">항목을 누르면 우측 「접수 · 처리 정보」 상단에 본문이 열립니다.</span>';
		return h;
	}
	if(cai.status === 'fail' && cai.result !== '901'){
		/* 실패 사유를 한 줄로만 알리고(§6 조용한 실패), 일시 오류는 다시 시도할 수 있게 한다.
		 * 901(기능 꺼짐)만 기존 플레이스홀더(추후 제공)로 떨어뜨린다. */
		var m = cai_failMsg(cai.result);
		h += '<span class="caws-aiphd"><strong><span class="caws-aiico">✦</span> AI 추천</strong><em class="cai-tag">' + m.tag + '</em></span>';
		h += '<span class="cai-empty">' + cai_esc(m.text)
		   + (m.retry ? ' <button type="button" class="cai-retry" onclick="cai_retry(event);">다시 시도</button>' : '')
		   + '</span>';
		return h;
	}
	/* idle / 901 : 기존 플레이스홀더(추후 제공) */
	if(typeof caws_aiPlaceholderHtml === 'function') return caws_aiPlaceholderHtml();
	return '<span class="caws-aiphd"><strong><span class="caws-aiico">✦</span> AI 추천</strong><em>추후 제공</em></span>';
}
/* CombineAsAiClient / ServiceImpl 결과코드 → 사용자 문구 */
function cai_failMsg(code){
	code = String(code || '');
	if(code === '900') return { tag:'미배포', text:'서버에 AI 추천 모듈이 아직 반영되지 않았습니다. (Java 재컴파일 · WAS 재기동 필요)', retry:false };
	if(code === '907') return { tag:'불가', text:'문의 내용이 너무 짧아 비슷한 사례를 찾을 수 없습니다.', retry:false };
	if(code === '908') return { tag:'불가', text:'접수건 정보를 찾을 수 없어 추천을 건너뜁니다.', retry:false };
	if(code === '902') return { tag:'미설정', text:'AI 추천 서버가 설정되지 않았습니다. 관리자에게 문의하세요.', retry:false };
	if(code === '903') return { tag:'지연', text:'AI 추천 서버 응답이 지연되어 건너뛰었습니다.', retry:true };
	return { tag:'오류', text:'AI 추천을 불러오지 못했습니다. (' + code + ')', retry:true };
}
function cai_retry(ev){
	if(ev) ev.stopPropagation();
	var asNo = cai.asNo;
	if(!asNo) return;
	delete cai.cache[asNo];
	cai_load(asNo);
}
/* 상태가 바뀌면 이미 그려진 버튼/팝오버만 갈아끼운다 (타임라인 전체를 다시 그리지 않는다) */
function cai_syncButton(){
	var btn = cai_el('caiBtn'), pop = cai_el('caiPop');
	if(btn){
		var cnt = btn.querySelector('.cai-cnt');
		if(cnt){ var tmp = document.createElement('span'); tmp.innerHTML = cai_countHtml(); cnt.parentNode.replaceChild(tmp.firstChild, cnt); }
	}
	if(pop) pop.innerHTML = cai_popHtml();
}
function cai_toggle(btn, evt){
	if(evt && evt.stopPropagation) evt.stopPropagation();
	var wrap = btn ? btn.parentNode : null;
	if(!wrap) return;
	var open = !wrap.classList.contains('open');
	var all = document.querySelectorAll('#asWorkspace .caws-aiwrap.open');
	for(var i=0; i<all.length; i++){
		all[i].classList.remove('open');
		var ob = all[i].querySelector('.caws-aibtn'); if(ob) ob.setAttribute('aria-expanded','false');
	}
	if(open){ wrap.classList.add('open'); btn.setAttribute('aria-expanded','true'); }
	if(!cai._closeBound){
		document.addEventListener('click', function(){
			var opened = document.querySelectorAll('#asWorkspace .caws-aiwrap.open');
			for(var j=0; j<opened.length; j++){
				opened[j].classList.remove('open');
				var b = opened[j].querySelector('.caws-aibtn'); if(b) b.setAttribute('aria-expanded','false');
			}
		});
		cai._closeBound = true;
	}
}
function cai_closePop(){
	var w = cai_el('caiWrap');
	if(w){ w.classList.remove('open'); var b = w.querySelector('.caws-aibtn'); if(b) b.setAttribute('aria-expanded','false'); }
}

/* =============================================================================
 * 3) COL3 상세 패널
 * ========================================================================== */
function cai_open(idx, evt){
	if(evt && evt.stopPropagation) evt.stopPropagation();
	if(!cai.items[idx]) return;
	cai.sel = idx;
	cai_closePop();
	/* COL3 가 접혀 있으면 펼친다 (c3-collapsed 상태에서는 본문을 볼 수 없다) */
	var g = cai_el('asGrid');
	if(g && g.classList.contains('c3-collapsed') && typeof asws_toggleCol === 'function') asws_toggleCol('c3');
	cai_mount();
	cai_syncButton();
	var box = cai_el('caiBox');
	var rec = cai_el('asRecord');
	if(rec) rec.scrollTop = 0;
	if(box) box.classList.add('flash');
	setTimeout(function(){ var b = cai_el('caiBox'); if(b) b.classList.remove('flash'); }, 700);
	/* [AX Lab] 수정 시작 (2026-10-16 AX Lab): Tier2는 원본 답변 전문 확인 후 열린 패널만 다시 그린다 */
	cai_loadFullAnswer(idx, function(changed){
		if(changed && cai.sel === idx) cai_mount();
	});
	/* [AX Lab] 수정 끝 */
}
function cai_close(){
	cai.sel = -1;
	cai_unmount();
	cai_syncButton();
}
function cai_move(d){
	var n = cai.sel + d;
	if(n < 0 || n >= cai.items.length) return;
	cai_open(n);
}
function cai_unmount(){ var b = cai_el('caiBox'); if(b && b.parentNode) b.parentNode.removeChild(b); }

/* #asRecord 맨 위에 꽂는다. caws_renderRecord() 가 #asRecord 를 다시 그리면 cai_remount() 가 다시 꽂는다. */
function cai_mount(){
	var rec = cai_el('asRecord');
	if(!rec || cai.sel < 0 || !cai.items[cai.sel]) return;
	var box = cai_el('caiBox');
	if(!box){
		box = document.createElement('div');
		box.id = 'caiBox';
		box.className = 'cai-box';
		rec.insertBefore(box, rec.firstChild);
	}
	box.innerHTML = cai_detailHtml(cai.items[cai.sel], cai.sel);
}
function cai_remount(){
	if(cai.sel < 0) return;
	if(!cai_el('asRecord')) return;
	cai_mount();
}
function cai_isWide(){ var g = cai_el('asGrid'); return !!(g && g.classList.contains('c1-collapsed')); }
function cai_toggleWide(){
	/* 기존 접기 기능 재사용(§8-3 3단). 목록/상세 넓게보기 모드와 겹치면 그쪽을 우선한다. */
	var g = cai_el('asGrid');
	if(!g) return;
	if(g.classList.contains('list-wide') || g.classList.contains('detail-wide')){
		alert('목록/상세 넓게 보기 모드에서는 사용할 수 없습니다. 기본 보기로 돌아간 뒤 이용해주세요.');
		return;
	}
	if(typeof asws_toggleCol === 'function') asws_toggleCol('c1');
	cai_mount();
}

function cai_detailHtml(it, idx){
	var t = cai_tier(it);
	var wide = cai_isWide();
	var meta = [];
	meta.push(cai_metaLabel(it));	/* [AX Lab] 2026-10-15: low는 관련도 대신 참고 사례 배지 */
	if(it.occurred_at) meta.push(cai_esc(it.occurred_at));
	if(it.service_cate) meta.push(cai_esc(it.service_cate));
	if(it.topic) meta.push(cai_esc(it.topic));
	if(it.resolution) meta.push(cai_esc(it.resolution));
	if(it.doc_id) meta.push('<span class="cai-docid">' + cai_esc(it.doc_id) + '</span>');

	var h = ''
	+ '<div class="cai-hd">'
	+   '<strong><span class="caws-aiico">✦</span> AI 추천 상세</strong>'
	+   '<span class="cai-nav">'
	+     '<button type="button" class="caws-minib" onclick="cai_move(-1);"' + (idx <= 0 ? ' disabled' : '') + ' title="이전 추천">&#8249;</button>'
	+     '<em>' + (idx + 1) + ' / ' + cai.items.length + '</em>'
	+     '<button type="button" class="caws-minib" onclick="cai_move(1);"' + (idx >= cai.items.length - 1 ? ' disabled' : '') + ' title="다음 추천">&#8250;</button>'
	+   '</span>'
	+   '<div class="caws-sp"></div>'
	+   '<button type="button" class="caws-minib" onclick="cai_toggleWide();" title="' + (wide ? '목록을 다시 펼칩니다' : '목록을 접어 이 패널을 넓게 봅니다') + '">' + (wide ? '기본' : '넓게') + '</button>'
	+   '<button type="button" class="caws-minib cai-x" onclick="cai_close();" title="닫기">&#215;</button>'
	+ '</div>'
	+ '<div class="cai-ttl"><i class="cai-tier ' + t.cls + '">' + t.label + '</i><b>' + cai_esc(it.title) + '</b></div>'
	+ '<div class="cai-meta">' + meta.join(' · ') + '</div>';
	/* [AX Lab] 수정 (2026-10-16 AX Lab): 추천 근거 */
	var why = cai_whyHtml(it, 4);
	if(why) h += '<div class="cai-whyrow" title="문의와 이 자료에 함께 들어 있는 말입니다. 순위는 문장 뜻(AI 판단)도 함께 보고 정합니다."><em>겹친 단어</em>' + why + '</div>';

	/* 과거사례는 "어떤 문의였나"가 맥락이므로 원 문의를 접힌 상태로 함께 둔다 */
	if(Number(it.tier) === 2 && cai_nvl(it.question_text, '') !== ''){
		h += '<div class="caws-acc off" id="caiQAcc">'
		  +    '<button type="button" class="caws-acch" onclick="cai_el(\'caiQAcc\').classList.toggle(\'off\');"><span class="caws-achev">&#9662;</span>원 문의 보기</button>'
		  +    '<div class="caws-accb"><div class="cai-q">' + cai_esc(it.question_text) + '</div></div>'
		  +  '</div>';
	}

	/* 본문 — 서버가 화이트리스트로 정제한 HTML (§8-5). answer_html 이 없으면 answer_text 를 이스케이프해 보여준다 */
	var body = cai_nvl(it.answer_html, '');
	if(body === '') body = '<p>' + cai_esc(cai_nvl(it.answer_text, '(내용 없음)')).replace(/\n/g, '<br>') + '</p>';
	h += '<div class="caws-aimd">' + body + '</div>';

	/* 내부 메모 — Tier2 만, 기본 접힘 (§6 스펙 원칙) */
	if(cai_nvl(it.internal_note, '') !== ''){
		h += '<div class="caws-acc off" id="caiNoteAcc">'
		  +    '<button type="button" class="caws-acch" onclick="cai_el(\'caiNoteAcc\').classList.toggle(\'off\');"><span class="caws-achev">&#9662;</span>내부 조치메모 <span class="caws-asum">고객 미노출</span></button>'
		  +    '<div class="caws-accb"><div class="cai-q cai-note">' + cai_esc(it.internal_note) + '</div></div>'
		  +  '</div>';
	}

	/* 첨부 — 파일명 + 확장자 배지. 넓게 보기에서는 이미지 썸네일 (§8-6) */
	var files = it.attached_file || [];
	if(files.length){
		h += '<div class="cai-files"><span class="cai-fl">첨부 ' + files.length + '</span>';
		for(var i=0; i<files.length; i++){
			var u = String(files[i] || ''); if(!u) continue;
			var ext = cai_fileExt(u) || 'file';
			h += '<a class="cai-file" href="' + cai_esc(u) + '" target="_blank" rel="noopener" title="' + cai_esc(u) + '">'
			  +    '<i>' + cai_esc(ext.toUpperCase().substring(0, 4)) + '</i><span>' + cai_esc(cai_fileName(u)) + '</span></a>';
		}
		if(wide){
			var th = '';
			for(var k=0; k<files.length; k++){ if(cai_isImg(files[k])) th += '<a href="' + cai_esc(files[k]) + '" target="_blank" rel="noopener"><img src="' + cai_esc(files[k]) + '" alt="" loading="lazy"></a>'; }
			if(th) h += '<div class="cai-thumbs">' + th + '</div>';
		}
		h += '</div>';
	}

	/* 액션 — Tier 별 주 액션 + deep_link 가 있을 때만 보조 액션 (§8-4) */
	h += '<div class="cai-act">';
	var tier = Number(it.tier);
	if(tier === 1){
		h += '<button type="button" class="caws-send cai-primary" onclick="cai_insertDraft(' + idx + ');" title="이 답변 원문을 아래 작성영역에 붙여 넣습니다">답변 초안에 넣기</button>';
		if(it.deep_link) h += '<button type="button" class="btn-s" onclick="cai_openLink(' + idx + ');">게시물 열기</button>';
	}else if(tier === 2){
		var asNo = cai_caseNo(it);
		/* [AX Lab] 수정 시작 (2026-10-12 AX Lab): 원본 접수건은 현재 AS를 유지하고 통합 AS 화면 새 탭으로 열기 */
		if(asNo) h += '<button type="button" class="caws-send cai-primary" onclick="cai_openCase(\'' + cai_esc(asNo) + '\');" title="통합 AS 화면을 새 탭으로 열어 이 접수건을 선택합니다">원본 접수건 열기</button>';
		/* [AX Lab] 수정 끝 */
		h += '<button type="button" class="btn-s" onclick="cai_insertDraft(' + idx + ');" title="답변 내용을 작성영역에 붙여 넣습니다 (단편 기록일 수 있어 확인 후 사용)">초안에 넣기</button>';
	}else{
		if(it.deep_link) h += '<button type="button" class="caws-send cai-primary" onclick="cai_openLink(' + idx + ');">게시물 열기</button>';
		if(it.public_link) h += '<a class="btn-s cai-pub" href="' + cai_esc(it.public_link) + '" target="_blank" rel="noopener" title="고객이 보는 라인어스 게시물 주소 (답변에 안내용으로 붙일 수 있습니다)">고객용 링크</a>';
	}
	h += '</div>';
	return h;
}

/* [AX Lab] 수정 시작 (2026-10-16 AX Lab): 재촉·연락 요청 문의 ("연락 달라", "재문의 드립니다")
 * 이런 문의는 비슷한 사례(AI 추천)보다 "앞서 접수한 건이 무엇이었나" 가 먼저 필요하다. 그래서 추천 서버가
 * follow_up=true 를 주면 combine-as-keyword.js 의 「문의 내용 키워드 · 연관 이력」 블록(#ckwBox — 접수번호
 * 직접 참조·같은 고객 1년 이력)을 접수·처리 정보 맨 위로 올리고 안내 한 줄을 붙인다.
 * 판정은 서버(combine_wordstats.py)가 한다: 비슷한 과거 문의 10건 중 '처리현황독촉' 문의가 2건 이상이거나,
 * 문의에 인사·연락 표현만 있고 업무 내용이 없을 때. 구 서버 응답(follow_up 없음)이면 아무것도 하지 않는다.
 * combine-as-keyword.js 는 고치지 않는다 — ckw_mount() 가 블록이 #asRecord 안에 있으면 위치를 건드리지 않으므로
 * 한 번 옮기면 키워드 재조회(ckw_render)에도 그 자리에 남고, #asRecord 를 통째로 다시 그릴 때만 다시 옮긴다. */
function cai_fuOf(data){
	if(!data || typeof data.follow_up === 'undefined') return null;
	var d = data.follow_up_detail || {};
	return { on:!!data.follow_up, nag:Number(d.nag_near || 0), k:Number(d.near_k || 10), empty:!!d.content_free };
}
function cai_fuReason(){
	var f = cai.fu || {}, r = [];
	if(f.empty) r.push('문의에 업무 내용 없이 인사·연락 표현만 있습니다');
	if(f.nag >= 2) r.push('비슷한 과거 문의 ' + f.k + '건 중 ' + f.nag + '건이 처리현황 독촉(재문의·연락 요청) 문의였습니다');
	return r.join(' · ');
}
function cai_fuPopHtml(){
	return '<span class="cai-funote" title="' + cai_esc(cai_fuReason()) + '">재문의·연락 요청으로 보이는 문의입니다. '
	     + '우측 「문의 내용 키워드 · 연관 이력」에서 앞서 접수한 건을 먼저 확인해주세요.'
	     + (cai.fu.empty ? ' 문의에 구체적인 내용이 없어 아래 추천은 참고용입니다.' : '') + '</span>';
}
function cai_fuLater(){ setTimeout(function(){ try{ cai_fuApply(); }catch(e){} }, 0); }
function cai_fuApply(){
	var rec = cai_el('asRecord'), box = cai_el('ckwBox'), note = cai_el('caiFuNote');
	if(!cai.fu || !cai.fu.on || !rec || !box || box.parentNode !== rec || cai.asNo !== ((typeof caws !== 'undefined' && caws) ? caws.asNo : '')){
		if(note && note.parentNode) note.parentNode.removeChild(note);
		return;
	}
	if(!note){
		note = document.createElement('div');
		note.id = 'caiFuNote';
		note.className = 'cai-funote panel';
	}
	note.innerHTML = '<b>↻ 재문의·연락 요청</b> 앞서 접수한 건을 먼저 확인하세요. 아래 연관 이력에 같은 고객의 이전 접수가 있습니다.';
	note.title = cai_fuReason();
	/* AI 추천 상세(#caiBox)가 열려 있으면 그 아래, 아니면 맨 위 */
	var cb = cai_el('caiBox');
	var anchor = (cb && cb.parentNode === rec) ? cb.nextSibling : rec.firstChild;
	if(anchor !== note) rec.insertBefore(note, anchor);
	if(note.nextSibling !== box) rec.insertBefore(box, note.nextSibling);
	box.classList.add('cai-fu');
}
/* [AX Lab] 수정 끝 */

/* =============================================================================
 * 4) 액션
 * ========================================================================== */
/* 답변 초안 삽입 : answer_text(원문)만 textarea 에 넣는다. HTML 은 절대 넣지 않는다. */
function cai_insertDraft(idx){
	var it = cai.items[idx]; if(!it) return;
	/* [AX Lab] 수정 시작 (2026-10-16 AX Lab): 과거사례는 원본 답변 전문 확인이 끝난 뒤 초안에 넣는다 */
	if(Number(it.tier) === 2 && it._fullState !== 'done' && it._fullState !== 'fail'){
		cai_loadFullAnswer(idx, function(){ cai_insertDraft(idx); });
		return;
	}
	/* [AX Lab] 수정 끝 */
	var txt = cai_answerText(it.answer_text);
	if(txt === ''){ alert('붙여 넣을 답변 원문이 없습니다.'); return; }
	if(typeof caws_openCompose === 'function') caws_openCompose();
	var ta = cai_el('cawsText');
	if(!ta){ alert('작성영역을 찾을 수 없습니다. 접수건을 먼저 선택해주세요.'); return; }
	var cur = String(ta.value || '');
	ta.value = cur.trim() === '' ? txt : (cur.replace(/\s+$/, '') + '\n\n' + txt);
	if(typeof caws_autoGrow === 'function') caws_autoGrow(ta);
	if(typeof caws_syncDraftTag === 'function') caws_syncDraftTag();
	try{ ta.focus(); ta.setSelectionRange(ta.value.length, ta.value.length); }catch(e){}
}
/* [AX Lab] 수정 시작 (2026-10-12 AX Lab): 과거사례 원본을 통합 AS 화면 새 탭에서 선택해 연다 */
function cai_openCase(asNo){
	if(!asNo) return;
	var url = '/ad/as/list.do?as_no=' + encodeURIComponent(asNo);
	var opened = window.open(url, '_blank', 'noopener');
	if(opened) opened.opener = null;
}
/* [AX Lab] 수정 끝 */
/* 게시물 열기 : deep_link(/ad/{faq|notice|down|videofaq}/form.do?seq=N) 를 기존 게시판 상세 열기 방식(POST 새 창)으로 연다.
   caws_goBoard 와 달리 번호 변환이 필요 없다 — 추천 API 의 deep_link 는 이미 SEQ 기준이다. */
function cai_openLink(idx){
	var it = cai.items[idx]; if(!it || !it.deep_link) return;
	var link = String(it.deep_link);
	var m = /^(\/ad\/[a-z]+\/form\.do)\?(?:.*&)?seq=(\d+)/.exec(link);
	if(!m){ window.open(link, '_blank'); return; }
	var url = m[1], seq = m[2], gbn = '';
	if(typeof CAWS_BOARDS !== 'undefined'){
		for(var i=0; i<CAWS_BOARDS.length; i++){ if(CAWS_BOARDS[i].url === url){ gbn = CAWS_BOARDS[i].gbn; break; } }
	}
	try{ $('#caiBoardFrm').remove(); }catch(e){}
	var f = $('<form id="caiBoardFrm" method="post" target="_blank"></form>');
	f.attr('action', url);
	f.append('<input type="hidden" name="pageType" value="update" />');
	f.append('<input type="hidden" name="seq" value="' + cai_esc(seq) + '" />');
	if(gbn) f.append('<input type="hidden" name="board_gbn" value="' + gbn + '" />');
	f.append('<input type="hidden" name="page" value="1" />');
	f.appendTo('body');
	f.submit();
}

/* =============================================================================
 * 5) 기존 함수 래핑 (combine-as-keyword.js 와 같은 방식)
 *   - caws_renderAll  : 건이 바뀔 때 1회 → 추천 조회 시작
 *   - caws_renderRecord : #asRecord 가 다시 그려지면 열려 있던 상세 패널을 다시 꽂는다
 *   - caws_clear      : 선택 해제 시 상태 초기화
 * ========================================================================== */
(function(){
	if(typeof window.caws_renderAll !== 'function') return;	/* combine-as-thread.js 미로드 → 아무것도 하지 않는다 */

	var _renderAll = window.caws_renderAll;
	window.caws_renderAll = function(){
		var r = _renderAll.apply(this, arguments);
		try{ cai_load((typeof caws !== 'undefined') ? caws.asNo : ''); }catch(e){}
		return r;
	};
	if(typeof window.caws_renderRecord === 'function'){
		var _renderRecord = window.caws_renderRecord;
		window.caws_renderRecord = function(){
			var r = _renderRecord.apply(this, arguments);
			try{ setTimeout(function(){ cai_remount(); cai_fuApply(); /* [AX Lab] 2026-10-16 */ }, 0); }catch(e){}
			return r;
		};
	}
	if(typeof window.caws_clear === 'function'){
		var _clear = window.caws_clear;
		window.caws_clear = function(){
			var r = _clear.apply(this, arguments);
			try{ cai.asNo = ''; cai.sel = -1; cai.status = 'idle'; cai.items = []; cai.fu = null; cai.seq++; }catch(e){}	/* [AX Lab] 2026-10-16 fu */
			return r;
		};
	}
})();
