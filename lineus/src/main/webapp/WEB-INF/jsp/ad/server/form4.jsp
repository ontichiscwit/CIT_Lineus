<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="egovframework.com.comm.util.CommonExecute"%>



<script type="text/javascript">
	
	var paramString = "" ; 
	
	$(document).ready(function(){
		
		$( "#end_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#str_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		
		/**	공통 코드 처리		*/
		commonCode.getCodeList('SERVICE' , 'SV01' , 'service_type') ; 			/**	SERVICE_TYPE 	*/
		
		paramString = location.href.indexOf('?') != -1 ? location.href.substring(location.href.indexOf('?') + 1 , location.href.length) : "" ; 
		
		if (common.nvl('${vo.seq}', '') == '') {
			alert('서버정보를 등록해 주세요.');
			location.href = '/ad/server/form.do';
			return;
		}
		
		initView();
		
	});
	
	/* init */
	function initView() {
		
		var datas = {'server_seq' : $('#server_seq').val(),'cust_seq' : $('#cust_seq').val()} ;
		common.ajaxCall(datas , '/ad/server/getServiceList.do' , 'setServiceList') ;
		
	}
	
	/* Service 정보 셋팅 */
	function setServiceList(data) {
		console.log(data);
		var str = "" ;
		var paging_src = "" ;
		var htmlWrap = $('#service_wrap');
		
		htmlWrap.empty();
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var vo = data.vo != "undefined" ? data.vo : null ;
		
		if(resultList != null && resultList.length > 0){
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = data.resultList[i];
				str += "<tr onclick=\"listDetail('update', '" + datas.seq + "' , '" + datas.cust_seq + "' , '" + datas.server_seq + "');\" style=\"cursor:pointer;\">" ;
				str += "	<td  onclick=\'event.cancelBubble=true;\'> <input type='checkbox' name='chk' value='"+datas.seq+"@'></td>" ;
				str += "	<td>" + datas.rnum + "</td>" ;
				str += "	<td>" + common.nvl(datas.service_name , '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.app_type_nm , '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.lan_type_nm, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.development_tool, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.management_tool, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.management_addr, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.site_addr, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.site_id, '-')+ "</td>" ;
				str += "	<td>" + common.nvl(datas.site_pass, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.str_dt, '-') + "</td>" ;
				str += "	<td>" + common.nvl(datas.end_dt, '-') + "</td>" ;
				str += "</tr>" ;
				$('#count').html(vo.rowCnt) ; 
				htmlWrap.html(str);
				$("#pagination").html(vo.json_paging);
			}
		} else {
			$('#count').html('0') ; 
			commonTable.notData(12 , '등록된 데이터가 없습니다.' , 'serviceList') ; 
			$("#pagination").html('');
		} 
	}
	
	/*service 추가*/
	function addService(){
		openServicepop('insert');
	}
	
	/*service 삭제*/
	function delService() {
		var del_service_seq = '';
		var service_seq = '';
		
		$("input[name=chk]:checked").each(function() {
			chkVal = $(this).val() ;
			service_seq = chkVal.split('@')[0];
			
			if (del_service_seq == '') del_service_seq = service_seq;
			else del_service_seq = del_service_seq + "@"+ service_seq;
			
		});
		
		if (common.nvl(del_service_seq,'') != '') {
			var delText = '선택된 Service정보를 삭제하시겠습니까?';
			
			if (confirm(delText)) {
				var datas = {
						'pageType' : 'delete',
						'del_service_seq' : del_service_seq,
						'server_seq' : '${vo.seq}',
						'cust_seq' : '${vo.cust_seq}'
				
						
				}
				common.ajaxCall(datas , '/ad/server/proc4.do', 'procReturn') ;
			}
		}
	}
	
	
	
	/*팝업닫기*/
	function closeServicepop(){
		$('#service_popupLayer').hide();
	}	
	
	 function regServiceInfo(){
		var f = document.service_popup;
		
		f.server_seq.value = '${vo.seq}';
		f.cust_seq.value = '${vo.cust_seq}';
		
		common.ajaxCall($('form[name=service_popup]').serialize() , '/ad/server/proc4.do' , 'procReturn') ;
	 }
	 
	function listDetail(payType,service_seq,cust_seq,server_seq){
		
		var datas = {
			'seq' : service_seq,
			'cust_seq' : cust_seq,
			'server_seq' : server_seq
			
		}
			common.ajaxCall(datas, '/ad/server/getServiceInfo.do', 'setServiceInfo');
	}
	
	function setServiceInfo(data){
		
		document.service_popup.reset();
		var info = typeof data.info != "undefined" ? data.info : null ;
		
		$('#service_name').val( common.nvl(info.service_name , ''));
		$('#service_type').val( common.nvl(info.service_type , ''));
		$('#development_tool').val( common.nvl(info.development_tool, ''));
		$('#management_tool').val( common.nvl(info.management_tool, ''));
		$('#management_addr').val( common.nvl(info.management_addr, ''));
		$('#site_addr').val( common.nvl(info.site_addr, ''));
		$('#site_id').val( common.nvl(info.site_id, ''));
		$('#site_pass').val( common.nvl(info.site_pass, ''));
		$('#service_etc').val( common.nvl(info.service_etc, ''));
		$('#account_etc').val( common.nvl(info.account_etc, ''));
		$('#end_dt').val(  makeDate( common.nvl(info.end_dt, '')));
		$('#srt_dt').val(  makeDate(common.nvl(info.srt_dt, '')));
		
		
		$('#service_popup #seq').val( common.nvl(info.seq, '')); /* service SEQ */
	    $('#server_seq').val( common.nvl(info.server_seq, ''));
	    $('#service_popup #cust_seq').val( common.nvl(info.cust_seq, ''));
	    
		$("#service_popupLabel").html("Service정보 보기/수정");
		$('#service_popupLayer').show();
		$('#service_popup #pageType').val("update");
		
	}
	
	function procReturn(data){
		
		var returnCode = typeof data.returnCode != "undefined" ? data.returnCode : "002" ; 
		var msg = "" ; 
		
		if(returnCode == "000") msg = "정상적으로 처리 되었습니다." ; 
		else if(returnCode == "001") msg = "비정상적으로 처리 되었습니다." ; 
		else if(returnCode == "002") msg = "처리도중 오류가 발생했습니다." ;
		
		alert(msg) ; 
		if(returnCode == "000") {
			initView();
			closeServicepop();
		}
	}
	
	function moveTab(gubun){
		if ($('#server_seq').val() == '' && gubun != '1') {
			alert('서버 정보를 등록해 주세요.');
			return;
		}
		location.href = "/ad/server/form" + gubun + ".do${ QUERYSTRING }" ;
	}
	
	function goList() {
		var f = document.procFrm;
		f.action = '/ad/server/list.do' + window.location.search.substring();
		f.submit();	
	}
	
	
	// 오픈팝업
	function openServicepop(type) {
		if(type=='insert') {
			document.service_popup.reset();
			$("#service_popupLabel").html("Service정보 등록");
			$('#service_popupLayer').show();
			$('#service_popup #pageType').val("insert");
		}
	}
	
	
	
	
	
</script>

<div class="tit_wrap">
	<%-- <%= CommonExecute.returnLineMap(request) %> --%>
	<h2 class="tit_ico_customer">거래처 관리<span class="tit_depth mgl20 mgt8">서버정보</span></h2>
</div>
<div class="tit_sWrap">
	<h3 class="tit_dot_gray">서버 상세 정보<c:if test="${ vo.pageType ne 'insert' }">&nbsp;&lt;<span class="colorBlue mg15" style="line-height:25px;">${ vo.cust_kor_name }, ${ vo.erp_code }</span>&gt;</c:if></h3>
</div>
<!-- tab -->
<ul class="tab_line list4 mgb20">
	<li><a href="javascript:moveTab('');">서버 정보</a></li><!-- 활성시 current -->
	<li><a href="javascript:moveTab('2');">DB 정보</a></li><!-- 활성시 current -->
	<li><a href="javascript:moveTab('3');">어플리케이션 정보</a></li><!-- 활성시 current -->
	<li class="active"><a href="javascript:moveTab('4');">서비스(서버용) 정보</a></li><!-- 활성시 current -->
	
</ul>
	
<form name="procFrm" method="post" onsubmit="return false;">
	<input type="hidden" name="server_seq"id="server_seq" 	value="${ vo.server_seq }"/>  <!-- 서버 seq -->
	<input type="hidden" name="pageType"  id="pageType" 	value="${vo.pageType}"/>
	<input type="hidden" name="erp_code"  id="erp_code" 	value="${ vo.erp_code }"/>
	<input type="hidden" name="cust_seq"  id="cust_seq" 	value="${ vo.cust_seq }"/>
<!-- write -->
<div class="tit_bWrap mgb10">
	<h4 style="display: inline-block;">서비스 정보</h4>
	<button class="btn_ico_circle_plus_g mgr5 floatR" onclick="addService();"><span>서비스 추가</span></button>
	<button class="btn_ico_stop_g mgr5 floatR" onclick="delService();"><span>서비스 삭제</span></button>
</div>
<div class="mgb20" style="overflow-x:auto;">
	<table class="hType mgb10" id="service_tb">
		<caption>서비스 목록</caption>
		<colgroup>
			<col style="width:40px" /> <!--선택 -->
			<col style="width:40px" /> <!--NO-->
			<col style="width:120px" /><!--구분 -->
			<col style="width:100px" /><!--용도-->
			<col style="width:100px" /><!--IP -->
			<col style="width:120px" /><!--경로-->
			<col style="width:120px" /><!--계정 -->
			<col style="width:120px" /><!--암호 -->
			<col style="width:100px" /><!--계정설명 -->
			<col style="width:150px" /><!--시작일 -->
			<col style="width:150px" /><!--종료/만료일 -->
			<col style="width:250px" /><!--비고 -->
		</colgroup>
		<thead>
			<tr>
				<th scope="col">선택</th>
				<th scope="col">No</th>
				<th scope="col">구분</th>
				<th scope="col">용도</th>
				<th scope="col">IP(PORT)</th>
				<th scope="col">경로</th>
				<th scope="col">계정</th>
				<th scope="col">암호</th>
				<th scope="col">계정설명</th>
				<th scope="col">시작일</th>
				<th scope="col">종료/만료일</th>
				<th scope="col">비고</th>
			</tr>
		</thead>
		<tbody id="service_wrap">
			<tr>
			</tr>
		</tbody>
	</table>
</div>
 
<!--// list -->
<div class="page">
	<div class="btn_left">
		<button type="button" class="btn_ico_list" onclick="goList();"><span>목록</span></button>
	</div>
	<div id="pagination"></div>
</div>
</form>



<!-- 레이어팝업 -->
<form name="service_popup" id="service_popup" method="post" onsubmit="return false;">
	<input type="hidden" name="seq" id="seq"  value=""/> <!-- service seq -->
	<input type="hidden" name="pageType" id="pageType" value=""/>
	<input type="hidden" name="server_seq" id="server_seq"  value="${vo.server_seq}"/>
	<input type="hidden" name="cust_seq" id="cust_seq" value="${vo.cust_seq}"/>
	
	<div id="service_popupLayer" style="display: none;">
		<div class="box_layer layer_sms" style="height: 560px; width: 800px; margin-top: -350px;">
			<h1 id="service_popupLabel">서비스 정보 등록</h1>
			<div class="layer_contents" style="padding-top: 20px; height: auto;">
				<h3 class="tit_sWrap">서비스 정보 내역</h3>
				<table class="sType mgb20">
					<caption>서비스 정보 등록</caption>
					<colgroup>
						<col style="width: 100px">
						<col style="width: 200px">
						<col style="width: 100px">
						<col style="width: 200px">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">사용명칭</th>
							<td colspan ="3"><input type="text" name="service_name" id="service_name" placeholder="서비스 사용명칭 "></td>
						</tr>
						<tr>
							<th scope="row">사용구분</th>
							<td><select name="service_type" id="service_type" title="사용구분"></select></td>
							<th scope="row">IP</th>
							<td><input TYPE="text" name="service_ip" id="service_ip" title="IP " placeholder="IP"/></td>
						</tr>
						<tr>
							<th scope="row" >접속경로</th>
							<td colspan ="3" ><input type="text" title="" name="service_route" id="service_route" placeholder="접속경로"></td>
						</tr>
						<tr>
							<th scope="row">아이디</th>
							<td><input type="text" title="service_id" name="service_id" id="service_id" placeholder="ID"></td>
							<th scope="row">비밀번호</th>
							<td><input type="text" name="service_pass" id="service_pass" title="PASS" placeholder="PASS"/></td>
						</tr>
						<tr>
							<th scope="row">계정설명</th>
							<td colspan="3"><input type="text" name="account_etc" id="account_etc" title="계정설명" value="" class="mgr5"  placeholder="계정설명"></td>
						</tr>
						<tr>
							<th scope="row">시작일</th>
							<td><input type="text" name="str_dt" id="str_dt" title="시작일" value="" class="mgr5" placeholder="시작일"></td>
							<th scope="row">종료일(만료일)</th>
							<td><input type="text" name="end_dt" id="end_dt" title="종료일" value="" class="mgr5" placeholder="종료일"></td>
						</tr>
						<tr>
							<th scope="row">비고</th>
							<td colspan="3"><input type="text" name="service_etc" id="service_etc" title="비고" value="" class="mgr5" placeholder="비고"></td>
						</tr>
					</tbody>
				</table>
				<div class="btn_wrap mgt20">
					<div class="floatR">
						<button type="button" class="btn_ico_confirm mgr5" onclick="regServiceInfo()">
							<span>저장</span>
						</button>
						<button type="button" class="btn_ico_cancel" onclick="javascript:closeServicepop();">
							<span>취소</span>
						</button>
					</div>
				</div>
			</div>
			<button type="button" class="btn_close" onclick="javascript:closeServicepop();">창 닫기</button>
		</div>
		<div class="layer_dimmed"></div>
	</div>
</form>







