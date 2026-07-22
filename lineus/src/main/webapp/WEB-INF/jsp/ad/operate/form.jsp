<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="egovframework.com.comm.util.CommonExecute"%>
<style>
	.status_bold {color:#0032c3 !important;font-weight:bold;}
	.block_btn {background-color: #f3f3f3 ; }
</style>


<script type="text/javascript">
	
	var wk_cnt = 0; 		//참여인력관리 addcnt
	var cg_cnt = 0; 		//담당자정보 addcnt
	var sv_cnt = 0; 		//서버정보 addcnt
	var nt_cnt = 0; 		//비고정보 addcnt
	
	var paramString = "" ; 
	
	$(document).ready(function(){
		
		$( "#open_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#test_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		/**	select box 정보 처리	*/
		commonCode.getCodeList('OPERATE' , 'OP01' , 'state_type') ; 			/**	상태	   */
		commonCode.getCodeList('PROJECT' , 'PR02' , 'system_code') ; 		/**	유형   */
		commonCode.getCodeList('PROJECT' , 'PR03' , 'package_code') ; 			/**	패키지	   */
		<c:if test="${ vo.pageType ne 'insert'}">initView();</c:if>
		
		
		$("#cust_nm").keydown(function (key) {
		    if(key.keyCode == 13){showLayer();}
	    });
		$("#searchKorName").keydown(function (key) {
		    if(key.keyCode == 13){custList(1);}
	    });
		$("#searchProjectName").keydown(function (key) {
		    if(key.keyCode == 13){projectList(1);}
	    });
		$("#searchCustName").keydown(function (key) {
		    if(key.keyCode == 13){projectList(1);}
	    });
		
	});
	
	function initView() {
		
		$('#cust_nm').attr('readonly','readonly');
		$('#searchCust').css('display','none');
		
		
		var datas = {'oper_seq' : $('#oper_seq').val()} ; 
		common.ajaxCall(datas , '/ad/operate/getOperateInfo.do' , 'setOperateInfo') ; 
	}
	
	
	function setOperateInfo(data) {
		
		
		var info   = typeof data.info 	!='undefined' ? data.info : null ; //기본정보
		var server = typeof data.server !='undefined' ? data.server : null ; //연결서버
		var worker = typeof data.worker !='undefined' ? data.worker : null ; //참여인력
		var charge = typeof data.charge !='undefined' ? data.charge : null ; //담당자정보
		var note   = typeof data.note 	!='undefined' ? data.note : null ; //비고정보
		
		if (info != null) {
			   /* 프로젝트 정보 */
			  $("#cust_nm").val(common.nvl(info.cust_nm,''));      
			  $("#erp_code").val(common.nvl(info.erp_code,''));      
			  $("#cust_address").val(common.nvl(info.cust_address,''));     
			  $("#dam_emp_name").val(common.nvl(info.dam_emp_name,''));   
			  $("#dam_tel_no").val(common.nvl(info.dam_tel_no,'')); 
			   
			  $("#cust_seq").val(common.nvl(info.cust_seq,''));      
			  $("#project_nm").val(common.nvl(info.project_nm,''));      
			  $("#term_start_dt").val(makeDate(common.nvl(info.term_start_dt,'')));   
			  $("#term_end_dt").val(makeDate(common.nvl(info.term_end_dt,''))); 
			  $("#system_nm").val(common.nvl(info.system_nm,''));      
				 
			  
			  $("#open_dt").val(makeDate(common.nvl(info.open_dt,'')));      
			  $("#test_dt").val(makeDate(common.nvl(info.test_dt,'')));    
			  $("#package_code").val(common.nvl(info.package_code,''));  
			  
			  $("#cust_nm").removeClass('w200');
			  $("#system_code").val(common.nvl(info.system_code,''));
			  $("#state_type").val(common.nvl(info.state_type,''));
			  
			  <c:if test="${ vo.pageType ne 'insert'}">
			  	$("#system_code").attr('disabled',true);
			  	$("#system_code").addClass('block_btn');
			  </c:if>
			  
			  /*연결서버*/
			if (server != null && server.length > 0) {
				for (var i=0; i < server.length; i++) {
					var list = server[i];
					var str = '';
					str += '<tr id="tr'+(i+1)+'">';
					str += '<td><input type="checkbox"  class="server_check" cnt="'+(i+1)+'" value="'+common.nvl(list.dtl_seq,'')+'"></td>'; /* 체크박스  */
					str += '<td style="display:none;"><input type="text" id="dtl_seq'+(i+1)+'"  name="dtl_seq'+(i+1)+'" value="'+common.nvl(list.dtl_seq,'')+'" readonly="readonly"></td>'; 
					str += '<td style="display:none;"><input type="text" id="server_seq'+(i+1)+'"  name="server_seq'+(i+1)+'" value="'+common.nvl(list.server_seq,'')+'" readonly="readonly"></td>'; 
					str += '<td><input type="text" name="server_type_nm'+(i+1)+'" id="server_type_nm'+(i+1)+'" title="사용용도" value="'+common.nvl(list.server_type_nm,'')+'"  readonly="readonly"/></td>'; /* 참여기간 */
					str += '<td><input type="text" name="server_nm'+(i+1)+'" id="server_nm'+(i+1)+'" title="사용명" value="'+common.nvl(list.server_nm,'')+'" readonly="readonly"/></td>';
					str += '<td><input type="text" name="os_nm'+(i+1)+'" id="os_nm'+(i+1)+'" title="OS" value="'+common.nvl(list.os_nm,'')+'" readonly="readonly"/></td>';
					str += '<td><input type="text" name="server_ip'+(i+1)+'" id="server_ip'+(i+1)+'" title="IP(내부)" value="'+common.nvl(list.server_ip,'')+'" readonly="readonly"/></td>';
					str += '<td><input type="text" name="pb_ip'+(i+1)+'" id="pb_ip'+(i+1)+'" title="IP(공용)"  value="'+common.nvl(list.pb_ip,'')+'" readonly="readonly"/></td>';
					str += '<td><input type="text" name="server_status_nm'+(i+1)+'" id="server_status_nm'+(i+1)+'" title="서버상태" value="'+common.nvl(list.server_status_nm,'')+'"  readonly="readonly"/></td>';
					str += '<td><input type="text" name="main_mng_nm'+(i+1)+'" id="main_mng_nm'+(i+1)+'" title="담당주체" value="'+common.nvl(list.main_mng_nm,'')+'" readonly="readonly"/></td>';
					str += '<td><input type="text" name="emp_nm'+(i+1)+'" id="emp_nm'+(i+1)+'" title="담당자명" value="'+common.nvl(list.emp_nm,'')+'" readonly="readonly"/></td>';
					str += '</tr>';
					$('#server_tb #sv_wrap').append(str);
											
				}
				sv_cnt = server.length;
			}
			
			/*운영인력*/
			if (worker != null && worker.length > 0) {
				for (var i=0; i < worker.length; i++) {
					var list = worker[i];
					
					var str = '';
					str += '<tr id="tr'+(i+1)+'" >';
					str += '<td><input type="checkbox" class="worker_check"cnt="'+(i+1)+'"  value="'+common.nvl(list.wk_seq,'')+'"></td>';
					//str += '<td><input type="checkbox" disabled readonly  class="worker_check"cnt="'+(i+1)+'"  value="'+common.nvl(list.wk_seq,'')+'"></td>';					
					str += '<td style="display:none;"><input type="text" id="wk_seq'+(i+1)+'"  name="wk_seq'+(i+1)+'" value="'+common.nvl(list.wk_seq,'')+'"></td>'; 
					str += '<td style="display:none;"><input type="text" id="wk_emp_no'+(i+1)+'" class="wk_emp_no"  name="wk_emp_no'+(i+1)+'" value="'+common.nvl(list.wk_emp_no,'')+'"></td>'; 
					str += '<td>';
					str += '	<select name="task_code'+(i+1)+'" id="task_code'+(i+1)+'" class="task_code" title="시스템업무 구분 선택" onchange="javascript:masterWkChValidate(\''+(i+1)+'\');">';
					str += '	</select>';
					str += '</td>';
					str += '<td><input type="text" name="worker_nm'+(i+1)+'" id="worker_nm'+(i+1)+'" value="'+ common.nvl(list.worker_nm , '')+'" title="담당자명 입력" readonly="readonly" style="width:80%" class="mgr5" />';
					str += 		'<button type="button" class="btn_ico_search_s" onclick="javascript:showEmpLayer(\''+(i+1)+'\');"><span></span></button>';
					//str += 		'<button type="button" class="btn_ico_search_s"><span></span></button>';
					str += '</td>';
					str += '<td><input type="text" name="worker_dept2_nm'+(i+1)+'" id="worker_dept2_nm'+(i+1)+'" title="담당자 팀명" readonly="readonly" value="'+ common.nvl(list.worker_dept2_nm , '-')+'"/></td>';
					str += '<td><input type="text" name="wk_hp_no'+(i+1)+'" id="wk_hp_no'+(i+1)+'" title="연락처 입력"value="'+ common.nvl(list.wk_hp_no , '')+'" /></td>';
					str += '<td><input type="text" name="wk_email'+(i+1)+'" id="wk_email'+(i+1)+'" title="이메일 입력" value="'+ common.nvl(list.wk_email , '')+'"/></td>';
					
					if( common.nvl(list.master_yn , '') == 'Y'){
						str += '<td><input type="checkbox" class="mCheckBox" name="master_yn'+(i+1)+'" id="master_yn'+(i+1)+'" value="1" checked="checked" onchange="javascript:masterWkChValidate(\''+(i+1)+'\');"/></td>';
					}else{
						str += '<td><input type="checkbox" class="mCheckBox" name="master_yn'+(i+1)+'" id="master_yn'+(i+1)+'" value="0" onchange="javascript:masterWkChValidate(\''+(i+1)+'\');"/></td>';
					}
					str += '<td><input type="text" name="wk_etc'+(i+1)+'" id="wk_etc'+(i+1)+'" title="비고"  value="'+ common.nvl(list.wk_etc , '')+'"/></td>';
					
					
					str += '<td><select  name="is_use'+(i+1)+'" id="is_use'+(i+1)+'" class="is_use" title="사용여부"></select></td>';
					
					
					str += '</tr>';
					$('#worker_tb #wk_wrap').append(str);
					
					commonCode.getCodeList('OPERATE' , info.system_code , 'task_code' +(i+1)) ; 	/**	담당구분		*/
					commonCode.getCodeList('COMMON' ,  'CD05' , 'is_use' +(i+1)) ; 			/**	사용여부		*/
					$('#task_code'+(i+1)).val(list.task_code);
					$('#is_use'+(i+1)).val(list.is_use);
					
					 <c:if test="${ vo.pageType ne 'insert'}">
					  	$("#task_code"+(i+1)).attr('disabled',true);
					  </c:if>
					
				}
				wk_cnt = worker.length;		
			}
			
			/*담당자*/
			if (charge != null && charge.length > 0) {
				for (var i=0; i < charge.length; i++) {
					var list = charge[i];
					
					var str = '';
					str += '<tr id="tr'+(i+1)+'" >';
					str += '<td><input type="checkbox"  class="charge_check"cnt="'+(i+1)+'" value="'+common.nvl(list.ch_seq,'')+'"></td>';
					str += '<td style="display:none;"><input type="text" id="ch_seq'+(i+1)+'"  name="ch_seq'+(i+1)+'" value="'+common.nvl(list.ch_seq,'')+'"></td>'; 
					
					str += '<td>';
					str += '	<select name="charge_code'+(i+1)+'" id="charge_code'+(i+1)+'" title="담당 구분 선택">';
					str += '		<option value=""></option>';
					str += '	</select>';
					str += '</td>';
					str += '<td><input type="text" name="company_nm'+(i+1)+'" id="company_nm'+(i+1)+'" title="소속명 입력" value="'+ common.nvl(list.company_nm , '')+'" /></td>';
					str += '<td><input type="text" name="charge_nm'+(i+1)+'" id="charge_nm'+(i+1)+'" title="담당자명 입력"  value="'+ common.nvl(list.charge_nm , '')+'"/></td>';
					str += '<td><input type="text" name="company_tel_no'+(i+1)+'" id="company_tel_no'+(i+1)+'" title="연락처1 입력"  value="'+ common.nvl(list.company_tel_no , '')+'"/></td>';
					str += '<td><input type="text" name="hp_no'+(i+1)+'" id="hp_no'+(i+1)+'" title="연락처2 입력"  value="'+ common.nvl(list.hp_no , '')+'"/></td>';
					str += '<td><input type="text" name="email'+(i+1)+'" id="email'+(i+1)+'" title="이메일 입력"  value="'+ common.nvl(list.email , '')+'"/></td>';
					str += '<td><input type="text" name="ch_etc'+(i+1)+'" id="ch_etc'+(i+1)+'" title="비고"  value="'+ common.nvl(list.ch_etc , '')+'"/></td>';
					str += '</tr>';
					$('#charge_tb #cg_wrap').append(str);
					
					commonCode.getCodeList('PROJECT' , 'PR05' , 'charge_code' +(i+1)) ; 	/**	담당구분		*/
					$('#charge_code'+(i+1)).val(list.charge_code);
				}
				cg_cnt = charge.length;		
			}
			
			/*비고*/
			if (note != null && note.length > 0) {
				for (var i=0; i < note.length; i++) {
					var list = note[i];
					
					var str = '';
					str += '<tr id="tr'+(i+1)+'" >';
					str += '<td><input type="checkbox"  class="note_check"cnt="'+(i+1)+'" value="'+common.nvl(list.nt_seq,'')+'"></td>';
					str += '<td style="display:none;"><input type="text" id="nt_seq'+(i+1)+'"  name="nt_seq'+(i+1)+'" value="'+common.nvl(list.nt_seq,'')+'"></td>'; 
					str += '<td>';
					str += '	<select name="note_code'+(i+1)+'" id="note_code'+(i+1)+'" title="비고 구분 선택">';
					str += '		<option value=""></option>';
					str += '	</select>';
					str += '</td>';
					str += '<td><input type="text" name="content'+(i+1)+'" id="content'+(i+1)+'" title="내용 입력" value="'+ common.nvl(list.content , '-')+'" /></td>';
					str += '<td><input type="text" name="reg_nm'+(i+1)+'" id="reg_nm'+(i+1)+'" title="작성자"  value="'+ common.nvl(list.reg_nm , '-')+'" readonly="readonly"/></td>';
					str += '<td><input type="text" name="reg_date'+(i+1)+'" id="reg_date'+(i+1)+'" title="작성일자"  value="'+ common.nvl(list.reg_date , '-')+'"readonly="readonly"/></td>';
					str += '</tr>';
					$('#note_tb #nt_wrap').append(str);
					
					commonCode.getCodeList('OPERATE' , 'OP02' , 'note_code' +(i+1)) ; 	/**	비고구분		*/
					$('#note_code'+(i+1)).val(list.note_code);
				}
				nt_cnt = note.length;		
			}
			
		}
	}
	
	/* 서버 정보 ADD */
	function addServer() {
		var str = '';
		sv_cnt++;
		str += '<tr id="tr'+sv_cnt+'" >';
		str += '<td><input type="checkbox" class="server_check" id="check'+sv_cnt+'" cnt="'+sv_cnt+'" value="" readonly="readonly"></td>';
		str += '<td style="display:none;"><input type="hidden" name="dtl_seq'+sv_cnt+'" id="dtl_seq'+sv_cnt+'"/></td>';
		str += '<td style="display:none;"><input type="hidden" name="server_seq'+sv_cnt+'" id="server_seq'+sv_cnt+'"/></td>';
		str += '<td><input type="text" name="server_type_nm'+sv_cnt+'" id="server_type_nm'+sv_cnt+'" title="사용용도 입력" readonly="readonly"/></td>';
		str += '<td>';
		str += 		'<input type="text" name="server_nm'+sv_cnt+'" id="server_nm'+sv_cnt+'" title="사용명칭 입력" class="mgr5" readonly="readonly" style="width:80%;"/>';
		str += 		'<button type="button" class="btn_ico_search_s" onclick="showServerLayer('+sv_cnt+');"><span></span></button>';
		str += '</td>';
		str += '<td><input type="text" name="os_nm'+sv_cnt+'" id="os_nm'+sv_cnt+'" title="os" readonly="readonly"/></td>';
		str += '<td><input type="text" name="server_ip'+sv_cnt+'" id="server_ip'+sv_cnt+'" title="IP(내부)" readonly="readonly"/></td>';
		str += '<td><input type="text" name="pb_ip'+sv_cnt+'" id="pb_ip'+sv_cnt+'" title="IP(공인)" readonly="readonly"/></td>';
		str += '<td><input type="text" name="server_status_nm'+sv_cnt+'" id="server_status_nm'+sv_cnt+'" title="서버상태" readonly="readonly"/></td>';
		str += '<td><input type="text" name="main_mng_nm'+sv_cnt+'" id="main_mng_nm'+sv_cnt+'" title="관리주체" readonly="readonly"/></td>';
		str += '<td><input type="text" name="emp_nm'+sv_cnt+'" id="emp_nm'+sv_cnt+'" title="관리자명" readonly="readonly"/></td>';
		str += '</tr>';
		$('#server_tb #sv_wrap').append(str);
	}
	
	function delServer() {
		if ($('#sv_wrap input[type=checkbox]:checked').length == 0) { 
			alert('삭제할 행을 선택하세요.');
			return;
		}
		$('#sv_wrap input[type=checkbox]:checked').each(function(){
			if (common.isEmpty($('#del_dtl_seq1').val())) $('#del_dtl_seq1').val($(this).val());
			else $('#del_dtl_seq1').val($('#del_dtl_seq1').val() + "@" + $(this).val());
			$(this).parent().parent('tr').remove();
			sv_cnt = sv_cnt -1;
		});
	}
	
	/* 참여인력 정보 ADD*/
	function addWorker() {
		var str = '';
		wk_cnt++;
		str += '<tr id="tr'+wk_cnt+'" >';
		str += '<td><input type="checkbox" class="worker_check" id="check'+wk_cnt+'" cnt="'+wk_cnt+'" value=""></td>';
		str += '<td style="display:none"><input type="hidden" id="wk_emp_no'+wk_cnt+'" class="wk_emp_no" name="wk_emp_no'+wk_cnt+'"></td>';
		str += '<td>';
		str += '	<select class="task_code" name="task_code'+wk_cnt+'" class="task_code" id="task_code'+wk_cnt+'" title="시스템업무 구분 선택" onchange="javascript:masterWkChValidate(\''+(wk_cnt)+'\');">';
		str += '	</select>';
		str += '</td>';
		str += '<td><input type="text" name="worker_nm'+wk_cnt+'" id="worker_nm'+wk_cnt+'" title="담당자명 입력" readonly="readonly" style="width:80%" class="mgr5" />';
		str += 		'<button type="button" class="btn_ico_search_s" onclick="javascript:showEmpLayer(\''+wk_cnt+'\');"><span></span></button>';
		str += '</td>';
		str += '<td><input type="text" name="worker_dept2_nm'+wk_cnt+'" id="worker_dept2_nm'+wk_cnt+'" title="담당자 팀명" readonly="readonly"/></td>';
		str += '<td><input type="text" name="wk_hp_no'+wk_cnt+'" id="wk_hp_no'+wk_cnt+'" title="연락처 입력" /></td>';
		str += '<td><input type="text" name="wk_email'+wk_cnt+'" id="wk_email'+wk_cnt+'" title="이메일 입력" /></td>';
		str += '<td><input type="checkbox" class="mCheckBox" name="master_yn'+wk_cnt+'" id="master_yn'+wk_cnt+'" value="1" checked="checked" onchange="javascript:masterWkChValidate(\''+wk_cnt+'\');"/></td>';
		//str += '<td><input type="checkbox" name="check-3" value="3" class="lcs_check" checked="checked" id="switch" autocomplete="off" /></td>';
		str += '<td><input type="text" name="wk_etc'+wk_cnt+'" id="wk_etc'+wk_cnt+'" title="비고" /></td>';
		str += '<td><select class="is_use" name="is_use'+wk_cnt+'" id="is_use'+wk_cnt+'" title="사용여부" onchange="javascript:IsUseGubun(this);"/></select></td>';
		str += '</tr>';
		$('#worker_tb #wk_wrap').append(str);
		
		var system_code = $('#system_code').val();
		commonCode.getCodeList('OPERATE' , system_code , 'task_code' +wk_cnt) ; 	/**	담당구분		*/
		commonCode.getCodeList('COMMON' , 'CD05' , 'is_use' +wk_cnt) ; 	/**	담당구분		*/
	}
	
	
	function delWorker() {
		if ($('#wk_wrap .worker_check:checked').length == 0) { 
			alert('삭제할 행을 선택하세요.');
			return;
		}
		$('#wk_wrap .worker_check:checked').each(function(){
			if (common.isEmpty($('#del_dtl_seq2').val())) $('#del_dtl_seq2').val($(this).val());
			else $('#del_dtl_seq2').val($('#del_dtl_seq2').val() + "@" + $(this).val());
			$(this).parent().parent('tr').remove();
			wk_cnt = wk_cnt -1;
		});
	}
	
	function IsUseGubun(){
		
	}
	
	
	/* 담당자 정보 ADD */
	function addCharge() {
		var str = '';
		cg_cnt++;
		str += '<tr id="tr'+cg_cnt+'" >';
		str += '<td><input type="checkbox" class="charge_check" id="check'+cg_cnt+'" cnt="'+cg_cnt+'" value=""></td>';
		str += '<td>';
		str += '	<select name="charge_code'+cg_cnt+'" id="charge_code'+cg_cnt+'" title="담당 구분 선택">';
		str += '		<option value="">결제관련 결정</option>';
		str += '	</select>';
		str += '</td>';
		str += '<td><input type="text" name="company_nm'+cg_cnt+'" id="company_nm'+cg_cnt+'" title="소속명 입력" /></td>';
		str += '<td><input type="text" name="charge_nm'+cg_cnt+'" id="charge_nm'+cg_cnt+'" title="담당자명 입력" /></td>';
		str += '<td><input type="text" name="company_tel_no'+cg_cnt+'" id="company_tel_no'+cg_cnt+'" title="연락처1 입력" /></td>';
		str += '<td><input type="text" name="hp_no'+cg_cnt+'" id="hp_no'+cg_cnt+'" title="연락처2 입력" /></td>';
		str += '<td><input type="text" name="email'+cg_cnt+'" id="email'+cg_cnt+'" title="이메일 입력" /></td>';
		str += '<td><input type="text" name="ch_etc'+cg_cnt+'" id="ch_etc'+cg_cnt+'" title="비고" /></td>';
		str += '</tr>';
		$('#charge_tb #cg_wrap').append(str);
		
		commonCode.getCodeList('PROJECT' , 'PR05' , 'charge_code' +cg_cnt) ; 	/**	담당구분		*/
		
		
	}
	
	function delCharge() {
		if ($('#cg_wrap input[type=checkbox]:checked').length == 0) { 
			alert('삭제할 행을 선택하세요.');
			return;
		}
		$('#cg_wrap input[type=checkbox]:checked').each(function(){
			if (common.isEmpty($('#del_dtl_seq3').val())) $('#del_dtl_seq3').val($(this).val());
			else $('#del_dtl_seq3').val($('#del_dtl_seq3').val() + "@" + $(this).val());
			$(this).parent().parent('tr').remove();
			cg_cnt = cg_cnt -1; 
		});
	}
	
	
	/*관리내역*/
	function addNote(){
		
		var str = '';
		nt_cnt++;
		str += '<tr id="tr'+nt_cnt+'" >';
		str += '<td><input type="checkbox" class="charge_check" id="check'+nt_cnt+'" cnt="'+nt_cnt+'" value=""></td>';
		str += '<td>';
		str += '	<select name="note_code'+nt_cnt+'" id="note_code'+nt_cnt+'" title="관리내용 구분 선택">';
		str += '	</select>';
		str += '</td>';
		str += '<td><input type="text" name="content'+nt_cnt+'" id="content'+nt_cnt+'" title="내용 입력" /></td>';
		str += '<td><input type="text" name="reg_id'+nt_cnt+'" id="reg_id'+nt_cnt+'" title="등록자" readonly="readonly"/></td>';
		str += '<td><input type="text" name="reg_date'+nt_cnt+'" id="reg_date'+nt_cnt+'" title="등록일 입력" readonly="readonly" /></td>';
		str += '</tr>';
		$('#note_tb #nt_wrap').append(str);
		
		commonCode.getCodeList('OPERATE' , 'OP02' , 'note_code' +nt_cnt) ; 	/**	담당구분		*/
		
	}
	
	function delNote(){
		
		if ($('#nt_wrap input[type=checkbox]:checked').length == 0) { 
			alert('삭제할 행을 선택하세요.');
			return;
		}
		$('#nt_wrap input[type=checkbox]:checked').each(function(){
			if (common.isEmpty($('#del_dtl_seq4').val())) $('#del_dtl_seq4').val($(this).val());
			else $('#del_dtl_seq4').val($('#del_dtl_seq4').val() + "@" + $(this).val());
			$(this).parent().parent('tr').remove();
			nt_cnt = nt_cnt -1; 
		});
		
	}
	
	
	function goProc(){
		
		var cust_nm = $('#cust_nm');
		var epr_code = $('#erp_code');
		var project_nm = $('#project_nm');
		var system_nm = $('#system_nm');
		var system_code = $('#system_code');
		var state_type = $('#state_type');
		
			
		if (cust_nm.val()=='') {
			alert('거래처명을 조회하세요.');
			cust_nm.focus();
			return;
		}
		
		if (epr_code.val()=='') {
			alert('거래처코드를 입력하세요.');
			epr_code.focus();
			return;
		}
		
		/* if (project_nm.val()=='') {
			alert('프로젝트명을 입력하세요.');
			project_nm.focus();
			return;
		} */
		
		if (system_code.val()=='') {
			alert('시스템유형을 선택하세요.');
			system_code.focus();
			return;
		}
		
		if (system_nm.val()=='') {
			alert('시스템명을 입력하세요.');
			system_nm.focus();
			return;
		}
		if (state_type.val()=='') {
			alert('유지보수 거래상태를 선택하세요.');
			state_type.focus();
			return;
		}
		
	   var returnVali = true;
	   $('#worker_tb tbody tr').each(function(){
			var task_code = $(this).find('.task_code');
			var wk_emp_no = $(this).find('.wk_emp_no');
			var is_use = $(this).find('.is_use');
			task_code.attr('disabled',false);
			if(task_code.val() == ""){alert('유지보수 담당자 정보의 시스템업무 구분을 선택하세요.'); task_code.focus;returnVali =false; return;}
			else if(wk_emp_no.val() == ""){alert('유지보수 담당자 정보의 담당자를 조회하세요.'); wk_emp_no.focus; returnVali =false;return;}
			else if(is_use.val() == ""){alert('유지보수 담당자 정보의 사용여부를 선택하세요.'); is_use.focus; returnVali =false;return;};
			
		});
		
	   
	   if(returnVali ==false){ return;}
	   var taskArr =[];
	   var masterArr = [];
	   $('#wk_wrap > tr').each(function(i,e){
			var i = i+1;
			var currentTaskVal = $('#task_code'+i).val();
			var currentUseVal = $('#is_use'+i).val();
			var currentCehckVal = $('#master_yn'+i).is(":checked") == true ? '1' : '0';
			/*  업무유형 arr - 사용여부 (예)*/
			if(currentTaskVal !='' && currentUseVal == 'C001'){
				taskArr.push(currentTaskVal);
				if(currentCehckVal == '1'){masterArr.push(currentTaskVal);}
			}
		});
		
		var uniqueTask =[];
		$.each(taskArr,function(i,el){
			if($.inArray(el,uniqueTask)==-1)uniqueTask.push(el);
		}); 
		
		console.log(uniqueTask);
		if(uniqueTask.length >  masterArr.length){alert('유지보수 담당자 정보의 대표담당자를 지정 하세요.');return;}
		
	   $('#system_code').attr('disabled',false);
	   if(returnVali){
			var f = document.procFrm;
			f.pageType.value = '${vo.pageType}';
			f.sv_cnt.value = sv_cnt ;
			f.cg_cnt.value = cg_cnt ;
			f.wk_cnt.value = wk_cnt ;
			f.nt_cnt.value = nt_cnt ;
			
			common.ajaxCall($('form[name=procFrm]').serialize() , '/ad/operate/proc.do' , 'procReturn') ;  
		}else{
			return;
		}
	}
	
	function procReturn(data){
		var returnCode = typeof data.returnCode != "undefined" ? data.returnCode : "002" ; 
		var msg = "" ; 
		
		if(returnCode == "000") msg = "정상적으로 처리 되었습니다." ; 
		else if(returnCode == "001") msg = "비정상적으로 처리 되었습니다." ; 
		else if(returnCode == "002") msg = "처리도중 오류가 발생했습니다." ;
		
		alert(msg) ; 
		if(returnCode == "000") {
			location.href = "/ad/operate/list.do" 
		}
	}
	
	function goList() {
		var f = document.procFrm;
		f.action = '/ad/operate/list.do' + window.location.search.substring();
		f.submit();	
	}
	
	
	/**	거래처 조회	*/
	function showLayer(){
		$('#div1').show() ;
		$('#div1').css('height' , '710') ; 
		$('#div_dim').show() ;
		$('#searchKorName').val($('#cust_nm').val());
		custList(1) ; 
		$('#searchKorName').attr( 'autofocus','autofocus');
		$('[autofocus]:not(:focus)').eq(0).focus();
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
				str += '	<td>'+common.nvl(datas.cust_kor_name , '')+'['+common.nvl(datas.erp_code , '')+']</td> ' ;
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
	
	function setValue(seq){
		var datas = {'seq' 				: seq }
		common.ajaxCall(datas , '/ad/member/getCustInfo.do', 'makeCustInfo') ;
		closeLayer() ; 
	}
	
	function makeCustInfo(data){
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null ; 
		$('#cust_seq').val(common.nvl(resultVO.seq, '')) ; 
		$('#cust_nm').val(common.nvl(resultVO.cust_kor_name, '')) ; 
		$('#cust_info #erp_code').val(common.nvl(resultVO.erp_code, '')) ; 
		$('#cust_address').val(common.nvl(resultVO.cust_address, '')) ; 
		$('#cust_post_no').val(common.nvl(resultVO.zip_code, '')) ; 
		$('#dam_emp_name').val(common.nvl(resultVO.emp_name, '')) ; 
		$('#dam_tel_no').val(common.nvl(resultVO.tel_no, '')) ;
		
	}
	
	function closeLayer() {
		$('#div1').hide() ; 
		$('#div_dim').hide() ; 
		$('#searchKorName').val('') ; 
		$("#searchKorName").removeAttr( "autofocus" );
	}
	
	
	
	
	
	
	/**	서버 조회	*/
	function showServerLayer(rownum){
		$('#div2').show() ;
		$('#div2').css('height' , '710') ; 
		$('#div_dim2').show() ; 
		serverList(1) ; 
		$('#searchServerName').attr( 'autofocus','autofocus');
		$('[autofocus]:not(:focus)').eq(0).focus();
		$('#div2 #rownum').val(rownum);
	}
	
	function serverList(custPage){
		var datas = {
				'page' : custPage , 
				'search_text' : $('#searchServerName').val(),
				'search_type13' : $('#ipNumber').val()
		}
		
		common.ajaxCall(datas , '/ad/server/getServerList.do', 'makeServerList') ;
	}
	
	function makeServerList(data){
		$('#serverInfoList').empty() ; 
		$('#layer_pagination2').empty() ; 
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var vo = typeof data.vo != "undefined" ? data.vo : null ; 
		
		if(resultList != null && resultList.length > 0){
			var str = '' ; 
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ;
				str += "<tr onclick=\"setServerValue('" + datas.seq + "', '"+ datas.cust_seq +"');\" style=\"cursor:pointer;\">" ;
				str += '	<td>'+common.nvl(datas.rnum , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.cust_kor_name , '')+'['+common.nvl(datas.erp_code , '')+']</td> ' ;
				str += '	<td>'+common.nvl(datas.server_nm , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.server_type_nm , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.server_ip , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.pb_ip , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.server_status_nm , '')+'</td> ' ;
				str += '</tr> ' ;
			}
			$('#serverInfoList').append(str) ; 
			$('#layer_pagination2').html(vo.json_paging) ; 
		}else{
			commonTable.notData(9 , '조회된 정보가 없습니다.' , 'serverInfoList') ; 
		}
	}
	
	function setServerValue(seq,cust_seq){
		var datas = {'seq': seq, 'cust_seq' : cust_seq}
		common.ajaxCall(datas , '/ad/server/getServerInfo2.do', 'makeServerInfo') ;
		closeLayer2() ; 
	}
	
	function makeServerInfo(data){
		var info = typeof data.info != "undefined" ? data.info : null ; 
		var row_cnt = $('#div2 #rownum').val();
		$('#server_type_nm'+row_cnt).val(common.nvl(info.server_type_nm, '')) ; 
		$('#server_nm'+row_cnt).val(common.nvl(info.server_nm, '')) ; 
		$('#os_nm'+row_cnt).val(common.nvl(info.os_nm, '')) ; 
		$('#server_ip'+row_cnt).val(common.nvl(info.server_ip, '')) ; 
		$('#pb_ip'+row_cnt).val(common.nvl(info.pb_ip, '')) ; 
		$('#server_status_nm'+row_cnt).val(common.nvl(info.server_status_nm, '')) ; 
		$('#main_mng_nm'+row_cnt).val(common.nvl(info.main_mng_nm, '')) ;
		$('#emp_nm'+row_cnt).val(common.nvl(info.emp_nm, '')) ;
		$('#server_seq'+row_cnt).val(common.nvl(info.seq, '')) ;
	}
	
	function closeLayer2() {
		$('#div2').hide() ; 
		$('#div_dim2').hide() ; 
		$('#searchServerName').val('') ; 
		$("#searchServerName").removeAttr( "autofocus" );
	}

	
	
	/**	프로젝트 조회	*/
	function showProjectLayer(rownum){
		$('#div3').show() ;
		$('#div3').css('height' , '710') ; 
		$('#div_dim3').show() ; 
		projectList(1) ; 
		$('#searchProjectName').attr( 'autofocus','autofocus');
		$('[autofocus]:not(:focus)').eq(0).focus();
	}
	
	function projectList(projectPage){
		var datas = {
				'page' : projectPage,
				'search_text' :$('#searchProjectName').val(),
				'search_type3' :$('#searchCustName').val()
		}
		
		common.ajaxCall(datas , '/ad/project/getProjectList.do', 'makeProjectList') ;
	}
	
	function makeProjectList(data){
		$('#projectInfoList').empty() ; 
		$('#layer_pagination3').empty() ; 
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var vo = typeof data.vo != "undefined" ? data.vo : null ; 
		
		if(resultList != null && resultList.length > 0){
			var str = '' ; 
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ;
				str += "<tr onclick=\"setProjectValue('" + datas.pro_seq + "', '"+ datas.cust_seq +"');\" style=\"cursor:pointer;\">" ;
				str += '	<td>'+common.nvl(datas.rnum , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.cust_kor_name , '')+'['+common.nvl(datas.erp_code , '')+']</td> ' ;
				str += '	<td>'+common.nvl(datas.project_nm , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.system_code_nm , '')+'</td> ' ;
				str += '	<td>'+makeDate(common.nvl(datas.term_start_dt, '-')) + ' ~ ' + makeDate(common.nvl(datas.term_end_dt, '-')) +'</td> ' ;
				if ( common.nvl(datas.state_type, '-') == "C001" ){
					str += "	<td class='status_bold'>" + common.nvl(datas.state_type_nm, '-') + "</td>" ;
				}else{
					str += "	<td>" + common.nvl(datas.state_type_nm, '-') + "</td>" ;
					
				}
				str += '</tr> ' ;
			}
			$('#projectInfoList').append(str) ; 
			$('#layer_pagination3').html(vo.json_paging) ; 
		}else{
			commonTable.notData(9 , '조회된 정보가 없습니다.' , 'projectInfoList') ; 
		}
	}
	
	function setProjectValue(pro_seq,cust_seq){
		var datas = {'pro_seq': pro_seq}
		common.ajaxCall(datas , '/ad/project/getProjectInfo.do', 'setProjectInfo') ;
		closeLayer3() ; 
	}
	
	function setProjectInfo(data) {
		
		var info = typeof data.info !='undefined' ? data.info : null ; //기본정보
		var server = typeof data.server !='undefined' ? data.server : null ; //연결서버
		var charge = typeof data.charge !='undefined' ? data.charge : null ; //담당자정보
		
		
		if (info != null) {
			  
				goReset();
			
			   /* 프로젝트정보 -> 운영 정보 */
			  $("#cust_nm").val(common.nvl(info.cust_nm,''));      
			  $("#erp_code").val(common.nvl(info.erp_code,''));      
			  $("#cust_address").val(common.nvl(info.cust_address,''));     
			  $("#dam_emp_name").val(common.nvl(info.dam_emp_name,''));   
			  $("#dam_tel_no").val(common.nvl(info.dam_tel_no,'')); 
			   
			  $("#cust_seq").val(common.nvl(info.cust_seq,''));      
			  $("#project_nm").val(common.nvl(info.project_nm,''));      
			 
			  
			  $("#system_code").val(common.nvl(info.system_code,'')); 
			  
			  $("#open_dt").val(makeDate(common.nvl(info.open_dt,'')));      
			  $("#test_dt").val(makeDate(common.nvl(info.test_dt,'')));    
			  $("#package_code").val(common.nvl(info.package_code,''));  
			  
			  /*연결서버*/
			if (server != null && server.length > 0) {
				for (var i=0; i < server.length; i++) {
					var list = server[i];
					var str = '';
					str += '<tr id="tr'+(i+1)+'">';
					str += '<td><input type="checkbox"  class="server_check" cnt="'+(i+1)+'" value="'+common.nvl(list.dtl_seq,'')+'"></td>'; /* 체크박스  */
					str += '<td style="display:none;"><input type="text" id="dtl_seq'+(i+1)+'"  name="dtl_seq'+(i+1)+'" value="" readonly="readonly"></td>'; 
					str += '<td style="display:none;"><input type="text" id="server_seq'+(i+1)+'"  name="server_seq'+(i+1)+'" value="'+common.nvl(list.server_seq,'')+'" readonly="readonly"></td>'; 
					str += '<td><input type="text" name="server_type_nm'+(i+1)+'" id="server_type_nm'+(i+1)+'" title="사용용도" value="'+common.nvl(list.server_type_nm,'')+'"  readonly="readonly"/></td>'; /* 참여기간 */
					str += '<td><input type="text" name="server_nm'+(i+1)+'" id="server_nm'+(i+1)+'" title="사용명" value="'+common.nvl(list.server_nm,'')+'" readonly="readonly"/></td>';
					str += '<td><input type="text" name="os_nm'+(i+1)+'" id="os_nm'+(i+1)+'" title="OS" value="'+common.nvl(list.os_nm,'')+'" readonly="readonly"/></td>';
					str += '<td><input type="text" name="server_ip'+(i+1)+'" id="server_ip'+(i+1)+'" title="IP(내부)" value="'+common.nvl(list.server_ip,'')+'" readonly="readonly"/></td>';
					str += '<td><input type="text" name="pb_ip'+(i+1)+'" id="pb_ip'+(i+1)+'" title="IP(공용)"  value="'+common.nvl(list.pb_ip,'')+'" readonly="readonly"/></td>';
					str += '<td><input type="text" name="server_status_nm'+(i+1)+'" id="server_status_nm'+(i+1)+'" title="서버상태" value="'+common.nvl(list.server_status_nm,'')+'"  readonly="readonly"/></td>';
					str += '<td><input type="text" name="main_mng_nm'+(i+1)+'" id="main_mng_nm'+(i+1)+'" title="담당주체" value="'+common.nvl(list.main_mng_nm,'')+'" readonly="readonly"/></td>';
					str += '<td><input type="text" name="emp_nm'+(i+1)+'" id="emp_nm'+(i+1)+'" title="담당자명" value="'+common.nvl(list.emp_nm,'')+'" readonly="readonly"/></td>';
					str += '</tr>';
					$('#server_tb #sv_wrap').append(str);
											
				}
				sv_cnt = server.length;
			}
			
			/*담당자*/
			if (charge != null && charge.length > 0) {
				for (var i=0; i < charge.length; i++) {
					var list = charge[i];
					
					var str = '';
					str += '<tr id="tr'+(i+1)+'" >';
					str += '<td><input type="checkbox"  class="charge_check"cnt="'+(i+1)+'" value=""></td>';
					str += '<td style="display:none;"><input type="text" id="ch_seq'+(i+1)+'"  name="ch_seq'+(i+1)+'" value=""></td>'; 
					
					str += '<td>';
					str += '	<select name="charge_code'+(i+1)+'" id="charge_code'+(i+1)+'" title="담당 구분 선택">';
					str += '		<option value=""></option>';
					str += '	</select>';
					str += '</td>';
					str += '<td><input type="text" name="company_nm'+(i+1)+'" id="company_nm'+(i+1)+'" title="소속명 입력" value="'+ common.nvl(list.company_nm , '-')+'" /></td>';
					str += '<td><input type="text" name="charge_nm'+(i+1)+'" id="charge_nm'+(i+1)+'" title="담당자명 입력"  value="'+ common.nvl(list.charge_nm , '-')+'"/></td>';
					str += '<td><input type="text" name="company_tel_no'+(i+1)+'" id="company_tel_no'+(i+1)+'" title="연락처1 입력"  value="'+ common.nvl(list.company_tel_no , '-')+'"/></td>';
					str += '<td><input type="text" name="hp_no'+(i+1)+'" id="hp_no'+(i+1)+'" title="연락처2 입력"  value="'+ common.nvl(list.hp_no , '-')+'"/></td>';
					str += '<td><input type="text" name="email'+(i+1)+'" id="email'+(i+1)+'" title="이메일 입력"  value="'+ common.nvl(list.email , '-')+'"/></td>';
					str += '<td><input type="text" name="ch_etc'+(i+1)+'" id="ch_etc'+(i+1)+'" title="비고"  value="'+ common.nvl(list.ch_etc , '-')+'"/></td>';
					str += '</tr>';
					$('#charge_tb #cg_wrap').append(str);
					
					commonCode.getCodeList('PROJECT' , 'PR05' , 'charge_code' +(i+1)) ; 	/**	담당구분		*/
					$('#charge_code'+(i+1)).val(list.charge_code);
				}
				cg_cnt = charge.length;		
			}
		}
	}
	
	function closeLayer3() {
		$('#div3').hide() ; 
		$('#div_dim3').hide() ; 
		$('#searchProjectName').val('') ; 
		$("#searchProjectName").removeAttr( "autofocus" );
	}

	
	
	/* 유지보수담당자 조회 */
	function showEmpLayer(num){
		$('#div6').show() ; 
		$('#div6_dim').show() ; 
		charList(1) ; 
		$("#searchCharName").attr( "autofocus","autofocus" );
		$('[autofocus]:not(:focus)').eq(0).focus();
		$("#div6 #rowNum").val(num); 
	}
	
	function charList(charPage){
		
		var datas = {
				'page' : charPage ,
				'emp_nm' : $('#searchCharName').val() ,
				'search_type2' : 'Y' 	 				
		};
		common.ajaxCall(datas , '/ad/cust/getEmpList.do', 'makeCharList') ;
	}
	
	
	function makeCharList(data){
		
		$('#charInfoList').empty() ; 
		$('#layer_pagination6').empty() ; 
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var vo = typeof data.vo != "undefined" ? data.vo : null ; 
		
		if(resultList != null && resultList.length > 0){
			var str = '' ; 
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ;
				var empty1 = "'"+datas.emp_no+"'";
				var empty2 = "'"+datas.emp_nm+"'";
				var empty3 = "'"+datas.dept2_nm+"'";
				var empty4 = "'"+datas.e_mail+"'";
				var empty5 = "'"+datas.mobile_no+"'";
				str += '<tr onclick="javascript:setValueChar('+ empty1 +','+ empty2 +','+ empty3 +','+ empty4 +','+ empty5 +');" style="cursor:pointer;"> ' ;
				str += '	<td>'+common.nvl(datas.rnum , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.dept1_nm , '')+"/"+common.nvl(datas.dept2_nm , '') + '</td> ' ;
				str += '	<td>'+common.nvl(datas.emp_no , '')+ '</td> ' ;
				str += '	<td>'+common.nvl(datas.emp_nm , '')+ '</td> ' ;
				str += '	<td>'+common.nvl(datas.dept_grade_nm , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.e_mail , '')+'</td> ' ;
				str += '</tr> ' ;
			}
			$('#charInfoList').append(str) ; 
			$('#layer_pagination6').html(vo.json_paging) ; 
		}else{
			commonTable.notData(7 , '조회된 정보가 없습니다.' , 'charInfoList') ; 
		}
		
	}
	
	function setValueChar(emp_no,emp_nm,dep2_nm,email,tel){
		var rowNum = $("#div6 #rowNum").val();
		$('#worker_tb #worker_nm'+rowNum).val(common.nvl(emp_nm, ''));
		$('#worker_tb #wk_emp_no'+rowNum).val(common.nvl(emp_no, ''));
		$('#worker_tb #worker_dept2_nm'+rowNum).val(common.nvl(dep2_nm, ''));
		$('#worker_tb #wk_hp_no'+rowNum).val(common.nvl(tel, ''));
		$('#worker_tb #wk_email'+rowNum).val(common.nvl(email, ''));
		
		closeLayer6();
	}
	
	function closeLayer6() {
		$('#div6').hide() ; 
		$('#div6_dim').hide() ; 
		$('#searchKorName').val('') ; 
		$('#searchEmpName').val('') ; 
		$("#searchKorName").removeAttr( "autofocus" );
		$("#searchEmpName").removeAttr( "autofocus" );
		$("#searchCharName").removeAttr( "autofocus" );
	}
	
	/*시스템유형 변경 시, 유지보수 담당자 - 시스템 업무구분 리셋*/
	function resetTask(){
		var cnt = 0;
		$('#wk_wrap > tr').each(function() {
			cnt ++
			$(this).children('.task_code').val('');
			var system_code = $('#system_code').val();
			commonCode.getCodeList('OPERATE' , system_code , 'task_code' +cnt) ; 	/**	담당구분		*/
		});
	}
	
	/*시스템업무 당 하나의 대표담당자.*/
	function masterWkChValidate(cnt){
		
		var cntTaskVal = $('#task_code'+cnt).val();
		var cntCheckVal  =  $('#master_yn'+cnt).is(":checked") == true ? '1' : '0';
		if(cntCheckVal == '1'){ $('#master_yn'+cnt).val('1'); }else{ $('#master_yn'+cnt).val('0');}  
		
		if(cntCheckVal == '1' ){
			$('#wk_wrap > tr').each(function(i,e){
				var i = i+1;
				if(cnt != i){
					var currentTaskVal = $('#task_code'+i).val();
					var currentCehckVal = $('#master_yn'+i).is(":checked") == true ? '1' : '0';
					
					if(cntCheckVal == currentCehckVal && cntTaskVal == currentTaskVal){
						if(cntCheckVal != '' && currentCehckVal !=''){
							//체크해제
							$('#master_yn'+i).attr("checked",false);
							$('#master_yn'+i).val('0');
							alert('한 업무당 한명의 대표담당자만 지정 가능합니다.'); return;
							
						}
					} 
				}
				
			});
		}
	}
	
	
	
	
	function goReset(){
		
		$("#cg_cnt").val("");
		$("#sv_cnt").val(""); 
		$("#del_dtl_seq1").val(""); 
		$("#del_dtl_seq3").val(""); 
		$("#sv_wrap").empty();
		$("#cg_wrap").empty();
	}
	
</script>

<div class="tit_wrap">
	<h2 class="tit_ico_customer">운영시스템 관리<span class="tit_depth mgl20 mgt8">운영정보</span></h2>
</div>
<div class="tit_sWrap">
<%-- <h3 class="tit_dot_gray">운영정보 상세 정보<c:if test="${ vo.pageType ne 'insert' }">&nbsp;&lt;<span class="colorBlue mg15" style="line-height:25px;">${ vo.cust_kor_name }, ${ vo.erp_code }</span>&gt;</c:if></h3>
 --%>
 </div>
<!-- tab -->
	
<form name="procFrm" method="post" onsubmit="return false;">
	<input type="hidden" name="oper_seq"  	id="oper_seq"       value="${ vo.oper_seq }"/>
	<input type="hidden" name="pageType"    id="pageType" 	    value="${ vo.pageType }"/>
	<input type="hidden" name="cg_cnt"  	id="cg_cnt" 		value=""/>
	<input type="hidden" name="wk_cnt"  	id="wk_cnt" 		value=""/>
	<input type="hidden" name="sv_cnt"  	id="sv_cnt" 		value=""/>
	<input type="hidden" name="nt_cnt"  	id="nt_cnt" 		value=""/>
	<input type="hidden" name="cust_seq" 	id="cust_seq" 	value=""/>
	<input type="hidden" name="del_dtl_seq1" id="del_dtl_seq1" 	value=""/>
	<input type="hidden" name="del_dtl_seq2" id="del_dtl_seq2" 	value=""/>
	<input type="hidden" name="del_dtl_seq3" id="del_dtl_seq3" 	value=""/>
	<input type="hidden" name="del_dtl_seq4" id="del_dtl_seq4" 	value=""/>
<!-- write -->
<div class="tit_bWrap clearB mgb10">
	<h4>고객사 정보</h4>
</div>
<table class="sType mgb20" id="cust_info">
	<caption>소속 고객사 정보</caption>
	<colgroup>
		<col style="width:140px;" />
		<col style="width:360px;" />
		<col style="width:140px;" />
		<col style="width:360px;" />
	</colgroup>
	<tr>
		<th scope="row">거래처 명 <span class="request">필수입력</span></th>
		<td>
			<input type="text" id="cust_nm" title="거래처 명" value="" class="w200"/>
			<button type="button" class="btn_line_gray w70" id="searchCust" onclick="javascript:showLayer();">조회하기</button>
		</td>
		<th scope="row">거래처 코드<span class="request">필수입력</span></th>
		<td>
			<input type="text" readonly="readonly" id="erp_code" name="erp_code" title="거래처 코드" value="" />
			
		</td>
	</tr>
	<tr>
		<th scope="row">거래처 주소</th>
		<td>
			<input type="text" readonly="readonly" id="cust_address" title="거래처 주소" value="" />
		</td>
		<th scope="row">우편번호</th>
		<td>
			<input type="text" readonly="readonly" id="cust_post_no" title="우편번호" value="" />
		</td>
	</tr>
	<tr>
		<th scope="row">거래처 담당자</th>
		<td>
			<input type="text" readonly="readonly" id="dam_emp_name" title="거래처 담당자" value="" />
		</td>
		<th scope="row">거래처 담당자 연락처</th>
		<td>
			<input type="text" readonly="readonly" id="dam_tel_no" title="거래처 담당자" value="" />
		</td>
	</tr>
</table>

<div class="tit_bWrap clearB mgb10">
	<h4>시스템 기본 정보</h4>
</div>
<table class="sType mgb20">
	<caption>프로젝트 스펙 정보 입력</caption>
	<colgroup>
		<col style="width:125px;" />
		<col style="width:375px;" />
		<col style="width:125px;" />
		<col style="width:375px;" />
	</colgroup>
	<tr>
	 	<th scope="row">프로젝트명</th>
		<td colspan="3">
			<input type="text" name="project_nm" id="project_nm" title="프로젝트명" placeholder="프로젝트명을 입력하세요.(프로젝트 정보가 없는 경우 수기 입력 가능)" class="w340 mgr15"/>
			
			<c:if test="${ vo.pageType eq 'insert'}">
			<button type="button" class="btn_ico_search_f mgr5" style="width:160px;border-radius:0px;" onclick="showProjectLayer(1);"><span>프로젝트 정보 가져오기</span></button>
			</c:if>	
		</td>
	</tr>
	<tr>
	 	<th scope="row">시스템명<span class="request">필수입력</span></th>
		<td>
			<input type="text" name="system_nm" id="system_nm" title="시스템명" placeholder="시스템명을 입력하세요."/>
		</td>
		<th scope="row">시스템유형<span class="request">필수입력</span></th>
		<td>
			<select  name="system_code" id="system_code" title="시스템유형" onChange="resetTask();"  ></select>
		</td>
	</tr>
	<tr>
		<th scope="row">유지보수 거래 상태<span class="request">필수입력</span></th>
		<td>
			<select  name="state_type" id="state_type" title="유지보수 거래 상태" ></select>
		</td>
		<!-- <th scope="row">유지보수 계약기간</th>
		<td>
			<input type="text" name="term_start_dt" id="term_start_dt" title="투입시작일 입력" class="w125" readonly="readonly"/> ~
			<input type="text" name="term_end_dt" id="term_end_dt" title="투입종료일 입력" class="w125 mgr5"readonly="readonly" />
		</td> -->
		<th scope="row">SI/Package</th>
		<td colspan="3">
			<select  name="package_code" id="package_code" class="w340"></select>
		</td>
	</tr>
	<tr>
		<th scope="row">전산오픈일</th>
		<td>
			<input type="text" name="open_dt" id="open_dt" title="전산오픈일 입력" class="w125" />
			
		</td>
		<th scope="row">최종검수일</th>
		<td>
			<input type="text" name="test_dt" id="test_dt" title="최종검수일" class="w125"/>
		</td>
	</tr>
	<!-- <tr>
		<th scope="row">SI/Package</th>
		<td colspan="3">
			<select  name="package_code" id="package_code" class="w340"></select>
		</td>
	</tr> -->
</table>
<!--// write -->
<!--write -->
<div class="tit_bWrap mgb10">
	<h4 class="floatL mgt8">서버(APP,DB) 정보</h4>
	<span class="floatR">
		<button class="btn_ico_circle_plus_g mgr5" onclick="addServer();"><span>행추가</span></button>
		<button class="btn_ico_stop_g" onclick="delServer();"><span>행삭제</span></button>
	</span>
</div>
<div class="mgb20" style="overflow-x:auto;">
	<table class="hType mgb10" id="server_tb" style="width:1000px;">
		<caption>서버/APP/DB 정보</caption>
		<colgroup>
			<col style="width:40px" /> <!--선택 -->
			<col style="width:100px" /><!--사용용도-->
			<col style="width:180px" /><!--사용명칭-->
			<col style="width:100px" /><!--OS -->
			<col style="width:120px" /><!--서버IP(내부)-->
			<col style="width:120px" /><!--서버IP(공인)-->
			<col style="width:100px" /><!--상태-->
			<col style="width:100px" /><!--서버담당자-->
		</colgroup>
		<thead>
			<tr>
				<th scope="col">선택</th>
				<th scope="col">사용용도</th>
				<th scope="col">사용명칭</th>
				<th scope="col">OS</th>
				<th scope="col">서버IP(내부)</th>
				<th scope="col">서버IP(공인)</th>
				<th scope="col">상태</th>
				<th scope="col">담당주체</th>
				<th scope="col">담당자명</th>
			</tr>
		</thead>
		<tbody id="sv_wrap">
		</tbody>
	</table>
</div>
<!-- write -->
<div class="tit_bWrap mgb10">
	<h4 class="floatL mgt8">유지보수 담당자 정보</h4>
	<span class="floatR">
		<button class="btn_ico_circle_plus_g mgr5" onclick="addWorker();"><span>행추가</span></button>
		<button class="btn_ico_stop_g" onclick="delWorker();"><span>행삭제</span></button>
	</span>
</div>
<div class="mgb20" style="overflow-x:auto;">
	<table class="hType mgb10" id="worker_tb"  style="width:1000px;">
		<caption>유지보수 담당자 정보</caption>
		<colgroup>
			<col style="width:40px" /> <!--선택 -->
			<col style="width:120px" /><!--시스템 업무유형-->
			<col style="width:180px" /><!--담당자명-->
			<col style="width:100px" /><!--담당자소속 -->
			<col style="width:120px" /><!--연락처-->
			<col style="width:120px" /><!--이메일 -->
			<col style="width:60px" /><!--대표담당자 -->
			<col style="width:150px" /><!--비고-->
			<col style="width:80px" /><!--비고-->
			
		</colgroup>
		<thead>
			<tr>
				<th scope="col">선택</th>
				<th scope="col">시스템 업무 구분<span class="request">필수입력</span></th>
				<th scope="col">담당자명<span class="request">필수입력</span></th>
				<th scope="col">담당자 소속</th>
				<th scope="col">연락처</th>
				<th scope="col">이메일</th>
				<th scope="col">대표담당자</th>
				<th scope="col">비고</th>
				<th scope="col">사용여부<span class="request">필수입력</span></th>
			</tr>
		</thead>
		<tbody id="wk_wrap">
		</tbody>
	</table>
</div>
<!--// write -->

<!--write -->
<div class="tit_bWrap mgb10">
	<h4 class="floatL mgt8">거래처 담당자 정보</h4>
	<span class="floatR">
		<button class="btn_ico_circle_plus_g mgr5" onclick="addCharge();"><span>행추가</span></button>
		<button class="btn_ico_stop_g" onclick="delCharge();"><span>행삭제</span></button>
	</span>
</div>
<div class="mgb20" style="overflow-x:auto;">
	<table class="hType mgb10" id="charge_tb" style="width:1000px;">
		<caption>담당자 정보</caption>
		<colgroup>
			<col style="width:40px" /> <!--선택 -->
			<col style="width:100px" /><!--담당자구분-->
			<col style="width:100px" /><!--소속명-->
			<col style="width:100px" /><!--담당자명 -->
			<col style="width:120px" /><!--연락처1(회사)-->
			<col style="width:120px" /><!--연락처2(핸드폰)-->
			<col style="width:100px" /><!--이메일 -->
			<col style="width:100px" /><!--비고-->
		</colgroup>
		<thead>
			<tr>
				<th scope="col">선택</th>
				<th scope="col">담당자구분</th>
				<th scope="col">소속명</th>
				<th scope="col">담당자명</th>
				<th scope="col">연락처1(회사)</th>
				<th scope="col">연락처2(핸드폰)</th>
				<th scope="col">이메일</th>
				<th scope="col">비고</th>
			</tr>
		</thead>
		<tbody id="cg_wrap">
		</tbody>
	</table>
</div>
<!--// write -->

<!--write -->
<div class="tit_bWrap mgb10">
	<h4 class="floatL mgt8">관리 내역</h4>
	<span class="floatR">
		<button class="btn_ico_circle_plus_g mgr5" onclick="addNote();"><span>행추가</span></button>
		<button class="btn_ico_stop_g" onclick="delNote();"><span>행삭제</span></button>
	</span>
</div>
<div class="mgb20" style="overflow-x:auto;">
	<table class="hType mgb10" id="note_tb" style="width:1000px;">
		<caption>관리정보</caption>
		<colgroup>
			<col style="width:40px" /> <!--선택 -->
			<col style="width:100px" /><!--구분-->
			<col style="width:400px" /><!--내용 -->
			<col style="width:100px" /><!--등록자-->
			<col style="width:100px" /><!--등록일시-->
		</colgroup>
		<thead>
			<tr>
				<th scope="col">선택</th>
				<th scope="col">구분</th>
				<th scope="col">내용</th>
				<th scope="col">등록자</th>
				<th scope="col">등록일시</th>
			</tr>
		</thead>
		<tbody id="nt_wrap">
		</tbody>
	</table>
</div>
<!--// write -->
<!--// list -->
<div class="btn_wrap">
	<div class="floatL">
		<button type="button" class="btn_ico_list" onclick="goList();"><span>목록</span></button>
	</div>
	<div class="floatR">
		<button type="button" class="btn_ico_confirm" id="btnView1" onclick="goProc();"><span>저장</span></button>
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
			<col style="width:150px;" />
			<col style="width:80px;" />
			<col style="width:120px;" />
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



<div class="box_layer layer_sms" style="margin-top:-300px;display:none;" id="div2">
<h1>서버 정보 조회 검색 결과</h1>
<div class="layer_contents pdt20" style="height:657px;">
	서버명칭:
	<input type="text" class="w175 mgr10" id="searchServerName" name="searchServerName" title="서버 정보 검색" placeholder="사용명칭">
	IP 주소:
	<input type="text" class="w175 mgr10" id="ipNumber" name="ipNumber" title="IP 주소 검색" placeholder="IP주소">
	<input type="hidden" id="rownum" name="rownum" value="">
	
	<button type="button" class="btn_ico_search mgr5" onclick="javascript:serverList(1);"><span>검색</span></button>
	<table class="vType_line" style="margin-top: 10px" style="overflow-x:auto;">
		<caption>서버 정보 목록</caption>
		<colgroup>
			<col style="width:40px;" />
			<col style="width:120px;" />
			<col style="width:130px;" />
			<col style="width:auto;" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">No</th>
				<th scope="col">기관명</th>
				<th scope="col">사용명칭</th>
				<th scope="col">사용용도</th>
				<th scope="col">IP내부</th>
				<th scope="col">IP공인</th>
				<th scope="col">서버상태</th>
			</tr>
		</thead>
		<tbody id="serverInfoList"></tbody>
	</table>
	<div class="page" id="layer_pagination2" style="margin-top: 10px;"></div>
</div>
<button type="button" class="btn_close" onclick="javascript:closeLayer2();">창 닫기</button>
</div>
<div class="layer_dimmed" style="display:none;" id="div_dim2"></div>


<div class="box_layer layer_sms" style="margin-top:-300px;display:none;" id="div3">
<h1>프로젝트 정보 조회 검색 결과</h1>
<div class="layer_contents pdt20" style="height:657px;">
	프로젝트명칭:
	<input type="text" class="w175 mgr10" id="searchProjectName" name="searchProjectName" title="프로젝트 정보 검색" placeholder="사용명칭">
	거래처명:
	<input type="text" class="w175 mgr10" id="searchCustName" name="searchCustName" title="거래처명검색" placeholder="거래처명">
	
	<button type="button" class="btn_ico_search mgr5" onclick="javascript:projectList(1);"><span>검색</span></button>
	<table class="vType_line" style="margin-top: 10px" style="overflow-x:auto;">
		<caption>프로젝트 정보 목록</caption>
		<colgroup>
			<col style="width:40px;" />
			<col style="width:150px;" />
			<col style="width:150px;" />
			<col style="width:60px;" />
			<col style="width:180px;" />
			<col style="width:80px;" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">No</th>
				<th scope="col">기관명</th>
				<th scope="col">프로젝트명</th>
				<th scope="col">시스템구분</th>
				<th scope="col">프로젝트 기간</th>
				<th scope="col">프로젝트 상태</th>
			</tr>
		</thead>
		<tbody id="projectInfoList"></tbody>
	</table>
	<div class="page" id="layer_pagination3" style="margin-top: 10px;"></div>
</div>
<button type="button" class="btn_close" onclick="javascript:closeLayer3();">창 닫기</button>
</div>
<div class="layer_dimmed" style="display:none;" id="div_dim3"></div>

<!-- 운영 담당자 조회 -->
<div class="box_layer layer_sms" style="display:none;height:510px;" id="div6">
<h1>운영 담당자 조회</h1>
<div class="layer_contents pdt20" style="height:480px;">
	이름:
	<input type="text" class="w175 mgr10" id="searchCharName" name="searchCharName" title="담당자 입력" autofocus="autofocus"/>
	<input type="hidden" id="rowNum" name="rowNum" value=""/>
	<button type="button" class="btn_ico_search mgr5" onclick="javascript:charList(1);"><span>검색</span></button>
	<table class="vType_line" id="emp_tb" style="margin-top: 10px">
		<caption>직원 정보 목록</caption>
		<colgroup>
			<col style="width:40px;" />
			<col style="width:160px;" />
			<col style="width:100px;" />
			<col style="width:100px;" />
			<col style="width:60px;" />
			<col style="width:120px;" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">No</th>
				<th scope="col">부서명/팀명</th>
				<th scope="col">사번</th>
				<th scope="col">이름</th>
				<th scope="col">직급</th>
				<th scope="col">이메일</th>
			</tr>
		</thead>
		<tbody id="charInfoList"></tbody>
	</table>
	<div class="page" id="layer_pagination6" style="margin-top: 10px;"></div>
</div>
<button type="button" class="btn_close" onclick="javascript:closeLayer6();">창 닫기</button>
</div>
<div class="layer_dimmed" style="display:none;" id="div6_dim"></div>



