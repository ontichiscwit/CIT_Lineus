<%@page import="egovframework.com.comm.util.CommonExecute"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.mtz.monthpicker.js"></script>
<script type="text/javascript">
	var ht_cnt = 0;
	var bill_code_option = "";
	var mtac_code_option = "";
	var deal_code_option = "";
	var buy_busi_option = "";
	var sv_period_option = "";
	var sv_method_option = "";

	$(document).ready(function() {
		
		commonCode.getCodeList("CUST","CD28","m_bill_code");
		commonCode.getCodeList("CUST","CD29","m_mtac_code");
		commonCode.getCodeList("CUST","CD35","m_deal_code");
		commonCode.getCodeList("CUST","CD36","m_buy_busi_name");
		commonCode.getCodeList("CUST","CD37","m_service_period");
		commonCode.getCodeList("CUST","CD38","m_service_method");
		
		//천단위 콤마
		function numberWithCommas(x) {
		    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		}
		
		initView();
	});

	function initView() {
		if (common.nvl('${vo.seq}', '') == '') {
			alert('관리정보를 등록해 주세요.');
			location.href = '/ad/cust/form.do';
			return;
		}

		var datas = {
			'crm_code' : $("#crm_code").val()
		}
		common.ajaxCall(datas, '/ad/cust/getErpMtHist.do', 'drawErpList');

		var datas = {
			'seq' : $('#seq').val()
		};
		common.ajaxCall(datas, '/ad/cust/getProjectCnt.do', 'setProjectCnt');

		// 		var datas = {'seq' : $('#seq').val()} ;
		// 		common.ajaxCall(datas , '/ad/cust/getMtacHistInfo.do' , 'setMtacInfo') ; 

		//계약추가 팝업 날짜 세팅
		$("#gyeyag_il").datepicker(datepicker);
		$("#st_date").datepicker(datepicker);
		$("#end_date").datepicker(datepicker);

	
		
		$('#supp_amt').keyup(function(e) {
			
			var thisVal = $(this).val();
			var thisVat = $('#vat').val();
			thisVal = thisVal.replace(/,/g, '');
			thisVat = thisVat.replace(/,/g, '');
			var thisTotAmt = Number(thisVal) + Number(thisVat);
			
			$(this).val(numberWithCommas(thisVal));
			$('#in_tot_amt').val(numberWithCommas(thisTotAmt));
			
		});

		$('#vat').keyup(function(e) {
			var thisVal = $(this).val();
			var thisAuppAmt = $('#supp_amt').val();
			thisVal = thisVal.replace(/,/g, '');
			thisAuppAmt = thisAuppAmt.replace(/,/g, '');
			var thisTotAmt = Number(thisVal) + Number(thisAuppAmt);
			
			$(this).val(numberWithCommas(thisVal));
			$('#in_tot_amt').val(numberWithCommas(thisTotAmt));
			
		});

	}

	function drawErpList(data) {
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null;

		if (resultList == null)
			return;

		var str = "";
		
		// 목록중에 item_cd별로 가장 위 행의 색을 달리한다.
		var cuItemCd = "";
		var rowBgColor = "";
		
		for (var i = 0; i < resultList.length; i++) {
			
			// 추가 정보 가 있는 경우 mtac_code 값이 온다. 이를 이용하여 버튼라벨을 만든다.
			var btnLabel = "";
			if (resultList[i].mtac_code){
				btnLabel = "상세조회";
			}else{
				btnLabel = "상세등록";
			}
			
			if (cuItemCd != resultList[i].item_cd){
				rowBgColor = "#e8eaea";
				cuItemCd = resultList[i].item_cd;
			}else{
				rowBgColor = "";
			}

			str += "<tr style='background-color:"+rowBgColor+"'>";
			
			// virtual_contract의 경우만 체크박스를 만든다.
			if (resultList[i].t_code == "Z"){
				str += "	<td>" + '<input type="checkbox" data="'+common.nvl(resultList[i].vw_pk, '')+'"/>' + "</td>"; //체크박스
			}else{
				str += "	<td> - </td>"; //체크박스
			}
			
			str += "	<td>" + resultList[i].item_grp1_nm + "</td>";//분류
			str += "	<td id='item_cd"+i+"' data='"+resultList[i].item_cd+"' >" + resultList[i].item_nm + "</td>";//품목명
			str += "	<td>" + common.strToDate(common.nvl(resultList[i].contract_date, '')) + "</td>"; //계약일자
			str += "	<td>" + common.strToDate(resultList[i].st_date) + "~" + common.strToDate(resultList[i].end_date) + "</td>"; //계약기간
			
			str += "	<td>" + common.comma(resultList[i].tot_amt);
			// virual_contract가 아닌경우에만 수금내역 버튼을 만들어준다.
			if (resultList[i].t_code != "Z"){
				str += "	<button class='btn_line_gray' onclick='btnPayInfo("+i+");'>수금내역</button>";
			}
			str += "	</td>";//월 유지보수 금액(VAT포함)
			
			str += "	<td>" + common.nvl(resultList[i].memo, '') + "</td>";//비고
			str += "	<td>" + common.nvl(resultList[i].reg_id, '') + "</td>";//등록구분
			str += "	<td>";
			// virtual_contract의 경우만 수정버튼을 만든다.
			if (resultList[i].t_code == "Z"){
				str += '	<button class="btn_line_gray" style="width:60px;" onclick="openContract(\''+common.nvl(resultList[i].pk_seq, '')+'\');">계약수정</button>';
			}
			str += '	<button class="btn_line_gray"  style="width:60px;" onclick="contactDtInfoOpen(\''+common.nvl(resultList[i].vw_pk, '')+'\');">'+btnLabel+'</button>';
			str += "	</td>";//상세계약정보
			str += "</tr>";
		}

		$("#erpHistList").html(str);
	}

	var projectCnt = 0;
	function setProjectCnt(data) {
		projectCnt = typeof data.cnt != 'undefined' ? data.cnt : 0;
	}

	function moveTab(gubun) {
		if (projectCnt == 0 && gubun == '3') {
			alert('프로젝트 정보를 등록해 주세요.');
			return;
		}
		location.href = "/ad/cust/form" + gubun + ".do${ QUERYSTRING }";
	}

	function goList() {
		var f = document.procFrm;

		f.action = '/ad/cust/list.do' + window.location.search.substring();
		f.submit();
	}

	//계약추가 팝업
	function openContract(pk_seq) {
		// 가상 계약 테이블에서 정보를 가져와 셋팅한다.
		if (pk_seq){
			
			$("#virtualContractLabel").html("계약수정");
			
			var datas = {"seq":pk_seq};
			$.ajax({
				type			: 'POST',
				url				: '/ad/cust/getVirtualContractInfo.do',
				dataType		: "json",
				async 			: false,
				data			: datas,
				success: function(data) {
					if (data.resultObj){
						$("#v_seq").val(pk_seq);
						$("#code_item").val(data.resultObj.code_item);
						$("#supp_amt").val(numberWithCommas(data.resultObj.supp_amt));
						$("#vat").val(numberWithCommas(data.resultObj.vat));
						$("#st_date").val(strToDate(data.resultObj.st_date));
						$("#end_date").val(strToDate(data.resultObj.end_date));
						$("#gyeyag_il").val(strToDate(data.resultObj.gyeyag_il));
						$("#memo").val(data.resultObj.memo);
						var in_tot_amt = Number(data.resultObj.vat) + Number(data.resultObj.supp_amt)
						$("#in_tot_amt").val( numberWithCommas(in_tot_amt) ); 
						
					}else{
						document.virtual_contract.reset();
						$("#v_seq").val(pk_seq);
					}
					
					$('#contactInfoLayer').show();
				}
				,statusCode : {
					403:function(data){
						alert("권한이 없습니다.");
					},
					404:function(data){
						alert('해당 페이지가 존재하지 않습니다.');
					}
				}
			});
			
		}else{
			$("#virtualContractLabel").html("계약추가");
			document.virtual_contract.reset();
			$('#contactInfoLayer').show();
		}
		
		
	}
	
	
	function strToDate(str){
		if (str == null || str.length < 8) return str;
		
		return str.substr(0,4) + '/' + str.substr(4,2) + '/' + str.substr(6,2);
	}

	function closeContract() {
		$('#contactInfoLayer').hide();
	}

	//계약상세정보팝업
	function contactDtInfoOpen(vwPk) {
		
		// 추가 정보 테이블에서 정보를가져와 셋팅한다.
		var datas = {"vw_pk":vwPk};
		$.ajax({
			type			: 'POST',
			url				: '/ad/cust/getMaintenanceAddInfo.do',
			dataType		: "json",
			async 			: false,
			data			: datas,
			success: function(data) {
				
				if (data.resultObj){
					$("#m_vw_pk").val(data.resultObj.vw_pk);
					$("#m_contract_seq").val(data.resultObj.contract_seq);
					$("#m_contract_nm").val(data.resultObj.contract_nm);
					$("#m_bill_code").val(data.resultObj.bill_code);
					$("#m_mtac_code").val(data.resultObj.mtac_code);
					$("#m_mon_off_amt").val(data.resultObj.mon_off_amt);
					$("#m_year_off_amt").val(data.resultObj.year_off_amt);
					$("#m_etc").val(data.resultObj.etc);
					$("#m_reg_nm").val(data.resultObj.reg_nm);
					$("#m_reg_date").val(data.resultObj.reg_date);
					$("#m_deal_code").val(data.resultObj.deal_code);
					$("#m_buy_busi_name").val(data.resultObj.buy_busi_name);
					$("#m_buy_cost").val( numberWithCommas(data.resultObj.buy_cost) );
					$("#m_service_period").val(data.resultObj.service_period);
					$("#m_service_method").val(data.resultObj.service_method);
					
					document.maintenanceAdd.auto_renew_yn.value = data.resultObj.auto_renew_yn;
					
					if (document.maintenanceAdd.auto_renew_yn.value == "Y"){
						$("#m_auto_renew_yn").attr("checked",true);
					}
					
					if(data.resultObj.mtac_code != 'C012'){
						$('#m_buy_cost').attr("readonly",true);
						$("#m_buy_busi_name").attr("disabled", "disabled").css('background-color','#f3f3f3');
						$("#m_service_period").attr("disabled", "disabled").css('background-color','#f3f3f3');
						$("#m_service_method").attr("disabled", "disabled").css('background-color','#f3f3f3');
					}
				}else{
					$('#m_buy_cost').attr("readonly",true);
					$("#m_buy_busi_name").attr("disabled", "disabled").css('background-color','#f3f3f3');
					$("#m_service_period").attr("disabled", "disabled").css('background-color','#f3f3f3');
					$("#m_service_method").attr("disabled", "disabled").css('background-color','#f3f3f3');
					
					document.maintenanceAdd.reset();
					$("#m_vw_pk").val(vwPk);
				}
				
				$('#contactDeInfoLayer').show(function(){
					validateContactDtInfo();
				});
				
					
			}
			,statusCode : {
				403:function(data){
					alert("권한이 없습니다.");
				},
				404:function(data){
					alert('해당 페이지가 존재하지 않습니다.');
				}
			}
		});
		
	}
	
	
	
	function validateContactDtInfo() {
		
		$('#m_mtac_code').change(function(){
			
			if( $(this).val() == 'C012'){
				$('#m_buy_cost').attr("readonly",false);
				$("#m_buy_busi_name").removeAttr("disabled").css('background-color','#fff');
				$("#m_service_period").removeAttr("disabled").css('background-color','#fff');
				$("#m_service_method").removeAttr("disabled").css('background-color','#fff');
			}else{
				$('#m_buy_cost').attr("readonly",true); $('#m_buy_cost').val('');
				$("#m_buy_busi_name").attr("disabled", "disabled").css('background-color','#f3f3f3'); $("#m_buy_busi_name").val('');
				$("#m_service_period").attr("disabled", "disabled").css('background-color','#f3f3f3');$("#m_service_period").val('');
				$("#m_service_method").attr("disabled", "disabled").css('background-color','#f3f3f3');$("#m_service_method").val('');
			}  	
		});
		
	}
	
	
	function closeContractDe() {
		$('#contactDeInfoLayer').hide();
	}

	function regVirtualContract(frm) {
		if (frm.cust_code.value == ""){
			alert('해당 거래처의 erp 코드가 존재하지 않아 등록 할 수 없습니다.');
			return false;
		}
		
		if (frm.gyeyag_il.value == ""){
			alert('계약일자를 선택하세요');
			return false;
		}else{
			frm.gyeyag_il.value = common.replaceAll(frm.gyeyag_il.value,'/','');
		}
		
		if (frm.st_date.value == ""){
			alert('계약시작일을 선택하세요');
			return false;
		}else{
			frm.st_date.value = common.replaceAll(frm.st_date.value,'/','');
		}
		
		if (frm.end_date.value == ""){
			alert('계약종료일을 선택하세요');
			return false;
		}else{
			frm.end_date.value = common.replaceAll(frm.end_date.value,'/','');
		}
		
		frm.supp_amt.value = frm.supp_amt.value.replace(/,/g, '');
		if (!$.isNumeric(frm.supp_amt.value)) {
			alert('공급가액은 숫자만 입력 가능 합니다.');
			frm.supp_amt.value="";
			frm.supp_amt.focus();
			return false;
		}
		
		frm.vat.value = frm.vat.value.replace(/,/g, '');
		if (!$.isNumeric(frm.vat.value)) {
			alert('부가세는 숫자만 입력 가능 합니다.');
			frm.vat.value="";
			frm.vat.focus();
			return false;
		}
		
		$.ajax({
			type : 'post',
			url : '/ad/cust/regVirtualContract.do',
			data : $(frm).serialize(),
			dataType : 'html',
			contentType : 'application/x-www-form-urlencoded; charset=UTF-8',
			success : function(datas) {
				var data = JSON.parse(datas);
				console.log(data);
				
				if(data.resultCode && data.resultCode == '000'){
					alert("정상 처리 되었습니다.");
					location.replace(location.href);
				}else if(data.resultCode && data.resultCode == '999'){
					if (data.errorMsg){
						alert("처리 실패 !!\r\n" + data.errorMsg);
					}else{
						alert("처리 실패 !!");
					}
				}
			}
			,statusCode : {
				403:function(data){
					alert("권한이 없습니다.");
				},
				404:function(data){
					alert('해당 페이지가 존재하지 않습니다.');
				}
			}
		});
		return false;
	}
	
	function delVirtualContract(){
		
		var pkArr = "";
		
		$("#erpHistList input[type=checkbox]").each(function (num){
			if ($(this).is(":checked")) pkArr += "," + $(this).attr("data"); 
		});
		
		if (pkArr != ""){
			pkArr = pkArr.slice(1);
			
			$.ajax({
				type : 'post',
				url : '/ad/cust/delVirtualContract.do',
				data : "pkArr="+pkArr,
				dataType : 'html',
				contentType : 'application/x-www-form-urlencoded; charset=UTF-8',
				success : function(datas) {
					var data = JSON.parse(datas);
					console.log(data);
					if(data.resultCode && data.resultCode == '000'){
						alert("정상 처리 되었습니다.");
						location.replace(location.href);
					}else if(data.resultCode && data.resultCode == '999'){
						if (data.errorMsg){
							alert("처리 실패 !!\r\n" + data.errorMsg);
						}else{
							alert("처리 실패 !!");
						}
					}
				}
				,statusCode : {
					403:function(data){
						alert("권한이 없습니다.");
					},
					404:function(data){
						alert('해당 페이지가 존재하지 않습니다.');
					}
				}
			});
		}
	}
	
	function regMaintenance(frm) {
		
		
		//frm.m_buy_cost.value = frm.m_buy_cost.value.replace(/,/g, '');
 		/* if (!$.isNumeric(frm.m_buy_cost.value)) {
 			alert('매입원가는 숫자만 입력 가능 합니다.');
 			frm.supp_amt.value="";
 			frm.supp_amt.focus();
 			return false;
 		} */

		if ($("#m_auto_renew_yn").is(":checked")){
			frm.auto_renew_yn.value = "Y";
		}else{
			frm.auto_renew_yn.value = "N";
		}
		
		$.ajax({
			type : 'post',
			url : '/ad/cust/regMaintenance.do',
			data : $(frm).serialize(),
			dataType : 'html',
			contentType : 'application/x-www-form-urlencoded; charset=UTF-8',
			success : function(datas) {
				var data = JSON.parse(datas);
				console.log(data);
				if(data.resultCode && data.resultCode == '000'){
					alert("저장되었습니다.");
				}else if(data.resultCode && data.resultCode == '999'){
					if (data.errorMsg){
						alert("처리 실패 !!\r\n" + data.errorMsg);
					}else{
						alert("처리 실패 !!");
					}
				}
				
				closeContractDe();
			}
			,statusCode : {
				403:function(data){
					alert("권한이 없습니다.");
				},
				404:function(data){
					alert('해당 페이지가 존재하지 않습니다.');
				}
			}
		});
		return false;
	}
	
	
	
	
	/*수금정보관련함수 */
	function btnPayInfo(num) {
		/* IN('C300000001','H000000110')  HIS 유보류*/
		/* IN('C300000005','C300000005')  SMS 유보류*/
		if($('#item_cd'+num).attr('data') == 'C300000001' || $('#item_cd'+num).attr('data') == 'C300000005') {
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
				'bill_code' : $('#item_cd'+num).attr('data')
		} ;
		
		$('#svae_bill_code').val($('#item_cd'+num).attr('data'));
		
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
			success : function(data){
				console.log(data);
				
				var resultList2 = typeof data.resultList != 'undefined' ? data.resultList : null;
				
				var strHeader = '';
				var strFooter = '';
				var str = '';
				var cur_erp_code = '';
				
				if (resultList2 != null) {
					
					$('#setPayTable').empty();
					
					var prev_re_amt = 0; //20171110 미수금 누계용 변수 추가
					for (var i=0; i<resultList2.length; i++) {
						var subDatas = resultList2[i];
						
						if ($.trim(cur_erp_code) != $.trim(subDatas.erp_code)) { 
							strHeader = '<div>';
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
							strHeader += '		<tbody id="payTb'+subDatas.erp_code+'">';
							strHeader += '		</tbody>';
							strHeader += '	</table>';
							strHeader += '</div>';
							$('#setPayTable').append(strHeader);
							cur_erp_code = subDatas.erp_code;
							prev_re_amt = 0; //20171110 미수금 누계용 변수 추가
						} 
						
						var month = (subDatas.sale_ym).substring(0,4) + '/' +(subDatas.sale_ym).substring(4,6);
						str = '		<tr>';
						str += '			<th style="background-color:#81959d ; border-right:0 px;color:#fff; ">'+ month +'</th>';
						str += '			<td><input type="text" name="ubo_amt'+i+'" value="'+common.comma(subDatas.ubo_amt)+'" class="w120 mgr5 textR" readonly="readonly"></td>';
						str += '			<td><input type="text" name="su_amt'+i+'" value="'+common.comma(subDatas.su_amt)+'" class="w120 mgr5 textR" readonly="readonly"></td>';
						str += '			<td><input type="text" name="re_amt'+i+'" value="'+common.comma((Number(subDatas.ubo_amt) - Number(subDatas.su_amt)) + Number(prev_re_amt))+'" class="w120 mgr5 textR" readonly="readonly"></td>'; //20171110 미수금 누계를 더하는 식으로 변경
						str += '		</tr>';
						prev_re_amt = (Number(subDatas.ubo_amt) - Number(subDatas.su_amt)) + Number(prev_re_amt); //20171110 미수금 누계
						
						$("#payTb" + subDatas.erp_code).append(str);
					}	
				}
				if(resultList2.length == 0){
					console.log("정보없음");
					
					
					var str = '<p style="font-size: 36px; font-weight: 700; text-align:center; line-height: 1.2em; letter-spacing: -0.05em; margin: 50px 0 20px;">해당 정보가 없습니다<br>날짜를 다시 검색해 주세요</p>';
					$('#setPayTable').append(str);
					
				}
			}
			,statusCode : {
				403:function(data){
					alert("권한이 없습니다.");
				},
				404:function(data){
					alert('해당 페이지가 존재하지 않습니다.');
				}
			}
		}) ; 	
	}
	
</script>

<div class="tit_wrap">
	<%=CommonExecute.returnLineMap(request)%> 
</div>
<div class="tit_sWrap">
	<h3 class="tit_dot_gray">
		거래처 상세 정보
		<c:if test="${ vo.pageType ne 'insert' }">&nbsp;&lt;<span class="colorBlue mg15" style="line-height: 25px;">${ vo.cust_kor_name },
				${ vo.crm_code }</span>&gt;</c:if>
	</h3>
</div>
<!-- tab -->
<ul class="tab_line list7 mgb20">
	<li><a href="javascript:moveTab('');">관리 정보</a></li>
	<!-- 활성시 current -->
	<li><a href="javascript:moveTab('2');">프로젝트 정보</a></li>
	<li><a href="javascript:moveTab('3');">운영 정보</a></li>
	<li><a href="javascript:moveTab('4');">시스템 이력</a></li>
	<li class="active"><a href="javascript:moveTab('5');">유지보수 이력</a></li>
	<li><a href="javascript:moveTab('7');">매출 이력(부가솔루션)</a></li>
	<li><a href="javascript:moveTab('6');">문서관리</a></li>
</ul>
<!--// tab -->
<!-- list -->
<div class="tit_bWrap mgb10">
	<h4 class="floatL mgt8">계약정보 내역</h4>
	
	<div class="btn_wrap">
		<div class="floatR">
			<button type="button" class="btn_ico_circle_plus" onclick="openContract()">
				<span>계약추가</span>
			</button>
			<button type="button" class="btn_ico_stop" onclick="delVirtualContract()">
				<span>계약삭제</span>
			</button>
		</div>
	</div>
</div>
<div class="wrapTable mgb20">

	<form name="procFrm" method="post" onsubmit="return false;">
		<input type="hidden" name="seq" id="seq" value="${ vo.seq }" /> <input type="hidden" name="pageType" id="pageType"
			value="${ vo.pageType }"
		/> <input type="hidden" name="ht_cnt" id="ht_cnt" value="" /> <input type="hidden" name="del_dtl_seq"
			id="del_dtl_seq" value=""
		/> <input type="hidden" name="crm_code" id="crm_code" value="${ vo.crm_code }" />


		<table class="hType mgb10">
			<colgroup>
				<col style="width: 40px" />
				<!--선택  -->
				<col style="width: 90px" />
				<!--분류  -->
				<col style="width: 50PX" />
				<!--품목명 -->
				<col style="width: 90px" />
				<!--계약일자 -->
				<col style="width: 160px" />
				<!--계약기간 -->
				<col style="width: 110px" />
				<!--유지보수금액-->
				<col style="width: auto" />
				<!--비고 -->
				<col style="width: 50px" />
				<!--등록구분  -->
				<col style="width: 140px" />
				<!--버튼 -->
			</colgroup>
			<thead>
				<tr>
					<th scope="col">선택</th>
					<th scope="col">분류</th>
					<th scope="col">품목명</th>
					<th scope="col">계약일자</th>
					<th scope="col">계약기간</th>
					<th scope="col">유지보수금액<br>(VAT포함)</th>
					<th scope="col">비고</th>
					<th scope="col">등록구분</th>
					<th scope="col">상세계약정보</th>
				</tr>
			</thead>
			<tbody id="erpHistList">

			</tbody>
		</table>
	</form>
</div>
<!--// list -->
<div class="btn_wrap">
	<div class="floatL">
		<button type="button" class="btn_ico_list" onclick="goList();">
			<span>목록</span>
		</button>
	</div>
</div>

<!-- 메모 레이어 팝업 -->
<div id="memoInfoLayer" style="display: none;">
	<div class="box_layer layer_sms" style="height: 230px; margin-top: -115px">
		<h1>메모</h1>
		<div class="layer_contents" style="padding-top: 20px;">
			<textarea name="show_etc" id="show_etc"></textarea>
			<div class="btn_wrap mgt20">
				<div class="floatR">
					<button type="button" class="btn_ico_confirm mgr5" onclick="memoLayerConfirm();">
						<span>저장</span>
					</button>
					<button type="button" class="btn_ico_cancel" onclick="memoLayerClose();">
						<span>취소</span>
					</button>
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
					<th></th>
					<th>총 유보금액</th>
					<th>총 수금금액</th>
					<th>총 미수금</th>
				</tr>
				<tr>
					<th>총계</th>
					<td><input type="text" id="total_ubo_amt" name="total_ubo_amt" class="w115 mgr5 textR" readonly="readonly" value="0">원</td>
					<td><input type="text" id="total_su_amt" name="total_su_amt" class="w115 mgr5 textR" readonly="readonly" value="0">원</td>
					<td><input type="text" id="total_receive_amt" name="total_receive_amt" class="w115 mgr5 textR" readonly="readonly" value="0">원</td>
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


<!-- 가상계약 레이어팝업 -->
<form name="virtual_contract" id="virtual_contract" method="post" onsubmit="return false;">
	<input type="hidden" name="cust_code" value="${vo.erp_code}" />
	<input type="hidden" name="seq" id="v_seq"/>
	<div id="contactInfoLayer" style="display: none;">
		<div class="box_layer layer_sms" style="height: 400px; width: 700px; margin-top: -300px;">
			<h1 id="virtualContractLabel">계약 추가</h1>
			<div class="layer_contents" style="padding-top: 20px; height: auto;">
				<h3 class="tit_sWrap">계약정보 내역 <span class="colorBlue mg15"> &nbsp;>>&nbsp;저장,수정 권한은 시스템 관리자에게 문의하세요.</span></h3>
				<table class="sType mgb20">
					<caption>계약 정보</caption>
					<colgroup>
						<col style="width: 100px">
						<col style="width: 200px">
						<col style="width: 100px">
						<col style="width: 200px">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">품목명</th>
							<td>
								<!--ERP KYERP.TB_CM_ITEM_MST 테이블의 ITEM_CD 값중 하나 
								C300000001 - OCS/EMR 유보료,  
								C300000005 - SMS 유보료 
								C300000006 - H/W 유보료, 
								C300000013 : 기타유보료, 
								-->
								<select name="code_item" id="code_item" title="품목명" style="width: 172px;">
										<option value="C300000001">OCS/EMR 유보료</option>
										<option value="C300000005">SMS 유보료</option>
										<option value="C300000006">H/W 유보료</option>
										<option value="C300000013">기타유보료</option>
								</select>
							</td>
							<th scope="row">계약일자</th>
							<td><input type="text" name="gyeyag_il" id="gyeyag_il" class="w135 mgr2" title="계약일자" value="" readonly="readonly"></td>
						</tr>
						<tr>
							<th scope="row">계약기간</th>
							<td colspan="3">
								<input type="text" title="계약기간" name="st_date" id="st_date" class="w135 mgr2" readonly="readonly"> ~ 
								<input	type="text" title="계약기간" name="end_date" id="end_date"  class="w135 mgr2" readonly="readonly"></td>
						</tr>
						<tr>
							<th scope="row">유지보수금액</th>
							<td><input type="text" title="공급가액" class="textR" name="supp_amt" id="supp_amt" style="width: 172px;margin-bottom:5px;" placeholder="공급가액"
								value=""
							> <input type="text" class="textR" title="VAT" name="vat" id="vat" style="width: 172px;" placeholder="VAT" value=""></td>
							<th scope="row">총 유지보수금액</th>
							<td><input type="text" class="textR" title="총금액" id="in_tot_amt" style="width: 172px;" placeholder="공급가액 + VAT"
								readonly="readonly" value=""
							></td>
						</tr>
						<tr>
							<th scope="row">비고</th>
							<td colspan="3"><input type="text" name="memo" id="memo" title="비고" value="" class="mgr5""></td>
						</tr>

					</tbody>
				</table>
				<div class="btn_wrap mgt20">
					<div class="floatR">
						<button type="button" class="btn_ico_confirm mgr5" onclick="regVirtualContract(this.form)">
							<span>저장</span>
						</button>
						<button type="button" class="btn_ico_cancel" onclick="javascript:closeContract();">
							<span>취소</span>
						</button>
					</div>
				</div>
			</div>
			<button type="button" class="btn_close" onclick="javascript:closeContract();">창 닫기</button>
		</div>
		<div class="layer_dimmed"></div>
	</div>
</form>

<!-- 상세계약내용 레이어팝업 -->
<form name="maintenanceAdd" id="maintenanceAdd" method="post" onsubmit="return false;">
<input type="hidden" name="vw_pk" id="m_vw_pk">
<input type="hidden" name="auto_renew_yn" value="N">
<div id="contactDeInfoLayer" style="display: none;">
	<div class="box_layer layer_sms" style="height: 620px; width: 700px; margin-top: -300px;">
		<h1>상세 계약정보 등록</h1>
		<div class="layer_contents" style="padding-top: 20px; overflow-y:visible;">
			<h3 class="tit_sWrap">상세 계약정보</h3>
			<table class="sType mgb20">
				<caption>계약 정보</caption>
				<colgroup>
					<col style="width: 100px">
					<col style="width: 200px">
					<col style="width: 100px">
					<col style="width: 200px">
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">계약서번호<span class="request">필수입력</span></th>
						<td><input type="text" id="m_contract_seq" name="contract_seq" title="계약서번호" class="mgr5 " style="width: 172px;"></td>
						<th scope="row">계약서명<span class="request">필수입력</span></th>
						<td><input type="text" id="m_contract_nm" name="contract_nm" title="계약서명" class="mgr5 " style="width: 172px;"></td>
					</tr>
					<tr>
						<th scope="row">계약유형<span class="request">필수입력</span></th>
						<td><select id="m_mtac_code" name="mtac_code" title="계약유형" style="width: 172px;">
								<option value="1">1</option>
								<option value="2">2</option>
						</select></td>

						<th scope="row">매입업체명</th>
						<td><select id="m_buy_busi_name" name="buy_busi_name" title="매입업체명" style="width: 172px;">
								<option value="1">1</option>
								<option value="2">2</option>
						</select></td>
					</tr>
					<tr>
						<th scope="row">매입원가</th>
						<td colspan="3"><input type="text" id="m_buy_cost" name="buy_cost" title="매입원가" style="width: 172px;" placeholder="매입원가" value=""></td>
					</tr>
					<tr>
						<th scope="row">서비스주기</th>
						<td><select id="m_service_period" name="service_period" title="서비스주기" style="width: 172px;">
								<option value="1">1</option>
								<option value="2">2</option>
						</select></td>
						<th scope="row">서비스방법</th>
						<td><select id="m_service_method" name="service_method" title="서비스방법" style="width: 172px;">
								<option value="1">1</option>
								<option value="2">2</option>
						</select></td>
					</tr>
					<tr>
						<th scope="row">자동갱신여부</th>
						<td colspan="3"><input id="m_auto_renew_yn" type="checkbox" title="자동갱신여부"></td>
					</tr>
					<tr>
						<th scope="row">등록자</th>
						<td><input type="text" id="m_reg_nm" name="reg_nm" title="등록자" style="width: 172px;" readonly="readonly" value=""></td>
						<th scope="row">등록일시</th>
						<td><input type="text" id="m_reg_date" name="reg_date" title="등록일시" style="width: 172px;" readonly="readonly" value=""></td>
					</tr>

				</tbody>
			</table>
			<h3 class="tit_sWrap">비고</h3>
			<textarea name="etc" id="m_etc" style="height:144px;" class="mgb10" ></textarea>

			<div class="btn_wrap mgt20">
				<div class="floatR">
					<button type="button" class="btn_ico_confirm mgr5" onclick="regMaintenance(this.form)">
						<span>저장</span>
					</button>
					<button type="button" class="btn_ico_cancel" onclick="javascript:closeContractDe();">
						<span>취소</span>
					</button>
				</div>
			</div>
		</div>
		<button type="button" class="btn_close" onclick="javascript:closeContractDe();">창 닫기</button>
	</div>
	<div class="layer_dimmed"></div>
</div>
</form>