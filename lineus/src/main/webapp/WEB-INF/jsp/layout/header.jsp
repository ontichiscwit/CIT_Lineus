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
	
	function getAsAlarm(){
		common.ajaxCall(null, '/ad/main/getAsAlarm.do', 'setAsAlarm') ;
		//setTimeout(function(){getAsAlarm();},600000);
	}
	
	function setAsAlarm(data){
		var data = typeof data.resultList != "undefined" ? data.resultList : null ;
		if(data == null){ return;}
		var str = '';
		
	}
	
	
	
	$(document).ready(function(){
		
		$(".list6").find("li > a").each(function(){
			if($(this).attr("href").indexOf("/${NOW_PRI}") != -1){
				if(!$(this).hasClass("active")) $(this).addClass("active")
			}else{
				if($(this).hasClass("active")) $(this).removeClass("active")
			}
		}) ; 
		
		$(".list6").find("ul").parent('li').hover(function(){$(this).find("ul").show() ;} , function(){$(".list6").find("ul").hide() ;});
		
		judHostname();
		
		
		//getAsAlarm(); 

	}) ;
	
</script>
<div id="jw_header">
	<div class="innerWrap">
		<h1><a href="<%=session.getAttribute("defaultUrl")%>">ontic crm</a></h1>
		<span id="appendText"></span>
		<div class="nav_util">
			<div class="txt_welcome">
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
		<ul class="list6"> ${ MENULIST } </ul>
	</div>
</div>

<!-- <div id="modal_div">
	<p class="up-title">UPCOMING PLAN</p>
	<ul class="up-plan">
      <li><div class="roundhead"></div>Discuss with Adrian Begi<div class="secondo">Call Adrian at the right dddddddddddddfffffffffffftime</div></li>
      <li><div class="roundhead"></div>Video calling with Boss<div class="secondo">I hate but have to talk with my ceo</div></li>
      <li><div class="roundhead"></div>UEFA Champions League Final<div class="secondo">Real Madrid vs Juventus</div></li>
   </ul>
</div> -->

<style>
#modal_div{
	width:280px; 
	height:auto; 
	background-color:white;
	position:absolute;
	z-index:10;
	box-shadow: 0px 6px 8px 2px rgba(0, 0, 0, 0.03);
}
.up-title{
    padding: 10px 15px;
    margin: 0;
    font-size: 12px;
    color: rgba(0, 0, 0, 0.5);
    font-weight: 600;
}
.up-plan{
	list-style: none;
    margin: 0;
    padding: 5px 15px;
}
.up-plan li {
    position: relative;
    font-size: 13px;
    padding: 8px 0px;
    height :80px;
    border-bottom: 1px solid red;
}
.roundhead {
    width: 55px;
    height: 55px;
    float: left;
    margin: 10px;
    text-align: center;
}
</style>
