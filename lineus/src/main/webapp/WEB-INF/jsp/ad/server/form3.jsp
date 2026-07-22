<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="egovframework.com.comm.util.CommonExecute"%>



<script type="text/javascript">
	
	var paramString = "" ; 
	
	$(document).ready(function(){
		
		/**	공통 코드 처리		*/
		commonCode.getCodeList('APP' , 'AP01' , 'app_type') ; 			/**	APP_TYPE_NM 	*/
		commonCode.getCodeList('APP' , 'AP02' , 'lan_type') ; 		
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
		common.ajaxCall(datas , '/ad/server/getAppList.do' , 'setAppList') ;
		
	}
	
	/* APP 정보 셋팅 */
	function setAppList(data) {
		console.log(data);
		var str = "" ;
		var paging_src = "" ;
		var htmlWrap = $('#app_wrap');
		
		htmlWrap.empty();
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var vo = data.vo != "undefined" ? data.vo : null ;
		
		if(resultList != null && resultList.length > 0){
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = data.resultList[i];
				str += "<tr onclick=\"listDetail('update', '" + datas.seq + "' , '" + datas.cust_seq + "' , '" + datas.server_seq + "');\" style=\"cursor:pointer;\">" ;
				str += "	<td  onclick=\'event.cancelBubble=true;\'> <input type='checkbox' name='chk' value='"+datas.seq+"@'></td>" ;
				str += "	<td>" + datas.rnum + "</td>" ;
				str += "	<td>" + "<input type='text' value='" +common.nvl(datas.app_name , '-') + "' readonly='readonly'/>" + "</td>" ;
				str += "	<td>" + "<input type='text' value='" + common.nvl(datas.app_type_nm , '-') + "' readonly='readonly'/>" + "</td>" ;
				str += "	<td>" + "<input type='text' value='" + common.nvl(datas.lan_type_nm, '-') + "' readonly='readonly'/>" + "</td>" ;
				str += "	<td>" + "<input type='text' value='" + common.nvl(datas.development_tool, '-') + "' readonly='readonly'/>" + "</td>" ;
				/*str += "	<td>" + common.nvl(datas.management_tool, '-') + "</td>" ;*/
				/*str += "	<td>" + common.nvl(datas.management_addr, '-') + "</td>" ;*/
				str += "	<td>" + "<input type='text' value='" + common.nvl(datas.site_addr, '-') + "' readonly='readonly'/>" + "</td>" ;
				str += "	<td>" + "<input type='text' value='" + common.nvl(datas.site_id, '-')  + "' readonly='readonly'/>" + "</td>" ;
				/*str += "	<td>" + common.nvl(datas.site_pass, '-') + "</td>" ;*/
				str += "	<td>" + "<input type='text' value='" + common.nvl(datas.app_etc, '-') + "' readonly='readonly'/>" + "</td>" ;
				str += "</tr>" ;
				$('#count').html(vo.rowCnt) ; 
				htmlWrap.html(str);
				$("#pagination").html(vo.json_paging);
			}
		} else {
			$('#count').html('0') ; 
			commonTable.notData(12 , '등록된 데이터가 없습니다.' , 'appList') ; 
			$("#pagination").html('');
		} 
	}
	
	/*app 추가*/
	function addApp(){
		openAPPpop('insert');
	}
	
	/*app 삭제*/
	function delApp() {
		var del_app_seq = '';
		var app_seq = '';
		
		$("input[name=chk]:checked").each(function() {
			chkVal = $(this).val() ;
			app_seq = chkVal.split('@')[0];
			
			if (del_app_seq == '') del_app_seq = app_seq;
			else del_app_seq = del_app_seq + "@"+ app_seq;
			
		});
		
		if (common.nvl(del_app_seq,'') != '') {
			var delText = '선택된 APP정보를 삭제하시겠습니까?';
			
			if (confirm(delText)) {
				var datas = {
						'pageType' : 'delete',
						'del_app_seq' : del_app_seq,
						'server_seq' : '${vo.seq}',
						'cust_seq' : '${vo.cust_seq}'
				
						
				}
				common.ajaxCall(datas , '/ad/server/proc3.do', 'procReturn') ;
			}
		}
	}
	
	
	
	/*팝업닫기*/
	function closeAPPpop(){
		$('#app_popupLayer').hide();
	}	
	
	 function regAppInfo(){
		 
		var app_name = $('#app_name');
		var app_type = $('#app_type');
		var lan_type = $('#lan_type');
		var site_addr = $('#site_addr');
		var site_id = $('#site_id');
		var site_pass = $('site_pass');
		 
		if (app_name.val()=='') {
			alert('사용명칭을 입력하세요.');
			app_name.focus();
			return;
		}
		if (app_type.val()=='') {
			alert('어플리케이션 종류를 입력하세요.');
			app_type.focus();
			return;
		}
		if (lan_type.val()=='') {
			alert('대표 개발언어를 입력하세요.');
			lan_type.focus();
			return;
		}
		if (site_addr.val()=='') {
			alert('접속가능 주소를 입력하세요.');
			site_addr.focus();
			return;
		}
		if (site_id.val()=='') {
			alert('접속가능 아이디를 입력하세요.');
			site_id.focus();
			return;
		}
		if (site_pass.val()=='') {
			alert('접속가능 패스워드를 입력하세요.');
			site_pass.focus();
			return;
		}
		
		var f = document.app_popup;
		
		f.server_seq.value = '${vo.seq}';
		f.cust_seq.value = '${vo.cust_seq}';
		
		common.ajaxCall($('form[name=app_popup]').serialize() , '/ad/server/proc3.do' , 'procReturn') ;
	 }
	 
	function listDetail(payType,app_seq,cust_seq,server_seq){
		
		var datas = {
			'seq' : app_seq,
			'cust_seq' : cust_seq,
			'server_seq' : server_seq
			
		}
			common.ajaxCall(datas, '/ad/server/getAppInfo.do', 'setAppInfo');
	}
	
	function setAppInfo(data){
		
		document.app_popup.reset();
		var info = typeof data.info != "undefined" ? data.info : null ;
		
		$('#app_name').val( common.nvl(info.app_name , '-'));
		$('#app_type').val( common.nvl(info.app_type , '-'));
		$('#lan_type').val( common.nvl(info.lan_type, '-'));
		$('#development_tool').val( common.nvl(info.development_tool, '-'));
		$('#management_tool').val( common.nvl(info.management_tool, '-'));
		$('#management_addr').val( common.nvl(info.management_addr, '-'));
		$('#site_addr').val( common.nvl(info.site_addr, '-'));
		$('#site_id').val( common.nvl(info.site_id, '-'));
		$('#site_pass').val( common.nvl(info.site_pass, '-'));
		$('#app_etc').val( common.nvl(info.app_etc, '-'));
		$('#app_popup #seq').val( common.nvl(info.seq, '-')); /* DB SEQ */
	    $('#server_seq').val( common.nvl(info.server_seq, '-'));
	    $('#app_popup #cust_seq').val( common.nvl(info.cust_seq, '-'));
	    
		$("#app_popupLabel").html("APP정보 보기/수정");
		$('#app_popupLayer').show();
		$('#app_popup #pageType').val("update");
		
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
			closeAPPpop();
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
	function openAPPpop(type) {
		if(type=='insert') {
			document.app_popup.reset();
			$("#app_popupLabel").html("APP정보 등록");
			$('#app_popupLayer').show();
			$('#app_popup #pageType').val("insert");
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
	<li class="active"><a href="javascript:moveTab('3');">어플리케이션 정보</a></li><!-- 활성시 current -->
	<li><a href="javascript:moveTab('4');">서비스(서버용) 정보</a></li><!-- 활성시 current -->
	
</ul>
	
<form name="procFrm" method="post" onsubmit="return false;">
	<input type="hidden" name="server_seq"id="server_seq"   value="${vo.server_seq }"/>  <!-- 서버 seq -->
	<input type="hidden" name="pageType"  id="pageType" 	value="${vo.pageType}"/>
	<input type="hidden" name="erp_code"  id="erp_code" 	value="${vo.erp_code }"/>
	<input type="hidden" name="cust_seq"  id="cust_seq" 	value="${vo.cust_seq }"/>
<!-- write -->
<div class="tit_bWrap mgb10">
	<h4 style="display: inline-block;">APP 정보</h4>
	<span class="tit_depth mgl20">행을 클릭하여 상세 정보를 확인하세요.</span>
	<button class="btn_ico_circle_plus_g mgr5 floatR" onclick="addApp();"><span>APP추가</span></button>
	<button class="btn_ico_stop_g mgr5 floatR" onclick="delApp();"><span>APP삭제</span></button>
</div>
<div class="mgb20" style="overflow-x:auto;">
	<table class="hType mgb10" id="app_tb" style="width:1000px;">
		<caption>APP 목록</caption>
		<colgroup>
			<%-- <col style="width:40px" /> <!--선택 -->
			<col style="width:40px" /> <!--NO-->
			<col style="width:120px" /><!--사용명칭 -->
			<col style="width:100px" /><!--종류-->
			<col style="width:100px" /><!--대표언어 -->
			<col style="width:120px" /><!--개발툴-->
			<col style="width:120px" /><!--소스관리툴 -->
			<col style="width:100px" /><!--소스관리 주소 -->
			<col style="width:100px" /><!--운영 싸이트 -->
			<col style="width:100px" /><!--접속 ID -->
			<col style="width:100px" /><!--접속 pass -->
			<col style="width:100px" /><!--비고 --> --%>
			
			<col style="width:40px" /> <!--NO-->
			<col style="width:40px" /> <!--NO-->
			<col style="width:150px" /><!--사용명칭 -->
			<col style="width:120px" /><!--사용명칭 -->
			<col style="width:120px" /><!--사용명칭 -->
			<col style="width:120px" /><!--사용명칭 -->
			<col style="width:120px" /><!--사용명칭 -->
			<col style="width:100px" /><!--사용명칭 -->
			<col style="width:150px" /><!--사용명칭 -->
			
		</colgroup>
		<thead>
			<tr>
				<th scope="col">선택</th>
				<th scope="col">No</th>
				<th scope="col">사용명칭</th>
				<th scope="col">APP 종류</th>
				<th scope="col">대표 개발언어</th>
				<th scope="col">개발툴</th>
				<!--<th scope="col">소스 관리 툴</th>-->
				<!--<th scope="col">소스 관리 주소</th>-->
				<th scope="col">운영 싸이트</th>
				<th scope="col">접속가능 ID</th>
				<!--<th scope="col">접속가능 PASS</th>-->
				<th scope="col">비고</th>
			</tr>
		</thead>
		<tbody id="app_wrap">
			
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
<form name="app_popup" id="app_popup" method="post" onsubmit="return false;">
	<input type="hidden" name="seq" id="seq"  value=""/> <!-- APP seq -->
	<input type="hidden" name="pageType" id="pageType" value=""/>
	<input type="hidden" name="server_seq" id="server_seq"  value="${vo.server_seq}"/>
	<input type="hidden" name="cust_seq" id="cust_seq" value="${vo.cust_seq}"/>
	
	<div id="app_popupLayer" style="display: none;">
		<div class="box_layer layer_sms" style="height: 560px; width: 800px; margin-top: -350px;">
			<h1 id="app_popupLabel">APP정보 등록</h1>
			<div class="layer_contents" style="padding-top: 20px; height: auto;">
				<h3 class="tit_sWrap">어플리케이션 정보 내역</h3>
				<table class="sType mgb20">
					<caption>APP정보 등록</caption>
					<colgroup>
						<col style="width: 100px">
						<col style="width: 200px">
						<col style="width: 100px">
						<col style="width: 200px">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">사용명칭<span class="request">필수입력</span></th>
							<td colspan ="3"><input type="text" name="app_name" id="app_name" placeholder="APP사용명칭  ex) 프로젝트명 -별칭"></td>
						</tr>
						<tr>
							<th scope="row">어플리케이션 종류<span class="request">필수입력</span></th>
							<td><select name="app_type" id="app_type" title="어플리케이션 종류"></select></td>
							<th scope="row">대표 개발언어<span class="request">필수입력</span></th>
							<td><select name="lan_type" id="lan_type" title="대표 개발언어 "></select></td>
						</tr>
						<tr>
							<th scope="row">개발 툴</th>
							<td><input type="text" title="개발툴" name="development_tool" id="development_tool" placeholder="개발 툴"></td>
							<th scope="row">소스 관리 툴</th>
							<td><input type="text" id="management_tool" name ="management_tool" placeholder="소스관리 툴"></td>
						</tr>
						<tr>
							<th scope="row">소스관리 주소</th>
							<td colspan ="3"><input type="text" title="소스관리 주소" name="management_addr" id="management_addr" placeholder="소스관리 주소"></td>
						</tr>
						<tr>
							<th scope="row">운영 싸이트 주소<span class="request">필수입력</span></th>
							<td colspan="3" ><input type="text" id="site_addr" name ="site_addr" placeholder="운영 싸이트 주소"></td>
						</tr>
						<tr>
							<th scope="row">접속 가능 ID(싸이트)<span class="request">필수입력</span></th>
							<td><input type="text" title="싸이트 ID" name="site_id" id="site_id" placeholder="싸이트 접속 가능 ID"></td>
							<th scope="row">접속 가능 PASS(싸이트)<span class="request">필수입력</span></th>
							<td><input type="text" name="site_pass" id="site_pass" title="싸이트 접속 가능 PASS" placeholder="싸이트 접속 가능 PASS"/></td>
						</tr>
						<tr>
							<th scope="row">비고</th>
							<td colspan="3"><input type="text" name="app_etc" id="app_etc" title="비고" value="" class="mgr5""></td>
						</tr>
					</tbody>
				</table>
				<div class="btn_wrap mgt20">
					<div class="floatR">
						<button type="button" class="btn_ico_confirm mgr5" onclick="regAppInfo()">
							<span>저장</span>
						</button>
						<button type="button" class="btn_ico_cancel" onclick="javascript:closeAPPpop();">
							<span>취소</span>
						</button>
					</div>
				</div>
			</div>
			<button type="button" class="btn_close" onclick="javascript:closeAPPpop();">창 닫기</button>
		</div>
		<div class="layer_dimmed"></div>
	</div>
</form>







