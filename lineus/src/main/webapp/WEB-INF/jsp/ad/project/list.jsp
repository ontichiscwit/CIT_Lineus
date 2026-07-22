<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
	
	$(document).ready(function(){
		
		/**	공통 코드 처리		*/
		
		commonCode.getCodeList('CUST' , 'CD01' , 'search_type1') ; 		/**	거래처 구분		*/
		commonCode.getCodeList('CUST' , 'CD03' , 'search_type2') ; 		/**	개러처 거래상태	*/
		commonCode.getCodeList('PROJECT' , 'PR02' , 'search_type4') ; 		/**	유형		*/
		commonCode.getCodeList('PROJECT' , 'PR01' , 'search_type5') ; 		/**	상태		*/
		
		//$('#search_type1').val('${ vo.search_type1}');
		$('#search_type1').val('C001'); 
		$('#search_type1').prop('disabled',true);
		$('#search_type2').val('${ vo.search_type2}');
		$('#search_type3').val('${ vo.search_type3}');
		$('#search_type4').val('${ vo.search_type4}');
		$('#search_type5').val('${ vo.search_type5}');
		$('#search_text').val('${ vo.search_text}');
		
		$( "#search_start1" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#search_end1" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#search_start2" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#search_end2" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$("#search_text").keyup(function(e){if(e.keyCode == 13)  getProjectList(1); });
		
		var search_type6 = '${ vo.search_type6 }';
		(search_type6 == 'Y') ? $('#search_type6').prop('checked',true) : $('#search_type6').prop('checked',false);
		if ('${ vo.search_start1 }' != '') $('#search_start1').val('${ vo.search_start1 }');
		if ('${ vo.search_end1 }' != '') $('#search_end1').val('${ vo.search_end1 }');
		
		
		var search_type9 = '${ vo.search_type9 }';
		(search_type9 == 'Y') ? $('#search_type9').prop('checked',true) : $('#search_type9').prop('checked',false);
		if ('${ vo.search_start2 }' != '') $('#search_start2').val('${ vo.search_start2 }');
		if ('${ vo.search_end2 }' != '') $('#search_end2').val('${ vo.search_end2 }');
		
		$('#page').val('${ vo.page}') ; 
		$('#pageSize').val('${ vo.pageSize}') ;
		
		makeListData();
		
	});
	
	function goSearch(){
		var f = document.listFrm ; 
		f.page.value = "1" ;
		f.target = "" ; 
		f.action = "/ad/project/list.do" ; 
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
	
	function getProjectList(page){
		var f = document.listFrm ;
		f.page.value = page ; 
		f.target = '' ; 
		f.submit() ; 
	}
		
	function makeListData() {
		common.ajaxCall($('form[name=listFrm]').serialize(), '/ad/project/getProjectList.do', 'setProjectList') ;
	}
	
	function setProjectList(data) {
		
		var str = "" ;
		var htmlWrap = $('#projectList');
		htmlWrap.empty();
		
		$('#count').html('0') ;
		$("#pagination").html('');
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var vo = data.vo != "undefined" ? data.vo : null ;
		
		if(resultList != null && resultList.length > 0){
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = data.resultList[i];
				str += "<tr onclick=\"listDetail('update', '" + datas.pro_seq + "');\" style=\"cursor:pointer;\">" ;
				str += "	<td>" + datas.rnum + "</td>" ;
				str += "	<td>" + common.nvl(datas.cust_gubun_nm , '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.deal_code_nm , '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.cust_kor_name , '-') + "["+common.nvl(datas.erp_code , '-')+"]"+"</td>" ;
				str += "	<td>" + common.nvl(datas.project_nm, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.system_code_nm, '-') + "</td>" ;
				str += "	<td>" + makeDate(common.nvl(datas.term_start_dt, '-')) + ' ~ ' + makeDate(common.nvl(datas.term_end_dt, '-')) +"</td>" ;
				str += "	<td>" + common.nvl(datas.state_type_nm, '-') + "</td>" ;
				str += "</tr>" ;
				$('#count').html(vo.rowCnt) ; 
				htmlWrap.html(str);
				$("#pagination").html(vo.json_paging);
			}
		} else {
			$('#count').html('0') ; 
			commonTable.notData(15 , '조회된 데이터가 없습니다.' , 'getProjectList') ; 
			$("#pagination").html('');
		} 
	}
	
	function listDetail(pageType, pro_seq){
		var f = document.listFrm;
		
		f.pageType.value = pageType ; 
		f.pro_seq.value = pro_seq;
		f.target = "" ; 
		f.action = "/ad/project/form.do";
		f.submit();
	}
	
	function projectRegist() {
		var f = document.listFrm;
		f.pageType.value = 'insert';
		f.method = "post";
		f.action = "/ad/project/form.do";
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
		if(returnCode == "000") getProjectList(1); 
	}

</script>
<div class="tit_wrap">
	<h2 class="tit_ico_customer">프로젝트 관리<span class="tit_depth no_arrow mgl10 mgt8">검색 조건을 선택해 주세요.</span></h2>
	<div class="location">
		<a href="/ad/main/list.do" class="home">Home</a>
		<a href="/ad/project/list.do" class="depth"><span class="here">프로젝트 관리</span></a>
	</div>
</div>
<!-- search -->
<form id="listFrm" name="listFrm" method="get">
	<input type="hidden" name="page" id="page" value="${ vo.page }" />
	<input type="hidden" name="pro_seq" id="pro_seq" value="" />
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
		<th scope="row">시스템유형</th>
		<td>
			<select id="search_type4" name="search_type4" title="시스템유형"></select>
		</td>
		<th scope="row">프로젝트상태</th>
		<td colspan="3">
			<select id="search_type5" name="search_type5" title="프로젝트상태" class="w155"></select>
		</td>
		
	</tr>
	<tr>
		<th scope="row">프로젝트 시작일</th>
		<td colspan="2">
			<input type="checkbox" id="search_type6" name="search_type6" value="Y"/>
			<input type="text" id="search_start1" name="search_start1" title="시작일" class="w105"/>~
			<input type="text" id="search_end1" name="search_end1" title="종료일" class="w105"/>
		</td>
		<th scope="row">프로젝트 종료일</th>
		<td colspan="2">
			<input type="checkbox" id="search_type9" name="search_type9" value="Y"/>
			<input type="text" id="search_start2" name="search_start2" title="시작일" class="w105"/>~
			<input type="text" id="search_end2" name="search_end2" title="종료일" class="w105"/>
		</td>
	</tr>
	<tr>
		<th scope="row">통합검색</th>
		<td colspan="5">
			<input type="text" id="search_text" name="search_text" placeholder="프로젝트명 /거래처명 / 거래처코드 " class="w640 mgr10" title="통합 검색 키워드 입력" value="${ vo.search_text }" /><button type="button" class="btn_ico_reset mgr5" onclick="searchReset();"><span>초기화</span></button><button type="button" class="btn_ico_search" onclick="getProjectList(1);"><span>검색</span></button>
		</td>
	</tr>
</table>

<div class="info_upper mgb5">
	<div class="sorting">
		조회건수 : <strong><span class="count" id="count">0</span> 건</strong>
	</div>
	<div class="floatR">
		<button type="button" class="btn_ico_circle_plus" onclick="projectRegist();"><span>프로젝트 등록</span></button>
		<button type="button" class="btn_ico_excel" onclick="javascript:goExl();"><span>엑셀다운로드</span></button>
		<select id="pageSize" name="pageSize" onchange="getProjectList(1);" title="리스트 행 선택" class="w140">
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
		<col style="width:80px" />
		<col style="width:60px" />
		<col style="width:180px" />
		<col style="width:180px" />
		<col style="width:100px" />
		<col style="width:140px" />
		<col style="width:100px" />
	</colgroup>
	<thead>
		<tr>
			<th scope="col">No</th>
			<th scope="col">거래처 구분</th>
			<th scope="col">거래처 거래상태</th>
			<th scope="col">거래처명</th>
			<th scope="col">프로젝트명</th>
			<th scope="col">시스템유형</th>
			<th scope="col">투입기간</th>
			<th scope="col">프로젝트상태</th>
		</tr>
	</thead>
	<tbody id="projectList">
	</tbody>
</table>

<div class="page">
	<div class="btn_left">
		<button type="button" class="btn_ico_circle_plus" onclick="projectRegist();"><span>프로젝트 등록</span></button>
	</div>
	<div id="pagination"></div>
</div>
</form>