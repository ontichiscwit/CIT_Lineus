<%@page import="egovframework.com.comm.util.CommonExecute"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      		uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui"     		uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix = "fn"		uri = "http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" 	uri="http://www.springframework.org/tags"%>
<script type="text/javascript">
	
	var del_p_code = "" ; 
	var group_addCnt = 0 ;
	
	var del_code = "" ; 
	var code_addCnt = 0 ; 
	
	function init(){
		getCodeGroup() ; 
	}
	
	$(document).ready(function(){
		sessionStorage.setItem("search_type10_checked", true);
		init() ; 
	}) ;
	
	function getCodeGroup(){
		
		$('#table1Tbody').empty() ; 
		$('#table2Tbody').empty() ; 
		
		del_p_code = "" ;
		group_addCnt = 0 ;
		
		del_code = "" ; 
		code_addCnt = 0 ;
		
		$.ajax({
			type : 'post' ,
			url : '/ad/code/getCodeGroupList.do' , 
			data : $('form[name=listFrm]').serialize() ,
			dataType : 'json' , 
			statusCode : {
				403:function(data){
					alert("권한이 없습니다.");
				},
				404:function(data){
					alert('해당 페이지가 존재하지 않습니다.');
				}
			},
			success : function(data){
				var resultList = typeof data.resultList != "undefined" ? data.resultList : null ;
				
				if(resultList != null && resultList.length > 0){
					// table1Tbody
					
					var str = '' ; 
					
					for(var i = 0 ; i < resultList.length ; i++){
						var datas = resultList[i] ;
						var num = (i + 1) ; 
						str += '<tr id="groupTr'+num+'" onclick="javascript:goCodeDetail(\''+common.nvl(datas.p_code , '')+'\');" style="cursor:pointer;">' ;
						
						str += '	<td>';
						str += '		<input type="text" name="p_code_'+num+'" id="p_code_'+num+'" readonly="readonly" title="공통 그룹 코드" value="'+common.nvl(datas.p_code,'')+'" class="w100 mgr2" maxlength="4"/>';
						str += '	</td>';
						
						str += '	<td>';
						str += '		<input type="text" name="p_code_name_'+num+'" id="p_code_name_'+num+'" readonly="readonly" title="공통 그룹 코드명" value="'+common.nvl(datas.p_code_name,'')+'" class="w200 mgr2" maxlength="250"/>';
						str += '	</td>';
						
						str += '	<td onclick="event.cancelBubble=true;">';
						str += '		<input type="radio" id="use_yn_'+ num +'" name="use_yn_'+ num +'" title="노출여부" value="Y"  '+(	common.nvl(datas.use_yn , '') == "Y" ? "checked" : ""	)+'/> 노출&nbsp;';
						str += '		<input type="radio" id="use_yn_'+ num +'" name="use_yn_'+ num +'" title="노출여부" value="N" '+(	common.nvl(datas.use_yn , '') != "Y" ? "checked" : ""	)+'/> 비 노출';
						str += '	</td>';
						
						/* str += '	<td onclick="event.cancelBubble=true;">';
						str += '		<button type="button" onclick="javascript:delCodeGrp('+num+');">삭제</button>';
						str += '		<input type="hidden" name="listType_'+num+'" id="listType_'+num+'" value="u" />';
						str += '	</td>';
						 */
						str += '</tr>' ;
						
						group_addCnt = num ; 
					}
					
					$('#table1Tbody').append( str ) ; 
					
				}else{
					commonTable.notData(4 , '조회된 데이터가 없습니다.' , 'table1Tbody') ; 
				}
			}
		}) ; 
	}
	
	/* function delCodeGrp(idx){
		if($('#listType_' + idx).val() == "u"){
			if(del_p_code == "") del_p_code = $('#p_code_' + idx).val() ; 
			else del_p_code = del_p_code + "@" + $('#p_code_' + idx).val() ;
		}
		
		$('#groupTr' + idx).remove() ;
		
	} */
	
	function addCodeGroup(){
		
		group_addCnt = group_addCnt + 1 ; 
		
		var num = group_addCnt ; 
		
		var str = '<tr id="groupTr'+num+'">' ;
		
		str += '	<td>';
		str += '		<input type="text" name="p_code_'+num+'" id="p_code_'+num+'"  title="공통 그룹 코드" value="" class="w100 mgr2" maxlength="4"/>';
		str += '	</td>';
		
		str += '	<td>';
		str += '		<input type="text" name="p_code_name_'+num+'" id="p_code_name_'+num+'" title="공통 그룹 코드명" value="" class="w200 mgr2" maxlength="250"/>';
		str += '	</td>';
		
		str += '	<td>';
		str += '		<input type="radio" id="use_yn_'+ num +'" name="use_yn_'+ num +'" title="노출여부" value="Y"  checked/> 노출&nbsp;';
		str += '		<input type="radio" id="use_yn_'+ num +'" name="use_yn_'+ num +'" title="노출여부" value="N" /> 비 노출';
		str += '	</td>';
		
		/* str += '	<td>';
		str += '		<button type="button" onclick="javascript:delCodeGrp('+num+');">삭제</button>';
		str += '		<input type="hidden" name="listType_'+num+'" id="listType_'+num+'" value="i" />';
		str += '	</td>';
		 */
		str += '</tr>' ;
		
		$('#table1Tbody').append( str ) ; 
	}
	
	function goCodeDetail(p_code){
		$('#table2Tbody').empty() ; 
		
		del_code = "" ; 
		code_addCnt = 0 ;
		
		$('#p_code').val(p_code) ; 
		
		$.ajax({
			type : 'post' ,
			url : '/ad/code/getCodeDetailList.do' , 
			data : $('form[name=listFrm]').serialize() ,
			dataType : 'json' , 
			statusCode : {
				403:function(data){
					alert("권한이 없습니다.");
				},
				404:function(data){
					alert('해당 페이지가 존재하지 않습니다.');
				}
			},
			success : function(data){
				var resultList = typeof data.resultList != "undefined" ? data.resultList : null ;
				
				if(resultList != null && resultList.length > 0){
					var str = '' ; 
					
					for(var i = 0 ; i < resultList.length ; i++){
						var datas = resultList[i] ;
						var num = (i + 1) ; 
						str += '<tr id="codeTr'+num+'">' ;
						
						str += '	<td>';
						str += '		<input type="text" name="code_'+num+'" id="code_'+num+'" readonly="readonly" title="공통 코드" value="'+common.nvl(datas.code , '')+'" class="w100 mgr2" maxlength="4"/>';
						str += '	</td>';
						
						str += '	<td>';
						str += '		<input type="text" name="code_name_'+num+'" id="code_name_'+num+'" readonly="readonly" title="공통 그룹 코드명" value="'+common.nvl(datas.code_name,'')+'" class="w200 mgr2" maxlength="250"/>';
						str += '	</td>';
						
						str += '	<td>';
						str += '		<input type="radio" id="code_use_yn_'+ num +'" name="code_use_yn_'+ num +'" title="노출여부" value="Y"  '+(	common.nvl(datas.use_yn , '') == "Y" ? "checked" : ""	)+'/> 노출&nbsp;';
						str += '		<input type="radio" id="code_use_yn_'+ num +'" name="code_use_yn_'+ num +'" title="노출여부" value="N" '+(	common.nvl(datas.use_yn , '') != "Y" ? "checked" : ""	)+'/> 비 노출';
						str += '	</td>';
						
						/* str += '	<td>';
						str += '		<button type="button" onclick="javascript:delCode('+num+');">삭제</button>';
						str += '		<input type="hidden" name="code_listType_'+num+'" id="code_listType_'+num+'" value="u" />';
						str += '	</td>';
						 */
						str += '</tr>' ;
						
						code_addCnt = num ; 
					}
					
					$('#table2Tbody').append( str ) ; 
					
				}else{
					commonTable.notData(4 , '조회된 데이터가 없습니다.' , 'table2Tbody') ; 
				}
			}
		}) ; 
	}
	
	function delCode(idx){
		if($('#code_listType_' + idx).val() == "u"){
			if(del_code == "") del_code = $('#code_' + idx).val() ; 
			else del_code = del_code + "@" + $('#code_' + idx).val() ;
		}
		
		$('#codeTr' + idx).remove() ;
	}
	
	function addCode(){
		
		if($('#p_code').val() == '' ) return ; 
		
		code_addCnt = code_addCnt + 1 ; 
		
		if(code_addCnt == "1") $('#table2Tbody').empty() ; 
		
		var num = code_addCnt ; 
		var str = '<tr id="codeTr'+num+'">' ;
		
		str += '	<td>';
		str += '		<input type="text" name="code_'+num+'" id="code_'+num+'" title="공통 코드" value="" class="w100 mgr2" maxlength="4"/>';
		str += '	</td>';
		
		str += '	<td>';
		str += '		<input type="text" name="code_name_'+num+'" id="code_name_'+num+'" title="공통 그룹 코드명" value="" class="w200 mgr2" maxlength="250"/>';
		str += '	</td>';
		
		str += '	<td>';
		str += '		<input type="radio" id="code_use_yn_'+ num +'" name="code_use_yn_'+ num +'" title="노출여부" value="Y"  checked/> 노출&nbsp;';
		str += '		<input type="radio" id="code_use_yn_'+ num +'" name="code_use_yn_'+ num +'" title="노출여부" value="N" /> 비 노출';
		str += '	</td>';
		
		/* str += '	<td>';
		str += '		<button type="button" onclick="javascript:delCode('+num+');">삭제</button>';
		str += '		<input type="hidden" name="code_listType_'+num+'" id="code_listType_'+num+'" value="i" />';
		str += '	</td>';
		 */
		str += '</tr>' ;
		
		$('#table2Tbody').append( str ) ; 
		
	}
	
	function goSave(){
		var f = document.listFrm ; 
		
		if(group_addCnt != 0){
			for(var i = 1 ; i <= group_addCnt ; i++ ){
				if(typeof $('#p_code_' + i).val() != "undefined"){
					if($('#listType_' + i).val() == "i"){
						
						if(common.isEmpty(common.replaceAll($('#p_code_' + i).val() , ' ' , ''))){
							alert("그룹 코드를 작성해 주세요.");
							return ; 
						}
						if(common.isEmpty(common.replaceAll($('#p_code_name_' + i).val() , ' ' , ''))){
							alert("그룹 코드명을 작성해 주세요.");
							return ; 
						}
					}
					
					for(var j = 1 ; j <= group_addCnt ; j++){
						
						if(i != j){
							if(typeof $('#p_code_' + j).val() != "undefined"){
								if($('#p_code_' + i).val() == $('#p_code_' + j).val()){
									alert("그룹코드가 중복 됩니다.") ; 
									return ; 
								}
							}
						}
						
					}					
				}
			}
		}
		
		if(code_addCnt != 0){
			for(var i = 1 ; i <= code_addCnt ; i++ ){
				if(typeof $('#code_' + i).val() != "undefined"){
					if($('#code_listType_' + i).val() == "i"){
						
						if(common.isEmpty(common.replaceAll($('#code_' + i).val() , ' ' , ''))){
							alert("상세코드를 작성해 주세요.");
							return ; 
						}
						if(common.isEmpty(common.replaceAll($('#code_name_' + i).val() , ' ' , ''))){
							alert("상세 코드명을 작성해 주세요.");
							return ; 
						}
					}
					
					for(var j = 1 ; j <= code_addCnt ; j++){
						
						if(i != j){
							if(typeof $('#code_' + j).val() != "undefined"){
								if($('#code_' + i).val() == $('#code_' + j).val()){
									alert("상세코드가 중복 됩니다.") ; 
									return ; 
								}
							}
						}
						
					}					
				}
			}
		}
		
		f.del_p_code.value = del_p_code ; 
		f.group_addCnt.value = group_addCnt ; 
		f.del_code.value = del_code ; 
		f.code_addCnt.value = code_addCnt ;
		
		$.ajax({
			type : 'post' ,
			url : '/ad/code/proc.do' , 
			data : $('form[name=listFrm]').serialize() ,
			dataType : 'json' , 
			statusCode : {
				403:function(data){
					alert("권한이 없습니다.");
				},
				404:function(data){
					alert('해당 페이지가 존재하지 않습니다.');
				}
			}, 
			success : function(data){
				var returnCode = typeof data.returnCode != "undefined" ? common.nvl(data.returnCode , "1000") : "1000" ; 
				var msg = "" ; 
				
				if(returnCode == "400") msg = "처리도중 오류가 발생했습니다." ;
				else if (returnCode == "gradeNot") msg = "내부관리자와 일반사용자는 권한이 없습니다.";
				else msg = "정상적으로 처리 되었습니다." ; 
				
				alert(msg) ;
				init() ; 
				
			}
		}) ; 
		
	}

</script>

<form name="listFrm" id="listFrm">
<input type="hidden" name="p_code" id="p_code" value=""/>
<input type="hidden" name="del_p_code" id="del_p_code" value=""/>
<input type="hidden" name="group_addCnt" id="group_addCnt" value=""/>
<input type="hidden" name="del_code" id="del_code" value=""/>
<input type="hidden" name="code_addCnt" id="code_addCnt" value=""/>

<div class="tit_wrap">
	<%= CommonExecute.returnLineMap(request) %>
</div>
<!-- write -->
<div class="tit_bWrap mgb10">
	<select name="code_group" id="code_group" onchange="getCodeGroup();">
		<option value="COMMON" selected>COMMON</option>
		<option value="AS">AS</option>
		<option value="CUST">CUST</option>
	</select>
</div>
<div style="width: calc(50% - 10px); padding-right: 10px; float: left;">
	<div class="tit_sWrap">
		<h3 class="tit_dot_gray">코드 그룹 </h3>
	</div>

	<div class="mgt-10 mgb10 textR">
		<button type="button" class="btn_add" onclick="javascript:addCodeGroup();"><span>추가</span></button>
	</div>
	<table class="hType mgb20">
		<caption>코드 그룹 내역</caption>
		<colgroup>
			<col style="width:60px">
			<col style="width:200px">
			<col style="width:200px">
			<%-- <col style="width:100px"> --%>
		</colgroup>
		<thead>
			<tr>
				<th scope="col">그룹 코드</th>
				<th scope="col">코드명</th>
				<th scope="col">노출 설정</th>
				<!-- <th scope="col">삭제</th> -->
			</tr>
		</thead>
		<tbody id="table1Tbody"></tbody>
	</table>
</div>


<div style="width: calc(50% - 10px); padding-left: 10px; float: left;">
	<div class="tit_sWrap">
		<h3 class="tit_dot_gray">코드 상세</h3>
	</div>

	<div class="mgt-10 mgb10 textR">
		<button type="button" class="btn_add" onclick="javascript:addCode();"><span>추가</span></button>
	</div>

	<table class="hType mgb20" >
		<caption>코드 상세 내역</caption>
		<colgroup>
			<col style="width:60px">
			<col style="width:200px">
			<col style="width:200px">
			<!-- <col style="width:100px"> -->
		</colgroup>
		<thead>
			<tr>
				<th scope="col">코드</th>
				<th scope="col">코드 명</th>
				<th scope="col">노출 설정</th>
				<!-- <th scope="col">삭제</th> -->
			</tr>
		</thead>
		<tbody id="table2Tbody"></tbody>
	</table>
</div>

<!--// write -->
<div class="btn_wrap">
	<div class="floatR">
		<button type="button" class="btn_ico_confirm" onclick="javascript:goSave();"><span>저장</span></button>
		<!-- <button type="button" class="btn_ico_cancel"><span>취소</span></button> -->
	</div>
</div>
</form>