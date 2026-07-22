<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<style>
	.box_terms{overflow: auto; height: 300px}


	.box_terms p.p1 {margin: 0.0px 0.0px 0.0px 0.0px; line-height: 13.5px; font: 10.0px 'Malgun Gothic'; color: #797979}
	.box_terms p.p2 {margin: 0.0px 0.0px 0.0px 0.0px; line-height: 13.5px; font: 10.0px Helvetica; color: #797979; min-height: 12.0px}
	.box_terms p.p3 {margin: 0.0px 0.0px 0.0px 36.0px; line-height: 13.5px; font: 10.0px 'Malgun Gothic'; color: #797979}
	.box_terms p.p4 {margin: 0.0px 0.0px 0.0px 36.0px; line-height: 13.5px; font: 10.0px Helvetica; color: #797979; min-height: 12.0px}
	.box_terms li.li1 {margin: 0.0px 0.0px 0.0px 0.0px; line-height: 13.5px; font: 10.0px 'Malgun Gothic'; color: #797979}
	.box_terms span.s1 {font: 10.0px Helvetica}
	.box_terms span.s2 {font: 10.0px 'MS Gothic'}
	.box_terms span.Apple-tab-span {white-space:pre}
	.box_terms ol.ol1 {list-style-type: decimal}
	#content_div {display:block; overflow-y: auto;height:350px;  }
	.layer_join2 {width:466px;height:490px;margin:-185px 0 0 -233px;}
	.layer_join2 .layer_contents {padding:25px 30px 30px;}	
	.layer_join3 {width:466px;height:520px;margin:-185px 0 0 -233px;}
	.layer_join3 .layer_contents {padding:25px 30px 30px;}
	
</style>


<script type="text/javascript">
	$(document).ready(function(){
		commonCode.getCodeList('COMMON' , 'CD03' , 'phone1') ; 				/**	핸드폰 앞자리	*/
		commonCode.getCodeList('COMMON' , 'CD01' , 'emp_grade') ; 				/**	회원등급	*/
		
	}) ; 
	
	var a = '' ; 
	var b = '' ; 
	var c = '' ; 
	var d = '' ; 
	var erp_code = '';
	
	function showLayer(gbn){
		
		if($('#emp_grade').val() == "") {alert('회원 유형을 먼저 선택해주세요.'); return;}
		
		$('#info1').val('') ; 
		$('#info2').val('') ; 
		$('#info3').val('') ; 
		$('#emp_id').val('') ;
		$('#erp_code').val('') ; 
		
		
		$('#div' + gbn).show() ; 
		$('#div_dim').show() ; 
		
		$('html, body').animate({'scrollTop' : 0}, 'slow');
		
		if(gbn == "1"){
			$('#search_text').val('') ;
			$('#div' + gbn).css('height' , '230px') ; 
		}
	}
	
	function closeLayer(gbn){
		$('#div' + gbn).hide() ; 
		$('#div_dim').hide() ;	
	}
	
	function goReSearch(){
		$('#search_text').val('') ; 
		$('#div2').hide() ; 
		$('#div3').hide() ; 
		$('#div1').show() ; 
	}
	
	function setValue(){
		$('#info1').val(a) ; 
		$('#info2').val(b) ; 
		$('#info3').val(c) ;
		$('#erp_code').val(erp_code) ;
		
		if($('#emp_grade').val()  == "C001"){
			$('#emp_id').val(d) ;
		}
		closeLayer('2') ; 
	}
	
	function selectCust(val){
		var datas = {'search_type1' : '1' , 'search_text' : val}
		common.ajaxCall(datas , '/fr/join/getCustInfo.do', 'setValue2') ;
	}
	function setValue2(data){
		
		var resultVO = typeof data.resultVO !="undefined" ? data.resultVO : null ; 
		$('#info1').val(common.nvl(resultVO.crm_code, '') + (common.nvl(resultVO.treat_no, '') != '' ? '/' + common.nvl(resultVO.treat_no, '') : '') ) ; 
		$('#info2').val(common.nvl(resultVO.cust_nm, '')) ; 
		$('#info3').val(common.nvl(resultVO.cust_address, '')) ; 
		$('#erp_code').val(common.nvl(resultVO.crm_code, '')) ; 
		
		if($('#emp_grade').val() == "C001"){
			$('#emp_id').val(common.nvl(resultVO.crm_code, '')) ;
		}
		closeLayer('3') ; 
	}
	
	function goSearch(){
		
		var chk = $(":input:radio[name=search_type1]:checked").val();
		
		if(common.isEmpty($('#search_text').val())){
			if(chk == "1") alert("CRM코드를 입력해 주세요.") ; 
			else if(chk == "2") alert("요양기관번호를 입력해 주세요.") ; 
			else if(chk == "3") alert("거래처명을 입력해 주세요.") ; 
			return ; 
		}
		
		if(chk == "1" || chk == "2" ){
			var datas = {'search_type1' : chk , 'search_text' : $('#search_text').val()}
			common.ajaxCall(datas , '/fr/join/getCustInfo.do', 'makeCustInfo') ;
		}
		if(chk == "3"){
			var datas = {'search_type1' : chk , 'search_text' : $('#search_text').val()}
			common.ajaxCall(datas , '/fr/join/getCustList.do', 'makeCustInfo2') ;
		}
	}
	
	
	function makeCustInfo(data){
		var resultVO = typeof data.resultVO !="undefined" ? data.resultVO : null ; 
		
		var str = '' ; 
		
		$('#tabTbody').empty() ; 
		$('#btn1').show() ; 
		$('#btn2').show() ;
		
		$('#div1').hide() ; 
		$('#div2').show() ; 
		$('#div3').hide() ; 
		
		if(resultVO != null){
			str += '<tr> ' ;
			str += '	<th scope="row">사업자등록번호</th> ' ;
			str += '	<td>'+common.nvl(resultVO.cust_no, '')+'</td> ' ;
			str += '</tr> ' ;
			str += '<tr> ' ;
			str += '	<th scope="row">대표자명</th> ' ;
			str += '	<td>'+common.nvl(resultVO.ceo, '')+'</td> ' ;
			str += '</tr> ' ;
			str += '<tr> ' ;
			str += '	<th scope="row">기관명</th> ' ;
			str += '	<td>'+common.nvl(resultVO.cust_kor_name, '')+'</td> ' ;  //기관명 거래처명으로 조회되도록 수정 2020.09.07. 민지대리  //CRM_CUST_PROJECT_MGT.cust_kor_name 거래처명, CRM_CUST_MGT.cust_nm 사업자등록명
			str += '</tr> ' ;
			str += '<tr> ' ;
			
			str += '	<th scope="row">CRM코드</th> ' ;
			str += '	<td>'+common.nvl(resultVO.crm_code, '')+'</td> ' ;
			str += '</tr> ' ;
			str += '<tr> ' ;
			
			str += '	<th scope="row">주소</th> ' ;
			str += '	<td>'+common.nvl(resultVO.cust_address, '')+'</td> ' ;
			str += '</tr> ' ;
			
			
			a = common.nvl(resultVO.crm_code, '') + (common.nvl(resultVO.treat_no, '') != '' ? '/' + common.nvl(resultVO.treat_no, '') : '') ;
			//b = common.nvl(resultVO.cust_nm, '') ; 
			b = common.nvl(resultVO.cust_kor_name, '') ;  //기관명 거래처명으로 조회되도록 수정 2020.09.07. 민지대리  //CRM_CUST_PROJECT_MGT.cust_kor_name 거래처명, CRM_CUST_MGT.cust_nm 사업자등록명
			c = common.nvl(resultVO.cust_address, '') ; 
			d = common.nvl(resultVO.crm_code, '') ;
			erp_code = common.nvl(resultVO.crm_code, '');
			
		}else{
			str += '<tr> ' ;
			str += '	<td colspan="2" class="no_results"> ' ;
			str += '		검색결과가 없습니다.<br /> ' ;
			str += '		고객센터에 문의바랍니다. ' ;
			str += '	</td> ' ;
			str += '</tr> ' ;
			
			$('#btn1').hide() ; 
		}
		
		$('#tabTbody').append(str) ; 
	}
	
	function makeCustInfo2(data){
		var resultList = typeof data.resultList !="undefined" ? data.resultList : null ; 
		
		var str = '' ; 
		
		$('#content_div').empty() ; 
		
		$('#div1').hide() ; 
		$('#div2').hide() ; 
		$('#div3').show() ; 
		
		if(resultList != null && resultList.length != 0 ){
			
			for(var i = 0 ; i < resultList.length; i++ ){
				
				str += '<table class="vType_line mgb20" >';
				str += '<colgroup>';
				str += '<col style="width:140px;" />';
				str += '<col style="width:auto;" />';
				str += '</colgroup>';
				str += '<tbody id="tabTbody">';
				str += '<tr> ' ;
				str += '	<th scope="row">CRM CODE</th> ' ;
				str += '	<td>'+common.nvl(resultList[i].crm_code, '')+'</td> ' ;
				str += '</tr> ' ;
				str += '<tr> ' ;
				str += '	<th scope="row">사업자등록번호</th> ' ;
				str += '	<td>'+common.nvl(resultList[i].cust_no, '')+'</td> ' ;
				str += '</tr> ' ;
				str += '<tr> ' ;
				str += '	<th scope="row">대표자명</th> ' ;
				str += '	<td>'+common.nvl(resultList[i].ceo, '')+'</td> ' ;
				str += '</tr> ' ;
				str += '<tr> ' ;
				str += '	<th scope="row">병원명</th> ' ;
				str += '	<td>'+common.nvl(resultList[i].cust_kor_name, '')+'</td> ' ;
				str += '</tr> ' ;
				str += '<tr> ' ;
				str += '	<th scope="row">사업자등록명</th> ' ;
				str += '	<td>'+common.nvl(resultList[i].cust_nm, '')+'</td> ' ;
				str += '</tr> ' ;
				
				str += '<tr> ' ;
				str += '	<th scope="row">주소</th> ' ;
				str += '	<td>'+common.nvl(resultList[i].cust_address, '')+'</td> ' ;
				str += '</tr> ' ;
				
				str += '<tr> ' ;
				str += '	<td colspan="2">'+ '<button type="button" style="width:360px" class="btn_ico_save" onclick="javascript:selectCust(\''+common.nvl(resultList[i].crm_code, '')+'\');"><span>확인</span></button></td>' ;
				str += '</tr> ' ;
				str += '</tbody>';
				str += '</table>';
			}
			
		}else{
			str += '<table class="vType_line mgb20" >';
			str += '<colgroup>';
			str += '<col style="width:140px;" />';
			str += '<col style="width:auto;" />';
			str += '</colgroup>';
			str += '<tbody id="tabTbody">';
			str += '<tr> ' ;
			str += '	<td colspan="2" class="no_results"> ' ;
			str += '		검색결과가 없습니다.<br /> ' ;
			str += '		고객센터에 문의바랍니다. ' ;
			str += '	</td> ' ;
			str += '</tr> ' ;
			str += '</tbody>';
			str += '</table>';
				
		}
		
		$('.layer_join3 #content_div').append(str) ; 
	}
	
	
	
	
	function goSave(){
		if(!$('#agree_terms1').is(":checked")){
			alert('개인정보 수집 이용에 동의해주세요.') ; 
			return ; 
		}
		
		if(!$('#agree_terms2').is(":checked")){
			alert('서비스 이용약관에 동의해주세요.') ; 
			return ; 
		}
		
		if($('#emp_grade').val() == ""){
			alert('회원유형을 선택해 주세요.') ; 
			return ; 
		}
		
		if($('#emp_id').val() == ""){
			alert('거래처를 조회해 주세요.') ; 
			return ; 
		}
		
		if($('#emp_id').val() == ""){
			alert('거래처를 조회해 주세요.') ; 
			return ; 
		}
		
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
		
		if(common.isNotEmpty($('#pass').val())){
			var minlen = 4; 
			if ($('#pass').val().length < minlen ) {
				alert('사용하실 비밀번호를 최소 4자리 이상 입력해주세요.');
				return;
			}
		}
		
		
		if(common.isEmpty($('#emp_name').val())){
			alert("사용자 이름을 입력해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#dept_name').val())){
			alert("근무부서를 입력해 주세요.") ; 
			return ; 
		}
		
		if(common.isEmpty($('#dept_grade').val())){
			alert("직책을 입력해 주세요.") ; 
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
		
		if(!confirm('회원 가입을 진행 하시겠습니까?')) return ; 
		
		$('#email').val($('#email1').val() + "@" + $('#email2').val()) ; 
		$('#tel_no').val($('#phone1').val() + "-" + $('#phone2').val() + "-" + $('#phone3').val()) ;
		
		common.ajaxCall($('form[name=procFrm]').serialize() , '/fr/join/registJoin.do', 'registResult') ;
	}
	
	function registResult(data){
		var msg = "" ; 
		var returnCode = typeof data.returnCode != "undefined" ? data.returnCode : "888" ; 
		if(returnCode == "888") msg = "비정상적인 실행 입니다." ; 
		else if(returnCode == "999") msg = "처리도중 오류가 발생했습니다." ; 
		else if(returnCode == "100") msg = "선택된 회원 정보가 없습니다." ; 
		else if(returnCode == "200") msg = "데이터를 확인해 주세요." ; 
		else if(returnCode == "300") msg = "이미 대표계정이 존재합니다." ; 
		else if(returnCode == "400") msg = "동일한 아이디가 존재합니다." ; 
		else if(returnCode == "500") msg = "대표계정 상태가 정상일 경우 일반계정 가입이 가능합니다.\n대표 계정 상태를 문의하세요." ; 
		else if(returnCode == "000") msg = "정상처리 되었습니다.\n승인처리후 로그인 가능합니다." ;
		else if(returnCode == "002") msg = "정상처리 되었습니다.\n회원가입을 축하드립니다." ; 
		
		alert(msg) ; 
		if(returnCode == "000" || returnCode == "002") location.href='/fr/login/form.do' ; 
	}
	
</script>

<style type="text/css">
	.box_terms p.p1 {margin: 0.0px 0.0px 0.0px 0.0px; line-height: 13.5px; font: 10.0px 'Malgun Gothic'; color: #797979}
	.box_terms p.p2 {margin: 0.0px 0.0px 0.0px 0.0px; line-height: 13.5px; font: 10.0px Helvetica; color: #797979; min-height: 12.0px}
	.box_terms p.p3 {margin: 0.0px 0.0px 0.0px 36.0px; line-height: 13.5px; font: 10.0px 'Malgun Gothic'; color: #797979}
	.box_terms p.p4 {margin: 0.0px 0.0px 0.0px 36.0px; line-height: 13.5px; font: 10.0px Helvetica; color: #797979; min-height: 12.0px}
	.box_terms li.li1 {margin: 0.0px 0.0px 0.0px 0.0px; line-height: 13.5px; font: 10.0px 'Malgun Gothic'; color: #797979}
	.box_terms span.s1 {font: 10.0px Helvetica}
	.box_terms span.s2 {font: 10.0px 'MS Gothic'}
	.box_terms span.Apple-tab-span {white-space:pre}
	.box_terms ol.ol1 {list-style-type: decimal}
</style>
<form name="procFrm" id="procFrm" method="post" onsubmit="return false;">
	<input type="hidden" name="erp_code" id="erp_code" value=""/>
	<input type="hidden" name="email" id="email" value=""/>
	<input type="hidden" name="tel_no" id="tel_no" value=""/>
	<input type="hidden" name="pageType" id="pageType" value="insert"/>
	
<div id="jw_header">
	<div class="innerWrap">
		<h1><a href="/fr/login/form.do">ONTIC LineUS</a></h1>
	</div>
</div>

<div class="tit_wrap_admin">
	<div class="innerWrap">
		<h2>회원가입</h2>
		<span>
			신규 고객사의 경우 ONTIC LineUs에서 고객사 대표 계정을 발급받으시기 위해서는 최초 1번의 회원가입 절차가 필요합니다.
		</span>
	</div>
</div>
	

<div id="jw_contents">
	<!-- 개인정보 수집 및 제공 동의 -->
	<div class="tit_sWrap">
		<h3 class="tit_bold_gray mgt30">개인정보 수집 및 제공 동의</h3>
	</div>
	<p class="txt_join mgb20">아래 중외정보기술 고객의 “개인정보 제공 동의"를 읽어보신 후 동의하여 주시기 바랍니다.</p>
<div class="box_terms">
	<p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">㈜중외정보기술 (이하 "회사"라 합니다)는 개인정보보호법에 따라 ㈜중외정보기술의 고객사 또는 고객사 담당자 (이하 "이용고객 또는 회원"이라 합니다)의 개인정보 보호 및 권익을 보호하고 개인정보와 관련한 이용고객의 고충을 원활하게 처리할 수 있도록 다음과 같은 처리방침을 두고 있습니다.</span></p>
	<p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">회사는 개인정보처리방침을 개정하는 경우 웹사이트 공지사항(또는 개별공지)을 통하여 공지할 것입니다.</span></p>
	<p class="p2">
		<br>
	</p>
	<p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">○ 본 방침은 공시한 날로부터 시행됩니다.</span></p>
	<p class="p2">
		<br>
	</p>
	<p class="p1" style="line-height: 1.5;"><b><span style="font-size: 10pt;">1. 개인정보의 처리 목적</span><span class="Apple-converted-space" style="font-size: 10pt;">&nbsp;</span></b></p>
	<p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">회사는 개인정보를 다음의 목적을 위해 처리합니다. 처리한 개인정보는 다음의 목적 이외의 용도로는 사용되지 않으며 이용 목적이 변경될 시에는 사전동의를 구할 예정입니다.</span></p>
	<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">① Ontic LineUs 회원가입 및 관리</span></p>
	<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">- 회원 가입의사 확인, 회원제 서비스 제공에 따른 본인 식별·인증, 회원자격 유지·관리, 제한적 본인 확인제 시행에 따른 본인확인, 서비스 부정이용 방지, 만14세 미만 아동 개인정보 수집 시 법정대리인 동의 여부 확인, 각종 고지·통지, 고충처리, 분쟁 조정을 위한 기록 보존 등을 목적으로 개인정보를 처리합니다.</span></p>
	<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">② 재화 또는 서비스 제공</span></p>
	<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">- ONTIC LineUs에서 이용고객의 유지보수 요청 및 기타 요구사항에 대해 원활한 서비스 제공을 목적으로 개인정보를 처리합니다.</span></p>
	<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">③ 마케팅 및 광고에의 활용</span></p>
	<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">- 신규 서비스(제품) 개발 및 맞춤 서비스 제공, 이벤트 및 광고성 정보 제공 및 참여기회 제공 등을 목적으로 개인정보를 처리합니다.</span></p>
	<p class="p2"><b></b>
		<br>
	</p>
	<p class="p1" style="line-height: 1.5;"><b><span style="font-size: 10pt;">2. 개인정보 수집 항목 및 방법</span></b></p>
	<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">- 개인정보 항목 : 이메일, 휴대전화번호, 비밀번호, 로그인ID, 이름, 회사전화번호, 직책, 부서, 회사명 </span>
		<br><span style="font-size: 10pt;">
		- 수집방법 : Ontic LineUs 회원 가입 시 또는 당사자간 프로젝트 계약 정보, 유지보수 계약 정보를 활용하여 수집</span></p>
	<span style="font-size: 10pt;">- 보유근거 : 상법 등 관련법령의 규정 </span>
	<br><span style="font-size: 10pt;">
		- 보유기간 : 5년 </span>
	<br><span style="font-size: 10pt;">
		- 관련법령 : 신용정보의 수집/처리 및 이용 등에 관한 기록 : 3년</span></p>
	<p class="p2"><b></b>
		<br>
	</p>
	<p class="p1" style="line-height: 1.5;"><b><span style="font-size: 10pt;">3. 개인정보의 처리 및 보유 기간</span></b></p>
	<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">① 회사는 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의 받은 개인정보 보유, 이용기간 내에서 개인정보를 처리, 보유합니다.</span></p>
	<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">② 수집된 개인정보는 수집.</span><span style="font-size: 10pt;">이용에 관한 동의일로부터 서비스 해지 시까지 위 개인정보의 처리 목적을 위하여 보유.</span><span style="font-size: 10pt;">이용됩니다.</span></p>
	<p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">-</span><span style="font-size: 10pt;"> 보유근거 : 상법 등 관련법령의 규정</span></p>
	<p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">-</span><span style="font-size: 10pt;"> 관련법령 : 신용정보의 수집/처리 및 이용 등에 관한 기록 : 3년</span></p>
	<p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">-</span><span style="font-size: 10pt;"> 예외사유 : 이용고객에서 제명 또는 계약해지된 경우</span></p>
	<p class="p2">
		<br>
	</p>
	<p class="p1" style="line-height: 1.5;"><b><span style="font-size: 10pt;">4. 정보주체의 권리</span></b><span class="s1"><b><span style="font-size: 10pt;">,</span></b>
		</span><b><span style="font-size: 10pt;">의무 및 그 행사방법</span><span class="Apple-converted-space" style="font-size: 10pt;">&nbsp;</span></b></p>
	<p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">이용고객은 개인정보주체로서 다음과 같은 권리를 행사할 수 있습니다.</span></p>
	<p class="p1" style="line-height: 1.5;"><span style="font-family: &quot;Malgun Gothic&quot;; font-size: 10pt;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ①</span><span style="font-family: &quot;Malgun Gothic&quot;;">&nbsp;</span><span style="font-family: &quot;Malgun Gothic&quot;; font-size: 10pt;">정보주체는 회사에 대해 언제든지 다음 각 호의 개인정보보호 관련 권리를 행사할 수 있습니다</span><span class="s1" style="font-family: &quot;Malgun Gothic&quot;; font-size: 10pt;">.</span></p>
	<p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1. 개인정보 열람요구</span></p>
	<p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 
2. 오류 등이 있을 경우 정정 요구</span></p>
	<p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 3. 삭제요구</span></p>
	<p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 4. 처리정지 요구</span></p>
	<p class="p1" style="line-height: 1.5;"><span style="font-family: &quot;Malgun Gothic&quot;; font-size: 10pt;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;②&nbsp;</span><span style="font-family: &quot;Malgun Gothic&quot;; font-size: 10pt;">제1항에 따른 권리 행사는 회사에 대해 서면, 전자우편, 모사전송(FAX) 등을 통하여 하실 수 있으며 회사는 이에 대해 지체 없이 조치하겠습니다</span><span class="s1" style="font-family: &quot;Malgun Gothic&quot;; font-size: 10pt;">.</span></p>
	<p class="p1" style="line-height: 1.5;"><span style="font-family: &quot;Malgun Gothic&quot;; font-size: 10pt;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;③&nbsp;</span><span style="font-family: &quot;Malgun Gothic&quot;; font-size: 10pt;">
정보주체가 개인정보의 오류 등에 대한 정정 또는 삭제를 요구한 경우에는 회사는 정정 또는 삭제를 완료할 때까지 해당 개인정보를 이용하거나 제공하지 않습니다</span><span class="s1" style="font-family: &quot;Malgun Gothic&quot; font-size: 10pt;">.</span></p>
	<p class="p1" style="line-height: 1.5;"><span style="font-family: &quot;Malgun Gothic&quot;; font-size: 10pt;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp④ 제1항에 따른 권리 행사는 정보주체의 법정대리인이나 위임을 받은 자 등 대리인을 통하여 하실 수 있습니다. 이 경우 개인정보 보호법 시행규칙 별지 제11호 서식에 따른 위임장을 제출하셔야 합니다.</span></p>
	<p class="p4">
		<br>
	</p>
	<p class="p1" style="line-height: 1.5;"><b><span style="font-size: 10pt;">5. 개인정보의 파기</span></b></p>
	<p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">회사는 원칙적으로 개인정보 처리목적이 달성된 경우에는 지체없이 해당 개인정보를 파기합니다. 파기의 절차, 기한 및 방법은 다음과 같습니다.</span></p>
	<p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">-</span><span style="font-size: 10pt;"> 파기절차 : 이용고객이 입력한 정보는 목적 달성 후 별도의 DB에 옮겨져(종이의 경우 별도의 서류) 내부 방침 및 기타 관련 법령에 따라 일정기간 저장된 후 혹은 즉시 파기됩니다. 이 때, DB로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 다른 목적으로 이용되지 않습니다.</span></p>
	<p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">-</span><span style="font-size: 10pt;"> 파기기한 : 이용고객의 개인정보는 개인정보의 보유기간이 경과된 경우에는 보유기간의 종료일로부터 5일 이내에, 개인정보의 처리 목적 달성, 해당 서비스의 폐지, 사업의 종료 등 그 개인정보가 불필요하게 되었을 때에는 개인정보의 처리가 불필요한 것으로 인정되는 날로부터 5일 이내에 그 개인정보를 파기합니다.</span></p>
	<p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">-</span><span style="font-size: 10pt;"> 파기방법 : 전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용합니다.</span></p>
	<p class="p4">
		<br>
	</p>
	<p class="p1" style="line-height: 1.5;"><b><span style="font-size: 10pt;">6. 개인정보의 안전성 확보 조치</span></b></p>
	<p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">회사는 개인정보보호법 제29조에 따라 다음과 같이 안전성 확보에 필요한 기술적/관리적 및 물리적 조치를 하고 있습니다.</span></p>
	<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">① 개인정보 취급 관련 안정성 확보를 위해 정기적으로 자체 감사를 실시하고 있습니다.</span></p>
	<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">② 개인정보를 취급하는 직원을 지정하고 담당자에 한정시켜 최소화 하여 개인정보를 관리하는 대책을 시행하고 있습니다.</span></p>
	<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">③ 회사는 해킹이나 컴퓨터 바이러스 등에 의한 개인정보 유출 및 훼손을 막기 위하여 보안프로그램을 설치하고 주기적인 갱신·점검을 하며 외부로부터 접근이 통제된 구역에 시스템을 설치하고 기술적/물리적으로 감시 및 차단하고 있습니다.</span></p>
	<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">④ 이용고객의 비밀번호는 암호화 되어 저장 및 관리되고 있어, 본인만이 알 수 있으며 중요한 데이터는 파일 및 전송 데이터를 암호화 하거나 파일 잠금 기능을 사용하는 등의 별도 보안기능을 사용하고 있습니다.</span></p>
	<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">⑤ 개인정보를 처리하는 데이터베이스시스템에 대한 접근권한의 부여</span><span class="s1" style="font-size: 10pt;">,</span><span style="font-size: 10pt;">변경</span><span class="s1" style="font-size: 10pt;">,</span><span style="font-size: 10pt;">말소를 통하여 개인정보에 대한 접근통제를 위하여 필요한 조치를 하고 있으며 침입차단시스템을 이용하여 외부로부터의 무단 접근을 통제하고 있습니다.</span></p>
	<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">⑥ 개인정보를 보관하고 있는 물리적 보관 장소를 별도로 두고 이에 대해 출입통제 절차를 수립, 운영하고 있습니다.</span></p>
	<p class="p4">
		<br>
	</p>
	<p class="p1" style="line-height: 1.5;"><b><span style="font-size: 10pt;">7. 개인정보 보호책임자 작성</span><span class="Apple-converted-space" style="font-size: 10pt;">&nbsp;</span></b></p>
	<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">① 회사는 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다</span><span class="s1" style="font-size: 10pt;">.<br>
		</span></p>
	<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">▶ 개인정보 보호책임자 </span>
		<p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">
		성명 : 이완세</span><span class="s1"> <p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">
		</span><span style="font-size: 10pt;">직급 : 이사</span><span class="s1"><p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">
		</span><span style="font-size: 10pt;">연락처 : 02-801-1061, wanse@cwit.co.kr</span><span class="s1"><p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">
		<br>
		</span><span style="font-size: 10pt;">▶ 개인정보 보호 담당부서</span><span class="s1"><p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">
		</span><span style="font-size: 10pt;">부서명 : 헬스케어BU</span><span class="s1"><p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">
		</span><span style="font-size: 10pt;">담당자 : 곽영건 부장</span><span class="s1"><p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">
		</span><span style="font-size: 10pt;">연락처 : 02-801-1057, younggun.kwak@cwit.co.kr</span></p>
		<p class="p4">
			<br>
		</p>
		<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">② 이용고객은 회사의 서비스(또는 사업)을 이용하시면서 발생한 모든 개인정보 보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의하실 수 있습니다. 회사는 정보주체의 문의에 대해 지체 없이 답변 및 처리해드릴 것입니다.</span></p>
		<p class="p4">
			<br>
		</p>
		<p class="p1" style="line-height: 1.5;"><b><span style="font-size: 10pt;">8. 개인정보 처리방침 변경</span><span class="Apple-converted-space" style="font-size: 10pt;">&nbsp;</span></b></p>
		<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">① 개인정보처리방침은 서비스 시행일로부터 적용되며, 법령 및 방침에 따른 변경내용의 추가, 삭제 및 정정이 있는 경우에는 변경사항의 시행 7일 전부터 공지사항을 통하여 고지할 것입니다.</span></p>
		<p class="p2">
			<br>
		</p>
		<p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">※ 이용고객께서는 개인정보 수집</span><span class="s2" style="font-size: 10pt;">?</span><span style="font-size: 10pt;">이용에 대한 동의를 거부하실 수 있으나, 이상의 정보는 서비스 제공에 필수적으로 필요한 정보이므로, 동의를 거부하실 경우 회원가입, 서비스 이용 등을 하실 수 없습니다.</span></p>
		<p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">※ 회원가입 후 서비스 이용과정에서 필요에 따라 요청되는 정보는 서비스 이용과정에서 별도로 안내하고 동의 받도록 하겠습니다.</span></p>
	</div>
	<!--// 개인정보 수집 및 제공 동의 -->

	<!-- 이용약관 -->
	<div class="tit_sWrap">
		<h3 class="tit_bold_gray mgt30">이용약관</h3>
	</div>
	<p class="txt_join mgb20">아래 중외정보기술  고객의 “서비스 이용약관"를 읽어보신 후 동의하여 주시기 바랍니다.</p>
	<div class="box_terms">
		
		<p class="p1" style="line-height: 1.5;"><span class="s1"><b><span style="font-size: 10pt;">제 1 장 총 칙</span></b></span></p><p class="p2" style="line-height: 1.5;"><span class="s1"><b><span style="font-size: 10pt;">제 1 조 (목적)</span></b></span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">이 약관은 ㈜중외정보기술(이하 “회사”라 합니다.)이 제공하는 ONTIC LineUs 웹 시스</span><span class="s2" style="font-size: 10pt;">템</span><span class="s1" style="font-size: 10pt;">과 ㈜중외정보기술의 고객사 또는 고객사 담당자 (이하 "이용고객"이라 합니다)간에 시스템 유지보수 및 고객 요청사항과 관련된 인터넷 서비스 (이하 "서비스" 라 합니다)의 이용 조건 및 절차에 관한 기본적인 사항을 정함을 목적으로 합니다.</span></p><p class="p4"><span class="s1"></span><br></p><p class="p2" style="line-height: 1.5;"><span class="s1"><b><span style="font-size: 10pt;">제 2 조 (용어의 정의)</span></b></span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">이 약관에서 사용하는 용어의 정의는 다음과 같습니다.</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">1. 이용 계약: 회사가 제공하는 서비스 이용과 관련하여 회사와 이용고객 간에 체결하는 계약을 말합니다.</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">2. 회원: 회사가 제공하는 절차에 따른 가입 신청 및 이용 계약 체결을 완료한 뒤, 계정을 발급받아 서비스를 이용할 수 있는 자를 말합니다.</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">3. 이용고객 ID: 회원의 식별과 서비스 이용을 위하여 고객사별로 회사가 발급하는 문자, 숫자의 조합을 말합니다. 회원은 이용고객 ID를 통해 하위 ID들을 임의 생성하여 관리할 수 있습니다.</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">4. 비밀번호: 회원이 자신의 ID와 일치하는 이용고객임을 확인하기 위해 선정한 문자, 특수문자, 숫자 등의 조합을 말합니다.</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">5. 시스템 유지보수: 회사와 이용고객 간에 체결한 이용 계약에 의해 요청되는 이용고객의 문의사항, 수정사항, A/S 요청사항을 말합니다.</span></p><p class="p4"><span class="s1"></span><br></p><p class="p2" style="line-height: 1.5;"><span class="s1"><b><span style="font-size: 10pt;">제 3 조 (이용약관의 효력 및 변경)</span></b></span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">1. 이 약관은 인터넷(<a href="http://lineus.cwit.co.kr"><span class="s3" style="font-size: 10pt;">http://lineus.cwit.co.kr</span></a>, <a href="http://cs.cwit.co.kr"><span class="s3" style="font-size: 10pt;">http://cs.cwit.co.kr</span></a>)을 통하여 공지하거나 기타의 방법으로 공지함으로써 효력이 발생합니다.</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">2. 회사는 변경 사유가 발생될 경우에는 이 약관을 변경할 수 있으며, 약관이 변경된 경우에는 지체 없이 이를 공지합니다.</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">3. 이용고객은 변경된 약관 사항에 동의하지 않으면 이용을 중단하고 이용 계약을 해지할 수 있습니다. 약관의 효력발생일 이후의 계속적인 이용은 약관의 변경사항에 동의 한 것으로 간주합니다.</span></p><p class="p5"><span class="s1"></span><br></p><p class="p2" style="line-height: 1.5;"><span class="s1"><b><span style="font-size: 10pt;">제 4 조 (약관 이외의 준칙)</span></b></span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">약관에 언급되지 않은 사항이 전기통신기본법, 전기통신사업법, 기타 관련법령에 규정되어 있는 경우 그 규정에 따라 적용할 수 있습니다.</span></p><p class="p6"><span class="s1"></span><br></p><p class="p1" style="line-height: 1.5;"><span class="s1"><b><span style="font-size: 10pt;">제 2 장 서비스 이용계약</span></b></span></p><p class="p2" style="line-height: 1.5;"><span class="s1"><b><span style="font-size: 10pt;">제 5 조 (서비스 이용 신청 및 이용계약의 성립)</span></b></span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">회사가 제공하는 서비스를 이용하고자 하는 자가 본 약관의 내용에 대하여 동의를 한 다음 회사가 제시하는 양식과 절차에 따라 이용 신청을 하고, 그 신청한 내용에 대해 회사가 승낙함으로써 회사와 이용고객 간 이용 계약이 체결됩니다.</span></p><p class="p4"><span class="s1"></span><br></p><p class="p2" style="line-height: 1.5;"><span class="s1"><b><span style="font-size: 10pt;">제 6 조 (이용 신청 및 약관의 동의)</span></b></span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">이용고객은 회사가 정한 양식에 따라 회원정보를 기입한 후 본 약관에 동의한다는 의사표시를 함으로써 회원가입을 신청합니다.</span></p><p class="p4"><span class="s1"></span><br></p><p class="p2" style="line-height: 1.5;"><span class="s1"><b><span style="font-size: 10pt;">제 7 조 (이용신청의 승낙)</span></b></span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">1. 회사는 제6조에 따른 이용고객에 대하여 약관조건, 업무상 또는 기술상 문제가 없는 경우 본 조 제2항의 경우를 예외로 하여 서비스 이용 신청을 승낙합니다.</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">2. 회사는 다음에 해당하는 경우에는 이를 승낙하지 아니 할 수 있습니다. <br>
		- 다른 이용고객의 명의를 사용하여 신청한 경우</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">- 이용자 정보를 허위로 기재하여 신청한 경우</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">- 이용고객의 귀책사유로 인해 이용신청의 승낙이 곤란한 경우<span class="Apple-converted-space" style="font-size: 10pt;">&nbsp;</span></span></p><p class="p4"><span class="s1"></span><br></p><p class="p2" style="line-height: 1.5;"><span class="s1"><b><span style="font-size: 10pt;">제 8 조 (이용고객ID 부여 및 관리)</span></b></span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">1. 회사는 이용고객에 대하여 약관에 정하는 바에 따라 이용고객 ID를 부여합니다.</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">2. 이용 고객은 다른 이용 고객 ID를 및 비밀번호를 도용 또는 부정하게 사용하지 말아야 하며, 이용고객 ID 및 비밀번호 관리에 상당한 주의를 기울여야 합니다.</span></p><p class="p4"><span class="s1"></span><br></p><p class="p2" style="line-height: 1.5;"><span class="s1"><b><span style="font-size: 10pt;">제 9 조 (이용고객 정보의 변경)</span></b></span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">이용고객은 이용 신청 시 기재한 이용고객 정보가 변경되었을 경우에는, 온라인으로 수정을 하거나 회사에 통보 하여야 하며 미변경으로 인하여 발생되는 문제의 책임은 이용고객에게 있습니다.</span></p><p class="p6"><span class="s1"></span><br></p><p class="p1" style="line-height: 1.5;"><span class="s1"><b><span style="font-size: 10pt;">제 3 장 계약 당사자의 의무 및 서비스</span></b></span></p><p class="p2" style="line-height: 1.5;"><span class="s1"><b><span style="font-size: 10pt;">제 10 조 (회사의 의무)</span></b></span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">1. 회사는 법령과 본 약관이 금지하거나 미풍 양속에 반하는 행위를 하지 않으며, 계속적이고 안정적인 서비스를 제공하기 위하여 노력합니다.</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">2. 회사는 이용 고객의 개인정보보호를 위해 보안시스템을 구축하며 개인정보처리방침을 공시하고 준수합니다.</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">3. 회사는 이용고객 개인정보를 본인의 승낙없이 타인에게 누설, 배포하지 않습니다. 단, 전기통신관련법령 등 관계법령에 의하여 관련 국가기관 등의 요구가 있는 경우에는 그러하지 아니합니다.</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">4. 회사는 이용고객으로부터 제기되는 의견이나 불만이 정당하다고 인정될 경우에는 바로 처리될 수 있도록 최선의 노력을 합니다.</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">2. 회사는 특별한 사유가 없는 한 서비스 제공설비를 항상 운용 가능한 상태로 유지, 보수하여야 합니다.</span></p><p class="p4"><span class="s1"></span><br></p><p class="p2" style="line-height: 1.5;"><span class="s1"><b><span style="font-size: 10pt;">제 11 조 (이용고객의 의무)</span></b></span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">1. 이용 고객은 서비스 이용 시 다음 각 호의 행위를 하지 않아야 합니다.</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">- 서비스에서 얻은 정보를 회사의 사전 승낙 없이 복제하거나 이를 변경, 출판 및 방송 등에 사용하거나 타인에게 제공하는 행위<br>
		- 회사의 저작권, 타인의 저작권 등 기타 권리를 침해하는 행위<br>
		- 공공질서 및 미풍양속에 위반되는 내용의 정보, 문장, 도형 등을 타인에게 유포하는 행위<br>
		- 관계법령에 위배되는 행위<br>
		- 기타 회사가 부적절하다고 판단하는 행위</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">2. 이용고객은 관계법령, 이 약관에서 규정하는 사항, 이용안내 및 주의 사항을 준수하여야 합니다.</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">3. 이용고객은 내용별로 회사가 공지사항에 게시하거나 별도로 공지한 이용제한 사항을 준수하여야 합니다.</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">4. 이용고객은 회사의 사전 승낙없이 웹사이트 상에서 어떠한 영리행위도 할 수 없습니다.</span></p><p class="p6"><span class="s1"></span><br></p><p class="p2" style="line-height: 1.5;"><span class="s1"><b><span style="font-size: 10pt;">제 12 조 (서비스의 요금)</span></b></span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">회사에서 제공하는 서비스는 기본적으로 회사와 이용고객 간의 유지보수 계약에 의해 진행됩니다. 이용고객이 요청한 서비스가 유상으로 제공되어야 할 경우 양사간 별도 협의에 의해 처리하며, 이 부분은 ONTIC LineUs에서 관리하지 않습니다.</span></p><p class="p4"><span class="s1"></span><br></p><p class="p2" style="line-height: 1.5;"><span class="s1"><b><span style="font-size: 10pt;">제 13 조 (서비스 이용시간)</span></b></span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">서비스는 회사의 업무상 또는 기술상의 장애, 기타 특별한 사유가 없는 한 연중무휴, 1일 24시간 이용할 수 있습니다. 다만 설비의 점검 등 회사가 필요한 경우 또는 설비의 장애, 서비스 이용의 전부 또는 일부에 대하여 제한할 수 있습니다.</span></p><p class="p6"><span class="s1"></span><br></p><p class="p2" style="line-height: 1.5;"><span class="s1"><b><span style="font-size: 10pt;">제 14 조 (정보의 제공 및 광고의 게재)</span></b></span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">1. 회사는 회원이 서비스 이용 중 필요가 있다고 인정되는 다양한 정보 및 광고에 대해서는 전자우편이나 서신우편, SMS(핸드폰 문자메시지), 팩스, 메신저 등의 방법으로 회원에게 제공할 수 있으며, 만약 원치 않는 정보를 수신한 경우 회원은 이를 수신거부 할 수 있습니다.</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">2. 회사는 서비스의 운용과 관련하여 서비스화면, 홈페이지, 전자우편 등에 광고 등을 게재할 수 있으며, 회사는 이용고객이 동의하는 것으로 간주합니다.</span></p><p class="p6"><span class="s1"></span><br></p><p class="p2" style="line-height: 1.5;"><span class="s1"><b><span style="font-size: 10pt;">제 15조 (서비스 제한 및 정지)</span></b></span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">1. 이용고객이 상기 서비스 이용을 위한 유지보수료를 지속적으로 연체하는 경우 회사는 이용고객에게 사전 통보 후 서비스 이용을 중단 할 수 있습니다.</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">2. 회사가 서비스 이용을 중단하여 발생되는 이용고객의 손해에 대하여 회사는 아무런 책임을 지지 않습니다.</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">3. 회사는 전시, 사변, 천재지변 또는 이에 준하는 국가비상사태가 발생하거나 발생할 우려가 있는 경우와 전기통신사업법에 의한 기간통신 사업자가 전기통신서비스를 중지하는 등 기타 불가항력적 사유가 있는 경우에는 서비스의 전부 또는 일부를 제한하거나 정지할 수 있습니다.</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">4. 회사는 제1항의 규정에 의하여 서비스의 이용을 제한하거나 정지한 때에는 그 사유 및 제한기간 등을 지체 없이 이용고객에게 알려야 합니다.</span></p><p class="p6"><span class="s1"></span><br></p><p class="p2" style="line-height: 1.5;"><span class="s1"><b><span style="font-size: 10pt;">제 16 조 (서비스의 해지)</span></b></span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">1. 파산, 화의, 회사정리 또는 해산절차 진행, 채무정리, 경매신청, 유지보수 계약해지 등과 이와 유사한 절차 진행 시 회사는 이용고객에게 서비스 이용을 해지할 수 있습니다.<span class="Apple-converted-space" style="font-size: 10pt;">&nbsp;</span></span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">2. 서비스 이용이 해지된 경우에도 이미 발생한 각 당사자의 권리와 의무에는 영향을 미치지 아니합니다.</span></p><p class="p6"><span class="s1"></span><br></p><p class="p1" style="line-height: 1.5;"><span class="s1"><b><span style="font-size: 10pt;">제 4 장 기타</span></b></span></p><p class="p2" style="line-height: 1.5;"><span class="s1"><b><span style="font-size: 10pt;">제 17 조 (서비스 이용제한)</span></b></span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">회사는 이용고객이 아래 기재된 문구에 해당하는 행위를 하였을 경우 사전통지 없이 이용에 제한을 둘 수 있습니다.</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">- 운영을 고의로 방해한 경우<br>
		- 공공질서 및 미풍양속에 저해되는 내용을 고의로 유포시킨 경우<br>
		- 이용고객이 국익 또는 사회적 공익을 저해할 목적으로 이용을 계획 또는 실행하는 경우<br>
		- 타인의 명예를 손상시키거나 불이익을 주는 행위를 한 경우 <br>
		- 안정적 운영을 방해할 목적으로 다량의 정보를 전송하거나 광고성 정보를 전송하는 경우<br>
		- 정보통신설비의 오작동이나 정보 등의 파괴를 유발시키는 컴퓨터 바이러스 프로그램 등을 유포하는 경우<br>
		- 회사, 다른 이용고객 또는 타인의 지적재산권을 침해하는 경우&nbsp;<br>
		- 정보통신윤리 위원회 등 외부기관의 시정요구가 있거나 불법선거 운동과 관련하여 선거관리위원회의 유권해석을 받은 경우 &nbsp;<br>
		- 타인의 개인정보, 이용자 ID 및 비밀번호를 부정하게 사용하는 경우 <br>
		- 회사의 정보를 이용하여 얻은 정보를 회사의 사전 승낙 없이 복제 또는 유통시키거나 상업적으로 이용하는 경우&nbsp;<br>
		- 이용고객이 게시판에 음란물을 게재하거나 음란사이트를 링크하는 경우<br>
		- 본 약관을 포함하여 기타 회사가 정한 이용조건 및 관계법령에 위반한 경우</span></p><p class="p4"><span class="s1"></span><br></p><p class="p2" style="line-height: 1.5;"><span class="s1"><b><span style="font-size: 10pt;">제 18 조 (면책)</span></b></span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">1. 회사는 이용고객의 귀책사유로 인하여 장애가 발생한 경우에는 책임이 면제됩니다.</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">2. 회사는 이용고객이 게시 또는 전송한 자료의 내용에 대해서는 책임이 면제됩니다.</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">3. 회사는 이용고객 상호간 또는 이용자와 제3자 상호간에 서비스를 매개로 하여 물품거래 등을 한 경우에는 책임이 면제됩니다.</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">4 .회사는 자료 보관 및 전송에 관한 책임이 없으며 자료의 손실이 있는 경우에도 책임이 면제됩니다.</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">5. 회사는 천재지변 기타 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없을 경우에는 서비스 제공 중지에 관한 책임을 면합니다.</span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">6. 회사는 이용고객들의 귀책사유로 인한 이용의 장애에 대하여 책임을 면합니다.</span></p><p class="p6"><span class="s1"></span><br></p><p class="p2" style="line-height: 1.5;"><span class="s1"><b><span style="font-size: 10pt;">제 19 조 (관할 법원)</span></b></span></p><p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">1. 본 약관내용에 관하여 상호 이견이 있을 경우 원만히 협의하여 해결하되, 협의로 해결되지 아니하여 소송을 제기하는 경우에는 회사 소재지 법원을 관할법원으로 합니다.</span></p><p class="p6"><span class="s1"></span><br></p><p class="p2" style="line-height: 1.5;"><span class="s1"><b><span style="font-size: 10pt;">· 부칙</span></b></span></p><p class="p1" style="line-height: 1.5;">
		
		<p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">(시행일) 이 약관은 공시한 날로부터 시행합니다.</span></p>
	</div>
	<div class="terms_agree">
		<input type="checkbox" id="agree_terms1" /><label for="agree_terms1">위와 같은 개인정보 수집 이용에 동의하십니까? 동의하는 경우에는 왼쪽 박스에 체크해 주십시오. </label><br />
		<input type="checkbox" id="agree_terms2" /><label for="agree_terms2">위와 같은 서비스 이용약관에 동의하십니까? 동의하는 경우에는 왼쪽 박스에 체크해 주십시오. </label>
	</div>
	<!--// 이용약관 -->
	<div class="tit_sWrap">
		<h3 class="tit_bold_gray floatL">회원 정보</h3>
	</div>
	<table class="vType_line mgb20">
		<caption>회원 정보 입력</caption>
		<colgroup>
			<col style="width:200px;">
			<col style="width:300px;">
			<col style="width:200px;">
			<col style="width:300px;">
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">회원유형</th>
				<td >
					<select id="emp_grade" name="emp_grade" title="회원유형 선택" class="w260">
					</select>
				</td>
				<td colspan="2" class="colorRed">※ 대표 계정 사용 승인 이후 일반 계정 생성이 가능합니다.</td>
			</tr>
			<tr>
				<th scope="row">CRM코드<span class="request">필수입력</span></th>
				<td colspan="3">
					<input type="text" id="info1" title="소속기관 사업자등록번호 입력" class="w260 mgr5" readonly="readonly" />
					<button type="button" class="btn_line_gray" onclick="javascript:showLayer('1');">조회</button>
				</td>
			</tr>
			<tr>
				<th scope="row">소속기관 명</th>
				<td>
					<input type="text" id="info2" readonly="readonly" title="소속기관 명 입력" />
				</td>
				<th scope="row">소속기관 주소</th>
				<td>
					<input type="text" id="info3" readonly="readonly" title="소속기관 주소 입력" />
				</td>
			</tr>
			<tr>
				<th scope="row">아이디<span class="request">필수입력</span></th>
				<td colspan="3">
					<input type="text" id="emp_id" name="emp_id" title="아이디 입력" class="w260" />
				</td>
			</tr>
			<tr>
				<th scope="row">비밀번호<span class="request">필수입력</span></th>
				<td>
					<input type="password" id="pass" name="pass" title="비밀번호 입력" class="w260" maxlength="12"/>
				</td>
				<td colspan="4" class="colorRed">※ 사용하실 비밀번호를 입력해주세요. (영문자, 숫자, 특수문자 또는 이의 조합 4자리 이상 12자리 이하)</td>
			</tr>
			<tr>	
				
				<th scope="row">비밀번호 재입력<span class="request">필수입력</span></th>
				<td>
					<input type="password" id="pass_confirm" title="비밀번호 재입력" class="w260"  maxlength="12"/>
				</td>
				<td colspan="4" class="colorRed">※ 사용하실 비밀번호를 한번 더 입력해주세요.</td>
			</tr>
			<tr>
				<th scope="row">사용자 이름<span class="request">필수입력</span></th>
				<td colspan="3">
					<input type="text" id="emp_name" name="emp_name" title="사용자 이름 입력" class="w260" maxlength="10"/>
				</td>
			</tr>
			<tr>
				<th scope="row">근무부서<span class="request">필수입력</span></th>
				<td>
					<input type="text" id="dept_name" name="dept_name" title="근무부서 입력" maxlength="20"/>
				</td>
				<th scope="row">직책<span class="request">필수입력</span></th>
				<td>
					<input type="text" id="dept_grade" name="dept_grade" title="직책 입력" maxlength="20" />
				</td>
			</tr>
			<tr>
				<th scope="row">이메일<span class="request">필수입력</span></th>
				<td colspan="3">
					<input type="text" id="email1" title="이메일 입력1" class="w190" />
					<span class="textC w32">@</span>
					<input type="text" id="email2" title="이메일 입력2" class="w190">
				</td>
			</tr>
			<tr>
				<th scope="row">연락처<span class="request">필수입력</span></th>
				<td colspan="3">
					<select id="phone1" title="연락처 입력1" class="w110">
					</select>
					<input type="text" id="phone2" title="연락처 입력2" class="w110 mgl5" maxlength='4'/>
					<input type="text" id="phone3" title="연락처 입력3" class="w110 mgl5"  maxlength='4'/>
				</td>
			</tr>
		</tbody>
	</table>
	<div class="btn_wrap">
		<div class="floatR">
			<button type="button" class="btn_ico_regist" onclick="javascript:goSave();"><span>회원가입</span></button>
		</div>
	</div>
</div>
</form>

<div class="box_layer layer_join1" id="div1" style="display:none;">
	<div class="layer_contents">
		<h1 class="tit_search mgb10">거래처 정보 조회</h1>
		<table class="vType_line mgb20">
			<caption>거래처 정보 조회</caption>
			<colgroup>
				<col style="width:100px;" />
				<col style="width:auto;" />
			</colgroup>
			<tr>
				<th scope="row">선택</th>
				<td>
					<!-- <input type="radio" name="search_type1" class="mgr5" value="1" checked>CRM코드
					<input type="radio" name="search_type1" class="mgl10 mgr5" value="3">거래처명 -->
					<label>
						<input type="radio" name="search_type1" class="mgl10 mgr5" value="2" checked>
						<span class="fontW_b mgr5">요양기관번호</span>
					</label>
					
				</td>
			</tr>
			<tr>
				<th scope="row">검색</th>
				<td>
					<input type="text" id="search_text" name="search_text" title="검색명" placeholder="‘’-”’없이 숫자만 입력해주세요" />
				</td>
			</tr>
		</table>
		<div class="btn_wrap">
			<div class="floatR">
				<button type="button" class="btn_ico_search w95" onclick="javascript:goSearch();"><span>검색</span></button>
				<button type="button" class="btn_ico_cancel w95" onclick="javascript:closeLayer('1');"><span>닫기</span></button>
			</div>
		</div>
	</div>
	<button type="button" class="btn_close" onclick="javascript:closeLayer('1');">창 닫기</button>
</div>

<div class="box_layer layer_join2" id="div2" style="display:none;">
	<div class="layer_contents" >
		<h1 class="tit_search">
			거래처 정보 조회 검색 결과
		</h1>
		<p class="txt_pop_search mgb20" >
			입력하신 정보와 일치하는 거래처 정보는 다음과 같습니다.<br />
			맞으면 확인을 눌러주세요
		</p>
	
		<table class="vType_line mgb20">
			<caption>거래처 정보 조회 검색 결과</caption>
			<colgroup>
				<col style="width:140px;" />
				<col style="width:auto;" />
			</colgroup>
			<tbody id="tabTbody"></tbody>
		</table>
		
		<div class="btn_wrap">
			<div class="floatR">
				<button type="button" class="btn_ico_save w95" id="btn1" onclick="javascript:setValue();"><span>확인</span></button>
				<button type="button" class="btn_ico_search w95 dblue"  id="btn2" onclick="javascript:goReSearch();"><span>다시검색</span></button>
			</div>
		</div>
	</div>
	<button type="button" class="btn_close" onclick="javascript:closeLayer('2');">창 닫기</button>
</div>


<div class="box_layer layer_join3" id="div3" style="display:none;">
	<div class="layer_contents" >
		<h1 class="tit_search">
			거래처 정보 조회 검색 결과
		</h1>
		<p class="txt_pop_search mgb20" >
			입력하신 정보와 일치하는 거래처 정보는 다음과 같습니다.<br />
			맞으면 확인을 눌러주세요
		</p>
		
		<div id="content_div"></div>
		<div class="btn_wrap">
			<div class="floatR">
				<button type="button" class="btn_ico_search w95 dblue"  id="btn2" onclick="javascript:goReSearch();"><span>다시검색</span></button>
			</div>
		</div>
	</div>
	<button type="button" class="btn_close" onclick="javascript:closeLayer('3');">창 닫기</button>
</div>


<div class="layer_dimmed" id="div_dim" style="display:none;"></div>





