<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="egovframework.com.comm.util.CommonExecute"%>

<script type="text/javascript">
	
	var mt_cnt = 0; 		//서버유지보수업체 addcnt
	var vc_cnt = 0; 		//백신 addcnt
	var bd_cnt = 0; 		//건물구조 addcnt
	var cg_cnt = 0; 		//담당자정보 addcnt
	var paramString = "" ; 
	var OLD_TREAT_NO = ""; //요양관리번호
	var CHK_FLAG = false; //요양관리번호
	var TREATNO_CHK = false;
	
	$(document).ready(function(){
		$( "#open_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#term_start_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#term_end_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#test_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#mtac_contract_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#buss_open_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#approval_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		/**	select box 정보 처리	*/
		commonCode.getCodeList('CUST' , 'CD13' , 'package_code') ; 			/**	si/Package		*/
		commonCode.getCodeList('CUST' , 'CD12' , 'mtac_month') ; 				/**	무상유지보수		*/
		commonCode.getCodeList('CUST' , 'CD14' , 'version') ; 						/**	OCS/EMR ver	*/
		commonCode.getCodeList('CUST' , 'CD15' , 'formation_code') ; 			/**	서버구성			*/
		commonCode.getCodeList('CUST' , 'CD16' , 'server_code') ; 				/**	제조사1			*/
		//commonCode.getCodeList('CUST' , 'CD17' , 'model_code') ; 				/**	제조사2			*/
		$('#model_code').append(commonCode.defaultViewOption);
		commonCode.getCodeList('CUST' , 'CD18' , 'os') ; 							/**	OS				*/
		commonCode.getCodeList('CUST' , 'CD19' , 'ram') ; 							/**	RAM				*/
		commonCode.getCodeList('CUST' , 'CD20' , 'sid') ; 							/**	서비스네임		*/
		commonCode.getCodeList('CUST' , 'CD21' , 'oracle_version') ; 			/**	오라클 버전		*/
		commonCode.getCodeList('CUST' , 'CD01' , 'cust_gubun') ; 				/**	병원종류			*/
		commonCode.getCodeList('CUST' , 'CD02' , 'specially_code') ; 			/**	전문병원여부		*/
		commonCode.getCodeList('CUST' , 'CD25' , 'new_code') ; 					/**	신규 기존 여부	*/
		commonCode.getCodeList('CUST' , 'CD26' , 'outside_cust_code') ; 		/**	외부수탁업체		*/
		
		initView();
	});
	
	function initView() {
		
		
		if (common.nvl('${vo.seq}','') == '') {
			alert('관리정보를 등록해 주세요.');
			location.href='/ad/cust/form.do';
			return;
		}
		
		var datas = {'seq' : $('#seq').val()} ; 
		common.ajaxCall(datas , '/ad/cust/getProjectCnt.do' , 'setProjectCnt') ; 
		
		var datas = {'seq' : $('#seq').val()} ; 
		common.ajaxCall(datas , '/ad/cust/getProjectInfo.do' , 'setProjectInfo') ; 
	}
	
	var projectCnt = 0 ;
	
	function setProjectCnt(data) {
		projectCnt = typeof data.cnt !='undefined' ? data.cnt : 0 ;
	}
	
	function setProjectInfo(data) {
		
		var info = typeof data.info !='undefined' ? data.info[0] : null ; //기본정보
		var mtac = typeof data.mtac !='undefined' ? data.mtac : null ; //서버유지보수업체
		var vc = typeof data.vc !='undefined' ? data.vc : null ; //백신
		var bd = typeof data.bd !='undefined' ? data.bd : null ; //건물구조
		var charge = typeof data.charge !='undefined' ? data.charge : null ; //담당자정보
		
		if (mtac.length == 0) addMtacCustCode();
		if (vc.length == 0) addVcCode();
		if (bd.length == 0) addBdCode();
		if (charge.length == 0) addCharge();
		
		if (info != null) {
			/* 프로젝트 정보 */
			$("#open_dt").val(common.nvl(info.open_dt,''));
			$("#package_code").val(common.nvl(info.package_code,''));
			$("#term_start_dt").val(common.nvl(info.term_start_dt,''));
			$("#term_end_dt").val(common.nvl(info.term_end_dt,''));
			$("#term_person_count").val(common.nvl(info.term_person_count,''));
			$("#mtac_month").val(common.nvl(info.mtac_month,''));
			$("#test_dt").val(common.nvl(info.test_dt,''));
			$("#pm").val(common.nvl(info.pm,''));
			$("#version").val(common.nvl(info.version,''));
			$("#approval_dt").val(common.nvl(info.approval_dt,''));
			
			/* 서버 정보 */
			$("#formation_code").val(common.nvl(info.formation_code,''));
			$("#server_code").val(common.nvl(info.server_code,''));
			
			if(common.nvl(info.server_code,'') != ""){
				changeServerCode(common.nvl(info.server_code,''));
				$("#model_code").val(common.nvl(info.model_code,''));
			}
			
			//$("#model_code").val(common.nvl(info.model_code,''));
			$("#os").val(common.nvl(info.os,''));
			$("#ram").val(common.nvl(info.ram,''));
			$("#sid").val(common.nvl(info.sid,''));
			$("#oracle_version").val(common.nvl(info.oracle_version,''));
			$("#server_ip").val(common.nvl(info.server_ip,''));
			$("#server_id").val(common.nvl(info.server_id,''));
			$("#server_pw").val(common.nvl(info.server_pw,''));
			$("#dur_ip").val(common.nvl(info.dur_ip,''));
			
			TREATNO_CHK = true;	
			OLD_TREAT_NO = common.nvl(info.treat_no,'');
			
			if (mtac != null && mtac.length > 0) {
				for (var i=0; i < mtac.length; i++) {
					var list = mtac[i];
					
					var str = '';
					str += '<select name="mtac_cust_code'+(i+1)+'" id="mtac_cust_code'+(i+1)+'"  title="서버유지보수업체 선택" class="w135 mgr5">';
					str += '</select>';
					$('#mt_wrap').append(str);
					
					commonCode.getCodeList('CUST' , 'CD22' , 'mtac_cust_code' +(i+1)) ; 	/**	서버 유지보수 업체		*/
					$('#mtac_cust_code'+(i+1)).val(list.mtac_cust_code);
				}
				mt_cnt = mtac.length;
			}
			
			if (vc != null && vc.length > 0) {
				for (var i=0; i < vc.length; i++) {
					var list = vc[i];
					
					var str = '';
					str += '<select name="vc_code'+(i+1)+'" id="vc_code'+(i+1)+'" title="백신 선택" class="w135 mgr5">';
					str += '</select>';
					$('#vc_wrap').append(str);
					
					commonCode.getCodeList('CUST' , 'CD23' , 'vc_code' +(i+1)) ; 	/**	백신		*/
					$('#vc_code'+(i+1)).val(list.vc_code);
				}
				vc_cnt = vc.length;		
			}
			
			$("#mtac_contract_dt").val(common.nvl(info.mtac_contract_dt,''));
			$("#pc").val(common.nvl(info.pc,''));
			
			/* 기본 정보 */
			$("#cust_kor_name").val(common.nvl(info.cust_kor_name,''));
			$("#crm_code").val(common.nvl(info.crm_code,''));
			$("#cust_gubun").val(common.nvl(info.cust_gubun,''));
			$("#ceo").val(common.nvl(info.ceo,''));
			$("#cust_no").val(common.nvl(info.cust_no,''));
			$("#law_no").val(common.nvl(info.law_no,''));
			$("#treat_no").val(common.nvl(info.treat_no,''));
			$("#accident_no").val(common.nvl(info.accident_no,''));
			$("#tel_no").val(common.nvl(info.tel_no,''));
			$("#fax_no").val(common.nvl(info.fax_no,''));
			$("#post_no").val(common.nvl(info.post_no,''));
			$("#buss_open_dt").val(common.nvl(info.buss_open_dt,''));
			$("#addr").val(common.nvl(info.addr,''));
			$("#email").val(common.nvl(info.email,''));
			$("#homepage").val(common.nvl(info.homepage,''));
			$("#buss_condition").val(common.nvl(info.buss_condition,''));
			$("#buss_item").val(common.nvl(info.buss_item,''));
			$("#basic_etc").val(common.nvl(info.basic_etc,''));
			
			/* 상세 정보 */
			if (bd != null && bd.length > 0) {
				for (var i=0; i < bd.length; i++) {
					var list = bd[i];
					
					var str = '';
					str += '<select name="bd_code'+(i+1)+'" id="bd_code'+(i+1)+'" title="건물구조 선택" class="w160 mgr5">';
					str += '<option value="">본관</option>';
					str += '</select>';
					str += '<input type="text" name="bd_etc'+(i+1)+'" id="bd_etc'+(i+1)+'" value="'+common.nvl(list.bd_etc,'')+'" title="건물구조 입력" class="w168 mgr5">';
					$('#bd_wrap').append(str);
					
					commonCode.getCodeList('CUST' , 'CD24' , 'bd_code' +(i+1)) ; 	/**	건물구조		*/
					$('#bd_code'+(i+1)).val(list.bd_code);
				}
				
				bd_cnt = bd.length;
			}
			
			$("#bed_count").val(common.nvl(info.bed_count,''));
			$("#medical_office").val(common.nvl(info.medical_office,''));
			$("#support_office").val(common.nvl(info.support_office,''));
			$("#medical_office2").val(common.nvl(info.medical_office2,''));
			$("#specially_code").val(common.nvl(info.specially_code,''));
			$("#doctor_count").val(common.nvl(info.doctor_count,''));
			$("#nurse_count").val(common.nvl(info.nurse_count,''));
			
			common.nvl(info.veterans_yn,'')!='' ? $("#veterans_yn").prop('checked',true) : '';
			common.nvl(info.military_yn,'')!='' ? $("#military_yn").prop('checked',true) : '';
			
			$("#new_code").val(common.nvl(info.new_code,''));
			$("#old_company_nm").val(common.nvl(info.old_company_nm,''));
			$("#come_count").val(common.nvl(info.come_count,''));
			$("#average_count").val(common.nvl(info.average_count,''));
			$("#outside_cust_code").val(common.nvl(info.outside_cust_code,''));
			
			common.nvl(info.military_yn,'')!='' ? $("#charge_yn").prop('checked',true) : '';
			
			$("#detail_etc").val(common.nvl(info.detail_etc,''));
			
			if (charge != null && charge.length > 0) {
				
				for (var i=0; i < charge.length; i++) {
					var list = charge[i];
					
					var str = '';
					str += '<tr id="tr'+(i+1)+'">';
					str += '<td><input type="checkbox" class="charge_check" id="check'+(i+1)+'" cnt="'+(i+1)+'"></td>';
					str += '<td>';
					str += '	<select name="charge_code'+(i+1)+'" id="charge_code'+(i+1)+'" title="담당 구분 선택">';
					str += '		<option value="">결제관련 결정</option>';
					str += '	</select>';
					str += '</td>';
					str += '<td><input type="text" name="charge_nm'+(i+1)+'" id="charge_nm'+(i+1)+'" value="'+common.nvl(list.charge_nm,'')+'" title="담당자명 입력" /></td>';
					str += '<td><input type="text" name="company_tel_no'+(i+1)+'" id="company_tel_no'+(i+1)+'" value="'+common.nvl(list.company_tel_no,'')+'" title="연락처1 입력" /></td>';
					str += '<td><input type="text" name="hp_no'+(i+1)+'" id="hp_no'+(i+1)+'" value="'+common.nvl(list.hp_no,'')+'" title="연락처2 입력" /></td>';
					str += '<td><input type="text" name="email'+(i+1)+'" id="email'+(i+1)+'" value="'+common.nvl(list.email,'')+'" title="이메일 입력" /></td>';
					str += '<td><input type="text" name="etc'+(i+1)+'" id="etc'+(i+1)+'" value="'+common.nvl(list.etc,'')+'" title="비고" /></td>';
					str += '</tr>';
					$('#cg_wrap').append(str);
					
					commonCode.getCodeList('CUST' , 'CD27' , 'charge_code' +(i+1)) ; 	/**	담당구분		*/
					$('#charge_code'+(i+1)).val(list.charge_code);
				}
				cg_cnt = charge.length;		
			}
			$('#p_lock').val(common.nvl(info.p_lock, ''));
			
			makeBtnGrade(common.nvl(info.p_lock, '')) 
		}
	}
	
	function makeBtnGrade(flag) {
		if (flag=='Y') {
			//$('#btnView1').hide();
			$('#btnView2').hide();
			$('#btnView3').hide();
			$('#btnView4').show();
		} else {
			$('#btnView1').show();
			$('#btnView2').show();
			$('#btnView3').show();	
			
			$('#btnView4').hide();
		}
	}
	
	function btnReportPrint() {
		//보고서 출력
		commonReport.getPopup();
		onPrint() ;
	}
	
	function onPrint() {
		var html = document.querySelector('html');
		var printContents = document.querySelector('#reportPopBox').innerHTML;
		var printDiv = document.createElement("div");
		printDiv.className = "print-div";
		 
		html.appendChild(printDiv);
		printDiv.innerHTML = printContents;
		document.body.style.display = 'none';
		window.print();
		document.body.style.display = 'block';
		printDiv.style.display = 'none';
	}
	
	function addMtacCustCode() {
		//서버 유지보수 업체 ADD
		var str = '';
		mt_cnt++;
		
		str += '<select name="mtac_cust_code'+mt_cnt+'" id="mtac_cust_code'+mt_cnt+'"  title="서버유지보수업체 선택" class="w135 mgr5">';
		str += '</select>';
		$('#mt_wrap').append(str);
		
		commonCode.getCodeList('CUST' , 'CD22' , 'mtac_cust_code' +mt_cnt) ; 	/**	서버 유지보수 업체		*/
	}
	
	function delMtacCustCode() {
		//서버 유지보수 업체 DEL
		if ($('#mt_wrap > select').length == 1) alert('하나 이하로는 삭제하실 수 없습니다.');
		else $('#mt_wrap > select').last().remove();	
	}
	
	function addVcCode() {
		// 백신 ADD
		var str = '';
		vc_cnt++;
		
		str += '<select name="vc_code'+vc_cnt+'" id="vc_code'+vc_cnt+'" title="백신 선택" class="w135 mgr5">';
		str += '</select>';
		$('#vc_wrap').append(str);
		
		commonCode.getCodeList('CUST' , 'CD23' , 'vc_code' +vc_cnt) ; 	/**	백신		*/
	}
	
	function delVcCode() {
		// 백신 DEL
		if ($('#vc_wrap > select').length == 1) alert('하나 이하로는 삭제하실 수 없습니다.');
		else $('#vc_wrap > select').last().remove();	
	}
	
	function addBdCode() {
		//건물구조 ADD
		var str = '';
		bd_cnt++;		
		
		str += '<select name="bd_code'+bd_cnt+'" id="bd_code'+bd_cnt+'" title="건물구조 선택" class="w160 mgr5">';
		str += '<option value="">본관</option>';
		str += '</select>';
		str += '<input type="text" name="bd_etc'+bd_cnt+'" id="bd_etc'+bd_cnt+'" title="건물구조 입력" class="w168 mgr5">';
		$('#bd_wrap').append(str);
		
		commonCode.getCodeList('CUST' , 'CD24' , 'bd_code' +bd_cnt) ; 	/**	건물구조		*/
	}
	
	function delBdCode() {
		//건물구조 Del
		if ($('#bd_wrap > select').length == 1) alert('하나 이하로는 삭제하실 수 없습니다.');
		else {
			$('#bd_wrap > select').last().remove();
			$('#bd_wrap > input').last().remove();
		}	
	}
	
	function addCharge() {
		var str = '';
		cg_cnt++;
		
		str += '<tr id="tr'+cg_cnt+'">';
		str += '<td><input type="checkbox"  class="charge_check" id="check'+cg_cnt+'" cnt="'+cg_cnt+'" ></td>';
		str += '<td>';
		str += '	<select name="charge_code'+cg_cnt+'" id="charge_code'+cg_cnt+'" title="담당 구분 선택">';
		str += '		<option value="">결제관련 결정</option>';
		str += '	</select>';
		str += '</td>';
		str += '<td><input type="text" name="charge_nm'+cg_cnt+'" id="charge_nm'+cg_cnt+'" title="담당자명 입력" /></td>';
		str += '<td><input type="text" name="company_tel_no'+cg_cnt+'" id="company_tel_no'+cg_cnt+'" title="연락처1 입력" /></td>';
		str += '<td><input type="text" name="hp_no'+cg_cnt+'" id="hp_no'+cg_cnt+'" title="연락처2 입력" /></td>';
		str += '<td><input type="text" name="email'+cg_cnt+'" id="email'+cg_cnt+'" title="이메일 입력" /></td>';
		str += '<td><input type="text" name="etc'+cg_cnt+'" id="etc'+cg_cnt+'" title="비고" /></td>';
		str += '</tr>';
		$('#cg_wrap').append(str);
		
		commonCode.getCodeList('CUST' , 'CD27' , 'charge_code' +cg_cnt) ; 	/**	담당구분		*/
	}
	
	function delCharge() {
		$('input:checkbox[class="charge_check"]').each(function() {
			if($(this).is(":checked")){//checked 처리된 항목의 값
				$('#tr'+$(this).attr('cnt')).remove();
			}
		});
			
	}
	
	function moveTab(gubun){
		if (projectCnt == 0 && gubun == '3') {
			alert('프로젝트 정보를 등록해 주세요.');
			return;
		}
		location.href = "/ad/cust/form" + gubun + ".do${ QUERYSTRING }" ;
	}
	
	
	function goProc(type){
		var f = document.procFrm;
		f.pageType.value = '${vo.pageType}';
		
		f.mt_cnt.value = mt_cnt ;
		f.vc_cnt.value = vc_cnt ;
		f.bd_cnt.value = bd_cnt ;
		f.cg_cnt.value = cg_cnt ;
		
		if($('#treat_no').val() == ''){alert('요양기관번호를 입력하세요.'); $('#treat_no').focus; return;};
		
		if($('#pageType').val() == 'update' && OLD_TREAT_NO != $('#treat_no').val() && CHK_FLAG == false){alert('요양기관번호  중복체크하세요.'); $('#treat_no').focus; return;}
		if(TREATNO_CHK == false){alert('요양기관번호  중복체크하세요.'); $('#treat_no').focus;  return;}
		
		
		if (type=='all') {
			if (!confirm('수정된 내용이 [프로젝트 정보]와 [운영정보]에 적용됩니다.\n저장하시겠습니까?')) return;
		} else if (type=='one') {
			if (!confirm('수정된 내용이 [프로젝트 정보]에만 적용됩니다.\n저장하시겠습니까?')) return;
		} else if (type=='lock') {
			if (!confirm('프로젝트 정보가 잠금(Lock)처리 됩니다.\n적용 하시겠습니까?')) return;
			f.p_lock.value = 'Y';
		} else if (type=='unlock') {
			if (!confirm('프로젝트 정보의 잠금(Unlock)처리가 해제 됩니다.\n적용 하시겠습니까?')) return;
			f.p_lock.value = 'N';
		}
		
		f.procFlag.value = type;
		common.ajaxCall($('form[name=procFrm]').serialize() , '/ad/cust/proc2.do' , 'procReturn') ; 
	}
	
	function procReturn(data){
		var returnCode = typeof data.returnCode != "undefined" ? data.returnCode : "002" ; 
		var msg = "" ; 
		
		if(returnCode == "000") msg = "정상적으로 처리 되었습니다." ; 
		else if(returnCode == "001") msg = "비정상적으로 처리 되었습니다." ; 
		else if(returnCode == "002") msg = "처리도중 오류가 발생했습니다." ;
		
		alert(msg) ; 
		if(returnCode == "000") {
			var datas = {'seq' : $('#seq').val()} ; 
			common.ajaxCall(datas , '/ad/cust/getProjectCnt.do' , 'setProjectCnt') ;
			
			makeBtnGrade($('#p_lock').val());
		}
	}
	
	function goList() {
		var f = document.procFrm;
		f.action = '/ad/cust/list.do' + window.location.search.substring();
		f.submit();	
	}
	
	function changeServerCode(thisObj){
		$("#model_code").empty() ; 
		
		if(thisObj != ""){
			commonCode.getCodeList('CUST' , thisObj , 'model_code') ; 	
		}else{
			$('#model_code').append(commonCode.defaultViewOption);
		}
		
	}
	
	/* 중복체크  기능 */
	
	function treatNoChk(){
		
		var datas = {'treat_no' : $('#treat_no').val()} ; 
		common.ajaxCall(datas , '/ad/cust/chkTreatNo.do' , 'resultTreatNo') ; 
	}
	
	function resultTreatNo(data){
		
		if(data.returnCode == "001"){alert('이미 등록된 번호가 있습니다.');TREATNO_CHK = false;
		}else{alert('사용가능한 번호입니다.'); TREATNO_CHK = true; CHK_FLAG= true; }
	}
	
	/*날짜 형식 유효성 검사 2021.12.13.이설아 추가*/
	function chkDateFormat(inputId, data){
		
		if(!data == ""){
		 	var data2 = data.replaceAll("/", "") ; 
			var datatimeRegexp = RegExp(/^\d{4}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])$/);
			var inputId = inputId;
			
		    if ( !datatimeRegexp.test(data2) ) {		
		        alert("날짜는 2022/01/01 형식으로 입력해주세요."); 
		        $('#' + inputId).val("");
		        $('#' + inputId).focus();
		    }else{
		    	if(!data.includes("/")){
		    		var rightDate = data.substring(0,4) + "/" + data.substring(4,6) + "/" + data.substring(6,8) ;
		    		$('#' + inputId).val(rightDate);
		    	}
		    }
		}		
		
	};
	
</script>

<div class="tit_wrap">
	<%-- <%= CommonExecute.returnLineMap(request) %> --%>
	<h2 class="tit_ico_customer">거래처 관리<span class="tit_depth mgl20 mgt8">프로젝트정보</span></h2>
</div>
<div class="tit_sWrap">
	<h3 class="tit_dot_gray">거래처 상세 정보<c:if test="${ vo.pageType ne 'insert' }">&nbsp;&lt;<span class="colorBlue mg15" style="line-height:25px;">${ vo.cust_kor_name }, ${ vo.crm_code }</span>&gt;</c:if></h3>
</div>
<!-- tab -->
<ul class="tab_line list7 mgb20">
	<li><a href="javascript:moveTab('');">관리 정보</a></li><!-- 활성시 current -->
	<li class="active"><a href="javascript:moveTab('2');">프로젝트 정보</a></li>
	<li><a href="javascript:moveTab('3');">운영 정보</a></li>
	<li><a href="javascript:moveTab('4');">시스템 이력</a></li>
	<li><a href="javascript:moveTab('5');">유지보수 이력</a></li>
	<li><a href="javascript:moveTab('7');">매출 이력(부가솔루션)</a></li>
	
	<li><a href="javascript:moveTab('6');">문서관리</a></li>
</ul>
<!--// tab -->
<c:choose>
	<c:when test="${vo.pageType eq 'update' }">
	<button class="btn_line_gray w90 floatR" onclick="btnReportPrint();">보고서 출력</button>
	</c:when>
</c:choose>

<form name="procFrm" method="post" onsubmit="return false;">
	<input type="hidden" name="seq"  		id="seq" 			value="${ vo.seq }"/>
	<input type="hidden" name="pageType"  id="pageType" 	value="${ vo.pageType }"/>
	<input type="hidden" name="mt_cnt"  	id="mt_cnt" 		value=""/>
	<input type="hidden" name="vc_cnt"  	id="vc_cnt" 		value=""/>
	<input type="hidden" name="bd_cnt"  	id="bd_cnt" 		value=""/>
	<input type="hidden" name="cg_cnt"  	id="cg_cnt" 		value=""/>
	<input type="hidden" name="p_lock"  	id="p_lock" 		value="N"/>
	<input type="hidden" name="procFlag"  	id="procFlag" 	value="N"/>
	<input type="hidden" name="erp_code" id="erp_code" 	value="${ vo.erp_code }"/>
<!-- write -->
<div class="tit_bWrap clearB mgb10">
	<h4>프로젝트 정보</h4>
</div>
<table class="sType mgb20">
	<caption>사업자 정보 입력</caption>
	<colgroup>
		<col style="width:125px;" />
		<col style="width:375px;" />
		<col style="width:125px;" />
		<col style="width:375px;" />
	</colgroup>
	<tr>
		<th scope="row">전산오픈일</th>
		<td>
			<input type="text" name="open_dt" id="open_dt" title="전산오픈일 입력" class="w125 mgr5" onchange="chkDateFormat('open_dt',this.value);" />
			<!-- <button type="button" class="btn_calendar">날짜선택</button> -->
		</td>
		<th scope="row">SI&#47;Package</th>
		<td>
			<select name="package_code" id="package_code" title="SI패키지 선택">
				<option value="">솔루션패키지</option>
			</select>
		</td>
	</tr>
	<tr>
		<th scope="row">투입기간</th>
		<td>
			<input type="text" name="term_start_dt" id="term_start_dt" title="투입기간 시작일 입력" class="w125 mgr5" onchange="chkDateFormat('term_start_dt',this.value);" />
			<!-- <button type="button" class="btn_calendar mgr5">날짜선택</button> -->~
			<input type="text" name="term_end_dt" id="term_end_dt" title="투입기간 종료일 입력" class="w125 mgl5 mgr5" onchange="chkDateFormat('term_end_dt',this.value);" />
			<!-- <button type="button" class="btn_calendar">날짜선택</button> -->
		</td>
		<th scope="row">투입인원</th>
		<td>
			<input type="text" name="term_person_count" id="term_person_count" title="투입인원 입력" />
		</td>
	</tr>
	<tr>
		<th scope="row">무상유지보수</th>
		<td>
			<select name="mtac_month" id="mtac_month" title="무상유지보수 기간 선택">
				<option value="">6개월</option>
			</select>
		</td>
		<!--  2018/03/30 최종검수일 -> 구축완료일로 명칭 변경 -->
		<th scope="row">구축완료일</th>
		<td>
			<input type="text" name="test_dt" id="test_dt" title="구축완료일 입력" class="w125 mgr5" onchange="chkDateFormat('test_dt',this.value);"/>
			<!-- <button type="button" class="btn_calendar mgr5">날짜선택</button> -->
		</td>
	</tr>
	<tr>
		<th scope="row">담당PM</th>
		<td>
			<input type="text" id="pm" name="pm" title="담당PM 입력" value="" />
		</td>
		<th scope="row">OCS&#47;EMR ver</th>
		<td>
			<select name="version" id="version" title="버전 선택">
				<option value="">ver 7.5</option>
			</select>
		</td>
	</tr>
	<tr>
		<th scope="row">첫 청구 <br>승인일(검수일)</th>
		<td colspan='3'>
			<input type="text" id="approval_dt" name="approval_dt" title="첫 청구 승인일(검수일) 입력" class="w125 mgr5" value="" onchange="chkDateFormat('approval_dt',this.value);"/>
		</td>
	</tr>
</table>
<!--// write -->
<!-- write -->
<div class="tit_bWrap mgb10">
	<h4>서버 정보</h4>
</div>
<table class="sType mgb20">
	<caption>서버 정보 입력</caption>
	<colgroup>
		<col style="width:125px;" />
		<col style="width:275px;" />
		<col style="width:125px;" />
		<col style="width:175px;" />
		<col style="width:125px;" />
		<col style="width:175px;" />
	</colgroup>
	<tr>
		<th scope="row">구성</th>
		<td>
			<select name="formation_code" id="formation_code" title="구성 선택" class="required" >
				<option value="">단일화</option>
			</select>
		</td>
		<th scope="row">서버 제조사&#47;모델</th>
		<td colspan="3">
			<select name="server_code" id="server_code" title="서버 제조사 선택" class="mgr5 w213" onchange="changeServerCode(this.value);">
				<option value="">제조사 선택</option>
			</select>
			<select name="model_code" id="model_code" title="서버 모델 선택" class="w213"></select>
		</td>
	</tr>
	<tr>
		<th scope="row">OS</th>
		<td>
			<select name="os" id="os" title="OS 선택">
				<option value="">Windows Server 2008 R2 Standard</option>
			</select>
		</td>
		<th scope="row">서버 RAM</th>
		<td colspan="3">
			<select name="ram" id="ram" title="서버 RAM 선택">
				<option value="">6g</option>
			</select>
		</td>
	</tr>
	<tr>
		<th scope="row">서비스네임</th>
		<td>
			<select name="sid" id="sid" title="서비스네임 선택">
				<option value="">ora9</option>
			</select>
		</td>
		<th scope="row">오라클버전</th>
		<td colspan="3">
			<select name="oracle_version" id="oracle_version" title="오라클버전 선택">
				<option value="">10g10.2.0.4</option>
			</select>
		</td>
	</tr>
	<tr>
		<th scope="row">서버IP(호스트)</th>
		<td>
			<input type="text" name="server_ip" id="server_ip" title="서버IP 입력" value="" />
		</td>
		<th scope="row">서버아이디</th>
		<td>
			<input type="text" name="server_id" id="server_id" title="서버아이디 입력" value="" />
		</td>
		<th scope="row">서버비밀번호</th>
		<td>
			<input type="text" name="server_pw" id="server_pw" title="서버비밀번호 입력" value="" />
		</td>
	</tr>
	<tr>
		<th scope="row">DUR브로커IP</th>
		<td colspan="5">
			<input type="text" name="dur_ip" id="dur_ip" title="DUR브로커IP 입력" class="w235" value="" />
		</td>
	</tr>
	<tr>
		<th scope="row">유지보수계약일자</th>
		<td>
			<input type="text" name="mtac_contract_dt" id="mtac_contract_dt" title="유지보수계약일자 입력" class="w200 mgr5" value="" onchange="chkDateFormat('mtac_contract_dt',this.value);"/>
			<!-- <button type="button" class="btn_calendar">날짜선택</button> -->
		</td>
		<th scope="row">서버유지보수업체</th>
		<td colspan="3">
			<div id="mt_wrap"></div>
			<button class="btn_plus mgr5" onclick="addMtacCustCode();"></button>
			<button class="btn_minus" onclick="delMtacCustCode();"></button>
		</td>
	</tr>
	<tr>
		<th scope="row">PC</th>
		<td>
			<input type="text" name="pc" id="pc" title="PC 입력" value="" />
		</td>
		<th scope="row">서버 백신</th>
		<td colspan="3">
			<div id="vc_wrap"></div>
			<button class="btn_plus mgr5" onclick="addVcCode();"></button>
			<button class="btn_minus" onclick="delVcCode();"></button>
		</td>
	</tr>
</table>
<!--// write -->
<!-- write -->
<div class="tit_bWrap mgb10">
	<h4>기본 정보</h4>
</div>
<table class="sType mgb20">
	<caption>기본 정보 입력</caption>
	<colgroup>
		<col style="width:125px;" />
		<col style="width:375px;" />
		<col style="width:125px;" />
		<col style="width:375px;" />
	</colgroup>
	<tr>
		<th scope="row">거래처명</th>
		<td>
			<input type="text" name="cust_kor_name" id="cust_kor_name" title="거래처명 입력" value="" />
		</td>
		<th scope="row">CRM코드</th>
		<td>
			<input type="text" name="crm_code" id="crm_code" title="CRM코드 입력" value="" />
		</td>
	</tr>
	<tr>
		<th scope="row">거래처구분</th>
		<td>
			<select name="cust_gubun" id="cust_gubun" title="병원종류 선택">
				<option value="">병원</option>
			</select>
		</td>
		<th scope="row">대표자</th>
		<td>
			<input type="text" name="ceo" id="ceo" title="대표자 입력" value="" />
		</td>
	</tr>
	<tr>
		<th scope="row">사업자등록번호</th>
		<td>
			<input type="text" name="cust_no" id="cust_no" title="사업자등록번호 입력" value="" />
		</td>
		<th scope="row">법인등록번호</th>
		<td>
			<input type="text" name="law_no" id="law_no" title="법인등록번호 입력" value="" />
		</td>
	</tr>
	<tr>
		<th scope="row">요양기관번호 <span class="request">필수입력</span></th>
		<td>
			<input type="text" name="treat_no" id="treat_no" title="요양기관번호 입력" value="" style="width:260px"   />
			<button class="btn_line_gray" onclick="treatNoChk();" >중복체크</button>
		</td>
		<th scope="row">산재요양기호</th>
		<td>
			<input type="text" name="accident_no" id="accident_no" title="산재요양기호 입력" value="" />
		</td>
	</tr>
	<tr>
		<th scope="row">전화번호</th>
		<td>
			<input type="text" name="tel_no" id="tel_no" title="전화번호 입력" value="" />
		</td>
		<th scope="row">팩스번호</th>
		<td>
			<input type="text" name="fax_no" id="fax_no" title="팩스번호 입력" value="" />
		</td>
	</tr>
	<tr>
		<th scope="row">우편번호</th>
		<td>
			<input type="text" name="post_no" id="post_no" title="우편번호 입력" value="" />
		</td>
		<th scope="row">개업일</th>
		<td>
			<input type="text" name="buss_open_dt" id="buss_open_dt" title="개업일 입력" class="w300 mgr5" value="" onchange="chkDateFormat('buss_open_dt',this.value);" />
			<!-- <button type="button" class="btn_calendar">날짜선택</button> -->
		</td>
	</tr>
	<tr>
		<th scope="row">주소</th>
		<td colspan="3">
			<input type="text" name="addr" id="addr" title="주소 입력" value="" />
		</td>
	</tr>
	<tr>
		<th scope="row">Email</th>
		<td>
			<input type="text" name="email" id="email" title="Email 입력" value="" />
		</td>
		<th scope="row">Homepage</th>
		<td>
			<input type="text" name="homepage" id="homepage" title="Homepage 입력" value="" />
		</td>
	</tr>
	<tr>
		<th scope="row">업태</th>
		<td>
			<input type="text" name="buss_condition" id="buss_condition" title="업태 입력" value="" />
		</td>
		<th scope="row">종목</th>
		<td>
			<input type="text" name="buss_item" id="buss_item" title="종목 입력" value="" />
		</td>
	</tr>
	<tr>
		<th scope="row">기타설명</th>
		<td colspan="3">
			<input type="text" name="basic_etc" id="basic_etc" title="기타설명 입력" value="" />
		</td>
	</tr>
</table>
<!--// write -->
<!-- write -->
<div class="tit_bWrap mgb10">
	<h4>상세 정보</h4>
</div>
<table class="sType mgb20">
	<caption>상세 정보 입력</caption>
	<colgroup>
		<col style="width:125px;" />
		<col style="width:375px;" />
		<col style="width:125px;" />
		<col style="width:375px;" />
	</colgroup>
	<tr>
		<th scope="row">건물구조</th>
		<td colspan="3">
			<div id="bd_wrap"></div>
			<button class="btn_plus mgr5" onclick="addBdCode();"></button><button class="btn_minus" onclick="delBdCode();"></button>
		</td>
	</tr>
	<tr>
		<th scope="row" class="colorBlue">병상수</th>
		<td>
			<input type="text" name="bed_count" id="bed_count" title="병상수 입력">
		</td>
		<td colspan="2"></td>
	</tr>
	<tr>
		<th scope="row">진료과</th>
		<td>
			<input type="text" name="medical_office" id="medical_office" title="진료과 입력">
		</td>
		<th scope="row">진료지원과</th>
		<td>
			<input type="text" name="support_office" id="support_office" title="진료지원과 입력">
		</td>
	</tr>
	<tr>
		<th scope="row">진료과2</th>
		<td>
			<input type="text" name="medical_office2" id="medical_office2" title="진료과2 입력">
		</td>
		<th scope="row" class="colorBlue">전문병원여부</th>
		<td>
			<select name="specially_code" id="specially_code" title="전문병원여부 선택">
				<option value="">선택해주세요</option>
			</select>
		</td>
	</tr>
	<tr>
		<th scope="row" class="colorBlue">의사수</th>
		<td>
			<input type="text" name="doctor_count" id="doctor_count" title="의사수 입력">
		</td>
		<th scope="row" class="colorBlue">간호사수</th>
		<td>
			<input type="text" name="nurse_count" id="nurse_count" title="간호사수 입력">
		</td>
	</tr>
	<tr>
		<th scope="row" class="colorBlue">보훈여부</th>
		<td>
			<input type="checkbox" name="veterans_yn" id="veterans_yn" value="Y" title="보훈여부 입력">
		</td>
		<th scope="row" class="colorBlue">군지역소재</th>
		<td>
			<input type="checkbox" name="military_yn" id="military_yn" value="Y" title="군지역소재 입력">
		</td>
	</tr>
	<tr>
		<th scope="row" class="colorBlue">신규&#47;기존</th>
		<td>
			<select name="new_code" id="new_code" title="신규/기존 선택">
				<option value="">신규</option>
			</select>
		</td>
		<th scope="row" class="colorBlue">기존전산업체</th>
		<td>
			<input type="text" name="old_company_nm" id="old_company_nm" title="기존전산업체 입력">
		</td>
	</tr>
	<tr>
		<th scope="row" class="colorBlue">일 평균 내원자 수</th>
		<td>
			<input type="text" name="come_count" id="come_count" title="일 평균 내원자 수 입력">
		</td>
		<th scope="row" class="colorBlue">평균재원자수</th>
		<td>
			<input type="text" name="average_count" id="average_count" title="평균재원자수 입력">
		</td>
	</tr>
	<tr>
		<th scope="row" class="colorBlue">외부수탁업체</th>
		<td>
			<select name="outside_cust_code" id="outside_cust_code" title="외부수탁업체 선택">
				<option value="">신규</option>
			</select>
		</td>
		<th scope="row" class="colorBlue">청구여부</th>
		<td>
			<input type="checkbox" name="charge_yn" id="charge_yn" value="Y" title="청구여부 입력">
		</td>
	</tr>
	<tr>
		<th scope="row">특이사항</th>
		<td colspan="3">
			<textarea type="text" name="detail_etc" id="detail_etc" title="특이사항 입력"></textarea>
		</td>
	</tr>
</table>
<!--// write -->
<!-- list -->
<div class="tit_bWrap mgb10">
	<h4 class="floatL mgt8">담당자 정보</h4>
	<span class="floatR">
		<button class="btn_ico_circle_plus_g mgr5" onclick="addCharge();"><span>행추가</span></button>
		<button class="btn_ico_stop_g" onclick="delCharge();"><span>행삭제</span></button>
	</span>
</div>
<table class="hType mgb20">
	<caption>담당자 정보 목록</caption>
	<colgroup>
		<col style="width:40px" />
		<col span=4 style="width:auto" />
		
	</colgroup>
	<thead>
		<tr>
			<th scope="col">선택</th>
			<th scope="col">담당 구분</th>
			<th scope="col">담당자명</th>
			<th scope="col">연락처1(회사)</th>
			<th scope="col">연락처2(핸드폰)</th>
			<th scope="col">이메일</th>
			<th scope="col">비고</th>
		</tr>
	</thead>
	<tbody id="cg_wrap"></tbody>
</table>
<!--// list -->

<div class="btn_wrap">
	<div class="floatL">
		<button type="button" class="btn_ico_list" onclick="goList();"><span>목록</span></button>
	</div>
	<div class="floatR">
		<button type="button" class="btn_ico_confirm" id="btnView1" onclick="goProc('all');"><span>일괄저장</span></button>
		<button type="button" class="btn_ico_confirm" id="btnView2" onclick="goProc('one');"><span>단독저장</span></button>
	 	<c:choose>
	 		<c:when test="${ adUserInfo.emp_grade eq 'C001' || adUserInfo.emp_grade eq 'C002'}">
				<button type="button" class="btn_ico_confirm" id="btnView3" onclick="goProc('lock');"><span>잠금</span></button>
				<button type="button" class="btn_ico_confirm" id="btnView4" onclick="goProc('unlock');"><span>잠금해제</span></button>			
	 		</c:when>
	 	</c:choose>
		<button type="button" class="btn_ico_cancel" onclick="goList();"><span>취소</span></button>	 	
	</div>
</div>
</form>