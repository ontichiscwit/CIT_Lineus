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
		
		$( "#deadline" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		 <c:choose>
		 	<c:when test="${ vo.pageType eq 'insert'}">
		 	addUpFile();	
		 	smEditorLoad();
		 	commonCode.getCodeList('AS' , 'CD03', 'work_type');
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
				
				str += '<tr>';
				str += '	<td><input type="checkbox" title="거래처 선택" value="'+datas.crm_code+'" onclick="uncheck(\'searchChk\')"/></td>';
				str += '	<td>'+datas.crm_code+'</td>';
				str += '	<td>'+datas.cust_kor_name+'</td>';
				str += '</tr>';
			}
			
			$("#searchCnt").html(custSearchList.length);
		}
		$("#custSearchBlock").html(str);
	}
	
	function addSelectList(){
		
		var tmpCrmCode;
		var tmpChk;
		var tmpObj;
		var tmpIdx;
		
		$("#custSearchBlock input[type=checkbox]").each(function(){
			if ($(this).prop("checked")){
				
				tmpCrmCode = $(this).val();
				tmpObj = null;
				tmpIdx = -1;
				
				for (var i=0; i < custSearchList.length ; i++){
					if (custSearchList[i].crm_code == tmpCrmCode){
						tmpObj = custSearchList[i];
						tmpIdx = i;
						break;
					}
				}
				
				tmpChk = false;
				for (var i=0; i < custSelectList.length ; i++){
					if (custSelectList[i].crm_code == tmpCrmCode){
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
		
		var tmpCrmCode;
		
		$("#custSelectBlock input[type=checkbox]").each(function(){
			if ($(this).prop("checked")){
				
				tmpCrmCode = $(this).val();
				
				for (var i=0; i < custSelectList.length ; i++){
					if (custSelectList[i].crm_code == tmpCrmCode){
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
				str += '	<td><input type="checkbox" title="거래처 선택" value="'+datas.crm_code+'" onclick="uncheck(\'selectChk\')"/></td>';
				str += '	<td>'+datas.crm_code+'</td>';
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
						$('#noticeNum').html(common.nvl(info.notice_num,''));
						$('#reg_date').html( (common.nvl(info.reg_date,'')).substr(0,10) );
						$('#emp_nm').html(common.nvl(info.emp_nm,''));
						$('#cnt').html(common.nvl(info.cnt,''));
						
						$('#deadline').val(makeDate(common.nvl(info.deadline, ''))) ;
						
						window.location.hash = 'seq=' + common.nvl(info.notice_num,'');

						var reg_id = jQuery.trim(common.nvl(info.reg_id, '')).toUpperCase();
						var group_userid = jQuery.trim('${adUserInfo.emp_no}').toUpperCase();
						var emp_grade = jQuery.trim('${adUserInfo.emp_grade}').toUpperCase();
						
						
						if (reg_id == group_userid || emp_grade == 'C001') {

							$('#title').val(common.nvl(info.title,''));
							$('#content').val(common.nvl(info.content,''));
							$('#highlight_words').val(common.nvl(info.highlight_words,''));
							smEditorLoad();
						} else {
							$('#title_view').html(common.nvl(info.title,''));
							$('#highlight_view').html(common.nvl(info.highlight_words,''));
							$('#content1').hide();
							$('#content2').html(common.nvl(info.content,'')).show();//.css({'width': '960px', 'overflow-x':'auto'});
							
							//console.log(common.nvl(info.content,''));
							
							$('#btnConfirm').hide();
						}
						
						// 20171116 박승모 초기 데이터 셋팅 추가
						$(":input:radio[name=open_type]:input[value="+info.open_type+"]").attr("checked",true).click();
						
						//2024.05.07 김규민 중요공지 옵션 추가
						$(":input:radio[name=imp_type]:input[value="+info.imp_type+"]").attr("checked",true).click();
						
						commonCode.getCodeList('AS' , 'CD03', 'work_type');
						
						if (common.nvl(info.work_type,'') !=''){
							$("#work_type").val(info.work_type);
						}
						
						if (common.nvl(info.work_type,'') !=''){
							commonCode.getCodeList('AS' , info.work_type, 'work_type2');
							$("#work_type2").show().val(info.work_type2);
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
			histStr += '	<td>'+ datas.crm_code +'</td>';
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
		
		if (common.nvl(f.work_type.value,'') == ''){
			alert('업무유형을 선택하세요');
			$('#work_type').focus();
			return;
		}
		
		if (f.work_type.value != 'P013' && common.nvl(f.work_type2.value,'') == ''){
			alert('상세 업무유형을 선택하세요');
			$('#work_type2').focus();
			return;
		}
		
		f.imp_type.value =  $(":input:radio[name=imp_type]:checked").val();
		
		var datePattern = /^\d{4}\/\d{2}\/\d{2}$/;
		 
		var enteredDate = f.deadline.value;
		
		if (f.imp_type.value == 'C001' && enteredDate === ""){
			alert('중요공지 마감일자를 입력해 주세요');
			$('#deadline').focus();
			return;
		}
		
		if (f.imp_type.value == 'C001' && !datePattern.test(enteredDate)){
			 alert('중요공지 마감일자를 형식에 맞게 기입해주세요.\n예시 : ' + formatDate(new Date()));
			 $('#deadline').val("");
			 $('#deadline').focus();
			 return;
		 }
		
		// crmCodeArr 값 셋팅하기
		f.open_type.value =  $(":input:radio[name=open_type]:checked").val();
		
		if (f.open_type.value == 'C003'){
			
			if (custSelectList.length < 1){
				alert('거래처를 선택하세요');
				return;
			}
			
			var tmpStr = '';
			for (var i=0; i < custSelectList.length; i++){
				tmpStr += ',' + custSelectList[i].crm_code;
			}
			

			f.crmCodeArr.value = tmpStr.substr(1);
		}
		
		var content = f.content.value;

		$('#noticecount').val("1")
		$('#noticeallcount').val("1")
		$('#noticeonlyadcount').val("1")
		$('#noticecustcount').val("1")
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
	    		
	    		if($(":input[name='open_type']:checked").val() == 'C001'){
	    		common.ajaxCall(datas, '/ad/board/getNoticeallexist.do','setNoticeallexist'); //공지사항 번호 전체공지 유형 검토
	    		
	    		if($('#noticeallcount').val() == 0){
		    		alert("공지사항(" + number + ")을 수정해주세요.");
		    	}
	    		
	    	}else if($(":input[name='open_type']:checked").val() == 'C003'){
	    		common.ajaxCall(datas, '/ad/board/getNoticeallexist.do','setNoticeallexist'); //공지사항 번호 전체공지 유형 검토
	    		
	    		common.ajaxCall(datas, '/ad/board/getNoticecustexist.do','setNoticecustexist'); //공지사항 번호 거래처공지 유형 검토
	    		
	    		if($('#noticeallcount').val() == 0){
	    			if($('#noticecustcount').val() == 0){
	    				alert("공지사항(" + number + ")을 수정해주세요.");
	    			}else{
	    				
	    			}
	    		}else{
		
	    		}
	    	}
	    }
	    	
	        return '<a onclick="noticelistDetail(\'update\', \'' + number + '\');" style="cursor:pointer;" target="_blank">공지사항(' + number + ')</a>';
	    
	    });
	    
	    
	    if($('#noticecount').val() == 0 || $('#noticeallcount').val() == 0 || $('#noticecustcount').val() == 0){
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
		
		if (confirm("작성된 정보로 공지사항을 등록하시겠습니까?")) {	
			f.target = "hiddenFrame" ; 
			f.action = "/ad/notice/proc.do" ; 
			f.submit();
		}
	}
	
	function formatDate(date) {
	    var year = date.getFullYear();
	    var month = ('0' + (date.getMonth() + 1)).slice(-2);
	    var day = ('0' + date.getDate()).slice(-2);
	    return year + '/' + month + '/' + day;
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
	
	function setNoticecustexist(data){
		var result = data.resultList != "undefined" ? data.resultList : null;
		
		var allIncluded = true; 
		
		for (var i = 0; i < custSelectList.length; i++) {
		    var found = false; 
		    for (var j = 0; j < result.length; j++) {
		        if (custSelectList[i].crm_code == result[j].CRM_CODE) {
		            found = true;
		            break;
		        }
		    }
		    if (!found) {
		        allIncluded = false; // 포함되지 않는 crm_code 발견
		        break; // outer loop 종료
		    }
		}
		
		if (!allIncluded) {
			alert("아래 공지사항 번호는 선택한 거래처에 대해 사용할 수 없습니다.");
			$('#noticecustcount').val("0");
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
		f.action="/ad/notice/list.do";
		f.submit();
	}
	
	function getSubCode(val){
		if (val == "001"){
			commonCode.getCodeList('CUST' , 'CD01' , 'search_type9');
			$("#search_type9").show();
			$("#search_type8").hide();
			$("#search_type7").hide();
		}else if (val == "002"){
			commonCode.getCodeList('CUST' , 'P001' , 'search_type9');
			$("#search_type9").show();
			$("#search_type8").hide();
			$("#search_type7").hide();
		}else if (val == "003"){
			$("#search_type9").hide();
			$("#search_type8").hide();
			$("#search_type7").show();
		}
	}
	
	function chkSubSearch(val){
		if ($("#search_type10").val() == "002"){
			commonCode.getCodeList('CUST' , val , 'search_type8');
			$("#search_type8").show();
		}
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
<input type="hidden" name="pageGubun" id="pageGubun" value="notice" />
<input type="hidden" name="pageType" id="pageType" value="${ vo.pageType }" />
<input type="hidden" name="page" id="page" value="${ vo.page }" />
<input type="hidden" name="board_gbn" id="board_gbn" value="0000" />
<input type="hidden" name="addCnt" id="addCnt" />
<input type="hidden" name="attach_seq" id="attach_seq" value="0"/>
<input type="hidden" name="del_attach_seq" id="del_attach_seq" />
<input type="hidden" name="del_attach_ord" id="del_attach_ord" />
<input type="hidden" name="seq" id="seq" value="${ vo.seq }" />
<input type="hidden" name="seq2" id="seq2" value="${ vo.seq }" />
<input type="hidden" name="listNum" id="listNum" value="${ vo.listNum }" />
<input type="hidden" name="search_start" id="search_start" value="${ vo.search_start }" />
<input type="hidden" name="search_end" id="search_end" value="${ vo.search_end }" />
<input type="hidden" name="crmCodeArr" id="crmCodeArr" value="" />


<!-- 검색어 유지를 위한 부분 -->
<input type="hidden" name="search_type1" id="search_type1" value="${ vo.search_type1 }" />
<input type="hidden" name="search_type2" id="search_type2" value="${ vo.search_type2 }" />
<input type="hidden" name="search_type3" id="search_type3" value="${ vo.search_type3 }" />
<input type="hidden" name="search_type4" id="search_type4" value="${ vo.search_type4 }" />
<input type="hidden" name="search_type5" id="search_type5" value="${ vo.search_type5 }" />
<input type="hidden" name="search_type6" id="search_type6" value="${ vo.search_type6 }" />
<input type="hidden" name="search_text" id="search_text" value="${ vo.search_text }" />

<input type="hidden" name="noticecount" id="noticecount" value="1" />
<input type="hidden" name="noticeallcount" id="noticeallcount" value="1" />
<input type="hidden" name="noticeonlyadcount" id="noticeonlyadcount" value="1" />
<input type="hidden" name="noticecustcount" id="noticecustcount" value="1" />
<input type="hidden" name="faqcount" id="faqcount" value="1" />
<input type="hidden" name="faqallcount" id="faqallcount" value="1" />
<input type="hidden" name="downcount" id="downcount" value="1" />
<input type="hidden" name="drugfaqcount" id="drugfaqcount" value="1" />
<input type="hidden" name="videofaqcount" id="videofaqcount" value="1" />

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
		<th scope="row">노출구분</th>
		<td>
			<input type="radio" name="open_type" value="C001" class="mgr5" onclick="$('#receiver_section').hide();$('#receiver_section2').hide()" checked>전체공지<span class="mgr20"></span>
			<input type="radio" name="open_type" value="C002" class="mgr5" onclick="$('#receiver_section').hide();$('#receiver_section2').hide()">직원공지<span class="mgr20"></span>
			<input type="radio" name="open_type" value="C003" class="mgr5" onclick="$('#receiver_section').show();$('#receiver_section2').show()">거래처공지<span class="mgr20"></span>
		</td>
	</tr>
	<tr>
		<th scope="row">중요구분</th>
		<td>
			<input type="radio" name="imp_type" value="C001" class="mgr5" onclick="$('#deadline_section').show()">중요공지<span class="mgr20"></span>
			<input type="radio" name="imp_type" value="C002" class="mgr5" onclick="$('#deadline_section').hide()" checked>일반공지<span class="mgr20"></span>
		</td>
	</tr>
	<tr id = "deadline_section" style="display:none;">
		<th scope="row">중요공지 마감일자</th>
		<td>
			<input type="text" name="deadline" id="deadline" title="중요공지 마감일자" class="w120 mgr5" />
		</td>
	</tr>
	<tr>
		<th scope="row">시스템유형 선택</th>
		<td>
			<select id="work_type" name="work_type" class="w200" title="시스템유형 선택" onchange="commonCode.getCodeList('AS' , this.value , 'work_type2');$('#work_type2').show()">
				<option>선택해주세요</option>
			</select>
			<select style="display:none;" id="work_type2" name="work_type2" class="w200" title="시스템유형 선택">
			</select>
		</td>
	</tr>
	<tr id="receiver_section" style="display:none;">
		<th scope="row">거래처검색 선택</th>
		<td>
			<select id="search_type10" name="search_type10" class="w200" title="거래처 검색 유형 선택" onchange="getSubCode(this.value)">
				<option value="">선택해주세요</option>
				<option value="001">거래처구분</option>
				<option value="002">HIS버전</option>
				<option value="003">거래처명 직접입력</option>
			</select>
			<select style="display:none;" id="search_type9" name="search_type9" class="w200" title="선택" onchange="chkSubSearch(this.value)">
				<option value="">선택해주세요</option>
			</select>
			<select style="display:none;" id="search_type8" name="search_type8" class="w200" title="선택">
				<option value="">선택해주세요</option>
			</select>
			<input style="display:none;" type="text" id="search_type7" name="search_type7" class="w200" title="거래처명 입력" onkeypress="if( event.keyCode==13 ){custSearch();}"/>
			
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
							<th>CRM코드</th>
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
							<th>CRM코드</th>
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
		<th scope="row">강조키워드</th>
		<td id="highlight_view">
			<input type="text" class="w100p" id="highlight_words" name="highlight_words" title="강조키워드 입력" />
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
