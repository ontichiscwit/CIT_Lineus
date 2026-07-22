<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/jsp/fr/common/chatbot.jsp" />

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


	
	var currentPage;
	
	var chatbotWindow = null;
	
	
	$(document).ready(function(){
		//2024.05.08 검색기간 관련 추가
		var searchStart = "${vo.search_start}";
		//var searchEnd = "${ vo.search_end }";
		
		if (searchStart) {
		$("#search_start").val("${vo.search_start}").datepicker(datepicker);
		} else {
		$("#search_start").val($.datepicker.formatDate('yy/mm/dd', new Date(new Date().setMonth(new Date().getMonth() - 3)))).datepicker(datepicker);
		}
		
		$("#search_end").val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		$("#search_text").val("${vo.search_text}");
		
		$('#pageSize').val('${ vo.pageSize}') ;
		
		$('.ui-datepicker-trigger').css('cursor','pointer');
		
		currentPage = ${ vo.page };
		if (location.hash) {
			currentPage = parseInt(location.hash.slice(5));
		}
		
		$("#search_text").keyup(function(e){if(e.keyCode == 13)  getBoardList(1); });
		
		$(window).on('hashchange', function() {
			var page = parseInt(location.hash.slice(5));
			if (!!page && currentPage !== page) {
				getBoardList(page);
			}
		});
		
		getBoardList(currentPage);
		
		
	});
	
	function getBoardList(pageIndex) {
		
 		$('#noticepage').hide();
		$('#pagination').hide();
		$('#noticeday').hide();
		
		currentPage = pageIndex;
		
		$("#loadingMessage").show();
		
		var f = document.listFrm ; 
		f.page.value = pageIndex ; 
		$.ajax({
			type			: 'POST',
			url				: "/fr/notice/getBoardList.do",
			dataType	: "json",
			data			: $('form[name=listFrm]').serialize() ,
			success: function(data) {
				setBoardList(data) ;
				
				window.location.hash = '#page' + currentPage;
			},
			 complete: function() {
		            $("#loadingMessage").hide();
		        }
		});
	}
	
	function setBoardList(data) {
		

		var str = "" ;
		var paging_src = "" ;
		var htmlWrap = $('#notice_list');
		htmlWrap.empty();
		
		var resultList = data.resultList != "undefined" ? data.resultList : null ; 
		var vo = data.vo != "undefined" ? data.vo : null ; 
		
		if(resultList != null && resultList.length > 0){
			for(var i = 0 ; i < resultList.length ; i++){
				
				var datas = data.resultList[i];
				
				var new_icon = '';
				
				if (common.nvl(datas.latest_post, '') == 'Y') {
					new_icon = '<span class="new"></span>';	
				}
				
				str += "<tr onclick=\"listDetail('update', '" + datas.seq + "','"+datas.rnum+"');\" style=\"cursor:pointer;\">" ;
				
				if (common.nvl(datas.imp_yn, '') == 'Y') {
					str += "	<td>" + "<span style=\"color: red;\">" + datas.notice_num + "</span></td>" ;
				} else {
					str += "	<td>" + datas.notice_num + "</td>" ;
				}
				
				if (common.nvl(datas.imp_yn, '') == 'Y') {
					str += "	<td>" + "<span style=\"color: red;\">" + common.nvl(datas.reg_date, '') + "</span></td>" ;
				} else {
					str += "	<td>" + common.nvl(datas.reg_date, '') + "</td>" ;
				}
				
				if (common.nvl(datas.imp_yn, '') == 'Y') {
					str += "	<td>" + "<span style=\"color: red;\">" + common.nvl(datas.cnt, '0') + "</span></td>" ;
				} else {
					str += "	<td>" + common.nvl(datas.cnt, '0') + "</td>" ;
				}

				// 시스템유형 데이터 처리
				var tmpStr = common.nvl(datas.work_type_nm, '');
				if (common.nvl(datas.work_type2_nm, '') != ''){
					tmpStr += ' > ' + common.nvl(datas.work_type2_nm, '');  
				}
				
				if (common.nvl(datas.imp_yn, '') == 'Y') {
					str += "	<td>" + "<span style=\"color: red;\">" + tmpStr + "</span></td>" ;
				} else {
					str += "	<td>" + tmpStr + "</td>" ;
				}
				
				// 제목
				
				if (common.nvl(datas.imp_yn, '') == 'Y') {
				    
				    var highlightWords = datas.highlight_words ? datas.highlight_words.split('#').filter(Boolean) : [];

				    
				    var title = common.nvl(datas.title, '-');
				    
				   
				    highlightWords.forEach(function(word) {
				        
				        var regex = new RegExp("(" + word + ")", "gi");
				        title = title.replace(regex, "<span style='font-weight: 900;line-height: 1.2;display: inline; vertical-align: baseline;'>$1</span>");
				    });

				   
				    str += "	<td class='textL'>" + "<span style=\"color: red;\">" + new_icon + "[중요]" + title + "</span></td>";
				} else {
				   
				    var highlightWords = datas.highlight_words ? datas.highlight_words.split('#').filter(Boolean) : [];

				   
				    var title = common.nvl(datas.title, '-');
				    
				    
				    highlightWords.forEach(function(word) {
				        var regex = new RegExp("(" + word + ")", "gi");
				        title = title.replace(regex, "<span style='font-weight: 900;line-height: 1.2;display: inline; vertical-align: baseline;'>$1</span>");
				    });

				    
				    str += "	<td class='textL'>" + new_icon + title + "</td>";
				}
				
				if (common.nvl(datas.imp_yn, '') == 'Y') {
					str += "	<td>" + "<span style=\"color: red;\">" + common.nvl(datas.notice_cnt, '0') + "</span></td>" ;
				} else {
					str += "	<td>" + common.nvl(datas.notice_cnt, '0') + "</td>" ;
				}
				
				str += "	<td>";
				if (common.nvl(datas.attach_seq, '') != 0 ) {
					str += '<button type="button" class="btn_download_blue"><span>다운로드</span></button>' ;	
				} else {
					str += '';
				}
				str += "	</td>" ;
				
				if (common.nvl(datas.imp_yn, '') == 'Y') {
					str += "	<td>" + "<span style=\"color: red;\">관리자</span></td>" ;
				} else {
					str += "	<td>관리자</td>" ;
				}
				
				str += "</tr>" ;
				
				htmlWrap.html(str);
				$("#pagination").html(vo.json_paging);
		 		$('#noticepage').show();
				$('#pagination').show();
				$('#noticeday').show();
				$("#loadingMessage").hide();
			}
		} else {
			commonTable.notData(8 , '조회된 데이터가 없습니다.' , 'notice_list') ;
			$("#pagination").html('');
			$('#noticepage').show();
			$('#pagination').show();
			$('#noticeday').show();
			$("#loadingMessage").hide();
		}
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
	
</script>
<form id="listFrm" name="listFrm" method="post" onsubmit="return false" enctype="multipart/form-data">
<input type="hidden" name="board_gbn" id="board_gbn" value="0000" />
<input type="hidden" name="pageType" id="pageType" />
<input type="hidden" name="page" id="page" />
<input type="hidden" name="seq" id="seq"/>
<input type="hidden" name="listNum" id="listNum" />


<!-- contents -->
<div id="jw_contents">
	<div class="tit_wrap">
		<h2 class="tit_ico_notice">공지사항<span class="txt_tit_right">중요하고 새로운 소식을 확인하세요.</span></h2>
		<div class="location">
			<a href="/fr/main/list.do" class="home">Home</a>
			<a href="/fr/notice/list.do" class="depth"><span class="here">공지사항</span></a>
		</div>
	</div>
	<div class="download_upper">
		<strong>검색을 이용하시면 보다 빠르게 원하시는 자료를 얻으실 수 있습니다.</strong>
		<div class="box_keyword">
			<input type="text" id="search_text" name="search_text" title="검색어입력" placeholder="제목과 내용이 모두 조회됩니다. 다소 시간이 소요될 수 있습니다." onkeypress="if( event.keyCode==13 ){getBoardList(1);}"/>
			<button type="button" onclick="getBoardList(1);"><span>검색</span></button>
		</div>
		<div style = "margin-top: 25px;" id = "noticeday">
			<input type="text" class="w155 mgr10 write_white"  id="search_start" name="search_start" title="시작 날짜" readonly = "readonly"/>
			<span class="txt_wave">~</span>
			<input type="text" class="w155 mgr10 write_white" id="search_end" name="search_end" title="끝나는 날짜" readonly = "readonly" />
		</div>
		<div class="floatR">
		<select id="pageSize" name="pageSize" onchange="getBoardList(1);" title="리스트 행 선택" class="w140">
			<option value="30">30개씩 노출</option>
			<option value="50">50개씩 노출</option>
		</select>
		</div>	
	</div>
	
	<div id="loadingMessage" style="display: none; text-align: center;">
		    <div>
		        <span style="color: blue; font-size: 25px; font-weight: 900;">데이터를 불러오고 있습니다</span><br>
		        <span style="color: black; font-size: 16px; font-weight: 500;">잠시만 기다려 주세요</span>
		        <div class="spinner"></div>
		    </div>
	</div>
	
	
		
	<!-- list -->
	<div id = "noticepage">
		<table class="hType mgb20">
			<caption>공지사항 목록</caption>
			<colgroup>
				<col style="width:75px" />
				<col style="width:120px" />
				<col style="width:75px" />
				<col style="width:135px" />
				<col style="width:auto" />
				<col style="width:70px" />
				<col style="width:70px" />
				<col style="width:70px" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">No</th>
					<th scope="col">작성일</th>
					<th scope="col">조회수</th>
					<th scope="col">시스템유형</th>
					<th scope="col">제목</th>
					<th scope="col">댓글수</th>
					<th scope="col">첨부파일</th>
					<th scope="col">작성자</th>
				</tr>
			</thead>
			<tbody id="notice_list"></tbody>
		</table>
	</div>
	<!--// list -->
	
	<!-- page -->
	<div class="page" id="pagination"></div>
	<!--// page -->
	
</div>
<!--// contents -->
</form>

