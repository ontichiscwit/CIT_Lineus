<%@page import="egovframework.com.comm.util.CommonExecute"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javascript" src="/js/jquery.mtz.monthpicker.js"></script>
<script type="text/javascript">
	
	$(document).ready(function(){
		commonCode.getPcodeList('AS' , 'search_as_type');
		commonCode.getCodeList('AS' , 'CD03' , 'search_code_type') ;
		getApprovalList('1');
	});
	
	
	function getApprovalList(page){
		var datas = {
				'page' : page , 
				'search_text' : $('#cust_name').val(),
				'search_type1' : $('#search_as_type').val(),
				'search_type2' : $('#search_code_type').val()
		}
		
		common.ajaxCall(datas , '/ad/approval/getApprovalList.do', 'makeApprovalList') ;
	}
	
	function makeApprovalList(data){
		var str = "" ;
		var htmlWrap = $('#approvalList');
		htmlWrap.empty();
		
		$('#count').html('0') ;
		$("#pagination").html('');
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var vo = data.vo != "undefined" ? data.vo : null ;
		
		if(resultList != null && resultList.length > 0){
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = data.resultList[i];
				str += "<tr>" ;
				str += "	<td>" + datas.RNUM + "</td>" ;
				str += "	<td>" + common.nvl(datas.CUST_KOR_NAME , '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.CUST_CODE , '-') + "</td>" ;
				
				str += "	<td>" + common.nvl(datas.P_CODE_NM, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.CODE_NM, '-') + "</td>" ;
				if(datas.AS_APPROVAL_YN == "C001"){str += "	<td>" + "Y" + "</td>" ;
				}else{str += "	<td>" + "N" + "</td>" ;}
				str += "	<td>" + "Y" + "</td>" ;
				str += "	<td>" + common.nvl(datas.REG_ID, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.REG_DATE, '-') + "</td>" ;
				str += "	<td onclick='javascript:delApproval("+datas.SEQ+")' style='cursor:pointer'>" + "[삭제]" + "</td>" ;
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
	
	
	var col_cnt = 0;
	/* ADD */
	function addCol() {
		
		if( $('#cust_code').val() == '' ){alert('거래처를 조회하세요'); return;}
		var str = '';
		col_cnt++;
		str += '<tr id="tr'+col_cnt+'" >';
		str += '<td><input type="checkbox" id="check'+col_cnt+'" class="col_check" cnt="'+col_cnt+'" ></td>'; /* 체크박스  */
		str += '<td><select class="as_type" name="as_type'+col_cnt+'" id="as_type'+col_cnt+'" cnt="'+col_cnt+'"></select></td>';
		str += '<td><select class="code_type" name="code_type'+col_cnt+'" id="code_type'+col_cnt+'" cnt="'+col_cnt+'"></select></td>';
		str += '<td></td>';
		str += '</tr>';
		$('#approval_add_wrap').append(str);
		commonCode.getPcodeList('AS' , 'as_type'+col_cnt);
		commonCode.getCodeList('AS' , 'CD03' , 'code_type'+col_cnt) ;
		
	}
	function delApproval(data){
		
		if(data != null){var result = confirm("본건을 삭제 하시겠습니까?");}
		if(result){
			var datas = {'seq': data};
			common.ajaxCall(datas , '/ad/approval/delApproval.do', 'procReturn') ;
	    }else{
			return;
	    }
	}
	
	function delCol() {
		if ($('#approval_add_wrap input[type=checkbox]:checked').length == 0) { 
			alert('삭제할 행을 선택하세요.');
			return;
		}
		$('#approval_add_wrap input[type=checkbox]:checked').each(function(){
			$(this).parent().parent('tr').remove();
			col_cnt = col_cnt -1;
		});
	}
	
	
	/**	거래처 조회	*/
	function showLayer(){
		$('#div1').show() ;
		$('#div1').css('height' , '710') ; 
		$('#div_dim').show() ; 
		$('#searchKorName').val($('#cust_nm').val());
		custList(1) ; 
		$('#searchKorName').attr( 'autofocus','autofocus');
		$('[autofocus]:not(:focus)').eq(0).focus();
	}
	
	function custList(custPage){
		var datas = {
				'page' : custPage , 
				'search_text' : $('#searchKorName').val() 
		}
		
		common.ajaxCall(datas , '/ad/approval/getCustList.do', 'makeCustList') ;
	}
	
	function makeCustList(data){
		$('#custInfoList').empty() ; 
		$('#layer_pagination').empty() ; 
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var vo = typeof data.vo != "undefined" ? data.vo : null ; 
		
		if(resultList != null && resultList.length > 0){
			var str = '' ; 
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ;
				str += '<tr onclick="javascript:setValue(\''+common.nvl(datas.seq, '')+'\');" style="cursor:pointer;"> ' ;
				str += '	<td>'+common.nvl(datas.rnum , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.cust_kor_name , '')+'['+common.nvl(datas.erp_code , '')+']</td> ' ;
				str += '	<td>'+common.nvl(datas.ceo , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.cust_no , '')+ '</td> ' ;
				str += '	<td>'+common.nvl(datas.cust_address , '')+'</td> ' ;
				str += '</tr> ' ;
			}
			$('#custInfoList').append(str) ; 
			$('#layer_pagination').html(vo.json_paging) ; 
		}else{
			commonTable.notData(5 , '조회된 정보가 없습니다.' , 'custInfoList') ; 
		}
	}
	
	function setValue(seq){
		var datas = {'seq' 				: seq }
		common.ajaxCall(datas , '/ad/member/getCustInfo.do', 'makeCustInfo') ;
		closeLayer() ; 
	}
	
	function makeCustInfo(data){
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null ; 
		console.log(resultVO);
		$('#cust_code').val(common.nvl(resultVO.erp_code, '')) ; 
		$('#cust_name').val(common.nvl(resultVO.cust_kor_name, '')) ;
	}
	
	function closeLayer() {
		$('#div1').hide() ; 
		$('#div_dim').hide() ; 
		$('#searchKorName').val('') ; 
		$("#searchKorName").removeAttr( "autofocus" );
	}
	
	var returnVali = true;
	function proCol(){
		
	   var returnVali = true;
	   $('#approval_add_wrap tr').each(function(){
			var as_type = $(this).find('.as_type');
			var code_type = $(this).find('.code_type');
			if(as_type.val() == ""){alert('A/S유형을 선택하세요.'); as_type.focus;returnVali =false; return;}
			else if(code_type.val() == ""){alert('코드명을 선택하세요.'); code_type.focus; returnVali =false;return;}
			
		});
		if(returnVali == false){ return;}
		var f = document.progRegistForm;
		f.group_addCnt.value = $('#approval_add_wrap tr').length;
		common.ajaxCall($('form[name=progRegistForm]').serialize() , '/ad/approval/proApproval.do' , 'procReturn') ;  
	} 
	
	function procReturn(data){
		if(data.returnCode ="000"){alert('정상 처리 되었습니다.');
			getApprovalList('1');
		}else{
			alert('처리도중 오류가 발생했습니다.');
		}	
	}
	
</script>

<div class="tit_wrap">
	<%= CommonExecute.returnLineMap(request) %>
</div>
<form name="progRegistForm" method="post" onsubmit="return false;">
<input type="hidden" id="group_addCnt" name="group_addCnt"></input>
<div class="tit_bWrap mgb10">
	<h4 class="floatL mgt8">승인 등록 정보</h4>
	<span class="floatR">
		<button class="btn_ico_circle_plus_g mgr5" onclick="addCol();"><span>행추가</span></button>
		<button class="btn_ico_stop_g" onclick="delCol();"><span>행삭제</span></button>
		<button class="btn_ico_stop_g" onclick="proCol();"><span>권한등록</span></button>
	</span>
</div>
<table class="sType mgb10">
	<caption>승인 권한 등록</caption>
	<colgroup>
		<col style="width:100px">
		<col style="width:200px">
		<col style="width:100px">
		<col style="width:*">
    </colgroup>
	<tbody>
		<tr>
			<th>거래처</th>
			<td colspan="3">
				<input type="text" name="cust_name" id="cust_name" class="w200" placeholder="거래처이름"/>
				<input type="text" name="cust_code" id="cust_code" class="w150" placeholder="거래처코드" readonly="readonly"/>
				<button type="button" class="btn_line_gray w75" onclick="javascript:showLayer();">거래처조회</button>
			</td>
		</tr>
	</tbody>
</table>

<!--write -->
<div class="mgb20" style="overflow-x:auto;">
	<table class="hType mgb10" id="approval_add_tb" style="width:1000px;">
		<caption>승인 등록 정보</caption>
		<colgroup>
			<col style="width:50px" /><!--사용용도-->
			<col style="width:150px" /><!--사용명칭-->
			<col style="width:150px" /><!--사용명칭-->
			<col style="width:auto" /><!--사용명칭-->
		</colgroup>
		<thead>
			<tr>
				<th scope="col">선택</th>
				<th scope="col">A/S유형</th>
				<th scope="col">코드명</th>
				<th scope="col"></th>
			</tr>
		</thead>
		<tbody id="approval_add_wrap">
			
		</tbody>
	</table>
	
	<div class="tit_bWrap mgb10">
		<h4 class="floatL mgt8">승인  정보</h4>
	</div>
	
	<table class="sType mgb10">
		<caption>승인 정보 조회</caption>
		<colgroup>
			<col style="width:100px">
			<col style="width:250px">
			<col style="width:100px">
			<col style="width:*">
	    </colgroup>
		<tbody>
			<tr>
				<th>거래처명</th>
				<td>
					<input type="text" name="cust_name" id="cust_name" class="w200" placeholder="거래처이름or코드"/>
				</td>
				<th>유형</th>
				<td>
					<select name="search_as_type" id="search_as_type" class="w150"></select>
					<select name="search_code_type" id="search_code_type" class="w150"></select>
					<button type="button" class="btn_line_gray w75" onclick="javascript:getApprovalList(1);">검색</button>
				</td>
			</tr>
		</tbody>
	</table>
	
	<table class="hType mgb10" id="approval_tb" style="width:1000px;">
		<caption>승인 정보</caption>
		<colgroup>
			<col style="width:50px" /><!--사용용도-->
			<col style="width:150px" /><!--거래처명-->
			<col style="width:150px" /><!--거래처코드-->
			<col style="width:auto" /><!--사용명칭-->
		</colgroup>
		<thead>
			<tr>
				<th scope="col">no</th>
				<th scope="col">거래처명</th>
				<th scope="col">거래처코드</th>
				<th scope="col">A/S유형</th>
				<th scope="col">코드명</th>
				<th scope="col">거래처 승인프로세스 여부</th>
				<th scope="col">코드별 승인프로세스 여부</th>
				<th scope="col">등록자</th>
				<th scope="col">등록일</th>
				<th scope="col">삭제</th>
			</tr>
		</thead>
		<tbody id="approvalList">
			
		</tbody>
	</table>
	<div class="page">
		<div id="pagination"></div>
	</div>
</div>
</form>
<!-- write -->
<div class="box_layer layer_sms" style="margin-top:-300px;display:none;" id="div1">
<h1>거래처 정보 조회 검색 결과</h1>
<div class="layer_contents pdt20" style="height:657px;">
	기관명:
	<input type="text" class="w175 mgr10" id="searchKorName" name="searchKorName" title="거래처 정보 검색">
	<button type="button" class="btn_ico_search mgr5" onclick="javascript:custList(1);"><span>검색</span></button>
	<table class="vType_line" style="margin-top: 10px">
		<caption>거래처 정보 목록</caption>
		<colgroup>
			<col style="width:50px;" />
			<col style="width:150px;" />
			<col style="width:80px;" />
			<col style="width:120px;" />
			<col style="width:auto;" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">No</th>
				<th scope="col">기관명</th>
				<th scope="col">대표자</th>
				<th scope="col">사업자등록번호</th>
				<th scope="col">주소</th>
			</tr>
		</thead>
		<tbody id="custInfoList"></tbody>
	</table>
	<div class="page" id="layer_pagination" style="margin-top: 10px;"></div>
</div>
<button type="button" class="btn_close" onclick="javascript:closeLayer();">창 닫기</button>
</div>
<div class="layer_dimmed" style="display:none;" id="div_dim"></div>


