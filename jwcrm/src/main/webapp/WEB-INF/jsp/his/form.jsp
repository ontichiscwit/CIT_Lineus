<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
</script>
<body class="jw_login">
	<div class="login_outer">
		<div class="login_inner">
			<div class="inner_upper">
				<img src="/images/front/txt_login_01.png" alt="JW 중외그룹" class="mgb15" />
				<img src="/images/front/txt_login_02.png" alt="JW Connected Care System에 오신 것을 환영합니다."   class="mgb40"/>
				<input type="text" placeholder="사용자 아이디를 입력하세요." class="input_id" id="emp_id" title="아이디 입력"  />
				<input type="password" placeholder="비밀 번호를 입력하세요." class="input_pw" id="pass" title="패스워드 입력"  />
				<input type="checkbox" id="chkIdSave" class="save_id" /><label for="save_id">아이디 저장</label>
				<button type="button" class="btn_login" onclick="javascript:loginProc();">로그인</button>
			</div>
			<div class="inner_lower">
				<a href="/fr/join/form.do">회원가입</a><a href="/fr/login/find.do">계정 찾기</a>
			</div>
			<img src="/images/front/logo_jw_gray.png" alt="jw Connected Care System" class="logo_footer" />
			<div class="address_footer">
				주소. 경기 과천시 과천대로7나길 60 C - 303(과천어반허브) (주)중외정보기술<br />
				Tel. 02-1588-0047  Fax. 02-801-1099
				<span class="copy_footer">COPYRIGHT© 중외정보기술 All Rights Reserved.</span>
			</div>
		</div>
	</div>
</body>