<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="egovframework.com.comm.util.DateTimeUtil"%>

<script type="text/javascript">
	$(document).ready(function(){
		commonCode.getCodeList('COMMON' , 'CD02' , 'use_type') ; 				/**	계정 상태		*/
		commonCode.getCodeList('COMMON' , 'CD06' , 'phone1') ; 				/**	핸드폰 앞자리	*/
		
		//계정추가
		<c:if test="${ vo.pageType ne 'update'}">
			$("select[name='use_type'] option[value='C001']").remove();
			$("select[name='use_type'] option[value='C002']").remove();
			$("select[name='use_type'] option[value='C003']").remove();
			$("select[name='use_type'] option[value='C004']").remove();
			$("select[name='use_type'] option[value='C005']").remove();
			
		</c:if>
		//계정변경
		<c:if test="${ vo.pageType ne 'insert'}">
			$("select[name='use_type'] option[value='C004']").remove();
			$("select[name='use_type'] option[value='C005']").remove();
			initView();
		</c:if>
	}) ; 
	
	function initView(){
		var datas = {'emp_id' : '${ vo.emp_id }' , 'is_page_gbn' : 'fr'}
		common.ajaxCall(datas , '/ad/member/getMemberInfo.do', 'makeMemberInfo') ;
	}
	
	function goList(){location.href = "/fr/member/list.do" ; }
	
	function goSave(){
		var f = document.procFrm ; 
		
		 if(common.isEmpty($('#emp_id').val())){
			alert('아이디를 입력해 주세요.') ; return ; 
		}
		
		
		if(common.isEmpty($('#use_type').val())){
			alert('계정상태를 선택해 주세요.') ; return ; 
		}
		
		<c:if test="${ vo.pageType eq 'insert'}">
		if(common.isEmpty($('#pass').val())){
			alert('비밀번호를 입력해 주세요.') ; return ; 
		}
		
		if(common.isEmpty($('#pass_confirm').val())){
			alert('비밀번호 재입력을 입력해 주세요.') ; return ; 
		}
		
		
		if($('#pass').val() != $('#pass_confirm').val()){
			alert('비밀번호를 확인해 주세요.') ; return ; 
		}		
		
		if(common.isNotEmpty($('#pass').val())){
			var minlen = 8;
			var maxlen = 20;  
			if (($('#pass').val().length < minlen) || ($('#pass').val().length > maxlen)) {
				alert('변경하실 비밀번호를 최소 8자리 이상 20자리 이하로 입력해주세요.');
				$('#pass_confirm').val('');
				$('#pass').focus();
				return;
			}
		}			
		</c:if>
		
		
		if(common.isEmpty($('#emp_name').val())){
			alert('이름을 입력해 주세요.') ; return ; 
		}
		
		if(common.isEmpty($('#email1').val()) || common.isEmpty($('#email2').val())){
			alert('이메일을 입력해 주세요.') ; return ; 
		}
		
		if(common.isEmpty($('#phone1').val()) || common.isEmpty($('#phone2').val()) || common.isEmpty($('#phone3').val())){
			alert('핸드폰 연락처를 입력해 주세요.') ; return ; 
		}
		
		
		if(common.isEmpty($('#cp_phone1').val()) || common.isEmpty($('#cp_phone2').val()) || common.isEmpty($('#cp_phone3').val())){
			alert('회사 전화번호를 입력해 주세요.') ; return ; 
		}
		
		
		
		if(common.isNotEmpty($('#email1').val()) && common.isNotEmpty($('#email2').val())){
			$('#email').val($('#email1').val() + "@" + $('#email2').val()) ; 
		}
		
		if(common.isNotEmpty($('#phone1').val()) && common.isNotEmpty($('#phone2').val()) && common.isNotEmpty($('#phone3').val())){
			$('#tel_no').val($('#phone1').val() + "-" + $('#phone2').val() + "-" + $('#phone3').val()) ; 
		}
		
		if(common.isNotEmpty($('#cp_phone1').val()) && common.isNotEmpty($('#cp_phone2').val()) && common.isNotEmpty($('#cp_phone3').val())){
			$('#company_no').val($('#cp_phone1').val() + "-" + $('#cp_phone2').val() + "-" + $('#cp_phone3').val()) ; 
		}
		
		$('#approval_auth').val("C001");
		
		if(!confirm('저장하시겠습니까?')) return ; 
		common.ajaxCall($('form[name=procFrm]').serialize() , '/fr/member/regist.do', 'registResult') ;
		
		
	}
	
	function passClear(){
		if(!confirm('비밀번호를 초기화 하시겠습니까?')) return ; 
		var datas = {'emp_id' 		: '${ vo.emp_id }' ,	'pageType' 	: 'passChange' , 'emp_id' : $('#emp_id').val()} ; 
		common.ajaxCall(datas , '/fr/member/regist.do', 'registResult') ;
	}
	
	function registResult(data){
		var msg = "" ; 
		var returnCode = typeof data.returnCode != "undefined" ? data.returnCode : "888" ; 
		var pageType = typeof data.pageType != "undefined" ? data.pageType : "" ; 
		
		if(returnCode == "888") msg = "비정상적인 실행 입니다." ; 
		else if(returnCode == "999") msg = "처리도중 오류가 발생했습니다." ; 
		else if(returnCode == "100") msg = "선택된 회원 정보가 없습니다." ; 
		else if(returnCode == "200") msg = "데이터를 확인해 주세요." ; 
		else if(returnCode == "300") msg = "이미 대표계정이 존재합니다." ; 
		else if(returnCode == "400") msg = "동일한 아이디가 존재합니다." ; 
		else if(returnCode == "600") msg = "변경 비밀번호를 대소문자 구분 + 숫자 + 특수문자 포함 8자리 이상 입력해 주세요." ;   			
		else if(returnCode == "000") msg = "정상처리 되었습니다." ;
		
		alert(msg) ; 
		if(returnCode == "000" && pageType != "passChange") goList() ; 
	}
	
	function makeMemberInfo(data){
				
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null ; 
		
		if(resultVO != null){
			
			$('#emp_id').val(common.nvl(resultVO.emp_id, '')) ; 
			$('#use_type').val(common.nvl(resultVO.use_type, '')) ; 
			$('#join_date').empty().text(common.nvl(resultVO.join_date, '')) ; 
			$('#emp_name').val(common.nvl(resultVO.emp_name, '')) ; 
			$('#dept1_nm').val(common.nvl(resultVO.dept1_nm, '')) ;
			$('#dept2_nm').val(common.nvl(resultVO.dept2_nm, '')) ; 			
			$('#dept_grade_nm').val(common.nvl(resultVO.dept_grade_nm, '')) ;
			
			$('#email1').val(common.spritStr(resultVO.email , 1, '@')) ; 
			$('#email2').val(common.spritStr(resultVO.email , 2, '@')) ;
			
			$('#phone1').val(common.spritStr(resultVO.tel_no , 1, '-')) ; 
			$('#phone2').val(common.spritStr(resultVO.tel_no , 2, '-')) ; 
			$('#phone3').val(common.spritStr(resultVO.tel_no , 3, '-')) ;
			
			$('#cp_phone1').val(common.spritStr(resultVO.company_no , 1, '-')) ; 
			$('#cp_phone2').val(common.spritStr(resultVO.company_no , 2, '-')) ; 
			$('#cp_phone3').val(common.spritStr(resultVO.company_no , 3, '-')) ;
			
			$('#approval_auth').val(common.nvl(resultVO.as_approval_yn, '')) ; 		
			$('#lock_yn').val(common.nvl(resultVO.lock_yn, '')) ; 	//로그인 lock 여부				
		}
	}
	
	
	$(document).ready(function(){
		$("#emp_id").on("keyup",chkId);
	});
	
	function chkId(){

		var inputId = $("#emp_id").val();
		if (inputId == ""){
			$("#label-id").removeClass("red").html("");
			return;
		}
		
		var datas = {'emp_id':inputId};
		
		$.ajax({
			type			: 'POST',
			url				: '/fr/member/checkId.do',
			dataType		: "json",
			async 			: true,
			data			: datas,
			success: function(data) {
				if (data.returnCode == "1"){
					$("#label-id").addClass("red").html("** 사용할 수 없는 아이디 입니다.");
// 					$("#emp_id").focus();
					
				}else{
					$("#label-id").removeClass("red").html("사용할 수 있는 아이디 입니다.");
				}
			}
		});
	}
	
	function clearLabel(){
		$('#label-id').html('');
	}
	
</script>

<div id="jw_contents">
	<div class="tit_wrap">
		<h2 class="tit_ico_admin">계정 관리</h2>
		<div class="location">
			<a href="/fr/main/list.do" class="home">Home</a>
			<a href="/fr/member/list.do" class="depth"><span class="here">계정관리</span></a>
		</div>
	</div>
	<!-- A/S 신청 제품 정보 -->
	
	<form name="procFrm" id="procFrm" method="post" onsubmit="return false;">
		<input type="hidden" name="pageType" value="${ vo.pageType }" />
		<input type="hidden" name ="tel_no" 	id="tel_no" 		value=""/>
		<input type="hidden" name ="company_no" 	id="company_no" 		value=""/>
		<input type="hidden" name ="approval_auth" 	id="approval_auth" 		value=""/>	
		<input type="hidden" name ="dept2_nm" 	id="dept2_nm" 		value="${ frUserInfo.dept1_nm }"/> 			
		<input type="hidden" name ="email" 		id="email" 		value=""/>
	
		<table class="sType mgb30">
			<caption>A/S 신청 제품 정보 입력</caption>
			<colgroup>
				<col style="width:130px;" />
				<col style="width:203px;" />
				<col style="width:130px;" />
				<col style="width:203px;" />
				<col style="width:130px;" />
				<col style="width:203px;" />
			</colgroup>
			<tr>
				<th scope="row">아이디<span class="request">필수입력</span></th>
				<td colspan="5">
					<input type="text" style="width:163px" id="emp_id" name="emp_id" maxlength="15" <c:if test="${ vo.pageType eq 'update'}">readonly="readonly"</c:if>>
					<span style="padding-left:10px" id="label-id" class="red"></span>
				</td>
			</tr>
			<tr>
				<th scope="row">계정상태<span class="request">필수입력</span></th>
				<td>
					<select name="use_type" id="use_type" ></select>
				</td>
				<th scope="row">계정생성일</th>
				<td id="join_date">
					<%= DateTimeUtil.getDateText(DateTimeUtil.getDate()) + " " + DateTimeUtil.getTimeText(DateTimeUtil.getTime()) %>
				</td>
				<th scope="row">LOCK여부<span class="request">필수 입력</span></th>
				<td colspan="3">
					<select  id="lock_yn" name="lock_yn" title="로그인 lock여부 선택">
						<!-- <option value="${ vo.lock_yn}">'+${ vo.lock_yn}+'</option> --> 
						<!-- <option value=\''+common.nvl(resultVO.lock_yn, '')+'\'>'+common.nvl(resultVO.lock_yn, '')+'</option> -->					
						<option value="Y">Y</option>
						<option value="N" selected="selected">N</option>					
					</select>				
				</td>					
			</tr>
			
			<c:choose>
				<c:when test="${ vo.pageType eq 'update' }">
				<tr>
					<th scope="row">비밀번호 초기화</th>
					<td colspan="5">
						<button type="button" class="btn_line_gray w80" onclick="javascript:passClear();">초기화</button><span class="notify_red mgl20">※ 초기화 시 초기비번(*Abc1234)으로 설정됩니다.</span>
					</td>
				</tr>	
				</c:when>
				<c:otherwise>
					<tr>
					    <th scope="row">비밀번호<span class="request">필수입력</span></th>
					    <td><input type="password" id="pass" name="pass"></td>
					    <th scope="row">비밀번호 재입력</th>
					    <td><input type="password" id="pass_confirm"></td>
					    <!-- <td colspan="2" class="colorRed">※ 영문자, 숫자, 특수문자 또는 이의 조합 4자리 이상 12자리 이하로 기입해주세요.</td> -->
						<td colspan="2" class="colorRed">※ 변경하실 비밀번호를 입력해주세요. (대소문자 구분 + 숫자 + 특수문자 포함 8자리 이상 20자리 이하)</td>					    
					</tr>
				</c:otherwise>
			</c:choose>
			
			
			
			<tr>
			    <th scope="row">이름<span class="request">필수입력</span></th>
			    <td colspan="5"><input type="text" id="emp_name" name="emp_name"></td>
			</tr>
			<tr>
			    <th scope="row">근무부서명</th>
			    <td colspan="2"><input type="text" id="dept1_nm" name="dept1_nm"></td>
			    <th scope="row">직책</th>
			    <td colspan="2"><input type="text" id="dept_grade_nm" name="dept_grade_nm"></td>
			</tr>
			<tr>
			    <th scope="row">이메일<span class="request">필수입력</span></th>
			    <td colspan="5"><input type="text" class="w150 mgr5" id="email1">@ <input type="text" class="w250 mgl5" id="email2"></td>
			</tr>
			<tr>
			    <th scope="row">연락처(회사)<span class="request">필수입력</span></th>
			    <td colspan="5">
			        <input class="w115 mgr5" id="cp_phone1" type="text"/><input type="text" class="w150 mgr5" id="cp_phone2" maxlength="4"><input type="text" class="w150" id="cp_phone3" maxlength="4">
			    </td>
			</tr>
			<tr>
			    <th scope="row">연락처(핸드폰)<span class="request">필수입력</span></th>
			    <td colspan="5">
			        <select class="w115 mgr5" id="phone1"></select><input type="text" class="w150 mgr5" id="phone2" maxlength="4"><input type="text" class="w150" id="phone3" maxlength="4">
			    </td>
			</tr>
		</table>
	
	</form>

	<div class="btn_wrap">
	    <button type="button" class="btn_ico_list" onclick="javascript:goList();"><span>목록</span></button>
		<div class="floatR">
			<button type="button" class="btn_ico_save" onclick="javascript:goSave();"><span>저장</span></button>
		</div>
	</div>
</div>