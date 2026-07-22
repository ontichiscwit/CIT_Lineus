<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="egovframework.com.comm.util.CommonExecute"%>


<script type="text/javascript">
	
	var ht_cnt = 0; 		//이력관리 addcnt
	var cg_cnt = 0; 		//담당자정보 addcnt
	var paramString = "" ; 
	
	$(document).ready(function(){
		
		$( "#adopt_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#free_end_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#free_start_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		/**	select box 정보 처리	*/
		commonCode.getCodeList('NETWORK' , 'NT01' , 'equipment') ; 			/**	장비구분	   */
		commonCode.getCodeList('NETWORK' , 'NT02' , 'network_mnf') ; 		/**	제조사	   */
		commonCode.getCodeList('NETWORK' , 'NT03' , 'emp_grade') ; 			/**	사용용도	   */
		commonCode.getCodeList('NETWORK' , 'NT04' , 'port_num') ; 			/**	포트수량	   */
		commonCode.getCodeList('NETWORK' , 'NT05' , 'access_type') ; 		/**	접속방식	   */
		commonCode.getCodeList('NETWORK' , 'NT06' , 'use_type') ; 			/**	사용구분	   */
		commonCode.getCodeList('NETWORK' , 'NT07' , 'unsed_status') ; 		/**	유휴폐기여부      */
		commonCode.getCodeList('NETWORK' , 'NT08' , 'contract_condition') ; /**	유무상구분	   */
		<c:if test="${ vo.pageType ne 'insert'}">initView();</c:if>
		
	});
	
	function initView() {
		
		$('#cust_nm').attr('readonly','readonly');
		$('#searchCust').css('display','none');
		
		var datas = {'seq' : $('#seq').val()} ; 
		common.ajaxCall(datas , '/ad/network/getNetworkInfo.do' , 'setNetworkInfo') ; 
	}
	
	
	
	function setNetworkInfo(data) {
		
		var info = typeof data.info !='undefined' ? data.info : null ; //기본정보
		var hist = typeof data.hist !='undefined' ? data.hist : null ; //이력
		var charge = typeof data.charge !='undefined' ? data.charge : null ; //담당자정보
		
		//if (hist.length == 0) addHist();
		//if (charge.length == 0) addCharge();
		
		if (info != null) {
			   /* 네트워크 정보 */
			   
			  $("#cust_nm").val(common.nvl(info.cust_nm,''));      
			  $("#erp_code").val(common.nvl(info.erp_code,''));      
			  $("#cust_address").val(common.nvl(info.cust_address,''));     
			  $("#dam_emp_name").val(common.nvl(info.dam_emp_name,''));   
			  $("#dam_tel_no").val(common.nvl(info.dam_tel_no,'')); 
			   
			  $("#cust_seq").val(common.nvl(info.cust_seq,''));      
			  $("#adopt_dt").val(makeDate(common.nvl(info.adopt_dt,'')));      
			  $("#equipment").val(common.nvl(info.equipment,''));     
			  $("#network_mnf").val(common.nvl(info.network_mnf,''));   
			  $("#network_model").val(common.nvl(info.network_model,'')); 
			  $("#serial_number").val(common.nvl(info.serial_number,'')); 
			  $("#network_type").val(common.nvl(info.network_type,''));  
			  $("#ip").val(common.nvl(info.ip,''));            
			  $("#id").val(common.nvl(info.id,''));            
			  $("#pass").val(common.nvl(info.pass,''));          
			  $("#port_num").val(common.nvl(info.port_num,''));      
			  $("#access_type").val(common.nvl(info.access_type,''));   
			  $("#network_nm").val(common.nvl(info.network_nm,''));    
			  $("#unsed_status").val(common.nvl(info.unsed_status,''));  
			  $("#location_net").val(common.nvl(info.location_net,''));  
			  $("#cust_worker").val(common.nvl(info.cust_worker,''));   
			  $("#cust_tel").val(common.nvl(info.cust_tel,''));      
			  $("#contract_condition").val(common.nvl(info.contract_condition,'')); 
			  $("#free_end_dt").val(makeDate(common.nvl(info.free_end_dt,'')));    
			  $("#free_start_dt").val(makeDate(common.nvl(info.free_start_dt,'')));  
			  $("#upd_id").val(common.nvl(info.upd_id,''));         
			  $("#upd_date").val(common.nvl(info.upd_date,''));       
			  $("#reg_id").val(common.nvl(info.reg_id,''));         
			  $("#reg_date").val(common.nvl(info.reg_date,''));       
			  $("#use_type").val(common.nvl(info.use_type,''));	

			  
			
			if (hist != null && hist.length > 0) {
				for (var i=0; i < hist.length; i++) {
					var list = hist[i];
					var str = '';
					str += '<tr id="tr'+(i+1)+'">';
					str += '<td><input type="checkbox"  class="hist_check" cnt="'+(i+1)+'"  value="'+common.nvl(list.hist_seq,'')+'"></td>'; /* 체크박스  */
					str += '<td style="display:none;"><input type="text" id="hist_seq'+(i+1)+'"  name="hist_seq'+(i+1)+'" value="'+common.nvl(list.hist_seq,'')+'"></td>'; 
					
					str += '<td>';
					str += '<input type="text" name="str_dt'+(i+1)+'" id="str_dt'+(i+1)+'" title="작업시작일" class="w100" value="'+ makeDate(common.nvl(list.str_dt , '-'))+'"/>';
					str += '<input type="text" name="end_dt'+(i+1)+'" id="end_dt'+(i+1)+'" title="작업종료일" class="w100" value="'+ makeDate(common.nvl(list.end_dt , '-'))+'"/>';
					str += '</td>'; /* 참여기간 */
					
					str += '<td>';
					str += '	<select name="infra_gubun'+(i+1)+'" id="infra_gubun'+(i+1)+'" title="작업인프라 구분 선택">'; /* 담당자구분 */
					str += '		<option value=""></option>';
					str += '	</select>';
					str += '</td>';/* 작업인프라 구분 */
					
					str += '<td>';
					str += '	<select name="work_type'+(i+1)+'" id="work_type'+(i+1)+'" title="작업 구분 선택">'; /* 담당자구분 */
					str += '		<option value=""></option>';
					str += '	</select>';
					str += '</td>';/* 작업구분 */
					
					str += '<td><input type="text" name="equipment_nm'+(i+1)+'" id="equipment_nm'+(i+1)+'" title="장비명" value="'+ common.nvl(list.equipment_nm , '-')+'"/></td>';
					str += '<td><input type="text" name="work_content'+(i+1)+'" id="work_content'+(i+1)+'" title="작업내용" value="'+ common.nvl(list.work_content , '-')+'"/></td>';
					str += '<td><input type="text" name="work_charge'+(i+1)+'" id="work_charge'+(i+1)+'" title="작업자(내부)" value="'+ common.nvl(list.work_charge , '-')+'"/></td>';
					str += '<td><input type="text" name="work_cust'+(i+1)+'" id="work_cust'+(i+1)+'" title="소속업체" value="'+ common.nvl(list.work_cust , '-')+'"/></td>';
					str += '<td><input type="text" name="cust_charge'+(i+1)+'" id="cust_charge'+(i+1)+'" title="업체담당자" value="'+ common.nvl(list.cust_charge , '-')+'"/></td>';
					str += '<td><input type="text" name="work_time'+(i+1)+'" id="work_time'+(i+1)+'" title="소요시간" value="'+ common.nvl(list.work_time , '-')+'"/></td>';
					str += '<td><input type="text" name="hist_etc'+(i+1)+'" id="hist_etc'+(i+1)+'" title="비고" value="'+ common.nvl(list.hist_etc , '-')+'"/></td>';
					str += '<td>'+common.nvl(list.reg_dt, '-')+'</td>';
					str += '</tr>';
					$('#hist_tb #ht_wrap').append(str);
					
					commonCode.getCodeList('NETWORK' , 'NT10' , 'infra_gubun' +(i+1)) ; /**	인프라구분		*/
					commonCode.getCodeList('NETWORK' , 'NT11' , 'work_type' +(i+1)) ; 	/**	작업구분		*/
					

					$( "#str_dt"+(i+1) ).datepicker(datepicker);
					$( "#end_dt"+(i+1) ).datepicker(datepicker);
					
					$('#infra_gubun'+(i+1)).val(list.infra_gubun);
					$('#work_type'+(i+1)).val(list.work_type);
				}
				ht_cnt = hist.length;
			}
			
			
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
					str += '<td><input type="text" name="company_nm'+(i+1)+'" id="company_nm'+(i+1)+'" title="소속명 입력" value="'+ common.nvl(list.company_nm , '-')+'" /></td>';
					str += '<td><input type="text" name="charge_nm'+(i+1)+'" id="charge_nm'+(i+1)+'" title="담당자명 입력"  value="'+ common.nvl(list.charge_nm , '-')+'"/></td>';
					str += '<td><input type="text" name="company_tel_no'+(i+1)+'" id="company_tel_no'+(i+1)+'" title="연락처1 입력"  value="'+ common.nvl(list.company_tel_no , '-')+'"/></td>';
					str += '<td><input type="text" name="hp_no'+(i+1)+'" id="hp_no'+(i+1)+'" title="연락처2 입력"  value="'+ common.nvl(list.hp_no , '-')+'"/></td>';
					str += '<td><input type="text" name="email'+(i+1)+'" id="email'+(i+1)+'" title="이메일 입력"  value="'+ common.nvl(list.email , '-')+'"/></td>';
					str += '<td><input type="text" name="etc'+(i+1)+'" id="etc'+(i+1)+'" title="비고"  value="'+ common.nvl(list.etc , '-')+'"/></td>';
					str += '</tr>';
					$('#charge_tb #cg_wrap').append(str);
					
					commonCode.getCodeList('NETWORK' , 'NT09' , 'charge_code' +(i+1)) ; 	/**	담당구분		*/
					$('#charge_code'+(i+1)).val(list.charge_code);
				}
				cg_cnt = charge.length;		
			}
		}
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
		str += '<td><input type="text" name="etc'+cg_cnt+'" id="etc'+cg_cnt+'" title="비고" /></td>';
		str += '</tr>';
		$('#charge_tb #cg_wrap').append(str);
		
		commonCode.getCodeList('NETWORK' , 'NT09' , 'charge_code' +cg_cnt) ; 	/**	담당구분		*/
		
		
	}
	/* 담당자 정보 DEL */
	/* function delCharge() {
		$('input:checkbox[class="charge_check"]').each(function() {
			if($(this).is(":checked")){//checked 처리된 항목의 값
				$('#tr'+$(this).attr('cnt')).remove();
			}
		});
			
	}
	 */
	
	function delCharge() {
		if ($('#cg_wrap input[type=checkbox]:checked').length == 0) { 
			alert('삭제할 행을 선택하세요.');
			return;
		}
		$('#cg_wrap input[type=checkbox]:checked').each(function(){
			if (common.isEmpty($('#del_dtl_seq1').val())) $('#del_dtl_seq1').val($(this).val());
			else $('#del_dtl_seq1').val($('#del_dtl_seq1').val() + "@" + $(this).val());
			$(this).parent().parent('tr').remove();
			cg_cnt = cg_cnt -1; 
		});
	}
	
	
	/* 이력관리 정보 ADD 그리드형식*/
	function addHist() {
		var str = '';
		ht_cnt++;
		str += '<tr id="tr'+ht_cnt+'"  >';
		str += '<td><input type="checkbox"  class="hist_check" id="check'+ht_cnt+'" cnt="'+ht_cnt+'" value=""></td>'; /* 체크박스  */
		str += '<td>';
		str += '<input type="text" name="str_dt'+ht_cnt+'" id="str_dt'+ht_cnt+'" title="작업시작일" class="w100" />';
		str += '<input type="text" name="end_dt'+ht_cnt+'" id="end_dt'+ht_cnt+'" title="작업종료일" class="w100"/>';
		str += '</td>'; /* 참여기간 */
		str += '<td>';
		str += '	<select name="infra_gubun'+ht_cnt+'" id="infra_gubun'+ht_cnt+'" title="작업인프라 구분 선택">'; /* 담당자구분 */
		str += '		<option value=""></option>';
		str += '	</select>';
		str += '</td>';/* 작업인프라 구분 */
		str += '<td>';
		str += '	<select name="work_type'+ht_cnt+'" id="work_type'+ht_cnt+'" title="작업 구분 선택">'; /* 담당자구분 */
		str += '		<option value=""></option>';
		str += '	</select>';
		str += '</td>';/* 작업구분 */
		str += '<td><input type="text" name="equipment_nm'+ht_cnt+'" id="equipment_nm'+ht_cnt+'" title="장비명" /></td>';
		str += '<td><input type="text" name="work_content'+ht_cnt+'" id="work_content'+ht_cnt+'" title="작업내용" /></td>';
		str += '<td><input type="text" name="work_charge'+ht_cnt+'" id="work_charge'+ht_cnt+'" title="작업자(내부)" /></td>';
		str += '<td><input type="text" name="work_cust'+ht_cnt+'" id="work_cust'+ht_cnt+'" title="소속업체" /></td>';
		str += '<td><input type="text" name="cust_charge'+ht_cnt+'" id="cust_charge'+ht_cnt+'" title="업체담당자" /></td>';
		str += '<td><input type="text" name="work_time'+ht_cnt+'" id="work_time'+ht_cnt+'" title="소요시간" /></td>';
		str += '<td><input type="text" name="hist_etc'+ht_cnt+'" id="hist_etc'+ht_cnt+'" title="비고" /></td>';
		str += '<td>-</td>';
		str += '</tr>';
		$('#hist_tb #ht_wrap').append(str);
		
		commonCode.getCodeList('NETWORK' , 'NT10' , 'infra_gubun' +ht_cnt) ; /**	인프라구분		*/
		commonCode.getCodeList('NETWORK' , 'NT11' , 'work_type' +ht_cnt) ; 	/**	작업구분		*/
		
		$( "#str_dt"+ht_cnt ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#end_dt"+ht_cnt ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
	}
	/* 이력관리 정보 DEL 그리드형식*/
	/* function delHist() {
		$('input:checkbox[class="hist_check"]').each(function() {
			if($(this).is(":checked")){//checked 처리된 항목의 값
				$('#tr'+$(this).attr('cnt')).remove();
			}
		});
	} */
	
	
	function delHist() {
		if ($('#ht_wrap input[type=checkbox]:checked').length == 0) { 
			alert('삭제할 행을 선택하세요.');
			return;
		}
		$('#ht_wrap input[type=checkbox]:checked').each(function(){
			if (common.isEmpty($('#del_dtl_seq2').val())) $('#del_dtl_seq2').val($(this).val());
			else $('#del_dtl_seq2').val($('#del_dtl_seq2').val() + "@" + $(this).val());
			$(this).parent().parent('tr').remove();
			ht_cnt = ht_cnt -1;
		});
	}
	
	
	function goProc(){
		
		var f = document.procFrm;
		f.pageType.value = '${vo.pageType}';
		
		f.ht_cnt.value = ht_cnt ;
		f.cg_cnt.value = cg_cnt ;
		
		console.log(f.port_num.value);
		
		common.ajaxCall($('form[name=procFrm]').serialize() , '/ad/network/proc.do' , 'procReturn') ; 
	}
	
	function procReturn(data){
		var returnCode = typeof data.returnCode != "undefined" ? data.returnCode : "002" ; 
		var msg = "" ; 
		
		if(returnCode == "000") msg = "정상적으로 처리 되었습니다." ; 
		else if(returnCode == "001") msg = "비정상적으로 처리 되었습니다." ; 
		else if(returnCode == "002") msg = "처리도중 오류가 발생했습니다." ;
		
		alert(msg) ; 
		if(returnCode == "000") {
			
			location.href = "/ad/network/list.do" 
		}
	}
	
	function goList() {
		var f = document.procFrm;
		f.action = '/ad/network/list.do' + window.location.search.substring();
		f.submit();	
	}
	
	
	/**	거래처 조회	*/
	function showLayer(){
		$('#div1').show() ;
		$('#div1').css('height' , '710') ; 
		$('#div_dim').show() ; 
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
	
	
	
</script>

<div class="tit_wrap">
	<h2 class="tit_ico_customer">네트워크 관리<span class="tit_depth mgl20 mgt8">네트워크정보</span></h2>
</div>
<div class="tit_sWrap">
	<h3 class="tit_dot_gray">네트워크 상세 정보<c:if test="${ vo.pageType ne 'insert' }">&nbsp;&lt;<span class="colorBlue mg15" style="line-height:25px;">${ vo.cust_kor_name }, ${ vo.erp_code }</span>&gt;</c:if></h3>
</div>
<!-- tab -->
	
<form name="procFrm" method="post" onsubmit="return false;">
	<input type="hidden" name="seq"  		id="seq" 			value="${ vo.seq }"/>
	<input type="hidden" name="pageType"  id="pageType" 	value="${ vo.pageType }"/>
	<input type="hidden" name="cg_cnt"  	id="cg_cnt" 		value=""/>
	<input type="hidden" name="ht_cnt"  	id="ht_cnt" 		value=""/>
	<input type="hidden" name="cust_seq" id="cust_seq" 	value=""/>
	<input type="hidden" name="del_dtl_seq1" id="del_dtl_seq1" 	value=""/>
	<input type="hidden" name="del_dtl_seq2" id="del_dtl_seq2" 	value=""/>
	
	
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
		<th scope="row">거래처 명</th>
		<td>
			<input type="text" id="cust_nm" title="거래처 명" value="" class="w200"/>
			<button type="button" class="btn_line_gray w70" id="searchCust" onclick="javascript:showLayer();">조회하기</button>
		</td>
		<th scope="row">거래처 코드</th>
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
	<h4>네트워크 기본 정보</h4>
</div>
<table class="sType mgb20">
	<caption>네트워크 스펙 정보 입력</caption>
	<colgroup>
		<col style="width:125px;" />
		<col style="width:375px;" />
		<col style="width:125px;" />
		<col style="width:375px;" />
	</colgroup>
	 <tr>
	 	<th scope="row">사용명칭</th>
		<td>
			<input type="text" name="network_nm" id="network_nm" title="사용명칭입력" placeholder="사용명칭"/>
		</td>
		<th scope="row">사용구분</th>
		<td>
			<select  name="use_type" id="use_type" title="사용구분" ></select>
		</td>
	</tr>
	<tr>
		<th scope="row">장비구분</th>
		<td>
			<select name="equipment" id="equipment" title="장비 입력" >
				<option>선택</option>
			</select>
		</td>
		<th scope="row">제조사/모델</th>
		<td>
			<select name="network_mnf" id="network_mnf" title="네트워크제조사 입력" class="w125 mgr5">
				<option>선택</option>
			</select>
			<select name="network_model" id="network_model" title="네트워크 모델 입력" class="w125">
				<option>선택</option>
			</select>
		</td>
	</tr>
	<tr>
		<th scope="row">시리얼 넘버</th>
		<td>
			<input type="text" name="serial_number" id="serial_number" title="시리얼넘버"  placeholder="시리얼넘버"/>
		</td>
		<th scope="row">IP</th>
		<td>
			<input type="text" name="ip" id="ip" title="IP" placeholder="IP"/>
		</td>
	</tr>
    <tr>
		<th scope="row">아이디</th>
		<td>
			<input type="text" name="id" id="id" title="아이디 입력"  placeholder="아이디"/>
			
		</td>
		<th scope="row">비밀번호</th>
		<td>	
			<input type="text" name="pass" id="pass" title="비밀번호 입력"  placeholder="비밀번호"/>
		</td>
	</tr>
	<tr>
		<th scope="row">포트수량</th>
		<td>
			<select name="port_num" id="port_num" title="포트수" ></select>
		</td>
		<th scope="row">접속방식</th>
		<td>	
			<select name="access_type" id="access_type" title="접속방식 " ></select>
		</td>
	</tr>
</table>
<!--// write -->

<div class="tit_bWrap clearB mgb10">
	<h4>네트워크 관리 정보</h4>
</div>

<table class="sType mgb20">
	<caption>네트워크 관리 정보 입력</caption>
	<colgroup>
		<col style="width:125px;" />
		<col style="width:375px;" />
		<col style="width:125px;" />
		<col style="width:375px;" />
	</colgroup>
	 <tr>
	 	<th scope="row">도입일</th>
		<td colspan ="3">
			<input type="text" name="adopt_dt" id="adopt_dt" title="도입일자" class="w125 mgr5"/>
		</td>
	</tr>
	<tr>
	 	<th scope="row">설치장소</th>
		<td>
			<input type="text" name="location_net" id="location_net" title="설치장소" />
		</td>
		<th scope="row">유휴폐기여부</th>
		<td>
			<select  name="unsed_status" id="unsed_status" title="유휴폐기여부"  ></select>
		</td>
	</tr>
	<tr>
		<th scope="row">유무상구분</th>
		<td>
			<select name="contract_condition" id="contract_condition" title="유무상구분">
				<option>선택</option>
			</select>
		</td>
		<th scope="row">무상보증기간</th>
		<td>
			<input type="text" name="free_start_dt" id="free_start_dt" title="계약일자 입력" class="w125" /> ~
			<input type="text" name="free_end_dt" id="free_end_dt" title="계약일자 입력" class="w125 mgr5" />
		</td>
	</tr>
	
</table>
<!-- write -->
<div class="tit_bWrap mgb10">
	<h4 class="floatL mgt8">담당자 정보</h4>
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
<!-- list -->
<div class="tit_bWrap mgb10">
	<h4 class="floatL mgt8">이력 관리 </h4>
	<span class="floatR">
		<button class="btn_ico_circle_plus_g mgr5" onclick="addHist();"><span>행추가</span></button>
		<button class="btn_ico_stop_g" onclick="delHist();"><span>행삭제</span></button>
	</span>
</div>
<div class="mgb20" style="overflow-x:auto;">
	<table class="hType mgb10" id="hist_tb">
		<caption>이력 목록</caption>
		<colgroup>
			<col style="width:40px" /><!--선택  -->
			<col style="width:250px" /><!--작업일자  -->
			<col style="width:140px" /><!--작업인프라구분 -->
			<col style="width:140px" /><!--작업구분  -->
			<col style="width:150px" /><!--장비명  -->
			<col style="width:250px" /><!--작업내용  -->
			<col style="width:100px" /><!--작업자  -->
			<col style="width:120px" /><!--소속업체 -->
			<col style="width:100px" /><!--업체담당자 -->
			<col style="width:100px" /><!--소요시간 -->
			<col style="width:180px" /><!--비고 -->
			<col style="width:100px" /><!--등록일-->
		</colgroup>
		<thead>
			<tr>
				<th scope="col">선택</th>
				<th scope="col">작업일자</th>
				<th scope="col">작업인프라구분</th>
				<th scope="col">작업구분</th>
				<th scope="col">장비명</th>
				<th scope="col">작업내용</th>
				<th scope="col">작업자(내부)</th>
				<th scope="col">소속업체</th>
				<th scope="col">업체담당자</th>
				<th scope="col">소요시간</th>
				<th scope="col">비고</th>
				<th scope="col">등록일</th>
			</tr>
		</thead>
		<tbody id="ht_wrap">
			<tr> 
				<!-- <td><input type="checkbox" name="" /></td> 선택
				<td>1</td> NO
				<td><input type="text" name="str_dt" id="str_dt" style="width:70%"class="mgr5"/></td>일자
				<td><select  name="infra_type"><option>선택</option></select></td>작업인프라구분
				<td><select  name="work_type"><option>선택</option></select></td>작업구분
				<td><input type="text" name="equipment_name"placeholder="장비명" /></td>장비명
				<td><input type="text" name="work_content"placeholder="작업내용"/></td>작업내용
				<td><input type="text" name="work_charge"placeholder="작업 담당자(내부)"/></td>작업자(내부)
				<td><input type="text" name="work_cust" placeholder="소속업체"/></td>소속업체
				<td><input type="text" name="cust_charge"placeholder="업체담당자"/></td>업체담당자
				<td><input type="text" name="end_dt" id="end_dt" placeholder="작업완료일" style="width:70%" class="mgr5"/></td>완료일
				<td><input type="text" name="work_time" placeholder="작업소요시간"/></td>소요시간
				<td><input type="text" name="hist_etc" placeholder="비고"/></td>비고
				<td>-</td>등록일 -->
			</tr>
		</tbody>
	</table>
</div>
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


<!-- 레이어팝업 -->
<form name="hist_popup" id="hist_popup" method="post" onsubmit="return false;">
	<input type="hidden" name="seq" id="seq"  value=""/> <!-- HIST seq -->
	<input type="hidden" name="pageType" id="pageType" value=""/>
	<div id="hist_popupLayer" style="display: none;">
		<div class="box_layer layer_sms" style="height: 560px; width: 800px; margin-top: -350px;">
			<h1 id="hist_popupLabel">이력 등록</h1>
			<div class="layer_contents" style="padding-top: 20px; height: auto;">
				<h3 class="tit_sWrap">이력정보</h3>
				<table class="sType mgb20">
					<caption>이력 등록</caption>
					<colgroup>
						<col style="width: 100px">
						<col style="width: 200px">
						<col style="width: 100px">
						<col style="width: 200px">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">작업 시작일/완료일</th>
							<td>
								<input type="text" name="str_dt" id="str_dt"/> ~
								<input type="text" name="end_dt" id="end_dt"/>
							</td>
							<th scope="row">작업소요시간</th>
							<td>
								<input type="text" name="work_time" id="work_time"/>
							</td>
						</tr>
						<tr>
							<th scope="row">작업인프라 구분</th>
							<td><select name="infra_type" id="infra_type" title="작업인프라구분"></select></td>
							<th scope="row">작업구분</th>
							<td><select name="work_type" id="work_type" title="작업구분"></select></td>
						</tr>
						<tr>
							<th scope="row">장비명</th>
							<td><input type="text" title="장비명" name="equipment_name" id="equipment_name" placeholder="장비명"></td>
						</tr>
						<tr>
							<th scope="row">작업내용</th>
							<td colspan ="3"><input type="text" title="작업내용" name="work_content" id="work_content" placeholder="작업내용"></td>
						</tr>
						<tr>
							<th scope="row">작업담당자</th>
							<td colspan="3" >
								<input type="text" id="work_charge_nm" name ="work_charge_nm" placeholder="이름">
								<input type="text" id="work_charge" name ="work_charge" placeholder="사번">
							</td>
						</tr>
						<tr>
							<th scope="row">소속업체</th>
							<td><input type="text" title="싸이트 ID" name="work_cust" id="site_id" placeholder="싸이트 접속 가능 ID"></td>
							<th scope="row">업체담당자</th>
							<td><input type="text" name="cust_charge" id="cust_charge" title="업체담당자" placeholder="업체담당자"/></td>
						</tr>
						<tr>
							<th scope="row">비고</th>
							<td colspan="3"><input type="text" name="app_etc" id="app_etc" title="비고" value="" class="mgr5""></td>
						</tr>
					</tbody>
				</table>
				<div class="btn_wrap mgt20">
					<div class="floatR">
						<button type="button" class="btn_ico_confirm mgr5" onclick="regAppInfo()">
							<span>저장</span>
						</button>
						<button type="button" class="btn_ico_cancel" onclick="javascript:closeAPPpop();">
							<span>취소</span>
						</button>
					</div>
				</div>
			</div>
			<button type="button" class="btn_close" onclick="javascript:closeAPPpop();">창 닫기</button>
		</div>
		<div class="layer_dimmed"></div>
	</div>
</form>


