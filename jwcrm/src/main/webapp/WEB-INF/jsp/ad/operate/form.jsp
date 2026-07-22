<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="egovframework.com.comm.util.CommonExecute"%>
<style>
	.status_bold {color:#0032c3 !important;font-weight:bold;}
	.block_btn {background-color: #f3f3f3 ; }
</style>


<script type="text/javascript">
	
	$(document).ready(function(){
		
		commonCode.getCodeList('AS' , 'CD07' , 'request_type') ; 			/**	문의유형	   */
		commonCode.getCodeList('AS' , 'CD03' , 'service_cate') ; 			/**	시스템(대)	   */
		commonCode.getCodeList('COMMON' , 'CD16' , 'master_yn') ; 			/**	담당자구분	   */
		$('#inquiry_type').append(commonCode.defaultViewOption);
		getEmpList();
		
		<c:if test="${ vo.pageType ne 'insert'}">
		    initView();
		</c:if>
		
	});
	
	function getEmpList(){
		common.ajaxCall({} , '/ad/as/getAsEmpList2.do', 'makeEmpList2') ;
	}
	
	function makeEmpList2(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		$('#wk_emp_no').empty().append('<option value="">담당자 선택</option>') ; 
		
		if(resultList != null && resultList.length > 0){
			var str = '' ; 
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ;
				
				str += '<option value="'+common.nvl(datas.emp_no, '')+'">'+common.nvl(datas.emp_nm, '')+'</option>' ; 
			}	
			
			$('#wk_emp_no').append(str) ;
		}
	}
	
	function initView() {
		
		var datas = {'oper_seq' : $('#oper_seq').val()} ; 
		common.ajaxCall(datas , '/ad/operate/getOperateInfo.do' , 'setOperateInfo') ; 
	}
	
	
	function setOperateInfo(data) {
		
		var info   = typeof data.info 	!='undefined' ? data.info : null ; //기본정보
		
		if (info != null) {
			  $("#request_type").val(common.nvl(info.request_type,''));    
			  if($('#request_type').val() != ''){
					getTaskType(common.nvl(info.request_type, ''));
				}
			  
			  $("#service_cate").val(common.nvl(info.service_cate,''));

			  
			  if(common.nvl(info.service_cate, '') != ""){
					setService_cate(common.nvl(info.service_cate, ''));
					$('#inquiry_type').val(common.nvl(info.inquiry_type, '')) ;
				}
			  
			  $("#wk_emp_no").val(common.nvl(info.wk_emp_no,''));  
			  $("#master_yn").val(common.nvl(info.master_yn,'')); 
			  $("#use_yn").val(common.nvl(info.use_yn,'')); 
		}
	}
	
	function goProc(){
		
		var request_type = $('#request_type');
		var service_cate = $('#service_cate');
		var inquiry_type = $('#inquiry_type');
		var wk_emp_no = $('#wk_emp_no');
		var master_yn = $('#master_yn');
		var use_yn = $('#use_yn');
			
		if (request_type.val()=='') {
			alert('문의유형을 선택하세요.');
			request_type.focus();
			return;
		}
		
		if ($('#val2').val() == 'Y') {
			if (service_cate.val()=='') {
				alert('시스템(대)을 선택하세요.');
				service_cate.focus();
				return;
			}
			
			if (inquiry_type.val()=='') {
				alert('시스템(소)을 선택하세요.');
				inquiry_type.focus();
				return;
			}
		}
		
		if (wk_emp_no.val()=='') {
			alert('처리담당자를 선택하세요.');
			wk_emp_no.focus();
			return;
		}
		
		if (master_yn.val()=='') {
			alert('담당자구분을 선택하세요.');
			master_yn.focus();
			return;
		}
		
		if (use_yn.val()=='') {
			alert('사용여부를 선택하세요.');
			use_yn.focus();
			return;
		}
		
		common.ajaxCall($('form[name=procFrm]').serialize() , '/ad/operate/proc.do' , 'procReturn') ;
	}
	
	function procReturn(data){
		var returnCode = typeof data.returnCode != "undefined" ? data.returnCode : "002" ; 
		var msg = "" ; 
		
		if(returnCode == "000") msg = "정상적으로 처리 되었습니다." ; 
		else if(returnCode == "002") msg = "처리도중 오류가 발생했습니다." ;
		else if(returnCode == "003") msg = "해당 문의유형:시스템(대):시스템(소)은 해당 담당자로 이미 등록되어 있습니다.\n중복등록은 불가능하니 기존등록을 참고해주세요." ;
		else if(returnCode == "099") msg = "해당 문의유형은 2차 분류 규칙이 정해져있지 않습니다.\n코드상세테이블을 수정해주세요." ; 
		
		alert(msg) ; 
		if(returnCode == "000") {
			location.href = "/ad/operate/list.do" 
		}
	}
	
	
	function goList() {
		location.href = '/ad/operate/list.do${ QUERYSTRING }' ; 
	}

	
	
	function getTaskType(request_type){
		
		$('#service_cate').val('') ;
		$('#inquiry_type').empty() ; 
		
		$('#inquiry_type').append(commonCode.defaultViewOption);
		
		var datas = {
				'request_type' : request_type,
				'pageType' : '${ vo.pageType }'
			}
		
			common.ajaxCall(datas, '/ad/as/getTaskType.do', 'setTaskType');
	}
	
	function setTaskType(data) {
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList
				: null;
		
		commonCode.getCodeList('AS' , 'CD03' , 'service_cate') ;
		
		if (resultList.val2 == 'Y') {
			$('#system_type').show();
			$('#service_cate').prop('disabled', false).removeClass('write_gray');
			
			if($('#request_type').val() == 'C011'){
				setService_cate("P010");
				$('#service_cate').prop('disabled', true).addClass('write_gray');
				$('#service_cate').val("P010");
			}else{
				$('#service_cate').find('option[value="P010"]').remove();
				$('#service_cate').prop('disabled', false).removeClass('write_gray');
				
			}
			
		} else {
			
			$('#system_type').hide();
			
			$('#version_info').val('') ; 
			$('#version_info_str').val('') ;
		
		}
		
		$('#val2').val(resultList.val2);
	
	}
	
	function setService_cate(thisObj){
		
		$('#inquiry_type').empty() ; 
		$('#version_info').val('') ; 
		$('#version_info_str').val('') ; 
		
		if(thisObj != ""){
			commonCode.getCodeList('AS' , thisObj , 'inquiry_type') ;
		}else{
			$('#inquiry_type').append(commonCode.defaultViewOption);	
		}
	}

	
</script>

<div class="tit_wrap">

	<h2 class="tit_ico_customer">처리담당자 관리<span class="tit_depth mgl20 mgt8">운영정보</span></h2>
	
</div>
 
<form name="procFrm" method="post" onsubmit="return false;">

	<input type="hidden" name="oper_seq"  	id="oper_seq"       value="${ vo.oper_seq }"/>
	<input type="hidden" name="pageType"    id="pageType" 	    value="${ vo.pageType }"/>
	
	<input type="hidden" name="val2" id="val2" value=""/>

<div class="tit_bWrap clearB mgb10">
	<h4>처리담당자 정보</h4>
</div>

<table class="sType mgb20">
	<caption>처리담당자 정보 입력</caption>
	<colgroup>
		<col style="width:125px;" />
		<col style="width:375px;" />
		<col style="width:125px;" />
		<col style="width:375px;" />
	</colgroup>
	<tr>
		<th scope="row">문의유형<span class="request">필수입력</span></th>
		<td>
			<select  title="문의유형 선택" name="request_type" id="request_type"  onchange="javascript:getTaskType(this.value);"></select>
		</td>
		<th scope="row">담당자구분<span class="request">필수입력</span></th>
		<td colspan="3">
			<select  name="master_yn" id="master_yn" title="담당자구분 선택" class="w340"></select>
		</td>
	</tr>
	<tr id="system_type" style="display: none;">
		<th scope="row">시스템(대)<span class="request">필수입력</span></th>
		<td>
			<select title="시스템(대) 선택" name="service_cate" id="service_cate" onchange="javascript:setService_cate(this.value);"></select>
		</td>
		<th scope="row">시스템(소)<span class="request">필수입력</span></th>
		<td colspan="3">
			<select title="시스템(소) 선택" id="inquiry_type" name="inquiry_type" class="w340"></select>
		</td>
	</tr>
	<tr>
		<th scope="row">담당자<span class="request">필수입력</span></th>
		<td>
			<select  name="wk_emp_no" id="wk_emp_no" title="담당자" ></select>
		</td>
		<th scope="row">사용여부<span class="request">필수입력</span></th>
		<td colspan="3">
			<select  name="use_yn" id="use_yn" title="사용여부 선택" class="w340">
				<option value="Y">사용</option>
				<option value="N">미사용</option>
			</select>
		</td>
	</tr>

</table>

<!--// list -->
<div class="btn_wrap">
	<div class="floatL">
		<button type="button" class="btn_ico_list" onclick="goList();"><span>목록</span></button>
	</div>
	<div class="floatR">
		<c:if test="${ adUserInfo.emp_grade eq 'C001'}">
		<button type="button" class="btn_ico_confirm" id="btnView1" onclick="goProc();"><span>저장</span></button>
		</c:if>
	</div>
</div>
</form>



