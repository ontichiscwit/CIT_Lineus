<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="t" %>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
    <meta charset="utf-8">
	<meta http-equiv="Content-Script-Type" content="text/javascript" />
	<meta http-equiv="Content-Style-Type" content="text/css" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=1000" />
	<meta name="apple-mobile-web-app-title" content="jw ONTIC LineUs System" />
	<title>ONTIC LineUs 관리자 시스템</title>
	
	<link rel="shortcut icon" href="/images/ontic_T0U_icon.ico">
	<link rel="stylesheet" type="text/css" href="/css/jw.css" />
	<link rel="stylesheet" type="text/css" href="/css/jquery-ui.css" />
	<link rel="stylesheet" type="text/css" href="/css/sumoselect.css" />
	
	<script type="text/javascript" src="/js/jquery.js"></script>
	<script type="text/javascript" src="/js/jquery-ui.min.js"></script>
	<script type="text/javascript" src="/js/jw_common_view.js"></script>
	<script type="text/javascript" src="/js/jw_common_action.js"></script> 
	<script type="text/javascript" src="/js/jw_common_ajaxController.js"></script>
	<script type="text/javascript" src="/js/jw_common.js"></script>
	<script type="text/javascript" src="/js/jquery.sumoselect.js"></script>
	<script type="text/javascript" src="/js/jquery.sumoselect.min.js"></script>
</head>

<body>
   	
   	<t:insertAttribute name ="header"/>
   	
   	<div id="alarm" style="background: #ecf8fc; border: 1px solid #dbdbdb; border-top: 0; display:none;">
		<div class="tit_sWrap" style="width: 1000px; margin: 0 auto;">
			<div class="w490 floatL">
				<p style="line-height: 34px;">· 읽지 않은 메시지 : <a href="#" style="color: #ff3000; font-weight: 700;">3건</a></p>
			</div>
			<div class="w490 floatR" style="position: relative;">
				<ul style="position:absolute; left: 0; top: 0;">
					<li>
						<a href="#" class="notice-title">[긴급공지] 조치메뉴얼 변경관련 공지입니다.</a>
						<span class="notice-date">2017-05-15 12:23:00</span>
						<span class="notice-author">시스템관리자</span>
					</li>
					<li>
						<a href="#" class="notice-title">[긴급공지] 조치메뉴얼 변경관련 공지입니다.2</a>
						<span class="notice-date">2017-05-15 12:23:00</span>
						<span class="notice-author">시스템관리자</span>
					</li>
					<li>
						<a href="#" class="notice-title">[긴급공지] 조치메뉴얼 변경관련 공지입니다.3</a>
						<span class="notice-date">2017-05-15 12:23:00</span>
						<span class="notice-author">시스템관리자</span>
					</li>
					<li>
						<a href="#" class="notice-title">[긴급공지] 조치메뉴얼 변경관련 공지입니다.4</a>
						<span class="notice-date">2017-05-15 12:23:00</span>
						<span class="notice-author">시스템관리자</span>
					</li>
					<li>
						<a href="#" class="notice-title">[긴급공지] 조치메뉴얼 변경관련 공지입니다.5</a>
						<span class="notice-date">2017-05-15 12:23:00</span>
						<span class="notice-author">시스템관리자</span>
					</li>
				</ul>
				<a href="#" style="position: absolute; right: 0; top: 8px; font-size: 9px; font-family: 'verdana'; color: #2785a9;">more &rsaquo;</a>
			</div>
		</div>
	</div>
   	
   	<div id="jw_contents">
   		<t:insertAttribute name ="content"/>
   		<iframe name="hiddenFrame" id="hiddenFrame" style="width:0px;height:0px;display:none;"></iframe>
   	</div>  	   
   	
   	<div id="jw_footer">
   		<t:insertAttribute name ="footer"/>
   	</div>
</body>
</html>
