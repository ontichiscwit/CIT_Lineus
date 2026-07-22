<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="egovframework.com.comm.util.DateTimeUtil"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style>
	.btn-success span {display:inline-block;height:100%;padding-left:18px;background:url('/images/ico_excel.png') no-repeat 0 50%;}
</style>

<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript" src="/js/jquery.mtz.monthpicker.js"></script>
<script type="text/javascript">

	google.charts.load('current', {'packages':['corechart']});				/**	원형	*/
	
	$(document).ready(function(){
		 
		sessionStorage.setItem("search_type10_checked", true);
		
	 	$( function() {$( "#accordion" ).accordion({collapsible: true});
	  	  $( "#accordion-resizer" ).resizable({minHeight: 240,minWidth: 1000,resize: function() {$( "#accordion" ).accordion( "refresh" );}});
	  	}); 
		
		/* 날짜 셋팅  */
		 var staetDate = (setY)+"/"+(setM < 10 ? '0' + setM : setM) ; 
		 $( "#as_search_dt" ).val(staetDate).monthpicker(monthpicker_option);
		 $( "#as_search_dt2" ).val(staetDate).monthpicker(monthpicker_option);
		 
		 var date = new Date();
		 var year = date.getFullYear();
		 
		 for(var i = 0 ; i < 10 ; i++){
			 var html ='';
			 var curYear = year - i;
			 if(curYear >= 2019){
			 	html += '<option val="'+curYear+'">' + curYear +'</option>' ;
			 	$( "#project_search_dt" ).append(html);
			 }
		 }
		 
		 /* 탭 버튼 클릭  */
		 goProductInfo('C001'); 
		 projectInfoCtr();
		 
		 $('#as_search_dt').change(function(){
			 if( $('#cust_no').val() == '' || $('#cust_no').val() == null){alert('거래처를 선택해주세요.');}else{asChartCtr( $('#cust_no').val() );}
		 });
		 
		 $('#as_search_dt2').change(function(){
			 if( $('#cust_no').val() == '' || $('#cust_no').val() == null){alert('거래처를 선택해주세요.');}else{asChartCtr( $('#cust_no').val() );}
		 });
		 
	});
	
	
	function firstTab(gubun){
		location.href = "/ad/main/list" + gubun + ".do" ; 
	};
	
	////////////////////////////////////////////////////////
	
	/* 그리드 셀렉터  */
	function gridSelector(code){
		$('.con_table tr').removeAttr('class');
		$('.con_table #tr'+code).attr('class','active');
	};
	
	//상위 제품버튼
	var PRODUCT;
	var CHARLIST1; 
	function goProductInfo(pro){
		PRODUCT = pro 
		//viewProductTitle(gubun);/* 타이틀-제품명 표시  */
		custGubunCountCtr();
		custGubunTab('0');/* 병원별 거래처 */
		//projectInfoCtr(gubun);/* 프로젝트현황 */
	};	
	
	//상위 병원 구분 버튼
	var CUSTGUBUN;
	function custGubunTab(gubun){
	
		CUSTGUBUN = gubun;
		for(var i = 0 ; i <=5 ; i++){
			if($('#cust_top'+ i ).hasClass("active")) $('#cust_top'+i).removeClass("active") ;
		}
		
		if(!$('#cust_top'+ gubun).hasClass("active"))	$('#cust_top'+ gubun).addClass("active") ;
		
		contractChartCtr(PRODUCT,gubun);
	};
	
	/* 타이틀-제품명 표시 */
	function viewProductTitle(pro){
		
	};
	
	/* 병원별 거래처  */
	function custGubunCountCtr(){
		common.ajaxCall(null, '/ad/main/getCustGubunCount.do', 'setCustGubunCount'); 
	};
	
	function setCustGubunCount(data){
		var custInfo = typeof data.resultInfo != "undefined" ? data.resultInfo : null ; 
		
		if(custInfo != null){
			$('#top2').append(custInfo[0].FLAG1);
			$('#top3').append(custInfo[0].FLAG2);
			$('#top4').append(custInfo[0].FLAG3);
			$('#top5').append(custInfo[0].FLAG4);
			$('#top6').append(custInfo[0].FLAG5);
			$('#top1').append(custInfo[0].TOT_COUNT);
		}
	};
	
	/* 계약차트 컨트롤러 */
	function contractChartCtr(pro,gubun){
		var datas = {'search_type1' : pro,'search_type3' : gubun};
		common.ajaxCall(datas, '/ad/main/getPayInfoCount.do', 'payChartInfo'); /* 유무상 */
		common.ajaxCall(datas, '/ad/main/getDelPayInfoCount.do', 'payEtcCharInfo'); /* 만료  */
	};
	
	function payChartInfo(data){
		
		var charInfo = typeof data.resultInfo != "undefined" ? data.resultInfo : null ; 
		
		if(charInfo != null){
			CHARLIST1 = charInfo ; 
			google.charts.setOnLoadCallback(drawPayChart);
			
			/* 계약상세리스 컨트롤러*/
			contractListCtr(charInfo);
			
			/* 계약 카운팅 */
			contractCount(charInfo);
		}
		
	};
	
	function contractCount(data){
		
		if(data.length != 0){
			for(var i = 0 ; i < data.length ; i ++){
				var html ='';			
				if( data[i].CODE == 'C001' || data[i].CODE == 'C002' ){
					html += data[i].CODE_NAME + '<span class="num_db pdl8 colorBlue" style="min-width:64px">' + data[i].CNT +'</span>';
				}else{
					html += data[i].CODE_NAME + '<span class="num_db pdl8 colorGrey" style="min-width:64px">' + data[i].CNT +'</span>';
				}
				
				$('#char2_' + data[i].CODE).empty();
				$('#char2_' + data[i].CODE).append(html);
			}
		}
	};
	
	function payEtcCharInfo(data){
		
		var data = typeof data.resultInfo != "undefined" ? data.resultInfo : null ;
		
		if(data != null && data.length != 0 && data[0] != null){
			$('#con_pro1').attr('data-count', common.nvl(data[0].FLAG2,'0')); /* 유상 */
			$('#con_pro3').attr('data-count', common.nvl(data[0].FLAG1,'0')); /* 무상 */
		}else{
			$('#con_pro1').attr('data-count', '0'); /* 유상 */
			$('#con_pro3').attr('data-count', '0'); /* 무상 */
		}
		countAction();
	};
	
	function countAction(){
		
		$('.counter').each(function() {
		  var $this = $(this),countTo = $this.attr('data-count');
		  $({ countNum: $this.text()}).animate({countNum: countTo},
		  {
			duration: 1000,easing:'easeInCubic',step: function() {$this.text(Math.floor(this.countNum));},
		    complete: function() {$this.text(this.countNum);
		    }
		  });
		});
	};
	
	function payEtcCharInfoBase(data){
		
		if(data != null && data.length != 0){
			for(var i = 0 ; i < data.length; i++){
			
				if(data[i].CODE == 'C002'){
					$('#con_pro2').html('&ensp;/' + data[i].CNT); /* 유상 */
				}else if(data[i].CODE == 'C001'){
					$('#con_pro4').html('&ensp;/' + data[i].CNT); /* 무상 */		
				}
			
			}
		}
		
	};
	
	function drawPayChart(){
		
		var arr = [] ; 
		var temp = [] ; 
		
		temp.push('거래구분') ; 
		temp.push('거래수') ; 
		
		arr.push(temp) ; 
		
		for(var i = 0 ; i < CHARLIST1.length ; i++){
			var datas = CHARLIST1[i] ;
			var imsi = [] ; 
			
			imsi.push(common.nvl(datas.CODE_NAME, '')) ; 
			imsi.push(Number(common.nvl(datas.CNT, '0'))) ; 
			
			arr.push(imsi) ; 
		}
		
		var chart1Data = google.visualization.arrayToDataTable(arr);
		console.log(CHARLIST1);
		
		var options = {
				width : 295,
				height : 260,
				title: '계약 현황',
				 fontSize: 13,
				legend : {position : 'bottom'},
				chartArea : {width:'100%',height:'80%'},
				titleTextStyle: {
			        color: '#333',    
			        fontName: 'Nanum Gothic', 
			        fontSize: 14
			    },
			    colors: ['#0090c8', '#58C9B9', '#999999', '#999999']
			};

		
		
		var chart = new google.visualization.PieChart(document.getElementById('char1'));
		chart.draw(chart1Data, options);
	};
	
	/* 계약정보테이블 컨트롤러 */
	function contractListCtr(charInfo){
		
		//계약정보타이틀 
		payListCount(charInfo);
		
		console.log(charInfo);
		//계약정보리스트 
		for(var i = 0; i < charInfo.length ; i++){
			
			$('#conInfo'+charInfo[i].CODE).empty();
			var datas ={
					
					'search_type1' : PRODUCT, 			//C001:ONTIC HIS
					'search_type2' : charInfo[i].CODE,	//C001:무상, C002:유상, C003:해지, C004:폐업, C005:중지
					'search_type3' : CUSTGUBUN			//0:총, 1:종합병원, 2:병원, 3:의원, 4:요양, 5:검진센터
					
			}
			common.ajaxCall(datas, '/ad/main/getPayInfoList.do', 'payInfoList');
		}
		
	};
	
	function payListCount(data){
		
		var html ='';
		for(var i = 0 ; i < data.length; i++){
			var span ='<span class="ui-accordion-header-icon ui-icon ui-icon-triangle-1-e"></span>';
			$('#conInfoTitle'+data[i].CODE).html(span + data[i].CODE_NAME + '(' +data[i].CNT + ')');
		}
		
		$( function() {$( "#accordion" ).accordion({collapsible: true});
	  	  $( "#accordion-resizer" ).resizable({minHeight: 240,minWidth: 1000,resize: function() {$( "#accordion" ).accordion( "refresh" );}});
	  	});
		
		payEtcCharInfoBase(data);
		
	};
	
	function payInfoList(data){
		
		var data = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		if (data != null && data.length > 0) {
			var htmlH ='';
			htmlH += '<table class="hType mgb10 con_table" id="TB'+data[0].DEAL_CODE+'">';
			htmlH += '<caption>유지보수현황</caption>';
			htmlH += '<colgroup>';
			htmlH += '<col style="width:35px">';
			htmlH += '<col style="width:140px">';
			htmlH += '<col style="width:80px">';
			htmlH += '<col style="width:80px">';
			htmlH += '<col style="width:150px">';
			htmlH += '<col style="width:80px">';
			htmlH += '<col style="width:100px">';
			htmlH += '<col style="width:140px">';
			htmlH += '</colgroup>';
			htmlH += '<thead>';
			htmlH += '<tr>';
			htmlH += '<th scope="col">No</th>';
			htmlH += '<th scope="col">거래처명(CODE)</th>';
			htmlH += '<th scope="col">제품명</th>';
			htmlH += '<th scope="col">거래상태</th>';
			htmlH += '<th scope="col">계약기간</th>';
			htmlH += '<th scope="col">계약 종료 -D</th>';
			htmlH += '<th scope="col">HIS ver</th>';
			htmlH += '<th scope="col">사업장 소재지</th>';
			htmlH += '</tr>';
			htmlH += '</thead>';
			htmlH += '<tbody id="TBODY'+data[0].DEAL_CODE+'">';
			htmlH += '</tbody>';
			htmlH += '</table>';
			
			$('#conInfo'+data[0].DEAL_CODE).html(htmlH);
		
		var code = data[0].DEAL_CODE;
		var html = "";
		for(var i = 0; i < data.length; i++){
			
			html += '<tr id="tr'+common.nvl(data[i].CRM_CODE, '')+'" onclick="getAsChartCtr(\''+common.nvl(data[i].CRM_CODE, '')+'\', \''+common.nvl(data[i].CUST_KOR_NAME, '')+'\');" style=\"cursor:pointer;\">' ;
			html += '<td>' + common.nvl(data[i].RNUM,'-') + '</td>';  
			html += '<td class="textL">' + common.nvl(data[i].CUST_KOR_NAME,'-') + '[' + common.nvl(data[i].CRM_CODE,'-') + ']'+ '</td>'; 
			
			
			if( common.nvl(data[i].BILL_CODE,'') != '' ){
				
				html += '<td>' + common.nvl(data[i].ITEM_NM,'-') + '</td>';
				
				if(common.nvl(data[i].DEAL_CODE,'') == 'C003' && common.nvl(data[i].CANCEL_DT, '').length == 8){
					//해지(C003) && 해지일(CANCEL_DT)이 있으면
					html += '<td>' + common.nvl(data[i].DEAL_CODE_NAME,'-') + '['+ makeDate(data[i].CANCEL_DT,'-') +']'+ '</td>'; 
				}else{
					html += '<td>' + common.nvl(data[i].DEAL_CODE_NAME,'-') + '</td>'; 
				}
				html += '<td><div id="resumeProficienciesBottom">';
				html += '<div class="progress">';
				
				
				var extraDay = common.nvl(data[i].FLAG4,'0');
				extraDay = Number(extraDay);
				
				if(  0 <= extraDay && extraDay <= 20   ){
					html += '<div class="html progress-bar progress-bar-red" role="progressbar" style="width:'+common.nvl(data[i].FLAG3,'0')+'%"></div>';
				}else if(  20 < extraDay && extraDay <= 40 ){
					html += '<div class="html progress-bar progress-bar-orange" role="progressbar" style="width:'+common.nvl(data[i].FLAG3,'0')+'%"></div>';
				}else if(  40 < extraDay && extraDay <= 90 ){
					html += '<div class="html progress-bar progress-bar-yellow" role="progressbar" style="width:'+common.nvl(data[i].FLAG3,'0')+'%"></div>';
				}else{
					html += '<div class="html progress-bar progress-bar-info" role="progressbar" style="width:'+common.nvl(data[i].FLAG3,'0')+'%"></div>';
				}
				
				html += '</div>';
				html += '</div>';
				
				var vmtac_start_dt ='';
				if (common.nvl(data[i].MTAC_START_DT, '').length == 8){
					vmtac_start_dt = makeDate(data[i].MTAC_START_DT,"-");
		 		}
				var vmtac_end_dt ='';
				if (common.nvl(data[i].MTAC_END_DT, '').length == 8){
					vmtac_end_dt = makeDate(data[i].MTAC_END_DT,"-");
		 		}
				
				html += vmtac_start_dt + ' ~ ' + vmtac_end_dt ;
				
				if(  0 <= extraDay && extraDay <= 20   ){
					html += '<td>' +'<span class="danger-red"></span>'+ common.nvl(data[i].FLAG4,'-') +'D'+ '</td>'; 
				}else if(  20 < extraDay && extraDay <= 40 ){
					html += '<td>' +'<span class="danger-orange"></span>'+ common.nvl(data[i].FLAG4,'-') +'D'+ '</td>'; 
				
				}else if(  40 < extraDay && extraDay <= 90 ){
					html += '<td>' +'<span class="danger-yellow"></span>'+ common.nvl(data[i].FLAG4,'-') +'D'+ '</td>'; 
				}else{
					html += '<td>' + common.nvl(data[i].FLAG4,'-') +'D'+ '</td>'; 
				}
				
			}else{
				html += '<td></td>'; /*제품이름 생략  */
				
				if(common.nvl(data[i].DEAL_CODE,'') == 'C003' && common.nvl(data[i].CANCEL_DT, '').length == 8){
					html += '<td>' + common.nvl(data[i].DEAL_CODE_NAME,'-') + '['+ makeDate(data[i].CANCEL_DT,'-') +']'+ '</td>'; 
				}else{
					html += '<td>' + common.nvl(data[i].DEAL_CODE_NAME,'-') + '</td>';
				}
				html += '<td>' + '거래 내역이 없습니다' + '</td>';
				html += '<td></td>';
			}
			
			html += '<td>' + common.nvl(data[i].HIS_TREAT_CODE_NM,'-') + '</td>'; 
			html += '<td>' + common.nvl(data[i].CUST_ADDRESS,'-') + '</td>'; 
			html += '</tr>';
			
		}	
		$('#TBODY'+code).html(html);
		}else {
			
		}
		
	};
	
	 function getAsChartCtr(code,name){
		
		//그리드 셀렉터
		gridSelector(code);
			
		var  html ='';
		html += name +'&nbsp;&lt';
		html += '<span class="colorBlue mg15">'+code+'</span>&gt';
		$('#as_chart_custname').html(html);
		$('#cust_no').val(code);
		
		asChartCtr(code);
	 };
	
	/* AS현황 컨트롤러 */
	function asChartCtr(code){
		
		var datas = {
				'search_type1' :code,
				'search_type2' : $('#as_search_dt').val(),
				'search_type3' : $('#as_search_dt2').val()
				
		}
		common.ajaxCall(datas, '/ad/main/getAsInfoCount.do', 'asCountChartInfo');
		common.ajaxCall(datas, '/ad/main/getAsStatusInfoCount.do', 'asStatusChartInfo');
		common.ajaxCall(datas, '/ad/main/getAsServiceCateInfoCount.do', 'asTypeChartInfo'); 
		
	};
	
	function asCountChartInfo(data){
		
		console.log(data);
		var charInfo = typeof data.resultInfo != "undefined" ? data.resultInfo : null ; 
		if(charInfo != null){
			
			var num1 = common.nvl(charInfo[0].FLAG1,'0'); /* 거래처 A/S건 수   */
			var num2 = common.nvl(charInfo[0].TOT_COUNT,'0');/* 총 거래처의 A/S수 */
			var num3 = common.nvl(charInfo[0].FLAG2,'0');/* 거래처 A/S건 - 처리완료건 수  */
			
			var cel = Number(num1)/Number(num2) *100 ; /*   거래처AS 수 all AS 수 */
			var cel2 = Number(num3)/Number(num1) *100 ; /*  거래처처리완료 AS 수 거래처 A/S 수  */
			if( num1 =='0' ){ cel2 = '0'; }
			var html ='';
			
			html += '<div style="height:50%">';
			html += '<div class="parcial">';
			html += '<div class="progressBar">';
			html += '<div class="percentagem" style="width:'+ cel.toFixed(2) +'%"></div>';
			html += '</div>';
			html += '</div>';
			
			html += '<div style="width:100%; height: 30px;">';
			html += '<span class="num_db_small floatR colorBlue" style="margin-right:40px" id="cust_as_per">' + cel.toFixed(2) + ' %' +'</span>';
			html += '</div>';
			html += '<div class="floatR" style="margin-right:40px">';
			html += '<span class="num_db_small2 colorBlue" id="cust_as_count">' + num1 + ' 건' + '</span>';
			html += '<span class="num_db_small2 colorGrey" id="cust_as_total">' + '&ensp;/ ' + '총 ' + num2 +' 건'  + '</span>';
			html += '</div>';
			html += '</div>';
			
			html += '<div style="height:50%">';
			html += '<div class="parcial">';
			html += '<div class="progressBar">';
			html += '<div class="percentagem" style="width:'+ parseInt(cel2) +'%"></div>';
			html += '</div>';
			html += '</div>';
			
			html += '<div style="width:100%; height: 30px;">';
			html += '<span class="num_db_small floatR colorBlue" style="margin-right:40px" id="cust_as_per">' + parseInt(cel2) + ' %' +'</span>';
			html += '</div>';
			html += '<div class="floatR" style="margin-right:40px">';
			html += '<span class="num_db_small2 colorBlue" id="cust_as_count">' +'처리완료 '+ num3 + ' 건' + '</span>';
			html += '<span class="num_db_small2 colorGrey" id="cust_as_total">' + '&ensp;/ ' + '총 ' + num1 +' 건'  + '</span>';
			html += '</div>';
			html += '</div>';
			
			$('#as_char1').empty();
			$('#as_char1').append(html);
			
		}else{
			
		}
	};
	
	var STATUS_CHARLIST;
	function asStatusChartInfo(data){
		
		var charInfo = typeof data.resultInfo != "undefined" ? data.resultInfo : null ; 
		
		if(charInfo != null){
			STATUS_CHARLIST = charInfo ; 
			google.charts.setOnLoadCallback(drawStatusChart);
		}
		
	};
	
	function drawStatusChart(){
		
		var arr = [] ; 
		var temp = [] ; 
		
		temp.push('진행상태') ; 
		temp.push('A/S수') ; 
		
		arr.push(temp) ; 
		
		for(var i = 0 ; i < STATUS_CHARLIST.length ; i++){
			var datas = STATUS_CHARLIST[i] ;
			var imsi = [] ; 
			
			imsi.push(common.nvl(datas.PROC_STATUS_NM, '')) ; 
			imsi.push(Number(common.nvl(datas.CNT, '0'))) ; 
			
			arr.push(imsi) ; 
		}
		
		var chart1Data = google.visualization.arrayToDataTable(arr);

		var options = {
				legend : {position : 'bottom'},
				chartArea : {width:'90%',height:'80%'}
				
			};

		var chart = new google.visualization.PieChart(document.getElementById('as_char2'));
		chart.draw(chart1Data, options);
		
	};
	
	var TYPE_CHARLIST;
	function asTypeChartInfo(data){
		
		var charInfo = typeof data.resultInfo != "undefined" ? data.resultInfo : null ; 
		
		if(charInfo != null){
			TYPE_CHARLIST = charInfo ; 
			google.charts.setOnLoadCallback(drawTypeChart);
		}
	};
	
	function drawTypeChart(){
		
		var arr = [] ; 
		var temp = [] ; 
		
		temp.push('유형') ; 
		temp.push('A/S수') ; 
		
		arr.push(temp) ; 
		
		for(var i = 0 ; i < TYPE_CHARLIST.length ; i++){
			var datas = TYPE_CHARLIST[i] ;
			var imsi = [] ; 
			
			imsi.push(common.nvl(datas.SERVICE_CATE_NM, '')) ; 
			imsi.push(Number(common.nvl(datas.SERVICE_COUNT, '0'))) ; 
			
			arr.push(imsi) ; 
		}
		
		var chart1Data = google.visualization.arrayToDataTable(arr);

		var options = {
				legend : {position : 'bottom'},
				chartArea : {width:'90%',height:'80%'}
				
			};

		var chart = new google.visualization.PieChart(document.getElementById('as_char3'));
		chart.draw(chart1Data, options);
		
	};
	
	
	/* 프로젝트 현황 컨트롤러 */ 
	function projectInfoCtr(){
		
		var datas ={
				'search_type1' : $('#project_search_dt').val()
		}
		common.ajaxCall(datas, '/ad/main/getProjectInfo.do', 'projectInfo');
			
	};
	
	function projectInfo(data){
		projectInfoList(data);
	};
	
	function projectInfoList(data){
		
		
		console.log(data);
		
		var datas = typeof data != "undefined" ? data : null ;
		if(datas != null && datas.length != 0 ){
			
			var	html =''; 
			var flag1 = '0'; /* 총 프로젝트 수  */
			var flag2 = '0'; /* 수주심의 확정 수  */
			var flag3 = '0'; /* 계약완료 수  */
			var flag4 = '0'; /* 오픈완료 수  */
			var flag5 = '0'; /* 종료완료 수  */
			
			for(var i = 0 ; i < datas.length; i++){
				
				var num = i +1;
				flag1 =	datas.length;
				
				html += '<tr>';
				html += '<td>'+ num +'</td>';
				html += '<td class="textL">'+ common.nvl(datas[i].hosName, '') + '[' + common.nvl(datas[i].hosNo, '') +']'+ '</td>';
				html += '<td>'+ common.nvl(datas[i].productType,'') +'</td>';
				html += '<td>'+ common.nvl(datas[i].buildUpPmNm,'') +'[' + common.nvl(datas[i].buildUpPmId, '') +']'+'</td>';
				
				/* 수주심의 */
				if(common.nvl(datas[i].reviewDate,'') != ''){
					html += '<td><button class="btn_file_blue" style="width:60px;">'+ '확정' +'</button>';
					html += '<span class="ac-bg-color">'+ datas[i].reviewDate +'</span></td>';
					
					flag2 ++;
					
				}else{
					html += '<td><button class="btn_file_blue" style="width:60px;margin-bottom:14px;">'+ '-' +'</button></td>';
				}
				
				/* 계약 */
				if(common.nvl(datas[i].contractDate,'') != ''){
					html += '<td><button class="btn_file_blue" style="width:60px;">'+ '완료' +'</button>';
					html += '<span class="ac-bg-color">'+ datas[i].contractDate +'</span></td>';
					
					flag3 ++;
					
				}else{
					html += '<td><button class="btn_file_blue" style="width:60px;margin-bottom:14px;">'+ '-' +'</button></td>';
				}
				
				/* 개발  - endFlag :진행중,완료,보류*/
				if(common.nvl(datas[i].endFlag,'') == '진행중'){
					html += '<td><button class="btn_file_yellow" style="width:60px;">'+ '진행중' +'</button>';
					html += '<span class="pn-bg-color">'+ "pn." + common.nvl(datas[i].startDate,'') +'</span></td>';
				}else if(common.nvl(datas[i].endFlag,'') == '보류'){
					html += '<td><button class="btn_file_gray" style="width:60px;">'+ '보류' +'</button>';
					html += '<span class="pn-bg-color">'+ "pn." + common.nvl(datas[i].startDate,'') +'</span></td>';
				}else if( common.nvl(datas[i].endFlag,'') == '완료' ){
					html += '<td><button class="btn_file_blue" style="width:60px;">'+ '완료' +'</button>';
					html += '<span class="pn-bg-color">'+ "pn." +common.nvl(datas[i].startDate,'') +'</span></td>';
				}
				
				/* 오픈 */
				if(common.nvl(datas[i].openDate,'') != ''){
					html += '<td><button class="btn_file_blue" style="width:60px;">'+ '완료' +'</button>';
					html += '<span class="ac-bg-color">'+ datas[i].openDate +'</span></td>';
					
					flag4 ++;
					
				}else{
					html += '<td><button class="btn_file_gray" style="width:60px;margin-bottom:14px;">'+ '-' +'</button></td>';
				}
				
				/* 종료 */
				if(common.nvl(datas[i].endFlag,'') == '진행중'){
					html += '<td><button class="btn_file_gray" style="width:60px;">'+ '-' +'</button>';
					html += '<span class="pn-bg-color">'+ "pn."+ common.nvl(datas[i].endDate,'') +'</span></td>';
				}else if(common.nvl(datas[i].endFlag,'') == '보류'){
					html += '<td><button class="btn_file_gray" style="width:60px;">'+ '-' +'</button>';
					html += '<span class="pn-bg-color">'+ "pn." +common.nvl(datas[i].endDate,'') +'</span></td>';
				}else if( common.nvl(datas[i].endFlag,'') == '완료' ){
					html += '<td><button class="btn_file_blue" style="width:60px;">'+ '완료' +'</button>';
					html += '<span class="pn-bg-color">'+"pn."+ common.nvl(datas[i].endDate,'') +'</span>';
					html += '<span class="ac-bg-color">'+ common.nvl(datas[i].prjEndDate,'') +'</span></td>';
					
					flag5 ++;
				}
				
				html += '</tr>';
			}
			
			$('#project_tb_body').html(html);
			$('#pro_top1').text(flag1);
			$('#pro_top2').text(flag2);
			$('#pro_top3').text(flag3);
			$('#pro_top4').text(flag4);
			$('#pro_top5').text(flag5);
			
		}else{
			
			var html ='';
			html += '<tr>';
			html += '<td style="background-color: #f6f6f6" colspan="9">조회된 데이터가 없습니다</td>';
			html += '</tr>';
			$('#project_tb_body').html(html);
			
		}
	};
	
	/* 총 거래처 리스트 엑셀 다운로드 */
	function goExcel(){
		if( confirm("ONTIC HIS 사용 거래처가 엑셀로 다운로드 됩니다.") ){
			
			var f = document.listFrm ; 
			
			try{
				$("#exlFrame").remove() ;
			}catch(e){}
			
			var downFrame = $('<iframe id="exlFrame" name="exlFrame" style="width:0px; height=0px ; display:none;"></iframe>') ; 
			downFrame.appendTo("body") ;
			
			f.target = "exlFrame" ; 
			f.action = "/ad/main/goExcel.do" ; 
			f.submit() ;
				
		}
	};
	
</script>

<style>
.btn-primary {color: #fff;background-color: #007bff;border-color: #007bff;}
.btn-primary:hover {color: #fff;background-color: #0069d9;border-color: #0062cc;}
.btn-success {color: #fff;background-color: #218838;border-color: #1e7e34;}
.btn-success:hover {color: #fff;background-color: #1a792f;border-color: #1e7e34;}
.btn {display: inline-block;font-weight: 800;text-align: center;white-space: nowrap;vertical-align: middle;border: 1px solid transparent;padding: 7px 35px 7px 35px;border-radius: .25rem;transition: color .15s ease-in-out,background-color .15s ease-in-out,border-color .15s ease-in-out,box-shadow .15s ease-in-out;}
.btn-danger {color: #fff;background-color: #dc3545;border-color: #dc3545;}
.btn-danger:hover {color: #fff;background-color: #c82333;border-color: #bd2130;}
.btn-warning {color: #212529;background-color: #ffc107;border-color: #ffc107;}
.btn-info {color: #fff;background-color: #17a2b8;border-color: #17a2b8;}
.btn-info:hover {color: #fff;background-color: #1693a7;border-color: #17a2b8;}
.prosolbtn .active{background-color: #2d3033;}
.probusolbtn .active{background-color: #2d3033;}
.calendarTb th {height: 30px;padding: 5px 2px;font-weight: 700;color: #fff;text-align: center;background-color: #404345;border-right: 0;border: solid 1px #fff;}
.calendarTb td {height: 60px;padding: 5px 2px;text-align: center;border: 1px solid #dadada; font-weight:bold;}
#resumeProficienciesBottom {float: left;clear: right;width: 100%;}
.progress {
	background:#e9e5e2;
	background-image: -webkit-gradient(linear, left top, left bottom, from(#dddddd), to(#e9e5e2));
	background-image: -webkit-linear-gradient(top, #dddddd, #e9e5e2);
	background-image: -moz-linear-gradient(top, #dddddd, #e9e5e2);
	background-image: -ms-linear-gradient(top, #dddddd, #e9e5e2);
	background-image: -o-linear-gradient(top, #dddddd, #e9e5e2);
	background-image: linear-gradient(top, #dddddd, #e9e5e2);  
	height:20px; 
	border-radius: 0px;
	-moz-box-shadow: 0 1px 0px #bebbb9 inset, 0 1px 0 #fcfcfc;	 
	-webkit-box-shadow: 0 1px 0px #bebbb9 inset, 0 1px 0 #fcfcfc;	 
	box-shadow: 0 1px 0px #bbbbbb inset, 0 1px 0 #fcfcfc;	  
}

.progress-bar {float: left;height: 100%;font-size: 12px;line-height: 20px;color: #fff;text-align: center;}

.progress-bar-info {background-color: #5bc0de;}
.progress-bar-yellow {background-color: #ffad00;}
.progress-bar-orange {background-color: #ff6e00;}
.progress-bar-red {background-color: #ff3d00;}

.html{
 -webkit-transition: width 4.50s ease !important;
 -moz-transition: width 4.50s ease !important;
 -o-transition: width 4.50s ease !important;
 transition: width 4.50s ease !important;
 }

.ac-bg-color{background-color:aliceblue;}
.pn-bg-color{background-color:antiquewhite;}
.con_table tr.active {background-color: aliceBlue;}

.parcial{
	padding-top: 15px;
    padding-bottom: 10px;
}
.progressBar {
    position:relative;
    width:400px;
    height:40px;
    margin:0px 0px 0px 40px;
    border-radius:10px;
    background: #e7e7e7;
}
.progressBar .percentagem {
    position:absolute;
    top:0;
    left:0;
    height:40px;
    border-top-left-radius: 10px;
    border-bottom-left-radius: 10px;
    border-top-right-radius: 10px;
    border-bottom-right-radius: 10px;
    background: #5ac0de;
    -webkit-transition: 5s all;
    -webkit-animation-duration: 5s;
    -webkit-animation-name: animationProgress;
}
.percentagem {
    background-color:#EACF00;
}

.percentual {
    -webkit-transition: 5s all;
    -webkit-animation-duration: 5s;
    -webkit-animation-name: animationProgress;
    transition: 5s all;
    animation-duration: 5s;
    animation-name: animationProgress;
}
@-webkit-keyframes animationProgress {
    from {
        width:0;
    }
}
@keyframes animationProgress {
    from {
        width:0;
    }
}


</style>

<form name="listFrm" id="listFrm" method="post" onsubmit="return false;">
	<input type="hidden" name="firstFlag" value="1"	/> <!--거래처현황 페이지  -->
	<input type="hidden" name="secondFlag" value="1" /> <!-- 거래처 유형 -->
	
</form>
<ul class="tab_dashboard list2 mgt30 mgb10">
	<li id="Firstli2" class="active"><a href="javascript:firstTab('');">거래처 현황</a></li>
	<li id="Firstli3"><a href="javascript:firstTab('1');">A/S</a></li>
</ul>


<!-- 상세품목선택  -->
<div class="tit_wrap mgt5 mgb5">
	<div class="floatL prosolbtn">
		<button type="button" id="pro1" class="btn btn-primary active" onclick="javascript:goInfo('C001')"><span>ONTIC HIS</span></button>
		<button type="button" id="pro2" class="btn btn-success" onclick="javascript:goExcel()"><span>Excel Download</span></button>
	</div>
</div>

<div class="mgb30" id="Thirddiv1">
	
	<div class="tit_wrap small">
		<h3 class="tit_ico_notice">ONTIC HIS 유지보수 현황</h3>
	</div>
	
	<ul class="list6 db-list mgb20" style="width:calc(100% + 8px)">
		<li id="cust_top0" class="pdr8" onclick="javascript:custGubunTab('0');" style="cursor:pointer;">
			<div class="db-greybox colorBlack" style="padding:20px 10px 23px;">총 거래처<span class="num_db pdl8" id="top1"></span></div>
		</li>
		<li id="cust_top1" class="pdr8" onclick="javascript:custGubunTab('1');" style="cursor:pointer;">
			<div class="db-greybox" style="padding:20px 10px 23px;">종합병원<span class="num_db pdl8" id="top2"></span></div>
		</li>
		<li id="cust_top2" class="pdr8" onclick="javascript:custGubunTab('2');" style="cursor:pointer;">
			<div class="db-greybox" style="padding:20px 10px 23px;">병원<span class="num_db pdl8" id="top3"></span></div>
		</li>
		<li id="cust_top3" class="pdr8" onclick="javascript:custGubunTab('3');" style="cursor:pointer;">
			<div class="db-greybox" style="padding:20px 10px 23px;">의원<span class="num_db pdl8" id="top4"></span></div>
		</li>
		<li id="cust_top4" class="pdr8" onclick="javascript:custGubunTab('4');" style="cursor:pointer;">
			<div class="db-greybox" style="padding:20px 10px 23px;">요양<span class="num_db pdl8" id="top5"></span></div>
		</li>
		<li id="cust_top5" class="pdr8" onclick="javascript:custGubunTab('5');" style="cursor:pointer;">
			<div class="db-greybox" style="padding:20px 10px 23px;">검진센터<span class="num_db pdl8" id="top6"></span></div>
		</li>
	</ul>
	
	<div class="floatWrap">
		<div class="floatL w300 mgr10">
			<div class="db_borderbox h270" style="overflow-y:hidden !important" id="char1"></div>
		</div>
		<div class="floatL w360 h270 mgr10" style="overflow-y:hidden !important">   
		
			<div class="db-greybox colorBlack" style="padding:22px 10px 22px" id="char2_C002">
			</div>
			<div class="db-greybox colorBlack" style="padding:22px 10px 22px" id="char2_C001">
			</div>
			<div class="db-greybox colorBlack" style="padding:22px 10px 20px" id="char2_C003">
			</div>
			<div class="db-greybox colorBlack" style="padding:22px 10px 21px"id="char2_C005">
			</div>
			
		</div>
		<div class="floatL" style="width:320px;">
			<div class="db_borderbox h270" id="char3" style="overflow-y:hidden !important">
				<div class="db-greybox colorBlack" style="padding:58px 10px 51px">
					<span class="danger-red"></span>[유상] 계약 만료 
					<span class="num_db_none counter" style="min-width:60px;text-align:right;" data-count="0" id="con_pro1">0</span>
					<span class="num_db_small colorGrey"  id="con_pro2"></span>
				</div>
				<div class="db-greybox colorBlack" style="padding:58px 10px 51px">
					<span class="danger-red"></span>[무상] 계약 만료 
					<span class="num_db_none  counter" style="min-width:60px;text-align:right;" data-count="0" id="con_pro3">0</span>
					<span class="num_db_small  colorGrey" id="con_pro4"></span>
				</div>
			</div>
		</div>
	</div>

	<div id="accordion-resizer" class="ui-widget-content">
	  <div id="accordion">
	  	<h3 style="padding-left:30px" id="conInfoTitleC002"></h3>
		<div style="padding:0;max-height:250px;" id="conInfoC002"/></div>
		<h3 style="padding-left:30px" id="conInfoTitleC001"></h3>
		<div style="padding:0;max-height:250px;" id="conInfoC001"/></div>
		<h3 style="padding-left:30px" id="conInfoTitleC003"></h3>
		<div style="padding:0;max-height:250px;" id="conInfoC003"/></div>
		<h3 style="padding-left:30px" id="conInfoTitleC005"></h3>
		<div style="padding:0;max-height:250px;" id="conInfoC005"/></div>
	  </div>
	</div>
	
</div>


<div style="width: 100%; background-color: #f6f6f6; height:40px;">
	<span class="floatL">
		<h3 class="mgl10" style="font-size:15px;line-height:40px;" id="as_chart_custname"></h3>
		<input type="hidden" name="cust_no"  id="cust_no" value="" />
	</span>
	<span class="floatR">
		A/S 접수일
		 <input type="text" class="w150 mgr5 mtz-monthpicker-widgetcontainer" name="as_search_dt" id="as_search_dt">~
		 <input type="text" class="w150 mgr5 mtz-monthpicker-widgetcontainer" name="as_search_dt2" id="as_search_dt2">
	</span>
</div>


<div style="display:table;width:100%;margin:20px 0">
	<div class="floatL w490 mgr60">
		<div class="tit_wrap small">
			<h3 class="tit_ico_graph3">A/S 현황</h3>
		</div>
		<div class="db_borderbox" style="height:243px; overflow:hidden;" id="as_char1">
			<span style="padding:110px 175px 110px 175px;font-size:14px;font-weight:500;color:#a2a2a2;">
			거래처를 선택해 주세요
			</span>
			<!-- <div style="height:50%">
				<div class="parcial">
					<div class="progressBar">
						<div class="percentagem" ></div>
					</div>
				</div>
				<div style="width:100%; height: 20px;">
					<span class="num_db_small colorGrey floatR" style="margin-right:40px" id="cust_as_per">20.0%</span>
				</div>
				<div class="floatR" style="margin-right:40px">
					<span class="num_db_small3 colorGrey" id="cust_as_count">20</span>
					<span class="num_db_small3 colorGrey" id="cust_as_total">/ 총 100 건 </span>
				</div>
			</div>
			
			<div style="height:50%">
				<div class="parcial">
					<div class="progressBar">
						<div class="percentagem" ></div>
					</div>
				</div>
				<div style="width:100%; height: 20px;">
					<span class="num_db_small colorGrey floatR" style="margin-right:40px" id="cust_as_per">20.0%</span>
				</div>
				<div class="floatR" style="margin-right:40px">
					<span class="num_db_small3 colorGrey" id="cust_as_count">20</span>
					<span class="num_db_small3 colorGrey" id="cust_as_total">/ 총 100 건 </span>
				</div>
			</div> -->
			
		</div>
	</div>
	<div class="floatL w200 mgr50">
		<div class="tit_wrap small">
			<h3 class="tit_ico_graph3" onclick="$('#chart1Layer').show();" style="cursor:pointer" title="확대">A/S 진행 상태 분포</h3>
		</div>
		<div class="db_borderbox" style="height:243px; overflow:hidden;" id="as_char2">
			<span style="padding:100px 30px 50px 30px;font-size:14px;font-weight:500;color:#a2a2a2;">거래처를 선택해 주세요</span>
		</div>
	</div>
	<div class="floatL w200">
		<div class="tit_wrap small">
			<h3 class="tit_ico_graph3" onclick="$('#chart2Layer').show();" style="cursor:pointer" title="확대">A/S 원인 유형별 분포</h3>
		</div>
		<div class="db_borderbox" style="height:243px; overflow:hidden;" id="as_char3">
			<span style="padding:100px 30px 50px 30px;font-size:14px;font-weight:500;color:#a2a2a2;">거래처를 선택해 주세요</span>
		</div>
	</div>
</div>


<div style="width: 100%;margin:60px 0px 60px 0px;border-style:dashed;border-color:#888888"></div>


<div class="tit_wrap small">
	<h3 class="tit_ico_notice">ONTIC HIS 프로젝트 현황</h3>
</div>

<div class="mgb10" style="width: 100%; background-color: #f6f6f6; height:40px;">
	<span class="floatR">
		수주심의 확정일 기준
		<select class="w150" id="project_search_dt" onchange="projectInfoCtr();"></select>
		<!-- <select class="w150 mgl5" id="product_status" onchange="projectInfoCtr();">
			<option>진행중</option>
			<option>보류</option>
			<option>종료</option>
		</select> -->
	</span>
</div>	

<ul class="list5 db-list mgb20" style="width:calc(100% + 8px)">
	<li id="Secondli1" class="pdr8">
		<div class="db-greybox colorBlack">총 프로젝트<span class="num_db pdl8 colorBlue" id="pro_top1">0</span></div>
	</li>
	<li id="Secondli2"class="pdr8">
		<div class="db-greybox colorBlack">수주심의(확정)<span class="num_db pdl8 " id="pro_top2">0</span></div>
	</li>
	<li id="Secondli3" class="pdr8">
		<div class="db-greybox colorBlack">계약(완료)<span class="num_db pdl8 " id="pro_top3">0</span></div>
	</li>
	<li id="Secondli4" class="pdr8">
		<div class="db-greybox colorBlack">오픈(완료)<span class="num_db pdl8 " id="pro_top4">0</span></div>
	</li>
	<li id="Secondli5" class="pdr8">
		<div class="db-greybox colorBlack">종료(완료)<span class="num_db pdl8 " id="pro_top5">0</span></div>
	</li>
</ul>

<div class="floatWrap mgb10">
	<table class="calendarTb">
		<caption>유지보수현황</caption>
		<colgroup>
			<col style="width:50px">
			<col style="width:210px">
			<col style="width:80px">
			<col style="width:100px">
			<col span="5" style="width:auto">
		</colgroup>
		<thead>
			<tr>
				<th rowspan="2">No</th>
				<th rowspan="2">거래처(CRM)</th>
				<th rowspan="2">프로젝트명</th>
				<th rowspan="2">PM명</th>
				<th colspan="5">진행 현황</th>
			</tr>
			<tr>
				<th>수주심의</th>
				<th>계약</th>
				<th>개발</th>
				<th>오픈</th>
				<th>종료</th>
			</tr>
		</thead>
		<tbody id="project_tb_body">
			
		</tbody>
	</table>
</div>
	

