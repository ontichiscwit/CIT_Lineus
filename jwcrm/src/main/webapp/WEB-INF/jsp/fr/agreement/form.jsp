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
	
	var datas = {
			emp_id 			: $('#emp_id').val() ,
			pass 				: $('#pass').val() 
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
		<p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">㈜중외정보기술 (이하 "회사"라 합니다)는 개인정보보호법에 따라 ㈜중외정보기술의 고객사 또는 고객사 담당자 (이하 "이용고객 또는 회원"이라 합니다)의 개인정보 보호 및 권익을 보호하고 개인정보와 관련한 이용고객의 고충을 원활하게 처리할 수 있도록 다음과 같은 처리방침을 두고 있습니다</span><span class="s1" style="font-size: 10pt;">.</span></p>
		<p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">회사는 개인정보처리방침을 개정하는 경우 웹사이트 공지사항(또는 개별공지)을 통하여 공지할 것입니다</span><span class="s1" style="font-size: 10pt;">.</span></p>
		<p class="p2"><br></p>
		<p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">○ 본 방침은 공시한 날로부터 시행됩니다</span><span class="s1" style="font-size: 10pt;">.</span></p>
		<p class="p2"><br></p>
		<p class="p1" style="line-height: 1.5;"><b><span style="font-size: 10pt;">1. 개인정보의 처리 목적</span><span class="Apple-converted-space" style="font-size: 10pt;">&nbsp;</span></b></p>
		<p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">회사는 개인정보를 다음의 목적을 위해 처리합니다. 처리한 개인정보는 다음의 목적 이외의 용도로는 사용되지 않으며 이용 목적이 변경될 시에는 사전동의를 구할 예정입니다</span><span class="s1" style="font-size: 10pt;">.</span></p>
		<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">① Ontic LineUs 회원가입 및 관리</span></p>
		<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">- 회원 가입의사 확인, 회원제 서비스 제공에 따른 본인 식별·인증, 회원자격 유지·관리, 제한적 본인 확인제 시행에 따른 본인확인, 서비스 부정이용 방지, 만14세 미만 아동 개인정보 수집 시 법정대리인 동의 여부 확인, 각종 고지·통지, 고충처리, 분쟁 조정을 위한 기록 보존 등을 목적으로 개인정보를 처리합니다</span><span class="s1" style="font-size: 10pt;">.</span></p>
		<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">② 재화 또는 서비스 제공</span></p>
		<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">- ONTIC LineUs에서 이용고객의 유지보수 요청 및 기타 요구사항에 대해 원활한 서비스 제공을 목적으로 개인정보를 처리합니다</span><span class="s1" style="font-size: 10pt;">.</span></p>
		<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">③ 마케팅 및 광고에의 활용</span></p>
		<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">- 신규 서비스(제품) 개발 및 맞춤 서비스 제공, 이벤트 및 광고성 정보 제공 및 참여기회 제공 등을 목적으로 개인정보를 처리합니다</span><span class="s1" style="font-size: 10pt;">.</span></p>
		<p class="p2"><b></b><br></p>
		<p class="p1" style="line-height: 1.5;"><b><span style="font-size: 10pt;">2. 개인정보 수집 항목 및 방법</span></b></p>
		<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">- 개인정보 항목 : 이메일, 휴대전화번호, 비밀번호, 로그인ID, 이름, 회사전화번호, 직책, 부서, 회사명 </span><br><span style="font-size: 10pt;">
		- 수집방법 : Ontic LineUs 회원 가입 시 또는 당사자간 프로젝트 계약 정보, 유지보수 계약 정보를 활용하여 수집</span></p>
		<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">- 보유근거 : 상법 등 관련법령의 규정 </span><br><span style="font-size: 10pt;">
		- 보유기간 : 5년 </span><br><span style="font-size: 10pt;">
		- 관련법령 : 신용정보의 수집/처리 및 이용 등에 관한 기록 : 3년</span></p>
		<p class="p2"><b></b><br></p>
		<p class="p1" style="line-height: 1.5;"><b><span style="font-size: 10pt;">3. 개인정보의 처리 및 보유 기간</span></b></p>
		<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">① 회사는 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의 받은 개인정보 보유, 이용기간 내에서 개인정보를 처리, 보유합니다</span><span class="s1" style="font-size: 10pt;">.</span></p>
		<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">② 수집된 개인정보는 수집</span><span class="s1" style="font-size: 10pt;">.</span><span style="font-size: 10pt;">이용에 관한 동의일로부터 서비스 해지 시까지 위 개인정보의 처리 목적을 위하여 보유</span><span class="s1" style="font-size: 10pt;">.</span><span style="font-size: 10pt;">이용됩니다</span><span class="s1" style="font-size: 10pt;">.</span></p>
		<p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">-</span><span style="font-size: 10pt;"> 보유근거 : 상법 등 관련법령의 규정</span></p>
		<p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">-</span><span style="font-size: 10pt;"> 관련법령 : 신용정보의 수집/처리 및 이용 등에 관한 기록 : 3년</span></p>
		<p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">-</span><span style="font-size: 10pt;"> 예외사유 : 이용고객에서 제명 또는 계약해지된 경우</span></p>
		<p class="p2"><br></p>
		<p class="p1" style="line-height: 1.5;"><b><span style="font-size: 10pt;">4. 정보주체의 권리</span></b><span class="s1"><b><span style="font-size: 10pt;">,</span></b></span><b><span style="font-size: 10pt;">의무 및 그 행사방법</span><span class="Apple-converted-space" style="font-size: 10pt;">&nbsp;</span></b></p>
		<p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">이용고객은 개인정보주체로서 다음과 같은 권리를 행사할 수 있습니다</span><span class="s1" style="font-size: 10pt;">.</span></p><p class="p1" style="line-height: 1.5;"><span style="font-family: &quot;Malgun Gothic&quot;; font-size: 10pt;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ①</span><span style="font-family: &quot;Malgun Gothic&quot;;">&nbsp;</span><span style="font-family: &quot;Malgun Gothic&quot;; font-size: 10pt;">정보주체는 회사에 대해 언제든지 다음 각 호의 개인정보보호 관련 권리를 행사할 수 있습니다</span><span class="s1" style="font-family: &quot;Malgun Gothic&quot;; font-size: 10pt;">.</span></p><p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1. 개인정보 열람요구<br></span><span style="font-size: 10pt;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 2. 오류 등이 있을 경우 정정 요구</span></p><p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 3. 삭제요구</span></p><p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 4. 처리정지 요구</span></p><p class="p1" style="line-height: 1.5;"><span style="font-family: &quot;Malgun Gothic&quot;; font-size: 10pt;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;②&nbsp;</span><span style="font-family: &quot;Malgun Gothic&quot;; font-size: 10pt;">제1항에 따른 권리 행사는 회사에 대해 서면, 전자우편, 모사전송(FAX) 등을 통하여 하실 수 있으며 회사는 이에 대해 지체 없이 조치하겠습니다</span><span class="s1" style="font-family: &quot;Malgun Gothic&quot;; font-size: 10pt;">.</span></p><p class="p1" style="line-height: 1.5;"><span style="font-family: &quot;Malgun Gothic&quot;; font-size: 10pt;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;③&nbsp;</span><span style="font-family: &quot;Malgun Gothic&quot;; font-size: 10pt;">정보주체가 개인정보의 오류 등에 대한 정정 또는 삭제를 요구한 경우에는 회사는 정정 또는 삭제를 완료할 때까지 해당 개인정보를 이용하거나 제공하지 않습니다</span><span class="s1" style="font-family: &quot;Malgun Gothic&quot;; font-size: 10pt;">.</span></p>
		<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">&nbsp;④ 제1항에 따른 권리 행사는 정보주체의 법정대리인이나 위임을 받은 자 등 대리인을 통하여 하실 수 있습니다. 이 경우 개인정보 보호법 시행규칙 별지 제11호 서식에 따른 위임장을 제출하셔야 합니다</span><span class="s1" style="font-size: 10pt;">.</span></p>
		<p class="p4"><br></p>
		<p class="p1" style="line-height: 1.5;"><b><span style="font-size: 10pt;">5. 개인정보의 파기</span></b></p>
		<p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">회사는 원칙적으로 개인정보 처리목적이 달성된 경우에는 지체없이 해당 개인정보를 파기합니다. 파기의 절차, 기한 및 방법은 다음과 같습니다</span><span class="s1" style="font-size: 10pt;">.</span></p>
		<p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">-</span><span style="font-size: 10pt;"> 파기절차 : 이용고객이 입력한 정보는 목적 달성 후 별도의 DB에 옮겨져(종이의 경우 별도의 서류) 내부 방침 및 기타 관련 법령에 따라 일정기간 저장된 후 혹은 즉시 파기됩니다. 이 때, DB로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 다른 목적으로 이용되지 않습니다</span><span class="s1" style="font-size: 10pt;">.</span></p>
		<p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">-</span><span style="font-size: 10pt;"> 파기기한 : 이용고객의 개인정보는 개인정보의 보유기간이 경과된 경우에는 보유기간의 종료일로부터 5일 이내에, 개인정보의 처리 목적 달성, 해당 서비스의 폐지, 사업의 종료 등 그 개인정보가 불필요하게 되었을 때에는 개인정보의 처리가 불필요한 것으로 인정되는 날로부터 5일 이내에 그 개인정보를 파기합니다</span><span class="s1" style="font-size: 10pt;">.</span></p>
		<p class="p3" style="line-height: 1.5;"><span class="s1" style="font-size: 10pt;">-</span><span style="font-size: 10pt;"> 파기방법 : 전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용합니다</span><span class="s1" style="font-size: 10pt;">.</span></p>
		<p class="p4"><br></p>
		<p class="p1" style="line-height: 1.5;"><b><span style="font-size: 10pt;">6. 개인정보의 안전성 확보 조치</span></b></p>
		<p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">회사는 개인정보보호법 제29조에 따라 다음과 같이 안전성 확보에 필요한 기술적/관리적 및 물리적 조치를 하고 있습니다</span><span class="s1" style="font-size: 10pt;">.</span></p>
		<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">① 개인정보 취급 관련 안정성 확보를 위해 정기적으로 자체 감사를 실시하고 있습니다</span><span class="s1" style="font-size: 10pt;">.</span></p>
		<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">② 개인정보를 취급하는 직원을 지정하고 담당자에 한정시켜 최소화 하여 개인정보를 관리하는 대책을 시행하고 있습니다</span><span class="s1" style="font-size: 10pt;">.</span></p>
		<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">③ 회사는 해킹이나 컴퓨터 바이러스 등에 의한 개인정보 유출 및 훼손을 막기 위하여 보안프로그램을 설치하고 주기적인 갱신·점검을 하며 외부로부터 접근이 통제된 구역에 시스템을 설치하고 기술적/물리적으로 감시 및 차단하고 있습니다</span><span class="s1" style="font-size: 10pt;">.</span></p>
		<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">④ 이용고객의 비밀번호는 암호화 되어 저장 및 관리되고 있어, 본인만이 알 수 있으며 중요한 데이터는 파일 및 전송 데이터를 암호화 하거나 파일 잠금 기능을 사용하는 등의 별도 보안기능을 사용하고 있습니다</span><span class="s1" style="font-size: 10pt;">.</span></p>
		<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">⑤ 개인정보를 처리하는 데이터베이스시스템에 대한 접근권한의 부여</span><span class="s1" style="font-size: 10pt;">,</span><span style="font-size: 10pt;">변경</span><span class="s1" style="font-size: 10pt;">,</span><span style="font-size: 10pt;">말소를 통하여 개인정보에 대한 접근통제를 위하여 필요한 조치를 하고 있으며 침입차단시스템을 이용하여 외부로부터의 무단 접근을 통제하고 있습니다</span><span class="s1" style="font-size: 10pt;">.</span></p>
		<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">⑥ 개인정보를 보관하고 있는 물리적 보관 장소를 별도로 두고 이에 대해 출입통제 절차를 수립, 운영하고 있습니다</span><span class="s1" style="font-size: 10pt;">.</span></p>
		<p class="p4"><br></p>
		<p class="p1" style="line-height: 1.5;"><b><span style="font-size: 10pt;">7. 개인정보 보호책임자 작성</span><span class="Apple-converted-space" style="font-size: 10pt;">&nbsp;</span></b></p>
		<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">① 회사는 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다</span><span class="s1" style="font-size: 10pt;">.<br>
		</span></p>
		<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">▶ 개인정보 보호책임자 </span><br><span style="font-size: 10pt;">
		성명 : 이완세</span><span class="s1"><br>
		</span><span style="font-size: 10pt;">직급 : 이사</span><span class="s1"><br>
		</span><span style="font-size: 10pt;">연락처 : 02-801-1061, wanse@cwit.co.kr</span><span class="s1"><br>
		<br>
		</span><span style="font-size: 10pt;">▶ 개인정보 보호 담당부서</span><span class="s1"><br>
		</span><span style="font-size: 10pt;">부서명 : 헬스케어BU</span><span class="s1"><br>
		</span><span style="font-size: 10pt;">담당자 : 곽영건 부장</span><span class="s1"><br>
		</span><span style="font-size: 10pt;">연락처 : 02-801-1057, younggun.kwak@cwit.co.kr</span></p>
		<p class="p4"><br></p>
		<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">② 이용고객은 회사의 서비스(또는 사업)을 이용하시면서 발생한 모든 개인정보 보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의하실 수 있습니다. 회사는 정보주체의 문의에 대해 지체 없이 답변 및 처리해드릴 것입니다</span><span class="s1" style="font-size: 10pt;">.</span></p>
		<p class="p4"><br></p>
		<p class="p1" style="line-height: 1.5;"><b><span style="font-size: 10pt;">8. 개인정보 처리방침 변경</span><span class="Apple-converted-space" style="font-size: 10pt;">&nbsp;</span></b></p>
		<p class="p3" style="line-height: 1.5;"><span style="font-size: 10pt;">① 개인정보처리방침은 서비스 시행일로부터 적용되며, 법령 및 방침에 따른 변경내용의 추가, 삭제 및 정정이 있는 경우에는 변경사항의 시행 7일 전부터 공지사항을 통하여 고지할 것입니다</span><span class="s1" style="font-size: 10pt;">.</span></p>
		<p class="p2"><br></p>
		<p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">※ 이용고객께서는 개인정보 수집</span><span class="s2" style="font-size: 10pt;">?</span><span style="font-size: 10pt;">이용에 대한 동의를 거부하실 수 있으나, 이상의 정보는 서비스 제공에 필수적으로 필요한 정보이므로, 동의를 거부하실 경우 회원가입, 서비스 이용 등을 하실 수 없습니다</span><span class="s1" style="font-size: 10pt;">.</span></p>
		<p class="p1" style="line-height: 1.5;"><span style="font-size: 10pt;">※ 회원가입 후 서비스 이용과정에서 필요에 따라 요청되는 정보는 서비스 이용과정에서 별도로 안내하고 동의 받도록 하겠습니다</span><span class="s1" style="font-size: 10pt;">.</span></p>
	</div>
	<!--// 개인정보 수집 및 제공 동의 -->

	<!-- 이용약관 -->
	<div class="tit_sWrap">
		<h3 class="tit_bold_gray mgt30">이용약관</h3>
	</div>
	<p class="txt_join mgb20">아래의 중외정보기술 고객의 “서비스 이용약관"를 읽어보신 후 동의하여
		주시기 바랍니다.</p>
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
		<input type="checkbox" id="agree_terms1" /> <label for="agree_terms1">위와
			같은 개인정보 수집 이용에 동의하십니까? 동의하는 경우에는 왼쪽 박스에 체크해 주십시오. </label> <br /> <input
			type="checkbox" id="agree_terms2" /> <label for="agree_terms2">위와
			같은 서비스 이용약관에 동의하십니까? 동의하는 경우에는 왼쪽 박스에 체크해 주십시오. </label>
	</div>
	<!--// 이용약관 -->

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