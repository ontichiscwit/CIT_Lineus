<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	System.out.println(request.getHeader("referer")) ;
%>
<style>
    .wrap-error p{margin:0;}
    .error-btns{margin-top: 50px;}
    .error-btns > a{display: inline-block; text-decoration: none; line-height: 45px; font-weight: 700; width: 140px; height: 45px; border: 1px solid #0075a2; background-color: #0090c8; color: #fff; font-size: 16px;}
    .error-btns > a.error-btn-grey{border-color: #3e464d; background-color: #525e68;}
</style>

<div class="wrap-error" style="text-align: center; display: table; margin: 100px auto;">
    <img src="/images/caution.jpg" alt="">
    <p style="font-size: 36px; font-weight: 700; line-height: 1.2em; letter-spacing: -0.05em; margin: 50px 0 20px;">죄송합니다.<br>페이지가 존재하지 않습니다.</p>
    <p style="font-size: 14px; color: #666; font-weight: 700;">클릭하신 링크가 깨졌거나 페이지가 삭제되었습니다.<br>재시도 후 같은 문제가 발생 시 아래 담당자에게 문의해주시기 바랍니다.<br><br>&nbsp;&nbsp;&nbsp;-1차 담당자 : 김규민 (TEL : 070-7707-5409)<br>-2차 담당자 : 김종호 (TEL : 02-801-1018) <br>-3차 담당자 : 김경아 (TEL : 02-801-1300)</p>
    <div class="error-btns">
        <a href="javascript:history.back(-1);" class="error-btn-grey">이전페이지</a>
    </div>
</div>