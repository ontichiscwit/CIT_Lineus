<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="egovframework.com.comm.util.CommonExecute"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix = "fn"		uri = "http://java.sun.com/jsp/jstl/functions"%>
<%@page import="egovframework.com.comm.util.StringUtil"%>
<%@page import="egovframework.com.comm.util.DateTimeUtil"%>


<script type="text/javascript" src="/js/jw_system_hist.js"></script>


<script type="text/javascript">

	var i_cnt = 0;
	var crm_code_flag = false;
	var dc_cnt = 0;
	
	$(document).ready(function(){
		$( "#std_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		initView();
	});
	
	function initView() {
		var datas = {'cust_seq' : $('#seq').val()} ; 
		common.ajaxCall(datas , '/ad/cust/getDocInfo.do' , 'setDocInfo') ; 
	}
	
	
	function setDocInfo(datas){
		
		var info = typeof datas.resultVO != "undefined" ? datas.resultVO.resultList : null ; 
		if (info != null) {
				$('#issue_wrap').empty();

			for (var i=0; i < info.length; i++) {
				var map = info[i];
				
				// 접수일 날짜를 형식에 맞게 셋팅
				var stdDt = "-";   
				if (common.nvl(map.d_std_dt, '').length == 8){
					stdDt = makeDate(map.d_std_dt,"/");
				}
				var str = '';	
				str += '<tr>';
				str += '	<td><input type="checkbox" name="doccheck" id="i_seq'+(i+1)+'" value1="'+common.nvl(map.doc_seq, '')+'"  value2="'+common.nvl(map.file_seq, '')+'" value3="'+common.nvl(map.attach_ord, '')+'"    title="선택" />';
				str += '<input type="hidden" name="dtl_seq'+(i+1)+'" id="dtl_seq'+(i+1)+'" value="'+common.nvl(map.doc_seq, '')+'" /></td>';
				str += '	<td>'+common.nvl(map.d_doc_type,'-')+'</td>';
				str += '	<td>'+common.nvl(map.d_detail_type,'-')+'</td>';
				str += '	<td>'+stdDt+'</td>';
				str += '    <td>'+common.nvl(map.attach_ori_nm, '')+'</td>';
				str += '    <td>';
				str += '	<button type="button" class="btn_file_blue mgr5" onclick="javascript:fileDown(\''+common.nvl(map.file_seq, '')+'\' , \''+common.nvl(map.attach_ord, '')+'\');"><span>다운로드</span></button>';					
				str += ' 	</td>';
				str += '	<td class="textL">'+common.nvl(map.d_doc_comment,'-')+'</td>';
				str += '	<td>'+common.nvl(map.d_reg_date,'-')+'</td>';
				str += '	<td>'+common.nvl(map.reg_nm,'-')+'</td>';
				str += '</tr>';
				$('#issue_wrap').append(str);
					
			}
				
		} 
	}
	
	function goReset() {
		<c:choose>
			<c:when test="${ vo.pageType ne 'insert' }">initView();</c:when>
			<c:otherwise>document.procFrm.reset();</c:otherwise>
		</c:choose>
	}
	
	
	function moveTab(gubun){
		
		var queryString = '${ QUERYSTRING }' ;
		if(queryString != ''){
			var arr = queryString.split("&") ;
			var newQuery = '' ; 
			for(var i = 0 ; i < arr.length ; i++){
				var datas = arr[i] ; 
				
				var imsi = datas.split('=') ; 
				
				if(i == 0) imsi[0] = common.replaceAll(imsi[0], "?", "") ; 
				
				if(imsi[0] == 'seq'){
					imsi[1] = $('#seq').val() ; 
				}
				
				if(imsi[0] == 'pageType'){
					imsi[1] = 'update' ; 
				}
				
				if(imsi[0] == 'cust_kor_name'){
					imsi[1] = encodeURI($('#cust_kor_name').val()) ; 
				}
				
				if(imsi[0] == 'crm_code'){
					imsi[1] = $('#crm_code').val() ; 
				}
				
				if(newQuery == "") newQuery = "?" + imsi[0] + "=" +imsi[1] ; 
				else newQuery = newQuery + "&" + imsi[0] + "=" +imsi[1] ;
			}
		}else{
			newQuery = "?pageType=update&seq=" + $('#seq').val() + "&cust_kor_name=" + encodeURI($('#cust_kor_name').val()) + "&crm_code=" + $('#crm_code').val() ; 
		}
		
		if ($('#seq').val() == '') {
			alert('관리정보를 등록해 주세요.');
			return;
		} else  {
			if (newQuery.indexOf("erp_code") < 0){
				location.href = "/ad/cust/form" + gubun + ".do" + newQuery + "&erp_code=" + $('#erp_code').val()
			}else{
				location.href = "/ad/cust/form" + gubun + ".do" + newQuery;
			}
		}
	}
	
	//레이어팝업 오픈
	function openDocAddLayer(){
		document.procFrm.reset();
		$('#addDocTbBody').empty();
		addDocRow();
		$('#addDocLayer').show();
		
	}
	
	//레이어팝업 닫기
	function closeAddDocLayer(){
		
		$('#addDocLayer').hide();
		document.procFrm.reset();
		//$('#addDocTbBody').empty();
		dc_cnt = 0;  
		initView();
		
	}
	
	function showDtcode(obj){
		var le = obj.getAttribute('data-set');
		le = 'detail_type' + le ;
		commonCode.getCodeList('CUST' , obj.value , le) ;
	}
	
	//행추가
	function addDocRow(){
		dc_cnt++;
		var str ='';
		str += '<tr id=tr-'+dc_cnt+' data-set='+dc_cnt+'>';
		str += '<td><select class="doc_type" id=doc_type'+dc_cnt+' data-set= '+dc_cnt+'  name=doc_type'+dc_cnt+' title="문서분류" onchange="showDtcode(this)">' + '</select></td>';
		str += '<td><select class="detail_type" id=detail_type'+dc_cnt+'  name=detail_type'+dc_cnt+' title="상세분류"><option>선택</option></select></td>';
		str += '<td><input type="text"  id=std_dt'+dc_cnt+' name=std_dt'+dc_cnt+' title="기준일입력" style="width:82%" class="mgr5"></td>';
		str += '<td><input type="file" id=uploadFile_'+dc_cnt+' name=uploadFile_'+dc_cnt+' class="uploadFile"></td>';
		str += '<td><input type="text" id=doc_comment'+dc_cnt+' name=doc_comment'+dc_cnt+' title="비고입력" class=""></td>';
		str += '<td><button class="btn_line_gray"  onclick="delRow(this);">행삭제</button></td>';
		str += '</tr>';
		$('#addDocTbBody').append(str);
		var target = 'doc_type' + dc_cnt ;
		commonCode.getCodeList('CUST' , 'CD44' , target) ;
		$('#std_dt'+dc_cnt).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
	}
	
	function delRow(obj){
		//문서등록 팝업 - 행삭제
		$(obj).parent().parent('tr').remove();
			
	}
	
	
	function delFileData(){
		//데이터 삭제
		var del_cnt = $('#issue_wrap input:checked').length;
		
		if( del_cnt == 0 ){ alert("삭제할 데이터를 선택해 주세요."); return; }
		if (!confirm(del_cnt + '개의 문서를 삭제하시겠습니까?')) return;
		
		if ($('input:checkbox[name="doccheck"]').is(":checked")){
			var datas = {};
			var i = 0;
			$('#issue_wrap input:checked').each(function() {
				datas['doc_seq' + i] = $(this).attr('value1');
				datas['file_seq' + i] = $(this).attr('value2');
				datas['attach_ord' + i] = $(this).attr('value3');
				i++;
			});
			datas['del_cnt'] = del_cnt;
		}
		common.ajaxCall(datas , '/ad/cust/docDel.do', 'delprocReturn') ;
	}
	
	
	
	function delprocReturn(data) {
		var returnCode = typeof data.returnCode != "undefined" ? data.returnCode : "002" ; 
		var seq = typeof data.seq != "undefined" ? data.seq : "" ; 
		var message = typeof data.message != "undefined" ? data.message : "" ; 
		var msg = "" ; 
		
		if(returnCode == "000") msg = "정상적으로 처리 되었습니다." ; 
		else if(returnCode == "001") msg = message ; 
		else if(returnCode == "002") msg = "처리도중 오류가 발생했습니다." ;
		
		alert(msg) ; 
		initView();
	}
	
	function goSave(){
		
		var le = $('#addDocTbBody tr').length;
		if (!confirm( le + '의 문서를 등록하시겠습니까?')) return;
		var arr =[];
		for(var i = 1 ; i <= le ; i++ ){
			var a =$('#addDocTbBody tr:nth-child('+i+')').attr('data-set');
			arr.push(a);
		}
		
		for(var i = 0 ; i < arr.length ; i++ ){
			var cnt = arr[i];
			
			if($('#doc_type'+ cnt).val() == null || $('#doc_type'+ cnt).val() == '' ){alert('문서분류를 등록해 주세요.'); $('#doc_type'+ cnt).focus(); return}
			if($('#detail_type'+ cnt).val() == null || $('#detail_type'+ cnt).val() == '' ){alert('상세분류를 등록해 주세요.'); $('#detail_type'+ cnt).focus() ; return}
			if($('#uploadFile_'+ cnt).val() == null || $('#uploadFile_'+ cnt).val() == '' ){alert('파일을 등록해 주세요.');$('#uploadFile_'+ cnt).focus() ;return}
		}
		
		var f = document.procFrm;
		f.dc_cnt.value = dc_cnt ;
		f.cust_seq.value = ${vo.seq} ;
		f.method="post";
		f.target ='hiddenFrame';
		f.action = '/ad/cust/proc6.do' ; 
		f.submit() ;  
		
	}
	
	function procReturn(gubun) {
		if(gubun == "success"){
			alert("정상적으로 처리 되었습니다.") ;
			closeAddDocLayer() ; 
		}else{
			alert("처리도중 오류가 발생했습니다.") ; 
			return ; 
		}
	}
	
	
</script>
<div class="tit_wrap">
	<h2 class="tit_ico_customer">거래처 관리<span class="tit_depth mgl20 mgt8">관리문서정보</span></h2>
</div>
<div class="tit_sWrap">
	<h3 class="tit_dot_gray">거래처 상세 정보<c:if test="${ vo.pageType ne 'insert' }">&nbsp;&lt;<span class="colorBlue mg15" style="line-height:25px;">${ vo.cust_kor_name }, ${ vo.erp_code }</span>&gt;</c:if></h3>
</div>
<!-- tab -->
<ul class="tab_line list3 mgb20">
	<li><a href="javascript:moveTab('');">관리 정보</a></li><!-- 활성시 current -->
	<li><a href="javascript:moveTab('5');">계약 이력</a></li>
	<li class="active"><a href="javascript:moveTab('6');">문서 관리</a></li>
</ul>

<input type="hidden" name="pageType" id="pageType" value="${vo.pageType}"/>
<input type="hidden" name="seq" id="seq" value="${vo.seq}" />
<input type="hidden" name="del_dtl_seq" id="del_dtl_seq" value="" />
<input type="hidden" name="dc_cnt" id="dc_cnt" />
<input type="hidden" name=cust_kor_name id="cust_kor_name" value="${vo.cust_kor_name}" />
<input type="hidden" name="crm_code" id="crm_code" value="${vo.crm_code}" />


<!-- write -->

<!-- list -->
<div class="tit_bWrap mgb10">
	<h4 class="floatL mgt8">관리문서 내역</h4>
	<span class="floatR">
		<button class="btn_ico_circle_plus_g mgr5" onclick="openDocAddLayer();"><span>문서등록</span></button>
		<button class="btn_ico_stop_g" onclick="delFileData();"><span>문서삭제</span></button>
	</span>
</div>
<table class="hType mgb20">
	<caption>이슈관리 목록</caption>
	<colgroup>
		<col style="width:35px" />
		<col style="width:80px" />
		<col style="width:80px" />
		<col style="width:70px" /> <!--기준일 -->
		<col style="width:200px" /> <!--문서명 -->
		<col style="width:70px" />
		<col style="width:100px" /><!--  -->
		<col style="width:75px" />
		<col style="width:50px" />
	</colgroup>
	<thead>
		<tr>
			<th scope="col">선택</th>
			<th scope="col">문서분류</th>
			<th scope="col">상세분류</th>
			<th scope="col">기준일</th>
			<th colspan='2' scope="col">문서명</th>
			
			<th scope="col">비고</th>
			<th scope="col">등록일</th>			
			<th scope="col">등록자</th>
		</tr>
	</thead>
	<tbody id="issue_wrap">
		
	</tbody>
</table>
<!--// list -->



<!-- docAddLayer 레이어팝업 -->
<form name="procFrm" id="procFrm"  method="post" enctype="multipart/form-data" onsubmit="return false;">
<input type="hidden" name="dc_cnt" id="dc_cnt" />
<input type="hidden" name=cust_seq id="cust_seq" />

<div id="addDocLayer" style="display: none;" >
	<div class="box_layer layer_sms" style="height: 540px; width: 1000px; margin-top: -300px; margin-left:-500px;">
		<h1 >문서등록</h1>
		<div class="layer_contents" style="padding-top: 20px; overflow-y:visible;">
			<div class="tit_bWrap mgb10">
				<h4 class="floatL mgt8">관리문서 등록</h4>
				<span class="floatR">
					<button class="btn_ico_circle_plus_g mgr5" onclick="addDocRow();"><span>행추가</span></button>
				</span>
			</div>
			<table class="hType mgb10" style="overflow-y:auto;max-height:500px">
				<caption>Document Management</caption>
				<colgroup>
					<col style="width: 75px">
					<col style="width: 75px">
					<col style="width: 110px">
					<col style="width: 200px">
					<col style="width: 130px">
					<col style="width: 50px">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">문서분류<span class="request mgl5">필수 입력</span></th>
						<th scope="col">상세분류<span class="request mgl5">필수 입력</span></th>
						<th scope="col">기준일</th>
						<th scope="col">파일선택<span class="request mgl5">필수 입력</span></th>
						<th scope="col">비고</th>
						<th scope="col">삭제</th>
					</tr>
				</thead>
				<tbody  id="addDocTbBody">
				</tbody>
			</table>
			<div class="btn_wrap mgt20">
				<div class="floatR">
					<button type="button" class="btn_ico_confirm" onclick="javascript:goSave();"><span>저장</span></button>
				    <button type="button" class="btn_ico_cancel" onclick="javascript:closeAddDocLayer();"><span>창 닫기</span></button>
				</div>
			</div>
		</div>
		<button type="button" class="btn_close" onclick="javascript:closeAddDocLayer();">창 닫기</button>
	</div>
	<div class="layer_dimmed"></div>
</div>
</form>
<!--레이어  -->
