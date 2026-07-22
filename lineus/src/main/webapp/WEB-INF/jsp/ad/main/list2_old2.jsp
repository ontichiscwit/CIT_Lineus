<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="egovframework.com.comm.util.DateTimeUtil"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript" src="/js/jquery.mtz.monthpicker.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<script type="text/javascript">

	var FcustGubun;
	var CHARINFO;
	google.charts.load('current', {'packages': ['corechart', 'bar']});		/**	a/s 추이 그래프	*/
	
	$(document).ready(function(){
		// 현 날짜 구하기
		var cuDate = new Date();
		var yyyymm = cuDate.getFullYear() + " 년 ";
		$("#setTab1SolutionLeftTitle").html(yyyymm + " 프로젝트 진행현황");
		
		goInfo() ;
	}) ;
	
	function goInfo(){
		custGubunTab('1');
		getOperCount('0');
		goChart('');
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
		getProjectCount(custGubunFlag);
		
	}
	
	//프로젝트 진행현황
	function getProjectCount(cust_gubun){
		var datas = {'cust_gubun': cust_gubun} ; 
		common.ajaxCall(datas, '/ad/main/getProjectCount.do', 'setProjectCount') ;
	}
	
	function setProjectCount(data){
		var info = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		if(info[0]==null){
			$('#pro1').html('0');
			$('#pro2').html('0');
			$('#pro3').html('0');
			$('#pro4').html('0');
			$('#pro5').html('0');
			$('#pro6').html('0');
		}else{
			$('#pro1').html(common.nvl(info[0].F1),'0');
			$('#pro2').html(common.nvl(info[0].F2),'0');
			$('#pro3').html(common.nvl(info[0].F3),'0');
			$('#pro4').html(common.nvl(info[0].F4),'0');
			$('#pro5').html(common.nvl(info[0].F5),'0');
			$('#pro6').html(common.nvl(info[0].F6),'0');
		}
	}
	
	function getProjectInfo(gubun){
		var cust_gubun = FcustGubun;
		var datas = {'cust_gubun': cust_gubun, 'gubun' :gubun } ; 
		common.ajaxCall(datas, '/ad/main/getProjectInfo.do', 'setProjectInfo') ;
	}
	
	function setProjectInfo(data){
		var proList = typeof data.resultList != "undefined" ? data.resultList : null ;
		console.log(proList);
		if (proList == null ) return;
		var htmlStr = "";
		    for (var i=0; i < proList.length; i++){
			htmlStr += '<tr style="cursor:pointer" onclick="goProDetail(\''+ proList[i].PRO_SEQ +'\')">';
			htmlStr += '	<td>' + proList[i].CUST_KOR_NAME + ' ['+proList[i].ERP_CODE+']'+'</td>';
			htmlStr += '	<td class="uder_line">' + common.nvl(proList[i].PROJECT_NM,'') +  '</td>';
			htmlStr += '	<td>' + common.nvl(proList[i].SYSTEM_CODE_NM,'') + '</td>';
			htmlStr += '	<td>' + common.strToDate(proList[i].TERM_START_DT)+'~'+common.strToDate(proList[i].TERM_END_DT)+ '</td>';
			htmlStr += '	<td>' + common.nvl(common.strToDate(proList[i].OPEN_DT),'') + '</td>';
			htmlStr += '	<td>' + common.nvl(proList[i].WORKER_CNT,'') + '</td>';
			htmlStr += '</tr>';
		}
		$("#projectListBody").html(htmlStr);
		$("#projectListLayer").show(); 
	}
	
	
	function goProDetail(pro_seq){
		var queryString = "?pageType=update&pro_seq=" + pro_seq;
		location.href = "/ad/project/form.do" + queryString;
	}
	
	//유지보수 카운팅
	function getOperCount(gubun){
		if(gubun == '0'){gubun = "";}
		var datas = {'gubun' :gubun } ; 
		common.ajaxCall(datas, '/ad/main/getOpercontractCount.do', 'setOperCount') ;
	}
	
	
	function setOperCount(data){
		
		var data = typeof data.resultList[0] != "undefined" ? data.resultList[0] : null ;
		if(data != null){
			$('#a1').html(data.A1);
			$('#a2').html(data.A2);
			$('#a3').html(data.A3);
			$('#a4').html(data.A4);
			$('#a5').html(data.A5);
			$('#a6').html(data.A6);
			$('#b1').html(data.B1);
			$('#b2').html(data.B2);
			$('#b3').html(data.B3);
			$('#b4').html(data.B4);
			$('#b5').html(data.B5);
			$('#b6').html(data.B6);
			$('#b7').html(data.B7);
		}else{
			$('#a1').html('0');
			$('#a2').html('0');
			$('#a3').html('0');
			$('#a4').html('0');
			$('#a5').html('0');
			$('#a6').html('0');
			$('#b1').html('0');
			$('#b2').html('0');
			$('#b3').html('0');
			$('#b4').html('0');
			$('#b5').html('0');
			$('#b6').html('0');
			$('#b7').html('0');
		}
		
	}
	
	
	function goChart(gubun){
		var datas = {
				'cust_gubun' : ''
				,'gubun' : gubun
				,'bill_code' : ''
		}
		common.ajaxCall(datas, '/ad/main/getOperChart.do', 'makeAsInfo') ;
	}
	
	function makeAsInfo(data){
		var info = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		if(info.length != 0){
			CHARINFO = info ; 
			google.charts.setOnLoadCallback(drawBasic);
		}else if(info == null || info.length == 0){
			$('#chart_div').empty();
		}
	}
	
	
	function drawBasic() {
		
		
		 var data = new google.visualization.DataTable();
	      data.addColumn('string', '거래처');
	      data.addColumn('number', 'A/S건수');
	      data.addColumn({type: 'string', role: 'annotation'});
	      
	      
	      var arr =[];
	      for(var i =0;  i < CHARINFO.length; i++ ){
			var temp = [];
			temp.push(CHARINFO[i].CUST_KOR_NAME ,parseInt(CHARINFO[i].AS_COUNT),CHARINFO[i].CUST_CODE);
			arr.push(temp);
		 }
	      
	      data.addRows(arr);

	      
	      var options = {
	        title: '당월 A/S건수',
	        hAxis: {
	          title: '거래처',
	          viewWindow: {
	            min: [7, 30, 0],
	            max: [17, 30, 0]
	          }
	        },
	        vAxis: {
	          title: 'A/S건수'
	        }
	        
	      };

	      var chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));
	      chart.draw(data, options);
	      google.visualization.events.addListener(chart, 'select', selectHandler);
	      
	      
		      function selectHandler() {
		  		var selection = chart.getSelection();
		  		
  				var cust_nm = data.getValue(chart.getSelection()[0].row, 0);
  				var cust_code = data.getValue(chart.getSelection()[0].row, 2);
		  				
		  		console.log(cust_code);
		  		getOperChartAmt(cust_code);
		  	}
	      
	    }
	
	
	function getOperChartAmt(cust_code){
		var datas = {
				'cust_code' : cust_code
		}
		common.ajaxCall(datas, '/ad/main/getAsAmtInfobyCust.do', 'setOperChartAmt') ;
	}
	function setOperChartAmt(data){
		var data = typeof data.info != 'undefined' ? data.info : null;
		if(data == null ){ 
			$('#chart_num1').html('0');
			$('#chart_num2').html('0');
			$('#chart_num3').html('0');
		}else{
			$('#chart_num1').html(common.comma(data.AMT));
			$('#chart_num2').html(data.AS_COUNT);
			$('#chart_num3').html(common.comma(data.AS_AMT));
			$('#chart_num4').html('1h ' + common.comma(data.HOURS_AMT));
			
		}
		
		
	}
	
	
	
</script>

<style>

.progress {
    height: 20px;
    margin-bottom: 20px;
    overflow: hidden;
    background-color: #f5f5f5;
    border-radius: 4px;
    -webkit-box-shadow: inset 0 1px 2px rgba(0,0,0,.1);
    box-shadow: inset 0 1px 2px rgba(0,0,0,.1);
}

.progress-bar {
    float: left;
    width: 0;
    height: 100%;
    font-size: 12px;
    line-height: 20px;
    color: #fff;
    text-align: center;
    background-color: #337ab7;
    -webkit-box-shadow: inset 0 -1px 0 rgba(0,0,0,.15);
    box-shadow: inset 0 -1px 0 rgba(0,0,0,.15);
    -webkit-transition: width .6s ease;
    -o-transition: width .6s ease;
    transition: width .6s ease;
}


.numdiv{
cursor:pointer;
margin-bottom: 20px;
margin-left: 20px;
}


</style>

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

<%-- <div class="floatWrap mgb5">
	<table>
	<colgroup>
		<col style="width:400px;" />
		<col style="width:100px;" />
		<col style="width:400px;" />
		<col style="width:100px;" />
	</colgroup>
		<tr>
			<td>
				<div class="progress">
		  			<div class="progress-bar" role="progressbar" aria-valuenow="10"aria-valuemin="0" aria-valuemax="100" style="width:10%">착수</div>
				</div>
			</td>
			<td><span class="num_db numdiv" id="pro1" onclick="javascript:getProjectInfo('1')">0</span></td>
			<td>
				<div class="progress">
		  			<div class="progress-bar" role="progressbar" aria-valuenow="30"aria-valuemin="0" aria-valuemax="100" style="width:30%">프로젝트 진행 30%</div>
				</div>
			</td>
			<td><span class="num_db numdiv" id="pro2" onclick="javascript:getProjectInfo('2')">0</span></td>
		</tr>
		<tr>
			<td>
				<div class="progress">
		  			<div class="progress-bar" role="progressbar" aria-valuenow="50"aria-valuemin="0" aria-valuemax="100" style="width:50%">프로젝트 진행 50%</div>
				</div>
			</td>
			<td><span class="num_db numdiv " id="pro3" onclick="javascript:getProjectInfo('3')">0</span></td>
			<td>
				<div class="progress">
		  			<div class="progress-bar" role="progressbar" aria-valuenow="70"aria-valuemin="0" aria-valuemax="100" style="width:70%">프로젝트 진행 70%</div>
				</div>
			</td>
			<td><span class="num_db numdiv " id="pro4" onclick="javascript:getProjectInfo('4')">0</span></td>
		</tr>
		<tr>
			<td>
				<div class="progress">
		  			<div class="progress-bar" role="progressbar" aria-valuenow="90"aria-valuemin="0" aria-valuemax="100" style="width:90%">프로젝트 진행 90%</div>
				</div>
			</td>
			<td><span class="num_db numdiv " id="pro5" onclick="javascript:getProjectInfo('5')">0</span></td>
			<td>
				<div class="progress">
		  			<div class="progress-bar" role="progressbar" aria-valuenow="100"aria-valuemin="0" aria-valuemax="100" style="width:100%">완수</div>
				</div>
			</td>
			<td><span class="num_db numdiv " id="pro6" onclick="javascript:getProjectInfo('6')">0</span></td>
		</tr>
	</table>
</div> --%>
<ul class="list3 db-list mgb20" style="width:calc(100% + 8px)">
	<li id="Secondli1" class="pdr8 active" onclick="javascript:secondTab('1');" style="cursor:pointer;">
		<div class="db-greybox colorBlack">착수전<span class="num_db pdl8" id="top1">184</span></div>
	</li>
	<li id="Secondli2" class="pdr8" onclick="javascript:secondTab('2');" style="cursor:pointer;">
		<div class="db-greybox">개발진행중<span class="num_db pdl8" id="top2">14</span></div>
	</li>
	<li id="Secondli3" class="pdr8" onclick="javascript:secondTab('3');" style="cursor:pointer;">
		<div class="db-greybox">완료<span class="num_db pdl8" id="top3">128</span></div>
	</li>
</ul>
<div class="floatWrap mgb5">
<table class="calendarTb">
	<thead>
		<tr>
			<th  rowspan="2">제품</th>
			<th  rowspan="2">프로젝트명</th>
			<th  rowspan="2">고객사</th>
			<th  rowspan="2">프로젝트기간</th>
			<th  colspan="5">진행 현황</th>
			
		</tr>
		<tr>
			<th>수주심의</th>
			<th>계약</th>
			<th>인력투입</th>
			<th>구축</th>
			<th>종료</th>
		</tr>
		
	</thead>
	<tbody>
		<tr>
			<td>ERP</td>
			<td>JW 신약구축</td>
			<td>JW 신약</td>
			<td>2018/09/01 ~ 2019/10/11</td>
			<td>완료</td>
			<td>완료</td>
			<td>완료</td>
			<td>완료</td>
			<td>완료</td>
		</tr>
		<tr>
			<td>ERP</td>
			<td>JW 신약구축</td>
			<td>JW 신약</td>
			<td>2018/09/01 ~ 2019/10/11</td>
			<td>완료</td>
			<td>완료</td>
			<td>완료</td>
			<td>완료</td>
			<td>완료</td>
		</tr>
		<tr>
			<td>ERP</td>
			<td>JW 신약구축</td>
			<td>JW 신약</td>
			<td>2018/09/01 ~ 2019/10/11</td>
			<td>완료</td>
			<td>완료</td>
			<td>완료</td>
			<td>완료</td>
			<td>완료</td>
		</tr>
	</tbody>
</table>

</div>





<!-- <div style="width: 100%; height:400px; background-color:#373737b8;">
	<p style="font-size: 36px; font-weight: 700; line-height: 1.2em; letter-spacing: -0.05em; margin: 50px 0 20px;">준비 중 입니다.</p>
</div>
 -->
 
 <!-- 
<div class="tit_wrap small">
	<h3 class="tit_ico_notice">유지보수 계약현황</h3>
</div>
<div class="mgb20">
	<ul class="list4 db-list">
		<li id="Secondli1" class="pdr8 active" onclick="javascript:getOperCount('0');" style="cursor:pointer;"><div class="db-greybox colorBlack">총 계약<span class="num_db pdl8" id="top1">5</span></div></li>
		<li id="Secondli2" class="pdr8" onclick="javascript:getOperCount('1');" style="cursor:pointer;"><div class="db-greybox">ONTIC SMARTWORKS<span class="num_db pdl8" id="top2">3</span></div></li>
		<li id="Secondli3" class="pdr8" onclick="javascript:getOperCount('2');" style="cursor:pointer;"><div class="db-greybox">ONTIC ERP<span class="num_db pdl8" id="top3">2</span></div></li>
		<li id="Secondli4" class="pdr8" onclick="javascript:getOperCount('3');" style="cursor:pointer;"><div class="db-greybox">제품미정<span class="num_db pdl8" id="top4">0</span></div></li>
	</ul>
</div>	

<div id="Thirddiv1">
	<ul class="pro_arrow light mgb5">
		<li class="w100 current">무상</li>활성시 current
		<li class="w152">유상 전환 예정</li>
		<li class="w202">유상 전환 지연</li>
		<li class="w115">유상</li>
		<li class="w201">갱신 전환 예정</li>
		<li class="w230">계약 갱신/계약 만료</li>
	</ul>
	
	<div class="floatWrap mgb20">
		<div class="db-greybox blue w100 mgr5 floatL">
			<p>총 무상 </p><ul><li class="num_db colorBlue" id="a1" onclick="javascript:goChart('a1');" style="cursor:pointer;">0</li></ul>
		</div>
		<div class="db-greybox blue w150 mgr-1 floatL">
			<p>무상 계약 만료 예정</p>
			<ul class="list2">
				<li class="num_db" onclick="javascript:goChart('a2');" style="cursor:pointer;"><span id="a2">0</span><p class="small">(1~2개월)</p></li>
				<li class="num_db" onclick="javascript:goChart('a3');" style="cursor:pointer;"><span id="a3">0</span><p class="small">(1개월↓)</p></li>
			</ul>
		</div>
		<div class="db-greybox blue w200 mgr5 floatL">
			<p class="colorRed">무상 계약 만료</p>
			<ul class="list3">
				<li class="num_db" onclick="javascript:goChart('a4');" style="cursor:pointer;"><span id="a4">0</span><p class="small">(1개월↓)</p></li>
				<li class="num_db" onclick="javascript:goChart('a5');" style="cursor:pointer;"><span id="a5">0</span><p class="small">(1~2개월)</p></li>
				<li class="num_db" onclick="javascript:goChart('a6');" style="cursor:pointer;"><span id="a6">0</span><p class="small">(3개월↑)</p></li>
			</ul>
		</div>
		
		<div class="db-greybox blue w109 mgr5 floatL">
			<p>총 유상</p><ul><li class="num_db colorBlue" id="b1" onclick="javascript:goChart('b1');" style="cursor:pointer;">0</li></ul>
		</div>
		<div class="db-greybox blue w201 floatL">
			<p>유상 계약 만료 예정</p>
			<ul class="list3">
				<li class="num_db" onclick="javascript:goChart('b2');" style="cursor:pointer;"><span id="b2">0</span><p class="small">(2~3개월)</p></li>
				<li class="num_db" onclick="javascript:goChart('b3');" style="cursor:pointer;"><span id="b3">0</span><p class="small">(1~2개월)</p></li>
				<li class="num_db" onclick="javascript:goChart('b4');" style="cursor:pointer;"><span id="b4">0</span><p class="small">(1개월↓)</p></li>
			</ul>
		</div>
		<div class="db-greybox blue w225  floatL">
			<p class="colorRed">(자동갱신Y)/계약만료</p>
			<ul class="list3">
				<li class="num_db" onclick="javascript:goChart('b5');" style="cursor:pointer;"><span id="b5">0</span><p class="small">(1년↑)</p></li>
				<li class="num_db" onclick="javascript:goChart('b6');" style="cursor:pointer;"><span id="b6">0</span><p class="small">(2년↑)</p></li>
				<li class="num_db" onclick="javascript:goChart('b7');" style="cursor:pointer;"><span id="b7">0</span><p class="small">(3년↑)</p></li>
			</ul>
		</div>
	</div>
</div>
<div id="Thirddiv2" style="height:300px;">	
	<div class="tit_wrap small">
		<h3 class="tit_ico_notice">유지보수 계약 거래처 A/S현황</h3>
	</div>
	<div class="floatL" style="width:80%; display:block;border:solid 1px #ffff;">
		<div id="chart_div"></div>
	</div>
	<div class="floatL" style="width:10%">
		<div class="db-greybox blue w200 mgb5 floatL" style="min-height:0px;">
			<p>당월 유지보수료 </p><ul style="height:40px"><li class="num_db colorBlue" id="chart_num1" style="font-size:35px !important;cursor:pointer;">0</li></ul>
		</div>
		<div class="db-greybox blue w200 mgb5 floatL" style="min-height:0px;">
			<p>당월A/S건수 </p><ul style="height:40px"><li class="num_db colorBlue" id="chart_num2" style="font-size:35px !important;cursor:pointer;">0</li></ul>
		</div>
		<div class="db-greybox blue w200 mgb5 floatL" style="min-height:0px;">
			<p>평균A/S비용</p><ul style="height:80px">
			<li class="num_db colorBlue" id="chart_num3" style="font-size:40px !important;cursor:pointer;">0</li>
			<li class="num_db colorRed" id="chart_num4" style="font-size:20px !important;cursor:pointer;">0</li>
			</ul>
		</div>
	</div>
</div>
 -->

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
	
	.calendarTb tr td:nth-child(5){
		background-color:#d1ebef;
	}
	.calendarTb tr td:nth-child(6){
		background-color:#acd9df;
	}
	.calendarTb tr td:nth-child(7){
		background-color:#91ced7;
	}
	.calendarTb tr td:nth-child(8){
		background-color:#60bbc8;
	}
	.calendarTb tr td:nth-child(9){
		background-color:#3da0ae;
	}
</style>




