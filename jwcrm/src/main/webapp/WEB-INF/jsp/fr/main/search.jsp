<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="egovframework.com.comm.util.DateTimeUtil"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="egovframework.com.comm.util.DateTimeUtil"%>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>


<style>

.spinner {
    margin: 10px auto;
    width: 40px;
    height: 40px;
    border: 4px solid rgba(0, 0, 0, 0.1);
    border-radius: 50%;
    border-top-color: #000;
    animation: spin 1s ease-in-out infinite;
}

@keyframes spin {
    to {
        transform: rotate(360deg);
    }
}

</style>



<script type="text/javascript">


	$(document).ready(function() {
		
			$("#search_text").val('${vo.search_text}');
			
			//var searchInput = document.getElementById('search_text').value;
            //var displayElement = document.getElementById('search_display');
            
            //displayElement.innerHTML = searchInput ? searchInput : '<span class="colorRed">개발중</span>입니다..';
			
			$("#search_text").keyup(function(e){if(e.keyCode == 13)  getSearchListCnt(); });
			
			getSearchListCnt()
		
	
	});
	
 	 function getSearchListCnt() {
 		 
 		$('#searchCntText').hide();
		$('#boardList').hide();
		
		var f = document.listFrm ; 
		
		if (common.isEmpty($('#search_text').val())) {
			alert('검색어를 입력하세요.');
			$('#search_text').focus(); 
			return;
		}
		
		$("#loadingMessage").show();
		
		$.ajax({
			type			: 'POST',
			url				: "/fr/main/getSearchListCnt.do",
			dataType	: "json",
			data			: $('form[name=listFrm]').serialize() ,
			success: function(data) {
				setSearchListCnt(data) ;
			},
			 complete: function() {
		            $("#loadingMessage").hide();
		        }
		});
	}
 	
	function setSearchListCnt(data){
		
		var searchInput = $('#search_text').val();
		
		var result = data.resultList != "undefined" ? data.resultList : null;
		if( result == null || result.length == 0 || data.resultList[0].TOTAL_CNT == 0 ){
			$('#searchCnt').html('"' + '<a style="color: #ff3000; font-weight: 900; font-size: 18px;">' + searchInput + '</a>' + '"에 대한 통합검색결과가 없습니다.');
			$('#searchCntText').show();
			$('#boardList').hide();
		}else{
			$('#searchCnt').html('"' + '<a style="color: #ff3000; font-weight: 900; font-size: 18px; margin : 10px 0;">' + searchInput + '</a>' + '"에 대한 통합검색결과는 ' + '<a style="color: #ff3000; font-weight: 900; font-size: 18px;">' + '총 ' + data.resultList[0].TOTAL_CNT + '</a>' + '건 입니다.' + '<ul style="border-bottom: 1px solid #dedede">');
			
			$('#searchCntText').hide();
			$('#boardList').hide();
			
			getBoardListCnt()
			getBoardList()
		
		
		}
	} 
	
	function getBoardListCnt() {
		var f = document.listFrm ; 
		
		$("#loadingMessage").show();

		$.ajax({
			type			: 'POST',
			url				: "/fr/main/getBoardListCnt.do",
			dataType	: "json",
			data			: $('form[name=listFrm]').serialize() ,
			success: function(data) {
				setBoardListCnt(data) ;
			},
			complete: function() {
	            $("#loadingMessage").hide();
	        }
		});
	}
	
	function setBoardListCnt(data){
		
		var searchInput = $('#search_text').val();
		
		var result = data.resultList != "undefined" ? data.resultList : null;
		
			$('#noticeCnt').html('<a style="color: #0000ff; font-weight: 900; font-size: 18px;">공지사항</a>' + ' 검색결과 총(<a style="color: #0000ff; font-weight: 900; font-size: 18px;">' + data.resultList[0].BOARD_CNT + '</a>)건');
			$('#faqCnt').html('<a style="color: #0000ff; font-weight: 900; font-size: 18px;">상담사례</a>' + ' 검색결과 총(<a style="color: #0000ff; font-weight: 900; font-size: 18px;">' + data.resultList[1].BOARD_CNT + '</a>)건');
			$('#downCnt').html('<a style="color: #0000ff; font-weight: 900; font-size: 18px;">다운로드</a>' + ' 검색결과 총(<a style="color: #0000ff; font-weight: 900; font-size: 18px;">' + data.resultList[2].BOARD_CNT + '</a>)건');
			$('#videofaqCnt').html('<a style="color: #0000ff; font-weight: 900; font-size: 18px;">FAQ(동영상)</a>' + ' 검색결과 총(<a style="color: #0000ff; font-weight: 900; font-size: 18px;">' + data.resultList[4].BOARD_CNT + '</a>)건');
			$('#drugfaqCnt').html('<a style="color: #0000ff; font-weight: 900; font-size: 18px;">FAQ(마약류보고)</a>' + ' 검색결과 총(<a style="color: #0000ff; font-weight: 900; font-size: 18px;">' + data.resultList[3].BOARD_CNT + '</a>)건');
		
	} 
	
	function getBoardList() {
		var f = document.listFrm ; 
		
		$("#loadingMessage").show();

		$.ajax({
			type			: 'POST',
			url				: "/fr/main/getBoardList.do",
			dataType	: "json",
			data			: $('form[name=listFrm]').serialize() ,
			success: function(data) {
				setBoardList(data) ;
			}
		});
	}
	
	function setBoardList(data){
		$('#notice-box').empty();
		$('#faq-box').empty();
		$('#down-box').empty();
		$('#videofaq-box').empty();
		$('#drugfaq-box').empty();
		
		var searchInput = $('#search_text').val();
		
		var result = data.resultList != "undefined" ? data.resultList : null;
		
		var noticestr = '';
		var faqstr = '';
		var downstr = '';
		var videofaqstr = '';
		var drugfaqstr = '';
		
		var noticestrCnt = 0;
		var faqstrCnt = 0;
		var downstrCnt = 0;
		var videofaqstrCnt = 0;
		var drugfaqstrCnt = 0;
		
		const maxLength = 50;
		
		for(var i = 0 ; i < result.length; i++){
			var val = result[i];
			var tempcontent = '';
			
			
			var searchInput = $('#search_text').val();
			
			 // 검색어를 강조하는 함수
		    function highlightText(text, search) {
		        var regex = new RegExp('(' + search + ')', 'gi');
		        return text.replace(regex, '<span style="color: red; font-weight: bold;">$1</span>');
		    }
			 
		 	// HTML 태그 제거 함수
		    function removeHtmlTags(text) {
		        return text.replace(/<\/?[^>]+(>|$)/g, "");
		    }
			 
		    if (val.CONTENT.length > maxLength) {
				tempcontent = val.CONTENT.substring(0, maxLength) + '...';
			}else{
				tempcontent = val.CONTENT
			}
			
		 	// HTML 태그 제거
		    var plainTitle = removeHtmlTags(val.TITLE);
		    var plainContent = removeHtmlTags(tempcontent);
		    
			// TITLE에 검색어 강조
		    var highlightedTitle = highlightText(plainTitle, searchInput);

		    // CONTENT에 검색어 강조
		    var highlightedContent = highlightText(plainContent, searchInput);
			
			var new_icon = '';
			
			if (common.nvl(val.LATEST_POST, '') == 'Y') {
				new_icon = '<span class="new"></span>';	
			}
				
			if(val.BOARD_GBN == '0001'){
				faqstr += "<div onclick=\"FaqlistDetail('update', '" + val.SEQ
								+ "');\" style=\"cursor:pointer;\">";
				faqstr += "<table>";
				faqstr += "<tr>";
				faqstr += "<td style=\"font-size: 16px;color:black;white-space: nowrap;font-weight: 800;\">" + new_icon + val.REG_DATE + " " + highlightedTitle + "</td>";
				faqstr += "</tr>";
				faqstr += "<tr>";
				faqstr += "<td colspan=\"4\" style=\"padding-bottom:15px;padding-top: 5px; border-bottom: 1px dashed #dedede !important;\">" + highlightedContent + "</td>";
				faqstr += "</tr>";
				faqstr += "</table>";
				faqstr += "</div>";
				
				faqstrCnt += 1;
				
			}else if(val.BOARD_GBN == '0002'){
				downstr += "<div onclick=\"DownlistDetail('update', '" + val.SEQ
								+ "');\" style=\"cursor:pointer;\">";
				downstr += "<table>";
				downstr += "<tr>";
				downstr += "<td style=\"font-size: 16px;color:black;white-space: nowrap;font-weight: 800;\">" + new_icon + val.REG_DATE + " " + highlightedTitle + "</td>";
				downstr += "</tr>";
				downstr += "<tr>";
				downstr += "<td colspan=\"4\" style=\"padding-bottom:15px;padding-top: 5px; border-bottom: 1px dashed #dedede !important;\">" + highlightedContent + "</td>";
				downstr += "</tr>";
				downstr += "</table>";
				downstr += "</div>";
				
				downstrCnt += 1;
				
			}else if(val.BOARD_GBN == '0005'){
				drugfaqstr += "<div onclick=\"DrugfaqlistDetail('update', '" + val.SEQ
								+ "');\" style=\"cursor:pointer;\">";
				drugfaqstr += "<table>";
				drugfaqstr += "<tr>";
				drugfaqstr += "<td style=\"font-size: 16px;color:black;white-space: nowrap;font-weight: 800;\">" + new_icon + val.REG_DATE + " " + highlightedTitle + "</td>";
				drugfaqstr += "</tr>";
				drugfaqstr += "<tr>";
				drugfaqstr += "<td colspan=\"4\" style=\"padding-bottom:15px;padding-top: 5px; border-bottom: 1px dashed #dedede !important;\">" + "<div>" + highlightedContent + "</div>" + "</td>";
				drugfaqstr += "</tr>";
				drugfaqstr += "</table>";
				drugfaqstr += "</div>";
				
				drugfaqstrCnt += 1;
				
			}else if(val.BOARD_GBN == '0006'){
				videofaqstr += "<div onclick=\"VideofaqlistDetail('update', '" + val.SEQ
								+ "');\" style=\"cursor:pointer;\">";
				videofaqstr += "<table>";
				videofaqstr += "<tr>";
				videofaqstr += "<td style=\"font-size: 16px;color:black;white-space: nowrap;font-weight: 800;\">" + new_icon + val.REG_DATE + " " + highlightedTitle + "</td>";
				videofaqstr += "</tr>";
				videofaqstr += "<tr>";
				videofaqstr += "<td colspan=\"4\" style=\"padding-bottom:15px;padding-top: 5px; border-bottom: 1px dashed #dedede !important;\">" + highlightedContent + "</td>";
				videofaqstr += "</tr>";
				videofaqstr += "</table>";
				videofaqstr += "</div>";
				
				videofaqstrCnt += 1;
			}else{
				noticestr += "<div onclick=\"NoticelistDetail('update', '" + val.SEQ
								+ "');\" style=\"cursor:pointer;\">";
				noticestr += "<table>";
				noticestr += "<tr>";
				
				if (common.nvl(val.IMP_YN, '') == 'Y') {
					noticestr += "<td style=\"font-size: 16px;color:black;white-space: nowrap;font-weight: 800;\">" + "<span style=\"color: red;\">" + new_icon + "[중요]" + val.REG_DATE + " " + val.TITLE + "</span></td>";
				} else {
					noticestr += "<td style=\"font-size: 16px;color:black;white-space: nowrap;font-weight: 800;\">" + new_icon + val.REG_DATE + " " + highlightedTitle + "</td>";
				}
								
				noticestr += "</tr>";
				noticestr += "<tr>";
				noticestr += "<td colspan=\"4\" style=\"padding-bottom:15px;padding-top: 5px; border-bottom: 1px dashed #dedede !important;\">" + highlightedContent + "</td>";
				noticestr += "</tr>";
				noticestr += "</table>";
				noticestr += "</div>";
				
				noticestrCnt += 1;
			}

		}
		
		
		if(noticestrCnt > 0){
			$("#notice-box").html(noticestr);
			
			getSearchStart()
			
			
		}else{
			$("#notice-box").html('<a style="line-height: 60px; color: #ff3000; font-weight: 900; font-size: 15px;">' + searchInput + '</a>' + '에 대한 검색결과가 없습니다.' + '<p style="border-bottom: 1px dashed #dedede"></p>');
		}
		
		if(faqstrCnt > 0){
			$("#faq-box").html(faqstr);
		}else{
			$("#faq-box").html('<a style="line-height: 60px; color: #ff3000; font-weight: 900; font-size: 15px;">' + searchInput + '</a>' + '에 대한 검색결과가 없습니다.' + '<p style="border-bottom: 1px dashed #dedede"></p>');
		}
		
		if(downstrCnt > 0){
			$("#down-box").html(downstr);
		}else{
			$("#down-box").html('<a style="line-height: 60px; color: #ff3000; font-weight: 900; font-size: 15px;">' + searchInput + '</a>' + '에 대한 검색결과가 없습니다.' + '<p style="border-bottom: 1px dashed #dedede"></p>');
		}
		
		if(drugfaqstrCnt > 0){
			$("#drugfaq-box").html(drugfaqstr);
		}else{
			$("#drugfaq-box").html('<a style="line-height: 60px; color: #ff3000; font-weight: 900; font-size: 15px;">' + searchInput + '</a>' + '에 대한 검색결과가 없습니다.' + '<p style="border-bottom: 1px dashed #dedede"></p>');
		}
		
		if(videofaqstrCnt > 0){
			$("#videofaq-box").html(videofaqstr);
		}else{
			$("#videofaq-box").html('<a style="line-height: 60px; color: #ff3000; font-weight: 900; font-size: 15px;">' + searchInput + '</a>' + '에 대한 검색결과가 없습니다.' + '<p style="border-bottom: 1px dashed #dedede"></p>');
		}
		
		
		$('#searchCntText').show();
		$('#boardList').show();
		$("#loadingMessage").hide();
		
		
		
	}
	
	function getSearchStart() {
		var f = document.listFrm ; 

		$.ajax({
			type			: 'POST',
			url				: "/fr/main/getSearchStart.do",
			dataType		: "json",
			data			: $('form[name=listFrm]').serialize() ,
			success: function(data) {
				setSearchStart(data) ;
			}
		});
	}
	
	function setSearchStart(data) {
	    var resultList = data.resultList !== "undefined" ? data.resultList : null;
	    if (resultList && resultList.length > 0) {
	        var datas = resultList[0];
	        $("#search_start").val(datas.search_start);
	    }
	}
	
	function NoticelistDetail(pageType, seq) {
		var f = document.listFrm;
		f.pageType.value = pageType;
		f.seq.value = seq;
		f.board_gbn.value = '9999';
		f.method = 'post';
		f.action = '/fr/notice/form.do';
		f.submit();
	}
	
	function FaqlistDetail(pageType, seq) {
		var f = document.listFrm;
		f.pageType.value = pageType;
		f.seq.value = seq;
		f.board_gbn.value = '9999';
		f.method = 'post';
		f.action = '/fr/faq/form.do';
		f.submit();
	}
	
	function DownlistDetail(pageType, seq) {
		var f = document.listFrm;
		f.pageType.value = pageType;
		f.seq.value = seq;
		f.board_gbn.value = '9999';
		f.method = 'post';
		f.action = '/fr/down/form.do';
		f.submit();
	}
	
	function VideofaqlistDetail(pageType, seq) {
		var f = document.listFrm;
		f.pageType.value = pageType;
		f.seq.value = seq;
		f.board_gbn.value = '9999';
		f.method = 'post';
		f.action = '/fr/videofaq/form.do';
		f.submit();
	}
	
	function DrugfaqlistDetail(pageType, seq) {
		var f = document.listFrm;
		f.pageType.value = pageType;
		f.seq.value = seq;
		f.board_gbn.value = '9999';
		f.method = 'post';
		f.action = '/fr/drugfaq/form.do';
		f.submit();
	}
	
	function loadMoreNotice() {
		var f = document.listFrm;
		f.method="post";
		f.target = "";
		f.action="/fr/notice/list.do";
		f.submit();
	}
	
	function loadMoreFaq() {
		var f = document.listFrm;
		f.method="post";
		f.target = "";
		f.action="/fr/faq/list.do";
		f.submit();
	}
	
	function loadMoreDown() {
		var f = document.listFrm;
		f.method="post";
		f.target = "";
		f.action="/fr/down/list.do";
		f.submit();
	}
	
	function loadMoreVideofaq() {
		var f = document.listFrm;
		f.method="post";
		f.target = "";
		f.action="/fr/videofaq/list.do";
		f.submit();
	}
	
	function loadMoreDrugfaq() {
		var f = document.listFrm;
		f.method="post";
		f.target = "";
		f.action="/fr/drugfaq/list.do";
		f.submit();
	}
	
	
	
</script>

<form id="listFrm" name="listFrm" method="post" onsubmit="return false" enctype="multipart/form-data">
	<input type="hidden" name="pageType" id="pageType" />
	<input type="hidden" name="page" id="page" value="1" />
	<input type="hidden" name="seq" id="seq" />
	<input type="hidden" name="board_gbn" id="board_gbn" />
	<input type="hidden" name="listNum" id="listNum" />
	<input type="hidden" name="user_id" id="user_id" value=${ frUserInfo.emp_id } />
	<input type="hidden" name="cust_code" id="cust_code" value=${ frUserInfo.cust_code } />
	<input type="hidden" name="search_start" id="search_start"/>

	
	<div id="jw_contents">
		<div class="download_upper">
			<strong>검색을 이용하시면 보다 빠르게 원하시는 자료를 얻으실 수 있습니다.</strong>
			<div class="box_keyword">
				<input type="text" id="search_text" name="search_text" title="검색어입력" placeholder="제목과 내용이 모두 조회됩니다. 다소 시간이 소요될 수 있습니다."  />
				<button type="button" onclick="getSearchListCnt();"><span>검색</span></button>
			</div>
		</div>
		<div style="text-align: center; display:none;" id="searchCntText">
			<div>
				<p style="line-height: 40px; font-size: 18px;"><a type="button" id="searchCnt"></a></p>
			</div>
		</div>
		<div id="loadingMessage" style="display: none; text-align: center;">
		    <div>
		        <span style="color: blue; font-size: 25px; font-weight: 900;">데이터를 불러오고 있습니다</span><br>
		        <span style="color: black; font-size: 16px; font-weight: 500;">잠시만 기다려 주세요</span>
		        <div class="spinner"></div>
		    </div>
		</div>
		<div style="text-align: left; display:none;" id="boardList">
			<div style="margin: 10px 0;">
				<p style="line-height: 60px; font-size: 18px; border-bottom: 1px solid #dedede">
				<a type="button" id="noticeCnt" style="display: inline-block;"></a>
				<button type="button" style="color: black; float: right !important; margin-top : 30px; cursor: pointer; font-size: 16px; display: inline-block;" id="load-more-notice" onclick="loadMoreNotice()">더보기 +</button>
				</p>
			</div>
			<div>
				<div  style="display: block; width: 100%;"  id="notice-box"></div>
			</div>
			<div style="margin: 10px 0;">
				<p style="line-height: 60px; font-size: 18px; border-bottom: 1px solid #dedede">
				<a type="button" id="faqCnt" style="display: inline-block;"></a>
				<button type="button" style="color: black; float: right !important; margin-top : 30px; cursor: pointer; font-size: 16px; display: inline-block;" id="load-more-faq" onclick="loadMoreFaq()">더보기 +</button>
				</p>
			</div>
			<div>
				<div  style="display: block; width: 100%;"  id="faq-box"></div>
			</div>
			<div style="margin: 10px 0;">
				<p style="line-height: 60px; font-size: 18px; border-bottom: 1px solid #dedede">
				<a type="button" id="downCnt" style="display: inline-block;"></a>
				<button type="button" style="color: black; float: right !important; margin-top : 30px; cursor: pointer; font-size: 16px; display: inline-block;" id="load-more-down" onclick="loadMoreDown()">더보기 +</button>
				</p>
			</div>
			<div>
				<div  style="display: block; width: 100%;" id="down-box"></div>
			</div>
			<div style="margin: 10px 0;">
				<p style="line-height: 60px; font-size: 18px; border-bottom: 1px solid #dedede">
				<a type="button" id="videofaqCnt" style="display: inline-block;"></a>
				<button type="button" style="color: black; float: right !important; margin-top : 30px; cursor: pointer; font-size: 16px; display: inline-block;" id="load-more-videofaq" onclick="loadMoreVideofaq()">더보기 +</button>
				</p>
			</div>
			<div>
				<div  style="display: block; width: 100%;" id="videofaq-box"></div>
			</div>
			<div style="margin: 10px 0;">
				<p style="line-height: 60px; font-size: 18px; border-bottom: 1px solid #dedede">
				<a type="button" id="drugfaqCnt" style="display: inline-block;"></a>
				<button type="button" style="color: black; float: right !important; margin-top : 30px; cursor: pointer; font-size: 16px; display: inline-block;" id="load-more-drugfaq" onclick="loadMoreDrugfaq()">더보기 +</button>
				</p>
			</div>
			<div>
				<div  style="display: block; width: 100%;"  id="drugfaq-box"></div>
			</div>
		</div>
		
	</div>
	

	
		
</form>





