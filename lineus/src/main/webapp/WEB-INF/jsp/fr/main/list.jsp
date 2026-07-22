<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="egovframework.com.comm.util.DateTimeUtil"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="egovframework.com.comm.util.DateTimeUtil"%>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<script type="text/javascript" src="js/jquery.tooltip.js"></script>


<script type="text/javascript">
	var myAsList;
	var crmAsList;

	google.charts.load('current', {'packages':['line']});

	var recentNoticeList;
	var notReadNoticeList;
	var asGraphList;

	$(document).ready(
		function() {
			
			var searchStart = "${ vo.str_dt }";
			
			$("#search_start" ).val(searchStart).datepicker(datepicker);
			$("#search_end" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
			$("#search_start2" ).val(searchStart).datepicker(datepicker);
			$("#search_end2" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
			
			
			$("#search_start3" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
			$("#search_end3" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
			
			$("#search_start4" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
			$("#search_end4" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
			
			
			$('.ui-datepicker-trigger').css('cursor','pointer');
		
			common.ajaxCall('', '/fr/notice/getRecentList.do','setRecentNoticeList');		//공지사항 -최근공지
			common.ajaxCall('', '/fr/notice/getNotReadList.do','setNotReadNoticeList');		//공지사항 -읽지않은공지
			changeNoticeData("noticeTab1");
	
			setMyAsStatus( $("#search_start" ).val(), $("#search_end" ).val() );
			setCrmAsStatus( $("#search_start" ).val(), $("#search_end" ).val() );
			
			common.ajaxCall('', '/fr/main/getAsGraph.do','setAsGraph');
			
			changeSearch1();
			changeSearch2();
			changeSearch3();
			changeSearch4();
			
			var datas = {'cust_code' : $('#cust_code').val() }
			common.ajaxCall(datas, '/fr/main/getTodayAnswerCnt.do','setAsAnswerTodayCnt');
			common.ajaxCall(datas, '/fr/main/getTodayAnswer.do','setAsAnswerTodayList');
			
			getMybadgeCount();
			$('.left').tooltip({align: 'left'});

		});
	
	
	
	function getAnswerListbyRecent(){
		
		var datas ={
				'asw_str_dt' :  $("#search_start3" ).val(),
				'asw_end_dt' :  $("#search_end3" ).val(),
				'answerGubunFlag' : "2",
				'cust_code' : $('#cust_code').val(),
				'user_id' : $("#user_id").val()
		}
		
		console.log(datas.answerGubunFlag);
		common.ajaxCall(datas, '/fr/main/getAnswerListbyRecent.do','setAnswerListbyRecent');
	}
	
	
	function setAnswerListbyRecent(data){
		
		$('#answer-box').empty();
		var result = data.resultList != "undefined" ? data.resultList : null;
		
		
		if(result.length == 0 || result == null  ){
			var str ='<div class="tit_wrap" style="text-align:center; margin-left: auto;margin-right: auto;display: table;"><h2> 해당 날짜의 답변이 없습니다.<br> 다시 조회해 주세요. </h2></div>';
		
		}else if(result.length > 0 ){ 
			var str ='';
		
		
			for(var i =0 ; i < result.length; i++){
				var val = result[i]; 
				
				str += '<div class="db-greybox mgb20" onclick="goAsDetail(\''+ val.AS_NO +'\')" style=\"cursor:pointer;\" >';
				if(val.TODAY_GUBUN == '1'){
					str += '<div class="pos1" style="width:40px;height:40px; position:absolute; top:-15px; left:-15px;"></div>';
				}else if(val.TODAY_GUBUN == '0'){
					str += '<div class="pos2" style="width:40px;height:40px; position:absolute; top:-15px; left:-15px;"></div>';
				}
				str += '<table class="db-answer">';
				str += '<tr>';
				str += '<td colspan="2" style="font-size: 14px;color:#797979;font-weight: 600;">'+ common.nvl(val.W_DATE,'') +'</td>';
				str += '<td colspan="2" class="textR mgb5" style="font-size: 14px;color: #0090c8;font-weight: 700;">AS접수번호 ' + common.nvl(val.AS_NO,'') +'</td>';
				str += '</tr>';
				str += '<tr>';
				str += '<td colspan="4" style="padding-bottom:5px;padding-top: 5px; border-bottom: 1px solid #dedede !important;">';
				str += '[요청] ' + common.nvl(val.CALL_CONTENT,'') + ' -' +common.nvl(val.APPLY_NM,'') + '</td>';
				str += '</tr>';
				str += '<tr>';
				str += '<td colspan="4" style="padding-bottom:5px;padding-top: 5px;">[답변] ' + common.nvl(val.W_CONTENT,'') + ' -' + common.nvl(val.W_NM,'') +'</td>';
				str += '</tr>';
				str += '</table>';
				str += '</div>';
				
			}
		}
		$('#answer-box').html(str);
		
	}
	
	
	
	function setAsAnswerTodayCnt(data){
		
		var result = data.resultList != "undefined" ? data.resultList : null;
		if( result == null || result.length == 0  ){
			$('#answerCnt').text("0건");
		}else{
			$('#answerCnt').text(data.resultList[0].TODAY_CNT + "건");
		}
	}
	
	function setAsAnswerTodayList(data){
		$('#notiUL').empty() ;
		
		var result = data.resultList != "undefined" ? data.resultList : null;
		if(result.length > 0 ) var str ='';
		for(var i =0 ; i < result.length; i++){
			var content = result[i].W_CONTENT.substring(0,20);
			str += '<li style="line-height:34px;" onclick="goAsDetail(\''+ result[i].AS_NO +'\')" >';
			str += '<img src="/images/front/icon_chat_02.png" class="valignM mgr5">';
			str += '<span class="an_apply_nm"> ['+result[i].APPLY_NM+' 님의 AS건]</span>';
			str += '<a href="javascript:goAsAnswerView();" class="an-title">' + content + '.. </a>';
			
			if( result[i].ATTACH_SEQ != '0' ){
				str += '<button type="button" class="btn_download_blue"><span>다운로드</span></button>';
			}
			str += '<span class="an-date">'+common.nvl(result[i].W_DATE,'') +'</span>';
			str += '<span class="an-author">&nbsp; -'+ common.nvl(result[i].W_NM,'') +'</span>';
			str += '</li>';
		}
		$('#notiUL').html(str);
		var count = $('#notiUL li').length;
		var height = $('#notiUL li').height();
		if(result.length > 1) fn_article(count , height , 1) ;
	}
	
	
	
	
	function fn_article(count , height , index){
		$('#notiUL').delay(2000).animate({
			top: -height * index,
		}, 500, function() {
			fn_article(count , height , (index + 1) % count);
		});
	}
	
	
	function changeSearch1(){
		$("#search_start" ).change(function() {
			setMyAsStatus( $("#search_start" ).val(),$("#search_end" ).val() );
		});
		$("#search_end" ).change(function() {
			setMyAsStatus($("#search_start" ).val(),$("#search_end" ).val() );
		});
	}
	
	
	function changeSearch2(){
		$("#search_start2" ).change(function() {
			setCrmAsStatus( $("#search_start2" ).val(),$("#search_end2" ).val() );  
		});
		$("#search_end2" ).change(function() {
			setCrmAsStatus( $("#search_start2" ).val(),$("#search_end2" ).val() );  
		});
		
	}
	
	function changeSearch3(){
		$("#search_start3" ).change(function() {
			getAnswerListbyRecent();
		});
		$("#search_end3" ).change(function() {
			getAnswerListbyRecent();
		});
	}
	
	function changeSearch4(){
		$("#search_start4" ).change(function() {
			getMyTodayAsInfo();
		});
		$("#search_end4" ).change(function() {
			getMyTodayAsInfo();
		});
	}
	
	
	
	function setAsGraph(data){
		console.log(data);
		asGraphList = data.result != "undefined" ? data.result : null;
		google.charts.setOnLoadCallback(drawChart);
	}
	
	function drawChart() {

		var data = new google.visualization.DataTable();
		data.addColumn('string', '');
		data.addColumn('number', 'AS');
		data.addColumn('number', 'AS처리');
		
		for (var i=0; i < asGraphList.length; i++){
			var tmp = [];
			tmp.push(asGraphList[i].YYYYMM);
			tmp.push(asGraphList[i].TOTAL);
			tmp.push(asGraphList[i].PROC3);
			data.addRow(tmp);
		}
		var options = {
			colors: ['#a52714', '#097138'],
			width : 500,
			height : 350,
			legend : {position : 'bottom'}
		};
		

		var chart = new google.charts.Line(document.getElementById('asChart'));
		chart.draw(data, google.charts.Line.convertOptions(options));
	}

	function setCrmAsStatus(str , end) {
		var datas = {
				'str_dt' :  str,
				'end_dt' : end
		};
		common.ajaxCall(datas, '/fr/main/getCrmAsStatus.do','drawCrmAs');
	}

	function drawCrmAs(data) {
		if (data.result == "undefined")	return;
		
		crmAsList = data.result;
		var total=0,proc1=0,proc2=0,proc3=0,proc4=0; 
		
		for (var i=0; i < crmAsList.length; i++){
			proc1 += Number(crmAsList[i].PROC1);
			proc2 += Number(crmAsList[i].PROC2);
			proc3 += Number(crmAsList[i].PROC3);
			proc4 += Number(crmAsList[i].PROC4);
		}
		
		total = proc1 + proc2 + proc3 + proc4;
		
		$("#crmTotal").html(total);
		$("#crmProc1").html(proc1);
		$("#crmProc2").html(proc2);
		$("#crmProc3").html(proc3);
		$("#crmProc4").html(proc4);
	}

	function setMyAsStatus(str, end) {
		
		var datas = {
				'str_dt' : str,
				'end_dt' : end
		};
		common.ajaxCall(datas, '/fr/main/getMyAsStatus.do', 'drawMyAs');
	}
	
	function drawMyAs(data) {
		
		
		if (data.result == "undefined")
			return;
		
		myAsList = data.result;
		
		var total=0,proc1=0,proc2=0,proc3=0,proc4=0;
		
		for (var i=0; i < myAsList.length; i++){
			proc1 += Number(myAsList[i].PROC1);
			proc2 += Number(myAsList[i].PROC2);
			proc3 += Number(myAsList[i].PROC3);
			proc4 += Number(myAsList[i].PROC4);
		}
		
		total = proc1 + proc2 + proc3 + proc4;

		$("#myTotal").html(total);
		$("#myProc1").html(proc1);
		$("#myProc2").html(proc2);
		$("#myProc3").html(proc3);
		$("#myProc4").html(proc4);
	}

	function setRecentNoticeList(data) {
		recentNoticeList = data.resultList != "undefined" ? data.resultList : null;
	}

	function setNotReadNoticeList(data) {
		notReadNoticeList = data.resultList != "undefined" ? data.resultList : null;
	}

	function changeNoticeData(id) {
		$("#noticeTab1").removeClass("active");
		$("#noticeTab2").removeClass("active");
		$("#" + id).addClass("active");

		if (id == "noticeTab1" && recentNoticeList != null) {

			reDrawNoticeListBody(recentNoticeList);

		} else if (id == "noticeTab2" && notReadNoticeList != null) {

			reDrawNoticeListBody(notReadNoticeList);
		}
	}

	function reDrawNoticeListBody(list) {
		
		var str = "";
		for (var i = 0; i < list.length; i++) {

			str += "<tr onclick=\"listDetail('update', '" + list[i].seq + "','"
					+ list[i].rnum + "');\" style=\"cursor:pointer;\">";
			
			str += "	<td>" + list[i].notice_num + "</td>";
			
			str += "	<td>";
			if (common.nvl(list[i].attach_seq, '') != 0) {
				str += '<button type="button" class="btn_download_blue" style="min-width:30px"><span>다운로드</span></button>';
			} else {
				str += '';
			}
			str += "	</td>";
			
			str += "	<td>" + list[i].title + "</td>";
			str += "	<td>" + list[i].reg_date + "</td>";
			str += "</tr>";
		}

		$("#noticeListBody").html(str);
	}

	function listDetail(pageType, seq, num) {
		var f = document.listFrm;
		f.pageType.value = pageType;
		f.seq.value = seq;
		f.listNum.value = num;
		f.method = 'post';
		f.action = '/fr/notice/form.do';
		f.submit();
	}
	
	function goAsDetail(asno){
		var queryString = "?as_no=" + asno;
		location.href = "/fr/as/list.do" + queryString;
	}

	function getAsCustList(flag, type){
		var seqStr = "";
		
		if (type == "my"){
			if (myAsList == null) return;
			
			for (var i=0; i < myAsList.length;i++){
				if (flag == 'TOTAL' || myAsList[i][flag] != 0){
					seqStr += ",'" + myAsList[i].AS_NO + "'"; 
				}
			}
		}else if (type == "crm"){
			if (crmAsList == null) return;
			
			for (var i=0; i < crmAsList.length;i++){
				if (flag == 'TOTAL' || crmAsList[i][flag] != '0'){
					seqStr += ",'" + crmAsList[i].AS_NO + "'"; 
				}
			}
		}else{
			alert("AS 목록 요청 Type 지정이 잘못되었습니다.");
			return;
		}
		
		
		if (seqStr === ""){
			alert("대상 건이 없습니다.");
			return;
		}
		
		var datas = {'asno' : seqStr.substring(1)} ;
		common.ajaxCall(datas, '/fr/main/dashboardAsStatus.do', 'showAsListLayer') ;

		$("#asListLayer").show();
	}
	
	function showAsListLayer(data){
		
		$("#asListBody").empty();
		
		var asList = typeof data.resultList != "undefined" ? data.resultList : null ;
		if (asList == null) return;
		
		var htmlStr = "";
		for (var i=0; i < asList.length; i++){
			htmlStr += '<tr style="cursor:pointer" onclick="goAsDetail(\''+ common.nvl(asList[i].AS_NO,'') +'\')">';
			htmlStr += '	<td>' + asList[i].AS_NO + '</td>';
			htmlStr += '	<td>' + common.nvl(asList[i].PROC_STATUS_NM,'') + '</td>';
			htmlStr += '	<td>' + common.nvl(asList[i].SYSTEM_TYPE_NM,'') + '['+common.nvl(asList[i].SYSTEM_NM,'') +']'+ '</td>';
			htmlStr += '	<td>' + common.nvl(asList[i].INQUIRY_TYPE_NM,'') + '</td>';
			htmlStr += '	<td>' + common.nvl(asList[i].APPLY_NM,'') + '</td>';
			htmlStr += '	<td>' + common.strToDate(asList[i].ACCEPT_DT) + '</td>';
			htmlStr += '</tr>';
		}
		
		$("#asListBody").html(htmlStr);
		$("#asListLayer").show();
		$('#div_dim').show() ;
		
	}
	
	function showAnswerLayer(){
		getAnswerListbyRecent();
		$("#answerLayer").show();
		$('#div_dim').show() ;
	}
	
	
	function showCamLayer(){
		$("#camLayer").show();
	}
	
	/* badge*/
	
	function getMybadgeCount(){
		common.ajaxCall(null, '/fr/main/getMybadgeCount.do', 'setMybadgeCount') ;
	} 
	function setMybadgeCount(data){
		
		var as = typeof data.todayMyAS != "undefined" ? data.todayMyAS : '0' ;
		var reply = typeof data.todayMyReply != "undefined" ? data.todayMyReply : '0' ;
		var approval = typeof data.approvalAs != "undefined" ? data.approvalAs : '0';
		
		console.log(data);
		
		$('#getApprovalAsInfo #badgeNum').html(approval.CNT);
		$('#getMyAsInfo #badgeNum').html(as.CNT);
		$('#getMyReplyInfo #badgeNum').html(reply.CNT);
	};
	
	
	function getMyTodayAsInfo(){
		
		var data = {"str_dt": $('#search_start4').val()  , "end_dt":$('#search_end4').val() };
		common.ajaxCall(data, '/fr/main/getTodayMyAs.do', 'setMyTodayAsInfo') ;
	};
	function setMyTodayAsInfo(data){
		$('#todayMyAsListBody').empty();
		
		var asList = typeof data.list != "undefined" ? data.list : null ;
		if (asList == null) return;
		var htmlStr = "";
		for (var i=0; i < asList.length; i++){
			htmlStr += '<tr style="cursor:pointer" onclick="goAsDetail(\''+ asList[i].AS_NO +'\')">';
			htmlStr += '	<td>' + common.nvl(asList[i].AS_NO,'') + '</td>';
			htmlStr += '	<td>' + common.nvl(asList[i].SYSTEM_TYPE_NM,'') + '['+common.nvl(asList[i].SYSTEM_NM,'') +']'+ '</td>';
			htmlStr += '	<td>' + common.nvl(asList[i].INQUIRY_TYPE_NM,'') + '</td>';
			htmlStr += '	<td>' + common.nvl(asList[i].CALL_CONTENT,'') + '</td>';
			if(asList[i].PROC_STATUS =="C001" ){
				htmlStr += '<td><button class="btn_line bk_gray">';
			}else if(asList[i].PROC_STATUS =="C002"){
				htmlStr += '<td><button class="btn_line bk_red">';
			}else if(asList[i].PROC_STATUS =="C003" || asList[i].PROC_STATUS =="C004" ){
				htmlStr += '<td><button class="btn_line bk_yellow">';
			}else if(asList[i].PROC_STATUS =="C005"){
				htmlStr += '<td><button class="btn_line bk_blue">';
			}else{
				htmlStr += '<td><button class="btn_line bk_gray">';
			}
			
			htmlStr +=  common.nvl(asList[i].PROC_STATUS_NM,'');  
			htmlStr +=  '</button></td>';
			htmlStr += '	<td>' + common.nvl(asList[i].EMP_NM,'') + '</td>';
			htmlStr += '	<td>' + common.nvl(asList[i].MK_ACCEPT_DT,'') +' '+  common.nvl(asList[i].MK_ACCEPT_TIME,'')+ '</td>';
			htmlStr += '</tr>';
		}
		
		$("#todayMyAsListBody").html(htmlStr);
		$("#todayMyAsLayer").show();
		$('#div_dim').show() ;
		
		
	};
	
	
	function getMyReplyInfo(){
		common.ajaxCall(datas, '/fr/main/dashboardMyReplyInfo.do', 'setMyReplyInfo') ;
	};
	function setMyReplyInfo(data){
		var asList = typeof data.resultList != "undefined" ? data.resultList : null ;
		if (asList == null) return;
	};
	
	
	function getAddressInfo(){
		common.ajaxCall(null, '/fr/main/dashboardAddressInfo.do', 'setAddressInfo') ;
	};
	function setAddressInfo(data){
		
		$("#addressListBody").empty();
		
		var list = typeof data.resultList != "undefined" ? data.resultList : null ;
		var vo = typeof data.vo != "undefined" ? data.vo : null ;
		if (list == null) return;
		var htmlStr = "";
		for (var i=0; i < list.length; i++){
			htmlStr += '<tr>';
			htmlStr += '	<td>' + common.nvl(list[i].system_code_nm,'') + '</td>';
			htmlStr += '	<td>' + common.nvl(list[i].system_nm,'') + '</td>';
			htmlStr += '	<td>' + common.nvl(list[i].task_code_nm,'')+ '</td>';
			htmlStr += '	<td>' + common.nvl(list[i].worker_nm,'') + '</td>';
			htmlStr += '	<td>' + common.nvl(list[i].wk_email,'') + '</td>';
			htmlStr += '	<td>' + common.nvl(list[i].company_no,'') + '</td>';
			htmlStr += '</tr>';
		}
		
		$("#addressListBody").html(htmlStr);
		$('#div_dim').show() ;
		$('#addressLayer').show();
	};
	
	function getApprovalAsInfo(){
		common.ajaxCall(null, '/fr/main/dashboardApprovalAsInfo.do', 'setApprovalAsInfo') ;
	}
	function setApprovalAsInfo(data){
		
		$('#approvalAsListBody').empty();
		
		var asList = typeof data.list != "undefined" ? data.list : null ;
		if (asList == null) return;
		var htmlStr = "";
		for (var i=0; i < asList.length; i++){
			htmlStr += '<tr style="cursor:pointer" onclick="goAsDetail(\''+ asList[i].AS_NO +'\')">';
			htmlStr += '	<td>' + common.nvl(asList[i].AS_NO,'') + '</td>';
			htmlStr += '	<td>' + common.nvl(asList[i].SYSTEM_TYPE_NM,'') + '['+common.nvl(asList[i].SYSTEM_NM,'') +']'+ '</td>';
			htmlStr += '	<td>' + common.nvl(asList[i].INQUIRY_TYPE_NM,'') + '</td>';
			htmlStr += '	<td>' + common.nvl(asList[i].REQUEST_TYPE_NM,'') + '</td>';
			htmlStr += '	<td>' + common.nvl(asList[i].CALL_CONTENT,'') + '</td>';
			htmlStr += '<td><button class="btn_line bk_gray">';
			htmlStr +=  common.nvl(asList[i].PROC_STATUS_NM,'');
			htmlStr += '</td>'; 
			htmlStr += '	<td>' + common.nvl(asList[i].EMP_NM,'') + '</td>';
			htmlStr += '	<td>' + common.nvl(asList[i].MK_ACCEPT_DT,'') +' '+  common.nvl(asList[i].MK_ACCEPT_TIME,'')+ '</td>';
			htmlStr += '</tr>';
		}
		$("#approvalAsListBody").html(htmlStr);
		$("#approvalAsLayer").show();
		$('#div_dim').show() ;
	}
	
	
</script>

<form id="listFrm" name="listFrm" method="post" onsubmit="return false" enctype="multipart/form-data">
<input type="hidden" name="board_gbn" id="board_gbn" value="0000" />
<input type="hidden" name="pageType" id="pageType" />
<input type="hidden" name="page" id="page" value="1" />
<input type="hidden" name="seq" id="seq" />
<input type="hidden" name="listNum" id="listNum" />
<input type="hidden" name="user_id" id="user_id" value=${ frUserInfo.emp_id } />
<input type="hidden" name="cust_code" id="cust_code" value=${ frUserInfo.cust_code } />
	<div id="alarm" style="background: rgb(236, 248, 252); border-width: 0px 1px 1px; border-right-style: solid; border-bottom-style: solid; border-left-style: solid; border-right-color: rgb(219, 219, 219); border-bottom-color: rgb(219, 219, 219); border-left-color: rgb(219, 219, 219); border-image: initial; border-top-style: initial; border-top-color: initial;">
		<div class="tit_sWrap" style="width: 1000px; margin: 0 auto;">
		</div>
	</div>
	<div id="jw_contents">
	<div class="floatWrap">
		<div class="col-50 mgb30">
			<div class="floatL w490 mgr20">
				<div class="tit_wrap w490">
					<h2 class="tit_ico_as">나의A/S현황</h2>
					<div class="floatR mgt10">
					<input type="text" name="search_start" id="search_start" class="w90 mgl5 mgr5" readonly=readonly>
					~
					<input type="text" class="w90 mgl5 mgr5" name="search_end" id="search_end" readonly=readonly>
					</div>
				</div>
				<div class="db_borderbox">
					<table class="db_table">
						<tr>
							<th>전체 신청건</th>
							<th>반려</th>
							<th>담당자배정중</th>
							<th>배정완료,처리중</th>
							<th>처리완료</th>
						</tr>
						<tr>
							<td id="myTotal" onclick="getAsCustList('TOTAL','my')" style="cursor:pointer;">0</td>
							<td id="myProc4" onclick="getAsCustList('PROC4','my')" style="cursor:pointer;" class="red">0</td>
							<td id="myProc1" onclick="getAsCustList('PROC1','my')" style="cursor:pointer;" class="colorGreen">0</td>
							<td id="myProc2" onclick="getAsCustList('PROC2','my')" style="cursor:pointer;" class="yellow">0</td>
							<td id="myProc3" onclick="getAsCustList('PROC3','my')" style="cursor:pointer;" class="blue">0</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
		<div class="col-50 mgb30">
			<div class="floatL w490 mgr20">
				<div class="tit_wrap w490">
					<h2 class="tit_ico_as"><span class="mgr5">전체</span>A/S현황</h2>
					<!-- <div class="search_radio">
						<input type="radio" name="period2" value="week" onclick="setCrmAsStatus(this.value)" checked="checked"/> 최근 일주일<span class="mgr5"></span>
						<input type="radio" name="period2" value="month" onclick="setCrmAsStatus(this.value)" /> 최근 한달<span class="mgr5"></span>
					</div> -->
					<div class="floatR mgt10">
					<input type="text" name="search_start2" id="search_start2" class="w90 mgl5 mgr5" readonly=readonly>
					~
					<input type="text" class="w90 mgl5 mgr5" name="search_end2" id="search_end2" readonly=readonly>
					</div>
				</div>
				<div class="db_borderbox">
					<table class="db_table">
						<tr>
							<th>전체 신청건</th>
							<th>반려</th>
							<th>담당자배정중</th>
							<th>배정완료,처리중</th>
							<th>처리완료</th>
						</tr>
						<tr>
							<td id="crmTotal" onclick="getAsCustList('TOTAL','crm')" style="cursor:pointer;">0</td>
							<td id="crmProc4" onclick="getAsCustList('PROC4','crm')" style="cursor:pointer;" class="red">0</td>
							<td id="crmProc1" onclick="getAsCustList('PROC1','crm')" style="cursor:pointer;" class="colorGreen">0</td>
							<td id="crmProc2" onclick="getAsCustList('PROC2','crm')" style="cursor:pointer;" class="yellow">0</td>
							<td id="crmProc3" onclick="getAsCustList('PROC3','crm')" style="cursor:pointer;" class="blue">0</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
		
		
		<!--공지탭영역-->
		<div class="col-50 mgb30">
			<div class="tit_wrap w490">
				<h2 class="tit_ico_as">공지사항</h2>
			</div>

			<ul class="tab_line big list3 mgr20" >
				<li id="noticeTab1" class="active" style="width:50% !important;">
					<a href="javascript:changeNoticeData('noticeTab1')">최근공지</a>
				</li>
				<li id="noticeTab2" style="width:50% !important;">
					<a href="javascript:changeNoticeData('noticeTab2')">읽지않은공지</a>
				</li>
				<table class="hType" style="display:block;overflow-y:auto;height:330px;">
					<caption>대시보드-공지사항</caption>
					<colgroup>
						<col style="width:50px">
						<col style="width:30px">
						<col style="width:300px">
						<col style="width:100px">
					</colgroup>
					<tbody id="noticeListBody">
					</tbody>
				</table>
			</ul>
		</div>

		<!--그래프영역-->
		<div class="col-50 mgb30">
			<div class="floatL w490 mgr20" style="width:100%">
				<div class="tit_wrap w490">
					<h2 class="tit_ico_as">업무현황추이</h2>
				</div>
				<div class="db_borderbox" style="board:1px solid red;" id="asChart" ></div>
			</div>
		</div>

	</div>
</div>
<div id="float_layer">
	<c:if test="${vo.approval eq 'use'}">
		<div title="결재 대기함"  class="float_button mgb10 floatL" id="getApprovalAsInfo" onclick="getApprovalAsInfo()"><span id="badge"><span id="badgeNum">0</span></span><i class="material-icons">inbox</i></div>
	</c:if>
	<div title="오늘의 A/S"  class="float_button mgb10 floatL" id="getMyAsInfo" onclick="getMyTodayAsInfo()"><span id="badge"><span id="badgeNum">0</span></span><i class="material-icons">assignment</i></div>
	<div title="A/S답변 조회"  class="float_button mgb10 floatL" id="getMyReplyInfo" onclick="showAnswerLayer()"><span id="badge"><span id="badgeNum">0</span></span><i class="material-icons">comment</i></div>
	<div title="시스템 관리자 연락처"  class="float_button mgb10 floatL" id="getAddressInfo" onclick="getAddressInfo()"><i class="material-icons">face</i></div>
</div>

</form>


<!-- AS리스트 레이어팝업 -->
<div class="box_layer layer_order_list"  id="asListLayer" style="height:600px;top:50%;display:none;">
	<h1 class="tit_back">AS목록</h1>
	<div class="layer_contents" style="padding-top:20px;height:600px;overflow-y:auto;">
		<table class="hType mgb20">
			<caption>총 수금정보</caption>
			<colgroup>
				<col style="width:auto;" />
			</colgroup>
			<tr>
				<th>접수번호</th>
				<th>처리상태</th>
				<th>시스템유형</th>
				<th>업무유형</th>
				<th>접수자</th>
				<th>접수일</th>
			</tr>
			<tbody id="asListBody">
			</tbody>
		</table>
	</div>
	<button type="button" class="btn_close" onclick="$('#asListLayer').hide();$('#div_dim').hide() ;">창 닫기</button>
</div>

<!-- 최근댓글팝업 -->
<div class="box_layer layer_rating" style="top:50%;width:600px;height:500px;display:none;"id="answerLayer"  >
	<h1 class="tit_back">오늘의 A/S답변</h1>
	<div class="layer_contents">
		<!-- <div class="comment mgb20">
			AS담당자의 신규 답변을 확인하세요. 감사합니다.
		</div> -->
		
		<div class="floatWrap mgb10">
	         <div class="mgl40" style="float:right">
	        	 <input type="text" name="search_start3" id="search_start3" class="w90 mgl5 mgr5" readonly=readonly>
				~
				<input type="text" class="w90 mgl5 mgr5" name="search_end3" id="search_end3" readonly=readonly>
			 </div>   
		</div>
		<div style="padding:15px;height:340px;overflow-y:auto;">
			<form  id="answer-box"></form>
		</div>
 	</div>
	<button type="button" class="btn_close" onclick="$('#answerLayer').hide();$('#div_dim').hide();">창 닫기</button>
</div>
<div class="layer_dimmed"  id="div_dim" style="display:none;"></div>

<!-- 담당자 연락처  -->
<div class="box_layer layer_order_list"  id="addressLayer" style="height:600px;top:50%;display:none;">
	<h1 class="tit_back">시스템 담당자 연락처</h1>
	<div class="layer_contents" style="padding-top:20px;height:450px;overflow-y:auto;">
		<table class="hType mgb20">
			<caption>담당자 연락처</caption>
			<colgroup>
				<col style="width:100px;" />
				<col style="width:140px;" />
				<col style="width:80px;" />
				<col style="width:70px;" />
				<col style="width:100px;" />
			</colgroup>
			<tr>
				<th>시스템유형</th>
				<th>시스템명</th>
				<th>업무유형</th>
				<th>담당자명</th>
				<th>이메일</th>
				<th>전화번호</th>
			</tr>
			<tbody id="addressListBody">
			</tbody>
		</table>
		<div class="page" id="layer_pagination" style="margin-top: 10px;"></div>
	</div>
	<button type="button" class="btn_close" onclick="$('#addressLayer').hide();$('#div_dim').hide() ;">창 닫기</button>
</div>

<!--오늘의 AS-->
<div class="box_layer layer_order_list"  id="todayMyAsLayer" style="height:600px;top:50%;display:none;">
	<h1 class="tit_back">${ frUserInfo.emp_name }님의 오늘의 A/S</h1>
	<div class="layer_contents" style="padding-top:20px;height:500px;overflow-y:auto;">
		<div class="mgl40 mgb10" style="float:right">
	        <input type="text" name="search_start4" id="search_start4" class="w90 mgl5 mgr5" readonly=readonly>~
			<input type="text" class="w90 mgl5 mgr5" name="search_end4" id="search_end4" readonly=readonly>
		</div>
		<table class="hType mgb20">
			<caption>A/S 진행 상태</caption>
			<colgroup>
				<col style="width:auto;" />
			</colgroup>
			<tr>
				<th>접수번호</th>
				<th>시스템명</th>
				<th>업무유형</th>
				<th>문의내용</th>
				<th>진행상태</th>
				<th>담당자명</th>
				<th>접수일</th>
			</tr>
			<tbody id="todayMyAsListBody">
			</tbody>
		</table>
	</div>
	<button type="button" class="btn_close" onclick="$('#todayMyAsLayer').hide();$('#div_dim').hide() ;">창 닫기</button>
</div>



<!--결재대기함AS-->
<div class="box_layer layer_order_list"  id="approvalAsLayer" style="height:600px;top:50%;display:none;">
	<h1 class="tit_back">A/S 결재 대기함</h1>
	<div class="layer_contents" style="padding-top:20px;height:500px;overflow-y:auto;">
		<table class="hType mgb20">
			<caption>A/S 결재 대기함</caption>
			<colgroup>
				<col style="width:auto;" />
			</colgroup>
			<tr>
				<th>접수번호</th>
				<th>시스템명</th>
				<th>업무유형</th>
				<th>문의유형</th>
				<th>문의내용</th>
				<th>진행상태</th>
				<th>담당자명</th>
				<th>접수일</th>
			</tr>
			<tbody id="approvalAsListBody">
			</tbody>
		</table>
	</div>
	<button type="button" class="btn_close" onclick="$('#approvalAsLayer').hide();$('#div_dim').hide() ;">창 닫기</button>
</div>

<style>
.db-greybox{
    background: #f7f7f7;
    border: 1px solid #e8e8e8;
    width: 100%;
    font-size: 11px;
    position: relative;
	min-height:130px;
	box-sizing: border-box;
    box-shadow: 1px 0 1px #eaeaea;
    padding-left:30px;
    padding-right:30px;
    padding-bottom:10px;
    }
    
   .db-answer{
    padding-bottom:10px;
    padding-top:10px;
    
    }
   .db-answer td{
   height:23px;
   }
   
   .an_apply_nm{
    color: #0090c8;
    font-weight: 700;
   }
   
   .tit_sWrap .col-70{width: 70%; float: left; box-sizing: border-box;}
   .tit_sWrap .col-15{width: 13%; float: left; box-sizing: border-box;}
   .tit_sWrap .col-70:nth-child(even){padding-left: 15px;}
   .tit_sWrap .col-70:nth-child(odd){padding-right: 15px;} 
   .tit_sWrap .col-20{width: 15%;float: right;box-sizing: border-box;line-height:31px;}
   .tit_sWrap{height:34px; overflow-y:hidden;}
   
   .pos2{
   	background : url('/images/front/icon_re.png')no-repeat 0 0;
   	display: block;
   }
   
   
   .pos1{
   	background: url('/images/front/icon_today.png')no-repeat 0 0;
   	display: block;
   }
   
   .an_noti_icon{
   	background: url('/images/front/icon_chat_02.png')no-repeat 0 0;
   	display: inline-block;
   	width:25px;
   	height:25px;
   }
   .search_btn{
   	color: #0090c8;
   	font-weight: 600;
    font-size: 12px;
   }
   #float_layer{
   top: 560px;
   position: absolute;
    right: 50%;
    margin-right: -530px;
    width: 100px;
    height: 160px;
   
   }
   .float_button{
    height: 60px;
    border-radius: 50%;
    background-color: #0090c8;
    width: 60px;
    text-align: center;
    line-height: 85px;
    }
  .material-icons {
  font-family: 'Material Icons';
  font-weight: normal;
  font-style: normal;
  font-size: 36px;  /* Preferred icon size */
  display: inline-block;
  line-height: 1;
  text-transform: none;
  letter-spacing: normal;
  word-wrap: normal;
  white-space: nowrap;
  direction: ltr;
  color: rgba(255, 255, 255, 1);
  /* Support for all WebKit browsers. */
  -webkit-font-smoothing: antialiased;
  /* Support for Safari and Chrome. */
  text-rendering: optimizeLegibility;
  /* Support for Firefox. */
  -moz-osx-font-smoothing: grayscale;
  /* Support for IE. */
  font-feature-settings: 'liga';
  cursor:pointer;
}


#badge{
	line-height: 27px;
    height: 30px;
    width: 30px;
    z-index: 100;
    position: absolute;
    left: 43%;
    background-color: #ff635b;
    color: #ffff;
    border-radius: 15px;
    text-align: center;
    vertical-align: middle;
    margin-top: -9px;
}
#badgeNum{
	font-size: 100%;
    font-weight: 700;
}


.btn_line {
    width: 70px;
    height: 25px;
    font-weight: 600;
    line-height: 1em;
    font-size: 12px;
    color: #ffff;
    letter-spacing: -0.05em;
    border-radius: 3px;
}
.bk_red{
	border: 1px solid #ff3600;
	background-color: #ff3600;
    
}

.bk_yellow{
	border: 1px solid #ffa800;
	background-color: #ffa800;
    
}
.bk_blue{
	border: 1px solid #0090c8;
	background-color: #0090c8;
    
}
.bk_gray{
	border: 1px solid #9f9f9f;
	background-color:#959595 ;
    
}

.tooltip {
padding: 5px;
font-size: 11px;
opacity: 0.85;
filter: alpha(opacity=85);
background-repeat: no-repeat;
background-image: url(tooltip.gif);
}
.tooltip-inner {
padding: 5px 10px;
max-width: 200px;
pointer-events: none;
color: white;
text-align: center;
background-color: black;
border-radius: 3px;
box-shadow: 0 0 3px rgba(0, 0, 0, 0.25);
}
.tooltip-bottom {
background-position: top center;
}
.tooltip-top {
background-position: bottom center;
}
.tooltip-left {
background-position: right center;
}
.tooltip-right {
background-position: left center;
}

</style>



