<%@page import="egovframework.com.comm.util.CommonExecute"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javascript" src="/js/jquery.mtz.monthpicker.js"></script>
<script type="text/javascript">
	
	$(document).ready(function(){
		getStateList('1');
	});
	
	
	function getStateList(page){
		var datas = {'page' : page};
		common.ajaxCall(datas , '/ad/system/getStateCrList.do', 'makeStateList') ;
	}
	
	function makeStateList(data){
		var str = "" ;
		var htmlWrap = $('#stateList');
		htmlWrap.empty();
		
		$('#count').html('0') ;
		$("#pagination").html('');
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var vo = data.vo != "undefined" ? data.vo : null ;
		
		if(resultList != null && resultList.length > 0){
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = data.resultList[i];
				str += "<tr id=row_"+datas.seq+">" ;
				str += "	<td>" + "<input type='text' readonly='readonly'  id='seq' name='seq' value="+datas.seq+">" + "</td>" ;
				str += "	<td>" + "<input type='text' id='gubun1' name='gubun1' value="+common.nvl(datas.gubun1, '')+"></td>" ;
				str += "	<td>" + "<input type='text' id='gubun2' name='gubun2' value="+common.nvl(datas.gubun2, '')+"></td>" ;
				str += "	<td>" + "<input type='text' id='gubun3' name='gubun3' value="+common.nvl(datas.gubun3, '')+"></td>" ;
				str += "	<td>" + "<input type='text' id='gubun4' name='gubun4' value="+common.nvl(datas.gubun4, '')+"></td>" ;
				str += "	<td>" + "<input type='text' id='val1' name='val1' value="+common.nvl(datas.val1, '')+"></td>" ;
				str += "	<td>" + "<input type='text' id='val2' name='val2' value="+common.nvl(datas.val2, '')+"></td>" ;
				str += "	<td>" + "<input type='text' id='val3' name='val3' value="+common.nvl(datas.val3, '')+"></td>" ;
				str += "	<td>" + "<input type='text' id='val4' name='val4' value="+common.nvl(datas.val4, '')+"></td>" ;
				str += "	<td onclick='javascript:updateState("+datas.seq+")' style='cursor:pointer'>" + "[수정]" + "</td>" ;
				str += "</tr>" ;
				$('#count').html(vo.rowCnt) ; 
				htmlWrap.html(str);
				$("#pagination").html(vo.json_paging);
			}
		} else {
			$('#count').html('0') ; 
			commonTable.notData(10 , '조회된 데이터가 없습니다.' , 'approvalList') ; 
			$("#pagination").html('');
		} 
	}
	
	function updateState(seq){
		
		var rowId = "row_" + seq ; 
		var gubun1 = $("#"+rowId +" #gubun1").val();
		var gubun2 = $("#"+rowId +" #gubun2").val();
		var gubun3 = $("#"+rowId +" #gubun3").val();
		var gubun4 = $("#"+rowId +" #gubun4").val();
		var val1 = $("#"+rowId +" #val1").val();
		var val2 = $("#"+rowId +" #val2").val();
		var val3 = $("#"+rowId +" #val3").val();
		var val4 = $("#"+rowId +" #val4").val();
		var datas = {
				'seq' : seq
				,'gubun1' : gubun1
				,'gubun2' : gubun2
				,'gubun3' : gubun3
				,'gubun4' : gubun4
				,'val1' : val1
				,'val2' : val2
				,'val3' : val3
				,'val4' : val4};
		common.ajaxCall(datas , '/ad/system/updateStateCr.do', 'procReturn') ;
		
	}
	
	
	function procReturn(data){
		if(data.returnCode ="000"){alert('정상 처리 되었습니다.');
			getStateList('1');
		}else{
			alert('처리도중 오류가 발생했습니다.');
		}	
	}
	
</script>
<style>
	.scroll-table {width: 1720px; table-layout: auto;}
</style>


<div class="tit_wrap">
	<%= CommonExecute.returnLineMap(request) %>
</div>
<form name="progRegistForm" method="post" onsubmit="return false;">
<input type="hidden" id="group_addCnt" name="group_addCnt"></input>
<div class="tit_bWrap mgb10">
	<h4 class="floatL mgt8">통계분석관리</h4>
</div>

<!--write -->
<div style="overflow-x:auto;">
	<table class="hType mgb10 scroll-table" id="approval_add_tb">
		<caption>관리 정보</caption>
		<colgroup>
			<col style="width:50px" />
			<col style="width:100px" />
			<col style="width:100px" />
			<col style="width:100px" />
			<col style="width:100px" />
			
			<col style="width:300px" />
			<col style="width:100px" />
			<col style="width:100px" />
			<col style="width:100px" />
			<col style="width:100px" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">SEQ</th>
				<th scope="col">구분1</th>
				<th scope="col">구분2</th>
				<th scope="col">구분3</th>
				<th scope="col">구분3</th>
				<th scope="col">VAL1</th>
				<th scope="col">VAL2</th>
				<th scope="col">VAL3</th>
				<th scope="col">VAL4</th>
				<th scope="col">수정</th>
			</tr>
		</thead>
		<tbody id="stateList"></tbody>
</table>
</div>
<div class="page">
	<div id="pagination"></div>
</div>
</form>
<!-- write -->



