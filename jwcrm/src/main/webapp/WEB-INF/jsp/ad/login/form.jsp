<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javascript">

	function makeLogin(data){
		var returnFlag = typeof data.returnFlag != 'undefined' ? data.returnFlag : '009' ;
		var msg = "" ; 
		
		if(returnFlag == "000") msg = "로그인 되었습니다." ; 
		else if(returnFlag == "001") msg = "아이디 및 비밀번호를 다시 한번 확인해주시기 바랍니다." ; 
		else if(returnFlag == "002") msg = "사용할수 없는 아이디 입니다." ; 
		else if(returnFlag == "009") msg = "비정상적으로 종료 되었습니다." ; 
		
		alert(msg) ;
		if(returnFlag == "000"){
			chkIdSave($('#emp_no'), 'ad');
			
			var returnUrl = typeof data.returnUrl != 'undefined' ? data.returnUrl : '/ad/as/list.do' ;
			
			location.href = returnUrl;
		}
	}

	function loginProc(){
		var datas = {
				emp_no 			: $('#emp_no').val() ,
				pass 			: $('#pass').val() 
		};
		
		
		common.ajaxCall(datas, '/ad/login/proc.do' , 'makeLogin') ; 
	}
	
	
	
	function judHostname(){
		var hostname = window.location.hostname;
		
		if(hostname == 'localhost' || hostname == '192.168.16.110'){
			console.log(window.location.hostname);
			var a = '<h3 style="font-size:20px;" class="colorRed">*개발용 서버 (테스트)</h3>';
			$('#appendText').append(a);
		}else{
			return;
		}
	} 
	 
	$(document).ready(function(){
		showSaveId($('#emp_no'), 'ad');
		$("#pass").keyup(function(e){if(e.keyCode == 13)  loginProc(); });
		
		judHostname();
		
	});
 
</script>

<body class="jw_login login_admin">
	<div class="login_outer">
		<div class="login_inner">
			<div class="inner_upper">
				<img src="/images/front/txt_login_01.png" alt="JW 중외그룹" class="mgb15" />
				<img src="/images/txt_login_02_02.png" alt="중외정보기술 LineUs에 오신 것을 환영합니다."/>
				<span id=appendText></span>
				<input type="text" placeholder="사용자 아이디를 입력하세요." class="input_id" id="emp_no" name="emp_no" title="아이디 입력"  />
				<input type="password" placeholder="비밀 번호를 입력하세요." class="input_pw" id="pass" name="pass" title="패스워드 입력"  />
				<input type="checkbox" id="chkIdSave" class="save_id" value="Y"/><label for="save_id">아이디 저장</label>
				<button type="button" class="btn_login" onclick="javascript:loginProc();">로그인</button>
			</div>
			<div class="inner_lower">
				<a href="javascript:location.href='/ad/login/search.do';">비밀번호 찾기</a>
			</div>
			<img src="/images/front/logo_jw_gray.png" alt="jw Connected Care System" class="logo_footer" />
			<div class="address_footer">
				주소. 경기 과천시 과천대로7나길 60 C - 303(과천어반허브) (주)중외정보기술<br/>
				Tel. 1588-0047 Fax. 02-801-1099
				<span class="copy_footer">COPYRIGHT© 중외정보기술 All Rights Reserved.</span>
			</div>
		</div>
	</div>
</body>

