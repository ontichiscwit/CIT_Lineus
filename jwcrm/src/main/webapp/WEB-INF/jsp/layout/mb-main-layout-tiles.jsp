<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="t" %>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no, minimal-ui">
    <title>ONTIC LineUs</title>
    <!-- Bootstrap -->
    <link rel="stylesheet" href="/plugins/bootstrap/css/bootstrap.min.css">
    <c:if test="${CURRENT_MENU_URL ne '/mb/login/form.do' }"><link rel="stylesheet" href="/css/mobile/font-awesome.min.css"></c:if>
    <link rel="stylesheet" href="/css/mobile/common.css">
    <link rel="stylesheet" href="/css/mobile/fonts.css">
    
    <script src="/plugins/bootstrap/js/jquery.js"></script>
    
	<script type="text/javascript" src="/js/jquery-ui.min.js"></script>
	<script type="text/javascript" src="/js/jw_common_view.js"></script>
	<script type="text/javascript" src="/js/jw_common_action.js"></script>
	<script type="text/javascript" src="/js/jw_common_ajaxController.js"></script>
	<script type="text/javascript" src="/js/jw_common.js"></script>
	<script type="text/javascript" src="/js/jw_common_layer.js"></script>
</head>
<body>
	<c:choose>
		<c:when test="${CURRENT_MENU_URL eq '/mb/login/form.do' }"><div class="wrap login"></c:when>
		<c:when test="${CURRENT_MENU_URL eq '/mb/as/main.do' }"><div class="wrap main"></c:when>
		<c:otherwise><div class="wrap"></c:otherwise>
	</c:choose>
	
    
        <t:insertAttribute name ="content"/>    
        <iframe name="hiddenFrame" id="hiddenFrame" style="width:0px;height:0px;display:none;"></iframe>
        
        <c:if test="${ CURRENT_MENU_URL eq '/fr/as/main.do'  }">
        
        <footer class="footer">
        	<t:insertAttribute name ="footer"/>
        </footer>
        
        </c:if>
    </div>
	
	<div class="modal fade" id="modal-policy" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="header modal-header">
                    <div class="menu right"><span class="icons close-btn" data-dismiss="modal" aria-label="Close"></span></div>
                    <div class="title"><p>약관 동의</p></div>
                </div>
                <div class="contents container modal-body">
                    <div class="border-text-box">
                        <strong>개인정보취급방침</strong><br>
                        '제이더블유홀딩스 주식회사'(이하 '회사'라 합니다)는 이용자의 개인정보를 중요시하며, 「정보통신망 이용촉진 및 정보보호에 관한 법률」, 「개인정보보호법」을 준수하기 위하여 노력하고 있습니다.<br>
                        회사는 개인정보취급방침을 통하여 회사가 이용자로부터 제공받은 개인정보를 어떠한 용도와 방식으로 이용하고 있으며, 개인정보보호를 위해 어떠한 조치를 취하고 있는지 알려드립니다.<br>
                        본 방침은 2014년5월1일부터 시행되며, 이를 개정하는 경우 웹사이트 공지사항(또는 개별공지)을 통하여 공지하겠습니다.<br>
                        <strong>0. 총칙</strong><br>
                        “개인정보”란 생존하는 개인에 관한 정보로서 당해 정보에 포함되어 있는 성명, 주민등록번호 등의 사항에 의하여 당해 개인을 식별할 수 있는 정보(당해 정보만으로는 특정 개인을 식별할 수 없더라도 다른 정보와 용이하게 결합하여 식별할 수 있는 것을 포함)를 말합니다.<br>
                        회사는 이용자의 개인정보보호를 매우 중요시하며, 「정보통신망 이용촉진 및 정보보호 등에 관한 법률」, 「개인정보보호법」 및 행정안전부가 제정한 "개인정보보호지침" 등을 준수하고 있습니다.<br>
                        회사는 본 개인정보취급방침을 통하여 이용자께서 제공하시는 개인정보가 어떠한 용도의 방식으로 이용되고 있으며 개인정보보호를 위해 어떠한 조치가 취해지고 있는지 알려 드립니다.<br>
                        회사는 본 개인정보취급방침을 제이더블유홀딩스 주식회사 홈페이지의 첫 화면에 공개함으로써 이용자께서 언제나 용이하게 보실 수 있도록 조치하고 있습니다.
                        회사는 개인정보취급방침의 지속적인 개선을 위하여 개인정보취급방침을 개정하는데 필요한 절차를 정하고 있습니다. 그리고 개인정보취급방침을 개정하는 경우 버전번호 등을 부여하여 개정된 사항을 쉽게 알아볼 수 있도록 하고 있습니다.<br>
                        <strong>제 1 조 수집하는 개인정보의 항목 및 수집방법</strong><br>
                        (1) 수집하는 개인정보의 항목<br>
                        회사는 고객지원 Q&A 이용 시 이용자로부터 아래와 같은 개인정보를 수집하고 있습니다.<br>
                        필수항목<br>
                        ※ 귀하께서는 필수항목 수집·이용에 대한 동의를 거부하실 수 있으나, 이는 서비스 제공에 필수적으로 제공되어야 하는 정보이므로, 동의를 거부하실 경우 고객센터를 이용 하실 수 없습니다.<br>
                        ① 고객지원 Q&A 이용을 위해 필요한 개인정보<br>
                        성명, 이메일 주소, 전화번호, 고객구분 법정대리인 정보(만 14세 미만 아동의 경우)<br>
                        선택항목<br>
                        ※ 귀하께서는 선택항목 수집·이용에 대한 동의를 거부하실 수 있으며, 이는 서비스 제공에 필수적으로 제공되어야 하는 정보가 아니므로, 동의를 거부하시더라도 홈페이지 이용이 가능합니다. <br>
                        서비스 이용과정에서 선택항목 수집, 이용이 필요할 경우 별도로 안내하고 동의 받도록 하겠습니다.<br>
                        ※ 회사는 이용자의 사생활을 현저히 침해할 우려가 민감정보(사상·신념, 노동조합·정당의 가입·탈퇴, 정치적 견해, 건강, 성생활 등에 관한 정보 등)는 수집하지 않습니다. 
                        ※ 회사는 원칙적으로 이용자가 만 14세 미만자일 경우 개인정보를 수집하지 않습니다.<br> 
                        부득이 서비스 이용을 위하여 만 14세 미만자의 개인정보를 수집할 때에는, 사전에 법정대리인의 동의를 구하고 관련 업무가 종료됨과 동시에 정보를 지체 없이 파기토록 하겠으며 업무가 진행되는 동안 개인정보를 철저히 관리토록 하겠습니다.<br>
                        (2) 개인정보 수집방법<br>
                        홈페이지를 통한 고객지원 Q&A를 이용 시 이용자의 직접입력 방식<br>
                        ※ 회사는 이용자께서 회사의 개인정보 수집·이용 동의서 각각의 내용에 대해 "동의" 또는 "동의하지 않음"을 선택할 수 있는 절차를 마련하고 있습니다.
                    </div>
                </div>
                <div class="footer fix modal-footer">
                    <button class="btn btn-primary btn-lg btn-block" data-dismiss="modal">동의함</button>
                    <button class="btn btn-default btn-lg btn-block" data-dismiss="modal">동의하지 않음</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap --> 
	<script src="/plugins/bootstrap/js/bootstrap.min.js"></script>
	<script src="/js/mb/custom.js"></script>
</body>
</html>
