<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<header class="header">
    <div class="menu left"></div>
    <div class="title"><img src="/images/mobile/logo-main.png" alt="" class="logo"></div>
    <div class="menu right"><a href="#" class="icons menu-hamburger"></a></div>
</header>
<div class="contents">
    <div class="container">
        <section class=" main-text">
            <div class="member-level">
            	<c:choose>
					<c:when test="${frUserInfo.emp_grade eq 'C001' }"><span class="text-center">고객사<br>대표</span></c:when>
					<c:otherwise><span class="text-center">고객사<br>회원</span></c:otherwise>
				</c:choose>
            </div>
            <div class="member-text">
                <h5>안녕하세요, <span class="big">${ frUserInfo.emp_name }</span>님!</h5>
                <h6>제품 A/S신청이나 이용 중 궁금하신 사항을 알려주세요.</h6>
            </div>
            <span class="triangle"></span>
        </section>
        <section class="btns">
            <div class="text-center">
                <a href="/mb/as/form.do" class="main-btn">
                    <i class="fa fa-pencil-square-o" aria-hidden="true"></i>
                    <hr />
                    A/S 신청
                </a>
                <a href="/mb/as/list.do" class="main-btn grey">
                    <i class="fa fa-list-alt" aria-hidden="true"></i>
                    <hr />
                    신청현황
                </a>
            </div>
        </section>
    </div>
</div>

<aside class="aside">
    <div class="wrap-side">
        <section class="member-info">
            <div>
                <p><strong>${ frUserInfo.emp_name }</strong>님 환영합니다!</p>
                <a href="/mb/login/form.do" class="btn btn-default btn-sm">로그아웃</a>
                <c:choose>
					<c:when test="${frUserInfo.emp_grade eq 'C001' }"><div class="icons member-level text-center">고객사<br>대표</div></c:when>
					<c:otherwise><div class="icons member-level text-center">고객사<br>회원</div></c:otherwise>
				</c:choose>
            </div>
        </section>
        <section class="side-footer">
            <ul class="horizontal-list">
                <li><a href="/mb/policy/list2.do">서비스이용약관</a></li>
                <li><a href="/mb/policy/list.do">개인정보처리방침</a></li>
            </ul>
        </section>
    </div>
    <div class="aside-blank"></div>
</aside>