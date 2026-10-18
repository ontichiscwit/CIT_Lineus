/* [AX Lab] 신규 파일 (2026-10-16 AX Lab): AS 목록에서 다른 접수건 선택 시 새 탭/현재 화면 선택
   - 아직 열린 접수건이 없거나 같은 건을 누르면 기존처럼 현재 화면에서 바로 연다.
   - 다른 건을 누르면 선택 모달을 표시하며, 행 선택 상태는 실제 열기 전까지 바꾸지 않는다.
   - 새 탭은 list.jsp 가 이미 지원하는 as_no/cn_as_no 쿼리 진입 방식을 재사용한다. */
(function(){
	'use strict';

	var pending = null;
	var modal = null;
	var previousFocus = null;

	function currentAsNo(){
		if(typeof asws !== 'undefined' && asws) return String(asws.asNo || '');
		return '';
	}

	function hasUnsavedChanges(){
		var answer = document.getElementById('cawsText');
		if(answer && String(answer.value || '').replace(/\s/g, '') !== '') return true;

		if(typeof caws_slots === 'function'){
			var slots = caws_slots();
			for(var i=0; i<slots.length; i++){
				if(slots[i].files && slots[i].files.length) return true;
			}
		}

		if(typeof caws !== 'undefined' && caws){
			if(caws.batchFiles && caws.batchFiles.length) return true;
			if(String(caws.batchMemo || '').replace(/\s/g, '') !== '') return true;
			if(caws.batch && typeof caws_batchHasChanges === 'function'){
				try{ if(caws_batchHasChanges()) return true; }catch(e){}
			}
		}
		return false;
	}

	function closeModal(){
		if(!modal) return;
		document.removeEventListener('keydown', onKeyDown);
		if(modal.parentNode) modal.parentNode.removeChild(modal);
		modal = null;
		pending = null;
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

	function openCurrent(){
		if(!pending) return;
		var target = pending;
		closeModal();
		asws_openDetail(target.asNo, target.cnAsNo);
	}

	function openNewTab(){
		if(!pending) return;
		var url = '/ad/as/list.do?as_no=' + encodeURIComponent(pending.asNo);
		if(pending.cnAsNo !== '') url += '&cn_as_no=' + encodeURIComponent(pending.cnAsNo);
		/* [AX Lab] 수정 시작 (2026-10-16 AX Lab): 브라우저별 window.open 반환값 차이로
		   정상 오픈을 팝업 차단으로 오인하지 않도록 링크 방식으로 연다.
		   기존 탭은 이동시키지 않고 선택 모달만 즉시 닫는다. */
		var link = document.createElement('a');
		link.href = url;
		link.target = '_blank';
		link.rel = 'noopener noreferrer';
		link.style.display = 'none';
		document.body.appendChild(link);
		link.click();
		document.body.removeChild(link);
		closeModal();
		/* [AX Lab] 수정 끝 */
	}

	function showModal(asNo, cnAsNo){
		closeModal();
		var workspace = document.getElementById('asWorkspace');
		if(!workspace){
			asws_openDetail(asNo, cnAsNo);
			return;
		}

		pending = { asNo:asNo, cnAsNo:cnAsNo };
		previousFocus = document.activeElement;
		modal = document.createElement('div');
		modal.className = 'asoc-backdrop';
		modal.setAttribute('role', 'presentation');
		modal.innerHTML = ''
			+ '<div class="asoc-dialog" role="dialog" aria-modal="true" aria-labelledby="asocTitle" aria-describedby="asocMessage">'
			+   '<h3 class="asoc-title" id="asocTitle">다른 접수건을 여시겠습니까?</h3>'
			+   '<p class="asoc-message" id="asocMessage">현재 접수건을 유지한 채 새 탭으로 열거나, 현재 화면의 접수건을 변경할 수 있습니다.</p>'
			+   '<div class="asoc-case">선택한 접수번호: <span id="asocTargetNo"></span></div>'
			+   (hasUnsavedChanges() ? '<div class="asoc-warning">현재 화면에 저장하지 않은 입력 내용이 있습니다. 현재 화면에서 열면 입력 내용이 사라집니다.</div>' : '')
			+   '<div class="asoc-actions">'
			+     '<button type="button" data-asoc="cancel">취소</button>'
			+     '<button type="button" data-asoc="new">새 탭으로 열기</button>'
			+     '<button type="button" class="asoc-current" data-asoc="current">현재 화면에서 열기</button>'
			+   '</div>'
			+ '</div>';

		modal.querySelector('#asocTargetNo').textContent = asNo;
		modal.addEventListener('click', function(e){
			if(e.target === modal){ closeModal(); return; }
			var action = e.target.getAttribute ? e.target.getAttribute('data-asoc') : '';
			if(action === 'cancel') closeModal();
			else if(action === 'new') openNewTab();
			else if(action === 'current') openCurrent();
		});
		workspace.appendChild(modal);
		document.addEventListener('keydown', onKeyDown);

		var currentBtn = modal.querySelector('[data-asoc="current"]');
		if(currentBtn) currentBtn.focus();
	}

	/* 목록 행 클릭 전용 진입점. 페이징/검색/등록 후 재조회 같은 기존 상세 유지 흐름은 건드리지 않는다. */
	window.asoc_selectFromList = function(asNo, cnAsNo){
		asNo = String(asNo || '');
		cnAsNo = String(cnAsNo || '');
		if(asNo === '') return;

		var current = currentAsNo();
		if(current === '' || current === asNo){
			asws_openDetail(asNo, cnAsNo);
			return;
		}
		showModal(asNo, cnAsNo);
	};
})();
