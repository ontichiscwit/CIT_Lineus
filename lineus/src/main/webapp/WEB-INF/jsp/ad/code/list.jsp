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
	
	$(document).ready(function(){
		init() ; 
	}) ;
	
	function init(){
		getCodeGroupSort();
		
		//getCodeGroup() ; 
	}
	
	
	function getCodeGroupSort(){
		common.ajaxCall(null , '/ad/code/getCodeGroupSort.do' , 'setCodeGroupSort') ;
		
	}
	
	function setCodeGroupSort(data){
		var data = typeof data.resultList != "undefined" ? data.resultList : null;   
		if(data == null) return;
		var str = "";
		var hasASValue = false;
		for(var i = 0 ; i < data.length ; i++){
			if (data[i].code_group == "AS") {
				hasASValue = true;
			}
			str += '<option value="'+data[i].code_group+'">' + data[i].code_group + '</option>';
		}
		
		$('#code_group').html(str);
		
		if (hasASValue) {
			$("#code_group").val("AS");
		}
		
		getCodeGroup();
	}
	
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
						str += '<tr id="groupTr'+num+'" onclick="javascript:goCodeDetail(\''+common.nvl(datas.p_code , '')+' \' , \''+common.nvl(datas.code_group, '')+'\');" style="cursor:pointer;" >' ;
						
						str += '	<td>';
						str += ' 		<input type="checkbox" title="선택" id="chk_Mst_'+ num +'" name="chk_'+ num +'" value="" />'	;
						str += '	</td>';
						
						str += '	<td>';
						str += '		<input type="text" name="p_code_group_'+num+'" id="p_code_group_'+num+'" readonly="readonly" title="코드그룹" value="'+common.nvl(datas.code_group,'')+'" class="w100" maxlength="4"/>';
						str += '	</td>';
						
						str += '	<td>';
						str += '		<input type="text" name="p_code_'+num+'" id="p_code_'+num+'" readonly="readonly" title="부모코드" value="'+common.nvl(datas.p_code,'')+'" class="w100" maxlength="4"/>';
						str += '	</td>';
						
						str += '	<td>';
						str += '		<input type="text" name="p_code_name_'+num+'" id="p_code_name_'+num+'"  title="부모코드명" value="'+common.nvl(datas.p_code_name,'')+'" class="w250" maxlength="500"/>';
						str += '	</td>';
						
						str += '	<td >';
						str += ' 		<input type="checkbox" title="선택" name="use_yn_'+ num + '"' + (common.nvl(datas.use_yn , '') == "Y" ? "checked" : "") + '/>'	;
						str += '	</td>';
						
						
						str += '</tr>' ;
						
						group_addCnt = num ; 
					}
					
					$('#table1Tbody').append( str ) ; 
					
					var data_mst_row_0 = resultList[0];
					goCodeDetail(common.nvl(data_mst_row_0.p_code , '') , common.nvl(data_mst_row_0.code_group , '') );
				}else{
					commonTable.notData(4 , '조회된 데이터가 없습니다.' , 'table1Tbody') ; 
				}
				
			}
		}) ; 
	}
	
	
	
	
	function addCodeGroup(){
		
		group_addCnt = group_addCnt + 1 ; 
		
		var arrayDelMst = [];
		$(document).ready(function() {
			  $('#table1Tbody tr').each(function() {
				  arrayDelMst.push(this.id.substring(7));
			  })
		});
		
		var maxNum = 0;
		if(arrayDelMst.length != 0){
			maxNum = Math.max.apply(Math, arrayDelMst);
		}
		var num = maxNum + 1 ; 
		
		
		var str = '<tr id="groupTr'+num+'" onclick="javascript:goClearCodeDetail();" style="cursor:pointer;" >' ;
				
		str += '	<td>';
		str += ' 		<input type="checkbox" title="선택" name="chk_'+ num +'" id="chk_Mst_'+ num +'"/>'	;
		str += '	</td>';
		
		str += '	<td>';
		str += '		<input type="text" name="p_code_group_'+num+'" id="p_code_group_'+num+'" readonly="readonly"  title="코드그룹"  class="w100 mgr2" maxlength="4"/>';
		str += '	</td>';
		
		str += '	<td>';
		str += '		<input type="text" name="p_code_'+num+'" id="p_code_'+num+'" title="부모코드"  class="w100 mgr2" maxlength="4"/>';
		str += '	</td>';
		
		str += '	<td>';
		str += '		<input type="text" name="p_code_name_'+num+'" id="p_code_name_'+num+'" title="부모코드명" class="w250 mgr2" maxlength="500"/>';
		str += '	</td>';
		
		str += '	<td >';
		str += ' 		<input type="checkbox" title="선택" name="use_yn_'+ num + '" />'	;
		str += '	</td>';
		
		str += '</tr>' ;
		
		$('#table1Tbody').append( str ) ; 
	}
	
	function goClearCodeDetail() {
		$('#p_code').val("") ; 
		$('#p_group_code').val("") ; 
		$('#table2Tbody').empty();
	}
	
	
	function goCodeDetail(p_code , p_group_code){
		$('#table2Tbody').empty() ; 
		
		del_code = "" ; 
		code_addCnt = 0 ;
		
		$('#p_code').val(p_code) ; 
		$('#p_group_code').val(p_group_code) ; 
		
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
						str += ' 		<input type="checkbox" title="선택" id="chk_Dtl_'+ num +'" name="chk_'+ num +'" value="'+common.nvl(datas.use_yn, '')+'"/>'	;
						str += '	</td>';	
						
						str += '	<td>';
						str += '		<input type="text" name="p_code_'+num+'" id="p_code_'+num+'" readonly="readonly" title="부모코드" value="'+common.nvl(datas.p_code,'')+'" maxlength="4"/>';
						str += '	</td>';
						
						str += '	<td>';
						str += '		<input type="text" name="code_'+num+'" id="code_'+num+'" readonly="readonly" title="부모코드" value="'+common.nvl(datas.code,'')+'" class="" maxlength="4"/>';
						str += '	</td>';
						
						str += '	<td>';
						str += '		<input type="text" name="code_name_'+num+'" id="code_name_'+num+'" title="부모코드명" value="'+common.nvl(datas.code_name,'')+'" class="" maxlength="500"/>';
						str += '	</td>';
						
						str += '	<td>';
						str += '		<input type="text" name="val1_'+num+'" id="p_code_'+num+'"  title="val1" value="'+common.nvl(datas.val1,'')+'" class="" maxlength="100"/>';
						str += '	</td>';
						
						str += '	<td>';
						str += '		<input type="text" name="val2_'+num+'" id="val2_'+num+'"  title="val2" value="'+common.nvl(datas.val2,'')+'" class="" maxlength="100"/>';
						str += '	</td>';
						
						str += '	<td>';
						str += '		<input type="text" name="val3_'+num+'" id="val3_'+num+'"  title="val3" value="'+common.nvl(datas.val3,'')+'" class="" maxlength="100"/>';
						str += '	</td>';
						
						str += '	<td>';
						str += '		<input type="text" name="val4_'+num+'" id="val4_'+num+'"  title="val4" value="'+common.nvl(datas.val4,'')+'" class="" maxlength="100"/>';
						str += '	</td>';
						
						str += '	<td>';
						str += '		<input type="text" name="val5_'+num+'" id="val5_'+num+'" title="val5" value="'+common.nvl(datas.val5,'')+'" class="" maxlength="100"/>';
						str += '	</td>';
						
						str += '	<td>';
						str += '		<input type="text" name="val6_'+num+'" id="val6_'+num+'" title="val6" value="'+common.nvl(datas.val6,'')+'" class="" maxlength="100"/>';
						str += '	</td>';
						
						str += '	<td>';
						str += '		<input type="text" name="val7_'+num+'" id="val7_'+num+'" title="val7" value="'+common.nvl(datas.val7,'')+'" class="" maxlength="100"/>';
						str += '	</td>';
						
						str += '	<td>';
						str += '		<input type="text" name="val8_'+num+'" id="val8_'+num+'" title="val8" value="'+common.nvl(datas.val8,'')+'" class="" maxlength="100"/>';
						str += '	</td>';
						
						str += '	<td>';
						str += '		<input type="text" name="val9_'+num+'" id="val9_'+num+'" title="val9" value="'+common.nvl(datas.val9,'')+'" class="" maxlength="100"/>';
						str += '	</td>';
						
						str += '	<td>';
						str += '		<input type="text" name="val10_'+num+'" id="val10_'+num+'" title="val10" value="'+common.nvl(datas.val10,'')+'" class="" maxlength="100"/>';
						str += '	</td>';
						
						str += '	<td>';
						str += '		<input type="number" name="sort_ord_'+num+'" id="sort_ord_'+num+'" title="정렬순서" value="'+common.nvl(datas.sort_ord,'')+'" class=""  min="1" max="10000"/>';
						str += '	</td>';
						
						
						str += '	<td >';
						str += ' 		<input type="checkbox" title="선택" name="use_yn_dtl_'+ num + '"' + (common.nvl(datas.use_yn_dtl , '') == "Y" ? "checked" : ""	) + '/>'	;
						str += '	</td>';
						
						
						str += '</tr>' ;
						
						code_addCnt = num ; 
					}
					
					$('#table2Tbody').append( str ) ; 
					
				}else{
					commonTable.notData(15 , '조회된 데이터가 없습니다.' , 'table2Tbody') ; 
				}
			}
		}) ; 
	}
	
	
	
	function addCode(){
		if($('#p_code').val() == '' ) {
			alert("코드 그룹 먼저 저장해 주세요.")
			return ; 
		}
		
		code_addCnt = code_addCnt + 1 ; 
		
		if(code_addCnt == "1") $('#table2Tbody').empty() ; 
		
		//create array of row index current
		var arrayDelDtl = [];
		$(document).ready(function() {
			  $('#table2Tbody tr').each(function() {
				  arrayDelDtl.push(this.id.substring(6));
			  })
		});
		
		var maxNum = 0;
		//get max row index current
		if(arrayDelDtl.length != 0){
			maxNum = Math.max.apply(Math, arrayDelDtl);
		}
			
		
		var num = maxNum + 1 ; 
		var p_code = $('#p_code').val();
		var str = '<tr id="codeTr'+num+'">' ;
		
		str += '	<td>';
		str += ' 		<input type="checkbox" title="선택" name="chk_'+ num +'" id="chk_Dtl_'+ num +'"/>'	;
		str += '	</td>';	
		
		str += '	<td>';
		str += ' 		<input type="text" title="부모코드" name="p_code_'+ num +'" id="p_code_'+ num +'" readonly="readonly" value="'+common.nvl(p_code,'')+'"/>'	;
		str += '	</td>';	
		
		str += '	<td>';
		str += '		<input type="text" name="code_'+num+'" id="code_'+num+'" title="부모코드"  maxlength="4"/>';
		str += '	</td>';
		
		str += '	<td>';
		str += '		<input type="text" name="code_name_'+num+'" id="code_name_'+num+'" title="부모코드명" maxlength="500"/>';
		str += '	</td>';
		
		str += '	<td>';
		str += '		<input type="text" name="val1_'+num+'" id="val1_'+num+'"  title="val1" maxlength="100"/>';
		str += '	</td>';
		
		str += '	<td>';
		str += '		<input type="text" name="val2_'+num+'" id="val2_'+num+'" title="val2" maxlength="100"/>';
		str += '	</td>';
		
		str += '	<td>';
		str += '		<input type="text" name="val3_'+num+'" id="val3_'+num+'" title="val3" maxlength="100"/>';
		str += '	</td>';
		
		str += '	<td>';
		str += '		<input type="text" name="val4_'+num+'" id="val4_'+num+'" title="val4" maxlength="100"/>';
		str += '	</td>';
		
		str += '	<td>';
		str += '		<input type="text" name="val5_'+num+'" id="val5_'+num+'" title="val5"maxlength="100"/>';
		str += '	</td>';
		
		str += '	<td>';
		str += '		<input type="text" name="val6_'+num+'" id="val6_'+num+'" title="val6" maxlength="100"/>';
		str += '	</td>';
		
		str += '	<td>';
		str += '		<input type="text" name="val7_'+num+'" id="val7_'+num+'" title="val7"maxlength="100"/>';
		str += '	</td>';
		
		str += '	<td>';
		str += '		<input type="text" name="val8_'+num+'" id="val8_'+num+'" title="val8" maxlength="100"/>';
		str += '	</td>';
		
		str += '	<td>';
		str += '		<input type="text" name="val9_'+num+'" id="val9_'+num+'" title="val9" maxlength="100"/>';
		str += '	</td>';
		
		str += '	<td>';
		str += '		<input type="text" name="val10_'+num+'" id="val10_'+num+'" title="val10" maxlength="100"/>';
		str += '	</td>';
		
		str += '	<td>';
		str += '		<input type="number" name="sort_ord_'+num+'" id="sort_ord_'+num+'"  title="정렬순서"  min="1" max="10000"/>';
		str += '	</td>';
		
		
		str += '	<td >';
		str += ' 		<input type="checkbox" title="선택" name="use_yn_dtl_'+ num + '"/>'	;
		str += '	</td>';
		
		/* str += '	<td>';
		str += '		<button type="button" onclick="javascript:delCode('+num+');">삭제</button>';
		str += '		<input type="hidden" name="code_listType_'+num+'" id="code_listType_'+num+'" value="i" />';
		str += '	</td>';
		 */
		str += '</tr>' ;
		
		$('#table2Tbody').append( str ) ; 
		
	}
	
	function goDel() {
		var f = document.listFrm;
		var cntMst = group_addCnt
		var arrayDelMst = [];
		var delMstCnt = 0;
		var delDtlCnt = 0;
		//create array index of row
		$(document).ready(function() {
			  $('#table1Tbody tr').each(function() {
				  arrayDelMst.push(this.id.substring(7));
			  })
		});
		for(var i = 0 ; i <= arrayDelMst.length ; i++){
			if($('#chk_Mst_' + arrayDelMst[i]).is(":checked")){
				if (common.isEmpty($('#p_code_' + arrayDelMst[i]).val()) || common.isEmpty($('#p_code_group_' + arrayDelMst[i]).val())){
					$('#groupTr' + arrayDelMst[i]).remove() ;
					delMstCnt++;
				}
				else {
					if(del_p_code == "") del_p_code = $('#p_code_' + arrayDelMst[i]).val() ; 
		 			else del_p_code = del_p_code + "@" + $('#p_code_' + arrayDelMst[i]).val() ;
					
					
				}
			}
		}
		
		var cntDtl = code_addCnt;
		var arrayDelDtl = [];
		$(document).ready(function() {
			  $('#table2Tbody tr').each(function() {
				  arrayDelDtl.push(this.id.substring(6));
			  })
		});
		
		for(var i = 0 ; i <= arrayDelDtl.length ; i++){
			if($('#chk_Dtl_' + arrayDelDtl[i]).is(":checked")){
				if (common.isEmpty($('#code_' + arrayDelDtl[i]).val()) || common.isEmpty($('#code_name_' + arrayDelDtl[i]).val())){
					$('#codeTr' + arrayDelDtl[i]).remove() ;
					delDtlCnt++;
				}
				else {
					if(del_code == "") del_code = $('#code_' + arrayDelDtl[i]).val() ; 
		 			else del_code = del_code + "@" + $('#code_' + arrayDelDtl[i]).val() ;
					
					
				}
			}
		}
		
		f.del_p_code.value = del_p_code ; 
		f.del_code.value = del_code ; 
		
		if(del_p_code != "" || del_code != ""){
			$.ajax({
				type : 'post' ,
				url : '/ad/code/del.do' , 
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
		} else if (delMstCnt == 0 && delDtlCnt == 0) {
			alert("작업할 자료를 선택해 주세요.");
		}
		
	}
	
// 	function delCode(idx){
// 		if($('#code_listType_' + idx).val() == "u"){
// 			if(del_code == "") del_code = $('#code_' + idx).val() ; 
// 			else del_code = del_code + "@" + $('#code_' + idx).val() ;
// 		}
		
// 		$('#codeTr' + idx).remove() ;
		
// 	}

	
	
	function goSave(){
		
		var f = document.listFrm ; 
		
		if(group_addCnt != 0){
			for(var i = 1 ; i <= group_addCnt ; i++ ){
				if(typeof $('#p_code_' + i).val() != "undefined"){
					
					if(common.isEmpty(common.replaceAll($('#p_code_' + i).val() , ' ' , ''))){
						alert("부모코드 작성해 주세요.");
						$('#p_code_' + i).focus();
						return ; 
					}
					if(common.isEmpty(common.replaceAll($('#p_code_name_' + i).val() , ' ' , ''))){
						alert("부모코드명 작성해 주세요.");
						$('#p_code_name_' + i).focus();
						return ; 
					}
				
					
					for(var j = 1 ; j <= group_addCnt ; j++){
						
						if(i != j){
							if(typeof $('#p_code_' + j).val() != "undefined"){
								if($('#p_code_' + i).val() == $('#p_code_' + j).val()){
									alert("그룹코드가 중복 됩니다.") ; 
									$('#p_code_' + j).focus();
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
						if(common.isEmpty(common.replaceAll($('#code_' + i).val() , ' ' , ''))){
							alert("상세코드를 작성해 주세요.");
							$('#code_' + i).focus();
							return ; 
						}
						if(common.isEmpty(common.replaceAll($('#code_name_' + i).val() , ' ' , ''))){
							alert("상세 코드명을 작성해 주세요.");
							$('#code_name_' + i).focus();
							return ; 
						}
					
					for(var j = 1 ; j <= code_addCnt ; j++){
						if(i != j){
							if(typeof $('#code_' + j).val() != "undefined"){
								if($('#code_' + i).val() == $('#code_' + j).val()){
									alert("상세코드가 중복 됩니다.") ; 
									$('#code_' + j).focus();
									return ; 
								}
							}
						}
						
					}					
				}
			}
		}
		
		
		f.group_addCnt.value = group_addCnt ; 
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
<input type="hidden" name="p_group_code" id="p_group_code" value=""/>
<input type="hidden" name="del_p_code" id="del_p_code" value=""/>
<input type="hidden" name="group_addCnt" id="group_addCnt" value=""/>
<input type="hidden" name="del_code" id="del_code" value=""/>
<input type="hidden" name="code_addCnt" id="code_addCnt" value=""/>

<div class="tit_wrap" style="">
	<%= CommonExecute.returnLineMap(request) %>
</div>
<!-- write -->
<div class="tit_bWrap mgb10">
	<select name="code_group" id="code_group" onchange="getCodeGroup();">
		
	</select>
</div>
<div style="float: left;">
	<div class="tit_sWrap">
		<h3 class="tit_dot_gray">코드 그룹 </h3>
	</div>

	<div class="mgt-10 mgb10 textR">
		<button type="button" class="btn_add" onclick="javascript:addCodeGroup();"><span>추가</span></button>
	</div>
	<table class="hType mgb20">
		<caption>코드 그룹 내역</caption>
		<colgroup>
			<col style="width:20px">
			<col style="width:50px">
			<col style="width:50px">
			<col style="width:100px">
			<col style="width:20px">
			<!-- <col style="width:100px"> -->
		</colgroup>
		<thead>
			<tr>
				<th scope="col">선택</th>
				<th scope="col">코드그룹</th>
				<th scope="col">부모코드</th>
				<th scope="col">부모코드명</th>
				<th scope="col">사용유무</th>
				<!-- <th scope="col">삭제</th> -->
			</tr>
		</thead>
		
		<tbody id="table1Tbody"></tbody>
	</table>
</div>


<div style="float: left;">
	<div class="tit_sWrap">
		<h3 class="tit_dot_gray">코드 상세</h3>
	</div>

	<div class="mgt-10 mgb10 textR">
		<button type="button" class="btn_add" onclick="javascript:addCode();"><span>추가</span></button>
	</div>

	<table class="hType mgb20" >
		<caption>코드 상세 내역</caption>
		<colgroup>
			<col style="width:50px">
			<col style="width:50px">
			<col style="width:70px">
			<col style="width:120px">
			<col style="width:70px">
			<col style="width:70px">
			<col style="width:70px">
			<col style="width:50px">
			<col style="width:50px">
			<col style="width:50px">
			<col style="width:50px">
			<col style="width:50px">
			<col style="width:50px">
			<col style="width:50px">
			<col style="width:50px">
			<col style="width:100px">
		</colgroup>
		<thead>
			<tr>
				<th scope="col">선택</th>
				<th scope="col">부모코드</th>
				<th scope="col">코드</th>
				<th scope="col">코드명</th>
				<th scope="col">참고1</th>
				<th scope="col">참고2</th>
				<th scope="col">참고3</th>
				<th scope="col">참고4</th>
				<th scope="col">참고5</th>
				<th scope="col">참고6</th>
				<th scope="col">참고7</th>
				<th scope="col">참고8</th>
				<th scope="col">참고9</th>
				<th scope="col">참고10</th>
				<th scope="col">정렬순서</th>
				<th scope="col">사용유무</th>
			</tr>
		</thead>
		<tbody id="table2Tbody"></tbody>
	</table>
</div>

<!--// write -->
<div class="btn_wrap">
	<div class="floatR">
		<button type="button" class="btn_ico_confirm" onclick="javascript:goSave();"><span>저장</span></button>
		<!-- 
		<button type="button" class="btn_ico_delete dgray" onclick="goDel();"><span>삭제</span></button>
		-->
	</div>
</div>
</form>