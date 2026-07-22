<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>


<script type="text/javascript">
	$(document).ready(function(){
		var title = ["as" , "down" , "faq" , "notice" , "member" , "chatting"] ; 
		var arr = location.href.split('/') ;
		for(var i = 0 ; i < title.length ; i++){
			if(title[i] == arr[4]){
				if(arr[4] == "member" && arr[5] == "form2.do") {
					if($('#a' + i).hasClass('active')) $('#a' + i).removeClass('active') ;
				}else{
					if(!$('#a' + i).hasClass('active')) $('#a' + i).addClass('active') ; 
				}
			}else {
				if($('#a' + i).hasClass('active')) $('#a' + i).removeClass('active') ;
			}
		}
		judHostname();
	}) ;
	
	function goLogOut(){
		if(confirm('로그아웃하시겠습니까?')){
			alert('정상적으로 로그아웃되었습니다.') ;
			location.href = '/fr/login/out.do' ; 
		}
	}
	
	function judHostname(){
		var hostname = window.location.hostname;
		
		if(hostname == 'localhost' || hostname == '192.168.16.110'){
			
			var a = '';
			a += '<div style="float:left" class="nav_util">';
			a += '<h3 style="font-size:25px;" class="colorRed">*개발용 서버 (테스트)</h3>';
			a += '</div>';	
			$('#appendText').append(a);
			//$('#a5').removeAttr('dispaly');
			//$('#a5').css('display','none');
		}else{
			//$('#a5').css('display','none');
			return;
		}
	} 
	
</script>

<div id="jw_header">
	<div class="innerWrap">
		<c:if test="${ frUserInfo ne null }">
		
		<span id="appendText"></span>
		
		<div class="nav_util">
			<div class="txt_welcome">
				<c:if test="${ frUserInfo.emp_grade ne 'C001' }"><span class="flag_general">고객사 일반</span></c:if>
				<c:if test="${ frUserInfo.emp_grade eq 'C001' }"><span class="flag_general2">고객사 대표</span></c:if>
				${ frUserInfo.cust_kor_name }&nbsp;${ frUserInfo.emp_name }님 환영합니다. 
				<!-- <a href="javascript:showHeaderDiv();" type="button" class="colorWhite  mgl20"><img src="/images/front/ico_doc.png" class="valignM mgr5">이용가이드</a>  -->
			</div>
			<ul>
				<li><a href="javascript:showHeaderDiv();" type="button" class="colorWhite  mgl20"><img src="/images/front/ico_doc.png" class="valignM mgr5">이용가이드</a></li>
				<li><a href="/fr/member/form2.do">개인정보수정</a></li>
				<li><a href="javascript:goLogOut();">로그아웃</a></li>
			</ul>
		</div>
		</c:if>
	</div>
</div>

<div id="jw_gnb">
	<div class="innerWrap">
		<h1><a href="/fr/main/list.do">ONTIC CRM</a></h1>
		<ul>
			<li class="gnb01"><a id="a0" href="/fr/as/form.do" class="active">A/S신청</a></li><!-- 활성시 active -->
			<li class="gnb02"><a id="a1" href="/fr/down/list.do">다운로드</a></li>
			<li class="gnb03"><a id="a2" href="/fr/faq/list.do">FAQ</a></li>
			<li class="gnb04"><a id="a3" href="/fr/notice/list.do">공지사항</a></li>
			<c:if test="${ frUserInfo.emp_grade eq 'C001' }"><li class="gnb05"><a id="a4" href="/fr/member/list.do">계정관리</a></li></c:if>
		</ul>
	</div>
</div>

