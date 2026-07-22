<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
	$(document).ready(function(){
		
		sessionStorage.setItem("search_type10_checked", true);
		
		commonCode.getCodeList('AS' , 'CD03' , 'search_type2') ;
		initForm();
		$("#search_text").val('${vo.search_text}');
		
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
	
	function initForm(){
		
		var searchStart = "${ vo.search_start }";
		var searchEnd = "${ vo.search_end }";
		
		$( "#search_start" ).val(makeDate(searchStart)).datepicker(datepicker);
		$( "#search_end" ).val(makeDate(searchEnd)).datepicker(datepicker);
		
		$("#search_type2").val("${vo.search_type2}");
		$("#search_type4").val("${vo.search_type4}");
		
		$("#search_text").val("${vo.search_text}");
		
	}
	//(2024.05.09.김규민) 검색 기간 기입 가능하도록 설정(형식 검토 알림창 날짜 표시)
	function formatDate(date) {
	    var year = date.getFullYear();
	    var month = ('0' + (date.getMonth() + 1)).slice(-2);
	    var day = ('0' + date.getDate()).slice(-2);
	    return year + '/' + month + '/' + day;
	}
	
	function getBoardList(pageIndex) {
		var f = document.listFrm ;
		
		//(2024.05.09.김규민) 검색 기간 기입 가능하도록 설정
		
		 var datePattern = /^\d{4}\/\d{2}\/\d{2}$/;
		 
		 var enteredDate = f.search_start.value;
		 
		 if (enteredDate === "" || !datePattern.test(enteredDate)){
			 alert('시작일을 형식에 맞게 기입해주세요.\n예시 : ' + formatDate(new Date()));
			 $('#search_start').val("");
			 $('#search_start').focus();
			 return;
		 }
		 
		 var enteredDate = f.search_end.value;
		 
		 if (enteredDate === "" || !datePattern.test(enteredDate)){
			 alert('종료일을 형식에 맞게 기입해주세요.\n예시 : ' + formatDate(new Date()));
			 $('#search_end').val("");
			 $('#search_end').focus();
			 return;
		 }
		
		f.page.value = pageIndex ; 
		$.ajax({
			type			: 'POST',
			url				: "/ad/board/getBoardList.do",
			dataType	: "json",
			data			: $('form[name=listFrm]').serialize() ,
			success: function(data) {
				setBoardList(data) ;  
				
				window.location.hash = '#page' + currentPage;
				
			}
			,statusCode : {
				403:function(data){
					alert("권한이 없습니다.");
				},
				404:function(data){
					alert('해당 페이지가 존재하지 않습니다.');
				}
			}
		});
	}
	
	function setBoardList(data) {
		var str = "" ;
		var paging_src = "" ;
		var htmlWrap = $('#videofaq_list');
		htmlWrap.empty();
		
		var resultList = data.resultList != "undefined" ? data.resultList : null ; 
		var vo = data.vo != "undefined" ? data.vo : null ; 
		
		// 전체 조회 건수 셋팅
		if (vo == null){
			$("#totalRowCnt").html(0);
		}else{
			$("#totalRowCnt").html(numberWithCommas(vo.rowCnt));
		}		
		
		if(resultList != null && resultList.length > 0){
			for(var i = 0 ; i < resultList.length ; i++){
				
				var datas = data.resultList[i];
				
				str += "<tr onclick=\"listDetail('update', '" + datas.seq + "','"+datas.rnum+"');\" style=\"cursor:pointer;\">" ;
				str += "	<td onclick='event.cancelBubble=true;'>";
				var reg_id = jQuery.trim(common.nvl(datas.reg_id, '')).toUpperCase();
				var group_userid = jQuery.trim('${adUserInfo.emp_no}').toUpperCase();
				var emp_grade = jQuery.trim('${adUserInfo.emp_grade}').toUpperCase();
				
				
				if (reg_id == group_userid || emp_grade == 'C001' || emp_grade == 'C002') {			//2021.04.02.이설아 HIS운영지원팀 요청으로 내부관리자도 게시글의 수정권한을 갖도록 소스수정
					str += "<input type=\"checkbox\" id=\"chkSeq\" name=\"chk\" class=\"\" value='" + datas.seq + "'/>"
				}
				str += "</td>" ;
				str += "	<td>" + datas.seq + "</td>" ;
				str += "	<td>" + datas.work_type_nm + "</td>" ;
				str += "	<td>" + common.nvl(datas.cnt, '0') + "</td>" ;
				str += "	<td class='textL'>" + common.nvl(datas.title, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.emp_nm, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.reg_date, '') + "</td>" ;
				str += "	<td>";
				if (common.nvl(datas.attach_seq, '') != 0 ) {
					str += '<button type="button" class="btn_download_blue"><span>다운로드</span></button>' ;	
				} else {
					str += '-';
				}
				str += "	</td>" ;
				str += "</tr>" ;
				
				htmlWrap.html(str);
				$("#pagination").html(vo.json_paging);
			}
		} else {
			commonTable.notData(8 , '조회된 데이터가 없습니다.' , 'videofaq_list') ;	
			$("#pagination").html('');
		}
	}
	
	function listDetail(pageType, seq, num) {
		var f = document.listFrm;
		f.pageType.value = pageType;
		f.seq.value = seq;
		f.listNum.value = num;
		f.method = 'post';
		f.action = '/ad/videofaq/form.do';
		f.submit();
	}
	
	function goForm() {
		var f = document.listFrm;
		f.pageType.value = 'insert';
		f.method = 'post';
		f.action = '/ad/videofaq/form.do';
		f.submit();
	}
	
	function goDel() {
		var f = document.listFrm;
		
		var total_seq = '';
		$("#videofaq_list input[type=checkbox]").each(function(){
			if ($(this).is(':checked')) {
				if (total_seq=='') total_seq = $(this).val();
				else total_seq = total_seq + '@' + $(this).val();
			}
		});
		if (total_seq == '') {
			alert('삭제할 글을 선택해주세요.');
			return;
		}
		f.del_seq.value = total_seq;
		
		if (confirm("선택된 글을 삭제하시겠습니까?")) {
			f.pageType.value = 'delete';
			f.target = "hiddenFrame" ; 
			f.action = "/ad/board/proc.do" ; 
			f.submit();
		}
	}

	function procReturn(flag , msg){
		alert(msg) ;
		if(flag == "success") location.href='/ad/videofaq/list.do' ; 
	}
</script>

<form id="listFrm" name="listFrm" method="post" onsubmit="return false" enctype="multipart/form-data">
<input type="hidden" name="board_gbn" id="board_gbn" value="0006" />
<input type="hidden" name="pageType" id="pageType" />
<input type="hidden" name="page" id="page" />
<input type="hidden" name="seq" id="seq" />
<input type="hidden" name="listNum" id="listNum" />
<input type="hidden" name="del_seq" id="del_seq" />
<div class="tit_wrap">
	<h2 class="tit_ico_videofaq">FAQ(동영상) 관리<span class="tit_depth no_arrow mgl10 mgt8">검색 조건을 선택해 주세요.</span></h2>
	<div class="location">
		<a href="/ad/main/list.do" class="home">Home</a>
		<a href="#" class="depth">게시판 관리</a>
		<a href="/ad/videofaq/list.do" class="depth"><span class="here">FAQ(동영상) 관리</span></a>
	</div>
</div>
<!-- search -->
<table class="sType mgb20">
	<caption>FAQ(동영상) 검색</caption>
	<colgroup>
		<col style="width:140px;" />
		<col style="width:auto;" />
	</colgroup>
	<tr>
		<th scope="row">작성자</th>
		<td>
			<input name="search_type4" id="search_type4" type="text" class="write_white" title="작성자 검색" onkeypress="if( event.keyCode==13 ){getBoardList(1);}"/>
		</td>
		<th scope="row">시스템유형</th>
		<td>
			<select style="width:153px" name="search_type2" id="search_type2" title="시스템유형 선택"></select>
		</td>
	</tr>
	<tr>
		<th scope="row">검색 기간</th>
		<td colspan="3">
			<input type="text" class="w155 mgr10 write_white" id="search_start" name="search_start" title="시작 날짜" readonly="readonly" />
			<span class="txt_wave">~</span>
			<input type="text" class="w155 mgr10 write_white" id="search_end" name="search_end" title="끝나는 날짜" readonly="readonly" />
		</td>
	</tr>
	<tr>
		<th scope="row">검색어</th>
		<td colspan="3">
			<input type="text" class="w640 mgr5" id="search_text" name="search_text" title="통합 검색 키워드 입력" onkeypress="if( event.keyCode==13 ){getBoardList(1);}"/>
			<button type="button" class="btn_ico_reset" onclick="this.form.reset();"><span>초기화</span></button>
			<button type="button" class="btn_ico_search" onclick="getBoardList(1);"><span>검색</span></button>
		</td>
	</tr>
</table>
<!--// search -->
<!-- list -->
<div class="sorting">
	조회건수 : <strong><span class="count" id="totalRowCnt" style="color:#ff3000">0</span> 건</strong>
	<div class="floatR">
		<button type="button" class="btn_ico_write dgray mgb5" onclick="goForm();"><span>동영상 등록</span></button>
	</div>	
</div>
<table class="hType mgb10">
	<caption>FAQ(동영상) 목록</caption>
	<colgroup>
		<col style="width:30px" />
		<col style="width:50px" />
		<col style="width:100px" />
		<col style="width:50px" />
		<col style="width:325px" />
		<col style="width:100px" />
		<col style="width:100px" />
		<col style="width:100px" />
	</colgroup>
	<thead>
		<tr>
			<th scope="col">선택</th>
			<th scope="col">No</th>
			<th scope="col">시스템유형</th>
			<th scope="col">조회수</th>
			<th scope="col">제목</th>
			<th scope="col">작성자</th>
			<th scope="col">작성일</th>
			<th scope="col">첨부파일</th>
		</tr>
	</thead>
	<tbody id="videofaq_list"></tbody>
</table>
<!--// list -->
<!-- page -->
<div class="page">
	<div class="btn_left">
		<button type="button" class="btn_ico_delete dgray" onclick="goDel();"><span>삭제</span></button>
	</div>
	<div id="pagination"></div>
</div>
<!--// page -->
</form>