
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style>
.banner .bx-controls-direction a{
	margin-top: 0;
    left: 50%;
    margin-left: -10px;
    -webkit-transform: rotate(90deg);
    position: absolute;
    outline: 0;
    width: 20px;
    height: 20px;
    text-indent: -9999px;
    z-index: 9999;
}
.disabled{
color : #a8afb2;
bakground-color:#ebebeb;

}

</style>
	

<script type="text/javascript">
	var fileCnt = 1 ; 
	
	$(document).ready(function(){
		
	
		/**	selectBox 초기화	*/
		$('#system_type').append(commonCode.defaultViewOption);	/* 시스템유형 */
		$('#inquiry_type').append(commonCode.defaultViewOption);	/* 상세유형 */
		$("#inquiry_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker); /* 처리요청일자 */
		
		var plus3days = new Date();
		plus3days.setDate(plus3days.getDate() + 3); // 현재 날짜에서 3일 더함
		
		$("#proc_dt").val(
				  $.datepicker.formatDate('yy/mm/dd', plus3days)
				).datepicker(datepicker);
		
		commonCode.getCodeList('AS' , 'CD04' , 'inportance') ; 		/**	중요도			*/
		commonCode.getCodeList('AS' , 'CD03' , 'request_type') ; 	/**	문의유형		*/
		
		$('#inportance').val('C002');
		
		addMultiFile() ; 
		getTelList() ; 
		
		var datas = {"cust_seq" : '${ frUserInfo.cust_seq}',  'is_page_gbn' : 'fr' , 'pageType' : 'insert'};
		common.ajaxCall(datas , '/fr/cust/getSystemInfo.do', 'makeSystemType') ;
			
	}) ;
	
	function getApplySmsTel(){
		$('#apply_sms_tel1').val('');
		$('#apply_sms_tel2').val('');
		$('#apply_sms_tel3').val('');
		
		$('#apply_sms_tel1').val(common.spritStr($('#v_apply_sms_tel').val() , 1, '-')) ;
		$('#apply_sms_tel2').val(common.spritStr($('#v_apply_sms_tel').val() , 2, '-')) ;
		$('#apply_sms_tel3').val(common.spritStr($('#v_apply_sms_tel').val() , 3, '-')) ;
	}
	
	function getApplyEmail(){
		$('#apply_email1').val('');
		$('#apply_email2').val('');
		
		$('#apply_email1').val(common.spritStr($('#v_apply_email').val() , 1, '@')) ;
		$('#apply_email2').val(common.spritStr($('#v_apply_email').val() , 2, '@')) ;
	}
	
	function makeSystemType(data){
		commonCode.returnOperCodeList(data,'system_type');
	}
	
	
	/* 상세유형 */
	function getTaskType(system_code){
		
		$('#inquiry_type').empty() ; 
		var oper_seq = $('#system_type option:selected').attr('oper_seq');
		
		$('#oper_seq').val(oper_seq);
		var datas = {"oper_seq" : oper_seq , "system_code" : system_code.split('@')[0], "pageType" : "insert" };
		common.ajaxCall(datas , '/fr/operate/getOperTask.do' , 'setTaskType') ;
	}
	
	function setTaskType(data){
		commonCode.returnTaskCodeList(data,'inquiry_type');
		if(data.length == 0)$('#inquiry_type').append(commonCode.defaultViewOption);
	}
	
	
	function getAssign(data){
		if(data == null || data == '') return;
		$('#assign_id').empty() ; 
		var assign_id = $('#inquiry_type option:selected').attr('emp_no');
		$('#assign_id').val(assign_id) ; 
	}
	
	
	function addMultiFile(){
		var str = '' ; 
		if(fileCnt == '1'){
			
		}else{}
		
		str += '<div id="multiFile'+fileCnt+'" class="mgb5">' ; 
		str += '		<input type="file" id="uploadFile_'+fileCnt+'" name="uploadFile_'+fileCnt+'">' ; 
		
		if(fileCnt > 1) 	str += '	<button class="btn_minus mgl5" onclick="deleteFile('+fileCnt+');"></button>';
		else 						str += '	<button class="btn_plus mgl5" onclick="addMultiFile();"></button>';
		
		str += '</div>' ; 
		
		$('#fileList').append(str) ; 
		fileCnt++ ; 
	}
	
	function deleteFile(cnt){
		$('#multiFile'+cnt).remove();
	}
	
	function goList(){
		location.href = "/fr/as/list.do" ; 
	}
	
	function goClear(){
		
		document.procFrm.reset() ;
		
		fileCnt = 1 ; 
		$('#fileList').empty() ; 
		addMultiFile() ; 
		getTelList();
	}
	
	function goSave(){
		
		var f = document.procFrm ; 
		
		if(common.isEmpty($('#system_type').val())){
			alert("시스템 유형을 선택해 주세요.") ;		
			$('#system_type').focus();
			return ; 
		}
		
		if(common.isEmpty($('#inquiry_type').val())){
			alert("상세 유형을 선택해 주세요.") ;		
			$('#inquiry_type').focus();
			return ; 
		}
		
		if(common.isEmpty($('#request_type').val())){
			alert("문의 유형을 선택해 주세요.") ;		
			$('#request_type').focus();
			return ; 
		}
		
		if(typeof $("input:radio[name=phone]:checked").val() != "undefined"){
			
			var hp_no = "" ;
			var phone_gbn = $("input:radio[name=phone]:checked").val() ;
			for(var i = 1; i <=3 ; i++){
				if(common.isNotEmpty($('#phone'+phone_gbn+'_' + i).val())){
					
					if(hp_no == "") hp_no = $('#phone'+phone_gbn+'_' + i).val() ; 
					else hp_no = hp_no + "-" + $('#phone'+phone_gbn+'_' + i).val() ;
					
				}else{
					alert("연락처를 입력해 주세요.") ;		
					$('#phone3_1').focus();
					return ; 
				}
			}
			
			$('#apply_tel').val(hp_no) ; 
		}else{
			alert("연락받으실 전화번호를 선택해 주세요.") ;		
			$('#phone1').focus();
			return ;
		}
		
		if($("#send_email").is(":checked")) f.send_email.value = "Y";
		if($("#send_sms").is(":checked")) f.send_sms.value = "Y";
		
		
		if(f.send_sms.value == "Y"){
			if(common.isEmpty($('#apply_sms_tel1').val()) || common.isEmpty($('#apply_sms_tel2').val()) || common.isEmpty($('#apply_sms_tel3').val())){
				alert("SMS 받으실 전화번호를 입력해 주세요.") ;		
				$('#apply_sms_tel1').focus();
				return ; 
			}else{
				$('#apply_sms_tel').val($('#apply_sms_tel1').val() + "-" + $('#apply_sms_tel2').val() + "-" + $('#apply_sms_tel3').val()) ; 
			}
		}
		
		if(f.send_email.value == "Y"){
			if(common.isEmpty($('#apply_email1').val()) || common.isEmpty($('#apply_email2').val())){
				alert("연락받으실 이메일 주소를 입력해 주세요.") ;
				$('#apply_email1').focus();
				return ; 
			}else{
				$("#apply_email").val( $('#apply_email1').val()+ "@" + $('#apply_email2').val()); 
			}
		}
		
		if( !$("#send_email").is(":checked") && ($('#request_type').val() == "C001" || $('#request_type').val() == 'C017') ){
			alert("문의유형이 '프로그램 신규 개발' 또는 '프로그램 개선'인 A/S건은 \nEmail수신이 필수 입니다.");
			$('#send_email').prop("checked",true);
			validateEmailform();
			$('#apply_email1').focus();
			return ; 
		}
		
		if(common.isEmpty($('#call_content').val())){
			alert("요청 내용을 입력해 주세요.") ;		
			$('#call_content').focus();
			return ; 
		}
		
		
	
		if(confirm("A/S를 등록하시겠습니까?")){
			
			f.target = "hiddenFrame" ; 
			f.action = "/fr/as/proc.do" ; 
			f.submit();
		}
	}
	
	function procReturn(flag , msg){
		alert(msg) ;
		if(flag == "success") goList() ; 
	}
	
	
	
	function getTelList(){
		common.ajaxCall({} , '/fr/as/getEmpTelList.do', 'makeTelList') ;
	}
	
	function makeTelList(data){
		var asDamTel = typeof  data.asDamTel != "undefined" ? data.asDamTel : null ; 
		var asMyTel = typeof  data.asMyTel != "undefined" ? data.asMyTel : "" ; 
		var asMyCpTel = typeof  data.asMyCpTel != "undefined" ? data.asMyCpTel : "" ; 
		var asMyEmail = typeof  data.asMyEmail != "undefined" ? data.asMyEmail : "" ;
		if(asDamTel != null){
			if(common.nvl(asDamTel.tel_no, '') != ''){
				$('#phone2_1').val(common.spritStr(asDamTel.tel_no , 1, '-')) ; 
				$('#phone2_2').val(common.spritStr(asDamTel.tel_no , 2, '-')) ; 
				$('#phone2_3').val(common.spritStr(asDamTel.tel_no , 3, '-')) ; 
			}
		}
		
		if(common.nvl(asMyCpTel, '') != ''){
			$('#phone1_1').val(common.spritStr(asMyCpTel , 1, '-')) ; 
			$('#phone1_2').val(common.spritStr(asMyCpTel , 2, '-')) ; 
			$('#phone1_3').val(common.spritStr(asMyCpTel , 3, '-')) ; 
		}
		
		if(common.nvl(asMyTel, '') != ''){
			$('#phone3_1').val(common.spritStr(asMyTel , 1, '-')) ; 
			$('#phone3_2').val(common.spritStr(asMyTel , 2, '-')) ; 
			$('#phone3_3').val(common.spritStr(asMyTel , 3, '-')) ; 
			
			$('#apply_sms_tel1').val(common.spritStr(asMyTel , 1, '-')) ; 
			$('#apply_sms_tel2').val(common.spritStr(asMyTel , 2, '-')) ; 
			$('#apply_sms_tel3').val(common.spritStr(asMyTel , 3, '-')) ; 
			
			
			$('#v_apply_sms_tel').val(common.nvl(asMyTel ,'')) ;
		}
		
		if(common.nvl(asMyEmail, '') != ''){
			$('#apply_email1').val(common.spritStr(asMyEmail , 1, '@')) ;
			$('#apply_email2').val(common.spritStr(asMyEmail , 2, '@')) ;
			$('#v_apply_email').val(common.nvl(asMyEmail ,'')) ;
		}
	}
	
	function validateEmailform(){
		if($("#send_email").is(":checked")){
			$('#apply_email1').removeAttr('readonly');
			$('#apply_email2').removeAttr('readonly');
			$("#th_apply_email").append('<span class="request mgl5">필수 입력</span>');
			$("#btn_apply_email").prop("disabled", false);
			$("#btn_apply_email").removeClass("disabled");
			
			$("#send_email").val("Y");
			
		}else{
			$('#apply_email1').val('');
			$('#apply_email1').attr('readonly','readonly');
			$('#apply_email2').val('');
			$('#apply_email2').attr('readonly','readonly');
			$('#th_apply_email').children().remove();
			$("#btn_apply_email").prop("disabled", true);
			$("#btn_apply_email").addClass("disabled");
			
			
			$("#send_email").val("");
		};
		
	};
	
	function validateSmsform(){
		if($("#send_sms").is(":checked")){
			$('#apply_sms_tel1').removeAttr('readonly');
			$('#apply_sms_tel2').removeAttr('readonly');
			$('#apply_sms_tel3').removeAttr('readonly');
			$("#th_apply_sms").append('<span class="request mgl5">필수 입력</span>');
			
			$("#btn_apply_sms").prop("disabled", false);
			$("#btn_apply_sms").removeClass("disabled");
			
			$("#send_sms").val("Y");
			
		}else{
			$('#apply_sms_tel1').val('');
			$('#apply_sms_tel1').attr('readonly','readonly');
			$('#apply_sms_tel2').val('');
			$('#apply_sms_tel2').attr('readonly','readonly');
			$('#apply_sms_tel3').val('');
			$('#apply_sms_tel3').attr('readonly','readonly');
			$('#th_apply_sms').children().remove();
			
			$("#btn_apply_sms").prop("disabled", true);
			$("#btn_apply_sms").addClass("disabled");
			
			$("#send_sms").val("");
		};
		
	};

	function fnChkByte(obj, maxByte)
	{
		var str = obj.value;
	    var str_len = str.length;
	    var rbyte = 0;
	    var rlen = 0;
	    var one_char = "";
	    var str2 = "";

	    for(var i=0; i<str_len; i++)
	    {
	        one_char = str.charAt(i);
	        if(escape(one_char).length > 4) {
	            rbyte += 3;                                         //한글3Byte
	        }else{
	            rbyte++;                                            //영문 등 나머지 1Byte
	        }
	        if(rbyte <= maxByte){
	            rlen = i+1;                                          //return할 문자열 갯수
	        }
	     }
	     if(rbyte > maxByte)
	     {
	        alert("메세지는 최대 " + maxByte + " byte를 초과할 수 없습니다.")
	        str2 = str.substr(0,rlen);                                  //문자열 자르기
	        obj.value = str2;
	        fnChkByte(obj, maxByte);
	     }
	     else
	     {
	    	$('#call_content_text').html(rbyte + '/ 3500 byte');
	     }
	};
	
	function chRequestType(val){
		if(val == "C001" || val == "C017"){
			$("#email_yn_th").children().remove();
			$("#email_yn_th").append('<span class="request mgl5">필수 입력</span>');
			
			if(!$("#send_email").is(":checked")){
				$('#send_email').prop("checked",true);
				validateEmailform();
			}
		}else{
			$("#email_yn_th").children().remove();
		}
	};
	
	
</script>
<div id="jw_contents">
	<div class="tit_wrap">
		<h2 class="tit_ico_admin">A/S 신청</h2>
		<div class="location">
			<a href="/fr/main/list.do" class="home">Home</a>
			<a href="/fr/as/form.do" class="depth"><span class="here">A/S 신청</span></a>
		</div>
	</div>
	
	
	<ul class="tab_back mgb30">
		<li class="active"><a href="/fr/as/form.do">A/S 신청등록</a></li><!-- 활성시 current -->
		<li><a href="/fr/as/list.do">신청 등록 현황</a></li>
	</ul>
	
	<form name="procFrm" id="procFrm" method="post" enctype="multipart/form-data" onsubmit="return false;">
		<input type="hidden" name="apply_tel" id="apply_tel" value=""/>	<!-- 등록자 연락처 -->
		<input type="hidden" name="assign_id" id="assign_id" value=""/>	<!-- 처리담당자 -->
		<input type="hidden" name="oper_seq" id="oper_seq" value=""/>	<!-- 운영정보 -->
		<input type="hidden" name="proc_dt" id="proc_dt" value=""/>		<!-- 처리예정일 -->
		<input type="hidden" name="v_apply_sms_tel" id="v_apply_sms_tel" value=""/>	
		<input type="hidden" name="v_apply_email" id="v_apply_email" value=""/>	
		<input type="hidden" name="apply_sms_tel" id="apply_sms_tel" value=""/>	
		<input type="hidden" name="apply_email" id="apply_email" value=""/>	
		<input type="hidden" name="cust_seq" id="cust_seq" value="${frUserInfo.cust_seq}"/>	<!-- 거래처seq -->
	
		<div class="tit_sWrap">
			<h3 class="tit_bold_gray">문의 서비스 정보</h3>
		</div>
	
		<table class="sType mgb30">
			<caption>A/S 신청 제품 정보 입력</caption>
			<colgroup>
				<col style="width:180px;" />
				<col style="width:317px;" />
				<col style="width:180px;" />
				<col style="width:323px;" />
			</colgroup>
			<tr>
				<th scope="row">시스템유형<span class="request">필수 입력</span></th>
				<td>
					<select class="w277" title="제품카테고리 선택" name="system_type" id="system_type" onchange="javascript:getTaskType(this.value);"></select>
				</td>
				<th scope="row">상세 유형<span class="request">필수 입력</span></th>
				<td colspan="3">
					<select class="w277" title="업무 선택" id="inquiry_type" name="inquiry_type" onchange="javascript:getAssign(this.value);"></select>
				</td>
			</tr>
			<tr>
				<th scope="row">문의유형<span class="request">필수 입력</span></th>
				<td colspan="3">
					<select class="w277" title="문의유형 선택" name="request_type" id="request_type" onchange="javascript:chRequestType(this.value);"></select>
				</td>
			</tr>
		</table>
	<!--// A/S 신청 제품 정보 -->

	<!-- 기본 정보 -->
	<div class="tit_sWrap">
		<h3 class="tit_bold_gray">기본 정보</h3>
	</div>
	<table class="sType mgb30">
		<caption>기본 정보 입력</caption>
		<colgroup>
			<col style="width:180px;" />
				<col style="width:317px;" />
				<col style="width:180px;" />
				<col style="width:323px;" />
		</colgroup>
		<tr>
			<th scope="row">연락받으실 전화번호<span class="request">필수 입력</span></th>
			<td colspan="3">
				<dl class="box_phone_num">
					<dt><input type="radio" name="phone" id="phone1" class="mgr10" value="1"/><label for="phone1">본인 연락처</label></dt>
					<dd>
						<input type="text" id="phone1_1" readonly="readonly" class="w60" title="본인 연락처1" /><span class="txt_dash">-</span>
						<input type="text" class="w60" id="phone1_2" readonly="readonly" title="본인 연락처2" /><span class="txt_dash">-</span>
						<input type="text" class="w60" id="phone1_3" readonly="readonly" title="본인 연락처3" />
					</dd>
					<dt class="w142"><input type="radio" name="phone" id="phone2" class="mgr10" value="2"/><label for="phone1">대표 담당자 연락처</label></dt>
					<dd>
						<input type="text" id="phone2_1" readonly="readonly" class="w60" title="대표 담당자 연락처1" /><span class="txt_dash">-</span>
						<input type="text" class="w60" id="phone2_2" readonly="readonly" title="대표 담당자 연락처2" /><span class="txt_dash">-</span>
						<input type="text" class="w60" id="phone2_3" readonly="readonly" title="대표 담당자 연락처3" />
					</dd>
					<dt class="mgt8"><input type="radio" name="phone" id="phone3" class="mgr10" value="3" /><label for="phone3">핸드폰(직접입력)</label></dt>
					<dd class="mgt8">
						<input type="text" id="phone3_1" class="w60" title="직접입력1" /><span class="txt_dash">-</span>
						<input type="text" class="w60" id="phone3_2" title="직접입력2" /><span class="txt_dash">-</span>
						<input type="text" class="w60" id="phone3_3" title="직접입력3" />
					</dd>
				</dl>
			</td>
		</tr>
		<tr>
			<th scope="row">SMS 수신여부</th>
			<td>
				<input type="checkbox" name="send_sms" id="send_sms" checked="checked" onchange="validateSmsform();"><label for="send_sms">SMS 수신</label>
			</td>
			<th scope="row" id="th_apply_sms">SMS 수신 전화번호<span class="request">필수입력</span></th>
			<td>
				<input type="text" id="apply_sms_tel1" class="w50" title="직접입력1" /><span class="txt_dash" style="width:10px">-</span>
				<input type="text" class="w50" id="apply_sms_tel2" title="직접입력2" /><span class="txt_dash" style="width:10px">-</span>
				<input type="text" class="w50" id="apply_sms_tel3" title="직접입력3" />
				
				<button class="btn_line_blue w80 mgl5" id="btn_apply_sms" onclick="javascript:getApplySmsTel();" >나의 전화번호</button>
			</td>
		</tr>
		<tr>
			<th scope="row" id="email_yn_th" >Email 수신여부</th>
			<td>
				<input type="checkbox" name="send_email" id="send_email" checked="checked" onchange="validateEmailform();"><label for="send_email" >Email 수신</label>
			</td>
			<th scope="row" id="th_apply_email">수신 이메일주소<span class="request">필수입력</span></th>
			<td>
				<input type="text" id="apply_email1"   class="w80 mgr5" title="이메일 주소" />@
				<input type="text" id="apply_email2"   class="w80 mgl5" title="이메일 주소" />
				<button class="btn_line_blue mgl5 w80"  id="btn_apply_email" onclick="javascript:getApplyEmail();">나의 이메일</button>	
			</td>
		</tr>
		<tr>
			<th scope="row">처리 요청 일자</th>
			<td>
				<input class="w245" type="text" name="inquiry_dt" id="inquiry_dt" />
			</td>
			<th scope="row">업무 중요도</th>
			<td>
				<select class="w245" name="inportance" id="inportance" ></select>
			</td>
		</tr>
		<tr>
			<th scope="row">요청 내용<span class="request">필수 입력</span></th>
			<td colspan="3">
				<textarea name="call_content" id="call_content" style="height:150px !important;" onKeyUp="javascript:fnChkByte(this,'3500')"></textarea>
				<div class="txt_byte" id="call_content_text">0 / 3500 byte</div>
			</td>
		</tr>
		<tr>
			<th scope="row">파일첨부</th>
			<td id="fileList"colspan="3"></td>
		</tr>
	</table>
	<!--// 기본 정보 -->

	<!--// write -->
	<div class="btn_wrap">
		<div class="floatL">
			<button type="button" class="btn_ico_reset" onclick="javascript:goClear();"><span>초기화</span></button>		
		</div>
		<div class="floatR">
			<button type="button" class="btn_ico_regist" onclick="javascript:goSave();"><span>등록</span></button>
			<button type="button" class="btn_ico_cancel" onclick="javascript:goList();"><span>취소</span></button>
		</div>
	</div>
	
	
	
	
	</form>
</div>