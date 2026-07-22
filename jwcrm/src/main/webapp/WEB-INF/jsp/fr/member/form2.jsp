<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="egovframework.com.comm.util.DateTimeUtil"%>
<script type="text/javascript">
	$(document).ready(function(){
		commonCode.getCodeList('COMMON' , 'CD02' , 'use_type') ; 				/**	계정 상태		*/
		commonCode.getCodeList('COMMON' , 'CD03' , 'phone1') ; 				/**	핸드폰번호	*/
		
		
		$('#use_type').val('${ frUserInfo.use_type }') ; 
		$('#email1').val(common.spritStr('${ frUserInfo.email}' , 1, '@')) ; 
		$('#email2').val(common.spritStr('${ frUserInfo.email}' , 2, '@')) ;
		
		$('#phone1').val(common.spritStr('${ frUserInfo.tel_no}' , 1, '-')) ; 
		$('#phone2').val(common.spritStr('${ frUserInfo.tel_no}' , 2, '-')) ; 
		$('#phone3').val(common.spritStr('${ frUserInfo.tel_no}' , 3, '-')) ;
		
		var datas = {'cust_code' 				: '${ frUserInfo.cust_code }' , 'is_page_gbn' : 'fr'} ; 
		common.ajaxCall(datas , '/ad/member/getCustInfo2.do', 'makeCustInfo') ;
		
	}) ;
	
	function makeCustInfo(data){
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null ; 
		$('#cust_kor_name').val(common.nvl(resultVO.cust_kor_name, '')) ; 
		$('#cust_addr').val(common.nvl(resultVO.cust_address, '')) ; 
		$('#cust_post').val(common.nvl(resultVO.zip_code, '')) ; 
		$('#cust_tel').val(common.nvl(resultVO.tel_no, '')) ; 
		$('#cust_dam').val(common.nvl(resultVO.emp_name, '')) ; 
	}
	
	function goSave(){
		if(common.isEmpty($('#use_type').val())){
			alert('계정상태를 선택해 주세요.') ; return ; 
		}
		
		if(common.isEmpty($('#pass').val())){
			alert('비밀번호를 입력해 주세요.') ; return ; 
		}
		
		if(common.isNotEmpty($('#changePass').val())){
			if(common.isEmpty($('#pass_confirm').val())){
				alert('비밀번호 재입력을 입력해 주세요.') ; return ;	
			} 
			if($('#changePass').val() != $('#pass_confirm').val()){
				alert('비밀번호를 확인해 주세요 입력해 주세요.') ; return ;	
			} 
		}
		
		if(common.isNotEmpty($('#changePass').val())){
			var minlen = 4; 
			if ($('#changePass').val().length < minlen ) {
				alert('변경하실 비밀번호를 최소 4자리 이상 입력해주세요.');
				$('#pass_confirm').val('');
				$('#changePass').focus();
				return;
			}
		}
		
		
		if(!confirm('저장하시겠습니까?')) return ; 
		
		if(common.isNotEmpty($('#email1').val()) && common.isNotEmpty($('#email2').val())){
			$('#email').val($('#email1').val() + "@" + $('#email2').val()) ; 
		}
		
		if(common.isNotEmpty($('#phone1').val()) && common.isNotEmpty($('#phone2').val()) && common.isNotEmpty($('#phone3').val())){
			$('#tel_no').val($('#phone1').val() + "-" + $('#phone2').val() + "-" + $('#phone3').val()) ; 
		}
		
		$('#use_type').prop('disabled',false);
		common.ajaxCall($('form[name=procFrm]').serialize() , '/fr/member/regist.do', 'registResult') ;
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
		else if(returnCode == "500") msg = "아이디/비밀번호를 확인해주세요." ; 
		else if(returnCode == "000") msg = "정상처리 되었습니다.\n정보가 변경되어 로그인 화면으로 이동합니다." ;
		$('#use_type').prop('disabled',true);
		alert(msg) ; 
		if(returnCode == "000") location.href = "/fr/login/out.do"
	}
	
</script>
<form name="procFrm" id="procFrm" method="post" onsubmit="return false;">
	<input type="hidden" name="pageType" value="changeIndividual" />
	<input type="hidden" name="seq" 			value="${ frUserInfo.seq }" />
	<input type="hidden" name ="tel_no" 	id="tel_no" 		value=""/>
	<input type="hidden" name ="email" 		id="email" 		value=""/>
	<input type="hidden" name ="emp_grade" 		id="emp_grade" 		value="${ frUserInfo.emp_grade }"/>

	<div id="jw_contents">
		<div class="tit_wrap">
			<h2 class="tit_ico_myinfo">개인정보수정</h2>
			<div class="location">
				<a href="/fr/main/list.do" class="home">Home</a>
				<a href="/fr/member/form2.do" class="depth"><span class="here">개인정보수정</span></a>
			</div>
		</div>
		
		<div class="tit_sWrap">
		    <h3>회원정보</h3>
		</div>

		<table class="sType mgb30">
			<caption>회원 정보 입력</caption>
			<colgroup>
				<col style="width:110px;" />
				<col style="width:150px;" />
				<col style="width:200px;" />
				<col style="width:110px;" />
				<col style="width:130px;" />
				<col style="width:130px;" />
				<col style="width:170px;" />
			</colgroup>
			<tr>
				<th scope="row" colspan="2">아이디</th>
				<td>
					<input type="text" id="emp_id" name="emp_id" maxlength="15" readonly="readonly" value="${ frUserInfo.emp_id }">
				</td>
				<th scope="row">계정상태</th>
				<td>
					<select name="use_type" id="use_type" disabled></select>
				</td>
				<th scope="row">계정생성일</th>
				<td>
					${ frUserInfo.join_date }
				</td>
			</tr>
			<tr>
			    <th scope="row" rowspan="4" style="border-right:1px solid #dadada;">비밀번호</th>
			</tr>
			<tr>
			    <th scope="row">현재비밀번호<span class="request">필수입력</span></th>
			    <td><input type="password" name="pass" id="pass"></td>
			    <td colspan="4" class="colorRed">※ 현재 비밀번호를 입력해주세요.</td>
			</tr>
			<tr>
			    <th scope="row">변경 비밀번호</th>
			    <td><input type="password" class="w160" name="changePass" id="changePass" maxlength="12"></td>
			    <td colspan="4" class="colorRed">※ 변경하실 비밀번호를 입력해주세요.<br>(영문자, 숫자, 특수문자 또는 이의 조합 4자리 이상 12자리 이하)</td>
			</tr>
			<tr>
			    <th scope="row">비밀번호 재입력</th>
			    <td><input type="password" id="pass_confirm" maxlength="12"></td>
			    <td colspan="4" class="colorRed">※ 변경 하실 비밀번호를 한번 더 입력해주세요.</td>
			</tr>
			<tr>
			    <th scope="row" colspan="2">이름</th>
			    <td colspan="7"><input type="text" id="emp_name" name="emp_name" value="${ frUserInfo.emp_name }"></td>
			</tr>
			<tr>
			    <th scope="row" colspan="2">근무부서</th>
			    <td><input type="text" id="dept_name" name="dept_name" value="${ frUserInfo.dept_name }"></td>
			    <th scope="row" colspan="2">직책</th>
			    <td colspan="2"><input type="text" id="dept_grade" name="dept_grade" value="${ frUserInfo.dept_grade }"></td>
			</tr>
			<tr>
			    <th scope="row">이메일</th>
			    <td colspan="6"><input type="text" class="w150 mgr5" id="email1">@ <input type="text" id="email2" class="w250 mgl5"></td>
			</tr>
			<tr>
			    <th scope="row">연락처</th>
			    <td colspan="6">
			        <select class="w115 mgr5" id="phone1"></select>
			        <input type="text" class="w150 mgr5" id="phone2">
			        <input type="text" class="w150" id="phone3">
			    </td>
			</tr>
		</table>


		<table class="sType mgb30">
			<caption>소속 거래처 정보 입력</caption>
			<colgroup>
				<col style="width:130px;" />
				<col style="width:370px;" />
				<col style="width:130px;" />
				<col style="width:370px;" />
			</colgroup>
			<tr>
			    <th>고객사명</th>
			    <td><input type="text" readonly="readonly" id="cust_kor_name"></td>
			    <th>CRM코드</th>
			    <td><input type="text" readonly="readonly" id="cust_code" name="cust_code" value="${ frUserInfo.cust_code }"></td>
			</tr>
			<tr>
			    <th>고객사 주소</th>
			    <td><input type="text" readonly="readonly" id="cust_addr"></td>
			    <th>우편번호</th>
			    <td><input type="text" readonly="readonly" id="cust_post"></td>
			</tr>
			<tr>
			    <th>고객사 대표 담당자</th>
			    <td><input type="text" readonly="readonly" id="cust_dam"></td>
			    <th>고객사 대표 연락처</th>
			    <td><input type="text" readonly="readonly" id="cust_tel"></td>
			</tr>
		</table>
	
		<div class="btn_wrap">
			<div class="floatR">
				<button type="button" class="btn_ico_save" onclick="javascript:goSave();"><span>저장</span></button>
			</div>
		</div>
	</div>
</form>