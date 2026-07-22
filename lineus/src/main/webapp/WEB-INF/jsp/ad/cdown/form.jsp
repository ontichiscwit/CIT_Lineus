<%@page import="egovframework.com.comm.util.CommonExecute"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javascript" src="/se/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">
	var oEditors = [];
	
	$(document).ready(function(){	 
		 <c:choose>
		 	<c:when test="${ vo.pageType eq 'insert'}">
		 	addUpFile();	
		 	smEditorLoad();
		 	</c:when>
		 	<c:otherwise>
		 	initView();
		 	</c:otherwise>
		 </c:choose>
	});
	
	function smEditorLoad() {
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
	} 
	
	function initView() {
		var f = document.frmNotice ; 
		
		$.ajax({
			type : 'post' ,
			url : '/ad/board/getBoardInfo.do' , 
			data : $('form[name=frmNotice]').serialize() ,
			dataType : 'json' , 
			statusCode : {
				403:function(data){
					alert("권한이 없습니다.");
				},
				404:function(data){
					alert('해당 페이지가 존재하지 않습니다.');
				}
			},
			success : function(data){
				
				var str ='';
				var resultVO = data.resultVO != "undefined" ? data.resultVO : null ;
				
				if(resultVO != null){
					var info = resultVO.info != "undefined" ? resultVO.info : null ; 
					var attachList = resultVO.attachList != "undefined" ? resultVO.attachList : null ; 
					/* 상단 disabled data */
					if (info != null){
						$('#attach_seq').val(common.nvl(info.attach_seq,''));

						var reg_id = jQuery.trim(common.nvl(info.reg_id, '')).toUpperCase();
						var group_userid = jQuery.trim('${adUserInfo.emp_no}').toUpperCase();
						
						if (reg_id == group_userid || group_userid == 'ADMIN') {
							$('#title').val(common.nvl(info.title,''));
							$('#content').val(common.nvl(info.content,''));
							smEditorLoad();
						} else {
							$('#title_view').html(common.nvl(info.title,''));
							$('#content1').hide();
							$('#content2').html(common.nvl(info.content,'')).show().css({'width': '960px', 'overflow-x':'auto'});
							$('#btnConfirm').hide();
							$('#btnDelete').hide();
						}
					}
					if (attachList != null && attachList.length > 0) {
						var fileStr = '' ; 
						for(var i = 0 ; i < attachList.length ; i++){
							var datas = attachList[i];
							fileStr += '<div id="file'+datas.attach_ord+'" style="margin-top:5px;">';
							if (reg_id == group_userid || group_userid == 'ADMIN') {
								fileStr += '	<input type="file" class="w355 mgr5" id="uploadFile'+datas.attach_ord+'" name="uploadFile'+datas.attach_ord+'" title="첨부파일" />';
								if (i == 0) fileStr += '	<button type="button" class="btn_plus mgr5" onclick="addUpFile();">파일추가</button>';	
								fileStr += '	<button type="button" class="btn_minus" onclick="fileDelete(\''+datas.attach_seq+'\' , \''+datas.attach_ord+'\');">파일삭제</button>';								
							}
							fileStr += '	&nbsp;&nbsp;<input type="text" class="w200 mgr5 mgb5" id="faq03" title="첨부파일" value="'+datas.attach_ori_nm+'" readonly="readonly" /><button type="button" onclick="fileDown(\''+datas.attach_seq+'\' , \''+datas.attach_ord+'\');" class="btn_line_gray mgr22 mgb5">다운로드</button>';
							fileStr += '</div>';
							
							addCnt = datas.attach_ord;
						}
						
						$('#fileWrap').html(fileStr) ; 
					} else {
						if (reg_id == group_userid || group_userid == 'ADMIN') {
							addUpFile();
						} else {
							$('#fileWrap').html('-');
						}
					}
				}
			}
		}) ; 	
	}
	
	function fileDelete(attach_seq , attach_ord){
		
		var f = document.frmNotice ; 
		
		if(common.isEmpty(attach_seq)){
			alert('삭제 하시려는 파일의 정보가 맞지 않습니다.') ; 
			return ; 
		}
		
		if(common.isEmpty(attach_ord)){
			alert('삭제 하시려는 파일의 정보가 맞지 않습니다.') ; 
			return ; 
		}
		
		if(f.del_attach_seq.value == ""){
			f.del_attach_seq.value = attach_seq ; 
			f.del_attach_ord.value = attach_ord ; 
		}else{
			f.del_attach_seq.value = f.del_attach_seq.value + "@" + attach_seq ; 
			f.del_attach_ord.value = f.del_attach_ord.value + "@" + attach_ord ;
		}
		
		$('#file'+attach_ord).remove();
	}
	
	function goSubmit() {
		
		var f = document.frmNotice;
		
		oEditors.getById['content'].exec("UPDATE_CONTENTS_FIELD", []) ;
		
		
		if (common.nvl(f.title.value,'') == '') {
			alert('제목을 입력해 주세요.');
			$('#title').focus();
			return;
		}
		
		if(common.replaceAll(f.content.value, "<br>" , "") == ""){
			alert("내용을 입력해 주세요.") ;
			return ;
		}
		
		if (confirm("작성된 정보로 등록하시겠습니까?")) {	
			f.target = "hiddenFrame" ; 
			f.action = "/ad/board/proc.do" ; 
			f.submit();
		}
	}
	
	function procReturn(flag , msg){
		alert(msg) ;
		if(flag == "success") listGo() ; 
	}
	
	var addCnt = 0;
	
	function addUpFile() {
		
		var str = '';
		
		addCnt = parseInt(addCnt) + 1;
		
		str += '<div id="file'+addCnt+'" style="margin-top:5px;">';
		str += '	<input type="file" class="w355 mgr5" id="uploadFile'+addCnt+'" name="uploadFile'+addCnt+'" title="첨부파일" />';
		if (addCnt == 1) {
			str += '	<button type="button" class="btn_plus mgr5" onclick="addUpFile('+addCnt+');">파일추가</button>';	
		}
		if (addCnt != 1) str += '	<button type="button" class="btn_minus" onclick="delUpFile('+addCnt+');">파일삭제</button>				';
		str += '</div>';
		
		$('#fileWrap').append(str);
		$('#addCnt').val(addCnt);
	}
	
	function delUpFile(num) {
		
		var fileDivSize = $('input[type^=file]').length;
		
		if (fileDivSize < 2) {
			alert('한개 이하로는 삭제할 수 없습니다.');
			return;
		} else {
			$('#file'+num).remove();
		}
	}
	
	function listGo() {
		var f = document.frmNotice;
		f.method="post";
		f.target = "";
		f.action="/ad/cdown/list.do";
		f.submit();
	}
	
	function goDel() {
		var f = document.frmNotice;
		
		f.del_seq.value = $('#seq').val();
		
		if (confirm("선택된 글을 삭제하시겠습니까?")) {
			f.pageType.value = 'delete';
			f.target = "hiddenFrame" ; 
			f.action = "/ad/board/proc.do" ; 
			f.submit();
		}
	}
	
	function procReturn(flag , msg){
		alert(msg) ;
		if(flag == "success") location.href='/ad/cdown/list.do' ; 
	}
</script>
<form id="frmNotice" name="frmNotice" method="post" enctype="multipart/form-data">
<input type="hidden" name="pageType" id="pageType" value="${ vo.pageType }" />
<input type="hidden" name="board_gbn" id="board_gbn" value="0003" />
<input type="hidden" name="addCnt" id="addCnt" />
<input type="hidden" name="attach_seq" id="attach_seq" value="0"/>
<input type="hidden" name="del_attach_seq" id="del_attach_seq" />
<input type="hidden" name="del_attach_ord" id="del_attach_ord" />
<input type="hidden" name="seq" id="seq" value="${ vo.seq }" />
<input type="hidden" name="del_seq" id="del_seq" />
<div class="tit_wrap">
	<%= CommonExecute.returnLineMap(request) %>
</div>
<!-- search -->
<table class="sType mgb10">
	<caption>사내게시판 상세정보 등록</caption>
	<colgroup>
		<col style="width:140px;" />
		<col style="width:auto;" />
	</colgroup>
	<tr>
		<th scope="row">제목</th>
		<td id="title_view">
			<input type="text" class="w100p" id="title" name="title" title="제목 입력" />
		</td>
	</tr>
	<tr>
		<td colspan="2" class="field_editor">
			<div class="box_editor" id="content1">
				<textarea id="content" name="content" style="height:315px;"></textarea>
			</div>
			<div id="content2" style="display:none;">
				
			</div>
		</td>
	</tr>
	<tr>
		<th scope="row">첨부파일</th>
		<td id="fileWrap"></td>
	</tr>
</table>
<!--// search -->
<div class="btn_wrap">
	<div class="floatL">
		<button type="button" class="btn_ico_list" onclick="listGo();"><span>목록</span></button>
	</div>
	<div class="floatR">
		<c:choose>
			<c:when test="${ vo.pageType eq 'insert' }">
			<button type="button" class="btn_ico_confirm" id="btnConfirm" onclick="goSubmit();"><span>등록</span></button>
			</c:when>
			<c:otherwise>
			<button type="button" class="btn_ico_confirm" id="btnConfirm" onclick="goSubmit();"><span>수정</span></button>
			<button type="button" class="btn_ico_delete dgray" id="btnDelete" onclick="goDel();"><span>삭제</span></button>
			</c:otherwise>
		</c:choose>
		<button type="button" class="btn_ico_cancel" id="btnCancel" onclick="listGo();"><span>취소</span></button>
	</div>
</div>
</form>
