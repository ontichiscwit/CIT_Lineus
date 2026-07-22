<%@page import="egovframework.com.comm.util.CommonExecute"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="egovframework.com.comm.util.DateTimeUtil"%>
<script type="text/javascript">

	$(document).ready(function(){
		commonCode.getCodeList('COMMON' , 'CD13' , 'part_type') ; 			/**	회원 등급		*/
		commonCode.getCodeList('COMMON' , 'CD04' , 'emp_grade') ; 			/**	회원 등급		*/
		commonCode.getCodeList('COMMON' , 'CD03' , 'phone1') ; 				/**	핸드폰 앞자리	*/
		getPostList() ; 
		
		$('#as1').hide() ;
		$('#as2').hide() ;
		<c:if test="${ vo.pageType ne 'insert'}">initView();</c:if>
	}) ;
	
	function getPostList(){
		common.ajaxCall({} , '/ad/member/getPostSelect.do', 'makeSelectBox') ;
	}
	
	function makeSelectBox(data){
		$('#dept_cd').empty() ; 
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		var str = commonCode.defaultViewOption ; 
		
		if(resultList != null && resultList.length > 0){
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ; 
				
				str += '<option value="'+common.nvl(datas.dept_cd , '')+'">'+common.nvl(datas.dept_nm , '')+'</option>' ; 
			}
		}
		
		$('#dept_cd').append(str) ; 
	}

	function searchErp(){
		$('#div1').show() ; 
		$('#div_dim').show() ;
		
		$('#div1').css('height' , '515px') ; 
		custList(1) ; 
	}
	
	function custList(custPage){
		var datas = {
				'page' : custPage , 
				'search_text' : $('#searchKorName').val() 
		}
		
		common.ajaxCall(datas , '/ad/member/getPostList.do', 'makeCustList') ;
	}
	
	function closeLayer() {
		$('#div1').hide() ; 
		$('#div_dim').hide() ; 
		$('#searchKorName').val('') ; 
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
				str += '<tr onclick="javascript:setValue(\''+common.nvl(datas.emp_no, '')+'\');" style="cursor:pointer;"> ' ;
				str += '	<td>'+common.nvl(datas.rnum , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.dept_nm , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.emp_nm , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.mobile_no , '')+'</td> ' ;
				str += '</tr> ' ;
			}
			$('#custInfoList').append(str) ; 
			$('#layer_pagination').html(vo.json_paging) ; 
		}else{
			commonTable.notData(4 , '조회된 정보가 없습니다.' , 'custInfoList') ; 
		}
	}
	
	function setValue(emp_no){
		var datas = {'emp_no' 				: emp_no }
		common.ajaxCall(datas , '/ad/member/getPostInfo.do', 'makePostInfo') ;
		closeLayer() ; 
	}
	
	function makePostInfo(data){
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null ; 
		
		$('#emp_no').val(common.nvl(resultVO.emp_no, '')) ; 
		$('#use_yn').val(common.nvl(resultVO.use_yn, 'N')) ;
		
		$('#emp_nm').val(common.nvl(resultVO.emp_nm, '')) ; 
		$('#dept_cd').val(common.nvl(resultVO.dept_cd, '')) ; 
		
		$('#dept_duty').val(common.nvl(resultVO.dept_duty_nm, '')) ; 
		
		$('#e_mail1').val(common.spritStr(resultVO.e_mail , 1, '@')) ; 
		$('#e_mail2').val(common.spritStr(resultVO.e_mail , 2, '@')) ;
		
		$('#phone1').val(common.spritStr(resultVO.mobile_no , 1, '-')) ; 
		$('#phone2').val(common.spritStr(resultVO.mobile_no , 2, '-')) ; 
		$('#phone3').val(common.spritStr(resultVO.mobile_no , 3, '-')) ;
	}
	
	function clearPass(){
		
		if ('C001' != '${su.emp_grade}' && 'C002' != '${su.emp_grade}'){
			alert('일반사용자는 권한이 없습니다.');
			return;
		}
		
		if(!confirm('비밀번호를 초기화 하시겠습니까?')) return ; 
		var datas = {'emp_no' : $('#emp_no').val() ,	'pageType' 	: 'erpPassChange'}
		common.ajaxCall(datas , '/ad/member/registMember.do', 'registResult') ;
	}
	
	function registResult(data){
		var msg = "" ; 
		var returnCode = typeof data.returnCode != "undefined" ? data.returnCode : "888" ; 
		var pageType = typeof data.pageType != "undefined" ? data.pageType : "" ; 
		
		console.log(returnCode) ; 
		console.log(pageType) ; 
		
		if(returnCode == "888") msg = "비정상적인 실행 입니다." ; 
		else if(returnCode == "999") msg = "처리도중 오류가 발생했습니다." ; 
		else if(returnCode == "100") msg = "선택된 회원 정보가 없습니다." ; 
		else if(returnCode == "200") msg = "데이터를 확인해 주세요." ; 
		else if(returnCode == "300") msg = "이미 대표계정이 존재합니다." ; 
		else if(returnCode == "400") msg = "동일한 아이디가 존재합니다." ; 
		else if(returnCode == "000") msg = "정상처리 되었습니다." ;
		
		alert(msg) ; 
		if(returnCode == "000" && pageType != "erpPassChange") goList() ; 
	}
	
	function goList(){
		location.href = "/ad/member/list2.do${ QUERYSTRING }"
	}
	
	function goSave(){
		
		if ('C001' != '${su.emp_grade}' && 'C002' != '${su.emp_grade}'){
			alert('일반사용자는 권한이 없습니다.');
			return;
		}
		
		if(common.isEmpty($('#emp_grade').val())){
			alert("계정 유형을선택해 주세요.") ; 
			return ; 
		}
		if(common.isEmpty($('#emp_no').val())){
			alert("직원을 검색해 주세요.") ; 
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
		</c:if>
		
		if(common.isEmpty($('#emp_nm').val())){
			alert("이름을 입력해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#e_mail1').val())){
			alert("이메일을 입력해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#e_mail2').val())){
			alert("이메일을 입력해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#phone1').val())){
			alert("연락처를 선택해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#phone2').val())){
			alert("연락처를 입력해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#phone3').val())){
			alert("연락처를 입력해 주세요.") ; 
			return ; 
		}
		
		if(!confirm('저장하시겠습니까?')) return ;
		var f = document.procFrm ; 
		f.pageType.value = 'erp${vo.pageType}'  ; 
		
		if(common.isNotEmpty($('#e_mail1').val()) && common.isNotEmpty($('#e_mail2').val())){
			$('#email').val($('#e_mail1').val() + "@" + $('#e_mail2').val()) ; 
		}
		
		if(common.isNotEmpty($('#phone1').val()) && common.isNotEmpty($('#phone2').val()) && common.isNotEmpty($('#phone3').val())){
			$('#tel_no').val($('#phone1').val() + "-" + $('#phone2').val() + "-" + $('#phone3').val()) ; 
		}
		
		common.ajaxCall($('form[name=procFrm]').serialize() , '/ad/member/registMember.do', 'registResult') ;
	}
	
	function initView(){
		var datas = {'emp_no' 				: '${ vo.emp_no }' }
		common.ajaxCall(datas , '/ad/member/getErpInfo.do', 'makeErpInfo') ;
	}
	
	function makeErpInfo(data){
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null ; 
		var tab1List = typeof data.tab1List != "undefined" ? data.tab1List : null ; 
		
		if(resultVO != null){
			$('#emp_grade').val(common.nvl(resultVO.emp_grade, '')) ; 
			$('#use_yn').val(common.nvl(resultVO.use_yn, '')) ; 
			$('#emp_nm').val(common.nvl(resultVO.emp_nm, '')) ; 
			$('#part_type').val(common.nvl(resultVO.part_type, '')) ; 
			$('#dept_cd').val(common.nvl(resultVO.dept_cd, '')) ; 
			$('#dept_duty').val(common.nvl(resultVO.dept_duty, '')) ; 
			$('#e_mail1').val(common.spritStr(resultVO.e_mail , 1, '@')) ; 
			$('#e_mail2').val(common.spritStr(resultVO.e_mail , 2, '@')) ;
			
			$('#phone1').val(common.spritStr(resultVO.mobile_no , 1, '-')) ; 
			$('#phone2').val(common.spritStr(resultVO.mobile_no , 2, '-')) ; 
			$('#phone3').val(common.spritStr(resultVO.mobile_no , 3, '-')) ; 
		}
		
		$('#as1').show() ;
		$('#as2').show() ; 
		
		$('#tab1Tbody').empty() ; 
		
		if(tab1List != null && tab1List.length > 0){
			
			var str = '' ;
			
			for(var i = 0 ; i < tab1List.length ; i++){
				var datas = tab1List[i] ; 
				
				str += '<tr> ' ;
				str += '	<td>'+(i+1)+'</td> ' ;
				str += '	<td>'+common.nvl(datas.accept_dt , '')+'</td> ' ;
				str += '	<td class="colorBlue">'+common.nvl(datas.use_type_name , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.proc_dt , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.inquiry_service , '')+' / '+common.nvl(datas.inquiry_type , '')+'</td> ' ;
				str += '</tr> ' ;
			}
			
			$('#tab1Tbody').append(str) ;
		}else{
			commonTable.notData(5 , '조회된 정보가 없습니다.' , 'tab1Tbody') ; 
		}
	}
	
</script>
<form name="procFrm" id="procFrm" method="post" onsubmit="return false;">
	<input type="hidden" name ="pageType" id="pageType" 	value="${ vo.pageType }"/>
	<input type="hidden" name ="tel_no" 	id="tel_no" 		value=""/>
	<input type="hidden" name ="email" 		id="email" 		value=""/>

	<div class="tit_wrap">
		<%= CommonExecute.returnLineMap(request) %>
	</div>
	
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
				<select id="emp_grade" name="emp_grade" title="계정유형 선택" class="w155 mgr5"></select>
				<c:if test="${ vo.pageType eq 'insert' }">
				<button class="btn_line_gray" onclick="javascript:searchErp();">조회</button>
				</c:if>
			</td>
		</tr>
		<tr>
			<th scope="row">아이디<span class="request mgl5">필수 입력</span></th>
			<td>
				<input type="text" id="emp_no" name="emp_no" title="아이디" readonly="readonly" value="${ vo.emp_no }" />
			</td>
			<th scope="row">계정 사용여부</th>
			<td colspan="3">
				<select id="use_yn" name="use_yn" title="계정상태 선택" class="w155">
					<option value="Y">사용</option>
					<option value="N">미사용</option>
				</select>
			</td>
		</tr>
		
		<c:choose>
			<c:when test="${ vo.pageType eq 'update' }">
			<tr>
				<th scope="row">비밀번호 초기화</th>
				<td colspan="5">
					<button type="button" class="btn_line_gray w75" onclick="javascript:clearPass();">초기화</button>
				</td>
			</tr>
			</c:when>
			<c:otherwise>
			<tr>
				<th scope="row">비밀번호<span class="request mgl5">필수 입력</span></th>
				<td>
					<input type="text" id="pass" name="pass" title="비밀번호 초기화"  />
				</td>
				<th scope="row">비밀번호 재입력<span class="request mgl5">필수 입력</span></th>
				<td colspan="3">
					<input type="text" id="pass_confirm" title="비밀번호 재입력"  />
				</td>
			</tr>
			</c:otherwise>
		</c:choose>
		<tr>
			<th scope="row">이름<span class="request mgl5">필수 입력</span></th>
			<td>
				<input type="text" id="emp_nm" name="emp_nm" title="이름" class="w155" value="" />
			</td>
			<th scope="row">파트</th>
			<td colspan="3">
				<select id="part_type" name="part_type" title="파트 선택" class="w155"></select>
			</td>
		</tr>
		<tr>
			<th scope="row">근무부서명</th>
			<td>
				<select id="dept_cd" name="dept_cd" title="계정상태 선택" class="w155"></select>
			</td>
			<th scope="row">직책</th>
			<td colspan="3">
				<input type="text" id="dept_duty" name="dept_duty"  title="계장" class="w155" value="" />
			</td>
		</tr>
		<tr>
			<th scope="row">이메일<span class="request mgl5">필수 입력</span></th>
			<td colspan="5">
				<input type="text" id="e_mail1" title="이메일" value="" class="w155" />
				<span class="textC w37">@</span>
				<input type="text" id="e_mail2" title="이메일" value="" class="w155" />
			</td>
		</tr>
		<tr>
			<th scope="row">연락처<span class="request mgl5">필수 입력</span></th>
			<td colspan="5">
				<select id="phone1" title="연락처" class="w115"></select><span class="textC w32">-</span>
				<input type="text" id="phone2" title="연락처" value="" class="w60" maxlength="4"/>
				<span class="textC w32">-</span>
				<input type="text" id="phone3" title="연락처" value="" class="w60"  maxlength="4"/>
			</td>
		</tr>
	</table>
	<!--// write -->
	
	<ul class="tab_line list2 mgb10" style="display:none;" id="as1">
		<li class="active"><a href="javascript:void(0);">A/S 처리 내역</a></li><!-- 활성시 current -->
		<li class="textR bgNone bdt_none bdr_none"><a href="javascript:alert('전체이력 레이어 없음');" class="floatR tit_depth">더보기</a></li>
	</ul>
	<table class="hType mgb20"  style="display:none;" id="as2">
		<caption>관리 계정 내역</caption>
		<colgroup>
			<col style="width:80px">
			<col span="4" style="width:auto">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">No</th>
				<th scope="col">신청일</th>
				<th scope="col">처리 상태</th>
				<th scope="col">처리완료일(예정일)</th>
				<th scope="col">문의접수유형</th>
			</tr>
		</thead>
		<tbody id="tab1Tbody"></tbody>
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

<div class="box_layer layer_sms" style="display:none;" id="div1">
<h1>직원 정보 조회 검색 결과</h1>
<div class="layer_contents pdt20" style="height:440px;">
	직원명:
	<input type="text" class="w175 mgr10" id="searchKorName" name="searchKorName" title="직원 명">
	<button type="button" class="btn_ico_search mgr5" onclick="javascript:custList(1);"><span>검색</span></button>
	<table class="vType_line" style="margin-top: 10px;">
		<caption>직원 정보 목록</caption>
		<colgroup>
			<col style="width:50px;" />
			<col style="width:150;" />
			<col style="width:100;" />
			<col style="width:200;" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">No</th>
				<th scope="col">부서</th>
				<th scope="col">직원명</th>
				<th scope="col">연락처</th>
			</tr>
		</thead>
		<tbody id="custInfoList"></tbody>
	</table>
	<div class="page" id="layer_pagination" style="margin-top: 10px;"></div>
</div>
<button type="button" class="btn_close" onclick="javascript:closeLayer();">창 닫기</button>
</div>
<div class="layer_dimmed" style="display:none;" id="div_dim"></div>
