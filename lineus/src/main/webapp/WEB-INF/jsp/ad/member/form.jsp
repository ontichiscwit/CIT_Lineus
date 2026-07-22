<%@page import="egovframework.com.comm.util.CommonExecute"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="egovframework.com.comm.util.DateTimeUtil"%>
<script type="text/javascript">
	$(document).ready(function(){
		
		if('update' == '${ vo.pageType }'){
			$('#showHide1').show() ; 
			$('#showHide3').show() ; 
		}else{
			$('#showHide2').show() ;
		}
		
		commonCode.getCodeList('COMMON' , 'CD02' , 'use_type') ; 			/**	계정 상태		 */
		commonCode.getCodeList('COMMON' , 'CD06' , 'phone1') ; 				/**	핸드폰 앞자리	 */
		commonCode.getCodeList('COMMON' , 'CD05' , 'approval_auth') ; 		/**	AS결재자		 */
		commonCode.getCodeList('COMMON' , 'CD01' , 'emp_grade') ; 			/**	회원 등급		 */
		
		<c:if test="${ vo.pageType ne 'insert'}">initView();</c:if>
		<c:if test="${ vo.pageType eq 'insert'}">
			$('#use_type').val('C006');
			$('#lock_yn').val('N');
			$("select[name='use_type'] option[value='C001']").remove();
			$("select[name='use_type'] option[value='C002']").remove();
			$("select[name='use_type'] option[value='C003']").remove();
			$("select[name='use_type'] option[value='C004']").remove();
			$("select[name='use_type'] option[value='C005']").remove();
		</c:if>
		
		//팝업창 Enter 검색 기능.
		$("#searchKorName").keyup(function(e){if(e.keyCode == 13)  custList(1); });
		
	}) ; 
	
	/**	거래처 조회	*/
	function showLayer(){
		$('#div1').show() ;
		$('#div1').css('height' , '710') ; 
		$('#div_dim').show() ; 
		custList(1) ; 
		$('#searchKorName').attr( 'autofocus','autofocus');
		$('[autofocus]:not(:focus)').eq(0).focus();
	}
	
	function goList(){
		location.href = "/ad/member/list.do${ QUERYSTRING }"
	}
	
	function clearPass(){
		
		if(!confirm('비밀번호를 초기화 하시겠습니까?')) return ; 
		var datas = {'seq' 				: '${ vo.seq }' ,	'pageType' 	: 'passChange' , 'emp_id' : $('#emp_id').val()}
		common.ajaxCall(datas , '/ad/member/registMember.do', 'registResult') ;
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
	
	function goSave(){
		
		
		if(common.isEmpty($('#erp_code').val())){
			alert("거래처를 선택해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#emp_grade').val())){
			alert("계정유형을 선택해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#emp_id').val())){
			alert("아이디를 입력해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#use_type').val())){
			alert("계정상태를 선택해 주세요.") ; 
			return ; 
		}
		
		<c:if test="${ vo.pageType eq 'insert'}">
		if(common.isEmpty($('#pass').val())){
			alert("비밀번호를 입력해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#pass_confirm').val())){
			alert("비밀번호 재입력을 입력해 주세요.") ; 
			return ; 
		}
		
		if($('#pass').val() != $('#pass_confirm').val()){
			alert("비밀번호를 확인해 주세요.") ; 
			return ; 
		}
		
		if (common.isNotEmpty($('#pass').val())) { 
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
			alert("이름을 입력해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#email1').val())){
			alert("이메일을 입력해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#email2').val())){
			alert("이메일을 입력해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#cp_phone1').val())){
			alert("연락처를 입력해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#cp_phone2').val())){
			alert("연락처를 입력해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#cp_phone3').val())){
			alert("연락처를 입력해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#approval_auth').val())){
			alert("AS결재권한을 선택해 주세요.") ; 
			return ; 
		}
		
		
		<c:if test="${ vo.pageType eq 'insert'}">
			if( $('#inout_gubun').val() == "C001" && $('#emp_grade').val() == "C002") {
				if($('#emp_id').val().length != 8){ 
					alert('입력한 아이디를 확인하세요 JW그룹웨어 사번을 사용하세요'); 
					return;
					};
				}
			/* if( $('#inout_gubun').val() == "C002" && $('#emp_grade').val() == "C001") {if( $('#emp_id').val().substring(0,1).match(/[^a-zA-Z]/) == null )alert('입력한 아이디를 확인하세요 첫문자는 영어로 기입하세요'); return;}
			if( $('#inout_gubun').val() == "C002" && $('#emp_grade').val() == "C002") {if( $('#emp_id').val().substring(0,1).match(/[^a-zA-Z]/) == null )alert('입력한 아이디를 확인하세요 첫문자는 영어로 기입하세요'); return;}
			if( $('#inout_gubun').val() == "C003" && $('#emp_grade').val() == "C001") {if( $('#emp_id').val().substring(0,1).match(/[^a-zA-Z]/) == null )alert('입력한 아이디를 확인하세요 첫문자는 영어로 기입하세요'); return;}
			if( $('#inout_gubun').val() == "C003" && $('#emp_grade').val() == "C002") {if( $('#emp_id').val().substring(0,1).match(/[^a-zA-Z]/) == null )alert('입력한 아이디를 확인하세요 첫문자는 영어로 기입하세요'); return;}
			 */
			 //사번확인필요if( $('#inout_gubun').val() == "C004" && $('#emp_grade').val() == "C002") {if( $('#emp_id').val().substring(0,1).match(/[^a-zA-Z]/) != null )alert('입력한 아이디를 확인하세요 첫문자는 영어로 기입하세요'); return;}
		</c:if>
		
		
		if(!confirm('저장하시겠습니까?')) return ; 
		
		if(common.isNotEmpty($('#email1').val()) && common.isNotEmpty($('#email2').val())){
			$('#email').val($('#email1').val() + "@" + $('#email2').val()) ; 
		}
		
		if(common.isNotEmpty($('#phone1').val()) && common.isNotEmpty($('#phone2').val()) && common.isNotEmpty($('#phone3').val())){
			$('#tel_no').val($('#phone1').val() + "-" + $('#phone2').val() + "-" + $('#phone3').val()) ; 
		}
		
		if(common.isNotEmpty($('#cp_phone1').val()) && common.isNotEmpty($('#cp_phone2').val()) && common.isNotEmpty($('#cp_phone3').val())){
			$('#company_no').val($('#cp_phone1').val() + "-" + $('#cp_phone2').val() + "-" + $('#cp_phone3').val()) ; 
		}
		
		common.ajaxCall($('form[name=procFrm]').serialize() , '/ad/member/registMember.do', 'registResult') ;
	}
	
	function custList(custPage){
		var datas = {
				'page' : custPage , 
				'search_text' : $('#searchKorName').val() 
		}
		
		common.ajaxCall(datas , '/ad/member/getCustList.do', 'makeCustList') ;
	}
	
	function makeCustList(data){
		$('#custInfoList').empty() ; 
		$('#layer_pagination').empty() ; 
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var vo = typeof data.vo != "undefined" ? data.vo : null ; 
		
		if(resultList != null && resultList.length > 0){
			var str = '' ; 
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ;
				str += '<tr onclick="javascript:setValue(\''+common.nvl(datas.seq, '')+'\');" style="cursor:pointer;"> ' ;
				str += '	<td>'+common.nvl(datas.rnum , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.cust_gubun_nm , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.cust_kor_name , '')+'['+common.nvl(datas.erp_code , '')+']</td> ' ;
				str += '	<td>'+common.nvl(datas.ceo , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.cust_no , '')+ '</td> ' ;
				str += '	<td>'+common.nvl(datas.cust_address , '')+'</td> ' ;
				str += '</tr> ' ;
			}
			$('#custInfoList').append(str) ; 
			$('#layer_pagination').html(vo.json_paging) ; 
		}else{
			commonTable.notData(5 , '조회된 정보가 없습니다.' , 'custInfoList') ; 
		}
	}
	
	function closeLayer() {
		$('#div1').hide() ; 
		$('#div_dim').hide() ; 
		$('#searchKorName').val('') ; 
		$("#searchKorName").removeAttr( "autofocus" );
	}
	
	function setValue(seq){
		var datas = {'seq' 				: seq }
		common.ajaxCall(datas , '/ad/member/getCustInfo.do', 'makeCustInfo') ;
		closeLayer() ; 
	}
	
	function makeCustInfo(data){
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null ; 
		$('#cust_nm').val(common.nvl(resultVO.cust_kor_name, '')) ; 
		$('#erp_code').val(common.nvl(resultVO.erp_code, '')) ; 
		$('#cust_addr').val(common.nvl(resultVO.cust_address, '')) ; 
		$('#cust_post_no').val(common.nvl(resultVO.zip_code, '')) ; 
		$('#cust_emp_no').val(common.nvl(resultVO.emp_name, '')) ; 
		$('#cust_tel_no').val(common.nvl(resultVO.tel_no, '')) ;
		$('#inout_gubun').val(common.nvl(resultVO.cust_gubun, ''));
		$('#showHide3').show() ; 
	}
	

	function initView(){
		
		var datas = {
				'emp_id' 				: '${ vo.emp_id }'
		}
		common.ajaxCall(datas , '/ad/member/getMemberInfo.do', 'makeMemberInfo') ;
	}
	
	function makeMemberInfo(data){
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null ; 
		//var tab1List = typeof data.tab1List != "undefined" ? data.tab1List : null ; 
		//var tab2List = typeof data.tab2List != "undefined" ? data.tab2List : null ; 
		
		if(resultVO != null){
			$('#cust_nm').val(common.nvl(resultVO.cust_kor_name, '')) ; 
			$('#erp_code').val(common.nvl(resultVO.cust_code, '')) ; 
			$('#cust_addr').val(common.nvl(resultVO.cust_address, '')) ; 
			$('#cust_post_no').val(common.nvl(resultVO.zip_code, '')) ; 
			$('#cust_emp_no').val(common.nvl(resultVO.dam_emp_name, '')) ; 
			$('#cust_tel_no').val(common.nvl(resultVO.dam_tel_no, '')) ;
			
			$('#emp_grade').val(common.nvl(resultVO.emp_grade, '')) ; 
			$('#emp_id').val(common.nvl(resultVO.emp_id, '')) ; 
			$('#use_type').val(common.nvl(resultVO.use_type, '')) ; 
			$('#use_type2').val(common.nvl(resultVO.use_type, '')) ;
			$('#join_date').empty().text(common.nvl(resultVO.join_date, '')) ; 
			$('#emp_name').val(common.nvl(resultVO.emp_name, '')) ; 
			$('#dept1_nm').val(common.nvl(resultVO.dept1_nm, '')) ; 
			$('#dept2_nm').val(common.nvl(resultVO.dept2_nm, '')) ; 
			$('#dept_grade_nm').val(common.nvl(resultVO.dept_grade_nm, '')) ;
			$('#approval_auth').val(common.nvl(resultVO.approval_auth, '')) ;		
			$('#email1').val(common.spritStr(resultVO.email , 1, '@')) ; 
			$('#email2').val(common.spritStr(resultVO.email , 2, '@')) ;
			
			$('#phone1').val(common.spritStr(resultVO.tel_no , 1, '-')) ; 
			$('#phone2').val(common.spritStr(resultVO.tel_no , 2, '-')) ; 
			$('#phone3').val(common.spritStr(resultVO.tel_no , 3, '-')) ; 
			
			$('#cp_phone1').val(common.spritStr(resultVO.company_no , 1, '-')) ; 
			$('#cp_phone2').val(common.spritStr(resultVO.company_no , 2, '-')) ; 
			$('#cp_phone3').val(common.spritStr(resultVO.company_no , 3, '-')) ; 
			
			$('#lock_yn').val(common.nvl(resultVO.lock_yn, '')) ; 	//로그인 lock 여부									
		}
		
	}
	function goView(pageType , seq){
		var f = document.procFrm ; 
		
		f.pageType.value = pageType ; 
		f.seq.value = seq ; 
		
		f.target = '' ; 
		f.action = '/ad/member/form.do' ; 
		f.submit() ; 
	}
	
	
	function setempGradeText(emp_grade){
		
		if( $('#erp_code').val() == "") {alert("거래처를 선택해 주세요."); $('#emp_grade').val(''); return ;} 
		if( $('#inout_gubun').val() == "C001" && emp_grade == "C001") $('#emp_id').attr('placeholder','약어 사용권장  ex) CWIT');
		if( $('#inout_gubun').val() == "C001" && emp_grade == "C002") $('#emp_id').attr('placeholder','JW그룹웨어 사번 사용');
		if( $('#inout_gubun').val() == "C002" && emp_grade == "C001") $('#emp_id').attr('placeholder','첫 문자는 영어사용');
		if( $('#inout_gubun').val() == "C002" && emp_grade == "C002") $('#emp_id').attr('placeholder','첫 문자는 영어사용');
		if( $('#inout_gubun').val() == "C003" && emp_grade == "C001") $('#emp_id').attr('placeholder','첫 문자는 영어사용');
		if( $('#inout_gubun').val() == "C003" && emp_grade == "C002") $('#emp_id').attr('placeholder','첫 문자는 영어사용');
		if( $('#inout_gubun').val() == "C004" && emp_grade == "C001") $('#emp_id').attr('placeholder','약어 사용권장  ex) CWIT');
		if( $('#inout_gubun').val() == "C004" && emp_grade == "C002") $('#emp_id').attr('placeholder','CWIT 사번사용');
		
	}
	
	
</script>
<form name="procFrm" id="procFrm" method="post" onsubmit="return false;">
	<input type="hidden" name ="pageType"   id="pageType" 	value="${ vo.pageType }"/>
	<input type="hidden" name ="seq" 		id="seq" 			value="${ vo.seq }"/>
	<input type="hidden" name ="tel_no" 	id="tel_no" 		value=""/>
	<input type="hidden" name ="company_no" 	id="company_no" 		value=""/>
	<input type="hidden" name ="email" 		id="email" 		value=""/>
	<input type="hidden" name ="inout_gubun"id="inout_gubun" value=""/>
	<input type="hidden" name ="use_type2"  id="use_type2" value=""/>
	
	<div class="tit_wrap">
		<%= CommonExecute.returnLineMap(request) %>
	</div>
	
	<div class="tit_sWrap">
		<h3 class="tit_dot_gray floatL">소속 고객사 정보</h3>
		<span class="tit_depth floatR mgt8" id="showHide1" style="display:none;">상세 보기</span>
	</div>
	
	<table class="sType mgb20" id="showHide2" style="display:none;">
		<caption>소속 고객사 정보</caption>
		<colgroup>
			<col style="width:140px;" />
			<col style="width:auto;" />
		</colgroup>
		<tr>
			<th scope="row">거래처 명</th>
			<td>
				<button type="button" class="btn_line_gray w105" onclick="javascript:showLayer();">조회 / 등록하기</button>
			</td>
		</tr>
	</table>
	
	<table class="sType mgb20" id="showHide3" style="display:none;">
		<caption>소속 고객사 정보</caption>
		<colgroup>
			<col style="width:140px;" />
			<col style="width:360px;" />
			<col style="width:140px;" />
			<col style="width:360px;" />
		</colgroup>
		<tr>
			<th scope="row">거래처 명</th>
			<td>
				<input type="text" readonly="readonly" id="cust_nm" title="거래처 명" value="" />
			</td>
			<th scope="row">거래처 코드</th>
			<td>
				<input type="text" readonly="readonly" id="erp_code" name="erp_code" title="거래처 코드" value="" />
			</td>
		</tr>
		<tr>
			<th scope="row">거래처 주소</th>
			<td>
				<input type="text" readonly="readonly" id="cust_addr" title="거래처 주소" value="" />
			</td>
			<th scope="row">우편번호</th>
			<td>
				<input type="text" readonly="readonly" id="cust_post_no" title="우편번호" value="" />
			</td>
		</tr>
		<tr>
			<th scope="row">거래처 담당자</th>
			<td>
				<input type="text" readonly="readonly" id="cust_emp_no" title="거래처 담당자" value="홍길동" />
			</td>
			<th scope="row">거래처 담당자 연락처</th>
			<td>
				<input type="text" readonly="readonly" id="cust_tel_no" title="거래처 담당자" value="" />
			</td>
		</tr>
	</table>
	
	<div class="tit_sWrap">
		<h3 class="tit_dot_gray">계정 정보</h3>
	</div>
	
	<table class="sType mgb20">
		<caption>계정 정보</caption>
		<colgroup>
			<col style="width:140px;" />
			<col style="width:194px;" />
			<col style="width:140px;" />
			<col style="width:194px;" />
			<col style="width:140px;" />
			<col style="width:192px;" />
		</colgroup>
		<tr>
			<th scope="row">계정유형<span class="request mgl5">필수 입력</span></th>
			<td colspan="5">
				<select id="emp_grade" name="emp_grade" title="계정유형 선택" class="w155" onchange="javascript:setempGradeText(this.value);"></select>
			</td>
		</tr>
		<tr>
			<th scope="row">아이디<span class="request mgl5">필수 입력</span></th>
			<td>
				<input type="text" id="emp_id" name="emp_id" title="아이디" value="" <c:if test="${ vo.pageType eq 'update' }">readonly="readonly"</c:if>/>
			</td>
			<th scope="row">계정상태<span class="request mgl5">필수 입력</span></th>
			<td>
				<select name="use_type" id="use_type" title="계정상태 선택"></select>
			</td>
			<th scope="row">계정생성일<span class="request mgl5">필수 입력</span></th>
			<td id="join_date">
				<%= DateTimeUtil.getDateText(DateTimeUtil.getDate()) + " " + DateTimeUtil.getTimeText(DateTimeUtil.getTime()) %>
			</td>
		</tr>
		<c:choose>
			<c:when test="${ vo.pageType eq 'update' }">
			<tr>
				<th scope="row">비밀번호 초기화</th>
				<td colspan="5">
					<button type="button" class="btn_line_gray w75" onclick="javascript:clearPass();">초기화</button><span class="colorRed mgl5">※ 초기화 시 초기비번(*Abc1234)으로 설정됩니다.</span>
				</td>
			</tr>
			</c:when>
			<c:otherwise>
			<tr>
				<th scope="row">비밀번호<span class="request mgl5">필수 입력</span></th>
				<td>
					<input type="password" id="pass" name="pass" title="비밀번호 초기화"  />
				    <span class="colorRed mgl5">※ 변경하실 비밀번호를 입력해주세요. (대소문자 구분 + 숫자 + 특수문자 포함 8자리 이상 20자리 이하)</span>						
				</td>
				<th scope="row">비밀번호 재입력<span class="request mgl5">필수 입력</span></th>
				<td colspan="3">
					<input type="password" id="pass_confirm" title="비밀번호 재입력"  />
					<span class="colorRed mgl5">※ 변경 하실 비밀번호를 한번 더 입력해주세요.</span>
				</td>
			</tr>
			</c:otherwise>
		</c:choose>
		<tr>
			<th scope="row">이름<span class="request mgl5">필수 입력</span></th>
			<td>
				<input type="text" id="emp_name" name="emp_name" title="이름" class="w155" value="" />
			</td>
			<th scope="row">A/S 결재권한<span class="request mgl5">필수 입력</span></th>
			<td>
				<select  id="approval_auth" name="approval_auth"  class="w155"></select>
			</td>
			<th scope="row">로그인 LOCK여부<span class="request mgl5">필수 입력</span></th>
			<td colspan="3">
				<select  id="lock_yn" name="lock_yn" title="로그인 lock여부 선택" class="w155">
					<!-- <option value="${ vo.lock_yn}">'+${ vo.lock_yn}+'</option> --> 
					<!-- <option value=\''+common.nvl(resultVO.lock_yn, '')+'\'>'+common.nvl(resultVO.lock_yn, '')+'</option> -->				
					<option value="Y">Y</option>
					<option value="N" selected="selected">N</option>					
				</select>				
			</td>			
		</tr>
		<tr>
			<th scope="row">근무부서</th>
			<td>
				<input type="text" id="dept1_nm" name="dept1_nm"  title="근무부서명" class="w155" value="" />
			</td>
			<th scope="row">근무팀</th>
			<td>
				<input type="text" id="dept2_nm" name="dept2_nm" title="계장" class="w155" value="" />
			</td>
			<th scope="row">직책</th>
			<td>
				<input type="text" id="dept_grade_nm" name="dept_grade_nm" title="직책" class="w155" value="" />
			</td>
		</tr>
		<tr>
			<th scope="row">이메일<span class="request mgl5">필수 입력</span></th>
			<td colspan="5">
				<input type="text" id="email1" title="이메일" value="" class="w155" />
				<span class="textC w37">@</span>
				<input type="text" id="email2" title="이메일" value="" class="w155" />
			</td>
		</tr>
		<tr>
			<th scope="row">연락처(회사)<span class="request mgl5">필수 입력</span></th>
			<td colspan="5">
				<input type="text" id="cp_phone1" title="연락처" value="" class="w155" maxlength="4"/>
				<span class="textC w20">-</span>
				<input type="text" id="cp_phone2" title="연락처" value="" class="w60" maxlength="4"/>
				<span class="textC w20">-</span>
				<input type="text" id="cp_phone3" title="연락처" value="" class="w60" maxlength="4"/>
			</td>
		</tr>
		
		<tr>
			<th scope="row">연락처(핸드폰)</th>
			<td colspan="5">
				<select id="phone1" title="연락처" class="w155"></select>
				<span class="textC w20">-</span>
				<input type="text" id="phone2" title="연락처" value="" class="w60" maxlength="4"/>
				<span class="textC w20">-</span>
				<input type="text" id="phone3" title="연락처" value="" class="w60" maxlength="4"/>
			</td>
		</tr>
	</table>
	<div class="btn_wrap">
		<div class="floatL">
			<button type="button" class="btn_ico_list" onclick="javascript:goList();"><span>목록</span></button>
		</div>
		<div class="floatR">
			<button type="button" class="btn_ico_confirm" onclick="javascript:goSave();"><span>저장</span></button>
			<button type="button" class="btn_ico_cancel" onclick="javascript:goList();"><span>취소</span></button>
		</div>
	</div>
</form>

<div class="box_layer layer_sms" style="margin-top:-350px;display:none;" id="div1">
<h1>거래처 정보 조회 검색 결과</h1>
<div class="layer_contents pdt20" style="height:657px;">
	기관명:
	<input type="text" class="w175 mgr10" id="searchKorName" name="searchKorName" title="거래처 정보 검색">
	<button type="button" class="btn_ico_search mgr5" onclick="javascript:custList(1);"><span>검색</span></button>
	<table class="vType_line" style="margin-top: 10px">
		<caption>거래처 정보 목록</caption>
		<colgroup>
			<col style="width:50px;" />
			<col style="width:100px;" />
			<col style="width:150px;" />
			<col style="width:80px;" />
			<col style="width:100px;" />
			<col style="width:auto;" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">No</th>
				<th scope="col">거래처구분</th>
				<th scope="col">기관명</th>
				<th scope="col">대표자</th>
				<th scope="col">사업자등록번호</th>
				<th scope="col">주소</th>
			</tr>
		</thead>
		<tbody id="custInfoList"></tbody>
	</table>
	<div class="page" id="layer_pagination" style="margin-top: 10px;"></div>
</div>
<button type="button" class="btn_close" onclick="javascript:closeLayer();">창 닫기</button>
</div>
<div class="layer_dimmed" style="display:none;" id="div_dim"></div>
