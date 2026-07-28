<%@page import="egovframework.com.comm.util.CommonExecute"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style>
	.status_bold {color:#0032c3 !important;font-weight:bold;}
	.scroll-table{width:1720px;;table-layout:auto;}
	.scroll-table tr:hover{background-color: #eef7f9 !important;}
	
	#procLayer .layer_contents { padding: 15px; }
	#procLayer table.sType th { vertical-align: middle; }
	#procLayer table.sType td { vertical-align: middle; }
	#procLayer input[type=text], #procLayer select, #procLayer input[type=number] { height: 30px; }
	#procLayer textarea { width: 98%; }
</style>

<script type="text/javascript">
	
	var v_as_no = "" ; 
	var procSelect;
	
	/* [AX Lab] 수정 시작 (2026-07-28 AX Lab): 고급필터의 '처리완료 외 상태' 체크박스(search_type13)를 화면에서 제거하고,
	   동일한 조회결과를 "처리상태 멀티셀렉트의 기본 체크"로 대체한다.
	   - 기본 체크 = 접수(C001) + 처리중(C004)  → 기존 체크박스가 걸던 조건과 완전히 동일
	   - 체크박스 제거 이유: (1) 자주 쓰는데 고급필터 안에 숨어 있었음 (2) 체크 시 처리상태 멀티셀렉트를
	     강제로 비워버려(change_exceptComplete) 사용자가 이유를 알 수 없었음 (3) 조회조건이 두 곳으로 갈려 있었음
	   - search_type13 은 hidden 으로만 남겨 항상 'N' 을 전송한다. 이 값으로 "첫 진입"을 판별한다.
	       · ''  (첫 진입, 검색 파라미터 없음) → 기본 체크 적용
	       · 'Y' (기능 제거 전 구 북마크/링크)  → 기본 체크 적용 (SQL 은 하위호환으로 동일 결과)
	       · 'N' (이 화면에서 검색 실행함)      → 사용자가 고른 처리상태를 그대로 존중
	     ※ 이 구분이 없으면 사용자가 처리상태를 전부 해제해도 매번 기본값으로 되돌아가 필터를 풀 수 없다.
	   - SQL(egov-as-query.xml)은 search_type13 != 'Y' 분기를 그대로 타므로 쿼리 무수정. */
	var ASWS_PROC_DEFAULT = 'C001,C004';	/* 접수, 처리중 */
	var ASWS_IS_FIRST_ENTRY = ('${ vo.search_type13 }' !== 'N');

	/* 처리상태 초기값 문자열 : 첫 진입이면 기본(접수+처리중), 검색 이후에는 저장된 사용자 선택 */
	function asws_procInitStr(){
		return ASWS_IS_FIRST_ENTRY ? ASWS_PROC_DEFAULT : '${ vo.procSelect }';
	}

	/* SumoSelect 에 처리상태 코드들을 체크 표시 (공식 API 사용 → 캡션/전체선택 상태까지 자동 갱신) */
	function asws_procApply(csv){
		if(typeof procSelect === 'undefined' || !procSelect) return;
		var arr = ('' + (csv || '')).split(',');
		for(var i = 0; i < arr.length; i++){
			var code = $.trim(arr[i]);
			if(code !== ''){
				try{ procSelect.sumo.selectItem(code); }catch(e){}
			}
		}
	}
	/* [AX Lab] 수정 끝 */
	
	$(document).ready(function(){
		
		var savedCheck = sessionStorage.getItem("search_type10_checked");
		if (savedCheck === null || savedCheck === "true") {
			$("#search_type10").prop("checked", true);
		} else {
			$("#search_type10").prop("checked", false);
		}
		
		
		
		initForm();
		if (typeof asws_initKpiCollapse === 'function') asws_initKpiCollapse(); /* [AX Lab] KPI 영역을 접힘으로 고정 + 구버전 저장값 정리 (2026-07-28 AX Lab) */
		makeListData();	/* [AX Lab] 상단 KPI(나에게 배정된 건 6종)는 getAsList.do 응답에 동봉되어 setAsList 에서 갱신됨 */
		$("#search_text").keyup(function(e){if(e.keyCode == 13)  getAsList(1); });
		/* [AX Lab] 삭제 (2026-07-24 AX Lab): emp_nm/search_type4/search_type6 필드는 고급필터 동적행으로 대체됨 */
		
		$("#searchKorName").keyup(function(e){if(e.keyCode == 13)  custList(1); });
		
		/*처리상태 - 멀티셀렉트박스 처리*/
		/*관련파일 - jquery.sumoselect.min.js, jquery.sumoselect.js*/
		procSelect = $('.procMultiSelect').SumoSelect({
												placeholder: '전체선택',
												csvDispCount : 5,
												captionFormatAllSelected: '전체선택',
												selectAll : true,
												locale :  ['OK', 'Cancel', '전체선택'],
												up : false
											});
		
		
		/* [AX Lab] 수정 시작 (2026-07-28 AX Lab): 처리상태 초기 체크 반영.
		   기존 코드는 option 의 selected "속성"과 캡션 텍스트를 직접 조작해서, getSelStr() 이 실제로 읽는
		   selected "프로퍼티"와 어긋날 수 있었다(검색 시 처리상태가 누락될 위험).
		   → 공식 API(sumo.selectItem) 로 교체하고, 초기값은 asws_procInitStr() 로 통일한다. */
		asws_procApply(asws_procInitStr());
		/* [AX Lab] 수정 끝 */
	}) ;
	
	/* [AX Lab] 수정 시작 (2026-07-24 AX Lab): 검색조건을 COL1 기본/고급 필터로 이동하며 initForm 정리.
	   - 기본필터(접수일자/처리구분/처리상태/통합검색)와 팝업(일괄처리/답변검색)용 코드/데이트픽커만 유지.
	   - 나머지 검색필드는 고급필터 동적행(asws_advInit)으로 대체. */
	function initForm(){

		commonCode.getCodeList('AS' , 'CD01' , 'procMultiSelect') ; //처리상태(멀티셀렉트)

		commonCode.getCodeList('AS' , 'CD05' , 'cause_type_pop') ; 	/**	원인유형(팝업)		*/
		commonCode.getCodeList('AS' , 'CD06' , 'action_type_pop') ; /**	조치유형(팝업)		*/
		commonCode.getCodeList('AS' , 'CD09' , 'proc_gubun_pop');		/**	처리구분(팝업)		*/

		/* 접수일자 datepicker (저장값 없으면 최근 7일 ~ 오늘) */
		var searchStart = "${vo.search_start}";
		if (searchStart) {
			$("#search_start").val("${vo.search_start}").datepicker(datepicker);
		} else {
			$("#search_start").val($.datepicker.formatDate('yy/mm/dd', new Date(new Date().setDate(new Date().getDate() - 7)))).datepicker(datepicker);
		}
		if ('${vo.search_end}' != '') {
			$("#search_end").val('${vo.search_end}').datepicker(datepicker);
		} else {
			$("#search_end").val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		}

		/* 답변검색 팝업 datepicker */
		$( "#aw_search_start1" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#aw_search_end1" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#aw_search_start2" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#aw_search_end2" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);

		/* 일괄처리 팝업 datepicker */
		$("#proc_dt_pop" ).datepicker(datepicker);
		$("#complete_dt_pop").datepicker(datepicker);

		/* 처리상태 멀티셀렉트 복원용 hidden 값 (getAsList 에서 SumoSelect 값으로 재설정) */
		/* [AX Lab] 수정 시작 (2026-07-28 AX Lab): 최초 목록조회(makeListData)는 SumoSelect 초기화보다 먼저 실행되어
		   이 hidden 값만 사용한다. 따라서 화면 표시(asws_procApply)와 별개로 여기에도 기본값을 넣어야
		   "목록은 필터됐는데 처리상태 칸은 비어 보이는" 불일치가 생기지 않는다. */
		$('#procSelect').val(asws_procInitStr());

		/* 처리구분(나의/전체 A/S) - 저장값 없으면 '나의 A/S'(2) 기본 */
		/* [AX Lab] 수정 시작 (2026-07-28 AX Lab): '전체 A/S' 선택이 검색 후 유지되지 않던 문제 수정.
		   기존에는 '전체 A/S' 의 option value 가 빈 문자열('') 이라 "미지정(첫 진입)" 과 구분되지 않았다.
		   검색(getAsList)은 listFrm 을 /ad/as/list.do 로 재요청해 화면을 다시 그리는데, 이때 돌아온
		   ''(=전체 선택) 이 "저장값 없음" 으로 판정되어 매번 '2'(나의 A/S) 로 되돌아갔다.
		   → AS 처리담당자가 아닌 계정은 담당건이 0건이라 '전체 A/S' 를 골라도 목록이 계속 비어 보였다.
		   해결: '전체 A/S' 의 값을 '1' 로 부여해 ''(미지정) 과 구분한다. 아래 복원 로직은 그대로 두어도
		   '1' 이 그대로 복원되므로 정상 동작한다.
		   서버(AdAsController.getAsList / exl)는 "2".equals(asGubunFlag) 일 때만 담당자(ASSIGN_ID) 필터를
		   걸고 그 외 값은 전체 조회로 처리하므로 Java·쿼리 수정 없이 동작한다. */
		var asGubun = '${ vo.asGubunFlag }';
		$('#asGubunFlag').val(asGubun === '' ? '2' : asGubun);
		/* [AX Lab] 수정 끝 */

		/* 고급필터 체크박스 상태 복원 */
		/* [AX Lab] 삭제 (2026-07-28 AX Lab): '처리완료 외 상태' 체크박스를 제거하고 처리상태 기본 체크(접수+처리중)로
		   대체했으므로 복원 대상이 아니다. search_type13 은 hidden 으로 항상 'N' 을 전송한다.
		var search_type13 = '${ vo.search_type13 }';
		(search_type13 == 'Y') ? $('#search_type13').prop('checked',true) : $('#search_type13').prop('checked',false);
		*/

		var search_type17 = '${ vo.search_type17 }';
		(search_type17 == 'Y') ? $('#search_type17').prop('checked',true) : $('#search_type17').prop('checked',false);

		/* 통합 검색 키워드 / 페이징 */
		$('#search_text').val('${ vo.search_text }');
		$('#page').val('${ vo.page}') ;
		$('#pageSize').val('${ vo.pageSize}') ;

		/* 고급 동적 검색구분 행 복원 (combine-as.js) */
		if (typeof asws_advInit === 'function') asws_advInit();

		/* 저장된 고급조건이 있으면 고급필터 패널을 펼쳐둔다. */
		if (typeof ASWS_ADV_INIT !== 'undefined' && ASWS_ADV_INIT && ASWS_ADV_INIT.length > 0) {
			if (typeof asws_advToggle === 'function' && !$('#advToggle').hasClass('open')) asws_advToggle();
		}
	}
	/* [AX Lab] 수정 끝 */
	
	function search_type(gubun){
		
		if (gubun == "1"){
			$(".highLevelSearch").hide();
		}else{
			$(".highLevelSearch").show();
		}
		
		$("#search_gubun").val(gubun).prop("selected", true);
	}
	
	function custList(custPage){
		var datas = {
				'page' : custPage , 
				'search_text' : $('#searchKorName').val() 
		}
		
		common.ajaxCall(datas , '/ad/member/getCustList.do', 'makeCustList') ;
		
	}
	
	function makeCustList(data){
			
			$('#custInfoList').empty() ; 
			$('#layer_pagination').empty() ; 
			
			var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
			var vo = typeof data.vo != "undefined" ? data.vo : null ; 
			
			if(resultList != null && resultList.length > 0){
				var str = '' ; 
				for(var i = 0 ; i < resultList.length ; i++){
					var datas = resultList[i] ;
					str += '<tr onclick="javascript:setValue(\''+common.nvl(datas.seq, '')+'\');" style="cursor:pointer;"> ' ;
					str += '	<td>'+common.nvl(datas.rnum , '')+'</td> ' ;
					str += '	<td>'+common.nvl(datas.cust_kor_name , '')+'['+common.nvl(datas.crm_code , '')+']</td> ' ;
					str += '	<td>'+common.nvl(datas.ceo , '')+'</td> ' ;
					str += '	<td>'+common.nvl(datas.cust_no , '')+ '</td> ' ;
					str += '	<td>'+common.nvl(datas.cust_address , '')+'</td> ' ;
					str += '</tr> ' ;
				}
				$('#custInfoList').append(str) ; 
				$('#layer_pagination').html(vo.json_paging) ; 
			}else{
				commonTable.notData(5 , '조회된 정보가 없습니다.' , 'custInfoList') ; 
			}
		}
		
	function setValue(seq){
		var datas = {'seq' 				: seq }
		common.ajaxCall(datas , '/ad/member/getCustInfo.do', 'makeCustInfo') ;
		closeLayer(1) ;
		
	}
	
	function closeLayer(num) {
		$('#div'+num).hide() ; 
		$('#div'+num+'_dim').hide() ; 
		$('#searchKorName').val('') ; 
		$('#searchEmpName').val('') ; 
		$("#searchKorName").removeAttr( "autofocus" );
		$("#searchEmpName").removeAttr( "autofocus" );
	}
	
	function makeCustInfo(data){
		
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null ; 
		
		$('#cust_kor_name').val(common.nvl(resultVO.cust_kor_name, '')) ; 
		$('#cust_code').val(common.nvl(resultVO.erp_code, '')) ; 
	
	}
	
	
	function setRequest_type(data) {
		if($('#search_type16').val() == 'C011'){
			setService_cate("P010");
			$('#search_type7').prop('disabled', true).addClass('write_gray');
			$('#search_type7').val("P010");
		}else{
			setService_cate($('#search_type7').val());
			$('#search_type7').prop('disabled', false).removeClass('write_gray');
		}
	}
	
	function setService_cate(thisObj){
		$('#search_type8').empty() ; 
		if(thisObj != ""){
			commonCode.getCodeList('AS' , thisObj , 'search_type8') ;
		}else{
			$('#search_type8').append(commonCode.defaultOption);	
			
		}
	}

	function searchReset() {
		/* [AX Lab] 수정 시작 (2026-07-28 AX Lab): 처리상태 해제를 form.reset() "앞"으로 이동.
		   reset() 이 먼저 돌면 option.selected 가 이미 false 로 바뀌어, 뒤이은 unSelectAll() 이
		   "해제할 항목이 없다"고 판단해 아무 것도 하지 않는다(내부 toggSelAll 은 선택된 항목만 클릭 처리).
		   그러면 드롭다운 목록의 체크 표시(li.selected)만 이전 상태로 남아 실제 조회조건과 어긋난다. */
		try{ if(typeof procSelect !== 'undefined' && procSelect) procSelect.sumo.unSelectAll(); }catch(e){}
		/* [AX Lab] 수정 끝 */

 		document.listFrm.reset() ;
		$("#search_start").val($.datepicker.formatDate('yy/mm/dd', new Date(new Date().setDate(new Date().getDate() - 7)))).datepicker(datepicker);
		$( "#search_end" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		/* [AX Lab] 수정 시작 (2026-07-24 AX Lab): 고급 동적조건/처리상태/처리구분 초기화 */
		if (typeof asws_advClear === 'function') asws_advClear();
		/* [AX Lab] 수정 시작 (2026-07-28 AX Lab): 초기화 시 처리상태를 "빈 값(=전체 조회)"으로 두면
		   처리완료 건까지 다 나와 첫 진입 상태와 달라진다. 첫 진입과 동일하게 기본 체크(접수+처리중)로 복원한다. */
		asws_procApply(ASWS_PROC_DEFAULT);
		$('#procSelect').val(ASWS_PROC_DEFAULT);
		/* [AX Lab] 수정 끝 */
		$('#asGubunFlag').val('2');
		/* [AX Lab] 수정 끝 */
	}
	
	//(2024.05.09.김규민) 검색 기간 기입 가능하도록 설정(형식 검토 알림창 날짜 표시)
	function formatDate(date) {
	    var year = date.getFullYear();
	    var month = ('0' + (date.getMonth() + 1)).slice(-2);
	    var day = ('0' + date.getDate()).slice(-2);
	    return year + '/' + month + '/' + day;
	}
	
	

	function getAsList(pageIndex) {
		var val = procSelect.sumo.getSelStr();
		$("#procSelect").val(val);

		var f = document.listFrm;

		// 현재 체크 상태 저장 (검색 후에도 유지되게)
		var isDateChecked = $("#search_type10").is(":checked");
		sessionStorage.setItem("search_type10_checked", isDateChecked);

		if (isDateChecked) {
			var datePattern = /^\d{4}\/\d{2}\/\d{2}$/;
			var startDate = f.search_start.value;
			var endDate = f.search_end.value;

			if (startDate === "" || !datePattern.test(startDate)) {
				alert('시작일을 형식에 맞게 기입해주세요.\n예시 : ' + formatDate(new Date()));
				$('#search_start').val("");
				$('#search_start').focus();
				return;
			}

			if (endDate === "" || !datePattern.test(endDate)) {
				alert('종료일을 형식에 맞게 기입해주세요.\n예시 : ' + formatDate(new Date()));
				$('#search_end').val("");
				$('#search_end').focus();
				return;
			}
		}
		
		/* [AX Lab] 삭제 (2026-07-24 AX Lab): 제거된 검색필드(search_type7/cust_*) 재활성 코드 - 고급필터 동적행으로 대체 */

		f.page.value = pageIndex;
		f.target = '';
		f.action = '/ad/as/list.do';
		f.submit();
	}
	
	function makeListData() {
		common.ajaxCall($('form[name=listFrm]').serialize(), '/ad/as/getAsList.do', 'setAsList') ;
	}
		
	/* [AX Lab] 수정 시작 (2026-07-23 AX Lab): 20컬럼 -> 4컬럼 축약 + 행클릭 상세연동(asws_openDetail).
	   나머지 축약된 컬럼값은 rowMap 에 저장해 오른쪽 상세 패널(COL3)에서 사용한다. */
	function setAsList(data) {
		$('#asList').empty();
		asws.rowMap = {};

		/* [AX Lab] 수정 시작 (2026-07-28 AX Lab): 상단 KPI를 목록 응답(getAsList.do)에 동봉해 갱신 (신규 URL 403 회피) */
		if (data && data.kpi) asws_makeKpi(data);
		/* [AX Lab] 수정 끝 */

		var resultList = typeof data.resultList != 'undefined' ? data.resultList : null;
		var vo = typeof data.vo != 'undefined' ? data.vo : null;

		if (resultList != null && resultList.length > 0) {

			var str = '' ;
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ;
				var asNo = common.nvl(datas.as_no, '');
				var cnAsNo = common.nvl(datas.cn_as_no, '');
				var asNoLink = common.nvl(datas.as_no_link, '');

				/* 축약 컬럼값 보관 (상세 패널에서 사용) */
				asws.rowMap[asNo] = datas;

				// 접수일
				var vAcceptDt = "-";
				if (common.nvl(datas.accept_dt, '').length == 8) vAcceptDt = makeDate(datas.accept_dt,"-");

				// 상태 뱃지 클래스
				var stCode = common.nvl(datas.proc_status, '');
				var stCls = asws_stClass(stCode);

				// 우선처 / 중요도 뱃지
				var prioIco = (common.nvl(datas.priority, '') == 'Y') ? '<span style="color:var(--red);font-weight:700;">★</span> ' : '';
				var gradeNm = common.nvl(datas.inportance_nm, '');
				var gradeCls = (common.nvl(datas.inportance, '') == 'C001') ? 'grade emc' : 'grade';
				var gradeTag = gradeNm ? ' <span class="'+gradeCls+'">'+gradeNm+'</span>' : '';

				// 문의/조치 내용 요약
				/* [AX Lab] 수정 시작 (2026-07-28 AX Lab): 제목(q-title)과 본문(q-body)에 같은 call_content 를
				   중복 출력해 행 높이를 불필요하게 2배로 쓰던 문제 수정.
				   → 제목 = 첫 번째 유효 줄, 본문 = 그 이후 내용(없으면 본문 div 자체를 생략). */
				var callC = common.nvl(datas.call_content, '');
				var actC  = common.nvl(datas.action_content, '');

				var callLines = callC.replace(/\r/g, '').split('\n');
				var callHead = '';
				var restIdx = callLines.length;
				for (var li = 0; li < callLines.length; li++) {
					if (callLines[li].replace(/\s/g, '') !== '') {
						callHead = $.trim(callLines[li]);
						restIdx = li + 1;
						break;
					}
				}
				var callRest = $.trim(callLines.slice(restIdx).join(' ').replace(/\s+/g, ' '));
				if (callHead === '') callHead = '(내용 없음)';
				/* 제목이 길 경우의 잘림은 CSS(.q-title .q-t : 1줄 ellipsis)가 처리하므로 여기서 자르지 않는다. */
				var actInfo = actC ? ('조치: ' + actC.substr(0, 40)) : '';
				/* [AX Lab] 수정 끝 */

				str += '<tr data-asno="'+asNo+'" onclick="asws_openDetail(\''+asNo+'\',\''+cnAsNo+'\');">';
				str += '  <td class="col-chk" onclick="event.cancelBubble=true;">' +
				       '<input type="checkbox" title="거래선택" name="chk" ' +
				       'value="'+asNo+'@'+cnAsNo+'" ' +
				       'data-as-no-link="'+asNoLink+'" ' +
				       'data-proc-status="'+stCode+'"/></td>';
				str += '  <td class="col-date">'+vAcceptDt+'</td>';
				/* [AX Lab] 수정 시작 (2026-07-28 AX Lab): 거래처명이 길면 3~4줄로 늘어나 행 높이를 키우던 문제 → 2줄 클램프
				   (td 에는 -webkit-box 를 쓸 수 없어 내부 div(cl-t)로 감싼다. 전체 값은 title 툴팁으로 확인 가능) */
				var custTxt = '['+common.nvl(datas.cust_code, '')+']'+common.nvl(datas.cust_kor_name,'');
				str += '  <td class="col-client"><div class="cl-t" title="'+asws_esc(custTxt)+'">'+asws_esc(custTxt)+'</div></td>';
				/* [AX Lab] 수정 끝 */
				str += '  <td>';
				/* [AX Lab] 수정 시작 (2026-07-28 AX Lab): 제목을 q-t 로 감싸 1줄 ellipsis 처리 (좁은 컬럼에서 2~3줄로 늘어나는 것 방지) */
				str += '    <div class="q-title">'+prioIco+'<span class="q-t">'+asws_esc(callHead)+'</span>'+gradeTag+'</div>';
				/* [AX Lab] 수정 끝 */
				/* [AX Lab] 수정 시작 (2026-07-28 AX Lab): 추가 내용이 있을 때만 본문 줄을 출력 (빈 줄로 행 높이 낭비 방지) */
				if (callRest !== '') str += '    <div class="q-body">'+asws_esc(callRest)+'</div>';
				/* [AX Lab] 수정 끝 */
				str += '    <div class="q-act">담당 '+common.nvl(datas.emp_nm,'-')+' · 답변 '+common.nvl(datas.total_aws_cnt,'0')+'건'+(actInfo? ' · '+asws_esc(actInfo):'')+'</div>';
				str += '  </td>';
				str += '  <td class="col-status"><span class="st '+stCls+'">'+common.nvl(datas.proc_status_nm, '')+'</span></td>';
				str += '</tr>';
			}

			$('#asList').append(str);
			$('#count').html(numberWithCommas(vo.rowCnt));
			$("#pagination").html(vo.json_paging);

			/* 첫 행 자동 선택(상세 열기) */
			var first = resultList[0];
			asws_openDetail(common.nvl(first.as_no,''), common.nvl(first.cn_as_no,''));

		} else {
			$('#asList').html('<tr><td colspan="5" style="text-align:center;padding:30px;color:#8A979E;">조회된 데이터가 없습니다.</td></tr>');
			$('#count').html('0');
			$("#pagination").html('');
			$('#asDetail').html('<div class="empty">조회된 접수건이 없습니다.</div>');
			$('#asRecord').html('<div class="none" style="padding:14px">조회된 접수건이 없습니다.</div>');
		}
	}
	/* [AX Lab] 수정 끝 */
	
	function btnAnswer(){
		$('#answer_layer').show();
		$('#dim_answer').show();
		
		//init
		$("#aw_search_type1").prop('checked', true) ;
		goAnswerList();
		
	}
	
	function btnAws(as_no) {
		
		var f = document.listFrm ;
		$('#wrap_aws').show();
		$('#dim_aws').show();
		awsList(1, as_no);
	}
	
	function awsList(awsPage, as_no){
		v_as_no = as_no ; 
		var datas = {
				'page' : awsPage ,
				'as_no' : as_no
		}
		common.ajaxCall(datas , '/ad/as/getAwsList.do', 'makeAwsList') ;
	}
	
	function makeAwsList(data){
		
		$('#awsInfoList').empty() ; 
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		if(resultList != null && resultList.length > 0){
			var str = '' ; 
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ;
				
				var u_class = '';
				var new_icon = '';
				if (common.nvl(datas.w_gubun, '') == 'U') {
					u_class = "gray";
				}
				
				if (common.nvl(datas.w_gubun, '') == 'U' && (i+1) == resultList.length) {
					new_icon = '<span class="new"></span>';	
				}
				
				str += '<tr id="awsTr'+(i+1)+'" class="'+u_class+'">';
				str += '		<td>'+common.nvl(datas.emp_nm)+'</td>';
				str += '		<td>'+new_icon+' '+common.nvl(datas.w_date)+'</td>';
				str += '		<td class="textL">'+common.nvl(datas.w_content)+'</td>';
				str += '</tr>';
			}
			$('#awsInfoList').append(str) ; 
			
		     var offset = $("#awsTr" + resultList.length).offset();
		     $('#awsWrap').animate({scrollTop : offset.top}, 1000);

		}
	}	
	
	function btnAwsProc() {
		
		if(common.isEmpty($('#w_content').val())){
			alert('답변 내용을 입력해 주세요.') ; return ; 
		}

		var f = document.answerForm;
		
		f.w_content.value = $('#w_content').val();
		f.as_no.value = v_as_no;
		f.pageType.value = 'insert';
			
		try{
			$("#exlFrame").remove() ;
		}catch(e){}
		
		var downFrame = $('<iframe id="awsFrame" name="awsFrame" style="width:0px; height=0px ; display:none;"></iframe>') ; 
		downFrame.appendTo("body") ;
		
		
		f.method="post";
		f.target = "awsFrame";
		f.action="/ad/as/awsProc.do";
		f.submit();
	}
	
	/* [AX Lab] 수정 시작 (2026-07-23 AX Lab): 답변 등록 콜백을 팝업(#awsInfoList)과 인라인 상세(#asThread) 양쪽에서 공유 */
	function awsProcReturn(resultCode){
		if(resultCode == "000"){
			alert('정상처리 되었습니다.') ;
			$('#w_content').val('') ;
			$('#asReplyText').val('') ;
			/* 기존 신규답변 팝업이 열려있으면 팝업 목록 갱신 */
			if(typeof v_as_no != 'undefined' && v_as_no) awsList(1 , v_as_no) ;
			/* 인라인 상세가 열려있으면 스레드 갱신 */
			if(typeof asws != 'undefined' && asws.asNo){
				common.ajaxCall({ as_no:asws.asNo, page:'1' }, '/ad/as/getAwsList.do', 'asws_renderThread') ;
			}
		}else{
			alert('처리도중 오류가 발생했습니다.') ; return ;
		}
	}

	/* [AX Lab] 목록 전체선택 체크박스 */
	function asws_toggleAll(el){
		$('#asList input[name=chk]').prop('checked', el.checked);
	}
	/* [AX Lab] 수정 끝 */
	
	function procReturn(data){
		// makeAwsList
		var resultCode = typeof data.resultCode != "undefined" ? data.resultCode : null ; 
		
		if(resultCode == "000"){
			alert('정상처리 되었습니다.') ; $('#w_content').val('');  awsList(1 , v_as_no) ; 
		}else{
			alert('처리도중 오류가 발생했습니다.') ; return ; 
		}
	}
	
	function btnAnswerClose(){
		$('#answer_layer').hide();
		$('#dim_answer').hide();
		
	}
	
	function btnAwsClose() {
		$('#wrap_aws').hide();
		$('#dim_aws').hide();
	}
	
	
	function goForm(pageType , as_no){
		var f = document.listFrm ; 

		var cnt = 0 ; 
		var chkVal = "" ;
		
		$("input[name=chk]:checked").each(function() {
			cnt++ ;  
			chkVal = $(this).val() ; 
		});
		
		if(pageType == 'subInsert'){
			
			if(cnt == 0){
				alert('상위 작업을 선택해 주세요.');
				return;
			}
			
			if(cnt > 1){
				alert('하위작업은 하나의 접수건만 선택할 수 있습니다.');
				return;
			}
			
			if (chkVal.split('@')[1] != '') {
				alert('해당 건에서는 하위작업을 생성할 수 없습니다.');
				return;				
			}
			
			var asNoList = [];
			var linkedAsNos = [];
	
		    $("input[name=chk]:checked").each(function() {
			  var chkVal = $(this).val() || "";
			  var as_no = chkVal.indexOf("@") > -1 ? chkVal.split("@")[0] : chkVal;
	
			  var asNoLink = $(this).data("as-no-link");
	
			  // 이미 엮여 있는 AS면 목록에 추가
			  if (asNoLink && asNoLink !== "") {
			    if (as_no) linkedAsNos.push(as_no);
			    return; // ❗ continue (중단 X)
			  }
	
			  if (as_no) asNoList.push(as_no);
			});
	
			if (linkedAsNos.length > 0) {
			  alert(
			    "이미 다른 접수건과 연결되어있어 하위작업 등록이 불가능합니다."
			  );
			  return;
			}
		}
		
		var as_no = chkVal.split('@')[0];
		var cn_as_no = chkVal.split('@')[1] ;
				
		
		f.pageType.value = pageType ; 
		f.as_no.value = as_no ; 
		
		f.target = '' ; 
		f.action = '/ad/as/form.do' ; 
		f.submit() ; 
	}
	
	function goExl() {
		
		var totalCnt = Number($('#count').html().replace(/,/g, ""));
	
		if(totalCnt == 0){
			alert("출력 가능한 데이터가 없습니다.") ;
			return ;
			
		}else if (totalCnt > 60000){
			alert("60,000건 이상의 데이터를 다운로드 할수 없습니다.\r\n기간 검색을 이용하여 조회건수를 조절하신 후 사용하세요") ; 
			return ;
		}else{
			if (confirm(totalCnt + "건의 데이터를 다운로드 받으시겠습니까?")) {
				var f = document.listFrm ; 
				
				try{
					$("#exlFrame").remove() ;
				}catch(e){}
				
				var downFrame = $('<iframe id="exlFrame" name="exlFrame" style="width:0px; height=0px ; display:none;"></iframe>') ; 
				downFrame.appendTo("body") ;
				
				f.target = "exlFrame" ; 
				f.action = "/ad/as/exl.do" ; 
				f.submit() ; 
			}
		}
	}
	
	function goView(pageType , as_no, cn_as_no){
		var f = document.listFrm ; 
		
		f.pageType.value = pageType ; 
		f.as_no.value = as_no ; 
		f.cn_as_no.value = cn_as_no ; 
		
		f.target = '' ; 
		f.action = '/ad/as/form.do' ; 
		f.submit() ; 
	}
	
	function delAsProc() {
	    executeDelete("NORMAL");
	}
	
	function delAsProcAll() {
	    executeDelete("ALL_LINKED");
	}
	
	function executeDelete(delType) {

	    var del_as_no = "";

	    $("input[name=chk]:checked").each(function () {
	        var asNo = $(this).val().split("@")[0];
	        del_as_no = del_as_no === "" ? asNo : del_as_no + "@" + asNo;
	    });

	    if (!del_as_no) {
	        alert("삭제할 A/S를 선택하세요.");
	        return;
	    }

	    var msg = delType === "ALL_LINKED"
	        ? "선택된 A/S와 연결된 모든 AS번호 및 하위 작업이 삭제됩니다.\n정말 삭제하시겠습니까?"
	        : "하위 작업이 모두 삭제됩니다.\n선택된 A/S를 삭제하시겠습니까?\n(연결된 AS번호는 삭제되지 않고 해당 AS번호만 해제됩니다.)";

	    if (!confirm(msg)) return;

	    var datas = {
	        del_as_no: del_as_no,
	        del_type: delType
	    };

	    common.ajaxCall(datas, "/ad/as/delProc.do", "delProcReturn");
	}
	
	function delProcReturn(data) {
		var resultCode = typeof data.resultCode != "undefined" ? data.resultCode : null ; 
		
		if(resultCode == "000"){
			alert('정상처리 되었습니다.') ; 
			getAsList(1);
		}else{
			alert('처리도중 오류가 발생했습니다.') ; return ; 
		}
	}
	
	/*답변검색팝업 */
	function goAnswerList(){
		
		var aw_search_start1 ='';
		var aw_search_end1 ='';
		var aw_search_start2 ='';
		var aw_search_end2 ='';
		
		if( $("#aw_search_type1").is(":checked") == true ){ 
			aw_search_start1 = $('#aw_search_start1').val();
			aw_search_end1 = $('#aw_search_end1').val();
			$('#aw_search_type1').val('Y');
		}else{
			$('#aw_search_type1').val('');
		}
		
		if( $("#aw_search_type2").is(":checked") == true ){ 
			aw_search_start2 = $('#aw_search_start2').val();
			aw_search_end2 = $('#aw_search_end2').val();
			$('#aw_search_type2').val('Y');
		}
		
		var aw_gubun = $(':radio[name="aw_gubun"]:checked').val();
		var aw_gubun2 ='';
		var aw_gubun3 ='';
		
		if(aw_gubun == 'U'){
			aw_gubun2 = 'Y';
			
		}else if(aw_gubun == 'A'){
			aw_gubun3 = 'Y';
		}
		
		var datas = {
			'aw_search_start1' : aw_search_start1,
			'aw_search_start2' : aw_search_start2,
			'aw_search_end1' : aw_search_end1,
			'aw_search_end2' : aw_search_end2,
			'aw_gubun3' : aw_gubun3,
			'aw_gubun2' : aw_gubun2,
			'aw_gubun' : aw_gubun,
			'aw_search_text3' : $('#aw_search_text3').val(), //거래처명
			'aw_search_text4' : $('#aw_search_text4').val(), //작성자이름
			'aw_search_text5' : $('#aw_search_text5').val(), //답변내용
			'aw_search_type1' : $('#aw_search_type1').val(),
			'aw_search_type2' : $('#aw_search_type2').val()
		}
		
		console.log(datas);
		common.ajaxCall(datas , '/ad/as/getAsAnswerList.do', 'setAnswerList') ; 
		
	}
	
	/* set답변리스트  */
	function setAnswerList(data){
		
		$('#wrap_answer').empty() ; 
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		var str = '';
		
		if( resultList.length == 0  || resultList == "undefined" ){
			str = '<p style="font-size: 36px; font-weight: 700; text-align:center; line-height: 1.2em; letter-spacing: -0.05em; margin: 50px 0 20px;">해당 정보가 없습니다<br>다시 검색해 주세요</p>';
			$('#wrap_answer').html(str);
        }
		for(var i = 0; i < resultList.length ; i ++){
			var val = resultList[i];
			str += '<div id="answer-box">';
			str += '<div class="answer-greybox mgb20" onclick="javascript:goAsDetail(\''+ val.as_no +'\')" style="cursor:pointer;">';
			str += '<div class="pos2" style="width:40px;height:40px; position:absolute; top:-15px; left:-15px;"></div>';
			str += '<table class="db-answer">';
			str += '<tbody>';
			str += '<tr>';
			str += '<td colspan="2" style="font-size: 13px;color:#797979;font-weight: 600;">'+val.w_an_date+'</td>';
			str += '<td colspan="2" class="textR mgb5" style="font-size: 13px;color: #0090c8;font-weight: 700;">AS접수번호' + val.as_no + ' | ' + val.cust_kor_name + '</td>';
			str += '</tr>';
			str += '<tr>';
			str += '<td colspan="4" style="padding-bottom:5px;padding-top: 5px; border-bottom: 1px solid #dedede !important;">[요청] '+ val.call_content +' -' +val.apply_nm +'</td>';
			str += '</tr>';
			str += '<tr>';
			str += '<td colspan="4" style="padding-bottom:5px;padding-top: 5px;">[답변] ' + val.w_content  + ' -' + val.w_nm + '</td>';
			str += '</tr>';
			str += '</tbody>';
			str += '</table>';
			str += '</div>';
			str += '</div> ';
	   	 }

		$('#wrap_answer').html(str);
		
	}
	

	function goAsDetail(asno){
		var queryString = "?pageType=update&as_no=" + asno;
		console.log(queryString);
		location.href = "/ad/as/form.do" + queryString;
	}

	
	
	// CMC 수정 - 복사 버튼 추가 
	function goInsertCopy(){
		var cntCheck = 0 ; 
		var chkVal = "" ;
		var as_no = '';
		
		var f = document.listFrm ; 
		$("input[name=chk]:checked").each(function() {
			cntCheck++ ; 
			chkVal = $(this).val() ;
			as_no = chkVal.split('@')[0];
			
		});
		
		if(cntCheck == 0){
			alert('복사할 A/S를 선택하여 주십시오.');
			return;
		}else if(cntCheck > 1){
			alert('A/S를 하나만 선택하여 주십시오.');
			return;	
		}
		
		f.pageType.value = 'insertcopy' ; 
		f.as_no.value = as_no ; 
		f.cn_as_no.value = "" ; 
		f.action = '/ad/as/form.do' ; 
		f.submit() ; 
	}
	
	
	
	/* [AX Lab] 삭제 (2026-07-28 AX Lab): '처리완료 외 상태' 체크박스를 제거하고 처리상태 기본 체크(접수+처리중)로
	   대체했으므로 아래 두 함수는 호출처가 없다.
	   - change_exceptComplete : 체크 시 처리상태 멀티셀렉트를 강제로 비우던 충돌 처리(혼란의 원인). 호출처는 그 체크박스 onchange 뿐.
	   - change_sate           : 이전부터 호출처가 없던 사용하지 않는 코드(원본 검색테이블 비활성화 시점에 이미 고아 상태).
	function change_exceptComplete(){
		var is_checked = $("input:checkbox[id='search_type13']").is(":checked");
		if(is_checked == true){
			try{ if(typeof procSelect !== 'undefined' && procSelect) procSelect.sumo.unSelectAll(); }catch(e){}
			$('#procSelect').val('');
		}
	}


	function change_sate(){
		var is_checked = $("input:checkbox[id='search_type13']").is(":checked");
		if(is_checked == true){
			$("input:checkbox[id='search_type13']").prop('checked', false);
		}

	}
	*/
	
	function setProcGrade(v_proc_grade) {
		$('.dev_proc, .dev_proc_shape').children('span').remove();
		// 처리상태가 처리완료 이면서 조치유형이 개발, 프로그램 수정 인 경우
		if ((v_proc_grade == "C001" || v_proc_grade == "C002")) {
			$('.dev_proc').append('<span class="request mgl5">필수 입력</span>');
			$('#completion_details').show();
		}else{
			$('#completion_details').hide();
			
			$('#proc_gubun_pop').val("");          // select 전체선택
			$('#proc_gubun_pop').trigger('change');
		}
	}
	
	function setProcGubun(v_proc_gubun) {
		$('.dev_proc_shape').children('span').remove();
		// 처리상태가 처리 완료 이면서 조치유형이 개발, 프로그램 수정 이면서 처리구분이 형상변경 인 경우
		if (($("#action_type_pop").val() == "C001" || $("#action_type_pop").val() == "C002")){
			
			$('#completion_details').show(); 
			
			if(v_proc_gubun == "C001") {
			$('.dev_proc_shape').append('<span style="color:blue;">&nbsp;&nbsp;&#42;</span>');
			}
			
		}else{
			$('#completion_details').hide();
		}
	}
	
	/**	거래처 조회	*/
	function showCustLayer(){
		$('#div1').show() ; 
		$('#div1').css('height' , '710') ;
		$('#div1_dim').show() ; 
		custList(1) ;
		$("#searchKorName").attr( "autofocus","autofocus");
		
		$('[autofocus]:not(:focus)').eq(0).focus();
		
	}

	/** 거래처 정보 초기화 */
	function resetCustInfo() {
		$('[name="cust_kor_name"]').val('');
		$('[name="cust_code"]').val('');
	}
	
	function openProcLayer() {
		  var blockedAsNos = [];

		  var asNoSet = new Set();

		  function addLinkedAsNos(asNoLink) {
		    if (!asNoLink) return;

		    String(asNoLink)
		      .split(",")
		      .map(function (v) { return v.trim(); })
		      .filter(function (v) { return v !== ""; })
		      .forEach(function (v) { asNoSet.add(v); });
		  }

		  $("input[name=chk]:checked").each(function () {
		    var chkVal = $(this).val() || "";
		    var as_no = chkVal.indexOf("@") > -1 ? chkVal.split("@")[0] : chkVal;

		    var asNoLink = $(this).data("as-no-link");   // 연결된 AS 정보
		    var procStatus = $(this).data("proc-status");// 처리상태

		    // 처리상태가 철회인 것은 차단
		    if (procStatus === "C006") {
		      if (as_no) blockedAsNos.push(as_no);
		      return;
		    }

		    if (as_no) asNoSet.add(as_no);

		    addLinkedAsNos(asNoLink);
		  });

		  if (blockedAsNos.length > 0) {
		    // 중복 제거해서 보기 좋게
		    blockedAsNos = Array.from(new Set(blockedAsNos));

		    alert(
		      "철회 상태인 A/S가 포함되어 있어 일괄처리가 불가능합니다.\n\n" +
		      "해당 접수번호:\n- " + blockedAsNos.join("\n- ")
		    );
		    return;
		  }

		  // ✅ 최종 대상 목록
		  var asNoList = Array.from(asNoSet).filter(function (v) { return v !== ""; });

		  if (asNoList.length === 0) {
		    alert("처리할 A/S를 선택하여 주십시오.");
		    return;
		  }

		  var joined = asNoList.join(",");

		  $("#checkedAsNo").val(joined);
		  $("#as_no_link_grp_str").val(joined);
		  $("#as_no_link_grp").val(joined);

		  $("#procLayer").show();
		  $("#div_dim_proc").show();

		  if ($("#proc_time1_pop option").length === 0) {
		    initProcTimeSelect();
		  }

		  updateActionContentCount();
		}

	

		function closeProcLayer(){
		  $("#procLayer").hide();
		  $("#div_dim_proc").hide();
		}

		function clearProcBatch(){
		  $("#proc_dt_pop").val("");
		  $("#proc_time1_pop").val("");
		  $("#proc_time2_pop").val("");
		  $("#cause_type_pop").val("");
		  $("#action_type_pop").val("");
		  $("#work_time_pop").val("");
		  $("#complete_dt_pop").val("");
		  $("#action_content_pop").val("");
		  updateActionContentCount();
		}

		function confirmProcBatch() {
			  var f = document.listFrm;

			  f.method = "post";
			  
			  var actionEmpty = (String($('#action_content_pop').val() || '').replace(/\s/g,'') === '');
			  var wEmpty = (String($('#w_content_pop').val() || '').replace(/\s/g,'') === '');
			  
			  if(common.isEmpty($('#proc_dt_pop').val())){
					alert('처리 예정 일자를 입력하세요.');
					$('#proc_dt_pop').focus(); 
					return;
				}
			  
			  if(common.isEmpty($('#cause_type_pop').val())){
					alert('원인유형을 선택하세요.');
					$('#cause_type_pop').focus(); 
					return;
				}
				
			  if(common.isEmpty($('#action_type_pop').val())){
					alert('조치유형을 선택하세요.');
					$('#action_type_pop').focus(); 
					return;
				}
			  
			  if(common.isEmpty($('#work_time_pop').val())){
					alert('작업시간을 입력하세요.');
					$('#work_time_pop').focus(); 
					return;
				}
				
			  if(common.isEmpty($('#complete_dt_pop').val())){
					alert('처리 완료 일자를 입력하세요.');
					$('#complete_dt_pop').focus(); 
					return;
				}
				
			  if(actionEmpty){
					alert('조치이력을 남겨주세요. 처리이력을 파악하는 데 꼭 필요합니다.');
					$('#action_content_pop').focus(); 
					return;
				}
			  
			  if (($('#action_type_pop').val() == 'C001' || $('#action_type_pop').val() == 'C002')) {
					
					if (common.isEmpty($('#proc_gubun_pop').val())) {
						alert('처리구분을 선택하세요.');
						$('#proc_gubun_pop').focus();
						return;
					}
					
					if (common.isEmpty($('#proc_build_info_pop').val())) {
						alert('빌드순번을 입력하세요.');
						$('#proc_build_info_pop').focus();
						return;
					}
					
					if (common.isEmpty($('#proc_test_info_pop').val())) {
						alert('개발처리서(테스트케이스)를 입력하세요.');
						$('#proc_test_info_pop').focus();
						return;
					}
					
					if ($('#proc_gubun_pop').val() == 'C001'){
						if ($('#proc_process_sp_pop').val().trim() == ''
							&& $('#proc_screen_sp_pop').val().trim() == ''
							&& $('#proc_table_sp_pop').val().trim() == ''
							&& $('#proc_function_sp_pop').val().trim() == ''
							&& $('#proc_interface_sp_pop').val().trim() == ''
							){
							alert('처리구분이 "형상변경"인 경우 아래 목록 중\n한가지 이상의 정의서가 필수입니다.\n-프로세스정의서\n-화면정의서\n-테이블정의서\n-기능분해도\n-인터페이스정의서');
							$('#proc_gubun_pop').focus();
							return;
						}
					}
					
				}
			  
			  if(wEmpty){
					alert('답변을 작성해주세요.');
					$('#w_content_pop').focus(); 
					return;
				}

			  $('#proc_time').val($('#proc_time1_pop').val() + "" + $('#proc_time2_pop').val());

			  var asNoLink = $("#as_no_link_grp").val();

			  f.as_no_link.value = asNoLink;
			  
			  if ($('#tel_confirm_pop').is(":checked"))
				  f.tel_confirm.value = "Y";
			  
			  f.proc_dt.value = $("#proc_dt_pop").val();
			  f.proc_time.value = $("#proc_time").val();
			  f.cause_type.value = $("#cause_type_pop").val();
			  f.action_type.value = $("#action_type_pop").val();
			  f.work_time.value = $("#work_time_pop").val();
			  f.complete_dt.value = $("#complete_dt_pop").val();
			  f.action_content.value = $("#action_content_pop").val();
			  
			  f.proc_gubun.value = $("#proc_gubun_pop").val();
			  f.proc_build_info.value = $("#proc_build_info_pop").val();
			  f.proc_test_info.value = $("#proc_test_info_pop").val();
			  f.proc_process_sp.value = $("#proc_process_sp_pop").val();
			  f.proc_screen_sp.value = $("#proc_screen_sp_pop").val();
			  f.proc_table_sp.value = $("#proc_table_sp_pop").val();
			  f.proc_function_sp.value = $("#proc_function_sp_pop").val();
			  f.proc_interface_sp.value = $("#proc_interface_sp_pop").val();
			  
			  f.w_content_pop.value = $("#w_content_pop").val();

			  f.target = "hiddenFrame";
			  f.action = "/ad/as/updateProcDetailByChecked.do";
			  f.submit();
		}
		
		function procReturn(type, successNos, failNos, pageType) {

			  function formatResult(label, nos) {
			    if (!nos || nos.trim() === "") {
			      return label + " : 미존재";
			    }

			    var arr = nos.split(",");
			    var result = label + " : " + arr.length + "건\n";

			    for (var i = 0; i < arr.length; i++) {
			      result += "-" + arr[i].trim() + "\n";
			    }

			    return result.trim();
			  }

			  var successText = formatResult("성공", successNos);
			  var failText = formatResult("실패", failNos);

			  alert(successText + "\n\n" + failText);

			  goList();
		}
		
		function goList(){
			location.href = '/ad/as/list.do${ QUERYSTRING }' ; 
		}

		function initProcTimeSelect(){
		  var h = "";
		  for (var i=0; i<24; i++){
		    var v = (i<10 ? "0"+i : ""+i);
		    h += "<option value='"+v+"'>"+v+"</option>";
		  }
		  $("#proc_time1_pop").html(h);

		  var m = "";
		  for (var j=0; j<60; j++){
		    var v2 = (j<10 ? "0"+j : ""+j);
		    m += "<option value='"+v2+"'>"+v2+"</option>";
		  }
		  $("#proc_time2_pop").html(m);
		}
		
		function renderSelectedAsList() {
			  var arr = [];

			  document.querySelectorAll("input[name='chk']:checked").forEach(function(chk){
			    var tr = chk.closest("tr");
			    if (!tr) return;

			    var asNo = tr.children[1].textContent.trim(); // 두 번째 td
			    if (asNo) arr.push(asNo);
			  });

			  document.getElementById("selected_as_list").textContent = arr.join(", ");
			}
		
		

		function updateActionContentCount(){
			  var $ta = $("#action_content_pop");
			  if ($ta.length === 0) return;

			  var v = $ta.val();
			  if (v == null) v = "";

			  $("#action_content_text_pop").text(v.length + " / 1300자");
			}

		$(document).on("input", "#action_content_pop", function(){
		  updateActionContentCount();
		});
		
		document.addEventListener("change", function(e){
			  if (e.target && e.target.name === "as_chk") {
			    renderSelectedAsList();
			  }
			});
		
	
</script>


<div class="tit_wrap">
	<%= CommonExecute.returnLineMap(request) %>
	
</div>

<form name="listFrm" id="listFrm" method="get">
<input type="hidden" name="pageType" id="pageType" value=""/>
<input type="hidden" name="as_no" id="as_no" value=""/>
<input type="hidden" name="as_no_link" id="as_no_link" value="">
<input type="hidden" name="as_no_link_grp" id="as_no_link_grp" value=""/>
<input type="hidden" name="cn_as_no" id="cn_as_no" value=""/>
<input type="hidden" name="page" id="page" value="${ vo.page }" />
<input type="hidden" name="procSelect" id="procSelect" value="" />
<input type="hidden" name="checkedAsNo" id="checkedAsNo" value="">
<input type="hidden" name="tel_confirm" id="tel_confirm"/>
<input type="hidden" name="proc_dt" id="proc_dt"/>
<input type="hidden" name="proc_time" id="proc_time" />
<input type="hidden" name="proc_time1" id="proc_time1" />
<input type="hidden" name="proc_time2" id="proc_time2"/>
<input type="hidden" name="cause_type" id="cause_type"/>
<input type="hidden" name="action_type" id="action_type"/>
<input type="hidden" name="work_time" id="work_time"/>
<input type="hidden" name="complete_dt" id="complete_dt"/>
<input type="hidden" name="action_content" id="action_content"/>
<input type="hidden" name="proc_gubun" id="proc_gubun"/>
<input type="hidden" name="proc_build_info" id="proc_build_info"/>
<input type="hidden" name="proc_test_info" id="proc_test_info"/>
<input type="hidden" name="proc_process_sp" id="proc_process_sp"/>
<input type="hidden" name="proc_screen_sp" id="proc_screen_sp"/>
<input type="hidden" name="proc_table_sp" id="proc_table_sp"/>
<input type="hidden" name="proc_function_sp" id="proc_function_sp"/>
<input type="hidden" name="proc_interface_sp" id="proc_interface_sp"/>
<input type="hidden" name="w_content" id="w_content"/>

<%-- [AX Lab] 수정 시작 (2026-07-23 AX Lab): AS 통합 워크스페이스(3분할) 화면 리뉴얼 --%>
<link rel="stylesheet" type="text/css" href="/css/combine-as.css" />
<script type="text/javascript" src="/js/combine-as.js"></script>
<%-- [AX Lab] 고급 동적필터 화면복원용 초기값(JSON) --%>
<script type="text/javascript">var ASWS_ADV_INIT = ${empty vo.advFiltersJson ? '[]' : vo.advFiltersJson};</script>

<div id="asWorkspace">

  <%-- [AX Lab] 수정 시작 (2026-07-28 AX Lab): 상단 KPI를 "나에게 배정된 건" 기준 6종으로 변경 (KPI는 getAsList.do 응답에 동봉되어 setAsList 에서 갱신) --%>
  <!-- 상단 KPI (getAsList.do 응답 data.kpi, 나에게 배정된 건 기준 현황) -->
  <%-- [AX Lab] 수정 시작 (2026-07-28 AX Lab): KPI 카드가 상단 영역을 과도하게 차지해 목록이 아래로 밀리는 문제 개선.
       KPI를 접기/펼치기 가능한 구조로 바꾸고, 접힌 상태에서도 핵심 수치(미처리/긴급/처리예정 오늘/지연)는
       요약 배지로 계속 노출해 중요 정보 손실 없이 화면 공간을 확보한다. (asws_toggleKpi, combine-as.js) --%>
  <%-- [AX Lab] 수정 시작 (2026-07-28 AX Lab): class 에 collapsed 를 직접 넣어 "닫힌 상태"로 그려지게 한다.
       JS(asws_initKpiCollapse) 로만 접으면 스크립트 실행 전까지 카드가 펼쳐진 채 렌더링돼
       화면이 한 번 출렁이므로(깜빡임), 처음부터 접힌 마크업으로 내려보낸다. --%>
  <div class="kpi-wrap collapsed" id="asKpiWrap">
  <%-- [AX Lab] 수정 끝 --%>
    <div class="kpi-head" onclick="asws_toggleKpi();" title="클릭하여 나의 A/S 현황 펼치기/접기">
      <div class="kpi-title">
        <span class="kpi-chev">&#9662;</span>
        나의 A/S 현황 <span class="kpi-title-sub">(나에게 배정된 건 기준)</span>
      </div>
      <div class="kpi-summary" id="kpiSummary">
        <span>미처리 <b id="kpi-recv-mini">0</b></span>
        <span class="kpi-urgent-item">긴급 <b id="kpi-urgent-mini">0</b></span>
        <span>처리예정 오늘 <b id="kpi-duetoday-mini">0</b></span>
        <span>지연 <b id="kpi-overdue-mini">0</b></span>
      </div>
    </div>
    <div class="kpi" id="asKpi">
      <div class="card" title="오늘(접수일 기준) 나에게 배정된 접수 건수입니다. 처리 상태와 무관하게 오늘 들어온 모든 건을 셉니다."><div class="ctop"><div class="ico i-mine">■</div><span class="clabel">오늘 신규 접수</span></div><div class="cnum" id="kpi-today">0</div><div class="csub">오늘 접수된 내 건</div></div>
      <div class="card" title="나에게 배정된 건 중 아직 처리완료·철회되지 않은 모든 미완료 건수입니다."><div class="ctop"><div class="ico i-recv">■</div><span class="clabel">미처리</span></div><div class="cnum" id="kpi-recv">0</div><div class="csub">완료·철회 제외</div></div>
      <div class="card" title="중요도 S(긴급)로 지정된 미완료 건수입니다. (완료·철회 제외)"><div class="ctop"><div class="ico i-urgent">■</div><span class="clabel">긴급</span></div><div class="cnum" id="kpi-urgent">0</div><div class="csub">중요도 S · 미완료</div></div>
      <div class="card" title="나에게 배정된 건 중 처리예정일이 오늘인 미완료 건수입니다. 오늘 안에 끝내야 하는 건입니다."><div class="ctop"><div class="ico i-prog">■</div><span class="clabel">처리예정 오늘</span></div><div class="cnum" id="kpi-duetoday">0</div><div class="csub">처리예정일=오늘</div></div>
      <div class="card" title="나에게 배정된 건 중 처리예정일이 지났는데 아직 완료하지 못한 건수입니다. (대시보드의 '지연'과 달리 처리예정일 초과 기준)"><div class="ctop"><div class="ico i-overdue">■</div><span class="clabel">처리예정일 지남</span></div><div class="cnum" id="kpi-overdue">0</div><div class="csub">예정일 초과 · 미완료</div></div>
      <div class="card" title="처리완료일(COMPLETE_DT)이 오늘인 내 건수입니다. 접수일과는 무관합니다."><div class="ctop"><div class="ico i-done">■</div><span class="clabel">오늘 처리완료</span></div><div class="cnum" id="kpi-donetoday">0</div><div class="csub">오늘 완료 건</div></div>
    </div>
  </div>
  <%-- [AX Lab] 수정 끝 --%>
  <%-- [AX Lab] 수정 끝 --%>

<%-- [AX Lab] 수정 시작 (2026-07-24 AX Lab): 검색조건을 AS목록(COL1) 내부 기본/고급 필터로 이동. 기존 상단 검색테이블 비활성화(원본 유지) --%>
<%--
<div class="tit_sWrap">

<div class="ico_s_modify">
<!-- <span class="tit_gray"; onclick="javascript:btnAnswer();">A/S 답변 조회 팝업</span>
 -->
 </div>	
	<div class="search_condition">
		검색 조건을 선택해 주세요.
		<select id="search_gubun" name="search_gubun" title="검색조건 선택" onchange="javascript:search_type(this.value);">
			<option value="1">일반 검색</option>
			<option value="2">고급 검색</option>
		</select>
	</div>
</div>

<table class="sType mgb10">
	<caption>A/S 접수 리스트 검색</caption>
	<colgroup>
		<col style="width:140px;" />
		<col style="width:275px;" />
		<col style="width:120px;" />
		<col style="width:175px;" />
		<col style="width:120px;" />
		<col style="width:170px;" />
	</colgroup>
	<tbody id="asSearchTbody">
		<tr> 
			<th scope="row">처리상태</th> 
			<td colspan="5"> 
				<select name="procMultiSelect" id="procMultiSelect" class="procMultiSelect" title="처리상태 선택" multiple data-max="2"></select>
				<label class="mgr15">
					<span class="fontW_b mgr5">처리완료 외 상태</span>
					<input type="checkbox" name="search_type13" id="search_type13" value="Y" onchange="javascript:change_exceptComplete();"   >
				</label> 
			</td>
		</tr> 
		<tr> 
			<th scope="row">접수경로</th> 
			<td> 
				<select name="search_type14" id="search_type14" class="w210 mgr10" title="접수경로 선택"></select>
			</td>
			<th scope="row">처리예정일</th> 
			<td colspan="3"> 
				<input type="checkbox" name="search_type15" id="search_type15" value="Y" class="mgr5">
				<input type="text" name="search_start3" id="search_start3" title="처리예정 시작일 입력" class="w135 mgr2" value=""/> 
				<input type="text" name="search_end3" id="search_end3" title="처리예정 종료일 입력" class="w135 mgl10 mgr2" value=""/> 
			</td> 
		</tr> 
		<tr>
			<th scope="row">접수번호</th> 
			<td> 
				<input type="text" name="search_type4" id="search_type4" title="접수번호 입력"> 
			</td> 
			<th scope="row">거래처명/코드</th> 
			<td colspan="3"> 
				<input type="text" name="cust_kor_name" id="cust_kor_name" value="" class="w100 mgr5 mgb5"  title="고객사 명 입력" readonly="readonly" />
				<input type="text" name="cust_code" id="cust_code" value="" class="w100 mgr5 mgb5" title="고객사 코드 입력" readonly="readonly" />
				<button type="button" class="btn_line_gray" onclick="showCustLayer();">조회</button>
				<button type="button" class="btn_line_gray" onclick="resetCustInfo();">초기화</button>
			</td> 
		</tr>
		
		
		<tr> 
			<th scope="row">처리담당자명</th> 
			<td> 
				<input type="text" name="emp_nm" id="emp_nm" title="처리담당자 입력" class="w135"> 
				<label class="mgr15">
					<span class="fontW_b mgr5">퇴사자</span>
					<input type="checkbox" name="search_type17" id="search_type17" value="Y"/>
				</label> 
			</td> 
			<th scope="row">접수일자</th> 
			<td colspan="3"> 
				<input type="checkbox" name="search_type10" id="search_type10" value="Y" class="mgr5" checked>
				<input type="text" name="search_start" id="search_start" title="투입기간 시작일 입력" class="w135 mgr2" value=""/> 
				<input type="text" name="search_end" id="search_end" title="투입기간 종료일 입력" class="w135 mgl10 mgr2" value=""/> 
			</td> 
		</tr> 
		
		
		<tr> 
			<th scope="row">문의유형</th> 
			<td> 
				<select name="search_type16" id="search_type16" title="문의유형 선택"  class="w210 mgr10" onchange="setRequest_type(this.value);"></select> 
			</td>
			<th scope="row">중요도</th> 
			<td> 
				<select name="search_type9" id="search_type9" title="중요도 선택" class="w135"></select> 
			</td> 
			<th scope="row">파트</th> 
			<td colspan="3"> 
				<select name="search_type12" id="search_type12" title="파트 선택" class="w135"></select> 
			</td> 
		</tr> 
		<tr> 
			<th scope="row">시스템유형</th> 
			<td> 
				<select name="search_type7" id="search_type7" title="시스템(대) 선택" class="w100 mgr2" onchange="setService_cate(this.value);"></select> 
				
				<select name="search_type8" id="search_type8" title="시스템(소) 선택" class="w100" ></select> 
			</td>
			<th scope="row">원인유형</th> 
			<td> 
				<select name="search_type2" id="search_type2" title="원인유형 선택"  class="w135"></select> 
			</td> 
			<th scope="row">조치유형</th> 
			<td colspan="3"> 
				<select name="search_type3" id="search_type3" title="조치유형 선택" class="w135"></select> 
			</td> 
		</tr> 
		
		
		<tr class="highLevelSearch"> 
			<th scope="row">부서명/코드</th> 
			<td> 
				<input type="text" name="search_type6" id="search_type6" title="부서명/코드 입력" class="w235"> 
			</td>
			<th scope="row">처리완료일</th> 
			<td colspan="3"> 
				<input type="checkbox" name="search_type11" id="search_type11" value="Y" class="mgr5">
				<input type="text" name="search_start2" id="search_start2" title="처리완료 시작일 입력" class="w135 mgr2" value=""  readonly="readonly"/> 
				<input type="text" name="search_end2" id="search_end2" title="처리완료 종료일 입력" class="w135 mgl10 mgr2" value="" readonly="readonly"/> 
			</td>
		</tr> 
		
		<tr> 
			<th scope="row">통합 검색 키워드</th> 
			<td colspan="5"> 
				<input type="text" placeholder="접수번호 / 거래처명 / 거래처코드 / 처리담당자명 / 요청내용 / 조치 및 처리의견" name="search_text" id="search_text" class="w640 mgr10"  style="ime-mode:active;"  title="통합 검색 키워드 입력" /><button type="button" class="btn_ico_reset mgr5" onclick="searchReset();"><span>초기화</span></button><button type="button" class="btn_ico_search mgr5" onclick="getAsList(1);"><span>검색</span></button> 
			</td> 
		</tr> 
	</tbody>
	
</table>
--%>
<%-- [AX Lab] 수정 끝 : 상단 검색테이블 비활성화 --%>
  <!-- 3분할 그리드 -->
  <div class="grid" id="asGrid">

    <!-- COL1 : 목록 -->
    <section class="col" id="col-c1">
      <div class="rail">
        <button type="button" onclick="asws_toggleCol('c1')" title="목록 펼치기">&#9656;</button>
        <div class="vtext">AS 목록</div>
      </div>
      <div class="chd">
        <h2>AS 목록</h2>
        <span class="cnt">조회 <b id="count">0</b>건</span>
        <div class="spacer"></div>
        <button type="button" class="collapse-btn" onclick="asws_toggleCol('c1')" title="목록 접기">&#9666;</button>
      </div>
      <div class="col-content">
        <%-- [AX Lab] 수정 시작 (2026-07-24 AX Lab): AS목록 상단 기본필터 + 고급필터(동적 검색구분) --%>
        <%-- [AX Lab] 수정 시작 (2026-07-28 AX Lab): 필터 영역이 화면을 과도하게 차지해 문의내용 목록이 아래로
             밀리는 문제 개선. 라벨을 필드 위에 쌓던 3행(bf-row) 구조를 인라인 2행(bf-line) 구조로 축약하고,
             전체폭 1행을 차지하던 '고급 검색' 토글을 1행 우측 인라인 칩으로 이동해 총 1행을 더 절약했다.
             (필드/name/id 는 그대로 유지 → 검색 로직·서버 파라미터 변경 없음) --%>
        <div class="basefilter">
          <!-- 기본필터 1행 : 처리구분 · 접수일자 · 고급검색 토글 -->
          <div class="bf-line">
            <%-- [AX Lab] 수정 시작 (2026-07-28 AX Lab): '전체 A/S' 의 value 를 '' → '1' 로 변경.
                 ''(빈값)은 "처리구분 미지정(첫 진입)" 과 값이 겹쳐, 검색 후 화면 복원 시 '전체 A/S' 가
                 매번 '나의 A/S' 로 되돌아갔다(=담당건 없는 계정은 목록이 비어 보임).
                 서버는 "2" 일 때만 담당자 필터를 걸므로 '1' 은 전체 조회로 동작한다.
                 또한 선택 즉시 조회되도록 onchange 를 추가해 별도로 검색 버튼을 누르지 않아도 되게 한다. --%>
            <select name="asGubunFlag" id="asGubunFlag" class="bf-sel-narrow" title="처리구분 선택" onchange="getAsList(1);">
              <option value="2">나의 A/S</option>
              <option value="1">전체 A/S</option>
            </select>
            <%-- [AX Lab] 수정 끝 --%>
            <label class="bf-chk" title="접수일자 기간조건 사용">
              <input type="checkbox" name="search_type10" id="search_type10" value="Y" checked> 접수일
            </label>
            <input type="text" name="search_start" id="search_start" class="bf-date" title="접수 시작일" value="">
            <span class="dwave">~</span>
            <input type="text" name="search_end" id="search_end" class="bf-date" title="접수 종료일" value="">
            <div class="spacer"></div>
            <button type="button" class="moretoggle" id="advToggle" onclick="asws_advToggle();" title="고급 검색조건 펼치기/접기">
              <span class="chev">&#9662;</span> 고급<span class="adv-cnt" id="advCnt" style="display:none;">0</span>
            </button>
          </div>
          <!-- 기본필터 2행 : 처리상태 · 통합검색 -->
          <div class="bf-line">
            <select name="procMultiSelect" id="procMultiSelect" class="procMultiSelect" title="처리상태 선택" multiple data-max="2"></select>
            <div class="sl-input">
              <input type="text" name="search_text" id="search_text" placeholder="접수번호 / 거래처 / 담당자 / 요청·조치내용" title="통합 검색 키워드">
              <button type="button" onclick="getAsList(1);" title="검색">검색</button>
            </div>
            <button type="button" class="btn-s" onclick="searchReset();" title="검색조건 초기화">초기화</button>
          </div>

          <%-- [AX Lab] 삭제 (2026-07-28 AX Lab): '처리완료 외 상태' 체크박스를 화면에서 제거.
               동일 조건(접수+처리중)을 위 2행의 처리상태 멀티셀렉트 기본 체크로 대체했다.
               조회조건이 처리상태 한 곳으로 모여, 현재 어떤 상태로 조회 중인지 화면에서 바로 보인다.
              <label class="bf-chk">
                <input type="checkbox" name="search_type13" id="search_type13" value="Y" onchange="javascript:change_exceptComplete();"> 처리완료 외 상태
              </label>
          --%>
          <%-- [AX Lab] 수정 시작 (2026-07-28 AX Lab): search_type13 은 hidden 으로만 유지.
               항상 'N' 을 전송해 "이 화면에서 검색을 실행했다"는 표시로 쓴다.
               (값이 없으면=첫 진입 → 처리상태 기본 체크 적용 / 'N'이면 → 사용자 선택 존중)
               SQL 은 search_type13 != 'Y' 분기를 타므로 조회 결과에는 영향이 없다. --%>
          <input type="hidden" name="search_type13" id="search_type13" value="N" />
          <%-- [AX Lab] 수정 끝 --%>

          <!-- 고급필터 본문 (토글은 위 1행 우측 '고급' 칩) -->
          <div class="morebody" id="advBody">
            <div class="bf-line" style="gap:16px; margin-bottom:7px;">
              <label class="bf-chk">
                <input type="checkbox" name="search_type17" id="search_type17" value="Y"> 퇴사자 포함
              </label>
            </div>
            <div id="advRows"></div>
            <button type="button" class="btn-s" id="advAddBtn" onclick="asws_advAddRow();" style="margin-top:4px;">+ 조건 추가</button>
          </div>
        </div>
        <%-- [AX Lab] 수정 끝 --%>
        <%-- [AX Lab] 수정 끝 --%>
        <div class="toolbar">
          <button type="button" class="btn-s primary" onclick="javascript:openProcLayer();">일괄처리</button>
          <button type="button" class="btn-s" onclick="javascript:goInsertCopy();">복사</button>
          <button type="button" class="btn-s" onclick="javascript:goForm('insert','');">신규작업</button>
          <button type="button" class="btn-s" onclick="javascript:goForm('subInsert','');">하위작업</button>
          <button type="button" class="btn-s" onclick="javascript:goExl();">엑셀</button>
          <div class="spacer"></div>
          <select id="pageSize" name="pageSize" onchange="getAsList(1);" title="리스트 행 선택">
            <option value="10">10개씩</option>
            <option value="30">30개씩</option>
            <option value="50">50개씩</option>
          </select>
        </div>
        <div class="tscroll">
          <table class="aslist">
            <colgroup>
              <col style="width:26px" /><col style="width:56px" /><col style="width:96px" /><col style="width:auto" /><col style="width:64px" />
            </colgroup>
            <thead>
              <tr>
                <th class="col-chk"><input type="checkbox" id="chkall" onclick="asws_toggleAll(this);" title="전체선택" /></th>
                <th>접수일</th>
                <th>거래처</th>
                <th>문의 내용 · 조치</th>
                <th>상태</th>
              </tr>
            </thead>
            <tbody id="asList"></tbody>
          </table>
        </div>
        <div class="list-page"><div id="pagination"></div></div>
      </div>
    </section>

    <!-- COL2 : 문의 상세 + 답변 -->
    <section class="col" id="col-c2">
      <div class="chd">
        <h2>문의 상세</h2>
        <div class="spacer"></div>
        <span class="cnt" id="pinlabel"></span>
      </div>
      <div class="col-content">
        <div class="detail-scroll" id="asDetail">
          <div class="empty">왼쪽 목록에서 접수건을 선택하세요.</div>
        </div>
      </div>
    </section>

    <!-- COL3 : 접수 · 처리 정보 -->
    <section class="col" id="col-c3">
      <div class="rail">
        <button type="button" onclick="asws_toggleCol('c3')" title="정보 펼치기">&#9666;</button>
        <div class="vtext">접수 · 처리 정보</div>
      </div>
      <div class="chd">
        <h2>접수 · 처리 정보</h2>
        <div class="spacer"></div>
        <button type="button" class="collapse-btn" onclick="asws_toggleCol('c3')" title="정보 접기">&#9656;</button>
      </div>
      <div class="col-content">
        <div class="rec-scroll" id="asRecord">
          <div class="none" style="padding:14px">왼쪽 목록에서 접수건을 선택하세요.</div>
        </div>
      </div>
    </section>

  </div>
</div>
<%-- [AX Lab] 수정 끝 : #asWorkspace --%>

<div class="box_layer layer_sms" id="wrap_aws" style="display:none;">
	<h1>신규답변</h1>
	<div class="layer_contents pdt20">
	    <div style="height: 120px;margin-bottom:10px; overflow-y: auto;" id="awsWrap">
               <table class="hType">
                   <caption>답변내용 목록</caption>
                   <colgroup>
                       <col style="width:100px" />
                       <col style="width:200px" />
                   </colgroup>
                   <thead>
                       <tr>
                           <th scope="col">작성자</th>
                           <th scope="col">답변일시</th>
                           <th scope="col">답변내용</th>
                       </tr>
                   </thead>
                   <tbody id="awsInfoList"></tbody>
               </table>
           </div>
		<textarea name="w_content" id="w_content" class="mgb10"></textarea>
		<div class="btn_wrap">
		    <div class="floatR">
		        <button type="button" class="btn_ico_write dgray" onclick="btnAwsProc();"><span>등록</span></button>
		        <button type="button" class="btn_ico_cancel dgray" onclick="btnAwsClose();"><span>취소</span></button>    
		    </div>
		</div>
	</div>
	<button type="button" class="btn_close" onclick="btnAwsClose();">창 닫기</button>
</div>
<div class="layer_dimmed" id="dim_aws" style="display:none;"></div>


<!-- 답변 검색팝업 -->
<div class="box_layer layer_code_edit" id="answer_layer" style="display:none;">
	<h1>답변검색</h1>
	<div class="layer_contents_nonscroll pdt20">
	    <div style="height:130px;padding-left:20px;padding-right:20px;padding-bottom:20px;" id="answer">
               <table class="sType mgb10">
                   <caption>답변검색</caption>
                   <colgroup>
                       <col style="width:100px" />
                       <col style="width:200px" />
                       <col style="width:100px" />
                       <col style="width:200px" />
                   </colgroup>
                   <thead>
                      <tr>
                           <th scope="row">답변작성일</th>
                           <td>
                           		<input type="checkbox" name="aw_search_type1" id="aw_search_type1" value="" class="mgr2">
                           		<input type="text" name="aw_search_start1" id="aw_search_start1" title="시작일입력" class="w90 mgr2" value="" readonly="readonly">~
                           		<input type="text" name="aw_search_end1" id="aw_search_end1" title="종료알입력" class="w90 mgr2" value="" readonly="readonly">
                           </td>
                           <th scope="row">AS접수일</th>
                           <td>
                           		<input type="checkbox" name="aw_search_type2" id="aw_search_type2" value="" class="mgr2">
                           		<input type="text" name="aw_search_start2" id="aw_search_start2" title="AS접수일 입력" class="w90 mgr2" value="" readonly="readonly">~
                           		<input type="text" name="aw_search_end2" id="aw_search_end2" title="AS 접수일 입력" class="w90 mgr2" value="" readonly="readonly">
                           </td>
                       </tr>
                       <tr>
                           <th scope="row">작성자구분</th>
                           <td>
                           		<input type="radio" id="fr" name="aw_gubun" value="U" checked="checked">고객
                           		<span class="mgr10"></span>
                           		<input type="radio" id="ad" name="aw_gubun" value="A"  >AS담당자
                           </td>
                           <th scope="row">거래처명</th>
                           <td>
                           		<input type="text" name="aw_search_text3" id="aw_search_text3" class=""  />
                           </td>
                       </tr>
                       <tr>
                       	   <th scope="row">작성자이름</th>
                           <td>
                           		<input type="text" name="aw_search_text4" id="aw_search_text4" class=""  title="거래처명 입력" />
                           </td>
                           <th scope="row">답변내용</th>
                           <td>
                           		<input type="text" name="aw_search_text5" id="aw_search_text5" class="w175"   title="답변내용 입력" />
                           		<button type="button" class="btn_ico_search mgr5" onclick="javascript:goAnswerList();"><span>검색</span></button>
                           </td>
                       </tr>
                   </thead>
                 </table>
           </div>
           
           <!-- 답변내용 -->
           <div style="padding-right:30px;padding-left:30px; height:340px;overflow-y:auto;" id="wrap_answer">
	           	
	           	
	           	
	           	<!-- 내용박스 -->
	           	<!-- /내용박스 -->
	           	<!-- <div id="answer-box">
		           	<div class="answer-greybox mgb20" onclick="goAsDetail('20180531089')" style="cursor:pointer;">
		           		<div class="pos2" style="width:40px;height:40px; position:absolute; top:-15px; left:-15px;"></div>
		           		<table class="db-answer">
		           			<tbody>
		           				<tr>
		           					<td colspan="2" style="font-size: 13px;color:#797979;font-weight: 600;">2018-06-01 14:15:19</td>
		           					<td colspan="2" class="textR mgb5" style="font-size: 13px;color: #0090c8;font-weight: 700;">AS접수번호 20180531089 | SG삼성조은병원</td>
		           				</tr>
		           				<tr>
		           					<td colspan="4" style="padding-bottom:5px;padding-top: 5px; border-bottom: 1px solid #dedede !important;">[요청] 향정약 (프리폴주,바스캄주) 실사용량 입력에 관해서 문의 -SG삼성</td>
		           				</tr>
		           				<tr>
		           					<td colspan="4" style="padding-bottom:5px;padding-top: 5px;">[답변] 
		           					안녕하세요. 중외정보기술 이은경입니다.처방을 실 사용량으로 입력하지 않았습니다. 처방시 실사용량으로 처방하여 사용하시도록 안내드렸습니다.감사합니다. -이은경
		           					</td>
		           				</tr>
		           			</tbody>
		           		</table>
		           	</div>
	           	</div> -->
           
           </div>
           <!-- //wrap  --> 
	</div>
	<button type="button" class="btn_close" onclick="btnAnswerClose();">창 닫기</button>
</div>
<div class="layer_dimmed" id="dim_answer" style="display:none;"></div>


<div class="box_layer layer_sms" style="margin-top:-300px; display:none;" id="div1">
<h1>거래처 정보 조회 검색 결과</h1>
<div class="layer_contents pdt20" style="height:657px;">
	기관명:
	<input type="text" class="w175 mgr10" id="searchKorName" name="searchKorName" title="거래처 정보 검색"  autofocus="autofocus" />
	<button type="button" class="btn_ico_search mgr5" onclick="javascript:custList(1);"><span>검색</span></button>
	<table class="vType_line" style="margin-top: 10px">
		<caption>거래처 정보 목록</caption>
		<colgroup>
			<col style="width:50px;" />
			<col style="width:200px;" />
			<col style="width:80px;" />
			<col style="width:150px;" />
			<col style="width:auto;" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">No</th>
				<th scope="col">기관명</th>
				<th scope="col">대표자</th>
				<th scope="col">사업자번호</th>
				<th scope="col">주소</th>
			</tr>
		</thead>
		<tbody id="custInfoList"></tbody>
	</table>
	<div class="page" id="layer_pagination" style="margin-top: 10px;"></div>
</div>
<button type="button" class="btn_close" onclick="javascript:closeLayer(1);">창 닫기</button>
</div>
<div class="layer_dimmed" style="display:none;" id="div1_dim"></div>



<!-- 처리완료 사항 일괄입력 팝업 -->
<div class="box_layer layer_rating"
     id="procLayer"
     style="
        top:20%;
        left:50%;
        transform:translateX(-50%);
        width:1000px;
        height:700px;
        display:none;
        overflow:hidden;   /* ⭐ 핵심 */
        box-sizing:border-box;">
  <h1 class="tit_back">처리완료 사항 일괄입력</h1>

<div class="layer_contents"
     style="
        box-sizing:border-box;
        padding-right:10px;
        height:calc(100% - 60px); /* 타이틀/버튼 영역 제외 */
        overflow-y:auto;          /* ⭐ 스크롤은 여기 */
        overflow-x:hidden;">

    <div class="tit_bWrap mgb10">
      <h4>처리완료 사항</h4>
    </div>

    <table class="sType mgb20" style="width:100%; table-layout:fixed;">
      <caption>접수 정보 입력</caption>
      <colgroup>
        <col style="width:180px;" />
        <col style="width:auto;" />
      </colgroup>
      <tr id="asno_list">
        <th scope="row">선택한 접수번호<span class="request">필수 입력</span></th>
        <td>
          <input type="text" id="as_no_link_grp_str" readonly="readonly"
                 style="width:100%; box-sizing:border-box; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;" />
          <input type="hidden" name="as_no_link_grp" id="as_no_link_grp" />
        </td>
      </tr>
    </table>

    <table class="sType mgb10" style="width:100%; table-layout:fixed;">
      <caption>처리완료 사항 입력</caption>
      <colgroup>
        <col style="width:160px;" />
        <col style="width:300px;" />
        <col style="width:160px;" />
        <col style="width:auto;" />
      </colgroup>
      
      <tr>
        <th scope="row" id="tel_confirm_th">전화 확인</th>
        <td colspan="3">
          <label for="tel_confirm">
            <input type="checkbox" id="tel_confirm_pop" name="tel_confirm_pop"> 전화확인 완료
          </label>
        </td>
      </tr>

      <tr>
        <th scope="row" id="proc_dt_th">처리 예정 일자<span class="request mgl5">필수 입력</span></th>
        <td>
          <input type="text" name="proc_dt_pop" id="proc_dt_pop" style="width:140px;" />
        </td>
        <th scope="row">처리 완료 예정 시각<span class="request mgl5">필수 입력</span></th>
        <td>
          <div style="white-space:nowrap;">
            <select name="proc_time1_pop" id="proc_time1_pop" style="width:70px; display:inline-block;"></select>
            <span style="display:inline-block; padding:0 6px;">:</span>
            <select name="proc_time2_pop" id="proc_time2_pop" style="width:70px; display:inline-block;"></select>
          </div>
        </td>
      </tr>

      <tr>
        <th scope="row" id="cause_type_th">원인유형<span class="request mgl5">필수 입력</span></th>
        <td>
          <select name="cause_type_pop" id="cause_type_pop" style="width:240px;">
            <option value="">선택해주세요</option>
          </select>
        </td>
        <th scope="row" id="action_type_th">조치유형<span class="request mgl5">필수 입력</span></th>
        <td>
          <select name="action_type_pop" id="action_type_pop" style="width:240px;" onchange="setProcGrade(this.value)">
            <option value="">선택해주세요</option>
          </select>
        </td>
      </tr>

      <tr id="work_time_tr_pop">
        <th scope="row" id="work_time_th">작업시간(Hour)<span class="request mgl5">필수 입력</span></th>
        <td>
          <input id="work_time_pop" type="number" name="work_time_pop" value=""
                 style="width:140px;" oninput="if(this.value<0)this.value='';" />
        </td>
        <th scope="row" id="complete_dt_th">처리 완료 일자<span class="request mgl5">필수 입력</span></th>
        <td>
          <input type="text" name="complete_dt_pop" id="complete_dt_pop" style="width:140px;" />
        </td>
      </tr>

      <tr>
        <th scope="row">
          <span id="action_content_th">조치 및 처리 의견<span class="request mgl5">필수 입력</span></span>
          <span style="color:red;">(외부에는 노출되지 않습니다)</span>
        </th>
        <td colspan="3">
          <textarea name="action_content_pop" id="action_content_pop"
                    style="width:98%;height:120px; box-sizing:border-box;"></textarea>
          <div class="txt_byte" id="action_content_text_pop">0 / 1300자</div>
        </td>
      </tr>
    </table>
    
    <div id="completion_details" style="display:none;">
		<div class="tit_bWrap mgb10">
			<h4>처리완료 상세 사항</h4>
		</div>

		<table class="sType mgb10" id="wrapFile">
			<caption>처리작업 상세사항 입력</caption>
			<colgroup>
				<col style="width: 180px;" />
				<col style="width: 320px;" />
				<col style="width: 160px;" />
				<col style="width: 320px;" />
			</colgroup>
			<tr>
				<th id="proc_gubun_th" scope="row" class="dev_proc">처리구분</th>
				<td><select id="proc_gubun_pop" name="proc_gubun_pop" onChange="setProcGubun(this.value)"
					class="w200"></select></td>
				<th scope="row" id="proc_build_info_th" class="dev_proc">빌드순번</th>
				<td><input type="text"
					id="proc_build_info_pop" name="proc_build_info_pop" value="" title="빌드순번" /></td>
			</tr>
			<tr>
				
				<th scope="row" id="proc_test_info_th" class="dev_proc">개발처리서(테스트케이스)</th>
				<td><input type="text"
					id="proc_test_info_pop" name="proc_test_info_pop" value="" title="개발처리서(테스트케이스) 입력" /></td>
				<th scope="row" class="dev_proc_shape">프로세스정의서</th>
				<td><input type="text" 
					id="proc_process_sp_pop" name="proc_process_sp_pop" value="" title="프로세스정의서 입력" /></td>
			</tr>
			<tr>
				
				<th scope="row" class="dev_proc_shape">화면정의서</th>
				<td><input type="text" 
					id="proc_screen_sp_pop" name="proc_screen_sp_pop" value="" title="화면정의서 입력" /></td>	
				<th scope="row" class="dev_proc_shape">테이블정의서</th>
				<td><input type="text" id="proc_table_sp_pop" name="proc_table_sp_pop"
					value="" title="테이블정의서 입력" /></td>
			</tr>
			<tr>
				<th scope="row" class="dev_proc_shape">기능분해도</th>
				<td><input type="text" 
					id="proc_function_sp_pop" name="proc_function_sp_pop" value="" title="기능분해도 입력" /></td>
				<th scope="row" class="dev_proc_shape">인터페이스정의서</th>
				<td><input type="text" 
					id="proc_interface_sp_pop" name="proc_interface_sp_pop" value="" title="인터페이스정의서 입력"/></td>
			</tr>
		</table>
	</div>

    <div class="tit_bWrap mgt20 mgb10">
      <h4>답변내용</h4>
    </div>
    
    <table class="sType mgb30" style="width:100%; table-layout:fixed;">
      <caption>답변내용 목록</caption>
      <colgroup>
        <col style="width:160px" />
        <col style="width:auto;" />
      </colgroup>
      <tbody id="aswWrapFile">
        <tr>
          <th scope="col">답변작성<span class="request mgl5">필수 입력</span></th>
          <td class="pd10">
            <input name="w_content_pop" id="w_content_pop" class="lineH13 pd5"
                      style="width:100%; box-sizing:border-box;"/>
        </tr>
      </tbody>
    </table>

    <div style="text-align:right; padding:10px 15px 0 15px; border-top:1px solid #e5e5e5;">
      <button type="button" class="btn_ico_confirm" style="width:90px" onclick="confirmProcBatch()">저장</button>
    </div>

  </div>

  <button type="button" class="btn_close" onclick="closeProcLayer()">창 닫기</button>
</div>

<div class="layer_dimmed" id="div_dim_proc" style="display:none;"></div>


</form>
<form name="answerForm" id="answerForm" method="post" enctype="multipart/form-data">
<input type="hidden" name="w_content" />
<input type="hidden" name="as_no" />
<input type="hidden" name="seq" />
<input type="hidden" name="pageType" />
</form>