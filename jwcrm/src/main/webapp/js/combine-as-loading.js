/* =============================================================================
 * [AX Lab] AS 통합화면 - 목록 로딩표시 / 빈 결과 안내  (2026-09-30 AX Lab)
 *
 * 배경 (실제로 겪은 증상)
 *   목록이 계속 비어 보여 "조회가 안 된다" 는 문의가 있었다. 서버 로그를 보면
 *   오류는 없었고, 처리구분 기본값이 '나의 A/S'(asGubunFlag=2) 라서 카운트 쿼리에
 *   AND IN_TB.ASSIGN_ID = :로그인사번 이 붙어 0건이 나온 것이었다.
 *   0건이면 AdAsController.getAsList 가 목록 쿼리를 아예 실행하지 않는다.
 *   → 화면에는 "조회된 데이터가 없습니다." 한 줄만 떠서, 사용자는 시스템 장애인지
 *     필터 때문인지 알 방법이 없었다. 이 파일이 그 두 가지를 구분해서 알려준다.
 *
 * 하는 일
 *   ① 조회 중 로딩 표시
 *   ② 0건일 때 원인별 안내 + 해결 버튼('전체 A/S로 다시 조회' / '검색조건 초기화')
 *   ③ 조회 실패 시 오류 표시 + 재시도
 *
 * ★ 왜 비동기(ajaxCallAsync 계열)로 바꿔야 했나
 *   공통 유틸 common.ajaxCall 은 async:false (동기 XHR) 다. 동기 XHR 이 도는 동안
 *   브라우저는 화면을 다시 그리지 않는다. 즉 로딩 표시를 DOM 에 넣어도 "절대 보이지
 *   않는다". (기존 asws_openDetail 의 '불러오는 중...' 문구가 실제로 안 보이는 이유도 같다)
 *   그래서 목록 조회만 비동기로 전환했다.
 *
 * ★ 비동기 전환 시 반드시 지켜야 하는 것 : "조회 후 열어둘 건"
 *   기존 호출부 두 곳이 동기 동작에 의존하고 있었다.
 *       makeListData();              // setAsList 가 첫 행을 자동으로 연다
 *       asws_openDetail(keepNo);     // 그 직후 원래 보던 건으로 되돌린다
 *   비동기로 바꾸면 순서가 뒤집혀 "보던 건이 첫 행으로 튕기는" 버그가 된다.
 *   → makeListData(afterFn) 형태로 콜백을 받고, setAsList 가 첫 행 자동선택 "대신"
 *     그 콜백을 실행한다. (asws_listTakeAfter)
 *     덤으로 기존에 있던 '첫 행을 열었다가 즉시 다른 건으로 바꾸는' 이중 렌더도 사라진다.
 *
 * 의존 : jQuery, combine-as.js(asws_esc / asws_openDetail), list.jsp(setAsList)
 *       list.jsp 에서 combine-as.js 보다 "뒤에" 로드할 것.
 * ========================================================================== */

/* 최신 요청 일련번호. 응답이 뒤늦게 도착해 이전 결과가 최신 결과를 덮어쓰는 것을 막는다.
   (정렬을 연속으로 클릭하는 등 요청이 겹칠 때 실제로 발생한다) */
var ASWS_LIST_SEQ = 0;

/* 이번 조회가 끝난 뒤 "첫 행 자동선택 대신" 실행할 콜백 (1회성) */
var ASWS_LIST_AFTER = null;

/* 목록 테이블의 컬럼 수. 안내행 colspan 에 쓴다.
   하드코딩하면 컬럼을 추가·삭제할 때마다 어긋나 안내문이 한 칸에 찌그러진다
   (실제로 과거에 colspan 을 손으로 보정한 이력이 있다). thead 에서 매번 세어 쓴다. */
function asws_listColspan(){
	try{
		/* thead 가 2행 이상이면 전체 th 를 세면 두 배가 되므로 첫 행만 센다. */
		var n = $('#asList').closest('table').find('thead tr').first().find('th').length;
		if(n > 0) return n;
	}catch(e){}
	return 16;	/* 안전망 : 현재 컬럼 수(좌측 6 + 우측 10) */
}

/* XSS 방지용 이스케이프. combine-as.js 의 asws_esc 를 쓰되 없으면 자체 처리. */
function asws_lesc(s){
	if(typeof asws_esc === 'function') return asws_esc(s);
	return String(s == null ? '' : s)
			.replace(/&/g,'&amp;').replace(/</g,'&lt;')
			.replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}

/* ---- 1) 로딩 표시 -------------------------------------------------------- */
/* 목록칸(.col-content) 위에 반투명 딤 + 가운데 스피너를 얹는다.
   기존 행/목록을 지우지 않고 그 위를 덮기만 하므로 "조회 중" 인 동안에도 직전 결과가
   그대로 보이고, 딤이 클릭을 막아 자연스럽게 비활성화 상태가 된다.

   ※ .tscroll(overflow:auto) 안에 넣으면 안 된다. 스크롤을 따라 움직여서 목록 일부만
     덮게 된다. 스크롤되지 않는 .col-content 를 기준점으로 쓴다. (CSS 참고)
   ※ 기준점을 못 찾는 예외 상황에서는 목록 tbody 에 로딩 행을 넣는 방식으로 폴백한다. */
function asws_listBusyOn(){
	var host = $('#asList').closest('.col-content');

	if(!host.length){
		$('#asList').html(
			'<tr><td colspan="' + asws_listColspan() + '" class="asws-loading">'
			+ '<span class="asws-spin"></span>목록을 불러오는 중입니다&hellip;'
			+ '</td></tr>'
		);
		return;
	}

	if(host.children('.asws-ovl').length) return;	/* 이미 떠 있으면 중복 생성 방지 */

	host.append(
		'<div class="asws-ovl" role="status" aria-live="polite">'
		+ '<div class="asws-ovl-ring"></div>'
		+ '<div class="asws-ovl-txt">불러오는 중&hellip;</div>'
		+ '</div>'
	);
	host.attr('aria-busy', 'true');
}

/* 오버레이 제거. 성공·실패 어느 쪽이든 반드시 호출돼야 화면이 잠기지 않는다. */
function asws_listBusyOff(){
	$('#asWorkspace .asws-ovl').remove();
	$('#asWorkspace #col-c1 .col-content').removeAttr('aria-busy');
}

/* ---- 2) 목록 조회 (비동기) ----------------------------------------------- */
/**
 * @param afterFn 조회 완료 후 실행할 함수(선택).
 *                주면 setAsList 의 "첫 행 자동선택" 대신 이 함수가 실행된다.
 */
function asws_listLoad(afterFn){
	var my = ++ASWS_LIST_SEQ;
	ASWS_LIST_AFTER = (typeof afterFn === 'function') ? afterFn : null;

	asws_listBusyOn();

	$.ajax({
		type     : 'POST',
		url      : '/ad/as/getAsList.do',
		dataType : 'json',
		async    : true,
		/* 응답이 영영 안 오면 딤이 걸린 채로 화면이 잠긴다. 상한을 둬서 반드시 error 로 빠지게 한다. */
		timeout  : 60000,
		data     : $('form[name=listFrm]').serialize(),
		success  : function(data){
			if(my !== ASWS_LIST_SEQ) return;	/* 더 최신 요청이 있다 → 이 응답은 버린다 */
			setAsList(data);
		},
		error    : function(xhr, textStatus){
			if(my !== ASWS_LIST_SEQ) return;
			ASWS_LIST_AFTER = null;
			asws_listErr(xhr, textStatus);
		},
		complete : function(){
			/* 스테일 응답이 최신 요청의 오버레이를 걷어내지 않도록 일련번호를 한 번 더 확인한다. */
			if(my === ASWS_LIST_SEQ) asws_listBusyOff();
		}
	});
}

/* setAsList 가 호출한다. 대기 중인 콜백을 "꺼내면서 비운다"(1회성 보장). */
function asws_listTakeAfter(){
	var fn = ASWS_LIST_AFTER;
	ASWS_LIST_AFTER = null;
	return fn;
}

/* ---- 3) 조회 실패 -------------------------------------------------------- */
function asws_listErr(xhr){
	var code = (xhr && xhr.status) ? xhr.status : 0;
	var msg;
	if(code === 403)      msg = '이 목록을 조회할 권한이 없습니다.';
	else if(code === 401) msg = '로그인이 만료되었습니다. 다시 로그인해 주세요.';
	else if(code === 0)   msg = '서버에 연결하지 못했습니다. 네트워크 상태를 확인해 주세요.';
	else                  msg = '서버 오류가 발생했습니다. (HTTP ' + code + ')';

	$('#asList').html(
		'<tr><td colspan="' + asws_listColspan() + '" class="asws-loaderr">'
		+ '<div class="asws-loaderr-tit">목록을 불러오지 못했습니다.</div>'
		+ '<div class="asws-loaderr-sub">' + asws_lesc(msg) + '</div>'
		+ '<button type="button" class="asws-empty-btn" onclick="asws_listLoad();">다시 시도</button>'
		+ '</td></tr>'
	);
	$('#count').html('0');
	$('#pagination').html('');
}

/* ---- 4) 빈 결과 안내 ----------------------------------------------------- */
/* 0건의 원인을 두 가지로 나눠 안내한다.
     (가) 처리구분이 '나의 A/S' → 나에게 배정된 건만 보고 있다. 이게 압도적으로 많은 원인이며,
          AS 처리담당자가 아닌 계정은 무엇을 검색해도 항상 0건이 된다.
     (나) '전체 A/S' 인데도 0건 → 순수하게 검색조건에 걸리는 건이 없는 경우. */
function asws_emptyHtml(){
	var isMine = ($('#asGubunFlag').val() === '2');
	var sub, btn;

	if(isMine){
		sub = '지금은 처리구분이 <b>나의 A/S</b> 라서 <b>나에게 배정된 접수건</b>만 조회합니다.<br>'
		    + 'A/S 처리담당자로 지정된 건이 없으면 검색조건과 상관없이 0건으로 나옵니다.';
		btn = '<button type="button" class="asws-empty-btn" onclick="asws_emptySwitchAll();">'
		    + '전체 A/S로 다시 조회</button>';
	}else{
		sub = '처리구분은 <b>전체 A/S</b> 입니다. 접수일·처리상태·통합검색 등<br>'
		    + '검색조건에 해당하는 접수건이 없습니다.';
		btn = '<button type="button" class="asws-empty-btn" onclick="searchReset();">'
		    + '검색조건 초기화</button>';
	}

	return '<tr><td colspan="' + asws_listColspan() + '" class="asws-empty">'
	     + '<div class="asws-empty-tit">조회된 데이터가 없습니다.</div>'
	     + '<div class="asws-empty-sub">' + sub + '</div>'
	     + btn
	     + '</td></tr>';
}

/* '전체 A/S로 다시 조회' 버튼.
   처리구분 select 는 listFrm 안에 있으므로 값만 바꾸고 재조회하면 그대로 전송된다.
   ※ 처리상태(SumoSelect)는 화면 위젯과 hidden(#procSelect)이 따로 놀 수 있어,
     getAsList() 와 동일하게 조회 직전에 위젯 값으로 hidden 을 동기화한다.
     (이걸 빼면 사용자가 방금 바꾼 처리상태가 조회에 반영되지 않는다) */
function asws_emptySwitchAll(){
	$('#asGubunFlag').val('1');
	try{
		if(typeof procSelect !== 'undefined' && procSelect){
			$('#procSelect').val(procSelect.sumo.getSelStr());
		}
	}catch(e){}
	asws_listLoad();
}
