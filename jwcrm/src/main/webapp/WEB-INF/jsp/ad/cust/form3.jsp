<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="egovframework.com.comm.util.CommonExecute"%>

<script type="text/javascript">

	var cg_cnt = 0;
	var nt_cnt = 0;
	var mt_cnt = 0; 		
	var vc_cnt = 0; 		
	
	
	$(document).ready(function(){
		/**	select box 정보 처리	*/
		commonCode.getCodeList('CUST' , 'CD03' , 'deal_code') ; 				/**	거래상태		*/
		commonCode.getCodeList('CUST' , 'CD03' , 'ch_deal_code') ; 				/**	거래상태		*/
		commonCode.getCodeList('CUST' , 'CD04' , 'his_basic_code') ; 		/**	HIS 기초		*/
		commonCode.getCodeList('CUST' , 'CD05' , 'his_treat_code') ; 		/**	HIS 진료		*/
		commonCode.getCodeList('CUST' , 'CD06' , 'his_work_code') ; 		/**	HIS 원무		*/
		commonCode.getCodeList('CUST' , 'CD07' , 'his_claim_code') ; 		/**	HIS 청구		*/
		commonCode.getCodeList('CUST' , 'CD02' , 'specially_code') ; 		/**	전문병원 여부	*/
		commonCode.getCodeList('CUST' , 'CD25' , 'new_code') ; 				/**	신규 여부		*/
		commonCode.getCodeList('CUST' , 'CD26' , 'outside_cust_code') ; 	/**	외부수탁		*/
		
		/*20180225추가  */
		commonCode.getCodeList('CUST' , 'CD39' , 'emergency_type_code') ;		/**	응급의료기관종류		*/
		commonCode.getCodeList('CUST' , 'CD40' , 'medicine_info_cust_code') ;		/**	의약품정보업체		*/
		commonCode.getCodeList('CUST' , 'CD41' , 'card_van_cust_code') ;		/**	카드밴사업체		*/
		commonCode.getCodeList('CUST' , 'CD42' , 'examination_cust_code') ;		/**	검진연동업체		*/
		commonCode.getCodeList('CUST' , 'CD43' , 'pasc_cust_code') ;		/**	팍스연동업체		*/
		
		commonCode.getCodeList('CUST' , 'CD15' , 'formation_code') ; 			/**	서버구성			*/
		commonCode.getCodeList('CUST' , 'CD16' , 'server_code') ; 				/**	제조사1			*/
		commonCode.getCodeList('CUST' , 'CD18' , 'os') ; 							/**	OS				*/
		commonCode.getCodeList('CUST' , 'CD19' , 'ram') ; 							/**	RAM				*/
		commonCode.getCodeList('CUST' , 'CD20' , 'sid') ; 							/**	서비스네임		*/
		commonCode.getCodeList('CUST' , 'CD21' , 'oracle_version') ; 			/**	오라클 버전		*/
		
		commonCode.getCodeList('CUST' , 'CD46' , 'ecfc') ;		/**	전자동의서업체(Electronic Consent Form Company)		*/
		commonCode.getCodeList('CUST' , 'CD47' , 'kiosk_usage') ;		/**	키오스크 사용여부	*/
		commonCode.getCodeList('CUST' , 'CD48' , 'eform_usage') ;		/**	심평원 E-FORM 사용여부	*/
		commonCode.getCodeList('CUST' , 'CD49' , 'hie') ;		/**	진료정보교류(Healthcare Information Exchange)		*/
		
		$( "#cancel_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#ch_cancel_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		$('#1_cancel_dt_cov').hide();
		$('#2_cancel_dt_cov').hide();
		
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
		common.ajaxCall(datas , '/ad/cust/getOperateInfo.do' , 'setOperateInfo') ; 
		
	}
	
	var projectCnt = 0 ;
	
	function setProjectCnt(data) {
		projectCnt = typeof data.cnt !='undefined' ? data.cnt : 0 ;
	}
	
	function setProjectInfo(data) {
		
		
		var info = typeof data.info !='undefined' ? data.info[0] : null ; //기본정보
		var charge = typeof data.charge !='undefined' ? data.charge : null ; //담당자정보
		var mtac = typeof data.mtac !='undefined' ? data.mtac : null ; //서버유지보수업체
		var vc = typeof data.vc !='undefined' ? data.vc : null ; //백신
		
		$("#specially_code").val(common.nvl(info.specially_code,''));
		$("#bed_count").val(common.nvl(info.bed_count,''));
		
		common.nvl(info.veterans_yn,'')!='' ? $("#veterans_yn").prop('checked',true) : '';
		common.nvl(info.military_yn,'')!='' ? $("#military_yn").prop('checked',true) : '';
		$("#doctor_count").val(common.nvl(info.doctor_count,''));
		$("#nurse_count").val(common.nvl(info.nurse_count,''));
		$("#new_code").val(common.nvl(info.new_code,''));
		
		
		
		$("#old_company_nm").val(common.nvl(info.old_company_nm,''));
		$("#come_count").val(common.nvl(info.come_count,''));
		$("#average_count").val(common.nvl(info.average_count,''));
		$("#outside_cust_code").val(common.nvl(info.outside_cust_code,''));
		common.nvl(info.military_yn,'')!='' ? $("#charge_yn").prop('checked',true) : '';
		
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
		$("#mtac_contract_dt").val(common.nvl(info.mtac_contract_dt,''));
		$("#pc").val(common.nvl(info.pc,''));
		
		if (charge != null && charge.length > 0) {
			
			$('#cg_wrap').html('');
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
	} 
	
	function setOperateInfo(data) {
		var info = typeof data.info !='undefined' ? data.info[0] : null ; //기본정보
		var charge = typeof data.charge !='undefined' ? data.charge : null ; //담당자정보
		var note = typeof data.note !='undefined' ? data.note : null ; //관리비고내역
		var mtac = typeof data.mtac !='undefined' ? data.mtac : null ; //서버유지보수업체
		var vc = typeof data.vc !='undefined' ? data.vc : null ; //백신

		if (charge.length == 0) addCharge();
		if (note.length == 0) addNote();
		if (mtac.length == 0) addMtacCustCode();
		if (vc.length == 0) addVcCode();
		
		/* 운영정보가 등록되지않았을때 최초 프로젝트 정보 셋팅 */
		if (info == null) common.ajaxCall({'seq' : $('#seq').val()} , '/ad/cust/getProjectInfo.do' , 'setProjectInfo') ;  
		
		if (info != null) {
			
			$('#deal_code').val(common.nvl(info.deal_code, ''));
			$('#ch_deal_code').val(common.nvl(info.ch_deal_code, ''));
			$('#his_basic_code').val(common.nvl(info.his_basic_code, ''));
			$('#his_treat_code').val(common.nvl(info.his_treat_code, ''));
			$('#his_work_code').val(common.nvl(info.his_work_code, ''));
			$('#his_claim_code').val(common.nvl(info.his_claim_code, ''));
			$('#specially_code').val(common.nvl(info.specially_code, ''));
			$('#bed_count').val(common.nvl(info.bed_count, ''));
			
			if( $('#deal_code').val() =="C003"){
				console.log($('#deal_code').val());
				$('#cancel_dt').val(makeDate(common.nvl(info.cancel_dt, '')));
				$('#1_cancel_dt_cov').show();
			}else{$('#1_cancel_dt_cov').hide();}
			
			
			if( $('#ch_deal_code').val() =="C003"){
				$('#ch_cancel_dt').val(makeDate(common.nvl(info.ch_cancel_dt, '')));
				$('#2_cancel_dt_cov').show();
			}else{$('#2_cancel_dt_cov').hide();}
			
			common.nvl(info.checkup_yn,'')!='' ? $("#checkup_yn").prop('checked',true) : '';
			common.nvl(info.his_yn,'')!='' ? $("#his_yn").prop('checked',true) : '';
			common.nvl(info.veterans_yn,'')!='' ? $("#veterans_yn").prop('checked',true) : '';
			common.nvl(info.military_yn,'')!='' ? $("#military_yn").prop('checked',true) : '';
			common.nvl(info.choice_yn,'')!='' ? $("#choice_yn").prop('checked',true) : '';
			common.nvl(info.dentist_yn,'')!='' ? $("#dentist_yn").prop('checked',true) : '';
			common.nvl(info.mental_yn,'')!='' ? $("#mental_yn").prop('checked',true) : '';
			common.nvl(info.oriental_yn,'')!='' ? $("#oriental_yn").prop('checked',true) : '';
			common.nvl(info.hemodialysis_yn,'')!='' ? $("#hemodialysis_yn").prop('checked',true) : '';
			common.nvl(info.care_yn,'')!='' ? $("#care_yn").prop('checked',true) : '';
			common.nvl(info.emergencyop_yn,'')!='' ? $("#emergencyop_yn").prop('checked',true) : '';
			common.nvl(info.nedis_yn,'')!='' ? $("#nedis_yn").prop('checked',true) : '';
			common.nvl(info.narcotics_yn,'')!='' ? $("#narcotics_yn").prop('checked',true) : '';
			
			common.nvl(info.onticsense_yn,'')!='' ? $("#onticsense_yn").prop('checked',true) : '';
			common.nvl(info.van_yn,'')!='' ? $("#van_yn").prop('checked',true) : '';
			
			common.nvl(info.issmgt_yn,'')!='' ? $("#issmgt_yn").prop('checked',true) : '';
			common.nvl(info.sms_yn,'')!='' ? $("#sms_yn").prop('checked',true) : '';
			common.nvl(info.alimtalk_yn,'')!='' ? $("#alimtalk_yn").prop('checked',true) : '';
			common.nvl(info.qkact_yn,'')!='' ? $("#qkact_yn").prop('checked',true) : '';
			
			
			$("#medicine_info_cust_code").val(common.nvl(info.medicine_info_cust_code,''));
			$("#emergency_type_code").val(common.nvl(info.emergency_type_code,''));
			$("#card_van_cust_code").val(common.nvl(info.card_van_cust_code,''));
			$("#examination_cust_code").val(common.nvl(info.examination_cust_code,''));
			$("#pasc_cust_code").val(common.nvl(info.pasc_cust_code,''));
			
			$("#ecfc").val(common.nvl(info.ecfc,''));
			$("#kiosk_usage").val(common.nvl(info.kiosk_usage,''));
			$("#eform_usage").val(common.nvl(info.eform_usage,''));
			$("#hie").val(common.nvl(info.hie,''));
			
			$('#doctor_count').val(common.nvl(info.doctor_count, ''));
			$('#nurse_count').val(common.nvl(info.nurse_count, ''));
			$('#care_grade').val(common.nvl(info.care_grade, ''));
			$('#new_code').val(common.nvl(info.new_code, ''));
			$('#old_company_nm').val(common.nvl(info.old_company_nm, ''));
			$('#come_count').val(common.nvl(info.come_count, ''));
			$('#average_count').val(common.nvl(info.average_count, ''));
			$('#outside_cust_code').val(common.nvl(info.outside_cust_code, ''));
			common.nvl(info.charge_yn,'')!='' ? $("#charge_yn").prop('checked',true) : '';
			$('#detail_etc').val(common.nvl(info.detail_etc, ''));
			
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
			$("#mtac_contract_dt").val(common.nvl(info.mtac_contract_dt,''));
			$("#pc").val(common.nvl(info.pc,''));
			
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
			
			if (note != null && note.length > 0) {
				for (var i=0; i < note.length; i++) {
					var list = note[i];
					
					var str = '';
					str += '<tr>';
					str += '<td><input type="checkbox" name="dtl_seq" id="dtl_seq" value="'+list.dtl_seq+'"></td>';
					str += '<td><input type="text" name="gubun'+(i+1)+'" id="gubun'+(i+1)+'" value="'+common.nvl(list.gubun,'')+'" title="구분 입력"></td>';
					str += '<td><input type="text" name="contents'+(i+1)+'" id="contents'+(i+1)+'" value="'+common.nvl(list.contents,'')+'" title="내용 입력" ></td>';
					str += '<td><span class="mgr5">'+common.nvl(list.reg_date,'')+'</span></td>';
					str += '<td>'+common.nvl(list.reg_id,'')+'</td>';
					str += '<td><input type="text" name="n_etc'+(i+1)+'" id="n_etc'+(i+1)+'" value="'+common.nvl(list.etc,'')+'" title="비고 입력" ></td>';
					str += '</tr>';
					$('#nt_wrap').append(str);
				}
				nt_cnt = note.length;		
			}
			
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
		str += '<td><input type="text" name="charge_nm'+cg_cnt+'" id="charge_nm'+cg_cnt+'" title="담당자명 입력"></td>';
		str += '<td><input type="text" name="company_tel_no'+cg_cnt+'" id="company_tel_no'+cg_cnt+'" title="연락처1 입력"></td>';
		str += '<td><input type="text" name="hp_no'+cg_cnt+'" id="hp_no'+cg_cnt+'" title="연락처2 입력"></td>';
		str += '<td><input type="text" name="email'+cg_cnt+'" id="email'+cg_cnt+'" title="이메일 입력"></td>';
		str += '<td><input type="text" name="etc'+cg_cnt+'" id="etc'+cg_cnt+'" title="비고"></td>';
		str += '</tr>';
		$('#cg_wrap').append(str);
		
		commonCode.getCodeList('CUST' , 'CD27' , 'charge_code' + cg_cnt) ; 	/**	담당자		*/
	}
	
	function delCharge() {
		$('input:checkbox[class="charge_check"]').each(function() {
			if($(this).is(":checked")){//checked 처리된 항목의 값
				$('#tr'+$(this).attr('cnt')).remove();
			}
		});
				
	}
	
	function addNote() {
		var str = '';
		nt_cnt++;
		str += '<tr>';
		str += '<td><input type="checkbox" name="dtl_seq" name="dtl_seq" value=""></td>';
		str += '<td><input type="text" name="gubun'+nt_cnt+'" id="gubun'+nt_cnt+'" title="구분 입력" ></td>';
		str += '<td><input type="text" name="contents'+nt_cnt+'" id="contents'+nt_cnt+'" title="내용 입력" ></td>';
		str += '<td><span class="mgr5">-</span></td>';
		str += '<td>-</td>';
		str += '<td><input type="text" name="n_etc'+nt_cnt+'" id="n_etc'+nt_cnt+'" title="비고 입력" ></td>';
		str += '</tr>';
		$('#nt_wrap').append(str);
	}
	
	function delNote() {
		if ($('#nt_wrap input[type=checkbox]:checked').length == 0) { 
			alert('삭제할 행을 선택하세요.');
			return;
		}
		$('#nt_wrap input[type=checkbox]:checked').each(function(){
			if (common.isEmpty($('#del_dtl_seq').val())) $('#del_dtl_seq').val($(this).val());
			else $('#del_dtl_seq').val($('#del_dtl_seq').val() + "@" + $(this).val());
			$(this).parent().parent('tr').remove();
		});
	}
	
	function moveTab(gubun){
		if (projectCnt == 0 && gubun == '3') {
			alert('프로젝트 정보를 등록해 주세요.');
			return;
		}
		location.href = "/ad/cust/form" + gubun + ".do${ QUERYSTRING }" ; 
	}
	
	
	
	function goProc(){
		var f = document.procFrm;
		
		
		if (  $("input:checkbox[id='his_yn']").is(":checked") == true &&  $('#deal_code').val() == '') {
			alert('HIS 거래상태를 선택해 주세요.');
			$('#deal_code').focus();
			return;
		}
		
		if ( $("input:checkbox[id='checkup_yn']").is(":checked") == true && $('#ch_deal_code').val() == '') {
			alert('CHECK UP 거래상태를 선택해 주세요.');
			$('#ch_deal_code').focus();
			return;
		}
		
		
		/* if ($('#his_basic_code').val() == '') {
			alert('HIS 기초 코드를 선택해 주세요.');
			$('#his_basic_code').focus();
			return;
		}
		if ($('#his_treat_code').val() == '') {
			alert('HIS 진료 코드를 선택해 주세요.');
			$('#his_treat_code').focus();
			return;
		}		
		if ($('#his_work_code').val() == '') {
			alert('HIS 원무 코드를 선택해 주세요.');
			$('#his_work_code').focus();
			return;
		}		
		if ($('#his_claim_code').val() == '') {
			alert('HIS 청구 코드를 선택해 주세요.');
			$('#his_claim_code').focus();
			return;
		} */		
		if ($('#specially_code').val() == '') {
			alert('전문병원 여부를 선택해 주세요.');
			$('#specially_code').focus();
			return;
		}		
		if ($('#bed_count').val() == '') {
			alert('병상수를 입력해 주세요.');
			$('#bed_count').focus();
			return;
		}
		
		if( $('#deal_code').val() == 'C003' && $('#cancel_dt').val() == "" ){
			alert('HIS 해지일을 입력해 주세요.');
			$('#cancel_dt').focus();
			return;			
		}
		
		if( $('#ch_deal_code').val() == 'C003' && $('#ch_cancel_dt').val() == "" ){
			alert('CHECK UP 해지일을 입력해 주세요.');
			$('#ch_cancel_dt').focus();
			return;			
		}
		
		if( $('#deal_code').val() != 'C003' ){
			$('#cancel_dt').val('');
		}
		
		if( $('#ch_deal_code').val() != 'C003' ){
			$('#ch_cancel_dt').val('');
		}
		
		if( $("input:checkbox[id='checkup_yn']").is(":checked") == false && $("input:checkbox[id='his_yn']").is(":checked") == false){
			alert('제품 사용여부를 확인해 주세요.');
			return;
		}

		
		var len = $('#cg_wrap').children('tr').length;
	
		for(var i=0 ; i < len; i++ ){
			var i = i+1;
			if( $('#charge_code'+i).val() != "" || $('#company_tel_no'+i).val() != ""  ||  $('#hp_no'+i).val() != "" ||  $('#email'+i).val() != "" ||  $('#etc'+i).val() != "" ){
				if( $('#charge_nm'+i).val() == "" || $('#charge_nm'+i).val() == null){
					alert('담당자명을 입력해 주세요.');
					$('#charge_nm'+i).focus();
					
					return;
				}
			}
			
		}
		
		/* $('#cg_wrap').children('tr').each(function(i,e){
			var i = i+1;
			if( $('#charge_nm'+i).val() == "" || $('#charge_nm'+i).val() == null){
				alert('담당자명을 입력해 주세요.');
				$('#charge_nm'+i).focus();
				return;
			}
			
		}); */
		
		
		
		f.pageType.value = '${vo.pageType}';
		f.cg_cnt.value = cg_cnt ;
		f.nt_cnt.value = nt_cnt ;
		f.mt_cnt.value = mt_cnt ;
		f.vc_cnt.value = vc_cnt ;

		common.ajaxCall($('form[name=procFrm]').serialize() , '/ad/cust/proc3.do' , 'procReturn') ; 
	}
	
	function procReturn(data){
		var returnCode = typeof data.returnCode != "undefined" ? data.returnCode : "002" ; 
		var msg = "" ; 
		
		if(returnCode == "000") msg = "정상적으로 처리 되었습니다." ; 
		else if(returnCode == "001") msg = "비정상적으로 처리 되었습니다." ; 
		else if(returnCode == "002") msg = "처리도중 오류가 발생했습니다." ;
		
		alert(msg) ; 
		//if(returnCode == "000") goList() ;
	}
	
	function goList() {
		location.href = '/ad/cust/list.do' + window.location.search.substring();
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
	
	function changeServerCode(thisObj){
		$("#model_code").empty() ; 
		
		if(thisObj != ""){
			commonCode.getCodeList('CUST' , thisObj , 'model_code') ; 	
		}else{
			$('#model_code').append(commonCode.defaultViewOption);
		}
		
	}
	
	function confirmDealCode(gubun,data){
		
		if(data == "C003"){$('#'+gubun+'_cancel_dt_cov').show();
		}else{$('#'+gubun+'_cancel_dt_cov').hide();} 
	}
	

</script>

<div class="tit_wrap">
	<%-- <%= CommonExecute.returnLineMap(request) %> --%>
	<h2 class="tit_ico_customer">거래처 관리<span class="tit_depth mgl20 mgt8">운영정보</span></h2>
</div>
<div class="tit_sWrap">
	<h3 class="tit_dot_gray">거래처 상세 정보<c:if test="${ vo.pageType ne 'insert' }">&nbsp;&lt;<span class="colorBlue mg15" style="line-height:25px;">${ vo.cust_kor_name }, ${ vo.crm_code }</span>&gt;</c:if></h3>
</div>
<!-- tab -->
<ul class="tab_line list7 mgb20">
	<li><a href="javascript:moveTab('');">관리 정보</a></li><!-- 활성시 current -->
	<li><a href="javascript:moveTab('2');">프로젝트 정보</a></li>
	<li class="active"><a href="javascript:moveTab('3');">운영 정보</a></li>
	<li><a href="javascript:moveTab('4');">시스템 이력</a></li>
	<li><a href="javascript:moveTab('5');">유지보수 이력</a></li>
		<li><a href="javascript:moveTab('7');">매출 이력(부가솔루션)</a></li>
	<li><a href="javascript:moveTab('6');">문서관리</a></li>
</ul>
<!--// tab -->

<form name="procFrm" method="post" onsubmit="return false;">
	<input type="hidden" name="seq"  		id="seq" 			value="${ vo.seq }"/>
	<input type="hidden" name="pageType" id="pageType" 	value="${ vo.pageType }"/>
	<input type="hidden" name="del_dtl_seq" id="del_dtl_seq" />
	<input type="hidden" name="cg_cnt"  	id="cg_cnt" 		value=""/> <!--담당자  -->
	<input type="hidden" name="nt_cnt"  	id="nt_cnt" 		value=""/>
	<input type="hidden" name="mt_cnt"  	id="mt_cnt" 		value=""/>
	<input type="hidden" name="vc_cnt"  	id="vc_cnt" 		value=""/>	

<!-- write -->
<div class="tit_bWrap mgb10">
	<h4>기본 정보</h4>
</div>
<table class="sType mgb20">
	<caption>기본 정보 입력</caption>
	<colgroup>
		<col style="width:125px;" />
		<col style="width:170px;" />
		<col style="width:170px;" />
		<col style="width:140px;" />
		<col style="width:170px;" />
		<col style="width:180px;" />
	</colgroup>
	<!-- <tr>
		<th scope="row">제품사용<span class="request">필수입력</span></th>
		<td colspan="5">
			<label class="mgr15"><span class="fontW_b mgr5">HIS</span><input type="checkbox" name="his_yn" id="his_yn" value="Y"></label>
			<label class="mgr15"><span class="fontW_b mgr5">CHECK UP</span><input type="checkbox" name="checkup_yn" id="checkup_yn" value="Y"></label>
		</td>
	</tr> -->
	<tr>
		<th scope="row" id="" >HIS 사용/상태 <span class="request">필수입력</span></th>
		<td colspan="2">
			<label class="mgr15"><span class="fontW_b mgr5">HIS</span><input type="checkbox" name="his_yn" id="his_yn" value="Y"></label>
			<select name="deal_code" id="deal_code" title="거래상태 선택" class="w100" onchange="confirmDealCode(1,this.value)">
				
			</select>
			<span id="1_cancel_dt_cov">
				<input type="text" class="w100" name="cancel_dt" id="cancel_dt" value="" title="해지일 입력">
			</span>
		</td>
		<th scope="row">CHECKUP 사용/상태 <span class="request">필수입력</span></th>
		<td colspan="2">
			<label class="mgr15"><span class="fontW_b mgr5">CHECK UP</span><input type="checkbox" name="checkup_yn" id="checkup_yn" value="Y"></label>
			<select name="ch_deal_code" id="ch_deal_code" title="거래상태 선택" class="w100" onchange="confirmDealCode(2,this.value)"></select>
			<span id="2_cancel_dt_cov">
				<input type="text" class="w100" name="ch_cancel_dt" id="ch_cancel_dt" value="" title="해지일 입력">
			</span>
		</td>
	</tr>
	<tr>
		<th scope="row">HIS버전</th>
		<td colspan="5">
			<span class="fontW_b mgr5">기초</span>
			<select name="his_basic_code" id="his_basic_code" title="HIS 기초 선택" class="w140 mgr20">
				<option value="">버전선택</option>
			</select>
			<span class="fontW_b mgr5">진료</span>
			<select name="his_treat_code" id="his_treat_code" title="HIS 진료 선택" class="w140 mgr20">
				<option value="">버전선택</option>
			</select>
			<span class="fontW_b mgr5">원무</span>
			<select name="his_work_code" id="his_work_code" title="HIS 원무 선택" class="w140 mgr20">
				<option value="">버전선택</option>
			</select>
			<span class="fontW_b mgr5">청구</span>
			<select name="his_claim_code" id="his_claim_code" title="HIS 청구 선택" class="w140 mgr20">
				<option value="">버전선택</option>
			</select>
		</td>
	</tr>
	
</table>
<!--// write -->
<!-- write -->
<div class="tit_bWrap mgb10">
	<h4>운영 정보</h4>
</div>
<table class="sType mgb20">
	<caption>운영 정보 입력</caption>
	<colgroup>
		<col style="width:125px;" />
		<col style="width:209px;" />
		<col style="width:125px;" />
		<col style="width:208px;" />
		<col style="width:125px;" />
		<col style="width:208px;" />
	</colgroup>
	<tr>
		<th scope="row">전문병원 여부 <span class="request">필수입력</span></th>
		<td>
			<select name="specially_code" id="specially_code" title="전문병원 여부 선택"></select>
		</td>
		<th scope="row">병상수 <span class="request">필수입력</span></th>
		<td colspan="3">
			<input type="text" name="bed_count" id="bed_count" title="병상수 입력" class="w168"  />
		</td>
	</tr>
	<tr>
		<th  rowspan="2" scope="row">선택</th>
		<td colspan="5">
			<label class="mgr15"><span class="fontW_b mgr5">보훈여부</span><input type="checkbox" name="veterans_yn" id="veterans_yn" value="Y"></label>
			<label class="mgr15"><span class="fontW_b mgr5">군지역소재</span><input type="checkbox" name="military_yn" id="military_yn" value="Y"></label>
			<label class="mgr15"><span class="fontW_b mgr5">선택진료</span><input type="checkbox" name="choice_yn" id="choice_yn" value="Y"></label>
			<label class="mgr15"><span class="fontW_b mgr5">치과유무</span><input type="checkbox" name="dentist_yn" id="dentist_yn" value="Y"></label>
			<label class="mgr15"><span class="fontW_b mgr5">정신과</span><input type="checkbox" name="mental_yn" id="mental_yn" value="Y"></label>
			<label class="mgr15"><span class="fontW_b mgr5">한방</span><input type="checkbox" name="oriental_yn" id="oriental_yn" value="Y"></label>
			<label class="mgr15"><span class="fontW_b mgr5">혈액투석</span><input type="checkbox" name="hemodialysis_yn" id="hemodialysis_yn" value="Y"></label>
			<label class="mgr15"><span class="fontW_b mgr5">포괄간호</span><input type="checkbox" name="care_yn" id="care_yn" value="Y"></label>
			<label class="mgr15"><span class="fontW_b mgr5">불출관리</span><input type="checkbox" name="issmgt_yn" id="issmgt_yn" value="Y"></label>
		</td>	
	</tr>
	<tr>
		<td colspan="5">
			<!-- 20180221 필드추가  -->
			<label class="mgr15"><span class="fontW_b mgr5">응급실운영</span><input type="checkbox" name="emergencyop_yn" id="emergencyop_yn" value="Y"></label>
			<label class="mgr15"><span class="fontW_b mgr5">NEDIS사용</span><input type="checkbox" name="nedis_yn" id="nedis_yn" value="Y"></label>
			<!-- 20180605 필드추가  -->
			<label class="mgr15"><span class="fontW_b mgr5">마약류연계</span><input type="checkbox" name="narcotics_yn" id="narcotics_yn" value="Y"></label>
			<!-- 20180803 필드추가  -->
			<label class="mgr15"><span class="fontW_b mgr5">Ontic Sense</span><input type="checkbox" name="onticsense_yn" id="onticsense_yn" value="Y"></label>
			<label class="mgr15"><span class="fontW_b mgr5">van인터페이스</span><input type="checkbox" name="van_yn" id="van_yn" value="Y"></label>
			<label class="mgr15"><span class="fontW_b mgr5">SMS</span><input type="checkbox" name="sms_yn" id="sms_yn" value="Y"></label>
			<label class="mgr15"><span class="fontW_b mgr5">알림톡</span><input type="checkbox" name="alimtalk_yn" id="alimtalk_yn" value="Y"></label>
			<label class="mgr15"><span class="fontW_b mgr5">똑딱</span><input type="checkbox" name="qkact_yn" id="qkact_yn" value="Y"></label>
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
		<col style="width:209px;" />
		<col style="width:125px;" />
		<col style="width:208px;" />
		<col style="width:125px;" />
		<col style="width:208px;" />
	</colgroup>
	<tr>
		<th scope="row">의사수</th>
		<td>
			<input type="text" name="doctor_count" id="doctor_count" title="의사수 입력"  />
		</td>
		<th scope="row">간호사수</th>
		<td>
			<input type="text" name="nurse_count" id="nurse_count" title="간호사수 입력"  />
		</td>
		
		<th scope="row" style="display:none">간호등급</th>
		<td style="display:none">
			<input type="text" name="care_grade" id="care_grade" title="간호등급 입력"  />
		</td>
		
		<th scope="row">응급의료기관종류</th>
		<td>
			<select name="emergency_type_code" id="emergency_type_code" title="응급의료기관종류 선택">
				<option>선택</option>
			</select>
		</td>
	</tr>
	<tr>
		<th scope="row">신규&#47;기존</th>
		<td>
			<select name="new_code" id="new_code" title="신규/기존 선택">
				<option>신규</option>
			</select>
		</td>
		<th scope="row" style="display:none">기존전산업체</th>
		<td colspan="3" style="display:none">
			<input type="text" name="old_company_nm" id="old_company_nm" title="기존전산업체 입력" class="w168"  />
		</td>
		
		
		<th scope="row">의약품정보업체</th>
		<td colspan ="3">
			<select name="medicine_info_cust_code" id="medicine_info_cust_code" title="의약품정보업체 선택">
				<option>선택</option>
			</select>
		</td>
		
	</tr>
	<tr>
		<th scope="row" style="display:none">일 평균 내원자 수</th>
		<td style="display:none">
			<input type="text" name="come_count" id="come_count" title="일 평균 내원자 수 입력"  />
		</td>
		
		<th scope="row">카드밴사업체</th>
		<td>
			<select name="card_van_cust_code" id="card_van_cust_code" title="카드밴사업체 선택">
				<option>선택</option>
			</select>
		</td>
		
		<th scope="row" style="display:none">평균재원자 수</th>
		<td colspan="3" style="display:none">
			<input type="text" name="average_count" id="average_count" title="평균재원자 수 입력" class="w168"  />
		</td>
		
		<th scope="row">검진연동업체</th>
		<td colspan ="3">
			<select name="examination_cust_code" id="examination_cust_code" title="검진연동 선택">
				<option>선택</option>
			</select>
		</td>
		
	</tr>
	<tr>
		<th scope="row">외부수탁업체</th>
		<td>
			<select name="outside_cust_code" id="outside_cust_code" title="외부수탁업체 선택">
				<option>씨젠의료재단</option>
			</select>
		</td>
		<th scope="row" style="display:none">청구여부</th>
		<td colspan="3" style="display:none">
			<input type="checkbox" name="charge_yn" id="charge_yn" title="청구여부" value="Y" />
		</td>
		
		<th scope="row">팍스연동업체</th>
		<td colspan="3">
			<select name="pasc_cust_code" id="pasc_cust_code" title="팍스연동업체 선택">
				<option>선택</option>
			</select>
		</td>
	</tr>
	<tr>
		<th scope="row">전자동의서업체</th>
		<td>
			<select name=ecfc id="ecfc" title="전자동의서업체 선택">
				<option>선택</option>
			</select>
		</td>
		<th scope="row">키오스크 사용여부</th>
		<td colspan="3">
			<select name="kiosk_usage" id="kiosk_usage" title="키오스크 사용여부 선택">
				<option>선택</option>
			</select>
		</td>
	</tr>
	<tr>
		<th scope="row">심평원 E-FROM<br>사용여부</th>
		<td>
			<select name=eform_usage id="eform_usage" title="심평원 E-FROM 사용여부 선택">
				<option>선택</option>
			</select>
		</td>
		<th scope="row">진료정보교류</th>
		<td colspan="3">
			<select name="hie" id="hie" title="진료정보교류 선택">
				<option>선택</option>
			</select>
		</td>
	</tr>
	<tr>
		<th scope="row">특이사항</th>
		<td colspan="5">
			<input type="text" name="detail_etc" id="detail_etc" title="특이사항 입력" value="" />
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
			<input type="text" name="mtac_contract_dt" id="mtac_contract_dt" title="유지보수계약일자 입력" class="w200 mgr5" value="" />
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
		<th scope="row">백신</th>
		<td colspan="3">
			<div id="vc_wrap"></div>
			<button class="btn_plus mgr5" onclick="addVcCode();"></button>
			<button class="btn_minus" onclick="delVcCode();"></button>
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
		<col style="width:50px" />
		<col span="4" style="width:auto" />
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
<!-- list -->
<div class="tit_bWrap mgb10">
	<h4 class="floatL mgt8">관리비고 내역</h4>
	<span class="floatR">
		<button class="btn_ico_circle_plus_g mgr5" onclick="addNote();"><span>행추가</span></button>
		<button class="btn_ico_stop_g" onclick="delNote();"><span>행삭제</span></button>
	</span>
</div>
<table class="hType mgb20">
	<caption>관리비고 목록</caption>
	<colgroup>
		<col style="width: 35px" />
		<col style="width: 120px" />
		<col style="width:auto" />
		<col style="width: 80px" />
		<col style="width: 80px" />
		<col style="width:auto" />
		
	</colgroup>
	<thead>
		<tr>
			<th scope="col">선택</th>
			<th scope="col">구분</th>
			<th scope="col">내용</th>
			<th scope="col">등록일시</th>
			<th scope="col">등록자</th>
			<th scope="col">비고</th>
		</tr>
	</thead>
	<tbody id="nt_wrap">
	</tbody>
</table>

</form>
<!--// list -->
<div class="btn_wrap">
	<div class="floatL">
		<button type="button" class="btn_ico_list" onclick="javascript:goList();"><span>목록</span></button>
	</div>
	<div class="floatR">
		<button type="button" class="btn_ico_confirm" onclick="goProc();"><span>저장</span></button><button type="button" class="btn_ico_cancel" onclick="javascript:goList();"><span>취소</span></button>
	</div>
</div>