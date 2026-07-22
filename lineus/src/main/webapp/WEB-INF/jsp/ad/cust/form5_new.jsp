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
			'erp_code' : $("#erp_code").val()
		}
		common.ajaxCall(datas, '/ad/cust/getErpMtHist.do', 'drawErpList');

		
	}

	function drawErpList(data) {
		console.log(data);
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null;
		if (resultList == null)
			return;
		var str = "";
		for (var i = 0; i < resultList.length; i++) {
			
			str += "<tr>";
			str += "	<td>" + resultList[i].ITEM_GRP3_NM + "</td>";//분류
			str += "	<td>" + resultList[i].ITEM_NM + "</td>";//품목명
			if(resultList[i].COST_GUBUN == "1"){
				str += "	<td>" + '유상' + "</td>"; //구분
			}else if (resultList[i].COST_GUBUN == "2"){
				str += "	<td>" + '무상' + "</td>"; //구분
			}
			str += "	<td>" + common.strToDate(resultList[i].CONTR_ST_DT) + "~" + common.strToDate(resultList[i].CONTR_END_DT) + "</td>"; //계약기간
			str += "	<td>" + common.comma(resultList[i].AMT);
			str += "</tr>";
		}

		$("#erpHistList").html(str);
	}

	
	function moveTab(gubun) {
		location.href = "/ad/cust/form" + gubun + ".do${ QUERYSTRING }";
	}

	function goList() {
		var f = document.procFrm;

		f.action = '/ad/cust/list.do' + window.location.search.substring();
		f.submit();
	}

</script>
<div class="tit_wrap">
	<h2 class="tit_ico_customer">거래처 관리<span class="tit_depth mgl20 mgt8">유지보수계약정보</span></h2>
</div>
<div class="tit_sWrap">
	<h3 class="tit_dot_gray">
		거래처 상세 정보
		<c:if test="${ vo.pageType ne 'insert' }">&nbsp;&lt;<span class="colorBlue mg15" style="line-height: 25px;">${ vo.cust_kor_name },
				${ vo.erp_code }</span>&gt;</c:if>
	</h3>
</div>
<!-- tab -->
<ul class="tab_line list3 mgb20">
	<li><a href="javascript:moveTab('');">관리 정보</a></li>
	<!-- 활성시 current -->
	<li class="active"><a href="javascript:moveTab('5');">계약 이력</a></li>
	<li><a href="javascript:moveTab('6');">문서 관리</a></li>
</ul>
<!--// tab -->
<!-- list -->
<div class="tit_bWrap mgb10">
	<h4 class="floatL mgt8">계약정보 내역</h4>
	
</div>
<div class="wrapTable mgb20">

	<form name="procFrm" method="post" onsubmit="return false;">
		<input type="hidden" name="seq" id="seq" value="${ vo.seq }" /> 
		<input type="hidden" name="pageType" id="pageType"value="${ vo.pageType }"/> 
		<input type="hidden" name="ht_cnt" id="ht_cnt" value="" /> 
		<input type="hidden" name="del_dtl_seq" id="del_dtl_seq" value=""/> 
		<input type="hidden" name="erp_code" id="erp_code" value="${ vo.erp_code }" />

		<table class="hType mgb10">
			<colgroup>
				<col style="width: auto" />
				
			</colgroup>
			<thead>
				<tr>
					<th scope="col">분류</th>
					<th scope="col">품목명</th>
					<th scope="col">유무상구분</th>
					<th scope="col">계약기간</th>
					<th scope="col">유지보수금액<br>(VAT포함)</th>
				</tr>
			</thead>
			<tbody id="erpHistList">

			</tbody>
		</table>
	</form>
</div>
<!--// list -->
