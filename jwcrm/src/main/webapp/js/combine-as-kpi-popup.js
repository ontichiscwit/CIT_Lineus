/* [AX Lab] 신규 파일 (2026-10-19): 나의 A/S KPI 카드 상세 목록 팝업 */
(function(window, $){
	'use strict';

	var AKP_CARDS = {
		'kpi-today':     { type:'TODAY',      title:'오늘 신규 접수' },
		'kpi-recv':      { type:'OPEN',       title:'미처리' },
		'kpi-urgent':    { type:'URGENT',     title:'긴급' },
		'kpi-duetoday':  { type:'DUE_TODAY',  title:'처리예정 오늘' },
		'kpi-overdue':   { type:'OVERDUE',    title:'처리예정일 지남' },
		'kpi-donetoday': { type:'DONE_TODAY', title:'오늘 처리완료' }
	};
	var akpXhr = null;
	var akpType = '';

	function akpEsc(value){
		if(typeof window.asws_esc === 'function') return window.asws_esc(value == null ? '' : String(value));
		return String(value == null ? '' : value)
			.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')
			.replace(/"/g,'&quot;').replace(/'/g,'&#39;');
	}

	function akpVal(row, name){
		if(!row) return '';
		var value = row[name];
		if(value == null) value = row[name.toLowerCase()];
		return value == null ? '' : String(value);
	}

	function akpMount(){
		if(document.getElementById('akpModal')) return;
		var html = ''
			+ '<div class="akp-dim" id="akpDim" style="display:none;"></div>'
			+ '<div class="akp-modal" id="akpModal" style="display:none;" role="dialog" aria-modal="true" aria-labelledby="akpTitle">'
			+ '  <div class="akp-head">'
			+ '    <h3 id="akpTitle">나의 A/S 목록</h3>'
			+ '    <span class="akp-count" id="akpCount"></span>'
			+ '    <button type="button" class="akp-close" id="akpClose" title="닫기 (ESC)">&times;</button>'
			+ '  </div>'
			+ '  <div class="akp-body" id="akpBody"></div>'
			+ '</div>';
		$('#asWorkspace').append(html);
		$('#akpDim, #akpClose').on('click', akpClose);
		$('#akpBody').on('click', 'tr[data-as-no]', function(){
			var asNo = String($(this).attr('data-as-no') || '');
			var cnAsNo = String($(this).attr('data-cn-as-no') || '');
			akpClose();
			if(typeof window.asoc_selectFromList === 'function') window.asoc_selectFromList(asNo, cnAsNo);
			else if(typeof window.asws_openDetail === 'function') window.asws_openDetail(asNo, cnAsNo);
		});
	}

	function akpClose(){
		if(akpXhr){
			akpXhr.abort();
			akpXhr = null;
		}
		$('#akpModal, #akpDim').hide();
		$(document).off('keydown.akp');
	}

	function akpRender(rows){
		rows = $.isArray(rows) ? rows : [];
		$('#akpCount').text(rows.length + '건');
		if(!rows.length){
			$('#akpBody').html('<div class="akp-empty">해당하는 A/S가 없습니다.</div>');
			return;
		}

		var html = ''
			+ '<table class="akp-table">'
			+ '<colgroup><col style="width:112px"><col style="width:82px"><col style="width:145px">'
			+ '<col><col style="width:88px"><col style="width:102px"><col style="width:76px"></colgroup>'
			+ '<thead><tr><th>접수번호</th><th>처리상태</th><th>거래처명</th><th>요청사항</th>'
			+ '<th>접수일</th><th>예정·완료일</th><th>담당자</th></tr></thead><tbody>';

		for(var i=0; i<rows.length; i++){
			var row = rows[i];
			var asNo = akpVal(row, 'AS_NO');
			var cnAsNo = akpVal(row, 'CN_AS_NO');
			var request = akpVal(row, 'CALL_CONTENT') || '(내용 없음)';
			var targetDate = akpType === 'DONE_TODAY'
				? akpVal(row, 'COMPLETE_DT') : akpVal(row, 'PROC_DT');
			html += '<tr data-as-no="'+akpEsc(asNo)+'" data-cn-as-no="'+akpEsc(cnAsNo)+'">'
				+ '<td class="akp-no">'+akpEsc(asNo)+'</td>'
				+ '<td class="akp-no"><span class="akp-status">'+akpEsc(akpVal(row, 'PROC_STATUS_NM') || '-')+'</span></td>'
				+ '<td>'+akpEsc(akpVal(row, 'CUST_KOR_NAME') || '-')+'</td>'
				+ '<td class="akp-request" title="'+akpEsc(request)+'"><div class="akp-request-text">'+akpEsc(request)+'</div></td>'
				+ '<td class="akp-date">'+akpEsc(akpVal(row, 'ACCEPT_DT') || '-')+'</td>'
				+ '<td class="akp-date">'+akpEsc(targetDate || '-')+'</td>'
				+ '<td class="akp-owner">'+akpEsc(akpVal(row, 'EMP_NM') || '-')+'</td>'
				+ '</tr>';
		}
		$('#akpBody').html(html + '</tbody></table>');
	}

	function akpOpen(config){
		akpMount();
		akpType = config.type;
		$('#akpTitle').text('나의 A/S - ' + config.title);
		$('#akpCount').text('');
		$('#akpBody').html('<div class="akp-loading">목록을 불러오는 중입니다.</div>');
		$('#akpDim').show();
		$('#akpModal').css('display', 'flex');
		$('#akpClose').focus();
		$(document).off('keydown.akp').on('keydown.akp', function(e){
			if(e.keyCode === 27) akpClose();
		});

		if(akpXhr) akpXhr.abort();
		var request = $.ajax({
			type:'POST',
			url:'/ad/as/getAsList.do',
			data:{ kpiType:config.type },
			dataType:'json'
		});
		akpXhr = request;
		request.done(function(data){
			akpRender(data && data.resultList);
		}).fail(function(xhr, status){
			if(status !== 'abort'){
				$('#akpCount').text('');
				$('#akpBody').html('<div class="akp-error">목록을 불러오지 못했습니다. 잠시 후 다시 시도해 주세요.</div>');
			}
		}).always(function(){
			if(akpXhr === request) akpXhr = null;
		});
	}

	function akpBind(){
		$.each(AKP_CARDS, function(numberId, config){
			var $number = $('#'+numberId);
			var $card = $number.closest('.card');
			if(!$card.length) return;
			$card.attr({ role:'button', tabindex:'0', 'aria-label':config.title+' 목록 보기' });
			$card.on('click.akp', function(){ akpOpen(config); });
			$card.on('keydown.akp', function(e){
				if(e.keyCode === 13 || e.keyCode === 32){
					e.preventDefault();
					akpOpen(config);
				}
			});
		});
	}

	$(akpBind);
	window.akp_close = akpClose;
})(window, window.jQuery);
