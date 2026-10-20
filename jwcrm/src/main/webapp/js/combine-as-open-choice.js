/* [AX Lab] 신규 파일 (2026-10-16 AX Lab): AS 목록에서 다른 접수건 선택 시 새 탭/현재 화면 선택 */
(function(){
	'use strict';

	var modal = null;
	var previousFocus = null;
	/* [AX Lab] 수정 시작 (2026-10-18 AX Lab): 평소 즉시 전환, 미저장 변경만 보호하고 브라우저 뒤로가기로 이전 AS 복원 */
	var historyReady = false;
	var historyIndex = 0;
	/* [AX Lab] 수정 시작 (2026-10-20 AX Lab): 미저장 항목 위치 안내 및 포커스 복원 */
	var dirtyFocusItem = null;
	var recordFieldInfo = {
		accept_route:{ label:'접수정보 > 접수경로', acc:'accept' },
		rl_apply_nm:{ label:'접수정보 > A/S신청자 이름', acc:'accept' },
		apply_tel:{ label:'접수정보 > A/S신청자 연락처', acc:'accept' },
		send_sms:{ label:'접수정보 > SMS수신동의여부', acc:'accept' },
		request_type:{ label:'접수정보 > 문의유형', acc:'accept' },
		service_cate:{ label:'접수정보 > 시스템유형', acc:'accept', editKey:'systype' },
		inquiry_type:{ label:'접수정보 > 시스템유형', acc:'accept', editKey:'systype' },
		version_info:{ label:'접수정보 > 버전정보', acc:'accept' },
		proc_status:{ label:'처리상태사항 > 현재 처리상태', acc:'proc' },
		assign_id:{ label:'처리상태사항 > 처리담당자', acc:'proc', editKey:'assign' },
		inportance:{ label:'처리상태사항 > 중요도', acc:'proc' },
		tel_confirm:{ label:'처리상태사항 > 전화확인', acc:'proc' },
		tel_absence:{ label:'처리상태사항 > 전화부재중', acc:'proc' },
		tel_absence_cnt:{ label:'처리상태사항 > 전화부재중 횟수', acc:'proc' },
		proc_dt:{ label:'처리완료사항 > 처리예정일자', acc:'done' },
		proc_time:{ label:'처리완료사항 > 예정시각', acc:'done' },
		cause_type:{ label:'처리완료사항 > 원인유형', acc:'done' },
		action_type:{ label:'처리완료사항 > 조치유형', acc:'done' },
		work_time:{ label:'처리완료사항 > 작업시간', acc:'done' },
		complete_dt:{ label:'처리완료사항 > 처리완료일', acc:'done' },
		proc_gubun:{ label:'처리완료 상세 > 처리구분', acc:'donedt' },
		proc_build_info:{ label:'처리완료 상세 > 빌드순번', acc:'donedt' },
		proc_test_info:{ label:'처리완료 상세 > 개발처리서', acc:'donedt' },
		proc_process_sp:{ label:'처리완료 상세 > 프로세스 정의서', acc:'donedt' },
		proc_screen_sp:{ label:'처리완료 상세 > 화면 정의서', acc:'donedt' },
		proc_table_sp:{ label:'처리완료 상세 > 테이블 정의서', acc:'donedt' },
		proc_function_sp:{ label:'처리완료 상세 > 기능분해도', acc:'donedt' },
		proc_interface_sp:{ label:'처리완료 상세 > 인터페이스 정의서', acc:'donedt' }
	};
	/* [AX Lab] 수정 끝 */

	function currentSelection(){
		return {
			asNo:(typeof asws !== 'undefined' && asws) ? String(asws.asNo || '') : '',
			cnAsNo:(typeof asws !== 'undefined' && asws) ? String(asws.cnAsNo || '') : ''
		};
	}

	/* [AX Lab] 수정 시작 (2026-10-20 AX Lab): boolean 대신 변경 필드 위치를 반환 */
	function liveRecordChange(){
		if(typeof caws === 'undefined' || !caws || !caws.fld) return null;
		var key = String(caws.fld);
		var vo = caws.vo || {};
		if(key === 'systype'){
			var cate = document.getElementById('cawsFldCate');
			var sub = document.getElementById('cawsFldSub');
			if(String(cate ? cate.value : '') !== String(vo.service_cate || '')
			   || String(sub ? sub.value : '') !== String(vo.inquiry_type || '')){
				return { id:'record-systype', kind:'record', key:'systype', live:true,
					label:'접수정보 > 시스템유형', acc:'accept', elementId:'cawsFldCate' };
			}
			return null;
		}
		var el = document.getElementById('cawsFldIn');
		if(!el) return null;
		var field = (key === 'assign') ? 'assign_id' : key;
		var live = String(el.value || '').trim();
		var saved = String(vo[field] || '');
		if(key === 'proc_dt' || key === 'complete_dt' || key === 'proc_time'){
			live = live.replace(/[^0-9]/g,'');
			saved = saved.replace(/[^0-9]/g,'');
		}
		if(live === saved) return null;
		var info = recordFieldInfo[field] || { label:'접수·처리 정보', acc:'' };
		return { id:'record-'+field, kind:'record', key:key, live:true,
			label:info.label, acc:info.acc, elementId:'cawsFldIn' };
	}
	/* [AX Lab] 수정 끝 */

	function dirtyState(){
		/* [AX Lab] 수정 시작 (2026-10-20 AX Lab): 미저장 종류와 실제 위치를 함께 수집 */
		var state = { answer:false, inquiry:false, history:false, historySeq:'', record:false, items:[] };
		var seen = {};
		function add(item){
			if(!item || seen[item.id]) return;
			seen[item.id] = true;
			state.items.push(item);
		}

		/* 현재 열려 있는 편집창을 우선해 가장 먼저 그 위치로 돌아가게 한다. */
		var inquiry = document.getElementById('cawsQTa');
		if(inquiry){
			var inquiryChanged = String(inquiry.value || '').trim()
				!== String((typeof caws !== 'undefined' && caws && caws.vo) ? (caws.vo.call_content || '') : '').trim();
			var deleted = document.querySelector('#cawsQBody .caws-qdel:checked');
			var inquiryFiles = document.querySelectorAll('#cawsQNewFiles input[type=file]');
			for(var qf=0; qf<inquiryFiles.length; qf++){
				if(inquiryFiles[qf].files && inquiryFiles[qf].files.length){ inquiryChanged = true; break; }
			}
			if(deleted || inquiryChanged){
				state.inquiry = true;
				add({ id:'inquiry', kind:'inquiry', label:'상세내용 > 문의내용', elementId:'cawsQTa' });
			}
		}

		var hist = document.getElementById('cawsHistEditTa');
		if(hist && !hist.disabled){
			var histBtn = document.querySelector('#cawsHistEditModal [onclick*="caws_histEditSave"]');
			var histCall = histBtn ? String(histBtn.getAttribute('onclick') || '') : '';
			var histMatch = /caws_histEditSave\('([^']+)'\)/.exec(histCall);
			var histSeq = histMatch ? histMatch[1] : '';
			var histEvent = (histSeq !== '' && typeof caws_histEvent === 'function') ? caws_histEvent(histSeq) : null;
			if(!histEvent || String(hist.value || '').trim() !== String(histEvent.text || '').trim()){
				state.history = true;
				state.historySeq = histSeq;
				add({ id:'history', kind:'history', label:'상세내용 > 작업처리 의견', elementId:'cawsHistEditTa', seq:histSeq });
			}
		}

		var liveChange = liveRecordChange();
		if(liveChange){ state.record = true; add(liveChange); }

		var answer = document.getElementById('cawsText');
		if(answer && String(answer.value || '').replace(/\s/g, '') !== ''){
			state.answer = true;
			add({ id:'answer', kind:'answer', label:'상세내용 > 고객 답변', elementId:'cawsText' });
		}

		if(typeof caws_slots === 'function'){
			var slots = caws_slots();
			for(var i=0; i<slots.length; i++){
				if(slots[i].files && slots[i].files.length){
					state.answer = true;
					add({ id:'answer', kind:'answer', label:'상세내용 > 고객 답변 첨부파일', elementId:'cawsText' });
					break;
				}
			}
		}

		if(typeof caws !== 'undefined' && caws && caws.batch
		   && typeof caws_batchHasChanges === 'function'){
			try{
				if(typeof CAWS_BATCH_FIELDS !== 'undefined' && typeof caws_batchChanged === 'function'){
					for(var bi=0; bi<CAWS_BATCH_FIELDS.length; bi++){
						var field = CAWS_BATCH_FIELDS[bi];
						if(!caws_batchChanged(field)) continue;
						state.record = true;
						var info = recordFieldInfo[field] || { label:'접수·처리 정보', acc:'' };
						add({ id:'record-'+(info.editKey || field), kind:'record', key:(info.editKey || field),
							label:info.label, acc:info.acc });
					}
				}
				if(String(caws.batchMemo || '').trim() !== ''){
					state.record = true;
					add({ id:'record-memo', kind:'record', label:'처리상태사항 > 조치이력',
						acc:'proc', elementId:'cawsBatchMemo' });
				}
				if(caws.batchFiles && caws.batchFiles.length){
					state.record = true;
					add({ id:'record-files', kind:'record', label:'처리상태사항 > 조치이력 첨부파일',
						acc:'proc', selector:'.caws-batchfiles-head button' });
				}
				if(caws_batchHasChanges()) state.record = true;
			}catch(e){}
		}
		if(state.record){
			var hasRecordItem = false;
			for(var ri=0; ri<state.items.length; ri++){
				if(state.items[ri].kind === 'record'){ hasRecordItem = true; break; }
			}
			if(!hasRecordItem) add({ id:'record', kind:'record', label:'접수·처리 정보', elementId:'asRecord' });
		}
		/* [AX Lab] 수정 끝 */
		return state;
	}

	function hasUnsavedChanges(){
		var state = dirtyState();
		return state.answer || state.inquiry || state.history || state.record;
	}

	/* [AX Lab] 수정 시작 (2026-10-20 AX Lab): 경고 닫기 후 미저장 위치로 이동·강조 */
	function closeModal(skipRestore){
		if(!modal) return;
		document.removeEventListener('keydown', onKeyDown);
		if(modal.parentNode) modal.parentNode.removeChild(modal);
		modal = null;
		if(!skipRestore && previousFocus && typeof previousFocus.focus === 'function'){
			try{ previousFocus.focus(); }catch(e){}
		}
		previousFocus = null;
	}

	function openAccordion(key){
		if(!key) return;
		var acc = document.getElementById('cawsAcc_'+key);
		if(acc && acc.classList.contains('off') && typeof caws_accToggle === 'function') caws_accToggle(key);
	}

	function highlightAndFocus(el){
		if(!el) return;
		var target = el;
		if(el.closest){
			target = el.closest('.kv, .caws-batchmemo-wrap, .caws-compose, .caws-btxt, .caws-modal') || el;
		}
		target.classList.add('asoc-focus-target');
		try{ target.scrollIntoView({ behavior:'smooth', block:'center' }); }
		catch(e){ try{ target.scrollIntoView(false); }catch(ignore){} }
		setTimeout(function(){
			try{ el.focus(); }catch(e){}
			target.classList.add('asoc-focus-pulse');
		}, 180);
		setTimeout(function(){
			target.classList.remove('asoc-focus-target');
			target.classList.remove('asoc-focus-pulse');
		}, 2600);
	}

	function focusDirty(item){
		if(!item) return;
		openAccordion(item.acc);
		if(item.kind === 'answer' && typeof caws_openCompose === 'function') caws_openCompose();

		/* 확정된 접수·처리 필드는 편집창을 다시 열어 실제 입력 컨트롤에 포커스한다. */
		if(item.kind === 'record' && item.key && !item.live && typeof caws_fldOpen === 'function'){
			try{ caws_fldOpen(item.key); }catch(e){}
			setTimeout(function(){
				var opened = document.getElementById('cawsFldIn')
					|| document.getElementById('cawsFldCate')
					|| document.querySelector('#cawsAcc_'+item.acc+' .caws-fe');
				highlightAndFocus(opened);
			}, 30);
			return;
		}

		var el = item.elementId ? document.getElementById(item.elementId) : null;
		if(!el && item.selector) el = document.querySelector(item.selector);
		if(!el && item.acc) el = document.getElementById('cawsAcc_'+item.acc);
		highlightAndFocus(el);
	}

	function goToDirty(){
		var item = dirtyFocusItem;
		closeModal(true);
		dirtyFocusItem = null;
		setTimeout(function(){ focusDirty(item); }, 20);
	}
	/* [AX Lab] 수정 끝 */

	function onKeyDown(e){
		if(!modal) return;
		if(e.key === 'Escape' || e.keyCode === 27){
			e.preventDefault();
			goToDirty();
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
		if(!state.answer && !state.inquiry && !state.history && !state.record){ closeModal(); return; }

		/* 저장 함수의 자체 검증 메시지와 입력 포커스가 가려지지 않도록 선택창부터 닫는다.
		   답변과 접수처리정보가 모두 변경됐으면 서로 다른 기존 저장 API를 각각 호출한다. */
		closeModal(true);
		dirtyFocusItem = null;
		/* [AX Lab] 수정 시작 (2026-10-20 AX Lab): 문의내용·조치이력 편집도 경고창 저장 대상에 포함 */
		if(state.inquiry && typeof caws_qSave === 'function') caws_qSave();
		if(state.history && state.historySeq !== '' && typeof caws_histEditSave === 'function') caws_histEditSave(state.historySeq);
		/* [AX Lab] 수정 끝 */
		if(state.answer && typeof caws_send === 'function') caws_send();
		if(state.record && typeof caws_batchSave === 'function') caws_batchSave();
	}

	function showDirtyModal(){
		closeModal();
		var workspace = document.getElementById('asWorkspace');
		if(!workspace) return;

		var state = dirtyState();
		dirtyFocusItem = state.items.length ? state.items[0] : null;
		var names = [];
		for(var i=0; i<state.items.length && i<3; i++) names.push(state.items[i].label);
		var locationText = names.join(', ');
		if(state.items.length > 3) locationText += ' 외 '+(state.items.length-3)+'곳';

		previousFocus = document.activeElement;
		modal = document.createElement('div');
		modal.className = 'asoc-backdrop';
		modal.setAttribute('role', 'presentation');
		modal.innerHTML = ''
			+ '<div class="asoc-dialog" role="dialog" aria-modal="true" aria-labelledby="asocTitle" aria-describedby="asocMessage">'
			+   '<h3 class="asoc-title" id="asocTitle">저장하지 않은 내용이 있습니다.</h3>'
			+   '<p class="asoc-message" id="asocMessage">변경한 내용을 저장하거나 수정 위치로 돌아간 후 다시 선택해 주세요.</p>'
			+   (locationText ? '<div class="asoc-location"><strong>미저장 위치</strong><span></span></div>' : '')
			+   '<div class="asoc-actions">'
			+     '<button type="button" data-asoc="cancel">수정 위치로 이동</button>'
			+     '<button type="button" class="asoc-current" data-asoc="save">저장</button>'
			+   '</div>'
			+ '</div>';
		var location = modal.querySelector('.asoc-location span');
		if(location) location.textContent = locationText;

		modal.addEventListener('click', function(e){
			if(e.target === modal){ goToDirty(); return; }
			var action = e.target.getAttribute ? e.target.getAttribute('data-asoc') : '';
			if(action === 'cancel') goToDirty();
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
