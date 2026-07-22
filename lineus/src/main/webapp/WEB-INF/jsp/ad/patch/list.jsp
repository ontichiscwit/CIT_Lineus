<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
	$(document).ready(function(){
		
		commonCode.getCodeList('COMMON' , 'CD08' , 'search_type1') ;
		commonCode.getCodeList('PROJECT' , 'PR02' , 'search_type2') ;
		initForm();
		getBoardList( ${ vo.page } );
		
	});
	
	function initForm(){
		
		var searchStart = "${ vo.search_start }";
		var searchEnd = "${ vo.search_end }";
		
		$( "#search_start" ).val(makeDate(searchStart)).datepicker(datepicker);
		$( "#search_end" ).val(makeDate(searchEnd)).datepicker(datepicker);
		
		$("#search_type1").val("${vo.search_type1}");
		$("#search_type2").val("${vo.search_type2}").change();
		$("#search_type3").val("${vo.search_type3}");
		$("#search_type4").val("${vo.search_type4}");
		$("#search_type5").val("${vo.search_type5}");
		
		$("#search_text").val("${vo.search_text}");
	}
	
	function getBoardList(pageIndex) {
		var f = document.listFrm ; 
		
		f.page.value = pageIndex ; 
		
		$.ajax({
			type			: 'POST',
			url				: "/ad/notice/getBoardList.do",
			dataType	: "json",
			data			: $('form[name=listFrm]').serialize() ,
			success: function(data) {
				setBoardList(data) ;
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
		var htmlWrap = $('#patch_list');
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
				
				
				str += "<tr onclick=\"listDetail('update', '" + datas.seq + "');\" style=\"cursor:pointer;\">" ;
				str += "	<td onclick='event.cancelBubble=true;'>";
				var reg_id = jQuery.trim(common.nvl(datas.reg_id, '')).toUpperCase();
				var group_userid = jQuery.trim('${adUserInfo.emp_no}').toUpperCase();
				var emp_grade = jQuery.trim('${adUserInfo.emp_grade}').toUpperCase();
				
				if (reg_id == group_userid ) {
					str += "<input type=\"checkbox\" id=\"chkSeq\" name=\"chk\" class=\"\" value='" + datas.seq + "'/>"
				}
				str += "</td>" ;
				str += "	<td>" + datas._num + "</td>" ;
				
				// 업무유형 데이터 처리
				var tmpStr = common.nvl(datas.system_type_nm, '');
				if (common.nvl(datas.work_type_nm, '') != ''){
					tmpStr += ' > ' + common.nvl(datas.work_type_nm, '');  
				}
				str += "	<td>" + tmpStr + "</td>" ;
				// 업무유형 데이터 처리
				
				str += "	<td>" + common.nvl(datas.open_type_nm, '') + "</td>" ;
				str += "	<td>" + common.nvl(datas.cnt, '0') + "</td>" ;
				str += "	<td class='textL'>" + common.nvl(datas.title, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas._cnt, '0') + "</td>" ;
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
			commonTable.notData(10 , '조회된 데이터가 없습니다.' , 'patch_list') ;
			$("#pagination").html('');
		}
	}
	
	function listDetail(pageType, seq) {
		var f = document.listFrm;
		f.pageType.value = pageType;
		f.seq.value = seq;
		f.method = 'post';
		f.action = '/ad/patch/form.do';
		f.submit();
	}
	
	function goForm() {
		var f = document.listFrm;
		f.pageType.value = 'insert';
		f.method = 'post';
		f.action = '/ad/patch/form.do';
		f.submit();
	}
	
	function vdCopy(){
		var f = document.listFrm;
		var patch_seq = '';
		var cnt = 0;
		
		$("#patch_list input[type=checkbox]").each(function(){
			if ($(this).is(':checked')) {patch_seq = $(this).val(); cnt++ }
		});
		
		if (cnt == 0) {alert('복사할 글을 선택해주세요.'); return;} 
		if(cnt > 1 ) {alert('하나만 선택해주세요.'); return;}
		alert('첨부파일을 제외하고 복사합니다.');
		listDetail('copy', patch_seq);
		
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
		$("#patch_list input[type=checkbox]").each(function(){
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
			f.action = "/ad/patch/proc.do" ; 
			f.submit();
		}
	}
	
	function procReturn(flag , msg){
		alert(msg) ;
		if(flag == "success") location.href='/ad/patch/list.do' ; 
	}
</script>
<form id="listFrm" name="listFrm" method="post" onsubmit="return false" enctype="multipart/form-data">
<input type="hidden" name="board_gbn" id="board_gbn" value="0000" />
<input type="hidden" name="pageType" id="pageType" />
<input type="hidden" name="page" id="page" />
<input type="hidden" name="seq" id="seq" />
<input type="hidden" name="del_seq" id="del_seq" />
<div class="tit_wrap">
	<h2 class="tit_ico_patch">패치노트<span class="tit_depth no_arrow mgl10 mgt8">검색 조건을 선택해 주세요.</span></h2>
	<div class="location">
		<a href="/ad/main/list.do" class="home">Home</a>
		<a href="#" class="depth">게시판 관리</a>
		<a href="/ad/patch/list.do" class="depth"><span class="here">패치노트</span></a>
	</div>
</div>
<!-- search -->
<table class="sType mgb20">
	<caption>패치노트 검색</caption>
	<colgroup>
		<col style="width:140px;" />
		<col style="width:193px;" />
		<col style="width:140px;" />
		<col style="width:193px;" />
		<col style="width:140px;" />
		<col style="width:193px;" />
	</colgroup>
	<tr>
		<th scope="row">노출구분</th>
		<td>
			<select name="search_type1" id="search_type1" title="노출구분 선택">
				<option>선택</option>
			</select>
		</td>
		<th scope="row">시스템/업무 유형</th>
		<td colspan="3">
			<select style="width:153px" name="search_type2" id="search_type2" title="시스템 유형 선택" onchange="commonCode.getCodeList('OPERATE' , this.value , 'search_type3');$('#search_type3').show()">
				<option value="">선택</option>
			</select>
			<select style="display:none;width:153px" name="search_type3" id="search_type3" title="업무유형 선택">
				<option value="">선택</option>
			</select>
		</td>
	</tr>
	<tr>
		<th scope="row">작성자</th>
		<td>
			<input name="search_type4" id="search_type4" type="text" class="write_white" title="작성자 검색" onkeypress="if( event.keyCode==13 ){getBoardList(1);}"/>
		</td>
		<th scope="row">수신처</th>
		<td colspan="3">
			<input name="search_type5" id="search_type5" type="text" class="write_white" title="수신처 검색" onkeypress="if( event.keyCode==13 ){getBoardList(1);}"/>
		</td>
	</tr>
	<tr>
		<th scope="row">검색 기간</th>
		<td colspan="5">
			<button type="button" class="btn_line_gray mgr5" id="date01" title="최근 일주일 검색" onclick="calSearchDate('w7');">최근 일주일</button>
			<button type="button" class="btn_line_gray mgr5" id="date02" title="최근 한달 검색" onclick="calSearchDate('m1');">최근 한달</button>
			<button type="button" class="btn_line_gray mgr20" id="date03" title="최근 3개월 검색" onclick="calSearchDate('m3');">최근 3개월</button>
			<input type="text" class="w155 mgr10 write_white" id="search_start" name="search_start" title="시작 날짜" readonly="readonly" />
			<span class="txt_wave">~</span>
			<input type="text" class="w155 mgr10 write_white" id="search_end" name="search_end" title="끝나는 날짜" readonly="readonly" />
		</td>
	</tr>
	<tr>
		<th scope="row">검색어</th>
		<td colspan="5">
			<input type="text" class="w640 mgr5" id="search_text" name="search_text" placeholder="공지사항 번호 /제목  /작성자" title="통합 검색 키워드 입력" onkeypress="if( event.keyCode==13 ){getBoardList(1);}"/>
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
		<button type="button" class="btn_ico_write dgray mgb5" onclick="goForm();"><span>글쓰기</span></button>
		<button type="button" class="btn_ico_copy dgray mgb5" onclick="vdCopy();"><span>복사</span></button>
	</div>		
</div>
<table class="hType mgb10">
	<caption>공지사항 목록</caption>
	<colgroup>
		<col style="width:30px" />
		<col style="width:50px" />
		<col style="width:100px" />
		<col style="width:100px" />
		<col style="width:50px" />
		<col style="width:325px" />
		<col style="width:50px" />
		<col style="width:100px" />
		<col style="width:100px" />
		<col style="width:100px" />
	</colgroup>
	<thead>
		<tr>
			<th scope="col">선택</th>
			<th scope="col">No</th>
			<th scope="col">업무유형</th>
			<th scope="col">노출구분</th>
			<th scope="col">조회수</th>
			<th scope="col">제목</th>
			<th scope="col">댓글수</th>
			<th scope="col">작성자</th>
			<th scope="col">작성일</th>
			<th scope="col">첨부파일</th>
		</tr>
	</thead>
	<tbody id="patch_list"></tbody>
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
