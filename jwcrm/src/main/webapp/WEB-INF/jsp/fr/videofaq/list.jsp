<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/jsp/fr/common/chatbot.jsp" />

<script type="text/javascript">
	
	var currentPage;
	
	var chatbotWindow = null;
	
	$(document).ready(function(){
	
		$("#search_text").val('${vo.search_text}');
		
		$('#pageSize').val('${ vo.pageSize}') ;
		
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
		var f = document.listFrm ; 
		f.page.value = pageIndex ; 
		$.ajax({
			type			: 'POST',
			url				: "/fr/board/getBoardList.do",
			dataType	: "json",
			data			: $('form[name=listFrm]').serialize() ,
			success: function(data) {
				setBoardList(data) ;
				
				window.location.hash = '#page' + currentPage;
			}
		});
	}
	
	function setBoardList(data) {
		var str = "" ;
		var paging_src = "" ;
		var htmlWrap = $('#faq_list');
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
				str += "	<td>" + datas.seq + "</td>" ;
				str += "	<td>" + common.nvl(datas.reg_date, '') + "</td>" ;
				str += "	<td>" + common.nvl(datas.cnt, '0') + "</td>" ;
				str += "	<td>" + datas.work_type_nm + "</td>" ;
				str += "	<td class=\"textL\">" + new_icon + common.nvl(datas.title, '-') + "</td>" ;
				str += "	<td>";
				if (common.nvl(datas.attach_seq, '') != 0 ) {
					str += '<button type="button" class="btn_download_blue"><span>다운로드</span></button>' ;	
				} else {
					str += '';
				}
				str += "	</td>" ;
				str += "	<td>관리자</td>";
				str += "</tr>" ;
				
				htmlWrap.html(str);
				$("#pagination").html(vo.json_paging);
			}
		} else {
			commonTable.notData(7 , '조회된 데이터가 없습니다.' , 'faq_list') ;
			$("#pagination").html('');
		}
	}
	
	function listDetail(pageType, seq, num) {
		var f = document.listFrm;
		f.pageType.value = pageType;
		f.seq.value = seq;
		f.listNum.value = num;
		f.method = 'post';
		f.action = '/fr/videofaq/form.do';
		f.submit();
	}
	
</script>
<form id="listFrm" name="listFrm" method="post" onsubmit="return false" enctype="multipart/form-data">
<input type="hidden" name="board_gbn" id="board_gbn" value="0006" />
<input type="hidden" name="pageType" id="pageType" />
<input type="hidden" name="page" id="page" />
<input type="hidden" name="seq" id="seq" />
<input type="hidden" name="listNum" id="listNum" />

<!-- contents -->
<div id="jw_contents">
	<div class="tit_wrap">
		<h2 class="tit_ico_videofaq">FAQ(동영상)<span class="txt_tit_right">다빈도 문의건에 대한 동영상 매뉴얼을 지원합니다.</span></h2>
		<div class="location">
			<a href="/fr/main/list.do" class="home">Home</a>
			<a href="/fr/videofaq/list.do" class="depth"><span class="here">FAQ(동영상)</span></a>
		</div>
	</div>
	<div class="download_upper">
		<strong>검색을 이용하시면 보다 빠르게 원하시는 자료를 얻으실 수 있습니다.</strong>
		<div class="box_keyword">
			<input type="text" id="search_text" name="search_text" title="검색어입력" placeholder="제목과 내용이 모두 조회됩니다. 다소 시간이 소요될 수 있습니다."  />
			<button type="button" onclick="getBoardList(1);"><span>검색</span></button>
		</div>
	</div>
	<div class="floatR">
		<select id="pageSize" name="pageSize" onchange="getBoardList(1);" title="리스트 행 선택" class="w140">
			<option value="30">30개씩 노출</option>
			<option value="50">50개씩 노출</option>
		</select>
	</div>
	
	<!-- list -->
	<table class="hType mgb20">
		<caption>FAQ(동영상) 목록</caption>
		<colgroup>
			<col style="width:75px" />
			<col style="width:135px" />
			<col style="width:90px" />
			<col style="width:90px" />
			<col style="width:auto" />
			<col style="width:145px" />
			<col style="width:90px" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">No</th>
				<th scope="col">작성일</th>
				<th scope="col">조회수</th>
				<th scope="col">시스템유형</th>
				<th scope="col">제목</th>
				<th scope="col">첨부파일</th>
				<th scope="col">작성자</th>
			</tr>
		</thead>
		<tbody id="faq_list"></tbody>
	</table>
	<!--// list -->
	<!-- page -->
	<div class="page" id="pagination"></div>
	<!--// page -->
</div>
<!--// contents -->
</form>