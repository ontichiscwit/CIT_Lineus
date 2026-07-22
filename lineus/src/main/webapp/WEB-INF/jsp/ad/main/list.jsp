<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="egovframework.com.comm.util.DateTimeUtil"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript" src="/js/jquery.mtz.monthpicker.js"></script>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

<script type="text/javascript">

	var myAsList;
	var teamAsList;
	var importanceAsList;
	
	var FcustGubun =''; 
	var FchartGubun; 

	google.charts.load('current', {'packages': ['corechart', 'line']});		/**	a/s 추이 그래프	*/
	google.charts.load('current', {'packages':['corechart']});				
	
	var CHARINFO = null;
	var CHARLIST = null ; 
	var CHARLIST2 = null ; 
	var CHARLIST3 = null ;

	

	$(document).ready(function(){
		
		$("#search_start" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$("#search_end" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);

		
		$('#my_info_tb .my_div').click(function(){
			$('#my_info_tb .my_div').removeClass('active','active');
			$(this).addClass('active','active');
		});
		
		var cuDate = new Date();
		var firstDate = new Date(cuDate.getFullYear(),cuDate.getMonth(), 1);
		$( "#worktime_dt" ).val($.datepicker.formatDate('yy/mm', firstDate));
		$( "#worktime_dt" ).monthpicker(monthpicker_option);	
		
		goInfo() ;
	}) ;
	
	function goInfo(){
		custGubunTab('1');
	}
	
	//첫번째 탭
	function firstTab(gubun){
		location.href = "/ad/main/list" + gubun + ".do" ; 
	}
	//거래처구분 탭 
	function custGubunTab(gubun){
		
	   for(var i = 1 ; i <= 4 ; i++){
			if(gubun == i){
				$('#Secondli' + i).attr("class","active");
			}else{
				$('#Secondli' + i).removeClass("active");
			};	
		}
	   if(gubun == '1') {custGubunFlag = '';}
	   if(gubun == '2') {custGubunFlag = 'C002';}
	   if(gubun == '3') {custGubunFlag = 'C001';}
	   if(gubun == '4') {custGubunFlag = 'C004';}
	   FcustGubun = custGubunFlag
	   getAsCount(custGubunFlag);
	   getMyCount(custGubunFlag);
	   getTodayAsInfo();
	   
	   getWorkTimeChart( $("#search_start" ).val(),$("#search_end" ).val() );
	   
	   changeSearch();
	}

	
	//AS현황
	function getAsCount(custGubunFlag){
		var datas = {'cust_gubun': custGubunFlag} ; 
		common.ajaxCall(datas, '/ad/main/getAsCount.do', 'setAsCount') ;
	}
	
	function setAsCount(data){
		
		var myAsInfo = typeof data.myAsInfo != "undefined" ? data.myAsInfo : null ; 
		var asInfo = typeof data.asInfo != "undefined" ? data.asInfo : null ; 
		var top2_1=0,top2_2=0,top2_3=0,top2_4=0,top2_5=0;
		var top3_1=0,top3_2=0,top3_3=0,top3_4=0,top3_5=0; 
		myAsList = myAsInfo;
		teamAsList = asInfo;
		
		
		if(myAsInfo != null){
			for (var i=0; i < myAsInfo.length;i++){
				top2_1 += Number(myAsInfo[i].FLAG1);
				top2_2 += Number(myAsInfo[i].FLAG2);
				top2_3 += Number(myAsInfo[i].FLAG3);
				top2_4 += Number(myAsInfo[i].FLAG4);
				top2_5 += Number(myAsInfo[i].FLAG5);
			}
		}
		$('#top2_1').empty().html(top2_1); 
		$('#top2_2').empty().html(top2_2); 
		$('#top2_3').empty().html(top2_3); 
		$('#top2_4').empty().html(top2_4);  
		$('#top2_5').empty().html(top2_5); 
		
		if(asInfo != null){
			for (var i=0; i < asInfo.length;i++){
				top3_1 += Number(asInfo[i].FLAG1);
				top3_2 += Number(asInfo[i].FLAG2);
				top3_3 += Number(asInfo[i].FLAG3);
				top3_4 += Number(asInfo[i].FLAG4);
				top3_5 += Number(asInfo[i].FLAG5);
			}
		}
		$('#top3_1').empty().html(top3_1); 
		$('#top3_2').empty().html(top3_2); 
		$('#top3_3').empty().html(top3_3); 
		$('#top3_4').empty().html(top3_4);  
		$('#top3_5').empty().html(top3_5); 
	
	}
	
	
	/* 나의 My관리-카운팅 */
	function getMyCount(){
		var datas = {'cust_gubun': FcustGubun} ; 
		common.ajaxCall(datas, '/ad/main/getMyCount.do', 'setMyCount') ;
	}
	
	function setMyCount(data){
		
		var todayAs = typeof data.todayAs != "undefined" ? data.todayAs.CNT : '0' ;
		var todayReply = typeof data.todayReply != "undefined" ? data.todayReply.CNT : '0' ;
		var operchar = typeof data.operchar != "undefined" ? data.operchar.CNT : '0' ;
		var frequenter = typeof data.frequenter != "undefined" ? data.frequenter.CNT : '0' ;
		
		$('#mycount1').html(todayAs); 		/*오늘의 A/S 카운팅*/
		$('#mycount2').html(todayReply); 	/*오늘의 A/S 답글 카운팅*/
		$('#mycount3').html(operchar); 		/*나의 A/S 담당업무*/
		$('#mycount4').html(frequenter); 	/*주요고객*/
		
	}
	
	/* 오늘의 A/S정보 */
	function getTodayAsInfo(){
		var datas = {'cust_gubun': FcustGubun} ; 
		common.ajaxCall(datas, '/ad/main/getTodayAsInfo.do', 'setTodayAsInfo') ;
	}
	
	function setTodayAsInfo(data){
		var list = typeof data.resultList != "undefined" ? data.resultList : null ;
		$('#myInfoTb').empty();
		$('#ch_title').html('오늘의 A/S 정보');
		if(list == null) return;
		var htmlStr ="";
		htmlStr += '<caption></caption>';
		htmlStr += '<colgroup>';
		htmlStr += '<col style="width:auto">';
		htmlStr += '<col style="width:auto">';
		htmlStr += '<col style="width:auto">';
		htmlStr += '<col style="width:auto">';
		htmlStr += '<col style="width:auto">';
		htmlStr += '<col style="width:auto">';
		htmlStr += '<col style="width:30px">';
		htmlStr += '</colgroup>';
		htmlStr += '<thead>';
		htmlStr += '<tr>';
		htmlStr += '<th scope="col">A/S번호</th>';
		htmlStr += '<th scope="col">처리상태</th>';
		htmlStr += '<th scope="col">거래처명</th>';
		htmlStr += '<th scope="col">시스템유형</th>';
		htmlStr += '<th scope="col">업무유형</th>';
		htmlStr += '<th scope="col">접수자</th>';
		//htmlStr += '<th scope="col">접수일</th>';
		htmlStr += '<th scope="col">중요</th>';
		htmlStr += '</tr>';
		htmlStr += '</thead>';
		htmlStr +='<tbody>';
		for(var i =0; i < list.length ; i++){
			htmlStr += '<tr style="cursor:pointer" onclick="goAsDetail(\''+ list[i].AS_NO +'\')">';
			htmlStr += '	<td class="uder_line">' + common.nvl(list[i].AS_NO,'') + '</td>';
			//htmlStr += '	<td>' + common.nvl(list[i].PROC_STATUS_NM,'') + '</td>';	아래 조건과 중복되므로 주석처리 2021.03.05.이설아
			
			if(list[i].PROC_STATUS == 'C002'  ||  list[i].PROC_STATUS == 'C006' || list[i].PROC_STATUS == 'C009' ){
				htmlStr += '	<td><button class="status_btn gray_btn">'+common.nvl(list[i].PROC_STATUS_NM,'')+'</button></td>';
			}else if(list[i].PROC_STATUS == 'C003' ||  list[i].PROC_STATUS == 'C004'){
				htmlStr += '	<td><button class="status_btn yellow_btn">'+common.nvl(list[i].PROC_STATUS_NM,'')+'</button></td>';
			}else if(list[i].PROC_STATUS == 'C005' ){
				htmlStr += '	<td><button class="status_btn blue_btn">'+common.nvl(list[i].PROC_STATUS_NM,'')+'</button></td>';
			}else if(list[i].PROC_STATUS == 'C001' ){
				htmlStr += '	<td><button class="status_btn red_btn">'+common.nvl(list[i].PROC_STATUS_NM,'')+'</button></td>';
			}else{
				htmlStr += '	<td>' + common.nvl(list[i].PROC_STATUS_NM,'') + '</td>';
			}
			
			htmlStr += '	<td>' + common.nvl(list[i].CUST_KOR_NAME,'')+ '</td>';
			htmlStr += '	<td>' + common.nvl(list[i].SYSTEM_TYPE_NM,'') + '['+common.nvl(list[i].SYSTEM_NM,'') +']'+ '</td>';
			htmlStr += '	<td>' + common.nvl(list[i].INQUIRY_TYPE_NM,'') + '</td>';
			htmlStr += '	<td>' + common.nvl(list[i].APPLY_NM,'') + '</td>';
			if(list[i].INPORTANCE == 'C001'){
				htmlStr += '<td><span class="emergency"></span></td>';	
			}else{
				htmlStr += '<td><span class="emergency-non"></span></td>';	
			}
			htmlStr += '</tr>';
		}
		htmlStr +='</tbody>';
		$('#myInfoTb').html(htmlStr);
	}
	
	/* 오늘의 A/S답글 */
	function getTodayReplyInfo(){
		var datas = {'cust_gubun': FcustGubun} ; 
		common.ajaxCall(datas, '/ad/main/getTodayReplyInfo.do', 'setTodayReplyInfo') ;
	}
	
	function setTodayReplyInfo(data){
		var list = typeof data.resultList != "undefined" ? data.resultList : null ;
		if(list == null) return;
		$('#ch_title').html('오늘의 A/S 답글');
		var htmlStr ="";
		htmlStr += '<caption></caption>';
		htmlStr += '<colgroup>';
		htmlStr += '<col style="width:auto">';
		htmlStr += '</colgroup>';
		htmlStr += '<thead>';
		htmlStr += '<tr>';
		htmlStr += '<th scope="col">거래처명</th>';
		htmlStr += '<th scope="col">A/S번호</th>';
		htmlStr += '<th scope="col">A/S문의내용</th>';
		htmlStr += '<th scope="col">댓글내용</th>';
		htmlStr += '<th scope="col">작성자</th>';
		htmlStr += '<th scope="col">작성일</th>';
		htmlStr += '</tr>';
		htmlStr += '</thead>';
		htmlStr +='<tbody>';
		for(var i =0; i < list.length ; i++){
			htmlStr += '<tr style="cursor:pointer" onclick="goAsDetail(\''+ list[i].AS_NO +'\')">';
			htmlStr += '	<td>' + common.nvl(list[i].CUST_KOR_NAME,'')+ '</td>';
			htmlStr += '	<td class="uder_line">' + common.nvl(list[i].AS_NO,'') + '</td>';
			htmlStr += '	<td>' + common.nvl(list[i].CALL_CONTENT,'')+ '</td>';
			htmlStr += '	<td>' + common.nvl(list[i].W_CONTENT,'') + '</td>';
			htmlStr += '	<td>' + common.nvl(list[i].APPLY_NM,'') + '</td>';
			htmlStr += '	<td>' + common.nvl(list[i].W_DATE,'') + '</td>';
			htmlStr += '</tr>';
		}
		htmlStr +='</tbody>';
		$('#myInfoTb').html(htmlStr);
	}
	
	/* 나의 A/S담당업무 */
	function getOperWorkerinfo(){
		var datas = {'cust_gubun': FcustGubun} ; 
		common.ajaxCall(datas, '/ad/main/getOperCharInfo.do', 'setOperWorkerinfo') ;
	}
	
	function setOperWorkerinfo(data){
		var list = typeof data.resultList != "undefined" ? data.resultList : null ;
		if(list == null) return;
		$('#ch_title').html('나의  A/S 담당업무');
		var htmlStr ="";
		htmlStr += '<caption></caption>';
		htmlStr += '<colgroup>';
		htmlStr += '<col style="width:auto">';
		htmlStr += '</colgroup>';
		htmlStr += '<thead>';
		htmlStr += '<tr>';
		htmlStr += '<th scope="col">거래처명</th>';
		htmlStr += '<th scope="col">시스템유형</th>';
		htmlStr += '<th scope="col">시스템명</th>';
		htmlStr += '<th scope="col">업무유형</th>';
		htmlStr += '<th scope="col">대표담당자</th>';
		htmlStr += '<th scope="col">사용여부</th>';
		htmlStr += '</tr>';
		htmlStr += '</thead>';
		htmlStr +='<tbody>';
		for(var i =0; i < list.length ; i++){
			htmlStr += '<tr style="cursor:pointer" onclick="goOperDetail(\''+ list[i].OPER_SEQ +'\')">';
			htmlStr += '	<td>' + common.nvl(list[i].CUST_KOR_NAME,'')+'['+ common.nvl(list[i].ERP_CODE,'') +']</td>';
			htmlStr += '	<td>' + common.nvl(list[i].SYSTEM_CODE_NM,'')+ '</td>';
			htmlStr += '	<td class="uder_line">' + common.nvl(list[i].SYSTEM_NM,'') + '</td>';
			htmlStr += '	<td>' + common.nvl(list[i].TASK_CODE_NM,'') + '</td>';
			htmlStr += '	<td>' + common.nvl(list[i].MASTER_YN,'N') + '</td>';
			if( common.nvl(list[i].IS_USE,'') == "C001" ){
				htmlStr += '	<td><button class="status_btn blue_btn">' + common.nvl(list[i].IS_USE_NM,'') + '</button></td>';
			}else if(common.nvl(list[i].IS_USE,'') == "C002"){
				htmlStr += '	<td><button class="status_btn gray_btn">' + common.nvl(list[i].IS_USE_NM,'') + '</button></td>';
			}
			htmlStr += '</tr>';
		}
		htmlStr +='</tbody>';
		$('#myInfoTb').html(htmlStr);
	}
	
	/* 나의 AS단골 고객 */
	function getFrequenterInfo(){
		var datas = {'cust_gubun': FcustGubun} ; 
		common.ajaxCall(datas, '/ad/main/getFrequenterInfo.do', 'setFrequenterInfo') ;
	}
	function setFrequenterInfo(data){
		var list = typeof data.resultList != "undefined" ? data.resultList : null ;
		if(list == null) return;
		$('#ch_title').html('주요고객 정보');
		var htmlStr ="";
		htmlStr += '<caption></caption>';
		htmlStr += '<colgroup>';
		htmlStr += '<col style="width:auto">';
		htmlStr += '</colgroup>';
		htmlStr += '<thead>';
		htmlStr += '<tr>';
		htmlStr += '<th scope="col">거래처명</th>';
		htmlStr += '<th scope="col">고객명</th>';
		htmlStr += '<th scope="col">고객ID</th>';
		htmlStr += '<th scope="col">전화번호</th>';
		htmlStr += '<th scope="col">이메일</th>';
		htmlStr += '</tr>';
		htmlStr += '</thead>';
		htmlStr +='<tbody>';
		for(var i =0; i < list.length ; i++){
			htmlStr += '<tr style="cursor:pointer" onclick="goEmpDetail(\''+ list[i].APPLY_ID +'\')">';
			htmlStr += '	<td>' + common.nvl(list[i].CUST_KOR_NAME,'')+'['+ common.nvl(list[i].ERP_CODE,'') +']</td>';
			htmlStr += '	<td>' + common.nvl(list[i].APPLY_NM,'')+ '</td>';
			htmlStr += '	<td class="uder_line">' + common.nvl(list[i].APPLY_ID,'') + '</td>';
			htmlStr += '	<td>' + common.nvl(list[i].TEL_NO,'') + '</td>';
			htmlStr += '	<td>' + common.nvl(list[i].EMAIL,'') + '</td>';
			htmlStr += '</tr>';
		}
		htmlStr +='</tbody>';
		$('#myInfoTb').html(htmlStr);
	}
	
	function getSearchWorkerInfo(){
		var datas = {'cust_gubun': FcustGubun, 'search_text': $('#searchWorkerName').val() } ; 
		common.ajaxCall(datas, '/ad/main/getSearchWorkerInfo.do', 'setSearchWorkerInfo') ;
	
	}
	function setSearchWorkerInfo(data){
		console.log(data);
		
		var list = typeof data.resultList != "undefined" ? data.resultList : null ;
		if(list == null) return;
		var htmlStr ="";
		for(var i =0; i < list.length ; i++){
			htmlStr += '<tr>';
			htmlStr += '	<td>' + common.nvl(list[i].CUST_KOR_NAME,'')+'['+ common.nvl(list[i].ERP_CODE,'') +']</td>';
			htmlStr += '	<td>' + common.nvl(list[i].SYSTEM_CODE_NM,'')+ '</td>';
			htmlStr += '	<td class="uder_line">' + common.nvl(list[i].SYSTEM_NM,'') + '</td>';
			htmlStr += '	<td>' + common.nvl(list[i].TASK_CODE_NM,'') + '</td>';
			htmlStr += '	<td>' + common.nvl(list[i].EMP_NM,'') + '</td>';
			htmlStr += '	<td>' + common.nvl(list[i].MASTER_YN,'N') + '</td>';
			if( common.nvl(list[i].IS_USE,'') == "C001" ){
				htmlStr += '	<td><button class="status_btn blue_btn">' + common.nvl(list[i].IS_USE_NM,'') + '</button></td>';
			}else{
				htmlStr += '	<td><button class="status_btn gray_btn">' + common.nvl(list[i].IS_USE_NM,'') + '</button></td>';
			}
			htmlStr += '</tr>';
		}
		
		$('#workerListBody').html(htmlStr);
		$('#workerListLayer').show();	
	} 
	
	
	function changeSearch(){			//2024.04.26 나의 A/S현황 리스트 조회 기간 변경
		$("#search_start" ).change(function() {
			getWorkTimeChart( $("#search_start" ).val(),$("#search_end" ).val() );
		});
		$("#search_end" ).change(function() {
			getWorkTimeChart($("#search_start" ).val(),$("#search_end" ).val() );
		});
	}
	
	function getWorkTimeChart(str,end){
		
		var datas = {
				'cust_gubun': FcustGubun,
				'str_dt' : str,
				'end_dt' : end
		}; 
		common.ajaxCall(datas, '/ad/main/getWorkTimeChart.do', 'setWorkTimeChart') ;
	}
	
	
	function setWorkTimeChart(data){
		
		var charList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		var myTotalAsTime = 0;
		
		$('#worktime_chart').empty();
		if(charList != null && charList.length != 0 ){
			CHARLIST2 = charList ; 
			CHARLIST3 = charList ; 
			google.charts.setOnLoadCallback(drawWorkTimeChart);
			
			for(var i = 0 ; i < CHARLIST3.length ; i++){
				var datas = CHARLIST3[i] ;
				myTotalAsTime = myTotalAsTime + Number(common.nvl(datas.TOT_TIME, '0'))
			}
			
			$('#myAsTime').html('&nbsp;&nbsp;&nbsp;(총 작업시간 : ' + '<a style="color: #ff3000; font-weight: 900; font-size: 16px;">' + myTotalAsTime.toFixed(1) + '</a>' + ' 시간)');
			
		}else if(charList == null || charList.length == 0){
			$('#myAsTime').html('&nbsp;&nbsp;&nbsp;(총 작업시간 : ' + '<a style="color: #ff3000; font-weight: 900; font-size: 16px;">0</a>' + ' 시간)');
			return;
		}
	}
	
	
	function drawWorkTimeChart(){
		var arr = [] ; 
		var temp = [] ; 
		temp.push('Element') ; 
		temp.push('workTime') ; 
		temp.push({ role: "style" }) ; 
		temp.push({ role: "annotation" }) ; 
		
		arr.push(temp) ; 

		var colorArr =['#008c9e','#0080ff','#005f6b','#343838','#a5dff9'];
		
		for(var i = 0 ; i < CHARLIST2.length ; i++){
			var val = Math.round( Math.random()*5 );
			var datas = CHARLIST2[i] ;
			var imsi = [] ; 
			
			imsi.push(common.nvl(datas.SYSTEM_TYPE_NM, '') + "[" +common.nvl(datas.SYSTEM_NM,'') + "]"+" "+common.nvl(datas.INQUIRY_TYPE_NM,'') ) ; 
			imsi.push(Number(common.nvl(datas.TOT_TIME, '0'))) ;
			imsi.push(colorArr[val]) ;
			imsi.push(common.nvl(datas.CUST_KOR_NAME, '') + "[" +common.nvl(datas.CUST_CODE,'') +"]") ; 
			
			arr.push(imsi) ; 
		}
		
		var chartData = google.visualization.arrayToDataTable(arr);

	    var options = {
	    		title: "작업시간 추이",
	            width: 900,
	            height: 260,
	            //bar: {groupWidth: "95%"},
	            legend: { position: 'right', maxLines: 2 },
	    };

	    var chart = new google.visualization.ColumnChart(document.getElementById('worktime_chart'));
	    chart.draw(chartData, options);
	    
	}
	
	/*레이어 -A/S현황*/
	function getAsCustList(flag, type){

		var seqStr = "";
		
		if (type == "my"){
			if (myAsList == null) return;
			
			for (var i=0; i < myAsList.length;i++){
				if (myAsList[i][flag] != 0) seqStr += ",'" + myAsList[i].AS_NO + "'"; 
			}
		}else if (type == "team"){
			if (teamAsList == null) return;
			
			for (var i=0; i < teamAsList.length;i++){
				if (teamAsList[i][flag] != '0') seqStr += ",'" + teamAsList[i].AS_NO + "'"; 
			}
		}else if(type == "importance"){
			if(importanceAsList == null) return;
			
			for (var i=0; i < importanceAsList.length;i++){
				 seqStr += ",'" + importanceAsList[i].AS_NO + "'"; 
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
		common.ajaxCall(datas, '/ad/main/getAsListByAsno.do', 'showAsListLayer') ;

		$("#asListLayer").show();
	}
	
	function showAsListLayer(data){
		var asList = typeof data.resultList != "undefined" ? data.resultList : null ;
		
		if (asList == null) return;
		var htmlStr = "";
		    for (var i=0; i < asList.length; i++){
			htmlStr += '<tr style="cursor:pointer" onclick="goAsDetail(\''+ asList[i].AS_NO +'\')">';
			htmlStr += '	<td class="uder_line">' + asList[i].AS_NO + '</td>';
			htmlStr += '	<td>' + asList[i].PROC_STATUS_NM + '</td>';
			htmlStr += '	<td>' + asList[i].CUST_KOR_NAME+ '</td>';
			htmlStr += '	<td>' + asList[i].SYSTEM_TYPE_NM + '['+asList[i].SYSTEM_NM +']'+ '</td>';
			htmlStr += '	<td>' + asList[i].INQUIRY_TYPE_NM + '</td>';
			htmlStr += '	<td>' + asList[i].APPLY_NM + '</td>';
			htmlStr += '	<td>' + asList[i].EMP_NM + '</td>';
			htmlStr += '	<td>' + common.strToDate(asList[i].INQUIRY_DT) + '</td>';
			htmlStr += '</tr>';
		}
		
		$("#asListBody").html(htmlStr);
		$("#asListLayer").show(); 
		
	}
	function goAsDetail(asno){
		var queryString = "?pageType=update&as_no=" + asno;
		location.href = "/ad/as/form.do" + queryString;
	}
	
	function goOperDetail(oper_seq){
		var queryString = "?pageType=update&oper_seq=" + oper_seq;
		location.href = "/ad/operate/form.do" + queryString;
		
	}
	
	
	
</script>

<!-- TAB -->
<ul class="tab_dashboard list2 mgt30 mgb30">
	<li id="Firstli1" class="active"><a href="javascript:firstTab('');">A/S</a></li><!-- 활성시 current -->
	<li id="Firstli2"><a href="javascript:firstTab('2');">프로젝트/운영관리</a></li>
</ul>

<!-- 거래처구분 자동화필요  -->
<ul class="tab_line big list4 mgb10" style="margin-bottom:0px;">
	<li id="Secondli1" class="active"><a href="javascript:custGubunTab('1');">전체</a></li>
	<li id="Secondli2" ><a href="javascript:custGubunTab('2');">대외기업</a></li>
	<li id="Secondli3" ><a href="javascript:custGubunTab('3');">JW</a></li>
	<li id="Secondli4" ><a href="javascript:custGubunTab('4');">CIT</a></li>
</ul>

<div class="floatWrap mgb20">
	<div class="w485 floatL">
		<div class="tit_wrap small"><h3 class="tit_ico_notice">나의 A/S현황 (당월)</h3></div>
		<div class="db-greybox">
			<ul class="list5">
				<li onclick="getAsCustList('FLAG1','my')" style="cursor:pointer;"><p>대기,팀장승인</p><p class="num_db colorYellow" id="top2_1">0</p></li>
				<li onclick="getAsCustList('FLAG2','my')" style="cursor:pointer;"><p>처리중</p><p class="num_db colorBlue" id="top2_2">0</p></li>
				<li onclick="getAsCustList('FLAG3','my')" style="cursor:pointer;"><p>처리완료</p><p class="num_db" id="top2_3">0</p></li>
				<li onclick="getAsCustList('FLAG4','my')" style="cursor:pointer;"><p>반려</p><p class="num_db" id="top2_4">0</p></li>
				<li onclick="getAsCustList('FLAG5','my')" style="cursor:pointer;"><p>지연</p><p class="num_db colorRed" id="top2_5">0</p></li>
			</ul>
		</div>
	</div>
	<div class="w485 floatR">
		<div class="tit_wrap small"><h3 class="tit_ico_notice">전체 A/S현황 (당월)</h3></div>
		<div class="db-greybox">
			<ul class="list5">
				<li onclick="getAsCustList('FLAG1','team')" style="cursor:pointer;"><p>대기,팀장승인</p><p class="num_db colorYellow" id="top3_1">0</p></li>
				<li onclick="getAsCustList('FLAG2','team')" style="cursor:pointer;"><p>처리중</p><p class="num_db colorBlue" id="top3_2">0</p></li>
				<li onclick="getAsCustList('FLAG3','team')" style="cursor:pointer;"><p>처리완료</p><p class="num_db" id="top3_3">0</p></li>
				<li onclick="getAsCustList('FLAG4','team')" style="cursor:pointer;"><p>반려</p><p class="num_db" id="top3_4">0</p></li>
				<li onclick="getAsCustList('FLAG5','team')" style="cursor:pointer;"><p>지연</p><p class="num_db colorRed" id="top3_5">0</p></li>
			</ul>
		</div>
	</div>
</div>
<div style="height:1px;background:#ddd;"></div>
<div style="display:table;width:100%;margin:20px 0">
	<div class="floatL w490 mgr20">
		<div class="tit_wrap small">
			<h3 class="tit_ico_as">나의  A/S관리</h3>
			<img class="" src="/images/loading.gif" alt="로딩중" title="로딩중" style="margin: 10px;float: right;">
		</div>
		<div class="db_borderbox h270" id="my_custinfo" >
			<table id="my_info_tb" style="width:100%;height:100%">
				<!-- <tr>
					<td class="my_div active" onclick="getTodayAsInfo()"><div id="my_div1" class="contents">오늘의  A/S<span class="num_db pdl8" id="mycount1">0</span></div></td>
					<td class="my_div" onclick="getTodayReplyInfo()"><div id="my_div2" class="contents">오늘의 A/S답글<span class="num_db pdl8" id="mycount2">0</span></div></td>
				</tr>
				<tr>
					<td class="my_div" onclick="getOperWorkerinfo()" ><i class="material-icons">assignment_ind</i><div id="my_div3" class="contents">나의 A/S담당업무 <span class="num_db pdl8" id="mycount3">0</span></div></td>
					<td class="my_div" onclick="getFrequenterInfo()" ><i class="material-icons">face</i><div id="my_div4" class="contents">주요 고객<span class="num_db pdl8" id="mycount4">0</span></div></td>
				</tr>
				<tr>
					<td class="my_div" onclick="getSearchWorkerInfo()"><i class="material-icons">work</i><div id="my_div5" class="contents">업무담당자 확인(변경)</div></td>
					<td class="my_div" onclick="getSearchWorkerInfo()"><i class="material-icons">hourglass_full</i><div id="my_div6" class="contents">이월 A/S</div></td>
					
				</tr> -->
				<tr>
					<td class="my_div active" onclick="getTodayAsInfo()"><div id="my_div1" class="contents">오늘의  A/S<span class="num_db pdl8" id="mycount1">0</span></div></td>
					<td class="my_div" onclick="getTodayReplyInfo()"><div id="my_div2" class="contents">오늘의 A/S답글<span class="num_db pdl8" id="mycount2">0</span></div></td>
				</tr>
				<tr>
					<td class="my_div" onclick="getOperWorkerinfo()" ><!-- <i class="material-icons">assignment_ind</i> --><div id="my_div3" class="contents">나의 A/S담당업무 <span class="num_db pdl8" id="mycount3">0</span></div></td>
					<td class="my_div" onclick="getFrequenterInfo()" ><!-- <i class="material-icons">face</i> --><div id="my_div4" class="contents">주요 고객<span class="num_db pdl8" id="mycount4">0</span></div></td>
				</tr>
				<tr>
					<td class="my_div" onclick="getSearchWorkerInfo()"><!-- <i class="material-icons">work</i> --><div id="my_div5" class="contents"></div></td>
					<td class="my_div" onclick="getSearchWorkerInfo()"><!-- <i class="material-icons">hourglass_full</i> --><div id="my_div6" class="contents"></div></td>
					
				</tr>
				
			</table>
		
		</div>
	</div>
	
	<div class="floatL w490">
		<div class="tit_wrap small">
			<h3 class="tit_ico_as"><span id="ch_title">나의A/S거래처 관리</span></h3>
		</div>
		<div class="db_borderbox h270" >
			<table class="hType" id="myInfoTb"></table>
		</div>
	</div>
</div>


<div style="display:table;width:100%;margin-top:20px">
	<div class="floatL mgr60" style="width:100%" >
		<div class="tit_wrap small">
			<div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap;">
			  
			  <!-- 텍스트 부분 (제목 + 작업시간) -->
			  <div style="display: flex; align-items: center; gap: 10px;">
			    <h3 class="tit_ico_graph2" style="margin: 0;">나의 A/S 작업시간</h3>
			    <p style="font-size: 16px; padding-top: 2px; margin: 0;">
			      <a type="button" id="myAsTime"></a>
			    </p>
			  </div>
			
			  <!-- 날짜 검색 부분 -->
			  <div class="mgt10" style="display: flex; align-items: center; gap: 5px;">
			    <input type="text" name="search_start" id="search_start" class="w90 mgl5 mgr5" readonly="readonly">
			    ~
			    <input type="text" class="w90 mgl5 mgr5" name="search_end" id="search_end" readonly="readonly">
			  </div>
			
			</div>
		</div>
		
		<div class="db_borderbox h270" id="worktime_chart"></div>
	</div>
</div>

<!-- AS 레이어팝업 -->
<div id="asListLayer" style="display:none;">
	<div class="box_layer layer_sms" style="height:700px;margin-top:-400px;">
		<h1>A/S목록</h1>
		<div class="layer_contents" style="padding-top:20px;height:600px;overflow-y:auto;">
			<table class="hType mgb20">
				<caption>A/S</caption>
				<colgroup>
					<col style="width:auto;" />
				</colgroup>
				<tr>
					<th>A/S번호</th>
					<th>처리상태</th>
					<th>거래처명</th>
					<th>시스템유형</th>
					<th>업무유형</th>
					<th>접수자</th>
					<th>처리담당자</th>
					<th>처리요청일자</th>
				</tr>
				<tbody id="asListBody">
				</tbody>
			</table>
		</div>
		<button type="button" class="btn_close" onclick="$('#asListLayer').hide()">창 닫기</button>
	</div>
	<div class="layer_dimmed"></div>
</div>

<!-- 운영 레이어팝업 -->
<div id="workerListLayer" style="display:none;">
	<div class="box_layer layer_sms" style="height:500px;margin-top:-300px;">
		<h1>업무담당자 확인(변경)</h1>
		<div class="layer_contents" style="padding-top:20px;height:600px;overflow-y:auto;">
			업무담당자 : 
			<input type="text" class="w175 mgr10" id="searchWorkerName" name="searchWorkerName" title="담당자 검색" placeholder="담당자명/사번" autofocus="autofocus">
			<button type="button" class="btn_ico_search mgr5" onclick="javascript:getSearchWorkerInfo();"><span>검색</span></button>
			<table class="hType mgb20 mgt10">
				<caption>업무담당자 확인(변경)</caption>
				<colgroup>
					<col style="width:auto;" />
				</colgroup>
				<tr>
					<th>거래처명</th>
					<th>시스템유형</th>
					<th>시스템명</th>
					<th>업무유형</th>
					<th>담당자</th>
					<th>대표담당자</th>
					<th>사용여부</th>
				</tr>
				<tbody id="workerListBody">
				</tbody>
			</table>
		</div>
		<button type="button" class="btn_close" onclick="$('#workerListLayer').hide()">창 닫기</button>
	</div>
	<div class="layer_dimmed"></div>
</div>

<style>
.btn {
    width:220px;
    display: inline-block;
    font-weight: 800;
    text-align: center;
    white-space: nowrap;
    vertical-align: middle;
    border: 1px solid transparent;
    padding: 7px 35px 7px 35px;
    border-radius: .25rem;
    transition: color .15s ease-in-out,background-color .15s ease-in-out,border-color .15s ease-in-out,box-shadow .15s ease-in-out;
}
.btn-small{
    width:120px;
    display: inline-block;
    font-weight: 800;
    text-align: center;
    white-space: nowrap;
    vertical-align: middle;
    border: 1px solid transparent;
    padding: 7px 35px 7px 35px;
    border-radius: .25rem;
    transition: color .15s ease-in-out,background-color .15s ease-in-out,border-color .15s ease-in-out,box-shadow .15s ease-in-out;
}
.btn-info {
    color: #fff;
    background-color: #17a2b8;
    border-color: #17a2b8;
}
.db_whitebox1{
	padding : 20px;
}
.db_whitebox2{
	padding : 20px;
}
#getMaxNumCustBody tr{
	background-color:aliceblue;
	word-wrap:break-word;
}
#my_info_tb{
	background: #f7f7f7;
	text-align: center;
	font-weight: 600;
    font-size: 14px;
    position: relative;
}
#my_info_tb tr{
	height:33.3%;
	border:solid 1px #e8e8e8;
}
#my_info_tb td{
	width:50%;
	border:solid 1px #e8e8e8;
}

#my_info_tb .my_div{
	cursor: pointer;
	
}

#my_info_tb .active{
	background: #edf7fb;
    /* padding: 36px 0 36px; */
    border: 1px solid #9bdaf2;
}
.status_btn{
   min-width: 30px;
   font-weight: 500;
   font-size: 12px;
   color: #fff;
   text-align: center;
   line-height: 28px;
   border-radius:3px;
   padding:2px;
   height:30px;
}
.gray_btn {
    background-color: #9e9e9e;
    border: #909597;
 }
 
 .gray_btn {
    background-color: #9e9e9e;
    border: #909597;
 }
 
 .yellow_btn {
    background-color: #ffa800;
    border: #909597;
 }
 
 .blue_btn {
    background-color: #0090c8;
    border: #909597;
 }
 
 .red_btn {
    background-color: #ff3000;
    border: #909597;
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
  color: rgb(82, 94, 103);
  /* Support for all WebKit browsers. */
  -webkit-font-smoothing: antialiased;
  /* Support for Safari and Chrome. */
  text-rendering: optimizeLegibility;
  /* Support for Firefox. */
  -moz-osx-font-smoothing: grayscale;
  /* Support for IE. */
  font-feature-settings: 'liga';
  cursor:pointer;
  vertical-align: middle;
}
 .contents{
 display:contents;
 
 
 } 
</style>

