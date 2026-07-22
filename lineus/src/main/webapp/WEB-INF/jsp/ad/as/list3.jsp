<%@page import="egovframework.com.comm.util.CommonExecute"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style>
    #jw_contents{width: 95vw !important; margin: 0 auto 44px; min-height: 78vh;}
	.status_bold {color:#0032c3 !important;font-weight:bold;}
	.scroll-table{width:1860px;table-layout:auto;}
	.scroll-table tr:hover{background-color: #eef7f9 !important;}
	.hType2 th{border-right:1px solid #dadada !important;}
	.hType2 td{border-right:1px solid #dadada !important;}
	textarea {height:50px;width:97%;}
	
</style>

<script type="text/javascript">

	var cntdata = 0;
	var asNoSave = "";
	var state_chk_value = "";
	var dataList;			//부결 팝업창에 사용
	$(document).ready(function(){
		initForm();
		
		/* 체크박스 전체선택 전체해제 */
		$("#checkall").click(function() {
			if($("#checkall").is(":checked")) $("input[name=chk]").prop("checked", true);
			else $("input[name=chk]").prop("checked", false);
		});

		$("input[name=chk]").click(function() {
			var total = $("input[name=chk]").length;
			var checked = $("input[name=chk]:checked").length;
			
			if(total != checked) $("#checkall").prop("checked", false);
			else $("#checkall").prop("checked", true); 
		});
		
	}) ;
	
	function initForm(){
		commonCode.getCodeList('AS' , 'CD01' , 'search_type1') ;	//처리상태
		
		$( "#search_start" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#search_end" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		$( "#search_start2" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#search_end2" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		var search_type2 = '${ vo.search_type2 }';
		(search_type2 == 'Y') ? $('#search_type2').prop('checked',true) : $('#search_type2').prop('checked',false);
		
        $('#checkall').prop('checked',false); //2024.01.25 전체선택한 다음 결제 후 전체체크표시 사라지도록 코드 추가
		
		if ('${ vo.search_start }' != '') $('#search_start').val('${ vo.search_start }');
		if ('${ vo.search_end }' != '') $('#search_end').val('${ vo.search_end }');
		
		$('#search_type1').val('${ vo.search_type1 }');
		
		$('#page').val('${ vo.page}') ;
		$('#pageSize').val('${ vo.pageSize}') ;
		$('#state_chk1').prop('checked',true);
		var state_chk = '${ vo.state_chk }';
		if(state_chk == "C"){
			$('#state_chk3').prop('checked',true);
		} else if(state_chk == "B"){
			$('#state_chk2').prop('checked',true);
			
		}else if(state_chk == "A"){
			$('#state_chk1').prop('checked',true);
		}
		makeListData();
	}
	
	
	function makeListData() {
		common.ajaxCall($('form[name=listFrm]').serialize(), '/ad/as/getAsApprList.do', 'setAsList') ;
	}
	
	function getAsList(pageIndex) {
		var f = document.listFrm ; 
		f.page.value = pageIndex ; 
		f.target = '' ; 
		f.action = '/ad/as/list3.do' ; 				
		f.submit() ; 
	}
	
	function goView(pageType , as_no, cn_as_no){
		var f = document.listFrm ; 
		
		f.pageType.value = pageType ; 
		f.as_no.value = as_no ; 
		f.cn_as_no.value = cn_as_no ; 
		//list3 - screen A/S승인
		f.current_file.value = 'list3';
		
		f.target = '' ; 
		f.action = '/ad/as/form.do' ; 
		f.submit() ; 
	}
	
	function setAsList(data) {
		$('#asList').empty();
		var resultList = typeof data.resultList != 'undefined' ? data.resultList : null;
		dataList = resultList;
		var vo = typeof data.vo != 'undefined' ? data.vo : null;
		
		if (resultList != null && resultList.length > 0) {
			
			
			var toggle = true;
			var prevAsNo = "0";
			var num = 0;
			var str = '' ; 
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ; 
				
				num = i+1;
				
				// 접수일 날짜를 형식에 맞게 셋팅
				var vAcceptDt = "-";   
				if (common.nvl(datas.accept_dt, '').length == 8){
					vAcceptDt = makeDate(datas.accept_dt,"-");
		 		}
				//완료일 날짜를 형식에 맞게 셋팅
				var vCompleteDt = "-";
				if (common.nvl(datas.complete_dt, '').length == 8){
					vCompleteDt = makeDate(datas.complete_dt,"-");
		 		}
				
				// 검수일 날짜를 조정
				var vStateDate = common.nvl(datas.star_state_date, '-');  
				if (vStateDate.length > 10) vStateDate = vStateDate.substr(0,10);
				
				if(common.nvl(datas.cn_as_no, '') == "" ) str += '<tr id="tr'+num+'" onclick="goView(\'update\' , \''+common.nvl(datas.as_no , '')+'\', \''+common.nvl(datas.cn_as_no , '')+'\');" style="cursor:pointer;background-color:'+(toggle ? "#f8fafb" : "#ffffff")+'"> ' ;
				else str += '<tr id="tr'+num+'" onclick="goView(\'subUpdate\' , \''+common.nvl(datas.as_no , '')+'\', \''+common.nvl(datas.cn_as_no , '')+'\');" style="cursor:pointer;background-color:'+(toggle ? "#f8fafb" : "#ffffff")+'"> ' ;
				str += '		<td  onclick=\'event.cancelBubble=true;\'>';
				str += ' 			<input type="checkbox" title="선택" name="chk" id="chk'+num+'" value="Y" />'	;
				str += '		</td>';	
				
				if (common.nvl(datas.as_no, '') != '') {
					//접수번호
					str += '		<td name="as_no'+num+'" id="as_no'+num+'">'+common.nvl(datas.as_no, '')+'</td> ' ;
				} else {
					str += '		<td>-</td> ' ;
				}
				
				//승인여부
				if(common.nvl(datas.appr_yn, '') == 'Y'){
					str += '	<td name="appr_yn'+num+'" id="appr_yn'+num+'">결재</td> ' ;
				} else if(common.nvl(datas.appr_yn, '') == 'N'){
					str += '	<td name="appr_yn'+num+'" id="appr_yn'+num+'">미결</td> ' ;
				} else if(common.nvl(datas.appr_yn, '') == 'R'){
					str += '	<td name="appr_yn'+num+'" id="appr_yn'+num+'">부결</td> ' ;
				} else {
					str += '	<td>-</td> ' ;
				}
				
				//승인구분 2020.09.08. 김민규부장님 요청으로 추가  (화면에만표시 1 접수(팀장), 2 배포) 
				if(common.nvl(datas.appr_gb, '') == '1'){ 
					str += '	<td name="appr_gb'+num+'" id="appr_gb'+num+'">접수</td> ' ;
				} else if(common.nvl(datas.appr_gb, '') == '2'){
					str += '	<td name="appr_gb'+num+'" id="appr_gb'+num+'">배포</td> ' ;
				} else {
					str += '	<td>-</td> ' ;
				}
				
				/* 처리상태 */
				str += '		<td>'+common.nvl(datas.proc_status_nm, '')+'</td> ' ;
				
				///* 문의내용 */
				//str += '		<td title="'+common.nvl(datas.call_content, '')+'" class="textL">' + datas.call_content.substr(0 , 33) +'</td> ' ;
				///* 조치내용 */
				//str += '		<td  title="'+common.nvl(datas.action_content, '')+'" class="textL">' + datas.action_content.substr(0 , 33) +'</td> ' ;
				
				/* 거래처 코드_거래처명 */
				str += '		<td class="textL">['+common.nvl(datas.cust_code, '')+']'+common.nvl(datas.cust_kor_name,'')+'</td> ' ;
				
				/* 요청자 */
				str += '		<td>'+common.nvl(datas.apply_nm, '')+'</td> ' ;
				
				
				/* 문의서비스 */
				str += '		<td >'+common.nvl(datas.system_type_nm, '')+'/'+common.nvl(datas.inquiry_type_nm, '')+'</td> ' ;
				
				
				/* 처리담당자 */
				str += '		<td>'+common.nvl(datas.emp_nm , '')+'</td> ' ;
				
				/* 문의내용 */
				str += '		<td class="textL">' + datas.call_content.substr(0 , 33) +'</td> ' ;
				/* 조치내용 */
				str += '		<td class="textL">' + datas.action_content.substr(0 , 33) +'</td> ' ;
				
				/* 중요도 */
				if (common.nvl(datas.inportance_nm, '') != '') {
					if (common.nvl(datas.inportance, '') == 'C001') str += '		<td><span class=""></span>'+common.nvl(datas.inportance_nm, '')+'</td> ' ;
					else str += '		<td><span class=""></span>'+common.nvl(datas.inportance_nm, '')+'</td> ' ;					
				} else {
					str += '	<td>-</td> ' ;
				}
				
				/* 문의유형 */ 	  
				str += '		<td>'+common.nvl(datas.request_type_nm , '')+'</td> ' ;
				
				/* 접수경로 */
				str += '		<td>'+common.nvl(datas.accept_route_nm , '')+'</td> ' ;
				
				/* 접수일 */
				str += '		<td>'+vAcceptDt+'</td> ' ;
				/* 처리완료일 */
				str += '		<td>'+vCompleteDt+'</td> ' ;
				
				/* 원인유형 */
				if(common.nvl(datas.cause_type_nm, '') != '') str += '		<td title="'+datas.cause_type_nm+'">'+datas.cause_type_nm.substr(0 , 3)+'</td> ' ;
				else  str += '	<td>-</td> ' ;
				/* 조치유형 */
				
				
				str += '		<td>'+common.nvl(datas.action_type_nm, '')+'</td> ' ;
				/*검수일 */
				str += '		<td>'+vStateDate+'</td> ' ;	
				
				/* 고객평가★ */
				var starCnt = common.nvl(datas.star_state, '');
				var starText = '';
				if (starCnt == 1) starText = '★☆☆☆☆';
				else if (starCnt == 2) starText = '★★☆☆☆';
				else if (starCnt == 3) starText = '★★★☆☆';
				else if (starCnt == 4) starText = '★★★★☆';
				else if (starCnt == 5) starText = '★★★★★';
				else starText = '-';
				if(starText != "-") str += '		<td class="colorRed">'+starText+'</td> ' ;
				else str += '<td>'+starText+'</td> ' ;
				
				/*답변 */
				if (common.nvl(datas.aws_cnt, '0') == '0') {
					str += '		<td>' +common.nvl(datas.total_aws_cnt, '')+ '</td>';
				} 
				
				/* 끝tr */
				str += '</tr> ' ;
			}
			cntdata = resultList.length;
			$('#asList').append(str);	
			$('#count').html(numberWithCommas(vo.rowCnt)); 
			$("#pagination").html(vo.json_paging);
			
		} else {
			commonTable.notData(21,"조회된 데이터가 없습니다.","asList");
			$('#count').html('0');
			$("#pagination").html('');
		}
	}
	
	function setRejectList(data) {
		$('#rejectListBody').empty();
		if (data != null && data.length > 0) {
			
			var num = 0;
			var str = '' ; 
			for(var i = 0 ; i < data.length ; i++){
				var datas = data[i] ; 
				
				num = i+1;
				str += '<tr> ' ;
				//NO
				str += '		<td>'+num+'</td> ' ;
				// 접수일 날짜를 형식에 맞게 셋팅
				var vAcceptDt = "-";   
				if (common.nvl(datas.accept_dt, '').length == 8){
					vAcceptDt = makeDate(datas.accept_dt,"-");
		 		}
				
				if (common.nvl(datas.as_no, '') != '') {
					//접수번호
					str += '	<td name="rej_as_no'+num+'" id="rej_as_no'+num+'">'+common.nvl(datas.as_no, '')+'</td> ' ;
				} else {
					str += '	<td>-</td> ' ;
				}
				//접수일
				str += '		<td>'+vAcceptDt+'</td> ' ;
				/* 거래처 코드_거래처명 */
				str += '		<td>'+common.nvl(datas.cust_kor_name,'')+'</td> ' ;
				
				/* 요청자 */
				str += '		<td>'+common.nvl(datas.apply_nm, '')+'</td> ' ;
				
				
				/* 문의서비스 */
				str += '		<td>'+common.nvl(datas.system_type_nm, '')+'/'+common.nvl(datas.inquiry_type_nm, '')+'</td> ' ;
				
				/* 문의내용 */
				str += '		<td title="'+common.nvl(datas.call_content, '')+'" class="textL">' + datas.call_content.substr(0 , 33) +'</td> ' ;
				
				/*  */
				str += '		<td><textarea id="reject_desc'+num+'"/></td> ' ;
				
				
				
				
				/* 끝tr */
				str += '</tr> ' ;
			}
			//cntdata = num;
			$('#rejectListBody').append(str);	
			
		} else {
			commonTable.notData(21,"선택된 데이터가 없습니다.","rejectListBody");
		}
	}
	
	/* 10분 경과시 페이지 자동 새로고침 (600000=600초=10분)*/
	function pageStart(){
		window.setTimeout("pageReload()",600000);
	}
	
	function pageReload(){
		location.reload();
	}
	
	function approve(){
		var f = document.listFrm ; 
		f.cntdata.value = cntdata ; 
		var cnt = cntdata;			//체크박스 전체 개수
		var checkedCnt = 0;			//체크된 체크박스 개수
		asNoSave = "";
		for(var i = 1 ; i <= cntdata ; i++){
			if($('#chk' + i).is(":checked")){
				// 미결 = 'N'
				if($('#appr_yn' + i).html() != '미결'){
					alert("미결 화면에서 결재를 진행해 주세요");
					return;
				}
				if(asNoSave == "") asNoSave = $('#as_no' + i).html() ; 
	 			else asNoSave = asNoSave + "@" + $('#as_no' + i).html() ;
				checkedCnt++;
			}
		}
		
		if(asNoSave == ""){
			alert("작업할 자료를 선택해주세요");
			return;
		} 
			
		if(confirm( checkedCnt+"건을 결재 하시겠습니까?" )){
		
			f.asNoSave.value = asNoSave ; 
			$.ajax({
				type : 'post' ,
				url : '/ad/code/apprv.do' , 
				data : $('form[name=listFrm]').serialize() ,
				dataType : 'json' , 
				statusCode : {
					403:function(data){
						alert("권한이 없습니다.");
					},
					404:function(data){
						alert('해당 페이지가 존재하지 않습니다.');
					}
				}, 
				success : function(data){
					
					var returnCode = typeof data.returnCode != "undefined" ? common.nvl(data.returnCode , "1000") : "1000" ; 
					var msg = "" ; 
					
					if(returnCode == "400") msg = "처리도중 오류가 발생했습니다." ;
					else msg = "정상적으로 처리 되었습니다." ; 
					
					alert(msg) ;
					initForm();
					
				}
			}) ; 
		}
		
	}
	
	function reject(){
		var f = document.listFrm ; 
		f.cntdata.value = cntdata ; 
		
		var checkedCnt = 0;			//체크된 체크박스 개수
		asNoSave = "";
		var data = [];
		for(var i = 1 ; i <= cntdata ; i++){
			if($('#chk' + i).is(":checked")){
				// 미결 = 'N'
				if($('#appr_yn' + i).html() != '미결'){
					alert("미결 화면에서 기각을 진행해 주세요");
					return;
				}
				if(asNoSave == "") asNoSave = $('#as_no' + i).html() ; 
	 			else asNoSave = asNoSave + "@" + $('#as_no' + i).html() ;
				checkedCnt++;
				data[data.length] = dataList[i - 1];
			}
		}
		setRejectList(data); 
		if(asNoSave == ""){
			alert("작업할 자료를 선택해주세요");
			return;
		} 
		
		$("#rejectListLayer").show();
		
	}
	
	function rejectProc(){
		
		if(confirm( $('#rejectListBody tr').length+"건을 반려 하시겠습니까?" )){
			var arrayObj = [];
			for(var i = 1 ; i <= $('#rejectListBody tr').length; i++){
				if($('#reject_desc' + i).val() == "") {
					alert("반려사유는 필수입니다.");
					return;
				}
				var obj = {};										//obj = {key1: value1, key2: value2};
				obj.AS_NO = $('#rej_as_no' + i).html() ; 			//obj객체에 key/value 추가
				obj.REJECT_DESC = $('#reject_desc' + i).val() ;
				arrayObj[arrayObj.length] = obj;					//만든 obj를 arrayObj 배열에 추가
			}
			var dataObj = {};
			dataObj.DATA_LIST = JSON.stringify(arrayObj);			//dataObj객체에 DATA_LIST라는 key이름으로 arrayObj 배열을 값으로 담음  
																	//JSON.stringify() :JavaScript 값을 JSON문자열로 변환
																	
			$.ajax({
				type : 'post' ,
				url : '/ad/code/reject.do' , 
				data : dataObj ,
				dataType : 'json' , 
				statusCode : {
					403:function(data){
						alert("권한이 없습니다.");
					},
					404:function(data){
						alert('해당 페이지가 존재하지 않습니다.');
					}
				}, 
				success : function(data){
					
					var returnCode = typeof data.returnCode != "undefined" ? common.nvl(data.returnCode , "1000") : "1000" ; 
					var msg = "" ; 
					
					if(returnCode == "400") msg = "처리도중 오류가 발생했습니다." ;
					else msg = "정상적으로 처리 되었습니다." ; 
					
					alert(msg) ;
					$("#rejectListLayer").hide();
					initForm();
					
				}
			}) ;
																	
			
		}
		
		
			
		
	}
	
	function cancel(){
		var f = document.listFrm ; 
		f.cntdata.value = cntdata ; 
		var cnt = cntdata;
		asNoSave = "";
		for(var i = 1 ; i <= cntdata ; i++){
			if($('#chk' + i).is(":checked")){
				// 미결 = 'N'
				if($('#appr_yn' + i).html() == '미결'){
					alert("결재 화면에서 취소를 진행해 주세요");
					return;
				}
				if(asNoSave == "") asNoSave = $('#as_no' + i).html() ; 
	 			else asNoSave = asNoSave + "@" + $('#as_no' + i).html() ;
			}
		}
		if(asNoSave == ""){
			alert("작업할 자료를 선택해주세요");
			return;
		} else {
			f.asNoSave.value = asNoSave ; 
			$.ajax({
				type : 'post' ,
				url : '/ad/code/cancel.do' , 
				data : $('form[name=listFrm]').serialize() ,
				dataType : 'json' , 
				statusCode : {
					403:function(data){
						alert("권한이 없습니다.");
					},
					404:function(data){
						alert('해당 페이지가 존재하지 않습니다.');
					}
				}, 
				success : function(data){
					
					var returnCode = typeof data.returnCode != "undefined" ? common.nvl(data.returnCode , "1000") : "1000" ; 
					var msg = "" ; 
					
					if(returnCode == "400") msg = "처리도중 오류가 발생했습니다." ;
					else msg = "정상적으로 처리 되었습니다." ; 
					
					alert(msg) ;
					initForm();
					
				}
			}) ; 
		}
	}
	
	function goForm(pageType , as_no){
		var f = document.listFrm ; 

		var cnt = 0 ; 
		var chkVal = "" ;
		
		$("input[name=chk]:checked").each(function() { //작업을 체크했을 때 체크한 개수를 1개 늘려줌
			cnt++ ;  
			chkVal = $(this).val() ; 
		});
		//cnt는 작업들 중 체크한 개수를 의미
		if(pageType == 'subInsert'){//'하위작접 생성' 버튼을 클릭했을 때
			
			if(cnt == 0){//체크한 작업의 개수가 0개일 때
				alert('상위 작업을 선택해 주세요.');
				return;
			}
			
			if(cnt > 1){//체크한 작업의 개수가 1개 보다 많을 때
				alert('하위작업은 하나의 접수건만 선택할 수 있습니다.');
				return;
			}
			
			if (chkVal.split('@')[1] != '') { //해당 코드는 "@" 문자 이후에 문자열이 있을 경우 하위 작업을 생성할 수 없음을 알리는 경고 메시지를 출력하고, 함수의 실행을 중지하는 역할을 함
				alert('해당 건에서는 하위작업을 생성할 수 없습니다.');
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
		
	
</script>

<body onload="pageStart()">
<div class="tit_wrap" >
	<%= CommonExecute.returnLineMap(request) %>
	
</div>

<form name="listFrm" id="listFrm" method="get" >
	<input type="hidden" name="pageType" id="pageType" value=""/>
	<input type="hidden" name="cntdata" id="cntdata" value=""/>
	<input type="hidden" name="asNoSave" id="asNoSave" value=""/>
	<input type="hidden" name="cn_as_no" id="cn_as_no" value=""/>
	<input type="hidden" name="current_file" id="current_file" value="" />
	<input type="hidden" name="as_no" id="as_no" value=""/>
	<input type="hidden" name="page" id="page" value="${ vo.page }" />

	<table class="sType mgb10" >
		<caption>A/S 접수 리스트 검색</caption>
		<colgroup>
			<col style="width:50px;" />
			<col style="width:100px;" />
			<col style="width:50px;" />
			<col style="width:275px;" />
			<col style="width:50px;" />
			<col style="width:135px;" />
		</colgroup>
		<tbody id="asSearchTbody">
			<tr> 
				<th scope="row">처리상태</th> 
				<td> 
					<select name="search_type1" id="search_type1" title="처리상태 선택"></select> 
				</td> 
				<th scope="row">접수일자</th> 
				<td> 
					<input type="checkbox" name="search_type2" id="search_type2" value="Y" class="mgr5">
					<input type="text" name="search_start" id="search_start" title="접수일 입력" class="w135 mgr2" value="" readonly="readonly"/> 
					<input type="text" name="search_end" id="search_end" title="접수일 입력" class="w135 mgl10 mgr2" value="" readonly="readonly"/> 
				</td> 
				<th scope="row">조회조건 </th> 
				<td> 
					미결
					<input type="radio" id="state_chk1" name="state_chk" value="A" style="margin-right:5px;">
					결재
					<input type="radio" id="state_chk2" name="state_chk" value="B" style="margin-right:5px;">
					전체
					<input type="radio" id="state_chk3" name="state_chk" value="C" style="margin-right:5px;">
				</td>
			</tr>
		</tbody>
		
	</table>
	<div class="info_upper mgb5" >
		<div class="floatR">
			<button type="button" class="btn_ico_search" onclick="javascript:getAsList(1);" ><span>조회</span></button>
			<button type="button" class="btn_ico_confirm" onclick="javascript:approve();" ><span>결재</span></button>
			<button type="button" class="btn_ico_delete dgray " onclick="reject();" ><span>부결</span></button>
			<button type="button" class="btn_ico_delete dgray" onclick="cancel();"><span>취소</span></button>
		</div>
	</div>
	<div class="info_upper mgb5">
		<div class="sorting">
			조회건수 : <strong><span class="count" id="count">0</span> 건</strong>
		</div>
		<div class="floatR">
		<c:if test="${roleList.get(0).role_code ne '02_JWH_USER'}">
			<button type="button" class="btn_ico_confirm w115" onclick="javascript:goForm('insert', '');"><span>신규작업 등록</span></button>
		</c:if>
			<select id="pageSize" name="pageSize"  onchange="getAsList(1);" title="리스트 행 선택" class="w140">
				<option value="10">10개씩 노출</option>
				<option value="30">30개씩 노출</option>
				<option value="50">50개씩 노출</option>
			</select>
		</div>
	</div>
	
	<div style="overflow-x:auto;">
	<table class="hType mgb10 scroll-table" id="tableData">
		<caption>A/S 접수 목록</caption>
		<colgroup>
			<col style="width:30px" /><!-- 선택 -->
			<col style="width:80px" /><!--접수번호-->
			<col style="width:70px" /><!--승인여부-->
			<col style="width:70px" /><!--승인구분-->		
			<col style="width:70px" /><!--처리상태-->
			<col style="width:140px" /><!--거래처명-->
			
			<col style="width:70px" /><!--요청자-->
			
			<col style="width:150px" /><!--문의서비스-->
			
			<col style="width:70px" /><!--처리담당자-->
			
			<col style="width:300px" /><!--문의내용-->
			<col style="width:300px" /><!--조치내용-->
			
			<col style="width:60px" /><!--중요도-->
			<col style="width:100px" /><!--문의유형-->
			<col style="width:100px" /><!--접수경로-->
			
			<col style="width:70px" /><!--접수일-->
			<col style="width:70px" /><!--처리완료일-->
			<col style="width:55px" /><!--원인유형-->
			<col style="width:55px" /><!--조치유형-->
			<col style="width:70px" /><!--검수일-->
			<col style="width:60px" /><!--고객평가-->
			<col style="width:55px" /><!--신규답변-->
			
		</colgroup>
		<thead>
			<tr>
				<th scope="col">
					<input type="checkbox" name="checkall" id="checkall" >
				</th>
				<th scope="col">접수번호</th>
				<th scope="col">승인여부</th>
				<th scope="col">승인구분</th>			
				<th scope="col">처리상태</th>
				<th scope="col">거래처명</th>
				<th scope="col">요청자</th>
				<th scope="col">문의서비스</th>
				<th scope="col">처리담당자</th>
				<th scope="col">문의내용</th>
				<th scope="col">조치내용</th>
				<th scope="col">중요도</th>
				<th scope="col">문의유형</th>
				<th scope="col">접수경로</th>
				<th scope="col">접수일</th>
				<th scope="col">처리완료일</th>
				<th scope="col">원인유형</th>
				<th scope="col">조치유형</th>
				<th scope="col">검수일</th>
				<th scope="col">고객평가</th>
				<th scope="col">신규답변</th>
				
			</tr>
		</thead>
		<tbody id="asList"></tbody>
	</table>
	
	</div>
	<div class="page">
		<div id="pagination"></div>
	</div>
	
	<!-- 반려의견 작성 팝업 -->
	<div style="display:none;" id="rejectListLayer">
		<div class="box_layer layer_sms" style="height:fit-content;width:1120px;margin:-220px 0 0 -550px !important;">
			<h1>반려 처리</h1>
			<div class="layer_contents" style="padding-top:30px;height:fit-content;overflow-y:auto;">
				<table class="hType mgb20 hType2">
					<caption>반려사유 기입</caption>
					<colgroup>
						<col style="width:50px;" />
						<col style="width:80px;" />
						<col style="width:70px;" />
						<col style="width:100px;" />
						<col style="width:70px;" />
						<col style="width:150px;" />
						<col style="width:200px;" />
						<col style="width:300px;" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">NO</th>
							<th scope="col">접수번호</th>
							<th scope="col">접수일</th>
							<th scope="col">거래처명</th>
							<th scope="col">요청자</th>
							<th scope="col">문의서비스</th>
							<th scope="col">문의내용</th>
							<th scope="col">반려사유</th>
						</tr>
					</thead>
					<tbody id="rejectListBody">
					</tbody>
				</table>
				<div class="floatR">
				<button type="button" class="btn_ico_delete dgray" onclick="rejectProc()">부결</button>
				</div>
			</div>
			<button type="button" class="btn_close" onclick="$('#rejectListLayer').hide()">창 닫기</button>
		</div>
	</div>

</form>
<form name="answerForm" id="answerForm" method="post" enctype="multipart/form-data">
	<input type="hidden" name="w_content" />
	<input type="hidden" name="as_no" />
	<input type="hidden" name="seq" />
	<input type="hidden" name="pageType" />
</form>
</body>