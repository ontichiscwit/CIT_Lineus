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
		
		commonCode.getCodeList('COMMON' , 'CD01' , 'emp_grade') ; 			/**	회원 등급		*/
		commonCode.getCodeList('COMMON' , 'CD02' , 'use_type') ; 				/**	계정 상태		*/
		commonCode.getCodeList('COMMON' , 'CD03' , 'phone1') ; 				/**	핸드폰 앞자리	*/
		
		<c:if test="${ vo.pageType ne 'insert'}">initView();</c:if>
		
		//대표 아이디 입력 시 대문자로 변환
		$("#emp_id").keyup(function() { 
			
			if( $('#emp_grade').val() == "" ){alert("계정 유형을 먼저 선택해주세요.");$("#emp_id").val(""); return;}
			if( $('#emp_grade').val() == "C001" )$(this).val($(this).val().toUpperCase());
		});
		
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
		
		if ('C001' != '${su.emp_grade}' && 'C002' != '${su.emp_grade}'){
			alert('일반사용자는 권한이 없습니다.');
			return;
		}
		
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
		else if(returnCode == "000") msg = "정상처리 되었습니다." ;
		
		alert(msg) ; 
		if(returnCode == "000" && pageType != "passChange") goList() ; 
	}
	
	function goSave(){
		
		if ('C001' != '${su.emp_grade}' && 'C002' != '${su.emp_grade}'){
			alert('일반사용자는 권한이 없습니다.');
			return;
		}
		
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
		
		if(common.isEmpty($('#phone1').val())){
			alert("연락처를 입력해 주세요.") ; 
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
		
		if(common.isNotEmpty($('#email1').val()) && common.isNotEmpty($('#email2').val())){
			$('#email').val($('#email1').val() + "@" + $('#email2').val()) ; 
		}
		
		if(common.isNotEmpty($('#phone1').val()) && common.isNotEmpty($('#phone2').val()) && common.isNotEmpty($('#phone3').val())){
			$('#tel_no').val($('#phone1').val() + "-" + $('#phone2').val() + "-" + $('#phone3').val()) ; 
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
				str += '	<td>'+common.nvl(datas.cust_kor_name , '')+'['+common.nvl(datas.crm_code , '')+']</td> ' ;
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
		var tab1List = typeof data.tab1List != "undefined" ? data.tab1List : null ; 
		var tab2List = typeof data.tab2List != "undefined" ? data.tab2List : null ; 
		
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
			$('#join_date').empty().text(common.nvl(resultVO.join_date, '')) ; 
			$('#emp_name').val(common.nvl(resultVO.emp_name, '')) ; 
			$('#dept_name').val(common.nvl(resultVO.dept_name, '')) ; 
			$('#dept_grade').val(common.nvl(resultVO.dept_grade, '')) ;
			
			$('#email1').val(common.spritStr(resultVO.email , 1, '@')) ; 
			$('#email2').val(common.spritStr(resultVO.email , 2, '@')) ;
			
			$('#phone1').val(common.spritStr(resultVO.tel_no , 1, '-')) ; 
			$('#phone2').val(common.spritStr(resultVO.tel_no , 2, '-')) ; 
			$('#phone3').val(common.spritStr(resultVO.tel_no , 3, '-')) ; 
			
			/* if(common.nvl(resultVO.emp_grade, '') == 'C002'){
				moveTab('2') ;
				$('#li1').hide() ; 
			} */
			$('#li1').hide() ;			
			$('#li2').hide() ;			
			$('#tab1').hide() ;			
			$('#tab2').hide() ;			
			 if(common.nvl(resultVO.emp_grade, '') != 'C002'){
				moveTab('1') ;
				$('#li1').show() ; 
			 }
			
			 
			
		}
		
		$('#tab1Tbody').empty() ; 
		if(tab1List != null && tab1List.length > 0){
			
			var str = '' ;
			
			for(var i = 0 ; i < tab1List.length ; i++){
				var datas = tab1List[i] ; 
				
				str += '<tr onclick="javascript:goView(\'update\' , \''+common.nvl(datas.seq , '')+'\');" style="cursor:pointer;"> ' ;
				str += '	<td>'+(i+1)+'</td> ' ;
				str += '	<td>'+common.nvl(datas.join_date, '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.emp_id, '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.emp_name, '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.dept_name, '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.dept_grade, '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.email, '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.tel_no, '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.use_type_name, '')+'</td> ' ;
				str += '	<td></td> ' ;
				str += '</tr> ' ;
			}
			
			$('#tab1Tbody').append(str) ;
		}else{
			commonTable.notData(10 , '조회된 정보가 없습니다.' , 'tab1Tbody') ; 
		}
		
		$('#tab2Tbody').empty() ; 
		if(tab2List != null && tab2List.length > 0){
			
			var str = '' ;
			
			for(var i = 0 ; i < tab2List.length ; i++){
				var datas = tab2List[i] ; 
				
				str += '<tr> ' ;
				str += '	<td>'+(i+1)+'</td> ' ;
				str += '	<td>'+common.nvl(datas.accept_dt , '')+'</td> ' ;
				str += '	<td class="colorBlue">'+common.nvl(datas.use_type_name , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.proc_dt , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.inquiry_service , '')+' / '+common.nvl(datas.inquiry_type , '')+'</td> ' ;
				str += '</tr> ' ;
			}
			
			$('#tab2Tbody').append(str) ;
		}else{
			commonTable.notData(5 , '조회된 정보가 없습니다.' , 'tab2Tbody') ; 
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
	
	function moveTab(gbn){
		for(var i = 1 ; i <= 2 ; i++){
			if(Number(gbn) == i){
				if(!$('#li' + i).hasClass('active')) $('#li' + i).addClass('active') ;
				$('#li' + i).show() ;
				$('#tab' + i).show() ; 
			}else{
				if($('#li' + i).hasClass('active')) $('#li' + i).removeClass('active') ;
				$('#li' + i).hide() ;
				$('#tab' + i).hide() ;
			}
		}
	}
	
	
</script>
<form name="procFrm" id="procFrm" method="post" onsubmit="return false;">
	<input type="hidden" name ="pageType" id="pageType" 	value="${ vo.pageType }"/>
	<input type="hidden" name ="seq" 		id="seq" 			value="${ vo.seq }"/>
	<input type="hidden" name ="tel_no" 	id="tel_no" 		value=""/>
	<input type="hidden" name ="email" 		id="email" 		value=""/>
	
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
				<select id="emp_grade" name="emp_grade" title="계정유형 선택" class="w155"></select>
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
			<td colspan="5">
				<input type="text" id="emp_name" name="emp_name" title="이름" class="w155" value="" />
			</td>
		</tr>
		<tr>
			<th scope="row">근무부서</th>
			<td>
				<input type="text" id="dept_name" name="dept_name" title="근무부서명" class="w155" value="" />
			</td>
			<th scope="row">직책</th>
			<td colspan="3">
				<input type="text" id="dept_grade" name="dept_grade" title="계장" class="w155" value="" />
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
			<th scope="row">연락처<span class="request mgl5">필수 입력</span></th>
			<td colspan="5">
				<select id="phone1" title="연락처" class="w155"></select>
				<span class="textC w20">-</span>
				<input type="text" id="phone2" title="연락처" value="" class="w60" maxlength="4"/>
				<span class="textC w20">-</span>
				<input type="text" id="phone3" title="연락처" value="" class="w60" maxlength="4"/>
			</td>
		</tr>
	</table>
	
	<c:if test="${ vo.pageType eq 'update' }">
	<ul class="tab_line list2 mgb10">
		<li id="li1" class="active"><a href="javascript:moveTab('1');">관리 계정 내역</a></li><!-- 활성시 current -->
		<li id="li2"><a href="javascript:moveTab('2');">A/S 신청 이력</a></li>
	</ul>
	
	<table class="hType mgb20" id="tab1">
		<caption>관리 계정 내역</caption>
		<colgroup>
			<col style="width:30px">
			<col span="9" style="width:auto">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">No</th>
				<th scope="col">계정생성일</th>
				<th scope="col">아이디</th>
				<th scope="col">이름</th>
				<th scope="col">근무부서명</th>
				<th scope="col">직책</th>
				<th scope="col">이메일</th>
				<th scope="col">연락처</th>
				<th scope="col">계정상태</th>
				<th scope="col"></th>
			</tr>
		</thead>
		<tbody id="tab1Tbody"></tbody>
	</table>
	
	<table class="hType mgb20" id="tab2" style="display:none;">
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
		<tbody id="tab2Tbody"></tbody>
	</table>
	
	</c:if>
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

<div class="box_layer layer_sms" style="margin-top:-300px;display:none;" id="div1">
<h1>거래처 정보 조회 검색 결과</h1>
<div class="layer_contents pdt20" style="height:657px;">
	기관명:
	<input type="text" class="w175 mgr10" id="searchKorName" name="searchKorName" title="거래처 정보 검색">
	<button type="button" class="btn_ico_search mgr5" onclick="javascript:custList(1);"><span>검색</span></button>
	<table class="vType_line" style="margin-top: 10px">
		<caption>거래처 정보 목록</caption>
		<colgroup>
			<col style="width:50px;" />
			<col style="width:200px;" />
			<col style="width:80px;" />
			<col style="width:150px;" />
			<col style="width:auto;" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">No</th>
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
