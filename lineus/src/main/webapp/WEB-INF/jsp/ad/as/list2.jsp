<%@page import="egovframework.com.comm.util.CommonExecute"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style>
	.status_bold {color:#0032c3 !important;font-weight:bold;}
	.scroll-table{width:1860px;;table-layout:auto;}
	.scroll-table tr:hover{background-color: #eef7f9 !important;}
</style>

<script type="text/javascript">

	var cntdata = 0;
	
	$(document).ready(function(){
		initForm();
		
	}) ;
	
	function initForm(){
		commonCode.getCodeList('AS' , 'CD01' , 'search_type1') ;	//처리상태
		
		$( "#search_start" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#search_end" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		$( "#search_start2" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#search_end2" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		
		if ('${ vo.search_start }' != '') $('#search_start').val('${ vo.search_start }');
		if ('${ vo.search_end }' != '') $('#search_end').val('${ vo.search_end }');
		
		if ('${ vo.search_start2 }' != '') $('#search_start2').val('${ vo.search_start2 }');
		if ('${ vo.search_end2 }' != '') $('#search_end2').val('${ vo.search_end2 }');
		
		var search_type2 = '${ vo.search_type2 }';
		(search_type2 == 'Y') ? $('#search_type2').prop('checked',true) : $('#search_type2').prop('checked',false);
		
		var search_type3 = '${ vo.search_type3 }';
		(search_type3 == 'Y') ? $('#search_type3').prop('checked',true) : $('#search_type3').prop('checked',false);
		
		$('#cust_searh').val('${ vo.cust_searh }');
		
		$('#search_type1').val('${ vo.search_type1 }');
		
		$('#page').val('${ vo.page}') ;
		$('#pageSize').val('${ vo.pageSize}') ;
		
		makeListData();
	}
	
	
	function makeListData() {
		common.ajaxCall($('form[name=listFrm]').serialize(), '/ad/as/getAsList2.do', 'setAsList') ;
	}
	

	function getAsList(pageIndex) {
		var f = document.listFrm ; 
		
		f.page.value = pageIndex ; 
		f.target = '' ; 
		f.action = '/ad/as/list2.do';		
		f.submit() ; 
	}
	
	function setAsList(data) {
		$('#asList').empty();
		
		var resultList = typeof data.resultList != 'undefined' ? data.resultList : null;
		var vo = typeof data.vo != 'undefined' ? data.vo : null;
		
		if (resultList != null && resultList.length > 0) {
			
			
			var toggle = true;
			var prevAsNo = "0";
			
			var str = '' ; 
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ; 
				
				
				
				var chkAsNo = common.nvl(datas.cn_as_no, '') != '' ? datas.cn_as_no: datas.as_no; /* 체크박스 */ 
				if (prevAsNo != chkAsNo){
					prevAsNo = chkAsNo;
					toggle = toggle ? false : true;
				}
				
				// 접수일 날짜를 형식에 맞게 셋팅
				var vAcceptDt = "-";   
				if (common.nvl(datas.accept_dt, '').length == 8){
					vAcceptDt = makeDate(datas.accept_dt,"-");
		 		}
				//완료일 날짜를 형식에 맞게 셋팅
				var vCompleteDt = "-";
				if (common.nvl(datas.complete_dt, '').length == 8){
					vCompleteDt = makeDate(datas.complete_dt,"-");
		 		}
				
				
				// 검수일 날짜를 조정
				var vStateDate = common.nvl(datas.star_state_date, '-');  
				if (vStateDate.length > 10) vStateDate = vStateDate.substr(0,10);
				
				str += '<tr>';
				//하위건
				str += '		<td>'+common.nvl(datas.as_no, '')+'</td> ' ;
				if(common.nvl(datas.appr_yn, '') == 'Y'){
					str += '<td>결재</td> ' ;
				} else if(common.nvl(datas.appr_yn, '') == 'N'){
					str += '<td>미결</td> ' ;
				} else if(common.nvl(datas.appr_yn, '') == 'R'){
					str += '<td>부결</td> ' ;
				} else {
					str += '<td>-</td> ' ;
				}
				
				/* 상태 */
				if( common.nvl(datas.proc_status, '') == "C001" ){
					str += '		<td class="status_bold">'+common.nvl(datas.proc_status_nm, '')+'</td> ' ;
				}else{
					str += '		<td>'+common.nvl(datas.proc_status_nm, '')+'</td> ' ;
				}
				
				
				/* 거래처 코드_거래처명 */
				str += '		<td class="textL">['+common.nvl(datas.cust_code, '')+']'+common.nvl(datas.cust_kor_name,'')+'</td> ' ;
				
				/* 요청자명 */
				str += '		<td>'+common.nvl(datas.apply_nm, '')+'</td> ' ;
				
				
				/* 문의서비스 */
				str += '		<td >'+common.nvl(datas.system_type_nm, '')+'/'+common.nvl(datas.inquiry_type_nm, '')+'</td> ' ;
				/* 중요도 */
				if (common.nvl(datas.inportance_nm, '') != '') {
					if (common.nvl(datas.inportance, '') == 'C001') str += '		<td><span class=""></span>'+common.nvl(datas.inportance_nm, '')+'</td> ' ;
					else str += '		<td><span class=""></span>'+common.nvl(datas.inportance_nm, '')+'</td> ' ;					
				} else {
					str += '		<td>-</td> ' ;
				}
				
				/* 처리담당자 */
				str += '		<td>'+common.nvl(datas.emp_nm , '')+'</td> ' ;
				
				/*답변 */
				if (common.nvl(datas.aws_cnt, '0') == '0') {
					str += '		<td>' +common.nvl(datas.total_aws_cnt, '')+ '</td>';
				} 
				
				/* 접수경로 */
				str += '		<td>'+common.nvl(datas.accept_route_nm , '')+'</td> ' ;
				
				/* 문의내용 */
				str += '<td class="textL">' + datas.call_content.substr(0 , 33) +'</td> ' ;
				/* 조치내용 */
				str += '<td class="textL">' + datas.action_content.substr(0 , 33) +'</td> ' ;
				
				/* 접수일 */
				str += '		<td>'+vAcceptDt+'</td> ' ;
				/* 처리완료일 */
				str += '		<td>'+vCompleteDt+'</td> ' ;
				
				/* 원인유형 */
				if(common.nvl(datas.cause_type_nm, '') != '') str += '		<td title="'+datas.cause_type_nm+'">'+datas.cause_type_nm.substr(0 , 3)+'</td> ' ;
				else  str += '		<td>-</td> ' ;
				/* 조치유형 */
				str += '		<td>'+common.nvl(datas.action_type_nm, '')+'</td> ' ;
				/*검수일 */
				str += '		<td>'+vStateDate+'</td> ' ;	
				
				/* 고객평가★ */
				var starCnt = common.nvl(datas.star_state, '');
				var starText = '';
				if (starCnt == 1) starText = '★☆☆☆☆';
				else if (starCnt == 2) starText = '★★☆☆☆';
				else if (starCnt == 3) starText = '★★★☆☆';
				else if (starCnt == 4) starText = '★★★★☆';
				else if (starCnt == 5) starText = '★★★★★';
				else starText = '-';
				if(starText != "-") str += '		<td class="colorRed">'+starText+'</td> ' ;
				else str += '<td>'+starText+'</td> ' ;
				
				
				/* 끝tr */
				str += '</tr> ' ;
			}
			$('#asList').append(str);	
			$('#count').html(numberWithCommas(vo.rowCnt)); 
			$("#pagination").html(vo.json_paging);
			
		} else {
			commonTable.notData(18,"조회된 데이터가 없습니다.","asList");
			$('#count').html('0');
			$("#pagination").html('');
		}
	}
	
	
	
	function showCustLayer(num){
		$('#custLayer').show() ; 
		$('#custLayer_dim').show() ; 
		$('#custLayer').css('height' , '710') ;
		$('#searchKorName').val('');
		custList(1);
		$("#searchKorName").attr( "autofocus","autofocus" );
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
		$('#layer_pagination1').empty() ; 
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var vo = typeof data.vo != "undefined" ? data.vo : null ; 
		
		if(resultList != null && resultList.length > 0){
			var str = '' ; 
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ;
				var num = (i + 1) ; 
				cntdata = num;
				str += '<tr ondblclick="javascript:setValue(\''+num+'\');" style="cursor:pointer;"> ' ;
				str += '	<td  id="rnum'+num+'">'+common.nvl(datas.rnum , '')+'</td> ' ;
				str += '	<td>';
				str += ' 		<input type="checkbox" title="선택" id="chk'+num+'" name="chk" value="" />'	;
				str += '	</td>';
				str += '	<td  id="cust_gubun_nm'+num+'">'+common.nvl(datas.cust_gubun_nm , '')+'</td> ' ;
				str += '	<td  id="cust_kor_name'+num+'">'+common.nvl(datas.cust_kor_name , '')+'</td> ' ;
				str += '	<td  id="erp_code'+num+'">'+common.nvl(datas.erp_code , '')+ '</td> ' ;
				str += '	<td  id="ceo'+num+'">'+common.nvl(datas.ceo , '')+'</td> ' ;
				str += '</tr> ' ;
				
			}
			$('#custInfoList').append(str) ; 
			$('#layer_pagination1').html(vo.json_paging) ; 
		}else{
			commonTable.notData(6 , '조회된 정보가 없습니다.' , 'custInfoList') ; 
		}
	}
	
	function setValue(index){
		var custChecked = "";
		var cntDataCurrent = cntdata;
		var datachecked = 0;
		
		for(var i = 1 ; i <= cntDataCurrent ; i++){
			if($('#chk' + i).is(":checked")){
				custChecked += "," + $('#erp_code'+i).html();
				datachecked++;
			}
		}
		if(datachecked > 0){
			$('#cust_searh').val(custChecked.substr(1));
		} else {
			$('#cust_searh').val($('#erp_code'+ index).html())
		}
		
		closeCustLayer() ; 
	}
	
	function conFirmCustlayer(){
		setValue();
	}
	
	function closeCustLayer() {
		$('#custLayer').hide() ; 
		$('#custLayer_dim').hide() ; 
		$('#searchEmpName').val('') ; 
		$("#searchEmpName").removeAttr( "autofocus" );
	}
	
	function goExl() {
		
		var totalCnt = Number($('#count').html().replace(",",""));
	
		if(totalCnt == 0){
			alert("출력 가능한 데이터가 없습니다.") ; 
			return ;
			
		}/* else if (totalCnt > 6000){
			alert("6000건 이상의 데이터를 다운로드 할수 없습니다.\r\n기간 검색을 이용하여 조회건수를 조절하신 후 사용하세요") ; 
			return ;	2021.03.09 이설아 수정
		} */else{
			var f = document.listFrm ; 
			
			try{
				$("#exlFrame").remove() ;
			}catch(e){}
			
			var downFrame = $('<iframe id="exlFrame" name="exlFrame" style="width:0px; height=0px ; display:none;"></iframe>') ; 
			downFrame.appendTo("body") ;
			
			f.target = "exlFrame" ; 
			f.action = "/ad/as/exl2.do" ; 
			f.submit() ; 
		}
	}
	
</script>


<div class="tit_wrap" >
	<%= CommonExecute.returnLineMap(request) %>
	
</div>

<form name="listFrm" id="listFrm" method="get">
<input type="hidden" name="pageType" id="pageType" value=""/>
<input type="hidden" name="as_no" id="as_no" value=""/>
<input type="hidden" name="cn_as_no" id="cn_as_no" value=""/>
<input type="hidden" name="page" id="page" value="${ vo.page }" />

<table class="sType mgb10">
	<caption>A/S 접수 리스트 검색</caption>
	<colgroup>
		<col style="width:50px;" />
		<col style="width:225px;" />
		<col style="width:50px;" />
		<col style="width:275px;" />
	</colgroup>
	<tbody id="asSearchTbody">
		<tr> 
			<th scope="row">처리상태</th> 
			<td> 
				<select name="search_type1" id="search_type1" title="처리상태 선택"></select> 
			</td> 
			<th scope="row">접수일자</th> 
			<td> 
				<input type="checkbox" name="search_type2" id="search_type2" value="Y" class="mgr5">
				<input type="text" name="search_start" id="search_start" title="접수일 입력" class="w135 mgr2" value=""  readonly="readonly"/> 
				<input type="text" name="search_end" id="search_end" title="접수일 입력" class="w135 mgl10 mgr2" value="" readonly="readonly"/> 
			</td> 
			
		</tr>
		<tr> 
			<th scope="row">거래처</th>
			<td>
				<input class="" type="text" name="cust_searh" id="cust_searh" title="" placeholder="" style="width:90%;"/>
				<button type="button" class="btn_ico_search_s" onclick="javascript:showCustLayer('1');"><span></span></button>
			</td>
			<th scope="row">처리요청일</th> 
			<td> 
				<input type="checkbox" name="search_type3" id="search_type3" value="Y" class="mgr5">
				<input type="text" name="search_start2" id="search_start2" title="" class="w135 mgr2" value=""  readonly="readonly"/> 
				<input type="text" name="search_end2" id="search_end2" title="" class="w135 mgl10 mgr2" value=""  readonly="readonly"/> 
			</td> 
		</tr>
	</tbody>
	
</table>
<div class="info_upper mgb5">
	<div class="sorting">
		조회건수 : <strong><span class="count" id="count">0</span> 건</strong>
	</div>
	<div class="floatR">
		<button type="button" class="btn_ico_search mgr5" onclick="javascript:getAsList(1);"><span>조회</span></button>
		<button type="button" class="btn_ico_excel" onclick="goExl();"><span>엑셀다운로드</span></button>
		<select id="pageSize" name="pageSize"  onchange="getAsList(1);" title="리스트 행 선택" class="w140">
			<option value="10">10개씩 노출</option>
			<option value="30">30개씩 노출</option>
			<option value="50">50개씩 노출</option>
		</select>
	</div>
</div>

<div style="overflow-x:auto;">
<table class="hType mgb10 scroll-table" >
	<caption>A/S 접수 목록</caption>
	<colgroup>
		<col style="width:80px" /><!--접수번호-->
		<col style="width:80px" /><!--승인여부-->
		<col style="width:70px" /><!--처리상태-->
		<col style="width:auto" /><!--거래처명-->
		
		<col style="width:70px" /><!--요청자-->
		
		<col style="width:150px" /><!--문의서비스-->
		<col style="width:60px" /><!--중요도-->
		<col style="width:70px" /><!--처리담당자-->
		<col style="width:50px" /><!--신규답변-->
		
		<col style="width:100px" /><!--접수경로-->
		
		
		<col style="width:300px" /><!--문의내용-->
		<col style="width:300px" /><!--조치내용-->
		<col style="width:70px" /><!--접수일-->
		<col style="width:70px" /><!--처리완료일-->
		<col style="width:50px" /><!--원인유형-->
		<col style="width:50px" /><!--조치유형-->
		<col style="width:70px" /><!--검수일-->
		<col style="width:60px" /><!--고객평가-->
		
	</colgroup>
	<thead>
		<tr>
			
			<th scope="col">접수번호</th>
			<th scope="col">승인여부</th>
			<th scope="col">처리상태</th>
			<th scope="col">거래처명</th>
			<th scope="col">요청자</th>
			<th scope="col">문의서비스</th>
			<th scope="col">중요도</th>
			<th scope="col">처리담당자</th>
			<th scope="col">신규답변</th>
			<th scope="col">접수경로</th>
			<th scope="col">문의내용</th>
			<th scope="col">조치내용</th>
			<th scope="col">접수일</th>
			<th scope="col">처리완료일</th>
			<th scope="col">원인유형</th>
			<th scope="col">조치유형</th>
			<th scope="col">검수일</th>
			<th scope="col">고객평가</th>
			
		</tr>
	</thead>
	<tbody id="asList"></tbody>
</table>

</div>
<div class="page">
	<div id="pagination"></div>
</div>




<div class="box_layer layer_sms" style="margin-top:-300px; display:none;height:600px;" id="custLayer">
<h1>거래처 정보 조회 검색 결과</h1>
<div class="layer_contents pdt20" style="height:500px;">
	기관명:
	<input type="text" class="w175 mgr10" id="searchKorName" name="searchKorName" title="거래처 정보 검색"  autofocus="autofocus" />
	<button type="button" class="btn_ico_search mgr5" onclick="javascript:custList();"  ><span>검색</span></button>
	<button type="button" class="btn_ico_confirm" onclick="javascript:conFirmCustlayer();"><span>확인</span></button>
	<table class="vType_line" style="margin-top: 10px">
		<caption>거래처 정보 목록</caption>
		<colgroup>
			<col style="width:50px;" />
			<col style="width:50px;" />
			<col style="width:100px;" />
			<col style="width:180px;" />
			<col style="width:100px;" />
			<col style="width:100px;" />
			
		</colgroup>
		<thead>
			<tr>
				<th scope="col">No</th>
				<th scope="col">선택</th>
				<th scope="col">거래처구분</th>
				<th scope="col">거래처명</th>
				<th scope="col">거래처 코드</th>
				<th scope="col">대표자</th>
			</tr>
		</thead>
		<tbody id="custInfoList"></tbody>
	</table>
	<div class="page" id="layer_pagination1" style="margin-top: 10px;"></div>
</div>
<button type="button" class="btn_close" onclick="javascript:closeCustLayer(1);">창 닫기</button>
</div>
<div class="layer_dimmed" style="display:none;" id="custLayer_dim"></div>
</form>
<form name="answerForm" id="answerForm" method="post" enctype="multipart/form-data">
<input type="hidden" name="w_content" />
<input type="hidden" name="as_no" />
<input type="hidden" name="seq" />
<input type="hidden" name="pageType" />
</form>