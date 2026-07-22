<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="egovframework.com.comm.util.DateTimeUtil"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript" src="/js/jquery.mtz.monthpicker.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<script type="text/javascript">

	var FCUSTGUBUN = '';
	var CHARINFO;
	
	$(document).ready(function(){
		// 현 날짜 구하기
		var cuDate = new Date();
		var yyyymm = cuDate.getFullYear() + " 년 ";
		$("#setTab1SolutionLeftTitle").html(yyyymm + " 프로젝트 진행현황");
		goInfo() ;
	}) ;
	
	function goInfo(){
		
		/* 프로젝트 현황 실행 */
		getProjectInfo();
		/* 유지보수 계약현황  실행*/
		getOperCount(FCUSTGUBUN);
		getOperContractInfo('A1');
		
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
	   FCUSTGUBUN = custGubunFlag;
	  	console.log("d");
	   getProjectInfo();
	   
	}
	
	//프로젝트 진행현황
	function getProjectInfo(){
		//var cust_gubun = FcustGubun;
		var datas = {'cust_gubun': FCUSTGUBUN } ; 
		common.ajaxCall(datas, '/ad/main/getProjectInfo.do', 'setProjectInfo') ;
	}
	
	function setProjectInfo(data){
		var datas = typeof data.resultList != "undefined" ? data.resultList : null ;
		if (datas == null ) return;
		
		if(datas != null && datas.length != 0 ){
			
			var	html =''; 
			var flag1 = '0'; /* 총 프로젝트 수  */
			var flag2 = '0'; /* 수주심의 확정 수  */
			var flag3 = '0'; /* 계약완료 수  */
			var flag4 = '0'; /* 개발완료 수  */
			var flag5 = '0'; /* 오픈 수  */
			var flag6 = '0'; /* 최종검수  */
			
			for(var i = 0 ; i < datas.length; i++){
				
				var num = i +1;
				flag1 =	datas.length;
				
				html += '<tr>';
				html += '<td>'+ num +'</td>';
				html += '<td class="textL">'+ common.nvl(datas[i].CUST_KOR_NAME, '') + '[' + common.nvl(datas[i].ERP_CODE, '') +']'+ '</td>';
				html += '<td>'+ common.nvl(datas[i].SYSTEM_NAME,'') +'</td>';
				html += '<td>'+ common.nvl(datas[i].PROJECT_NM,'') +'</td>';
				html += '<td>'+ common.nvl(datas[i].WORKER_NM,'') +'</td>';
				
				/* 수주심의 */
				if(common.nvl(datas[i].REVIEW_DT,'') != ''){
					html += '<td><button class="btn_file_blue" style="width:60px;">'+ '확정' +'</button>';
					html += '<span class="ac-bg-color">'+ makeDate(datas[i].REVIEW_DT,'/') +'</span></td>';
					flag2 ++;
				}else{
					html += '<td><button class="btn_file_gray" style="width:60px;margin-bottom:14px;">'+ '-' +'</button></td>';
				}
				
				/* 계약 */
				if(common.nvl(datas[i].CONTRACT_DT,'') != ''){
					html += '<td><button class="btn_file_blue" style="width:60px;">'+ '완료' +'</button>';
					html += '<span class="ac-bg-color">'+ makeDate(datas[i].CONTRACT_DT,'/') +'</span></td>';
					flag3 ++;
				}else{
					html += '<td><button class="btn_file_gray" style="width:60px;margin-bottom:14px;">'+ '-' +'</button></td>';
				}
				
				/* 개발  - endFlag :C001착수전,C002프로젝트진행30%,C003프로젝트진행50%,C004프로젝트진행70%,C005프로젝트진행90,C006완수*/
				var STATE_TYPE = common.nvl(datas[i].STATE_TYPE,'');
				var PROJECT_STATUS = common.nvl(datas[i].PROJECT_STATUS,'');
				
				if(STATE_TYPE == 'C002' || STATE_TYPE == 'C003' || STATE_TYPE == 'C004' || STATE_TYPE == 'C005'){
					html += '<td><button class="btn_file_yellow" style="width:60px;">'+ PROJECT_STATUS +'</button>';
					html += '<span class="pn-bg-color">'+ "pn." + makeDate(datas[i].TERM_START_DT,'/')+'</span></td>';
				}else if(STATE_TYPE == 'C001'){
					html += '<td><button class="btn_file_gray" style="width:60px;">'+ '착수전' +'</button>';
					html += '<span class="pn-bg-color">'+ "pn." + makeDate(datas[i].TERM_START_DT,'/')+'</span></td>';
				}else if(STATE_TYPE == 'C006' ){
					html += '<td><button class="btn_file_blue" style="width:60px;">'+ '완수' +'</button>';
					html += '<span class="pn-bg-color">'+ "pn." + makeDate(datas[i].TERM_START_DT,'/')+'</span></td>';
					flag4 ++;
				}
				
				/* 오픈 */
				if(common.nvl(datas[i].OPEN_DT,'') != ''){
					html += '<td><button class="btn_file_blue" style="width:60px;">'+ '완료' +'</button>';
					html += '<span class="ac-bg-color">'+ makeDate(datas[i].OPEN_DT,'/') +'</span></td>';
					flag5 ++;
				}else{
					html += '<td><button class="btn_file_gray" style="width:60px;margin-bottom:14px;">'+ '-' +'</button></td>';
				}
				
				/* 검수 */
				if(common.nvl(datas[i].TEST_DT,'') != ''){
					html += '<td><button class="btn_file_blue" style="width:60px;">'+ '완료' +'</button>';
					html += '<span class="pn-bg-color">'+ "pn."+ makeDate(datas[i].TERM_END_DT,'/') +'</span>';
					html += '<span class="ac-bg-color">'+ makeDate(datas[i].TEST_DT,'/') +'</span></td>';
					flag6 ++;
				}else if(common.nvl(datas[i].TEST_DT,'') == ''){
					html += '<td><button class="btn_file_gray" style="width:60px;">'+ '-' +'</button>';
					html += '<span class="pn-bg-color">'+ "pn."+ makeDate(datas[i].TERM_END_DT,'/') +'</span></td>';
				}
				
				html += '</tr>';
			}
			
			$('#project_tb_body').html(html);
			$('#pro1').text(flag1);
			$('#pro2').text(flag2);
			$('#pro3').text(flag3);
			$('#pro4').text(flag4);
			$('#pro5').text(flag5);
			$('#pro6').text(flag6);
			
		}else{
			
			var html ='';
			html += '<tr>';
			html += '<td style="background-color: #f6f6f6" colspan="10">조회된 데이터가 없습니다</td>';
			html += '</tr>';
			$('#project_tb_body').html(html);
			
		}
		
		 
	}
	
	
	function goProDetail(pro_seq){
		var queryString = "?pageType=update&pro_seq=" + pro_seq;
		location.href = "/ad/project/form.do" + queryString;
	}
	
	//유지보수 계약 정보 카운팅
	function getOperCount(cust_gubun){
		var datas = {'cust_gubun' :cust_gubun } ; 
		common.ajaxCall(datas, '/ad/main/getOpercontractCount.do', 'setOperCount') ;
	}
	
	function setOperCount(data){
		var data = typeof data.resultList[0] != "undefined" ? data.resultList[0] : null ;
		if(data != null){
			$('#A1').html(data.A1);
			$('#A2').html(data.A2);
			$('#A3').html(data.A3);
			$('#A4').html(data.A4);
			$('#A5').html(data.A5);
			$('#A6').html(data.A6);
			$('#A7').html(data.A7);
		}else{
			$('#A1').html('0');
			$('#A2').html('0');
			$('#A3').html('0');
			$('#A4').html('0');
			$('#A5').html('0');
			$('#A6').html('0');
			$('#A7').html('0');
		}
	}
	
	//유지보수 계약정보
	function getOperContractInfo(gubun){
		var datas = {'cust_gubun' : FCUSTGUBUN, 'gubun' : gubun} ; 
		common.ajaxCall(datas, '/ad/main/getOpercontractInfo.do', 'setOperContractInfo') ;
	} 
	
	function setOperContractInfo(data){
		var data = typeof data.resultList != "undefined" ? data.resultList : null ;
		$("#contractTbody").empty();
		if(data == null){ return;
		}else{
			var htmlStr = "";
		    for (var i=0; i < data.length; i++){
		    	var num = i+1; 
				htmlStr += '<tr style="cursor:pointer" onclick="goCustDetail(\''+ data[i].SEQ +'\')">';
				htmlStr += '	<td>' + num +'</td>';
				htmlStr += '	<td class="textL">' + data[i].CUST_KOR_NAME + ' ['+data[i].CUST_CODE+']'+'</td>';
				htmlStr += '	<td>' + data[i].ITEM_GRP3_NM + '</td>';
				if(data[i].COST_GUBUN == '1' ){
					htmlStr += '	<td>' + '유상' + '</td>';
				}else if(data[i].COST_GUBUN == '2'){
					htmlStr += '	<td>' + '무상' + '</td>';
				}
				htmlStr += '	<td>' + makeDate(data[i].CONTR_ST_DT,'/') +' ~ '+ makeDate(data[i].CONTR_END_DT,'/')+'</td>';
				htmlStr += '	<td>' + numberWithCommas(data[i].AMT) +'</td>';
				htmlStr += '</tr>';
			}
		    $("#contractTbody").html(htmlStr);
		}
	}
	
</script>

<form name="listFrm" id="listFrm" method="post" onsubmit="return false;">
	<input type="hidden" name="firstFlag" value="1"	/> <!--거래처현황 페이지  -->
	<input type="hidden" name="secondFlag" value="1" /> <!-- 거래처 유형 -->
</form>
<ul class="tab_dashboard list2 mgt30 mgb10">
	<li id="Firstli1"><a href="javascript:firstTab('');">A/S</a></li><!-- 활성시 current -->
	<li id="Firstli2" class="active"><a href="javascript:firstTab('2');">프로젝트/운영관리</a></li>
</ul>
<!-- 거래처구분 자동화필요  -->
<ul class="tab_line big list4 mgb10" style="margin-bottom:0px;">
	<li id="Secondli1" class="active"><a href="javascript:custGubunTab('1');">전체</a></li>
	<li id="Secondli2" ><a href="javascript:custGubunTab('2');">대외기업</a></li>
	<li id="Secondli3" ><a href="javascript:custGubunTab('3');">JW</a></li>
	<li id="Secondli4" ><a href="javascript:custGubunTab('4');">CIT</a></li>
</ul>
<div class="tit_wrap small">
	<h3 class="tit_ico_notice" id="setTab1SolutionLeftTitle"></h3>
</div>
<ul class="list6 db-list mgb20" style="width:calc(100% + 8px)">
	<li id="Secondli1" class="pdr8 active"  style="cursor:pointer;">
		<div class="db-greybox colorBlack">총 프로젝트<span class="num_db pdl8" id="pro1">0</span></div>
	</li>
	<li id="Secondli2" class="pdr8"  style="cursor:pointer;">
		<div class="db-greybox colorBlack">수주심의(확정)<span class="num_db pdl8" id="pro2">0</span></div>
	</li>
	<li id="Secondli3" class="pdr8"  style="cursor:pointer;">
		<div class="db-greybox">계약(완료)<span class="num_db pdl8" id="pro3">0</span></div>
	</li>
	<li id="Secondli4" class="pdr8"  style="cursor:pointer;">
		<div class="db-greybox">개발(완료)<span class="num_db pdl8" id="pro4">0</span></div>
	</li>
	<li id="Secondli5" class="pdr8"  style="cursor:pointer;">
		<div class="db-greybox">오픈(완료)<span class="num_db pdl8" id="pro5">0</span></div>
	</li>
	<li id="Secondli6" class="pdr8"  style="cursor:pointer;">
		<div class="db-greybox">최종검수(완료)<span class="num_db pdl8" id="pro6">0</span></div>
	</li>
</ul>
<div class="floatWrap mgb10">
	<table class="calendarTb">
		<colgroup>
			<col style="width:50px">
			<col style="width:120px">
			<col style="width:80px">
			<col style="width:140px">
			<col style="width:70px">
			<col span="5" style="width:auto">
		</colgroup>
		<thead>
			<tr>
				<th  rowspan="2">No</th>
				<th  rowspan="2">고객사</th>
				<th  rowspan="2">제품</th>
				<th  rowspan="2">프로젝트명</th>
				<th  rowspan="2">PM명</th>
				<th  colspan="5">진행 현황</th>
			</tr>
			<tr>
				<th>수주심의</th>
				<th>계약</th>
				<th>개발</th>
				<th>오픈</th>
				<th>검수</th>
			</tr>
		</thead>
		<tbody id="project_tb_body">
			
		</tbody>
	</table>
</div>

<!-- 유지보수 계약 현황 -->
<div class="tit_wrap small">
	<h3 class="tit_ico_notice">유지보수 계약현황</h3>
</div>

<div id="Thirddiv1">
	<ul class="pro_arrow light mgb5">
		<li class="w200 mgr5 current" style="background-color:#404345;">총 유지보수</li>
		<li class="w200">무상</li>
		<li class="w150">유상지연</li>
		<li class="w202">유상</li>
		<li class="w240">계약 갱신(계약 만료)</li>
	</ul>
	<div class="floatWrap mgb20">
		<div class="db-greybox blue w200 mgr5 floatL">
			<ul style="margin-top:0px;">
				<li class="num_db colorBlue" onclick="javascript:getOperContractInfo('A1');" style="cursor:pointer;"><span id="A1">0</span></li></ul>
		</div>
		<div class="db-greybox blue w200 mgr-1 floatL">
			<ul style="margin-top:0px;">
				<li class="num_db" onclick="javascript:getOperContractInfo('A2');" style="cursor:pointer;"><span id="A2">0</span></li>
			</ul>
		</div>
		<div class="db-greybox blue w150 mgr5 floatL">
			<ul style="margin-top:0px;">
				<li class="num_db" onclick="javascript:getOperContractInfo('A3');" style="cursor:pointer;"><span id="A3">0</span></li>
			</ul>
		</div>
		<div class="db-greybox blue w200 mgr-1 floatL">
			<ul style="margin-top:0px;">
				<li class="num_db" onclick="javascript:getOperContractInfo('A4');" style="cursor:pointer;"><span id="A4">0</span></li>
			</ul>
		</div>
		<div class="db-greybox  blue w240  floatL">
			<ul class="list3">
				<li class="num_db" onclick="javascript:getOperContractInfo('A5');" style="cursor:pointer;"><span id="A5">0</span><p class="small">(1년차)</p></li>
				<li class="num_db" onclick="javascript:getOperContractInfo('A6');" style="cursor:pointer;"><span id="A6">0</span><p class="small">(2년차)</p></li>
				<li class="num_db" onclick="javascript:getOperContractInfo('A7');" style="cursor:pointer;"><span id="A7">0</span><p class="small">(3년차↑)</p></li>
			</ul>
		</div>
	</div>
</div>

<div class="floatWrap mgb10">
    <table class="bcTb">
		<colgroup>
   			<col style="width: 80px;">
   			<col style="width: 240px;">
   			<col style="width: 240px;">
   			<col style="width: 120px;">
   			<col style="width: 220px;">
   			<col style="width: 200px;">
		</colgroup>
		<thead>
			<tr>
				<th>No</th>
				<th>거래처명</th>
				<th>품목명</th>
				<th>계약구분</th>
				<th>계약기간</th>
				<th>유지보수금액</th>
			</tr>
		</thead>
		<tbody id="contractTbody"></tbody>
	</table>
</div>

<!-- 프로젝트 레이어팝업 -->
<div id="projectListLayer" style="display:none;">
	<div class="box_layer layer_sms" style="height:700px;margin-top:-400px;">
		<h1>거래처목록</h1>
		<div class="layer_contents" style="padding-top:20px;height:600px;overflow-y:auto;">
			<table class="hType mgb20">
				<caption>프로젝트 정보</caption>
				<colgroup>
					<col style="width:150px;" />
					<col style="width:100px;" />
					<col style="width:80px;" />
					<col style="width:150px;" />
					<col style="width:auto;" />
					<col style="width:auto;" />
				</colgroup>
				<tr>
					<th>거래처명</th>
					<th>프로젝트명</th>
					<th>시스템유형</th>
					<th>투입기간</th>
					<th>시스템 오픈일</th>
					<th>참여인원수</th>
				</tr>
				<tbody id="projectListBody">
				</tbody>
			</table>
		</div>
		<button type="button" class="btn_close" onclick="$('#projectListLayer').hide()">창 닫기</button>
	</div>
	<div class="layer_dimmed"></div>
</div>





<style>
	.calendarTb  th{
	    height: 30px;
    	padding: 5px 2px;
    	font-weight: 700;
    	color: #fff;
    	text-align: center;
    	background-color: #404345;
    	border-right: 0;
    	border: solid 1px #fff; 
	}
	
	.calendarTb td{
		height: 60px;
	    padding: 5px 2px;
	    text-align: center;
	    border: 1px solid #dadada;
	}
	
	.bcTb {
	    display: block;
    	overflow-y: auto;
   		min-height: 300px;
   		max-height: 300px;
    }
	.bcTb th{
	    height: 30px;
    	padding: 5px 2px;
    	font-weight: 700;
    	color: #fff;
    	text-align: center;
    	background-color: #404345;
    	border-right: 0;
    	border: solid 1px #fff; 
	}
	.bcTb td{
		height: 30px;
	    padding: 5px 2px;
	    text-align: center;
	    border-bottom: 1px solid #dadada;
	}
	
	.ac-bg-color {
    	background-color: aliceblue;
	}
	.pn-bg-color {
    background-color: antiquewhite;
	}
</style>




