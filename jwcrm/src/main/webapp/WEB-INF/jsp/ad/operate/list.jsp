<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
	
	$(document).ready(function(){
		
		/**	공통 코드 처리		*/
		
		
		commonCode.getCodeList('AS' , 'CD07' , 'search_type1') ; 		// 문의유형
		commonCode.getCodeList('AS' , 'CD03' , 'search_type2') ; 		// 시스템(대)
		
		$('#search_type1').val('${ vo.search_type1}');
		$('#search_type2').val('${ vo.search_type2}');
		$('#search_type5').val('${ vo.search_type5}');
		$('#search_text').val('${ vo.search_text}');
		
		if($('#search_type1').val() == 'C001'){
			setService_cate("P010");
			$('#search_type2').prop('disabled', true).addClass('write_gray');
			$('#search_type2').val("P010");
		}else{
			setService_cate($('#search_type2').val());
			$('#search_type2').prop('disabled', false).removeClass('write_gray');
		}
		
		if( $('#search_type2').val() !=''){
			commonCode.getCodeList('AS' , $('#search_type2').val() , 'search_type3') ;
			$('#search_type3').val('${ vo.search_type3 }');
	     }
		
		$('#page').val('${ vo.page}') ; 
		$('#pageSize').val('${ vo.pageSize}') ;
		
		makeListData();
				
		$("#search_text").keyup(function(e){if(e.keyCode == 13)  getOperateList(1); });
	});
	
	function goSearch(){
		var f = document.listFrm ; 
		f.page.value = "1" ;
		f.target = "" ; 
		f.action = "/ad/operate/list.do" ; 
		f.submit() ; 
		
	}

	
	function getOperateList(page){
		var f = document.listFrm ;
		f.page.value = page ; 
		f.target = '' ; 
		f.submit() ; 
	}
		
	function makeListData() {
		common.ajaxCall($('form[name=listFrm]').serialize(), '/ad/operate/getOperateList.do', 'setOperateList') ;
	}
	
	function setOperateList(data) {
		
		var str = "" ;
		var htmlWrap = $('#operateList');
		htmlWrap.empty();
		
		$('#count').html('0') ;
		$("#pagination").html('');
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var vo = data.vo != "undefined" ? data.vo : null ;
		
		if(resultList != null && resultList.length > 0){
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = data.resultList[i];
				str += "<tr onclick=\"listDetail('update', '" + datas.oper_seq + "');\" style=\"cursor:pointer;\">" ;
				str += "	<td>" + datas.rnum + "</td>" ;
				str += "	<td>" + common.nvl(datas.request_type_nm , '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.service_cate_nm , '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.inquiry_type_nm , '-') +"</td>" ;
				str += "	<td>" + common.nvl(datas.wk_emp_nm, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.master_yn, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.use_yn, '-') + "</td>" ;
				str += "</tr>" ;
				$('#count').html(vo.rowCnt) ; 
				htmlWrap.html(str);
				$("#pagination").html(vo.json_paging);
			}
		} else {
			$('#count').html('0') ; 
			commonTable.notData(20 , '조회된 데이터가 없습니다.' , 'operateList') ; 
			$("#pagination").html('');
		} 
	}
	
	function listDetail(pageType, oper_seq){
		var f = document.listFrm;
		
		f.pageType.value = pageType ; 
		f.oper_seq.value = oper_seq;
		f.target = "" ; 
		f.action = "/ad/operate/form.do";
		f.submit();
	}
	
	function operateRegist() {
		var f = document.listFrm;
		f.pageType.value = 'insert';
		f.method = "post";
		f.action = "/ad/operate/form.do";
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
		if(returnCode == "000") getOperateList(1); 
	}
	
	function delProcReturn(data) {
		
		var returnCode = typeof data.returnCode != "undefined" ? data.returnCode : null ; 
		var returnText = typeof data.returnText != "undefined" ? data.returnText : null ; 
		
		if( returnCode == "100"){
			alert(returnText); 
			getOperateList(1);
		}else if (returnCode == "200"){	
			alert(returnText);
		}else{
			alert("비정상적인 실행입니다.");
		}
	}
	
	function setService_cate(thisObj){
		$('#search_type3').empty() ; 
		if(thisObj != ""){
			commonCode.getCodeList('AS' , thisObj , 'search_type3') ;
		}else{
			$('#search_type3').append(commonCode.defaultOption);	
			
		}
	}
	
</script>
<div class="tit_wrap">
	<h2 class="tit_ico_customer">처리담당자 관리<span class="tit_depth no_arrow mgl10 mgt8">검색 조건을 선택해 주세요.</span></h2>
	<div class="location">
		<a href="/ad/main/list.do" class="home">Home</a>
		<a href="/ad/operate/list.do" class="depth"><span class="here">처리담당자 관리</span></a>
	</div>
</div>
<!-- search -->
<form id="listFrm" name="listFrm" method="get">
	<input type="hidden" name="page" id="page" value="${ vo.page }" />
	<input type="hidden" name="oper_seq" id="oper_seq" value="" />
	<input type="hidden" name="pageType" id="pageType" value="" />
	<input type="hidden" name="del_dtl_seq" id="del_dtl_seq" />
	<input type="hidden" name="search_type15" id="search_type15" />

<table class="sType mgb10">
	<caption>처리담당자 검색</caption>
	<colgroup>
		<col style="width:140px;" />
		<col style="width:185px;" />
		<col style="width:140px;" />
		<col style="width:225px;" />
		<col style="width:140px;" />
		<col style="width:170px;" />
	</colgroup>
	<tr>
		<th scope="row">문의유형</th>
			<td>
				<select id="search_type1" name="search_type1" title="문의유형" class="w135"></select>
			</td>
		<th scope="row">시스템유형</th> 
			<td> 
				<select name="search_type2" id="search_type2" title="시스템(대) 선택" class="w85 mgr2" onchange="setService_cate(this.value);"></select> 
				
				<select name="search_type3" id="search_type3" title="시스템(소) 선택" class="w85" ></select> 
			</td>
		<th scope="row">처리담당자</th>
			<td colspan="3">
				<input id="search_type5" type="text" name="search_type5" title="처리담당자" class="w135"/>
			</td>
	</tr>
	<tr>
		<th scope="row">통합검색</th>
		<td colspan="5">
			<input type="text" id="search_text" placeholder="문의유형/시스템(대)/시스템(소)/처리담당자" name="search_text" class="w640 mgr10" title="통합 검색 키워드 입력" value="${ vo.search_text }" />
			<button type="button" class="btn_ico_reset mgr5" onclick="searchReset();"><span>초기화</span></button><button type="button" class="btn_ico_search" onclick="getOperateList(1);"><span>검색</span></button>
			
		</td>
	</tr>
</table>

<div class="info_upper mgb5">
	<div class="sorting">
		조회건수 : <strong><span class="count" id="count">0</span> 건</strong>
	</div>
	<div class="floatR">
		<c:if test="${ adUserInfo.emp_grade eq 'C001'}">
		<button type="button" class="btn_ico_circle_plus" onclick="operateRegist();"><span>처리담당자 등록</span></button>
		</c:if>
		<select id="pageSize" name="pageSize" onchange="getOperateList(1);" title="리스트 행 선택" class="w140">
			<option value="10">10개씩 노출</option>
			<option value="30">30개씩 노출</option>
			<option value="50">50개씩 노출</option>
		</select>
	</div>
</div>

<table class="hType mgb10">
	<caption>처림담당자정보 목록</caption>
	<colgroup>
		<col style="width:85px" />
		<col style="width:190px" />
		<col style="width:190px" />
		<col style="width:190px" />
		<col style="width:110px" />
		<col style="width:95px" />
		<col style="width:90px" />
	</colgroup>
	<thead>
		<tr>
			<th scope="col">No</th>
			<th scope="col">문의유형</th>
			<th scope="col">시스템(대)</th>
			<th scope="col">시스템(소)</th>
			<th scope="col">처리담당자</th>
			<th scope="col">담당자(정,부)</th>
			<th scope="col">사용여부</th>
		</tr>
	</thead>
	<tbody id="operateList">
	</tbody>
</table>

<div class="page">
	<div class="btn_left">
	</div>
	<!-- <div class="btn_right">
		<button type="button" class="btn_ico_delete" onclick="delOpProc();"><span>삭제</span></button>
	</div>
	 -->
	<div id="pagination"></div>
</div>
</form>