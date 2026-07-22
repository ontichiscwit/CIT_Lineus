<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">

	var BIurl ='';
	
	$(document).ready(function(){
		$('#jw_contents').css('width','1500px');
		getBiUrl();
	});
	
	function getBiUrl(){
		common.ajaxCall(null , '/ad/system/getBiUrl.do', 'makeBiUrl') ;
	}
	
	
	function makeBiUrl(datas){
		
		var returnVo = typeof datas.returnVo != "undefined" ? datas.returnVo : null ; 
		BIurl = returnVo.val1;
		
		$('#iff').attr('src',BIurl);
		
	}
</script>

<iframe width="1500" height="800" id="iff" align="center" scrolling="no"  frameborder="0" allowFullScreen="true"></iframe>
