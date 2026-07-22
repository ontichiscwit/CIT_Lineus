<%@page import="egovframework.com.comm.util.CommonExecute"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">

	$(document).ready(function(){
		changePageType('CD12') ; 
	}) ; 
	
	

	function changePageType(thisObj){
		var datas = {'group_code' : thisObj} ; 
		common.ajaxCall(datas, '/ad/rating/getRatingInfo.do', 'makeRatingInfo' + common.replaceAll(thisObj , 'CD' , '')) ;
		
	}
	
	/**	입력	*/
	function makeRatingInfo12(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		if(resultList != null && resultList.length > 0){
			var datas = resultList[0] ; 
			$('#point_5_12').val(common.nvl(datas.point_5, '')) ; 
			$('#point_4_up_12').val(common.nvl(datas.point_4_up, '')) ; 
			$('#point_4_down_12').val(common.nvl(datas.point_4_down, '')) ; 
			$('#point_3_up_12').val(common.nvl(datas.point_3_up, '')) ; 
			$('#point_3_down_12').val(common.nvl(datas.point_3_down, '')) ; 
			$('#point_1_12').val(common.nvl(datas.point_1, '')) ; 
		}
	}
	
	
	
	
	function goSave(){
		if(confirm("저장 하시겠습니까?")){
			var flag = $("#group_code").val() ;
			common.ajaxCall($('form[name=procFrm'+common.replaceAll(flag , 'CD' , '')+']').serialize(), '/ad/rating/registRating.do', 'returnSave') ;
		}
	}
	function goClear(){
		changePageType('CD12') ; 
	}
	
	function returnSave(data){
		var returnCode = typeof data.returnCode != "undefined" ? data.returnCode : "777" ; 
		var msg = "정상적으로 저장 되었습니다." ; 
		
		if(returnCode == "999") msg = "정상적으로 저장 되지 않았습니다." ; 
		else if(returnCode == "888") msg = "처리도중 오류가 발생 했습니다." ;
		else if(returnCode == "777") msg = "시스템 오류 입니다." ;
		else if(returnCode == "gradeNot") msg = "내부관리자와 일반사용자는 권한이 없습니다.";
		
		alert(msg) ; 
		return ; 
	}
	
</script>

<div class="tit_wrap">
	<%= CommonExecute.returnLineMap(request) %>
</div>

<div class="tit_bWrap mgb10">
	<select name="group_code" id="group_code">
	    <option value="CD12">연체기간</option>
	</select>
</div>

<form name="procFrm12" id="procFrm12" method="post" onsubmit="return false;">
	<input type="hidden" name="group_code" id="group_code" value="CD12"/>
	<table class="sType mgb20">
		<caption>업력</caption>
		<colgroup>
			<col style="width:130px;" />
			<col style="width:290px;" />
			<col style="width:130px;" />
			<col style="width:auto;" />
		</colgroup>
		<tr>
			<th scope="row">단위</th>
			<td colspan="3">
				<input type="text" class="w250" readonly="readonly" value="개월"/>
			</td>
		</tr>
		<tr>
		    <th scope="row">A</th>
		    <td colspan="3"><input type="text" class="w250 mgr5" name="point_5" id="point_5_12" value="" maxlength="50"/><input type="text" readonly="readonly" value="이하" class="w80" /></td>
		</tr>
		<tr>
		    <th scope="row">B</th>
		    <td colspan="3"><input type="text" class="w250 mgr5" name="point_4_up" id="point_4_up_12" value="" maxlength="50"/><input type="text" readonly="readonly" value="초과" class="w80 mgr10" /><input type="text" class="w250 mgr5" name="point_4_down" id="point_4_down_12" value="" maxlength="50"/><input type="text" readonly="readonly" value="이하" class="w80" /></td>
		</tr>
		<tr>
		    <th scope="row">C</th>
		    <td colspan="3"><input type="text" class="w250 mgr5" name="point_3_up" id="point_3_up_12" value="" maxlength="50"/><input type="text" readonly="readonly" value="초과" class="w80 mgr10" /><input type="text" class="w250 mgr5" name="point_3_down" id="point_3_down_12" value="" maxlength="50"/><input type="text" readonly="readonly" value="이하" class="w80" /></td>
		</tr>
		<tr>
		    <th scope="row">D</th>
		    <td colspan="3"><input type="text" class="w250 mgr5" name="point_1" id="point_1_12" value="" maxlength="50"/><input type="text" readonly="readonly" value="초과" class="w80" /></td>
		</tr>
	</table>
</form>


<div class="btn_wrap">
	<div class="floatR">
		<button type="button" class="btn_ico_confirm" onclick="javascript:goSave();"><span>저장</span></button><button type="button" class="btn_ico_cancel" onclick="goClear();"><span>취소</span></button>
	</div>
</div>
