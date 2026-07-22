<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">

	var currentPage;

	$(document).ready(function(){
		
		sessionStorage.setItem("search_type10_checked", true);
		
		//var searchStart = "20170101";
		//var searchStart = "${ vo.search_start }";		
		
		//$( "#search_start" ).val(makeDate(searchStart)).datepicker(datepicker);		
		//$( "#search_start" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		//$( "#search_end" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		commonCode.getCodeList('COMMON' , 'CD11' , 'search_type1') ;
		commonCode.getCodeList('COMMON' , 'CD14' , 'search_type3') ;
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
		
		$("#search_type1").val("${vo.search_type1}");
		$("#search_type3").val("${vo.search_type3}");
		
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
		var htmlWrap = $('#faq_list');
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
				
				
				if (reg_id == group_userid || emp_grade == 'C001') {
					str += "<input type=\"checkbox\" id=\"chkSeq\" name=\"chk\" class=\"\" value='" + datas.seq + "'/>"
				}
				str += "</td>" ;
				
				if (common.nvl(datas.best_faq, '') == 'Y') {
					str += "	<td>" + "<span style=\"color: red;\">" + datas.seq + "</span></td>" ;
				} else {
					str += "	<td>" + datas.seq + "</td>" ;
				}
				
				if (common.nvl(datas.best_faq, '') == 'Y') {
					str += "	<td>" + "<span style=\"color: red;\">" + common.nvl(datas.reg_date, '') + "</span></td>" ;
				} else {
					str += "	<td>" + common.nvl(datas.reg_date, '') + "</td>" ;
				}
				
				if (common.nvl(datas.best_faq, '') == 'Y') {
					str += "	<td>" + "<span style=\"color: red;\">" + (datas.onlyme_open_yn === 'N' ? '전체공지' : '나만보기') + "</span></td>" ;
				} else {
					str += "	<td>" + (datas.onlyme_open_yn === 'N' ? '전체공지' : '나만보기') + "</td>" ;
				}
				
				if (common.nvl(datas.best_faq, '') == 'Y') {
					str += "	<td>" + "<span style=\"color: red;\">" + common.nvl(datas.cnt, '') + "</span></td>" ;
				} else {
					str += "	<td>" + common.nvl(datas.cnt, '0') + "</td>" ;
				}
				
				if (common.nvl(datas.best_faq, '') == 'Y') {
					str += "	<td class=\"textL\">" + "<span style=\"color: red;\">" + "[이번주 BEST 문의]" + common.nvl(datas.title, '-') + "</span></td>" ;
				} else {
					str += "	<td class=\"textL\">" + common.nvl(datas.title, '-') + "</td>" ;
				}
				
				if (common.nvl(datas.best_faq, '') == 'Y') {
					str += "	<td>" + "<span style=\"color: red;\">" + common.nvl(datas.emp_nm, '') + "</span></td>" ;
				} else {
					str += "	<td>" + common.nvl(datas.emp_nm, '0') + "</td>" ;
				}

				if (common.nvl(datas.best_faq, '') == 'Y') {
					str += "	<td>" + "<span style=\"color: red;\">" + common.nvl(datas.like_cnt, '-') + "</span></td>" ;
				} else {
					str += "	<td>" + common.nvl(datas.like_cnt, '0') + "</td>" ;
				}
				
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
		f.action = '/ad/faq/form.do';
		f.submit();
	}
	
	function goForm() {
		var f = document.listFrm;
		f.pageType.value = 'insert';
		f.method = 'post';
		f.action = '/ad/faq/form.do';
		f.submit();
	}
	
	/* 최근 ~ 검색기간 */
	function calSearchDate(stype) {
		
		if (stype==""&&stype==null) return;
		$( "#search_start" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		var addDay = 0;
		var dateArr = $('#search_start').val().split('/');
		var date = new Date(dateArr[0], dateArr[1], dateArr[2]);
		var setYear = date.getFullYear();
		var setMonth = date.getMonth();
		var setDay = date.getDate();
		
		if (stype == 'w7') {
			setDay = date.getDate() - 7;
		} else if (stype=='m1') {
			setMonth = date.getMonth() - 1;
		} else if (stype=='m3') {
			setMonth = date.getMonth() - 3;
		}	
		
		var setDate = new Date(setYear, setMonth, setDay);
		
		var year = setDate.getFullYear().toString();
		var month = setDate.getMonth().toString();
		var day = setDate.getDate().toString();
		
		if (month.length == 1) month = "0" + month;
		if (day.length == 1) day =  "0" + day;
		$('#search_start').val(year + "/" + month + "/" + day);
		$('#search_end').val($.datepicker.formatDate('yy/mm/dd', new Date()));
	}
	
	function goDel() {
		var f = document.listFrm;
		
		var total_seq = '';
		$("#faq_list input[type=checkbox]").each(function(){
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
		if(flag == "success") location.href='/ad/faq/list.do' ; 
	}
</script>
<form id="listFrm" name="listFrm" method="post" onsubmit="return false" enctype="multipart/form-data">
<input type="hidden" name="board_gbn" id="board_gbn" value="0001" />
<input type="hidden" name="pageType" id="pageType" />
<input type="hidden" name="page" id="page" />
<input type="hidden" name="seq" id="seq" />
<input type="hidden" name="listNum" id="listNum" />
<input type="hidden" name="del_seq" id="del_seq" />
<div class="tit_wrap">
	<h2 class="tit_ico_faq">상담사례 관리<span class="tit_depth no_arrow mgl10 mgt8">검색 조건을 선택해 주세요.</span></h2>
	<div class="location">
		<a href="/ad/main/list.do" class="home">Home</a>
		<a href="#" class="depth">게시판 관리</a>
		<a href="/ad/faq/list.do" class="depth"><span class="here">상담사례 관리</span></a>
	</div>
</div>
<!-- search -->
<table class="sType mgb20">
	<caption>FAQ 검색</caption>
	<colgroup>
		<col style="width:140px;" />
		<col style="width:auto;" />
	</colgroup>
	<tr>
		<th scope="row">검색 기간</th>
		<td>
			<button type="button" class="btn_line_gray mgr5" id="date01" title="최근 일주일 검색" onclick="calSearchDate('w7');">최근 일주일</button>
			<button type="button" class="btn_line_gray mgr5" id="date02" title="최근 한달 검색" onclick="calSearchDate('m1');">최근 한달</button>
			<button type="button" class="btn_line_gray mgr20" id="date03" title="최근 3개월 검색" onclick="calSearchDate('m3');">최근 3개월</button>
			<input type="text" class="w155 mgr10 write_white" id="search_start" name="search_start" title="시작 날짜"/>
			<span class="txt_wave">~</span>
			<input type="text" class="w155 mgr10 write_white" id="search_end" name="search_end" title="끝나는 날짜"/>
		</td>
	</tr>
	<tr>
		<th scope="row">노출구분</th>
		<td>
			<select style="width:153px" name="search_type1" id="search_type1" title="노출구분 선택">
				<option>선택</option>
			</select>
		</td>
	</tr>
	<tr>
		<th scope="row">베스트구분</th>
		<td>
			<select style="width:153px" name="search_type3" id="search_type3" title="베스트구분 선택">
				<option>선택</option>
			</select>
		</td>
	</tr>
	<tr>
		<th scope="row">검색어</th>
		<td>
			<input type="text" class="w735 mgr5" id="search_text" name="search_text" title="통합 검색 키워드 입력" /><button type="button" class="btn_ico_search" onclick="getBoardList(1);"><span>검색</span></button>
		</td>
	</tr>
</table>
<!--// search -->
<!-- list -->
<div class="sorting">
	조회건수 : <strong><span class="count" id="totalRowCnt" style="color:#ff3000">0</span> 건</strong>
</div>
<table class="hType mgb10">
	<caption>상담사례 목록</caption>
	<colgroup>
		<col style="width:55px" />
		<col style="width:80px" />
		<col style="width:135px" />
		<col style="width:90px" />
		<col style="width:90px" />
		<col style="width:325px" />
		<col style="width:90px" />
		<col style="width:70px" />
		<col style="width:65px" />
	</colgroup>
	<thead>
		<tr>
			<th scope="col">선택</th>
			<th scope="col">No</th>
			<th scope="col">작성일</th>
			<th scope="col">노출구분</th>
			<th scope="col">조회수</th>
			<th scope="col">제목</th>
			<th scope="col">작성자</th>
			<th scope="col">좋아요 개수</th>
			<th scope="col">첨부파일</th>
		</tr>
	</thead>
	<tbody id="faq_list"></tbody>
</table>
<!--// list -->
<!-- page -->
<div class="page">
	<div class="btn_left">
		<button type="button" class="btn_ico_write dgray" onclick="goForm();"><span>글쓰기</span></button>
		<button type="button" class="btn_ico_delete dgray" onclick="goDel();"><span>삭제</span></button>
	</div>
	<div id="pagination"></div>
</div>
<!--// page -->
</form>