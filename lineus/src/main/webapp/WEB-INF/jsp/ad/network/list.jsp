<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
	
	$(document).ready(function(){
		
		/**	공통 코드 처리		*/
		
		commonCode.getCodeList('CUST' , 'CD01' , 'search_type1') ; 		/**	거래처 구분		*/
		commonCode.getCodeList('CUST' , 'CD03' , 'search_type2') ; 		/**	개러처 거래상태	*/
		
		commonCode.getCodeList('NETWORK' , 'NT01' , 'search_type4') ; 		/**	장비구분		*/
		commonCode.getCodeList('NETWORK' , 'NT02' , 'search_type5') ; 		/**	제조사		*/
		commonCode.getCodeList('NETWORK' , 'NT02' , 'search_type6') ; 		/**	모델		*/
		commonCode.getCodeList('NETWORK' , 'NT03' , 'search_type7') ; 		/**	사용구분		*/
		commonCode.getCodeList('NETWORK' , 'NT08' , 'search_type8') ; 		/**	유무상구분		*/
		commonCode.getCodeList('NETWORK' , 'NT07' , 'search_type9') ; 		/**	유휴폐기여부		*/
		
		
		$('#search_type1').val('${ vo.search_type1}');
		$('#search_type2').val('${ vo.search_type2}');
		$('#search_type3').val('${ vo.search_type3}');
		$('#search_type4').val('${ vo.search_type4}');
		$('#search_type5').val('${ vo.search_type5}');
		$('#search_type6').val('${ vo.search_type6}');
		$('#search_type7').val('${ vo.search_type7}');
		$('#search_type8').val('${ vo.search_type8}');
		$('#search_type9').val('${ vo.search_type9}');
		$('#search_type10').val('${ vo.search_type10}');
		$('#search_type11').val('${ vo.search_type11}');
		$('#search_type12').val('${ vo.search_type12}');
		
		$('#search_text').val('${ vo.search_text}');
		
		$('#page').val('${ vo.page}') ; 
		$('#pageSize').val('${ vo.pageSize}') ;
		makeListData();
		
		$("#search_text").keyup(function(e){if(e.keyCode == 13)  getNetworkList(1); });
	});
	
	function goSearch(){
		var f = document.listFrm ; 
		f.page.value = "1" ;
		
		f.target = "" ; 
		f.action = "/ad/network/list.do" ; 
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
	
	function getNetworkList(page){
		console.log(page);
		var f = document.listFrm ; 
		f.page.value = page ; 
		f.target = '' ; 
		f.submit() ; 
	}
		
	function makeListData() {
		common.ajaxCall($('form[name=listFrm]').serialize(), '/ad/network/getNetworkList.do', 'setNetworkList') ;
	}
	
	function setNetworkList(data) {
		
		var str = "" ;
		var htmlWrap = $('#networkList');
		htmlWrap.empty();
		
		$('#count').html('0') ;
		$("#pagination").html('');
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var vo = data.vo != "undefined" ? data.vo : null ;
		
		if(resultList != null && resultList.length > 0){
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = data.resultList[i];
				str += "<tr onclick=\"listDetail('update', '" + datas.seq + "');\" style=\"cursor:pointer;\">" ;
				str += "	<td>" + datas.rnum + "</td>" ;
				str += "	<td>" + common.nvl(datas.cust_gubun_nm , '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.cust_kor_name , '-') +common.nvl(datas.erp_code , '-') +"</td>" ;
				str += "	<td>" + makeDate(common.nvl(datas.adopt_dt, '-')) + "</td>" ;
				str += "	<td>" + common.nvl(datas.equipment_nm, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.network_nm, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.network_mnf_nm, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.network_model_nm, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.ip, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.id, '-')+ "</td>" ;
				str += "	<td>" + common.nvl(datas.use_type_nm, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.unsed_status_nm, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.contract_condition_nm, '-') + "</td>" ;
				str += "</tr>" ;
				$('#count').html(vo.rowCnt) ; 
				htmlWrap.html(str);
				$("#pagination").html(vo.json_paging);
			}
		} else {
			$('#count').html('0') ; 
			commonTable.notData(15 , '조회된 데이터가 없습니다.' , 'getNetworkList') ; 
			$("#pagination").html('');
		} 
	}
	
	function listDetail(pageType, seq){
		var f = document.listFrm;
		
		f.pageType.value = pageType ; 
		f.seq.value = seq;
		f.target = "" ; 
		f.action = "/ad/network/form.do";
		f.submit();
	}
	
	function networkRegist() {
		var f = document.listFrm;
		f.pageType.value = 'insert';
		f.method = "post";
		f.action = "/ad/network/form.do";
		f.submit();
	}
	
	function searchReset(){
		document.listFrm.reset() ;
		document.listFrm.search_type15.value = "" ;
		goSearch() ; 
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
		if(returnCode == "000") getNetworkList(1); 
	}

</script>
<div class="tit_wrap">
	<h2 class="tit_ico_customer">네트워크 관리<span class="tit_depth no_arrow mgl10 mgt8">검색 조건을 선택해 주세요.</span></h2>
	<div class="location">
		<a href="/ad/main/list.do" class="home">Home</a>
		<a href="/ad/network/list.do" class="depth"><span class="here">네트워크 관리</span></a>
	</div>
</div>
<!-- search -->
<form id="listFrm" name="listFrm" method="get">
	<input type="hidden" name="page" id="page" value="${ vo.page }" />
	<input type="hidden" name="seq" id="seq" value="" />
	<input type="hidden" name="pageType" id="pageType" value="" />
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
		<th scope="row">거래처 거래상태</th>
		<td>
			<select id="search_type2" name="search_type2" title="거래처 거래 상태"></select>
		</td>
		<th scope="row">거래처명/코드</th>
		<td>
			<input type="text" id="search_type3" name="search_type3" title="거래처명/코드">
		</td>
	</tr>
	
	<tr>
		<th scope="row">장비구분</th>
		<td>
			<select id="search_type4" name="search_type4" title="장비구분"></select>
		</td>
		<th scope="row">제조사</th>
		<td>
			<select id="search_type5" name="search_type5" title="제조사 " class="w155"></select>
		</td>
		
		<th scope="row">모델</th>
		<td>
			<select id="search_type6" name="search_type6" title="모델 " class="w155"></select>
		</td>
	</tr>
	<tr>
		<th scope="row">사용구분</th>
		<td>
			<select  id="search_type7" name="search_type7" title="사용구분 " class="w155"></select>
		</td>
		<th scope="row">유무상구분</th>
		<td>
			<select  id="search_type8" name="search_type8" title="유무상구분" class="w155"></select>
		</td>
		<th scope="row">유휴폐기여부</th>
		<td >
			<select id="search_type9" name="search_type9" title="유휴폐기여부" class="w155"></select>
		</td>
	</tr>
	<tr>
		<th scope="row">IP</th>
		<td>
			<input type="text" id="search_type10" name="search_type10" title="IP" class="w155"/>
		</td>
		<th scope="row">계정</th>
		<td>
			<input type="text" id="search_type11" name="search_typ11" title="계정 " class="w155"/>
		</td>
		<th scope="row">시리얼 넘버</th>
		<td>
			<input type="text" id="search_type12" name="search_type12" title="시리얼넘버" class="w155"/>
		</td>
	</tr>
	<tr>
		<th scope="row">사용명칭</th>
		<td colspan="5">
			<input type="text" id="search_text" name="search_text" class="w640 mgr10" title="통합 검색 키워드 입력" value="${ vo.search_text }" /><button type="button" class="btn_ico_reset mgr5" onclick="searchReset();"><span>초기화</span></button><button type="button" class="btn_ico_search" onclick="getNetworkList(1);"><span>검색</span></button>
		</td>
	</tr>
</table>

<div class="info_upper mgb5">
	<div class="sorting">
		조회건수 : <strong><span class="count" id="count">0</span> 건</strong>
	</div>
	<div class="floatR">
		<button type="button" class="btn_ico_circle_plus" onclick="networkRegist();"><span>네트워크 등록</span></button>
		<button type="button" class="btn_ico_excel" onclick="javascript:goExl();"><span>엑셀다운로드</span></button>
		<select id="pageSize" name="pageSize" onchange="getNetworkList(1);" title="리스트 행 선택" class="w140">
			<option value="10">10개씩 노출</option>
			<option value="30">30개씩 노출</option>
			<option value="50">50개씩 노출</option>
		</select>
	</div>
</div>

<table class="hType mgb10">
	<caption>서버 목록</caption>
	<colgroup>
		<col style="width:35px" />
		<col span="10" style="width:auto" />
	</colgroup>
	<thead>
		<tr>
			<th scope="col">No</th>
			<th scope="col">거래처 구분</th>
			<th scope="col">거래처명</th>
			<th scope="col">도입일자</th>
			<th scope="col">장비구분</th>
			<th scope="col">사용명칭</th>
			<th scope="col">제조사</th>
			<th scope="col">모델명</th>
			<th scope="col">IP</th>
			<th scope="col">계정</th>
			<th scope="col">사용구분</th>
			<th scope="col">유무상구분</th>
			<th scope="col">유휴폐기여부</th>
		</tr>
	</thead>
	<tbody id="networkList">
	</tbody>
</table>

<div class="page">
	<div class="btn_left">
		<button type="button" class="btn_ico_circle_plus" onclick="networkRegist();"><span>네트워크 등록</span></button>
	</div>
	<div id="pagination"></div>
</div>
</form>