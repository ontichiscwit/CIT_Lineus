<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javascript"></script>
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
</style>



<script type="text/javascript">
function doAgree(){
	if (!$("#agree_terms1").prop("checked")){
		alert('개인정보 수집 이용에 동의해 주십시요.');
		$("#agree_terms1").focus();
		return;
	}else if(!$("#agree_terms2").prop("checked")){
		alert('이용약관에 동의해 주십시요.');
		$("#agree_terms2").focus();
		return;
	}
	
	if($("#agree_terms1").prop("checked")){$('#use_agree').val("Y");}
	if($("#agree_terms2").prop("checked")){$('#perdata_agree').val("Y");}
	if($("#agree_terms3").prop("checked")){$('#sms_agree').val("Y");}
	if($("#agree_terms4").prop("checked")){$('#email_agree').val("Y");}
	
	var datas = {
			emp_id 			: $('#emp_id').val() ,
			pass 			: $('#pass').val(),
			use_agree 		: $('#use_agree').val(),
			perdata_agree 	: $('#perdata_agree').val(),
			sms_agree 		: $('#sms_agree').val(),
			email_agree 	: $('#email_agree').val()
	};

	common.ajaxCall(datas, '/fr/agreement/agree.do' , 'checkReturn'); 
}

function checkReturn(data){
	var returnFlag = typeof data.returnFlag != 'undefined' ? data.returnFlag : '009' ;
	
	if (returnFlag == "000"){
		alert('감사합니다 고객님.\r\nONTIC LineUs의 서비스의 정상적인 이용이 가능하십니다.\r\n확인을 클릭하시면 메인페이지로 이동합니다.\r\n오늘도 즐거운 하루 되십시오. ^^');
		location.href = "/fr/main/list.do" ;
		return;
	}else if (returnFlag == "009"){
		alert('비정상적으로 종료되었습니다.');
		location.href = "/fr/main/list.do" ;
		return;
	}
	
	alert(returnFlag);
}
</script>

<form>
	<input type="hidden" id="use_agree" value=""/>
	<input type="hidden" id="perdata_agree" value=""/>
	<input type="hidden" id="sms_agree" value=""/>
	<input type="hidden" id="email_agree" value=""/>
</form>

<div id="jw_contents">
	<div class="tit_wrap_join">
		<div class="innerWrap">
			<h2>이용약관 동의</h2>
			<span> 중외정보기술 서비스플랫폼을 이용하시려면 이용약관에 동의 해주세요. </span>
		</div>
	</div>

	<!-- 개인정보 수집 및 제공 동의 -->
	<div class="tit_sWrap">
		<h3 class="tit_bold_gray mgt30">개인정보 수집 및 제공 동의</h3>
	</div>
	<p class="txt_join mgb20">아래의 중외정보기술 고객의 “개인정보 제공 동의"를 읽어보신 후 동의하여
		주시기 바랍니다.</p>
	<div class="box_terms">
		<p></p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">㈜중외정보기술 (이하 "회사"라 합니다)는 개인정보보호법에 따라 “회사”의 고객사 또는 고객사 담당자 (이하 "이용고객 또는 회원"이라 합니다)의 개인정보 보호 및 권익을 보호하고 개인정보와 관련한 “이용고객”의 고충을 원활하게 처리할 수 있도록 다음과 같은 처리 방침을 두고 있습니다.</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">“회사”는 개인정보처리방침을 개정하는 경우 웹사이트 공지사항 또는 개별 공지를 통해 “이용고객"에게 공지 할 것입니다.</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;"><br></span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">○ 본 방침은 공시한 날로부터 시행됩니다.</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;"><br></span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">1. 개인정보의 처리 목적&nbsp;</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">“회사”는 개인정보를 아래 각호의 목적 이외의 용도로는 사용하지 않으며, 아래 각호의 목적이 변경 될 시에는 “이용고객”의 사전 동의를 구합니다.</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">① Ontic LineUs 회원 가입 및 관리</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">- 회원 가입의사 확인, 회원제 서비스 제공에 따른 본인 식별·인증, 회원자격 유지·관리, 제한적 본인 확인제 시행에 따른 본인확인, 서비스 부정이용 방지, 만14세 미만 아동 개인정보 수집 시 법정대리인 동의 여부 확인, 각종 고지·통지, 고충처리, 분쟁 조정을 위한 기록 보존 등을 목적</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">② 재화 또는 서비스 제공</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">- ONTIC LineUs에서 회원의 유지보수 요청 및 기타 요구사항에 대해 원활한 서비스 제공 목적&nbsp;</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">③ 마케팅 및 광고에의 활용</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">- 신규 서비스(제품) 개발 및 맞춤 서비스 제공, 이벤트 및 광고성 정보 제공 및 참여기회 제공 목적</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;"><br></span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">2. 개인정보 수집 항목 및 방법</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">- 개인정보 항목 : 이메일, 휴대전화번호, 비밀번호, 로그인ID, 이름, “이용고객”전화번호, 직책, 부서, “이용고객”상호명 또는 회사명&nbsp;</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">- 수집방법 : Ontic LineUs 회원 가입 시 또는 “회사”와 “이용고객”간 체결 된 계약 및 유지보수 계약 정보를 활용하여 수집</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">- 보유근거 : 상법 등 관련 법령의 규정&nbsp;</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">- 보유기간 : 5년&nbsp;</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">- 관련법령 : 신용정보의 수집/처리 및 이용 등에 관한 기록 : 3년</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;"><br></span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">3. 개인정보의 처리 및 보유 기간</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">① “회사”는 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보 수집 시에 동의 받은 개인정보 보유, 이용기간 내에서 개인정보를 처리, 보유합니다.</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">② 수집된 개인정보는 수집.이용에 관한 동의일로부터 서비스 해지 시까지 위 개인정보의 처리 목적을 위하여 보유.이용됩니다.</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">-보유근거 : 상법 등 관련법령의 규정</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">-관련법령 : 신용정보의 수집/처리 및 이용 등에 관한 기록 : 3년</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">-예외사유 : “이용고객”에서 제명 또는 계약 해지 된 경우</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;"><br></span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">4. 정보주체의 권리,의무 및 그 행사방법&nbsp;</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">“이용고객”은 개인정보주체로서 다음과 같은 권리를 행사 할 수 있습니다.</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">① 정보주체는 “회사”에 대해 언제든지 다음 각 호의 개인정보보호 관련 권리를 행사할 수 있습니다.</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;"><span style="white-space:pre">	</span>&nbsp; 1. 개인정보 열람요구</span>
	</span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;"><span style="white-space:pre">	</span>&nbsp; 2. 오류 등이 있을 경우 정정 요구</span>
	</span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;"><span style="white-space:pre">	</span>&nbsp; 3. 삭제요구</span>
	</span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;"><span style="white-space:pre">	</span>&nbsp; 4. 처리정지 요구</span>
	</span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">② 제1항에 따른 권리 행사는 “회사”에 대해 서면, 전자우편, 모사전송(FAX) 등을 통하여 하실 수 있으며 “회사”는 이에 대해 지체 없이 조치하겠습니다.</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">③ 정보주체가 개인정보의 오류 등에 대한 정정 또는 삭제를 요구한 경우에는 “회사”는 정정 또는 삭제를 완료할 때까지 해당 개인정보를 이용하거나 제공하지 않습니다.</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">④ 제1항에 따른 권리 행사는 정보주체의 법정대리인이나 위임을 받은 자 등 대리인을 통하여 하실 수 있습니다. 이 경우 개인정보 보호법 시행규칙 별지 제11호 서식에 따른 위임장을 제출하셔야 합니다.</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;"><br></span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">5. 개인정보의 파기</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">“회사”는 원칙적으로 개인정보 처리목적이 달성된 경우에는 지체 없이 해당 개인정보를 파기합니다. 파기의 절차, 기한 및 방법은 다음과 같습니다.</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">- 파기 절차 : “이용고객”이 입력한 정보는 목적 달성 후 별도의 DB에 옮겨져(종이의 경우 별도의 서류) 내부 방침 및 기타 관련 법령에 따라 일정 기간 저장된 후 혹은 즉시 파기됩니다. 이 때, DB로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 다른 목적으로 이용되지 않습니다.</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">- 파기 기한 : “이용고객”의 개인정보는 개인정보의 보유기간이 경과된 경우에는 보유기간의 종료일로부터 5일 이내에, 개인정보의 처리 목적 달성, 해당 서비스의 폐지, 사업의 종료 등 그 개인정보가 불필요하게 되었을 때에는 개인정보의 처리가 불필요한 것으로 인정되는 날로부터 5일 이내에 그 개인정보를 파기합니다.</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">- 파기 방법 : 전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용합니다.</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;"><br></span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">6. 개인정보의 안전성 확보 조치</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">“회사”는 개인정보보호법 제29조에 따라 다음과 같이 안전성 확보에 필요한 기술적/관리적 및 물리적 조치를 하고 있습니다.</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">① 개인정보 취급 관련 안정성 확보를 위해 정기적으로 자체 감사를 실시하고 있습니다.</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">② 개인정보를 취급하는 직원을 지정하고 담당자에 한정시켜 최소화 하여 개인정보를 관리하는 대책을 시행하고 있습니다.&nbsp;</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">③ “회사”는 해킹이나 컴퓨터 바이러스 등에 의한 개인정보 유출 및 훼손을 막기 위하여 보안프로그램을 설치하고 주기적인 갱신·점검을 하며 외부로부터 접근이 통제된 구역에 시스템을 설치하고 기술적/물리적으로 감시 및 차단하고 있습니다.&nbsp;</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">④ “이용고객”의 비밀번호는 암호화 되어 저장 및 관리되고 있어, 본인만이 알 수 있으며 중요한 데이터는 파일 및 전송 데이터를 암호화 하거나 파일 잠금 기능을 사용하는 등의 별도 보안기능을 사용하고 있습니다.&nbsp;</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">⑤ 개인정보를 처리하는 데이터베이스시스템에 대한 접근권한의 부여,변경,말소를 통하여 개인정보에 대한 접근통제를 위하여 필요한 조치를 하고 있으며 침입차단시스템을 이용하여 외부로부터의 무단 접근을 통제하고 있습니다.&nbsp;</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">⑥ 개인정보를 보관하고 있는 물리적 보관 장소를 별도로 두고 이에 대해 출입통제 절차를 수립, 운영하고 있습니다.</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;"><br></span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">7. 개인정보 보호책임자 작성&nbsp;</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">① “회사”는 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;"><br></span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">▶ 개인정보 보호책임자</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">성&nbsp; 명 : 이완세</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">직&nbsp; 급 : 상무이사</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">연락처 : 02-801-1061, wanse@cwit.co.kr</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;"><br></span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">▶ 개인정보 보호 담당부서</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">성&nbsp; 명 : 곽영건</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">직&nbsp; 급 : 수석연구원</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">연락처 : 02-801-1057, younggun.kwak@cwit.co.kr</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;"><br></span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">② “이용고객”은 “회사”의 서비스(또는 사업)을 이용하시면서 발생한 모든 개인정보 보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의하실 수 있습니다. “회사”는 정보주체의 문의에 대해 지체 없이 답변 및 처리해드릴 것입니다.</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;"><br></span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">8. 개인정보 처리방침 변경&nbsp;</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">개인정보처리방침은 서비스 시행일로부터 적용되며, 법령 및 방침에 따른 변경내용의 추가, 삭제 및 정정이 있는 경우에는 변경사항의 시행 7일 전부터 공지사항을 통하여 고지할 것입니다.</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;"><br></span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;"><br></span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">※ 이용고객께서는 개인정보 수집, 이용에 대한 동의를 거부하실 수 있으나, 이상의 정보는 서비스 제공에 필수적으로 필요한 정보이므로, 동의를 거부하실 경우 회원가입, 서비스 이용 등을 하실 수 없습니다.</span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;"><br></span></span>
</p>
<p class="" align="left" style="margin: 0cm 0cm 0.0001pt; line-height: normal; word-break: keep-all;"><span style="font-family: &quot;맑은 고딕&quot;; color: rgb(121, 121, 121);"><span style="font-size: 13.3333px; letter-spacing: -0.8px;">※ 회원가입 후 서비스 이용과정에서 필요에 따라 요청되는 정보는 서비스 이용과정에서 별도로 안내하고 동의 받도록 하겠습니다.</span></span>
</p>
<div>
	<br>
</div>
<p></p>
	</div>
	<!--// 개인정보 수집 및 제공 동의 -->

	<!-- 이용약관 -->
	<div class="tit_sWrap">
		<h3 class="tit_bold_gray mgt30">이용약관</h3>
	</div>
	<p class="txt_join mgb20">아래의 중외정보기술 고객의 “서비스 이용약관"를 읽어보신 후 동의하여
		주시기 바랍니다.</p>
	<div class="box_terms">
		<p></p><p class="" style="margin: 12pt 0cm 6pt; text-align: center; line-height: 107%; font-size: 16pt; font-family: &quot;맑은 고딕&quot;; font-weight: bold;"><span class=""><span style="font-size: 12pt; color: rgb(121, 121, 121); letter-spacing: -0.6pt;">제</span></span><span class=""><span lang="EN-US" style="font-size: 12pt; font-family: Helvetica, sans-serif; color: rgb(121, 121, 121); letter-spacing: -0.6pt;"> 1 </span></span><span class=""><span style="font-size: 12pt; color: rgb(121, 121, 121); letter-spacing: -0.6pt;">장</span></span><span class=""><span style="font-size: 12pt; font-family: Helvetica, sans-serif; color: rgb(121, 121, 121); letter-spacing: -0.6pt;"> </span></span><span class=""><span style="font-size: 12pt; color: rgb(121, 121, 121); letter-spacing: -0.6pt;">총</span></span><span class=""><span style="font-size: 12pt; font-family: Helvetica, sans-serif; color: rgb(121, 121, 121); letter-spacing: -0.6pt;"> </span></span><span class=""><span style="font-size: 12pt; color: rgb(121, 121, 121); letter-spacing: -0.6pt;">칙</span></span><span lang="EN-US" style="font-size: 9pt;"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt; font-size: 12pt; font-family: 굴림;"><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">제</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> 1 </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">조</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> (</span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">목적</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt">)</span></b></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;
letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">약관은</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">㈜중외정보기술</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">(</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이하</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">라</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.)</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">제공하는</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> ONTIC LineUs </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">웹</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">시스</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;맑은 고딕&quot;;mso-bidi-font-family:&quot;맑은 고딕&quot;;color:#797979;
letter-spacing:-.6pt">템을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">와</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">고객사</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">또는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">고객사</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">담당자</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> (</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이하</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> "</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">이용고객</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">"</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">이라</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">)</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">간에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">시스템</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">유지보수</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">및</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">고객</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">요청</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">사항과</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">관련된</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">인터넷</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> (</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이하</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> "</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">" </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">라</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">)</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이용</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">조건</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">및</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">절차에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">관한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">기본적인</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">사항을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">정함을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">목적으로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span lang="EN-US" style="font-size:
7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;letter-spacing:-.6pt"><o:p>&nbsp;</o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt; font-size: 12pt; font-family: 굴림;"><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">제</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> 2 </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">조</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> (</span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">용어의</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">정의</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt">)</span></b></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;
letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">약관에서</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">사용하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">용어의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">정의는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">다음과</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">같습니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">1. </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이용</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">계약</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">: “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">가</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">제공하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">” </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">이용과</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">관련하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사와</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">이용고객</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">” </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">간에</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">체결하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">계약을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">말합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">2. </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">: “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">가</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">제공하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">절차에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">따른</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">가입</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">신청</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">및</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이용</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">계약</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">체결을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">완료한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">뒤</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">계정을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">발급받아</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">를</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이용할</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">수</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">있는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">자를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">말합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">3. </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이용고객</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> ID: </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">식별과</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">” </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">이용을</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">위하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">이용고객</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">별로</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">가</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">발급하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">문자</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">숫자의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">조합을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">말합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">. </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원은</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이용고객</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> ID</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">통해</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">하위</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> ID</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">들을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">임의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">생성하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">관리할</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">수</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">있습니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">4. </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">비밀번호</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">: </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">자신의</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> ID</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">와</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">일치하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">이용고객</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">임을</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">확인하기</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">위해</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">선정한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">문자</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">특수문자</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">숫자</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">등의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">조합을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">말합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">5. </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">시스템</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">유지보수</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">: “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">와</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">이용고객</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">” </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">간에</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">체결한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이용</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">계약에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">의해</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">요청되는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">이용고객</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">의</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">문의사항</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">수정사항</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, A/S </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">요청사항을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">말합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span lang="EN-US" style="font-size:
7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;letter-spacing:-.6pt"><o:p>&nbsp;</o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt; font-size: 12pt; font-family: 굴림;"><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">제</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> 3 </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">조</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> (</span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">이용약관의</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">효력</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">및</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">변경</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt">)</span></b></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;
letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">1. </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">약관은</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">인터넷</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">(</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#333333;letter-spacing:-.6pt"><a href="http://lineus.cwit.co.kr/"><span style="color:#333333;text-decoration:
none;text-underline:none">http://lineus.cwit.co.kr</span></a></span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">,&nbsp;</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#333333;letter-spacing:-.6pt"><a href="http://cs.cwit.co.kr/"><span style="color:#333333;text-decoration:none;
text-underline:none">http://cs.cwit.co.kr</span></a></span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">)</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">을</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">통하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">공지하거나</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">기타의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">방법으로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">공지함으로써</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">효력이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">발생합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">2. “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">약관의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">변경</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">사유가</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">발생될</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우에는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">약관을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">변경할</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">수</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">있으며</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">약관이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">변경된</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우에는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">지체</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">없이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">공지합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">3. </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원은</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">변경된</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">약관</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">사항에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">동의하지</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">않으면</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">이용을</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">중단하고</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이용</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">계약을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">해지할</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">수</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">있습니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">. </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">약관의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">효력발생일</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이후의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">계속적인</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">이용은</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">약관의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">변경사항에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">동의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">것으로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">간주합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt; line-height: 18pt; font-size: 12pt; font-family: 굴림;"><span lang="EN-US" style="font-size:10.5pt;font-family:&quot;맑은 고딕&quot;;color:#333333;
letter-spacing:-.55pt"><o:p>&nbsp;</o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt; font-size: 12pt; font-family: 굴림;"><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">제</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> 4 </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">조</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> (</span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">약관</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">이외의</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">준칙</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt">)</span></b></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;
letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">약관에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">언급되지</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">않은</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">사항이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">전기통신기본법</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">전기통신사업법</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">기타</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">관련법령에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">규정되어</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">있는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">그</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">규정에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">따라</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">적용할</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">수</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">있습니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p><p class="" style="margin: 12pt 0cm 6pt; text-align: center; line-height: 107%; font-size: 16pt; font-family: &quot;맑은 고딕&quot;; font-weight: bold;"><span class=""><span style="font-size: 12pt; color: rgb(121, 121, 121); letter-spacing: -0.6pt;">제</span></span><span class=""><span lang="EN-US" style="font-size: 12pt; font-family: Helvetica, sans-serif; color: rgb(121, 121, 121); letter-spacing: -0.6pt;"> 2 </span></span><span class=""><span style="font-size: 12pt; color: rgb(121, 121, 121); letter-spacing: -0.6pt;">장</span></span><span class=""><span style="font-size: 12pt; font-family: Helvetica, sans-serif; color: rgb(121, 121, 121); letter-spacing: -0.6pt;"> </span></span><span class=""><span style="font-size: 12pt; color: rgb(121, 121, 121); letter-spacing: -0.6pt;">서비스</span></span><span class=""><span style="font-size: 12pt; font-family: Helvetica, sans-serif; color: rgb(121, 121, 121); letter-spacing: -0.6pt;"> </span></span><span class=""><span style="font-size: 12pt; color: rgb(121, 121, 121); letter-spacing: -0.6pt;">이용계약</span></span><span lang="EN-US" style="font-size: 9pt;"><o:p></o:p></span></p><p></p><p class="" style="margin: 0cm 0cm 0.0001pt; font-size: 12pt; font-family: 굴림;"><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">제</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> 5 </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">조</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> (</span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">서비스</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">이용</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">신청</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">및</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">이용계약의</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">성립</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt">)</span></b></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;
letter-spacing:-.6pt"><o:p></o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">“</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">가</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">제공하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">를</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이용하고자</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">자가</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">본</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">약관의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">내용에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">대하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">동의를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">다음</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">가</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">제시하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">양식과</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">절차에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">따라</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">이용</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">신청을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">하고</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">그</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">신청한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">내용에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">대해</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">가</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">승낙함으로써</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">와</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">이용고객</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">” </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">간</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이용</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">계약이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">체결됩니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span lang="EN-US" style="font-size:
7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;letter-spacing:-.6pt"><o:p>&nbsp;</o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt; font-size: 12pt; font-family: 굴림;"><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">제</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> 6 </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">조</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> (</span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">이용</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">신청</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">및</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">약관의</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">동의</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt">)</span></b></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;
letter-spacing:-.6pt"><o:p></o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">“</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이용고객</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">은</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">가</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">정한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">양식에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">따라</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원정보를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">기입한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">후</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">본</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">약관에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">동의한다는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">의사표시를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">함으로써</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원가입을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">신청합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span lang="EN-US" style="font-size:
7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;letter-spacing:-.6pt"><o:p>&nbsp;</o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt; font-size: 12pt; font-family: 굴림;"><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">제</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> 7 </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">조</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> (</span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">이용신청의</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">승낙</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt">)</span></b></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;
letter-spacing:-.6pt"><o:p></o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">1. “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">제</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">6</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">조에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">따른</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">대하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">약관조건</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">업무상</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">또는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">기술상</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">문제가</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">없는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">본</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">조</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">제</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">2</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">항의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">예외로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">” </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">이용</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">신청을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">승낙합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">2. “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">다음에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">해당하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우에는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">승낙하지</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">아니</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">할</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">수</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">있습니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.&nbsp;</span></span><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><br>
<span class="">- </span></span><span class=""><span style="font-size:10.0pt;
font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;mso-hansi-font-family:Helvetica;
mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">다른</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;
font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;mso-hansi-font-family:Helvetica;
mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">이용고객</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">의</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">명의를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">사용하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">신청한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우</span></span><span lang="EN-US" style="font-size:7.5pt;
font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">- “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이용고객</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">” </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">정보를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">허위로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">기재하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">신청한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우</span></span><span lang="EN-US" style="font-size:7.5pt;
font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">- “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이용고객</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">귀책사유로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">인해</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이용신청의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">승낙이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">곤란한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우</span></span><span class="apple-converted-space"><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">&nbsp;</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:
-.6pt"><o:p></o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span lang="EN-US" style="font-size:
7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;letter-spacing:-.6pt"><o:p>&nbsp;</o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt; font-size: 12pt; font-family: 굴림;"><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">제</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> 8 </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">조</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> (</span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">이용고객</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt">ID </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">부여</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">및</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">관리</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt">)</span></b></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;
letter-spacing:-.6pt"><o:p></o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">1. “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">대하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">약관에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">정하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">바에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">따라</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이용고객</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> ID</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">부여합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">2. </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원은</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">다른</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이용고객</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> ID </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">및</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">비밀번호를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">도용</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">또는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">부정하게</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">사용하지</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">말아야</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">하며</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이용고객</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> ID </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">및</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">비밀번호</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">관리에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">상당한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">주의를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">기울여야</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span lang="EN-US" style="font-size:
7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;letter-spacing:-.6pt"><o:p>&nbsp;</o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt; font-size: 12pt; font-family: 굴림;"><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">제</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> 9 </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">조</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> (</span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">회원</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">정보의</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">변경</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt">)</span></b></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;
letter-spacing:-.6pt"><o:p></o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원은</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">이용</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">신청</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">시</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">기재한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">이용고객</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">” </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">정보가</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">변경되었을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우에는</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">온라인으로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">수정을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">하거나</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">에</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">통보</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">하여야</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">하며</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">미변경으로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">인하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">발생되는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">문제의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">책임은</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원에게</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">있습니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt; line-height: 18pt; font-size: 12pt; font-family: 굴림;"><span lang="EN-US" style="font-size:10.5pt;font-family:&quot;맑은 고딕&quot;;color:#333333;
letter-spacing:-.55pt"><o:p>&nbsp;</o:p></span></p><p class="" style="margin: 12pt 0cm 6pt; text-align: center; line-height: 107%; font-size: 16pt; font-family: &quot;맑은 고딕&quot;; font-weight: bold;"><span class=""><span style="font-size: 12pt; color: rgb(121, 121, 121); letter-spacing: -0.6pt;">제</span></span><span class=""><span lang="EN-US" style="font-size: 12pt; font-family: Helvetica, sans-serif; color: rgb(121, 121, 121); letter-spacing: -0.6pt;"> 3 </span></span><span class=""><span style="font-size: 12pt; color: rgb(121, 121, 121); letter-spacing: -0.6pt;">장</span></span><span class=""><span style="font-size: 12pt; font-family: Helvetica, sans-serif; color: rgb(121, 121, 121); letter-spacing: -0.6pt;"> </span></span><span class=""><span style="font-size: 12pt; color: rgb(121, 121, 121); letter-spacing: -0.6pt;">계약</span></span><span class=""><span style="font-size: 12pt; font-family: Helvetica, sans-serif; color: rgb(121, 121, 121); letter-spacing: -0.6pt;"> </span></span><span class=""><span style="font-size: 12pt; color: rgb(121, 121, 121); letter-spacing: -0.6pt;">당사자의</span></span><span class=""><span style="font-size: 12pt; font-family: Helvetica, sans-serif; color: rgb(121, 121, 121); letter-spacing: -0.6pt;"> </span></span><span class=""><span style="font-size: 12pt; color: rgb(121, 121, 121); letter-spacing: -0.6pt;">의무</span></span><span class=""><span style="font-size: 12pt; font-family: Helvetica, sans-serif; color: rgb(121, 121, 121); letter-spacing: -0.6pt;"> </span></span><span class=""><span style="font-size: 12pt; color: rgb(121, 121, 121); letter-spacing: -0.6pt;">및</span></span><span class=""><span style="font-size: 12pt; font-family: Helvetica, sans-serif; color: rgb(121, 121, 121); letter-spacing: -0.6pt;"> </span></span><span class=""><span style="font-size: 12pt; color: rgb(121, 121, 121); letter-spacing: -0.6pt;">서비스</span></span><span lang="EN-US" style="font-size: 9pt;"><o:p></o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt; font-size: 12pt; font-family: 굴림;"><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">제</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> 10 </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">조</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> (</span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">회사의</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">의무</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt">)</span></b></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;
letter-spacing:-.6pt"><o:p></o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">1. “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">법령과</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">본</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">약관이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">금지하거나</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">미풍</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">양속에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">반하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">행위를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">하지</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">않으며</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">계속적이고</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">안정적인</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">를</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">제공하기</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">위하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">노력합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">2. “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">개인정보보호를</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">위해</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">보안시스템을</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">구축하며</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">개인정보처리방침을</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">공시하고</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">준수합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">3. “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">개인정보를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">본인의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">승낙</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">없이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">타인에게</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">누설</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">배포하지</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">않습니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">. </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">단</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">전기통신관련법령</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">등</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">관계</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">법령에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">의하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">관련</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">국가기관</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">등의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">요구가</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">있는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우에는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">그러하지</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">아니합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">4. “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원으로부터</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">제기되는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">의견이나</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">불만이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">정당하다고</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">인정될</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우에는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">바로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">처리될</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">수</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">있도록</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">최선의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">노력을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">2. “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">특별한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">사유가</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">없는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">” </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">제공</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">설비를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">항상</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">운용</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">가능한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">상태로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">유지</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">보수하여야</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span lang="EN-US" style="font-size:
7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;letter-spacing:-.6pt"><o:p>&nbsp;</o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt; font-size: 12pt; font-family: 굴림;"><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">제</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> 11 </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">조</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> (</span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">회원의</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">의무</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt">)</span></b></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;
letter-spacing:-.6pt"><o:p></o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">1. </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원은</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">” </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">이용</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">시</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">다음</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">각</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">호의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">행위를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">하지</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">않아야</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p><p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">



























































<span class=""><span lang="EN-US" style="font-size: 10pt; letter-spacing: -0.6pt;">- “</span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">서비스</span><span lang="EN-US" style="font-size: 10pt; letter-spacing: -0.6pt;">”</span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">에서</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">얻은</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">정보를</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> <span lang="EN-US">“</span></span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">회사</span><span lang="EN-US" style="font-size: 10pt; letter-spacing: -0.6pt;">”</span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">의</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">사전</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">승낙</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">없이</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">복제하거나</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">이를</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">변경</span><span lang="EN-US" style="font-size: 10pt; letter-spacing: -0.6pt;">, </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">출판</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">및</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">방송</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">등에</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">사용하거나</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">타인에게</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">제공하는</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">행위</span></span><span lang="EN-US" style="font-size: 10pt; letter-spacing: -0.6pt;"><br>
<span class="">- “</span></span><span class=""><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">회사</span><span lang="EN-US" style="font-size: 10pt; letter-spacing: -0.6pt;">”</span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">의</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">저작권</span><span lang="EN-US" style="font-size: 10pt; letter-spacing: -0.6pt;">, </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">타인의</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">저작권</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">등</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">기타</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">권리를</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">침해하는</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">행위</span></span><span lang="EN-US" style="font-size: 10pt; letter-spacing: -0.6pt;"><br>
<span class="">- </span></span><span class=""><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">공공질서</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">및</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">미풍양속에</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">위반되는</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">내용의</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">정보</span><span lang="EN-US" style="font-size: 10pt; letter-spacing: -0.6pt;">, </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">문장</span><span lang="EN-US" style="font-size: 10pt; letter-spacing: -0.6pt;">, </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">도형</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">등을</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">타인에게</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">유포하는</span><span style="font-size: 10pt; letter-spacing: -0.6pt;"> </span><span style="font-size: 10pt; font-family: &quot;맑은 고딕&quot;; letter-spacing: -0.6pt;">행위</span></span><br></span></span></p><p></p><p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">- </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">관계법령에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">위배되는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">행위</span></span><span lang="EN-US" style="font-size:10.0pt;
font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;
letter-spacing:-.6pt"><br>
<span class="">- </span></span><span class=""><span style="font-size:10.0pt;
font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;mso-hansi-font-family:Helvetica;
mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">기타</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;
font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;mso-hansi-font-family:Helvetica;
mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">가</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">부적절하다고</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">판단하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">행위</span></span><span lang="EN-US" style="font-size:7.5pt;
font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">2. </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원은</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">관계법령</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">약관에서</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">규정하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">사항</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이용</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">안내</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">및</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">주의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">사항을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">준수하여야</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">3. </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원은</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">내용별로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">가</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">공지사항에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">게시하거나</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">별도로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">공지한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">이용</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">제한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">사항을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">준수하여야</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">4. </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원은</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">의</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">사전</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">승낙</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">없이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">가</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">제공</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">또는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">운영하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">웹사이트</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">상에서</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">어떠한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">영리행위도</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">할</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">수</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">없습니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt; line-height: 18pt; font-size: 12pt; font-family: 굴림;"><span lang="EN-US" style="font-size:10.5pt;font-family:&quot;맑은 고딕&quot;;color:#333333;
letter-spacing:-.55pt"><o:p>&nbsp;</o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt; font-size: 12pt; font-family: 굴림;"><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">제</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> 12 </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">조</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> (</span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">서비스의</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">요금</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt">)</span></b></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;
letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">“</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">에서</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">제공하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">는</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">기본적으로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">와</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원간의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">유지보수</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">계약에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">의해</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">진행됩니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">. </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">요청한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">가</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">유상으로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">제공되어야</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">할</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">와</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원간의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">별도</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">합의에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">의해</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">처리되며</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">부분은</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> ONTIC LineUs</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">웹</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">시스템에서</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">관리하지</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">않습니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span lang="EN-US" style="font-size:
7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;letter-spacing:-.6pt"><o:p>&nbsp;</o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt; font-size: 12pt; font-family: 굴림;"><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">제</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> 13 </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">조</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> (</span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">서비스</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">이용시간</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt">)</span></b></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;
letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">“</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">의</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">업무상</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">또는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">기술상의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">장애</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">기타</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">특별한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">사유가</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">없는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">연중무휴</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, 1</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">일</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> 24</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">시간</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이용할</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">수</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">있습니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">. </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">다만</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">설비의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">장애</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">등</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">설비의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">점검이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">필요한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">는</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">” </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">이용의</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">전부</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">또는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">일부에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">대하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">제한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">할</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">수</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">있습니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt; line-height: 18pt; font-size: 12pt; font-family: 굴림;"><span lang="EN-US" style="font-size:10.5pt;font-family:&quot;맑은 고딕&quot;;color:#333333;
letter-spacing:-.55pt"><o:p>&nbsp;</o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt; font-size: 12pt; font-family: 굴림;"><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">제</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> 14 </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">조</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> (</span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">정보의</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">제공</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">및</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">광고의</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">게재</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt">)</span></b></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;
letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">1. “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">” </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">이용에</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">필요하다고</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">인정되는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">다양한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">정보</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">및</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">광고에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">대해서는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">전자우편이나</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">서신우편</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, SMS(</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">핸드폰</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">문자메시지</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">), </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">팩스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">메신저</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">등의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">방법으로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원에게</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">제공</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">할</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">수</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">있으며</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">만약</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">원치</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">않는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">정보를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">수신한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원은</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">수신</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">거부</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">할</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">수</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">있습니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">2. “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">의</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">운용과</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">관련하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">서비스화면</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">홈페이지</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">전자우편</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">등에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">광고</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">등을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">게재</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">할</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">수</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">있으며</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">동의한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">것으로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">간주합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt; line-height: 18pt; font-size: 12pt; font-family: 굴림;"><span lang="EN-US" style="font-size:10.5pt;font-family:&quot;맑은 고딕&quot;;color:#333333;
letter-spacing:-.55pt"><o:p>&nbsp;</o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt; font-size: 12pt; font-family: 굴림;"><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">제</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> 15</span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">조</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> (</span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">서비스</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">제한</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">및</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">정지</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt">)</span></b></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;
letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">1. </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">상기</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">” </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">이용을</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">위한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">유지보수료를</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">지속적으로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">연체하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">는</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원에게</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">사전</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">통보</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">후</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">” </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이용을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">중단</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">할</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">수</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">있습니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">2. </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">상기</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> 1</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">항으로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">인하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">가</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">” </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">이용을</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">중단하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">발생되는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">손해에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">대하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">는</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">아무런</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">책임을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">지지</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">않습니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">3. “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">전시</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">사변</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">천재지변</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">또는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">준하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">국가비상사태가</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">발생하거나</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">발생</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">할</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">우려가</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">있는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">전기통신사업법에</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">의한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">기간통신</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">사업자가</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">전기통신서비스를</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">중지하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">등</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">기타</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">불가항력적</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">사유가</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">있는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우에는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">의</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">전부</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">또는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">일부를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">제한하거나</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">정지</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">할</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">수</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">있습니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">4. “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">제</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">1</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">항의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">규정에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">의하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">의</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이용을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">제한하거나</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">정지한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">때에는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">그</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">사유</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">및</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">제한기간</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">등을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">지체</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">없이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원에게</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">알려야</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt; line-height: 18pt; font-size: 12pt; font-family: 굴림;"><span lang="EN-US" style="font-size:10.5pt;font-family:&quot;맑은 고딕&quot;;color:#333333;
letter-spacing:-.55pt"><o:p>&nbsp;</o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt; font-size: 12pt; font-family: 굴림;"><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">제</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> 16 </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">조</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> (</span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">서비스의</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">해지</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt">)</span></b></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;
letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">1. </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">파산</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">화의</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사정리</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">또는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">해산절차</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">진행</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">채무정리</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경매신청</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">채권</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">추심</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">및</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">압류</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">유지보수</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">계약해지</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">등</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이와</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">유사한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">절차가</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">진행되는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">는</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원에게</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이용계약을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">해지</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">할</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">수</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">있습니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span class="apple-converted-space"><span lang="EN-US" style="font-size:10.0pt;
font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;
letter-spacing:-.6pt">&nbsp;</span></span><span lang="EN-US" style="font-size:
7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">2. </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이용계약이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">해지된</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우라도</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이미</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">발생</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">된</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">와</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">이용고객</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">” </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">간의</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">권리와</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">의무에는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">영향을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">미치지</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">아니합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p><p class="" style="margin: 12pt 0cm 6pt; text-align: center; line-height: 107%; font-size: 16pt; font-family: &quot;맑은 고딕&quot;; font-weight: bold;"><span class=""><span style="font-size: 12pt; color: rgb(121, 121, 121); letter-spacing: -0.6pt;">제</span></span><span class=""><span lang="EN-US" style="font-size: 12pt; font-family: Helvetica, sans-serif; color: rgb(121, 121, 121); letter-spacing: -0.6pt;"> 4 </span></span><span class=""><span style="font-size: 12pt; color: rgb(121, 121, 121); letter-spacing: -0.6pt;">장</span></span><span class=""><span style="font-size: 12pt; font-family: Helvetica, sans-serif; color: rgb(121, 121, 121); letter-spacing: -0.6pt;"> </span></span><span class=""><span style="font-size: 12pt; color: rgb(121, 121, 121); letter-spacing: -0.6pt;">기타</span></span><span lang="EN-US" style="font-size: 9pt;"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt; font-size: 12pt; font-family: 굴림;"><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">제</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> 17 </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">조</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> (</span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">서비스</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">이용제한</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt">)</span></b></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;
letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">“</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">아래</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">기재된</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">문구에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">해당하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">행위를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">하였을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">사전통지</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">없이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">” </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">이용에</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">제한을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">둘</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">수</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">있습니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">- </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">운영을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">고의로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">방해한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우</span></span><span lang="EN-US" style="font-size:10.0pt;
font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;
letter-spacing:-.6pt"><br>
<span class="">- </span></span><span class=""><span style="font-size:10.0pt;
font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;mso-hansi-font-family:Helvetica;
mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">공공질서</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">및</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">미풍양속에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">저해되는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">내용을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">고의로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">유포시킨</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우</span></span><span lang="EN-US" style="font-size:10.0pt;
font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;
letter-spacing:-.6pt"><br>
<span class="">- </span></span><span class=""><span style="font-size:10.0pt;
font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;mso-hansi-font-family:Helvetica;
mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">회원이</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">국익</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">또는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">사회적</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">공익을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">저해</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">할</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">목적으로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">” </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">이용을</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">계획</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">또는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">실행하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우</span></span><span lang="EN-US" style="font-size:10.0pt;
font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;
letter-spacing:-.6pt"><br>
<span class="">- </span></span><span class=""><span style="font-size:10.0pt;
font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;mso-hansi-font-family:Helvetica;
mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">타인의</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">명예를</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">손상시키거나</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">불이익을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">주는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">행위를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">&nbsp;</span></span><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><br>
<span class="">- </span></span><span class=""><span style="font-size:10.0pt;
font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;mso-hansi-font-family:Helvetica;
mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">안정적</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">운영을</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">방해할</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">목적으로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">다량의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">정보를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">전송하거나</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">광고성</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">정보를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">전송하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우</span></span><span lang="EN-US" style="font-size:10.0pt;
font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;
letter-spacing:-.6pt"><br>
<span class="">- </span></span><span class=""><span style="font-size:10.0pt;
font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;mso-hansi-font-family:Helvetica;
mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">정보통신설비의</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">오작동이나</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">정보</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">등의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">파괴를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">유발시키는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">컴퓨터</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">바이러스</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">프로그램</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">등을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">유포하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우</span></span><span lang="EN-US" style="font-size:10.0pt;
font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;
letter-spacing:-.6pt"><br>
<span class="">- “</span></span><span class=""><span style="font-size:10.0pt;
font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;mso-hansi-font-family:Helvetica;
mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">다른</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">또는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">타인의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">지적재산권을</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">침해하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">&nbsp;</span></span><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><br>
<span class="">- </span></span><span class=""><span style="font-size:10.0pt;
font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;mso-hansi-font-family:Helvetica;
mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">정보통신윤리</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">위원회</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">등</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">외부기관의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">시정</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">요구가</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">있거나</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">불법선거</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">운동과</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">관련하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">선거관리위원회의</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">유권해석을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">받은</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> &nbsp;</span></span><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><br>
<span class="">- </span></span><span class=""><span style="font-size:10.0pt;
font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;mso-hansi-font-family:Helvetica;
mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">타인의</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">개인정보</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">회원</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">ID </span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">및</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">비밀번호를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">부정하게</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">사용하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">&nbsp;</span></span><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><br>
<span class="">- “</span></span><span class=""><span style="font-size:10.0pt;
font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;mso-hansi-font-family:Helvetica;
mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">의</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">정보를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이용하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">얻은</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">정보를</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">의</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">사전</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">승낙</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">없이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">복제</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">또는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">유통시키거나</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">상업적으로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이용하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">&nbsp;</span></span><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><br>
<span class="">- </span></span><span class=""><span style="font-size:10.0pt;
font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;mso-hansi-font-family:Helvetica;
mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">회원이</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">게시판에</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">음란물을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">게재하거나</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">음란사이트를</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">링크하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우</span></span><span lang="EN-US" style="font-size:10.0pt;
font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;
letter-spacing:-.6pt"><br>
<span class="">- </span></span><span class=""><span style="font-size:10.0pt;
font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;mso-hansi-font-family:Helvetica;
mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">본</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">약관을</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">포함하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">가</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">정한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이용</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">조건</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">및</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">기타</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">관계</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">법령에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">위반한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우</span></span><span lang="EN-US" style="font-size:7.5pt;
font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span lang="EN-US" style="font-size:
7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;letter-spacing:-.6pt"><o:p>&nbsp;</o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt; font-size: 12pt; font-family: 굴림;"><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">제</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> 18 </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">조</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> (</span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">면책</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt">)</span></b></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;
letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">1. “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">귀책사유로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">인하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">장애가</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">발생한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우에는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">책임이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">면제됩니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">2. “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">게시</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">또는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">전송한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">자료의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">내용에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">대해서는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">책임이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">면제됩니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">3. “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">상호간</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">또는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">제</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">3</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">자와</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">를</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">매개로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">물품거래로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">인한여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">발생되는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">의무와</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">권리에서</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">책임이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">면제됩니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">4 .”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">자료</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">보관</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">및</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">전송에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">관한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">책임이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">없으며</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">자료의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">손실이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">있는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우에도</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">책임이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">면제됩니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">5. “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">천재지변</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">기타</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">준하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">불가항력으로</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">인하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">를</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">제공할</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">수</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">없을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우에는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">” </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">제공</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">중지에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">따른</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">손해에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">대하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">책임을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">면합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">6. “</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회원의</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">귀책사유로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">인한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> <span lang="EN-US">“</span></span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">서비스</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">”</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">이용</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">장애에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">대하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">책임을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">면합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt; line-height: 18pt; font-size: 12pt; font-family: 굴림;"><span lang="EN-US" style="font-size:10.5pt;font-family:&quot;맑은 고딕&quot;;color:#333333;
letter-spacing:-.55pt"><o:p>&nbsp;</o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt; font-size: 12pt; font-family: 굴림;"><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">제</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> 19 </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">조</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> (</span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">관할</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">법원</span></b></span><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt">)</span></b></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;Helvetica&quot;,sans-serif;color:#797979;
letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt 27pt; font-size: 12pt; font-family: 굴림;"><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">1. </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">본</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">약관</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">내용에</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">관하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">상호</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">이견이</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">있을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">원만히</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">협의하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">해결하되</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">, </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">협의로</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">해결되지</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">아니하여</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">소송을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">제기하는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">경우에는</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">회사</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">소재지</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">법원을</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">관할법원으로</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US" style="font-size:7.5pt;font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"><o:p></o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt; line-height: 18pt; font-size: 12pt; font-family: 굴림;"><span lang="EN-US" style="font-size:10.5pt;font-family:&quot;맑은 고딕&quot;;color:#333333;
letter-spacing:-.55pt"><o:p>&nbsp;</o:p></span></p>

<p class="" style="margin: 0cm 0cm 0.0001pt; font-size: 12pt; font-family: 굴림;"><span class=""><b><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt">· </span></b></span><span class=""><b><span style="font-size:10.0pt;mso-ascii-font-family:Helvetica;mso-hansi-font-family:
Helvetica;mso-bidi-font-family:Helvetica;color:#797979;letter-spacing:-.6pt">부칙</span></b></span><span class=""><b><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
color:#797979;letter-spacing:-.6pt"> </span></b></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">(</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">시행일</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;
mso-fareast-font-family:&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">) </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:
Helvetica;mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;
color:#797979;letter-spacing:-.6pt">이</span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">약관은</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">공시한</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">날로부터</span></span><span class=""><span style="font-size:
10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:&quot;맑은 고딕&quot;;
color:#797979;letter-spacing:-.6pt"> </span></span><span class=""><span style="font-size:10.0pt;font-family:&quot;맑은 고딕&quot;;mso-ascii-font-family:Helvetica;
mso-hansi-font-family:Helvetica;mso-bidi-font-family:Helvetica;color:#797979;
letter-spacing:-.6pt">시행합니다</span></span><span class=""><span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Helvetica&quot;,sans-serif;mso-fareast-font-family:
&quot;맑은 고딕&quot;;color:#797979;letter-spacing:-.6pt">.</span></span><span lang="EN-US"><o:p></o:p></span></p><br><p></p>	
	
	</div>
	<div class="terms_agree">
		<input type="checkbox" id="agree_terms1" /> <label for="agree_terms1">위와
			같은 개인정보 수집 이용에 동의하십니까? 동의하는 경우에는 왼쪽 박스에 체크해 주십시오. </label> <br /> <input
			type="checkbox" id="agree_terms2" /> <label for="agree_terms2">위와
			같은 서비스 이용약관에 동의하십니까? 동의하는 경우에는 왼쪽 박스에 체크해 주십시오. </label>
	</div>
	<!--// 이용약관 -->
	
	
	<!--// SMS, 이메일  -->
	<div class="tit_sWrap">
		<h3 class="tit_bold_gray mgt30">SMS,이메일 수신에 대한 안내 </h3>
	</div>
	<p class="txt_join mgb20">아래의 중외정보기술 고객의 “SMS, 이메일 송신 서비스에 대한 안내"를 읽어보신 후 동의하여 주시기 바랍니다.</p>
	<table class="sType mgb30">
			<caption>SMS, 이메일 수신 동의</caption>
			<colgroup>
				<col style="width:180px;">
				<col style="auto;">	
			</colgroup>
			<tbody>
			<tr>
				<th scope="row" style="">목적</th>
				<td>
					A/S 처리 완료 알림 및 A/S 조치 정보 제공, 회원 가입/승인/탈퇴 알림, 당사의 신규 서비스 안내 
				</td>
			</tr>
			<tr>	
				<th scope="row">항목</th>
				<td>
					이메일 주소, 휴대폰 번호
				</td>
			</tr>
			<tr>	
				<th scope="row">보유기간</th>
				<td>
					SMS, 이메일 수신 동의 철회 시
				</td>
			</tr>
		</tbody>
	</table>
	<div class="terms_agree">
		<input type="checkbox" id="agree_terms3"> 
			<label for="agree_terms3">위와 같은 SMS 알림 서비스 이용에 동의하십니까? 동의하는 경우에는 왼쪽 박스에 체크해 주십시오. </label> 
			<br> 
		<input type="checkbox" id="agree_terms4"> 
			<label for="agree_terms4">위와 같은 이메일 발송 서비스 이용약관에 동의하십니까? 동의하는 경우에는 왼쪽 박스에 체크해 주십시오. </label>
	</div>
	
	<div class="btn_wrap">
		<div class="floatR">
			<button type="button" class="btn_ico_regist" onclick="doAgree()">
				<span>확인</span>
			</button>
			<button type="button" class="btn_ico_cancel" onclick="location.href='/fr/login/form.do'">
				<span>취소</span>
			</button>
		</div>
	</div>
</div>