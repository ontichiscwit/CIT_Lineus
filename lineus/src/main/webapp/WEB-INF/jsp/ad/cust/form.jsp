<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="egovframework.com.comm.util.CommonExecute"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix = "fn"		uri = "http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" 	uri="http://www.springframework.org/tags"%>
<%@page import="egovframework.com.comm.util.StringUtil"%>
<%@page import="egovframework.com.comm.util.DateTimeUtil"%>
<script type="text/javascript">

	var i_cnt = 0;
	var erp_code_flag = false;
	
	$(document).ready(function(){
		$( "#foundation_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#contract_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#maintenance_raise_dt" ).val($.datepicker.formatDate('yy/mm/dd', '')).datepicker(datepicker);
			
		
		/**	select box 정보 처리	*/
		commonCode.getCodeList('CUST' , 'CD01' , 'cust_gubun') ; 		/**	거래처 구분	*/
		commonCode.getCodeList('CUST' , 'CD08' , 'foundation_code') ; 	/**	소유 구분		*/
		commonCode.getCodeList('CUST' , 'CD09' , 'payment_code') ; 		/**	지불방법		*/
		commonCode.getCodeList('CUST' , 'CD04' , 'as_approval_yn') ;    /**	AS승인프로세스		*/
		commonCode.getCodeList('CUST' , 'CD03' , 'deal_code') ;       	/**	거래상태		*/
		commonCode.getCodeList('COMMON','CD09' , 'is_yn') ;       		/**	거래처 등록여부		*/
		
		
		
		paramString = location.href.indexOf('?') != -1 ? location.href.substring(location.href.indexOf('?') + 1 , location.href.length) : "" ; 
		
		<c:if test="${ vo.pageType ne 'insert' }">
			initView();
		</c:if>
		
		
		$('#charger_tel').keyup(function (e){
			$(this).val($(this).val().replace(/[^0-9]/g,""));
		});
		
		
	});
	
	//거래처 조회
	function initView() {
		var datas = {'seq' : $('#seq').val()} ; 
		common.ajaxCall(datas , '/ad/cust/getCustInfo.do' , 'setCustInfo') ;
		
	}
	
	
	//ERP 거래처 조회
	function custList(page) {
		
		var datas = {"cust_nm" : $('#search_cust_nm').val(),"is_yn" : $('#is_yn').val(), 'page' : page };
		common.ajaxCall(datas , '/ad/cust/getCustMaster.do' , 'setMasterInfo') ; 
	}
	
	/* function searchCustNm(page){
		var datas = {"cust_nm" : $('#search_cust_nm').val(), 'page' : page };
		common.ajaxCall(datas , '/ad/cust/getCustMaster.do' , 'setMasterInfo') ;
		
	} */
	
	//조회 거래처 정보 자동 입력
	function getCustValue(data){
		var datas = {"cust_cd" : data};
		common.ajaxCall(datas , '/ad/cust/getCustMasterOne.do' , 'setMasterInfoOne') ;
	}
		
	function setMasterInfoOne(data){
		var data = typeof data.vo !='undefined' ? data.vo : null ;
		$('#cust_nm').val(data.cust_nm); /** 거래처 이름*/
		$('#cust_kor_name').val(data.cust_nm);
		$('#ceo').val(data.represent);/** ceo*/
		$('#tel').val(data.addr_detail);/** 주소*/
		$('#erp_code').val(data.cust_cd);/** erp코드*/
		$('#cust_no').val(data.biz_reg_no);/** 사업자번호*/
		$('#buss_condition').val(data.biz_condition);/** 업태*/
		$('#buss_item').val(data.biz_type); /** 업종*/
		$('#cust_address').val(data.zip_nm); /** 주소*/
		$('#searchErpInfoDiv').hide();
		$('#div1_dim').hide();
	}
	
	
	function setMasterInfo(data){
		
		$('#layer_pagination').empty() ;
		$('#custInfoList').empty();
		//$('#search_cust_nm').val('');
		
		var resultList = typeof data.resultList !='undefined' ? data.resultList : null ;
		var vo = typeof data.vo != "undefined" ? data.vo : null ;
		
		if( resultList != null && resultList.length > 0 ){
			var htmlStr = "";
			for (var i =0; i < resultList.length; i++){
				var datas = resultList[i];
				htmlStr += '<tr onclick="javascript:getCustValue(\''+common.nvl(datas.cust_cd, '')+'\');" style="cursor:pointer;"> ' ;
				htmlStr += "	<td>"+common.nvl(datas.rnum, '')+"</td>";
				htmlStr += "	<td>"+common.nvl(datas.cust_cd, '')+"</td>";
				htmlStr += "	<td>"+common.nvl(datas.cust_nm, '')+"</td>";
				htmlStr += "	<td style=display:none>"+common.nvl(datas.biz_condition, '')+"</td>";
				htmlStr += "	<td>"+common.nvl(datas.biz_type, '')+"</td>";
				htmlStr += "	<td>"+common.nvl(datas.zip_nm, '')+"</td>";
				htmlStr += "	<td>"+common.nvl(datas.is_yn_nm, '')+"</td>";
				htmlStr += "</tr>";
				
			}
			$("#custInfoList").html(htmlStr);
			$('#layer_pagination').html(vo.json_paging) ; 
			$('#searchErpInfoDiv').show();
			$('#div1_dim').show();
			
		}else{
			alert("ERP 코드로 조회된 정보가 없습니다.") ; 
			return;
		}
	}
	
	function closeLayer(layer){
		$('#searchErpInfoDiv').hide();
		$('#empLayer').hide();
		$('#div1_dim').hide();
		$('#div_dim').hide();
		
	}
	
	
	
	function addIssue() {
		var str = '';
		
		i_cnt++;
		
		str += '<tr>';
		str += '	<td><input type="checkbox" name="dtl_seq" id="dtl_seq" title="선택" /></td>';
		str += '	<td>';
		str += '		<select id="gubun_code'+i_cnt+'" name="gubun_code'+i_cnt+'" title="구분 선택">';
		str += '			<option value="">최고서발송(1차)</option>';
		str += '		</select>';
		str += '	</td>';
		str += '	<td><textarea id="contents'+i_cnt+'" name="contents'+i_cnt+'" title="내용 입력" ></textarea></td>';
		str += '	<td>-<!-- 2017-01-01 00:00:00 --></td>';
		str += '	<td>-<!-- 홍길동 --></td>';
		str += '	<td>';
		str += '		<select id="action_result_code'+i_cnt+'" name="action_result_code'+i_cnt+'" title="조치결과 선택">';
		str += '			<option>입금</option>';
		str += '		</select>';
		str += '	</td>';
		str += '	<td>';
		str += '		<textarea id="action_result_etc'+i_cnt+'" name="action_result_etc'+i_cnt+'" title="조치결과 내용 입력"></textarea>';
		str += '	</td>';
		str += '	<td>-<!-- 2017-01-01 00:00:00 --></td>';
		str += '	<td>-<!-- 홍길동 --></td>';
		str += '</tr>';
		$('#issue_wrap').append(str);
		
		commonCode.getCodeList('CUST' , 'CD10' , 'gubun_code' + i_cnt) ; 
		commonCode.getCodeList('CUST' , 'CD11' , 'action_result_code' + i_cnt) ;
		
	}
	
	function delIssue() {
		if ($('#issue_wrap input[type=checkbox]:checked').length == 0) { 
			alert('삭제할 행을 선택하세요.');
			return;
		}
		$('#issue_wrap input[type=checkbox]:checked').each(function(){
			if (common.isEmpty($('#del_dtl_seq').val())) $('#del_dtl_seq').val($(this).val());
			else $('#del_dtl_seq').val($('#del_dtl_seq').val() + "@" + $(this).val());
			$(this).parent().parent('tr').remove();
		});
	}
	
	
	/* 유지보수담당자 조회 */
	function showEmpLayer(num){
		$('#empLayer').show() ; 
		$('#div_dim').show() ; 
		charList(num) ; 
		$("#searchKorName").attr( "autofocus","autofocus" );
		$('[autofocus]:not(:focus)').eq(0).focus();
		 
	}
	
	function charList(charPage){
		
		var datas = {
				'page' : charPage ,
				'emp_nm' : $('#searchKorName').val() 
		};
		common.ajaxCall(datas , '/ad/cust/getEmpList.do', 'makeCharList') ;
	}
	
	
	function makeCharList(data){
		
		$('#empInfoList').empty() ; 
		$('#layer_pagination1').empty() ; 
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var vo = typeof data.vo != "undefined" ? data.vo : null ; 
		
		if(resultList != null && resultList.length > 0){
			var str = '' ; 
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ;
				str += '<tr onclick="javascript:setValue('+ datas.emp_no +');" style="cursor:pointer;"> ' ;
				str += '	<td>'+common.nvl(datas.rnum , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.dept1_nm , '')+"/"+common.nvl(datas.dept2_nm , '') + '</td> ' ;
				str += '	<td>'+common.nvl(datas.emp_no , '')+ '</td> ' ;
				str += '	<td>'+common.nvl(datas.emp_nm , '')+ '</td> ' ;
				str += '	<td>'+common.nvl(datas.dept_grade_nm , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.e_mail , '')+'</td> ' ;
				str += '</tr> ' ;
			}
			$('#empInfoList').append(str) ; 
			$('#layer_pagination1').html(vo.json_paging) ; 
		}else{
			commonTable.notData(7 , '조회된 정보가 없습니다.' , 'empInfoList') ; 
		}
		
	}
	
	function setValue(emp_no){
		var datas = {'emp_no' 				: emp_no }
		common.ajaxCall(datas , '/ad/member/getPostInfo.do', 'makePostInfo') ;
		closeLayer() ; 
	}
	
	function makePostInfo(data){
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null ; 
		
		$('#charger_no').val(common.nvl(resultVO.emp_no, '')) ; 
		$('#charger_nm').val(common.nvl(resultVO.emp_nm, '')) ; 
		$('#charger_email').val(common.nvl(resultVO.e_mail ,'')) ; 
		$('#charger_tel').val(common.nvl(resultVO.company_no , '')) ;
		
	}
	
	
	function proc() {
		var f = document.procFrm;
		
		var erp_code = $('#erp_code');
		var cust_nm = $('#cust_nm');
		var cust_kor_name = $('#cust_kor_name');
		var cust_gubun = $('#cust_gubun');
		var foundation_code = $('#foundation_code');
		var as_approval_yn  = $('#as_approval_yn');
		var deal_code  = $('#deal_code');
		
		var charger_tel  = $('#charger_tel');
		var charger_email  = $('#charger_email');
		var charger_no  = $('#charger_no');
		
		
		if (cust_nm.val()=='') {
			alert('사업자등록명을 입력하세요.');
			cust_nm.focus();
			return;
		}
		
		if (cust_kor_name.val()=='') {
			alert('거래처명을 입력하세요.');
			cust_kor_name.focus();
			return;
		}
		if (erp_code.val() == '') {
			alert('erp 코드를 조회해 주세요.');
			erp_code.focus();
			return;
		}
		if (cust_gubun.val() == '') {
			alert('거래처 구분을 선택해 주세요.');
			cust_gubun.focus();
			return;
		}
		if (foundation_code.val() == '') {
			alert('소유구분을 선택해 주세요.');
			foundation_code.focus();
			return;
		}
		if (as_approval_yn.val() == '') {
			alert('A/S 승인 프로세스 여부를 선택해 주세요.');
			as_approval_yn.focus();
			return;
		}
		
		if (deal_code.val() == '') {
			alert('거래 상태를  선택해 주세요.');
			deal_code.focus();
			return;
		}
		
		if (charger_email.val() == '') {
			alert('시스템 대표관리자의 이메일을 입력하세요.');
			charger_email.focus();
			return;
		}
		if (charger_tel.val() == '') {
			alert('시스템 대표관리자의이메일을 입력하세요.');
			charger_tel.focus();
			return;
		}
		
		
		if (charger_no.val() == '') {
			alert('시스템 대표관리자를 선택하세요.');
			charger_nm.focus();
			return;
		}
		
		
		f.i_cnt.value = i_cnt ; 
		common.ajaxCall($('form[name=procFrm]').serialize() , '/ad/cust/proc.do' , 'procReturn') ; 
	}
	
	function procReturn(data) {
		var returnCode = typeof data.returnCode != "undefined" ? data.returnCode : "002" ; 
		var seq = typeof data.seq != "undefined" ? data.seq : "" ; 
		var message = typeof data.message != "undefined" ? data.message : "" ; 
		var msg = "" ; 
		
		if(returnCode == "000") msg = "정상적으로 처리 되었습니다." ; 
		else if(returnCode == "001") msg = message ; 
		else if(returnCode == "002") msg = "처리도중 오류가 발생했습니다." ;
		
		alert(msg) ; 
		if(returnCode == "000"){location.href = "/ad/cust/list.do"; } ;  
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
				
				if(imsi[0] == 'erp_code'){
					imsi[1] = $('#erp_code').val() ; 
				}
				
				if(newQuery == "") newQuery = "?" + imsi[0] + "=" +imsi[1] ; 
				else newQuery = newQuery + "&" + imsi[0] + "=" +imsi[1] ;
			}
		}else{
			newQuery = "?pageType=update&seq=" + $('#seq').val() + "&cust_kor_name=" + encodeURI($('#cust_kor_name').val()) + "&erp_code=" + $('#erp_code').val() ; 
		}
		
		if ($('#seq').val() == '') {
			alert('관리정보를 등록해 주세요.');
			return;
		}else  {
			if (newQuery.indexOf("erp_code") < 0){
				location.href = "/ad/cust/form" + gubun + ".do" + newQuery + "&erp_code=" + $('#erp_code').val()
			}else{
				location.href = "/ad/cust/form" + gubun + ".do" + newQuery;
			}
		}
	}
	
	function delProc() {
		if (confirm("관련된 모든 데이터가 삭제됩니다.\n정말 삭제 하시겠습니까?")) {
			var f = document.procFrm;
			f.pageType.value = 'delete';
			common.ajaxCall($('form[name=procFrm]').serialize() , '/ad/cust/proc.do' , 'procReturn') ;			
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
			f.action = '/ad/cust/list.do' + window.location.search.substring();
			f.submit();			
		}

	}
	
	function setCustInfo(data){
		var info = typeof data.info != "undefined" ? data.info[0] : null ; 
		var hist = typeof data.hist != "undefined" ? data.hist : null ; 
		
		if (info != null) {
			
			console.log(info);
			$('#erp_code_btn').remove();
			$('#cust_nm').attr('readonly','readonly');
			$('#cust_nm').removeClass('w95');
			
			$('#erp_code').val(common.nvl(info.erp_code), '');
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
			
			$('#as_approval_yn').val(common.nvl(info.as_approval_yn), '');
			
			$('#sales').val(common.nvl(info.sales), '');
			$('#payment_code').val(common.nvl(info.payment_code), '');
			
			$('#sales_grade').val(common.nvl(info.sales_grade), '');
			$('#detail_etc').val(common.nvl(info.detail_etc), '');
			$('#detail_etc2').val(common.nvl(info.detail_etc2), '');
			$('#foundation_grade').val(common.nvl(info.foundation_grade), '');
			
			$('#charger_nm').val(common.nvl(info.charger_nm), '');
			$('#charger_no').val(common.nvl(info.charger_no), '');
			$('#charger_email').val(common.nvl(info.charger_email), '');
			$('#charger_tel').val(common.nvl(info.charger_tel), '');
			
			
			if (hist != null && hist.length > 0) {
				if (hist.length != 0)$('#issue_wrap').empty();

				for (var i=0; i < hist.length; i++) {
					var map = hist[i];
					
					
					var str = '';	
					str += '<tr>';
					str += '	<td><input type="checkbox" name="i_seq'+(i+1)+'" id="i_seq'+(i+1)+'" value="'+common.nvl(map.dtl_seq, '')+'" title="선택" />';
					str += '<input type="hidden" name="dtl_seq'+(i+1)+'" id="dtl_seq'+(i+1)+'" value="'+common.nvl(map.dtl_seq, '')+'" /></td>';
					str += '	<td>';
					str += '		<select id="gubun_code'+(i+1)+'" name="gubun_code'+(i+1)+'" title="구분 선택">';
					str += '			<option value="" >선택</option>';
					str += '		</select>';
					str += '	</td>';
					str += '	<td><textarea id="contents'+(i+1)+'" name="contents'+(i+1)+'" title="내용 입력">'+common.nvl(map.contents,'')+'</textarea></td>';
					str += '	<td>'+common.nvl(map.reg_date,'-')+'</td>';
					str += '	<td>'+common.nvl(map.reg_id,'-')+'</td>';
					str += '	<td>';
					str += '		<select id="action_result_code'+(i+1)+'" name="action_result_code'+(i+1)+'" title="조치결과 선택">';
					str += '			<option value="">선택</option>';
					str += '		</select>';
					str += '	</td>';
					str += '	<td>';
					str += '		<textarea type="text" id="action_result_etc'+(i+1)+'" name="action_result_etc'+(i+1)+'" title="조치결과 내용 입력">'+common.nvl(map.action_result_etc,'')+'</textarea>';
					str += '	</td>';
					str += '	<td>'+common.nvl(map.action_change_date,'-')+'</td>';
					str += '	<td>'+common.nvl(map.action_emp_id,'-')+'</td>';
				
					$('#issue_wrap').append(str);
					
					
					commonCode.getCodeList('CUST' , 'CD10' , 'gubun_code' + (i+1)) ; 
					commonCode.getCodeList('CUST' , 'CD11' , 'action_result_code' + (i+1)) ; 
					
					$('#gubun_code'+(i+1)).val(map.gubun_code);
					$('#action_result_code'+(i+1)).val(map.action_result_code);
				}
				i_cnt = hist.length;
			}
		}
	}
	
	
	function goReset() {
		<c:choose>
			<c:when test="${ vo.pageType ne 'insert' }">initView();</c:when>
			<c:otherwise>document.procFrm.reset();</c:otherwise>
		</c:choose>
	}
	
	
	
	
</script>
<div class="tit_wrap">
	<%-- <%= CommonExecute.returnLineMap(request) %> --%>
	<h2 class="tit_ico_customer">거래처 관리<span class="tit_depth mgl20 mgt8">관리정보</span></h2>
</div>
<div class="tit_sWrap">
<%-- <h3 class="tit_dot_gray">거래처 상세 정보<c:if test="${ vo.pageType ne 'insert' }">&nbsp;&lt;<span class="colorBlue mg15" style="line-height:25px;">${ vo.cust_kor_name }, ${ vo.cust_code }</span>&gt;</c:if></h3>
 --%>
 </div>
<!-- tab -->
<ul class="tab_line list3 mgb20">
	<li class="active"><a href="javascript:moveTab('');">관리 정보</a></li><!-- 활성시 current -->
	<li><a href="javascript:moveTab('5');">계약 이력</a></li>
	<li><a href="javascript:moveTab('6');">문서 관리</a></li>
</ul>
<form name="procFrm" method="post" onsubmit="return false;">
<input type="hidden" name="pageType" id="pageType" value="${vo.pageType}"/>
<input type="hidden" name="seq" id="seq" value="${vo.seq}" />
<input type="hidden" name="del_dtl_seq" id="del_dtl_seq" value="" />
<input type="hidden" name="i_cnt" id="i_cnt" />
<!-- write -->
<div class="tit_bWrap mgb10">
	<h4 class="floatL">사업자 정보</h4>
</div>
<table class="sType mgb20">
	<caption>사업자 정보 입력</caption>
	<colgroup>
		<col style="width:125px;" />
		<col style="width:209px;" />
		<col style="width:125px;" />
		<col style="width:208px;" />
		<col style="width:125px;" />
		<col style="width:208px;" />
	</colgroup>
	<tr>
		<th scope="row">사업자등록명 <span class="request">필수입력</span></th>
		<td>
			<input type="text" readonly="readonly" id="cust_nm" name="cust_nm" title="사업자등록명 입력" value="" class="w95" />
			<button id="erp_code_btn" class="btn_line_gray" onclick="javascript:custList(1);">조회</button>
		</td>
		<th scope="row">대표자</th>
		<td>
			<input type="text" id="ceo" name="ceo" title="대표자 입력" value="" readonly="readonly" />
		</td>
		
		<th scope="row">대표번호</th>
		<td>
			<input type="text" id="tel_no" name="tel_no" name="" title="전화번호 입력" value="" readonly="readonly" />
		</td>
	</tr>
	<tr>
		<th scope="row">ERP코드 <span class="request">필수입력</span></th>
		<td>
			<input type="text" id="erp_code" name="erp_code" title="ERP코드 입력"  value="" readonly="readonly" /> <!-- 02617 -->
		</td>
		<th scope="row">사업자등록번호</th>
		<td>
			<input type="text" id="cust_no" name="cust_no" title="사업자등록번호 입력" value="" readonly="readonly" />
		</td>
		<th scope="row">법인등록번호</th>
		<td>
			<input type="text" id="law_no" name="law_no" title="법인등록번호 입력" value="" readonly="readonly" />
		</td>
	</tr>
	<tr>
		<th scope="row">업태</th>
		<td>
			<input type="text" id="buss_condition" name="buss_condition" title="업태 입력" value="" readonly="readonly" />
		</td>
		<th scope="row">업종</th>
		<td>
			<input type="text" id="buss_item" name="buss_item" title="종목 입력" value="" readonly="readonly" />
		</td>
		<td colspan="2"></td>
	</tr>
	<tr>
		<th scope="row" >사업자소재지</th>
		<td colspan="5">
			<input type="text" id="cust_address" name="cust_address" title="사업자소재지 입력" value="" readonly="readonly"  />
		</td>
		
	</tr>
</table>
<!--// write -->

<!-- write -->
<div class="tit_bWrap mgb10">
	<h4>기본 정보</h4>
</div>
<table class="sType mgb20">
	<caption>기본 정보 입력</caption>
	<colgroup>
		<col style="width:125px;" />
		<col style="width:209px;" />
		<col style="width:125px;" />
		<col style="width:208px;" />
		<col style="width:125px;" />
		<col style="width:208px;" />
	</colgroup>
	<tr>
		<th scope="row" >거래처명 <span class="request">필수입력</span></th>
		<td colspan="5">
			<input type="text" id="cust_kor_name" name="cust_kor_name" title="거래처명 입력" value="" />
		</td>
		<!-- <th scope="row" >A/S 승인 프로세스<span class="request">필수입력</span></th>
		<td colspan="3">
			<select  id="as_approval_yn" name="as_approval_yn" title="A/S 승인 프로세스 여부 선택 " class="w168">
				<option value="">선택</option>
			</select>
			<span class="tit_depth mgl20">A/S 접수 시 승인 프로세스를 실행합니다.</span>
		</td> -->
	</tr>
	<tr>
		<th scope="row">거래처구분 <span class="request">필수입력</span></th>
		<td>
			<select id="cust_gubun" name="cust_gubun" title="거래처구분 선택">
				<option value="">전체</option>
			</select>
		</td>
		<th scope="row">소유구분 <span class="request">필수입력</span></th>
		<td>
			<select id="foundation_code" name="foundation_code" title="소유구분 선택">
				<option value="">전체</option>
			</select>
		</td>
		<th scope="row">거래상태<span class="request">필수입력</span></th>
		<td>
			<select id="deal_code" name="deal_code" title="거래상태 선택">
				<option value="">전체</option>
			</select>
		</td>
	</tr>
	<tr>
		<th scope="row">회사설립일</th>
		<td>
			<input type="text" id="foundation_dt" name="foundation_dt" title="병원설립일 입력" class="w135 mgr5"  />
			<!-- <button type="button" class="btn_calendar">날짜선택</button> -->
		</td>
		<th scope="row">매출액</th>
		<td>
			<input type="text" id="sales" name="sales" title="매출액 입력" value="" onkeydown="onlyNumber(this);" onkeyup="common.inputNumberFormat(this)"/>
		</td>
		<th scope="row">지불방법</th>
		<td colspan="3">
			<select id="payment_code" name="payment_code" title="지불방법 선택" class="w168">
				<option value="">전체</option>
			</select>
		</td>
	</tr>
	
	
</table>
<!--// write -->
<!-- write -->
<div class="tit_bWrap mgb10">
	<h4>시스템 관리 정보</h4>
</div>
<table class="sType mgb20">
	<caption>기본 정보 입력</caption>
	<colgroup>
		<col style="width:125px;" />
		<col style="width:209px;" />
		<col style="width:125px;" />
		<col style="width:208px;" />
		<col style="width:125px;" />
		<col style="width:208px;" />
	</colgroup>
	<tr>
		<th scope="row" >대표 관리자명<span class="request">필수입력</span></th>
		<td colspan="5">
			<input type="text" id="charger_nm" name="charger_nm" title="대표 관리자명 " class="w168"/>
			<input type="hidden" id="charger_no" name="charger_no" title="대표 관리자명 " class="w168"/>
			<button class="btn_line_gray" onclick="javascript:showEmpLayer();">조회</button>
		</td>
	</tr>
	<tr>
		<th scope="row" >대표관리자 전화번호 (CWIT)<span class="request">필수입력</span></th>
		<td>
			<input type="text" id="charger_tel" name="charger_tel" title="대표관리자 전화번호 입력" value="" class="w168"/>
		</td>
		<th scope="row" >대표관리자 이메일 (CWIT)<span class="request">필수입력</span></th>
		<td colspan ="3">
			<input type="text" id="charger_email" name="charger_email" title="대표관리자 이메일 입력" value="" class="w168"/>
			<span class="tit_depth mgl20">SMS,이메일 발송 시 본 정보를 발신자 정보로 사용됩니다. </span>
		</td>
	</tr>
	<tr>
		<th scope="row" >A/S 승인 프로세스<span class="request">필수입력</span></th>
		<td colspan="5">
			<select  id="as_approval_yn" name="as_approval_yn" title="A/S 승인 프로세스 여부 선택 " class="w168">
				<option value="">선택</option>
			</select>
			<span class="tit_depth mgl20">A/S 접수 시 승인 프로세스를 실행합니다.</span>
		</td>
	</tr>	
</table>


<!-- write -->
<div class="tit_bWrap mgb10">
	<h4>기타 정보</h4>
</div>
<table class="sType mgb20">
	<caption>기타 정보 입력</caption>
	<colgroup>
		<col style="width:125px;" />
		<col style="width:209px;" />
		<col style="width:125px;" />
		<col style="width:208px;" />
		<col style="width:125px;" />
		<col style="width:208px;" />
	</colgroup>
	<tr>
		<th scope="row">영업부 의견</th>
		<td>
			<select id="sales_grade" name="sales_grade" title="영업부 의견 선택" class="w168">
				<option value="5">+5</option>
				<option value="4">+4</option>
				<option value="3">+3</option>
				<option value="2">+2</option>
				<option value="1">+1</option>
				<option value="0" selected="selected">0</option>
				<option value="-1">-1</option>
				<option value="-2">-2</option>
				<option value="-3">-3</option>
				<option value="-4">-4</option>
				<option value="-5">-5</option>			
			</select>
		</td>
		<th scope="row">상세의견</th>
		<td colspan="3">
			<input type="text" id="detail_etc" name="detail_etc" title="상세의견 입력" value="" />
		</td>
	</tr>
	<tr>
		<th scope="row">재단상태평가</th>
		<td>
			<select id="foundation_grade" name="foundation_grade" title="재단상태평가 선택" class="w168">
				<option value="5">+5</option>
				<option value="4">+4</option>
				<option value="3">+3</option>
				<option value="2">+2</option>
				<option value="1">+1</option>
				<option value="0" selected="selected">0</option>
				<option value="-1">-1</option>
				<option value="-2">-2</option>
				<option value="-3">-3</option>
				<option value="-4">-4</option>
				<option value="-5">-5</option>	
			</select>
		</td>
		<th scope="row">상세의견</th>
		<td colspan="3">
			<input type="text" id="detail_etc2" name="detail_etc2" title="상세의견 입력" value="" />
		</td>		
	</tr>
</table>
<!--// write -->
<!-- list -->
<div class="tit_bWrap mgb10">
	<h4 class="floatL mgt8">이슈관리 내역</h4>
	<span class="floatR">
		<button class="btn_ico_circle_plus_g mgr5" onclick="addIssue();"><span>행추가</span></button>
		<button class="btn_ico_stop_g" onclick="delIssue()"><span>행삭제</span></button>
	</span>
</div>
<table class="hType mgb20">
	<caption>이슈관리 목록</caption>
	<colgroup>
		<col style="width:35px" />
		<col style="width:70px" />
		<col style="width:100px" />
		<col style="width:50px" />
		<col style="width:50px" />
		<col style="width:70px" />
		<col style="width:100px" />
		<col style="width:50px" />
		<col style="width:50px" />
	</colgroup>
	<thead>
		<tr>
			<th scope="col">선택</th>
			<th scope="col">구분</th>
			<th scope="col">내용</th>
			<th scope="col">등록일시</th>
			<th scope="col">등록자</th>
			<th scope="col">조치구분</th>
			<th scope="col">조치내용</th>
			<th scope="col">조치변경일</th>
			<th scope="col">조치자</th>
			
		</tr>
	</thead>
	<tbody id="issue_wrap">
	</tbody>
</table>
<!--// list -->
<div class="btn_wrap">
	<div class="floatL">
		<button type="button" class="btn_ico_list" onclick="goList();"><span>목록</span></button>
	</div>
	<div class="floatR">
		<button type="button" class="btn_ico_confirm" onclick="proc();"><span>저장</span></button>
		<button type="button" class="btn_ico_cancel" onclick="goList('cancel');"><span>취소</span></button>
		<button type="button" class="btn_ico_reset dgray w100" onclick="goReset();"><span>이전초기화</span></button>
	</div>
</div>
</form>


<!-- erpcode 레이어팝업 -->
<div id="erpCodeLayer" style="display: none;" >
	<div class="box_layer layer_sms" style="height: 540px; width: 1000px; margin-top: -300px; margin-left:-500px;">
		<h1 >ERP 이력 리스트</h1>
		<div class="layer_contents" style="padding-top: 20px; overflow-y:visible;">
			<h3 class="tit_sWrap">ERP 이력 리스트</h3>
			
			<table class="hType mgb10">
				<caption>erpCode</caption>
				<colgroup>
					<col style="width: 50px">
					<col style="width: *">
					<col style="width: 120px">
					<col style="width: 130px">
					<col style="width: 100px">
					<col style="width: 150px">
					<col style="width: 180px">
					<col style="width: 80px">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">ERP코드</th>
						<th scope="col">사업자등록명</th>
						<th scope="col">사업자등록번호</th>
						<th scope="col">법인등록번호</th>
						<th scope="col">대표자</th>
						<th scope="col">등록자[아이디]</th>
						<th scope="col">등록일</th>
						<th scope="col">삭제</th>
					</tr>
				</thead>
				<tbody style="overflow-x:auto;max-height:100px" id="erpHistListBody">
				</tbody>
			</table>
			<div class="btn_wrap mgt20">
					<div class="floatR">
						<button type="button" class="btn_ico_cancel" onclick="javascript:closeErpCodeLayer();">
							<span>창 닫기</span>
						</button>
					</div>
				</div>
		</div>
		
		<button type="button" class="btn_close" onclick="javascript:closeLayer();">창 닫기</button>
	</div>
	<div class="layer_dimmed"></div>
</div>


<div class="box_layer layer_sms" style="margin-top:-300px ;height:auto;min-height:650px; display:none;" id="searchErpInfoDiv">
<h1>거래처 정보 조회 검색 결과</h1>
<div class="layer_contents pdt20" style="height:657px;">
	기관명:
	<input type="text" class="w175 mgr10" id="search_cust_nm" name="search_cust_nm" title="거래처 정보 검색"  autofocus="autofocus" />
	거래처 등록여부:
	<select id="is_yn" class="w175 mgr10"></select>
	
	<button type="button" class="btn_ico_search mgr5" onclick="javascript:custList(1);"><span>검색</span></button>
	<table class="vType_line" style="margin-top: 10px">
		<caption>거래처 정보 목록</caption>
		<colgroup>
			<col style="width:50px;" />
			<col style="width:80px;" />
			<col style="width:150px;" />
			<%-- <col style="width:100px;" />--%>
			<col style="width:100px;" />
			<col style="width:auto;" />
			<col style="width:70px;" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">No</th>
				<th scope="col">ERP코드</th>
				<th scope="col">고객(업체)명</th>
				<!-- <th scope="col">업태</th>-->
				<th scope="col">업종</th>
				<th scope="col">주소</th>
				<th scope="col">라이너스 등록여부</th>
			</tr>
		</thead>
		<tbody id="custInfoList"></tbody>
	</table>
	<div class="page" id="layer_pagination" style="margin-top: 10px;"></div>
</div>
<button type="button" class="btn_close" onclick="javascript:closeLayer(1);">창 닫기</button>
</div>
<div class="layer_dimmed" style="display:none;" id="div1_dim"></div>



<div class="box_layer layer_sms" style="margin-top:-300px;display:none;height:510px;" id="empLayer">
<h1>직원 정보 조회 검색 결과</h1>
<div class="layer_contents pdt20" style="height:480px;">
	직원명:
	<input type="text" class="w175 mgr10" id="searchKorName" name="searchKorName" title="직원 명">
	<button type="button" class="btn_ico_search mgr5" onclick="javascript:showEmpLayer(1);"><span>검색</span></button>
	<table class="vType_line" style="margin-top: 10px;">
		<caption>직원 정보 목록</caption>
		<colgroup>
			<col style="width:40px;" />
			<col style="width:160px;" />
			<col style="width:100px;" />
			<col style="width:100px;" />
			<col style="width:60px;" />
			<col style="width:120px;" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">No</th>
				<th scope="col">부서명/팀명</th>
				<th scope="col">사번</th>
				<th scope="col">이름</th>
				<th scope="col">직책</th>
				<th scope="col">이메일</th>
			</tr>
		</thead>
		<tbody id="empInfoList"></tbody>
	</table>
	<div class="page" id="layer_pagination1" style="margin-top: 10px;"></div>
</div>
<button type="button" class="btn_close" onclick="javascript:closeLayer();">창 닫기</button>
</div>
<div class="layer_dimmed" style="display:none;" id="div_dim"></div>

