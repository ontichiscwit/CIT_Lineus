<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">

	var set1OpCnt = 0;
	
	var listArr;
	
	$(document).ready(function(){
		sessionStorage.setItem("search_type10_checked", true);
		addDepth1Option();
	});
	
	function statList() {
		var f = document.frmList;
		common.ajaxCall($('form[name=frmList]').serialize(), '/ad/stat/getList01List.do', 'setStatList') ;
	}
	
	function setStatList(data) {
		
		$('#statList').empty();
		$('#statHeader').empty();
		
		var resultList = typeof data.resultList != 'undefined' ? data.resultList : null;
		var vo = typeof data.vo != 'undefined' ? data.vo : null;
		
		var HLength = $('[id^=optionTr]').find('[id^=optionC_]').length;
		
		var strHead = '<th scope="col">No.</th>';
		strHead += '<th scope="col">거래처명</th>';
		
		$('#searchOption tr').each(function(index){ 
			if ($('#'+$(this).context.id).find('[id^=optionC_] option:selected').text() != '거래처명') {
				strHead += '<th scope="col">'+$('#'+$(this).context.id).find('[id^=optionC_] option:selected').text()+'</th>';	
			}
		});

		$('#statHeader').append(strHead);
		
		if (resultList != null && resultList.length > 0) {
			
			listArr = resultList;
			
			var str = '' ;
			var arr = [] ; 
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ;
				var data = "" ; 
				
				data = common.nvl(datas.cust_kor_name,'') ; 
				
				for (var h=1; h<=HLength; h++) {
					
					var selector = $('[id^=optionTr'+h+']').find('[id^=optionC_'+h+'] option:selected').val();
					
					if (selector == 'A1') { //거래처명
						//기본
					} else if (selector == 'A2') { //거래처구분
						if(data == "") data = common.nvl(datas.cust_gubun_nm,'') ;
						else data = data + "@@" + common.nvl(datas.cust_gubun_nm,'') ;
					} else if (selector == 'A3') { //병원설립일
						if(data == "") data = common.nvl(datas.foundation_dt,'') ;
						else data = data + "@@" + common.nvl(datas.foundation_dt,'') ;
					} else if (selector == 'A4') { //계약일자
						if(data == "") data = common.nvl(datas.contract_dt,'') ;
						else data = data + "@@" + common.nvl(datas.contract_dt,'') ;
					} else if (selector == 'A5') { //이슈관리
						if(data == "") data = common.nvl(datas.action_result_code_nm,'') ;
						else data = data + "@@" + common.nvl(datas.action_result_code_nm,'') ;
					}
					
					
					if (selector == 'B1_1') { //전산오픈일
						if(data == "") data = common.nvl(datas.open_dt,'') ;
						else data = data + "@@" + common.nvl(datas.open_dt,'') ;
					} else if (selector == 'B1_2') { //투입인원
						if(data == "") data = common.nvl(datas.term_person_count,'') ;
						else data = data + "@@" + common.nvl(datas.term_person_count,'') ;
					} else if (selector == 'B1_3') { //담당PM
						if(data == "") data = common.nvl(datas.pm,'') ;
						else data = data + "@@" + common.nvl(datas.pm,'') ;
					} else if (selector == 'B1_4') { //최종검수일
						if(data == "") data = common.nvl(datas.test_dt,'') ;
						else data = data + "@@" + common.nvl(datas.test_dt,'') ;
					} else if (selector == 'B1_5') { //OCS/EMRver
						if(data == "") data = common.nvl(datas.version_nm,'') ;
						else data = data + "@@" + common.nvl(datas.version_nm,'') ;
					} else if (selector == 'B2_1') { //서버구성
						if(data == "") data = common.nvl(datas.formation_code_nm,'') ;
						else data = data + "@@" + common.nvl(datas.formation_code_nm,'') ;
					} else if (selector == 'B2_2') { //OS
						if(data == "") data = common.nvl(datas.os_nm,'') ;
						else data = data + "@@" + common.nvl(datas.os_nm,'') ;
					} else if (selector == 'B2_3') { //유지보수 계약일자
						if(data == "") data = common.nvl(datas.mtac_contract_dt,'') ;
						else data = data + "@@" + common.nvl(datas.mtac_contract_dt,'') ;
					} else if (selector == 'B3_1') { //거래처명
						if(data == "") data = common.nvl(datas.cust_kor_name,'') ;
						else data = data + "@@" + common.nvl(datas.cust_kor_name,'') ;
					} else if (selector == 'B3_2') { //거래처구분
						if(data == "") data = common.nvl(datas.cust_gubun_nm,'') ;
						else data = data + "@@" + common.nvl(datas.cust_gubun_nm,'') ;
					} else if (selector == 'B3_3') { //기타설명
						if(data == "") data = common.nvl(datas.basic_etc,'') ;
						else data = data + "@@" + common.nvl(datas.basic_etc,'') ;
					} else if (selector == 'B4_1') { //병상수
						if(data == "") data = common.nvl(datas.bed_count,'') ;
						else data = data + "@@" + common.nvl(datas.bed_count,'') ;
					} else if (selector == 'B4_2') { //보훈여부
						if(data == "") data = common.nvl(datas.veterans_yn,'') ? "Yes" : "No" ;
						else data = data + "@@" + common.nvl(datas.veterans_yn,'')  ? "Yes" : "No" ;
					} else if (selector == 'B4_3') { //군지역소재
						if(data == "") data = common.nvl(datas.military_yn,'') ? "Yes" : "No" ;
						else data = data + "@@" + common.nvl(datas.military_yn,'') ? "Yes" : "No" ;
					} else if (selector == 'B4_4') { //기존전산업체
						if(data == "") data = common.nvl(datas.old_company_nm,'') ;
						else data = data + "@@" + common.nvl(datas.old_company_nm,'') ;
					} else if (selector == 'B4_5') { //외부수탁업체
						if(data == "") data = common.nvl(datas.outside_cust_code_nm,'') ;
						else data = data + "@@" + common.nvl(datas.outside_cust_code_nm,'') ;
					} else if (selector == 'B5_1') { //담당구분
						if(data == "") data = common.nvl(datas.charge_code_nm,'') ;
						else data = data + "@@" + common.nvl(datas.charge_code_nm,'') ;
					} else if (selector == 'B5_2') { //담당자명
						if(data == "") data = common.nvl(datas.charge_nm,'') ;
						else data = data + "@@" + common.nvl(datas.charge_nm,'') ;
					} 
					
					
					if (selector == 'C1_1') { //거래상태
						if(data == "") data = common.nvl(datas.deal_code_nm,'') ;
						else data = data + "@@" + common.nvl(datas.deal_code_nm,'') ;
					} else if (selector == 'C1_2') {  //HIS(모듈별)
						
						var moduleTotal = '';
						
						if (common.nvl(datas.his_basic_code,'') != '') {
							if (moduleTotal == '') moduleTotal = common.nvl(datas.his_basic_code_nm,'');
							else moduleTotal = moduleTotal + ", " + common.nvl(datas.his_basic_code_nm,'');
						}
						
						if (common.nvl(datas.his_treat_code,'') != '') {
							if (moduleTotal == '') moduleTotal = common.nvl(datas.his_treat_code_nm,'');
							else moduleTotal = moduleTotal + ", " + common.nvl(datas.his_treat_code_nm,'');
						}						
						
						if (common.nvl(datas.his_work_code,'') != '') {
							if (moduleTotal == '') moduleTotal = common.nvl(datas.his_work_code_nm,'');
							else moduleTotal = moduleTotal + ", " + common.nvl(datas.his_work_code_nm,'');
						}						
						
						if (common.nvl(datas.his_claim_code,'') != '') {
							if (moduleTotal == '') moduleTotal = common.nvl(datas.his_claim_code_nm,'');
							else moduleTotal = moduleTotal + ", " + common.nvl(datas.his_claim_code_nm,'');
						}						

						if(data == "") {
							data = moduleTotal ;
						} else {
							data = data + "@@" + moduleTotal ;
						} 			
						
					} else if (selector == 'C2_1') {  //보훈여부
						if(data == "") data = common.nvl(datas.c_veterans_yn,'') ? "Yes" : "No" ;
						else data = data + "@@" + common.nvl(datas.c_veterans_yn,'')  ? "Yes" : "No" ;		
					} else if (selector == 'C2_2') {  //군지역소재
						if(data == "") data = common.nvl(datas.c_military_yn,'') ? "Yes" : "No" ;
						else data = data + "@@" + common.nvl(datas.c_military_yn,'') ? "Yes" : "No" ;				
					} else if (selector == 'C2_3') {  //선택진료
						if(data == "") data = common.nvl(datas.choice_yn,'') ? "Yes" : "No" ;
						else data = data + "@@" + common.nvl(datas.choice_yn,'')  ? "Yes" : "No" ;				
					} else if (selector == 'C2_4') {  //치과유무
						if(data == "") data = common.nvl(datas.dentist_yn,'') ? "Yes" : "No" ;
						else data = data + "@@" + common.nvl(datas.dentist_yn,'') ? "Yes" : "No" ;
					} else if (selector == 'C2_5') {  //정신과
						if(data == "") data = common.nvl(datas.mental_yn,'') ? "Yes" : "No" ;
						else data = data + "@@" + common.nvl(datas.mental_yn,'') ? "Yes" : "No" ;
					} else if (selector == 'C2_6') {  //한방
						if(data == "") data = common.nvl(datas.oriental_yn,'') ? "Yes" : "No" ;
						else data = data + "@@" + common.nvl(datas.oriental_yn,'') ? "Yes" : "No" ;
					} else if (selector == 'C2_7') {  //혈액투석
						if(data == "") data = common.nvl(datas.hemodialysis_yn,'')  ? "Yes" : "No" ;
						else data = data + "@@" + common.nvl(datas.hemodialysis_yn,'') ? "Yes" : "No" ;
					} else if (selector == 'C2_8') {  //포괄간호
						if(data == "") data = common.nvl(datas.care_yn,'')  ? "Yes" : "No" ;
						else data = data + "@@" + common.nvl(datas.care_yn,'')  ? "Yes" : "No" ;
					
					} else if (selector == 'C2_9') {  //응급실운영
						if(data == "") data = common.nvl(datas.emergencyop_yn,'')  ? "Yes" : "No" ;
						else data = data + "@@" + common.nvl(datas.emergencyop_yn,'')  ? "Yes" : "No" ;					
					} else if (selector == 'C2_10') {  //NEDIS사용
						if(data == "") data = common.nvl(datas.nedis_yn,'')  ? "Yes" : "No" ;
						else data = data + "@@" + common.nvl(datas.nedis_yn,'')  ? "Yes" : "No" ;
					} else if (selector == 'C2_11') {  //마약류연계
						if(data == "") data = common.nvl(datas.narcotics_yn,'')  ? "Yes" : "No" ;
						else data = data + "@@" + common.nvl(datas.narcotics_yn,'')  ? "Yes" : "No" ;					
					} else if (selector == 'C2_12') {  //Ontic Sense
						if(data == "") data = common.nvl(datas.onticsense_yn,'')  ? "Yes" : "No" ;
						else data = data + "@@" + common.nvl(datas.onticsense_yn,'')  ? "Yes" : "No" ;					
					} else if (selector == 'C2_13') {  //van인터페이스
						if(data == "") data = common.nvl(datas.van_yn,'')  ? "Yes" : "No" ;
						else data = data + "@@" + common.nvl(datas.van_yn,'')  ? "Yes" : "No" ;					
					
					} else if (selector == 'C3_1') {  //간호등급
						if(data == "") data = common.nvl(datas.care_grade,'') ;
						else data = data + "@@" + common.nvl(datas.care_grade,'') ;						
					} else if (selector == 'C3_2') {  //기존전산업체
						if(data == "") data = common.nvl(datas.old_company_nm,'') ;
						else data = data + "@@" + common.nvl(datas.old_company_nm,'') ;
					} else if (selector == 'C3_3') {  //외부수탁업체
						if(data == "") data = common.nvl(datas.outside_cust_code_nm,'') ;
						else data = data + "@@" + common.nvl(datas.outside_cust_code_nm,'') ;
					} else if (selector == 'C4_1') {  //OS
						if(data == "") data = common.nvl(datas.os_nm,'') ;
						else data = data + "@@" + common.nvl(datas.os_nm,'') ;
					} else if (selector == 'C5_1') {  //담당구분
						if(data == "") data = common.nvl(datas.charge_code_nm,'') ;
						else data = data + "@@" + common.nvl(datas.charge_code_nm,'') ;
					} else if (selector == 'C5_2') {  //담당자명
						if(data == "") data = common.nvl(datas.charge_nm,'') ;
						else data = data + "@@" + common.nvl(datas.charge_nm,'') ;
					} else if (selector == 'C6_1') {  //구분
						if(data == "") data = common.nvl(datas.gubun,'') ;
						else data = data + "@@" + common.nvl(datas.gubun,'') ;
					} else if (selector == 'C6_2') {  //내용
						if(data == "") data = common.nvl(datas.contents,'') ;
						else data = data + "@@" + common.nvl(datas.contents,'') ;
					} else if (selector == 'C6_3') {  //비고
						if(data == "") data = common.nvl(datas.etc,'') ;
						else data = data + "@@" + common.nvl(datas.etc,'') ;
					}
					
				}
				arr.push(data) ; 
			}
			dupClear(arr) ; 
		} else {
			commonTable.notData($('#statHeader th').length,'데이터가 없습니다.','statList');
		}
	}
	
	function dupClear(arr){
		
		var HLength = $('[id^=optionTr]').find('[id^=optionC_]').length;
		
		if(arr != null && arr.length > 0){
			
						
			var uniqueNames = [];

			$.each(arr, function(i, el){
				if($.inArray(el, uniqueNames) == -1) uniqueNames.push(el);
			});
			
			for(var i = 0 ; i < uniqueNames.length ; i++){
				var datas = uniqueNames[i].split("@@") ;
				var str = '' ; 
				str = '<tr>';
				str += '		<td>'+(i+1)+'</td>';
				
				for(var j = 0 ; j < datas.length ; j++){
					var datas2 = datas[j] ; 
					str += '		<td>'+datas2+'</td>';	
				}
				
				str += '</tr>';
				$('#statList').append(str);
			}
			
			$('#totalCount').html($('#statList tr').length);
			$('#totalCountWrap').show();
		}
		
	}
	
	function addDepth1Option() {
				
		set1OpCnt++;
		
		str = '';
		
		str += '<tr id="optionTr'+set1OpCnt+'" data-cnt="'+set1OpCnt+'">';
		str += '	<th scope="row">검색옵션</th>';
		str += '	<td>';
		str += '		<span id="opDepthA_'+set1OpCnt+'">';
		str += '			<select id="optionA_'+set1OpCnt+'" name="optionA_'+set1OpCnt+'" onchange="set2DepthOption(this, this.value);" title="검색'+set1OpCnt+'옵션 선택" class="w160 mgr5">';
		str += '				<option value="">선택</option>';
		str += '				<option value="A1">관리정보</option>';
		str += '				<option value="A2">프로젝트정보</option>';
		str += '				<option value="A3">운영정보</option>';
		str += '			</select>';
		str += '		</span>';
		str += '	</td>';
		str += '	<td>';
		if (set1OpCnt == 1) str += '		<button type="button" class="btn_plus mgr5" onclick="addDepth1Option();"></button>';	
		else str += '		<button type="button" class="btn_minus mgr5" onclick="delDepth1Option('+set1OpCnt+');"></button>';
		
		str += '	</td>';
		str += '</tr>';
		
		$('#searchOption').append(str);
		
		$('#opCnt').val(set1OpCnt);
	}
	
	function delDepth1Option(cnt) {
		$('#optionTr'+cnt).remove();
	}
	
	function set2DepthOption(object, gubun) {
		var optionH = '';
		var optionF = '';
		var str = '';
		
		var bCnt = $(object).parents('tr').data('cnt');
		
		$(object).parents('td').find('[id^=opDepthB_]').remove();
		$(object).parents('td').find('[id^=opDepthC_]').remove();
		$(object).parents('td').find('[id^=opDepthD_]').remove();
		
		if (gubun != '') {
			if (gubun == "A1") optionH = '<span id="opDepthC_'+bCnt+'"><select id="optionC_'+bCnt+'" name="optionC_'+bCnt+'" onchange="set3DepthOption(this, this.value);" class="w160 mgr5">';
			else optionH = '<span id="opDepthB_'+bCnt+'"><select id="optionB_'+bCnt+'" name="optionB_'+bCnt+'" onchange="set3DepthOption(this, this.value);" class="w160 mgr5">'; 
			
			str += '<option value="">선택</option>';
			if (gubun == "A1") { //관리정보
				str += '<option value="A1">거래처명</option>';
				str += '<option value="A2">거래처구분</option>';
				str += '<option value="A3">병원설립일</option>';
				str += '<option value="A4">계약일자</option>';
				str += '<option value="A5">이슈관리</option>';
			} else if (gubun == "A2") {  //프로젝트정보
				str += '<option value="B1">프로젝트정보</option>';
				str += '<option value="B2">서버정보</option>';
				str += '<option value="B3">기본정보</option>';
				str += '<option value="B4">상세정보</option>';
				str += '<option value="B5">담당자정보</option>';
			} else if (gubun == "A3") {  //운영정보
				str += '<option value="C1">기본정보</option>';
				str += '<option value="C2">운영정보</option>';
				str += '<option value="C3">상세정보</option>';
				str += '<option value="C4">서버정보</option>';
				str += '<option value="C5">담당자정보</option>';
				str += '<option value="C6">관리비고</option>';
			}
			optionF = '</select></span>';
			
			$(object).parents('td').append(optionH + "" + str + "" + optionF);
		}
	}
	
	function set3DepthOption(object, gubun) {
		
		if (gubun.substring(0,1) == "A") $(object).parents('td').find('[id^=opDepthD_]').remove();
		else $(object).parents('td').find('[id^=opDepthC_]').remove(); $(object).parents('td').find('[id^=opDepthD_]').remove();
		
		var bCnt = $(object).parents('tr').data('cnt');
		
		if (gubun != '') {

			if (gubun.substring(0,1) == "A") { //관리정보
				var optionH = '';
				var optionF = '';
				var str = '';							
				optionH = '<span id="opDepthD_'+bCnt+'">';
				optionF = '</span>';
				
				if (gubun == "A1") { //거래처명
					str += '<input type="text" id="cust_nm'+bCnt+'" name="cust_nm'+bCnt+'"  class="w160 mgr5"/>';
					$(object).parents('td').append(optionH + str + optionF);
				}
				
				if (gubun == "A2") { //거래처구분
					str += '<select id="cust_gubun'+bCnt+'" name="cust_gubun'+bCnt+'" class="w160 mgr5">';
					str += '</select>';
					$(object).parents('td').append(optionH + str + optionF);	
					commonCode.getCodeList('CUST' , 'CD01' , 'cust_gubun'+bCnt) ;
				}
				if (gubun == "A3") {
					str += '<input type="text" id="foundation_dt1_'+bCnt+'" name="foundation_dt1_'+bCnt+'"  class="w160 mgr5" title="병원설립일"/>~';
					str += '<input type="text" id="foundation_dt2_'+bCnt+'" name="foundation_dt2_'+bCnt+'"  class="w160 mgr5" title="병원설립일"/>';
					$(object).parents('td').append(optionH + str + optionF);		
					$( "#foundation_dt1_"+bCnt ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
					$( "#foundation_dt2_"+bCnt ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
				}				
				if (gubun == "A4") {
					str += '<input type="text" id="contract_dt1_'+bCnt+'" name="contract_dt1_'+bCnt+'"  class="w160 mgr5" title="계약일자" />~';
					str += '<input type="text" id="contract_dt2_'+bCnt+'" name="contract_dt2_'+bCnt+'"  class="w160 mgr5" title="계약일자" />';
					$(object).parents('td').append(optionH + str + optionF);		
					$( "#contract_dt1_"+bCnt ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
					$( "#contract_dt2_"+bCnt ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
				}				
				if (gubun == "A5") {
					str += '<select id="gubun_code'+bCnt+'" name="gubun_code'+bCnt+'" class="w160 mgr5">';
					str += '</select>';
					$(object).parents('td').append(optionH + str + optionF);	
					commonCode.getCodeList('CUST' , 'CD10' , 'gubun_code'+bCnt) ;
				}
			} else if (gubun.substring(0,1) == "B" || gubun.substring(0,1) == "C") {
				var optionH = '<span id="opDepthC_'+bCnt+'">';
				var optionF = '</span>';
				var str = '<select id="optionC_'+bCnt+'" name="optionC_'+bCnt+'" onchange="set4DepthOption(this, this.value);" class="w160 mgr5">';
				str += (getOption(gubun));
				str += '</select>';
				var setText = optionH + str + optionF;
				console.log(setText);
				$(object).parents('td').append(setText);
			}
		}
	}
	
	function set4DepthOption(object, gubun) {
		var str = '';							
		
		$(object).parents('td').find('[id^=opDepthD_]').remove();
		
		var bCnt = $(object).parents('tr').data('cnt');
		
		var optionH = '<span id="opDepthD_'+bCnt+'">';
		var optionF = '</span>';
		
		if (gubun.substring(0,2) == "B1") { //프로젝트정보
			if (gubun == 'B1_1') {
				//Calendar(from-to)
				str += '<input type="text" id="open_dt1_'+bCnt+'" name="open_dt1_'+bCnt+'"  class="w160 mgr5" title="전산오픈일"/>~';
				str += '<input type="text" id="open_dt2_'+bCnt+'" name="open_dt2_'+bCnt+'"  class="w160 mgr5" title="전산오픈일"/>';
				$(object).parents('td').append(optionH + str + optionF);		
				$( "#open_dt1_"+bCnt ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
				$( "#open_dt2_"+bCnt ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
			} else if (gubun == 'B1_2') {
				//직접입력
				str += '<input type="text" id="term_person_count'+bCnt+'" name="term_person_count'+bCnt+'"  class="w160 mgr5"/>';
				$(object).parents('td').append(optionH + str + optionF);
			} else if (gubun == 'B1_3') {
				//직접입력
				str += '<input type="text" id="pm'+bCnt+'" name="pm'+bCnt+'"  class="w160 mgr5"/>';
				$(object).parents('td').append(optionH + str + optionF);
			} else if (gubun == 'B1_4') {
				//Calendar(from-to)
				str += '<input type="text" id="test_dt1_'+bCnt+'" name="test_dt1_'+bCnt+'"  class="w160 mgr5" title="최종검수일"/>~';
				str += '<input type="text" id="test_dt2_'+bCnt+'" name="test_dt2_'+bCnt+'"  class="w160 mgr5" title="최종검수일"/>';
				$(object).parents('td').append(optionH + str + optionF);		
				$( "#test_dt1_"+bCnt ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
				$( "#test_dt2_"+bCnt ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);				
			} else if (gubun == 'B1_5') {
				//Select box(code)
				str += '<select id="version'+bCnt+'" name="version'+bCnt+'" class="w160 mgr5">';
				str += '</select>';
				$(object).parents('td').append(optionH + str + optionF);
				commonCode.getCodeList('CUST' , 'CD14' , 'version'+bCnt) ; 
			} 
		} else if (gubun.substring(0,2) == "B2") { //서버정보
			
			if (gubun == 'B2_1') {
				str += '<select id="formation_code'+bCnt+'" name="formation_code'+bCnt+'" class="w160 mgr5">';
				str += '</select>';
				$(object).parents('td').append(optionH + str + optionF);
				commonCode.getCodeList('CUST' , 'CD15' , 'formation_code'+bCnt) ; 						
			} else if (gubun == 'B2_2') {
				str += '<select id="os'+bCnt+'" name="os'+bCnt+'" class="w160 mgr5">';
				str += '</select>';
				$(object).parents('td').append(optionH + str + optionF);
				commonCode.getCodeList('CUST' , 'CD18' , 'os'+bCnt) ; 						
			} else if (gubun == 'B2_3') {
				str += '<input type="text" id="mtac_contract_dt1_'+bCnt+'" name="mtac_contract_dt1_'+bCnt+'"  class="w160 mgr5" title="최종검수일"/>~';
				str += '<input type="text" id="mtac_contract_dt2_'+bCnt+'" name="mtac_contract_dt2_'+bCnt+'"  class="w160 mgr5" title="최종검수일"/>';
				$(object).parents('td').append(optionH + str + optionF);		
				$( "#mtac_contract_dt1_"+bCnt ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
				$( "#mtac_contract_dt2_"+bCnt ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);				
			}
			
		} else if (gubun.substring(0,2) == "B3") { //기본정보
			
			if (gubun == 'B3_1') {
				str += '<input type="text" id="cust_kor_name'+bCnt+'" name="cust_kor_name'+bCnt+'"  class="w160 mgr5"/>';
				$(object).parents('td').append(optionH + str + optionF);
			} else if (gubun == 'B3_2') {
				str += '<select id="cust_gubun'+bCnt+'" name="cust_gubun'+bCnt+'" class="w160 mgr5">';
				str += '</select>';
				$(object).parents('td').append(optionH + str + optionF);
				commonCode.getCodeList('CUST' , 'CD01' , 'cust_gubun'+bCnt) ; 										
			} else if (gubun == 'B3_3') {
				str += '<input type="text" id="basic_etc'+bCnt+'" name="basic_etc'+bCnt+'"  class="w160 mgr5"/>';
				$(object).parents('td').append(optionH + str + optionF);
			}
			
		} else if (gubun.substring(0,2) == "B4") { //상세정보
			
			if (gubun == 'B4_1') {
				str += '<input type="text" id="bed_count'+bCnt+'" name="bed_count'+bCnt+'"  class="w160 mgr5"/>';
				$(object).parents('td').append(optionH + str + optionF);
			} else if (gubun == 'B4_2') {
				str += '<select id="veterans_yn'+bCnt+'" name="veterans_yn'+bCnt+'" class="w160 mgr5">';
				str += '		<option value="Y">Yes</option>';
				str += '		<option value="N">No</option>';
				str += '</select>';
				$(object).parents('td').append(optionH + str + optionF);
			} else if (gubun == 'B4_3') {
				str += '<select id="military_yn'+bCnt+'" name="military_yn'+bCnt+'" class="w160 mgr5">';
				str += '		<option value="Y">Yes</option>';
				str += '		<option value="N">No</option>';
				str += '</select>';
				$(object).parents('td').append(optionH + str + optionF);
			} else if (gubun == 'B4_4') {
				str += '<input type="text" id="old_company_nm'+bCnt+'" name="old_company_nm'+bCnt+'"  class="w160 mgr5"/>';
				$(object).parents('td').append(optionH + str + optionF);
			} else if (gubun == 'B4_5') {
				str += '<select id="outside_cust_code'+bCnt+'" name="outside_cust_code'+bCnt+'" class="w160 mgr5">';
				str += '</select>';
				$(object).parents('td').append(optionH + str + optionF);
				commonCode.getCodeList('CUST' , 'CD26' , 'outside_cust_code'+bCnt) ;
			}
			
		} else if (gubun.substring(0,2) == "B5") { //담당자정보
			
			if (gubun == 'B5_1') {
				//charge_code
				str += '<select id="charge_code'+bCnt+'" name="charge_code'+bCnt+'" class="w160 mgr5">';
				str += '</select>';
				$(object).parents('td').append(optionH + str + optionF);
				commonCode.getCodeList('CUST' , 'CD27' , 'charge_code'+bCnt) ;
			} else if (gubun == 'B5_2') {
				str += '<input type="text" id="charge_nm'+bCnt+'" name="charge_nm'+bCnt+'"  class="w160 mgr5"/>';
				$(object).parents('td').append(optionH + str + optionF);				
			}
			
		} else if (gubun.substring(0,2) == "C1") { //기본정보
			
			if (gubun == 'C1_1') {
				str += '<select id="deal_code'+bCnt+'" name="deal_code'+bCnt+'" class="w160 mgr5">';
				str += '</select>';
				$(object).parents('td').append(optionH + str + optionF);
				commonCode.getCodeList('CUST' , 'CD03' , 'deal_code'+bCnt) ;
			} else if (gubun == 'C1_2') {

				str += '<select id="his_basic_code'+bCnt+'" name="his_basic_code'+bCnt+'" class="w160 mgr5">';
				str += '</select>';
				str += '<select id="his_treat_code'+bCnt+'" name="his_treat_code'+bCnt+'" class="w160 mgr5">';
				str += '</select>';
				str += '<select id="his_work_code'+bCnt+'" name="his_work_code'+bCnt+'" class="w160 mgr5">';
				str += '</select>';
				str += '<select id="his_claim_code'+bCnt+'" name="his_claim_code'+bCnt+'" class="w160 mgr5">';
				str += '</select>';
				
				$(object).parents('td').append(optionH + str + optionF);
				
				commonCode.getCodeList('CUST' , 'CD04' , 'his_basic_code'+bCnt) ;
				commonCode.getCodeList('CUST' , 'CD05' , 'his_treat_code'+bCnt) ;
				commonCode.getCodeList('CUST' , 'CD06' , 'his_work_code'+bCnt) ;
				commonCode.getCodeList('CUST' , 'CD07' , 'his_claim_code'+bCnt) ;
			}
			
		} else if (gubun.substring(0,2) == "C2") { //운영정보
			
			if (gubun == 'C2_1') { //보훈여부 
				str += '<select id="c_veterans_yn'+bCnt+'" name="c_veterans_yn'+bCnt+'" class="w160 mgr5">';
				str += '		<option value="Y">Yes</option>';
				str += '		<option value="N">No</option>';
				str += '</select>';
				$(object).parents('td').append(optionH + str + optionF);
			} else if (gubun == 'C2_2') { //군지역소재 
				str += '<select id="c_military_yn'+bCnt+'" name="c_military_yn'+bCnt+'" class="w160 mgr5">';
				str += '		<option value="Y">Yes</option>';
				str += '		<option value="N">No</option>';
				str += '</select>';
				$(object).parents('td').append(optionH + str + optionF);
			} else if (gubun == 'C2_3') { //선택진료 
				str += '<select id="choice_yn'+bCnt+'" name="choice_yn'+bCnt+'" class="w160 mgr5">';
				str += '		<option value="Y">Yes</option>';
				str += '		<option value="N">No</option>';
				str += '</select>';
				$(object).parents('td').append(optionH + str + optionF);
			} else if (gubun == 'C2_4') { //치과유무 
				str += '<select id="dentist_yn'+bCnt+'" name="dentist_yn'+bCnt+'" class="w160 mgr5">';
				str += '		<option value="Y">Yes</option>';
				str += '		<option value="N">No</option>';
				str += '</select>';
				$(object).parents('td').append(optionH + str + optionF);
			} else if (gubun == 'C2_5') { //정신과 
				str += '<select id="mental_yn'+bCnt+'" name="mental_yn'+bCnt+'" class="w160 mgr5">';
				str += '		<option value="Y">Yes</option>';
				str += '		<option value="N">No</option>';
				str += '</select>';
				$(object).parents('td').append(optionH + str + optionF);
			} else if (gubun == 'C2_6') { //한방
				str += '<select id="oriental_yn'+bCnt+'" name="oriental_yn'+bCnt+'" class="w160 mgr5">';
				str += '		<option value="Y">Yes</option>';
				str += '		<option value="N">No</option>';
				str += '</select>';
				$(object).parents('td').append(optionH + str + optionF);
			} else if (gubun == 'C2_7') { //혈액투석
				str += '<select id="hemodialysis_yn'+bCnt+'" name="hemodialysis_yn'+bCnt+'" class="w160 mgr5">';
				str += '		<option value="Y">Yes</option>';
				str += '		<option value="N">No</option>';
				str += '</select>';
				$(object).parents('td').append(optionH + str + optionF);
			} else if (gubun == 'C2_8') { //포괄간호
				str += '<select id="care_yn'+bCnt+'" name="care_yn'+bCnt+'" class="w160 mgr5">';
				str += '		<option value="Y">Yes</option>';
				str += '		<option value="N">No</option>';
				str += '</select>';
				$(object).parents('td').append(optionH + str + optionF);
				
			} else if (gubun == 'C2_9') { //응급실운영
				str += '<select id="emergencyop_yn'+bCnt+'" name="emergencyop_yn'+bCnt+'" class="w160 mgr5">';
				str += '		<option value="Y">Yes</option>';
				str += '		<option value="N">No</option>';
				str += '</select>';
				$(object).parents('td').append(optionH + str + optionF);							
			} else if (gubun == 'C2_10') { //NEDIS사용
				str += '<select id="nedis_yn'+bCnt+'" name="nedis_yn'+bCnt+'" class="w160 mgr5">';
				str += '		<option value="Y">Yes</option>';
				str += '		<option value="N">No</option>';
				str += '</select>';
				$(object).parents('td').append(optionH + str + optionF);								
			} else if (gubun == 'C2_11') { //마약류연계
				str += '<select id="narcotics_yn'+bCnt+'" name="narcotics_yn'+bCnt+'" class="w160 mgr5">';
				str += '		<option value="Y">Yes</option>';
				str += '		<option value="N">No</option>';
				str += '</select>';
				$(object).parents('td').append(optionH + str + optionF);								
			} else if (gubun == 'C2_12') { //Ontic Sense
				str += '<select id="onticsense_yn'+bCnt+'" name="onticsense_yn'+bCnt+'" class="w160 mgr5">';
				str += '		<option value="Y">Yes</option>';
				str += '		<option value="N">No</option>';
				str += '</select>';
				$(object).parents('td').append(optionH + str + optionF);				
			} else if (gubun == 'C2_13') { //van인터페이스
				str += '<select id="van_yn'+bCnt+'" name="van_yn'+bCnt+'" class="w160 mgr5">';
				str += '		<option value="Y">Yes</option>';
				str += '		<option value="N">No</option>';
				str += '</select>';
				$(object).parents('td').append(optionH + str + optionF);				
			}
			
		} else if (gubun.substring(0,2) == "C3") { //상세정보
			
			if (gubun == 'C3_1') { //간호등급
				str += '<input type="text" id="care_grade'+bCnt+'" name="care_grade'+bCnt+'"  class="w160 mgr5"/>';
				$(object).parents('td').append(optionH + str + optionF);				
			} else if (gubun == 'C3_2') { //기존전산업체
				str += '<input type="text" id="old_company_nm'+bCnt+'" name="old_company_nm'+bCnt+'"  class="w160 mgr5"/>';
				$(object).parents('td').append(optionH + str + optionF);
			} else if (gubun == 'C3_3') { //외부수탁업체
				str += '<select id="outside_cust_code'+bCnt+'" name="outside_cust_code'+bCnt+'" class="w160 mgr5">';
				str += '</select>';
				$(object).parents('td').append(optionH + str + optionF);
				commonCode.getCodeList('CUST' , 'CD26' , 'outside_cust_code'+bCnt) ;
			}
			
		} else if (gubun.substring(0,2) == "C4") { //서버정보
			
			if (gubun == 'C4_1') {
				str += '<select id="os'+bCnt+'" name="os'+bCnt+'" class="w160 mgr5">';
				str += '</select>';
				$(object).parents('td').append(optionH + str + optionF);
				commonCode.getCodeList('CUST' , 'CD18' , 'os'+bCnt) ;
			}
			
		} else if (gubun.substring(0,2) == "C5") { //담당자정보
			
			if (gubun == 'C5_1') {
				str += '<select id="charge_code'+bCnt+'" name="charge_code'+bCnt+'" class="w160 mgr5">';
				str += '</select>';
				$(object).parents('td').append(optionH + str + optionF);
				commonCode.getCodeList('CUST' , 'CD27' , 'charge_code'+bCnt) ;
			} else if (gubun == 'C5_2') {
				str += '<input type="text" id="charge_nm'+bCnt+'" name="charge_nm'+bCnt+'"  class="w160 mgr5"/>';
				$(object).parents('td').append(optionH + str + optionF);	
			}
			
		} else if (gubun.substring(0,2) == "C6") { //관리비고
			
			if (gubun == 'C6_1') {
				str += '<input type="text" id="gubun'+bCnt+'" name="gubun'+bCnt+'"  class="w160 mgr5"/>';
				$(object).parents('td').append(optionH + str + optionF);
			} else if (gubun == 'C6_2') {
				str += '<input type="text" id="contents'+bCnt+'" name="contents'+bCnt+'"  class="w160 mgr5"/>';
				$(object).parents('td').append(optionH + str + optionF);
			} else if (gubun == 'C6_3') {
				str += '<input type="text" id="n_etc'+bCnt+'" name="n_etc'+bCnt+'"  class="w160 mgr5"/>';
				$(object).parents('td').append(optionH + str + optionF);
			}
			
		}
		
		
	}
	
	function getOption(gubun) {
		var str = '';
		if(gubun == 'B1') {
			str+='<option value="">선택</option>';
			str+='<option value="B1_1">전산오픈일</option>';
			str+='<option value="B1_2">투입인원</option>';
			str+='<option value="B1_3">담당PM</option>';
			str+='<option value="B1_4">최종검수일</option>';
			str+='<option value="B1_5">OCS/EMRver</option>';
		}
		if(gubun == 'B2') {
			str+='<option value="">선택</option>';
			str+='<option value="B2_1">서버구성</option>';
			str+='<option value="B2_2">OS</option>';
			str+='<option value="B2_3">유지보수 계약일자</option>';			
		}
		if(gubun == 'B3') {
			str+='<option value="">선택</option>';
			str+='<option value="B3_1">거래처명</option>';
			str+='<option value="B3_2">거래처구분</option>';
			str+='<option value="B3_3">기타설명</option>';			
		}
		if(gubun == 'B4') {
			str+='<option value="">선택</option>';
			str+='<option value="B4_1">병상수</option>';
			str+='<option value="B4_2">보훈여부</option>';
			str+='<option value="B4_3">군지역소재</option>';
			str+='<option value="B4_4">기존전산업체</option>';
			str+='<option value="B4_5">외부수탁업체</option>';
			
		}
		if(gubun == 'B5') {
			str+='<option value="">선택</option>';
			str+='<option value="B5_1">담당구분</option>';
			str+='<option value="B5_2">담당자명</option>';
		}
		
		if(gubun == 'C1') {
			str+='<option value="">선택</option>';
			str+='<option value="C1_1">거래상태</option>';
			str+='<option value="C1_2">HIS(모듈별)</option>';			
		}
		if(gubun == 'C2') {
			str+='<option value="">선택</option>';
			str+='<option value="C2_1">보훈여부</option>';
			str+='<option value="C2_2">군지역소재</option>';
			str+='<option value="C2_3">선택진료</option>';
			str+='<option value="C2_4">치과유무</option>';
			str+='<option value="C2_5">정신과</option>';
			str+='<option value="C2_6">한방</option>';
			str+='<option value="C2_7">혈액투석</option>';
			str+='<option value="C2_8">포괄간호</option>';
			str+='<option value="C2_9">응급실운영</option>';
			str+='<option value="C2_10">NEDIS사용</option>';
			str+='<option value="C2_11">마약류연계</option>';
			str+='<option value="C2_12">Ontic Sense</option>';
			str+='<option value="C2_13">van인터페이스</option>';					
		}
		if(gubun == 'C3') {
			str+='<option value="">선택</option>';
			str+='<option value="C3_1">간호등급</option>';
			str+='<option value="C3_2">기존전산업체</option>';
			str+='<option value="C3_3">외부수탁업체</option>';			
		}
		if(gubun == 'C4') {
			str+='<option value="">선택</option>';
			str+='<option value="C4_1">OS</option>';	
		}
		if(gubun == 'C5') {
			str+='<option value="">선택</option>';
			str+='<option value="C5_1">담당구분</option>';
			str+='<option value="C5_2">담당자명</option>';			
		}
		if(gubun == 'C6') {
			str+='<option value="">선택</option>';
			str+='<option value="C6_1">구분</option>';
			str+='<option value="C6_2">내용</option>';
			str+='<option value="C6_3">비고</option>';			
		}
		return str;
	}
	
	function goExl() {
		
		var str = "";
		for (var i=0; i < listArr.length; i++){
			str += ",'" + listArr[i].crm_code+"'";
		}
		
		var flag = $('#totalCount').html() > 0 ? 'T' : 'F' ;
		
		if(flag == 'T'){
			
			var f = document.frmList ; 
			f.crmList.value = str.slice(1);
			
			try{
				$("#exlFrame").remove() ;
			}catch(e){}
			
			var downFrame = $('<iframe id="exlFrame" name="exlFrame" style="width:0px; height=0px ; display:none;"></iframe>') ; 
			downFrame.appendTo("body") ;
			
			f.target = "exlFrame" ; 
			f.action = "/ad/stat/exl.do" ; 
			f.submit() ; 
			
		}else{
			alert("출력 가능한 데이터가 없습니다.") ; 
			return ; 
		}
	}

</script>

<form name="frmList" id="frmList" method="post" onsubmit="return false;">
<input type="hidden" name="opCnt" id="opCnt" />
<input type="hidden" name="crmList" id="crmList" />
<div class="tit_wrap">
	<h2 class="tit_ico_graph">고급 검색</h2>
	<div class="location">
		<a href="#" class="home">Home</a>
		<a href="#" class="home">통계분석</a>
		<a href="#" class="depth"><span class="here">고급 검색</span></a>
	</div>
</div>
<!-- search -->
<table class="sType mgb10">
	<caption>A/S 접수 리스트 검색</caption>
	<colgroup>
		<col style="width:100px;" />
		<col style="width:830px;" />
		<col style="width:auto;" />
	</colgroup>
	<tbody id="searchOption"></tbody>
</table>
<!--// search -->
<div class="info_upper mgb5">
	<div class="sorting" id="totalCountWrap" style="display:none;">
		조회건수 : <strong><span class="count" id="totalCount">0</span> 건</strong>
	</div>
	<div class="floatR">
		<button type="button" class="btn_ico_search mgr5" onclick="statList(1);"><span>검색</span></button>
		<button type="button" class="btn_ico_excel" onclick="javascript:goExl();"><span>엑셀다운로드</span></button>
	</div>
</div>
<!--// search -->
<!-- list -->
<table class="hType mgb10">
	<caption>A/S 접수 목록</caption>
	<colgroup>
		<col style="width:30px" />
	</colgroup>
	<thead>
		<tr id="statHeader">
			<!-- <th scope="col">No</th>
			<th scope="col">거래처명</th>
			<th scope="col">자동갱신여부</th>
			<th scope="col">계약서번호</th>
			<th scope="col">계약서명</th>
			<th scope="col">계약일시</th>
			<th scope="col">품목</th>
			<th scope="col">유/무상 구분</th>
			<th scope="col">유지보수기간</th>
			<th scope="col">계약잔여일</th>
			<th scope="col">월유보금액</th>
			<th scope="col">미수금(현재일기준)</th>
			<th scope="col">매입업체명</th>
			<th scope="col">매입원가</th>
			<th scope="col">서비수주기</th>
			<th scope="col">서비스방법</th> -->
		</tr>
	</thead>
	<tbody id="statList"></tbody>
</table>
<!--// list -->
</form>