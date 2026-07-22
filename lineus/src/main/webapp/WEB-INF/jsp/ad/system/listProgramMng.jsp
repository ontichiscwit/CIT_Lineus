<%@page import="egovframework.com.comm.util.CommonExecute"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style>
	.status_bold {color:#0032c3 !important;font-weight:bold;}
	.scroll-table{width:1860px;;table-layout:auto;}
	.scroll-table tr:hover{background-color: #eef7f9 !important;}
</style>

<script type="text/javascript">

	var typeProgrampop = '';
	
	$(document).ready(function(){
		
		initForm();
		
	}) ;
	
	function initForm(){
	
		/**	공통 코드 처리		*/
		commonCode.getCodeList('PROJECT' , 'PR02' , 'search_type3') ; 				
		commonCode.getCodeList('PROJECT' , 'PR02' , 'system_nm_view') ; 				
		
			
		var pageType = '${ vo.pageType}' ;
		
		$('#search_type1').val('${ vo.search_type1 }');
		$('#search_type2').val('${ vo.search_type2 }');
		$('#search_type3').val('${ vo.search_type3 }');
		$('#search_type4').val('${ vo.search_type4 }');
		
		$('#search_text').val('${ vo.search_text }');
		$('#page').val('${ vo.page}') ;
		$('#pageSize').val('${ vo.pageSize}') ;
		makeListData();
	
	}
	
	
	function makeListData() {
		common.ajaxCall($('form[name=listFrm]').serialize(), '/ad/system/getProgramList.do', 'setProgramList') ;
	}
	

	function getProgramListPanging(pageIndex) {
		var f = document.listFrm ; 
		f.page.value = pageIndex ; 
		f.target = '' ; 
		f.submit() ; 
	}
	
	function setProgramList(data) {
		$('#programList').empty();
		
		var resultList = typeof data.resultList != 'undefined' ? data.resultList : null;
		var vo = typeof data.vo != 'undefined' ? data.vo : null;
		if (resultList != null && resultList.length > 0) {
			
			for(var i = 0 ; i < resultList.length ; i++){
				var str = '' ; 
				var datas = resultList[i] ; 
				/* 접수번호 */
				str += '<tr id="programTr'+i+'" onclick="showProgramPopLayer( \'update\', \''+common.nvl(datas.system_code , '')+'\', \''+common.nvl(datas.category_id , '')+'\' , \''+common.nvl(datas.category_name , '')+'\' , \''+common.nvl(datas.program_id , '')+'\' , \''+common.nvl(datas.program_name , '')+'\' , \''+common.nvl(datas.use_yn , '')+'\' );" > ' ;
				str += '<td class="w50">'+common.nvl(datas.seq, '')+'</td> ' ;	
				/**/
				str += '<td>'+common.nvl(datas.system_name, '')+'</td> ' ;
				
				str += '<td style="display:none;">'+common.nvl(datas.category_id, '')+'</td> ' ;
				
				/**/
				str += '<td>'+common.nvl(datas.category_name, '')+'</td> ' ;
				
				/**/
				str += '<td>'+common.nvl(datas.program_id, '')+'</td> ' ;
				
				/**/
				str += '<td>'+common.nvl(datas.program_name, '')+'</td> ' ;
				
				str += '<td><input type="checkbox" title="" name="use_yn'+(i+1)+'" id="use_yn'+(i+1)+'" value="Y" disabled="disabled"/></td> ' ;
				
				str += '		<td style="display:none;">'+common.nvl(datas.system_code, '')+'</td> ' ;
				
				/* 끝tr */
				str += '</tr> ' ;
				$('#programList').append(str);	
				(common.nvl(datas.use_yn,'') == 'Y') ? $('#use_yn' + (i+1)).prop('checked',true) : $('#use_yn' + (i+1)).prop('checked',false); 
			}
			$("#pagination").html(vo.json_paging);
			
		} else {
			commonTable.notData(17,"조회된 데이터가 없습니다.","programList");
			$("#pagination").html('');
		}
	}
	
	
	function showProgramPopLayer(pageType, system_code , category_id, category_name , program_id , program_name , use_yn){
		$('#div_program_pop').show() ;
		$('#div_program_pop').css('height' , '300');
		$('#program_id').val(program_id);
		$('#program_name').val(program_name);
		$('#category_id').val(category_id);
		$('#category_name').val(category_name);
		$('#system_nm_view').val(system_code);
		$('#use_yn').val(use_yn);
	    (use_yn == 'Y') ? $('#use_yn').prop('checked',true) : $('#use_yn').prop('checked',false); 
	    $('#pageType').val(pageType);
	    if(pageType == "insert"){
	    	$( "#program_id" ).attr( "readonly", false);
	    } else{
	    	$( "#program_id" ).attr( "readonly", true);
	    }
	}
	
	function closeProgramPopLayer() {
		$('#div_program_pop').hide() ; 
	}
	
	
	function showCategoryPopLayer(type){
		typeProgrampop = type;
		searchCategoryName
		$('#searchCategoryName').val('') ;
		$('#div_category_pop').show() ;
		$('#div_category_pop').css('height' , '500');
		if(typeProgrampop == 'categoryPopLayerInsert'){
			$('#div_category_pop').css('margin-left' , '-230px');
		}
		categoryList(1);
	}

	function categoryList(categoryPage){
		var datas = {
				'page' : categoryPage , 
				'search_text' : $('#searchCategoryName').val() 
		}
		
		common.ajaxCall(datas , '/ad/as/getCategoryList.do', 'makeCategoryList') ;
	}

	function makeCategoryList(data){
		$('#categoryPopInfoList').empty() ; 
		$('#layer_pagination_category').empty() ; 
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var vo = typeof data.vo != "undefined" ? data.vo : null ; 
		
		if(resultList != null && resultList.length > 0){
			var str = '' ; 
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ;
				str += '<tr onclick="javascript:setCategory(\''+common.nvl(datas.category_id, '') +'\', \''+common.nvl(datas.category_name, '') +'\');" style="cursor:pointer;"> ' ;
				str += '	<td style="text-align: center;">'+common.nvl(datas.category_id , '')+'</td> ' ;
				str += '	<td style="text-align: center;">'+common.nvl(datas.category_name , '')+'</td> ' ;
				str += '</tr> ' ;
			}
			$('#categoryPopInfoList').append(str) ; 
			$('#layer_pagination_category').html(vo.json_paging) ; 
		}else{
			commonTable.notData(6 , '조회된 정보가 없습니다.' , 'categoryPopInfoList') ; 
		}
	}

	function setCategory(category_id , category_name){
		if(typeProgrampop == 'categoryPopLayerInsert'){
			$('#category_name').val(category_name) ;
			$('#category_id').val(category_id) ;
		} else {
			$('#search_type4').val(category_name) ;
		}
		
		closeCategoryPopLayer();
	}
	
	function closeCategoryPopLayer() {
		$('#div_category_pop').hide() ; 
	}
	
	function goSave(){
		if (common.isEmpty($('#program_id').val())) {
			alert('[프로그램ID]필수입력항목 오류');
			$('#program_id').focus(); 
			return;
		}
		
		if (common.isEmpty($('#program_name').val())) {
			alert('[프로그램명]필수입력항목 오류');
			$('#program_name').focus(); 
			return;
		}
		
		if (common.isEmpty($('#system_nm_view').val())) {
			alert('[시스템]필수입력항목 오류');
			$('#system_nm_view').focus(); 
			return;
		}
		
		if (common.isEmpty($('#category_name').val())) {
			alert('[중분류]필수입력항목 오류');
			$('#category_name').focus(); 
			return;
		}
		
		if($('#use_yn').is(":checked")){
			$('#use_yn').val('Y');
		} else {
			$('#use_yn').val('');
		}
		
		$('#system_nm').val($('#system_nm_view').val());
		
		$.ajax({
			type : 'post' ,
			url : '/ad/system/saveProgramMng.do' , 
			data : $('form[name=programSaveForm]').serialize() ,
			dataType : 'json' , 
			statusCode : {
				404:function(data){
					alert('해당 페이지가 존재하지 않습니다.');
				}
			}, 
			success : function(data){
				var returnCode = typeof data.returnCode != "undefined" ? common.nvl(data.returnCode , "1000") : "1000" ; 
				var msg = "" ; 
				if(returnCode == "003"){
					msg = "이미 등록된 자료 입니다." ;
				}else if(returnCode == "001") {
					msg = "처리도중 오류가 발생했습니다." ;
				}else msg = "정상적으로 처리 되었습니다." ; 
				
				alert(msg) ;
				if(returnCode != "003"){
					closeProgramPopLayer();
					initForm();
				}
			}
		}) ; 
	}
</script>


<div class="tit_wrap">
	<%= CommonExecute.returnLineMap(request) %>
	
</div>

<form name="listFrm" id="listFrm" method="get">
	<input type="hidden" name="page" id="page" value="${ vo.page }" />
	<table class="sType mgb10">
		<colgroup>
			<col style="width:120px;" />
			<col style="width:300px;" />
			<col style="width:120px;" />
			<col style="width:300px;" />
		</colgroup>
		<tbody id="asSearchTbody">
			<tr>
				<th scope="row">프로그램ID</th> 
				<td> 
					<input type="text" name="search_type1" id="search_type1" title="프로그램ID" > 
				</td>
				<th scope="row">프로그램명</th> 
				<td> 
					<input type="text" name="search_type2" id="search_type2" title="프로그램ID" class=""> 
				</td>
			</tr>
			<tr>
				<th scope="row">시스템</th> 
				<td> 
					<select name="search_type3" id="search_type3" title="시스템">
				</select>
				<th scope="row">중분류</th>
				<td>
					<input type="text" name="search_type4" id="search_type4" value="" title="중분류"   style="width:89%;"/>
					<button type="button" class="btn_ico_search_s" onclick="javascript:showCategoryPopLayer('');"><span></span></button>
				</td>
			</tr>
		</tbody>
		
	</table>
	<div class="info_upper mgb5">
		<div class="floatR">
			<button type="button" class="btn_ico_confirm w115" onclick="javascript:showProgramPopLayer('insert', '');"><span>신규작업 등록</span></button>
			<button type="button" class="btn_ico_search mgr5" onclick="getProgramListPanging(1);"><span>검색</span></button>
			<select id="pageSize" name="pageSize" onchange="getProgramListPanging(1);" title="리스트 행 선택" class="w140">
				<option value="10">10개씩 노출</option>
				<option value="30">30개씩 노출</option>
				<option value="50">50개씩 노출</option>
			</select>
		</div>
	</div>
	
	<div style="overflow-x:auto;">
	<table class="hType mgb10 scroll-table" style="width:1000px;">
		<caption>프로그램관리(유지보수)</caption>
		<colgroup>			
			<col style="width:40px" /><!-- No -->
			<col style="width:120px" /><!-- 시스템 -->
			<col style="width:120px" /><!-- 중분류 -->
			<col style="width:120px" /><!-- 프로그램ID-->
			<col style="width:120px" /><!-- 프로그램명 -->
			<col style="width:50px" /><!-- 사용여부 -->
		</colgroup>
		<thead>
			<tr>
				<th scope="col">No</th>
				<th scope="col">시스템</th>
				<th scope="col">중분류</th>
				<th scope="col">프로그램ID</th>
				<th scope="col">프로그램명</th>
				<th scope="col">사용여부</th>
			</tr>
		</thead>
		<tbody id="programList"></tbody>
	</table>
	
	</div>
	<div class="page">
		<div id="pagination"></div>
	</div>
</form>

<div class="box_layer layer_sms" style="margin-top:-80px ;display:none;height:600px;" id="div_category_pop">
	<h1>중분류</h1>
	<div class="layer_contents pdt20" style="height:500px;">
		중분류:
		<input type="text" class="w175 mgr10" id="searchCategoryName" name="searchCategoryName" title="중분류"  autofocus="autofocus" />
		<button type="button" class="btn_ico_search mgr5" onclick="javascript:categoryList(1);"><span>검색</span></button>
		<table class="vType_line" style="margin-top: 10px">
			<caption>중분류</caption>
			<colgroup>
				<col style="width:70px;" />
				<col style="width:70px;" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">중분류ID</th>
					<th scope="col">중분류명</th>
				</tr>
			</thead>
			<tbody id="categoryPopInfoList"></tbody>
		</table>
		<div class="page" id="layer_pagination_category" style="margin-top: 10px;"></div>
	</div>
	<button type="button" class="btn_close" onclick="javascript:closeCategoryPopLayer();">창 닫기</button>
</div>

<div class="box_layer layer_sms" style="margin-top:-150px; display:none;height:350px;width:900px; z-index:1" id="div_program_pop">
	<h1>프로그램관리</h1>
	<div class="layer_contents pdt20" style="height:500px;">
		<div class="tit_bWrap mgb10">
			<h4>프로그램 정보</h4>
		</div>
	<!-- write -->
		<form name="programSaveForm" id="programSaveForm" method="get">
			<input type="hidden" name="pageType" id="pageType"/>
			<input type="hidden" name="system_nm" id="system_nm"/>
			<table class="sType mgb20" id="wrapMfile">
				<caption>문의 유형 정보 입력</caption>
				<colgroup>
					<col style="width:50px;" />
					<col style="width:100px;" />
					<col style="width:50px;" />
					<col style="width:200px;" />
				</colgroup>
				<tr>
					<th scope="row">프로그램ID<span class="request mgl5">필수 입력</span></th>
					<td>
						<input type="text" name="program_id" id="program_id" value="" title=""/>
					</td>
					<th scope="row">프로그램명<span class="request mgl5">필수 입력</span></th>
					<td>
						<input type="text" name="program_name" id="program_name" value="" title="" style="width:200px;"/>
						<input type="checkbox" name="use_yn" id="use_yn" class="" style="margin-left:5px" value="Y"><label for="use_yn">사용여부</label>
					</td>
				</tr>
				<tr>
					<th scope="row">시스템<span class="request mgl5">필수 입력</span></th>
					<td>
						<select name="system_nm_view" id="system_nm_view" title="시스템" class="" style="width:175px;">
						</select>
						
					</td>
					<th scope="row">중분류<span class="request mgl5">필수 입력</span></th>
					<td>
						<input type="hidden" name="category_id" id="category_id" value="" />
						<input type="text" name="category_name" id="category_name" value="" title="" style="width:200px;"/>
						<button type="button" class="btn_ico_search_s" id="categoryPopLayerButton" onclick="javascript:showCategoryPopLayer('categoryPopLayerInsert');"><span></span></button>
					</td>
				</tr>
			</table>
		</form>
		<div class="btn_wrap">
			<div class="floatR">
				<button type="button" class="btn_ico_confirm"  onclick="javascript:goSave();"><span>저장</span></button>
			</div>
		</div>
	</div>
	<button type="button" class="btn_close" onclick="javascript:closeProgramPopLayer();">창 닫기</button>
	
</div>	


