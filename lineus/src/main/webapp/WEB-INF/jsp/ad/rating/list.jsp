<%@page import="egovframework.com.comm.util.CommonExecute"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">

	var cd08_option = "" ; 
	var cd09_option = "" ; 
	var cd11_option = "" ; 

	$(document).ready(function(){
		changePageType('CD1') ; 
		commonCode.getCodeList2('CUST' , 'CD08' , 'makeCd08') ; 
		commonCode.getCodeList2('CUST' , 'CD09' , 'makeCd09') ; 
		makeCd11();
	}) ; 
	
	function makeCd08(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var str = '<option value="">N/A</option>' ; 
		
		if(resultList != null && resultList.length > 0){
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ; 
				str += '<option value=\''+common.nvl(datas.code, '')+'\'>'+common.nvl(datas.code_name, '')+'</option>' ; 
			}
		}
		cd08_option = str ;
	}
	
	function makeCd09(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var str = '<option value="">N/A</option>' ; 
		
		if(resultList != null && resultList.length > 0){
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ; 
				str += '<option value=\''+common.nvl(datas.code, '')+'\'>'+common.nvl(datas.code_name, '')+'</option>' ; 
			}
		}
		cd09_option = str ;
	}
	
	function makeCd11(){
		 
		var str = '<option value="">N/A</option>' ; 
		
		for(var i = 0 ; i <= 10 ; i++){
			str += '<option value=\''+i+'\'>'+i+'</option>' ; 
		}
		
		cd11_option = str ;
	}

	function changePageType(thisObj){
		for(var i = 1 ; i <= 11 ; i++){
			if(thisObj == "CD" + i) $('#div' + i).show() ; 
			else  $('#div' + i).hide() ;
		}
		
		var datas = {'group_code' : thisObj} ; 
		common.ajaxCall(datas, '/ad/rating/getRatingInfo.do', 'makeRatingInfo' + common.replaceAll(thisObj , 'CD' , '')) ;
		
	}
	
	/**	입력	*/
	function makeRatingInfo1(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		if(resultList != null && resultList.length > 0){
			var datas = resultList[0] ; 
			$('#weight_1').val(common.nvl(datas.weight, '')) ; 
			$('#point_5_1').val(common.nvl(datas.point_5, '')) ; 
			$('#point_4_up_1').val(common.nvl(datas.point_4_up, '')) ; 
			$('#point_4_down_1').val(common.nvl(datas.point_4_down, '')) ; 
			$('#point_3_up_1').val(common.nvl(datas.point_3_up, '')) ; 
			$('#point_3_down_1').val(common.nvl(datas.point_3_down, '')) ; 
			$('#point_2_up_1').val(common.nvl(datas.point_2_up, '')) ; 
			$('#point_2_down_1').val(common.nvl(datas.point_2_down, '')) ; 
			$('#point_1_1').val(common.nvl(datas.point_1, '')) ; 
		}
	}
	
	function makeRatingInfo2(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		if(resultList != null && resultList.length > 0){
			var datas = resultList[0] ; 
			$('#weight_2').val(common.nvl(datas.weight, '')) ; 
			$('#point_5_2').val(common.nvl(datas.point_5, '')) ; 
			$('#point_4_up_2').val(common.nvl(datas.point_4_up, '')) ; 
			$('#point_4_down_2').val(common.nvl(datas.point_4_down, '')) ; 
			$('#point_3_up_2').val(common.nvl(datas.point_3_up, '')) ; 
			$('#point_3_down_2').val(common.nvl(datas.point_3_down, '')) ; 
			$('#point_2_up_2').val(common.nvl(datas.point_2_up, '')) ; 
			$('#point_2_down_2').val(common.nvl(datas.point_2_down, '')) ; 
			$('#point_1_2').val(common.nvl(datas.point_1, '')) ; 
		}
	}
	function makeRatingInfo3(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		if(resultList != null && resultList.length > 0){
			var datas = resultList[0] ; 
			$('#weight_3').val(common.nvl(datas.weight, '')) ; 
			$('#point_5_3').val(common.nvl(datas.point_5, '')) ; 
			$('#point_4_up_3').val(common.nvl(datas.point_4_up, '')) ; 
			$('#point_4_down_3').val(common.nvl(datas.point_4_down, '')) ; 
			$('#point_3_up_3').val(common.nvl(datas.point_3_up, '')) ; 
			$('#point_3_down_3').val(common.nvl(datas.point_3_down, '')) ; 
			$('#point_2_up_3').val(common.nvl(datas.point_2_up, '')) ; 
			$('#point_2_down_3').val(common.nvl(datas.point_2_down, '')) ; 
			$('#point_1_3').val(common.nvl(datas.point_1, '')) ; 
		}
	}
	function makeRatingInfo4(data){
		// cd08_option
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ;
		
		$('#point_5_4').empty().append(cd08_option) ; 
		$('#point_4_up_4').empty().append(cd08_option) ; 
		$('#point_3_up_4').empty().append(cd08_option) ; 
		$('#point_2_up_4').empty().append(cd08_option) ; 
		$('#point_1_4').empty().append(cd08_option) ;
		
		if(resultList != null && resultList.length > 0){
			var datas = resultList[0] ; 
			$('#weight_4').val(common.nvl(datas.weight, '')) ; 
			$('#point_5_4').val(common.nvl(datas.point_5, '')) ; 
			$('#point_4_up_4').val(common.nvl(datas.point_4_up, '')) ; 
			$('#point_3_up_4').val(common.nvl(datas.point_3_up, '')) ; 
			$('#point_2_up_4').val(common.nvl(datas.point_2_up, '')) ; 
			$('#point_1_4').val(common.nvl(datas.point_1, '')) ; 
		}
		
	}
	function makeRatingInfo5(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		if(resultList != null && resultList.length > 0){
			var datas = resultList[0] ; 
			$('#weight_5').val(common.nvl(datas.weight)) ; 
			$('#point_5_5').val(common.nvl(datas.point_5, '')) ; 
			$('#point_4_up_5').val(common.nvl(datas.point_4_up, '')) ; 
			$('#point_4_down_5').val(common.nvl(datas.point_4_down, '')) ; 
			$('#point_3_up_5').val(common.nvl(datas.point_3_up, '')) ; 
			$('#point_3_down_5').val(common.nvl(datas.point_3_down, '')) ; 
			$('#point_2_up_5').val(common.nvl(datas.point_2_up, '')) ; 
			$('#point_2_down_5').val(common.nvl(datas.point_2_down, '')) ; 
			$('#point_1_5').val(common.nvl(datas.point_1, '')) ; 
		}
	}
	function makeRatingInfo6(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		if(resultList != null && resultList.length > 0){
			var datas = resultList[0] ; 
			$('#weight_6').val(common.nvl(datas.weight, '')) ; 
			$('#point_5_6').val(common.nvl(datas.point_5, '')) ; 
			$('#point_4_up_6').val(common.nvl(datas.point_4_up, '')) ; 
			$('#point_4_down_6').val(common.nvl(datas.point_4_down, '')) ; 
			$('#point_3_up_6').val(common.nvl(datas.point_3_up, '')) ; 
			$('#point_3_down_6').val(common.nvl(datas.point_3_down, '')) ; 
			$('#point_2_up_6').val(common.nvl(datas.point_2_up, '')) ; 
			$('#point_2_down_6').val(common.nvl(datas.point_2_down, '')) ; 
			$('#point_1_6').val(common.nvl(datas.point_1, '')) ; 
		}
	}
	function makeRatingInfo7(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		if(resultList != null && resultList.length > 0){
			var datas = resultList[0] ; 
			$('#weight_7').val(common.nvl(datas.weight)) ; 
			$('#point_5_7').val(common.nvl(datas.point_5, '')) ; 
			$('#point_4_up_7').val(common.nvl(datas.point_4_up, '')) ; 
			$('#point_4_down_7').val(common.nvl(datas.point_4_down, '')) ; 
			$('#point_3_up_7').val(common.nvl(datas.point_3_up, '')) ; 
			$('#point_3_down_7').val(common.nvl(datas.point_3_down, '')) ; 
			$('#point_2_up_7').val(common.nvl(datas.point_2_up, '')) ; 
			$('#point_2_down_7').val(common.nvl(datas.point_2_down, '')) ; 
			$('#point_1_7').val(common.nvl(datas.point_1, '')) ; 
		}
	}
	function makeRatingInfo8(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		if(resultList != null && resultList.length > 0){
			var datas = resultList[0] ; 
			$('#weight_8').val(common.nvl(datas.weight, '')) ; 
			$('#point_5_8').val(common.nvl(datas.point_5, '')) ; 
			$('#point_4_up_8').val(common.nvl(datas.point_4_up, '')) ; 
			$('#point_4_down_8').val(common.nvl(datas.point_4_down, '')) ; 
			$('#point_3_up_8').val(common.nvl(datas.point_3_up, '')) ; 
			$('#point_3_down_8').val(common.nvl(datas.point_3_down, '')) ; 
			$('#point_2_up_8').val(common.nvl(datas.point_2_up, '')) ; 
			$('#point_2_down_8').val(common.nvl(datas.point_2_down, '')) ; 
			$('#point_1_8').val(common.nvl(datas.point_1, '')) ; 
		}
	}
	function makeRatingInfo9(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ;
		
		$('#point_5_9').empty().append(cd09_option) ; 
		$('#point_4_up_9').empty().append(cd09_option) ; 
		$('#point_3_up_9').empty().append(cd09_option) ; 
		$('#point_2_up_9').empty().append(cd09_option) ; 
		$('#point_1_9').empty().append(cd09_option) ;
		
		if(resultList != null && resultList.length > 0){
			var datas = resultList[0] ; 
			$('#weight_9').val(common.nvl(datas.weight, '')) ; 
			$('#point_5_9').val(common.nvl(datas.point_5, '')) ; 
			$('#point_4_up_9').val(common.nvl(datas.point_4_up, '')) ; 
			$('#point_3_up_9').val(common.nvl(datas.point_3_up, '')) ; 
			$('#point_2_up_9').val(common.nvl(datas.point_2_up, '')) ; 
			$('#point_1_9').val(common.nvl(datas.point_1, '')) ; 
		}
	}
	function makeRatingInfo10(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		if(resultList != null && resultList.length > 0){
			var datas = resultList[0] ; 
			$('#weight_10').val(common.nvl(datas.weight, '')) ; 
			$('#point_5_10').val(common.nvl(datas.point_5, '')) ; 
			$('#point_4_up_10').val(common.nvl(datas.point_4_up, '')) ; 
			$('#point_4_down_10').val(common.nvl(datas.point_4_down, '')) ; 
			$('#point_3_up_10').val(common.nvl(datas.point_3_up, '')) ; 
			$('#point_3_down_10').val(common.nvl(datas.point_3_down, '')) ; 
			$('#point_2_up_10').val(common.nvl(datas.point_2_up, '')) ; 
			$('#point_2_down_10').val(common.nvl(datas.point_2_down, '')) ; 
			$('#point_1_10').val(common.nvl(datas.point_1, '')) ; 
		}
	}
	function makeRatingInfo11(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ;
		
		$('#point_5_11').empty().append(cd11_option) ; 
		$('#point_4_up_11').empty().append(cd11_option) ; 
		$('#point_4_down_11').empty().append(cd11_option) ; 
		$('#point_3_up_11').empty().append(cd11_option) ; 
		$('#point_3_down_11').empty().append(cd11_option) ; 
		$('#point_2_up_11').empty().append(cd11_option) ; 
		$('#point_2_down_11').empty().append(cd11_option) ; 
		$('#point_1_11').empty().append(cd11_option) ;
		
		
		if(resultList != null && resultList.length > 0){
			var datas = resultList[0] ; 
			$('#weight_11').val(common.nvl(datas.weight, '')) ; 
			$('#point_5_11').val(common.nvl(datas.point_5, '')) ; 
			$('#point_4_up_11').val(common.nvl(datas.point_4_up, '')) ; 
			$('#point_4_down_11').val(common.nvl(datas.point_4_down, '')) ; 
			$('#point_3_up_11').val(common.nvl(datas.point_3_up, '')) ; 
			$('#point_3_down_11').val(common.nvl(datas.point_3_down, '')) ; 
			$('#point_2_up_11').val(common.nvl(datas.point_2_up, '')) ; 
			$('#point_2_down_11').val(common.nvl(datas.point_2_down, '')) ; 
			$('#point_1_11').val(common.nvl(datas.point_1, '')) ; 
		}
	}
	
	function changSelect(gubun , thisObj){
		
		if(thisObj == ""){
			$('#point_'+gubun+'_up_11').val("") ;
			$('#point_'+gubun+'_down_11').val("") ;
		}
	}
	
	
	function goSave(){
		if(confirm("저장 하시겠습니까?")){
			
			var flag = $("#group_code_main").val() ; 
			common.ajaxCall($('form[name=procFrm'+common.replaceAll(flag , 'CD' , '')+']').serialize(), '/ad/rating/registRating.do', 'returnSave') ;
		}
	}
	function goClear(){
		changePageType($('#group_code_main').val());
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
	<select name="group_code" id="group_code_main" onchange ="changePageType(this.value);">
	    <option value="CD1">업력</option>
	    <option value="CD2">서비스유지기간</option>
	    <option value="CD3">병원규모</option>
	    <option value="CD4">소유구분</option>
	    <option value="CD5">매출액</option>
	    <option value="CD6">HIS유지보수금액</option>
	    <option value="CD7">부가서비스 유지보수금액</option>
	    <option value="CD8">유지보수금액 인상일</option>
	    <option value="CD9">지불방법</option>
	    <option value="CD10">연체기간</option>
	    <option value="CD11">채권 최고서발송</option>
	</select>
</div>

<div id="div1">
	<form name="procFrm1" id="procFrm1" method="post" onsubmit="return false;">
		<input type="hidden" name="group_code" id="group_code" value="CD1"/>
		<table class="sType mgb20">
			<caption>업력</caption>
			<colgroup>
				<col style="width:130px;" />
				<col style="width:290px;" />
				<col style="width:130px;" />
				<col style="width:auto;" />
			</colgroup>
			<tr>
				<th scope="row">가중치</th>
				<td>
					<input type="text" class="w250" name="weight" id="weight_1" value="" maxlength="50"/>
				</td>
				<th scope="row">단위</th>
				<td>
					<input type="text" value="년" readonly="readonly" class="w250" />
				</td>
			</tr>
			<tr>
			    <th scope="row">5점</th>
			    <td colspan="3"><input type="text" class="w250 mgr5" name="point_5" id="point_5_1" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80" /></td>
			</tr>
			<tr>
			    <th scope="row">4점</th>
			    <td colspan="3"><input type="text" class="w250 mgr5" name="point_4_up" id="point_4_up_1" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80 mgr10" /><input type="text" class="w250 mgr5" name="point_4_down" id="point_4_down_1" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
			</tr>
			<tr>
			    <th scope="row">3점</th>
			    <td colspan="3"><input type="text" class="w250 mgr5" name="point_3_up" id="point_3_up_1" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80 mgr10" /><input type="text" class="w250 mgr5" name="point_3_down" id="point_3_down_1" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
			</tr>
			<tr>
			    <th scope="row">2점</th>
			    <td colspan="3"><input type="text" class="w250 mgr5" name="point_2_up" id="point_2_up_1" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80 mgr10" /><input type="text" class="w250 mgr5" name="point_2_down" id="point_2_down_1" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
			</tr>
			<tr>
			    <th scope="row">1점</th>
			    <td colspan="3"><input type="text" class="w250 mgr5" name="point_1" id="point_1_1" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
			</tr>
		</table>
	</form>
</div>

<div id="div2" style="display:none;">
	<form name="procFrm2" id="procFrm2" method="post" onsubmit="return false;">
		<input type="hidden" name="group_code" id="group_code" value="CD2"/>
		<table class="sType mgb20">
			<caption>업력</caption>
			<colgroup>
				<col style="width:130px;" />
				<col style="width:290px;" />
				<col style="width:130px;" />
				<col style="width:auto;" />
			</colgroup>
			<tr>
				<th scope="row">가중치</th>
				<td>
					<input type="text" class="w250" name="weight" id="weight_2" value="" maxlength="50"/>
				</td>
				<th scope="row">단위</th>
				<td>
					<input type="text" value="년" readonly="readonly" class="w250" />
				</td>
			</tr>
			<tr>
			    <th scope="row">5점</th>
			    <td colspan="3"><input type="text" class="w250 mgr5" name="point_5" id="point_5_2" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80" /></td>
			</tr>
			<tr>
			    <th scope="row">4점</th>
			    <td colspan="3"><input type="text" class="w250 mgr5" name="point_4_up" id="point_4_up_2" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80 mgr10" /><input type="text" class="w250 mgr5" name="point_4_down" id="point_4_down_2" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
			</tr>
			<tr>
			    <th scope="row">3점</th>
			    <td colspan="3"><input type="text" class="w250 mgr5" name="point_3_up" id="point_3_up_2" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80 mgr10" /><input type="text" class="w250 mgr5" name="point_3_down" id="point_3_down_2" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
			</tr>
			<tr>
			    <th scope="row">2점</th>
			    <td colspan="3"><input type="text" class="w250 mgr5" name="point_2_up" id="point_2_up_2" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80 mgr10" /><input type="text" class="w250 mgr5" name="point_2_down" id="point_2_down_2" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
			</tr>
			<tr>
			    <th scope="row">1점</th>
			    <td colspan="3"><input type="text" class="w250 mgr5" name="point_1" id="point_1_2" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
			</tr>
		</table>
	</form>
</div>

<div id="div3" style="display:none;">
	<form name="procFrm3" id="procFrm3" method="post" onsubmit="return false;">
		<input type="hidden" name="group_code" id="group_code" value="CD3"/>
		<table class="sType mgb20">
			<caption>업력</caption>
			<colgroup>
				<col style="width:130px;" />
				<col style="width:290px;" />
				<col style="width:130px;" />
				<col style="width:auto;" />
			</colgroup>
			<tr>
				<th scope="row">가중치</th>
				<td>
					<input type="text" class="w250" name="weight" id="weight_3" value="" maxlength="50"/>
				</td>
				<th scope="row">단위</th>
				<td>
					<input type="text" value="Bed" readonly="readonly" class="w250" />
				</td>
			</tr>
			<tr>
			    <th scope="row">5점</th>
			    <td colspan="3"><input type="text" class="w250 mgr5" name="point_5" id="point_5_3" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80" /></td>
			</tr>
			<tr>
			    <th scope="row">4점</th>
			    <td colspan="3"><input type="text" class="w250 mgr5" name="point_4_up" id="point_4_up_3" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80 mgr10" /><input type="text" class="w250 mgr5" name="point_4_down" id="point_4_down_3" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
			</tr>
			<tr>
			    <th scope="row">3점</th>
			    <td colspan="3"><input type="text" class="w250 mgr5" name="point_3_up" id="point_3_up_3" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80 mgr10" /><input type="text" class="w250 mgr5" name="point_3_down" id="point_3_down_3" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
			</tr>
			<tr>
			    <th scope="row">2점</th>
			    <td colspan="3"><input type="text" class="w250 mgr5" name="point_2_up" id="point_2_up_3" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80 mgr10" /><input type="text" class="w250 mgr5" name="point_2_down" id="point_2_down_3" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
			</tr>
			<tr>
			    <th scope="row">1점</th>
			    <td colspan="3"><input type="text" class="w250 mgr5" name="point_1" id="point_1_3" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
			</tr>
		</table>
	</form>
</div>

<div id="div4" style="display:none;">
	<form name="procFrm4" id="procFrm4" method="post" onsubmit="return false;">
		<input type="hidden" name="group_code" id="group_code" value="CD4"/>
		<table class="sType mgb20">
			<caption>업력</caption>
			<colgroup>
				<col style="width:130px;" />
				<col style="width:auto;" />
			</colgroup>
			<tr>
				<th scope="row">가중치</th>
				<td>
					<input type="text" class="w250" name="weight" id="weight_4" value="" maxlength="50" />
				</td>
			</tr>
			<tr>
			    <th scope="row">5점</th>
			    <td><select class="w250 mgr10" name="point_5" id="point_5_4"></select></td>
			</tr>
			<tr>
			    <th scope="row">4점</th>
			    <td><select class="w250 mgr10" name="point_4_up" id="point_4_up_4"></select></td>
			</tr>
			<tr>
			    <th scope="row">3점</th>
			    <td><select class="w250 mgr10"  name="point_3_up" id="point_3_up_4"></select></td>
			</tr>
			<tr>
			    <th scope="row">2점</th>
			    <td><select class="w250 mgr10" name="point_2_up" id="point_2_up_4"></select></td>
			</tr>
			<tr>
			    <th scope="row">1점</th>
			    <td><select class="w250 mgr10" name="point_1" id="point_1_4"></select></td>
			</tr>
		</table>
	</form>
</div>

<div id="div5" style="display:none;">
	<form name="procFrm5" id="procFrm5" method="post" onsubmit="return false;">
		<input type="hidden" name="group_code" id="group_code" value="CD5"/>
		<table class="sType mgb20">
				<caption>업력</caption>
				<colgroup>
					<col style="width:130px;" />
					<col style="width:290px;" />
					<col style="width:130px;" />
					<col style="width:auto;" />
				</colgroup>
				<tr>
					<th scope="row">가중치</th>
					<td>
						<input type="text" class="w250" name="weight" id="weight_5" value="" maxlength="50"/>
					</td>
					<th scope="row">단위</th>
					<td>
						<input type="text" value="천원(1,000)" readonly="readonly" class="w250" />
					</td>
				</tr>
				<tr>
				    <th scope="row">5점</th>
				    <td colspan="3"><input type="text" class="w250 mgr5" name="point_5" id="point_5_5" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80" /></td>
				</tr>
				<tr>
				    <th scope="row">4점</th>
				    <td colspan="3"><input type="text" class="w250 mgr5" name="point_4_up" id="point_4_up_5" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80 mgr10" /><input type="text" class="w250 mgr5" name="point_4_down" id="point_4_down_5" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
				</tr>
				<tr>
				    <th scope="row">3점</th>
				    <td colspan="3"><input type="text" class="w250 mgr5" name="point_3_up" id="point_3_up_5" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80 mgr10" /><input type="text" class="w250 mgr5" name="point_3_down" id="point_3_down_5" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
				</tr>
				<tr>
				    <th scope="row">2점</th>
				    <td colspan="3"><input type="text" class="w250 mgr5" name="point_2_up" id="point_2_up_5" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80 mgr10" /><input type="text" class="w250 mgr5" name="point_2_down" id="point_2_down_5" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
				</tr>
				<tr>
				    <th scope="row">1점</th>
				    <td colspan="3"><input type="text" class="w250 mgr5" name="point_1" id="point_1_5" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
				</tr>
			</table>
		</form>
</div>

<div id="div6" style="display:none;">
	<form name="procFrm6" id="procFrm6" method="post" onsubmit="return false;">
		<input type="hidden" name="group_code" id="group_code" value="CD6"/>
		<table class="sType mgb20">
				<caption>업력</caption>
				<colgroup>
					<col style="width:130px;" />
					<col style="width:290px;" />
					<col style="width:130px;" />
					<col style="width:auto;" />
				</colgroup>
				<tr>
					<th scope="row">가중치</th>
					<td>
						<input type="text" class="w250" name="weight" id="weight_6" value="" maxlength="50"/>
					</td>
					<th scope="row">단위</th>
					<td>
						<input type="text" value="만원(10,000)" readonly="readonly" class="w250" />
					</td>
				</tr>
				<tr>
				    <th scope="row">5점</th>
				    <td colspan="3"><input type="text" class="w250 mgr5" name="point_5" id="point_5_6" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80" /></td>
				</tr>
				<tr>
				    <th scope="row">4점</th>
				    <td colspan="3"><input type="text" class="w250 mgr5" name="point_4_up" id="point_4_up_6" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80 mgr10" /><input type="text" class="w250 mgr5" name="point_4_down" id="point_4_down_6" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
				</tr>
				<tr>
				    <th scope="row">3점</th>
				    <td colspan="3"><input type="text" class="w250 mgr5" name="point_3_up" id="point_3_up_6" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80 mgr10" /><input type="text" class="w250 mgr5" name="point_3_down" id="point_3_down_6" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
				</tr>
				<tr>
				    <th scope="row">2점</th>
				    <td colspan="3"><input type="text" class="w250 mgr5" name="point_2_up" id="point_2_up_6" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80 mgr10" /><input type="text" class="w250 mgr5" name="point_2_down" id="point_2_down_6" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
				</tr>
				<tr>
				    <th scope="row">1점</th>
				    <td colspan="3"><input type="text" class="w250 mgr5" name="point_1" id="point_1_6" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
				</tr>
			</table>
		</form>
</div>

<div id="div7" style="display:none;">
	<form name="procFrm7" id="procFrm7" method="post" onsubmit="return false;">
		<input type="hidden" name="group_code" id="group_code" value="CD7"/>
		<table class="sType mgb20">
				<caption>업력</caption>
				<colgroup>
					<col style="width:130px;" />
					<col style="width:290px;" />
					<col style="width:130px;" />
					<col style="width:auto;" />
				</colgroup>
				<tr>
					<th scope="row">가중치</th>
					<td>
						<input type="text" class="w250" name="weight" id="weight_7" value="" maxlength="50"/>
					</td>
					<th scope="row">단위</th>
					<td>
						<input type="text" value="만원(10,000)" readonly="readonly" class="w250" />
					</td>
				</tr>
				<tr>
				    <th scope="row">5점</th>
				    <td colspan="3"><input type="text" class="w250 mgr5" name="point_5" id="point_5_7" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80" /></td>
				</tr>
				<tr>
				    <th scope="row">4점</th>
				    <td colspan="3"><input type="text" class="w250 mgr5" name="point_4_up" id="point_4_up_7" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80 mgr10" /><input type="text" class="w250 mgr5" name="point_4_down" id="point_4_down_7" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
				</tr>
				<tr>
				    <th scope="row">3점</th>
				    <td colspan="3"><input type="text" class="w250 mgr5" name="point_3_up" id="point_3_up_7" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80 mgr10" /><input type="text" class="w250 mgr5" name="point_3_down" id="point_3_down_7" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
				</tr>
				<tr>
				    <th scope="row">2점</th>
				    <td colspan="3"><input type="text" class="w250 mgr5" name="point_2_up" id="point_2_up_7" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80 mgr10" /><input type="text" class="w250 mgr5" name="point_2_down" id="point_2_down_7" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
				</tr>
				<tr>
				    <th scope="row">1점</th>
				    <td colspan="3"><input type="text" class="w250 mgr5" name="point_1" id="point_1_7" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
				</tr>
			</table>
		</form>
</div>

<div id="div8" style="display:none;">
	<form name="procFrm8" id="procFrm8" method="post" onsubmit="return false;">
		<input type="hidden" name="group_code" id="group_code" value="CD8"/>
		<table class="sType mgb20">
				<caption>업력</caption>
				<colgroup>
					<col style="width:130px;" />
					<col style="width:290px;" />
					<col style="width:130px;" />
					<col style="width:auto;" />
				</colgroup>
				<tr>
					<th scope="row">가중치</th>
					<td>
						<input type="text" class="w250" name="weight" id="weight_8" value="" maxlength="50"/>
					</td>
					<th scope="row">단위</th>
					<td>
						<input type="text" value="년" readonly="readonly" class="w250" />
					</td>
				</tr>
				<tr>
				    <th scope="row">5점</th>
				    <td colspan="3"><input type="text" class="w250 mgr5" name="point_5" id="point_5_8" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80" /></td>
				</tr>
				<tr>
				    <th scope="row">4점</th>
				    <td colspan="3"><input type="text" class="w250 mgr5" name="point_4_up" id="point_4_up_8" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80 mgr10" /><input type="text" class="w250 mgr5" name="point_4_down" id="point_4_down_8" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
				</tr>
				<tr>
				    <th scope="row">3점</th>
				    <td colspan="3"><input type="text" class="w250 mgr5" name="point_3_up" id="point_3_up_8" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80 mgr10" /><input type="text" class="w250 mgr5" name="point_3_down" id="point_3_down_8" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
				</tr>
				<tr>
				    <th scope="row">2점</th>
				    <td colspan="3"><input type="text" class="w250 mgr5" name="point_2_up" id="point_2_up_8" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80 mgr10" /><input type="text" class="w250 mgr5" name="point_2_down" id="point_2_down_8" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
				</tr>
				<tr>
				    <th scope="row">1점</th>
				    <td colspan="3"><input type="text" class="w250 mgr5" name="point_1" id="point_1_8" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
				</tr>
			</table>
		</form>
</div>

<div id="div9" style="display:none;">
	<form name="procFrm9" id="procFrm9" method="post" onsubmit="return false;">
		<input type="hidden" name="group_code" id="group_code" value="CD9"/>
		<table class="sType mgb20">
			<caption>업력</caption>
			<colgroup>
				<col style="width:130px;" />
				<col style="width:auto;" />
			</colgroup>
			<tr>
				<th scope="row">가중치</th>
				<td>
					<input type="text" class="w250" name="weight" id="weight_9" value="" maxlength="50" />
				</td>
			</tr>
			<tr>
			    <th scope="row">5점</th>
			    <td><select class="w250 mgr10" name="point_5" id="point_5_9"></select></td>
			</tr>
			<tr>
			    <th scope="row">4점</th>
			    <td><select class="w250 mgr10" name="point_4_up" id="point_4_up_9"></select></td>
			</tr>
			<tr>
			    <th scope="row">3점</th>
			    <td><select class="w250 mgr10"  name="point_3_up" id="point_3_up_9"></select></td>
			</tr>
			<tr>
			    <th scope="row">2점</th>
			    <td><select class="w250 mgr10" name="point_2_up" id="point_2_up_9"></select></td>
			</tr>
			<tr>
			    <th scope="row">1점</th>
			    <td><select class="w250 mgr10" name="point_1" id="point_1_9"></select></td>
			</tr>
		</table>
	</form>
</div>

<div id="div10" style="display:none;">
	<form name="procFrm10" id="procFrm10" method="post" onsubmit="return false;">
		<input type="hidden" name="group_code" id="group_code" value="CD10"/>
		<table class="sType mgb20">
				<caption>업력</caption>
				<colgroup>
					<col style="width:130px;" />
					<col style="width:290px;" />
					<col style="width:130px;" />
					<col style="width:auto;" />
				</colgroup>
				<tr>
					<th scope="row">가중치</th>
					<td>
						<input type="text" class="w250" name="weight" id="weight_10" value="" maxlength="50"/>
					</td>
					<th scope="row">단위</th>
					<td>
						<input type="text" value="개월" readonly="readonly" class="w250" />
					</td>
				</tr>
				<tr>
				    <th scope="row">5점</th>
				    <td colspan="3"><input type="text" class="w250 mgr5" name="point_5" id="point_5_10" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80" /></td>
				</tr>
				<tr>
				    <th scope="row">4점</th>
				    <td colspan="3"><input type="text" class="w250 mgr5" name="point_4_up" id="point_4_up_10" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80 mgr10" /><input type="text" class="w250 mgr5" name="point_4_down" id="point_4_down_10" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
				</tr>
				<tr>
				    <th scope="row">3점</th>
				    <td colspan="3"><input type="text" class="w250 mgr5" name="point_3_up" id="point_3_up_10" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80 mgr10" /><input type="text" class="w250 mgr5" name="point_3_down" id="point_3_down_10" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
				</tr>
				<tr>
				    <th scope="row">2점</th>
				    <td colspan="3"><input type="text" class="w250 mgr5" name="point_2_up" id="point_2_up_10" value="" maxlength="50"/><input type="text" readonly="readonly" value="이상" class="w80 mgr10" /><input type="text" class="w250 mgr5" name="point_2_down" id="point_2_down_10" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
				</tr>
				<tr>
				    <th scope="row">1점</th>
				    <td colspan="3"><input type="text" class="w250 mgr5" name="point_1" id="point_1_10" value="" maxlength="50"/><input type="text" readonly="readonly" value="미만" class="w80" /></td>
				</tr>
			</table>
		</form>
</div>

<div id="div11" style="display:none;">
	<form name="procFrm11" id="procFrm11" method="post" onsubmit="return false;">
		<input type="hidden" name="group_code" id="group_code" value="CD11"/>
		<table class="sType mgb20">
			<caption>업력</caption>
			<colgroup>
				<col style="width:130px;" />
				<col style="width:290px;" />
				<col style="width:130px;" />
				<col style="width:auto;" />
			</colgroup>
			<tr>
				<th scope="row">가중치</th>
				<td>
					<input type="text" class="w250" name="weight" id="weight_11" value="" maxlength="50"/>
				</td>
				<th scope="row">단위</th>
				<td>
					<input type="text" value="발송건수" readonly="readonly" class="w250" />
				</td>
			</tr>
			<tr>
				<th scope="row">5점</th>
				<td colspan="3">
					<select class="w250 mgr10" name="point_5" id="point_5_11"></select>
					<input type="text" readonly="readonly" value="이하" class="w80 mgr10" />
				</td>
			</tr>
			<tr>
				<th scope="row">4점</th>
				<td colspan="3">
					<select class="w250 mgr10" name="point_4_up" id="point_4_up_11" onchange="changSelect('4', this.value);"></select>
					<input type="text" readonly="readonly" value="이상" class="w80 mgr10" />
					<select class="w250 mgr10" name="point_4_down" id="point_4_down_11"  onchange="changSelect('4', this.value);"></select>
					<input type="text" readonly="readonly" value="이하" class="w80" />
				</td>
			</tr>
			<tr>
				<th scope="row">3점</th>
				<td colspan="3">
					<select class="w250 mgr10" name="point_3_up" id="point_3_up_11" onchange="changSelect('3', this.value);"></select>
					<input type="text" readonly="readonly" value="이상" class="w80 mgr10" />
					<select class="w250 mgr10" name="point_3_down" id="point_3_down_11" onchange="changSelect('3', this.value);"></select>
					<input type="text" readonly="readonly" value="이하" class="w80" />
				</td>
			</tr>
			<tr>
				<th scope="row">2점</th>
				<td colspan="3">
					<select class="w250 mgr10" name="point_2_up" id="point_2_up_11" onchange="changSelect('2', this.value);"></select>
					<input type="text" readonly="readonly" value="이상" class="w80 mgr10" />
					<select class="w250 mgr10" name="point_2_down" id="point_2_down_11" onchange="changSelect('2', this.value);"></select>
					<input type="text" readonly="readonly" value="이하" class="w80" />
				</td>
			</tr>
			<tr>
				<th scope="row">1점</th>
				<td colspan="3">
					<select class="w250 mgr10" name="point_1" id="point_1_11"></select>
					<input type="text" readonly="readonly" value="이하" class="w80" />
				</td>
			</tr>
		</table>	
	</form>
</div>

<div class="btn_wrap">
	<div class="floatR">
		<button type="button" class="btn_ico_confirm" onclick="javascript:goSave();"><span>저장</span></button><button type="button" class="btn_ico_cancel" onclick="goClear();"><span>취소</span></button>
	</div>
</div>
