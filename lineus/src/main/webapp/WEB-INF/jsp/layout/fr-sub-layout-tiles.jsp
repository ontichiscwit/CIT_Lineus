<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="t" %>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!doctype html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<meta http-equiv="Content-Script-Type" content="text/javascript" />
	<meta http-equiv="Content-Style-Type" content="text/css" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=1000" />
	<meta name="apple-mobile-web-app-title" content="jw Connected Care System" />
	<title>ONTIC LineUs 고객사 시스템</title>
	<link rel="shortcut icon" href="/images/ontic_T0U_icon.ico">
	
	<link rel="stylesheet" type="text/css" href="/css/front/jw_front.css" />
	<link rel="stylesheet" type="text/css" href="/css/jquery-ui.css" />
	<link rel="stylesheet" type="text/css" href="/css/front/jquery.bxslider.min.css" />
	
	
	
	<script type="text/javascript" src="/js/jquery.js"></script>
	<script type="text/javascript" src="/js/jquery-ui.min.js"></script>
	<script type="text/javascript" src="/js/jquery.bxslider.min.js"></script>
	<script type="text/javascript" src="/js/jw_common_view.js"></script>
	<script type="text/javascript" src="/js/jw_common_action.js"></script>
	<script type="text/javascript" src="/js/jw_common_ajaxController.js"></script>
	<script type="text/javascript" src="/js/jw_common.js"></script>
	<script type="text/javascript" src="/js/jw_common_layer.js"></script>
	
	<script type="text/javascript">
		$(document).ready(function(){
			var x = location.pathname;
			
			if(x == '/fr/main/list.do' && common.nvl(getCookie("FIRST_FLAG"), '' ) == ''){
				$('#FIRST_CHECK_DIV').show() ; 
				$('#FIRST_CHECK_DIM').show() ;
			}
			
			
			
		}) ; 
		
		
		
		
		function closeShowFirst(){
			$('#FIRST_CHECK_DIV').hide() ; 
			$('#FIRST_CHECK_DIM').hide() ;
		}
		
		
		
		function closeShowContinue() {
			setCookie('FIRST_FLAG','1',3650);
			$('#FIRST_CHECK_DIV').hide() ; 
			$('#FIRST_CHECK_DIM').hide() ; 
		}
		
		function closeWithOutFirst(){
			$('#FIRST_CHECK_DIV').hide() ; 
			$('#FIRST_CHECK_DIM').hide() ; 
		}
		
		function closeWithGuide(){
			$('#FIRST_CHECK_DIV').hide() ; 
			$('#FIRST_CHECK_DIM').hide() ;
			$('#HEADER_DIV').show() ; 
			$('#HEADER_DIM').show() ; 
		}
		
		function showHeaderDiv(){
			$('#HEADER_DIV').show() ; 
			$('#HEADER_DIM').show() ; 
		}
		
		function hideHeaderDiv(){
			$('#HEADER_DIV').hide() ; 
			$('#HEADER_DIM').hide() ; 
		}
	
	</script>
	<style>
	  .resize{
	   height:590px;
	   width:auto;
	   }
	
	</style>
	
</head>

<body>
   	
   	<t:insertAttribute name ="header"/>
   	
   	<t:insertAttribute name ="content"/>
   	<iframe name="hiddenFrame" id="hiddenFrame" style="width:0px;height:0px;display:none;"></iframe>  	   
   	
   	<div id="jw_footer">
   		<t:insertAttribute name ="footer"/>
   	</div>
   	
   	<div class="box_layer layer_help" id="FIRST_CHECK_DIV" style="display:none;">
		<h1 class="tit_back"></h1>
		<div class="layer_contents">
			<div style="display:table;width:100%;">
			    <div style="display:table-cell;width:168px;text-align: center;">
			        <img src="/images/front/user_guide/ico_tit.png" alt="">
			    </div>
			    <div style="display:table-cell;vertical-align:top;">
                    <h1>Welcome</h1>
                    <h3>중외정보기술 고객지원서비스에 오신 것을 환영합니다.</h3>
                    <p>저희 중외정보기술 고객지원 서비스에 오신 것을 환영합니다.<br />
                    저희 중외정보기술 고객지원 서비스인 Ontic LineUs에서는 처음으로 방문하신 고객님들에게,<br />
                    서비스를 쉽게 사용하실 수 있는 <span class="colorRed">사용자도움말</span>을 제공하고 있습니다.</p>
                    <img src="/images/front/user_guide/img0.jpg" alt="">
                    <p class="colorBlue">사용자도움말은 웹페이지 상단 메뉴에 고정으로 노출되어있어 언제든지 활용이 가능합니다.</p>
			        <div class="btn_wrap" style="margin:60px 0 60px 0;">
                        <button type="button" class="btn_ico_save w190 mgr5" onclick="javascript:closeWithGuide();"><span>사용자도움말 바로가기</span></button><button type="button" class="btn_ico_cancel w135" onclick="javascript:closeShowFirst();"><span>다음에 보기</span></button>
                    </div>
                    <div class="floatR">
                        <input type="checkbox" class="mgr10" id="firstCheckFlag" onclick="javascript:closeShowContinue();">다시 보지 않기
                    </div>
			    </div>
			</div>
			<!--// write -->
		</div>
		<button type="button" class="btn_close" onclick="javascript:closeShowFirst();">창 닫기</button>
	</div>
	<div class="layer_dimmed" id="FIRST_CHECK_DIM" style="display:none;"></div>
	
	<div class="box_layer layer_guide" id="HEADER_DIV" style="display:none;margin:-380px 0 0 -470px !important">
	<div class="layer_contents">
		<ol id="guide-tab">
			<li><a data-slide-index="0" href="">둘러보기</a></li>
			<!--<li><a data-slide-index="1" href="">Dashboard</a></li>-->
			<li><a data-slide-index="1" href="">A/S신청하기</a></li>
			<li><a data-slide-index="2" href="">A/S현황보기</a></li>
			<li><a data-slide-index="3" href="">A/S평가하기</a></li>
			<li><a data-slide-index="4" href="">계정관리하기</a></li>
		</ol>
		<ul class="guide-slider">
		    <li class="tab1">
		        <h2 class="tit_guide">둘러보기</h2>
                           <p class="colorBlue" style="margin-top:0px;">A/S신청</p>
		                <img src="/images/front/user_guide/img1-1.jpg" alt="">
                           <p class="mgb30">
                               A/S신청 메뉴는 2개의 탭으로 구성되어 있습니다.<br />
                               <span class="colorRed">'A/S접수정보'</span>탭에서는 시스템 사용 중에 발생하는 오류나 각종 문의사항, 요청사항을 등록하고 처리현황을 조회하실 수 있습니다.<br />
                               <span class="colorRed">'신청등록현황'</span>탭에서는 지금까지 등록하신 A/S건에 대한 이력을 보실 수 있습니다.<br />
                               A/S신청과 이력에 대한 조회는 모바일 버전에서도 제공됩니다.<br />
                               사용하시는 스마트폰이나 태블릿에서 동일한 URL(lineus.cwit.co.kr)로 접근하시면 됩니다.
                           </p>
                           <p class="colorBlue">다운로드</p>
		                <img src="/images/front/user_guide/img1-2.jpg" alt="">
                           <p class="mgb30">
                               중외정보기술에서 제공하는 각종 브로슈어나 기타 유용한 자료를 모아 둔 곳입니다.<br />
                               필요하실 때 다운로드를 받아서 활용하실 수 있습니다.
                           </p>
                           <p class="colorBlue">FAQ</p>
                           <img src="/images/front/user_guide/img1-3.jpg" alt="">
                           <p class="mgb30">
                               FAQ메뉴는 자주 묻는 질문을 모아 둔 곳입니다.<br />
                               자주 발생되는 문의 건에 대해서는 주기적으로 업데이트하고 있으니, A/S등록하시기 전에<br />
                               FAQ에서 한번 찾아보시는 것도 좋은 해결방안이 될 수 있습니다.
                           </p>
                           <p class="colorBlue">공지사항</p>
		                <img src="/images/front/user_guide/img1-4.jpg" alt="">
                           <p class="mgb30">
                               고객님께 전달드릴 공지내용이 등록되는 곳입니다.<br />
                               배포와 관련된 내용도 등록되니 새로운 공지사항은 꼭 읽어주시길 당부드립니다.
                           </p>
                           <p class="colorBlue">계정관리</p>
		                <img src="/images/front/user_guide/img1-5.jpg" alt="">
                           <p class="mgb30">
                               고객님의 계정이 마스터 계정(회원 ID=사업자등록번호)라면 병원 담당자별로 하위 계정을<br />
                               본 메뉴에서 생성하고 관리하실 수 있습니다.<br />
                               하위 계정 고객님의 경우 이 메뉴는 보이지 않습니다.
                           </p>
               </li>
               <li class="tab2">
                   <h2 class="tit_guide">A/S신청하기</h2>
                   <img src="/images/front/user_guide/img3-1.jpg" alt="">
                   <p>Web page에서 A/S를 신청하시려면 A/S 신청 메뉴로 들어가셔서</p>
                   <ul class="list-circle">
                       <li>문의 서비스 정보 선택</li>
                       <li>문의 유형 선택</li>
                       <li>연락받으실 전화번호 선택 - 거래처 생성 시 등록된 번호를 선택하시거나 직접 입력</li>
                       <li>요청 내용 입력과 첨부 파일 추가(선택 입력)</li>
                   </ul>
                   <p>하신 후 <span class="colorRed">[등록]</span>버튼을 누르시면 신청이 완료됩니다.</p>
               </li>
               <li class="tab3">
                   <h2 class="tit_guide">A/S현황보기</h2>
                   <img src="/images/front/user_guide/img4-1.jpg" alt="">
                   <p>A/S신청 메뉴의 '신청 등록 현황' 탭 메뉴로 이동하시면 고객님 병원에서 신청하신 A/S신청 내역과 처리 현황을 보실 수 있습니다.</p>
                   <p class="colorBlue">A/S 요청 철회</p>
                   <!--<p class="small">--><p>신청하신 A/S를 철회하고자 하실 때에는 해당 행의 <span class="colorRed">[철회]</span>버튼을 클릭하시면 됩니다.<br />
                   그러나 중외정보기술의 처리 담당자가 해당 A/S를 업무배정 완료하였을 경우에는 철회가 불가합니다.</p>
                   <p class="colorBlue">상세 정보 조회 및 수정</p>
                   <p><!--<p class="small">-->조회하고자 하시는 A/S의 행을 클릭하시면 상세 정보를 보실 수 있는 팝업이 노출됩니다.</p>
                   <ul class="small"><!--<ul class="small">-->
                       <p>- 처리 정보 Tab : 해당 요청 건의 내용과 현재 진행상태를 보여줍니다. 해당 A/S건이 담당자 업무배정 전 상태라면 요청 내용의 수정이 가능합니다.</p>
                       <p>- 답변 내역 Tab : 해당 요청 관과 관련하여 질의와 답변한 이력을 보여줍니다. 추가 질의를 등록하시거나 삭제하실 수 있습니다.</p>
                   </ul>
                   <img src="/images/front/user_guide/img4-2.jpg" alt="">
               </li>
               <li class="tab4">
                   <h2 class="tit_guide">A/S평가하기</h2>
                   <img src="/images/front/user_guide/img5.jpg" alt="">
                   <p>처리가 완료된 A/S건은 신청 등록 현황 Tab에서 검수 확인 열의 <span class="colorRed">[확인]</span> 버튼이 활성화됩니다. <br />
                   클릭하시면 해당 A/S건에 대한 검수확인/고객평가 팝업이 보여집니다.<br />
                   고객 평가 자료는 향후 서비스 개선을 위한 귀중한 자료로 활용되니, 꼭 평가해주시기 바랍니다.</p>
               </li>
               <li class="tab5">
                   <h2 class="tit_guide">계정관리하기</h2>
                   <img src="/images/front/user_guide/img6-1.jpg" alt="">
                   <p>회원가입을 통해 병원별로 발급되는 마스터 계정(ID=사업자등록번호)로 로그인 시 계정 관리 메뉴에서 하위 계정을 생성하고 관리하실 수 있습니다.</p>
                   <p class="colorBlue">계정 조회 및 수정</p>
                   <p><!--<p class="small">-->조회하거나 수정하시려면 계정의 행을 클릭하시면 상세페이지로 이동합니다.<br />
                   <span class="colorRed">※</span> 하위 관리자의 퇴사 등 인력 변동이 일어날 경우 외부 인력의 무단 사용을 방지하기 위해 반드시 해당 계정의 상태값을 비워주셔야 합니다.</p>
                   <p class="colorBlue">계정 추가</p>
                   <p><!--<p class="small">-->목록 페이지에서 <span class="colorRed">[계정추가]</span>버튼을 클릭하면 계정 추가 화면으로 이동합니다.<br />
                   계정 추가는 마스터 계정이 아닌 하위 계정만 생성이 가능하며, 생성 즉시 로그인이 가능합니다.<br />
                   직책과 이메일을 제외한 나머지 항목은 모두 필수입력사항입니다.</p>
                   <img src="/images/front/user_guide/img6-2.jpg">
               </li>
		</ul>
	</div>
	<button type="button" class="btn_close" onclick="javascript:hideHeaderDiv();">창 닫기</button>
</div>
<div class="layer_dimmed" id="HEADER_DIM" style="display:none;" onclick="javascript:hideHeaderDiv();"></div>



<script>
	$(function(){
		$('.guide-slider').bxSlider({
               slideWidth: 534,
               pagerCustom: '#guide-tab',
               infiniteLoop: false,
               hideControlOnEnd: true,
               touchEnabled: false
		});
	})
</script>
	   	
</body>
</html>
