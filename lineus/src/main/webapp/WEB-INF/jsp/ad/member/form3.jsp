<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="egovframework.com.comm.util.DateTimeUtil"%>
<script type="text/javascript">

	$(document).ready(function(){
		//commonCode.getCodeList('COMMON' , 'CD04' , 'emp_grade') ; 			/**	회원 등급		*/
		commonCode.getCodeList('COMMON' , 'CD06' , 'phone1') ; 				/**	핸드폰 앞자리	*/
		//getPostList() ; 
		
		/* $('#dept_cd').val('${ adUserInfo.dept_cd }') ; 
		$('#emp_grade').val(common.nvl('${ adUserInfo.emp_grade }', '')) ; 

		$('#e_mail1').val(common.spritStr('${ adUserInfo.e_mail }' , 1, '@')) ; 
		$('#e_mail2').val(common.spritStr('${ adUserInfo.e_mail }' , 2, '@')) ;
		
		$('#phone1').val(common.spritStr('${ adUserInfo.mobile_no }' , 1, '-')) ; 
		$('#phone2').val(common.spritStr('${ adUserInfo.mobile_no }' , 2, '-')) ; 
		$('#phone3').val(common.spritStr('${ adUserInfo.mobile_no }' , 3, '-')) ; */
		
		getMyInfo();
	}) ;
	
	function getMyInfo() {
		common.ajaxCall({'emp_no' : '${adUserInfo.emp_no}'} , '/ad/member/getErpInfo.do', 'makeMyInfo') ;
	}
	
	function makeMyInfo(data) {
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null ;
		
		$('#reg_date').html(common.nvl(resultVO.reg_date, '')) ;
		$('#e_mail').val(common.nvl(resultVO.e_mail, '')) ; 
		
		$('#phone1').val(common.spritStr(resultVO.mobile_no, 1, '-')) ; 
		$('#phone2').val(common.spritStr(resultVO.mobile_no, 2, '-')) ; 
		$('#phone3').val(common.spritStr(resultVO.mobile_no, 3, '-')) ; 
		
		$('#cp_phone1').val(common.spritStr(resultVO.company_no , 1, '-')) ; 
		$('#cp_phone2').val(common.spritStr(resultVO.company_no , 2, '-')) ; 
		$('#cp_phone3').val(common.spritStr(resultVO.company_no , 3, '-')) ;
		
		$('#emp_nm').val(common.nvl(resultVO.emp_nm, '')) ; 
		$('#emp_grade').val(common.nvl(resultVO.emp_grade, '')) ; 
		$('#dept_cd').val(common.nvl(resultVO.dept_cd, '')) ; 
		$('#dept_duty').val(common.nvl(resultVO.dept_duty, '')) ; 
		
		$('#dept1_nm').val(common.nvl(resultVO.dept1_nm, '')) ;  
		$('#dept1_cd').val(common.nvl(resultVO.dept1_cd, '')) ; 
		$('#dept2_nm').val(common.nvl(resultVO.dept2_nm, '')) ; 
		$('#dept2_cd').val(common.nvl(resultVO.dept2_cd, '')) ; 				
		$('#use_yn').val(common.nvl(resultVO.use_yn, '')) ; 
		$('#dept_grade_cd').val(common.nvl(resultVO.dept_grade_cd, '')) ; 
		$('#dept_grade_nm').val(common.nvl(resultVO.dept_grade_nm, '')) ; 	
		
		$('#lock_yn').val(common.nvl(resultVO.lock_yn, '')) ;  //로그인 LOCK 여부	
		$('#pass_chg_date').html(common.nvl(resultVO.pass_chg_date, '')) ; //2024.03.13 비밀번호 변경 관련 수정(비밀번호 )
	}
	
	function getPostList(){
		common.ajaxCall({} , '/ad/member/getPostSelect.do', 'makeSelectBox') ;
	}
	
	function makeSelectBox(data){
		$('#dept_cd').empty() ; 
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		var str = commonCode.defaultViewOption ; 
		
		if(resultList != null && resultList.length > 0){
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ; 
				
				str += '<option value="'+common.nvl(datas.dept_cd , '')+'">'+common.nvl(datas.dept_nm , '')+'</option>' ; 
			}
		}
		
		$('#dept_cd').append(str) ; 
	}
	
	function goSave(){
		if (common.nvl($('#pass').val(),'') == '') {
			alert('현재 비밀번호를 입력해 주세요.');
			$('#pass').focus();
			return;
		}
		
		
		if (common.nvl($('#pass').val(),'') != '') {
		    if (common.nvl($('#pass').val(),'') == common.nvl($('#changePass').val(),'')) {
			    alert('변경하실 비밀번호가 현재 비밀번호와 일치합니다. \n다시 입력해주세요.');
			    $('#changePass').val('');
			    $('#changePass_confirm').val('');
			    $('#changePass').focus();
			    return;
		    }
		    
		}    

		if (common.nvl($('#changePass').val(),'') != '') {
			
			if (common.nvl($('#changePass_confirm').val(),'') != common.nvl($('#changePass').val(),'')) {
				alert('변경하실 비밀번호를 정확히 입력하세요.');
				$('#changePass_confirm').val('');
				$('#changePass_confirm').focus();
				return;
			}
		}
		
		
		if (common.nvl($('#changePass').val(),'') != '') {
			
			console.log('changePass value:', $('#changePass').val());
			
			var minlen = 8;
			var maxlen = 20;  
			if (($('#changePass').val().length < minlen) || ($('#changePass').val().length > maxlen)) {
				alert('변경하실 비밀번호를 최소 8자리 이상 20자리 이하로 입력해주세요.');
				$('#changePass_confirm').val('');
				$('#changePass').focus();
				return;
			}
		}
		
		if(common.isEmpty($('#emp_no').val())){
			alert("사번을 입력해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#emp_nm').val())){
			alert("이름을 입력해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#e_mail').val())){
			alert("이메일을 입력해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#phone1').val())){
			alert("연락처를 입력해 주세요.") ; 
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
		
		if(!confirm('저장하시겠습니까?')) return ;
		var f = document.procFrm ; 

		if(common.isNotEmpty($('#phone1').val()) && common.isNotEmpty($('#phone2').val()) && common.isNotEmpty($('#phone3').val())){
			$('#mobile_no').val($('#phone1').val() + "-" + $('#phone2').val() + "-" + $('#phone3').val()) ; 
		}
		
		if(common.isNotEmpty($('#cp_phone1').val()) && common.isNotEmpty($('#cp_phone2').val()) && common.isNotEmpty($('#cp_phone3').val())){
			$('#company_no').val($('#cp_phone1').val() + "-" + $('#cp_phone2').val() + "-" + $('#cp_phone3').val()) ; 
		}
		
		common.ajaxCall($('form[name=procFrm]').serialize() , '/ad/member/registMember.do', 'registResult') ;		
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
		
		if(returnCode == "888") msg = "비정상적인 실행 입니다." ; 
		else if(returnCode == "999") msg = "처리도중 오류가 발생했습니다." ; 
		else if(returnCode == "100") msg = "선택된 회원 정보가 없습니다." ; 
		else if(returnCode == "200") msg = "데이터를 확인해 주세요." ; 
		else if(returnCode == "300") msg = "이미 대표계정이 존재합니다." ; 
		else if(returnCode == "400") msg = "동일한 아이디가 존재합니다." ; 
		else if(returnCode == "500") msg = "현재 비밀번호를 정확히 입력해 주세요." ; 
		else if(returnCode == "600") msg = "변경 비밀번호를 대소문자 구분 + 숫자 + 특수문자 포함 8자리 이상 입력해 주세요." ;   		
		else if(returnCode == "700") msg = "최근에 사용한 비밀번호는 사용할 수 없습니다." ;   		
		else if(returnCode == "000") {  
			msg = "정상처리 되었습니다." ;
			if(pageType != "erpPassChange") msg = msg + "\n정보가 변경되어 로그아웃 합니다." ;  
		}
		
		alert(msg) ; 
		if(returnCode == '000' && pageType != 'erpPassChange') location.href = '/ad/login/out.do' ; 
	}
	
	function goMain() {
		location.href="/ad/main/list.do";
	}
	

</script>
<form name="procFrm" id="procFrm" method="post" onsubmit="return false;">
	<input type="hidden" name ="pageType" id="pageType" 	value="erpIndividual"/>
	<input type="hidden" name ="mobile_no" 	id="mobile_no" 		value=""/>
	<input type="hidden" name ="company_no" 	id="company_no" 		value=""/>
	<input type="hidden" name ="emp_grade" 		id="emp_grade" 		value=""/>
	<input type="hidden" name ="dept_cd" 		id="dept_cd" 		value=""/>
	<input type="hidden" name ="dept_duty" 		id="dept_duty" 		value=""/>

	<input type="hidden" name ="dept1_nm" 		id="dept1_nm" 		value=""/>
	<input type="hidden" name ="dept1_cd" 		id="dept1_cd" 		value=""/>
	<input type="hidden" name ="dept2_nm" 		id="dept2_nm" 		value=""/>
	<input type="hidden" name ="dept2_cd" 		id="dept2_cd" 		value=""/>
	<input type="hidden" name ="use_yn" 		id="use_yn" 		value=""/>		
	<input type="hidden" name ="dept_grade_cd" 		id="dept_grade_cd" 		value=""/>
	<input type="hidden" name ="dept_grade_nm" 		id="dept_grade_nm" 		value=""/>

	<input type="hidden" name ="lock_yn" 		id="lock_yn" 		value=""/>				
		
	
	<div class="tit_wrap">
		<h2 class="tit_ico_admin">개인 정보 수정</h2>
		<div class="location">
			<a href="/ad/main/list.do" class="home">Home</a>
			<a href="/ad/member/form3.do" class="depth"><span class="here">개인정보수정</span></a>
		</div>
	</div>
	<div class="tit_sWrap">
		<h3 class="tit_dot_gray">계정 정보</h3>
	</div>
	<!-- write -->
	<table class="sType mgb20">
		<caption>계정 정보</caption>
		<colgroup>
			<col style="width:80px;" />
			<col style="width:140px;" />
			<col style="width:194px;" />
			<col style="width:140px;" />
			<col style="width:194px;" />
			<col style="width:140px;" />
			<col style="width:192px;" />
		</colgroup>
		<tr>
			<th scope="row" colspan="2">아이디</th>
			<td>
				<input type="text" id="emp_id" name="emp_id" title="아이디" readonly="readonly" value="${ adUserInfo.emp_no }" />
			</td>
			<th scope="row">계정생성일</th>
			<td colspan="1" id="reg_date"></td>
			<th scope="row">비밀번호 변경일</th>
            <td colspan="1" id="pass_chg_date"></td>
		</tr>
		<tr>
			<th scope="row" rowspan="3" style="border-right: 1px solid #ddd">비밀번호</th>
			<th scope="row">현재 비밀번호<span class="request mgl5">필수 입력</span></th>
			
			<td colspan="5">
				<input type="password" id="pass" name="pass" class="w155" title="현재비밀번호">
				<span class="colorRed mgl5">※ 현재 비밀번호를 입력해주세요.</span>
			</td>
		</tr>
		<tr>
			<th scope="row" >변경 비밀번호</th>
			<td colspan="5">
				<input type="password" id="changePass" name="changePass" class="w155" title="변경비밀번호">  
				<!--  <span class="colorRed mgl5">※ 변경하실 비밀번호를 입력해주세요. (영문자, 숫자, 특수문자 또는 이의 조합 4자리 이상 12자리 이하)</span> -->
				<span class="colorRed mgl5">※ 변경하실 비밀번호를 입력해주세요. (대소문자 구분 + 숫자 + 특수문자 포함 8자리 이상 20자리 이하)</span>				
			</td>  
		</tr>
		<tr>
			<th scope="row" >비밀번호 재입력</th>
			<td colspan="5">
				<input type="password" id="changePass_confirm" name="changePass_confirm" class="w155" title="비밀번호재입력">
				<span class="colorRed mgl5">※ 변경 하실 비밀번호를 한번 더 입력해주세요.</span>
			</td>
		</tr>
		
		<tr>
			<th scope="row" colspan="2">사번<span class="request mgl5">필수 입력</span></th>
			<td colspan="5">
				<input  readonly="readonly" type="text" id="emp_no" name="emp_no" title="사번" class="w155" value="${ adUserInfo.emp_no }" />
			</td>
		</tr>
		
		<tr>
			<th scope="row" colspan="2">이름<span class="request mgl5">필수 입력</span></th>
			<td colspan="5">
				<input type="text" readonly="readonly" id="emp_nm" name="emp_nm" title="이름" class="w155" value="" />
			</td>
		</tr>
		<tr>
			<th scope="row" colspan="2">이메일<span class="request mgl5">필수 입력</span></th>
			<td colspan="5">
				<input type="text" readonly="readonly" id="e_mail" name="e_mail" title="이메일" class="w155" value="" />
			</td>
		</tr>
		<tr>
			<th scope="row" colspan="2">연락처(핸드폰)<span class="request mgl5">필수 입력</span></th>
			<td colspan="5">
				<select id="phone1" name="phone1" title="연락처" class="w115">
				</select><span class="textC w32">-</span>
				<input type="text" id="phone2" name="phone2" title="연락처" value="" class="w60" /><span class="textC w32">-</span>
				<input type="text" id="phone3" name="phone3" title="연락처" value="" class="w60" />
			</td>
		</tr>
		<tr>
			<th scope="row" colspan="2">연락처(회사)<span class="request mgl5">필수 입력</span></th>
			<td colspan="5">
				<input type="text" id="cp_phone1" name="cp_phone1" title="연락처" class="w115"/><span class="textC w32">-</span>
				<input type="text" id="cp_phone2" name="cp_phone2" title="연락처" value="" class="w60" /><span class="textC w32">-</span>
				<input type="text" id="cp_phone3" name="cp_phone3" title="연락처" value="" class="w60" />
			</td>
		</tr>
	</table>
	<div class="btn_wrap">
		<div class="floatR">
			<button type="button" class="btn_ico_confirm dgray w95" onclick="javascript:goSave();"><span>저장</span></button>
			<button type="button" class="btn_ico_cancel dgray w95" onclick="javascript:goMain();"><span>취소</span></button>
		</div>
	</div>
</form>

