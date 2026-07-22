<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="egovframework.com.comm.util.CommonExecute"%>



<script type="text/javascript">
	
	var paramString = "" ; 
	
	$(document).ready(function(){
		
		/**	공통 코드 처리		*/
		commonCode.getCodeList('SERVER' , 'SV03' , 'dbms_type') ; 			/**	DB 타입	*/
		commonCode.getCodeList('DB' , 'DB01' , 'archive_mode') ; 		
		commonCode.getCodeList('DB' , 'DB02' , 'backup') ; 		
		$("#db_popupLayer #backup_dt").val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
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
		
		var datas = {'server_seq' : $('#seq').val(),'cust_seq' : $('#cust_seq').val()} ;
		common.ajaxCall(datas , '/ad/server/getDbList.do' , 'setDbList') ;
		
	}
	
	/* DB 정보 셋팅 */
	function setDbList(data) {
		var str = "" ;
		var paging_src = "" ;
		var htmlWrap = $('#db_wrap');
		
		htmlWrap.empty();
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var vo = data.vo != "undefined" ? data.vo : null ;
		
		if(resultList != null && resultList.length > 0){
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = data.resultList[i];
				str += "<tr onclick=\"listDetail('update', '" + datas.seq + "' , '" + datas.cust_seq + "' , '" + datas.server_seq + "');\" style=\"cursor:pointer;\">" ;
				str += "	<td  onclick=\'event.cancelBubble=true;\'> <input type='checkbox' name='chk' value='"+datas.seq+"@'></td>" ;
				str += "	<td>" + datas.rnum + "</td>" ;
				str += "	<td>" + "<input type='text' value='" + common.nvl(datas.db_name , '-') + "' readonly='readonly'/>" + "</td>" ;
				str += "	<td>" + "<input type='text' value='" + common.nvl(datas.dbms_type_nm , '-') + "' readonly='readonly'/>"+ "</td>" ;
				/* str += "	<td>" + common.nvl(datas.dbms_version_nm, '-') + "</td>" ;*/
				str += "	<td>" + "<input type='text' value='" + common.nvl(datas.db_host, '-') + "' readonly='readonly'/>"+ "</td>" ;
				/*str += "	<td>" + common.nvl(datas.port, '-') + "</td>" ;*/
				/*str += "	<td>" + common.nvl(datas.sid, '-') + "</td>" ;*/
				str += "	<td>" + "<input type='text' value='" + common.nvl(datas.service_name, '-') + "' readonly='readonly'/>"+ "</td>" ;
				str += "	<td>" + "<input type='text' value='" + common.nvl(datas.db_user_name, '-') + "' readonly='readonly'/>"+ "</td>" ;
				/*str += "	<td>" + common.nvl(datas.db_user_pass, '-') + "</td>" ;*/
				/*str += "	<td>" + common.nvl(datas.db_link, '-') + "</td>" ;*/
				/*str += "	<td>" + common.nvl(datas.archive_mode_nm, '-') + "</td>" ;*/
				/*str += "	<td>" + common.nvl(datas.backup_nm, '-') + "</td>" ;*/
				/*str += "	<td>" + makeDate(common.nvl(datas.backup_dt, '-')) + "</td>" ;*/
				str += "	<td>" + "<input type='text' value='" + common.nvl(datas.db_etc, '-') + "' readonly='readonly'/>"+ "</td>" ;
				str += "</tr>" ;
				$('#count').html(vo.rowCnt) ; 
				htmlWrap.html(str);
				$("#pagination").html(vo.json_paging);
			}
		} else {
			$('#count').html('0') ; 
			commonTable.notData(15 , '등록된 데이터가 없습니다.' , 'dbList') ; 
			$("#pagination").html('');
		} 
	}
	
	/*DB 추가*/
	function addDB(){
		openDBpop('insert');
	}
	
	/*DB 삭제*/
	function delDB() {
		var del_db_seq = '';
		var db_seq = '';
		
		$("input[name=chk]:checked").each(function() {
			chkVal = $(this).val() ;
			db_seq = chkVal.split('@')[0];
			
			if (del_db_seq == '') del_db_seq = db_seq;
			else del_db_seq = del_db_seq + "@"+ db_seq;
			
		});
		
		if (common.nvl(del_db_seq,'') != '') {
			var delText = '선택된 DB정보를 삭제하시겠습니까?';
			
			if (confirm(delText)) {
				var datas = {
						'pageType' : 'delete',
						'del_db_seq' : del_db_seq,
						'server_seq' : '${vo.seq}',
						'cust_seq' : '${vo.cust_seq}'
				
						
				}
				common.ajaxCall(datas , '/ad/server/proc2.do', 'procReturn') ;
			}
		}
	}
	
	
	
	/*팝업닫기*/
	function closeDBpop(){
		$('#db_popupLayer').hide();
	}	
	
	 function regDbInfo(){
		 
		 var db_name = $('#db_popupLayer #db_name');
		 var host = $('#db_popupLayer #db_host');
		 var port = $('#db_popupLayer #db_port');
		 var service_name = $('#db_popupLayer #service_name');
		 var user_name = $('#db_popupLayer #db_user_name');
		 var pass = $('#db_popupLayer #db_user_pass');
		 
		if (db_name.val()=='') {
				alert('사용명칭을 입력하세요.');
				db_name.focus();
				return;
		}
		
		if (host.val()=='') {
				alert('host를 입력하세요.');
				host.focus();
				return;
		}
		
		if (port.val()=='') {
			alert('port를 입력하세요.');
			port.focus();
			return;
		}
		
		if (service_name.val()=='') {
				alert('서비스명을 입력하세요.');
				service_name.focus();
				return;
		}
		
		if (user_name.val()=='') {
			alert('user name 입력하세요.');
			user_name.focus();
			return;
		}
		 
		if (pass.val()=='') {
			alert('패스워드를 입력하세요.');
			pass.focus();
			return;
		} 
		 
		 
		 
		 
		 var f = document.db_popup;
		
		f.server_seq.value = '${vo.seq}';
		f.cust_seq.value = '${vo.cust_seq}';
		
		common.ajaxCall($('form[name=db_popup]').serialize() , '/ad/server/proc2.do' , 'procReturn') ;
	 }
	 
	function listDetail(payType,db_seq,cust_seq,server_seq){
		
		var datas = {
			'seq' : db_seq,
			'cust_seq' : cust_seq,
			'server_seq' : server_seq
			
		}
			common.ajaxCall(datas, '/ad/server/getDbInfo.do', 'setDbInfo');
	}
	
	function setDbInfo(data){
		
		document.db_popup.reset();
		var info = typeof data.info != "undefined" ? data.info : null ;
		
		$('#db_name').val( common.nvl(info.db_name , '-'));
		$('#dbms_type').val( common.nvl(info.dbms_type , '-'));
		$('#dbms_version_nm').val( common.nvl(info.dbms_version_nm, '-'));
		$('#db_host').val( common.nvl(info.db_host, '-'));
		$('#db_port').val( common.nvl(info.db_port, '-'));
		$('#db_sid').val( common.nvl(info.db_sid, '-'));
		$('#service_name').val( common.nvl(info.service_name, '-'));
		$('#db_user_name').val( common.nvl(info.db_user_name, '-'));
		$('#db_user_pass').val( common.nvl(info.db_user_pass, '-'));
		$('#db_link').val( common.nvl(info.db_link, '-'));
		$('#archive_mode').val( common.nvl(info.archive_mode, '-'));
		$('#backup').val( common.nvl(info.backup, '-'));
		$('#backup_dt').val( makeDate(common.nvl(info.backup_dt, '-'))  );
		$('#db_etc').val( common.nvl(info.db_etc, '-'));
	    $('#db_popup #seq').val( common.nvl(info.seq, '-')); /* DB SEQ */
	    $('#server_seq').val( common.nvl(info.server_seq, '-'));
	    $('#db_popup #cust_seq').val( common.nvl(info.cust_seq, '-'));
	    
	   
		$("#db_popupLabel").html("DB정보 보기/수정");
		$('#db_popupLayer').show();
		$('#db_popup #pageType').val("update");
		
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
			closeDBpop();
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
	function openDBpop(type) {
		if(type=='insert') {
			document.db_popup.reset();
			$("#db_popupLabel").html("DB정보 등록");
			$('#db_popupLayer').show();
			$('#db_popup #pageType').val("insert");
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
	<li class="active"><a href="javascript:moveTab('2');">DB 정보</a></li><!-- 활성시 current -->
	<li><a href="javascript:moveTab('3');">어플리케이션 정보</a></li><!-- 활성시 current -->
	<li><a href="javascript:moveTab('4');">서비스(서버용) 정보</a></li><!-- 활성시 current -->
	
</ul>
	
<form name="procFrm" method="post" onsubmit="return false;">
	<input type="hidden" name="seq"  	  id="seq" 			value="${ vo.seq }"/> 
	<input type="hidden" name="pageType"  id="pageType" 	value="${vo.pageType}"/>
	<input type="hidden" name="procFlag"  id="procFlag" 	value="N"/>
	<input type="hidden" name="erp_code"  id="erp_code" 	value="${ vo.erp_code }"/>
	<input type="hidden" name="cust_seq"  id="cust_seq" 	value="${ vo.cust_seq }"/>
<!-- write -->
<div class="tit_bWrap mgb10">
	<h4 style="display: inline-block;">DB 정보</h4>
	<span class="tit_depth mgl20">행을 클릭하여 상세 정보를 확인하세요.</span>
	<button class="btn_ico_circle_plus_g mgr5 floatR" onclick="addDB();"><span>DB추가</span></button>
	<button class="btn_ico_stop_g mgr5 floatR" onclick="delDB();"><span>DB삭제</span></button>
</div>
<div class="mgb20" style="overflow-x:auto;">
	<table class="hType mgb10" id="db_tb" style="width:1000px;">
		<caption>DB 목록</caption>
		<colgroup>
			<%-- <col style="width:40px" /> <!--선택 -->
			<col style="width:40px" /> <!--NO-->
			<col style="width:120px" /><!--사용명칭 -->
			<col style="width:100px" /><!--DBMS 제품명-->
			<col style="width:100px" /><!--DBMS 버전 -->
			<col style="width:120px" /><!--HOST-->
			<col style="width:120px" /><!--PORT -->
			<col style="width:100px" /><!--SID -->
			<col style="width:100px" /><!--SERVICE NAME -->
			<col style="width:100px" /><!--USER NAME -->
			<col style="width:100px" /><!--PASS -->
			<col style="width:100px" /><!--DB LINK -->
			<col style="width:100px" /><!--ARCHIVE MODE -->
			<col style="width:100px" /><!--BACKUP -->
			<col style="width:140px" /><!--BACKUP보관일 -->
			<col style="width:150px" /><!--비고 --> --%>
			<col style="width:40px" /> 
			<col style="width:50px" />
			<col style="width:150px" />
			<col style="width:100px" />
			<col style="width:120px" />
			<col style="width:100px" />
			<col style="width:100px" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">선택</th>
				<th scope="col">No</th>
				<th scope="col">사용명칭</th>
				<th scope="col">DBMS 제품명</th>
				<!--<th scope="col">DBMS 버전</th>-->
				<th scope="col">HOST</th>
				<!--<th scope="col">PORT</th>-->
				<!--<th scope="col">SID</th>-->
				<th scope="col">SERVICE NAME</th>
				<th scope="col">USER NAME</th>
				<!--<th scope="col">PASS</th>-->
				<!--<th scope="col">DB LINK</th>-->
				<!--<th scope="col">ARCHIVE MODE</th>-->
				<!--<th scope="col">BACKUP</th>-->
				<!--<th scope="col">BACKUP보관일</th>-->
				<th scope="col">비고</th>
			</tr>
		</thead>
		<tbody id="db_wrap">
			<!-- <tr> 
				<td><input type="checkbox" name="" /></td> 선택
				<td>1</td> NO
				<td><input type="text" name="db_name" id="db_name" placeholder="DB사용명칭"/></td>사용명칭
				<td><select  name="dbms_type"><option>선택</option></select></td>DBMS 제품명
				<td><select  name="dbms_version"><option>선택</option></select></td>DBMS 버전
				<td><input type="text" name="db_host" placeholder="host"/></td>HOST
				<td><input type="text" name="db_port" placeholder="port" /></td>PORT
				<td><input type="text" name="db_sid" placeholder="sid"/></td>SID
				<td><input type="text" name="service_name" placeholder="service name"/></td>SERVICE NAME
				<td><input type="text" name="db_user_name" placeholder="user name"/></td>USER NAME
				<td><input type="text" name="db_user_pass" placeholder="password"/></td>PASS
				<td><input type="text" name="db_link" placeholder="DB 링크"/></td>DB LINK
				<td><select name="archive_mode" ><option>선택</option></select></td>ARCHIVE MODE
				<td><select name="backup"><option>선택</option></select></td>BACKUP
				<td><input type="text" name="backup_dt" id="backup_dt" placeholder="백업 보관일" style="width:70%" class="mgr5"/></td>BACKUP보관일
				<td><input type="text" name="db_etc" placeholder="비고"/></td>비고
			</tr> -->
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
<form name="db_popup" id="db_popup" method="post" onsubmit="return false;">
	<input type="hidden" name="seq" id="seq"  value=""/> <!-- DB seq -->
	<input type="hidden" name="pageType" id="pageType" value=""/>
	<input type="hidden" name="server_seq" id="server_seq"  value= "${ vo.server_seq }"/>
	<input type="hidden" name="cust_seq" id="cust_seq" value="${ vo.cust_seq }"/>
	
	<div id="db_popupLayer" style="display: none;">
		<div class="box_layer layer_sms" style="height: 560px; width: 800px; margin-top: -350px;">
			<h1 id="db_popupLabel">DB정보 등록</h1>
			<div class="layer_contents" style="padding-top: 20px; height: auto;">
				<h3 class="tit_sWrap">DB정보 내역</h3>
				<table class="sType mgb20">
					<caption>DB정보 등록</caption>
					<colgroup>
						<col style="width: 100px">
						<col style="width: 200px">
						<col style="width: 100px">
						<col style="width: 200px">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">사용명칭<span class="request">필수입력</span></th>
							<td colspan ="3"><input type="text" name="db_name" id="db_name" placeholder="DB사용명칭  ex) 프로젝트명 -별칭"></td>
						</tr>
						<tr>
							<th scope="row">DBMS 제품명</th>
							<td><select name="dbms_type" id="dbms_type" title="DBMS 제품명"></select></td>
							<th scope="row">DBMS 버전</th>
							<td><select name="dbms_version" id="dbms_version" title="DBMS 버전"></select></td>
						</tr>
						<tr>
							<th scope="row">HOST<span class="request">필수입력</span></th>
							<td><input type="text" title="host" name="db_host" id="db_host" placeholder="HOST"></td>
							<th scope="row">PORT<span class="request">필수입력</span></th>
							<td><input type="text" id="db_port" name ="db_port" placeholder="PORT"></td>
						</tr>
						<tr>
							<th scope="row">SID</th>
							<td><input type="text" title="sid" name="db_sid" id="db_sid" placeholder="SID"></td>
							<th scope="row">SERVICE NAME<span class="request">필수입력</span></th>
							<td><input type="text" id="service_name" name ="service_name" placeholder="SERVICE NAME"></td>
						</tr>
						<tr>
							<th scope="row">USER NAME<span class="request">필수입력</span></th>
							<td><input type="text" id="db_user_name" name ="db_user_name" placeholder="USER NAME"></td>
							<th scope="row">PASS<span class="request">필수입력</span></th>
							<td><input type="text" title="password" name="db_user_pass" id="db_user_pass" placeholder="PASS"></td>
						</tr>
						<tr>
							<th scope="row">DB LINK</th>
							<td><input type="text" title="DB LINK" name="db_link" id="db_link" placeholder="DB LINK"></td>
							<th scope="row">ARCHIVE MODE</th>
							<td><select name="archive_mode" id="archive_mode" title="ARCHIVE MODE"></select></td>
						</tr>
						<tr>
							<th scope="row">BACKUP</th>
							<td><select name="backup" id="backup" title="BACKUP"></select></td>
							<th scope="row">BACKUP보관일</th>
							<td><input type="text" class="w140" id="backup_dt" name ="backup_dt"></td>
						</tr>
						<tr>
							<th scope="row">비고</th>
							<td colspan="3"><input type="text" name="db_etc" id="db_etc" title="비고" value="" class="mgr5""></td>
						</tr>
					</tbody>
				</table>
				<div class="btn_wrap mgt20">
					<div class="floatR">
						<button type="button" class="btn_ico_confirm mgr5" onclick="regDbInfo()">
							<span>저장</span>
						</button>
						<button type="button" class="btn_ico_cancel" onclick="javascript:closeDBpop();">
							<span>취소</span>
						</button>
					</div>
				</div>
			</div>
			<button type="button" class="btn_close" onclick="javascript:closeDBpop();">창 닫기</button>
		</div>
		<div class="layer_dimmed"></div>
	</div>
</form>







