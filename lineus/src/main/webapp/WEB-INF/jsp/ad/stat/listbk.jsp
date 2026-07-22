<%@page import="egovframework.com.comm.util.CommonExecute"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
	$(document).ready(function(){
		
		
		commonCode.getCodeList('CUST' , 'CD28' , 'search_type1') ; 		/**	품목			*/
		commonCode.getCodeList('CUST' , 'CD03' , 'search_type2') ; 		/**	거래상태		*/
		
		$( "#start_date" ).datepicker(datepicker);
		$( "#end_date" ).datepicker(datepicker);
		/* commonTable.notData(17,"검색해 주세요.","tBody"); */
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
		/* $('#tBody').empty(); */
		/* commonTable.notData(17,"검색해 주세요.","tBody"); */
	}
	
	function goSearch(){
		common.ajaxCall($('form[name=listFrm]').serialize(), '/ad/stat/getMtacList.do', 'makeList') ;
	}
	
	/* function makeList(data){
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
		
	}*/
	
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
		<caption>고객사별 A/S현황 검색</caption>
		<colgroup>
			<col style="width:140px;" />
			<col style="width:auto;" />
		</colgroup>
		<tr>
			<th scope="row">기간선택</th>
			<td>
				<input type="radio" class="mgr5" name="search_type1"   checked>전월
			    <input type="radio" class="mgl10 mgr5" name="search_type1"  >당월
			    <input type="radio" class="mgl10 mgr5" name="search_type1"  >범위지정
			    <input type="text" class="w100 mgr5" name="start_date" id="start_date" readonly="readonly">~
				<input type="text" class="w100 mgl10 mgr5" name="end_date" id="end_date" readonly="readonly">
			</td>
		</tr>
		<tr>
			<th scope="row">처리코드 선택</th>
			<td>
				<input type="radio" class="mgr5" name="search_type2"   checked>처리상태
			    <input type="radio" class="mgl10 mgr5" name="search_type2"  >접수경로
			    <input type="radio" class="mgl10 mgr5" name="search_type2"  >문의유형
			    <input type="radio" class="mgl10 mgr5" name="search_type2"  >원인유형
			    <input type="radio" class="mgl10 mgr5" name="search_type2"  >조치유형
			    
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
		<button type="button" class="btn_ico_search mgr5" onclick=""><span>검색</span></button>
		<button type="button" class="btn_ico_excel" onclick="javascript:goExl();"><span>엑셀다운로드</span></button>
	</div>
</div>
<!-- list -->
<table class="hType mgb10">
	<caption>고객사별 A/S현황</caption>
	<colgroup>
		
    </colgroup>
	<thead>
		<tr>
			<th scope="col">대상구분</th>
			<th scope="col">총합계</th>
			<th scope="col">담당자배정중(변경)</th>
			<th scope="col">배정완료</th>
			<th scope="col">처리중</th>
			<th scope="col">처리완료</th>
			<th scope="col">처리율</th>
			<th scope="col">답변수총계</th>
			<th scope="col">답변율</th>
		</tr>
	</thead>
	
	<tbody id="tBody">
		<tr>
			<th>합산 누계</th>
			<th class="colorRed">561</th>
			<th>30</th>
			<th>2</th>
			<th>500</th>
			<th>500</th>
			<th>85%</th>
			<th>241</th>
			<th>100%</th>
		</tr>
		<tr>
			<th>강경인</th>
			<td>561</td>
			<td>30</td>
			<td>2</td>
			<td>500</td>
			<td>500</td>
			<td>85%</td>
			<td>241</td>
			<td>100%</td>
		</tr>
		<tr>
			<th>강준희</th>
			<td>561</td>
			<td>30</td>
			<td>2</td>
			<td>500</td>
			<td>500</td>
			<td>85%</td>
			<td>241</td>
			<td>100%</td>
		</tr>
		<tr>
			<th>강형열</th>
			<td>561</td>
			<td>30</td>
			<td>2</td>
			<td>500</td>
			<td>500</td>
			<td>85%</td>
			<td>241</td>
			<td>100%</td>
		</tr>
		<tr>
			<th>공성환</th>
			<td>561</td>
			<td>30</td>
			<td>2</td>
			<td>500</td>
			<td>500</td>
			<td>85%</td>
			<td>241</td>
			<td>100%</td>
		</tr>
		<tr>
			<th>관리자</th>
			<td>561</td>
			<td>30</td>
			<td>2</td>
			<td>500</td>
			<td>500</td>
			<td>85%</td>
			<td>241</td>
			<td>100%</td>
		</tr>
		<tr>
			<th>김경인</th>
			<td>561</td>
			<td>30</td>
			<td>2</td>
			<td>500</td>
			<td>500</td>
			<td>85%</td>
			<td>241</td>
			<td>100%</td>
		</tr>
	</tbody>
</table>
<!--// list -->
