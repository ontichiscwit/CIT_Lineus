<%@page import="egovframework.com.comm.util.CommonExecute"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="egovframework.com.comm.util.DateTimeUtil"%>
<script type="text/javascript">

	$(document).ready(function(){
		commonCode.getCodeList('COMMON' , 'CD06' , 'phone1') ; 				/**	핸드폰 앞자리	*/
		
		<c:if test="${ vo.pageType ne 'insert'}">initView();</c:if>
		<c:if test="${ vo.pageType eq 'insert'}">
			$('#lock_yn').val('N');
	</c:if>		
	}) ;
	
	function searchErp(){
		$('#div1').show() ; 
		$('#div_dim').show() ;
		$('#div1').css('height' , '515px') ; 
		custList(1) ; 
	}
	
	function custList(custPage){
		var datas = {
				'page' : custPage , 
				'search_text' : $('#searchKorName').val() 
		}
		
		common.ajaxCall(datas , '/ad/member/getPostList.do', 'makeCustList') ;
	}
	
	function closeLayer() {
		$('#div1').hide() ; 
		$('#div_dim').hide() ; 
		$('#searchKorName').val('') ; 
	}
	
	function makeCustList(data){
		$('#custInfoList').empty() ; 
		$('#layer_pagination').empty() ; 
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var vo = typeof data.vo != "undefined" ? data.vo : null ; 
		
		if(resultList != null && resultList.length > 0){
			var str = '' ; 
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ;
				str += '<tr onclick="javascript:setValue(\''+common.nvl(datas.emp_no, '')+'\');" style="cursor:pointer;"> ' ;
				str += '	<td>'+common.nvl(datas.rnum , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.dept1_nm , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.dept2_nm , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.emp_nm , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.emp_no , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.dept_grade_nm , '')+'</td> ' ;
				str += '</tr> ' ;
			}
			$('#custInfoList').append(str) ; 
			$('#layer_pagination').html(vo.json_paging) ; 
		}else{
			commonTable.notData(6 , '조회된 정보가 없습니다.' , 'custInfoList') ; 
		}
	}
	
	function setValue(emp_no){
		var datas = {'emp_no' 				: emp_no }
		common.ajaxCall(datas , '/ad/member/getPostInfo.do', 'makePostInfo') ;
		closeLayer() ; 
	}
	
	function makePostInfo(data){
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null ; 
		
		$('#emp_no').val(common.nvl(resultVO.emp_no, '')) ; 
		$('#use_yn').val(common.nvl(resultVO.use_yn, 'Y')) ;		
		$('#emp_nm').val(common.nvl(resultVO.emp_nm, '')) ; 
		
		$('#dept_grade_nm').val(common.nvl(resultVO.dept_grade_nm, '')) ; 
		$('#dept1_nm').val(common.nvl(resultVO.dept1_nm, '')) ; 
		$('#dept2_nm').val(common.nvl(resultVO.dept2_nm, '')) ; 
		$('#dept_grade_cd').val(common.nvl(resultVO.dept_grade_cd, '')) ; 
		$('#dept1_cd').val(common.nvl(resultVO.dept1_cd, '')) ; 
		$('#dept2_cd').val(common.nvl(resultVO.dept2_cd, '')) ; 
		
		$('#e_mail1').val(common.spritStr(resultVO.e_mail , 1, '@')) ; 
		$('#e_mail2').val(common.spritStr(resultVO.e_mail , 2, '@')) ;
		
		$('#phone1').val(common.spritStr(resultVO.mobile_no , 1, '-')) ; 
		$('#phone2').val(common.spritStr(resultVO.mobile_no , 2, '-')) ; 
		$('#phone3').val(common.spritStr(resultVO.mobile_no , 3, '-')) ;
		
		$('#cp_phone1').val(common.spritStr(resultVO.company_no , 1, '-')) ; 
		$('#cp_phone2').val(common.spritStr(resultVO.company_no , 2, '-')) ; 
		$('#cp_phone3').val(common.spritStr(resultVO.company_no , 3, '-')) ;
		
		$('#lock_yn').val(common.nvl(resultVO.lock_yn, 'N')) ; 	//로그인 lock 여부					
	}
	
	function clearPass(){
		
		if(!confirm('비밀번호를 초기화 하시겠습니까?')) return ; 
		var datas = {'emp_no' : $('#emp_no').val() ,	'pageType' 	: 'erpPassChange'}
		common.ajaxCall(datas , '/ad/member/registMember.do', 'registResult') ;
	}
	
	function registResult(data){
		var msg = "" ; 
		var returnCode = typeof data.returnCode != "undefined" ? data.returnCode : "888" ; 
		var pageType = typeof data.pageType != "undefined" ? data.pageType : "" ; 
		
		console.log(returnCode) ; 
		console.log(pageType) ; 
		
		if(returnCode == "888") msg = "비정상적인 실행 입니다." ; 
		else if(returnCode == "999") msg = "처리도중 오류가 발생했습니다." ; 
		else if(returnCode == "100") msg = "선택된 회원 정보가 없습니다." ; 
		else if(returnCode == "200") msg = "데이터를 확인해 주세요." ; 
		else if(returnCode == "300") msg = "이미 대표계정이 존재합니다." ; 
		else if(returnCode == "400") msg = "동일한 아이디가 존재합니다." ; 
		else if(returnCode == "600") msg = "변경 비밀번호를 대소문자 구분 + 숫자 + 특수문자 포함 8자리 이상 입력해 주세요." ;   		
		else if(returnCode == "000") msg = "정상처리 되었습니다." ;
		
		alert(msg) ; 
		if(returnCode == "000" && pageType != "erpPassChange") goList() ; 
	}
	
	function goList(){
		location.href = "/ad/member/list2.do${ QUERYSTRING }"
	}
	
	function goSave(){
		
		
		if(common.isEmpty($('#emp_no').val())){
			alert("직원을 검색해 주세요.") ; 
			return ; 
		}
		
		<c:if test="${ vo.pageType eq 'insert'}">
		if(common.isEmpty($('#pass').val())){
			alert("비밀번호를 입력해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#pass_confirm').val())){
			alert("비밀번호 재입력을 입력해 주세요.") ; 
			return ; 
		}
		
		if($('#pass').val() != $('#pass_confirm').val()){
			alert("비밀번호를 확인해 주세요.") ; 
			return ; 
		}
		
		if (common.nvl($('#Pass').val(),'') != '') { 
			var minlen = 8;
			var maxlen = 20;  
			if (($('#Pass').val().length < minlen) || ($('#Pass').val().length > maxlen)) {
				alert('변경하실 비밀번호를 최소 8자리 이상 20자리 이하로 입력해주세요.');
				$('#Pass_confirm').val('');
				$('#Pass').focus();
				return;
			}
		}		
		</c:if>
		
		if(common.isEmpty($('#emp_nm').val())){
			alert("이름을 입력해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#e_mail1').val())){
			alert("이메일을 입력해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#e_mail2').val())){
			alert("이메일을 입력해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#phone1').val())){
			alert("연락처를 선택해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#phone2').val())){
			alert("연락처를 입력해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#phone3').val())){
			alert("연락처를 입력해 주세요.") ; 
			return ; 
		}
		
		
		if(common.isEmpty($('#cp_phone1').val())){
			alert("회사 연락처를 선택해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#cp_phone2').val())){
			alert("회사 연락처를 입력해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#cp_phone3').val())){
			alert("회사 연락처를 입력해 주세요.") ; 
			return ; 
		}
		
		
		if(!confirm('저장하시겠습니까?')) return ;
		var f = document.procFrm ; 
		f.pageType.value = 'erp${vo.pageType}'  ; 
		
		if(common.isNotEmpty($('#e_mail1').val()) && common.isNotEmpty($('#e_mail2').val())){
			$('#e_mail').val($('#e_mail1').val() + "@" + $('#e_mail2').val()) ; 
		}
		
		if(common.isNotEmpty($('#phone1').val()) && common.isNotEmpty($('#phone2').val()) && common.isNotEmpty($('#phone3').val())){
			$('#mobile_no').val($('#phone1').val() + "-" + $('#phone2').val() + "-" + $('#phone3').val()) ; 
		}
		
		
		if(common.isNotEmpty($('#cp_phone1').val()) && common.isNotEmpty($('#cp_phone2').val()) && common.isNotEmpty($('#cp_phone3').val())){
			$('#company_no').val($('#cp_phone1').val() + "-" + $('#cp_phone2').val() + "-" + $('#cp_phone3').val()) ; 
		}
		
		common.ajaxCall($('form[name=procFrm]').serialize() , '/ad/member/registMember.do', 'registResult') ;
	}
	
	function initView(){
		var datas = {'emp_no' 				: '${ vo.emp_no }' }
		common.ajaxCall(datas , '/ad/member/getErpInfo.do', 'makeErpInfo') ;
	}
	
	function makeErpInfo(data){
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null ; 
		
		if(resultVO != null){
			$('#emp_no').val(common.nvl(resultVO.emp_no, '')) ; 
			$('#emp_nm').val(common.nvl(resultVO.emp_nm, '')) ; 
			$('#dept1_nm').val(common.nvl(resultVO.dept1_nm, '')) ; 
			$('#dept1_cd').val(common.nvl(resultVO.dept1_cd, '')) ; 
			$('#dept2_nm').val(common.nvl(resultVO.dept2_nm, '')) ; 
			$('#dept2_cd').val(common.nvl(resultVO.dept2_cd, '')) ; 
			
			
			$('#use_yn').val(common.nvl(resultVO.use_yn, '')) ;	
			$('#dept_grade_cd').val(common.nvl(resultVO.dept_grade_cd, '')) ; 
			$('#dept_grade_nm').val(common.nvl(resultVO.dept_grade_nm, '')) ; 
			
			
			$('#e_mail1').val(common.spritStr(resultVO.e_mail , 1, '@')) ; 
			$('#e_mail2').val(common.spritStr(resultVO.e_mail , 2, '@')) ;
			
			$('#phone1').val(common.spritStr(resultVO.mobile_no , 1, '-')) ; 
			$('#phone2').val(common.spritStr(resultVO.mobile_no , 2, '-')) ; 
			$('#phone3').val(common.spritStr(resultVO.mobile_no , 3, '-')) ; 
			
			$('#cp_phone1').val(common.spritStr(resultVO.company_no , 1, '-')) ; 
			$('#cp_phone2').val(common.spritStr(resultVO.company_no , 2, '-')) ; 
			$('#cp_phone3').val(common.spritStr(resultVO.company_no , 3, '-')) ; 
			
			$('#lock_yn').val(common.nvl(resultVO.lock_yn, '')) ; 	//로그인 lock 여부			
		}
	}
	
</script>
<form name="procFrm" id="procFrm" method="post" onsubmit="return false;">
	<input type="hidden" name ="pageType" id="pageType" 	value="${ vo.pageType }"/>
	<input type="hidden" name ="mobile_no" 	id="mobile_no" 		value=""/>
	<input type="hidden" name ="company_no" 	id="company_no" 		value=""/>
	<input type="hidden" name ="e_mail" 		id="e_mail" 		value=""/>

	<div class="tit_wrap">
		<%= CommonExecute.returnLineMap(request) %>
	</div>
	
	<div class="tit_sWrap">
		<h3 class="tit_dot_gray">계정 정보</h3>
	</div>
	
	<table class="sType mgb20">
		<caption>계정 정보</caption>
		<colgroup>
			<col style="width:140px;" />
			<col style="width:194px;" />
			<col style="width:140px;" />
			<col style="width:194px;" />
			<col style="width:140px;" />
			<col style="width:192px;" />
		</colgroup>
		<tr>
			<th scope="row">아이디(사번)<span class="request mgl5">필수 입력</span></th>
			<td colspan="5">
				<input id="emp_no" type="text" name="emp_no" title="아이디 " class="w155 mgr5" readonly="readonly" value="${ vo.emp_no }"/>
				<c:if test="${ vo.pageType eq 'insert' }">
				<button class="btn_line_gray" onclick="javascript:searchErp();">조회</button>
				</c:if>
			</td>
		</tr>
		<tr>
			<th scope="row">성명<span class="request mgl5">필수 입력</span></th>
			<td>
				<input type="text" id="emp_nm" name="emp_nm" title="성명" readonly="readonly" />
			</td>
			<th scope="row">계정 사용여부<span class="request mgl5">필수 입력</span></th>
			<td>			
				<select id="use_yn" name="use_yn" title="계정상태 선택" class="w155">
					<option value="Y">사용</option>
					<option value="N">미사용</option>
				</select>
			</td>
			<th scope="row">로그인 LOCK여부<span class="request mgl5">필수 입력</span></th>
			<td colspan="3">
				<select  id="lock_yn" name="lock_yn" title="로그인 lock여부 선택" class="w155">
					<!-- <option value="${ vo.lock_yn}">'+${ vo.lock_yn}+'</option> --> 
					<!-- <option value=\''+common.nvl(resultVO.lock_yn, '')+'\'>'+common.nvl(resultVO.lock_yn, '')+'</option> -->
					<option value="Y">Y</option> 
					<option value="N" selected="selected">N</option> 					
				</select>				
			</td>			
		</tr>
		
		<c:choose>
			<c:when test="${ vo.pageType eq 'update' }">
			<tr>
				<th scope="row">비밀번호 초기화</th>
				<td colspan="5">
					<button type="button" class="btn_line_gray w75" onclick="javascript:clearPass();">초기화</button><span class="colorRed mgl5">※ 초기화 시 초기비번(*Abc1234)으로 설정됩니다.</span>
				</td>
			</tr>
			</c:when>
			<c:otherwise>
			<tr>
				<th scope="row">비밀번호<span class="request mgl5">필수 입력</span></th>
				<td>
					<input type="password" id="pass" name="pass" title="비밀번호 초기화"  />
					<span class="colorRed mgl5">※ 변경하실 비밀번호를 입력해주세요. (대소문자 구분 + 숫자 + 특수문자 포함 8자리 이상 20자리 이하)</span>		
				</td>
				<th scope="row">비밀번호 재입력<span class="request mgl5">필수 입력</span></th>
				<td colspan="3">
					<input type="password" id="pass_confirm" title="비밀번호 재입력"  />
					<span class="colorRed mgl5">※ 변경 하실 비밀번호를 한번 더 입력해주세요.</span>
				</td>
			</tr>
			</c:otherwise>
		</c:choose>
		<tr>
			<th scope="row">근무부서명</th>
			<td>
				<input type="text" id="dept1_nm" name="dept1_nm" title="부서명" class="w155"/>
				<input type="hidden" id="dept1_cd" name="dept1_cd" title="부서코드" class="w155" />
			</td>
			<th scope="row">근무팀명</th>
			<td>
				<input type="text" id="dept2_nm" name="dept2_nm" title="팀명" class="w155"/>
				<input type="hidden" id="dept2_cd" name="dept2_cd" title="팀코드" class="w155" />
			</td>
			<th scope="row">직책</th>
			<td>
				<input type="text" id="dept_grade_nm" name="dept_grade_nm"  title="직책" class="w155" value="" />
				<input type="hidden" id="dept_grade_cd" name="dept_grade_cd"  title="직책코드" class="w155" value="" />
			</td>
		</tr>
		<tr>
			<th scope="row">이메일<span class="request mgl5">필수 입력</span></th>
			<td colspan="5">
				<input type="text" id="e_mail1" title="이메일" value="" class="w155" />
				<span class="textC w37">@</span>
				<input type="text" id="e_mail2" title="이메일" value="" class="w155" />
			</td>
		</tr>
		<tr>
			<th scope="row">연락처<span class="request mgl5">필수 입력</span></th>
			<td colspan="5">
				<select id="phone1" title="연락처" class="w115"></select><span class="textC w32">-</span>
				<input type="text" id="phone2" title="연락처" value="" class="w115" maxlength="4"/>
				<span class="textC w32">-</span>
				<input type="text" id="phone3" title="연락처" value="" class="w115"  maxlength="4"/>
			</td>
		</tr>
		<tr>
			<th scope="row">연락처(회사)<span class="request mgl5">필수 입력</span></th>
			<td colspan="5">
				<input type="text" id="cp_phone1" title="연락처" class="w115"/><span class="textC w32">-</span>
				<input type="text" id="cp_phone2" title="연락처" value="" class="w115" maxlength="4"/>
				<span class="textC w32">-</span>
				<input type="text" id="cp_phone3" title="연락처" value="" class="w115"  maxlength="4"/>
			</td>
		</tr>
	</table>
	
	<div class="btn_wrap">
		<div class="floatL">
			<button type="button" class="btn_ico_list" onclick="javascript:goList();"><span>목록</span></button>
		</div>
		<div class="floatR">
			<button type="button" class="btn_ico_confirm" onclick="javascript:goSave();"><span>저장</span></button>
			<button type="button" class="btn_ico_cancel" onclick="javascript:goList();"><span>취소</span></button>
		</div>
	</div>
	<!--// write -->
</form>

<div class="box_layer layer_sms" style="margin-top:-350px;display:none;" id="div1">
<h1>직원 정보 조회 검색 결과</h1>
<div class="layer_contents pdt20" style="height:440px;">
	직원명:
	<input type="text" class="w175 mgr10" id="searchKorName" name="searchKorName" title="직원 명">
	<button type="button" class="btn_ico_search mgr5" onclick="javascript:custList(1);"><span>검색</span></button>
	<table class="vType_line" style="margin-top: 10px;">
		<caption>직원 정보 목록</caption>
		<colgroup>
			<col style="width:50px;" />
			<col style="width:100;" />
			<col style="width:100;" />
			<col style="width:100;" />
			<col style="width:100;" />
			<col style="width:100;" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">No</th>
				<th scope="col">부서명</th>
				<th scope="col">팀명</th>
				<th scope="col">직원명</th>
				<th scope="col">사번</th>
				<th scope="col">직책</th>
			</tr>
		</thead>
		<tbody id="custInfoList"></tbody>
	</table>
	<div class="page" id="layer_pagination" style="margin-top: 10px;"></div>
</div>
<button type="button" class="btn_close" onclick="javascript:closeLayer();">창 닫기</button>
</div>
<div class="layer_dimmed" style="display:none;" id="div_dim"></div>
