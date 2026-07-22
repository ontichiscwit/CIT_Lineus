<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javascript">

	function makeLogin(data){
		var returnFlag = typeof data.returnFlag != 'undefined' ? data.returnFlag : '009' ;
		var msg = "" ; 
		var policy1_val = typeof data.policy1_val != 'undefined' ? data.policy1_val : '0' ;
		var policy2_val = typeof data.policy2_val != 'undefined' ? data.policy2_val : '0' ;		
		var policy3_val = typeof data.policy3_val != 'undefined' ? data.policy3_val : '0' ;
		var login_f_cnt = typeof data.login_f_cnt != 'undefined' ? data.login_f_cnt : '0' ; //비밀번호 오류횟수	
		var pass_d_day = typeof data.pass_d_day != 'undefined' ? data.pass_d_day : '0' ; //비밀번호 변경일까지 남은 일수
		var chg_day_yn = typeof data.chg_day_yn != 'undefined' ? data.chg_day_yn : 'N' ; //2024.03.29 비밀번호 변경일까지 남은 일수가 7일인 경우에 알림창 띄우기
		
		//if(returnFlag == "000") msg = "로그인 되었습니다." ; 
		//if(returnFlag == "001") msg = "아이디 및 비밀번호를 다시 한번 확인해주시기 바랍니다." ;
		if(returnFlag == "001") msg = "아이디를 다시 한번 확인해주시기 바랍니다." ;    	 	
		else if(returnFlag == "002") msg = "사용할수 없는 아이디 입니다." ;  
		else if(returnFlag == "009") msg = "비정상적으로 종료 되었습니다." ; 
		
		else if(returnFlag == "600") msg = "비밀번호는 대소문자 구분 + 숫자 + 특수문자 포함 8자리 이상이어야 합니다. \r\n비밀번호정책으로 하단에 비밀번호 변경에서 비밀번호 변경해주세요." ;  //비밀번호맞으나 비밀번호 체계가 아님
		else if(returnFlag == "650") msg = "비밀번호 오류횟수제한 " + policy2_val + "회 중에 "+ login_f_cnt +"회 잘못 입력하였습니다. \r\n비밀번호를 다시 한번 확인해주시기 바랍니다. \r\n비밀번호는 대소문자 구분 + 숫자 + 특수문자 포함 8자리 이상이어야 합니다. \r\n비밀번호정책으로 하단에 비밀번호 찾기에서 비밀번호 변경해주세요." ;  //비밀번호틀리고 비밀번호 체계가 아님			
		else if(returnFlag == "700") msg = "비밀번호 오류횟수제한 " + policy2_val + "회 중에 "+ login_f_cnt +"회 잘못 입력하였습니다. \r\n비밀번호를 다시 한번 확인해주시기 바랍니다. \r\n비밀번호분실시 하단에 비밀번호 찾기에서 비밀번호 변경해주세요." ;  //비밀번호틀림		    
		else if(returnFlag == "710") msg = "비밀번호 변경일자가 " + policy1_val + "일이 초과되었습니다. \r\n비밀번호정책으로 정책일수 초과시 하단에 비밀번호 변경에서 비밀번호 변경해주세요." ;  //비밀번호정책 정책일수 초과						
		else if(returnFlag == "720") msg = "비밀번호 오류횟수제한 " + policy2_val + "회 모두 초과되었습니다. \r\n비밀번호정책으로 오류횟수제한 초과시 로그인제한 됩니다. \r\n관리자에게(070-7707-5409) 로그인LOCK해제(N) 요청해주세요." ;  //비밀번호정책 비밀번호 오류횟수제한 		
		//else if(returnFlag == "730") msg = "로그인 되었습니다. \r\n비밀번호 변경일까지 " + pass_d_day + "일 남았습니다. \r\n" + pass_d_day + "일 내에 비밀번호 변경해주세요." ;  //이전 알림창
		else if(returnFlag == "740") msg = "로그인LOCK여부(Y)인경우 로그인제한 됩니다. \r\n관리자에게(070-7707-5409) 로그인LOCK해제(N) 요청해주세요." ;  //비밀번호 정책 로그인LOCK여부(Y)인경우 로그인제한 		
		
		if(chg_day_yn == "Y")  msg = "로그인 되었습니다. \r\n비밀번호 변경일까지 " + pass_d_day + "일 남았습니다. \r\n" + pass_d_day + "일 내에 비밀번호 변경해주세요." ;  //2024.03.28 비밀번호 변경일까지 얼마 남지 않았을 경우 알림창 표시
		
		if(returnFlag != "000") {alert(msg)} ;   	
		if(returnFlag == "000"){
			
			if(chg_day_yn == "Y"){
				alert(msg)}
			;
			
			chkIdSave($('#emp_no'), 'ad');
			
			 var returnUrl = typeof data.returnUrl != 'undefined' ? data.returnUrl : '/ad/as/list.do' ;
			
			location.href = returnUrl;
		}
	}

	function loginProc(){
		
		var emp_no = $('#emp_no').val();
		
		//2023.03.21 RPA전용계정은 비밀번호 정책에서 제외
		if(emp_no == 'RPAsys'){
			var datas = {
					emp_no 			: $('#emp_no').val() ,
					pass 			: $('#pass').val() 
			};
			
			common.ajaxCall(datas, '/ad/login/procRPA.do' , 'makeLogin') ; 
			
		}else{
			var datas = {
					emp_no 			: $('#emp_no').val() ,
					pass 			: $('#pass').val() 
			};
			
			common.ajaxCall(datas, '/ad/login/proc.do' , 'makeLogin') ; 
		}
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
				<a href="javascript:location.href='/ad/login/search.do';">비밀번호 변경</a>
			</div>
			<img src="/images/front/logo_jw_gray.png" alt="jw Connected Care System" class="logo_footer" />
			<div class="address_footer">
				주소. 경기 과천시 과천대로7나길 60 C - 303(과천어반허브) (주)중외정보기술<br />
				Tel. 1588-0047 Fax. 02-801-1099
				<span class="copy_footer">COPYRIGHT© 중외정보기술 All Rights Reserved.</span>
			</div>
		</div>
	</div>
</body>

