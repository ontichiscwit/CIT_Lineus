<%@ page import="egovframework.com.comm.util.CommonExecute"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import ="java.util.List" %>
<%@ page import ="egovframework.com.comm.model.RoleVO" %>
<%
	/*세션-로그인한 사용자의 권한코드 가져오기*/
	List<RoleVO> roleList = (List<RoleVO>) session.getAttribute("roleList");
	String role_code = "";	//세션 권한코드
	
	for(int i=0; i<roleList.size(); i++){
		role_code += roleList.get(i).getRole_code() + " ";
	}

%>
<style>
	.status_bold {color:#0032c3 !important;font-weight:bold;}
	.scroll-table{width:1860px;;table-layout:auto;}
	.scroll-table tr:hover{background-color: #eef7f9 !important;}
	
</style>

<script type="text/javascript">
	
	var v_as_no = "" ; 
	var role_code = '<%=role_code%>';	
	var procSelect;
	var reg_name = '${adUserInfo.emp_nm }';	//로그인자 이름
	
	$(document).ready(function(){
		initForm();
		makeListData();
		
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
		
		
		var procSelectStr = '${ vo.procSelect }';
		var procSelectArray = procSelectStr.split(",");
		for(var i = 0 ; i < procMultiSelect.childElementCount ; i++){
			for(var j = 0 ; j < procSelectArray.length ; j++){
				if ($("#procMultiSelect").find('option').eq(i).val() == procSelectArray[j]){
					$("ul.options > li.opt").eq(i).addClass('selected');
					$("#procMultiSelect").find('option').eq(i).attr("selected","selected");
					$('span.placeholder').text(procSelectArray.length+" Selected");
				}
			}
				
		}
		
	}) ;
	
	function initForm(){
		
 		search_type(common.nvl('${ vo.search_gubun }','1')) ;
 		
 		//$("select[name='search_type1'] option[value='C006']").remove();
 		
 		commonCode.getCodeList('AS' , 'CD01' , 'search_type1') ;	//처리상태
		commonCode.getCodeList('AS' , 'CD07' , 'search_type6') ; 	//처리등급
		commonCode.getCodeList('AS' , 'CD05' , 'search_type2') ;	//원인유형
		commonCode.getCodeList('AS' , 'CD06' , 'search_type3') ;	//조치유형
		commonCode.getCodeList('AS' , 'CD04' , 'search_type9') ;	//중요도
		commonCode.getCodeList('CUST' , 'CD01' , 'search_type13') ;	//거래처구분
		commonCode.getCodeList('PROJECT' , 'PR02' , 'search_type7') ;	//시스템구분 
		commonCode.getCodeList('AS' , 'CD02' , 'search_type15') ;	//접수경로 
		commonCode.getCodeList('AS' , 'CD03' , 'search_type17') ; 	//문의유형		
		commonCode.getCodeList('AS' , 'CD01' , 'procMultiSelect') ; //처리상태2	
		
		
		
		$('#search_type8').append(commonCode.defaultViewOption); //업무유형 디폴트
		
		
		$( "#search_start" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#search_end" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		$( "#search_start2" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#search_end2" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
	
		$( "#search_start3" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#search_end3" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		$( "#search_start4" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#search_end4" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
	
		
		$( "#aw_search_start1" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#aw_search_end1" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		$( "#aw_search_start2" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#aw_search_end2" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		
		$('#search_type1').val('${ vo.search_type1 }');
		$('#search_type2').val('${ vo.search_type2 }');
		$('#search_type3').val('${ vo.search_type3 }');
		$('#search_type4').val('${ vo.search_type4 }');
		$('#search_type5').val('${ vo.search_type5 }');
		$('#search_type6').val('${ vo.search_type6 }');
		$('#search_type7').val('${ vo.search_type7 }');
		
		$('#search_type9').val('${ vo.search_type9 }');
		$('#search_type13').val('${ vo.search_type13 }');
		$('#search_type14').val('${ vo.search_type14 }');
		$('#search_type15').val('${ vo.search_type15 }');
		$('#search_type16').val('${ vo.search_type16 }');
		$('#search_type17').val('${ vo.search_type17 }');
		$('#procSelect').val('${ vo.procSelect }');
		
		if( $('#search_type7').val() !=''){
			commonCode.getCodeList('OPERATE' , $('#search_type7').val() , 'search_type8') ;	
		}
		
		$('#search_type8').val('${ vo.search_type8 }');
		
		var search_type10 = '${ vo.search_type10 }';
		(search_type10 == 'Y') ? $('#search_type10').prop('checked',true) : $('#search_type10').prop('checked',false);
		
		var search_type11 = '${ vo.search_type11 }';
		(search_type11 == 'Y') ? $('#search_type11').prop('checked',true) : $('#search_type11').prop('checked',false);
		
		var search_type12 = '${ vo.search_type12 }';
		(search_type12 == 'Y') ? $('#search_type12').prop('checked',true) : $('#search_type12').prop('checked',false);
		
		var search_type18 = '${ vo.search_type18 }';
		(search_type18 == 'Y') ? $('#search_type18').prop('checked',true) : $('#search_type18').prop('checked',false);
		
		if ('${ vo.search_start }' != '') $('#search_start').val('${ vo.search_start }');
		if ('${ vo.search_end }' != '') $('#search_end').val('${ vo.search_end }');
		
		if ('${ vo.search_start2 }' != '') $('#search_start2').val('${ vo.search_start2 }');
		if ('${ vo.search_end2 }' != '') $('#search_end2').val('${ vo.search_end2 }');
		
		
		if ('${ vo.search_start3 }' != '') $('#search_start3').val('${ vo.search_start3 }');
		if ('${ vo.search_end3 }' != '') $('#search_end3').val('${ vo.search_end3 }');
		
		if ('${ vo.search_start4 }' != '') $('#search_start4').val('${ vo.search_start4 }');
		if ('${ vo.search_end4 }' != '') $('#search_end4').val('${ vo.search_end4 }');
		
		
		$('#search_text').val('${ vo.search_text }');
		$('#page').val('${ vo.page}') ;
		$('#pageSize').val('${ vo.pageSize}') ;
		
		/*2022.06.28.이설아	JW홀딩스사용자가 추가됨. JW홀딩스사용자는 JW그룹 AS건만 조회할 수 있다*/
		if(role_code.includes("02_JWH_USER")){
			$('#search_type13').val('C001');
			$('#search_type13').prop('disabled',true);
		}
		
		/*2022.03.07.이설아	외부사용자가 추가됨. 외부사용자는 본인이 유지보수담당자인 AS건만 조회할 수 있다*/
		if(role_code.includes("05_EXTERNAL_USER") ){
			$('#search_type14').val(reg_name);
			$('#search_type14').prop('disabled',true);
			$('#search_type14').css({"color" : "gray"});
		}
		
		//Enter 검색 기능
		$("#search_text").keyup(function(e){if(e.keyCode == 13)  getAsList(1); });
		$("#search_type4").keyup(function(e){if(e.keyCode == 13)  getAsList(1); });
		$("#search_type5").keyup(function(e){if(e.keyCode == 13)  getAsList(1); });
		$("#search_type14").keyup(function(e){if(e.keyCode == 13)  getAsList(1); });
		$("#search_type16").keyup(function(e){if(e.keyCode == 13)  getAsList(1); });
		
		
	}
	
	function search_type(gubun){
		
		if (gubun == "1"){
			$(".highLevelSearch").hide();
		}else{
			$(".highLevelSearch").show();
		}
		
		$("#search_gubun").val(gubun).prop("selected", true);
	}
	
	function setSystem_type(thisObj){
		$('#search_type8').empty() ; 
		
		if(thisObj != ""){
			commonCode.getCodeList('OPERATE' , thisObj , 'search_type8') ;
		}else{
			$('#search_type8').append(commonCode.defaultOption);	
			
		}
	}

	function searchReset() { //A/S관리-'초기화'버튼
 		document.listFrm.reset() ; //해당 코드는 HTML 폼의 입력 값들을 초기화하여 기본값으로 설정하는 기능을 수행
 		$( "#search_start" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);//접수일 초기화
		$( "#search_end" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		$( "#search_start2" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);//처리완료 시작일 초기화
		$( "#search_end2" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		$( "#search_start3" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);//처리 요청일 초기화
		$( "#search_end3" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		
		$( "#search_complete_start" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#search_complete_end" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
	}
	
	
	function getAsList(pageIndex) {					//페이지이동-이벤트사용
		var val = procSelect.sumo.getSelStr();
		$( "#procSelect" ).val(val);
		
		var f = document.listFrm ;					
		f.page.value = pageIndex ; 					//넘기고 싶은 값
		f.target = '' ; 							//폼의 타겟 지정 
		f.action = '/ad/as/list.do' ; 				//이동할페이지 			
		f.submit() ; 
	}
	
	function makeListData() {
		$('#search_type13').prop('disabled',false);
		$('#search_type14').prop('disabled',false);
		common.ajaxCall($('form[name=listFrm]').serialize(), '/ad/as/getAsList.do', 'setAsList') ;	//serialize() :form안에 값들을 한 번에 전송 가능한 data로 만들어 줌
		
	}
	
	function escapeHtml(text) {
	    return text.replace(/&/g, "&amp;")
	               .replace(/</g, "&lt;")
	               .replace(/>/g, "&gt;")
	               .replace(/"/g, "&quot;")
	               .replace(/'/g, "&#039;");
	}
		
	function setAsList(data) {
		$('#asList').empty();
		
		if(role_code.includes("02_JWH_USER")){
			$('#search_type13').val('C001'); //거래처 구분 : JW그룹(C001)
			$('#search_type13').prop('disabled',true);
		}
		
		if(role_code.includes("05_EXTERNAL_USER") ){
			$('#search_type14').val(reg_name);//처리 담당자명 : 관리자
			$('#search_type14').prop('disabled',true);
		}
		
		var resultList = typeof data.resultList != 'undefined' ? data.resultList : null;
		var vo = typeof data.vo != 'undefined' ? data.vo : null;
		
		if (resultList != null && resultList.length > 0) { //조회건수가 1건 이상 있는 경우
			
			
			var toggle = true;
			var prevAsNo = "0";
			
			var str = '' ; 
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ; 
				
				
				
				var chkAsNo = common.nvl(datas.cn_as_no, '') != '' ? datas.cn_as_no: datas.as_no; /* 체크박스 */ 
				if (prevAsNo != chkAsNo){
					prevAsNo = chkAsNo;
					toggle = toggle ? false : true;
				}
				
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
				//처리요청일 날짜를 형식에 맞게 셋팅
				var vInquiryDt = "-";
				if (common.nvl(datas.inquiry_dt, '').length == 8){
					vInquiryDt = makeDate(datas.inquiry_dt,"-");
		 		}
				
				
				// 검수일 날짜를 조정
				var vStateDate = common.nvl(datas.star_state_date, '-');  
				if (vStateDate.length > 10) vStateDate = vStateDate.substr(0,10);
				
				
				// 배포승인일시 형식에 맞게 셋팅
				var vAppr_date2 = "-";
				if (common.nvl(datas.appr_date2, '').length == 8){
					vAppr_date2 = makeDate(datas.appr_date2,"-");
		 		}
				var vApprDt =  vAppr_date2 + "<br>" + common.nvl(datas.appr_time2, '') ;   
				
				/* 접수번호 */
				if(common.nvl(datas.cn_as_no, '') == "" ) str += '<tr onclick="goView(\'update\' , \''+common.nvl(datas.as_no , '')+'\', \''+common.nvl(datas.cn_as_no , '')+'\');" style="cursor:pointer;background-color:'+(toggle ? "#f8fafb" : "#ffffff")+'"> ' ;
				else str += '<tr onclick="goView(\'subUpdate\' , \''+common.nvl(datas.as_no , '')+'\', \''+common.nvl(datas.cn_as_no , '')+'\');" style="cursor:pointer;background-color:'+(toggle ? "#f8fafb" : "#ffffff")+'"> ' ;
				str += '		<td onclick=\'event.cancelBubble=true;\'><input type="checkbox" title="거래선택" name="chk" value="'+common.nvl(datas.as_no, '')+'@'+common.nvl(datas.cn_as_no, '')+'"/></td> ' ;
				if (common.nvl(datas.cn_as_no, '') != '') {
					//하위건
					str += '		<td>'+common.nvl(datas.as_no, '')+'</td> ' ;	//2021.06.08 
					str += '		<td style="display:none;">'+common.nvl(datas.cn_as_no, '')+'</td> ' ;
				} else {
					//원건
					str += '		<td>'+common.nvl(datas.as_no, '')+'</td> ' ;	
					str += '		<td style="display:none;">-</td> ' ;
				}
				
				
				/* 처리상태 */
				if( common.nvl(datas.proc_status, '') == "C001" ){
					str += '		<td class="status_bold">'+common.nvl(datas.proc_status_nm, '')+'</td> ' ;
				}else{
					str += '		<td>'+common.nvl(datas.proc_status_nm, '')+'</td> ' ;
				}
				
				
				/* 거래처 코드_거래처명 */
				str += '		<td class="textL">['+common.nvl(datas.cust_code, '')+']'+common.nvl(datas.cust_kor_name,'')+'</td> ' ;
				
				/* 요청자명 */
				str += '		<td>'+common.nvl(datas.apply_nm, '')+'</td> ' ;
				
				
				/* 문의서비스 */
				str += '		<td >'+common.nvl(datas.system_type_nm, '')+'/'+common.nvl(datas.inquiry_type_nm, '')+'</td> ' ;
				/* 중요도 */
				if (common.nvl(datas.inportance_nm, '') != '') {
					if (common.nvl(datas.inportance, '') == 'C001') str += '		<td><span class="emergency"></span>'+common.nvl(datas.inportance_nm, '')+'</td> ' ;
					else str += '		<td><span class="emergency-non"></span>'+common.nvl(datas.inportance_nm, '')+'</td> ' ;					
				} else {
					str += '		<td>-</td> ' ;
				}
				
				/* 처리담당자 */
				str += '		<td>'+common.nvl(datas.emp_nm , '')+'</td> ' ;
				
				/* 처리요청일 */
				str += '		<td>'+vInquiryDt+'</td> ' ;
				
				
				/* 접수경로 */
				str += '		<td>'+common.nvl(datas.accept_route_nm , '')+'</td> ' ;
				
				//2025.03.19  마우스 호버 시능 추가
				/* 문의내용 */
				str += '<td title="'+ escapeHtml(common.nvl(datas.call_content, '')) +'" class="textL">' + datas.call_content.substr(0 , 33) +'</td> ' ;
				/* 조치내용 */
				str += '<td class="textL">' + datas.action_content.substr(0 , 33) +'</td> ' ;
				
				/* 접수일 */
				str += '		<td>'+vAcceptDt+'</td> ' ;
				/* 처리완료일 */
				str += '		<td>'+vCompleteDt+'</td> ' ;
				
				/* 예상작업시간 */
				if(common.nvl(datas.expected_work_time, '') != '') str += '		<td>' +common.nvl(datas.expected_work_time, '')+ '</td>';
				else 	str += '		<td>' +common.nvl(datas.expected_work_time, '')+ '</td>';
				
				/* 진행률 */
				str += '		<td>' +common.nvl(datas.progress_rate, '')+ '</td>';
				
				/* 대상 프로젝트 */
				str += '<td class="textL">' + datas.target_project.substr(0 , 33) +'</td> ' ;

				/* 작업시간 */
				if(common.nvl(datas.work_time, '') != '') str += '		<td>' +common.nvl(datas.work_time, '')+ '</td>';
				else 	str += '		<td>' +common.nvl(datas.work_time, '')+ '</td>';
				
				/* 원인유형 */
				if(common.nvl(datas.cause_type_nm, '') != '') str += '		<td title="'+datas.cause_type_nm+'">'+datas.cause_type_nm.substr(0 , 3)+'</td> ' ;
				else  str += '		<td>-</td> ' ;
				/* 조치유형 */
				str += '		<td>'+common.nvl(datas.action_type_nm, '')+'</td> ' ;
				
/* 				//검수일
				str += '		<td>'+vStateDate+'</td> ' ;
				
				// 고객평가★ 
				var starCnt = common.nvl(datas.star_state, '');
				var starText = '';
				if (starCnt == 1) starText = '★☆☆☆☆';
				else if (starCnt == 2) starText = '★★☆☆☆';
				else if (starCnt == 3) starText = '★★★☆☆';
				else if (starCnt == 4) starText = '★★★★☆';
				else if (starCnt == 5) starText = '★★★★★';
				else starText = '-';
				if(starText != "-") str += '		<td class="colorRed">'+starText+'</td> ' ;
				else str += '<td>'+starText+'</td> ' ; */
				
				/*배포승인일시*/
				str += '		<td>'+vApprDt+'</td> ' ;
				
				/* 끝tr */
				str += '</tr> ' ;
			}
			
			$('#asList').append(str);	
			$('#count').html(numberWithCommas(vo.rowCnt)); 
			$("#pagination").html(vo.json_paging);
			
		} else { //조회건수가 0건인 경우
			commonTable.notData(17,"조회된 데이터가 없습니다.","asList");
			$('#count').html('0');
			$("#pagination").html('');
		}
	}
	
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
	
	function awsProcReturn(resultCode){
		
		if(resultCode == "000"){
			alert('정상처리 되었습니다.') ; $('#w_content').val('');  awsList(1 , v_as_no) ; 
		}else{
			alert('처리도중 오류가 발생했습니다.') ; return ; 
		}
	}
	
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
	
	function goExl() {
		
		var totalCnt = Number($('#count').html().replace(",",""));//네자리 값마다 있는 ',' 제거 후의 값을 totalCnt 변수에 대입'
	
		if(totalCnt == 0){//조회 건수가 0건일 경우
			alert("출력 가능한 데이터가 없습니다.") ; 
			return ;
			
		}else{
			$('#search_type13').prop('disabled',false);
			$('#search_type14').prop('disabled',false);
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
	
	function goView(pageType , as_no, cn_as_no){
		var f = document.listFrm ; 
		
		f.pageType.value = pageType ; 
		f.as_no.value = as_no ; 
		f.cn_as_no.value = cn_as_no ; 
		
		f.current_file.value = 'list';
		
		f.target = '' ; 
		f.action = '/ad/as/form.do' ; 
		f.submit() ; 
	}
	
	function delAsProc() {
		var as_no = '';
		var cn_as_no = '';
		var del_as_no = '';
		
		$("input[name=chk]:checked").each(function() {
			chkVal = $(this).val() ;
			as_no = chkVal.split('@')[0];
			
			if (del_as_no == '') del_as_no = as_no;
			else del_as_no = del_as_no + "@"+ as_no;
			
		});
		
		if (common.nvl(del_as_no,'') != '') {
			var delText = (cn_as_no == '') ? '하위 작업 모두 삭제 됩니다.\n선택된 A/S를 삭제 하시겠습니까?' : '선택된 A/S를 삭제하시겠습니까?';
			
			if (confirm(delText)) {
				var datas = {
						'del_as_no' : del_as_no 
				}
				common.ajaxCall(datas , '/ad/as/delProc.do', 'delProcReturn') ;
			}
		}
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
		location.href = "/ad/as/form.do" + queryString;
	}

	/*job scheduler 수동실행*/
	function schedulerTrigger(){
		/* 
		var f = document.listFrm ; 
		f.target = '' ; 
		f.action = '/ad/as/schedulerTrigger.do' ; 
		f.submit() ;  
		*/
		if(confirm('JW그룹웨어 전자의뢰서는 10분마다 자동 업데이트됩니다.\n수동으로 불러오기를 진행하시겠습니까?')){
			common.ajaxCall($('form[name=listFrm]').serialize(), '/ad/as/schedulerTrigger.do', 'ReturnSchedulerTrigger') ;
		}
	}
	
	function ReturnSchedulerTrigger(data){
		var resultCode = typeof data.resultCode != "undefined" ? data.resultCode : null ; 
		
		if(resultCode == "000"){
			alert('정상처리 되었습니다.') ; 
			getAsList(1);
		}else{
			alert('처리도중 오류가 발생했습니다.') ; return ; 
		}
	}
	
	var expanded = false;

</script>


<div class="tit_wrap">
	<%= CommonExecute.returnLineMap(request) %>
	
</div>

<form name="listFrm" id="listFrm" method="get">
<input type="hidden" name="pageType" id="pageType" value=""/>
<input type="hidden" name="as_no" id="as_no" value=""/>
<input type="hidden" name="cn_as_no" id="cn_as_no" value=""/>
<input type="hidden" name="current_file" id="current_file" value="" />
<input type="hidden" name="page" id="page" value="${ vo.page }" />
<input type="hidden" name="procSelect" id="procSelect" value="" />
<div class="tit_sWrap">

<div class="ico_s_modify">
<span class="tit_gray" onclick="javascript:btnAnswer();">A/S 답변 조회 팝업</span>
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
			<td>
				<select id="procMultiSelect" class="procMultiSelect" multiple data-max="2">
				</select>
			</td>
			<th scope="row">접수번호</th> 
			<td> 
				<input type="text" name="search_type4" id="search_type4" title="접수번호 입력"  > 
			</td>
			<th scope="row">중요도</th> 
			<td> 
				<select name="search_type9" id="search_type9" title="중요도 선택" class=""></select> 
			</td>
		</tr>
		
		<tr>
			<th scope="row">거래처구분</th> 
			<td> 
				<select name="search_type13" id="search_type13" title="거래처구분 선택"></select> 
			</td>
			<th scope="row">거래처명/코드</th> 
			<td> 
				<input type="text" name="search_type5" id="search_type5" title="거래처명 입력" class="" > 
			</td>
			<th scope="row">문의유형</th>
			<td>
				<select name="search_type17" id="search_type17" title="문의유형 선택"></select>
			</td>
			
		</tr>
		
		<tr>
			<th scope="row">처리담당자명</th> 
			<td> 
				<input type="text" name="search_type14" id="search_type14" title="처리담당자 입력" > 
			</td>
			<th scope="row">부서명</th> 
			<td colspan="3"> 
				<input type="text" name="search_type16" id="search_type16" title="부서명" class="" > 
			</td>
		</tr>
		
		<tr>
			<th scope="row">시스템/업무유형</th> 
			<td> 
				<select name="search_type7" id="search_type7" title="문의유형1 선택" class="w100 mgr2" onchange="setSystem_type(this.value);"></select> 
				<select name="search_type8" id="search_type8" title="문의유형2 선택" class="w100" ></select> 
			</td> 
			 
			<th scope="row">접수일자</th> 
			<td colspan="3"> 
				<input type="checkbox" name="search_type10" id="search_type10" value="Y" class="mgr5">
				<input type="text" name="search_start" id="search_start" title="접수일 입력" class="w135 mgr2" value=""  readonly="readonly"/> 
				<input type="text" name="search_end" id="search_end" title="접수일 입력" class="w135 mgl10 mgr2" value="" readonly="readonly"/> 
			</td> 
		</tr> 
		
		<tr>
			<th scope="row">원인/조치유형</th> 
			<td> 
				<select name="search_type2" id="search_type2" title="원인유형1 선택"  class="w100 mgr2"></select>
				<select name="search_type3" id="search_type3" title="조치유형 선택" class="w100"></select> 
			</td>
			
			<!-- 2022.01.19.  
			<th>처리요청일</th> 
			<td colspan="3"> 
				<input type="checkbox" name="search_type12" id="search_type12" value="Y" class="mgr5">
				<input type="text" name="search_start3" id="search_start3" title="처리요청일 입력" class="w135 mgr2" value=""  readonly="readonly"/> 
				<input type="text" name="search_end3" id="search_end3" title="처리요청일 입력" class="w135 mgl10 mgr2" value="" readonly="readonly"/> 
			</td>
			-->
			<th>배포승인일자</th> 
			<td colspan="3"> 
				<input type="checkbox" name="search_type18" id="search_type18" value="Y" class="mgr5">
				<input type="text" name="search_start4" id="search_start4" title="배포승인일 입력" class="w135 mgr2" value=""  readonly="readonly"/> 
				<input type="text" name="search_end4" id="search_end4" title="배포승인일 입력" class="w135 mgl10 mgr2" value="" readonly="readonly"/> 
			</td>
			
		</tr>	
	
		<tr class="highLevelSearch"> 
			<th>접수경로/처리등급</th> 
			<td> 
				<select class="w100 mgr2" name="search_type15" id="search_type15" title="접수경로 선택"></select> 
				<select class="w100" name="search_type6" id="search_type6" title="처리등급 선택"></select> 
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
				<input type="text" placeholder="접수번호  /거래처명  /거래처코드  /처리담당자명  /요청자명  /접수내용 /처리내용/빌드순번/CTS빌드" name="search_text" id="search_text" class="w630 mgr10"  style="ime-mode:active;"  title="통합 검색 키워드 입력" />
				<button type="button" class="btn_ico_reset mgr5" onclick="searchReset();"><span>초기화</span></button>
				<button type="button" class="btn_ico_search mgr5" onclick="getAsList(1);"><span>검색</span></button> 
			</td> 
		</tr> 
	</tbody>
	
</table>
<div class="info_upper mgb5">
	<div class="sorting">
		조회건수 : <strong><span class="count" id="count">0</span> 건</strong>
	</div>
	<div class="floatR">
		<c:if test="${roleList.get(0).role_code ne '02_JWH_USER'}">
			<button type="button" class="btn_ico_confirm w115" onclick="javascript:goForm('insert', '');"><span>신규작업 등록</span></button>
		</c:if>
		<button type="button" class="btn_ico_excel" onclick="goExl();"><span>엑셀다운로드</span></button>
		<select id="pageSize" name="pageSize" onchange="getAsList(1);" title="리스트 행 선택" class="w140">
			<option value="10">10개씩 노출</option>
			<option value="30">30개씩 노출</option>
			<option value="50">50개씩 노출</option>
		</select>
	</div>
</div>

<div style="overflow-x:auto;">
<table class="hType mgb10 scroll-table" >
	<caption>A/S 접수 목록</caption>
	<colgroup>
		<col style="width:30px" /><!-- 선택 -->
		<col style="width:80px" /><!-- 접수번호 -->
		<col style="width:80px ; display:none;" /><!-- 하위작업 -->
		<col style="width:70px" /><!-- 처리상태 -->
		<col style="width:auto" /><!-- 거래처명 -->
		
		<col style="width:70px" /><!-- 요청자 -->
		
		<col style="width:150px" /><!-- 문의서비스 -->
		<col style="width:60px" /><!-- 중요도 -->
		<col style="width:70px" /><!-- 처리담당자 -->
		<col style="width:90px" /><!-- 처리요청일자 -->
		
		<col style="width:100px" /><!-- 접수경로 -->
		
		
		<col style="width:180px" /><!-- 문의내용 -->
		<col style="width:180px" /><!-- 조치내용 -->
		<col style="width:70px" /><!-- 접수일 -->
		<col style="width:80px" /><!-- 처리완료일 -->
		<col style="width:80px" /><!-- 예상작업시간 -->
		<col style="width:50px" /><!-- 진행률 -->
		<col style="width:100px" /><!-- 대상 프로젝트 -->
		<col style="width:50px" /><!-- 작업시간 -->
		<col style="width:50px" /><!-- 원인유형 -->
		<col style="width:50px" /><!-- 조치유형 -->
		<col style="width:100px" /><!-- 배포승인일시 -->
		
	</colgroup>
	<thead>
		<tr>
			<th scope="col">선택</th>
			<th scope="col">접수번호</th>
			<th scope="col" style="display:none;">하위작업</th>
			<th scope="col">처리상태</th>
			<th scope="col">거래처명</th>
			
			<th scope="col">요청자</th>
			
			<th scope="col">문의서비스</th>
			<th scope="col">중요도</th>
			<th scope="col">처리담당자</th>
			<th scope="col">처리요청일자</th>
			
			<th scope="col">접수경로</th>
			
			
			<th scope="col">문의내용</th>
			<th scope="col">조치내용</th>
			<th scope="col">접수일</th>
			<th scope="col">처리완료일자</th>
			<th scope="col">예상작업시간</th>
			<th scope="col">진행률</th>
			<th scope="col">대상프로젝트</th>
			<th scope="col">작업시간</th>
			<th scope="col">원인유형</th>
			<th scope="col">조치유형</th>
			<th scope="col">배포승인일시</th>
			
		</tr>
	</thead>
	<tbody id="asList"></tbody>
</table>

</div>
<div class="page">
	<div class="btn_left">
	 	<c:if test="${roleList.get(0).role_code ne '02_JWH_USER'}">
			<button type="button" class="btn_ico_confirm w140" onclick="javascript:schedulerTrigger();"><span>JW그룹웨어 연동하기</span></button>
			<!-- <button type="button" class="btn_ico_confirm w120" onclick="javascript:goForm('subInsert', '');"><span>하위작업 등록</span></button> -->
		</c:if>
		
		<!-- <button type="button" class="btn_ico_confirm w115" onclick="javascript:goForm('insert', '');"><span>신규작업 등록</span></button> -->
	</div>
	<div id="pagination"></div>
	<!-- <div class="btn_right">
		<button type="button" class="btn_ico_delete" onclick="delAsProc();"><span>삭제</span></button>
	</div> -->
</div>

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
	        
           </div>
           <!-- //wrap  --> 
	</div>
	<button type="button" class="btn_close" onclick="btnAnswerClose();">창 닫기</button>
</div>
<div class="layer_dimmed" id="dim_answer" style="display:none;"></div>


</form>
<form name="answerForm" id="answerForm" method="post" enctype="multipart/form-data">
<input type="hidden" name="w_content" />
<input type="hidden" name="as_no" />
<input type="hidden" name="seq" />
<input type="hidden" name="pageType" />
</form>