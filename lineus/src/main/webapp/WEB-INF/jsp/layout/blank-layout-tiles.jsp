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
	<meta name="apple-mobile-web-app-title" content="jw Connected Care System" />
	<title>ONTIC LineUs</title>
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/css/jw.css" />
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/css/jquery-ui.css" />
	<link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/css/front/jquery.bxslider.min.css" />
	
	
	<script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery.js"></script>
	<script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery-ui.min.js"></script>
	<script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery.bxslider.min.js"></script>
	
	
<%-- 	<script type="text/javascript" src="<%= request.getContextPath()%>/js/jw_common_view.js"></script>
	<script type="text/javascript" src="<%= request.getContextPath()%>/js/jw_common_action.js"></script>
	<script type="text/javascript" src="<%= request.getContextPath()%>/js/jw_common_ajaxController.js"></script>
	<script type="text/javascript" src="<%= request.getContextPath()%>/js/jw_common_layer.js"></script> --%>
	
</head>

<body>
	<t:insertAttribute name ="content"/>
	<iframe name="hiddenFrame" id="hiddenFrame" style="width:0px;height:0px;display:none;"></iframe>   	
</body>
</html>
