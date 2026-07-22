<%@page import="egovframework.com.comm.util.CommonExecute"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style>
.scrolltbody {
    display: block;
    width: 350px;
}
.scrolltbody tbody {
    display: block;
    height: 170px;
    overflow: auto;
}
.scrolltbody th:nth-of-type(1), .scrolltbody td:nth-of-type(1) { width: 50px; }
.scrolltbody th:nth-of-type(2), .scrolltbody td:nth-of-type(2) { width: 100px; }
.scrolltbody th:last-child { width: 200px; }
.scrolltbody td:last-child { width: calc( 200px - 19px );  }
.scrolltbody td {padding:5px 2px;height: 20px}


#tbAnswerList {
	display: block;
	width: 100%
}
	
#tbAnswerList thead{
	display: inline-block;
	width: 100%;
	height: auto;
}
	
#tbAnswerList tbody{
	overflow:  auto;
   	max-height: 500px;
   	display: inline-block;
}

#tbAnswerList thead th:nth-of-type(1){width: 70px;}
#tbAnswerList tbody td:nth-of-type(1){width: 70px;}
	
#tbAnswerList thead th:nth-of-type(2){width: 120px;}
#tbAnswerList tbody td:nth-of-type(2){width: 120px;}
	
#tbAnswerList thead th:nth-of-type(3){width: 100px;}
#tbAnswerList tbody td:nth-of-type(3){width: 100px;}
	
#tbAnswerList thead th:nth-of-type(4){width: 450px;} 
#tbAnswerList tbody td:nth-of-type(4){width: 450px;}
	
#tbAnswerList thead th:nth-of-type(5){width: 150px;} 
#tbAnswerList tbody td:nth-of-type(5){width: 150px;}
	
#tbAnswerList tbody td:nth-of-type(6){width: 100px;}
#tbAnswerList thead th:nth-of-type(6){width: 100px;}


</style>

<script type="text/javascript" src="/se/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">
	var custSearchList;
	var custSelectList = new Array();
	var downHistList;
	var oEditors = [];
	
	$(document).ready(function(){
		
		 <c:choose>
		 	<c:when test="${ vo.pageType eq 'insert'}">
		 	addUpFile();	
		 	smEditorLoad();
		 	commonCode.getCodeList('PROJECT' , 'PR02', 'system_type');
		 	commonCode.getCodeList('CUST' , 'CD01' , 'search_type9');
		 	$('#work_type').append(commonCode.defaultViewOption);
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
	
	function custSearch(){
		var f = document.frmNotice ; 
		
		$.ajax({
			type : 'post',
			url : '/ad/notice/custSearch.do' ,
			data : $('form[name=frmNotice]').serialize() ,
			dataType : 'json',
			success : function (data){
				//console.log(data);
				custSearchList = data.custSearchVO != "undefined" ? data.custSearchVO : null ;
				
				resetCustSearchList();
			}
			,statusCode : {
				403:function(data){
					alert("권한이 없습니다.");
				},
				404:function(data){
					alert('해당 페이지가 존재하지 않습니다.');
				}
			}
		});
	}
	
	function resetCustSearchList(){
		var str = "";
		
		if (custSearchList != null && custSearchList.length > 0) {
			for(var i = 0 ; i < custSearchList.length ; i++){
				
				var datas = custSearchList[i];
				console.log(datas);
				
				str += '<tr>';
				str += '	<td><input type="checkbox" title="거래처 선택" value="'+datas.erp_code+'" onclick="uncheck(\'searchChk\')"/></td>';
				str += '	<td>'+datas.erp_code+'</td>';
				str += '	<td>'+datas.cust_kor_name+'</td>';
				str += '</tr>';
			}
			
			$("#searchCnt").html(custSearchList.length);
		}
		$("#custSearchBlock").html(str);
	}
	
	function addSelectList(){
		
		var tmpErpCode;
		var tmpChk;
		var tmpObj;
		var tmpIdx;
		
		$("#custSearchBlock input[type=checkbox]").each(function(){
			if ($(this).prop("checked")){
				
				tmpErpCode = $(this).val();
				tmpObj = null;
				tmpIdx = -1;
				
				for (var i=0; i < custSearchList.length ; i++){
					if (custSearchList[i].erp_code == tmpErpCode){
						tmpObj = custSearchList[i];
						tmpIdx = i;
						break;
					}
				}
				
				tmpChk = false;
				for (var i=0; i < custSelectList.length ; i++){
					if (custSelectList[i].erp_code == tmpErpCode){
						tmpChk = true;
						break;
					}
				}
				
				if (!tmpChk){
					if (tmpObj != null){
						custSelectList.push(tmpObj);
						resetCustSelectList();
					}
					
					//console.log(tmpIdx);
					//console.log(custSearchList.length);
					
					if (tmpIdx != -1){
						custSearchList.splice(tmpIdx,1);
						resetCustSearchList();
					}
				}
			}
		});
	}
	
	function removeSelectList(){
		
		var tmpErpCode;
		
		$("#custSelectBlock input[type=checkbox]").each(function(){
			if ($(this).prop("checked")){
				
				tmpErpCode = $(this).val();
				
				for (var i=0; i < custSelectList.length ; i++){
					if (custSelectList[i].erp_code == tmpErpCode){
						custSelectList.splice(i,1);
						break;
					}
				}
			}
		});
		
		resetCustSelectList();
	}
	
	function resetCustSelectList(){
		var str = "";
		
		if (custSelectList != null && custSelectList.length > 0) {
			var str = ""; 

			for(var i = 0 ; i < custSelectList.length ; i++){
				
				var datas = custSelectList[i];
				
				str += '<tr>';
				str += '	<td><input type="checkbox" title="거래처 선택" value="'+datas.erp_code+'" onclick="uncheck(\'selectChk\')"/></td>';
				str += '	<td>'+datas.erp_code+'</td>';
				str += '	<td>'+datas.cust_kor_name+'</td>';
				str += '</tr>';
			}
			
			$("#selectCnt").html(custSelectList.length);
		}
		
		$("#custSelectBlock").html(str);
	}
	
	function uncheck(id){
		$("#"+id).prop("checked",false);
	}
	
	function chkCustSearchList(obj){
		$("#custSearchBlock input[type=checkbox]").each(function(){
			$(this).prop("checked",$(obj).prop("checked"));
		});
	}
	
	function chkCustSelectList(obj){
		$("#custSelectBlock input[type=checkbox]").each(function(){
			$(this).prop("checked",$(obj).prop("checked"));
		});
	}
	
	function initView() {
		
		var pageType = '${ vo.pageType }';
		
		// 등록모드가 아닐때
		var f = document.frmNotice ; 
		
		
		if(pageType == 'copy'){
			addUpFile();
		}
		
		$.ajax({
			type : 'post' ,
			url : '/ad/notice/getBoardInfo.do' , 
			data : $('form[name=frmNotice]').serialize() ,
			dataType : 'json' , 
			success : function(data){
				
				var str ='';
				var resultVO = data.resultVO != "undefined" ? data.resultVO : null ;
				
				if(resultVO != null){
					var info = resultVO.info != "undefined" ? resultVO.info : null ; 
					var attachList = resultVO.attachList != "undefined" ? resultVO.attachList : null ; 
					var attachHistList = resultVO.attachHistList != "undefined" ? resultVO.attachHistList : null ;
					var custList = resultVO.custSelectList != "undefined" ? resultVO.custSelectList : null ;
					
					/* 상단 disabled data */
					if (info != null){
						$('#attach_seq').val(common.nvl(info.attach_seq,''));

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
							$('#content2').html(common.nvl(info.content,'')).show();//.css({'width': '960px', 'overflow-x':'auto'});
							
							//console.log(common.nvl(info.content,''));
							
							$('#btnConfirm').hide();
						}
						
						// 20171116 박승모 초기 데이터 셋팅 추가
						$(":input:radio[name=open_type]:input[value="+info.open_type+"]").attr("checked",true).click();
						commonCode.getCodeList('PROJECT' , 'PR02', 'system_type');
						commonCode.getCodeList('CUST' , 'CD01' , 'search_type9');
						
						if (common.nvl(info.system_type,'') !=''){
							$("#system_type").val(info.system_type);
						}
						
						if (common.nvl(info.system_type,'') !=''){
							commonCode.getCodeList('OPERATE' , info.system_type, 'work_type');
							$("#work_type").show().val(info.work_type);
						}
						
						// 수신 거래처 목록 가져오기
						if (custList != null) custSelectList = custList;
						resetCustSelectList();
					}
					
					
					if (attachList != null && attachList.length > 0) {
						if(pageType != 'copy'){
							var fileStr = '' ; 
							for(var i = 0 ; i < attachList.length ; i++){
								var datas = attachList[i];
								fileStr += '<div id="file'+datas.attach_ord+'" style="margin-top:5px;">';
	
								if (reg_id == group_userid ||  emp_grade == 'C001') {
	
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
						}
						
					} else { 
						addUpFile();
						
					}
				}
			}
			,statusCode : {
				403:function(data){
					alert("권한이 없습니다.");
				},
				404:function(data){
					alert('해당 페이지가 존재하지 않습니다.');
				}
			}
		}); 
		
		
		$('[id^=btnTab]').bind("click",function(){
			
			$('[id^=subTab]').hide();
			$('.tab_line li').removeClass("active");
			$(this).parent('li').addClass("active");
			var dataid = $(this).data("id");
			$("#"+dataid).show();
			
			if (dataid=='subTab2') setAnswerData(); //답변내역 리스트 호출
			 
		});
		
		
		$('#w_content').keyup(function (e){
	          var content = $(this).val();
	          if(content.length >= 800){
	        	  content = content.substring(0 , 800) ;
	        	  $(this).val(content)
	          }
	          
	          $('#w_content_text').html(content.length + '/ 800 자');
	          
	     });
		
		
		
		
	}
	
	function setDownHistData(obj){
		downHistList = obj;
		// 파일 다운로드 이력 목록 보여주기
		var histStr = '';
		
		for(var i = 0 ; i < downHistList.length ; i++){
			var datas = downHistList[i];
			histStr += '<tr>';
			histStr += '	<td>'+(downHistList.length - i)+'</td>';
			histStr += '	<td>'+ datas.erp_code +'</td>';
			histStr += '	<td>'+ datas.cust_kor_name +'</td>';
			histStr += '	<td>['+ datas.reg_id +']'+ datas.emp_nm +'</td>';
			histStr += '	<td class="textL">'+ datas.attach_ori_nm +'</td>';
			histStr += '	<td>'+datas.reg_dt+'</td>';
			histStr += '</tr>';
		}
		
		$('#attachHistList').html(histStr);
	}
	
	
	function setAnswerData(){
		var datas = {'notice_seq' : '${ vo.seq }' } ;
		common.ajaxCall(datas , '/ad/board/getAwsList.do', 'getNoticeAnswer') ;
	}
	
	
	function getNoticeAnswer(data){
		
		$("#attachAnswerList").empty();
		var resultVO = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		if(resultVO != null && resultVO.lenght !=0){
			
			var AswStr ='';
			for(var i=0; i < resultVO.length; i++){
				AswStr += "<tr>";
				AswStr += "	<td>"+ (i+1) +"</td>";
				
				 /* <c:choose>
				 <c:when test="${resultVO[i].w_gubun eq 'U'}" >
				 	AswStr += "<td>" +resultVO[i].w_cust_nm+"</td>";
				 </c:when>
				 
				 <c:when test="${resultVO[i].w_gubun eq 'A'}" >
				 	AswStr += "<td>관리자</td>";
				 </c:when>
				 </c:choose>
				  */
				 
				 if(resultVO[i].w_gubun == 'U'){
					AswStr += "<td>" +resultVO[i].w_cust_nm+"</td>";
				 }else if(resultVO[i].w_gubun == 'A'){
					AswStr += "<td>관리자</td>";
				 } 
				
				AswStr += "	<td>"+resultVO[i].w_nm+"</td>";
				AswStr += "	<td class='textL'>"+resultVO[i].w_content+"</td>";
				AswStr += "	<td>"+resultVO[i].w_date+"</td>";
				AswStr += " <td onclick='event.cancelBubble=true;'><button type='button' class='btn_delete_blue' onclick='javascript:deleteAnswer(" + resultVO[i].seq + ")';><span>삭제</span></button></td>";
				AswStr += "<tr>";
			}
			$("#attachAnswerList").html(AswStr);
		}
	}
	
	
	function aswForm(){
		
		if(!confirm('문의내용을 등록하시겠습니까?')) return ;
		var datas = {
				'w_content' : $('#w_content').val(),
				'notice_seq' : '${ vo.seq }'
				}
		common.ajaxCall(datas, '/ad/board/awsform.do', 'registResult') ;
	}
	
	
	function registResult(data){
		
		var msg = "처리도중 오류가 발생했습니다." ; 
		var returnCode = typeof data.returnCode != "undefined" ? data.returnCode : "888" ; 
		if(returnCode == "000") msg = "정상처리 되었습니다." ;
		alert(msg) ; 
		if(returnCode == "000") {$('#w_content').val('');$('#w_content_text').html('0/ 800 자'); setAnswerData()}
	}
	
	function deleteAnswer(data){
		if(!confirm('문의내용을 삭제하시겠습니까?')) return ;
		var datas = {'seq' : data}
		common.ajaxCall(datas, '/ad/board/awsDel.do', 'registResult') ;
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
		
		var f = document.getElementById('frmNotice');
		
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
		
		/* if (common.nvl(f.system_type.value,'') == ''){
			alert('시스템유형을 선택하세요');
			$('#system_type').focus();
			return;
		}
		
		if (common.nvl(f.work_type.value,'') == ''){
			alert('상세 업무유형을 선택하세요');
			$('#work_type').focus();
			return;
		} */
		
		// erpCodeArr 값 셋팅하기
		f.open_type.value =  $(":input:radio[name=open_type]:checked").val();
		
		if (f.open_type.value == 'C003'){
			
			if (custSelectList.length < 1){
				alert('거래처를 선택하세요');
				return;
			}
			
			var tmpStr = '';
			for (var i=0; i < custSelectList.length; i++){
				tmpStr += ',' + custSelectList[i].erp_code;
			}
			

			f.erpCodeArr.value = tmpStr.substr(1);
		}
		
		if (confirm("작성된 정보로 공지사항을 등록하시겠습니까?")) {	
			f.target = "hiddenFrame" ; 
			f.action = "/ad/notice/proc.do" ; 
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
		f.action="/ad/notice/list.do";
		f.submit();
	}
	
</script>
<form id="frmNotice" name="frmNotice" method="post" enctype="multipart/form-data">
<input type="hidden" name="pageGubun" id="pageGubun" value="notice" />
<input type="hidden" name="pageType" id="pageType" value="${ vo.pageType }" />
<input type="hidden" name="page" id="page" value="${ vo.page }" />
<input type="hidden" name="board_gbn" id="board_gbn" value="0000" />
<input type="hidden" name="addCnt" id="addCnt" />
<input type="hidden" name="attach_seq" id="attach_seq" value="0"/>
<input type="hidden" name="del_attach_seq" id="del_attach_seq" />
<input type="hidden" name="del_attach_ord" id="del_attach_ord" />
<input type="hidden" name="seq" id="seq" value="${ vo.seq }" />
<input type="hidden" name="search_start" id="seq" value="${ vo.search_start }" />
<input type="hidden" name="search_end" id="seq" value="${ vo.search_end }" />
<input type="hidden" name="erpCodeArr" id="erpCodeArr" value="" />

<!-- 검색어 유지를 위한 부분 -->
<input type="hidden" name="search_type1" id="search_type1" value="${ vo.search_type1 }" />
<input type="hidden" name="search_type2" id="search_type2" value="${ vo.search_type2 }" />
<input type="hidden" name="search_type3" id="search_type3" value="${ vo.search_type3 }" />
<input type="hidden" name="search_type4" id="search_type4" value="${ vo.search_type4 }" />
<input type="hidden" name="search_type5" id="search_type5" value="${ vo.search_type5 }" />
<input type="hidden" name="search_type6" id="search_type6" value="${ vo.search_type6 }" />
<input type="hidden" name="search_text" id="search_text" value="${ vo.search_text }" />

<div class="tit_wrap">
	
	<h2 class="tit_ico_notice">공지사항관리</h2>
	
	<div class="location">
		<a href="/ad/main/list.do" class="home">Home</a>
		<a href="#" class="depth">게시판관리</a>
		<a href="/ad/notice/list.do" class="depth">
		<span class="here">공지사항관리</span>
		</a>
	</div>
	
</div>
<!-- search -->
<table class="sType mgb10">
	<caption>공지사항 상세정보 등록</caption>
	<colgroup>
		<col style="width:140px;" />
		<col style="width:auto;" />
	</colgroup>
	<tr>
		<th scope="row">노출구분</th>
		<td>
			<input type="radio" name="open_type" value="C001" class="mgr5" onclick="$('#receiver_section').hide();$('#receiver_section2').hide()" checked>전체공지<span class="mgr20"></span>
			<input type="radio" name="open_type" value="C002" class="mgr5" onclick="$('#receiver_section').hide();$('#receiver_section2').hide()">직원공지<span class="mgr20"></span>
			<input type="radio" name="open_type" value="C003" class="mgr5" onclick="$('#receiver_section').show();$('#receiver_section2').show()">거래처공지<span class="mgr20"></span>
		</td>
	</tr>
	<tr>
		<th scope="row">시스템/업무 유형 선택</th>
		<td>
			<select id="system_type" name="system_type" class="w200" title="시스템유형 선택" onchange="commonCode.getCodeList('OPERATE' , this.value , 'work_type');$('#work_type').show()">
				<option>선택해주세요</option>
			</select>
			<select id="work_type" name="work_type" class="w200" title="업무유형 선택"></select>
		</td>
	</tr>
	<tr id="receiver_section" style="display:none;">
		<th scope="row">거래처검색 선택</th>
		<td>
			<select id="search_type9" name="search_type9" class="w200" title="거래처 유형 선택"></select>
			<input type="text" id="search_type7" name="search_type7" class="w200" placeholder="거래처명 검색" title="거래처명 입력" onkeypress="if( event.keyCode==13 ){custSearch();}"/>
			<button type="button" class="btn_line_gray mgr5" onclick="custSearch()">검색</button>
			<!-- button type="button" class="btn_line_gray mgr22">초기화</button -->
		</td>
	</tr>
	<tr id="receiver_section2" style="display:none;">
		<th scope="row">수신자 선택</th>
		<td>
			<div class="w350 mgr10" style="display: table-cell;">
				<div style="min-height:30px"><h5>거래처 검색결과 (총 <span id="searchCnt">0</span>개)</h5></div>
				<div class="h200">
					<table class="hType scrolltbody">
						<thead>
							<th><input id="searchChk" type="checkbox" title="모두선택" onclick="chkCustSearchList(this)"/></th>
							<th>ERP코드</th>
							<th>거래처명</th>
						</thead>
						<tbody id="custSearchBlock">
						</tbody>
					</table>
				</div>
			</div>
			<!---->
			
			<div class="w100" style="display: table-cell; vertical-align:middle;">
				<table>
					<tr>
					
						<button style="width:80px;height:30px;background-color:#cdcece;margin-left:7px" type="button" class="btn_line_blue mgb10" onclick="addSelectList()" >▶</button>
					
					</tr>
				</table>
			</div>
			
			<!---->
			<div class="w350 mgr10" style="display: table-cell;">
				<div style="min-height:30px;float:left; width:70%"><h5>수신거래처 목록 (총 <span id="selectCnt">0</span>개)</h5></div>
				<div style="min-height:30px;display:inline-block; width:30%; text-align:right"><h5 style="cursor:pointer" onclick="removeSelectList()">[삭제]</h5></div>
				<div class="h200">
					<table class="hType scrolltbody">
						<thead>
							<th><input id="selectChk" type="checkbox" title="모두선택" onclick="chkCustSelectList(this)"/></th>
							<th>ERP코드</th>
							<th>거래처명</th>
						</thead>
						<tbody id="custSelectBlock">
						</tbody>
					</table>
				</div>
			</div>
		</td>
	</tr>
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
			<div id="content2" style="display:none;line-height:1.5em;">
				
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

<ul class="tab_line list2 mgb20">
	<li class="active"><a href="#" id="btnTab1" data-id="subTab1">첨부파일 다운로드 이력</a></li><!-- 활성시 current -->
	<li><a href="#" id="btnTab2" data-id="subTab2">문의내용</a></li>
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
				<th scope="col" style="cursor:pointer" onClick="histSort(this,'erp_code')">ERP코드</th>
				<th scope="col" style="cursor:pointer" onClick="histSort(this,'cust_kor_name')">거래처명</th>
				<th scope="col" style="cursor:pointer" onClick="histSort(this,'emp_nm')">사용자명</th>
				<th scope="col" style="cursor:pointer" onClick="histSort(this,'attach_ori_nm')">첨부파일명</th>
				<th scope="col" style="cursor:pointer" onClick="histSort(this,'reg_dt')">다운로드 일시</th>
			</tr>
		</thead>
		<tbody id="attachHistList"></tbody>
	</table>
</div>


<div id="subTab2" style="display:none ; margin-bottom: 20px;">
	
		<table class="hType mgb5">
			<caption>답변내용 목록</caption>
			<colgroup>
				<col style="width:130px">
			</colgroup>
			<tbody>
			<tr>
				<th scope="col">댓글작성</th>
				<td class="pd10" style="border:1px solid #dadada"><textarea name="w_content" id="w_content" class="lineH13 pd5"></textarea>
				<div id="w_content_text" style="float:right">0/ 800 자</div>
				</td>
			</tr>
			</tbody>
		</table>
	
	<div class="btn_wrap mgb10">
		<div class="floatR">
			<button type="button" class="btn_ico_write dgray" onclick="aswForm();"><span>댓글작성</span></button>
		</div>
	</div>
	
	<table class="hType" id="tbAnswerList">
		<caption>문의내용</caption>
		<thead>
			<tr>
				<th scope="col">NO</th>
				<th scope="col">거래처명</th>
				<th scope="col">작성자</th>
				<th scope="col">내용</th>
				<th scope="col">작성일시</th>
				<th scope="col"></th>
			</tr>
		</thead>
		<tbody id="attachAnswerList"></tbody>
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
			<c:when test="${ vo.pageType eq 'insert' || vo.pageType eq 'copy' }">
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
