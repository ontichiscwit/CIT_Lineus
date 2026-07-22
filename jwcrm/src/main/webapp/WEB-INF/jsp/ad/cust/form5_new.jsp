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
		initView();
	});

	function initView() {
		if (common.nvl('${vo.seq}', '') == '') {
			alert('관리정보를 등록해 주세요.');
			location.href = '/ad/cust/form.do';
			return;
		}
		
		//무상계약 이력 조회
		var datas = {
			'erp_code' : $("#erp_code").val()
		}
		common.ajaxCall(datas, '/ad/cust/getErpFreeContract.do', 'setErpFreeContractList');

		//유상계약-최신계약 이력 조회
		var datas = {
			'erp_code' : $("#erp_code").val()
		};
		common.ajaxCall(datas, '/ad/cust/getErpBill.do', 'setErpBillList');
		
		//유상계약-이전계약 이력 조회
		var datas = {
			'erp_code' : $("#erp_code").val()
		};
		common.ajaxCall(datas, '/ad/cust/getErpBillHsty.do', 'setErpBillHstyList');
		
		//프로젝트 정보 입력 유무 조회
		var datas = {
				'seq' : $('#seq').val()
		};
		common.ajaxCall(datas, '/ad/cust/getProjectCnt.do', 'setProjectCnt');

	};

	/* 무상계약 리스트 */
	function setErpFreeContractList(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null;
		
		if(resultList != null && resultList.length > 0){
			var str = '';
			for (var i = 0; i < resultList.length; i++) {
				str += '<tr>';
				str += '	<td>'+resultList[i].cust_code+'</td>';
				str += '	<td>'+resultList[i].cust_nm+'</td>';
				str += '	<td>무상</td>';
				str += '	<td>'+resultList[i].contract_kind+'</td>';
				str += '	<td>'+common.strToDate(resultList[i].contract_date)+'</td>';
				str += '	<td>'+common.strToDate(resultList[i].st_date)+'</td>';
				str += '	<td>'+common.strToDate(resultList[i].end_date)+'</td>';
				str += '	<td>'+common.comma(common.nvl(resultList[i].maint_month_amt,0))+'</td>';
				str += '	<td>'+common.nvl(resultList[i].memo,'')+'</td>';
				str += '	<td>ERP</td>';
				str += '	<td>'+common.nvl(resultList[i].reg_nm,'')+'</td>';
				str += '</tr>';
			}
			$('#erpFreeContractList').append(str);
			
		}else{
			commonTable.notData(11 , '조회된 정보가 없습니다.' , 'erpFreeContractList') ; 
		}
	};
	
	/* 유상계약 최신계약 리스트 */
	function setErpBillList(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null;
		
		if(resultList != null && resultList.length > 0){
			var str = '';
			for (var i = 0; i < resultList.length; i++) {
				str += '<tr>';
				str += '	<td>'+resultList[i].cust_code+'</td>';
				str += '	<td>'+resultList[i].cust_nm+'</td>';
				str += '	<td>유상</td>';
				str += '	<td>'+common.nvl(resultList[i].item_nm)+'</td>';
				str += '	<td>'+common.strToDate(resultList[i].contract_date)+'</td>';
				str += '	<td>'+common.strToDate(resultList[i].st_date)+'</td>';
				str += '	<td>'+common.strToDate(resultList[i].end_date)+'</td>';
				str += '	<td>'+common.comma(resultList[i].maint_month_amt)+'</td>';
				str += '	<td>'+common.nvl(resultList[i].memo,'')+'</td>';
				str += '	<td>ERP</td>';
				str += '	<td>'+common.nvl(resultList[i].reg_nm,'')+'</td>';
				str += '</tr>';
			}
			
			$('#erpBillList').append(str);
		}else{
			commonTable.notData(11 , '조회된 정보가 없습니다.' , 'erpBillList') ; 
		}
		
	};
	
	/* 유상계약 이전계약 리스트 */
	function setErpBillHstyList(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null;
		
		if(resultList != null && resultList.length > 0){
			var str = '';
			for (var i = 0; i < resultList.length; i++) {
				str += '<tr>';
				str += '	<td>'+resultList[i].cust_code+'</td>';
				str += '	<td>'+resultList[i].cust_nm+'</td>';
				str += '	<td>유상</td>';
				str += '	<td>'+resultList[i].item_nm+'</td>';
				str += '	<td>'+common.strToDate(resultList[i].contract_date)+'</td>';
				str += '	<td>'+common.strToDate(resultList[i].st_date)+'</td>';
				str += '	<td>'+common.strToDate(resultList[i].end_date)+'</td>';
				str += '	<td>'+common.comma(resultList[i].maint_month_amt)+'</td>';
				str += '	<td>'+common.nvl(resultList[i].memo,'')+'</td>';
				str += '	<td>ERP</td>';
				str += '	<td>'+common.nvl(resultList[i].reg_nm,'')+'</td>';
				str += '</tr>';
			}
			
			$('#erpBillHstyList').append(str);
		}else{
			commonTable.notData(11 , '조회된 정보가 없습니다.' , 'erpBillHstyList') ; 
		}
	};	
	
	/* 프로젝트 정보 입력 유무 조회 */
	var projectCnt = 0;
	function setProjectCnt(data) {
		projectCnt = typeof data.cnt != 'undefined' ? data.cnt : 0;
	}
	
	/* 상단 탭 이동 */
	function moveTab(gubun) {
		if (projectCnt == 0 && gubun == '3') {
			alert('프로젝트 정보를 등록해 주세요.');
			return;
		}
		location.href = "/ad/cust/form" + gubun + ".do${ QUERYSTRING }";
	};
	
	/* 목록 버튼 이벤트 */
	function goList() {
		var f = document.procFrm;

		f.action = '/ad/cust/list.do' + window.location.search.substring();
		f.submit();
	};
	
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
<!-- 상단 tab -->
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

<!-- 무상계약 list -->
<div style="margin-top: 40px" class="tit_sWrap">
	<h4 class="tit_dot_gray">무상 계약</h4>
</div>
<div class="wrapTable mgb20">

	<form name="procFrm" method="post" onsubmit="return false;">
		<input type="hidden" name="seq" id="seq" value="${ vo.seq }" /> <input type="hidden" name="pageType" id="pageType" value="${ vo.pageType }"/> 
		<input type="hidden" name="ht_cnt" id="ht_cnt" value="" /> 
		<input type="hidden" name="del_dtl_seq" id="del_dtl_seq" value=""/> 
		<input type="hidden" name="crm_code" id="crm_code" value="${ vo.crm_code }" />
		<input type="hidden" name="erp_code" id="erp_code" value="${vo.erp_code}" />
	</form>
		<table class="hType mgb10">
			<colgroup>
				<!--erp코드  -->
				<col style="width: auto" />
				<!--거래처명  -->
				<col style="width: auto" />
				<!--무/유상 구분  -->
				<col style="width: 80PX" />
				<!--계약서종류 -->
				<col style="width: 100px" />
				<!--계약일자 -->
				<col style="width: 90px" />
				<!--시작일 -->
				<col style="width: 90px" />
				<!--종료일-->
				<col style="width: 90px" />
				<!--유지보수금액-->
				<col style="width: auto" />
				<!--메모 -->
				<col style="width: 150px" />
				<!--등록시스템  -->
				<col style="width: 60px" />
				<!--등록자 -->
				<col style="width: 80px" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">ERP코드</th>
					<th scope="col">거래처명</th>
					<th scope="col">무/유상 구분</th>
					<th scope="col">계약서종류</th>
					<th scope="col">계약일자</th>
					<th scope="col">시작일</th>
					<th scope="col">종료일</th>
					<th scope="col">유지보수금액<br>(VAT포함)</th>
					<th scope="col">메모</th>
					<th scope="col">등록시스템</th>
					<th scope="col">등록자</th>
				</tr>
			</thead>
			<tbody id="erpFreeContractList">

			</tbody>
		</table>
</div>

<!-- 유상계약 list -->
<div style="margin-top: 40px" class="tit_sWrap">
	<h4 class="tit_dot_gray">유상 계약</h4>
</div>
<div class="tit_bWrap mgb10">
	<h4 class="floatL mgt8 colorBlue">최신 계약</h4>
</div>
<div class="wrapTable mgb20">		
		
		<table class="hType mgb10">
			<colgroup>
				<!--erp코드  -->
				<col style="width: auto" />
				<!--거래처명  -->
				<col style="width: auto" />
				<!--무/유상 구분  -->
				<col style="width: 80PX" />
				<!--품목명 -->
				<col style="width: 100px" />
				<!--계약일자 -->
				<col style="width: 90px" />
				<!--시작일 -->
				<col style="width: 90px" />
				<!--종료일-->
				<col style="width: 90px" />
				<!--유지보수금액-->
				<col style="width: auto" />
				<!--메모 -->
				<col style="width: 150px" />
				<!--등록시스템  -->
				<col style="width: 60px" />
				<!--등록자 -->
				<col style="width: 80px" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">ERP코드</th>
					<th scope="col">거래처명</th>
					<th scope="col">무/유상 구분</th>
					<th scope="col">품목명</th>
					<th scope="col">계약일자</th>
					<th scope="col">시작일</th>
					<th scope="col">종료일</th>
					<th scope="col">유지보수금액<br>(VAT포함)</th>
					<th scope="col">메모</th>
					<th scope="col">등록시스템</th>
					<th scope="col">등록자</th>
				</tr>
			</thead>
			<tbody id="erpBillList">

			</tbody>
		</table>

</div>

<div class="tit_bWrap mgb10">
	<h4 class="floatL mgt8 colorBlue">이전 계약</h4>
</div>
<div class="wrapTable mgb20">		
		
		<table class="hType mgb10">
			<colgroup>
				<!--erp코드  -->
				<col style="width: auto" />
				<!--거래처명  -->
				<col style="width: auto" />
				<!--무/유상 구분  -->
				<col style="width: 80PX" />
				<!--품목명 -->
				<col style="width: 100px" />
				<!--계약일자 -->
				<col style="width: 90px" />
				<!--시작일 -->
				<col style="width: 90px" />
				<!--종료일-->
				<col style="width: 90px" />
				<!--유지보수금액-->
				<col style="width: auto" />
				<!--메모 -->
				<col style="width: 150px" />
				<!--등록시스템  -->
				<col style="width: 60px" />
				<!--등록자 -->
				<col style="width: 80px" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">ERP코드</th>
					<th scope="col">거래처명</th>
					<th scope="col">무/유상 구분</th>
					<th scope="col">품목명</th>
					<th scope="col">계약일자</th>
					<th scope="col">시작일</th>
					<th scope="col">종료일</th>
					<th scope="col">유지보수금액<br>(VAT포함)</th>
					<th scope="col">메모</th>
					<th scope="col">등록시스템</th>
					<th scope="col">등록자</th>
				</tr>
			</thead>
			<tbody id="erpBillHstyList">

			</tbody>
		</table>

</div>

<div class="btn_wrap">
	<div class="floatL">
		<button type="button" class="btn_ico_list" onclick="goList();">
			<span>목록</span>
		</button>
	</div>
</div>





