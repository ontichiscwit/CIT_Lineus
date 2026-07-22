<%@page import="egovframework.com.comm.util.CommonExecute"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>


<style>
	.status_bold {color:#0032c3 !important;font-weight:bold;}
	.scroll-table{table-layout:auto;}
	.scroll-table tr:hover{background-color: #eef7f9 !important;}

	
</style>

<script type="text/javascript">

	var cntdata = 0;
	
	$(document).ready(function(){
		initForm();
		makeListData();
	}) ;
	
	function initForm(){
		
		commonCode.getCodeList('PROJECT' , 'PR02' , 'search_type7') ; //시스템구분
		commonCode.getCodeList('CUST' , 'CD01' , 'search_type13') ;	  //거래처구분
		$( "#search_start" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$( "#search_end" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		
		if ('${ vo.search_type7 }' != '') $('#search_type7').val('${ vo.search_type7 }');		//다시 프론트로 돌아왔을 때 검색조건 고정되도록
		if ('${ vo.search_type13 }' != '') $('#search_type13').val('${ vo.search_type13 }');	//다시 프론트로 돌아왔을 때 검색조건 고정되도록
		if ('${ vo.search_start }' != '') $('#search_start').val('${ vo.search_start }');
		if ('${ vo.search_end }' != '') $('#search_end').val('${ vo.search_end }');
		
		
	}
	
	
	function makeListData() {
		
		common.ajaxCall($('form[name=listFrm]').serialize(), '/ad/as/getAsList4.do', 'setAsList') ;
	}

	function getAsList() {
		
		var f = document.listFrm ; 
		console.log(document.listFrm.search_type7.value);	
		f.target = '' ; 
		f.action = '/ad/as/list4.do' ; 				
		f.submit() ; 
	}
	
	function setAsList(data) {
		$('#asList').empty();
		
		var resultList = typeof data.resultList != 'undefined' ? data.resultList : null;
		var vo = typeof data.vo != 'undefined' ? data.vo : null;
		
		if (resultList != null && resultList.length > 0) {
			
			var prevAsNo = "0";
			
			var str = '' ; 
			for(var i = 0 ; i < resultList.length ; i++){
				
				
				var datas = resultList[i] ;
				
				
				/*순번*/
				if(datas.rnum == resultList.length){
					str += '<tr class="stats_tr_total"><td></td>'
				}else{
					str+='<tr><td>'+datas.rnum +'</td>'
				}
				
				/*시스템타입*/
				str += '<td class="textL pdl8">'+common.nvl(datas.system_type,'') +'</td>'
				
				/*시스템*/
				if( common.nvl(datas.system_type_nm,'')!= ''){
					str += '<td class="textL pdl8 stats_borderRight">'+datas.system_type_nm +'</td>'
				}else{
					str += '<td class="textL pdl8"><b>총계</b></td>'
				}
				
				/*전년도-합계*/
				str += '<td class="textR pdr8">'+numberWithCommas(datas.jcnt_tot) +'</td>'
				
				/*전년도-프로그램*/
				str += '<td class="textR pdr8">'+numberWithCommas(datas.jcnt1) +'</td>'
				
				/*전년도-데이터*/
				str += '<td class="textR pdr8">'+numberWithCommas(datas.jcnt2) +'</td>'
				
				/*전년도-권한*/
				str += '<td class="textR pdr8">'+numberWithCommas(datas.jcnt3) +'</td>'
				
				/*전년도-기타*/
				str += '<td class="textR pdr8 stats_borderRight">'+numberWithCommas(datas.jcnt4) +'</td>'
				
				/*조회기간-합계*/
				str += '<td class="textR pdr8">'+ numberWithCommas(datas.cnt_tot) +'</td>'
				
				/*조회기간-프로그램*/
				str += '<td class="textR pdr8">'+numberWithCommas(datas.cnt1) +'</td>'
				
				/*조회기간-데이터*/
				str += '<td class="textR pdr8">'+numberWithCommas(datas.cnt2) +'</td>'
				
				/*조회기간-권한*/
				str += '<td class="textR pdr8">'+numberWithCommas(datas.cnt3) +'</td>'
				
				/*조회기간-기타*/
				str += '<td class="textR pdr8 stats_borderRight">'+numberWithCommas(datas.cnt4) +'</td>'
				
				/*누적-합계*/
				str += '<td class="textR pdr8">'+ numberWithCommas(datas.ncnt_tot) +'</td>'
		
				/*누적-프로그램*/
				str += '<td class="textR pdr8">'+numberWithCommas(datas.ncnt1) +'</td>'
				
				/*누적-데이터*/
				str += '<td class="textR pdr8">'+numberWithCommas(datas.ncnt2) +'</td>'
				
				/*누적-권한*/
				str += '<td class="textR pdr8">'+numberWithCommas(datas.ncnt3) +'</td>'
				
				/*누적-기타*/
				str += '<td class="textR pdr8">'+numberWithCommas(datas.ncnt4) +'</td>'
				
				str += '</tr>'
				
			}
			$('#asList').append(str);
			$('#count').html(numberWithCommas(vo.rowCnt));
			$('#lastYear').html('전년도 ('+ (new Date().getFullYear()-1) +'년)');
			$('#thatMonth').html('조회기간 ('+ vo.search_start +' ~ '+ vo.search_end +')'); 
			$('#nextYear').html('누적 ('+ new Date().getFullYear() +'/01/01'+ ' ~ '+ vo.search_end +')'); 
			
			
		} else {
			commonTable.notData(18,"조회된 데이터가 없습니다.","asList");
			$('#count').html('0');
		}
	
	}
	
	function goExl() {
		
		var totalCnt = Number($('#count').html().replace(",",""));
	
		if(totalCnt == 0){
			alert("출력 가능한 데이터가 없습니다.") ; 
			return ;
			
		}else if (totalCnt > 6000){
			alert("6000건 이상의 데이터를 다운로드 할수 없습니다.\r\n기간 검색을 이용하여 조회건수를 조절하신 후 사용하세요") ; 
			return ;
		}else{
			var f = document.listFrm ; 
			
			try{
				$("#exlFrame").remove() ;
			}catch(e){}
			
			var downFrame = $('<iframe id="exlFrame" name="exlFrame" style="width:0px; height=0px ; display:none;"></iframe>') ; 
			downFrame.appendTo("body") ;
			
			f.target = "exlFrame" ; 
			f.action = "/ad/as/exl4.do" ; 
			f.submit() ; 
			
		}
	}

	
	
</script>



<div class="tit_wrap" >
	<%= CommonExecute.returnLineMap(request) %>
	
</div>
<form name="listFrm" id="listFrm" method="get">

	<table class="sType mgb10">
		<caption>A/S 접수 리스트 검색</caption>
		<colgroup>
			<col style="width:140px;" />
			<col style="width:auto;" />
		</colgroup>
		<tbody id="asSearchTbody">
			<tr> 
				<th scope="row">시스템</th> 
				<td>
					<select name="search_type7" id="search_type7" title="문의유형1 선택" class="w300 mgr2"></select> 
				</td>
			</tr>	
			<tr>	
				<th scope="row">거래처구분</th> 
				<td> 
					<select  name="search_type13" id="search_type13" title="거래처구분 선택" class="w300 mgr2"></select> 
				</td> 
			</tr>
			<tr>
				<th>검색일자</th>
				<td>
					<input type="checkbox" name="search_type10" id="search_type10" value="Y" class="mgr5">
					<input type="text" name="search_start" id="search_start" title="접수일 입력" class="w135 mgr2" value=""  readonly="readonly"/> 
					<input type="text" name="search_end" id="search_end" title="접수일 입력" class="w135 mgl10 mgr2" value="" readonly="readonly"/> 
				</td>
			</tr>
		</tbody>
	</table>
	<div class="info_upper mgb5">
		<div class="sorting">
			조회건수 : <strong><span class="count" id="count">0</span> 건</strong>
		</div>
		<div class="floatR">
			<button type="button" class="btn_ico_search mgr5" onclick="javascript:getAsList();"><span>조회</span></button>
			<button type="button" class="btn_ico_excel" onclick="goExl();"><span>엑셀다운로드</span></button>
		</div>
	</div>

	<div style="overflow-x:auto;">
		<table class="stats_hType mgb10 scroll-table" >
			<caption>A/S 접수 목록</caption>
			<thead>
				<tr>
					<th scope="col" rowspan="2">순번</th>
					<th scope="col" rowspan="2">시스템 타입</th>
					<th scope="col" rowspan="2">시스템</th>
					<th scope="col" colspan="5" id="lastYear">전년도</th>
					<th scope="col" colspan="5" id="thatMonth">조회기간</th>
					<th scope="col" colspan="5" id="nextYear">누적</th>
				</tr>
				<tr>
					<th scope="col">합계</th>
					<th scope="col">프로그램</th>
					<th scope="col">데이터</th>
					<th scope="col">권한</th>
					<th scope="col">기타</th>
					<th scope="col">합계</th>
					<th scope="col">프로그램</th>
					<th scope="col">데이터</th>
					<th scope="col">권한</th>
					<th scope="col">기타</th>
					<th scope="col">합계</th>
					<th scope="col">프로그램</th>
					<th scope="col">데이터</th>
					<th scope="col">권한</th>
					<th scope="col">기타</th>
					
				</tr>
			</thead>
			<tbody id="asList"></tbody>
		</table>
	</div>
</form>
