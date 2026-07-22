<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="egovframework.com.comm.util.DateTimeUtil"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="egovframework.com.comm.util.DateTimeUtil"%>
<jsp:include page="/WEB-INF/jsp/fr/common/chatbot.jsp" />

	<link rel="stylesheet" type="text/css" href="/css/front/jw_front.css" />
	<link rel="stylesheet" type="text/css" href="/css/jquery-ui.css" />

<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>


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
   .background-cell {
    background-image: url('/images/ico_new.png');
    background-repeat: no-repeat; /* 이미지 반복 없음 */
    background-position: center; /* 이미지를 가운데 정렬 */
}
	.hType thead th {
    position: sticky;
    top: 0; /* 헤더가 스크롤되지 않도록 설정 */
}
   
   /*
   .draggable {
    width: 50px;
    height: 50px;
    font-size: 40px;
    cursor: grab;
    position: absolute; 유동적인 위치 설정 
    right: 100px;  초기 위치 (예시)
    top: 100px;초기 위치 (예시) 
}


.draggable:active {
    cursor: grabbing;
}
 */
@keyframes blink {
            0% { opacity: 1; }
            50% { opacity: 0; }
            100% { opacity: 1; }
        }

        .blinking {
            animation: blink 1s infinite;
        }
       
   
</style>



<script type="text/javascript">

	var chatbotWindow = null;

	var myAsList;
	var crmAsList;

	google.charts.load('current', {'packages':['line']});

	var recentNoticeList;
	var notReadNoticeList;
	var recentFaqList;
	var manyReadFaqList;
	/* var asGraphList; */
	
	var bestFaqList;

	$(document).ready(
		function() {
			
			var x = location.pathname;
			
			if(x == '/fr/main/list.do' && common.nvl(getCookie("CHATBOTAI_FLAG2"), '' ) == ''){
				   $('#CHATBOT_AI_DIV2').show() ;
				}
			
			 // cust_code 가져오기
		    var custCode = $("#cust_code").val();
		     // cust_kor_name 가져오기
		    var custKorname = $("#cust_kor_name").val();

		    // iframe src 세팅
		    if (custCode) {
		        $("#chatbotFrame").attr("src", "https://ai.cwit.co.kr/popup_v2/fragment");
		    }
		    
			var searchStart = "${ vo.str_dt }";
			
			$("#search_start" ).val(searchStart).datepicker(datepicker);
			$("#search_end" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
			$("#search_start2" ).val(searchStart).datepicker(datepicker);
			$("#search_end2" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
			
			$("#search_start3" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
			$("#search_end3" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
			
			
			$('.ui-datepicker-trigger').css('cursor','pointer');
			
			// 드래그 앤 드롭 기능 추가
	        /* const icon = document.getElementById('chatbot');
	        
	        icon.addEventListener('mousedown', (e) => {
	            let shiftX = e.clientX - icon.getBoundingClientRect().left;
	            let shiftY = e.clientY - icon.getBoundingClientRect().top;

	            function moveAt(pageX, pageY) {
	                icon.style.left = pageX - shiftX + 'px';
	                icon.style.top = pageY - shiftY + 'px';
	            }

	            function onMouseMove(event) {
	                moveAt(event.pageX, event.pageY);
	            }

	            document.addEventListener('mousemove', onMouseMove);

	            icon.addEventListener('mouseup', () => {
	                document.removeEventListener('mousemove', onMouseMove);
	                icon.onmouseup = null;
	            });
	        });

	        icon.ondragstart = () => {
	            return false;
	        }; */
		
			common.ajaxCall('', '/fr/notice/getRecentList.do','setRecentNoticeList');
			common.ajaxCall('', '/fr/notice/getNotReadList.do','setNotReadNoticeList');
			changeNoticeData("noticeTab1");
			
			common.ajaxCall('', '/fr/faq/getRecentList.do','setRecentFaqList');
			common.ajaxCall('', '/fr/faq/getManyReadList.do','setManyReadFaqList');
			changeFaqData("faqTab2");
	
			setMyAsList( $("#search_start" ).val(), $("#search_end" ).val() ); //2024.04.26 나의 A/S현황 리스트 추가
			setCrmAsList( $("#search_start2" ).val(), $("#search_end2" ).val() ); //2024.04.26 병원전체 A/S현황 리스트 추가
			
			
			
			//(2024.05.31 김규민)오늘의 AS답변 다시 복구 작업..
			//setMyAsStatus( $("#search_start3" ).val(), $("#search_end3" ).val() );
			//setCrmAsStatus( $("#search_start" ).val(), $("#search_end3" ).val() );
			
			//2024.05.31 김규민)메인화면 내 그래프 제거
			/*
			common.ajaxCall('', '/fr/main/getAsGraph.do','setAsGraph'); */
			
			getAsCustList('TOTAL','my'); 
			
			setBestFaqList();

			
			changeSearch1();
			changeSearch2();
 			changeSearch3(); 
			
			
 			
			var datas = {'cust_code' : $('#cust_code').val() }
			common.ajaxCall(datas, '/fr/main/getTodayAnswerCnt.do','setAsAnswerTodayCnt');
			common.ajaxCall(datas, '/fr/main/getTodayAnswer.do','setAsAnswerTodayList'); 
			
 			getAnswerListbyRecent(); 
 			
 			$("#search_text").keyup(function(e){if(e.keyCode == 13)  getSearchList(); });
 			
		});
	
		
	function getAnswerListbyRecent(){
		
		var datas ={
				'asw_str_dt' :  $("#search_start3" ).val(),
				'asw_end_dt' :  $("#search_end3" ).val(),
				'answerGubunFlag' : $("input[type=radio][name=type1]:checked").val(),
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
				str += '<td colspan="2" style="font-size: 14px;color:#797979;font-weight: 600;">'+ val.W_DATE +'</td>';
				str += '<td colspan="2" class="textR mgb5" style="font-size: 14px;color: #0090c8;font-weight: 700;">AS접수번호 ' + val.AS_NO +'</td>';
				str += '</tr>';
				str += '<tr>';
				str += '<td colspan="4" style="padding-bottom:5px;padding-top: 5px; border-bottom: 1px solid #dedede !important;">';
				str += '[요청] ' + val.CALL_CONTENT + ' -' +val.APPLY_NM + '</td>';
				str += '</tr>';
				str += '<tr>';
				str += '<td colspan="4" style="padding-bottom:5px;padding-top: 5px;">[답변] ' + val.W_CONTENT + ' -' + val.W_NM +'</td>';
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
			str += '<li class="blinking" style="line-height:34px;" onclick="goAsDetail(\''+ result[i].AS_NO +'\')" >';
			str += '<img src="/images/front/icon_chat_02.png" class="valignM mgr5">';
			str += '<span class="an_apply_nm"> ['+result[i].APPLY_NM+' 님의 AS건]</span>';
			str += '<a href="javascript:goAsAnswerView();" class="an-title">' + content + '.. </a>';
			
			if( result[i].ATTACH_SEQ != '0' ){
				str += '<button type="button" class="btn_download_blue"><span>다운로드</span></button>';
			}
			str += '<span class="an-date">'+result[i].W_DATE +'</span>';
			str += '<span class="an-author">&nbsp; -'+ result[i].W_NM +'</span>';
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
	
	
	function changeSearch1(){			//2024.04.26 나의 A/S현황 리스트 조회 기간 변경
		$("#search_start" ).change(function() {
			setMyAsList( $("#search_start" ).val(),$("#search_end" ).val() );
		});
		$("#search_end" ).change(function() {
			setMyAsList($("#search_start" ).val(),$("#search_end" ).val() );
		});
	}
	
	
	function changeSearch2(){			//2024.04.29 병원전체 A/S현황 조회 기간 변경
		$("#search_start2" ).change(function() {
			setCrmAsList( $("#search_start2" ).val(),$("#search_end2" ).val() );  
		});
		$("#search_end2" ).change(function() {
			setCrmAsList( $("#search_start2" ).val(),$("#search_end2" ).val() );  
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
				'str_dt' : str,
				'end_dt' : end
		};
		common.ajaxCall(datas, '/fr/main/getCrmAsStatus.do','drawCrmAs');
	}

	function drawCrmAs(data) {
		if (data.result == "undefined")	return;
		
		crmAsList = data.result;
		var total=0,proc1=0,proc2=0,proc3=0;
		
		for (var i=0; i < crmAsList.length; i++){
			proc1 += Number(crmAsList[i].PROC1);
			proc2 += Number(crmAsList[i].PROC2);
			proc3 += Number(crmAsList[i].PROC3);
		}
		
		total = proc1 + proc2 + proc3;
		
		$("#crmTotal").html(total);
		$("#crmProc1").html(proc1);
		$("#crmProc2").html(proc2);
		$("#crmProc3").html(proc3);
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
		
		var total=0,proc1=0,proc2=0,proc3=0;
		
		for (var i=0; i < myAsList.length; i++){
			proc1 += Number(myAsList[i].PROC1);
			proc2 += Number(myAsList[i].PROC2);
			proc3 += Number(myAsList[i].PROC3);
		}
		
		total = proc1 + proc2 + proc3;

		$("#myTotal").html(total);
		$("#myProc1").html(proc1);
		$("#myProc2").html(proc2);
		$("#myProc3").html(proc3);
	}

	function setRecentNoticeList(data) {
		recentNoticeList = data.resultList != "undefined" ? data.resultList : null;
	}

	function setNotReadNoticeList(data) {
		notReadNoticeList = data.resultList != "undefined" ? data.resultList : null;
	}
	
	//2024.04.19 (병원용 라인어스 리뉴얼) 상담사례-최근 업로드된 사례
	function setRecentFaqList(data) {
		recentFaqList = data.resultList != "undefined" ? data.resultList : null;
	}
	
	//2024.04.19 (병원용 라인어스 리뉴얼) 상담사례-조회수가 많은 사례
	function setManyReadFaqList(data) {
		manyReadFaqList = data.resultList != "undefined" ? data.resultList : null;
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
			
			var new_icon = '';
			
			if (common.nvl(list[i].latest_post, '') == 'Y') {
				new_icon = '<span class="new"></span>';	
			}

			str += "<tr onclick=\"listDetail('update', '" + list[i].seq + "','"
					+ list[i].rnum + "');\" style=\"cursor:pointer;\">";
			
			if (common.nvl(list[i].imp_yn, '') == 'Y') {
				str += "	<td>" + "<span style=\"color: red;\">" + list[i].notice_num + "</span></td>";
			} else {
				str += "	<td>" + list[i].notice_num + "</td>";
			}
			
			str += "	<td>";
			if (common.nvl(list[i].attach_seq, '') != 0) {
				str += '<button type="button" class="btn_download_blue" style="min-width:30px"><span>다운로드</span></button>';
			} else {
				str += '';
			}
			str += "	</td>";
			
			// 제목
			
			if (common.nvl(list[i].imp_yn, '') == 'Y') {
			    
			    var highlightWords = list[i].highlight_words ? list[i].highlight_words.split('#').filter(Boolean) : [];

			    
			    var title = common.nvl(list[i].title, '-');
			    
			   
			    highlightWords.forEach(function(word) {
			        
			        var regex = new RegExp("(" + word + ")", "gi");
			        title = title.replace(regex, "<span style='font-weight: 900;line-height: 1.2;display: inline; vertical-align: baseline;'>$1</span>");
			    });

			   
			    str += "	<td class='textL' style='padding-left: 0;'>" + "<span style=\"color: red;\">" + new_icon + "[중요]" + title + "</span></td>";
			} else {
			   
			    var highlightWords = list[i].highlight_words ? list[i].highlight_words.split('#').filter(Boolean) : [];

			   
			    var title = common.nvl(list[i].title, '-');
			    
			    
			    highlightWords.forEach(function(word) {
			        var regex = new RegExp("(" + word + ")", "gi");
			        title = title.replace(regex, "<span style='font-weight: 900;line-height: 1.2;display: inline; vertical-align: baseline;'>$1</span>");
			    });

			    
			    str += "	<td class='textL' style='padding-left: 0;'>" + new_icon + title + "</td>";
			}
			
			if (common.nvl(list[i].imp_yn, '') == 'Y') {
				str += "	<td>" + "<span style=\"color: red;\">" + list[i].reg_date + "</span></td>";
			} else {
				str += "	<td>" + list[i].reg_date + "</td>";
			}
			str += "</tr>";
		}

		$("#noticeListBody").html(str);
	}

	function listDetail(pageType, seq, num) {
		var f = document.listFrm;
		f.pageType.value = pageType;
		f.seq.value = seq;
		f.board_gbn.value = '0000';
		f.listNum.value = num;
		f.method = 'post';
		f.action = '/fr/notice/form.do';
		f.submit();
	}
	
	//2024.04.19 (병원용 라인어스 리뉴얼) 상담사례 변경탭
	function changeFaqData(id) {
		$("#faqTab1").removeClass("active");
		$("#faqTab2").removeClass("active");
		$("#" + id).addClass("active");

		if (id == "faqTab1" && recentFaqList != null) {

			reDrawFaqListBody(recentFaqList);

		} else if (id == "faqTab2" && manyReadFaqList != null) {

			reDrawFaqListBody(manyReadFaqList);
		}
	}

	function reDrawFaqListBody(list) {
		var str = "";
		

		for (var i = 0; i < list.length; i++) {
			
			var new_icon = '';
			
			if (common.nvl(list[i].latest_post, '') == 'Y') {
				new_icon = '<span class="new"></span>';	
			}

			str += "<tr onclick=\"FaqlistDetail('update', '" + list[i].seq + "','"
					+ list[i].rnum + "');\" style=\"cursor:pointer;\">";
			
			if (common.nvl(list[i].best_faq, '') == 'Y') {
				str += "	<td>" + "<span style=\"color: red;\">" + list[i].seq + "</span></td>" ;
			} else {
				str += "	<td>" + list[i].seq + "</td>" ;
			}
			
			str += "	<td>";
			if (common.nvl(list[i].attach_seq, '') != 0) {
				str += '<button type="button" class="btn_download_blue" style="min-width:30px"><span>다운로드</span></button>';
			} else {
				str += '';
			}
			str += "	</td>";
			
			if (common.nvl(list[i].best_faq, '') == 'Y') {
				str += "	<td class=\"textL\" style=\"padding-left : 0px\">" + "<span style=\"color: red;\">" + new_icon + "[이번주 BEST 문의]" + list[i].title + "</span></td>" ;
			} else {
				str += "	<td class=\"textL\" style=\"padding-left : 0px\">" + new_icon + list[i].title + "</td>" ;
			}
			
			if (common.nvl(list[i].best_faq, '') == 'Y') {
				str += "	<td>" + "<span style=\"color: red;\">" + list[i].reg_date + "</span></td>" ;
			} else {
				str += "	<td>" + list[i].reg_date + "</td>" ;
			}
			
			str += "</tr>";
		}

		$("#faqListBody").html(str);
	}

	function FaqlistDetail(pageType, seq, num) {
		var f = document.listFrm;
		f.pageType.value = pageType;
		f.seq.value = seq;
		f.board_gbn.value = '0001';
		f.listNum.value = num;
		f.method = 'post';
		f.action = '/fr/faq/form.do';
		f.submit();
	}
	
	function goAsDetail(asno){
		console.log(asno);
		var queryString = "?as_no=" + asno;
		location.href = "/fr/as/list.do" + queryString;
	}
	
	function setMyAsList(str, end) {
			
			var datas = {
					'str_dt' : str,
					'end_dt' : end
			};
			common.ajaxCall(datas, '/fr/main/getMyAsList.do', 'drawMyAsList');
		}
		
	function drawMyAsList(data){
		
		$('#MyAsListBody').empty() ;
		
		var asList = typeof data.resultList != "undefined" ? data.resultList : null ;
		
		if (asList == null) return;
		
		var htmlStr = "";
		
		for (var i=0; i < asList.length; i++){
			
			var completeDate = asList[i].COMPLETE_DT ? asList[i].COMPLETE_DT : "-";
			
			
			htmlStr += '<tr style="cursor:pointer" onclick="goAsDetail(\''+ asList[i].AS_NO +'\')">';
			htmlStr += '	<td>' + asList[i].AS_NO + '</td>';
			htmlStr += '	<td>' + asList[i].PROC_STATUS_NM + '</td>';
			htmlStr += '	<td>' + asList[i].REQUEST_TYPE_NM + '</td>';
			htmlStr += '    <td style="text-align: left; white-space: normal; overflow: hidden;">' + asList[i].CALL_CONTENT + '</td>';
			htmlStr += '	<td>' + asList[i].EMP_NM + '</td>';
			htmlStr += '</tr>';
		}
	
		$('#MyAsListBody').append(htmlStr);
		
	}
	
	function setCrmAsList(str, end) {
		
		var datas = {
				'str_dt' : str,
				'end_dt' : end
		};
		common.ajaxCall(datas, '/fr/main/getCrmAsList.do', 'drawCrmAsList');
	}
	
	function drawCrmAsList(data){
	
	$('#CrmAsListBody').empty() ;
	
	var asList = typeof data.resultList != "undefined" ? data.resultList : null ;
	
	if (asList == null) return;
	
	var htmlStr = "";
	
	for (var i=0; i < asList.length; i++){
		
		var completeDate = asList[i].COMPLETE_DT ? asList[i].COMPLETE_DT : "-";
		
		
		htmlStr += '<tr style="cursor:pointer" onclick="goAsDetail(\''+ asList[i].AS_NO +'\')">';
		htmlStr += '	<td>' + asList[i].AS_NO + '</td>';
		htmlStr += '	<td>' + asList[i].PROC_STATUS_NM + '</td>';
		htmlStr += '	<td>' + asList[i].REQUEST_TYPE_NM + '</td>';
		htmlStr += '    <td style="text-align: left; white-space: normal; overflow: hidden;">' + asList[i].CALL_CONTENT + '</td>';
		htmlStr += '	<td>' + asList[i].EMP_NM + '</td>';
		htmlStr += '</tr>';
	}
	
	$('#CrmAsListBody').append(htmlStr);
	
	}
	
// 2024.04.26 필요없어짐에 따라 주석처리
	function getAsCustList(flag, type, str, end){

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
		
		var datas = {'asno' : seqStr.substring(1),
					 'str_dt' : str,
					 'end_dt' : end
		} ;
		common.ajaxCall(datas, '/fr/main/getFrAsList.do', 'showAsListLayer') ;

		$("#asListLayer").show();
	} 
	
 	function showAsListLayer(data){
		var asList = typeof data.resultList != "undefined" ? data.resultList : null ;
		
		if (asList == null) return;
		
		
		var htmlStr = "";
		for (var i=0; i < asList.length; i++){
			htmlStr += '<tr style="cursor:pointer" onclick="goAsDetail(\''+ asList[i].AS_NO +'\')">';
			htmlStr += '	<td>' + asList[i].PROC_STATUS_NM + '</td>';
			htmlStr += '	<td>' + asList[i].COMPLETE_DT + '</td>';
			htmlStr += '	<td>' + asList[i].SERVICE_CATE_NM+'/'+asList[i].INQUIRY_TYPE_NM + '</td>';
			htmlStr += '	<td>' + asList[i].CALL_content + '</td>';
			htmlStr += '	<td>' + asList[i].EMP_NM + '</td>';
			htmlStr += '</tr>';
		}
		
		$("#asListBody").html(htmlStr);
		
		//$('#asListBody').append(htmlStr);
		$("#asListLayer").show();
		$('#div_dim').show() ;
		
	}
	
	function showAnswerLayer(){
		//initAnswerListbyRecent();
		$("#answerLayer").show();
		$('#div_dim').show() ;
	}
	
	function closeAnswerLayer(){
		//initAnswerListbyRecent();
	}
	
	function getSearchList(){
		var f = document.listFrm;
		if (common.isEmpty($('#search_text').val())) {
			alert('검색어를 입력하세요.');
			$('#search_text').focus(); 
			return;
		}	
			f.method = 'post';
			f.action = '/fr/main/search.do';
			f.submit();
	}
	
	function closeShowBestFaq(){
		$('#BEST_FAQ_DIV').hide() ;
	}
	
	function setBestFaqList() {
		common.ajaxCall('', '/fr/main/getBestFaqList.do', 'drawBestFaqList');
	}
	
	function drawBestFaqList(data) {
		var dataList = typeof data.resultList != "undefined" ? data.resultList : null ;
		
		if (dataList == null){
			$('#BEST_FAQ_DIV').hide() ;
			return;
		}
		
		var str = "";
		

		for (var i = 0; i < dataList.length; i++) {
			
			var new_icon = '';
			if (common.nvl(dataList[i].latest_post, '') == 'Y') {
 				new_icon = '<span class="new"></span>';	
			}
			str += "<tr onclick=\"FaqlistDetail('update', '" + dataList[i].seq + "','"
					+ dataList[i].rnum + "');\" style=\"cursor:pointer;\">";
			str += "	<td>•</td>";
			str += "	<td>" + dataList[i].seq + "</td>";
			/* str += "	<td>" + dataList[i].title + "</td>"; */
			str += "	<td class=\"textL\" style=\"padding-left : 0px\">" + new_icon + dataList[i].title + "</td>";
			str += "	<td>" + dataList[i].reg_date + "</td>";
			str += "</tr>";
		}

		$("#BestfaqListBody").append(str);
	}
	
	function closeShowChatbotAI(){
		$('#CHATBOT_AI_DIV2').hide() ;
	}
	
	function openChatbotpopupWindow() {
	    // 창이 이미 열려 있다면 해당 창에 포커스
	    if (chatbotWindow && !chatbotWindow.closed) {
	        chatbotWindow.focus();
	    } else {
	        // 새 창 열기
	        chatbotWindow = window.open(
	            'https://ai.cwit.co.kr/popup/', // 열 URL
	            'chatbotpopupWindow', // 창 이름
	            'width=420,height=600,top=4000,left=4000' // 창 크기 및 위치 지정
	        );
	    }
	}
	
	
	function closeShowContinueChatbotAI() {
		setCookie('CHATBOTAI_FLAG2','1',1);
		$('#CHATBOT_AI_DIV2').hide() ; 
	}

	
	
	
	
</script>

<form id="listFrm" name="listFrm" method="post" onsubmit="return false" enctype="multipart/form-data">
<input type="hidden" name="board_gbn" id="board_gbn" />
<input type="hidden" name="pageType" id="pageType" />
<input type="hidden" name="page" id="page" value="1" />
<input type="hidden" name="seq" id="seq" />
<input type="hidden" name="listNum" id="listNum" />
<input type="hidden" name="user_id" id="user_id" value=${ frUserInfo.emp_id } />
<input type="hidden" name="cust_code" id="cust_code" value=${ frUserInfo.cust_code } />
<input type="hidden" name="cust_kor_name" id="cust_kor_name" value=${ frUserInfo.cust_kor_name } />

	 <div id="alarm" style="background: rgb(236, 248, 252); border-width: 0px 1px 1px; border-right-style: solid; border-bottom-style: solid; border-left-style: solid; border-right-color: rgb(219, 219, 219); border-bottom-color: rgb(219, 219, 219); border-left-color: rgb(219, 219, 219); border-image: initial; border-top-style: initial; border-top-color: initial;">
		<div class="tit_sWrap" style="width: 1000px; margin: 0 auto;">
			<div class="col-15">
				<p style="line-height: 34px;"> 오늘의 AS답변 : <a href="javascript:showAnswerLayer();" type="button"  style="color: #ff3000; font-weight: 700;"id="answerCnt"></a></p>
			</div>
			<div class="col-70" style="position: relative;" id="db_notiUL">
				<ul id="notiUL" style="position: absolute; left: 0px; top: 0px;" ></ul>
			</div>
			<div class="col-20">
				<a href="javascript:showAnswerLayer();" type="button" class="mgl20 search_btn">
				<img src="/images/front/icon_chat_s.png" class="valignM mgr5">AS답변 검색 &nbsp >></a>
			</div>
		</div>
	</div> 
	
	<div id="jw_contents">
	<div class="download_upper">
		<strong>검색을 이용하시면 보다 빠르게 원하시는 정보를 얻으실 수 있습니다.</strong>
		<div class="box_keyword">
			<input type="text" id="search_text" name="search_text" title="검색어입력" placeholder="제목과 내용이 모두 조회됩니다. 다소 시간이 소요될 수 있습니다."  />
			<button type="button" onclick="getSearchList();"><span>검색</span></button>
		</div>
	</div>
	<div class="floatWrap">
		<div class="col-50 mgb30">
			<div class="floatL w490 mgr20">
				<div class="tit_wrap w490">
					<h2 class="tit_ico_as">나의A/S현황</h2>
					<!-- <div class="search_radio">
						<input type="radio" name="period1" value="week" onclick="setMyAsStatus(this.value)" checked="checked"/> 최근 일주일<span class="mgr5"></span>
						<input type="radio" name="period1" value="month" onclick="setMyAsStatus(this.value)"/> 최근 한달<span class="mgr5"></span>
					</div> -->
					<div class="floatR mgt10">
					<input type="text" name="search_start" id="search_start" class="w90 mgl5 mgr5" readonly=readonly>
					~
					<input type="text" class="w90 mgl5 mgr5" name="search_end" id="search_end" readonly=readonly>
					</div>
				</div>
					<table class="hType" style="display:block;overflow-y:scroll;height:330px;table-layout: fixed;">
					<caption>나의 A/S현황</caption>
						<colgroup>
							<col style="width:70px" /><!-- 접수번호 -->
							<col style="width:70px" /><!-- 처리상태 -->
							<col style="width:80px" /><!-- 문의유형 -->
							<col style="width:190px" /><!-- 요청내용 -->
							<col style="width:70px" /><!-- 처리담당자 -->
						</colgroup>
						<thead>
							<tr>
								<th>접수번호</th>
								<th>처리상태</th>
								<th>문의유형</th>
								<th>요청내용</th>
								<th>처리담당자</th>
							</tr>
						</thead>
						<tbody id="MyAsListBody">
						</tbody>
					</table>
			</div>
		</div>
		<div class="col-50 mgb30">
			<div class="floatL w490 mgr20">
				<div class="tit_wrap w490">
					<h2 class="tit_ico_as">병원전체A/S현황</h2>
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
				<table class="hType" style="display:block;overflow-y:scroll;height:330px;table-layout: fixed;">
					<caption>병원전체 A/S현황</caption>
						<colgroup>
							<col style="width:70px" /><!-- 접수번호 -->
							<col style="width:70px" /><!-- 처리상태 -->
							<col style="width:80px" /><!-- 문의유형 -->
							<col style="width:190px" /><!-- 요청내용 -->
							<col style="width:70px" /><!-- 처리담당자 -->
						</colgroup>
						<thead>
							<tr>
								<th>접수번호</th>
								<th>처리상태</th>
								<th>문의유형</th>
								<th>요청내용</th>
								<th>처리담당자</th>
							</tr>
						</thead>
						<tbody id="CrmAsListBody">
						</tbody>
					</table>
			</div>
		</div>
		
		
		<!--공지탭영역-->
		<div class="col-50 mgb30">
			<div class="tit_wrap w490">
				<h2 class="tit_ico_notice2">공지사항</h2>
			</div>

			<ul class="tab_line big list3 mgr20" >
				<li id="noticeTab1" class="active" style="width:50% !important;">
					<a href="javascript:changeNoticeData('noticeTab1')">최근공지</a>
				</li>
				<li id="noticeTab2" style="width:50% !important;">
					<a href="javascript:changeNoticeData('noticeTab2')">읽지않은공지</a>
				</li>
				
				<table class="hType" style="display:block;overflow-y:auto;height:330px">
					<caption>대시보드-공지사항</caption>
					<colgroup>
						<col style="width:50px">
						<col style="width:30px">
						<col style="width:70%">
						<col style="width:100px">
					</colgroup>
					<tbody id="noticeListBody">
					</tbody>
				</table>
			</ul>
			
		</div>

		<!--상담사례-->
		<div class="col-50 mgb30">
				<div class="tit_wrap w490">
					<h2 class="tit_ico_faq2">상담사례</h2>
				</div>
				
				<ul class="tab_line big list3 mgr20" >
				<li id="faqTab2" class="active" style="width:50% !important;">
					<a href="javascript:changeFaqData('faqTab2')">조회수가 많은 사례</a>
				</li>
				<li id="faqTab1" style="width:50% !important;">
					<a href="javascript:changeFaqData('faqTab1')">최근 업로드된 사례</a>
				</li>
				
				<table class="hType" style="display:block;overflow-y:auto;height:330px">
					<caption>대시보드-상담사례</caption>
					<colgroup>
						<col style="width:50px">
						<col style="width:30px">
						<col style="width:70%">
						<col style="width:100px">
					</colgroup>
					<tbody id="faqListBody">
					</tbody>
				</table>
			</ul>
		</div>
	</div>
</div>
</form>


<!-- AS리스트 레이어팝업 -->
<%-- <div class="box_layer layer_order_list"  id="asListLayer" style="height:400px;display:none;" >
	<div class="layer_contents" style="padding-top:20px;height:365px;">
		<table class="hType" style="display:block;overflow-y:auto;height:330px;">
			<caption>나의 A/S현황</caption>
			<colgroup>
		<col style="width:70px" /><!-- 처리상태 -->
		<col style="width:70px" /><!-- 처리완료일 -->
		<col style="width:90px" /><!-- 문의유형 -->
		<col style="width:300px" /><!-- 요청내용 -->
		<col style="width:70px" /><!-- 처리담당자 -->
			</colgroup>
			<tr>
				<th>처리상태</th>
				<th>처리완료일</th>
				<th>문의유형</th>
				<th>요청내용</th>
				<th>처리담당자</th>
			</tr>
			<tbody id="asListBody">
			</tbody>
		</table>
	</div>
</div> --%>

<!-- 최근댓글팝업 -->
<div class="box_layer layer_rating" style="top:40%;width:600px;height:500px;display:none;"id="answerLayer"  >
	<h1 class="tit_back">AS 답변</h1>
	<div class="layer_contents">
		<!-- <div class="comment mgb20">
			AS담당자의 신규 답변을 확인하세요. 감사합니다.
		</div>
		 -->
		<div class="floatWrap mgb10">
	         <div class="mgl40" style="float:right">
	        	
	        	<input type="radio" id="val1" name="type1" value="1" onclick="getAnswerListbyRecent()" checked="checked"/>병원전체AS<span class="mgr5"></span>
				<input type="radio" id="val2" name="type1" value="2" onclick="getAnswerListbyRecent()" />나의AS<span class="mgr5"></span> 
				 | 답변작성일
	        	<input type="text" name="search_start3" id="search_start3" class="w90 mgl5 mgr5" readonly=readonly>
				~
				<input type="text" class="w90 mgl5 mgr5" name="search_end3" id="search_end3" readonly=readonly>
			 </div>   
		</div>
		<div style="padding:15px;height:340px;overflow-y:auto;">
			<form  id="answer-box"></form>
		</div>
 	</div>
	<button type="button" class="btn_close" onclick="$('#answerLayer').hide();$('#div_dim').hide();closeAnswerLayer(); ">창 닫기</button>
</div>
<div class="layer_dimmed"  id="div_dim" style="display:none;"></div>


<!-- 금주의 BEST 상담사례
	<div class="box_layer layer_help" style="width:425px;height:500px;left:23%;" id="BEST_FAQ_DIV">
	    <h1 class="tit_back"></h1>
	   <div class="layer_contents">
	        
	            <div style="width:100%;">
	                <img src="/images/front/BEST_FAQ_TEXT.jpg" alt="" style="width:100%;">
	            </div>
	            <table class="hType" style="display:block;overflow-y:auto;height:330px;margin-left:20px;border-spacing: 0 20px;width:90%;">
					<caption>금주의 BEST 상담사례</caption>
					<colgroup>
						<col style="width:10px">
						<col style="width:50px">
						<col style="width:190px">
						<col style="width:80px">
					</colgroup>
					<tbody id="BestfaqListBody">
					</tbody>
				</table>
	    </div>
	    <button type="button" class="btn_close" onclick="javascript:closeShowBestFaq();">창 닫기</button>
	</div>
	 -->
	
	<!-- ChatbotAI -->
	<div class="box_layer layer_help" style="width:600px;height:700px;left:60%;background-color: rgba(0, 144, 200, 0) !important; background:none !important; 
            border:0 !important; 
            box-shadow:none !important; display:none;" id="CHATBOT_AI_DIV2">
	    <h1 class="tit_back" style="height: 1px !important;background-color: rgba(0, 144, 200, 0) !important;"></h1>
	    <div class="layer_contents" style="width:100%;height:106.5%;padding:0;">
         <iframe id="chatbotFrame"
                src=""
                style="width:100%;height:94%;border:none;"></iframe>
   	    </div>
	    <button type="button" class="btn_close" style="top:20px;right:180px"onclick="javascript:closeShowChatbotAI();">창 닫기</button>
	    <div class="floatR" style="position:absolute; top:570px; right:180px;">
            <input type="checkbox" class="mgr10" id="ChatbotAICheckFlag" onclick="javascript:closeShowContinueChatbotAI();"><strong>오늘하루보지않기</strong>
        </div>
	</div>
	
	
	


