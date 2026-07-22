<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">

function makeLogin(data){
	var returnFlag = typeof data.returnFlag != 'undefined' ? data.returnFlag : '009' ;
	var msg = "" ; 
	
	if(returnFlag == "000") msg = "로그인 되었습니다." ; 
	else if(returnFlag == "001") msg = "아이디 혹은 비밀번호를 확인해 주세요." ; 
	else if(returnFlag == "002") msg = "사용할수 없는 아이디 입니다." ; 
	else if(returnFlag == "009") msg = "비정상적으로 종료 되었습니다." ; 
	
	alert(msg) ;
	if(returnFlag == "000") {
		chkIdSave($('#emp_id'), 'fr');
		location.href = "/mb/as/main.do" ; 
	}
}

function loginProc(){
	var datas = {
			emp_id 			: $('#emp_id').val() ,
			pass 				: $('#pass').val() 
	};
	
	
	common.ajaxCall(datas, '/fr/login/proc.do' , 'makeLogin') ; 
}

$(document).ready(function(){
	showSaveId($('#emp_id'), 'fr');
	$("#pass").keyup(function(e){if(e.keyCode == 13)  loginProc(); });
});

</script>

<div class="contents">
    <div class="container">
        <section class="text-center login-info">
            <img src="/images/mobile/logo.png" alt="" class="login-logo">
            <h4>중외정보기술 고객지원 서비스에<br>오신 것을 환영합니다</h4>
        </section>
        <section>
            <form action="">
                <fieldset>
                    <div class="form-group">
                        <input type="text" class="form-control" placeholder="아이디" id="emp_id">
                    </div>
                    <div class="form-group">
                        <input type="password" class="form-control" placeholder="비밀번호" id="pass">
                    </div>
                    <div class="form-group">
                        <div class="row">
                            <div class="col-xs-6">
                                <label class="custom-checkbox" id="save_id"><input type="checkbox"  id="chkIdSave" class="check-all"><span>아이디 저장</span></label>
                            </div>
                        </div>
                    </div>
                </fieldset>
                <fieldset>    
                    <div class="form-group">
                        <a href="javascript:loginProc();" class="btn btn-primary btn-lg btn-block">로그인</a>
                    </div>
                </fieldset>
            </form>
        </section>
    </div>
</div>