<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javascript">

	function goProc(){
		var f = document.procFrm ; 
		if(common.isEmpty(f.emp_no.value)){
			alert('아이디를 입력해 주세요.') ; 
			return ; 
		}
		if(common.isEmpty(f.emp_nm.value)){
			alert('사용자 이름을 입력해 주세요.') ; 
			return ; 
		}
		if (common.isEmpty(f.email1.value) || common.isEmpty(f.email2.value)) {
			alert('이메일을 입력해 주세요.') ; 
			return ;			
		}
		$('#e_mail').val(f.email1.value + "@" + f.email2.value);
		$.ajax({
			type : 'post' ,
			url : '/ad/login/searchProc.do' , 
			data : $('form[name=procFrm]').serialize() ,
			dataType : 'json' , 
			statusCode : {
				403:function(data){
					alert("권한이 없습니다.");
				},
				404:function(data){
					alert('해당 페이지가 존재하지 않습니다.');
				}
			}, 
			success : function(data){
				var returnFlag = typeof data.returnFlag != "undefined" ? data.returnFlag : null ; 
				if(returnFlag != null){
					var msg = "" ; 
					
					if(returnFlag == "000") {
						$('#wrapPass').show(); 
						$('#btnSearch1').hide(); 
						$('#btnSearch2').hide();
						$('#emp_no').attr('readonly', 'readonly');
						$('#emp_nm').attr('readonly', 'readonly');
						$('#email1').attr('readonly', 'readonly');
						$('#email2').attr('readonly', 'readonly');
					}
					else if(returnFlag == "001") msg = "일치 하는 정보가 없습니다." ;
					else if(returnFlag == "002") msg = "사용할 수 없는 아이디 입니다." ;
					
					if (returnFlag != '000') goFail();
				}else{
					alert("처리도중 오류가 발생했습니다.") ; 
					return ; 
				}
			}
		}) ; 
	}
	
	function goUpdate() {
		var f = document.procFrm ; 
		
		if (common.nvl(f.pass.value, '') == '') {
			alert('변경 비밀번호를 입력해 주세요.');
			return;
		}
		
		if (common.nvl(f.pass_confirm.value, '') == '') {
			alert('비밀번호 재입력을 입력해 주세요.');
			return;
		}
		
		if (common.nvl(f.pass_confirm.value, '') != common.nvl(f.pass.value, '')) {
			alert('비밀번호 재입력을 정확히 입력해 주세요.');
			$('#pass_confirm').val('');
			return;
		}
		
		if (common.nvl(f.pass.value, '') != '') {    
			var minlen = 8;
			var maxlen = 20;  
			if ((f.pass.value.length < minlen) || (f.pass.value.length > maxlen)) {
				alert('변경하실 비밀번호를 최소 8자리 이상 20자리 이하로 입력해주세요.');
				$('#Pass_confirm').val('');
				$('#Pass').focus();
				return;
			}
		}		
			
		common.ajaxCall($('form[name=procFrm]').serialize(), '/ad/login/proc2.do' , 'makeUpdate') ; 
	}
	
	function makeUpdate(data) {
		var returnFlag = typeof data.returnFlag != "undefined" ? data.returnFlag : null ;
		if(returnFlag != null){
			var msg = "" ; 
			
			if(returnFlag == "000") msg = "정상적으로 변경 되었습니다.\n로그인 페이지로 이동합니다.";
			else if(returnFlag == "600") msg = "변경 비밀번호를 대소문자 구분 + 숫자 + 특수문자 포함 8자리 이상 입력해 주세요." ;
			else if(returnFlag == "300") msg = "최근 변경한 비밀번호 5회 내에 동일한 비밀번호가 존재합니다. \n다른 비밀번호를 입력해주세요." ; //2024.03.26 비밀번호 정책 관련 추가
			else if(returnFlag == "001") goFail();
			alert(msg);
			if (returnFlag == "000") goLogin();
		}else{
			alert("처리도중 오류가 발생했습니다.") ; 
			return ; 
		}
	}
	
	function goFail() {
		var f = document.procFrm ; 
		
		f.target = "" ; 
		f.action = "/ad/login/fail.do" ; 
		f.submit() ;
	}
	
	function goLogin(){
		var f = document.procFrm ; 
		
		f.target = "" ; 
		f.action = "/ad/login/form.do" ; 
		f.submit() ;
	}
	
	//setTimeout(function() {
	//  document.getElementById("emp_no").value = " ";
	//}, 700); // 1000 밀리초 = 1초
	
</script>
<div class="tit_wrap_admin">
	<div class="innerWrap">
		<h2>비밀번호 변경</h2>
		<span>
			회원가입 시, 등록하신 정보를 입력해 주세요. 등록된 정보와 일치하면 비밀번호 변경이 가능합니다.
		</span>
	</div>
</div>

<form name="procFrm" id="procFrm" method="post">
	<input type="hidden" name="e_mail" id="e_mail" value=""/>
		
	<div id="jw_contents">
		<ul class="tab_back mgt30 mgb20"></ul>
		<table class="vType_line mgb20">
			<caption>비밀번호 찾기</caption>
			<colgroup>
				<col style="width:160px;">
				<col style="width:auto;">
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">사용자 ID</th>
					<td><input type="text" id="emp_no" name="emp_no" title="아이디 입력" class="w190" /></td>
				</tr>
				<tr>
				
					<th scope="row">사원명</th>
					<td><input type="text" id="emp_nm" name="emp_nm" title="사용자 이름 입력" class="w190" value = ""/></td>
				</tr>
				<tr>
					<th scope="row">이메일</th>
					<td>
						<input type="text" id="email1" name="email1" title="이메일 입력1" class="w190" /><span class="textC w30">@</span>
						<input type="text" id="email2" name="email2" title="이메일 입력2" class="w190" />
					</td>
				</tr>
			</tbody>
		</table>
		<div class="btn_wrap">
			<div class="floatR">
				<button type="button" class="btn_ico_search" id="btnSearch1" onclick="goProc();"><span>비밀번호 변경</span></button>
				<button type="button" class="btn_ico_cancel" id="btnSearch2" onclick="goLogin();"><span>취소</span></button>
			</div>
		</div>
				
		<div id="wrapPass" style="display:none;" class="mgr10">
			<table class="vType_line mgb20">
				<caption>비밀번호 	변경</caption>
				<colgroup>
					<col style="width:160px;">
					<col style="width:auto;">
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">변경 비밀번호</th>
						<td>
							<input type="password" id="pass" name="pass" title="변경 비밀번호 입력" class="w190" />
							<span class="colorRed mgl5">※ 변경하실 비밀번호를 입력해주세요. (대소문자 구분 + 숫자 + 특수문자 포함 8자리 이상 20자리 이하)</span>		
						</td>
					</tr>
					<tr>
						<th scope="row">비밀번호 재입력</th>
						<td>
							<input type="password" id="pass_confirm" name="pass_confirm" title="비밀번호 재입력" class="w190" />
							<span class="colorRed mgl5">※ 변경 하실 비밀번호를 한번 더 입력해주세요.</span>
						</td>
					</tr>
				</tbody>
			</table>
			<div class="btn_wrap">
				<div class="floatR">
					<button type="button" class="btn_ico_regist" onclick="goUpdate();"><span>저장</span></button>
					<button type="button" class="btn_ico_cancel" onclick="goLogin();"><span>취소</span></button>
				</div>
			</div>
		</div>			
	</div>
	<!--// contents -->	
</form>