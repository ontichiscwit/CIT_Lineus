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
				
				console.log(resultVO);
				
				if(resultVO != null){
					var info = resultVO.info != "undefined" ? resultVO.info : null ; 
					var attachList = resultVO.attachList != "undefined" ? resultVO.attachList : null ; 
					var attachHistList = resultVO.attachHistList != "undefined" ? resultVO.attachHistList : null ;
					/* 상단 disabled data */
					if (info != null){
						$('#attach_seq').val(common.nvl(info.attach_seq,''));
						$('#noticeNum').html(common.nvl(info.seq,''));
						$('#reg_date').html( (common.nvl(info.reg_date,'')).substr(0,10) );
						$('#emp_nm').html(common.nvl(info.emp_nm,''));
						$('#cnt').html(common.nvl(info.cnt,''));
						
						window.location.hash = 'seq=' + common.nvl(info.seq,'');

						var reg_id = jQuery.trim(common.nvl(info.reg_id, '')).toUpperCase();
						var group_userid = jQuery.trim('${adUserInfo.emp_no}').toUpperCase();
						var emp_grade = jQuery.trim('${adUserInfo.emp_grade}').toUpperCase();
						
						if (reg_id == group_userid || emp_grade == 'C001') {
							$('#title').val(common.nvl(info.title,''));
							$('#content').val(common.nvl(info.content,''));
							smEditorLoad();
						} else {
							$('#title_view').html(common.nvl(info.title,''));
							$('#content1').hide();
							$('#content2').html(common.nvl(info.content,'')).show().css({'width': '960px', 'overflow-x':'auto'});
							$('#btnConfirm').hide();
						}
					}
					if (attachList != null && attachList.length > 0) {
						var fileStr = '' ; 
						for(var i = 0 ; i < attachList.length ; i++){
							var datas = attachList[i];
							fileStr += '<div id="file'+datas.attach_ord+'" style="margin-top:5px;">';
							if (reg_id == group_userid  ||  emp_grade == 'C001') {
								fileStr += '	<input type="file" class="w355 mgr5" id="uploadFile'+datas.attach_ord+'" name="uploadFile'+datas.attach_ord+'" title="첨부파일" />';
								if (i == 0) fileStr += '	<button type="button" class="btn_plus mgr5" onclick="addUpFile();">파일추가</button>';	
								fileStr += '	<button type="button" class="btn_minus" onclick="fileDelete(\''+datas.attach_seq+'\' , \''+datas.attach_ord+'\');">파일삭제</button>';								
							}
							fileStr += '	&nbsp;&nbsp;<input type="text" class="w200 mgr5 mgb5" id="faq03" title="첨부파일" value="'+datas.attach_ori_nm+'" readonly="readonly" /><button type="button" onclick="fileDown(\''+datas.attach_seq+'\' , \''+datas.attach_ord+'\');" class="btn_line_gray mgr22 mgb5">다운로드</button>';
							fileStr += '</div>';
							
							addCnt = datas.attach_ord;
						}
						
						$('#fileWrap').html(fileStr) ; 
						if (attachHistList != null && attachHistList.length > 0){
							setDownHistData(attachHistList);
						}
					} else {
						if (reg_id == group_userid ||  emp_grade == 'C001') {
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
		
		var content = f.content.value;

		$('#noticecount').val("1")
		$('#noticeallcount').val("1")
		$('#faqcount').val("1")
		$('#faqallcount').val("1")
		$('#downcount').val("1")
		$('#drugfaqcount').val("1")
		$('#videofaqcount').val("1")

		// 2024.07.01(김규민) --- 게시글 간 이동 링크 생성 코드(정규 표현식을 사용하여 상담사례(숫자) 패턴을 찾고, 상담사례 No.숫자와 <a> 태그로 변환)
		// 게시글 저장 시 아래 조건을 만족하면 형태 변환 후 해당 게시글로 이동할 수 있는 링크 형태로 자동 변형 
		// 수정 시 각각의 게시글 번호에 대해 존재여부 및 사용가능 여부 검토(사용불가 유형 --> 공지사항 : '직원공지' , '거래처공지' / 상담사례 : '나만보기')
	    var replacedContent = content.replace(/상담사례\((\d+)\)/g, function(match, number) {
	    	var datas = {'seq': number }
			common.ajaxCall(datas, '/ad/board/getFaqexist.do','setFaqexist'); //상담사례 번호 존재여부 검토
				    	
	    	if($('#faqcount').val() == 0){
	    		alert("상담사례(" + number + ")을 수정해주세요.");
	    	}else{
	    		common.ajaxCall(datas, '/ad/board/getFaqallexist.do','setFaqallexist'); //상담사례 번호 전체공지 유형 검토
	    		
	    		if($('#faqallcount').val() == 0){
	    			alert("상담사례(" + number + ")을 수정해주세요.");
	    		}
	    	}
	    	
	    		return '<a onclick="faqlistDetail(\'update\', \'' + number + '\');" style="cursor:pointer;" target="_blank">상담사례(' + number + ')</a>';
	    
	    });
		
	    if($('#faqcount').val() == 0 || $('#faqallcount').val() == 0){
			$('#content').focus();
			return;
	    }
	    
	    
	    var replacedContent = replacedContent.replace(/공지사항\((\d+)\)/g, function(match, number) {
	    	var datas = {'seq' : number }
	    	common.ajaxCall(datas, '/ad/board/getNoticeexist.do','setNoticeexist');
	    	
	    	if($('#noticecount').val() == 0){
	    		alert("공지사항(" + number + ")을 수정해주세요.");
	    	}else{
	    		common.ajaxCall(datas, '/ad/board/getNoticeallexist.do','setNoticeallexist'); //공지사항 번호 전체공지 유형 검토
	    		
	    		if($('#noticeallcount').val() == 0){
		    		alert("공지사항(" + number + ")을 수정해주세요.");
		    	}
	    	}
	    	
	        return '<a onclick="noticelistDetail(\'update\', \'' + number + '\');" style="cursor:pointer;" target="_blank">공지사항(' + number + ')</a>';
	    
	    });
	    
	    
	    if($('#noticecount').val() == 0 || $('#noticeallcount').val() == 0){
			$('#content').focus();
			return;
	    }
	    
	    
	    var replacedContent = replacedContent.replace(/다운로드\((\d+)\)/g, function(match, number) {
	    	var datas = {'seq' : number }
	    	common.ajaxCall(datas, '/ad/board/getDownexist.do','setDownexist');
	    	
	    	if($('#downcount').val() == 0){
	    		alert("다운로드(" + number + ")을 수정해주세요.");
	    	}
	    	
	        return '<a onclick="downlistDetail(\'update\', \'' + number + '\');" style="cursor:pointer;" target="_blank">다운로드(' + number + ')</a>';
	    
	    });
	    
	    if($('#downcount').val() == 0){
			$('#content').focus();
			return;
	    }
	    
	    var replacedContent = replacedContent.replace(/마약류보고\((\d+)\)/g, function(match, number) {
	    	var datas = {'seq' : number }
	    	common.ajaxCall(datas, '/ad/board/getDrugfaqexist.do','setDrugfaqexist');
	    	
	    	if($('#drugfaqcount').val() == 0){
	    		alert("마약류보고(" + number + ")을 수정해주세요.");
	    	}
	    	
	    	return '<a onclick="drugfaqlistDetail(\'update\', \'' + number + '\');" style="cursor:pointer;" target="_blank">마약류보고(' + number + ')</a>';
	    });
	    
	    if($('#drugfaqcount').val() == 0){
			$('#content').focus();
			return;
	    }
	    
	    var replacedContent = replacedContent.replace(/동영상\((\d+)\)/g, function(match, number) {
	    	var datas = {'seq' : number }
	    	common.ajaxCall(datas, '/ad/board/getVideofaqexist.do','setVideofaqexist');
	    	
	    	if($('#videofaqcount').val() == 0){
	    		alert("동영상(" + number + ")을 수정해주세요.");
	    	}
	    	
	        return '<a onclick="videofaqlistDetail(\'update\', \'' + number + '\');" style="cursor:pointer;" target="_blank">동영상(' + number + ')</a>';
	    });
	    
	    if($('#videofaqcount').val() == 0){
			$('#content').focus();
			return;
	    }
	    
	    // 변환된 내용을 다시 설정
	    f.content.value = replacedContent;
		
		if (confirm("작성된 정보로 FAQ(마약류보고)를 등록하시겠습니까?")) {	
			f.target = "hiddenFrame" ; 
			f.action = "/ad/board/proc.do" ; 
			f.submit();
		}
	}
	
	function setDownHistData(obj){
		downHistList = obj;
		// 파일 다운로드 이력 목록 보여주기
		var histStr = '';
		
		for(var i = 0 ; i < downHistList.length ; i++){
			var datas = downHistList[i];
			histStr += '<tr>';
			histStr += '	<td>'+(downHistList.length - i)+'</td>';
			histStr += '	<td>'+ datas.crm_code +'</td>';
			histStr += '	<td>'+ datas.cust_kor_name +'</td>';
			histStr += '	<td>['+ datas.reg_id +']'+ datas.emp_nm +'</td>';
			histStr += '	<td class="textL">'+ datas.attach_ori_nm +'</td>';
			histStr += '	<td>'+datas.reg_dt+'</td>';
			histStr += '</tr>';
		}
		
		$('#attachHistList').html(histStr);
	}
	
		function histSort(obj, sortKey){
		
		var className;
		if ($(obj).attr('class') == "undefined"){
			className = "up";
		}else{
			className = $(obj).attr('class');
		}
		
		$(obj).removeClass(className);
		
		className = className == "up" ? "down" : "up";
		if (className == "up"){
			downHistList.sort(function(a,b){
				return a[sortKey] < b[sortKey] ? -1 : a[sortKey] > b[sortKey] ? 1 : 0;
			});	
		}else{
			downHistList.sort(function(a,b){
				return a[sortKey] > b[sortKey] ? -1 : a[sortKey] < b[sortKey] ? 1 : 0;
			});
		}
		
		$('#attachHistList').html("");
		setDownHistData(downHistList);
		$(obj).addClass(className);
	}
	
	function setNoticeexist(data){
		var result = data.resultList != "undefined" ? data.resultList : null;
		if(data.resultList[0].CNT == 0){
		alert("아래 공지사항 번호는 존재하지 않습니다.");
		$('#noticecount').val(data.resultList[0].CNT);
		return;
		}
	}
	
	function setNoticeallexist(data){
		var result = data.resultList != "undefined" ? data.resultList : null;
		if(data.resultList[0].CNT == 0){
		alert("아래 공지사항 번호는 전체공지가 아닙니다.");
		$('#noticeallcount').val(data.resultList[0].CNT);
		return;
		}
	}
	
	function setFaqexist(data){
		var result = data.resultList != "undefined" ? data.resultList : null;
		if(data.resultList[0].CNT == 0){
		alert("아래 상담사례 번호는 존재하지 않습니다.");
		$('#faqcount').val(data.resultList[0].CNT);
		return;
		}
	}
	
	function setFaqallexist(data){
		var result = data.resultList != "undefined" ? data.resultList : null;
		if(data.resultList[0].CNT == 0){
		alert("아래 상담사례 번호는 전체공지가 아닙니다.");
		$('#faqallcount').val(data.resultList[0].CNT);
		return;
		}
	}
	
	function setDownexist(data){
		var result = data.resultList != "undefined" ? data.resultList : null;
		if(data.resultList[0].CNT == 0){
		alert("아래 다운로드 번호는 존재하지 않습니다.");
		$('#downcount').val(data.resultList[0].CNT);
		return;
		}
	}
	
	function setDrugfaqexist(data){
		var result = data.resultList != "undefined" ? data.resultList : null;
		if(data.resultList[0].CNT == 0){
		alert("아래 마약류보고 번호는 존재하지 않습니다.");
		$('#drugfaqcount').val(data.resultList[0].CNT);
		return;
		}
	}
	
	function setVideofaqexist(data){
		var result = data.resultList != "undefined" ? data.resultList : null;
		if(data.resultList[0].CNT == 0){
		alert("아래 동영상 번호는 존재하지 않습니다.");
		$('#videofaqcount').val(data.resultList[0].CNT);
		return;
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
		f.action="/ad/drugfaq/list.do";
		f.submit();
	}
	
	function faqlistDetail(pageType, seq) {
		var f = document.frmNotice;
		f.pageType.value = pageType;
		f.seq.value = seq;
		f.method = 'post';
		f.target = '_blank';
		f.action = '/ad/faq/form.do';
		f.submit();
	}
	
	function downlistDetail(pageType, seq) {
		var f = document.frmNotice;
		f.pageType.value = pageType;
		f.seq.value = seq;
		f.method = 'post';
		f.target = '_blank';
		f.action = '/ad/down/form.do';
		f.submit();
	}
	
	function videofaqlistDetail(pageType, seq) {
		var f = document.frmNotice;
		f.pageType.value = pageType;
		f.seq.value = seq;
		f.method = 'post';
		f.target = '_blank';
		f.action = '/ad/videofaq/form.do';
		f.submit();
	}
	
	function drugfaqlistDetail(pageType, seq) {
		var f = document.frmNotice;
		f.pageType.value = pageType;
		f.seq.value = seq;
		f.method = 'post';
		f.target = '_blank';
		f.action = '/ad/drugfaq/form.do';
		f.submit();
	}
	
	function noticelistDetail(pageType, seq) {
		
		var datas = {'seq' : seq }
		common.ajaxCall(datas, '/ad/board/getNoticenum.do','setNoticenum');
		
		var f = document.frmNotice;
		f.pageType.value = pageType;
		f.seq.value = $('#seq2').val();
		f.method = 'post';
		f.target = '_blank';
		f.action = '/ad/notice/form.do';
		f.submit();
	}
	
	function setNoticenum(data){
		
		var result = data.resultList != "undefined" ? data.resultList : null;
			$('#seq2').val(data.resultList[0].SEQ);
	}

	
</script>
<form id="frmNotice" name="frmNotice" method="post" enctype="multipart/form-data">
<input type="hidden" name="pageType" id="pageType" value="${ vo.pageType }" />
<input type="hidden" name="page" id="page" value="${ vo.page }" />
<input type="hidden" name="board_gbn" id="board_gbn" value="0005" />
<input type="hidden" name="addCnt" id="addCnt" />
<input type="hidden" name="attach_seq" id="attach_seq" value="0"/>
<input type="hidden" name="del_attach_seq" id="del_attach_seq" />
<input type="hidden" name="del_attach_ord" id="del_attach_ord" />
<input type="hidden" name="seq" id="seq" value="${ vo.seq }" />
<input type="hidden" name="seq2" id="seq2" value="${ vo.seq }" />
<input type="hidden" name="listNum" id="listNum" value="${ vo.listNum }" />
<input type="hidden" name="search_start" id="search_start" value="${ vo.search_start }" />
<input type="hidden" name="search_end" id="search_end" value="${ vo.search_end }" />
<input type="hidden" name="search_text" id="search_text" value="${ vo.search_text }" />

<input type="hidden" name="noticecount" id="noticecount" value="1" />
<input type="hidden" name="noticeallcount" id="noticeallcount" value="1" />
<input type="hidden" name="faqcount" id="faqcount" value="1" />
<input type="hidden" name="faqallcount" id="faqallcount" value="1" />
<input type="hidden" name="downcount" id="downcount" value="1" />
<input type="hidden" name="drugfaqcount" id="drugfaqcount" value="1" />
<input type="hidden" name="videofaqcount" id="videofaqcount" value="1" />
<div class="tit_wrap">

<h2 class="tit_ico_dfaq">FAQ(마약류보고)</h2>

<div class="location">
	<a href="/ad/main/list.do" class="home">Home</a>
	<a href="#" class="depth">게시판관리</a>
	<a href="/ad/drugfaq/list.do" class="depth">
	<span class="here">FAQ(마약류보고)</span>
	</a>
</div>
	<%-- <%= CommonExecute.returnLineMap(request) %> --%>
</div>
<!-- search -->
<table class="sType mgb10">
	<caption>FAQ(마약류보고) 상세정보 등록</caption>
	<colgroup>
		<col style="width:140px;" />
		<col style="width:auto;" />
	</colgroup>
	<c:choose>
	<c:when test="${ vo.pageType eq 'insert' }">

	</c:when>
			
	<c:otherwise>
	<tr>
		<th scope="row">No.</th>
		<td id="noticeNum"></td>
	</tr>
	<tr>
		<th scope="row">등록일</th>
		<td id="reg_date"></td>
	</tr>
	<tr>
		<th scope="row">작성자</th>
		<td id="emp_nm"></td>
	</tr>				
	<tr>
		<th scope="row">조회수</th>
		<td id="cnt"></td>
	</tr>
			</c:otherwise>
	</c:choose>
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

<!--첨부파일 다운로드이력-->
<c:choose>
<c:when test="${ vo.pageType eq 'insert' || vo.pageType eq 'copy' }">
</c:when>
<c:otherwise>

<ul class="tab_line list5 mgb20">
	<li class="active"><a href="#" id="btnTab1" data-id="subTab1">첨부파일 다운로드 이력</a></li>
</ul>

<div id="subTab1" style="max-height:300px;overflow-y:auto;margin-bottom:20px;">
	<table class="hType">
		<caption>다운로드 이력 목록</caption>
		<colgroup>
			<col style="width:50px" />
			<col style="width:100px" />
			<col style="width:160px" />
			<col style="width:100px" />
			<col style="width:150px" />
			<col style="width:100px" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">NO</th>
				<th scope="col" style="cursor:pointer" onClick="histSort(this,'crm_code')">CRM코드</th>
				<th scope="col" style="cursor:pointer" onClick="histSort(this,'cust_kor_name')">거래처명</th>
				<th scope="col" style="cursor:pointer" onClick="histSort(this,'emp_nm')">사용자명</th>
				<th scope="col" style="cursor:pointer" onClick="histSort(this,'attach_ori_nm')">첨부파일명</th>
				<th scope="col" style="cursor:pointer" onClick="histSort(this,'reg_dt')">다운로드 일시</th>
			</tr>
		</thead>
		<tbody id="attachHistList"></tbody>
	</table>
</div>

</c:otherwise>
</c:choose>

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
			</c:otherwise>
		</c:choose>
		<button type="button" class="btn_ico_cancel" id="btnCancel" onclick="listGo();"><span>취소</span></button>
	</div>
</div>
</form>
