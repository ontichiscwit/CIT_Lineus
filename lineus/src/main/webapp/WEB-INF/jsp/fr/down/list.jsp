<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script type="text/javascript">
	
	$(document).ready(function(){
		getBoardList(1);
		
		$("#search_text").keyup(function(e){if(e.keyCode == 13)  getBoardList(1); });
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
			}
		});
	}
	
 	function setBoardList(data) {
		var str = "" ;
		var paging_src = "" ;
		var htmlWrap = $('#down_list');
		htmlWrap.empty();
		
		var resultList = data.resultList != "undefined" ? data.resultList : null ; 
		var vo = data.vo != "undefined" ? data.vo : null ; 
		
		if(resultList != null && resultList.length > 0){
			for(var i = 0 ; i < resultList.length ; i++){
				
				var datas = data.resultList[i];
				
				str += "<tr onclick=\"listDetail('update', '" + datas.seq + "','"+datas.rnum+"');\" style=\"cursor:pointer;\">" ;
				str += "	<td>" + datas.rnum + "</td>" ;
				str += "	<td>" + common.nvl(datas.reg_date, '') + "</td>" ;
				str += "	<td>" + common.nvl(datas.cnt, '0') + "</td>" ;
				str += "	<td class=\"textL\">" + common.nvl(datas.title, '-') + "</td>" ;
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
			commonTable.notData(6 , '조회된 데이터가 없습니다.' , 'down_list') ;
			$("#pagination").html('');
		}
	} 
	
	function listDetail(pageType, seq, num) {
		var f = document.listFrm;
		f.pageType.value = pageType;
		f.seq.value = seq;
		f.listNum.value = num;
		f.method = 'post';
		f.action = '/fr/down/form.do';
		f.submit();
	}
		
</script>

<form name="listFrm" id="listFrm" method="post" onsubmit="return false" enctype="multipart/form-data">
<input type="hidden" name="board_gbn" id="board_gbn" value="0002" />
<input type="hidden" name="pageType" id="pageType" />
<input type="hidden" name="page" id="page" />
<input type="hidden" name="seq" id="seq" />
<input type="hidden" name="cust_code" id="cust_code" value=${ frUserInfo.cust_code } />
<input type="hidden" name="listNum" id="listNum" />
<div id="jw_contents">
	<div class="tit_wrap">
		<h2 class="tit_ico_download">다운로드 관리<span class="txt_tit_right">제품매뉴얼 및 고객님의 필요한 자료를 지원합니다.</span></h2>
		<div class="location">
			<a href="/fr/main/list.do" class="home">Home</a>
			<a href="/fr/down/list.do" class="depth"><span class="here">다운로드</span></a>
		</div>
	</div>
	<div class="download_upper">
		<strong>검색을 이용하시면 보다 빠르게 원하시는 자료를 얻으실 수 있습니다.</strong>
		<div class="box_keyword">
			<input type="text" id="search_text" name="search_text" title="검색어입력" placeholder="" />
			<button type="button" onclick="getBoardList(1);"><span>검색</span></button>
		</div>
	 </div>
	
	<!-- list -->
	<table class="hType mgb20">
		<caption>다운로드 목록</caption>
		<colgroup>
			<col style="width:75px" />
			<col style="width:135px" />
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
				<th scope="col">제목</th>
				<th scope="col">첨부파일</th>
				<th scope="col">작성자</th>
			</tr>
		</thead>
		<tbody id="down_list"></tbody>
	</table>
	<!--// list -->
	<!-- page -->
	<div class="page" id="pagination">
	</div>
	<!--// page -->
</div>
</form>