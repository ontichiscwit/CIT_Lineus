<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="egovframework.com.comm.util.DateTimeUtil"%>

<script type="text/javascript">

	var chatbotWindow = null;

	$(document).ready(function(){
		commonCode.getCodeList('COMMON' , 'CD02' , 'use_type') ; 				/**	계정 상태		*/
		/* $("select[name='use_type'] option[value='C001']").remove();
		$("select[name='use_type'] option[value='C002']").remove();
		$("select[name='use_type'] option[value='C003']").remove();
		$("select[name='use_type'] option[value='C004']").remove();
		$("select[name='use_type'] option[value='C005']").remove();
		 */
		commonCode.getCodeList('COMMON' , 'CD03' , 'phone1') ; 				/**	핸드폰 앞자리	*/
		
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
		var datas = {'seq' 				: '${ vo.seq }' , 'is_page_gbn' : 'fr'}
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
		
		if($('#pass').val().length < 4){
			alert('비밀번호는 최소 4자리 이상 기입해주세요.') ; return ; 
		}
		</c:if>
		
		if(common.isEmpty($('#emp_name').val())){
			alert('이름을 입력해 주세요.') ; return ; 
		}
		
		if(common.isEmpty($('#email1').val()) || common.isEmpty($('#email2').val())){
			alert('이메일을 입력해 주세요.') ; return ; 
		}
		
		if(common.isEmpty($('#phone1').val()) || common.isEmpty($('#phone2').val()) || common.isEmpty($('#phone3').val())){
			alert('전화번호를 입력해 주세요.') ; return ; 
		}
		
		if(!confirm('저장하시겠습니까?')) return ; 
		
		if(common.isNotEmpty($('#email1').val()) && common.isNotEmpty($('#email2').val())){
			$('#email').val($('#email1').val() + "@" + $('#email2').val()) ; 
		}
		
		if(common.isNotEmpty($('#phone1').val()) && common.isNotEmpty($('#phone2').val()) && common.isNotEmpty($('#phone3').val())){
			$('#tel_no').val($('#phone1').val() + "-" + $('#phone2').val() + "-" + $('#phone3').val()) ; 
		}

		common.ajaxCall($('form[name=procFrm]').serialize() , '/fr/member/regist.do', 'registResult') ;
	}
	
	function passClear(){
		if(!confirm('비밀번호를 초기화 하시겠습니까?')) return ; 
		var datas = {'seq' 		: '${ vo.seq }' ,	'pageType' 	: 'passChange' , 'emp_id' : $('#emp_id').val()} ; 
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
			$('#dept_name').val(common.nvl(resultVO.dept_name, '')) ; 
			$('#dept_grade').val(common.nvl(resultVO.dept_grade, '')) ;
			
			$('#email1').val(common.spritStr(resultVO.email , 1, '@')) ; 
			$('#email2').val(common.spritStr(resultVO.email , 2, '@')) ;
			
			$('#phone1').val(common.spritStr(resultVO.tel_no , 1, '-')) ; 
			$('#phone2').val(common.spritStr(resultVO.tel_no , 2, '-')) ; 
			$('#phone3').val(common.spritStr(resultVO.tel_no , 3, '-')) ; 
			
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
		<input type="hidden" name="seq" value="${ vo.seq }" />
		<input type="hidden" name ="tel_no" 	id="tel_no" 		value=""/>
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
				<td colspan="3" id="join_date">
					<%= DateTimeUtil.getDateText(DateTimeUtil.getDate()) + " " + DateTimeUtil.getTimeText(DateTimeUtil.getTime()) %>
				</td>
			</tr>
			
			<c:choose>
				<c:when test="${ vo.pageType eq 'update' }">
				<tr>
					<th scope="row">비밀번호 초기화</th>
					<td colspan="5">
						<button type="button" class="btn_line_gray w80" onclick="javascript:passClear();">초기화</button><span class="notify_red mgl20">※ 초기화 시 아이디와 동일한 비밀번호로 설정됩니다.</span>
					</td>
				</tr>	
				</c:when>
				<c:otherwise>
					<tr>
					    <th scope="row">비밀번호<span class="request">필수입력</span></th>
					    <td><input type="password" id="pass" name="pass" maxlength="12"></td>
					    <th scope="row">비밀번호 재입력</th>
					    <td><input type="password" id="pass_confirm" maxlength="12"></td>
					    <td colspan="2" class="colorRed">※ 영문자, 숫자, 특수문자 또는 이의 조합 4자리 이상 12자리 이하로 기입해주세요.</td>
					</tr>
				</c:otherwise>
			</c:choose>
			
			
			
			<tr>
			    <th scope="row">이름<span class="request">필수입력</span></th>
			    <td colspan="5"><input type="text" id="emp_name" name="emp_name"></td>
			</tr>
			<tr>
			    <th scope="row">근무부서명</th>
			    <td colspan="2"><input type="text" id="dept_name" name="dept_name"></td>
			    <th scope="row">직책</th>
			    <td colspan="2"><input type="text" id="dept_grade" name="dept_grade"></td>
			</tr>
			<tr>
			    <th scope="row">이메일<span class="request">필수입력</span></th>
			    <td colspan="5"><input type="text" class="w150 mgr5" id="email1">@ <input type="text" class="w250 mgl5" id="email2"></td>
			</tr>
			<tr>
			    <th scope="row">연락처<span class="request">필수입력</span></th>
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