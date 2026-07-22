
/*달력 창 옵션 설정*/

var setDt = new Date();
var setY = setDt.getFullYear();
var setM = setDt.getMonth()+1;
var setD = setDt.getDate()+1;
var defaultDt = setY+"/"+setM+"/"+setD;

var datepicker = {
	showOn: "button",
	buttonImage: "/images/ico_calendar.png",
	buttonImageOnly: true, // 버튼에 있는 이미지만 표시한다.
	changeMonth: true, 
	changeYear: true,
	dateFormat: "yy/mm/dd" ,
	dayNames: ['일요일','월요일', '화요일', '수요일', '목요일', '금요일', '토요일'],
	dayNamesMin: ['일','월', '화', '수', '목', '금', '토'], 
	monthNamesShort: ['1','2','3','4','5','6','7','8','9','10','11','12'],
	monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	nextText: '다음 달',
	prevText: '이전 달',
	showMonthAfterYear:true,
	currentText:'오늘 날짜',
	closeText: '닫기'
}

var monthpicker_option = {
	pattern: 'yyyy/mm',
	showOn: "button",
	buttonImage: "/images/ico_calendar.png",
	buttonImageOnly: true,
	selectedYear: setY,
	startYear: setY - 10,
	finalYear: setY + 10,
	monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
	closeText: '닫기'
};


var userAnserJsonObj = {} ;

var page_option = {
	totalRecordCount : "" , //전체 게시물 건 수
	recordCountPerPage : "" , //한 페이지당 게시되는 게시물 건 수
	pageSize : 5 , //페이지 리스트에 게시되는 페이지 max개수
	firstPageNoOnPageList : 1 , //페이지 리스트의 첫 페이지 번호
	lastPageNoOnPageList : 5 , //페이지 리스트의 마지막 페이지 번호
	
	
	//currentPageNo  현재 페이지 번호
	//firstRecordIndex   페이징 SQL의 조건절에 사용되는 시작 rownum
	//lastRecordIndex   페이징 SQL의 조건절에 사용되는 마지막 rownum
	//nextPageLabel 다음
}

var common = {
	isNotEmpty : function(_str){
		obj = String(_str) ; 
		
		if(obj == null || obj == undefined || obj == 'null' || obj =='undefined' || obj == '') return false ; 
		else return true ; 
	} , 
	
	isEmpty : function(_str){
		return !common.isNotEmpty(_str) ; 
	} , 
	
	nvl : function(_str , changeStr){
		if(common.isEmpty(_str)) return changeStr ;
		else return _str ;
	} , 
	/**	조회 권한이 없을 경우 이동 하는 스크립트	*/
	isLoginPage : function(){
		var f = $("<form></form>") ;
		f.attr('id' , 'moveFrm') ; 
		f.attr('action' , '/ad/login/form.do') ; 
		f.attr('method' , 'post') ; 
		f.appendTo("body") ;
		
		f.submit() ; 
	} , 
	
	replaceAll : function(_str , pattern , replaceStr){
		if(common.isNotEmpty(_str)){
			while(_str.indexOf(pattern) != -1){
				_str = _str.replace(pattern, replaceStr)
			}
		}
		
		return _str ; 
	},
	
	/**	로 연결된 연락처를 나눈다.	*/
	spritStr : function(_num , returnFlag, gbn){
		var returnStr = '' ;
		try{
			if(common.isNotEmpty(_num)){
				var arr = _num.split(gbn) ;
					
				for(var i = 0 ; i < arr.length ; i++){
					if(returnFlag == (i+1)){
						returnStr = arr[i] ; 
						break ; 
					}
				}
			}
		}catch(e){}
		
		return returnStr;
		
	} , 
	
	ajaxCall : function(datas , url , returnScript){
		$.ajax({
			type			: 'POST',
			url				: url,
			dataType		: "json",
			async 			: false,
			data			: datas,
			success: function(data) {
				var nextScript = (returnScript != '' ? returnScript+"(data)" : "returnAjax(data);") ;
				eval(nextScript) ; 
			}
			,statusCode : {
				403:function(data){
					alert("권한이 없습니다.");
				},
				404:function(data){
					alert('해당 페이지가 존재하지 않습니다.');
				}
			}
		});
	} , 
	
	ajaxCall2 : function(datas , target , url , returnScript){
		$.ajax({
			type				: 'POST',
			url				: url,
			dataType		: "json",
			async 			: false,
			data				: datas,
			success: function(data) {
				var nextScript = (returnScript != '' ? returnScript+"(data , target)" : "returnAjax(data , target);") ;
				eval(nextScript) ; 
			}
			,statusCode : {
				403:function(data){
					alert("권한이 없습니다.");
				},
				404:function(data){
					alert('해당 페이지가 존재하지 않습니다.');
				}
			}
		});
	},
	
	ajaxCallAsync : function(datas , url , returnScript){
		$.ajax({
			type			: 'POST',
			url				: url,
			dataType		: "json",
			async 			: true,
			data			: datas,
			success: function(data) {
				var nextScript = (returnScript != '' ? returnScript+"(data)" : "returnAjax(data);") ;
				eval(nextScript) ; 
			}
			,statusCode : {
				403:function(data){
					alert("권한이 없습니다.");
				},
				404:function(data){
					alert('해당 페이지가 존재하지 않습니다.');
				}
			}
		});
	} , 
	
	//콤마찍기
	comma : function(str) {
	    str = String(str);
	    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
	},
	 
	//콤마풀기
	uncomma : function(str) {
	    str = String(str);
	    return str.replace(/[^\d]+/g, '');
	},
	 
	//값 입력시 콤마찍기
	inputNumberFormat : function(obj) {
	    obj.value = common.comma(common.uncomma(obj.value));
	}
	//<input type="text" onkeyup="common.inputNumberFormat(this)" />
	,
	replaceAll : function(str, searchStr, replaceStr) {
	    return str.split(searchStr).join(replaceStr);
	}
	,
	// 날짜형식으로 바꾸기
	strToDate : function(str){
		if (str == null || str.length < 8) return str;
		
		return str.substr(0,4) + '/' + str.substr(4,2) + '/' + str.substr(6,2);
	}
} ; 

var commonTable = {
	notData : function(colspan , msg , tableId){
		var str = '' ; 
		
		str += '<tr>' ; 
		str += '	<td colspan="'+colspan+'" style="text-align: center;">'+msg+'</td>' ; 
		str += '</tr>' ; 
		
		$('#' + tableId).html(str) ; 
	}	
} ; 

var commonCode = {
		
		defaultOption 		: '<option value=\'\'>전체선택</option>' , 
		defaultViewOption 	: '<option value=\'\'>선택</option>' , 
		
		getPcodeList : function(code_group , target){
			var datas = {
				'code_group' : code_group 
			} ; 
			common.ajaxCall2(datas , target , '/comm/getPcode.do' , 'commonCode.returnPcodeList') ; 
		} , 
		
		
		getCodeList : function(code_group , p_code , target){
			var datas = {
				'code_group' : code_group , 	
				'p_code' : p_code 	
			} ; 
			common.ajaxCall2(datas , target , '/comm/getCode.do' , 'commonCode.returnCodeList') ; 
		} , 
		
		getCodeNm : function(code_group , p_code , code ){
			var datas = {
					'code_group' : code_group , 	
					'p_code' : p_code ,
					'code' : code
			} ; 
			var str = '' ; 
			
			$.ajax({
				type				: 'POST',
				url				: '/comm/getCodeNm.do',
				dataType		: "json",
				async 			: false,
				data				: datas,
				success: function(data) {
					var resultStr = typeof data.resultStr != "undefined" ? data.resultStr : null ;
					
					if(resultStr != null) str = resultStr.code_name ; 
				}
			});
			
			return str ; 
		} , 
		
		getCodeList2 : function(code_group , p_code , returnFunction){
			var datas = {
				'code_group' : code_group , 	
				'p_code' : p_code 	
			} ; 
			common.ajaxCall(datas , '/comm/getCode.do' , returnFunction) ; 
		} , 
		
		getCodeTreeList : function(p_code, returnFunction){
			var datas = {
				'p_code' : p_code
			};
			
			common.ajaxCall(datas , '/comm/getCode2.do', returnFunction) ;
		} ,
		
		
		
		returnCodeList : function(data , target){
			
			var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
			
			if(target.indexOf('procMultiSelect') != -1 ){
				
			}else{
				if(location.href.indexOf('list') != -1) $('#' + target).empty().append(commonCode.defaultOption) ;
				else $('#' + target).empty().append(commonCode.defaultViewOption) ;
			}
			
			if(resultList != null && resultList.length > 0){
				var str = '' ;
				
				for(var i = 0 ; i < resultList.length ; i++){
					var datas = resultList[i] ; 
					str += '<option value=\''+common.nvl(datas.code, '')+'\'>'+common.nvl(datas.code_name, '')+'</option>' ; 
				}
				
				$('#' + target).append(str) ; 
			} 
		},
		
		returnPcodeList : function(data , target){
			
			var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
			
			if(location.href.indexOf('list') != -1) $('#' + target).empty().append(commonCode.defaultOption) ;
			else $('#' + target).empty().append(commonCode.defaultViewOption) ;
			
			if(resultList != null && resultList.length > 0){
				var str = '' ;
				
				for(var i = 0 ; i < resultList.length ; i++){
					var datas = resultList[i] ; 
					str += '<option value=\''+common.nvl(datas.p_code, '')+'\'>'+common.nvl(datas.p_code_name, '')+'</option>' ; 
				}
				
				$('#' + target).append(str) ; 
			} 
		},
		
		/*20181113추가*/
		returnOperCodeList : function(data , target){
			var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
			if(location.href.indexOf('list') != -1) $('#' + target).empty().append(commonCode.defaultOption) ;
			else $('#' + target).empty().append(commonCode.defaultViewOption) ;
			
			if(resultList != null && resultList.length > 0){
				var str = '' ;
				
				for(var i = 0 ; i < resultList.length ; i++){
					var datas = resultList[i] ; 
						str += '<option value=\''+common.nvl(datas.code, '')+'@'+common.nvl(datas.oper_seq, '')+'\'  oper_seq=\''+common.nvl(datas.oper_seq, '')+'\'   state_type=\''+common.nvl(datas.state_type, '')+'\' >'+common.nvl(datas.code_nm, '')+' [' + common.nvl(datas.system_nm, '')+']'+'</option>' ; 
					
				}
				
				$('#' + target).append(str) ; 
			} 
		},
		returnSystemCodeList : function(data , target){
			var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
			if(location.href.indexOf('list') != -1) $('#' + target).empty().append(commonCode.defaultOption) ;
			else $('#' + target).empty().append(commonCode.defaultViewOption) ;
			
			if(resultList != null && resultList.length > 0){
				var str = '' ;
				
				for(var i = 0 ; i < resultList.length ; i++){
					var datas = resultList[i] ; 
					str += '<option value=\''+common.nvl(datas.code, '')+'\'  oper_seq=\''+common.nvl(datas.oper_seq, '')+'\'   state_type=\''+common.nvl(datas.state_type, '')+'\' >'+common.nvl(datas.code_nm, '')+' [' + common.nvl(datas.system_nm, '')+']'+'</option>' ; 
				}
				
				$('#' + target).append(str) ; 
			} 
		},
		
		/*20181113추가*/
		returnTaskCodeList : function(data , target){
			var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
			if(location.href.indexOf('list') != -1) $('#' + target).empty().append(commonCode.defaultOption) ;
			else $('#' + target).empty().append(commonCode.defaultViewOption) ;
			
			if(resultList != null && resultList.length > 0){
				var str = '' ;
				
				for(var i = 0 ; i < resultList.length ; i++){
					var datas = resultList[i] ; 
					
					/*if(common.nvl(datas.is_use, '') == "C002"){
						str += '<option style="color:red"  value=\''+common.nvl(datas.code, '')+'\'  worker_nm=\''+common.nvl(datas.worker_nm, '')+'\' emp_no=\''+common.nvl(datas.wk_emp_no, '')+'\' is_use=\''+common.nvl(datas.is_use, '')+'\'  >'+common.nvl(datas.code_nm, '')+" [미사용]" +'</option>' ;
					}else{
						str += '<option value=\''+common.nvl(datas.code, '')+'\'  worker_nm=\''+common.nvl(datas.worker_nm, '')+'\' emp_no=\''+common.nvl(datas.wk_emp_no, '')+'\' is_use=\''+common.nvl(datas.is_use, '')+'\'  >'+common.nvl(datas.code_nm, '')+'</option>' ;
					}*/
					str += '<option value=\''+common.nvl(datas.code, '')+'\'  worker_nm=\''+common.nvl(datas.worker_nm, '')+'\' emp_no=\''+common.nvl(datas.wk_emp_no, '')+'\' is_use=\''+common.nvl(datas.is_use, '')+'\'  >'+common.nvl(datas.code_nm, '')+'</option>' ;
					
				}
				
				$('#' + target).append(str) ; 
			} 
		}
		
}


var commonReport = {
		
	getPopup : function() {
		
		
		var mtLenth = $('#mt_wrap select').length;
		var mtTextArr = new Array();
		for (var i = 1; i <= parseInt(mtLenth); i++) {
			if($('#mtac_cust_code'+i+' option:selected').text() != '선택') {
				mtTextArr.push($('#mtac_cust_code'+i+' option:selected').text());
			}
//			if (mtText == '') mtText = $('#mtac_cust_code'+i+' option:selected').text();
//			else mtText = mtText + "," + $('#mtac_cust_code'+i+' option:selected').text();
		}			
		
		var vcLenth = $('#vc_wrap select').length;
		var vcTextArr = new Array();
		for (var i = 1; i <= parseInt(vcLenth); i++) {
			if($('#vc_code'+i+' option:selected').text() != '선택') {
				vcTextArr.push($('#vc_code'+i+' option:selected').text());
			}
//			if (vcText == '') vcText = $('#vc_code'+i+' option:selected').text();
//			else vcText = vcText + "," + $('#vc_code'+i+' option:selected').text();
		}
		
		var bdLenth = $('#bd_wrap select').length;
		var bdTextArr = new Array();
		for (var i = 1; i <= parseInt(bdLenth); i++) {
			if($('#bd_code'+i+' option:selected').text() != '선택') {
				bdTextArr.push($('#bd_code'+i+' option:selected').text() + " / " + $('#bd_etc'+i).val());
			}
//			if (bdText == '') bdText = $('#bd_code'+i+' option:selected').text() + " / " + $('#bd_etc'+i).val();
//			else bdText = bdText + ", " + $('#bd_code'+i+' option:selected').text() + " / " + $('#bd_etc'+i).val();
		}	
		
		var chk1 = ($('input:checkbox[id="veterans_yn"]:checked').val() == "Y") ? "YES" : "NO";
		var chk2 = ($('input:checkbox[id="military_yn"]:checked').val() == "Y") ? "YES" : "NO";
		var chk3 = ($('input:checkbox[id="charge_yn"]:checked').val() == "Y") ? "YES" : "NO";
		
		//셀렉트 박스 선택의 경유 빈값으로 처리 하기 위한 변수
		var mtac_month = ($('#mtac_month option:selected').text() == '선택') ? " " : $('#mtac_month option:selected').text();
		var package_code = ($('#package_code option:selected').text() == '선택') ? " " : $('#package_code option:selected').text();  
		var version = ($('#version option:selected').text() == '선택') ? " " : $('#version option:selected').text();  
		var formation_code = ($('#formation_code option:selected').text() == '선택') ? " " : $('#formation_code option:selected').text();  
		var server_code = ($('#server_code option:selected').text() == '선택') ? " " : $('#server_code option:selected').text();  
		var model_code = ($('#model_code option:selected').text() == '선택') ? " " : $('#model_code option:selected').text();  
		var server_model = " ";
		if(server_code != " " && model_code != " ") { server_model = server_code + " / " + model_code; }
		var os = ($('#os option:selected').text() == '선택') ? " " : $('#os option:selected').text();  
		var ram = ($('#ram option:selected').text() == '선택') ? " " : $('#ram option:selected').text();  
		var sid = ($('#sid option:selected').text() == '선택') ? " " : $('#sid option:selected').text();  
		var oracle_version = ($('#oracle_version option:selected').text() == '선택') ? " " : $('#oracle_version option:selected').text();  
		var specially_code = ($('#specially_code option:selected').text() == '선택') ? " " : $('#specially_code option:selected').text();  
		var new_code = ($('#new_code option:selected').text() == '선택') ? " " : $('#new_code option:selected').text();  
		var outside_cust_code = ($('#outside_cust_code option:selected').text() == '선택') ? " " : $('#outside_cust_code option:selected').text();  
		
		var str = '';
		
		str += '<div id="reportPop">';
		str += '<div class="box_layer" style="width:900px;height:800px;margin:-400px 0 0 -450px;">';
		str += '	<h1>거래처 기초 정보 보고서</h1>';
		str += '	<div class="layer_contents" style="padding:80px 60px 40px;height:635px;overflow-y:auto;" id="reportPopBox">';
		str += '           <h2 style="text-align: center; font-size:30px;">거래처 기초 정보</h2>';
		str += '           <h3 class="floatR" style="font-size:15px; line-height: 55px">발행일자: '+getCurrentDateTime()+'</h3>';
		str += '           ';
		str += '           <!-- 기본정보 -->';
		str += '           <div class="tit_bWrap clearB mgb10">';
		str += '               <h4>기본 정보</h4>';
		str += '           </div>';
		str += '           <table class="sType mgb20">';
		str += '               <caption>기본 정보 조회</caption>';
		str += '               <colgroup>';
		str += '                   <col style="width:125px;" />';
		str += '                   <col style="width:260px;" />';
		str += '                   <col style="width:125px;" />';
		str += '                   <col style="width:260px;" />';
		str += '               </colgroup>';
		str += '               <tr>';
		str += '                   <th scope="row">거래처명</th>';
		str += '                   <td colspan="3" class="fontW_b">'+$('#cust_kor_name').val()+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">CRM코드</th>';
		str += '                   <td class="fontW_b">'+$('#crm_code').val()+'</td>';
		str += '                   <th scope="row">ERP코드</th>';
		str += '                   <td class="fontW_b">'+$('#erp_code').val()+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">대표자</th>';
		str += '                   <td class="fontW_b">'+$('#ceo').val()+'</td>';
		str += '                   <th scope="row">거래처구분</th>';
		str += '                   <td class="fontW_b">'+$('#cust_gubun option:selected').text()+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">사업자등록번호</th>';
		str += '                   <td class="fontW_b">'+$('#cust_no').val()+'</td>';
		str += '                   <th scope="row">법인등록번호</th>';
		str += '                   <td class="fontW_b">'+$('#law_no').val()+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">요양기관번호</th>';
		str += '                   <td class="fontW_b">'+$('#treat_no').val()+'</td>';
		str += '                   <th scope="row">산재요양기호</th>';
		str += '                   <td class="fontW_b">'+$('#accident_no').val()+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">전화번호</th>';
		str += '                   <td class="fontW_b">'+$('#tel_no').val()+'</td>';
		str += '                   <th scope="row">팩스번호</th>';
		str += '                   <td class="fontW_b">'+$('#fax_no').val()+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">우편번호</th>';
		str += '                   <td class="fontW_b">'+$('#post_no').val()+'</td>';
		str += '                   <th scope="row">개업일</th>';
		str += '                   <td class="fontW_b">'+$('#buss_open_dt').val()+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">사업자소재지</th>';
		str += '                   <td colspan="3" class="fontW_b">'+$('#addr').val()+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">Email</th>';
		str += '                   <td class="fontW_b">'+$('#email').val()+'</td>';
		str += '                   <th scope="row">Homepage</th>';
		str += '                   <td class="fontW_b">'+$('#homepage').val()+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">업태</th>';
		str += '                   <td class="fontW_b">'+$('#buss_condition').val()+'</td>';
		str += '                   <th scope="row">종목</th>';
		str += '                   <td class="fontW_b">'+$('#buss_item').val()+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">기타설명</th>';
		str += '                   <td colspan="3" class="fontW_b">'+$('#basic_etc').val()+'</td>';
		str += '               </tr>';
		str += '           </table>';
		str += '           <!-- 프로젝트정보 -->';
		str += '           <div class="tit_bWrap clearB mgb10">';
		str += '               <h4>프로젝트 정보</h4>';
		str += '           </div>';
		str += '           <table class="sType mgb20">';
		str += '               <caption>프로젝트 정보 조회</caption>';
		str += '               <colgroup>';
		str += '                   <col style="width:125px;" />';
		str += '                   <col style="width:260px;" />';
		str += '                   <col style="width:125px;" />';
		str += '                   <col style="width:260px;" />';
		str += '               </colgroup>';
		str += '               <tr>';
		str += '                   <th scope="row">전산오픈일</th>';
		str += '                   <td class="fontW_b">'+$('#open_dt').val()+'</td>';
		str += '                   <th scope="row">SI&#47;Package</th>';
		str += '                   <td colspan="2" class="fontW_b">'+package_code+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">투입기간</th>';
		str += '                   <td class="fontW_b">'+$('#term_start_dt').val()+' ~ '+$('#term_end_dt').val()+'</td>';
		str += '                   <th scope="row">투입인원</th>';
		str += '                   <td class="fontW_b">'+$('#term_person_count').val()+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">무상유지보수</th>';
		str += '                   <td class="fontW_b">'+mtac_month+'</td>';
		str += '                   <th scope="row">구축완료일</th>';
		str += '                   <td class="fontW_b">'+$('#test_dt').val()+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">담당PM</th>';
		str += '                   <td class="fontW_b">'+$('#pm').val()+'</td>';
		str += '                   <th scope="row">OCS&#47;EMR ver</th>';
		str += '                   <td class="fontW_b">'+version+'</td>';
		str += '               </tr>';
		
		str += '               <tr >';
		str += '                   <th scope="row">첫 청구 승인일<br>(검수일)</th>';
		str += '                   <td colspan ="3" class="fontW_b">'+$('#approval_dt').val()+'</td>';
		str += '               </tr>';
		
		
		str += '           </table>';
		str += '           <!--// write -->';
		str += '           <!-- write -->';
		str += '           <div class="tit_bWrap mgb10">';
		str += '               <h4>서버 정보</h4>';
		str += '           </div>';
		str += '           <table class="sType mgb20">';
		str += '               <caption>서버 정보 입력</caption>';
		str += '               <colgroup>';
		str += '               <col style="width:125px;" />';
		str += '                   <col style="width:260px;" />';
		str += '                   <col style="width:125px;" />';
		str += '                   <col style="width:260px;" />';
		str += '               </colgroup>';
		str += '               <tr>';
		str += '                   <th scope="row">구성</th>';
		str += '                   <td class="fontW_b">'+formation_code+'</td>';
		str += '                   <th scope="row">서버 제조사&#47;모델</th>';
		str += '                   <td class="fontW_b">'+server_model+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">OS</th>';
		str += '                   <td class="fontW_b">'+os+'</td>';
		str += '                   <th scope="row">서버 RAM</th>';
		str += '                   <td class="fontW_b">'+ram+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">서비스네임</th>';
		str += '                   <td class="fontW_b">'+sid+'</td>';
		str += '                   <th scope="row">오라클버전</th>';
		str += '                   <td class="fontW_b">'+oracle_version+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">서버IP(호스트)</th>';
		str += '                   <td colspan="3" class="fontW_b">'+$('#server_ip').val()+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">서버아이디</th>';
		str += '                   <td class="fontW_b">'+$('#server_id').val()+'</td>';
		str += '                   <th scope="row">서버비밀번호</th>';
		str += '                   <td class="fontW_b">'+$('#server_pw').val()+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">DUR브로커IP</th>';
		str += '                   <td colspan="5" scope="row">'+$('#dur_ip').val()+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">유지보수계약일자</th>';
		str += '                   <td class="fontW_b">'+$('#mtac_contract_dt').val()+'</td>';
		str += '                   <th scope="row">서버유지보수업체</th>';
		str += '                   <td class="fontW_b" colspan="3">'+mtTextArr.join(", ")+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">PC</th>';
		str += '                   <td class="fontW_b">'+$('#pc').val()+'</td>';
		str += '                   <th scope="row">서버백신</th>';
		str += '                   <td class="fontW_b">'+vcTextArr.join(", ")+'</td>';
		str += '               </tr>';
		str += '           </table>';
		str += '           <!--// write -->';
		str += '           <!-- write -->';
		str += '           <div class="tit_bWrap mgb10">';
		str += '               <h4>상세 정보</h4>';
		str += '           </div>';
		str += '           <table class="sType mgb20">';
		str += '               <caption>상세 정보 입력</caption>';
		str += '               <colgroup>';
		str += '                   <col style="width:125px;" />';
		str += '                   <col style="width:260px;" />';
		str += '                   <col style="width:125px;" />';
		str += '                   <col style="width:260px;" />';
		str += '               </colgroup>';
		str += '               <tr>';
		str += '                   <th scope="row">건물구조</th>';
		str += '                   <td class="fontW_b">'+bdTextArr.join(", ")+'</td>';
		str += '                   <th scope="row">병상수</th>';
		str += '                   <td class="fontW_b">'+$('#bed_count').val()+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">진료과</th>';
		str += '                   <td class="fontW_b">'+$('#medical_office').val()+'</td>';
		str += '                   <th scope="row">진료지원과</th>';
		str += '                   <td class="fontW_b">'+$('#support_office').val()+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">진료과2</th>';
		str += '                   <td class="fontW_b">'+$('#medical_office2').val()+'</td>';
		str += '                   <th scope="row">전문병원여부</th>';
		str += '                   <td class="fontW_b">'+specially_code+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">의사수</th>';
		str += '                   <td class="fontW_b">'+$('#doctor_count').val()+'</td>';
		str += '                   <th scope="row">간호사수</th>';
		str += '                   <td class="fontW_b">'+$('#nurse_count').val()+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">보훈여부</th>';
		str += '                   <td class="fontW_b">'+chk1+'</td>';
		str += '                   <th scope="row">군지역소재</th>';
		str += '                   <td class="fontW_b">'+chk2+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">신규/기존</th>';
		str += '                   <td class="fontW_b">'+new_code+'</td>';
		str += '                   <th scope="row">기존전산업체</th>';
		str += '                   <td class="fontW_b">'+$('#old_company_nm').val()+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">일 평균 내원수</th>';
		str += '                   <td class="fontW_b">'+$('#come_count').val()+'</td>';
		str += '                   <th scope="row">평균재원자수</th>';
		str += '                   <td class="fontW_b">'+$('#average_count').val()+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">외부수탁업체</th>';
		str += '                   <td class="fontW_b">'+outside_cust_code+'</td>';
		str += '                   <th scope="row">청구여부</th>';
		str += '                   <td class="fontW_b">'+chk3+'</td>';
		str += '               </tr>';
		str += '               <tr>';
		str += '                   <th scope="row">기타설명</th>';
		str += '                   <td colspan="3" class="fontW_b">'+$('#detail_etc').val()+'</td>';
		str += '               </tr>';
		str += '           </table>';
		str += '           <!--// write -->';
		str += '           <!-- list -->';
		str += '           <div class="tit_bWrap mgb10">';
		str += '               <h4 class="floatL mgt8">담당자 정보</h4>';
		str += '           </div>';
		str += '           <table class="hType mgb20" style="">';
		str += '               <caption>담당자 정보 목록</caption>';
		str += '               <colgroup>';
		str += '                   <col span="5" style="width:auto" />';
		str += '               </colgroup>';
		str += '               <thead>';
		str += '                   <tr>';
		str += '                       <th scope="row">담당 구분</th>';
		str += '                       <th scope="row">담당자명</th>';
		str += '                       <th scope="row">연락처1(회사)</th>';
		str += '                       <th scope="row">연락처2(핸드폰)</th>';
		str += '                       <th scope="row">이메일</th>';
		str += '                       <th scope="row">비고</th>';
		str += '                   </tr>';
		str += '               </thead>';
		str += '               <tbody>';
		var bdLenth = $('#cg_wrap tr').length;
		
		for (var i = 1; i <= parseInt(bdLenth); i++) {
			var charge_code = ($('#charge_code'+i+' option:selected').text() == '선택') ? " " : $('#charge_code'+i+' option:selected').text();
			if(charge_code == " ") { continue; }
			str += '                   <tr>';
			str += '                       <td class="fontW_b">'+charge_code+'</td>';
			str += '                       <td class="fontW_b">'+$('#charge_nm'+i).val()+'</td>';
			str += '                       <td class="fontW_b">'+$('#company_tel_no'+i).val()+'</td>';
			str += '                       <td class="fontW_b">'+$('#hp_no'+i).val()+'</td>';
			str += '                       <td class="fontW_b">'+$('#email'+i).val()+'</td>';
			str += '                       <td class="fontW_b">'+$('#etc'+i).val()+'</td>';
			str += '                   </tr>';				
		}	
		str += '               </tbody>';
		str += '           </table>';
		str += '           <!--// list -->';
		str += '	</div>';
		str += '	<button type="button" class="btn_close" onclick="commonReport.close();">창 닫기</button>';
		str += '</div>';
		str += '<div class="layer_dimmed"></div>';
		str += '</div>';
		
		$('body').append(str);
	},
	
	close : function() {
		$('#reportPop').remove();
	}
}

function getCurrentDateTime() {
	var d = new Date();
	var FullYear = d.getFullYear() + "/" + (d.getMonth() + 1) + "/" + d.getDate();
	var FullTime = d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds();
	var FullText =  FullYear + " " +  FullTime;
	return FullText;
}
