<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javascript">
	var chatbotWindow = null;
	
	$(document).ready(function(){
		commonCode.getCodeList('COMMON' , 'CD02' , 'search_type1') ; 			/**	회원상태		*/
		goList(1) ; 
	}) ; 
	
	function goList(page) {
		$('#page').val(page) ;
		common.ajaxCall($('form[name=listFrm]').serialize() , '/fr/member/getList.do', 'makeList') ;
	}  
	
	function makeList(data){
		
		$('#listTbody').empty() ; 
		$("#pagination").html('');
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var vo = typeof data.vo != "undefined" ? data.vo : null ; 
		
		if(resultList != null && resultList.length > 0){
			var str = '' ; 
			
			for(var i = 0 ; i < resultList.length ; i++){
				
				var datas = resultList[i] ;
				
				str += '<tr onclick="javascript:goView(\'update\' , \''+common.nvl(datas.seq , '')+'\');" style="cursor:pointer;"> ' ;
				str += '	<td>'+common.nvl(datas.rnum , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.emp_id , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.emp_name , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.dept_name , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.dept_grade , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.tel_no , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.email , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.use_type_name , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.join_date , '')+'</td> ' ;
				str += '</tr> ' ;
				
			}
			
			$('#listTbody').append(str) ; 
			$("#pagination").html(vo.json_paging);
		}else{
			commonTable.notData(9 , '조회된 정보가 없습니다.' , 'listTbody') ; 
		}
	}
	
	function goView(pageType , seq){
		var f = document.listFrm ; 
		
		f.pageType.value = pageType ; 
		f.seq.value = seq ;
		
		f.target = '' ; 
		f.action = '/fr/member/form.do' ; 
		f.submit() ; 
	}
	
</script>

<div id="jw_contents">
	<div class="tit_wrap">
		<h2 class="tit_ico_admin">계정 관리</h2>
		<div class="location">
			<a href="/fr/main/list.do" class="home">Home</a>
			<a href="/fr/member/list.do" class="depth"><span class="here">계정관리</span></a>
		</div>
	</div>
	<form name="listFrm" id="listFrm" method="post" onsubmit="return false;">
		<input type="hidden" name="page" id="page" value="${ vo.page }"/>
		<input type="hidden" name="pageType" id="pageType" value=""/>
		<input type="hidden" name="seq" id="seq" value=""/>
		
		<div class="info_upper mgb10">
		    <div class="floatL">
		        계정상태 :
		        <select id="search_type1" name="search_type1" class="w150 mgl5" onchange="javascript:goList(1);"></select>
		    </div>
		    <div class="floatR">
		        
		        <select id="pageSize" name="pageSize"  class="w150 mgl5"  onchange="javascript:goList(1);">
		            <option value="10">10개씩 노출</option>
		            <option value="50">50개씩 노출</option>
					<option value="80">80개씩 노출</option>
					<option value="100">100개씩 노출</option>
		        </select>
		    </div>
		</div>
	</form>
	<!--// A/S 신청 제품 정보 -->
	<table class="hType mgb20">
		<colgroup>
			<col style="width:35px;">
			<col span="8" style="width:auto;">
		</colgroup>
		<thead>
			<tr>
				<th>No</th>
				<th>아이디</th>
				<th>사용자 이름</th>
				<th>근무부서</th>
				<th>직책</th>
				<th>연락처</th>
				<th>이메일</th>
				<th>계정상태</th>
				<th>계정생성일</th>
			</tr>
		</thead>
		<tbody id="listTbody"></tbody>
	</table>
	<div class="btn_wrap">
	    <button type="button" class="btn_ico_plue" onclick="javascript:goView('insert' , '');"><span>계정추가</span></button>
	</div>
	<div class="page" id="pagination"></div>
	<!--// write -->
</div>