<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script type="text/javascript">
	function goLogin(){
		var f = document.procFrm ; 
		
		f.target = "" ; 
		f.action = "/ad/login/form.do" ; 
		f.submit() ;
	}
</script>
<!-- contents -->
<div class="tit_wrap_admin">
	<div class="innerWrap">
		<h2>비밀번호 찾기</h2>
		<span>
			회원가입 시, 등록하신 정보를 입력해 주세요. 등록된 정보와 일치하면 가입하신 비밀번호를 알려드립니다.
		</span>
	</div>
</div>
<div id="jw_contents">
	<div class="box_result false">
		<strong class="txt01">입력하신 정보와 일치하는 정보가 없습니다.</strong>
	</div>
	<div class="btn_wrap">
		<div class="floatR">
			<button type="button" class="btn_ico_search" onclick="javascript:location.href='/ad/login/search.do' ;"><span>재 검색</span></button>
			<button type="button" class="btn_ico_cancel" onclick="goLogin();"><span>취소</span></button>
		</div>
	</div>
</div>
<!--// contents -->