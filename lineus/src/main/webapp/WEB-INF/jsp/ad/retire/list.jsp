<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javascript">
	$(document).ready(function(){
		
		
		/**	공통 코드 처리 */
		//commonCode.getCodeList('RETIRE' , 'RT01' , 'search_type2') ; 	
		commonCode.getCodeList('RETIRE' , 'RT02' , 'search_type1') ; 	
		commonCode.getCodeList('RETIRE' , 'RT03' , 'search_type4') ; 	
		
		//검색일자 초기값 설정(90일 단위 검색)
		var searchStart = new Date();
		searchStart.setMonth(searchStart.getMonth() - 3);
		
		$("#search_start" ).val($.datepicker.formatDate('yy/mm/dd', searchStart)).datepicker(datepicker);
		$("#search_end" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		if ('${ vo.search_start }' != '') $('#search_start').val('${ vo.search_start }');
		if ('${ vo.search_end }' != '') $('#search_end').val('${ vo.search_end }');
		$('#search_text').val('${ vo.search_text}') ; 
		$('#search_type1').val('${ vo.search_type1 }') ; 
		$('#search_type4').val('${ vo.search_type4 }') ; 
		$('#page').val('${ vo.page}') ; 
		$('#pageSize').val('${ vo.pageSize}') ;
		$("#search_text").keyup(function(e){if(e.keyCode == 13)  getRetireList(1); });			//enter키 이벤트
		
		//default : 미완료(C002)
		$('#conf2').prop('checked',true);
		
		var search_type2 = '${ vo.search_type2 }';
		if(search_type2 == "C001") $('#conf1').prop('checked',true);
		else if(search_type2 == "C002") $('#conf2').prop('checked',true);
		else if(search_type2 == "C003") $('#conf3').prop('checked',true);
		
		makeListData() ;   
		
	}) ;
	
	function goClear(){
		document.listFrm.reset() ;
		getRetireList(1);
	}
	
	function getRetireList(page){
		var f = document.listFrm ; 
		f.page.value = page ; 
		f.target = '' ; 
		f.action = '/ad/retire/list.do' ; 
		f.submit() ; 
	}
	
	function makeListData(){
		common.ajaxCall($('form[name=listFrm]').serialize(), '/ad/retire/getRetireList.do', 'setRetireList') ;
	}
	
	function setRetireList(data){
		
		$('#listTbody').empty();
		
		var resultList = typeof data.resultList != 'undefined' ? data.resultList : null;
		var vo = typeof data.vo != 'undefined' ? data.vo : null; 
		
		if(resultList != null && resultList.length > 0){
			
			var str = '' ;
			for(var i = 0 ; i < resultList.length ; i++){
				
				var datas = resultList[i];
				
				var vRetireDate = "-";
				if (common.nvl(datas.retiredt, '').length == 8){
					vRetireDate = makeDate(datas.retiredt,"-");
		 		}
				
				str += "<tr onclick=\"goView('update', '" + datas.userid + "', '" + datas.retiredt + "');\" style=\"cursor:pointer;\">" ;
				str += '	<td>'+common.nvl(datas.rnum , '')+'</td> ' ;		/* 순번 */
				str += '	<td>'+common.nvl(datas.userid , '')+'</td> ' ;		/* 사번 */
				str += '	<td>'+common.nvl(datas.usernm , '')+'</td> ' ;		/* 이름 */
				str += '	<td>'+common.nvl(datas.company_nm , '')+'</td> ' ;	/* 그룹사 */
				str += '	<td>'+common.nvl(datas.deptnm , '')+'</td> ' ;		/* 팀명 */
				str += '	<td>'+vRetireDate+'</td> ' ;						/* 퇴사일 */
																				/* 퇴사유형*/			
				if(common.nvl(datas.retire_flag , '') == 'C002'){				
					str += '	<td>사간이동</td> ' ;
				}else{
					str += '	<td>퇴사</td> ' ;
				}
				str += '	<td>'+common.nvl(datas.conf , '')+'</td> ' ;		/* 확인완료 */
				str += '</tr> ' ;
			}
			
			$('#listTbody').append(str);
			$('#count').html(vo.rowCnt) ; 
			$("#pagination").html(vo.json_paging);
		}else{
			commonTable.notData(8 , '조회된 정보가 없습니다.' , 'listTbody') ; 
			$('#count').html('0') ; 
			$("#pagination").html('');
		}
		
	}
	
	function goView(pageType , userid, retiredt){
		
		var f = document.listFrm ; 
		
		f.pageType.value = pageType ; 
		f.userid.value = userid ; 
		f.retiredt.value = retiredt ; 
		
		f.target = '' ; 
		f.action = '/ad/retire/form.do' ; 
		f.submit() ; 
	}
	
	
	function goExl(){
		var flag = $('#count').html() > 0 ? 'T' : 'F' ;
		
		if(flag == 'T'){
			
			var f = document.listFrm ; 
			
			try{
				$("#exlFrame").remove() ;
			}catch(e){}
			
			var downFrame = $('<iframe id="exlFrame" name="exlFrame" style="width:0px; height=0px ; display:none;"></iframe>') ; 
			downFrame.appendTo("body") ;
			
			f.target = "exlFrame" ; 
			f.action = "/ad/retire/exl.do" ; 
			f.submit() ; 
			
		}else{
			alert("출력 가능한 데이터가 없습니다.") ; 
			return ; 
		}
	}
	
</script>
<div class="tit_wrap">
	<h2 class="tit_ico_admin">퇴사자 관리<span class="tit_depth no_arrow mgl10 mgt8">검색 조건을 선택해 주세요.</span></h2>
	<div class="location">
		<a href="/ad/main/list.do" class="home">Home</a>
		<a href="/ad/retire/list.do" class="depth"><span class="here">퇴사자 관리</span></a>
	</div>
</div>

<div class="tit_sWrap">
	<h3 class="tit_dot_gray">계정 정보</h3>
</div>

<form name="listFrm" id="listFrm" method="get" onsubmit="return false;">
	<input type="hidden" name="pageType" id="pageType" value=""/>
	<input type="hidden" name="page" id="page" value="${ vo.page }" />
	<input type="hidden" name="userid" id="userid" value="" />
	<input type="hidden" name="retiredt" id="retiredt" value="" />


<table class="sType mgb10">
	<caption>계정 정보</caption>
	<colgroup>
		<col style="width:140px;" />
		<col style="width:195px;" />
		<col style="width:140px;" />
		<col style="width:195px;" />
		<col style="width:140px;" />
		<col style="width:190px;" />
	</colgroup>
	<tr>
		<th scope="row">그룹사 구분</th>
		<td>
			<select name="search_type1" id="search_type1" title="그룹사 선택" class="w155"></select>
		</td>
		<th scope="row">확인완료 구분</th>
		<td>
			<input type="radio" class="mgr5" name="search_type2" id="conf2" value="C002" style="margin-right:5px;">미완료
			<input type="radio" class="mgl10 mgr5" name="search_type2" id="conf1" value="C001" style="margin-right:5px;">완료
			<input type="radio" class="mgl10 mgr5" name="search_type2" id="conf3" value="C003" style="margin-right:5px;">전체
		</td>
		<th scope="row">퇴사유형</th>
		<td>
			<select name="search_type4" id="search_type4" title="퇴사유형 선택" class="w155"></select>
		</td>
	</tr>
	<tr >
		<th scope="row">퇴사일</th>
		<td colspan="5">
			<input type="text" class="w155 mgr10" id="search_start" name="search_start" title="시작 날짜" readonly="readonly" value="" />
			<span class="txt_wave">~</span>
			<input type="text" class="w155 mgr10" id="search_end" name="search_end" title="끝나는 날짜" readonly="readonly" value="" />
		</td>
	</tr>
	<tr>
		<th scope="row">통합 검색 키워드</th>
		<td colspan="5">
			<input type="text" class="w640 mgr5" id="search_text" name="search_text" title="통합 검색 키워드 입력" placeholder="퇴사자 사번 /이름 /그룹사 코드 /그룹사명 /팀명 ">
			<button type="button" class="btn_ico_reset" onclick="javascript:goClear();"><span>초기화</span></button>&nbsp;
			<button type="button" class="btn_ico_search" onclick="javascript:getRetireList(1);"><span>검색</span></button>
		</td>
	</tr>
</table>

<div class="info_upper mgb5">
	<div class="sorting">
		조회건수 : <strong><span class="count" id="count">0</span> 건</strong>
	</div>
	<div class="floatR">
		<button type="button" class="btn_ico_excel" onclick="javascript:goExl();"><span>엑셀다운로드</span></button>
		<select id="pageSize" name="pageSize" title="리스트 행 선택" class="w140" onchange="javascript:getRetireList(1);">
			<option value="10">10개씩 노출</option>
			<option value="50">50개씩 노출</option>
			<option value="80">80개씩 노출</option>
			<option value="100">100개씩 노출</option>
		</select>
	</div>
</div>

</form>

<table class="hType mgb10">
	<caption>관리 계정 내역</caption>
	<colgroup>
		<col style="width:50px">
		<col style="width:30px">
		<col style="width:auto">
	</colgroup>
	<thead>
		<tr>
			<th scope="col">No</th>
			<th scope="col">사번</th>
			<th scope="col">이름</th>
			<th scope="col">그룹사</th>
			<th scope="col">팀명</th>
			<th scope="col">퇴사일</th>
			<th scope="col">퇴사유형</th>
			<th scope="col">확인완료</th>
		</tr>
	</thead>
	<tbody id="listTbody"></tbody>
</table>
<!-- page -->
<div class="page">
	<div id="pagination"></div>
</div>