<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
	
	
<script type="text/javascript">


$(document).ready(function(){
	
	window.GitpleConfig = {
	  appCode: 'QH0ckhB8DATqawrRjmwM4fLIzxfXio2j' // 워크스페이스 > 서비스 설정 > 일반 에서 앱코드 복사
	};

	!function(){function e(){function e(){var e=t.contentDocument,a=e.createElement("script");
	a.type="text/javascript"
	,a.async=!0,a.src=window[n]&&window[n].url?window[n].url+"/inapp-web/gitple-loader.js":"https://app.gitple.io/inapp-web/gitple-loader.js",a.charset="UTF-8",e.head&&e.head.appendChild(a)}var t=document.getElementById(a);t||((t=document.createElement("iframe")).id=a,t.style.display="none",t.style.width="0",t.style.height="0",t.addEventListener?t.addEventListener("load",e,!1):t.attachEvent?t.attachEvent("onload",e):t.onload=e,document.body.appendChild(t))}var t=window,n="GitpleConfig",a="gitple-loader-frame";if(!window.Gitple){document;var i=function(){i.ex&&i.ex(arguments)};i.q=[],i.ex=function(e){i.processApi?i.processApi.apply(void 0,e):i.q&&i.q.push(e)},window.Gitple=i,t.attachEvent?t.attachEvent("onload",e):t.addEventListener("load",e,!1)}}();

	Gitple('boot', {
		  id: '${ frUserInfo.emp_id}', // [필수] 상담고객 식별 ID
		  name: '${ frUserInfo.emp_name}',
		  email: '${ frUserInfo.email}',
		  phone: '${ frUserInfo.tel_no}',
		  meta: {      // [선택] 아래 세부 정보 참고
		    'CUST_NAME': '${ frUserInfo.cust_kor_name}',
		    'CRM_CODE': '${ frUserInfo.cust_code}',
		   
		  }
		});
	 
});


</script>



<style>
	.nType_line{border:2px solid #c9d7dc;padding:20px;background-color:#f3fdff}
	.nType_line td{color:#008fc8; font-weight:700}
	
</style>

<div id="jw_contents">
	<div class="tit_wrap">
		<h2 class="tit_ico_chat">채팅상담 서비스<span class="txt_tit_right">온라인 채팅을 통해 궁금하신 점을 상담해보세요.</span></h2> 
		<div class="location">
			<a href="/fr/main/list.do" class="home">Home</a>
			<a href="/fr/chatting/form.do" class="depth"><span class="here">채팅상담 서비스</span></a>
		</div>
	</div>
	<form name="procFrm" id="procFrm" method="post" enctype="multipart/form-data" onsubmit="return false;">
		<table class="nType_line mgb40">
			<caption>소개</caption>
			<tr>
				<td>
					ONTIC LineUs에서 제공하는 채팅상담기능은 챗봇(Chatbot)기반의 인공지능형 고객 응대 서비스입니다.
					FAQ안내봇, 상담안내봇, 상담접수봇 등의 비대면 챗봇과 상담 도우미봇을 통해서 고객 상담의 만족도를 높여줍니다.
				</td>
				
			</tr>
			
		</table>
		<div class="tit_sWrap">
			<h3 class="tit_bold_gray">채팅상담기능을 이용하시면</h3>
		</div>
		<div class="terms_agree">
			<span style="font-size:14px;margin-bottom:5px;">- 시간,장소에 상관없이 언제 어디서든 문의하실 수 있습니다.</span><br>
			<span style="font-size:14px;margin-bottom:5px;">- 사용 중이신 LineUs 시스템에서 이탈하지 않고, 현재 시스템 내에서 모든 질의와 응답이 이루어집니다.</span><br>
			<span style="font-size:14px;margin-bottom:5px;">- 상담에 필요한 과거 문의 내용, 상황 등에 대해서 새롭게 설명하지 않으셔도 됩니다.</span><br>
			<span style="font-size:14px;margin-bottom:5px;">- A/S 신청이나 전화로 상담하기 예민한 문제에 대해 부담없이 질문하실 수 있습니다.</span><br>
		</div>
		<div class="terms_agree">
			<div class="tit_sWrap">
				<h3 class="tit_bold_gray" style="font-size:14px;">화면 우측 하단 위젯 버튼  &nbsp
				<img src="/images/front/icon_chat_02.png" class="valignM mgr5">을 눌러 궁금하신 내용에 대해 상담을 진행해보세요.</h3>
			</div>
			<span style="color:#ff4900">Note] 현재 시범서비스 중으로 일부 기능은 제공되지 않을 수 있습니다.</span>
		</div>
		<div class="gb10">
			<img src="/images/front/img_chat.png" class="valignM mgr5">
		</div>
	</form>
</div>