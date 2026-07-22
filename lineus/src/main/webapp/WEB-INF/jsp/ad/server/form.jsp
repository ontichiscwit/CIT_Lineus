<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="egovframework.com.comm.util.CommonExecute"%>



<script type="text/javascript">
	
	var paramString = "" ; 
	
	$(document).ready(function(){
		
		$( "#take_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#term_start_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#term_end_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#free_start_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#free_end_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#backup_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#service_wrap #str_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#service_wrap #end_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#wk_wrap #end_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#wk_wrap #str_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		/**	공통 코드 처리		*/
		commonCode.getCodeList('SERVER' , 'SV01' , 'access_type') ; 		/**	접속방식	*/
		commonCode.getCodeList('SERVER' , 'SV02' , 'contract_condition') ; 		/**	유무상구분	*/
		commonCode.getCodeList('SERVER' , 'SV03' , 'dbms_type') ; 			/**	DMBS 종류	*/
		commonCode.getCodeList('SERVER' , 'SV04' , 'disk_num') ; 			/**	디스크 수량	*/
		commonCode.getCodeList('SERVER' , 'SV05' , 'disk_type') ; 			/**	디스크타입	*/
		commonCode.getCodeList('SERVER' , 'SV06' , 'disk_volume') ; 		/**	디스크용량	타입 확인필요*/
		commonCode.getCodeList('SERVER' , 'SV07' , 'duplex_cdt') ; 			/**	이중화구성	*/
		commonCode.getCodeList('SERVER' , 'SV08' , 'main_mng') ; 			/**	관리주체	*/
		commonCode.getCodeList('SERVER' , 'SV09' , 'os') ; 					/**	os		*/
		commonCode.getCodeList('SERVER' , 'SV10' , 'raid_type') ; 			/**	RAID타입   */
		commonCode.getCodeList('SERVER' , 'SV11' , 'disk_num') ; 			/**	RAM수량     */
		commonCode.getCodeList('SERVER' , 'SV12' , 'ram_type') ; 			/**	RAM종류     */
		commonCode.getCodeList('SERVER' , 'SV13' , 'server_mnf') ; 			/**	제조사        */
		commonCode.getCodeList('SERVER' , 'SV14' , 'server_status') ; 		/**	상태		*/
		commonCode.getCodeList('SERVER' , 'SV15' , 'server_type') ; 		/**	사용용도	*/
		commonCode.getCodeList('SERVER' , 'SV16' , 'third_solution') ; 		/**	써드파티 솔루션*/
		commonCode.getCodeList('SERVER' , 'SV17' , 'unsed_status') ; 		/**	유휴폐기여부*/
		commonCode.getCodeList('SERVER' , 'SV18' , 'use_vpn') ; 			/**	vpn사용여부*/
		commonCode.getCodeList('SERVER' , 'SV19' , 'vaccine_type') ; 		/**	백신		*/
		
		paramString = location.href.indexOf('?') != -1 ? location.href.substring(location.href.indexOf('?') + 1 , location.href.length) : "" ; 
		
		$("#cust_nm").keydown(function (key) {
		    if(key.keyCode == 13){showLayer();}
	    });
		
		$("#worker_nm").keydown(function (key) {
		    if(key.keyCode == 13){showEmpLayer(1);}
	    });
		
		<c:if test="${ vo.pageType ne 'insert' }">
			initView();
		</c:if>
	});
	
	/* init */
	function initView() {
		
		$('#searchCust').remove(); /*거래처조회 버튼  숨김*/
		$('#cust_nm').removeClass(); /*거래처조회 버튼  숨김*/
		$('#cust_nm').attr('readonly','readonly'); /*거래처명 readonly처리*/
		
		var datas = {'seq' : $('#seq').val(),'cust_seq' : $('#cust_seq').val()} ; 
		common.ajaxCall(datas , '/ad/server/getServerInfo.do' , 'setServerInfo') ;
		
		var datas = {'seq' : $('#cust_seq').val()} ; 
		common.ajaxCall(datas , '/ad/cust/getCustInfo.do' , 'setCustInfo') ;
	}
	
	/* 거래처 기본 정보 셋팅 */
	function setCustInfo(data) {
		
		var info = typeof data.info !='undefined' ? data.info[0] : null ; //기본정보
		
		if (info != null) {
			/* 거래처 기본 정보 */
			$('#cust_info #erp_code').val(common.nvl(info.erp_code), '');
			$('#ceo').val(common.nvl(info.ceo), '');
			$('#tel_no').val(common.nvl(info.tel_no), '');
			$('#cust_nm').val(common.nvl(info.cust_nm), '');
			$('#cust_no').val(common.nvl(info.cust_no), '');
			
			$('#law_no').val(common.nvl(info.law_no), '');
			$('#buss_condition').val(common.nvl(info.buss_condition), '');
			$('#buss_item').val(common.nvl(info.buss_item), '');
			$('#cust_address').val(common.nvl(info.cust_address), '');
			
			$('#cust_kor_name').val(common.nvl(info.cust_kor_name), '');
			$('#cust_gubun').val(common.nvl(info.cust_gubun), '');
			$('#deal_code').val(common.nvl(info.deal_code), '');
			$('#foundation_code').val(common.nvl(info.foundation_code), '');
			$('#foundation_dt').val(common.nvl(info.foundation_dt), '');
			$('#contract_dt').val(common.nvl(info.contract_dt), '');
			$('#maintenance_raise_dt').val(common.nvl(info.maintenance_raise_dt), '');
			
			$('#tel_no').val(common.nvl(info.tel_no), '');
			$('#as_approval_yn').val(common.nvl(info.as_approval_yn), '');
			
			$('#sales').val(common.nvl(info.sales), '');
			$('#payment_code').val(common.nvl(info.payment_code), '');
			
			$('#sales_grade').val(common.nvl(info.sales_grade), '');
			$('#detail_etc').val(common.nvl(info.detail_etc), '');
			$('#detail_etc2').val(common.nvl(info.detail_etc2), '');
			$('#foundation_grade').val(common.nvl(info.foundation_grade), '');
		}
	}
	
	/* 서버 정보 셋팅 */
	function setServerInfo(data) {
		
		var info = typeof data.info !='undefined' ? data.info : null ; //기본정보
		
		if (info != null) {
			/* 서버 정보 */
			$("#server_type").val(common.nvl(info.server_type),'');
			$("#server_nm").val(common.nvl(info.server_nm),'');
			$("#server_mnf").val(common.nvl(info.server_mnf),'');
			$("#server_model").val(common.nvl(info.server_model),'');
			$("#server_id").val(common.nvl(info.server_id),'');
			$("#server_pass").val(common.nvl(info.server_pass),'');
			$("#server_ip").val(common.nvl(info.server_ip),'');
			$("#server_status").val(common.nvl(info.server_status),'');
			$("#pb_ip").val(common.nvl(info.pb_ip),'');
			$("#unsed_status").val(common.nvl(info.unsed_status),'');
			$("#serial_number").val(common.nvl(info.serial_number),'');
			/* 서버 관리 정보 */
			$("#main_mng").val(common.nvl(info.main_mng),'');
			$("#worker_nm").val(common.nvl(info.worker_nm),'');
			$("#worker_id").val(common.nvl(info.worker_id),'');
			$("#cust_worker").val(common.nvl(info.cust_worker),'');
			$("#cust_tel").val(common.nvl(info.cust_tel),'');
			$('#take_dt').val(makeDate(common.nvl(info.take_dt, ''))) ;
			$("#location_pc").val(common.nvl(info.location_pc),'');
			$("#mng_cust").val(common.nvl(info.mng_cust),'');
			$('#term_start_dt').val(makeDate(common.nvl(info.term_start_dt, ''))) ;
			$('#term_end_dt').val(makeDate(common.nvl(info.term_end_dt, ''))) ;
			$("#contract_condition").val(common.nvl(info.contract_condition),'');
			$('#free_start_dt').val(makeDate(common.nvl(info.free_start_dt, ''))) ;
			$('#free_end_dt').val(makeDate(common.nvl(info.free_end_dt, ''))) ;
			/*서버스펙 정보*/
			$("#os").val(common.nvl(info.os),'');
			$("#access_type").val(common.nvl(info.access_type),'');
			$("#ram_type").val(common.nvl(info.ram_type),'');
			$("#ram_num").val(common.nvl(info.ram_num),'');
			$("#dur_ip").val(common.nvl(info.dur_ip),'');
			$("#dbms_type").val(common.nvl(info.dbms_type),'');
			$("#dbms_version").val(common.nvl(info.dbms_version),'');
			$("#disk_type").val(common.nvl(info.disk_type),'');
			$("#disk_volume").val(common.nvl(info.disk_volume),'');
			$("#use_vpn").val(common.nvl(info.use_vpn),'');
			$("#vpn_addr").val(common.nvl(info.vpn_addr),'');
			$("#vpn_id").val(common.nvl(info.vpn_id),'');
			$("#vpn_pass").val(common.nvl(info.vpn_pass),'');
			$("#storage_volume").val(common.nvl(info.storage_volume),'');
			$("#storage_host").val(common.nvl(info.storage_host),'');
		}
	}
	
	function moveTab(gubun){
		if ($('#server_seq').val() == '' && gubun != '1') {
			alert('서버 정보를 등록해 주세요.');
			return;
		}
		location.href = "/ad/server/form" + gubun + ".do${ QUERYSTRING }" ;
	}
	
	function goProc(){
		
		var cust_nm = $('#cust_nm');
		var erp_code =$('#cust_info #erp_code');
		var server_type = $('#server_type');
		var server_nm = $('#server_nm');
		var server_id = $('#server_id');
		var server_pass = $('#server_pass');
		var server_mnf = $('#server_mnf');
		var server_model = $('#server_model');
		var server_status = $('#server_status');
		var main_mng = $('#main_mng');
		var worker_id = $('#worker_id');
		var worker_nm = $('#worker_nm');
		var location_pc = $('#location_pc');
		var os = $('#os');
		
		
		if(cust_nm.val() 	  == ""){alert('거래처명을 조회하세요.');cust_nm.focus(); return;}
		if(erp_code.val()     == ""){alert('거래처코드를 조회하세요.');erp_code.focus();      return;}
		if(server_type.val()  == ""){alert('사용용도를 선택하세요.');server_type.focus();   return;}
		if(server_nm.val()    == ""){alert('사용명칭을 입력하세요.');server_nm.focus();     return;}
		if(server_id.val()    == ""){alert('서버 아이디를 입력하세요.');server_id.focus();     return;}
		if(server_pass.val()  == ""){alert('서버 비밀번호를 입력하세요.');server_pass.focus();   return;}
		if(server_mnf.val()   == ""){alert('서버 제조사를 선택하세요.');server_mnf.focus();    return;}
		if(server_model.val() == ""){alert('서버 모델을 선택하세요.');server_model.focus();  return;}
		if(server_status.val()== ""){alert('서버 상태를 선택하세요.');server_status.focus(); return;}
		if(main_mng.val()     == ""){alert('관리주체를 선택하세요.');main_mng.focus();      return;}
		if(worker_id.val()    == ""){alert('내부 담당자를 조회하세요.');worker_id.focus();     return;}
		if(worker_nm.val()    == ""){alert('내부 담당자를 조회하세요.');worker_nm.focus();     return;}
		if(location_pc.val()  == ""){alert('PC 위치를 입력하세요.');location_pc.focus();   return;}
		if(os.val()           == ""){alert('OS 종류를 선택하세요.');os.focus();            return;}
		
		var f = document.procFrm;
		f.pageType.value = '${vo.pageType}';
		common.ajaxCall($('form[name=procFrm]').serialize() , '/ad/server/proc.do' , 'procReturn') ;
	}
	
	function procReturn(data){
		
		var returnCode = typeof data.returnCode != "undefined" ? data.returnCode : "002" ; 
		var msg = "" ; 
		
		if(returnCode == "000") msg = "정상적으로 처리 되었습니다." ; 
		else if(returnCode == "001") msg = "비정상적으로 처리 되었습니다." ; 
		else if(returnCode == "002") msg = "처리도중 오류가 발생했습니다." ;
		
		alert(msg) ; 
		if(returnCode == "000") {
			location.href = "/ad/server/list.do" ;
		}
	}
	
	function goList() {
		var f = document.procFrm;
		f.action = '/ad/server/list.do' + window.location.search.substring();
		f.submit();	
	}
	
	function changeServerCode(thisObj){
		$("#model_code").empty() ; 
		
		if(thisObj != ""){
			commonCode.getCodeList('CUST' , thisObj , 'model_code') ; 	
		}else{
			$('#model_code').append(commonCode.defaultViewOption);
		}
		
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
		
		common.ajaxCall(datas , '/ad/member/getCustList.do', 'makeCustList') ;
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
		$('#cust_seq').val(common.nvl(resultVO.seq, '')) ; 
		$('#cust_nm').val(common.nvl(resultVO.cust_kor_name, '')) ; 
		$('#cust_info #erp_code').val(common.nvl(resultVO.erp_code, '')) ; 
		$('#cust_address').val(common.nvl(resultVO.cust_address, '')) ; 
		$('#cust_post_no').val(common.nvl(resultVO.zip_code, '')) ; 
		$('#dam_emp_name').val(common.nvl(resultVO.emp_name, '')) ; 
		$('#dam_tel_no').val(common.nvl(resultVO.tel_no, '')) ;
		
	}
	
	function closeLayer() {
		$('#div1').hide() ; 
		$('#div_dim').hide() ; 
		$('#searchKorName').val('') ; 
		$("#searchKorName").removeAttr( "autofocus" );
	}
	
	
	
	/* 유지보수담당자 조회 */
	function showEmpLayer(num){
		$('#div6').show() ; 
		$('#div6_dim').show() ; 
		$("#search_empname").val( $("#worker_nm").val() );
		
		charList(1) ; 
		$("#searchCharName").attr( "autofocus","autofocus" );
		$('[autofocus]:not(:focus)').eq(0).focus();
		 
	}
	
	function charList(charPage){
		
		
		console.log( $('#search_empname').val() );
		var datas = {
				'page' : charPage ,
				'search_text' : $('#search_empname').val() 
		};
		common.ajaxCall(datas , '/ad/member/getEmpList.do', 'makeCharList') ;
	}
	
	
	function makeCharList(data){
		
		$('#charInfoList').empty() ; 
		$('#layer_pagination6').empty() ; 
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var vo = typeof data.vo != "undefined" ? data.vo : null ; 
		
		if(resultList != null && resultList.length > 0){
			var str = '' ; 
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ;
				var empty1 = "'"+datas.emp_no+"'";
				var empty2 = "'"+datas.emp_nm+"'";
				
				str += '<tr onclick="javascript:setValueChar('+ empty1 +','+ empty2 +');" style="cursor:pointer;"> ' ;
				str += '	<td>'+common.nvl(datas.rnum , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.dept2_nm , '')+"/"+common.nvl(datas.dept2_nm , '')+ '</td> ' ;
				str += '	<td>'+common.nvl(datas.emp_no , '')+ '</td> ' ;
				str += '	<td>'+common.nvl(datas.emp_nm , '')+ '</td> ' ;
				str += '	<td>'+common.nvl(datas.dept_grade_nm , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.e_mail , '')+'</td> ' ;
				str += '</tr> ' ;
			}
			$('#charInfoList').append(str) ; 
			$('#layer_pagination6').html(vo.json_paging) ; 
		}else{
			commonTable.notData(7 , '조회된 정보가 없습니다.' , 'charInfoList') ; 
		}
		
	}
	
	function setValueChar(emp_no,emp_nm){
		$('#worker_id').val(common.nvl(emp_no, ''));
		$('#worker_nm').val(common.nvl(emp_nm, ''));
		closeLayer6();
	}
	
	function closeLayer6() {
		$('#div6').hide() ; 
		$('#div6_dim').hide() ; 
		$('#searchEmpName').val('') ; 
		$("#searchEmpName").removeAttr( "autofocus" );
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
	<li class="active"><a href="javascript:moveTab('');">서버 정보</a></li><!-- 활성시 current -->
	<li><a href="javascript:moveTab('2');">DB 정보</a></li><!-- 활성시 current -->
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
<!-- write -->
<div class="tit_bWrap clearB mgb10">
	<h4>고객사 정보</h4>
</div>
<table class="sType mgb20" id="cust_info">
	<caption>소속 고객사 정보</caption>
	<colgroup>
		<col style="width:140px;" />
		<col style="width:360px;" />
		<col style="width:140px;" />
		<col style="width:360px;" />
	</colgroup>
	<tr>
		<th scope="row">거래처 명<span class="request">필수입력</span></th>
		<td>
			<input type="text" id="cust_nm" title="거래처 명" value="" class="w200"/>
			<button type="button" class="btn_line_gray w70" id="searchCust" onclick="javascript:showLayer();">조회하기</button>
		</td>
		<th scope="row">거래처 코드<span class="request">필수입력</span></th>
		<td>
			<input type="text" readonly="readonly" id="erp_code" name="erp_code" title="거래처 코드" value="" />
			
		</td>
	</tr>
	<tr>
		<th scope="row">거래처 주소</th>
		<td>
			<input type="text" readonly="readonly" id="cust_address" title="거래처 주소" value="" />
		</td>
		<th scope="row">우편번호</th>
		<td>
			<input type="text" readonly="readonly" id="cust_post_no" title="우편번호" value="" />
		</td>
	</tr>
	<tr>
		<th scope="row">거래처 담당자</th>
		<td>
			<input type="text" readonly="readonly" id="dam_emp_name" title="거래처 담당자" value="" />
		</td>
		<th scope="row">거래처 담당자 연락처</th>
		<td>
			<input type="text" readonly="readonly" id="dam_tel_no" title="거래처 담당자" value="" />
		</td>
	</tr>
</table>


<div class="tit_bWrap clearB mgb10">
	<h4>서버 기본 정보</h4>
</div>
<table class="sType mgb20">
	<caption>서버 정보 입력</caption>
	<colgroup>
		<col style="width:140px;" />
		<col style="width:360px;" />
		<col style="width:140px;" />
		<col style="width:360px;" />
	</colgroup>
	 <tr>
	 	<th scope="row">사용용도 / 사용명칭<span class="request">필수입력</span></th>
		<td>
			<select name="server_type" id="server_type" title="사용용도선택" class="w125 mgr5">
				<option>선택</option>
			</select>
			<input type="text" name="server_nm" id="server_nm" title="사용명칭입력" class="w125 mgr5" placeholder="사용명칭"/>
		</td>
		<th scope="row">서버 제조사 / 모델<span class="request">필수입력</span></th>
		<td>
			<select name="server_mnf" id="server_mnf" title="서버제조사 입력" class="w125 mgr5">
				<option>선택</option>
			</select>
			<select name="server_model" id="server_model" title="서버모델 입력" class="w125 mgr5">
				<option>선택</option>
			</select>
		</td>
	</tr>
    <tr>
		<th scope="row">서버 아이디/비밀번호<span class="request">필수입력</span></th>
		<td>
			<input type="text" name="server_id" id="server_id" title="서버 아이디 입력" class="w125 mgr5" placeholder="아이디"/>
			<input type="text" name="server_pass" id="server_pass" title="서버 비밀번호 입력"  class="w125 mgr5" placeholder="비밀번호"/>
		</td>
		<th scope="row">서버IP(내부)<span class="request">필수입력</span></th>
		<td>
			<input type="text" name="server_ip" id="server_ip" title="서버IP(내부)입력"  placeholder="내부IP"/>
		</td>
	</tr>
	<tr>
		<th scope="row">서버상태<span class="request">필수입력</span></th>
		<td>
			<select name="server_status" id="server_status" title="서버상태 선택" class="w125 mgr5">
				<option>선택</option>
			</select>
		</td>
		<th scope="row">서버IP(공인)</th>
		<td>
			<input type="text" name="pb_ip" id="pb_ip" title="서버IP(공인)입력"  placeholder="공인IP"/>
		</td>
	</tr>
	<tr>
		<th scope="row">유휴폐기여부</th>
		<td>
			<select name="unsed_status" id="unsed_status" title="유휴폐기여부 선택" class="w335">
				<option value="">선택</option>
			</select>
		</td>
		<th scope="row">시리얼넘버</th>
		<td>
			<input type="text" name="serial_number" id="serial_number" title="시리얼넘버 선택" class="w335" placeholder="시리얼넘버"/>
		</td>
	</tr>
</table>
<!--// write -->



<div class="tit_bWrap clearB mgb10">
	<h4>서버 관리 정보</h4>
</div>
<table class="sType mgb20">
	<caption>서버 관리 정보 입력</caption>
	<colgroup>
		<col style="width:140px;" />
		<col style="width:360px;" />
		<col style="width:140px;" />
		<col style="width:360px;" />
	</colgroup>
	 <tr>
	 	<th scope="row">관리주체<span class="request">필수입력</span></th>
		<td colspan="3">
			<select name="main_mng" id="main_mng" title="관리주체선택" class="w125 mgr5">
				<option>선택</option>
			</select>
		</td>
	</tr>
	<tr>	
		<th scope="row">내부담당자<span class="request">필수입력</span></th>
		<td>
			<input type="text" name="worker_nm" id="worker_nm" title="내부담당자 이름" placeholder="내부 담당자 이름" class="w125 mgr5" />
			<input type="text" name="worker_id" id="worker_id" title="내부담당자 사번" placeholder="내부 담당자 사번" class="w125 mgr5" readonly="readonly"/>
			<button type="button" class="btn_ico_search_s" onclick="javascript:showEmpLayer('1');"><span></span></button>
		</td>
		<th scope="row">유지보수업체 담당자</th>
		<td>
			<input type="text" name="cust_worker" id="cust_worker" title="외부담당자 이름" placeholder="외부 담당자 이름" class="w125 mgr5"/>
			<input type="text" name="cust_tel" id="cust_tel" title="외부담당자 연락처" placeholder="외부 담당자  연락처" class="w125 mgr5"/>
		</td>
	</tr>
    <tr>
		<th scope="row">도입일자</th>
		<td>
			<input type="text" name="take_dt" id="take_dt" title="도입일자 입력" class="w125 mgr5" />
		</td>
		<th scope="row">PC위치<span class="request">필수입력</span></th>
		<td>
			<input type="text" name="location_pc" id="location_pc" title="PC위치 입력" class="w335" placeholder="PC위치"/>
		</td>
	</tr>
	<tr>
		<th scope="row">유지보수업체</th>
		<td>
			<input type="text" name="mng_cust" id="mng_cust" title="유지보수업체 입력" class="w125 mgr5" placeholder=""/>
		</td>
		<th scope="row">계약일자</th>
		<td>
			<input type="text" name="term_start_dt" id="term_start_dt" title="계약일자 입력" class="w125" /> ~
			<input type="text" name="term_end_dt" id="term_end_dt" title="계약일자 입력" class="w125 mgr5" />
		</td>
	</tr>
	<tr>
		<th scope="row">유무상구분</th>
		<td>
			<select  name="contract_condition" id="contract_condition" title="유무상구분" class="w125 mgr5">
				<option>선택</option>
			</select>	
		</td>
		<th scope="row">무상보증기간</th>
		<td>
			<input type="text" name="free_start_dt" id="free_start_dt" title="계약일자 입력" class="w125" />
			~<input type="text" name="free_end_dt" id="free_end_dt" title="계약일자 입력" class="w125 mgr5" />
		</td>
	</tr>
</table>
<!--// write -->



<div class="tit_bWrap clearB mgb10">
	<h4>서버 스펙 정보</h4>
</div>
<table class="sType mgb30">
	<caption>서버 스펙 정보 입력</caption>
	<colgroup>
		<col style="width:140px;" />
		<col style="width:360px;" />
		<col style="width:140px;" />
		<col style="width:360px;" />
	</colgroup>
	 <tr>
	 	<th scope="row">OS<span class="request">필수입력</span></th>
		<td>
			<select name="os" id="os" title="OS선택" class="w125 mgr5">
				<option>선택</option>
			</select>
		</td>
		<th scope="row">접속방식</th>
		<td>
			<select name="access_type" id="access_type" title="접속방식선택" class="w125 mgr5">
				<option>선택</option>
			</select>
		</td>
	</tr>
	<tr>	
		<th scope="row">RAM / RAM수량</th>
		<td>
			<select  name="ram_type" id="ram_type" title="서버RAM" class="w125 mgr5">
				<option>선택</option>
			</select>	
			<input type="text" name="ram_num" id="ram_num" title="RAM수량" placeholder="RAM수량" class="w125 mgr5"/>
		</td>
		<th scope="row">서버백신</th>
		<td>
			<select  name="vaccine_type" id="vaccine_type" title="서버백신선택"  class="w125 mgr5">
				<option>선택</option>
			</select>	
		</td>
	</tr>
    <tr>
		<th scope="row">DUR 브로커IP</th>
		<td>
			<input type="text" name="dur_ip" id="dur_ip" title="DUR브로커 IP입력" placeholder="DUR 브로커IP"/>
		</td>
		<th scope="row">DBMS제품명/버전</th>
		<td>
			<select name="dbms_type" id="dbms_type" title="DBMS제품명선택"  class="w125 mgr5">
				<option>선택</option>
			</select>
			<select name="dbms_version" id="dbms_version" title="DBMS버전선택"  class="w125 mgr5">
				<option>선택</option>
			</select>
		</td>
	</tr>
	<tr>
		<th scope="row">DISK TYPE</th>
		<td>
			<select name="disk_type" id="disk_type" title="DISK타입선택" class="w125 mgr5">
				<option>선택</option>
			</select>
		</td>
		<th scope="row">DISK용량</th>
		<td>
			<input type="text" name="disk_volume" id="disk_volume" title="DISK용량선택" placeholder="DISK용량" class="w125 mgr5" />
		</td>
	</tr>
	<tr>
		<th scope="row">이중화구성</th>
		<td>
			<select name="duplex_cdt" id="duplex_cdt" title="이중화구성 선택" class="w125 mgr5">
				<option>선택</option>
			</select>
		</td>
		<th scope="row">써드파티 솔루션</th>
		<td>
			<select name="third_solution" id="third_solution" title="써드파티솔루션 선택" class="w125 mgr5">
				<option>선택</option>
			</select>
		</td>
	</tr>
	<tr>
		<th scope="row">RAID구성 / DISK수량</th>
		<td>
			<select name="raid_type" id="raid_type" title="RAID구성선택" class="w125 mgr5">
				<option>선택</option>
			</select>
			<select name="disk_num" id="disk_num" title="DISK수량선택" class="w125 mgr5">
				<option>선택</option>
			</select>
		</td>
		
		<th scope="row">디스크사용정보</th>
		<td>
			<input type="text" name="disk_info" id="disk_info" title="디스트사용정보입력" placeholder="디스크사용정보" />
		</td>
	</tr>
	<tr>
		<th scope="row">VPN사용여부 / VPN주소</th>
		<td>
			<select  name="use_vpn" id="use_vpn" title="VAN사용여부 선택" class="w125 mgr5">
				<option>선택</option>
			</select>
			<input type="text" name="vpn_addr" id="vpn_addr" title="VPN주소입력" class="w125 mgr5" placeholder="VPN주소" />
		</td>
		<th scope="row">VPN아이디 / 비밀번호</th>
		<td>
			<input type="text" name="vpn_id" id="vpn_id" title="VPN아이디 입력" class="w125 mgr5" placeholder="VPN아이디" />
			<input type="text" name="vpn_pass" id="vpn_pass" title="VPN비밀번호 입력" class="w125 mgr5 " placeholder="VPN비밀번호" />
		</td>
	</tr>
	<tr>
		<th scope="row">STORAGE볼륨</th>
		<td>
			<input type="text" name="storage_volume" id="storage_volume" title="STORAGE볼륨입력" placeholder="STORAGE " />
		</td>                                                            
		<th scope="row">STORAGE HOST</th>
		<td>
			<input type="text" name="storage_host" id="storage_host" title="STORAGE HOST입력" placeholder="STORAGE HOST" />
		</td>
	</tr>
</table>


<!--// list -->
<div class="btn_wrap">
	<div class="floatL">
		<button type="button" class="btn_ico_list" onclick="goList();"><span>목록</span></button>
	</div>
	<div class="floatR">
		<button type="button" class="btn_ico_confirm" id="btnView1" onclick="goProc();"><span>저장</span></button>
	</div>
</div>
</form>


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



<!-- 운영 담당자 조회 -->
<div class="box_layer layer_sms" style="display:none;" id="div6">
<h1>운영 담당자 조회</h1>
<div class="layer_contents pdt20"> 
	이름:
	<input type="text" class="w175 mgr10" id="search_empname" name="search_empname" title="담당자 입력" autofocus="autofocus"/>
	<input type="hidden" id="rowNum" name="rowNum" value=""/>
	<button type="button" class="btn_ico_search mgr5" onclick="javascript:charList(1);"><span>검색</span></button>
	<table class="vType_line" id="emp_tb" style="margin-top: 10px">
		<caption>직원 정보 목록</caption>
		<colgroup>
			<col style="width:50px;" />
			<col style="width:180px;" />
			<col style="width:100px;" />
			<col style="width:100px;" />
			<col style="width:80px;" />
			<col style="width:120px;" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">No</th>
				<th scope="col">부서명/팀명</th>
				<th scope="col">사번</th>
				<th scope="col">이름</th>
				<th scope="col">직급</th>
				<th scope="col">이메일</th>
			</tr>
		</thead>
		<tbody id="charInfoList"></tbody>
	</table>
	<div class="page" id="layer_pagination6" style="margin-top: 10px;"></div>
</div>
<button type="button" class="btn_close" onclick="javascript:closeLayer6();">창 닫기</button>
</div>
<div class="layer_dimmed" style="display:none;" id="div6_dim"></div>



