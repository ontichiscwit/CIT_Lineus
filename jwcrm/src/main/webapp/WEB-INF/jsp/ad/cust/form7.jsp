<%@page import="egovframework.com.comm.util.CommonExecute"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript" src="<%=request.getContextPath()%>/js/jquery.mtz.monthpicker.js"></script>
<script type="text/javascript">
	

	$(document).ready(function() {
		
		commonCode.getCodeList("CUST","CD28","m_bill_code");
		commonCode.getCodeList("CUST","CD29","m_mtac_code");
		commonCode.getCodeList("CUST","CD35","m_deal_code");
		commonCode.getCodeList("CUST","CD36","m_buy_busi_name");
		commonCode.getCodeList("CUST","CD37","m_service_period");
		commonCode.getCodeList("CUST","CD38","m_service_method");
		
		
		initView();
	});
	
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

	function initView() {
		if (common.nvl('${vo.seq}', '') == '') {
			alert('관리정보를 등록해 주세요.');
			location.href = '/ad/cust/form.do';
			return;
		}

		
		var datas = {
			'erp_code' : $('#erp_code').val()
		}
		common.ajaxCall(datas, '/ad/cust/getSolutionHist.do', 'getSolutionHistData');

				
	}

	function getSolutionHistData(data) {
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null;
		if(resultList.length > 0){
			
			for(var i=0; i < resultList.length ; i++){
				var str='';
				var subDatas = resultList[i];
				var issue_dt = "-";   
				if (common.nvl(subDatas.ISSUE_DT, '').length == 8){
					issue_dt = makeDate(subDatas.ISSUE_DT,"-");
		 		}
				str = '		<tr>';
				str += '		<td>'+ subDatas.ITEM_GRP1_NM +'</td>';
				str += '		<td>'+ subDatas.ITEM_NM +'</td>';
				str += '		<td>'+ issue_dt +'</td>';
				str += '		<td>'+common.comma(subDatas.SUPP_WON_AMT)+'</td>';
				str += '		<td>'+common.comma(subDatas.VAT_WON_AMT)+'</td>';
				str += '		<td>'+common.comma(subDatas.TOTAL_AMT)+'</td>';
				str += '	</tr>';
				$('#erpHistList').append(str);
			}
			
		}	
		
	}
	
	
	function goList() {
		var f = document.procFrm;

		f.action = '/ad/cust/list.do' + window.location.search.substring();
		f.submit();
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
	<li><a href="javascript:moveTab('5');">유지보수 이력</a></li>
	<li class="active"><a href="javascript:moveTab('7');">매출 이력(부가솔루션)</a></li>
	<li><a href="javascript:moveTab('6');">문서관리</a></li>
</ul>
<!--// tab -->
<!-- list -->
<div class="tit_bWrap mgb10">
	<h4 class="floatL mgt8">부가솔루션 매출 내역</h4>
	
</div>
<div class="wrapTable mgb20">

	<form name="procFrm" method="post" onsubmit="return false;">
		<input type="hidden" name="seq" id="seq" value="${ vo.seq }" /> <input type="hidden" name="pageType" id="pageType"value="${ vo.pageType }"/> 
		<input type="hidden" name="ht_cnt" id="ht_cnt" value="" /> <input type="hidden" name="del_dtl_seq" id="del_dtl_seq" value=""/> 
		<input type="hidden" name="crm_code" id="crm_code" value="${ vo.crm_code }" />
		<input type="hidden" name="erp_code" id="erp_code" value="${ vo.erp_code }" />
		


		<table class="hType mgb10">
			<colgroup>
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
				<!--등록구분  -->
				<col style="width: 140px" />
				<!--버튼 -->
			</colgroup>
			<thead>
				<tr>
					<th scope="col">분류</th>
					<th scope="col">품목명</th>
					<th scope="col">매출발행일자</th>
					<th scope="col">공급가액</th>
					<th scope="col">VAT</th>
					<th scope="col">총금액</th>
					
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

