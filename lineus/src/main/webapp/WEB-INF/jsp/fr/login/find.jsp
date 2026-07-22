<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
	
	var PAGETYPE = "" ; 
	
	$(document).ready(function(){
		
	}) ; 

	function moveTab(gubun){
		for(var i = 1 ; i <=2 ; i++){
			if(Number(gubun) == i){
				if(!$('#li' + i).hasClass("active")) $('#li' + i).addClass("active") ;
				$('#div' + i).show() ; 
			}else {
				if($('#li' + i).hasClass("active")) $('#li' + i).removeClass("active") ;
				$('#div' + i).hide() ; 
			}
		}
	}
	
	function goMoveLoginPage(){
		location.href = "/fr/login/form.do" ; 
	}
	
	function goMoveJoinPage(){
		location.href = "/fr/join/form.do" ; 
	}
	
	function goFind(gubun){
		var datas = null ;
		var isFlag = false ; 
		
		if(gubun == "id"){
			if(common.isEmpty($('#user_name1').val())){
				alert("사용자 이름을 입력해 주세요.") ; 	return ;  
			}
			if(common.isEmpty($('#e_mail1').val())){
				alert("이메일을 입력해 주세요.") ; 	return ;  
			}
			if(common.isEmpty($('#e_mail2').val())){
				alert("이메일을 입력해 주세요.") ; 	return ;  
			}
			
			datas = {
				'emp_name' :  $('#user_name1').val() ,
				'email' :  $('#e_mail1').val() + "@" +  $('#e_mail2').val() , 
				'pageType' : 'findId' 
			} ; 
			
		}else if(gubun == "pass"){
			if(common.isEmpty($('#emp_id2').val())){
				alert("아이디를 입력해 주세요.") ; 	return ;  
			}
			if(common.isEmpty($('#user_name2').val())){
				alert("사용자 이름을 입력해 주세요.") ; 	return ;  
			}
			if(common.isEmpty($('#e_mail3').val())){
				alert("이메일을 입력해 주세요.") ; 	return ;  
			}
			if(common.isEmpty($('#e_mail4').val())){
				alert("이메일을 입력해 주세요.") ; 	return ;  
			}
			
			datas = {
				'emp_id' :  $('#emp_id2').val() ,
				'emp_name' :  $('#user_name2').val() ,
				'email' :  $('#e_mail3').val() + "@" +  $('#e_mail4').val() , 
				'pageType' : 'findPw' 
			} ; 
		}
		
		common.ajaxCall(datas, '/fr/login/registFind.do', 'setResult') ;
	}
	
	function setResult(data){
		var userInfo = typeof data.userInfo != "undefined" ? data.userInfo : null ; 
		var pageType = typeof data.pageType != "undefined" ? data.pageType : "" ; 
		var returnFlag = typeof data.returnFlag != "undefined" ? data.returnFlag : "" ; 
		
		if(pageType == "changePw"){		
			if(returnFlag == "success"){
				alert("정상적으로 변경 되었습니다.\n로그인 페이지로 이동합니다.") ; 
				goMoveLoginPage() ; 
			}else if(returnFlag == "600"){   
				alert("변경 비밀번호를 대소문자 구분 + 숫자 + 특수문자 포함 8자리 이상 입력해 주세요.") ; 					
			}else{
				alert("처리도중 오류가 발생했습니다.") ;
			}
		}else{
			$('#tab').hide() ;
			
			for(var i = 1 ; i <= 5 ; i++){
				$('#div' + i).hide() ; 	
			}
			
			PAGETYPE = pageType ; 
			
			if(pageType == "findId"){
				if(userInfo != null){
					$('#div3').show() ;
					$('#emp_id_str').empty().html(common.nvl(userInfo.emp_id)); 
				}	else{
					$('#div4').show() ;
				}
			}else if(pageType == "findPw"){
				if(userInfo != null){
					$('#div5').show() ;
				}	else{
					$('#div4').show() ;
				}
			}			
		}
	}
	
	function reFind(){
		$('#tab').show() ;
		
		for(var i = 1 ; i <= 5 ; i++){
			$('#div' + i).hide() ; 	
		}
		
		if(PAGETYPE == "findId"){
			$('#div1').show() ;
			$('#user_name1').val('') ; 
			$('#e_mail1').val('') ; 
			$('#e_mail2').val('') ;
		}else if(PAGETYPE == "findPw"){
			$('#div2').show() ;
			$('#emp_id2').val('') ; 
			$('#user_name2').val('') ; 
			$('#e_mail3').val('') ; 
			$('#e_mail4').val('') ;
		}
		
	}
	
	function goChangePw(){
		if(common.isEmpty($('#pass').val())){
			alert("비밀번호를 입력해 주세요.") ; 	return ;  
		}
		if(common.isEmpty($('#pass_confirm').val())){
			alert("비밀번호 재입력을 입력해 주세요.") ; 	return ;  
		}
		if($('#pass').val() != $('#pass_confirm').val()){
			alert("비밀번호를 확인해 주세요.") ; 	return ;  
		}
		
		if(common.isNotEmpty($('#pass').val())){ 
			var minlen = 8;
			var maxlen = 20;  
			if (($('#pass').val().length < minlen) || ($('#pass').val().length > maxlen)) {
				alert('변경하실 비밀번호를 최소 8자리 이상 20자리 이하로 입력해주세요.');
				$('#pass_confirm').val('');
				$('#pass').focus();
				return;
			}
		}		
		
		if(!confirm("변경 하시겠습니까?")) return ; 
		
		var datas = {
				'emp_id' : $('#emp_id2').val() ,
				'pass' : $('#pass').val() ,
				'pageType' : 'changePw'
				
		} ; 
		
		common.ajaxCall(datas, '/fr/login/registFind.do', 'setResult') ;
		
	}
	
</script>

<div id="jw_header">
	<div class="innerWrap">
		<h1><a href="/fr/login/form.do">ONTIC LineUS</a></h1>
	</div>
</div>

<div class="tit_wrap_admin">
	<div class="innerWrap">
		<h2>아이디/비밀번호 찾기</h2>
		<span>
			회원가입 또는 고객사 관리자로부터 발급받으신 계정 정보를 입력해주세요.
		</span>
	</div>
</div>
<div id="jw_contents">
	<ul class="tab_back mgt30 mgb20" id="tab">
		<li id="li1" class="active"><a href="javascript:moveTab('1');"><span class="ico_id">아이디 찾기</span></a></li><!-- 활성시 current -->
		<li id="li2"><a href="javascript:moveTab('2');"><span class="ico_pw">비밀번호 찾기</span></a></li>
	</ul>
	
	<div id="div1">
		<table class="vType_line mgb20">
			<caption>아이디 찾기</caption>
			<colgroup>
				<col style="width:160px;">
				<col style="width:auto;">
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">사용자 이름</th>
					<td><input type="text" title="사용자 이름 입력" id="user_name1" class="w190" /></td>
				</tr>
				<tr>
					<th scope="row">이메일</th>
					<td>
						<input type="text" title="이메일 입력1" class="w190" id="e_mail1"/><span class="textC w30">@</span>
						<input type="text" title="이메일 입력2" class="w190" id="e_mail2"/>
					</td>
				</tr>
			</tbody>
		</table>
		
		<div class="btn_wrap">
			<div class="floatR">
				<button type="button" class="btn_ico_search" onclick="javascript:goFind('id');"><span>아이디 찾기</span></button>
				<button type="button" class="btn_ico_cancel" onclick="javascript:goMoveLoginPage();"><span>취소</span></button>
			</div>
		</div>
		
	</div>
	
	<div id="div2" style="display:none;">
		<table class="vType_line mgb20">
			<caption>비밀번호 찾기</caption>
			<colgroup>
				<col style="width:160px;">
				<col style="width:auto;">
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">아이디</th>
					<td><input type="text" title="아이디 입력" id="emp_id2" class="w190" /></td>
				</tr>
				<tr>
					<th scope="row">사용자 이름</th>
					<td><input type="text" title="사용자 이름 입력" id="user_name2" class="w190" /></td>
				</tr>
				<tr>
					<th scope="row">이메일</th>
					<td>
						<input type="text" title="이메일 입력1" class="w190" id="e_mail3"/><span class="textC w30">@</span>
						<input type="text" title="이메일 입력2" class="w190" id="e_mail4"/>
						
					</td>
				</tr>
			</tbody>
		</table>
		<div class="btn_wrap">
			<div class="floatR">
				<button type="button" class="btn_ico_search" onclick="javascript:goFind('pass');"><span>비밀번호 찾기</span></button>
				<button type="button" class="btn_ico_cancel" onclick="javascript:goMoveLoginPage();"><span>취소</span></button>
			</div>
		</div>
	</div>
	
	<div id="div3" style="display:none;">
		<div class="box_result true">
			<strong class="txt01">입력하신 정보와 일치하는 ID 는 다음과 같습니다<br />
			<span class="colorBlue" id="emp_id_str"></span></strong>
		</div>
		<div class="btn_wrap">
			<div class="floatR">
				<button type="button" class="btn_ico_save" onclick="javascript:goMoveLoginPage();"><span>로그인</span></button>
			</div>
		</div>
	</div>
	
	<div id="div4" style="display:none;">
		<div class="box_result false">
			<strong class="txt01">입력하신 정보와 일치하는 아이디 또는 패스워드가 없습니다.</strong>
			<span class="txt02">ONTIC LineUS을 이용하시려면 회원가입을 해주세요.</span>
		</div>
		<div class="btn_wrap">
			<div class="floatR">
				<button type="button" class="btn_ico_regist" onclick="javascript:goMoveJoinPage();"><span>회원가입</span></button><button type="button" class="btn_ico_search" onclick="javascript:reFind();"><span>재 검색</span></button>
			</div>
		</div>
	</div>
	
	<div id="div5" style="display:none;">
		<ul class="tab_back mgt30 mgb20">
			<li class="active" style="width:100%"><a href="#"><span class="ico_pw">비밀번호 재 설정</span></a></li><!-- 활성시 current -->
		</ul>
		<table class="vType_line mgb20">
			<caption>비밀번호 찾기</caption>
			<colgroup>
				<col style="width:160px;">
				<col style="width:auto;">
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">변경 비밀번호</th>
					<td>
						<input type="password" id="pass" title="변경 비밀번호 입력" class="w190"/>
						<span class="colorRed mgl5">※ 변경하실 비밀번호를 입력해주세요. (대소문자 구분 + 숫자 + 특수문자 포함 8자리 이상 20자리 이하)</span>		
					</td>
				</tr>
				<tr>
					<th scope="row">비밀번호 재입력</th>
					<td>
						<input type="password" id="pass_confirm" title="비밀번호 재입력" class="w190"/>
						<span class="colorRed mgl5">※ 변경 하실 비밀번호를 한번 더 입력해주세요.</span>						
					</td>
				</tr>
			</tbody>
		</table>
		<div class="btn_wrap">
			<div class="floatR">
				<button type="button" class="btn_ico_regist" onclick="javascript:goChangePw();"><span>저장</span></button>
				<button type="button" class="btn_ico_cancel" onclick="javascript:goMoveLoginPage();"><span>취소</span></button>
			</div>
		</div>
	</div>
	
</div>
<div id="jw_footer">
	<div id="jw_fnb">
		<div class="innerWrap">
			<ul>
				<li><a href="http://www.cwit.co.kr" target="_blank">회사소개</a></li>
				<li><a href="/fr/agreement/form2.do">개인정보처리방침</a></li>
				<li><a href="/fr/agreement/form3.do">서비스이용약관</a></li>
			</ul>
		</div>
	</div>
	<!--// fnb -->
	<div class="innerWrap">
		<address>
			주소. 경기 과천시 과천대로7나길 60 C - 303(과천어반허브) (주)중외정보기술<br />
			Tel. 1588-0047     Fax. 02-801-1099
			(콜센터 문의: 1588-0047 운영시간 : 9:00~18:00)
			<div class="copy">COPYRIGHT© 중외정보기술 All Rights Reserved.</div>
		</address>
	</div>
</div>