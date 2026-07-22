<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="egovframework.com.comm.util.DateTimeUtil"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript" src="/js/jquery.mtz.monthpicker.js"></script>
<script type="text/javascript">

	var onticHisArr;
	var onticSmsArr;

	
	google.charts.load('current', {packages: ['corechart', 'line']});		/**	a/s 추이 그래프	*/

	$(document).ready(function(){
		
		$( "#solution_start_dt" ).datepicker("destroy");
		$( "#solution_end_dt" ).datepicker("destroy");
		$( "#solution_start_dt" ).monthpicker(monthpicker_option);
		$( "#solution_end_dt" ).monthpicker(monthpicker_option);
		
		var cuDate = new Date();
		var lastDate = new Date(cuDate.getFullYear(),cuDate.getMonth() -1, 1);
		var firstDate = new Date(cuDate.getFullYear(),cuDate.getMonth() - 1, 1);
		$( "#solution_start_dt" ).val($.datepicker.formatDate('yy/mm', firstDate));
		$( "#solution_end_dt" ).val($.datepicker.formatDate('yy/mm', lastDate));
		
		// 전월 날짜 구하기
		var cuDate = new Date();
		var firstDate = new Date(cuDate.getFullYear(),cuDate.getMonth() - 1, 1);
		var yyyymm = firstDate.getFullYear() + " 년 " + (firstDate.getMonth() + 1) + " 월 기준";
		$("#setTab1SolutionLeftTitle").html(yyyymm);
		
		var billCodeArray = []; 
		
		proOneTab('1');
		calChange();
 
	}) ;
	
	/* 솔루션,부가솔루션 */
	/* function thirdTab(gubun){
		for(var i = 1 ; i <= 3 ; i++){
			if(Number(gubun) == i){
				if(!$('#Thirdli' + i).hasClass("active"))	$('#Thirdli' + i).addClass("active") ;
				$('#Thirddiv' + i).show();
			}else{
				if($('#Thirdli' + i).hasClass("active")) $('#Thirdli' + i).removeClass("active") ;
				$('#Thirddiv' + i).hide();
			}
		}	
		goSecond();
	} */
	
	
	function proOneTab(gubun){
		
		if(gubun == '1'){
			if(!$('#Thirdli1').hasClass("active"))	$('#Thirdli1').addClass("active") ;
			if($('#Thirdli3').hasClass("active")) $('#Thirdli3').removeClass("active") ;
			
			for(var i = 3 ; i <=5 ; i++){
				if($('#pro'+ i ).hasClass("active")) $('#pro'+i).removeClass("active") ;
			}
			if(!$('#pro'+ gubun).hasClass("active"))	$('#pro'+ gubun).addClass("active") ;
			
			$('#Thirddiv1').show();
			$('#Thirddiv2').hide();
			$('#Thirddiv3').hide();
		}else if(gubun == '3'){
			
			if(!$('#Thirdli3').hasClass("active"))	$('#Thirdli3').addClass("active") ;
			if($('#Thirdli1').hasClass("active")) $('#Thirdli1').removeClass("active") ;
			
			for(var i = 1 ; i <=2 ; i++){
				if($('#pro'+ i ).hasClass("active")) $('#pro'+i).removeClass("active") ;
			}
			if(!$('#pro'+ gubun).hasClass("active"))	$('#pro'+ gubun).addClass("active") ;
			
			$('#Thirddiv3').show();
			$('#Thirddiv1').hide();
			$('#Thirddiv2').hide();
		}
		
		if(gubun == '1'){
			$('.prosolbtn').show();
			$('.probusolbtn').hide();
			goInfo('C001');
		}else if(gubun == '3'){
			$('.prosolbtn').hide();
			$('.probusolbtn').show();
			goInfo2('P000000678');
		}
		
	}
	
	/*거래처카운팅-부가솔루션*/
	function goInfo2(codeGubun){
		var str_dt = $( "#solution_start_dt" ).val();
		var end_dt = $( "#solution_end_dt" ).val();
		
		var gubun = '';
		if(codeGubun == 'P000000678'){
			gubun = 3;
		}else if(codeGubun == 'P000000644'){
			gubun = 4;
		}else if(codeGubun == 'A200000006'){
			gubun = 5;
		}
		
		for(var i = 3 ; i <= 5 ; i++){
			if(Number(gubun) == i){
				if(!$('#pro' + i).hasClass("active"))	$('#pro' + i).addClass("active") ;
			}else{
				if($('#pro' + i).hasClass("active")) $('#pro' + i).removeClass("active") ;
			}
		}
		
		var datas = {'firstFlag' : '3' , 'item_code': codeGubun, 'str_dt': str_dt, 'end_dt':end_dt } ; 
		common.ajaxCall(datas, '/ad/main/getMainInfo.do', 'makeInfo1') ;
		
		
		
	}
	
	/*거래처카운팅-솔루션 */
	function goInfo(codeGubun){
		
		var gubun = '';
		if(codeGubun == 'C001'){
			gubun = '1';
		}else if(codeGubun == 'C004'){
			gubun = '2';
		}
		for(var i = 1 ; i < 3 ; i++){
			if(Number(gubun) == i){
				if(!$('#pro' + i).hasClass("active"))	$('#pro' + i).addClass("active") ;
				$('#Thirddiv' + i).show();
			}else{
				if($('#pro' + i).hasClass("active")) $('#pro' + i).removeClass("active") ;
				$('#Thirddiv' + i).hide();
			}
		}
		
		var datas = {'firstFlag' : '1' , 'bill_code': codeGubun} ; 
		common.ajaxCall(datas, '/ad/main/getMainInfo.do', 'makeInfo1') ;
		productGubun(gubun);
		
	}
	
	/* 계약현황 */
	function goSecond(){
		var second = "" ; 
		var third = "" ; 
		for(var i = 1 ; i <= 6 ; i++){
			if($('#Secondli' + i).hasClass("active")) second = i ;/*병원유형 */
		}	
		
		for(var i = 1 ; i <= 5 ; i++){
			if($('#pro' + i).hasClass("active"))	third = i  ;
		}
		
		if( third == 1 || third == 2 ){
			var datas = {'firstFlag' : '1', 'secondFlag' : second, 'thirdFlag' : third} ;
			common.ajaxCall(datas, '/ad/main/getMainSubInfo.do', 'makeMidInfo'+third) ;
		}else{
			getTab1SolutionLeft();
			getTab1SolutionRight();
		}
	}
	
	
	function firstTab(gubun){
		location.href = "/ad/main/list" + gubun + ".do" ; 
	}
	
	
	function makeInfo1(data){
		var top1 = typeof data.top1 != "undefined" ? data.top1 : null ; 
		if(top1 != null){
			$('#top1').html(common.nvl(top1.tot_count , '0')) ; 
			$('#top2').html(common.nvl(top1.flag1 , '0')) ; 
			$('#top3').html(common.nvl(top1.flag2 , '0')) ; 
			$('#top4').html(common.nvl(top1.flag3 , '0')) ; 
			$('#top5').html(common.nvl(top1.flag4 , '0')) ;
			$('#top6').html(common.nvl(top1.flag5 , '0')) ;
		}else{
			$('#top1').html('0') ; 
			$('#top2').html('0') ; 
			$('#top3').html('0') ; 
			$('#top4').html('0') ; 
			$('#top5').html('0') ;
			$('#top6').html('0') ;
		}
		
		goSecond();
	}
	

	
	/////부가솔루션///////////////////////////////////////////////////////////////////////////
	/*부가솔루션-계약현황  */
	
	
	function makeMidInfo3(data){
		
		var third = "" ; 
		for(var i = 1 ; i <= 3 ; i++){
			if($('#Thirdli' + i).hasClass("active"))	third = i  ;
		}	
		if(third !='3' ) return;
		onticHisArr = typeof data.resultVO != "undefined" ? data.resultVO : null ; 
		
		if(third == "3"){
			var b1=0,b2=0,b3=0,b4=0,b5=0,b6=0,b7=0;
			if(onticHisArr != null){
				
				for (var i=0; i < onticHisArr.length; i++){
					b1 += Number(onticHisArr[i].b1);
					b2 += Number(onticHisArr[i].b2);
					b3 += Number(onticHisArr[i].b3);
					b4 += Number(onticHisArr[i].b4);
					b5 += Number(onticHisArr[i].b5);
					b6 += Number(onticHisArr[i].b6);
					b7 += Number(onticHisArr[i].b7);
				}
				
				
				$('#s_b1').html(common.nvl(b1 , '0')) ;
				$('#s_b2').html(common.nvl(b2 , '0')) ;
				$('#s_b3').html(common.nvl(b3 , '0')) ;
				$('#s_b4').html(common.nvl(b4 , '0')) ;
				$('#s_b5').html(common.nvl(b5 , '0')) ;
				$('#s_b6').html(common.nvl(b6 , '0')) ;
				$('#s_b7').html(common.nvl(b7 , '0')) ;	
			}
		}
		
		/* getTab1SolutionLeft();
		getTab1SolutionRight();
		 *//* var datas={};
		common.ajaxCallAsync(datas, '/ad/main/getTab1SolutionItemList.do', 'setTab1SolutionItemListData') ; */
	}
	
	
	function setTab1SolutionItemListData(data){
		var resultData = typeof data.resultList != "undefined" ? data.resultList : null ; 
		$('#item_code').empty();
		
		if (resultData.length > 0) {
			var str =''
			str += '<option value="">전체선택</option>'
			for(var i =0 ; i < resultData.length; i++){
				var datas = resultData[i];
				str += '<option value="'+datas.ITEM_CD+'">' +datas.ITEM_NM+'</option>';		
			}
			
			$('#item_code').html(str);
		}else{
			
		}
		
	}
	
	
	
	function getTab1SolutionLeft(){
		
		var second = "" ; 
		var item_code ="";
		for(var i = 1 ; i <= 6 ; i++){
			if($('#Secondli' + i).hasClass("active")) second = i ;
		}
		
		
		for(var i = 3 ; i <= 5 ; i++){
			if($('#pro' + i).hasClass("active")) pro = i ;
		}
		
		if(pro == '3'){
			item_code ='P000000678';
		}else if(pro == '4'){
			item_code ='P000000644';
		}else if(pro == '5'){
			item_code ='A200000006';
		}
		
		var str_dt = $( "#solution_start_dt" ).val();
		var end_dt = $( "#solution_end_dt" ).val();
		
		
		var datas = {'firstFlag' : '1', 'secondFlag' : second, 'item_code' : item_code , 'str_dt': str_dt, 'end_dt': end_dt};
		common.ajaxCallAsync(datas, '/ad/main/getTab1SolutionLeft.do', 'setTab1SolutionLeftData') ;
		
	}
	
	function getTab1SolutionRight(){
		
		var second = "" ; 
		var item_code = "" ; 
		for(var i = 1 ; i <= 6 ; i++){
			if($('#Secondli' + i).hasClass("active")) second = i ;
		}	
		
		for(var i = 3 ; i <= 5 ; i++){
			if($('#pro' + i).hasClass("active")) pro = i ;
		}
		
		if(pro == '3'){
			item_code ='P000000678';
		}else if(pro == '4'){
			item_code ='P000000644';
		}else if(pro == '5'){
			item_code ='A200000006';
		}
		
		var datas = 
		{'firstFlag' : '1',
		 'secondFlag' : second,
		 'str_dt' : $('#solution_start_dt').val(),
		 'end_dt' : $('#solution_end_dt').val(),
		 'item_code' : item_code
		} ;
		common.ajaxCallAsync(datas, '/ad/main/getTab1SolutionRight.do', 'setTab1SolutionRightData') ;
		
	}
	
	function setTab1SolutionLeftData(data){
		
		var resultData = typeof data.resultList != "undefined" ? data.resultList : null ; 
		$('#setTab1SolutionLeftData').empty();
		console.log(resultData);
		 if (resultData.length > 0) {
			var str =''
			for(var i = 0 ; i < resultData.length; i++){
				var rank = i+1;
				var datas = resultData[i];
				str += '<tr style="cursor:pointer" onclick="goDetailForm7(\''+ datas.SEQ +'\')">';
				str += '<td>'+ rank +'</td>';		
				str += '<td>'+datas.CRM_CODE+'</td>';	
				str += '<td class="uder_line">'+datas.CUST_KOR_NAME+'</td>';		
				str += '<td>'+common.nvl(common.comma(datas.MISU_AMT),'0')+'</td>';
				str += '</tr>';
			}
			$('#setTab1SolutionLeftData').html(str);
		}else{
			commonTable.notData(4, '데이터가 없습니다.', 'setTab1SolutionLeftData');
		} 
		
		 
	}
	
	function setTab1SolutionRightData(data){
		   var resultData = typeof data.resultList != "undefined" ? data.resultList : null ; 
			$('#setTab1SolutionRightData').empty();
			
			console.log(resultData);
			
			 if (resultData.length > 0) {
				var str =''
				for(var i =0 ; i < resultData.length; i++){
					var datas = resultData[i];
					
					var issue_dt = "-";   
					if (common.nvl(datas.ISSUE_DT, '').length == 8){
						issue_dt = makeDate(datas.ISSUE_DT,"-");
			 		}
					str += '<tr style="cursor:pointer" onclick="goDetailForm7(\''+ datas.SEQ +'\')">';
					str += '<td>'+datas.CRM_CODE+'</td>';	
					str += '<td class="uder_line">'+datas.CUST_KOR_NAME+'</td>';		
					str += '<td>'+common.nvl(common.comma(datas.TOTAL_AMT),'0')+'</td>';
					str += '<td>'+issue_dt+'</td>';
					str += '</tr>';
				}
				$('#setTab1SolutionRightData').html(str);
			}else{
				commonTable.notData(4, '데이터가 없습니다.', 'setTab1SolutionRightData');
			}
			
			
	}
	
	function calChange(){
		$("#solution_start_dt").change(function(){
			var codeVal ='';
			for(var i = 3 ; i <= 5 ; i++){
				if($('#pro' + i).hasClass("active") ){
					if(i == 3){
						codeVal = 'P000000678';
					}else if(i == 4){
						codeVal = 'P000000644';
					}else if(i == 5){
						codeVal = 'A200000006';
					}
				}	 
			}
			
			goInfo2(codeVal);
			
		});
		
		$("#solution_end_dt").change(function(){
			var codeVal ='';
			for(var i = 3 ; i <= 5 ; i++){
				if($('#pro' + i).hasClass("active") ){
					if(i == 3){
						codeVal = 'P000000678';
					}else if(i == 4){
						codeVal = 'P000000644';
					}else if(i == 5){
						codeVal = 'A200000006';
					}
				}	 
			}
			
			goInfo2(codeVal);
		});
	}
	///////////////////////////////////////////////////////////////////////////////////////
	
	/*계약현황HIS */
	function makeMidInfo1(data){
		
		var third = "" ; 
		for(var i = 1 ; i <= 3 ; i++){
			if($('#Thirdli' + i).hasClass("active"))	third = i  ;
		}	
		
		onticHisArr = typeof data.resultVO != "undefined" ? data.resultVO : null ; 
		
		if(third == "1"){
			var a1=0,a2=0,a3=0,a4=0,a5=0,a6=0,b1=0,b2=0,b3=0,b4=0,b5=0,b6=0,b7=0,b8=0;
			if(onticHisArr != null){
				
				for (var i=0; i < onticHisArr.length; i++){
					a1 += Number(onticHisArr[i].a1);
					a2 += Number(onticHisArr[i].a2);
					a3 += Number(onticHisArr[i].a3);
					a4 += Number(onticHisArr[i].a4);
					a5 += Number(onticHisArr[i].a5);
					a6 += Number(onticHisArr[i].a6);
					b1 += Number(onticHisArr[i].b1);
					b2 += Number(onticHisArr[i].b2);
					b3 += Number(onticHisArr[i].b3);
					b4 += Number(onticHisArr[i].b4);
					b5 += Number(onticHisArr[i].b5);
					b6 += Number(onticHisArr[i].b6);
					b7 += Number(onticHisArr[i].b7);
					b8 += Number(onticHisArr[i].b8);
				}
				
				$('#a1').html(common.nvl(a1 , '0')) ;
				$('#a2').html(common.nvl(a2 , '0')) ;
				$('#a3').html(common.nvl(a3 , '0')) ;
				$('#a4').html(common.nvl(a4 , '0')) ;
				$('#a5').html(common.nvl(a5 , '0')) ;
				$('#a6').html(common.nvl(a6 , '0')) ;
				
				$('#b1').html(common.nvl(b1 , '0')) ;
				$('#b2').html(common.nvl(b2 , '0')) ;
				$('#b3').html(common.nvl(b3 , '0')) ;
				$('#b4').html(common.nvl(b4 , '0')) ;
				$('#b5').html(common.nvl(b5 , '0')) ;
				$('#b6').html(common.nvl(b6 , '0')) ;
				$('#b7').html(common.nvl(b7 , '0')) ;
				$('#b8').html(common.nvl(b8 , '0')) ;
			}
		}
		
		getTab1LeftList();
		getTab1RightTop();
		getAsAnalList();
	}
	
	/* 거래처 유형에 따른 계약현황  */
	function secondTab(gubun){
		for(var i = 1 ; i <= 6 ; i++){
			if(Number(gubun) == i){
				if(!$('#Secondli' + i).hasClass("active")) $('#Secondli' + i).addClass("active") ;
			}else{
				if($('#Secondli' + i).hasClass("active")) $('#Secondli' + i).removeClass("active") ;
			}
			var asRightTitle = '';
			if (gubun == '1') asRightTitle = '총 거래처'; 
			if (gubun == '2') asRightTitle = '종합병원'; 
			if (gubun == '3') asRightTitle = '병원'; 
			if (gubun == '4') asRightTitle = '의원'; 
			if (gubun == '5') asRightTitle = '요양';
			if (gubun == '6') asRightTitle = '검진센터';
			
			$('#asRightTitle').html(asRightTitle);
		}
		
		goSecond();
	}
	
	
	
	
	function productGubun(gubun){
		 
		for(var i = 1 ; i <= 3 ; i++){
			if(Number(gubun) == i){
				if(!$('#pro' + i).hasClass("active"))	$('#pro' + i).addClass("active") ;
				$('#Thirddiv' + i).show();
			}else{
				if($('#pro' + i).hasClass("active")) $('#pro' + i).removeClass("active") ;
				$('#Thirddiv' + i).hide();
			}
		}  	
		/* 계약현황 */
		goSecond();
	}
	
	
	function getTab1LeftList() {
		
		var second = "" ; 
		var third = "" ; 
		for(var i = 1 ; i <= 6 ; i++){
			if($('#Secondli' + i).hasClass("active")) second = i ;
		}	
		
		
		
		/* for(var i = 1 ; i <= 3 ; i++){
			if($('#Thirdli' + i).hasClass("active"))	third = i  ;
		} */	
		
		var datas = {'firstFlag' : '1', 'secondFlag' : second, 'thirdFlag' : third} ;
		common.ajaxCallAsync(datas, '/ad/main/getFirstTab1LeftList.do', 'setTab1LeftListData') ;
	}
	
	var tab1LeftListData;
	
	function setTab1LeftListData(data){
		tab1LeftListData = typeof data.resultList != 'undefined' ? data.resultList : null;
		drawTab1LeftList($("#tab1LeftSelect").val());
	}
	
	function drawTab1LeftList(chk){
		if (tab1LeftListData == null){
			
			$('#firstTab1LeftListCnt').html('0');
			return;
		} 
			
		
		var cnt = -1;
		if (chk == "10") cnt = 10;
		else if (chk == "30") cnt = 30;
		
		$('#tab1LeftList').empty();
		
		if (tab1LeftListData.length > 0) {
			var str = '';
			var gradeText = '';
			
			for (var i=0; i < tab1LeftListData.length && (cnt == -1 || cnt > i); i++) {
				
				var datas = tab1LeftListData[i];
				var tdClass = '';
				
				str += '<tr style="cursor:pointer" onclick="goDetailForm5(\''+ datas.seq +'\')">';
				str += '		<td>'+(i+1)+'</td>';
				str += '		<td>'+common.nvl(datas.crm_code,'')+'</td>';
				str += '		<td class="uder_line">'+common.nvl(datas.cust_kor_name,'')+'</td>';
				str += '		<td>'+common.nvl(common.comma(datas.misu_amt),'0')+'</td>';
				str += '</tr>';
			}
			$('#tab1LeftList').html(str);
			$('#firstTab1LeftListCnt').html(Number(tab1LeftListData.length));
		} else {
			commonTable.notData(4, '데이터가 없습니다.', 'tab1LeftList');
		}
	}
	
	function makeTab1LeftList(data) {
		
		var resultList = typeof data.resultList != 'undefined' ? data.resultList : null;
		
		$('#tab1LeftList').empty();
		
		if (resultList != null && resultList.length > 0) {
			var str = '';
			var gradeText = '';
			
			for (var i=0; i<resultList.length; i++) {
				var datas = resultList[i];
				
				var tdClass = '';
				
				str += '<tr style="cursor:pointer" onclick="goDetailForm5(\''+ datas.seq +'\')">';
				str += '		<td>'+(i+1)+'</td>';
				str += '		<td>'+common.nvl(datas.crm_code,'')+'</td>';
				str += '		<td class="uder_line">'+common.nvl(datas.cust_kor_name,'')+'</td>';
				str += '		<td>'+common.nvl(common.comma(datas.misu_amt),'0')+'</td>';
				str += '</tr>';
			}
			$('#tab1LeftList').html(str);
			$('#firstTab1LeftListCnt').html(Number(resultList.length));
		} else {
			commonTable.notData(4, '데이터가 없습니다.', 'tab1LeftList');
		}
	}
	
	function goDetailForm5(seq){
		location.href = "/ad/cust/form5.do?seq=" + seq;
	}
	
	
	function goDetailForm7(seq){
		location.href = "/ad/cust/form7.do?seq=" + seq;
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
	
	function getAsAnalList(){
		var firstFlag = "1" ; 
		var secondFlag = "" ; 
		var thirdFlag = "" ; 
		
		for(var i = 1 ; i <= 6 ; i++){
			if($('#Secondli' + i).hasClass("active")) secondFlag = i ;
		}
		
		for(var i = 1 ; i <= 3 ; i++){
			if($('#pro' + i).hasClass("active"))	thirdFlag = i  ;
		}	
		
		
		var datas = {
				'firstFlag' 			: firstFlag , 
				'secondFlag' 		: secondFlag , 
				'thirdFlag' 			: thirdFlag  
		} ; 
		common.ajaxCall(datas, '/ad/main/getAsAnalysis.do', 'setAsAnalysis') ;
	}
	
	
	var asAnalysisList;
	function setAsAnalysis(data){
		$('#asAnalysisTable').empty();
		
		
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
		
		// 이슈건 출력
		for (var i=0;i < asAnalysisList.length ; i++){
			var data = asAnalysisList[i];
			
			if (data.CNT == 0){
				htmlTag += "<tr>";
				htmlTag += "	<td class='fontW_b colorRed'>ISSUE</td>";
				htmlTag += "	<td class='fontW_b colorRed' style='cursor:pointer;text-decoration:underline' onclick='goDetailForm("+data.SEQ+")'>["+data.CRM_CODE+"]"+data.CUST_NM+"</td>";
				htmlTag += "	<td class='fontW_b colorRed' style='cursor:pointer;text-decoration:underline' onclick='goAsList(\""+data.CUST_NM+"\")'>"+ common.comma(data.CNT) +"건/월</td>";
				htmlTag += "	<td class='fontW_b colorRed'>-</td>";
				htmlTag += "	<td class='fontW_b colorRed'>-</td>";
				htmlTag += "</tr>";
			}
		}
		
		$("#asAnalysisTable").html(htmlTag);
		
		return;
	}
	
	function viewMoreLayer(type){

		if (asAnalysisList == null || asAnalysisList.length < 1) return;
		
		// 이슈건을 재외한 새로운 Array객체를 만든다.
		var tmpList = new Array();
		for (var i=0; i < asAnalysisList.length; i++){
			
			if ((type == "C" || type == "D") && (asAnalysisList[i].AVG_AMT == '-' || asAnalysisList[i].AVG_AMT == '무상')) continue;
			if (Number(asAnalysisList[i].CNT) > 0) tmpList.push(asAnalysisList[i]);
		}
		
		
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
		
		$("#asListLayerTitle").html(layerTitle);
		$("#asListLayerCnt").html(tmpList.length);
		
		// 전월 날짜 구하기
		var cuDate = new Date();
		var firstDate = new Date(cuDate.getFullYear(),cuDate.getMonth() - 1, 1);
		var yyyymm = firstDate.getFullYear() + "년" + (firstDate.getMonth() + 1) + "월";
		$("#asListLayerYYMM").html(yyyymm);
		// 전월 날짜 구하기 끝
		
		$("#asListLayerBody").html(htmlTag);
		$("#asListLayer").show();
	}
	
	function getTab1RightTop() {
		
		var second = "" ; 
		var third = "" ; 
		for(var i = 1 ; i <= 5 ; i++){
			if($('#Secondli' + i).hasClass("active")) second = i ;
		}	
		for(var i = 1 ; i <= 3 ; i++){
			if($('#Thirdli' + i).hasClass("active"))	third = i  ;
		}	
		
		var datas = {'firstFlag' : '1', 'secondFlag' : second, 'thirdFlag' : third} ;
		common.ajaxCall(datas, '/ad/main/getFirstTab1RightTop.do', 'makeTab1RightTop') ;
	}
	
	function makeTab1RightTop(data) {
		
		var resultData = typeof data.resultData != 'undefined' ? data.resultData : null;
		
		if (!resultData) return;
		
		var isPlus = false;
		if (Number(resultData.CNT_RATE) > 0) isPlus = true;
		var tag1 = resultData.CNT_BY_DAY1 + "</span>건 / 월 <span class='" + (isPlus ? 'colorBlue' : 'colorRed') + " small'>(전전월 대비 " + (isPlus ? '↑' : '↓') + Math.abs(Number(resultData.CNT_RATE)) + "%)";
		
		isPlus = false;
		if (Number(resultData.AMT_RATE) > 0) isPlus = true;
		var tag2 = common.comma(resultData.AMT_BY_DAY1) + "</span>원 / 건 <span class='" + (isPlus ? 'colorBlue' : 'colorRed') + " small'>(전전월 대비 " + (isPlus ? '↑' : '↓') + Math.abs(Number(resultData.AMT_RATE)) + "%)";
		
		$('#setValue1').html(tag1);
		$('#setValue3').html(tag2);
		
	}
	
	/* SMS- 계약현황 */
	function makeMidInfo2(data) {
		
		var third = "" ; 
		for(var i = 1 ; i <= 3 ; i++){
			if($('#pro' + i).hasClass("active"))	third = i  ;
		}	
		
		onticSmsArr = typeof data.resultVO != "undefined" ? data.resultVO : null ; 
		
		if (third == '2') {
			if(onticSmsArr != null){
				
				var c1=0,c2=0,c3=0,c4=0,c5=0,f1=0,f2=0,f3=0,f4=0,f5=0;
				
				for (var i=0; i < onticSmsArr.length; i++){
					c2 += Number(onticSmsArr[i].c2);
					c3 += Number(onticSmsArr[i].c3);
					c4 += Number(onticSmsArr[i].c4);
					c5 += Number(onticSmsArr[i].c5);
					f2 += Number(onticSmsArr[i].f2);
					f3 += Number(onticSmsArr[i].f3);
					f4 += Number(onticSmsArr[i].f4);
					f5 += Number(onticSmsArr[i].f5);
				}
				
				c1 = c2 + c3 + c4 + c5;
				f1 = f2 + f3 + f4 + f5;
				
				$('#sms_top1').html(c1);
				$('#sms_top2').html(c2);
				$('#sms_top3').html(c3);
				$('#sms_top4').html(c4);
				$('#sms_top5').html(c5);
				
				
				$('#sms_mid1').html(f1);
				$('#sms_mid2').html(f2);
				$('#sms_mid3').html(f3);
				$('#sms_mid4').html(f4);
				$('#sms_mid5').html(f5);
		
				
				
			}
		}
		
		tab1SmsLeft();
		tab1SmsRight();
	}
	
	function tab1SmsLeft(data) {
		var second = "" ; 
		var third = "" ; 
		for(var i = 1 ; i <= 5 ; i++){
			if($('#Secondli' + i).hasClass("active")) second = i ;
		}	
		for(var i = 1 ; i <= 3 ; i++){
			if($('#pro' + i).hasClass("active"))	third = i  ;
		}	
		
		var datas = {'firstFlag' : '1', 'secondFlag' : second, 'thirdFlag' : third} ;
		common.ajaxCall(datas, '/ad/main/getTab1SmsLeft.do', 'makeTab1SmsLeft') ;
	}
	
	function makeTab1SmsLeft(data) {
		var resultList = typeof data.resultList != 'undefined' ? data.resultList : null;
		
		if (resultList != null && resultList.length > 0) {
			var str = '';
			var gradeText = '';
			
			for (var i=0; i<resultList.length; i++) {
				var datas = resultList[i];
				
				var tdClass = '';
				
				str += '<tr style="cursor:pointer" onclick="goDetailForm5(\''+ datas.seq +'\')">';
				str += '	<td>'+(i+1)+'</td>';
				str += '	<td class="uder_line">'+common.nvl(datas.cust_kor_name, '')+'</td>';
				str += '	<td>'+common.nvl(datas.mtac_code_nm, '')+'</td>';
				str += '	<td>'+common.nvl(common.comma(datas.misu_amt),'')+'</td>';
				str += '</tr>';
			}
			$('#firstTab1SmsLeftListCnt').html(Number(resultList.length));
			$('#smsLeftList').html(str);
		}else {
			commonTable.notData(4, '데이터가 없습니다.', 'smsLeftList');
		}
	}
	
	function tab1SmsRight() {
		var second = "" ; 
		var third = "" ; 
		for(var i = 1 ; i <= 5 ; i++){
			if($('#Secondli' + i).hasClass("active")) second = i ;
		}	
		for(var i = 1 ; i <= 3 ; i++){
			if($('#pro' + i).hasClass("active"))	third = i  ;
		}	
		
		var datas = {'firstFlag' : '1', 'secondFlag' : second, 'thirdFlag' : third} ;
		common.ajaxCall(datas, '/ad/main/getTab1SmsRight.do', 'makeTab1SmsRight') ;
	}
	
	var CHARLIST = null ;
	
	function makeTab1SmsRight(data){
		var charList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		if(charList != null){
			CHARLIST = charList ; 
			google.charts.setOnLoadCallback(drawLineColors);
		}
	}
	
	function drawLineColors(){
		var newArr = [];
		if(CHARLIST != null && CHARLIST.length > 0){
			for (var i = 0 ; i < CHARLIST.length ; i++){
				var tmpArr = [];
				tmpArr[0] = CHARLIST[i].YYYYMM + "월";
				tmpArr[1] = CHARLIST[i].TOT;
				tmpArr[2] = CHARLIST[i].C1;
				tmpArr[3] = CHARLIST[i].C2;
				tmpArr[4] = CHARLIST[i].C3;
				tmpArr[5] = CHARLIST[i].C4;
				newArr.push(tmpArr);
			}
		}
		
		var data = new google.visualization.DataTable();
	      data.addColumn('string', 'X');
	      data.addColumn('number', 'Total');
	      data.addColumn('number', 'S-50');
	      data.addColumn('number', 'S-100');
	      data.addColumn('number', 'L-80');
	      data.addColumn('number', 'L-150');

	      data.addRows(newArr);

	      var options = {
				width : 480,
				height : 330
	      };

	      var chart = new google.visualization.LineChart(document.getElementById('char1'));
	      chart.draw(data, options);
	}
	
	function goHisCustList(flag){
		
		if (onticHisArr == null) return;

		var seqStr = "";
		
		for (var i=0; i < onticHisArr.length;i++){
			if (onticHisArr[i][flag] != 0) seqStr += ",'" + onticHisArr[i].seq + "'"; 
		}
		
		
		if (seqStr === ""){
			alert("대상 건이 없습니다.");
			return;
		}
		
		var datas = {'seqArr' : seqStr.substring(1)} ;
		common.ajaxCall(datas, '/ad/main/getCustListBySeq.do', 'showCustListLayer') ;
	}
	
	function goSmsCustList(flag){
		
		if (onticSmsArr == null) return;

		var seqStr = "";
		
		if(flag != 'c1' || flag != 'f1'){
			for (var i=0; i < onticSmsArr.length;i++){
					if (onticSmsArr[i][flag] != 0) seqStr += ",'" + onticSmsArr[i].seq + "'"; 
			}
		}
		if(flag == 'c1' ){
			for (var i=0; i < onticSmsArr.length;i++){
				if (onticSmsArr[i]['c2'] != 0) seqStr += ",'" + onticSmsArr[i].seq + "'";
				if (onticSmsArr[i]['c3'] != 0) seqStr += ",'" + onticSmsArr[i].seq + "'";
				if (onticSmsArr[i]['c4'] != 0) seqStr += ",'" + onticSmsArr[i].seq + "'";
				if (onticSmsArr[i]['c5'] != 0) seqStr += ",'" + onticSmsArr[i].seq + "'";
				
			}
		}
		
		
		if(flag == 'f1' ){
			for (var i=0; i < onticSmsArr.length;i++){
				if (onticSmsArr[i]['f2'] != 0) seqStr += ",'" + onticSmsArr[i].seq + "'";
				if (onticSmsArr[i]['f3'] != 0) seqStr += ",'" + onticSmsArr[i].seq + "'";
				if (onticSmsArr[i]['f4'] != 0) seqStr += ",'" + onticSmsArr[i].seq + "'";
				if (onticSmsArr[i]['f5'] != 0) seqStr += ",'" + onticSmsArr[i].seq + "'";
				
			}
		}
		
		if (seqStr === ""){
			alert("대상 건이 없습니다.");
			return;
		}
		
		var datas = {'seqArr' : seqStr.substring(1)} ;
		console.log(datas);
		common.ajaxCall(datas, '/ad/main/getCustListBySeq.do', 'showCustListLayer') ;
	}
	
	function showCustListLayer(data){
		var custList = typeof data.resultList != "undefined" ? data.resultList : null ;
		
		if (custList == null) return;
		
		
		var htmlStr = "";
		for (var i=0; i < custList.length; i++){
			htmlStr += '<tr style="cursor:pointer" onclick="goDetailForm5(\''+ custList[i].SEQ +'\')">';
			htmlStr += '	<td>' + custList[i].CRM_CODE + '</td>';
			htmlStr += '	<td>' + custList[i].CUST_GUBUN + '</td>';
			htmlStr += '	<td>' + custList[i].FOUNDATION_CODE + '</td>';
			htmlStr += '	<td>' + custList[i].SPECIALLY_CODE + '</td>';
			htmlStr += '	<td class="uder_line">' + custList[i].CUST_KOR_NAME + '</td>';
			htmlStr += '	<td>' + custList[i].DEAL_CODE + '</td>';
			htmlStr += '	<td>' + common.strToDate(custList[i].CONTRACT_DT) + '</td>';
			htmlStr += '</tr>';
		}
		
		$("#custListBody").html(htmlStr);
		$("#custListLayer").show();
		
	}
	
</script>

<style>
.btn-primary {
    color: #fff;
    background-color: #007bff;
    border-color: #007bff;
}
.btn-primary:hover {
    color: #fff;
    background-color: #0069d9;
    border-color: #0062cc;
}

.btn-success {
    color: #fff;
    background-color: #218838;
    border-color: #1e7e34;
}


.btn-success:hover {
    color: #fff;
    background-color: #1a792f;
    border-color: #1e7e34;
}

.btn {
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



.btn-danger {
    color: #fff;
    background-color: #dc3545;
    border-color: #dc3545;
}

.btn-danger:hover {
    color: #fff;
    background-color: #c82333;
    border-color: #bd2130;
}


.btn-warning {
    color: #212529;
    background-color: #ffc107;
    border-color: #ffc107;
}


.btn-info {
    color: #fff;
    background-color: #17a2b8;
    border-color: #17a2b8;
}


.btn-info:hover {
    color: #fff;
    background-color: #1693a7;
    border-color: #17a2b8;
}

.prosolbtn .active{
 	background-color: #2d3033;
}

.probusolbtn .active{
 	background-color: #2d3033;
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


<!-- <ul class="tab_line big list3">
	<li id="Thirdli1" class="active"><a href="javascript:thirdTab('1');">ONTIC HIS</a></li>활성시 current
	<li id="Thirdli2"><a href="javascript:thirdTab('2');">ONTIC Messenger Service</a></li>
	<li id="Thirdli3"><a href="javascript:thirdTab('3');">부가솔루션</a></li>
</ul>
 -->

<ul class="tab_line big list2" style="margin-bottom:0px;">
	<li id="Thirdli1" class="active"><a href="javascript:proOneTab('1');">솔루션</a></li>
	<li id="Thirdli3"><a href="javascript:proOneTab('3');">부가솔루션</a></li>
</ul>
 


<!-- 상세품목선택  -->
<div class="tit_wrap small mgt5 mgb5">
	<div class="floatL prosolbtn">
		<button type="button" id="pro1" class="btn btn-primary active" onclick="javascript:goInfo('C001')"><span>ONTIC HIS</span></button>
		<button type="button" id="pro2" class="btn btn-success" onclick="javascript:goInfo('C004')"><span>OMS</span></button>
		<span class="colorRed tit_depth mgl20 mgt8">거래처 관리 > 등록된 유지보수 정보 기준으로 거래처를 카운팅 합니다. *폐업,해지 거래처 제외</span>
		
	</div>
	<div class="floatL probusolbtn"  style="display:none;">
		<button type="button" id="pro3" class="btn btn-primary active" onclick="javascript:goInfo2('P000000678')"><span>마약류통합관리시스템</span></button>
		<button type="button" id="pro4" class="btn btn btn-danger" onclick="javascript:goInfo2('P000000644')"><span>Ontic Sense</span></button>
		<button type="button" id="pro5" class="btn btn btn-info" onclick="javascript:goInfo2('A200000006')"><span>van인터페이스</span></button>
		<span style="margin-left: 320px;">
			<input type="text" class="w80 mgr5 mtz-monthpicker-widgetcontainer" name="solution_start_dt" id="solution_start_dt" readonly="">
			<input type="text" class="w80 mgr5 mtz-monthpicker-widgetcontainer" name="solution_end_dt" id="solution_end_dt" readonly="">
			<img class="ui-datepicker-trigger" src="/images/ico_calendar.png" alt="..." title="...">
			
		</span>	
	</div>
	
</div>
	
<!--거래처 -->
<ul class="list6 db-list mgb20" style="width:calc(100% + 8px)">
	<li id="Secondli1" class="pdr8 active" onclick="javascript:secondTab('1');" style="cursor:pointer;">
		<div class="db-greybox colorBlack">총 거래처<span class="num_db pdl8" id="top1">0</span></div>
	</li>
	<li id="Secondli2"class="pdr8" onclick="javascript:secondTab('2');" style="cursor:pointer;">
		<div class="db-greybox">종합병원<span class="num_db pdl8" id="top2">0</span></div>
	</li>
	<li id="Secondli3" class="pdr8"  onclick="javascript:secondTab('3');" style="cursor:pointer;">
		<div class="db-greybox">병원<span class="num_db pdl8" id="top3">0</span></div>
	</li>
	<li id="Secondli4" class="pdr8"  onclick="javascript:secondTab('4');" style="cursor:pointer;">
		<div class="db-greybox">의원<span class="num_db pdl8" id="top4">0</span></div>
	</li>
	<li id="Secondli5" class="pdr8"  onclick="javascript:secondTab('5');" style="cursor:pointer;">
		<div class="db-greybox">요양<span class="num_db pdl8" id="top5">0</span></div>
	</li>
	<li id="Secondli6" class="pdr8"  onclick="javascript:secondTab('6');" style="cursor:pointer;">
		<div class="db-greybox">검진센터<span class="num_db pdl8" id="top6">0</span></div>
	</li>
</ul>


<div id="Thirddiv1">
	<div class="tit_wrap small">
		<h3 class="tit_ico_notice">계약현황</h3>
	</div>
	
	<ul class="pro_arrow light mgb5">
		<li class="w100 current">무상</li><!-- 활성시 current -->
		<li class="w152">유상 전환 예정</li>
		<li class="w202">유상 전환 지연</li>
		<li class="w115">유상</li>
		<li class="w201">계약갱신</li>
		<li class="w230">갱신 전환 예정 / 지연</li>
	</ul>
	
	<div class="floatWrap mgb20">
		<div class="db-greybox blue w100 mgr5 floatL">
			<p>총 무상 </p><ul><li class="num_db colorBlue" id="a1" onclick="javascript:goHisCustList('a1');" style="cursor:pointer;">0</li></ul>
		</div>
		<div class="db-greybox blue w150 mgr-1 floatL">
			<p>무상 계약 만료 예정</p>
			<ul class="list2">
				<li class="num_db" onclick="javascript:goHisCustList('a2');" style="cursor:pointer;"><span id="a2">0</span><p class="small">(1~2개월)</p></li>
				<li class="num_db" onclick="javascript:goHisCustList('a3');" style="cursor:pointer;"><span id="a3">0</span><p class="small">(1개월↓)</p></li>
			</ul>
		</div>
		<div class="db-greybox blue w200 mgr5 floatL">
			<p class="colorRed">무상 계약 만료</p>
			<ul class="list3">
				<li class="num_db" onclick="javascript:goHisCustList('a4');" style="cursor:pointer;"><span id="a4">0</span><p class="small">(1개월↓)</p></li>
				<li class="num_db" onclick="javascript:goHisCustList('a5');" style="cursor:pointer;"><span id="a5">0</span><p class="small">(1~2개월)</p></li>
				<li class="num_db" onclick="javascript:goHisCustList('a6');" style="cursor:pointer;"><span id="a6">0</span><p class="small">(3개월↑)</p></li>
			</ul>
		</div>
		
		<div class="db-greybox blue w109 mgr5 floatL">
			<p>총 유상</p><ul><li class="num_db colorBlue" id="b1" onclick="javascript:goHisCustList('b1');" style="cursor:pointer;">0</li></ul>
		</div>
		<div class="db-greybox blue w201 floatL">
			<p>갱신대상 (자동갱신Y,2개월↓)</p>
			<ul class="list3">
				<li class="num_db" onclick="javascript:goHisCustList('b5');" style="cursor:pointer;"><span id="b5">0</span><p class="small">(3년차)</p></li>
				<!-- <li class="num_db" onclick="javascript:goHisCustList('b6');" style="cursor:pointer;"><span id="b6">0</span><p class="small">(5년차)</p></li>-->
				<li class="num_db" onclick="javascript:goHisCustList('b7');" style="cursor:pointer;"><span id="b7">0</span><p class="small">(5년↑)</p></li>
				<li class="num_db" onclick="javascript:goHisCustList('b8');" style="cursor:pointer;"><span id="b8">0</span><p class="small">(계약만료)</p></li>
				
			</ul>
		</div>
		<div class="db-greybox blue w225  floatL">
			<p class="colorRed">계약 만료 예정/만료(자동갱신N)</p>
			<ul class="list3">
				<li class="num_db" onclick="javascript:goHisCustList('b2');" style="cursor:pointer;"><span id="b2">0</span><p class="small">(1~2개월)</p></li>
				<li class="num_db" onclick="javascript:goHisCustList('b3');" style="cursor:pointer;"><span id="b3">0</span><p class="small">(1개월↓)</p></li>
				<li class="num_db" onclick="javascript:goHisCustList('b4');" style="cursor:pointer;"><span id="b4">0</span><p class="small">(계약만료)</p></li>
			</ul>
		</div>
		
	</div>
	
	<div class="floatWrap">
		<div class="floatL w490 mgr20">
			<div class="tit_wrap small">
				<h3 class="tit_ico_notice">수금현황</h3>
				<span class="colorRed tit_depth mgl20 mgt8">(전월 기준 연체 거래처 : <span id="firstTab1LeftListCnt">0</span>)</span>
				<span class="floatR">
				<select onchange="drawTab1LeftList(this.value)" id="tab1LeftSelect">
					<option value="10">TOP 10</option>
					<option value="30">TOP 30</option>
					<option value="total">전체보기</option>
				</select>
				</span>
			</div>
			<div class="db_borderbox h340">
				<table class="hType">
					<caption>A/S 접수 리스트 검색</caption>
					<colgroup>
						<col style="width:50px;" />
						<col style="width:80px;" />
						<col style="width:140px;" />
						<col style="width:100px;" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">순위</th>
							<th scope="col">CRM Code</th>
							<th scope="col">거래처명</th>
							<th scope="col">연체금액(원)</th>
<!-- 						<th scope="col">거래처 등급</th> -->
						</tr>
					</thead>
					<tbody id="tab1LeftList"></tbody>
				</table>
			</div>
		</div>
		<div class="floatL w490">
			<div class="tit_wrap small">
				<h3 class="tit_ico_graph3">A/S 분석(전월기준, <span id="asRightTitle">총 거래처</span>)</h3>
			</div>
			<div class="db-greybox pd10">
				<ul class="list2">
					<li class="textL pdl30">
						<p class="small mgb5">평균 A/S건</p>
						<p><span id="setValue1"></span></p>
					</li>
					<li class="textL pdl30">
						<p class="small mgb5">평균 A/S비용</p>
						<p><span id="setValue3"></span></p>
					</li>
				</ul>
			</div>
			<div class="db_borderbox h285">
				<table class="hType">
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
	</div>
</div>
<!-- SMS Tab -->
<div id="Thirddiv2" style="display:none;">
	<div class="tit_wrap small">
		<h3 class="tit_ico_notice">계약현황</h3>
	</div>
	<!-- <ul class="list5 db-list mgb20" style="width:calc(100% + 8px)">
		<li class="pdr8">
			<div class="db-greybox colorBlack">
				총 계약<span class="num_db pdl8" id="sms_top1" onclick="javascript:goSmsCustList('c1');" style="cursor:pointer;">0</span>
			</div>
		</li>
		<li class="pdr8">active
			<div class="db-greybox">
				S-50<span class="num_db pdl8" id="sms_top2" onclick="javascript:goSmsCustList('c2');" style="cursor:pointer;">0</span>
			</div>
		</li>
		<li class="pdr8">
			<div class="db-greybox">
				S-100<span class="num_db pdl8" id="sms_top3" onclick="javascript:goSmsCustList('c3');" style="cursor:pointer;">0</span>
			</div>
		</li>
		<li class="pdr8">
			<div class="db-greybox">
				L-80<span class="num_db pdl8" id="sms_top4" onclick="javascript:goSmsCustList('c4');" style="cursor:pointer;">0</span>
			</div>
		</li>
		<li class="pdr8">
			<div class="db-greybox">
				L-150<span class="num_db pdl8" id="sms_top5" onclick="javascript:goSmsCustList('c5');" style="cursor:pointer;">0</span>
			</div>
		</li>
	</ul> -->
	
	
	<ul class="list5 db-list mgb20" style="width:calc(100% + 8px)">
		<li class="pdr8">
			<div class="db-greybox cpd">
				<div class="cnumber-box1">
					총 계약<span class="num_db pdl8 clh colorBlue" id="sms_top1" onclick="javascript:goSmsCustList('c1');" style="cursor:pointer;">0</span>
				</div>
				<div class="cnumber-box2">
					<span class="num_db pdl8 clh colorBlue" id="sms_mid1" onclick="javascript:goSmsCustList('f1');" style="cursor:pointer;">0</span>
					<p class="small pdl8 cmb">계약만료</p>
				</div>
			</div>
		</li>
		
		<li class="pdr8">
			<div class="db-greybox cpd">
				<div class="cnumber-box1">
					S-50<span class="num_db pdl8 clh" id="sms_top2" onclick="javascript:goSmsCustList('c2');" style="cursor:pointer;">0</span>
				</div>
				<div class="cnumber-box2" style="height:60px">
					<span class="num_db pdl8 clh" id="sms_mid2" onclick="javascript:goSmsCustList('f2');" style="cursor:pointer;">30</span>
					<p class="small pdl8 cmb">만료</p>
				</div>
			</div>
		</li>
		
		<li class="pdr8">
			<div class="db-greybox cpd">
				<div class="cnumber-box1">
					S-100<span class="num_db pdl8 clh" id="sms_top3" onclick="javascript:goSmsCustList('c3');" style="cursor:pointer;">0</span>
				</div>
				<div class="cnumber-box2" >
					<span class="num_db pdl8 clh" id="sms_mid3" onclick="javascript:goSmsCustList('f3');" style="cursor:pointer;">30</span>
					<p class="small pdl8 cmb">만료</p>
				</div>
			</div>
		</li>
		
		
		<li class="pdr8">
			<div class="db-greybox cpd">
				<div class="cnumber-box1">
					L-80<span class="num_db pdl8 clh" id="sms_top4" onclick="javascript:goSmsCustList('c4');" style="cursor:pointer;">0</span>
				</div>
				<div class="cnumber-box2">
					<span class="num_db pdl8 clh" id="sms_mid4" onclick="javascript:goSmsCustList('f4');" style="cursor:pointer;">30</span>
					<p class="small pdl8 cmb">만료</p>
				</div>
			</div>
		</li>
		
		<li class="pdr8">
			<div class="db-greybox cpd">
				<div class="cnumber-box1">
					L-150<span class="num_db pdl8 clh" id="sms_top5" onclick="javascript:goSmsCustList('c5');" style="cursor:pointer;">0</span>
				</div>
				<div class="cnumber-box2">
					<span class="num_db pdl8 clh" id="sms_mid5" onclick="javascript:goSmsCustList('f5');" style="cursor:pointer;">30</span>
					<p class="small pdl8 cmb">만료</p>
				</div>
			</div>
		</li>
	</ul>
	
	<div class="floatWrap">
		<div class="floatL w490 mgr20">
			<div class="tit_wrap small">
				<h3 class="tit_ico_notice">수금현황</h3>
				<span class="colorRed tit_depth mgl20 mgt8">(전월 기준 연체 거래처 : <span id="firstTab1SmsLeftListCnt">0</span>)</span>
				
			</div>
			<div class="db_borderbox h340">
				<table class="hType">
					<thead>
						<tr>
							<th scope="col">순위</th>
							<th scope="col">거래처명</th>
							<th scope="col">Type</th>
							<th scope="col">연체금액(원)</th>
<!-- 							<th scope="col">거래처 등급</th> -->
						</tr>
					</thead>
					<tbody id="smsLeftList"></tbody>
				</table>
			</div>
		</div>
		<div class="floatL w490">
			<div class="tit_wrap small">
				<h3 class="tit_ico_graph">최근 6개월간 총 거래처</h3>
				<!-- <a href="" class="btn_ico_search_g floatR mgt10"><span>검색</span></a> -->
			</div>
			<div class="db_borderbox h340" style="overflow:hidden;" id="char1">
				
			</div>
		</div>
	</div>
</div>


<div id="Thirddiv3" style="display:none;">
	<!-- <div class="tit_wrap small">
		<h3 class="tit_ico_notice">계약현황</h3>
	</div>
	
	<ul class="pro_arrow light mgb5">
		<li class="w100 current" style="display:none;">무상</li>
		<li class="w380" style="display:none;">유상전환</li>
		<li class="w160 current">유상</li>
		<li class="w840">계약갱신(자동갱신대상 제외)</li>
	</ul>
	
	<div class="floatWrap mgb20">
		<div class="db-greybox blue w160 mgr5 floatL">
			<p>유상</p><ul><li class="num_db" id="s_b1" onclick="javascript:goHisCustList('b1');" style="cursor:pointer;">0</li></ul>
		</div>
		<div class="db-greybox blue w415 mgr-1 floatL">
			<p>갱신대상(자동갱신 제외)</p>
			<ul class="list3">
				<li class="num_db" onclick="javascript:goHisCustList('b2');" style="cursor:pointer;"><span id="s_b2">0</span><p class="small">(2개월미만)</p></li>
				<li class="num_db" onclick="javascript:goHisCustList('b3');" style="cursor:pointer;"><span id="s_b3">0</span><p class="small">(1개월미만)</p></li>
				<li class="num_db" onclick="javascript:goHisCustList('b4');" style="cursor:pointer;"><span id="s_b4">0</span><p class="small">(갱신지연)</p></li>
			</ul>
		</div>
		<div class="db-greybox blue w417 floatL">
			<p class="colorRed">갱신대상(자동갱신, 2개월↓)</p>
			<ul class="list3">
				<li class="num_db" onclick="javascript:goHisCustList('b5');" style="cursor:pointer;"><span id="s_b5">0</span><p class="small">(3년차)</p></li>
				<li class="num_db" onclick="javascript:goHisCustList('b6');" style="cursor:pointer;"><span id="s_b6">0</span><p class="small">(5년차)</p></li>
				<li class="num_db" onclick="javascript:goHisCustList('b7');" style="cursor:pointer;"><span id="s_b7">0</span><p class="small">(5년 이상)</p></li>
			</ul>
		</div>
	</div>
	 -->
	<div class="floatWrap">
		<div class="floatL w490 mgr20">
			<div class="tit_wrap small">
				<h3 class="tit_ico_notice">수금현황</h3>
				<!--<span class="colorRed tit_depth mgl20 mgt8">( <span id="setTab1SolutionLeftTitle"> </span> )</span>
				 <span class="floatR">
				<select onchange="drawTab1LeftList(this.value)" id="tab1LeftSelect">
					<option value="10">TOP 10</option>
					<option value="30">TOP 30</option>
					<option value="total">전체보기</option>
				</select>
				</span> -->
			</div>
			<div class="db_borderbox h340">
				<table class="hType">
					<caption>수금현황</caption>
					<colgroup>
						<col style="width:40px;" />
						<col style="width:60px;" />
						<col style="width:130px;" />
						<col style="width:90px;" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col">순위</th>
							<th scope="col">CRM Code</th>
							<th scope="col">거래처명</th>
							<th scope="col">연체금액(원)</th>
						</tr>
					</thead>
					<tbody id="setTab1SolutionLeftData"></tbody>
				</table>
			</div>
		</div>
		<div class="floatL w490">
			<div class="tit_wrap small">
				<h3 class="tit_ico_graph3">매출<!-- (월별, <span id="asRightTitle">제품별</span>) --></h3>
				<span class="floatR">
					<!-- <select style="width:30%;" onchange="getTab1SolutionRight(this.value)" id="item_code">
						
					</select> -->
				</span>
			</div>
			
			<div class="db_borderbox h340">
				<table class="hType">
					<colgroup>
						<col style="width:60px">
						<col style="width:100px">
						<col style="width:110px">
						<col style="width:80px">
					</colgroup>
					<thead>
						<tr>
							<th scope="col">CRM Code</th>
							<th scope="col">거래처명</th>
							<th scope="col">매출액(+VAT)</th>
							<th scope="col">매출일</th>
						</tr>
					</thead>
					<tbody id="setTab1SolutionRightData"></tbody>
				</table>
			</div>
		</div>
	</div>
</div>

<!-- 거래처리스트 레이어팝업 -->
<div id="custListLayer" style="display:none;">
	<div class="box_layer layer_sms" style="height:700px;margin-top:-400px;">
		<h1>거래처목록</h1>
		<div class="layer_contents" style="padding-top:20px;height:600px;overflow-y:auto;">
			<table class="hType mgb20">
				<caption>총 수금정보</caption>
				<colgroup>
					<col style="width:auto;" />
				</colgroup>
				<tr>
					<th>CRM CODE</th>
					<th>거래처구분</th>
					<th>재단구분</th>
					<th>전문병원유형</th>
					<th>거래처명</th>
					<th>거래상태</th>
					<th>생성일</th>
				</tr>
				<tbody id="custListBody">
				</tbody>
			</table>
		</div>
		<button type="button" class="btn_close" onclick="$('#custListLayer').hide()">창 닫기</button>
	</div>
	<div class="layer_dimmed"></div>
</div>

<!-- AS분석 레이어팝업 -->
<div id="asListLayer" style="display:none;">
	<div class="box_layer layer_sms" style="height:700px;margin-top:-400px;">
		<h1>A/S 분석 (<span id="asListLayerTitle" style="vertical-align:unset"></span>)</h1>
		<div class="layer_contents" style="padding-top:20px;height:600px;overflow-y:auto;">
		<span class="floatL">총 <span id="asListLayerCnt">0</span>개의 데이터가 있습니다.</span>
		<span class="floatR">*<span id="asListLayerYYMM">----년 --월</span> A/S기준</span>
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
				<tbody id="asListLayerBody">
				</tbody>
			</table>
		</div>
		<button type="button" class="btn_close" onclick="$('#asListLayer').hide()">창 닫기</button>
	</div>
	<div class="layer_dimmed"></div>
</div>
