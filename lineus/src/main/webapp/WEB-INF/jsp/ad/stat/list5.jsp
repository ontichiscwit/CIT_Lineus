<%@page import="egovframework.com.comm.util.CommonExecute"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javascript" src="/js/jquery.mtz.monthpicker.js"></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

<script type="text/javascript">
	var exlHeaderList;
	var exlDataList;
	
	google.charts.load('current', {'packages':['line']});
	
	$(document).ready(function(){
		init();
		$("#btnSubmit").click();
	});
	
	function changeRangeType(obj){

		if (obj.value == "mon"){
			$( "#search_start" ).datepicker("destroy");
			$( "#search_end" ).datepicker("destroy");
			$( "#search_start" ).monthpicker(monthpicker_option);
			$( "#search_end" ).monthpicker(monthpicker_option);
			
			var cuDate = new Date();
			var lastDate = new Date(cuDate.getFullYear(),cuDate.getMonth() + 1, 0);
			var firstDate = new Date(cuDate.getFullYear(),cuDate.getMonth() - 13, 1);
			$( "#search_start" ).val($.datepicker.formatDate('yy/mm', firstDate));
			$( "#search_end" ).val($.datepicker.formatDate('yy/mm', lastDate));
			
		}else{
			$( "#search_start" ).monthpicker("destroy");
			$( "#search_end" ).monthpicker("destroy");
			$( "#search_start" ).datepicker(datepicker);
			$( "#search_end" ).datepicker(datepicker);
			
// 			var cuDate = new Date();
// 			var lastDate = new Date(cuDate.getFullYear(),cuDate.getMonth() + 1, 0);
// 			var firstDate = new Date(cuDate.getFullYear(),cuDate.getMonth(), 1);
// 			$( "#search_start" ).val($.datepicker.formatDate('yy/mm/dd', firstDate))
// 			$( "#search_end" ).val($.datepicker.formatDate('yy/mm/dd', lastDate))

			var cuDate = new Date();
			var lastDate = new Date();
			lastDate.setDate(cuDate.getDate() - 6);
			$( "#search_start" ).val($.datepicker.formatDate('yy/mm/dd', lastDate));
			$( "#search_end" ).val($.datepicker.formatDate('yy/mm/dd', cuDate));

		}
	}
	
	function init(){
		$("#rangeType").change();
		$("#accept_route").click();
	}
	
	function makeList(data){
		
		console.log(data);
		
		if (!data.resultCode || data.resultCode != "000"){
			if (data.errorMsg) alert(data.errorMsg);
			return;
		}
		
		if (!data.resultHeader){
			alert("헤더정보가 없습니다.");
			return;
		}
		
		if (!data.resultList){
			alert("데이터가 존재하지 않습니다.");
			return;
		}
		
		if (data.resultList.length == 0){
			alert("조회된 데이터가 없습니다.");
			$("#tot_count").html(0);
			$("#tBody").html("");
			return;
		}
		
		$("#tot_count").html(data.resultList.length);
		
		var headerList = data.resultHeader;
		var dataList = data.resultList;
		var totObj = new Object();
		
		// 헤더 HTML을 만든다.
		var headerHtml = "";
		headerHtml += '<tr>';
		for (var i=0; i < headerList.length; i++){
			headerHtml += '<th scope="col">'+headerList[i].label+'</th>';
		}
		headerHtml += '</tr>';
		$("#tHeader").html(headerHtml);
		
		// 데이터 리스트를 이용하여 총합 object 값을 채운다.
		for (var i=0; i < dataList.length; i++){
			for (var j=0; j < headerList.length; j++){
				
				if (headerList[j].dType == "sum"){
					if (!totObj[headerList[j].fieldName]) totObj[headerList[j].fieldName] = 0;
					totObj[headerList[j].fieldName] += dataList[i][headerList[j].fieldName];
				}
			}
		}
		
		// 총합 object의 라벨 및 평균을 셋팅한다.
		for (var i=0; i < headerList.length; i++){
			
			if (headerList[i].dType == "label"){
				totObj[headerList[i].fieldName] = headerList[i].ref;
			}else if (headerList[i].dType == "avg"){
				totObj[headerList[i].fieldName] = (totObj[headerList[i].ref] * 100 / totObj["TOT"]).toFixed(2); 
			}
// 			console.log(headerList[i].fieldName + ":" + totObj[headerList[i].fieldName]);
		}
		
		// 총합 object를 dataList에 추가 한다.
		dataList.unshift(totObj);

		// 바디 HTML을 만든다.
		var bodyHtml = "";
		for (var i=0; i < dataList.length; i++){
			bodyHtml += "<tr>";
			
			for (var j=0; j < headerList.length; j++){
				if (i == 0 ){
					if (headerList[j].fieldName == "TOT"){
						bodyHtml += '<th class="colorRed">'+dataList[i][headerList[j].fieldName]+'</th>';
					}else{
						bodyHtml += '<th>'+dataList[i][headerList[j].fieldName]+'</th>';
					}
					
				}else {
					bodyHtml += '<td>'+dataList[i][headerList[j].fieldName]+'</td>';
				}
			}
			
			bodyHtml += "</tr>";
		}
		$("#tBody").html(bodyHtml);
		
		exlHeaderList = headerList;
		exlDataList = dataList;
		
// 		console.log(exlHeaderList);
// 		console.log(exlDataList);
		
		google.charts.setOnLoadCallback(drawChart);
	}
	
	function drawChart() {

		var data = new google.visualization.DataTable();
		data.addColumn('string', '');
		
		// 해더 라벨 처리
		for (var i=1; i < exlDataList.length; i++){
			data.addColumn('number', exlDataList[i]["NAME"]);
		}
		
		for (var i=2; i < exlHeaderList.length; i++){
			var tmp = [];
			tmp.push(exlHeaderList[i].label);
			
			for (var j=1; j < exlDataList.length; j++){
				tmp.push(exlDataList[j][exlHeaderList[i].fieldName]);
			}
			
			data.addRow(tmp);
		}

		var options = {
			width : 990,
			height : 300,
			legend : {position : 'bottom'}
		};

		var chart = new google.charts.Line(document.getElementById('chart'));
		chart.draw(data, google.charts.Line.convertOptions(options));
	}

	
	function goExl(){
		if (!exlHeaderList || !exlDataList){
			alert("다운로드할 데이터가 없습니다.");
		}

		var dataObject = new Object();
		dataObject["headerList"] = exlHeaderList;
		dataObject["dataList"] = exlDataList;

		var f = document.excelForm ; 
		
		try{
			$("#exlFrame").remove() ;
		}catch(e){}
		
		var downFrame = $('<iframe id="exlFrame" name="exlFrame" style="width:0px; height=0px ; display:none;"></iframe>') ; 
		downFrame.appendTo("body") ;
		
		f.target = "exlFrame" ;
		f.action = "/ad/stat/stat2Exl.do" ;
		f.data.value = JSON.stringify(dataObject);
		f.submit() ; 

	}
	
	function goSearch(){
		var frm = document.listFrm;
		
		frm.search_start.value = common.replaceAll(frm.search_start.value,'/','');
		frm.search_end.value = common.replaceAll(frm.search_end.value,'/','');
		
		exlHeaderList = null;
		exlDataList = null;
		
		common.ajaxCall($(frm).serialize(), '/ad/stat/getListByRange.do', 'makeList') ;
		
		frm.search_start.value = makeDate(frm.search_start.value);
		frm.search_end.value = makeDate(frm.search_end.value);
	}
	
</script>

<div class="tit_wrap">
	<%= CommonExecute.returnLineMap(request) %>
</div>
<!-- search -->

<form id="listFrm" name="listFrm" method="post" onsubmit="return false">
	<table class="sType mgb10">
		<caption>유형별 A/S현황 검색</caption>
		<colgroup>
			<col style="width:140px;" />
			<col style="width:auto;" />
		</colgroup>
		<tr>
			<th scope="row">기간선택</th>
			<td>
				<select id="rangeType" class="mgr5 w100" onchange="changeRangeType(this)">
					<option value="mon">월별</option>
					<option value="day">일별</option>
				</select>
			    <input type="text" class="w100 mgr5" name="search_start" id="search_start" readonly>~
				<input type="text" class="w100 mgl10 mgr5" name="search_end" id="search_end" readonly>
			</td>
		</tr>
		<tr>
			<th scope="row">처리코드 선택</th>
			<td>
				<input type="radio" class="mgr5" name="search_type" id="accept_route" value="accept_route" >접수경로
			    <input type="radio" class="mgl10 mgr5" name="search_type" id="service_cate" value="service_cate" >문의유형
			    <input type="radio" class="mgl10 mgr5" name="search_type" id="cause_type" value="cause_type" >원인유형
			    <input type="radio" class="mgl10 mgr5" name="search_type" id="action_type" value="action_type" >조치유형
			</td>
		</tr>
		
	</table>
</form>
<div class="info_upper mgb5">
	<div class="floatR">
		<button type="button" class="btn_ico_search mgr5" id="btnSubmit" onclick="goSearch()"><span>검색</span></button>
		<button type="button" class="btn_ico_excel" onclick="goExl()"><span>엑셀다운로드</span></button>
	</div>
</div>

<div id="chart" style="min-height:300px;margin-bottom:10px;">
<!-- 그래프 영역 -->
</div>
<!--// search -->
<div class="info_upper mgb5">
	<div class="sorting">
		조회건수 : <strong><span class="count" id="tot_count">0</span> 건</strong>
	</div>
	
</div>
<!-- list -->
<table class="hType mgb10">
	<caption>유형별 A/S현황</caption>
	<colgroup>
		
    </colgroup>
	<thead id="tHeader">
	</thead>
	
	<tbody id="tBody">
	</tbody>
</table>
<form name="excelForm" method="post">
<input type="hidden" name="data"/>
</form>
<!--// list -->
