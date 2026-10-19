/* [AX Lab] 신규 파일 (2026-10-16 AX Lab): AS 목록에서 다른 접수건 선택 시 새 탭/현재 화면 선택 */
(function(){
	'use strict';

	var modal = null;
	var previousFocus = null;
	/* [AX Lab] 수정 시작 (2026-10-18 AX Lab): 평소 즉시 전환, 미저장 변경만 보호하고 브라우저 뒤로가기로 이전 AS 복원 */
	var historyReady = false;
	var historyIndex = 0;

	function currentSelection(){
		return {
			asNo:(typeof asws !== 'undefined' && asws) ? String(asws.asNo || '') : '',
			cnAsNo:(typeof asws !== 'undefined' && asws) ? String(asws.cnAsNo || '') : ''
		};
	}

	function liveRecordChanged(){
		if(typeof caws === 'undefined' || !caws || !caws.fld) return false;
		var key = String(caws.fld);
		var vo = caws.vo || {};
		if(key === 'systype'){
			var cate = document.getElementById('cawsFldCate');
			var sub = document.getElementById('cawsFldSub');
			return String(cate ? cate.value : '') !== String(vo.service_cate || '')
				|| String(sub ? sub.value : '') !== String(vo.inquiry_type || '');
		}
		var el = document.getElementById('cawsFldIn');
		if(!el) return false;
		var field = (key === 'assign') ? 'assign_id' : key;
		var live = String(el.value || '').trim();
		var saved = String(vo[field] || '');
		if(key === 'proc_dt' || key === 'complete_dt' || key === 'proc_time'){
			live = live.replace(/[^0-9]/g,'');
			saved = saved.replace(/[^0-9]/g,'');
		}
		return live !== saved;
	}

	function dirtyState(){
		var state = { answer:false, record:false };
		var answer = document.getElementById('cawsText');
		if(answer && String(answer.value || '').replace(/\s/g, '') !== '') state.answer = true;

		if(typeof caws_slots === 'function'){
			var slots = caws_slots();
			for(var i=0; i<slots.length; i++){
				if(slots[i].files && slots[i].files.length){ state.answer = true; break; }
			}
		}

		/* 접수·처리 정보의 전체 편집 필드, 조치이력, 첨부 변경을 기존 비교 함수로 한 번에 확인한다. */
		if(typeof caws !== 'undefined' && caws && caws.batch
		   && typeof caws_batchHasChanges === 'function'){
			try{ state.record = caws_batchHasChanges(); }catch(e){}
		}
		/* 날짜를 아직 완성하지 않은 상태처럼 vo에 반영되기 전인 현재 입력값도 놓치지 않는다. */
		if(!state.record) state.record = liveRecordChanged();
		return state;
	}

	function hasUnsavedChanges(){
		var state = dirtyState();
		return state.answer || state.record;
	}

	function closeModal(){
		if(!modal) return;
		document.removeEventListener('keydown', onKeyDown);
		if(modal.parentNode) modal.parentNode.removeChild(modal);
		modal = null;
		if(previousFocus && typeof previousFocus.focus === 'function'){
			try{ previousFocus.focus(); }catch(e){}
		}
		previousFocus = null;
	}

	function onKeyDown(e){
		if(!modal) return;
		if(e.key === 'Escape' || e.keyCode === 27){
			e.preventDefault();
			closeModal();
		}
	}

	function queryValue(name){
		var m = new RegExp('(?:^|[?&])'+name+'=([^&]*)').exec(window.location.search || '');
		if(!m) return '';
		try{ return decodeURIComponent(String(m[1]).replace(/\+/g,' ')); }catch(e){ return ''; }
	}

	function historyUrl(asNo, cnAsNo){
		var url = '/ad/as/list.do';
		if(asNo !== ''){
			url += '?as_no='+encodeURIComponent(asNo);
			if(cnAsNo !== '') url += '&cn_as_no='+encodeURIComponent(cnAsNo);
		}
		return url;
	}

	function historyState(asNo, cnAsNo, index){
		return { asoc:true, asNo:String(asNo||''), cnAsNo:String(cnAsNo||''), index:index };
	}

	function initHistory(){
		if(historyReady) return;
		var asNo = queryValue('as_no');
		var cnAsNo = queryValue('cn_as_no');
		var old = window.history.state;
		if(old && old.asoc === true){
			historyIndex = Number(old.index) || 0;
		}else{
			try{ window.history.replaceState(historyState(asNo,cnAsNo,0),'',window.location.href); }catch(e){}
			historyIndex = 0;
		}
		historyReady = true;
	}

	function rememberCurrent(){
		initHistory();
		var current = currentSelection();
		var state = window.history.state;
		if(!state || state.asoc !== true
		   || String(state.asNo||'') !== current.asNo
		   || String(state.cnAsNo||'') !== current.cnAsNo){
			try{
				window.history.replaceState(
					historyState(current.asNo,current.cnAsNo,historyIndex),
					'', historyUrl(current.asNo,current.cnAsNo)
				);
			}catch(e){}
		}
	}

	function openDetail(asNo, cnAsNo, addHistory){
		if(addHistory){
			rememberCurrent();
			historyIndex++;
			try{
				window.history.pushState(
					historyState(asNo,cnAsNo,historyIndex),
					'', historyUrl(asNo,cnAsNo)
				);
			}catch(e){}
		}
		asws_openDetail(asNo, cnAsNo);
	}

	function saveDirty(){
		var state = dirtyState();
		if(!state.answer && !state.record){ closeModal(); return; }

		/* 저장 함수의 자체 검증 메시지와 입력 포커스가 가려지지 않도록 선택창부터 닫는다.
		   답변과 접수처리정보가 모두 변경됐으면 서로 다른 기존 저장 API를 각각 호출한다. */
		closeModal();
		if(state.answer && typeof caws_send === 'function') caws_send();
		if(state.record && typeof caws_batchSave === 'function') caws_batchSave();
	}

	function showDirtyModal(){
		closeModal();
		var workspace = document.getElementById('asWorkspace');
		if(!workspace) return;

		previousFocus = document.activeElement;
		modal = document.createElement('div');
		modal.className = 'asoc-backdrop';
		modal.setAttribute('role', 'presentation');
		modal.innerHTML = ''
			+ '<div class="asoc-dialog" role="dialog" aria-modal="true" aria-labelledby="asocTitle" aria-describedby="asocMessage">'
			+   '<h3 class="asoc-title" id="asocTitle">저장하지 않은 내용이 있습니다.</h3>'
			+   '<p class="asoc-message" id="asocMessage">변경한 내용을 저장하거나 취소한 후 다시 선택해 주세요.</p>'
			+   '<div class="asoc-actions">'
			+     '<button type="button" data-asoc="cancel">취소</button>'
			+     '<button type="button" class="asoc-current" data-asoc="save">저장</button>'
			+   '</div>'
			+ '</div>';

		modal.addEventListener('click', function(e){
			if(e.target === modal){ closeModal(); return; }
			var action = e.target.getAttribute ? e.target.getAttribute('data-asoc') : '';
			if(action === 'cancel') closeModal();
			else if(action === 'save') saveDirty();
		});
		workspace.appendChild(modal);
		document.addEventListener('keydown', onKeyDown);

		var saveBtn = modal.querySelector('[data-asoc="save"]');
		if(saveBtn) saveBtn.focus();
	}

	function clearDetail(){
		if(typeof asws !== 'undefined' && asws){
			asws.asNo = ''; asws.cnAsNo = ''; asws.curRow = null;
		}
		try{ $('#asList tr').removeClass('on'); $('#pinlabel').text(''); }catch(e){}
		if(typeof caws_clear === 'function') caws_clear('왼쪽 목록에서 접수건을 선택하세요.');
	}

	/* 목록 행 클릭 전용 진입점. 검색·페이징처럼 현재 상세를 유지하는 흐름은 건드리지 않는다. */
	window.asoc_selectFromList = function(asNo, cnAsNo){
		asNo = String(asNo || '');
		cnAsNo = String(cnAsNo || '');
		if(asNo === '') return;

		var current = currentSelection();
		if(current.asNo === asNo && current.cnAsNo === cnAsNo){
			openDetail(asNo, cnAsNo, false);
			return;
		}
		if(current.asNo !== '' && hasUnsavedChanges()){
			showDirtyModal();
			return;
		}
		openDetail(asNo, cnAsNo, true);
	};

	window.addEventListener('popstate', function(e){
		var state = e.state;
		if(!state || state.asoc !== true) return;

		/* 뒤로가기 자체도 미저장 내용을 잃게 할 수 있으므로 현재 AS를 이력에 복원하고 동일 경고를 표시한다. */
		if(hasUnsavedChanges()){
			var current = currentSelection();
			historyIndex = (Number(state.index) || 0) + 1;
			try{
				window.history.pushState(
					historyState(current.asNo,current.cnAsNo,historyIndex),
					'', historyUrl(current.asNo,current.cnAsNo)
				);
			}catch(ignore){}
			showDirtyModal();
			return;
		}

		historyIndex = Number(state.index) || 0;
		var asNo = String(state.asNo || '');
		var cnAsNo = String(state.cnAsNo || '');
		if(asNo === '') clearDetail();
		else openDetail(asNo, cnAsNo, false);
	});

	if(document.readyState === 'loading'){
		document.addEventListener('DOMContentLoaded', initHistory);
	}else{
		initHistory();
	}
	/* [AX Lab] 수정 끝 */
})();
