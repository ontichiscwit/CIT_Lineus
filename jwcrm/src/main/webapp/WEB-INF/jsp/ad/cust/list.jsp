<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
	
	$(document).ready(function(){
		
		sessionStorage.setItem("search_type10_checked", true);
		
		/**	공통 코드 처리		*/
		
		commonCode.getCodeList('CUST' , 'CD01' , 'search_type1') ; 		/**	거래처 구분		*/
		commonCode.getCodeList('CUST' , 'CD08' , 'search_type2') ; 		/**	재단구분			*/
		commonCode.getCodeList('CUST' , 'CD02' , 'search_type3') ; 		/**	전문병원유형		*/
		commonCode.getCodeList('CUST' , 'CD03' , 'search_type4') ; 		/**	거래상태			*/
		commonCode.getCodeList('CUST' , 'CD22' , 'search_type8') ; 		/**	백신			*/
		commonCode.getCodeList('CUST' , 'CD23' , 'search_type9') ; 		/**	서버유지보수업체			*/
		commonCode.getCodeList('CUST' , 'CD15' , 'search_type7') ; 		/**	서버구성			*/
		$('#search_type6').empty().append(commonCode.defaultOption) ;
		 
		
		$('#search_type1').val('${ vo.search_type1}');
		$('#search_type2').val('${ vo.search_type2}');
		$('#search_type3').val('${ vo.search_type3}');
		$('#search_type4').val('${ vo.search_type4}');
		$('#search_type5').val('${ vo.search_type5}');
		change5('${ vo.search_type6}');
		$('#search_type7').val('${ vo.search_type7}');
		$('#search_type8').val('${ vo.search_type8}');
		$('#search_type9').val('${ vo.search_type9}');
		$('#search_text').val('${ vo.search_text}');
		$('#search_type15').val('${ vo.search_type15}') ;
		
		$('#page').val('${ vo.page}') ; 
		$('#pageSize').val('${ vo.pageSize}') ;
		makeListData();
		
		//$("#search_text").keyup(function(e){if(e.keyCode == 13)  custList(1); });
	});
	
	function goSearch(){
		var f = document.listFrm ; 
		f.page.value = "1" ;
		
		f.target = "" ; 
		f.action = "/ad/cust/list.do" ; 
		f.submit() ; 
		
	}
	
	function change5(){
		$('#search_type6').empty().append(commonCode.defaultOption) ; 
		alert($('#search_type6').val());
		if($('#search_type5').val() == "") return ; 
		
		commonCode.getCodeList('CUST' , $('#search_type5').val() , 'search_type6') ; 		/**	HIS 버전			*/
	}
	
	function change5(value){	
		$('#search_type6').empty().append(commonCode.defaultOption) ; 
		if($('#search_type5').val() == "") return ; 
		
		commonCode.getCodeList('CUST' , $('#search_type5').val() , 'search_type6') ; 		/**	HIS 버전			*/
		$('#search_type6').val(value);
	}
	
	function goExl(){
		var flag = $('#count').html() > 0 ? 'T' : 'F' ;
		
		if(flag == 'T'){
			
			var f = document.listFrm ; 
			
			try{
				$("#exlFrame").remove() ;
			}catch(e){}
			
			var downFrame = $('<iframe id="exlFrame" name="exlFrame" style="width:0px; height=0px ; display:none;"></iframe>') ; 
			downFrame.appendTo("body") ;
			
			f.target = "exlFrame" ; 
			f.action = "/ad/cust/exl.do" ; 
			f.submit() ; 
			
		}else{
			alert("출력 가능한 데이터가 없습니다.") ; 
			return ; 
		}
	}
	
	function custList(page){
		var f = document.listFrm ; 
		
		f.page.value = page ; 
		f.target = '' ; 
		f.action = '/ad/cust/list.do' ; 
		f.submit() ; 
	}
		
	function makeListData() {
		common.ajaxCall($('form[name=listFrm]').serialize(), '/ad/cust/getCustList.do', 'getCustList') ;
	}
	
	function getCustList(data) {
		
		var str = "" ;
		var paging_src = "" ;
		var htmlWrap = $('#custList');
		
		htmlWrap.empty();
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var vo = data.vo != "undefined" ? data.vo : null ;
		
		if(resultList != null && resultList.length > 0){
			for(var i = 0 ; i < resultList.length ; i++){
				
				var datas = data.resultList[i];
	
				str += "<tr onclick=\"listDetail('update', '" + datas.seq + "', '"+ common.nvl(datas.cust_kor_name, '-') +"', '"+ common.nvl(datas.crm_code, '-') +"');\" style=\"cursor:pointer;\">" ;
				str += "	<td onclick='event.cancelBubble=true;'><input type=\"checkbox\" id=\"chkCustNo\" name=\"chk\" class=\"\" value='" + datas.seq +"'/></td>" ;
				str += "	<td>" + datas.rnum + "</td>" ;
				str += "	<td>" + common.nvl(datas.cust_gubun_nm , '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.foundation_code_nm, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.specially_code_nm, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.cust_kor_name, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.deal_code_nm, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.his_basic_code_nm, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.his_treat_code_nm, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.his_work_code_nm, '-')+ "</td>" ;
				str += "	<td>" + common.nvl(datas.his_claim_code_nm, '-') + "</td>" ;
				
				str += "	<td>" + common.nvl(datas.formation_code_nm, '-') + "</td>" ;
				str += "	<td>" + common.replaceAll(common.nvl(datas.mtac_nm, '-'),'@',"<br/>") + "</td>" ;
				str += "	<td>" + common.replaceAll(common.nvl(datas.vc_nm, '-'),'@',"<br/>") + "</td>" ;
				
				str += "	<td>" + common.nvl(datas.reg_date, '-') + "</td>" ;
				str += "</tr>" ;
				
				$('#count').html(vo.rowCnt) ; 
				htmlWrap.html(str);
				$("#pagination").html(vo.json_paging);
			}
		} else {
			$('#count').html('0') ; 
			commonTable.notData(15 , '조회된 데이터가 없습니다.' , 'custList') ; 
			$("#pagination").html('');
		}
	}
	
	function listDetail(pageType, seq, cust_kor_name, crm_code){
		var f = document.listFrm;
		
		f.pageType.value = pageType ; 
		f.cust_kor_name.value = cust_kor_name ; 
		f.crm_code.value = crm_code ; 
		f.seq.value = seq;
		
		f.target = "" ; 
		f.action = "/ad/cust/form.do";
		f.submit();
	}
	
	function custRegist() {
		var f = document.listFrm;
		f.pageType.value = 'insert';
		f.method = "post";
		f.action = "/ad/cust/form.do";
		f.submit();
	}
	
	function searchReset(){
		document.listFrm.reset() ;
		document.listFrm.search_type15.value = "" ;
		document.listFrm.search_text.value ="";
		goSearch() ; 
	}
	
	function changeDealCode(){
		var chkValue = "" ; 
		$("input[name=chk]:checked").each(function() {
			if (chkValue == '') chkValue = $(this).val();
			else chkValue = chkValue + "@"+ $(this).val();
		});
		
		if(chkValue == ""){
			alert("상태 변경 하실 거래처를 선택해 주세요.") ; 
			return ; 
		}
		
		if(confirm("거래중지 상태로 변경 하시겠습니까?")){
			var f = document.listFrm ; 
			f.del_dtl_seq.value = chkValue ; 
			
			common.ajaxCall($('form[name=listFrm]').serialize(), '/ad/cust/regist.do', 'returnProc') ;
		}
	}
	
	function returnProc(data){
		var msg = "" ; 
		var returnCode = typeof data.returnCode != "undefined" ? data.returnCode : "888" ; 
		var pageType = typeof data.pageType != "undefined" ? data.pageType : "" ; 
		
		if(returnCode == "888") msg = "비정상적인 실행 입니다." ; 
		else if(returnCode == "999") msg = "처리도중 오류가 발생했습니다." ; 
		else if(returnCode == "100") msg = "정보가 없습니다." ; 
		else if(returnCode == "000") msg = "정상처리 되었습니다." ;
		else if(returnCode == "200") msg = "운영정보가 존재하지 않습니다." ; //운영 정보 존재하지 않을때 예외처리 추가
		
		alert(msg) ; 
		if(returnCode == "000") custList(1); 
	}

</script>
<div class="tit_wrap">
	<h2 class="tit_ico_customer">거래처 관리<span class="tit_depth no_arrow mgl10 mgt8">검색 조건을 선택해 주세요.</span></h2>
	<div class="location">
		<a href="/ad/main/list.do" class="home">Home</a>
		<a href="/ad/cust/list.do" class="depth"><span class="here">거래처 관리</span></a>
	</div>
</div>
<!-- search -->
<form id="listFrm" name="listFrm" method="get">
	<input type="hidden" name="page" id="page" value="${ vo.page }" />
	<input type="hidden" name="seq" id="seq" value="" />
	<input type="hidden" name="pageType" id="pageType" value="" />
	<input type="hidden" name="cust_kor_name" id="cust_kor_name" />
	<input type="hidden" name="crm_code" id="crm_code" />
	<input type="hidden" name="del_dtl_seq" id="del_dtl_seq" />
	<input type="hidden" name="search_type15" id="search_type15" />

<table class="sType mgb10">
	<caption>거래처 검색</caption>
	<colgroup>
		<col style="width:140px;" />
		<col style="width:195px;" />
		<col style="width:140px;" />
		<col style="width:195px;" />
		<col style="width:140px;" />
		<col style="width:190px;" />
	</colgroup>
	<tr>
		<th scope="row">거래처 구분</th>
		<td>
			<select id="search_type1" name="search_type1" title="거래처 구분 선택"></select>
		</td>
		<th scope="row">소유 구분</th>
		<td>
			<select id="search_type2" name="search_type2" title="재단 구분 선택"></select>
		</td>
		<th scope="row">전문병원 유형</th>
		<td>
			<select id="search_type3" name="search_type3" title="전문병원 유형 선택"></select>
		</td>
	</tr>
	<tr>
		<th scope="row">거래상태</th>
		<td>
			<select id="search_type4" name="search_type4" title="거래상태 선택"></select>
		</td>
		<th scope="row">HIS버전</th>
		<td colspan="3">
			<select id="search_type5" name="search_type5" title="HIS버전 선택1" class="w155 mgr5" onchange="javascript:change5();">
				<option value="">전체선택</option>
				<option value="CD04"> <c:if test="${vo.search_type5 eq 'CD04' }">selected</c:if>>기초버전</option>
				<option value="CD05"> <c:if test="${vo.search_type5 eq 'CD05' }">selected</c:if>>진료버전</option>
				<option value="CD06"> <c:if test="${vo.search_type5 eq 'CD06' }">selected</c:if>>원무버전</option>
				<option value="CD07"> <c:if test="${vo.search_type5 eq 'CD07' }">selected</c:if>>청구버전</option>
			</select>
			<select id="search_type6" name="search_type6" title="HIS버전 선택2" class="w155"></select>
		</td>
	</tr>
	<tr>
		<th scope="row">서버구성</th>
		<td>
			<select id="search_type7" name="search_type7" title="서버구성 선택" class="w155"></select>
		</td>
		<th scope="row">서버유지보수업체</th>
		<td>
			<select id="search_type8" name="search_type8" title="서버유지보수업체 선택" class="w155"></select>
		</td>
		<th scope="row">백신</th>
		<td>
			<select id="search_type9" name="search_type9" title="백신 선택" class="w155"></select>
		</td>
	</tr>
	<tr>
		<th scope="row">거래처명 / CRM코드</th>
		<td colspan="5">
			<input type="text" id="search_text" name="search_text" class="w640 mgr5" title="통합 검색 키워드 입력" value="${ vo.search_text }" /><button type="button" class="btn_ico_reset mgr5" onclick="searchReset();"><span>초기화</span></button><button type="button" class="btn_ico_search" onclick="custList(1);"><span>검색</span></button>
		</td>
	</tr>
</table>

<div class="info_upper mgb5">
	<div class="sorting">
		조회건수 : <strong><span class="count" id="count">0</span> 건</strong>
	</div>
	<div class="floatR">
		<button type="button" class="btn_ico_circle_plus" onclick="custRegist();"><span>거래처 등록</span></button>
		<button type="button" class="btn_ico_excel" onclick="javascript:goExl();"><span>엑셀다운로드</span></button>
		<select id="pageSize" name="pageSize" onchange="custList(1);" title="리스트 행 선택" class="w140">
			<option value="10">10개씩 노출</option>
			<option value="30">30개씩 노출</option>
			<option value="50">50개씩 노출</option>
		</select>
	</div>
</div>

<table class="hType mgb10">
	<caption>A/S 접수 목록</caption>
	<colgroup>
		<col style="width:35px" />
		<col style="width:35px" />
		<col span="13" style="width:auto" />
	</colgroup>
	<thead>
		<tr>
			<th scope="col">선택</th>
			<th scope="col">No</th>
			<th scope="col">거래처 구분</th>
			<th scope="col">재단구분</th>
			<th scope="col">전문병원유형</th>
			<th scope="col">거래처명</th>
			<th scope="col">거래상태</th>
			<th scope="col">기초버전</th>
			<th scope="col">진료버전</th>
			<th scope="col">원무버전</th>
			<th scope="col">청구버전</th>
			<th scope="col">서버구성</th>
			<th scope="col">서버유지보수업체</th>
			<th scope="col">백신</th>
			<th scope="col">생성일</th>
		</tr>
	</thead>
	<tbody id="custList">
	</tbody>
</table>

<div class="page">
	<div class="btn_left">
		<button type="button" class="btn_ico_circle_plus" onclick="custRegist();"><span>거래처 등록</span></button>
	</div>
	<div class="btn_right">
		<button type="button" class="btn_ico_stop" onclick="javascript:changeDealCode();"><span>거래중지</span></button>
	</div>
	<div id="pagination"></div>
</div>
</form>