<%@page import="egovframework.com.comm.util.CommonExecute"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
	$(document).ready(function(){
		sessionStorage.setItem("search_type10_checked", true);
		commonCode.getCodeList('CUST' , 'CD28' , 'search_type1') ; 		/**	품목			*/
		commonCode.getCodeList('CUST' , 'CD03' , 'search_type2') ; 		/**	거래상태		*/
		
		$( "#start_date" ).datepicker(datepicker);
		$( "#end_date" ).datepicker(datepicker);
		commonTable.notData(17,"검색해 주세요.","tBody");
	}) ;
	
	function change4(thisObj){
		if(thisObj == "A"){
			$('#search_type4').val('1');
			$('#search_type4').prop('disabled',true);
		}else{
			$('#search_type4').prop('disabled',false);
		}
	}
	
	function goClear(){
		document.listFrm.reset() ;
		
		$('#search_type4').val('1');
		$('#search_type4').prop('disabled',true);
		$('#tBody').empty();
		commonTable.notData(17,"검색해 주세요.","tBody");
	}
	
	function goSearch(){
		common.ajaxCall($('form[name=listFrm]').serialize(), '/ad/stat/getMtacList.do', 'makeList') ;
	}
	
	function makeList(data){
		// tot_count
		// tBody
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		$('#tBody').empty() ;
		$('#tot_count').html('0') ; 
		
		if(resultList != null && resultList.length > 0){
			
			var str = '' ; 
			
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ; 
				
				str += '<tr> ' ;
				str += '	<td>'+(i+1)+'</td> ' ;
				str += '	<td>'+common.nvl(datas.cust_kor_name, '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.auto_renew_yn, 'N')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.contract_seq, '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.contract_nm, '')+'</td> ' ;
				str += '	<td>'+makeDate(common.nvl(datas.contract_dt, ''))+'</td> ' ;
				str += '	<td>'+common.nvl(datas.bill_code, '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.mtac_code, '')+'</td> ' ;
				str += '	<td>'+makeDate(common.nvl(datas.mtac_start_dt, ''))+'<br/>~'+makeDate(common.nvl(datas.mtac_end_dt, ''))+'</td> ' ;
				str += '	<td>'+common.nvl(datas.mtac_calc, '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.mon_off_amt, '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.receive_amt, '0')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.buy_busi_name, '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.buy_cost, '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.service_period, '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.service_method, '')+'</td> ' ;
				str += '	<td><a href="javascript:goMove(\''+common.nvl(datas.seq, '')+'\', \''+common.nvl(datas.crm_code, '')+'\', \''+common.nvl(datas.cust_kor_name, '')+'\')" class="colorBlue">[조회]</a></td> ' ;
				str += '</tr> ' ;
			}
			$('#tBody').append(str) ; 
			$('#tot_count').html(resultList.length) ; 
		}else{
			commonTable.notData(17,"조회된 데이터가 없습니다.","tBody");
		}
		
	}
	
	function goMove(seq , crm_code , cust_kor_name){
		var f = document.listFrm;
		
		f.pageType.value = 'update' ; 
		f.cust_kor_name.value = cust_kor_name ; 
		f.crm_code.value = crm_code ; 
		f.seq.value = seq;
		
		f.target = "" ; 
		f.action = "/ad/cust/form.do";
		f.submit();
	}
	
	function goExl(){
		// tot_count
		var flag = $('#tot_count').html() > 0 ? 'T' : 'F' ;
		
		if(flag == 'T'){
			
			var f = document.listFrm ; 
			
			try{
				$("#exlFrame").remove() ;
			}catch(e){}
			
			var downFrame = $('<iframe id="exlFrame" name="exlFrame" style="width:0px; height=0px ; display:none;"></iframe>') ; 
			downFrame.appendTo("body") ;
			
			f.target = "exlFrame" ; 
			f.action = "/ad/stat/exl2.do" ; 
			f.submit() ; 
			
		}else{
			alert("출력 가능한 데이터가 없습니다.") ; 
			return ; 
		}
	}
	
</script>

<div class="tit_wrap">
	<%= CommonExecute.returnLineMap(request) %>
</div>
<!-- search -->

<form id="listFrm" name="listFrm" method="post">
	<input type="hidden" name="seq" id="seq" value="" />
	<input type="hidden" name="pageType" id="pageType" value="" />
	<input type="hidden" name="cust_kor_name" id="cust_kor_name" />
	<input type="hidden" name="crm_code" id="crm_code" />

	<table class="sType mgb10">
		<caption>유지보수 계약 현황 검색</caption>
		<colgroup>
			<col style="width:140px;" />
			<col style="width:360px;" />
			<col style="width:140px;" />
			<col style="width:360px;" />
		</colgroup>
		<tr>
			<th scope="row">품목 구분</th>
			<td>
				<select title="유지보수 구분" name="search_type1" id="search_type1"></select>
			</td>
			<th scope="row">거래상태</th>
			<td>
				<select title="거래상태" name="search_type2" id="search_type2"></select>
			</td>
		</tr>
		<tr>
			<th scope="row">유지보수 기간</th>
			<td>
			    <input type="radio" class="mgr5" name="search_type3" id="search_type3_1" value="A" onclick="change4(this.value);" checked>전체
			    <input type="radio" class="mgl10 mgr5"  name="search_type3" id="search_type3_2" value="B"  onclick="change4(this.value);">갱신 대상
			    <select title="" class="mgl10" style="width:187px;" name="search_type4" id="search_type4" disabled>
			        <option value="1">1개월미만</option>
			        <option value="2">2개월미만</option>
			        <option value="3">3개월미만</option>
			    </select>
			</td>
			<th scope="row">계약일시</th>
			<td>
				<input type="text" class="w100 mgr5" name="start_date" id="start_date" readonly>~
				<input type="text" class="w100 mgl10 mgr5" name="end_date" id="end_date" value="">
			</td>
		</tr>
		<tr>
			<th scope="row">월 유지보수 금액(원)</th>
			<td>
				<input type="text" class="w145 mgr10" name="search_text"  id="search_text">~
				<input type="text" class="w145 mgl10" name="search_text2"  id="search_text2">
			</td>
			<th scope="row">수금 구분</th>
			<td>
			    <input type="radio" class="mgr5" name="search_type5" id="search_type5_1" value="A" checked>전체
			    <input type="radio" class="mgl10 mgr5" name="search_type5" id="search_type5_2" value="B">미수금거래처만(전 월 기준)
			</td>
		</tr>
		<tr>
			<th scope="row">거래처명</th>
			<td colspan="3">
			    <input type="text" class="mgr10" style="width:521px;" name="search_text3" id="search_text3"><input type="checkbox" class="mgr5" name="search_type6" id="search_type6" value="Y" checked>최신 데이터만 조회<button type="button" class="btn_ico_reset mgl10 mgr5" onclick="javascript:goClear();"><span>초기화</span></button><button type="button" class="btn_ico_search mgr5"  onclick="javascript:goSearch();"><span>검색</span></button>
			</td>
		</tr>
	</table>
</form>
<!--// search -->
<div class="info_upper mgb5">
	<div class="sorting">
		조회건수 : <strong><span class="count" id="tot_count">0</span> 건</strong>
	</div>
	<div class="floatR">
		<button type="button" class="btn_ico_excel" onclick="javascript:goExl();"><span>엑셀다운로드</span></button>
	</div>
</div>
<!-- list -->
<table class="hType mgb10">
	<caption>A/S 접수 목록</caption>
	<colgroup>
		<col style="width:30px" />
		<col style="width:auto" />
		<col style="width:50px" />
		<col span="14" style="width:auto;">
          </colgroup>
	<thead>
		<tr>
			<th scope="col">No</th>
			<th scope="col">거래처명</th>
			<th scope="col">자동갱신여부</th>
			<th scope="col">계약서번호</th>
			<th scope="col">계약서명</th>
			<th scope="col">계약일시</th>
			<th scope="col">품목</th>
			<th scope="col">유/무상 구분</th>
			<th scope="col">유지보수기간</th>
			<th scope="col">계약잔여일</th>
			<th scope="col">월유보금액</th>
			<th scope="col">미수금(전 월 기준)</th>
			<th scope="col">매입업체명</th>
			<th scope="col">매입원가</th>
			<th scope="col">서비수주기</th>
			<th scope="col">서비스방법</th>
			<th scope="col">거래처정보</th>
		</tr>
	</thead>
	<tbody id="tBody"></tbody>
</table>
<!--// list -->
