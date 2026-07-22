<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
	function fileSave(){
		var f = document.frm ; 
		
		f.target = "hiddenFrame" ; 
		f.action = "/sm/file/proc.do" ; 
		f.submit() ; 
	}
	
	function makeList(){
		alert("파일 첨부 완료") ; 
		return ; 
	}
	
	function fileDown(attach_seq , attach_ord){
		try{
			$("#fileFrm").remove() ; 
			$("#downFrame").remove() ;
		}catch(e){}
		var downFrame = $('<iframe id="downFrame" name="downFrame" style="width:0px; height=0px ; display:none;"></iframe>') ; 
		
		downFrame.appendTo("body") ;
		
		var f = $("<form></form>") ;
		f.attr('id' , 'fileFrm') ; 
		f.attr('action' , '/comm/fileDown.do') ; 
		f.attr('method' , 'post') ; 
		f.attr('target' , 'downFrame') ;
		f.appendTo("body") ;
		
		var attach_seq  = "<input type='hidden' name='attach_seq' value='"+attach_seq+"'/>" ; 
		var attach_depth  = "<input type='hidden' name='attach_ord' value='"+attach_ord+"'/>" ; 
		
		f.append(attach_seq).append(attach_depth) ; 
		f.submit() ; 
		
	}
	
	function goExl(){
		
		var f = document.frm2 ;
		
		try{
			$("#exlFrame").remove() ;
		}catch(e){}
		
		var downFrame = $('<iframe id="exlFrame" name="exlFrame" style="width:0px; height=0px ; display:none;"></iframe>') ; 
		downFrame.appendTo("body") ;
		
		f.target = "exlFrame" ; 
		f.action = "/sm/exl/proc.do" ; 
		f.submit() ; 
	}
	
</script>

<h1>첨부파일 sample</h1>
<form name="frm" method="post" enctype="multipart/form-data">
	<input type="file" name="upfile">
	<button name="save" id="save" onclick="javascript:fileSave();"> 전송 </button>
</form>

<h1>다운로드 sample</h1>

	<a href="javascript:fileDown('1', '1')">다운로드</a>

	
<h1>엑셀 다운로드 sample</h1>
<form name="frm2" method="post">
	<a href="javascript:goExl()">엑셀 다운로드</a>
</form>
	
<h1> 에디터	</h1>	
<script type="text/javascript" src="/se/js/HuskyEZCreator.js" charset="utf-8"></script>
<script >
var oEditors = [];

$(document).ready(function(){
	 /**	smartEditor 설정	*/
	 nhn.husky.EZCreator.createInIFrame({
		oAppRef: oEditors,
		elPlaceHolder: "content",
		sSkinURI: "/se/SmartEditor2Skin.html",	
		htParams : {
			bUseToolbar : true,						// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
			bUseVerticalResizer : true,			// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
			bUseModeChanger : true,				// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
			fOnBeforeUnload : function(){}
		}, 
		fOnAppLoad : function(){},
		fCreator: "createSEditor2"
	});
}) ; 

</script>
<textarea name="content" id="content" cols="30" rows="2" style="width:95%;display:none;"></textarea>

내용 확인 <br/>

1 . 요거 실행 >> oEditors.getById['content'].exec("UPDATE_CONTENTS_FIELD", []) ; <br/>
	
2. null 체크 >>	
	if(common.replaceAll(f.content.value, " " , "") == ""){
		alert("내용을 입력해 주세요.") ; 
		return ;
	}
