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
			
			//팝업 화면 테스트용
			/*
			 if(x == '/fr/main/list.do'){
				$('#FIRST_CHECK_DIV').show() ; 
				$('#FIRST_CHECK_DIM').show() ;
				//$('#CIT_MOVE2_DIV').show() ;
				$('#RENEWAL_CHECK_DIV').show() ;
			}    
			*/
			/*
			
			 if(x == '/fr/main/list.do'){
				$('#CHATBOTGUIDE_CHECK_DIV').show() ;
				$('#FIRST_CHECK_DIV').show() ; 
			}   
			*/
			
			
			/*
 			if(x == '/fr/main/list.do' && common.nvl(getCookie("CIT_MOVE2_FLAG"), '') == ''){
				$('#CIT_MOVE2_DIV').show() ;
			} */
			
			   if(x == '/fr/main/list.do' && common.nvl(getCookie("FIRST_FLAG"), '' ) == ''){
				$('#FIRST_CHECK_DIV').show() ;
				$('#FIRST_CHECK_DIM').show() ;
			}

			
			   if(x == '/fr/main/list.do' && common.nvl(getCookie("REINQUIRY_FLAG"), '' ) == ''){
					$('#REINQUIRY_CHECK_DIV').show() ;
					$('#REINQUIRY_CHECK_DIM').show() ;
				}
			   /*
			   if(x == '/fr/main/list.do' && common.nvl(getCookie("RENEWAL_FLAG"), '' ) == ''){
					$('#RENEWAL_CHECK_DIV').show() ; 
					$('#RENEWAL_CHECK_DIM').show() ;
				*/
				
			   if(x == '/fr/main/list.do' && common.nvl(getCookie("CHATBOTGUIDE_FLAG"), '' ) == ''){
				   $('#CHATBOTGUIDE_CHECK_DIV').show() ;
				}
				
			   if(x == '/fr/main/list.do' && common.nvl(getCookie("PAUSESERVICE_FLAG2"), '' ) == ''){
				   $('#PAUSESERVICE_CHECK_DIV2').show() ;
				}
				
			 
		}) ;  
		
		function closeShowFirst(){
			$('#FIRST_CHECK_DIV').hide() ; 
			$('#FIRST_CHECK_DIM').hide() ;
		}
		
		function closeShowWork(){
			$('#WORK_CHECK_DIV').hide() ; 
			$('#WORK_CHECK_DIM').hide() ;
		}
		
		function closeShowReinquiry(){
			$('#REINQUIRY_CHECK_DIV').hide() ; 
			$('#REINQUIRY_CHECK_DIM').hide() ;
		}
		
		function closeShowRenewal(){
			$('#RENEWAL_CHECK_DIV').hide() ; 
			$('#RENEWAL_CHECK_DIM').hide() ;
		}
		
		function closeShowRenewal2(){
			$('#RENEWAL_CHECK_DIV2').hide() ; 
			$('#RENEWAL_CHECK_DIM2').hide() ;
		}
		
		function closeShowFirstCit(){
			$('#CIT_MOVE2_DIV').hide() ;
		}
		
		function closeShowFirstChatbot(){
			$('#CHATBOTGUIDE_CHECK_DIV').hide() ;
		}
		
		function closeShowPauseService2(){
			$('#PAUSESERVICE_CHECK_DIV2').hide() ; 
		}
		
		function closeShowContinue() {
			setCookie('FIRST_FLAG','1',3650);
			$('#FIRST_CHECK_DIV').hide() ; 
			$('#FIRST_CHECK_DIM').hide() ; 
		}
		
		function closeShowWorkContinue() {
			setCookie('WORK_FLAG','1',3650);
			$('#WORK_CHECK_DIV').hide() ; 
			$('#WORK_CHECK_DIM').hide() ; 
		}
		
		function closeShowContinueReinquiry() {
			setCookie('REINQUIRY_FLAG','1',3650);
			$('#REINQUIRY_CHECK_DIV').hide() ; 
			$('#REINQUIRY_CHECK_DIM').hide() ; 
		}
		
		function closeShowContinueChatbotguide() {
			setCookie('CHATBOTGUIDE_FLAG','1',1);
			$('#CHATBOTGUIDE_CHECK_DIV').hide() ; 
		}
		
		function closeShowContinueCit() {
			setCookie('CIT_MOVE2_FLAG','1',7);
			$('#CIT_MOVE2_DIV').hide() ; 
		}
		
		function closeShowContinuePauseService2() {
			setCookie('PAUSESERVICE_FLAG2','1',1);
			$('#PAUSESERVICE_CHECK_DIV2').hide() ; 
		}
		
		function closeWithOutFirst(){
			$('#FIRST_CHECK_DIV').hide() ; 
			$('#FIRST_CHECK_DIM').hide() ; 
		}
		
		function closeWithOutWork(){
			$('#WORK_CHECK_DIV').hide() ; 
			$('#WORK_CHECK_DIM').hide() ; 
		}
		
		function closeWithOutReinquiry(){
			$('#REINQUIRY_CHECK_DIV').hide() ; 
			$('#REINQUIRY_CHECK_DIM').hide() ; 
		}
		
		function closeWithOutRenewal(){
			$('#RENEWAL_CHECK_DIV').hide() ; 
			$('#RENEWAL_CHECK_DIM').hide() ; 
		}
		
		function closeWithOutFirstCit(){
			$('#CIT_MOVE2_DIV').hide() ; 
		}
		
		function closeWithGuide(){
			$('#FIRST_CHECK_DIV').hide() ; 
			$('#FIRST_CHECK_DIM').hide() ;
			$('#RENEWAL_CHECK_DIV').hide() ; 
			$('#RENEWAL_CHECK_DIM').hide() ;
			$('#CIT_MOVE2_DIV').hide() ;
			$('#HEADER_DIV').show() ; 
			$('#HEADER_DIM').show() ; 
		}
		
		function closeWithRenewalGuide(){
			$('#RENEWAL_CHECK_DIV').hide() ; 
			$('#RENEWAL_CHECK_DIM').hide() ;
			$('#FIRST_CHECK_DIV').hide() ; 
			$('#FIRST_CHECK_DIM').hide() ;
			$('#CIT_MOVE2_DIV').hide() ;
			$('#RENEWAL_DIV').show() ; 
			$('#RENEWAL_DIM').show() ; 
		}
		
		function showHeaderDiv(){
			$('#HEADER_DIV').show() ; 
			$('#HEADER_DIM').show() ; 
		}
		
		function hideHeaderDiv(){
			$('#HEADER_DIV').hide() ; 
			$('#HEADER_DIM').hide() ; 
		}
		
		function showRenewalDiv(){
			$('#RENEWAL_DIV').show() ; 
			$('#RENEWAL_DIM').show() ; 
		}
		
		function hideRenewalDiv(){
			$('#RENEWAL_DIV').hide() ; 
			$('#RENEWAL_DIM').hide() ; 
		}
	
	</script>
	
	<!-- 기존 코드 head 안에 추가 
	<script src="https://polyfill.io/v3/polyfill.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/@hackler/javascript-sdk@11.21.0/lib/index.browser.umd.min.js"></script>
	<script>
		var hostname = window.location.hostname;
		var SDK_KEY = "mcL5ZZJlMrMzDr3BhhJoyxinoxJoTAQs"
		if(hostname == 'localhost' || hostname == '192.168.16.110' || hostname == '192.168.20.46'){ //핵클 관련
			SDK_KEY = "Cp9oSu8Zvqs7QuPSn1ozwS33MfbJdWiC"
		}
		
		var emp_id = "${frUserInfo.emp_id}";
		var cust_code = "${frUserInfo.cust_code}";
		var user = {
			userId: emp_id,
			identifiers: {
			  cust_code: cust_code
		  	}
		  };
		  
		  window.hackleClient = Hackle.createInstance(SDK_KEY, { user: user });
	</script>
	-->
</head>

<body>
   	
   	<t:insertAttribute name ="header"/>
   	
   	<t:insertAttribute name ="content"/>
   	<iframe name="hiddenFrame" id="hiddenFrame" style="width:0px;height:0px;display:none;"></iframe>  	   
   	
   	<div id="jw_footer">
   		<t:insertAttribute name ="footer"/>
   	</div>
   	
   	<!-- 처음 이용 시 안내 팝업    -->
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
	
   	<!-- 시스템 작업 안내 팝업 -->
<div class="box_layer layer_help" id="WORK_CHECK_DIV" style="display:none;">
    <h1 class="tit_back">시스템 교체 작업</h1>
    <div class="layer_contents">
        <div style="padding:10px 30px 20px;">

            <!-- 상단 인사/안내 -->
            <p style="font-size:18px;color:#222;line-height:1.7;margin-bottom:24px;">
                안녕하세요. <strong>중외정보기술</strong>입니다.<br />
                시스템 교체작업으로 인하여 <strong style="color:#0a84d1;">LineUs 접속이 불가</strong>하여 안내드립니다.
            </p>

            <!-- 작업 정보 박스 -->
            <table style="width:100%;border-collapse:collapse;font-size:16px;color:#333;margin-bottom:22px;">
                <tbody>
                    <tr>
                        <th style="width:110px;text-align:left;padding:13px 16px;background:#f5f7fa;border:1px solid #e3e7ec;font-weight:600;white-space:nowrap;">작업내용</th>
                        <td style="padding:13px 16px;border:1px solid #e3e7ec;">시스템 교체 (Lineus 거래처공지 30672)</td>
                    </tr>
                    <tr>
                        <th style="text-align:left;padding:13px 16px;background:#f5f7fa;border:1px solid #e3e7ec;font-weight:600;white-space:nowrap;">작업영향</th>
                        <td style="padding:13px 16px;border:1px solid #e3e7ec;">LineUs 사이트 접속 불가</td>
                    </tr>
                    <tr>
                        <th style="text-align:left;padding:13px 16px;background:#f5f7fa;border:1px solid #e3e7ec;font-weight:600;white-space:nowrap;">작업일시</th>
                        <td style="padding:13px 16px;border:1px solid #e3e7ec;">
                            <strong style="color:#d9342b;">2026-06-28(일) 08:00 ~ 14:00</strong>
                            <span style="color:#888;">(6시간)</span>
                        </td>
                    </tr>
                </tbody>
            </table>

            <!-- 문의처 -->
            <div style="margin-bottom:22px;">
                <p style="font-size:16px;font-weight:600;color:#222;margin-bottom:10px;">문의 전화</p>
                <ul style="list-style:none;padding:0;margin:0;font-size:16px;color:#333;line-height:2;">
                    <li><strong style="color:#0a84d1;">010-9163-9941</strong> &nbsp;조상욱 &middot; CS본부장</li>
                    <li><strong style="color:#0a84d1;">010-6489-5268</strong> &nbsp;이용준 &middot; CS본부 병원S&amp;C팀장</li>
                    <li><strong style="color:#0a84d1;">010-2488-0404</strong> &nbsp;박창선 &middot; DO본부 HIS기술지원팀장</li>
                </ul>
            </div>

            <!-- 응급 안내 -->
            <p style="font-size:15px;color:#d9342b;background:#fdf2f1;border:1px solid #f5cfcb;border-radius:4px;padding:13px 16px;margin-bottom:0;">
                ※ 응급상황 발생 시 위 문의전화 연락처로 전화 부탁드립니다.
            </p>

            <!-- 다시 보지 않기 -->
            <div class="floatR" style="margin-top:18px;font-size:15px;">
                <input type="checkbox" class="mgr10" id="WorkCheckFlag" onclick="javascript:closeShowWorkContinue();">다시 보지 않기
            </div>

        </div>
    </div>
    <button type="button" class="btn_close" onclick="javascript:closeShowWork();">창 닫기</button>
</div>
	
	<!-- 재문의 변경 안내 팝업  -->
	<div class="box_layer layer_help" id="REINQUIRY_CHECK_DIV" style="display:none;">
	    <h1 class="tit_back">A/S 관련 공지 사항</h1>
	   <!--<div class="layer_contents"> -->
	        
	            <div style="width:100%;">
	                <img src="/images/front/user_guide/Reinquiry_guide.png" alt="" style="width:100%; height:100%; object-fit:cover;">
	            </div>
	            <div class="floatR">
	                <input type="checkbox" class="mgr10" id="ReinquiryCheckFlag" onclick="javascript:closeShowContinueReinquiry();">다시 보지 않기
	            </div>
	        
	        <!--// write -->
	    <!--</div> -->
	    <button type="button" class="btn_close" onclick="javascript:closeShowReinquiry();">창 닫기</button>
	</div>
	
	<!-- 본사 이전 안내 팝업    -->
	<div class="box_layer layer_help" id="CIT_MOVE2_DIV" style="display:none;">
	    <h1 class="tit_back">시스템 공지 사항</h1>
	   <!--<div class="layer_contents"> -->
	        
	            <div style="width:100%;">
	                <img src="/images/front/user_guide/CIT_MOVE2.jpg" alt="" style="width:100%; height:100%; object-fit:cover;">
	            </div>
	            <!-- <div class="floatR">
	                <input type="checkbox" class="mgr10" id="firstCheckFlag" onclick="javascript:closeShowContinueCit();">일주일 보지 않기
	            </div>
	        
	        <!--// write -->
	    <!--</div> -->
	    <button type="button" class="btn_close" onclick="javascript:closeShowFirstChatbot();">창 닫기</button>
	</div>
	
	<!-- 리뉴얼 안내 팝업    -->
	<div class="box_layer layer_help" id="RENEWAL_CHECK_DIV" style="display:none;">
		<h1 class="tit_back"></h1>
		<div class="layer_contents">
			<div style="display:table;width:100%;">
			    <div style="display:table-cell;width:168px;text-align: center;">
			        <img src="/images/front/user_guide/renewal_new.png" alt="">
			    </div>
			    <div style="display:table-cell;vertical-align:top;">
                    <h1>Renewal OPEN</h1>
                    <h3 style="margin-bottom: 0;">라인어스를 새롭게 단장하여 오픈합니다.</h3>
               		<p style="font-size: 16px; letter-spacing: 0.2px; font-weight: 705; margin-bottom : 10px;">
					        중외정보기술은 고객님께 더 나은 서비스를 제공하기 위해 끊임없이 발전하겠습니다.
					</p>
					<br>
					<p style="font-size: 16px; letter-spacing: 0.2px; font-weight: 705;">
					        1.<span class="colorRed">통합검색창</span>으로 전체 정보검색이 쉬워졌습니다.
					</p>
					<p style="font-size: 14px; letter-spacing: 0.2px; font-weight: 600;">
					    &nbsp;&nbsp;&nbsp;- 제목과 내용이 함께 조회됩니다.
					</p>
					<br>
					<p style="font-size: 16px; letter-spacing: 0.2px; font-weight: 705;">
					        2.꼭 필요한 정보들을 <span class="colorRed">한눈에 확인</span>하기 쉽습니다.
					</p>
					<p style="font-size: 14px; letter-spacing: 0.2px; font-weight: 600;">
					    &nbsp;&nbsp;&nbsp;- A/S현황, 공지사항, 상담사례 등 한 눈에 확인할 수 있습니다.
					</p>
					<br>
					<p style="font-size: 16px; letter-spacing: 0.2px; font-weight: 705;">
					        3.A/S 신청 시  <span class="colorRed">작성요령</span>을 참고해주세요.
					</p>
					<p style="font-size: 14px; letter-spacing: 0.2px; font-weight: 600;">
					    &nbsp;&nbsp;&nbsp;- "안돼요","오류나요"라는 표현은 문제를 해결하는데에 확인절차가 한번 더 필요합니다.
					</p>
					<p style="font-size: 14px; letter-spacing: 0.2px; font-weight: 600;">
					    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;작성요령을 참고하여 문의를 올려주시면 보다 빠른 확인이 가능하니 참고해보세요.
					</p>
					<br>
					<p style="font-size: 16px; letter-spacing: 0.2px; font-weight: 705;">
					        4.도움이 된 사례에  <span class="colorRed">♥</span>좋아요 표시를 해주세요.
					</p>
					<p style="font-size: 14px; letter-spacing: 0.2px; font-weight: 600;">
					    &nbsp;&nbsp;&nbsp;- 타병원의 상담사례를 공유해드립니다. ♥좋아요 버튼으로 표현을 해주시면
					</p>
					<p style="font-size: 14px; letter-spacing: 0.2px; font-weight: 600;">
					    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;더 유용한 사례를 만드는데에 도움이 됩니다.
					</p>
			        <div class="btn_wrap" style="margin:30px 0 0 0;">
                        <button type="button" class="btn_ico_save w190 mgr5" onclick="javascript:closeWithRenewalGuide();"><span>리뉴얼 구경하러가기</span></button>
                    </div>
                    <div class="floatR">
                        <input type="checkbox" class="mgr10" id="RenewalCheckFlag" onclick="javascript:closeShowContinueRenewal();"><strong>오늘하루보지않기</strong>
                    </div>
			    </div>
			</div>
			<!--// write -->
		</div>
		<button type="button" class="btn_close" onclick="javascript:closeShowRenewal();">창 닫기</button>
	</div>
	
	<!-- 전기안전점검에 따른 서비스 일시 중단 안내-->
	<div class="box_layer layer_help" id="PAUSESERVICE_CHECK_DIV2" style="display:none;">
	    <h1 class="tit_back"></h1>
        <div style="width:100%;">
            <img src="/images/front/user_guide/pauseserivce2.png" alt="" style="width:100%; height:586px;">
             <div style="position:absolute; top:610px; right:10px;">
		        <input type="checkbox" id="PauseServiceFlag" onclick="javascript:closeShowContinuePauseService2();">
		        <strong>오늘하루보지않기</strong>
		    </div>
        </div>
	    <button type="button" class="btn_close" onclick="javascript:closeShowPauseService2();">창 닫기</button>
	</div>
	
	
	
	
	<div class="layer_dimmed" id="FIRST_CHECK_DIM" style="display:none;"></div>
	
	<div class="box_layer layer_guide" id="HEADER_DIV" style="display:none;margin:-380px 0 0 -470px !important">
	<div class="layer_contents">
		<ol id="guide-tab">
			<li><a data-slide-index="0" href="">둘러보기</a></li>
			<li><a data-slide-index="1" href="">A/S신청하기</a></li>
			<li><a data-slide-index="2" href="">A/S현황보기</a></li>
			<li><a data-slide-index="3" href="">A/S평가하기</a></li>
			<li><a data-slide-index="4" href="">계정관리하기</a></li>
		</ol>
		<ul class="guide-slider">
		    <li class="tab1">
		        <h2 class="tit_guide">둘러보기</h2>
                           <p class="colorBlue" style="margin-top:0px;">A/S신청</p>
		                <img src="/images/front/user_guide/img1-1.png" alt="">
                           <p class="mgb30">
                               A/S신청 메뉴는 2개의 탭으로 구성되어 있습니다.<br />
                               <span class="colorRed">'A/S접수정보'</span>탭에서는 시스템 사용 중에 발생하는 오류나 각종 문의사항, 요청사항을 등록하고 처리현황을 조회하실 수 있습니다.<br />
                               <span class="colorRed">'신청등록현황'</span>탭에서는 지금까지 등록하신 A/S건에 대한 이력을 보실 수 있습니다.<br />
                               A/S신청과 이력에 대한 조회는 모바일 버전에서도 제공됩니다.<br />
                               사용하시는 스마트폰이나 태블릿에서 동일한 URL(lineus.cwit.co.kr)로 접근하시면 됩니다.
                           </p>
                           <p class="colorBlue">다운로드</p>
		                <img src="/images/front/user_guide/img1-2.png" alt="">
                           <p class="mgb30">
                               중외정보기술에서 제공하는 각종 브로슈어나 기타 유용한 자료를 모아 둔 곳입니다.<br />
                               필요하실 때 다운로드를 받아서 활용하실 수 있습니다.
                           </p>
                           <p class="colorBlue">상담사례</p>
                           <img src="/images/front/user_guide/img1-3.png" alt="">
                           <p class="mgb30">
                               상담사례 메뉴는 자주 묻는 질문을 모아 둔 곳입니다.<br />
                               자주 발생되는 문의 건에 대해서는 주기적으로 업데이트하고 있으니, A/S등록하시기 전에<br />
                               상담사례에서 한번 찾아보시는 것도 좋은 해결방안이 될 수 있습니다.
                           </p>
                           <p class="colorBlue">공지사항</p>
		                <img src="/images/front/user_guide/img1-4.png" alt="">
                           <p class="mgb30">
                               고객님께 전달드릴 공지내용이 등록되는 곳입니다.<br />
                               배포와 관련된 내용도 등록되니 새로운 공지사항은 꼭 읽어주시길 당부드립니다.
                           </p>
                           <p class="colorBlue">계정관리</p>
		                <img src="/images/front/user_guide/img1-5.png" alt="">
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





	<div class="box_layer layer_guide2" id="RENEWAL_DIV" style="display:none;margin:-380px 0 0 -470px !important">
	<div class="layer_contents">
		<ol id="guide-tab2">
			<li><a data-slide-index="0" href="">통합검색창</a></li>
			<li><a data-slide-index="1" href="">한눈에 확인하기</a></li>
			<li><a data-slide-index="2" href="">A/S작성요령</a></li>
			<li><a data-slide-index="3" href="">좋아요</a></li>
		</ol>
		<ul class="guide-slider2">
		    <li class="tab7">
		        <h2 class="tit_guide2">통합검색창</h2>
		        
		        	<p style="font-size: 14px; letter-spacing: 0.3px; font-weight: 800;">
					       제목과 내용이 함께 조회되며 각 카테고리별로 찾고자 하는 정보를 찾아보세요.
					</p>
					<br>
		                <img src="/images/front/user_guide/renewal_search.png" alt="" style="width: 534px; height: 450px !important;">
               </li>
               <li class="tab8">
                   <h2 style="font-family:'Noto Sans KR';font-size:30px;margin-bottom:20px;">한눈에 확인하기</h2>
                   
                   <p style="font-size: 14px; letter-spacing: 0.3px; font-weight: 800; color:#0090c8;">
					    1.A/S 신청 현황
				   </p>
                   <p style="font-size: 14px; letter-spacing: 0.3px; font-weight: 800;">
					    &nbsp;&nbsp;"내가 무슨 내용을 올렸었지?" 이제는 한눈에 바로 확인해보세요.
					</p>
                   <img src="/images/front/user_guide/renewal_onesee1.jpg" alt="">
                   <br>
                   <p style="font-size: 14px; letter-spacing: 0.3px; font-weight: 800; color:#0090c8;">
					    2.중요공지사항
				   </p>
                   <p style="font-size: 14px; letter-spacing: 0.3px; font-weight: 800;">
					    &nbsp;&nbsp;중요한 공지사항은 상단에 붉은글씨로 표현됩니다. 잊지말고 꼭 확인해주세요.
					</p>
                   <img src="/images/front/user_guide/renewal_onesee2.png" alt="" class="notice-image">
                   <br>
                   <p style="font-size: 14px; letter-spacing: 0.3px; font-weight: 800; color:#0090c8;">
					    3.상담사례
				   </p>
                   <p style="font-size: 14px; letter-spacing: 0.3px; font-weight: 800;">
					    &nbsp;&nbsp;1)나의 질문과 유사한 타병원 상담사례를 활용하여 신속하게 해결해보세요.
					</p>
					<p style="font-size: 14px; letter-spacing: 0.3px; font-weight: 800;">
					    &nbsp;&nbsp;2)타병원은 어떤 사례를 많이 조회해봤을지 조회수가 많은 사례순으로 확인해보세요.
					</p>
                   <img src="/images/front/user_guide/renewal_onesee3.png" alt="">
                   
               </li>
               <li class="tab9">
                   <h2 style="font-family:'Noto Sans KR';font-size:30px;margin-bottom:20px;">A/S작성요령</h2>
                   <p style="font-size: 14px; letter-spacing: 0.3px; font-weight: 800;">
					    "안돼요","오류나요" 라는 표현은 문제를 해결하는데에 확인 절차가 한번 더 필요해요.
					</p>
					<p style="font-size: 14px; letter-spacing: 0.3px; font-weight: 800;">
					    작성요령을 참고하여 문의를 올려주시면 보다 빠른 확인이 가능하니 참고해 보세요 :)
					</p>
                   <img src="/images/front/user_guide/renewal_writetip.png" alt="">
               </li>
               <li class="tab10">
                   <h2 style="font-family:'Noto Sans KR';font-size:30px;margin-bottom:20px;">좋아요</h2>
                   <br><br><br>
                   <p style="font-size: 14px; letter-spacing: 0.3px; font-weight: 800;">
					    타병원의 상담사례를 공유해드립니다. 도움이 된 상담사례에 '♥좋아요'를 눌러주세요.
					</p>
					<p style="font-size: 14px; letter-spacing: 0.3px; font-weight: 800;">
					    ♥좋아요 버튼으로 표현을 해주시면 더 유용한 사례를 만드는데에 도움이 됩니다.
					</p>
					<br><br><br>
                   <img src="/images/front/user_guide/renewal_like.png" alt="">
               </li>
		</ul>
	</div>
	<button type="button" class="btn_close" onclick="javascript:hideRenewalDiv();">창 닫기</button>
</div>
<div class="layer_dimmed" id="RENEWAL_DIM" style="display:none;" onclick="javascript:hideRenewalDiv();"></div>

<script>
	$(function(){
		$('.guide-slider').bxSlider({
               slideWidth: 534,
               pagerCustom: '#guide-tab',
               infiniteLoop: false,
               hideControlOnEnd: true,
               touchEnabled: false
		});
		
		$('.guide-slider2').bxSlider({
            slideWidth: 534,
            pagerCustom: '#guide-tab2',
            infiniteLoop: false,
            hideControlOnEnd: true,
            touchEnabled: false
		});
	})
</script>
	   	
</body>
</html>
