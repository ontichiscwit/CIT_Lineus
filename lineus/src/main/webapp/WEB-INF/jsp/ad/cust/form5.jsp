<%@page import="egovframework.com.comm.util.CommonExecute"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript" src="<%= request.getContextPath()%>/js/jquery.mtz.monthpicker.js"></script>
<script type="text/javascript">

	var ht_cnt = 0;
	var bill_code_option = "" ; 
	var mtac_code_option = "" ; 
	var deal_code_option = "" ; 
	var buy_busi_option = "" ; 
	var sv_period_option = "" ; 
	var sv_method_option = "" ; 
	
	$(document).ready(function(){
		commonCode.getCodeList2('CUST' , 'CD28' , 'makeBillCode') ; 	/**	수금정보	*/ 	
		commonCode.getCodeList2('CUST' , 'CD29' , 'makeMtacCode') ; /**	유지보수	*/
		commonCode.getCodeList2('CUST' , 'CD35' , 'makeDealCode') ; 		/**	거래 구분	*/
		commonCode.getCodeList2('CUST' , 'CD36' , 'makeBuyBisiCode') ; 		/**	매입업체코드	*/
		commonCode.getCodeList2('CUST' , 'CD37' , 'makeSvPeriodCode') ; 		/**	서비스주기	*/
		commonCode.getCodeList2('CUST' , 'CD38' , 'makeSvMethodCode') ; 		/**	서비스방법	*/
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
		common.ajaxCall(datas , '/ad/cust/getMtacHistInfo.do' , 'setMtacInfo') ; 
	}
	
	var projectCnt = 0 ;
	function setProjectCnt(data) {
		projectCnt = typeof data.cnt !='undefined' ? data.cnt : 0 ;
	}
	
	function setMtacInfo(data) {
		var list = typeof data.list !='undefined' ? data.list : null ; //담당자정보
		
		if (list.length == 0) addMThist() ;
		
		if (list != null && list.length > 0) {
			for (var i=0; i < list.length; i++) {
				var map = list[i];
				
				var str = '';
				str += '<tr>';
				str += '	<td><input type="checkbox" name="dtl_seq" id="dtl_seq" value="'+common.nvl(map.dtl_seq,'')+'"></td>';
				str += '	<td>';
				str += '		<select name="deal_code'+(i+1)+'" id="deal_code'+(i+1)+'" title="거래 구분">';
				str += '		</select>';
				str += '	</td>';				
				str += '	<td>';
				str += '		<input type="text" name="contract_seq'+(i+1)+'" id="contract_seq'+(i+1)+'" value="'+common.nvl(map.contract_seq,'')+'" title="계약서 번호 입력" />';	
				str += '	</td>';
				str += '	<td>';
				str += '		<input type="text" name="contract_nm'+(i+1)+'" id="contract_nm'+(i+1)+'" value="'+common.nvl(map.contract_nm,'')+'" title="계약서 명 입력" />';
				str += '	</td>';
				str += '	<td>';
				str += '		<input type="text" name="contract_dt'+(i+1)+'" id="contract_dt'+(i+1)+'" value="'+common.nvl(map.contract_dt,'')+'" class="w90" title="계약일자 입력" />';
				str += '	</td>';
				str += '	<td>';
				str += '		<select name="bill_code'+(i+1)+'" id="bill_code'+(i+1)+'" title="수금정보 선택">';
				str += '			<option value="">SMS 유보료</option>';
				str += '		</select>';
				str += '	</td>';
				str += '	<td>';
				str += '		<select name="mtac_code'+(i+1)+'" id="mtac_code'+(i+1)+'" title="유지보수 구분">';
				str += '			<option value="">유상</option>';
				str += '		</select>';
				str += '	</td>';
				str += '	<td>';
				str += '		<input type="text" name="mtac_start_dt'+(i+1)+'" id="mtac_start_dt'+(i+1)+'" value="'+common.nvl(map.mtac_start_dt,'')+'" class="w90" title="유지보수 시작일 입력" />';
				str += '		~';
				str += '		<input type="text" name="mtac_end_dt'+(i+1)+'" id="mtac_end_dt'+(i+1)+'" value="'+common.nvl(map.mtac_end_dt,'')+'" class="w90 mgl5" title="유지보수 시작일 입력" />';
				str += '	</td>';
				str += '	<td><input type="text" name="mon_off_amt'+(i+1)+'" id="mon_off_amt'+(i+1)+'" value="'+common.nvl(map.mon_off_amt,'')+'" title="월 유보금액 입력" /></td>';
				//str += '	<td><input type="text" name="year_off_amt'+(i+1)+'" id="year_off_amt'+(i+1)+'" value="'+common.nvl(map.year_off_amt,'')+'"  title="년 유보금액 입력" /></td>';
				str += '	<td>';
				str += '		<select name="buy_busi_name'+(i+1)+'" id="buy_busi_name'+(i+1)+'" title="매입업체명">';
				str += '		</select>';
				str += '	</td>';	
				str += '	<td>';
				str += '		<input type="text" name="buy_cost'+(i+1)+'" id="buy_cost'+(i+1)+'" value="'+common.nvl(map.buy_cost,'')+'" title="매입원가" />';
				str += '		</select>';
				str += '	</td>';	
				str += '	<td>';
				str += '		<select name="service_period'+(i+1)+'" id="service_period'+(i+1)+'" title="서비스주기">';
				str += '		</select>';
				str += '	</td>';	
				str += '	<td>';
				str += '		<select name="service_method'+(i+1)+'" id="service_method'+(i+1)+'" title="서비스방법">';
				str += '		</select>';
				str += '	</td>';	
				str += '	<td>';
				str += '		<input type="checkbox" name="auto_renew_yn'+(i+1)+'" id="auto_renew_yn'+(i+1)+'" value="Y" title="자동갱신여부">';
				str += '	</td>';	
				str += '	<td><button type="button" class="btn_line_gray small w37" onclick="btnPayInfo('+(i+1)+');">보기</button></td>';
				str += '	<td><button type="button" class="btn_line_gray small w37" onclick="btnMeno('+(i+1)+');">보기</button></td>';
				str += '	<td>'+common.nvl(map.reg_id,'')+'</td>';
				str += '	<td>'+common.nvl(map.reg_date,'')+'</td>';
				str += '</tr>';
				$('#hist_wrap').append(str);
				
				$( "#mtac_start_dt"+(i+1) ).val(common.nvl(map.mtac_start_dt,$.datepicker.formatDate('yy/mm/dd', new Date()))).datepicker(datepicker);
				$( "#mtac_end_dt"+(i+1) ).val(common.nvl(map.mtac_end_dt,$.datepicker.formatDate('yy/mm/dd', new Date()))).datepicker(datepicker);
				$( "#contract_dt"+(i+1) ).val(common.nvl(map.contract_dt,$.datepicker.formatDate('yy/mm/dd', new Date()))).datepicker(datepicker);
				
				$('#bill_code' + (i+1)).empty().append(bill_code_option).val(map.bill_code) ; 
				$('#mtac_code' + (i+1)).empty().append(mtac_code_option).val(map.mtac_code) ;
				$('#deal_code' + (i+1)).empty().append(deal_code_option).val(map.deal_code) ;
				
				$('#buy_busi_name' + (i+1)).empty().append(buy_busi_option).val(map.buy_busi_name) ;
				$('#service_period' + (i+1)).empty().append(sv_period_option).val(map.service_period) ;
				$('#service_method' + (i+1)).empty().append(sv_method_option).val(map.service_method) ;
				
				(common.nvl(map.auto_renew_yn,'') == 'Y') ? $('#auto_renew_yn' + (i+1)).attr('checked',true) : $('#auto_renew_yn' + (i+1)).attr('checked',false); 
				
				$('#etcWrap').append('<input type="hidden" name="etc'+(i+1)+'" id="etc'+(i+1)+'" value="'+common.nvl(map.etc, '')+'" />');
			}
			ht_cnt = list.length;		
		}
	}
	
	function makeBillCode(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var str = commonCode.defaultViewOption ; 
		
		if(resultList != null && resultList.length > 0){
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ; 
				str += '<option value=\''+common.nvl(datas.code, '')+'\'>'+common.nvl(datas.code_name, '')+'</option>' ; 
			}
		}
		bill_code_option = str ; 
	}
	
	function makeMtacCode(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var str = commonCode.defaultViewOption ; 
		
		if(resultList != null && resultList.length > 0){
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ; 
				str += '<option value=\''+common.nvl(datas.code, '')+'\'>'+common.nvl(datas.code_name, '')+'</option>' ; 
			}
		}
		mtac_code_option = str ; 
	}
	
	function makeMtacCode(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var str = commonCode.defaultViewOption ; 
		
		if(resultList != null && resultList.length > 0){
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ; 
				str += '<option value=\''+common.nvl(datas.code, '')+'\'>'+common.nvl(datas.code_name, '')+'</option>' ; 
			}
		}
		mtac_code_option = str ; 
	}
	
	function makeDealCode(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var str = commonCode.defaultViewOption ; 
		
		if(resultList != null && resultList.length > 0){
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ; 
				str += '<option value=\''+common.nvl(datas.code, '')+'\'>'+common.nvl(datas.code_name, '')+'</option>' ; 
			}
		}
		deal_code_option = str ; 
	}
	
	function makeBuyBisiCode(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var str = commonCode.defaultViewOption ; 
		
		if(resultList != null && resultList.length > 0){
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ; 
				str += '<option value=\''+common.nvl(datas.code, '')+'\'>'+common.nvl(datas.code_name, '')+'</option>' ; 
			}
		}
		buy_busi_option = str ; 
	}
	
	function makeSvPeriodCode(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var str = commonCode.defaultViewOption ; 
		
		if(resultList != null && resultList.length > 0){
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ; 
				str += '<option value=\''+common.nvl(datas.code, '')+'\'>'+common.nvl(datas.code_name, '')+'</option>' ; 
			}
		}
		sv_period_option = str ; 
	}
	
	function makeSvMethodCode(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var str = commonCode.defaultViewOption ; 
		
		if(resultList != null && resultList.length > 0){
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ; 
				str += '<option value=\''+common.nvl(datas.code, '')+'\'>'+common.nvl(datas.code_name, '')+'</option>' ; 
			}
		}
		sv_method_option = str ; 
	}
	
	function chgDealCode(code, ht_cnt) {
		if (code == 'C001') {
			//매입업체명, 서비스주기, 서비스방법
			$('#buy_busi_name'+ht_cnt).attr('disabled','disabled');
			$('#buy_cost'+ht_cnt).attr('readonly','readonly');
			$('#service_period'+ht_cnt).attr('disabled','disabled');
			$('#service_method'+ht_cnt).attr('disabled','disabled');
		} else {
			$('#buy_busi_name'+ht_cnt).attr('disabled',false);
			$('#buy_cost'+ht_cnt).attr('readonly',false);
			$('#service_period'+ht_cnt).attr('disabled',false);
			$('#service_method'+ht_cnt).attr('disabled',false);
		}
		
	}

	function addMThist() {
		var str = '';
		ht_cnt++;
		str += '<tr>';
		str += '	<td><input type="checkbox" name="dtl_seq" id="dtl_seq" value=""></td>';
		str += '	<td>';
		str += '		<select name="deal_code'+ht_cnt+'" id="deal_code'+ht_cnt+'" title="거래 구분" onchange="chgDealCode(this.value, '+ht_cnt+');">';
		str += '		</select>';
		str += '	</td>';		
		str += '	<td>';
		str += '		<input type="text" name="contract_seq'+ht_cnt+'" id="contract_seq'+ht_cnt+'" title="계약서 번호 입력" />';
		str += '	</td>';
		str += '	<td>';
		str += '		<input type="text" name="contract_nm'+ht_cnt+'" id="contract_nm'+ht_cnt+'" title="계약서 명 입력" />';
		str += '	</td>';
		str += '	<td>';
		str += '		<input type="text" name="contract_dt'+ht_cnt+'" id="contract_dt'+ht_cnt+'" class="w90" title="계약일자 입력" />';
		str += '	</td>';
		str += '	<td>';
		str += '		<select name="bill_code'+ht_cnt+'" id="bill_code'+ht_cnt+'" title="수금정보 선택">';
		str += '			<option value="">SMS 유보료</option>';
		str += '		</select>';
		str += '	</td>';
		str += '	<td>';
		str += '		<select name="mtac_code'+ht_cnt+'" id="mtac_code'+ht_cnt+'" title="유지보수 구분">';
		str += '			<option value="">유상</option>';
		str += '		</select>';
		str += '	</td>';
		str += '	<td>';
		str += '		<input type="text" name="mtac_start_dt'+ht_cnt+'" id="mtac_start_dt'+ht_cnt+'" class="w90" title="유지보수 시작일 입력" />';
		str += '		~';
		str += '		<input type="text" name="mtac_end_dt'+ht_cnt+'" id="mtac_end_dt'+ht_cnt+'" class="w90 mgl5" title="유지보수 시작일 입력" />';
		str += '	</td>';
		str += '	<td><input type="text" name="mon_off_amt'+ht_cnt+'" id="mon_off_amt'+ht_cnt+'" title="월 유보금액 입력" /></td>';
		//str += '	<td><input type="text" name="year_off_amt'+ht_cnt+'" id="year_off_amt'+ht_cnt+'" title="년 유보금액 입력" /></td>';
		
		str += '	<td>';
		str += '		<select name="buy_busi_name'+ht_cnt+'" id="buy_busi_name'+ht_cnt+'" title="매입업체명">';
		str += '		</select>';
		str += '	</td>';	
		str += '	<td>';
		str += '		<input type="text" name="buy_cost'+ht_cnt+'" id="buy_cost'+ht_cnt+'" title="매입원가" />';
		str += '		</select>';
		str += '	</td>';	
		str += '	<td>';
		str += '		<select name="service_period'+ht_cnt+'" id="service_period'+ht_cnt+'" title="서비스주기">';
		str += '		</select>';
		str += '	</td>';	
		str += '	<td>';
		str += '		<select name="service_method'+ht_cnt+'" id="service_method'+ht_cnt+'" title="서비스방법">';
		str += '		</select>';
		str += '	</td>';	
		str += '	<td>';
		str += '		<input type="checkbox" name="auto_renew_yn'+ht_cnt+'" id="auto_renew_yn'+ht_cnt+'" value="Y" title="자동갱신여부">';
		str += '	</td>';	
		
		str += '	<td><button type="button" class="btn_line_gray small w37" onclick="btnPayInfo('+ht_cnt+');">보기</button></td>';
		str += '	<td><button type="button" class="btn_line_gray small w37" onclick="btnMeno('+ht_cnt+');">보기</button></td>';
		str += '	<td><!-- 홍길동 --></td>';
		str += '	<td><!-- 2017-01-01 00:00:00 --></td>';
		str += '</tr>';
		$('#hist_wrap').append(str);
		
		$( "#mtac_start_dt"+ht_cnt ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#mtac_end_dt"+ht_cnt ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#contract_dt"+ht_cnt ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		$('#bill_code' + ht_cnt).empty().append(bill_code_option) ; 
		$('#mtac_code' + ht_cnt).empty().append(mtac_code_option) ; 
		$('#deal_code' + ht_cnt).empty().append(deal_code_option) ; 
		
		$('#buy_busi_name' + ht_cnt).empty().append(buy_busi_option) ;
		$('#service_period' + ht_cnt).empty().append(sv_period_option) ;
		$('#service_method' + ht_cnt).empty().append(sv_method_option) ;
		
		$('#etcWrap').append('<input type="hidden" name="etc'+ht_cnt+'" id="etc'+ht_cnt+'" />');
		
	}
	
	function delMThist() {
		if ($('#hist_wrap input[type=checkbox]:checked').length == 0) {
			alert('삭제하실 행을 체크해 주세요.');
			return;
		}
		$('#hist_wrap input[type=checkbox]:checked').each(function(){
			if (common.isEmpty($('#del_dtl_seq').val())) $('#del_dtl_seq').val($(this).val());
			else $('#del_dtl_seq').val($('#del_dtl_seq').val() + "@" + $(this).val());
			$(this).parent().parent('tr').remove();
		});
	}
	
	function goProc(){
		var f = document.procFrm;
		f.pageType.value = '${vo.pageType}';
		
		f.ht_cnt.value = ht_cnt ;
		common.ajaxCall($('form[name=procFrm]').serialize() , '/ad/cust/proc5.do' , 'procReturn') ; 
	}
	
	function moveTab(gubun){
		if (projectCnt == 0 && gubun == '3') {
			alert('프로젝트 정보를 등록해 주세요.');
			return;
		}
		location.href = "/ad/cust/form" + gubun + ".do${ QUERYSTRING }" ; 
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
		var f = document.procFrm;
		
		f.action = '/ad/cust/list.do';
		f.submit();
	}
	
	var etc_num = '';
	
	function btnMeno(num) {
		var etc_content = $('#etc'+num).val();
		$("#show_etc").val(etc_content);
		$('#memoInfoLayer').show();
		etc_num = num;
	}
	
	function memoLayerConfirm() {
		$('#etc'+etc_num).val($("#show_etc").val());
		etc_num = '';
		$('#memoInfoLayer').hide();
	}
	
	function memoLayerClose() {
		$('#show_etc').val('');
		$('#show_etc').val($("#etc"+etc_num).val());
		$('#memoInfoLayer').hide();
	}
	
	function btnPayInfo(num) {
		if($('#bill_code'+num).val() == 'C004' || $('#bill_code'+num).val() == 'C001') {
			$('#payInfoLayer').show();
			var staetDate = (setY-1)+"/"+(setM < 10 ? '0' + setM : setM) ; 
			var endDate = setY+"/"+(setM < 10 ? '0' + setM : setM) ; 
			$( "#search_start" ).val(staetDate).monthpicker(monthpicker_option);
			$( "#search_end" ).val(endDate).monthpicker(monthpicker_option);
			getPayInfo(num);
			
			$( "#search_start, #search_end" ).change(function(){
				getPayInfo(num);
			});			
		} else {
			alert('유지보수 이력이 존재하지 않습니다.');
		}
	}
	
	function payLayerClose() {
		$('#payInfoLayer').hide();
		$('#setPayTable').empty();
	}
	
	function getPayInfo(num) {
		
		var datas = {
				'crm_code' : $('#crm_code').val(),
				'bill_code' : $('#bill_code'+num).val()
		} ;
		$('#svae_bill_code').val($('#bill_code'+num).val());
		common.ajaxCall(datas , '/ad/cust/getPayInfo.do' , 'setPayInfo') ; 
	}
	
	function setPayInfo(data) {
		 var resultList = typeof data.resultList != 'undefined' ? data.resultList : null;
		 
		 var str = '';
		 var total_ubo_amt = 0;
		 var total_su_amt = 0;
		 var total_receive_amt = 0;
		 
		 if (resultList != null && resultList.length>0) {
			 
			for (var i=0; i<resultList.length;i++) {
				var datas = resultList[i];
				
				if (total_ubo_amt == 0) total_ubo_amt = parseInt(datas.ubo_amt);
				else total_ubo_amt = total_ubo_amt + parseInt(datas.ubo_amt);
				if (total_su_amt == 0) total_su_amt = parseInt(datas.su_amt);
				else total_su_amt = total_su_amt + parseInt(datas.su_amt);
			}
			total_receive_amt = total_ubo_amt - total_su_amt;
			
			$('#total_ubo_amt').val((total_ubo_amt == 0) ? 0 : common.comma(total_ubo_amt));
			$('#total_su_amt').val((total_su_amt == 0) ? 0 : common.comma(total_su_amt));
			$('#total_receive_amt').val((total_receive_amt == 0) ? 0 : common.comma(total_receive_amt));
		 }
		 
		 setSubPayInfo();
	}
	
	function setSubPayInfo() {
		
		var subDatas = {
				'crm_code' : $('#crm_code').val()
				,'search_start' : $('#search_start').val()
				,'search_end' : $('#search_end').val()
				,'bill_code' : $('#svae_bill_code').val()
		};
		
		$.ajax({
			type : 'post' ,
			url : '/ad/cust/getPayInfo.do' , 
			data : subDatas ,
			dataType : 'json' , 
			statusCode : {
				403:function(data){
					alert("권한이 없습니다.");
				},
				404:function(data){
					alert('해당 페이지가 존재하지 않습니다.');
				}
			}, 
			success : function(data){
				
				var resultList2 = typeof data.resultList != 'undefined' ? data.resultList : null;
				
				var strHeader = '';
				var strFooter = '';
				var str = '';
				var cur_erp_code = '';
				
				if (resultList2 != null && resultList2.length > 0) {
					var prev_re_amt = 0; //20171110 미수금 누계용 변수 추가
					for (var i=0; i<resultList2.length; i++) {
						var subDatas = resultList2[i];
						
						if ($.trim(cur_erp_code) == '' || $.trim(cur_erp_code) != $.trim(subDatas.erp_code)) { 
							strHeader += '<div id="putPayTable'+i+'">';
							strHeader += '	<h4>[ERP코드, '+subDatas.erp_code+']</h4>';
							strHeader += '	<table class="hType mgb20">';
							strHeader += '		<caption>수금이력</caption>';
							strHeader += '		<colgroup>';
							strHeader += '			<col style="width:100px;" />';
							strHeader += '			<col span="3" style="width:auto;" />';
							strHeader += '		</colgroup>';
							strHeader += '		<tr>';
							strHeader += '			<th>결제월</th>';
							strHeader += '			<th>월 유보금액</th>';
							strHeader += '			<th>수금금액</th>';
							strHeader += '			<th>미수금</th>';
							strHeader += '		</tr>';
						} 
						
						var month = (subDatas.sale_ym).substring(0,4) + '/' +(subDatas.sale_ym).substring(4,6);
						str += '		<tr>';
						str += '			<th>'+ month +'</th>';
						str += '			<td><input type="text" name="ubo_amt'+i+'" value="'+common.comma(subDatas.ubo_amt)+'" class="w120 mgr5" readonly="readonly"></td>';
						str += '			<td><input type="text" name="su_amt'+i+'" value="'+common.comma(subDatas.su_amt)+'" class="w120 mgr5" readonly="readonly"></td>';
						str += '			<td><input type="text" name="re_amt'+i+'" value="'+common.comma((Number(subDatas.ubo_amt) - Number(subDatas.su_amt)) + Number(prev_re_amt))+'" class="w120 mgr5" readonly="readonly"></td>'; //20171110 미수금 누계를 더하는 식으로 변경
						str += '		</tr>';
						prev_re_amt = (Number(subDatas.ubo_amt) - Number(subDatas.su_amt)) + Number(prev_re_amt); //20171110 미수금 누계
						if (cur_erp_code == '') { 
							strFooter += '	</table>';
							strFooter += '</div>';
						}
						
						cur_erp_code = subDatas.erp_code;
					}	
					$('#setPayTable').empty(); //이 전의 미수금 데이터 그려져있던 부분 초기화
					$('#setPayTable').append(strHeader + str + strFooter);
				
				}
			}
		}) ; 	
	}
		
</script>

<div class="tit_wrap">
<h2 class="tit_ico_customer">거래처 관리<span class="tit_depth mgl20 mgt8">유지보수이력</span></h2>

</div>
<div class="tit_sWrap">
	<h3 class="tit_dot_gray">거래처 상세 정보<c:if test="${ vo.pageType ne 'insert' }">&nbsp;&lt;<span class="colorBlue mg15" style="line-height:25px;">${ vo.cust_kor_name }, ${ vo.crm_code }</span>&gt;</c:if></h3>
</div>
<!-- tab -->
<ul class="tab_line list6 mgb20">
	<li><a href="javascript:moveTab('');">관리 정보</a></li><!-- 활성시 current -->
	<li><a href="javascript:moveTab('2');">프로젝트 정보</a></li>
	<li><a href="javascript:moveTab('3');">운영 정보</a></li>
	<li><a href="javascript:moveTab('4');">시스템 이력</a></li>
	<li class="active"><a href="javascript:moveTab('5');">유지보수 이력</a></li>
	<li><a href="javascript:moveTab('6');">문서관리</a></li>
</ul>
<!--// tab -->
<!-- list -->
<div class="tit_bWrap mgb10">
	<h4 class="floatL mgt8">계약정보 내역</h4>
	<span class="floatR">
		<button class="btn_ico_circle_plus_g mgr5" onclick="addMThist();"><span>항목추가</span></button>
		<button class="btn_ico_stop_g" onclick="delMThist();"><span>항목삭제</span></button>
	</span>
</div>
<div class="wrapTable mgb20">

<form name="procFrm" method="post" onsubmit="return false;">
	<input type="hidden" name="seq"  		id="seq" 			value="${ vo.seq }"/>
	<input type="hidden" name="pageType" id="pageType" 	value="${ vo.pageType }"/>
	<input type="hidden" name="ht_cnt"  	id="ht_cnt" 		value=""/>
	<input type="hidden" name="del_dtl_seq"  	id="del_dtl_seq" 		value=""/>
	<input type="hidden" name="crm_code"  	id="crm_code" 		value="${ vo.crm_code }"/>
	
	<div id="etcWrap"></div>

	<table class="hType mgb10">
		<caption>계약정보 내역</caption>
		<colgroup>
			<col style="width: 35px" />
			<col style="width: 90px" />
			<col style="width: 100PX" />
			<col style="width: 90px" />
			<col style="width: 120px" />
			<col style="width: 110px" />
			<col style="width: 90px" />
			<col style="width: 260px" />
			<col style="width: 90px" />
			<col style="width: 90px" />
			<col style="width: 90px" />
			<col style="width: 90px" />
			<col style="width: 90px" />
			<col style="width: 90px" />
			<col style="width: 50px" />
			<col style="width: 40px" />
			<col style="width: 50px" />
			<col style="width: 80px" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">선택</th>
				<th scope="col">거래구분</th>
				<th scope="col">계약서 번호</th>
				<th scope="col">계약서 명</th>
				<th scope="col">계약일자</th>
				<th scope="col">품목</th>
				<th scope="col">유/무상구분</th>
				<th scope="col">유지보수기간</th>
				<th scope="col">월 유보금액</th>
				<th scope="col">매입업체명</th>
				<th scope="col">매입원가</th>
				<th scope="col">서비스주기</th>
				<th scope="col">서비스방법</th>
				<th scope="col">자동갱신여부</th>
				<th scope="col">수금정보</th>
				<th scope="col">메모</th>
				<th scope="col">등록자</th>
				<th scope="col">등록일시</th>
			</tr>
		</thead>
		<tbody id="hist_wrap"></tbody>
	</table>
</div>
<!--// list -->
<div class="btn_wrap">
	<div class="floatL">
		<button type="button" class="btn_ico_list" onclick="goList();"><span>목록</span></button>
	</div>
	<div class="floatR">
		<button type="button" class="btn_ico_confirm" onclick="goProc();"><span>저장</span></button>
		<button type="button" class="btn_ico_cancel" onclick="goList();"><span>취소</span></button>
	</div>
</div>

<!-- 메모 레이어 팝업 -->
<div id="memoInfoLayer" style="display:none;">
	<div class="box_layer layer_sms" style="height:230px;margin-top:-115px">
		<h1>메모</h1>
		<div class="layer_contents" style="padding-top:20px;">
			<textarea name="show_etc" id="show_etc"></textarea>
			<div class="btn_wrap mgt20">
				<div class="floatR">
					<button type="button" class="btn_ico_confirm mgr5" onclick="memoLayerConfirm();"><span>저장</span></button>
					<button type="button" class="btn_ico_cancel" onclick="memoLayerClose();"><span>취소</span></button>
				</div>
			</div>		
		</div>
		<button type="button" class="btn_close" onclick="memoLayerClose();">창 닫기</button>
	</div>
	<div class="layer_dimmed"></div>
</div>

<!-- 수금정보 레이어팝업 -->
<div id="payInfoLayer" style="display:none;">
	<input type="hidden" id="svae_bill_code" value="" />
	<div class="box_layer layer_sms" style="height:800px;margin-top:-400px;">
		<h1>수금정보</h1>
		<div class="layer_contents" style="padding-top:20px;height:auto;">
		    <h3 class="tit_sWrap">총 수금정보</h3>
			<table class="hType mgb20">
				<caption>총 수금정보</caption>
				<colgroup>
					<col style="width:100px;" />
					<col span="3" style="width:auto;" />
				</colgroup>
				<tr>
					<th>결제월</th>
					<th>월 유보금액</th>
					<th>수금금액</th>
					<th>미수금</th>
				</tr>
				<tr>
					<th>총계</th>
					<td><input type="text" id="total_ubo_amt" name="total_ubo_amt" class="w115 mgr5" readonly="readonly" value="0">원</td>
					<td><input type="text" id="total_su_amt" name="total_su_amt" class="w115 mgr5" readonly="readonly" value="0">원</td>
					<td><input type="text" id="total_receive_amt" name="total_receive_amt" class="w115 mgr5" readonly="readonly" value="0">원</td>
				</tr>
			</table>
			<div class="floatWrap">
	               <h3 class="tit_sWrap floatL mgt8">수금이력</h3>
	               <div class="floatR">
	                   결제 월 : <input type="text" class="w100 mgl10 mgr5" id="search_start" name="search_start">~<input type="text" id="search_end" name="search_end" class="w100 mgl10 mgr5">
	               </div>   
			</div>
			<div id="setPayTable" style="height:520px;overflow-y:auto;border:1px solid #dadada;padding:10px;">
			
			</div>
		</div>
		<button type="button" class="btn_close" onclick="payLayerClose();">창 닫기</button>
	</div>
	<div class="layer_dimmed"></div>
</div>
</form>