<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<jsp:include page="/WEB-INF/jsp/fr/common/chatbot.jsp" />

<style>
        ol {
            margin-bottom: 10px; /* 리스트 아이템 사이의 간격 */
        }
        li {
        	font-size: 12px; /* 강조된 텍스트의 크기 */
            margin-bottom: 10px; /* 리스트 아이템 사이의 간격 */
        }
        li strong {
            font-size: 12px; /* 강조된 텍스트의 크기 */
        }
        .indent {
            display: block; /* 블록 요소로 변경하여 전체 줄을 들여쓰기 */
            margin-left: 20px; /* 들여쓰기 설정 */
        }
        
    .as-card {
        border: 1px solid #dedede;
        border-radius: 4px;
        padding: 10px 12px;
        margin-bottom: 10px;
        background: #fafafa;
    }
    .as-card-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 6px;
        font-size: 13px;
    }
    .as-card-date {
        color: #777;
        font-weight: 600;
    }
    .as-card-asno {
        color: #0090c8;
        font-weight: 700;
    }
    .as-card-meta {
        font-size: 12px;
        color: #555;
        margin-bottom: 6px;
    }
    .as-card-body {
        font-size: 12px;
        color: #555;
        line-height: 1.5;
        white-space: pre-line; /* 줄바꿈 유지 */
        border-top: 1px solid #dedede;
        padding-top: 5px;
    }
    .as-card-body-label {
        font-weight: 600;
        margin-right: 4px;
    }
    .as-card-requester {
        margin-top: 4px;
        text-align: right;
        font-size: 11px;
        color: #999;
    }
    .as-card-header label {
    cursor: pointer;
	}
	.as-card-header input[type="checkbox"] {
	    margin-right: 4px;
	    vertical-align: middle;
	}
    
</style>

<script type="text/javascript">


	var fileCnt = 1 ; 
	var a = '' ; 
	var b = '' ; 
	var c = '' ; 
	var d = '' ; 
	
	var chatbotWindow = null;
	
	var selectedAsNos = [];
	
	var unprocessedAsMap = {};

	// 요청 내용 기본 텍스트
	var defaultCallContent =
	"※ 요청 내용이 구체적이지 않을 경우, 접수 및 처리가 지연될 수 있으니 가능한 상세히 작성해 주시기 바랍니다.\n" +
	"(첨부파일이 있으면 신속한 처리가 가능합니다.)\n\n" +
	"1. 프로그램명 : \n\n" +
	"2. 화면명 : \n\n" +
	"3.환자등록번호 : \n\n" +
	"4.발생일시 : \n\n" +
	"5. 내용 : ";
	
	$(document).ready(function(){
		
		try {
	        var ua = navigator.userAgent;
	        var isChrome = ua.indexOf("Chrome") > -1 && ua.indexOf("Edg") === -1 && ua.indexOf("OPR") === -1;
	        var isEdge = ua.indexOf("Edg") > -1;

	        if ((isChrome || isEdge) && window.URLSearchParams) { // Chrome 또는 Edge일 때만
	            var urlParams = new URLSearchParams(window.location.search);
	            var callContent = urlParams.get("call_content");
	            var chatbotId = urlParams.get("chatbot_id");

	            if (callContent && $("#call_content").length) {
	            	$("#call_content").val(callContent.replace(/\s*\(챗봇 요약\)\s*/g, ""));
	            	$("#call_content3").val(callContent.replace(/\s*\(챗봇 요약\)\s*/g, ""));
	            }

	            if (chatbotId && $("#chatbot_id").length) {
	                $("#chatbot_id").val(chatbotId);
	            }
	        }
	    } catch(e) {
	        console.warn("URL 파라미터 처리 중 오류:", e);
	        // IE 포함 모든 브라우저에서 오류 발생해도 무시하고 다음 코드 실행
	    }
	    
	    
		
		/**	selectBox 초기화	*/
		commonCode.getCodeList('AS' , 'CD07' , 'request_type') ; 		/**	문의유형		*/
		$('#request_type').find('option[value="C999"]').remove();
		commonCode.getCodeList('AS' , 'CD03' , 'service_cate') ; 		/**	시스템(대)		*/
		$('#inquiry_type').append(commonCode.defaultViewOption);	
		/**	textarea 처리	*/
		$('#call_content2').keyup(function (e){
	          var content = $(this).val();
	          if(content.length >= 1000){
	        	  content = content.substring(0 , 1000) ;
	        	  $(this).val(content)
	          }
	          
	          $('#call_content2_text').html(content.length + '/ 1000 자');
	     });
		
		$("#call_content2").val(defaultCallContent);		
		
		$("#search_start3" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$("#search_end3" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		addMultiFile() ; 
		getTelList() ; 
		showRequestTypePopLayer();
		
		changeSearch3();
		
		var datas = {'cust_code' : '${ frUserInfo.cust_code}' , 'is_page_gbn' : 'fr'} ; 
		common.ajaxCall(datas , '/ad/member/getCustInfo2.do', 'makeCustInfo') ;
		
		 $('#unprocessedas-box').on('change', 'input.chk-as', function(){
		        var no = $(this).val();

		        if ($(this).is(':checked')) {
		            // 중복 없이 추가
		            if (selectedAsNos.indexOf(no) === -1) {
		                selectedAsNos.push(no);
		            }
		        } else {
		            // 해제되면 배열에서 제거
		            selectedAsNos = selectedAsNos.filter(function(v){
		                return v !== no;
		            });
		        }
		    });
		 

		  $('#linkLayer').on('keydown', '#search_text', function(e){
		    if (e.keyCode === 13) {
		      e.preventDefault();
		      getUnprocessedAsList();
		    }
		  });
		
		
	}) ;
	
	function makeCustInfo(data){
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null ; 
		if(resultVO != null){
			a = common.nvl(resultVO.his_basic_code, '') ;		/**	기초	*/  
			b = common.nvl(resultVO.his_treat_code, '') ;		/**	진료	*/ 
			c = common.nvl(resultVO.his_work_code, '') ;		/**	업무	*/ 
			d = common.nvl(resultVO.his_claim_code, '') ;	/**	청구	*/ 
		}
	}
	
	function addMultiFile(){
		var str = '' ; 
		
		str += '<div id="multiFile'+fileCnt+'">' ; 
		str += '		<input type="file" id="uploadFile_'+fileCnt+'" name="uploadFile_'+fileCnt+'">' ; 
		
		if(fileCnt > 1) 	str += '	<button class="btn_minus mgl5" onclick="deleteFile('+fileCnt+');"></button>';
		else 						str += '	<button class="btn_plus mgl5" onclick="addMultiFile();"></button>';
		
		str += '</div>' ; 
		
		$('#fileList').append(str) ; 
		fileCnt++ ; 
	}
	
	function deleteFile(cnt){
		$('#multiFile'+cnt).remove();
	}
	
	function goList(){
		location.href = "/fr/as/list.do" ; 
	}
	
	function goClear(){
		
		document.procFrm.reset() ;
		
		$("#call_content").val($("#call_content3").val());
		fileCnt = 1 ; 
		$('#fileList').empty() ; 
		addMultiFile() ; 
		getTelList();
		$('#system_type').hide();
		$('#asno_list').hide();
		$("#call_content2").val(defaultCallContent);	
	}
	
	function goSave(){
		
		var f = document.procFrm ; 
		
		if(common.isEmpty($('#request_type').val())){
			alert("문의유형을 선택해 주세요.") ;
			return ;
		}
		
		if($('#request_type').val() == "C010"){
			if (common.isEmpty($('#as_no_link').val())){
				alert('재문의 선택 시 최소 하나 이상의 연관된 접수번호를 선택해야합니다.');
				return ;
			}
		}
		
		//2025.03.12 김규민 2차분류가 필수인 경우 시스템(대),시스템(소)는 필수값 체크
		if ($('#val2').val() == 'Y') {
			if (common.isEmpty($('#service_cate').val())) {
				alert('시스템(대)를 선택하세요.');
				$('#service_cate').focus(); 
				return;
			}	
			
			if (common.isEmpty($('#inquiry_type').val())) {
				alert('시스템(소)를 선택하세요.');
				$('#inquiry_type').focus(); 
				return;
			}	
		}
		
		if(typeof $("input:radio[name=phone]:checked").val() != "undefined"){
			
			var hp_no = "" ;
			var phone_gbn = $("input:radio[name=phone]:checked").val() ;
			console.log(phone_gbn);
			for(var i = 1; i <=3 ; i++){
				console.log('#phone'+phone_gbn+'_' + i);
				console.log($('#phone'+phone_gbn+'_' + i).val());
				if(common.isNotEmpty($('#phone'+phone_gbn+'_' + i).val())){
					
					if(hp_no == "") hp_no = $('#phone'+phone_gbn+'_' + i).val() ; 
					else hp_no = hp_no + "-" + $('#phone'+phone_gbn+'_' + i).val() ;
					
				}else{
					alert("연락처를 입력해 주세요.") ; return ; 
				}
			}
			
			$('#apply_tel').val(hp_no) ; 
		}else{
			alert("연락받으실 전화번호를 선택해 주세요.") ;		return ;
		}
		
		if(typeof $("input:radio[name=send_sms]:checked").val() == "undefined"){
			alert("SMS수신동의여부를 선택해주세요.") ;		return ; 
		}
		
		if(common.isEmpty($('#rl_apply_nm').val())){
			alert("신청자명을 입력해 주세요.") ;		return ; 
		}
		
		if(common.isEmpty($('#call_content2').val())){
			alert("요청 내용을 입력해 주세요.") ;		return ; 
		}
		
	
		if(confirm("A/S를 등록하시겠습니까?\n선택하신 문의유형에 따라 담당자가 자동배정됩니다.")){
			
			$('#request_type').prop('disabled',false);
			$('#service_cate').prop('disabled',false);
			$('#inquiry_type').prop('disabled',false);
			
			var call_content = $("#call_content").val();
			var call_content2 = $("#call_content2").val();
			
			$("#call_content").val("0. 챗봇요약 : " + call_content + "\n\n" + call_content2);
			
			f.target = "hiddenFrame" ; 
			f.action = "/fr/as/proc.do" ; 
			f.submit();
		}
	}
	
	function procReturn(flag , msg){
		alert(msg) ;
		if(flag == "success") goList() ; 
	}
	
	function getTaskType(request_type){
		
		$('#service_cate').val('') ;
		$('#inquiry_type').empty() ; 
		$('#version_info').val('') ; 
		$('#version_info_str').val('') ;
		$('#assign_id').val('') ;
		
		$('#inquiry_type').append(commonCode.defaultViewOption);
		
		var datas = {
				'request_type' : request_type,
				'pageType' : '${ vo.pageType }'
			}
		
			common.ajaxCall(datas, '/fr/as/getTaskType.do', 'setTaskType');
	}
	
	function setTaskType(data) {
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList
				: null;
		
		commonCode.getCodeList('AS' , 'CD03' , 'service_cate') ;
		
		$('#val2').val(resultList.val2);
		
		if (resultList.val2 == 'Y') {
			$('#assign_id').val('') ;
			
			
			$('#system_type').show();
			$('#asno_list').hide();
			$('#service_cate').prop('disabled', false).removeClass('write_gray');
			
			
			if($('#request_type').val() == 'C011'){
				setService_cate("P010");
				$('#service_cate').prop('disabled', true).addClass('write_gray');
				$('#service_cate').val("P010");
			}else{
				setService_cate($('#service_cate').val());
				$('#service_cate').find('option[value="P010"]').remove();
				$('#service_cate').prop('disabled', false).removeClass('write_gray');
			}
			
		} else {
			$('#system_type').hide();
			
			if($('#request_type').val() == "C010"){
				$('#asno_list').show();
			}else{
				$('#asno_list').hide();
			}
			
			$('#version_info').val('') ; 
			$('#version_info_str').val('') ;
			
			/* 처리담당자 정보 가져오기*/
			var datas = {
					'request_type' : $('#request_type').val(),
					'val2' : $('#val2').val(),
					'pageType' : '${ vo.pageType }'
				}
			
				common.ajaxCall(datas, '/fr/as/getWorker.do', 'setWorker');
		
		}
	}
	
	function setWorker(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		$('#assign_id').val('') ;

		if(data != ""){
			$('#assign_id').val(resultList.wk_emp_no);
		}
		
	}
	
	function setService_cate(thisObj){
		
		$('#inquiry_type').empty() ; 
		$('#assign_id').val('') ;
		$('#version_info').val('') ; 
		$('#version_info_str').val('') ; 
		
		if(thisObj != ""){
			commonCode.getCodeList('AS' , thisObj , 'inquiry_type') ;
			
			if(thisObj == "P002"){ $('#version_info').val(a) ; if(a != "") $('#version_info_str').val(commonCode.getCodeNm('CUST' , 'CD04' , a));}
			else if(thisObj == "P003"){ $('#version_info').val(b) ; if(b != "") $('#version_info_str').val(commonCode.getCodeNm('CUST' , 'CD05' , b));}
			else if(thisObj == "P004"){ $('#version_info').val(c) ; if(c != "") $('#version_info_str').val(commonCode.getCodeNm('CUST' , 'CD06' , c));}
			else if(thisObj == "P005"){ $('#version_info').val(d) ; if(d != "") $('#version_info_str').val(commonCode.getCodeNm('CUST' , 'CD07' , d));}
			else if(thisObj == "P008"){$('#inquiry_type').find('option[value="C999"]').remove();}
		}else{
			$('#inquiry_type').append(commonCode.defaultViewOption);	
		}
	}
	
	function getInquiry_type(inquiry_type){
		
		/* 처리담당자 정보 가져오기*/
		
		var datas = {
				'request_type' : $('#request_type').val(),
				'service_cate' : $('#service_cate').val(),
				'inquiry_type' : inquiry_type,
				'val2' : $('#val2').val(),
				'pageType' : '${ vo.pageType }'
			}
		
		common.ajaxCall(datas, '/fr/as/getWorker.do', 'setWorker');
	}
	
	function getTelList(){
		common.ajaxCall({} , '/fr/as/getEmpTelList.do', 'makeTelList') ;
	}
	
	function makeTelList(data){
		var asDamTel = typeof  data.asDamTel != "undefined" ? data.asDamTel : null ;
		var asMyTel = typeof  data.asMyTel != "undefined" ? data.asMyTel : "" ; 
		
		if(asDamTel != null){
			if(common.nvl(asDamTel.tel_no, '') != ''){
				$('#phone2_1').val(common.spritStr(asDamTel.tel_no , 1, '-')) ; 
				$('#phone2_2').val(common.spritStr(asDamTel.tel_no , 2, '-')) ; 
				$('#phone2_3').val(common.spritStr(asDamTel.tel_no , 3, '-')) ; 
			}
		}
		
		if(common.nvl(asMyTel, '') != ''){
			$('#phone1_1').val(common.spritStr(asMyTel , 1, '-')) ; 
			$('#phone1_2').val(common.spritStr(asMyTel , 2, '-')) ; 
			$('#phone1_3').val(common.spritStr(asMyTel , 3, '-')) ; 
		}
	}
	
	function showRequestTypePopLayer() {
		$('#div7').show();
		$("#div7")
				.css(
						{
							"top" : (($(window).height() - $("#div7")
									.outerHeight()) / 2 + $(window).scrollTop())
									+ 200 + "px"
						});
		$('#div7_dim').show();
	}
	
	function closeLayer(num) {
		$('#div'+num).hide() ; 
		$('#div'+num+'_dim').hide() ; 
	}
	
	function showLinkLayer(){
	    var current = $('#as_no_link').val();
	    if (current && current.trim() !== '') {
	        selectedAsNos = current.split(',').map(function(v){ return v.trim(); });
	    } else {
	        selectedAsNos = [];
	    }

	    getUnprocessedAsList();
	    $('#linkLayer').show();
	    $('#div_dim').show();
	}
	
	function getUnprocessedAsList(){
		
		var datas ={
				'as_str_dt' :  $("#search_start3").val(),
				'as_end_dt' :  $("#search_end3").val(),
				'asGubunFlag' : $("input[type=radio][name=type1]:checked").val(),
				'cust_code' : $('#cust_code').val(),
				'user_id' : $("#user_id").val(),
				'search_text' : $("#search_text").val()
		}
		
		console.log(datas.asGubunFlag);
		common.ajaxCall(datas, '/fr/as/getUnprocessedAsList.do','setUnprocessedAsList');
	}
	
 
	function setUnprocessedAsList(data){

		  $('#asList').empty();

		  var raw = typeof data.resultList != "undefined" ? data.resultList : null;

		  // 매번 맵 초기화
		  unprocessedAsMap = {};

		  if (!raw || raw.length == 0) {
		    var emptyRow = ''
		      + '<tr>'
		      + '  <td colspan="3" style="text-align:center; padding:20px;">'
		      + '    해당 날짜의 미처리 A/S가 없습니다.<br>다시 조회해 주세요.'
		      + '  </td>'
		      + '</tr>';
		    $('#asList').html(emptyRow);
		    return;
		  }

		  // 선택된 것 먼저 보여주기
		  var selected = [];
		  var others = [];

		  for (var i = 0; i < raw.length; i++) {
		    var v = raw[i];
		    unprocessedAsMap[String(v.AS_NO)] = v;

		    if (selectedAsNos.indexOf(String(v.AS_NO)) >= 0) selected.push(v);
		    else others.push(v);
		  }

		  var result = selected.concat(others);
		  var str = '';

		  for (var j = 0; j < result.length; j++) {
		    var val = result[j];

		    var asNo = escapeHtml(val.AS_NO);
		    var callContent = (val.CALL_CONTENT || '').replace(/\r?\n/g, ' ').replace(/\s+/g, ' ').trim();
		    var callContentTitle = escapeHtml(callContent);
		    var checked = (selectedAsNos.indexOf(String(val.AS_NO)) >= 0) ? ' checked' : '';

		    str += ''
		    	  + '<tr>'
		    	  + '  <td><input type="checkbox" class="chk-as" value="' + asNo + '"' + checked + '></td>'
		    	  + '  <td>' + asNo + '</td>'
		    	  + '  <td title="' + callContentTitle + '" style="text-align:left; white-space:pre-line;">'
		    	  +       escapeHtml(callContent.substr(0, 33))
		    	  + '  </td>'
		    	  + '</tr>';
		  }

		  $('#asList').html(str);
		}
	
	function changeSearch3(){

	}
	
	function confirmUnprocessedAs() {

	    if (selectedAsNos.length === 0) {
	        alert('선택된 A/S가 없습니다.');
	        return;
	    }

	    var latestNo = null;
	    var latestDateNum = null;

	    // 선택된 A/S 중 가장 최신 건 찾기
	    selectedAsNos.forEach(function(no) {
	        var info = unprocessedAsMap[String(no)];
	        if (!info) return;

	        var dStr = (info.REG_DATE || '').replace(/[^\d]/g, ''); // YYYYMMDD
	        if (dStr.length !== 8) return;

	        var dNum = parseInt(dStr, 10);
	        if (latestDateNum === null || dNum > latestDateNum) {
	            latestDateNum = dNum;
	            latestNo = String(no);
	        }
	    });

	    // 날짜 비교에 실패했으면 마지막 선택 건으로 대체
	    if (!latestNo) {
	        latestNo = String(selectedAsNos[selectedAsNos.length - 1]);
	    }

	    var latestInfo = unprocessedAsMap[latestNo];

	    // 1. 연관된 접수번호 세팅
	    var joined = selectedAsNos.join(',');
	    $('#as_no_link_str').val(joined);
	    $('#as_no_link').val(joined);

	    // 2. 요청내용 자동 기입
	    if (latestInfo && latestInfo.CALL_CONTENT) {
	        var current = $('#call_content2').val() || '';

	        // 템플릿만 있을 때만 교체
	        if (isOnlyTemplate(current, defaultCallContent)) {
	            $('#call_content2').val(latestInfo.CALL_CONTENT);
	        }
	        // 이미 뭔가 써 있으면 아무것도 안 함
	    }
	    
	 // 3. 신청자명 자동 기입
	    if (latestInfo && latestInfo.RL_APPLY_NM) {
	        var current = $('#rl_apply_nm').val();

	        // 공백일 경우에만 기입
	        if (!current || $.trim(current) === '') {
	            $('#rl_apply_nm').val(latestInfo.RL_APPLY_NM);
	        }
	        // 이미 뭔가 써 있으면 아무것도 안 함
	    }
	 
	 // 4. 연락처 자동 기입 (직접입력 phone3_1~3) - 하이픈 기준
	    if (latestInfo && latestInfo.APPLY_TEL) {

	      // 이미 직접입력칸에 값이 있으면 건드리지 않기
	      var hasAny =
	        $.trim($('#phone3_1').val() || '') !== '' ||
	        $.trim($('#phone3_2').val() || '') !== '' ||
	        $.trim($('#phone3_3').val() || '') !== '';

	      if (!hasAny) {
	        var tel = String(latestInfo.APPLY_TEL || '');
	        var parts = tel.split('-');

	        if (parts.length >= 3) {
	          $('#phone3_1').val($.trim(parts[0]));
	          $('#phone3_2').val($.trim(parts[1]));
	          $('#phone3_3').val($.trim(parts[2]));

	          $('#phone3').prop('checked', true);
	        }
	      }
	    }

	    $('#linkLayer').hide();
	    $('#div_dim').hide();
	}

	function clearUnprocessedAs(){
	    selectedAsNos = [];
	    $('#unprocessedas-box input.chk-as').prop('checked', false);
	    $('#as_no_link_str').val('');
	    $('#as_no_link').val('');
	}
	
	function isOnlyTemplate(current, template) {
	    var cur = (current || '').replace(/\r\n/g, '\n');
	    var tmpl = (template || '').replace(/\r\n/g, '\n');

	    if (cur.indexOf(tmpl) !== 0) return false;

	    var rest = cur.slice(tmpl.length);
	    return rest.trim().length === 0;
	}
	
	function escapeHtml(s) {
		  return String(s == null ? '' : s)
		    .replace(/&/g, '&amp;')
		    .replace(/</g, '&lt;')
		    .replace(/>/g, '&gt;')
		    .replace(/"/g, '&quot;')
		    .replace(/'/g, '&#39;');
		}
	
</script>
<div id="jw_contents">
	<div class="tit_wrap">
		<h2 class="tit_ico_admin">A/S 신청</h2>
		<div class="location">
			<a href="/fr/main/list.do" class="home">Home</a>
			<a href="/fr/as/form.do" class="depth"><span class="here">A/S 신청</span></a>
		</div>
	</div>
	
	
	<ul class="tab_back mgb30">
		<li class="active"><a href="/fr/as/form.do">A/S 신청등록</a></li><!-- 활성시 current -->
		<li><a href="/fr/as/list.do">신청 등록 현황</a></li>
	</ul>
	
	<form name="procFrm" id="procFrm" method="post" enctype="multipart/form-data" onsubmit="return false;">
		<input type="hidden" name="apply_tel" id="apply_tel" value=""/>	<!-- 등록자 연락처 -->
		<input type="hidden" name="val2" id="val2" value=""/>
		<input type="hidden" name="assign_id" id="assign_id" value=""/>
		<input type="hidden" name="chatbot_id" id="chatbot_id" value=""/>
		<input type="hidden" name="call_content3" id="call_content3" value=""/>
		<input type="hidden" name="user_id" id="user_id" value=${ frUserInfo.emp_id } />
		<input type="hidden" name="cust_code" id="cust_code" value=${ frUserInfo.cust_code } />
	
		<div class="tit_sWrap">
			<h3 class="tit_bold_gray">문의 서비스 정보</h3><span style="margin-left: 30px; color:red;">※선택하신 문의 유형에 따라 담당자가 자동 배정됩니다.</span> <!--KR -->
		</div>
	
		<table class="sType mgb30">
			<caption>A/S 신청 제품 정보 입력</caption>
			<colgroup>
				<col style="width:180px;" />
				<col style="width:317px;" />
				<col style="width:180px;" />
				<col style="width:323px;" />
			</colgroup>
			<tr>
				<th scope="row">문의유형<span class="request">필수 입력</span></th>
				<td>
					<select  name="request_type" id="request_type" title="문의유형 선택" class="w170" onchange="javascript:getTaskType(this.value);"></select>
					<button type="button" id="btnProgramName" class="btn_line_gray2" style="width:100px"
						onclick="showRequestTypePopLayer()">문의유형 기준표</button>
				</td>
				<th scope="row">버전정보</th>
				<td>
					<input type="text" 	id="version_info_str" readonly="readonly">
					<input type="hidden" name="version_info" id="version_info" >
				</td>
			</tr>
			<tr id="system_type" style="display: none;">
				<th scope="row">시스템(대)<span class="request">필수 입력</span></th>
				<td>
					<select class="w277" title="시스템(대) 선택" name="service_cate" id="service_cate" onchange="javascript:setService_cate(this.value);"></select>
				</td>
				<th scope="row">시스템(소)<span class="request">필수 입력</span></th>
				<td>
					<select title="시스템(소) 선택" id="inquiry_type" name="inquiry_type" onchange="javascript:getInquiry_type(this.value);"></select>
				</td>
			</tr>
			<tr id="asno_list" style="display: none;">
				<th scope="row">연관된 접수번호<span class="request">필수 입력</span></th>
				<td colspan="3">
					<input type="text" 	id="as_no_link_str" readonly="readonly" style="width: 676px !important; white-space: nowrap !important; overflow: hidden; text-overflow: ellipsis;">
					<input type="hidden" name="as_no_link" id="as_no_link" >
					<button type="button" id="btnUnprocessedAs" class="btn_line_gray2" style="width:100px" onclick="showLinkLayer()">AS내역 조회</button>
				</td>
			</tr>
		</table>
	<!--// A/S 신청 제품 정보 -->

	<!-- 기본 정보 -->
	<div class="tit_sWrap">
		<h3 class="tit_bold_gray">기본 정보</h3>
	</div>
	<table class="sType mgb30">
		<caption>기본 정보 입력</caption>
		<colgroup>
			<col style="width:180px;" />
			<col style="width:auto;" />
		</colgroup>
		<tr>
			<th scope="row">작성 요령</th>
			<td>
			<div class="mgb5" style="padding-left: 5px; height: 210px !important;">
				    <strong style="font-size: 15px;">아래 내용을 포함하여 문의해 주시면 원활한 해결에 도움이 됩니다 :)</strong>
				    <ol></ol>
				    <ol>
				        <li><strong>1.프로그램 명칭 및 화면:</strong> 문제가 발생한 프로그램명칭과 화면을 구체적으로 적어주세요.<br>
				            <strong class="indent">Ex. 외래접수수납프로그램의 수납화면</strong></li>
				        <li><strong>2.동작:</strong> 어떤 동작을 수행했을 때 문제가 발생했는지 적어주세요.<br>
				            <strong class="indent">Ex. [저장] 버튼을 눌렀을 때</strong></li>
				        <li><strong>3.현상:</strong> 문제가 발생했을 때 어떤 현상이 나타나는지 설명해 주세요.<br>
				            <strong class="indent">Ex. 무반응, 오류 팝업 발생, 단가착오 등</strong></li>
				        <li><strong>4.오류 팝업 내용:</strong> 오류 팝업이 발생했다면, 팝업 내용을 기재하거나 스크린샷을 파일첨부해 주세요.</li>
				    </ol>
				    <strong style="color: red; font-size: 16px;">※ 요청 내용이 구체적이지 않을 경우, 접수 및 처리가 지연될 수 있으니 가능한 상세히 작성해 주시기 바랍니다.</strong>
				</div>
			</td>
		</tr>
		<tr>
			<th scope="row">챗봇요약</th>
			<td>
				<textarea name="call_content" id="call_content" cols="30" rows="10" value="테스트" readonly="readonly" style="height:50px !important; background : #E0E0E0"></textarea>
			</td>
		</tr>
		<tr>
			<th scope="row">요청 내용<span class="request">필수 입력</span></th>
			<td>
				<textarea name="call_content2" id="call_content2" style="height:300px !important;"></textarea>
				<div class="txt_byte" id="call_content2_text">147 / 1000 자</div>
			</td>
		</tr>
		<tr>
			<th scope="row">신청자명<span class="request">필수 입력</span></th>
			<td>
				<input class="w277" type="text" name="rl_apply_nm" id="rl_apply_nm" />
			</td>
		</tr>
		<tr>
			<th scope="row">연락받으실 전화번호<span class="request">필수 입력</span></th>
			<td>
				<dl class="box_phone_num">
					<dt><input type="radio" name="phone" id="phone1" class="mgr10" value="1"/><label for="phone1">본인 연락처</label></dt>
					<dd>
						<input type="text" id="phone1_1" readonly="readonly" class="w60" title="본인 연락처1" /><span class="txt_dash">-</span>
						<input type="text" class="w60" id="phone1_2" readonly="readonly" title="본인 연락처2" /><span class="txt_dash">-</span>
						<input type="text" class="w60" id="phone1_3" readonly="readonly" title="본인 연락처3" />
					</dd>
					<dt class="w142"><input type="radio" name="phone" id="phone2" class="mgr10" value="2"/><label for="phone2">대표 담당자 연락처</label></dt>
					<dd>
						<input type="text" id="phone2_1" readonly="readonly" class="w60" title="대표 담당자 연락처1" /><span class="txt_dash">-</span>
						<input type="text" class="w60" id="phone2_2" readonly="readonly" title="대표 담당자 연락처2" /><span class="txt_dash">-</span>
						<input type="text" class="w60" id="phone2_3" readonly="readonly" title="대표 담당자 연락처3" />
					</dd>
					<dt class="mgt8"><input type="radio" name="phone" id="phone3" class="mgr10" value="3" /><label for="phone3">직접입력</label></dt>
					<dd class="mgt8">
						<input type="text" id="phone3_1" class="w60" title="직접입력1" /><span class="txt_dash">-</span>
						<input type="text" class="w60" id="phone3_2" title="직접입력2" /><span class="txt_dash">-</span>
						<input type="text" class="w60" id="phone3_3" title="직접입력3" />
					</dd>
				</dl>
			</td>
		</tr>
		<tr>
			<th scope="row">SMS수신동의여부<span class="request mgl5">필수 입력</span></th>
			<td>
				<input type="radio" name="send_sms" id="send_sms1" class="mgr10" value="Y"/>
				<label for="send_sms1">동의</label>
				<input type="radio" name="send_sms" id="send_sms2" class="mgr5 mgl10" value="N" checked="checked"/>
				<label for="send_sms2">미동의</label>
				<span style="margin-left: 30px; color:red;">※동의 후 핸드폰번호 기재 시, A/S처리현황을 SMS 또는 알림톡으로 전송해드립니다.</span>
			</td>
		</tr>
		<tr>
			<th scope="row">파일첨부</th>
			<td id="fileList"></td>
		</tr>
	</table>
	<!--// 기본 정보 -->

	<!--// write -->
	<div class="btn_wrap">
		<div class="floatL">
			<button type="button" class="btn_ico_reset" onclick="javascript:goClear();"><span>초기화</span></button>		
		</div>
		<div class="floatR">
			<button type="button" class="btn_ico_regist" onclick="javascript:goSave();"><span>등록</span></button>
			<button type="button" class="btn_ico_cancel" onclick="javascript:goList();"><span>취소</span></button>
		</div>
	</div>
	
	</form>
	
	<!-- 문의유형 기준표 --> <!--KI -->
<div class="box_layer layer_sms" style="display: none; height: 640px;"
	id="div7">
	<h1>문의유형 기준표</h1>
	<div class="layer_contents pdt20" style="height: 620px; font-size:12px !important; color:#3a3a3a !important;" >
		<table class="stats_hType mgb10 scroll-table">
			<caption>문의유형 기준표</caption>
			<colgroup>
				<col style="width: 40px;" />
				
				
				<col style="width: 150px;" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">문의유형</th>
					<th scope="col">설명</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td><strong>프로그램 실행불가</strong></td>
				    <td style="text-align: left;">
				        <strong>Ontic HIS 프로그램 <span style="color: red;">실행 및 작동이 완전히 불가능</span>한 경우</strong>
				        <br>
				        &nbsp;&nbsp;- “프로그램이 안켜져요.”
				        <br>
				        &nbsp;&nbsp;- “특정 버튼만 누르면 프로그램이 꺼져요.”
				    </td>
				</tr>
				<tr>
					<td><strong>프로그램 일부오류</strong></td>
					<td style="text-align: left;">
					<strong>Ontic HIS 프로그램 <span style="color: red;">사용은 가능하나, 일부 기능에 오류</span>가 있는 경우</strong>
					<br>
					&nbsp;&nbsp;- 기능, 배포, 업데이트, 설치, 패치 오류 등
					</td>
				</tr>
				<tr>
					<td><strong>프로그램 기능/사용법 문의</strong></td>
					<td style="text-align: left;">
					<strong><span style="color: red;">Ontic HIS 프로그램의 기능에 대한 문의</span>하는 경우</strong>
					<br>
					&nbsp;&nbsp;- 서식지 수정 및 요청
					<br>
					&nbsp;&nbsp;- 청구/수가 점검오류 확인 
					<br>
					&nbsp;&nbsp;- 정책 및 법령(보험법) 반영 관련
					<br>
					&nbsp;&nbsp;- 교육, 매뉴얼 요청 등
					</td>
				</tr>
				<tr>
					<td><strong>프로그램 개선 문의</strong></td>
					<td style="text-align: left;">
					<strong>Ontic HIS 프로그램 오류가 아닌 <span style="color: red;">프로그램 기능 개선</span>에 대한 문의</strong>
					</td>
				</tr>
				<tr>
					<td><strong>서버 점검 요청</strong></td>
					<td style="text-align: left;">
					<strong><span style="color: red;">정기/비정기적인 DB 서버 점검</span>이 필요하거나,</strong>
					<br>
					<strong>Ontic HIS 프로그램 <span style="color: red;"> 속도 문제로 점검</span>이 필요한 경우</strong>
					</td>
				</tr>
				<tr>
					<td><strong>일반 문의 및 요청</strong></td>
					<td style="text-align: left;">
					<strong>Ontic HIS 프로그램의 <span style="color: red;">기능 외 모든 문의 및 요청</span></strong>
					<br>
					&nbsp;&nbsp;- 영업, 견적, 비용 문의
					<br>
					&nbsp;&nbsp;- Ontic HIS 프로그램 설치 및 부가솔루션 설치 요청
					<br>
					&nbsp;&nbsp;- 통계데이터 요청
					<br>
					&nbsp;&nbsp;- 데이터 추가/수정/삭제 요청
					<br>
					&nbsp;&nbsp;- 연동 관련 문의 등
					</td>
				</tr>
				<tr>
					<td><strong>재문의</strong></td>
					<td style="text-align: left;">
					<strong>기존에 등록했던 A/S와 관련하여 다시 문의하는 경우</strong>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<button type="button" class="btn_close"
		onclick="javascript:closeLayer(7);">창 닫기</button>
</div>
<div class="layer_dimmed" style="display: none;" id="div7_dim"></div>


<!-- AS 내역 팝업 -->
<div class="box_layer layer_rating" style="top:40%; left:45% !important; width:800px;height:500px;display:none;" id="linkLayer">
    <h1 class="tit_back">AS 내역</h1>
    <div class="layer_contents">
        <div class="floatWrap mgb10">
            <div class="mgl40" style="float:right">
                <input type="radio" id="val1" name="type1" value="1"
				       checked="checked"/>병원전체AS<span class="mgr5"></span>
				<input type="radio" id="val2" name="type1" value="2"
				       />나의AS<span class="mgr5"></span>
                 | AS신청일
                <input type="text" name="search_start3" id="search_start3"
                       class="w90 mgl5 mgr5" readonly="readonly">
                ~
                <input type="text" class="w90 mgl5 mgr5" name="search_end3"
                       id="search_end3" readonly="readonly">
                <span class="mgr5">|</span>
			    <input type="text" id="search_text" name="search_text"
			           class="w120 mgl5 mgr5" placeholder="문의내용">
			    <button type="button" class="btn_line_gray2" style="width:60px"
			            onclick="getUnprocessedAsList()">조회</button>
            </div>   
        </div>

        <!-- 리스트 영역: 높이 조금 줄이기 -->
        <div id="unprocessedas-box" style="padding:15px;height:300px;overflow:auto;">
		  <table class="hType mgb10 scroll-table">
		    <caption>A/S 접수 목록</caption>
		    <colgroup>
		      <col style="width:30px" />  <!-- 선택 -->
		      <col style="width:90px" />  <!-- 접수번호 -->
		      <col style="width:auto" />  <!-- 문의내용 -->
		    </colgroup>
		    <thead>
		      <tr>
		        <th scope="col">선택</th>
		        <th scope="col">접수번호</th>
		        <th scope="col">문의내용</th>
		      </tr>
		    </thead>
		    <tbody id="asList"></tbody>
		  </table>
		</div>

        <!-- 확인/초기화 버튼을 layer_contents 안으로 이동 -->
        <div style="text-align:right; padding:5px 15px 0 15px;">
            <button type="button" class="btn_line_gray2" style="width:70px"
                    onclick="confirmUnprocessedAs()">확인</button>
            <button type="button" class="btn_line_gray2" style="width:70px"
                    onclick="clearUnprocessedAs()">초기화</button>
        </div>
    </div>

    <button type="button" class="btn_close"
            onclick="$('#linkLayer').hide();$('#div_dim').hide();">창 닫기</button>
</div>
<div class="layer_dimmed"  id="div_dim" style="display:none;"></div>



</div>