<%@page import="egovframework.com.comm.model.UserVO"%>
<%@page import="egovframework.com.comm.util.CommonExecute"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="egovframework.com.comm.util.DateTimeUtil"%>

<script type="text/javascript">
	$(document).ready(function(){
		
		initView();
		
	}) ; 
	
	function initView(){
		
		var datas = {
				'userid' 				: '${ vo.userid }',
				'retiredt' 				: '${ vo.retiredt }'
		}
		var datas2 = {
				'retiredt' 				: '${ vo.retiredt }'
		}
		common.ajaxCall(datas , '/ad/retire/getRetireInfo.do', 'makeRetireInfo') ;
		common.ajaxCall(datas2 , '/ad/retire/getRetireInit.do', 'initRetireForm') ;
	}
	
	function makeRetireInfo(data){
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null ; 
		
		if(resultVO != null){
			
			var vRetireDate = "-";
			if (common.nvl(resultVO.retiredt, '').length == 8){
				vRetireDate = makeDate(resultVO.retiredt,"-");
	 		}
			
			var vRetireFlag = "";
			if(common.nvl(resultVO.retire_flag , '') == 'C002'){	
				vRetireFlag = "사간이동";
			}else{
				vRetireFlag = "퇴사";
			}
			
			$('#company_nm').val(common.nvl(resultVO.company_nm, '')) ; 
			$('#userid').val(common.nvl(resultVO.userid, '')) ; 
			$('#usernm').val(common.nvl(resultVO.usernm, '')) ; 
			$('#deptnm').val(common.nvl(resultVO.deptnm, '')) ; 
			$('#retiredt').val(vRetireDate) ; 
			$('#retire_flag').val(vRetireFlag) ; 
			
		}
		
	}
	
	function initRetireForm(data){
		
		$('#listTbody').empty();
		
		var resultList = typeof data.resultList != 'undefined' ? data.resultList : null;
		var vo = typeof data.vo != 'undefined' ? data.vo : null; 
		
		$("input[name='cdCnt']").val( resultList.length );			 
		
		if(resultList != null && resultList.length > 0){
			var str = '' ;
			
			for(var i = 0 ; i < resultList.length ; i++){
				
				var datas = resultList[i];
				var num = i ; 
				str += '<tr> ' ;
				str += '	<td>'+(i+1)+'</td> ' ;		
				str += '	<td>'+common.nvl(datas.code_name , '')+'<input type="hidden" name="check_cd"  id="check_cd" value="'+common.nvl(datas.code , '')+'"></td> ' ; //체크리스트 항목 코드 hidden처리
				str += '	<td><input type="checkbox" title="반납체크" name="check_yn" id="check_yn" value="N" onchange="javascript:changeCheck(\''+num+'\');" /><input type="hidden" name="hidden_check_yn" id="hidden_check_yn" value="N" /></td> ' ;
				str += '	<td>'+'<input type="text" title="비고" name="note" id="note" onchange="javascript:changeNote(\''+num+'\');" />'+'</td> ' ;
				str += '	<td>'+'<input type="text" readonly="readonly" title="확인자" name="reg_nm" id="reg_nm"/><input type="hidden" title="확인자 사번" name="reg_id" id="reg_id"/>'+'</td> ' ;
				str += '	<td>'+'<input type="text" readonly="readonly" title="확인일자" name="reg_date" id="reg_date"/>'+'</td> ' ;
				
				str += '</tr> ' ;
				
			}
			$('#listTbody').append(str);
			
		}
		
		getRetireInfo();
		
	}
	
	function getRetireInfo(){
		
		var datas = {
				'emp_no' 				: '${ vo.userid }',
				'retire_date'			: '${ vo.retiredt }'
		}
		
		common.ajaxCall(datas , '/ad/retire/getRetireCheck.do', 'makeRetireCheck') ;
		
	}
	
	function makeRetireCheck(data){
		
		var cdCnt = $("input[name='cdCnt']").val();
		var cdSize = $("input[name = 'check_cd']").length ; 
		var checkCdArray = new Array(cdSize);
		
		var resultList = typeof data.resultList != 'undefined' ? data.resultList : null;
		var vo = typeof data.vo != 'undefined' ? data.vo : null; 
		var total = 0;
		
		if(resultList != null && resultList.length > 0){
			for(var i = 0 ; i < resultList.length ; i++){
				
				var datas = resultList[i];
				
				for(var j = 0 ; j<cdSize ; j++){
					checkCdArray[j] = $("input[name='check_cd']").eq(j).val() ;
					
					if(checkCdArray[j] == datas.check_cd){
						
						$("input[name='note']").eq(j).val(datas.note);
						$("input[name='reg_nm']").eq(j).val(datas.reg_nm);
						$("input[name='reg_id']").eq(j).val(datas.reg_id);
						$("input[name='reg_date']").eq(j).val(datas.reg_date);
						
						if(datas.check_yn == 'Y'){
							$("input[name='check_yn']").eq(j).prop('checked', true);
							$("input[name='check_yn']").eq(j).val('Y');
							$("input[name='hidden_check_yn']").eq(j).val('Y');
						}else{
							$("input[name='check_yn']").eq(j).prop('checked', false);
							$("input[name='check_yn']").eq(j).val('N');
							$("input[name='hidden_check_yn']").eq(j).val('N');
						}
					}
				}
			}
			
			//모든 개별 체크박스가 체크되어 있다면, 전체체크박스 체크하기
			for(var z = 0 ; z < cdCnt ; z++){
				
				if( $("input[name='check_yn']").eq(z).is(":checked") ){
					total += 1;
				}
				if(total == cdCnt){
					$('#checkall').prop('checked', true);
				}else{
					$('#checkall').prop('checked', false);
				}
				
			}
			
		}
		
		
	}
	
	function goSave(){
		
		var cdCnt = $("input[name='cdCnt']").val();
		var chkSum = 0;
		
		if(confirm('저장 하시겠습니까?')){
			
			var f = document.procFrm;	
			
			f.target = "hiddenFrame" ; 
			f.action = "/ad/retire/proc.do" ; 
			f.submit();
			
		}
		
	}
	
	function procReturn(gubun) {
		if(gubun == "success"){
			alert("정상적으로 처리 되었습니다.") ;
			goList() ; 
		}else{
			alert("처리도중 오류가 발생했습니다.") ; 
			return ; 
		}
	}
	
	function goList(type) {
		var f = document.procFrm;
		
		var flag = true;
		
		if (type == 'cancel') {
			if (confirm('수정된 내용을 저장 취소하시겠습니까?')) {
				flag = true;
			} else {
				flag = false;
			}
		}
		
		if (flag) {
			//alert( window.location.search.substring() ); 
			/*
			f.action = '/ad/retire/list.do';
			f.submit();			
			*/
			
			location.href = '/ad/retire/list.do${ QUERYSTRING }' ; 
		}

	}
	
	function changeNote(index){
		
		<%
		UserVO userInfo = session.getAttribute("adUserInfo") != null ?  (UserVO) session.getAttribute("adUserInfo") : null ;
		String reg_nm = userInfo.getEmp_nm() ;		
		%>
		
		//debugger;
		//var reg_id = <%= userInfo.getEmp_no() %>;
		var reg_id = '${adUserInfo.emp_no }';
		var reg_name = '${adUserInfo.emp_nm }';
		$("input[name='reg_nm']").eq(index).val(reg_name);
		$("input[name='reg_id']").eq(index).val(reg_id);
		$("input[name='reg_date']").eq(index).val('');
		
	}
	
	function changeCheck(index){
		
		var reg_name = '${adUserInfo.emp_nm }';
		var reg_id = '${adUserInfo.emp_no }';
		var cdCnt = $("input[name='cdCnt']").val();
		var total = 0;
		
		if( $("input[name='check_yn']").eq(index).is(":checked") ){
			$("input[name='reg_nm']").eq(index).val(reg_name);
			$("input[name='reg_id']").eq(index).val(reg_id);
			$("input[name='check_yn']").eq(index).val('Y');
			$("input[name='hidden_check_yn']").eq(index).val('Y');
			$("input[name='reg_date']").eq(index).val('');
			
			
		}else{
			$("input[name='note']").eq(index).val('');
			$("input[name='reg_nm']").eq(index).val('');
			$("input[name='reg_id']").eq(index).val('');
			$("input[name='reg_date']").eq(index).val('');
			$("input[name='check_yn']").eq(index).val('N');
			$("input[name='hidden_check_yn']").eq(index).val('N');
		}
		
		for(var z = 0 ; z < cdCnt ; z++){
			
			if( $("input[name='check_yn']").eq(z).is(":checked") ){
				total += 1;
			}
			if(total == cdCnt){
				$('#checkall').prop('checked', true);
			}else{
				$('#checkall').prop('checked', false);
			}
			
		}
		
	}
	
	function checkAllData(){
		var checked = $('#checkall').is(":checked");
		var index = $("input[name='cdCnt']").val();
		var reg_name = '${adUserInfo.emp_nm }';
		var reg_id = '${adUserInfo.emp_no }';
		
		for(var i = 0 ; i < index; i++){
			if(checked){
				if($("input[name='check_yn']").eq(i).is(":checked") ){			//이미 체크가 되어있었다면
					
				}else{
					$("input[name='check_yn']").eq(i).prop('checked', true);
					$("input[name='hidden_check_yn']").eq(i).val('Y');
					$("input[name='reg_nm']").eq(i).val(reg_name);
					$("input[name='reg_id']").eq(i).val(reg_id);
					$("input[name='reg_date']").eq(i).val('');
					
				}
				
			}else {
				$("input[name='check_yn']").eq(i).prop('checked',false);
				$("input[name='hidden_check_yn']").eq(i).val('N');
				$("input[name='note']").eq(i).val('');
				$("input[name='reg_nm']").eq(i).val('');
				$("input[name='reg_id']").eq(i).val('');
				$("input[name='reg_date']").eq(i).val('');
		 	}
		}    
	}
	
</script>
<form name="procFrm" id="procFrm" method="post" onsubmit="return false;">
	<input type="hidden" name="pageType" id="pageType" value=""/>
	<input type="hidden" name="page" id="page" value="${ vo.page }" />
	<input type="hidden" name="retireId" id="retireId" value="${ vo.userid }" />
	<input type="hidden" name="retireDate" id="retireDate" value="${ vo.retiredt }" />
	<input type="hidden" name="cdCnt" id="cdCnt" value="" />
	<input type="hidden" name="complete" id="complete" value="" />
	
	<div class="tit_wrap">
		<%= CommonExecute.returnLineMap(request) %>
	</div>
	
	<div class="tit_sWrap">
		<h3 class="tit_dot_gray floatL">퇴사자 정보</h3>
		<span class="tit_depth floatR mgt8" id="showHide1" style="display:none;">상세 보기</span>
	</div>
	
	<table class="sType mgb20" >
		<caption>퇴사자 정보</caption>
		<colgroup>
			<col style="width:140px;" />
			<col style="width:360px;" />
			<col style="width:140px;" />
			<col style="width:360px;" />
		</colgroup>
		<tr>
			<th scope="row">이름</th>
			<td>
				<input type="text" readonly="readonly" id="usernm" title="이름" value="" />
			</td>
			<th scope="row">사번</th>
			<td>
				<input type="text" readonly="readonly" id="userid" title="사번" value="" />
			</td>
		</tr>
		<tr>
			<th scope="row">기업명</th>
			<td>
				<input type="text" readonly="readonly" id="company_nm" title="기업명" value="" />
			</td>
			<th scope="row">팀명</th>
			<td>
				<input type="text" readonly="readonly" id="deptnm" title="팀명" value="" />
			</td>
		</tr>
		<tr>
			<th scope="row">퇴사일</th>
			<td>
				<input type="text" readonly="readonly" id="retiredt" title="퇴사일" value="" />
			</td>
			<th scope="row">퇴사 유형</th>
			<td>
				<input type="text" readonly="readonly" id="retire_flag" title="퇴사 유형" value="" />
			</td>
		</tr>
	</table>
	
	<div class="tit_sWrap">
		<h3 class="tit_dot_gray">체크리스트</h3>
	</div>
	
	<table class="hType mgb20">
		<caption>체크리스트</caption>
		<colgroup>
			<col style="width:80px;" />
			<col style="width:150px;" />
			<col style="width:140px;" />
			<col style="width:330px;" />
			<col style="width:140px;" />
			<col style="width:160px;" />
		</colgroup>
		<thead>
		<tr>
			<th scope="col">No</th>
			<th scope="col">확인내용</th>
			<th scope="col">체크
				<input type="checkbox" name="checkall" id="checkall" onchange="checkAllData()">
			</th>
			<th scope="col">비고</th>
			<th scope="col">확인자</th>
			<th scope="col">확인일</th>
		</tr>
		</thead>
		<tbody id="listTbody"></tbody>
	</table>
	<div class="btn_wrap">
		<div class="floatL">
			<button type="button" class="btn_ico_list" onclick="javascript:goList();"><span>목록</span></button>
		</div>
		<div class="floatR">
			<button type="button" class="btn_ico_confirm" onclick="javascript:goSave();"><span>저장</span></button>
			<button type="button" class="btn_ico_cancel" onclick="javascript:goList('cancel');"><span>취소</span></button>
		</div>
	</div>
</form>


<div class="layer_dimmed" style="display:none;" id="div_dim"></div>
