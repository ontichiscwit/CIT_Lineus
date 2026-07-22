<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javascript">
	
	$(document).ready(function(){
		commonCode.getCodeList('COMMON' , 'CD04' , 'search_type1') ; 		/**	직원 등급		*/
		
		$("#search_start" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$("#search_end" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$("#search_text").keyup(function(e){if(e.keyCode == 13)  goList(1); });
		
		$('#search_type1').val('${ vo.search_type1 }') ; 
		$('#search_type2').val('${ vo.search_type2 }') ; 
		
		var search_type3 = 'ALL' ; 
		if('${ vo.search_type3 }' != '') search_type3 = '${ vo.search_type3}' ; 
		
		$('input:radio[name=search_type3]:input[value='+search_type3+']').attr("checked", true);
		$('#search_start').val('${ vo.search_start}') ; 
		$('#search_end').val('${ vo.search_end}') ; 
		$('#search_text').val('${ vo.search_text}') ; 
		$('#page').val('${ vo.page}') ; 
		
		makeListData() ; 
	}) ; 

	function goTab(gbn){
		location.href = '/ad/member/list'+gbn+'.do' ; 
	}
	
	function goClear(){
		document.listFrm.reset() ;
		goList(1);
	}
	
	function goList(page){
		var f = document.listFrm ; 
		
		f.page.value = page ; 
		f.target = '' ; 
		f.action = '/ad/member/list2.do' ; 
		f.submit() ; 
	}
	
	function makeListData(){
		common.ajaxCall($('form[name=listFrm]').serialize(), '/ad/member/getEmpList.do', 'getEmpList') ;
	}
	
	function getEmpList(data){
		$('#listTbody').empty() ; 
		$('#count').html('0') ;
		$("#pagination").html('');
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var vo = typeof data.vo != "undefined" ? data.vo : null ; 
		if(resultList != null && resultList.length > 0){
			
			var str = '' ; 
			
			for(var i = 0 ; i < resultList.length ; i++){
				
				var datas = resultList[i] ;
				
				str += '<tr onclick="javascript:goView(\'update\' , \''+common.nvl(datas.emp_no , '')+'\');" style="cursor:pointer;"> ' ;
				str += '	<td onclick=\'event.cancelBubble=true;\'><input type="checkbox" id="check10" name="chk" value="'+common.nvl(datas.emp_no , '')+'"/></td> ' ;
				str += '	<td>'+common.nvl(datas.rnum , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.emp_grade_name , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.emp_no , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.emp_nm , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.dept_nm , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.mobile_no , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.e_mail , '')+'</td> ' ;
				if(common.nvl(datas.use_yn, '') == "N") str += '	<td class="colorRed">N</td> ' ;
				else  str += '	<td>Y</td> ' ;
				str += '</tr> ' ;
			}
			
			$('#listTbody').append(str) ; 
			$('#count').html(vo.rowCnt) ; 
			$("#pagination").html(vo.json_paging);
		}else{
			commonTable.notData(9 , '조회된 정보가 없습니다.' , 'listTbody') ; 
		}
	}
	
	function goView(pageType , emp_no){
		
		if (pageType == 'insert' && ('C001' != '${su.emp_grade}' && 'C002' != '${su.emp_grade}')){
			alert('일반사용자는 권한이 없습니다.');
			return;
		}
		
		var f = document.listFrm ; 
		
		f.pageType.value = pageType ; 
		f.emp_no.value = emp_no ; 
		
		f.target = '' ; 
		f.action = '/ad/member/form2.do' ; 
		f.submit() ; 
	}
	
	function goProc(){
		
		if ('C001' != '${vo.emp_grade}' && 'C002' != '${vo.emp_grade}'){
			alert('일반사용자는 권한이 없습니다.');
			return;
		}
		
		var seq_arr = '' ; 
		
		$("input[name=chk]:checked").each(function() {
			if(seq_arr == "") seq_arr = $(this).val() ; 
			else seq_arr = seq_arr + "@" + $(this).val() ; 
		});
		
		if(seq_arr == ''){
			alert('탈퇴 처리하실 아이디를 선택해 주세요.') ; 
			return ; 
		}
		
		if(!confirm('탈퇴처리 하시겠습니까?')) return ; 
		
		var datas = {'seq_arr' 	: seq_arr , 	'pageType' : 'erpChange'} ; 
		common.ajaxCall(datas , '/ad/member/registMember.do', 'registResult') ;
	}
	
	function registResult(data){
		var msg = "" ; 
		var returnCode = typeof data.returnCode != "undefined" ? data.returnCode : "888" ; 
		
		if(returnCode == "888") msg = "비정상적인 실행 입니다." ; 
		else if(returnCode == "999") msg = "처리도중 오류가 발생했습니다." ; 
		else if(returnCode == "200") msg = "데이터를 확인해 주세요." ; 
		else if(returnCode == "100") msg = "선택된 직원 정보가 없습니다." ; 
		else if(returnCode == "000") msg = "정상처리 되었습니다." ;
		else if(returnCode == "300") msg = "동일한 아이디가 존재합니다." ;
		
		alert(msg) ; 
		if(returnCode == "000") goList(1) ; 
	}
	
	function goExl(){
		var flag = $('#count').html() > 0 ? 'T' : 'F' ;
		
		if(flag == 'T'){
			
			var f = document.listFrm ; 
			
			try{
				$("#exlFrame").remove() ;
			}catch(e){}
			
			var downFrame = $('<iframe id="exlFrame" name="exlFrame" style="width:0px; height=0px ; display:none;"></iframe>') ; 
			downFrame.appendTo("body") ;
			
			f.target = "exlFrame" ; 
			f.action = "/ad/member/exl2.do" ; 
			f.submit() ; 
			
		}else{
			alert("출력 가능한 데이터가 없습니다.") ; 
			return ; 
		}
	}
</script>
<div class="tit_wrap">
	<h2 class="tit_ico_admin">계정 관리<span class="tit_depth no_arrow mgl10 mgt8">검색 조건을 선택해 주세요.</span></h2>
	<div class="location">
		<a href="/ad/main/list.do" class="home">Home</a>
		<a href="/ad/member/list.do" class="depth"><span class="here">계정 관리</span></a>
	</div>
</div>

<ul class="tab_line list2 mgb10">
	<li id="tab1"><a href="javascript:void(0);" onclick="javascript:goTab('');">거래처 회원 관리</a></li>
	<li id="tab2" class="active"><a href="javascript:void(0);">사원 관리</a></li><!-- 활성시 current -->
</ul>

<div class="tit_sWrap">
	<h3 class="tit_dot_gray">계정 정보</h3>
</div>

<form name="listFrm" id="listFrm" method="get" onsubmit="return false;">
	<input type="hidden" name="page" id="page" value="${ vo.page }"/>
	<input type="hidden" name="pageType" id="pageType" value=""/>
	<input type="hidden" name="emp_no" id="emp_no" value=""/>

<table class="sType mgb10">
	<caption>계정 정보</caption>
	<colgroup>
		<col style="width:140px;" />
		<col style="width:auto;" />
	</colgroup>
	<tr>
		<th scope="row">계정유형</th>
		<td>
			<select id="search_type1" name="search_type1" title="계정유형 선택" class="w155"></select>
		</td>
	</tr>
	<tr>
		<th scope="row">계정상태</th>
		<td>
			<select id="search_type2" name="search_type2" title="계정상태 선택" class="w155">
				<option value="">전체선택</option>
				<option value="Y">사용</option>
				<option value="N">미사용</option>
			</select>
		</td>
	</tr>
	<tr>
		<th scope="row">계정생성일</th>
		<td>
			<input type="radio" id="order06" name="search_type3" value="ALL" class="mgr5 mgl10" checked><label for="order06" class="mgr20">전체기간</label>
			<input type="radio" id="order07" name="search_type3" value="SEARCH" class="mgr5"><label for="order07" class="mgr22">기간설정</label>
			<input type="text" class="w155 mgr10" id="search_start" name="search_start" title="시작 날짜" readonly="readonly" value="" />
			<span class="txt_wave">~</span>
			<input type="text" class="w155 mgr10" id="search_end" name="search_end" title="끝나는 날짜" readonly="readonly" value="" />
		</td>
	</tr>
	<tr>
		<th scope="row">통합 검색 키워드</th>
		<td>
			<input type="text" class="w640 mgr5" id="search_text" name="search_text" title="통합 검색 키워드 입력">
			<button type="button" class="btn_ico_reset" onclick="javascript:goClear();"><span>초기화</span></button>&nbsp;
			<button type="button" class="btn_ico_search" onclick="javascript:goList(1);"><span>검색</span></button>
		</td>
	</tr>
</table>

<div class="info_upper mgb5">
	<div class="sorting">
		조회건수 : <strong><span class="count" id="count">0</span> 건</strong>
	</div>
	<div class="floatR">
		<button type="button" class="btn_ico_write" onclick="javascript:goView('insert' , '' );"><span>계정추가</span></button>
		<button type="button" class="btn_ico_excel" onclick="javascript:goExl();"><span>엑셀다운로드</span></button>
		<select id="pageSize" name="pageSize" title="리스트 행 선택" class="w140" onchange="javascript:goList(1);">
			<option value="10">10개씩 노출</option>
			<option value="50">50개씩 노출</option>
			<option value="80">80개씩 노출</option>
			<option value="100">100개씩 노출</option>
		</select>
	</div>
</div>

</form>

<table class="hType mgb10">
	<caption>관리 계정 내역</caption>
	<colgroup>
		<col style="width:50px">
		<col style="width:30px">
		<col span="7" style="width:auto">
	</colgroup>
	<thead>
		<tr>
			<th scope="col">선택</th>
			<th scope="col">No</th>
			<th scope="col">직원등급</th>
			<th scope="col">아이디</th>
			<th scope="col">이름</th>
			<th scope="col">부서명</th>
			<th scope="col">연락처</th>
			<th scope="col">이메일</th>
			<th scope="col">사용여부</th>
		</tr>
	</thead>
	<tbody id="listTbody"></tbody>
</table>
<!-- page -->
<div class="page">
	<div class="btn_left">
		<button type="button" class="btn_ico_write" onclick="javascript:goView('insert' , '' );"><span>계정추가</span></button>
		<button type="button" class="btn_ico_stop" onclick="javascript:goProc();"><span>탈퇴처리</span></button>
	</div>
	<div id="pagination"></div>
</div>