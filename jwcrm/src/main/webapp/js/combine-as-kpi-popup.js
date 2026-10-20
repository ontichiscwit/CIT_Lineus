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
	/* [AX Lab] 수정 시작 (2026-10-20 AX Lab): KPI 상세 목록 컬럼 클릭 정렬 상태/정의 */
	var akpRows = [];
	var akpSort = { key:'', direction:'' };
	var AKP_COLUMNS = [
		{ key:'AS_NO',         label:'접수번호',    type:'text' },
		{ key:'PROC_STATUS_NM',label:'처리상태',    type:'text' },
		{ key:'CUST_KOR_NAME', label:'거래처명',    type:'text' },
		{ key:'CALL_CONTENT',  label:'요청사항',    type:'text' },
		{ key:'ACCEPT_DT',     label:'접수일',      type:'date' },
		{ key:'TARGET_DT',     label:'예정·완료일', type:'date' },
		{ key:'EMP_NM',        label:'담당자',      type:'text' }
	];
	/* [AX Lab] 수정 끝 */

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
		/* [AX Lab] 수정 시작 (2026-10-20 AX Lab): 같은 컬럼은 오름차순/내림차순을 번갈아 적용 */
		$('#akpBody').on('click', '.akp-sort-button', function(){
			var key = String($(this).attr('data-sort-key') || '');
			if(!key) return;
			if(akpSort.key === key){
				akpSort.direction = akpSort.direction === 'asc' ? 'desc' : 'asc';
			}else{
				akpSort.key = key;
				akpSort.direction = 'asc';
			}
			akpRender();
		});
		/* [AX Lab] 수정 끝 */
	}

	function akpClose(){
		if(akpXhr){
			akpXhr.abort();
			akpXhr = null;
		}
		$('#akpModal, #akpDim').hide();
		$(document).off('keydown.akp');
	}

	/* [AX Lab] 수정 시작 (2026-10-20 AX Lab): 문자/날짜 컬럼 정렬, 빈 값은 방향과 무관하게 마지막에 배치 */
	function akpSortValue(row, key){
		if(key === 'TARGET_DT'){
			return akpType === 'DONE_TODAY' ? akpVal(row, 'COMPLETE_DT') : akpVal(row, 'PROC_DT');
		}
		return akpVal(row, key);
	}

	function akpSortedRows(){
		if(!akpSort.key || !akpSort.direction) return akpRows.slice(0);
		var type = 'text';
		for(var c=0; c<AKP_COLUMNS.length; c++){
			if(AKP_COLUMNS[c].key === akpSort.key){
				type = AKP_COLUMNS[c].type;
				break;
			}
		}
		var wrapped = [];
		for(var i=0; i<akpRows.length; i++) wrapped.push({ row:akpRows[i], index:i });
		wrapped.sort(function(a, b){
			var av = $.trim(akpSortValue(a.row, akpSort.key));
			var bv = $.trim(akpSortValue(b.row, akpSort.key));
			var aEmpty = av === '' || av === '-';
			var bEmpty = bv === '' || bv === '-';
			if(aEmpty || bEmpty){
				if(aEmpty && bEmpty) return a.index - b.index;
				return aEmpty ? 1 : -1;
			}
			if(type === 'date'){
				av = av.replace(/[^0-9]/g, '');
				bv = bv.replace(/[^0-9]/g, '');
			}else{
				av = av.toLowerCase();
				bv = bv.toLowerCase();
			}
			var result = av < bv ? -1 : (av > bv ? 1 : 0);
			if(result === 0) return a.index - b.index;
			return akpSort.direction === 'desc' ? -result : result;
		});
		var sorted = [];
		for(var j=0; j<wrapped.length; j++) sorted.push(wrapped[j].row);
		return sorted;
	}
	/* [AX Lab] 수정 끝 */

	function akpRender(rows){
		/* [AX Lab] 수정 시작 (2026-10-20 AX Lab): 최초 응답은 보관하고 헤더 클릭 때 정렬된 복사본만 렌더링 */
		if($.isArray(rows)) akpRows = rows.slice(0);
		rows = akpSortedRows();
		/* [AX Lab] 수정 끝 */
		$('#akpCount').text(rows.length + '건');
		if(!rows.length){
			$('#akpBody').html('<div class="akp-empty">해당하는 A/S가 없습니다.</div>');
			return;
		}

		var html = ''
			+ '<table class="akp-table">'
			+ '<colgroup><col style="width:112px"><col style="width:82px"><col style="width:145px">'
			+ '<col><col style="width:88px"><col style="width:102px"><col style="width:76px"></colgroup>'
			+ '<thead><tr>';
		/* [AX Lab] 수정 시작 (2026-10-20 AX Lab): 접근 가능한 정렬 버튼과 현재 방향 표시 */
		for(var h=0; h<AKP_COLUMNS.length; h++){
			var column = AKP_COLUMNS[h];
			var active = akpSort.key === column.key;
			var ariaSort = active ? (akpSort.direction === 'desc' ? 'descending' : 'ascending') : 'none';
			var indicator = active ? (akpSort.direction === 'desc' ? '&#9660;' : '&#9650;') : '&#8645;';
			html += '<th aria-sort="'+ariaSort+'"><button type="button" class="akp-sort-button'
				+ (active ? ' is-active' : '') + '" data-sort-key="'+akpEsc(column.key)
				+ '" title="'+akpEsc(column.label)+' 정렬">'+akpEsc(column.label)
				+ '<span class="akp-sort-indicator" aria-hidden="true">'+indicator+'</span></button></th>';
		}
		html += '</tr></thead><tbody>';
		/* [AX Lab] 수정 끝 */

		for(var i=0; i<rows.length; i++){
			var row = rows[i];
			var asNo = akpVal(row, 'AS_NO');
			var cnAsNo = akpVal(row, 'CN_AS_NO');
			var request = akpVal(row, 'CALL_CONTENT') || '(내용 없음)';
			/* [AX Lab] 수정 시작 (2026-10-19 AX Lab): 기존 AS 목록과 동일한 처리상태 칩 색상 적용 */
			var procStatus = akpVal(row, 'PROC_STATUS');
			var statusClass = typeof window.asws_stClass === 'function'
				? window.asws_stClass(procStatus) : '';
			/* [AX Lab] 수정 끝 */
			var targetDate = akpType === 'DONE_TODAY'
				? akpVal(row, 'COMPLETE_DT') : akpVal(row, 'PROC_DT');
			html += '<tr data-as-no="'+akpEsc(asNo)+'" data-cn-as-no="'+akpEsc(cnAsNo)+'">'
				+ '<td class="akp-no">'+akpEsc(asNo)+'</td>'
				+ '<td class="akp-no"><span class="akp-status st '+akpEsc(statusClass)+'">'+akpEsc(akpVal(row, 'PROC_STATUS_NM') || '-')+'</span></td>'
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
		/* [AX Lab] 수정 시작 (2026-10-20 AX Lab): KPI 팝업을 새로 열 때 서버 기본 정렬(접수번호 내림차순)로 초기화 */
		akpRows = [];
		akpSort = { key:'', direction:'' };
		/* [AX Lab] 수정 끝 */
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
