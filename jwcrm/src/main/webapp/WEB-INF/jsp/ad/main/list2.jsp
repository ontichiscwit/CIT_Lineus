<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="egovframework.com.comm.util.DateTimeUtil"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

<script type="text/javascript">

	var myAsList;
	var teamAsList;

	google.charts.load('current', {'packages': ['corechart', 'line']});		/**	a/s 추이 그래프	*/
	google.charts.load('current', {'packages':['corechart']});				/**	원형	*/
	
	var CHARLIST = null ; 
	var CHARLIST2 = null ; 
	var CHARLIST3 = null ;

	$(document).ready(function(){
		goInfo() ; 
	}) ;
	
	function goInfo(){
		
		var firstFlag = "2" ; 
		var secondFlag = "" ; 
		var thirdFlag = "" ; 
		
		for(var i = 1 ; i <= 5 ; i++){
			if($('#Secondli' + i).hasClass("active")) secondFlag = i ;
		}	
		
		var datas = {
				'firstFlag' 			: firstFlag , 
				'secondFlag' 		: secondFlag , 
				'thirdFlag' 			: thirdFlag  
				
		} ; 
		
		common.ajaxCall(datas, '/ad/main/getMainInfo.do', 'makeInfo' + firstFlag) ;
		
	}
	
	function goSubInfo(){
		var firstFlag = "2" ; 
		var secondFlag = "" ; 
		
		for(var i = 1 ; i <= 5 ; i++){
			if($('#Secondli' + i).hasClass("active")) secondFlag = i ;
		}	
		
		var datas = {
				'firstFlag' 			: firstFlag , 
				'secondFlag' 		: secondFlag  
		} ; 
		
		common.ajaxCall(datas, '/ad/main/getMainSubInfo.do', 'makeSubInfo' + firstFlag) ;
		
		$('#his_gubun0').prop('checked' , true) ; 
		$('#as_gubun0').prop('checked' , true) ; 
		
		hisChartInfo('1') ; 
		asChartInfo('1') ; 
		getAsAnalList();
	}
	
	function hisChartInfo(his_gubun){
		
		$("input:radio[name=his_gubun]:input[value="+ his_gubun +"]").prop("checked",true);
		$("input:radio[name=his_gubun2]:input[value="+ his_gubun +"]").prop("checked",true);
		
		var firstFlag = "2" ; 
		var secondFlag = "" ; 
		
		for(var i = 1 ; i <= 5 ; i++){
			if($('#Secondli' + i).hasClass("active")) secondFlag = i ;
		}	
		
		var datas = {
				'firstFlag' 			: firstFlag , 
				'secondFlag' 		: secondFlag  ,
				'his_gubun'		: his_gubun
		} ; 
		
		common.ajaxCall(datas, '/ad/main/getMainHisChart.do', 'makeHisInfo' + firstFlag) ;
	}
	
	function asChartInfo(as_gubun){
		
		$("input:radio[name=as_gubun]:input[value="+ as_gubun +"]").prop("checked",true);
		$("input:radio[name=as_gubun2]:input[value="+ as_gubun +"]").prop("checked",true);
		
		var firstFlag = "2" ; 
		var secondFlag = "" ; 
		
		for(var i = 1 ; i <= 5 ; i++){
			if($('#Secondli' + i).hasClass("active")) secondFlag = i ;
		}	
		
		var datas = {
				'firstFlag' 			: firstFlag , 
				'secondFlag' 		: secondFlag  ,
				'as_gubun'			: as_gubun
		} ; 
		
		common.ajaxCall(datas, '/ad/main/getMainAsChart.do', 'makeAsInfo' + firstFlag) ;
	}
	
	function makeInfo2(data){
		var top1 = typeof data.top1 != "undefined" ? data.top1 : null ; 
		myAsList = typeof data.top2 != "undefined" ? data.top2 : null ; 
		teamAsList = typeof data.top3 != "undefined" ? data.top3 : null ; 
		
		if(top1 != null){
			$('#top1').empty().html(common.nvl(top1.tot_count , '0')) ; 
			$('#top2').empty().html(common.nvl(top1.flag1 , '0')) ; 
			$('#top3').empty().html(common.nvl(top1.flag2 , '0')) ; 
			$('#top4').empty().html(common.nvl(top1.flag3 , '0')) ; 
			$('#top5').empty().html(common.nvl(top1.flag4 , '0')) ; 
		}
		
		if(myAsList != null){
			console.log(myAsList);
			var flag1=0,flag2=0,flag3=0,flag4=0;
			
			for (var i=0; i < myAsList.length;i++){
				flag1 += Number(myAsList[i].FLAG1);
				flag2 += Number(myAsList[i].FLAG2);
				flag3 += Number(myAsList[i].FLAG3);
				flag4 += Number(myAsList[i].FLAG4);
			}
			
			$('#top2_1').empty().html(flag1); 
			$('#top2_2').empty().html(flag2); 
			$('#top2_3').empty().html(flag3); 
			$('#top2_4').empty().html(flag4); 
		}
		
		if(teamAsList != null){
			console.log(teamAsList);
			
			var flag1=0,flag2=0,flag3=0,flag4=0;
			
			for (var i=0; i < teamAsList.length;i++){
				flag1 += Number(teamAsList[i].FLAG1);
				flag2 += Number(teamAsList[i].FLAG2);
				flag3 += Number(teamAsList[i].FLAG3);
				flag4 += Number(teamAsList[i].FLAG4);
			}
			
			$('#top3_1').empty().html(flag1); 
			$('#top3_2').empty().html(flag2); 
			$('#top3_3').empty().html(flag3); 
			$('#top3_4').empty().html(flag4);  
		}
		
		goSubInfo() ; 
	}
	
	function makeSubInfo2(data){
		var charList = typeof data.charList != "undefined" ? data.charList : null ; 
		
		if(charList != null){
			CHARLIST = charList ; 
			google.charts.setOnLoadCallback(drawLineColors);
		}
	}
	
	function makeHisInfo2(data){
		var charList = typeof data.charList != "undefined" ? data.charList : null ; 
		
		if(charList != null){
			CHARLIST2 = charList ; 
			google.charts.setOnLoadCallback(drawChart1);
		}
	}
	
	function makeAsInfo2(data){
		var charList = typeof data.charList != "undefined" ? data.charList : null ; 
		
		if(charList != null){
			CHARLIST3 = charList ; 
			google.charts.setOnLoadCallback(drawChart2);
		}
	}
	
	function firstTab(gubun){
		location.href = "/ad/main/list" + gubun + ".do" ; 
		
	}
	
	function secondTab(gubun){
		for(var i = 1 ; i <= 5 ; i++){
			if(Number(gubun) == i){
				if(!$('#Secondli' + i).hasClass("active")) $('#Secondli' + i).addClass("active") ;
			}else{
				if($('#Secondli' + i).hasClass("active")) $('#Secondli' + i).removeClass("active") ;
			}
		}	
		
		goSubInfo() ; 
	}
	
	
	function drawLineColors(){
		
		var arr = [] ; 
		
		if(CHARLIST != null && CHARLIST.length > 0){
			
			console.log(CHARLIST);
			
			var nowDate = new Date();
			 
			for(var i = 5 ; i >= 0 ; i--){
				
				var date = new Date(nowDate.getFullYear() , nowDate.getMonth() - i, nowDate.getDate()) ;
				
				var sub = [] ; 
				
				sub.push( (date.getMonth() + 1) + "월" ) ; 
				sub.push( 0 ) ; 
				sub.push( 0 ) ; 
				sub.push( 0 ) ; 
				
				arr.push(sub) ; 
			}
			
			for (var i = 0 ; i < CHARLIST.length ; i++){
				var datas = CHARLIST[i] ; 
				
				var accept_dt = Number(common.nvl(datas.accept_dt , '0')) ; 
				var tot_count = common.nvl(datas.tot_count , '0') ; 
				var flag1 = common.nvl(datas.flag1 , '0') ; 
				var flag2 = common.nvl(datas.flag2 , '0') ; 
				
				for(var a = 0 ; a < arr.length ; a++){
					var arr_data = arr[a] ; 
					
					if(accept_dt + "월" == arr_data[0]){
						arr[a][1] = Number(tot_count) ; 
						arr[a][2] = Number(flag1) ; 
						arr[a][3] = Number(flag2) ; 
					}
				}
			}
		}
		
		var data = new google.visualization.DataTable();
	      data.addColumn('string', 'X');
	      data.addColumn('number', '총AS요청건');
	      data.addColumn('number', '정상처리');
	      data.addColumn('number', '지연처리');

	      data.addRows(arr);

	      var options = {
				colors: ['#a52714', '#097138' , '#077138'],
				width : 450,
				height : 250
	      };
	      
	      console.log(data);

	      var chart = new google.visualization.LineChart(document.getElementById('char1'));
	      chart.draw(data, options);
	}
	
	
	var chart1Data;
	function drawChart1(){
		
		var arr = [] ; 
		
		var temp = [] ; 
		
		temp.push('version') ; 
		temp.push('count') ; 
		
		arr.push(temp) ; 
		
		for(var i = 0 ; i < CHARLIST2.length ; i++){
			var datas = CHARLIST2[i] ;
			var imsi = [] ; 
			
			imsi.push(common.nvl(datas.code_name, '')) ; 
			imsi.push(Number(common.nvl(datas.cnt, '0'))) ; 
			
			arr.push(imsi) ; 
		}
		
		chart1Data = google.visualization.arrayToDataTable(arr);

		var options = {
				width : 245,
				height : 225,
				legend : {
					position : 'bottom'
				},
				chartArea : {
					left:0,
					top:20,
					width:'80%',
					height:'70%'
				}
	        };

		var chart = new google.visualization.PieChart(document.getElementById('char2'));

		chart.draw(chart1Data, options);
		
		chart1Big();
	}
	
	function chart1Big(){
		if (chart1Data == null) return;
		var options = {
				width : 680,
				height : 400,
				fontSize: '12',
				is3D: true,
				chartArea : {
					left:0,
					top:20,
					width:'100%',
					height:'100%'
				}
	        };
		
		var chart = new google.visualization.PieChart(document.getElementById('char1Big'));
		chart.draw(chart1Data, options);
	}
	
	
	var chart2Data;
	function drawChart2(){
		
		var arr = [] ; 
		
		var temp = [] ; 
		
		temp.push('type') ; 
		temp.push('count') ; 
		
		arr.push(temp) ; 
		
		for(var i = 0 ; i < CHARLIST3.length ; i++){
			var datas = CHARLIST3[i] ;
			var imsi = [] ; 
			
			imsi.push(common.nvl(datas.code_name, '')) ; 
			imsi.push(Number(common.nvl(datas.cnt, '0'))) ; 
			
			arr.push(imsi) ; 
		}
		
		chart2Data = google.visualization.arrayToDataTable(arr);

	    var options = {
			width : 245,
			height : 225,
			legend : {
				position : 'bottom'
			},
			chartArea : {
				left:0,
				top:20,
				width:'80%',
				height:'70%'
			}
	    };

	    var chart = new google.visualization.PieChart(document.getElementById('char3'));

	    chart.draw(chart2Data, options);
	    chart2Big();
	}
	
	function chart2Big(){
		if (chart2Data == null) return;
		
		var options = {
				width : 750,
				height : 400,
				fontSize: '12',
				is3D: true,
				chartArea : {
					left:0,
					top:20,
					width:'100%',
					height:'100%'
				}
	        };
		
		var chart = new google.visualization.PieChart(document.getElementById('char2Big'));
		
		google.visualization.events.addListener(chart, 'select', function(){
			var selectedItem = chart.getSelection()[0];
			if (selectedItem){
 	 			 	 			
 	 			var cuDate = new Date();
 	 			var gubun = $("input:radio[name=as_gubun2]:checked").val();
 	 			
 	 			var search_start = $.datepicker.formatDate('yy/mm/dd', new Date());
 	 			var search_end = $.datepicker.formatDate('yy/mm/dd', new Date());
 	 			
 	 			if (gubun == '1'){
 	 				search_start = $.datepicker.formatDate('yy/mm/dd', new Date(cuDate.getFullYear(),cuDate.getMonth(),1));
 	 	 			search_end = $.datepicker.formatDate('yy/mm/dd', new Date(cuDate.getFullYear(),cuDate.getMonth()+1,0));
 	 			}else if (gubun == '2'){
 	 				search_start = $.datepicker.formatDate('yy/mm/dd', new Date(cuDate.getFullYear(),cuDate.getMonth()-1,1));
 	 	 			search_end = $.datepicker.formatDate('yy/mm/dd', new Date(cuDate.getFullYear(),cuDate.getMonth(),0));
 	 			}else if (gubun == '3'){
 	 				search_start = $.datepicker.formatDate('yy/mm/dd', new Date(cuDate.getFullYear(),cuDate.getMonth()-2,1));
 	 	 			search_end = $.datepicker.formatDate('yy/mm/dd', new Date(cuDate.getFullYear(),cuDate.getMonth()+1,0));
 	 			}
 	 			 	 			
 	 			
 	 			self.location.href = "/ad/as/list.do?search_type2="
 	 					+ CHARLIST3[selectedItem.row].search_type2
 	 					+ "&search_gubun=2&search_type10=Y&search_start="
 	 					+ search_start
 	 					+ "&search_end="
 	 					+ search_end
			}
		});
		
		chart.draw(chart2Data, options);
	}
	
	
	function getAsAnalList(){
		var firstFlag = "2" ; 
		var secondFlag = "" ; 
		var thirdFlag = "" ; 
		
		for(var i = 1 ; i <= 5 ; i++){
			if($('#Secondli' + i).hasClass("active")) secondFlag = i ;
		}	
		
		var datas = {
				'firstFlag' 			: firstFlag , 
				'secondFlag' 		: secondFlag , 
				'thirdFlag' 			: thirdFlag  
				
		} ; 
		common.ajaxCall(datas, '/ad/main/getAsAnalysis.do', 'setAsAnalysis') ;
	}
	
	function setAsAnalysis(data){
		$('#asAnalysisTable').empty();
		$('#asAnalysisNotTable').empty();
		
		console.log(data);
		
		asAnalysisList = typeof data.resultList != 'undefined' ? data.resultList : null;
		
		// as건 최대 랭킹값, as건 최소 랭킹값, 건당비용 최소랭킹값, 건당비용 최대랭킹값 구하기
		var maxAsRank = -1, minAsRank = 1000000, maxCostRank = -1, minCostRank = 1000000;
		for (var i=0;i < asAnalysisList.length ; i++){
			var data = asAnalysisList[i];
			
			if (data.CNT != '0'){
				if (maxAsRank < Number(data.RK1)) maxAsRank = Number(data.RK1); // as건 최대 랭킹값
				if (minAsRank > Number(data.RK1)) minAsRank = Number(data.RK1); // as건 최소 랭킹값
			}
			
			if (data.AVG_AMT != '-' && data.AVG_AMT != '무상'){
				if (maxCostRank < Number(data.RK2)) maxCostRank = Number(data.RK2); // 건당비용 최대랭킹값
				if (minCostRank > Number(data.RK2)) minCostRank = Number(data.RK2); // 건당비용 최소랭킹값
			}
		}
		
		// AS 최대건 출력
		var htmlTag = "";
		for (var i=0;i < asAnalysisList.length ; i++){
			var data = asAnalysisList[i];
			
			if (data.RK1 == maxAsRank){
				htmlTag += "<tr>";
				htmlTag += "	<td>A/S건 최대</td>";
				htmlTag += "	<td style='cursor:pointer;text-decoration:underline' onclick='goDetailForm("+data.SEQ+")'>["+data.CRM_CODE+"]"+data.CUST_NM+"</td>";
				htmlTag += "	<td style='cursor:pointer;text-decoration:underline' onclick='goAsList(\""+data.CUST_NM+"\")'>"+ common.comma(data.CNT) +"건/월</td>";
				htmlTag += "	<td>"+(data.AVG_AMT == '-' || data.AVG_AMT == '무상' ? "" : "&#8361;")+ common.comma(data.AVG_AMT) +"</td>";
				htmlTag += "	<td style='cursor:pointer;text-decoration:underline' onclick='viewMoreLayer(\"A\")'>more</td>";
				htmlTag += "</tr>";
			}
		}
		
		// AS 최소건 출력
		for (var i=0;i < asAnalysisList.length ; i++){
			var data = asAnalysisList[i];
			
			if (data.RK1 == minAsRank){
				htmlTag += "<tr>";
				htmlTag += "	<td>A/S건 최소</td>";
				htmlTag += "	<td style='cursor:pointer;text-decoration:underline' onclick='goDetailForm("+data.SEQ+")'>["+data.CRM_CODE+"]"+data.CUST_NM+"</td>";
				htmlTag += "	<td style='cursor:pointer;text-decoration:underline' onclick='goAsList(\""+data.CUST_NM+"\")'>"+ common.comma(data.CNT) +"건/월</td>";
				htmlTag += "	<td>"+(data.AVG_AMT == '-' || data.AVG_AMT == '무상' ? "" : "&#8361;")+ common.comma(data.AVG_AMT) +"</td>";
				htmlTag += "	<td style='cursor:pointer;text-decoration:underline' onclick='viewMoreLayer(\"B\")'>more</td>";
				htmlTag += "</tr>";
			}
		}
		
		// 비용 최대건 출력
		for (var i=0;i < asAnalysisList.length ; i++){
			var data = asAnalysisList[i];
			
			if (data.RK2 == maxCostRank){
				htmlTag += "<tr>";
				htmlTag += "	<td>A/S비용 최대</td>";
				htmlTag += "	<td style='cursor:pointer;text-decoration:underline' onclick='goDetailForm("+data.SEQ+")'>["+data.CRM_CODE+"]"+data.CUST_NM+"</td>";
				htmlTag += "	<td style='cursor:pointer;text-decoration:underline' onclick='goAsList(\""+data.CUST_NM+"\")'>"+ common.comma(data.CNT) +"건/월</td>";
				htmlTag += "	<td>"+(data.AVG_AMT == '-' || data.AVG_AMT == '무상' ? "" : "&#8361;")+ common.comma(data.AVG_AMT) +"</td>";
				htmlTag += "	<td style='cursor:pointer;text-decoration:underline' onclick='viewMoreLayer(\"C\")'>more</td>";
				htmlTag += "</tr>";
			}
		}
		
		// 비용 최소건 출력
		for (var i=0;i < asAnalysisList.length ; i++){
			var data = asAnalysisList[i];
			
			if (data.RK2 == minCostRank){
				htmlTag += "<tr>";
				htmlTag += "	<td>A/S비용 최소</td>";
				htmlTag += "	<td style='cursor:pointer;text-decoration:underline' onclick='goDetailForm("+data.SEQ+")'>["+data.CRM_CODE+"]"+data.CUST_NM+"</td>";
				htmlTag += "	<td style='cursor:pointer;text-decoration:underline' onclick='goAsList(\""+data.CUST_NM+"\")'>"+ common.comma(data.CNT) +"건/월</td>";
				htmlTag += "	<td>"+(data.AVG_AMT == '-' || data.AVG_AMT == '무상' ? "" : "&#8361;")+ common.comma(data.AVG_AMT) +"</td>";
				htmlTag += "	<td style='cursor:pointer;text-decoration:underline' onclick='viewMoreLayer(\"D\")'>more</td>";
				htmlTag += "</tr>";
			}
		}
		
		$("#asAnalysisTable").html(htmlTag);
		
		
		var htmlTag = "";
		// 이슈건 출력
		for (var i=0;i < asAnalysisList.length ; i++){
			var data = asAnalysisList[i];
			
			if (data.CNT == 0){
				htmlTag += "<tr>";
				htmlTag += "	<td class='fontW_b colorRed'>ISSUE</td>";
				htmlTag += "	<td class='fontW_b colorRed' style='cursor:pointer;text-decoration:underline' onclick='goDetailForm("+data.SEQ+")'>["+data.CRM_CODE+"]"+data.CUST_NM+"</td>";
				htmlTag += "	<td class='fontW_b colorRed' style='cursor:pointer;text-decoration:underline' onclick='goAsList(\""+data.CUST_NM+"\")'>"+ common.comma(data.CNT) +"건/월</td>";
				htmlTag += "</tr>";
			}
		}
		
		$("#asAnalysisNotTable").html(htmlTag);
	}
	
	function viewMoreLayer(type){

		if (asAnalysisList == null || asAnalysisList.length < 1) return;
		
		// 이슈건을 재외한 새로운 Array객체를 만든다.
		var tmpList = new Array();
		for (var i=0; i < asAnalysisList.length; i++){
			
			if ((type == "C" || type == "D") && (asAnalysisList[i].AVG_AMT == '-' || asAnalysisList[i].AVG_AMT == '무상')) continue;
			if (Number(asAnalysisList[i].CNT) > 0) tmpList.push(asAnalysisList[i]);
		}
		
		console.log(tmpList);
		
		if (tmpList.length < 1) return;
		
		
		var layerTitle = "";
		// 각각의 타입별로 소팅한다.
		if (type == "A"){
			layerTitle = "A/S건 최대";
			// A/S건수 내림차순소팅
			tmpList.sort(function(a,b){
				return Number(a['CNT']) > Number(b['CNT']) ? -1 : Number(a['CNT']) < Number(b['CNT']) ? 1 : 0;
			});
		}else if (type == "B"){
			layerTitle = "A/S건 최소";
			// A/S건수 오름차순소팅
			tmpList.sort(function(a,b){
				return Number(a['CNT']) < Number(b['CNT']) ? -1 : Number(a['CNT']) > Number(b['CNT']) ? 1 : 0;
			});
		}else if (type == "C"){
			layerTitle = "A/S비용 최대";
			// 건별비용 내림차순소팅
			tmpList.sort(function(a,b){
				return Number(a['AVG_AMT']) > Number(b['AVG_AMT']) ? -1 : Number(a['AVG_AMT']) < Number(b['AVG_AMT']) ? 1 : 0;
			});
		}else if (type == "D"){
			layerTitle = "A/S비용 최소";
			// 건별비용 오름차순소팅
			tmpList.sort(function(a,b){
				return Number(a['AVG_AMT']) < Number(b['AVG_AMT']) ? -1 : Number(a['AVG_AMT']) > Number(b['AVG_AMT']) ? 1 : 0;
			});
		}else{
			return;
		}
		
		var htmlTag = "";
		for (var i=0; i < tmpList.length; i++){
			
			htmlTag += "<tr>";
			htmlTag += "	<td>"+(i+1)+"</td>";
			htmlTag += "	<td>"+tmpList[i].CUST_GUBUN_NM+"</td>";
			htmlTag += "	<td>"+tmpList[i].FOUNDATION_CODE_NM+"</td>";
			htmlTag += "	<td style='cursor:pointer;text-decoration:underline' onclick='goDetailForm("+tmpList[i].SEQ+")'>["+tmpList[i].CRM_CODE+"]"+tmpList[i].CUST_NM+"</td>";
			htmlTag += "	<td style='cursor:pointer;text-decoration:underline' onclick='goAsList(\""+tmpList[i].CUST_NM+"\")'>"+common.comma(tmpList[i].CNT)+"건/월</td>";
			htmlTag += "	<td>"+(tmpList[i].AVG_AMT == '-' || tmpList[i].AVG_AMT == '무상' ? "" : "&#8361;")+common.comma(tmpList[i].AVG_AMT)+"</td>";
			htmlTag += "</tr>";
		}
		
		$("#asListLayer2Title").html(layerTitle);
		$("#asListLayer2Cnt").html(tmpList.length);
		
		// 전월 날짜 구하기
		var cuDate = new Date();
		var firstDate = new Date(cuDate.getFullYear(),cuDate.getMonth() - 1, 1);
		var yyyymm = firstDate.getFullYear() + "년" + (firstDate.getMonth() + 1) + "월";
		$("#asListLayer2YYMM").html(yyyymm);
		// 전월 날짜 구하기 끝
		
		$("#asListLayer2Body").html(htmlTag);
		$("#asListLayer2").show();
	}
	
	function goDetailForm(seq){
		location.href = "/ad/cust/form.do?seq=" + seq;
	}
	
	function goAsList(crmCode){
		var currentDate = new Date();
		
		var firstDate = new Date(currentDate.getFullYear(), currentDate.getMonth() - 1, 1);
		var lastDate = new Date(currentDate.getFullYear(), currentDate.getMonth(), 0);
		
		var firstMonth = (firstDate.getMonth() + 1);
		var lastMonth = (lastDate.getMonth() + 1);
		
		var startStr = firstDate.getFullYear() + "%2F" + (firstMonth < 10 ? "0" + firstMonth : firstMonth) + "%2F01";
		var endStr = lastDate.getFullYear() + "%2F" + (lastMonth < 10 ? "0" + lastMonth : lastMonth) + "%2F" + (lastDate.getDate());
		
		var queryString = "?search_type10=Y&search_start=" + startStr + "&search_end=" + endStr + "&search_text=" + crmCode + "&search_type1=C005";
		
		location.href = "/ad/as/list.do" + queryString;
	}
	
	function goAsDetail(asno){
		var queryString = "?pageType=update&as_no=" + asno;
		location.href = "/ad/as/form.do" + queryString;
	}

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
		}else{
			alert("AS 목록 요청 Type 지정이 잘못되었습니다.");
			return;
		}
		
		console.log(seqStr);
		
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
		
		console.log(asList);

		var htmlStr = "";
		for (var i=0; i < asList.length; i++){
			htmlStr += '<tr style="cursor:pointer" onclick="goAsDetail(\''+ asList[i].AS_NO +'\')">';
			htmlStr += '	<td>' + asList[i].AS_NO + '</td>';
			htmlStr += '	<td>' + asList[i].PROC_STATUS_NM + '</td>';
			htmlStr += '	<td>' + asList[i].CUST_KOR_NAME + '</td>';
			htmlStr += '	<td>' + asList[i].SERVICE_CATE_NM + '</td>';
			htmlStr += '	<td>' + asList[i].EMP_NM + '</td>';
			htmlStr += '</tr>';
		}
		
		$("#asListBody").html(htmlStr);
		$("#asListLayer").show();
		
	}
	
</script>

<ul class="tab_dashboard list3 mgt30 mgb30">

	<!--<li id="Firstli1"><a href="javascript:firstTab('');">통계분석</a></li><!-- 활성시 current -->
	<!--<li id="Firstli2" class="active"><a href="javascript:firstTab('1');">A/S</a></li>
	<!--<li id="Firstli3"><a href="javascript:firstTab('2');">채권관리</a></li>-->
	
	<li id="Firstli1" ><a href="javascript:firstTab('');">통계분석</a></li><!-- 활성시 current -->
	<li id="Firstli2"><a href="javascript:firstTab('1');">거래처 현황</a></li>
	<li id="Firstli3" class="active"><a href="javascript:firstTab('2');">A/S</a></li>

	
	
</ul>

<div class="floatWrap mgb20">
	<div class="w485 floatL">
		<div class="tit_wrap small"><h3 class="tit_ico_notice">나의 A/S현황 (당월)</h3></div>
		<div class="db-greybox">
			<ul class="list4">
				<li onclick="getAsCustList('FLAG1','my')" style="cursor:pointer;"><p>승인대기</p><p class="num_db" id="top2_1">0</p></li>
				<li onclick="getAsCustList('FLAG2','my')" style="cursor:pointer;"><p>처리중</p><p class="num_db" id="top2_2">0</p></li>
				<li onclick="getAsCustList('FLAG3','my')" style="cursor:pointer;"><p>처리지연중</p><p class="num_db colorYellow" id="top2_3">0</p></li>
				<li onclick="getAsCustList('FLAG4','my')" style="cursor:pointer;"><p>이월</p><p class="num_db colorRed" id="top2_4">0</p></li>
			</ul>
		</div>
	</div>
	<div class="w485 floatR">
		<div class="tit_wrap small"><h3 class="tit_ico_notice">전체 A/S현황 (당월)</h3></div>
		<div class="db-greybox">
			<ul class="list4">
				<li onclick="getAsCustList('FLAG1','team')" style="cursor:pointer;"><p>접수</p><p class="num_db" id="top3_1">0</p></li>
				<li onclick="getAsCustList('FLAG2','team')" style="cursor:pointer;"><p>담당자배정</p><p class="num_db" id="top3_2">0</p></li>
				<li onclick="getAsCustList('FLAG3','team')" style="cursor:pointer;"><p>처리중</p><p class="num_db colorYellow" id="top3_3">0</p></li>
				<li onclick="getAsCustList('FLAG4','team')" style="cursor:pointer;"><p>처리완료</p><p class="num_db colorBlue" id="top3_4">0</p></li>
			</ul>
		</div>
	</div>
</div>
<div style="height:1px;background:#ddd;"></div>
<div class="mgt20">
	<ul class="list5 db-list">
		<li id="Secondli1" class="pdr8 active" onclick="javascript:secondTab('1');" style="cursor:pointer;"><div class="db-greybox colorBlack">총 거래처<span class="num_db pdl8" id="top1">0</span></div></li>
		<li id="Secondli2" class="pdr8" onclick="javascript:secondTab('2');" style="cursor:pointer;"><div class="db-greybox">종합병원<span class="num_db pdl8" id="top2">0</span></div></li>
		<li id="Secondli3" class="pdr8" onclick="javascript:secondTab('3');" style="cursor:pointer;"><div class="db-greybox">병원<span class="num_db pdl8" id="top3">0</span></div></li>
		<li id="Secondli4" class="pdr8" onclick="javascript:secondTab('4');" style="cursor:pointer;"><div class="db-greybox">의원<span class="num_db pdl8" id="top4">0</span></div></li>
		<li id="Secondli5" onclick="javascript:secondTab('5');" style="cursor:pointer;"><div class="db-greybox">요양병원<span class="num_db pdl8" id="top5">0</span></div></li>
	</ul>
</div>

<div style="display:table;width:100%;margin:20px 0">
	<div class="floatL w490 mgr60">
		<div class="tit_wrap small">
			<h3 class="tit_ico_graph2">기간별 AS 추이</h3>
		</div>
		<div class="db_borderbox h270" id="char1">
			<!--  그래프 영역 -->
		</div>
	</div>
	<div class="floatL w200 mgr50">
		<div class="tit_wrap small">
			<h3 class="tit_ico_graph3" onclick="$('#chart1Layer').show();" style="cursor:pointer" title="확대">HIS버전별 AS 분포</h3>
		</div>
		<div class="mgb10">
            <label class="mgr10"><input type="radio" class="mgr5" name="his_gubun" id="his_gubun0" value="1" onclick="hisChartInfo('1');" checked>기초</label>
            <label class="mgr10"><input type="radio" class="mgr5" name="his_gubun" value="2" onclick="hisChartInfo('2');">진료</label>
            <label class="mgr10"><input type="radio" class="mgr5" name="his_gubun" value="3" onclick="hisChartInfo('3');">원무</label>
            <label><input type="radio" class="mgr5" name="his_gubun" value="4"  onclick="hisChartInfo('4');">청구</label>
        </div>
		<div class="db_borderbox" style="height:243px; overflow:hidden;" id="char2">
			<!--  그래프 영역 -->
		</div>
	</div>
	<div class="floatL w200">
		<div class="tit_wrap small">
			<h3 class="tit_ico_graph3" onclick="$('#chart2Layer').show();" style="cursor:pointer" title="확대">AS 원인 유형별 분포</h3>
		</div>
		<div class="mgb10">
            <label class="mgr10"><input type="radio" class="mgr5" name="as_gubun" id="as_gubun0" value="1" onclick="asChartInfo('1');" checked>당월</label>
            <label class="mgr10"><input type="radio" class="mgr5" name="as_gubun" value="2" onclick="asChartInfo('2');" >전월</label>
            <label class="mgr10"><input type="radio" class="mgr5" name="as_gubun" value="3" onclick="asChartInfo('3');" >최근3개월</label>
        </div>
		<div class="db_borderbox" style="height:243px; overflow:hidden;" id="char3">
			<!--  그래프 영역 -->
		</div>
	</div>
</div>

<div class="tit_wrap small">
	<h3 class="tit_ico_graph3">AS 분석</h3>
</div>

<div class="floatWrap">
	<div class="floatL w490 mgr20">
		<div class="db_borderbox h200">
			<table class="hType">
				<caption>AS분석</caption>
				<colgroup>
					<col style="width:100px">
					<col style="width:auto">
					<col style="width:50px">
					<col style="width:100px">
					<col style="width:60px">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">구분</th>
						<th scope="col">거래처명</th>
						<th scope="col">A/S건</th>
						<th scope="col">건별 A/S비용</th>
						<th scope="col">더보기</th>
					</tr>
				</thead>
				<tbody id="asAnalysisTable"></tbody>
			</table>
		</div>
	</div>
	<div class="floatL w490">
		<div class="db_borderbox h200">
			<table class="hType">
				<colgroup>
					<col style="width:100px">
					<col style="width:auto">
					<col style="width:100px">
				</colgroup>
				<thead>
					<tr>
						<th>구분</th>
						<th>거래처명</th>
						<th>A/S건</th>
					</tr>
				</thead>
				<tbody id="asAnalysisNotTable"></tbody>
			</table>
		</div>
	</div>
</div>

<!-- AS리스트 레이어팝업 -->
<div id="asListLayer" style="display:none;">
	<div class="box_layer layer_sms" style="height:700px;margin-top:-400px;">
		<h1>AS목록</h1>
		<div class="layer_contents" style="padding-top:20px;height:600px;overflow-y:auto;">
			<table class="hType mgb20">
				<caption>총 수금정보</caption>
				<colgroup>
					<col style="width:auto;" />
				</colgroup>
				<tr>
					<th>접수번호</th>
					<th>처리상태</th>
					<th>거래처명</th>
					<th>문의서비스</th>
					<th>처리담당자</th>
				</tr>
				<tbody id="asListBody">
				</tbody>
			</table>
		</div>
		<button type="button" class="btn_close" onclick="$('#asListLayer').hide()">창 닫기</button>
	</div>
	<div class="layer_dimmed"></div>
</div>


<!-- AS분석 레이어팝업 -->
<div id="asListLayer2" style="display:none;">
	<div class="box_layer layer_sms" style="height:700px;margin-top:-400px;">
		<h1>A/S 분석 (<span id="asListLayer2Title" style="vertical-align:unset"></span>)</h1>
		<div class="layer_contents" style="padding-top:20px;height:600px;overflow-y:auto;">
		<span class="floatL">총 <span id="asListLayer2Cnt">0</span>개의 데이터가 있습니다.</span>
		<span class="floatR">*<span id="asListLayer2YYMM">----년 --월</span> A/S기준</span>
			<table class="hType mgb20">
				<caption>총 수금정보</caption>
				<colgroup>
					<col style="width:50px;" />
					<col style="width:100px;" />
					<col style="width:80px;" />
					<col style="width:auto;" />
					<col style="width:60px;" />
					<col style="width:100px;" />
				</colgroup>
				<tr>
					<th>No</th>
					<th>거래처구분</th>
					<th>재단구분</th>
					<th>거래처명</th>
					<th>A/S건수</th>
					<th>건별 A/S비용</th>
				</tr>
				<tbody id="asListLayer2Body">
				</tbody>
			</table>
		</div>
		<button type="button" class="btn_close" onclick="$('#asListLayer2').hide()">창 닫기</button>
	</div>
	<div class="layer_dimmed"></div>
</div>

<!-- Chart1 레이어팝업 -->
<div id="chart1Layer" style="display:none;">
	<div class="box_layer" style="width:650px;height:520px;margin:-300px 0 0 -325px;overflow:hidden;">
		<h1 class="tit_ico_graph3">HIS버전별 AS 분포 </h1>
		<div class="mgb10" style="padding-top:20px;text-align:center">
            <label class="mgr10"><input type="radio" class="mgr5" name="his_gubun2" id="his_gubun2" value="1" onclick="hisChartInfo('1');" checked>기초</label>
            <label class="mgr10"><input type="radio" class="mgr5" name="his_gubun2" value="2" onclick="hisChartInfo('2');">진료</label>
            <label class="mgr10"><input type="radio" class="mgr5" name="his_gubun2" value="3" onclick="hisChartInfo('3');">원무</label>
            <label><input type="radio" class="mgr5" name="his_gubun2" value="4"  onclick="hisChartInfo('4');">청구</label>
        </div>
		<div class="layer_contents" style="margin-left:50px;height:400px;overflow:hidden;" id="char1Big">
		</div>
		<button type="button" class="btn_close" onclick="$('#chart1Layer').hide()">창 닫기</button>
	</div>
	<div class="layer_dimmed"></div>
</div>

<!-- Chart2 레이어팝업 -->
<div id="chart2Layer" style="display:none;">
	<div class="box_layer" style="width:800px;height:520px;margin:-300px 0 0 -400px;overflow:hidden;">
		<h1>AS 원인 유형별 분포</h1>
		<div class="mgb10" style="padding-top:20px;text-align:center">
            <label class="mgr10"><input type="radio" class="mgr5" name="as_gubun2" id="as_gubun2" value="1" onclick="asChartInfo('1');" checked>당월</label>
            <label class="mgr10"><input type="radio" class="mgr5" name="as_gubun2" value="2" onclick="asChartInfo('2');" >전월</label>
            <label class="mgr10"><input type="radio" class="mgr5" name="as_gubun2" value="3" onclick="asChartInfo('3');" >최근3개월</label>
        </div>
		<div class="layer_contents" style="height:400px;overflow:hidden;cursor:pointer" id="char2Big">
		</div>
		<button type="button" class="btn_close" onclick="$('#chart2Layer').hide()">창 닫기</button>
	</div>
	<div class="layer_dimmed"></div>
</div>
