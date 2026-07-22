<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn"		uri = "http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javascript">
	
	function goLogOut(){
		if(confirm('로그아웃하시겠습니까?')){
			alert('정상적으로 로그아웃되었습니다.') ;
			location.href = '/ad/login/out.do' ; 
		}
	}
	
	
	function judHostname(){
		var hostname = window.location.hostname;
		
		if(hostname == 'localhost' || hostname == '192.168.16.110'){
			console.log(window.location.hostname);
			var a = '<h1 style="font-size:20px;" class="colorRed">*개발용 서버 (테스트)</h1>';
			$('#appendText').append(a);
		}else{
			return;
		}
	} 
	
	$(document).ready(function(){
		
		$(".list8").find("li > a").each(function(){
			if($(this).attr("href").indexOf("/${NOW_PRI}") != -1){
				if(!$(this).hasClass("active")) $(this).addClass("active")
			}else{
				if($(this).hasClass("active")) $(this).removeClass("active")
			}
		}) ; 
		
		$(".list8").find("ul").parent('li').hover(function(){$(this).find("ul").show() ;} , function(){$(".list8").find("ul").hide() ;});
		
		judHostname();
		

	}) ;
	
</script>
<div id="jw_header">
	<div class="innerWrap">
		<h1><a href="<%=session.getAttribute("defaultUrl")%>">ontic crm</a></h1>
		<span id="appendText"></span>
		<div class="nav_util">
			<div class="txt_welcome">
				<c:choose>
					<c:when test="${ adUserInfo.emp_grade eq 'C001' }"><span class="flag_admin">관리자</span></c:when>
					<c:when test="${ adUserInfo.emp_grade eq 'C002' }"><span class="flag_second">내부관리자</span></c:when>
					<c:otherwise><span class="flag_eng">엔지니어</span></c:otherwise>
				</c:choose>
				${ adUserInfo.emp_nm }님 환영합니다.
			</div>
			<ul>
				<li><a href="/ad/member/form3.do">개인정보수정</a></li>
				<li><a href="javascript:goLogOut();">로그아웃</a></li>
			</ul>
		</div>
	</div>
</div>

<div id="jw_gnb">
	<div class="innerWrap">
		<ul class="list8"> ${ MENULIST } </ul>
	</div>
</div>