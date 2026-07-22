<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>


<style>
.gnb01 a {
    cursor: pointer;
}
</style>


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
		
		
		var ua = navigator.userAgent;
	    var isIE = ua.indexOf("MSIE") > -1 || ua.indexOf("Trident") > -1;

	    if (!isIE) { // IE 제외
		// cust_code 가져오기
		var custCode = "${ frUserInfo.cust_code }";
		// cust_kor_name 가져오기
		var custKorname = "${ frUserInfo.cust_kor_name }";
		
		var currentUrl = window.location.href;

		// URL에 파라미터 붙이기
		var url = "https://ai.cwit.co.kr/his_beta?cust_code=" + encodeURIComponent(custCode)
          + "&cust_kor_name=" + encodeURIComponent(custKorname)
          + "&return_url=" + encodeURIComponent(currentUrl);

		// iframe src 설정
		$("#chatbotAiFrame").attr("src", url);
		}
		
		
		
		
        
        
        /*라인어스와 연동(챗봇 사이트에 기입)
     	// "만족","불만족" 선택 시(id가 두개 다를 것으로 생각되어서 아래와 같은 형태로 두개 만드신 후 id값만 조정해주세요^^)
        document.getElementById("btncloseChatbot").addEventListener("click", function() {
            window.parent.postMessage(
                { action: "closeChatbot" },
                "https://lineusadmin.cwit.co.kr" //테스트 시 : "http://192.168.20.46:8080"
            );
        });

        // "AS직접신청" 선택 시 (임시로 id값을 입력하였으니 만들어주실 버튼 id 기입해주세요^^)
        document.getElementById("btngoAsForm").addEventListener("click", function() {
            const content = "챗봇 대화 요약"; // 요청내용 요약 부분 기입해주세요
            const url = "/fr/as/form.do?call_content=" + encodeURIComponent(content);

            window.parent.postMessage(
                { action: "goAsForm", menuUrl: url },
                "https://lineusadmin.cwit.co.kr" //테스트 시 : "http://192.168.20.46:8080"
            );
        });
        */
        
        
        
        
		
	}) ;
	
	
	/*챗봇 사이트와 연동(라인어스에 기입)*/
    window.addEventListener("message", function(event) {
    if (event.origin !== "https://ai.cwit.co.kr") {
        return;
    }

    if (event.data.action === "closeChatbot") {
        $('#div_dim').hide();
        document.getElementById("OPEN_CHATBOT_AI_DIV").style.display = "none";
    }
    else if (event.data.action === "goAsForm") {
        window.location.href = event.data.menuUrl;
    }
});
    
	
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
	
	function openChatbotWindow() {
	    // 창이 이미 열려 있다면 해당 창에 포커스
	    if (chatbotWindow && !chatbotWindow.closed) {
	        chatbotWindow.focus();
	    } else {
	        // 새 창 열기
	        chatbotWindow = window.open(
	            'https://ai.cwit.co.kr/his/', // 열 URL
	            'chatbotWindow', // 창 이름
	            'width=420,height=600,top=4000,left=4000' // 창 크기 및 위치 지정
	        );
	    }
	}
	
	function openChatbotWindow2() {
	    // 창이 이미 열려 있다면 해당 창에 포커스
	    if (chatbotWindow && !chatbotWindow.closed) {
	        chatbotWindow.focus();
	    } else {
	        // 새 창 열기
	        chatbotWindow = window.open(
	            'https://ai.cwit.co.kr/his/', // 열 URL
	            'chatbotWindow', // 창 이름
	            'width=420,height=600,top=120,left=750' // 창 크기 및 위치 지정
	        );
	    }
	}

	
	function openChatbotAI() {
		var ua = navigator.userAgent;
	    var isIE = ua.indexOf("MSIE") > -1 || ua.indexOf("Trident") > -1;

	    if (!isIE) { // IE 제외
	        
	        $('#div_dim').show();

	        var chatbotDiv = document.getElementById("OPEN_CHATBOT_AI_DIV");
	        if (!chatbotDiv) return;

	        var style = window.getComputedStyle(chatbotDiv);
	        if (style.display === "none") {
	            chatbotDiv.style.display = "block";
	        }
	    } else {
	        // Chrome이 아닐 경우 페이지 이동
	        var f = document.listFrm;
	        f.method = 'post';
			f.action = '/fr/as/form.do';
			f.submit();
	    }
	}
	
	function NoticelistDetail(pageType, seq) {
		var f = document.listFrm;
		f.pageType.value = 'update';
		f.seq.value = '19031';
		f.board_gbn.value = '0000';
		f.method = 'post';
		f.action = '/fr/notice/form.do';
		f.submit();
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
					<li><a href="javascript:showRenewalDiv();" type="button" class="colorWhite  mgl20"><img src="/images/front/ico_doc.png" class="valignM mgr5">리뉴얼가이드</a></li>
					<li><a href="javascript:showHeaderDiv();" type="button" class="colorWhite"><img src="/images/front/ico_doc.png" class="valignM mgr5">이용가이드</a></li>
					<li><a href="/fr/member/form2.do">개인정보수정</a></li>
					<li><a href="javascript:goLogOut();">로그아웃</a></li>
				</ul>
			</div>
			</c:if>
		</div>
	</div>
	
	<div id="jw_gnb" style="display: flex; position: relative;">
		<input type="hidden" name="pageType" id="pageType" />
		<input type="hidden" name="page" id="page" value="1" />
		<input type="hidden" name="seq" id="seq" />
		<input type="hidden" name="board_gbn" id="board_gbn" />
		<input type="hidden" name="listNum" id="listNum" />
		<input type="hidden" name="user_id" id="user_id" value=${ frUserInfo.emp_id } />
		<input type="hidden" name="cust_code" id="cust_code" value=${ frUserInfo.cust_code } />
		<div class="innerWrap">
			<h1><a href="/fr/main/list.do">ONTIC CRM</a></h1>
			<ul>
				<!-- <li class="gnb09"><a id="a9" href="/fr/main/search.do">통합검색</a></li>-->
				<!--<li class="gnb01"><a id="a0" href="/fr/as/form.do" class="active">A/S신청</a></li>-->
				<li class="gnb01"><a id="a0" onclick="openChatbotAI()">A/S신청</a></li> 
				<li class="gnb02"><a id="a1" href="/fr/down/list.do">다운로드</a></li>
				<li class="gnb03"><a id="a2" href="/fr/faq/list.do">상담사례</a></li>
				<!-- <li class="gnb06"><a id="a6" target="_blank" href="https://tattered-driver-2aa.notion.site/eb9bfe6ebcb24156a4a44e96f1340afa?v=871f3828f23e4a74b175097e2aeaafb1">다빈도Q&A</a></li> -->
				<li class="gnb08"><a id="a8" href="/fr/videofaq/list.do">FAQ(동영상)</a></li>
				<li class="gnb07"><a id="a7" href="/fr/drugfaq/list.do">FAQ(마약류보고)</a></li>
				<li class="gnb04"><a id="a3" href="/fr/notice/list.do">공지사항</a></li>
				<c:if test="${ frUserInfo.emp_grade eq 'C001' }"><li class="gnb05"><a id="a4" href="/fr/member/list.do">계정관리</a></li></c:if>
			</ul>
		</div>
	    <div>
	        <a onclick="NoticelistDetail('update', '19031');">
	            <img src="/images/front/alimtalk_banner.png" alt="배너 이미지" style="height: 80px;">
	        </a>
	    </div>
	</div>
	
	<!-- openChatbotAI -->
	<div class="box_layer layer_help" style="display: none; width:600px;height:700px;left:58%;background-color: rgba(0, 144, 200, 0) !important; background:none !important; 
            border:0 !important; 
            box-shadow:none !important; " id="OPEN_CHATBOT_AI_DIV">
	    <h1 class="tit_back" style="height: 1px !important;background-color: rgba(0, 144, 200, 0) !important;"></h1>
	    <div class="layer_contents" style="width:95%;height:100%;padding:0;">
         <iframe id="chatbotAiFrame"
                src=""
                style="width:90%;height:105%;border:none;"></iframe>
   	    </div>
	</div>
	
	<div id="chatbot" style="bottom:0px; right : 30px; position:fixed;">
		<ul>
			<li>
				<a class="button-link" onclick="openChatbotAI()">
					<img src="/images/front/chatbot_icon.gif" height="180" width="180">
				</a>
			</li>		
		</ul>
	</div>
	<div id="chatbot" style="bottom:12%; right : 8%; position:fixed;">
		<ul>
			<li>
				<a class="button-link" onclick="openChatbotAI()">
					<img src="/images/front/chatbot_icon2.gif" height="150" width="150">
				</a>
			</li>		
		</ul>
	</div>	
	
	
	<div class="layer_dimmed"  id="div_dim" style="display:none;"></div>
