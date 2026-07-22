<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>


<style>
  .download-link {
    cursor: pointer;
  }
</style>

<script type="text/javascript">

function makeLogin(data){
	var returnFlag = typeof data.returnFlag != 'undefined' ? data.returnFlag : '009' ;
	var msg = "" ; 
	
	if(returnFlag == "000") msg = "로그인 되었습니다." ; 
	else if(returnFlag == "001") msg = "아이디 및 비밀번호를 다시 한번 확인해주시기 바랍니다." ; 
	else if(returnFlag == "002") msg = "사용할수 없는 아이디 입니다.\r\n자세한 내용은 1588-0047로 문의 바랍니다." ;
	else if(returnFlag == "003") msg = "아이디 및 비밀번호를 다시 한번 확인해주시기 바랍니다." ; 
	else if(returnFlag == "009") msg = "비정상적으로 종료 되었습니다." ; 
	else if(returnFlag == "006") msg = "환영합니다! 고객님^^ \r\nONTIC LineUs의 서비스를 정상적으로 이용하시기 위해서는 최초 1번의 서비스이용약관 및 개인정보처리방침에 대한 동의절차가 필요합니다.\r\n확인을 클릭하시면 약관동의 페이지로 이동합니다." ;
	else if(returnFlag == "004")  msg = "본 계정은 아직 승인 대기 중입니다.\r\n승인완료 후 사용가능합니다.\r\n자세한 내용은 1588-0047로 문의 바랍니다.";
	else if(returnFlag == "007")  msg = "거래 상태가 해지,중지,폐업 중 입니다.\r\n자세한 내용은 1588-0047로 문의 바랍니다.";
	alert(msg);
	
	if(returnFlag == "000") {
		chkIdSave($('#emp_id'), 'fr');
		//location.href = "https://tattered-driver-2aa.notion.site/eb9bfe6ebcb24156a4a44e96f1340afa?v=871f3828f23e4a74b175097e2aeaafb1" ; ---2024.03.08 다빈도Q&A 테스트 관련 일시적 변경
		location.href = "/fr/main/list.do" ;
	}else if(returnFlag == "006") {
		location.href = "/fr/agreement/form.do" ;
	}
}

function loginProc(){
	var datas = {
			emp_id 			: $('#emp_id').val() ,
			pass 				: $('#pass').val() 
	};
	
	
	common.ajaxCall(datas, '/fr/login/proc.do' , 'makeLogin') ; 
}

function fileDown(attach_seq, attach_ord){

    if(!confirm("원격연결 프로그램을 다운로드하시겠습니까?")){
        return;
    }

    try{
        $("#fileFrm").remove();
        $("#downFrame").remove();
    }catch(e){}

    var downFrame = $('<iframe id="downFrame" name="downFrame" style="width:0px; height=0px; display:none;"></iframe>');
    downFrame.appendTo("body");

    var f = $("<form></form>");
    f.attr('id', 'fileFrm');
    f.attr('action', '/comm/fileDown.do');
    f.attr('method', 'post');
    f.attr('target', 'downFrame');
    f.appendTo("body");

    var attach_seq_input = "<input type='hidden' name='attach_seq' value='"+attach_seq+"'/>"; 
    var attach_ord_input = "<input type='hidden' name='attach_ord' value='"+attach_ord+"'/>"; 

    f.append(attach_seq_input).append(attach_ord_input);
    f.submit();
}

function judHostname(){
	var hostname = window.location.hostname;
	
	if(hostname == 'localhost' || hostname == '192.168.16.110' || hostname == '192.168.20.46'){
		console.log(window.location.hostname);
		var a = '<h3 style="font-size:20px;" class="colorRed">*개발용 서버 (테스트)</h3>';
		$('#appendText').append(a);
	}else{
		return;
	}
} 

$(document).ready(function(){
	showSaveId($('#emp_id'), 'fr');
	$("#pass").keyup(function(e){if(e.keyCode == 13)  loginProc(); });
	judHostname();
});

</script>
<body class="jw_login">
	<div class="login_outer">
		<div class="login_inner">
			<div class="inner_upper">
				<img src="/images/front/txt_login_01.png" alt="중외정보기술 ONTIC LineUS" class="mgb15" />
				<img src="/images/front/txt_login_02.png" alt="중외정보기술 ONTIC LineUS에 오신 것을 환영합니다." />
				<span id="appendText"></span>
				<input type="text" placeholder="사용자 아이디를 입력하세요." class="input_id" id="emp_id" title="아이디 입력"  />
				<input type="password" placeholder="비밀 번호를 입력하세요." class="input_pw" id="pass" title="패스워드 입력"  />
				<input type="checkbox" id="chkIdSave" class="save_id" /><label for="save_id">아이디 저장</label>
				<button type="button" class="btn_login" onclick="javascript:loginProc();">로그인</button>
			</div>
			<div class="inner_lower"
			     style="
			       white-space: nowrap !important;
			       height: auto !important;
			       padding: 10px 50px 10px !important;
			       line-height: 20px !important;
			     ">
			  <a href="/fr/join/form.do"
			     style="display: inline-block !important; margin-right: 40px !important;">
			     회원가입
			  </a>
			
			  <a href="/fr/login/find.do"
			     style="display: inline-block !important; margin-right: 40px !important;">
			     아이디/비밀번호 찾기
			  </a>
			
			  <a class="download-link" onclick="fileDown('122649','1');"
			     style="display: inline-block !important;">
			     원격연결 프로그램 설치
			  </a>
			</div>
			<img src="/images/front/logo_jw_gray.png" alt="중외정보기술 ONTIC LineUS" class="logo_footer" />
			<div class="address_footer">
				주소. 경기 과천시 과천대로7나길 60 C - 303(과천어반허브) (주)중외정보기술<br />
				Tel. 1588-0047 Fax. 02-801-1099
				<span class="copy_footer">COPYRIGHT© 중외정보기술 All Rights Reserved.</span>
			</div>
		</div>
	</div>
</body>