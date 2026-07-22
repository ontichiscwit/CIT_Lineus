<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      		uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui"     		uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix = "fn"		uri = "http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" 	uri="http://www.springframework.org/tags"%>
<%@page import="egovframework.com.comm.util.StringUtil"%>
<%@page import="egovframework.com.comm.util.DateTimeUtil"%>
<%@ page import="egovframework.com.comm.model.UserVO"%>
<%@ page import="java.util.List"%>
<%@ page import="egovframework.com.comm.model.RoleVO"%>
<style>
	.custom-combobox {position: relative;display: inline-block;}
	.custom-combobox-toggle {position: absolute;top: 0;bottom: 0;margin-left: -1px;padding: 0;}
	.custom-combobox-input {margin: 0;padding: 5px 10px;width: 120px;}
	
		/* 전체 레이어 */
	#unprocessedas-layer {
	    position: fixed;
	    top: 0;
	    left: 0;
	    right: 0;
	    bottom: 0;
	    z-index: 9999;
	}
	
	/* 반투명 배경 */
	#unprocessedas-layer .un-as-dimmed {
	    position: absolute;
	    top: 0;
	    left: 0;
	    right: 0;
	    bottom: 0;
	    background: rgba(0,0,0,0.4);
	}
	
	/* 팝업 박스 */
	#unprocessedas-layer .un-as-box {
	    position: absolute;
	    top: 50%;
	    left: 50%;
	    transform: translate(-50%, -50%);
	    width: 700px;
	    max-height: 650px;
	    background: #fff;
	    border-radius: 4px;
	    box-shadow: 0 4px 12px rgba(0,0,0,0.25);
	    display: flex;
	    flex-direction: column;
	}
	
	/* 헤더 */
	#unprocessedas-layer .un-as-header {
	    display: flex;
	    align-items: center;
	    justify-content: space-between;
	    padding: 12px 16px;
	    border-bottom: 1px solid #e0e0e0;
	}
	#unprocessedas-layer .un-as-header h2 {
	    margin: 0;
	    font-size: 16px;
	}
	
	/* 닫기 버튼 */
	#unprocessedas-layer .un-as-header .btn_close {
	    border: 0;
	    background: transparent;
	    font-size: 18px;
	    cursor: pointer;
	}
	
	/* 본문 */
	#unprocessedas-layer .un-as-body {
	    padding: 12px 16px;
	    overflow-y: auto;
	    flex: 1;
	}
	
	/* 푸터 */
	#unprocessedas-layer .un-as-footer {
	    border-top: 1px solid #e0e0e0;
	    padding: 10px 16px;
	    text-align: right;
	}
	
	/* 카드 스타일 */
	#unprocessedas-box .as-card {
	    border: 1px solid #e0e0e0;
	    border-radius: 4px;
	    padding: 8px 10px;
	    margin-bottom: 8px;
	    background: #fafafa;
	    font-size: 12px;
	    line-height: 1.4;
	}
	
	#unprocessedas-box .as-card-header {
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    margin-bottom: 4px;
	    font-weight: 600;
	}
	
	#unprocessedas-box .as-card-meta {
	    margin-bottom: 4px;
	    font-size: 11px;
	    color: #666;
	}
	
	#unprocessedas-box .as-card-body {
	    font-size: 12px;
        color: #555;
        line-height: 1.5;
        white-space: pre-line; /* 줄바꿈 유지 */
        border-top: 1px solid #dedede;
        padding-top: 5px;
	}
	
	#unprocessedas-box .as-card-body-label {
	    font-weight: 600;
	    margin-right: 4px;
	}
	
	#unprocessedas-box .as-card-requester {
	    margin-top: 4px;
	    text-align: right;
	    color: #555;
	}
	
		/* 미처리 AS 팝업 전용 스타일 */
	.unprocessed-as-popup .layer_contents {
	    height: 480px;
	    overflow: hidden;
	    padding: 15px 20px 20px !important;
	}
	
	/* 리스트 영역 스크롤 */
	.unprocessed-as-popup .unprocess-list-wrap {
	    padding: 15px;
	    height: 420px;
	    overflow-y: auto;
	}
	
	/* 하단 버튼 영역 */
	.unprocessed-as-popup .unprocess-btn-wrap {
	    text-align: right;
	    padding: 14px 22px 24px 22px;
	    border-top: 1px solid #e3e3e3;
	}
	
	/* 버튼 모양 조금 강조 */
	.unprocessed-as-popup .unprocess-btn-wrap button {
	    min-width: 80px;
	    height: 30px;
	    font-weight: 600;
	}
	
	
	/*------------------------------------*/
		/* 전체 레이어 */
	#processedas-layer {
	    position: fixed;
	    top: 0;
	    left: 0;
	    right: 0;
	    bottom: 0;
	    z-index: 9999;
	}
	
	/* 반투명 배경 */
	#processedas-layer .un-as-dimmed {
	    position: absolute;
	    top: 0;
	    left: 0;
	    right: 0;
	    bottom: 0;
	    background: rgba(0,0,0,0.4);
	}
	
	/* 팝업 박스 */
	#processedas-layer .un-as-box {
	    position: absolute;
	    top: 50%;
	    left: 50%;
	    transform: translate(-50%, -50%);
	    width: 700px;
	    max-height: 650px;
	    background: #fff;
	    border-radius: 4px;
	    box-shadow: 0 4px 12px rgba(0,0,0,0.25);
	    display: flex;
	    flex-direction: column;
	}
	
	/* 헤더 */
	#processedas-layer .un-as-header {
	    display: flex;
	    align-items: center;
	    justify-content: space-between;
	    padding: 12px 16px;
	    border-bottom: 1px solid #e0e0e0;
	}
	#processedas-layer .un-as-header h2 {
	    margin: 0;
	    font-size: 16px;
	}
	
	/* 닫기 버튼 */
	#processedas-layer .un-as-header .btn_close {
	    border: 0;
	    background: transparent;
	    font-size: 18px;
	    cursor: pointer;
	}
	
	/* 본문 */
	#processedas-layer .un-as-body {
	    padding: 12px 16px;
	    overflow-y: auto;
	    flex: 1;
	}
	
	/* 푸터 */
	#processedas-layer .un-as-footer {
	    border-top: 1px solid #e0e0e0;
	    padding: 10px 16px;
	    text-align: right;
	}
	
	/* 카드 스타일 */
	#processedas-box .as-card {
	    border: 1px solid #e0e0e0;
	    border-radius: 4px;
	    padding: 8px 10px;
	    margin-bottom: 8px;
	    background: #fafafa;
	    font-size: 12px;
	    line-height: 1.4;
	}
	
	#processedas-box .as-card-header {
	    display: flex;
	    justify-content: space-between;
	    align-items: center;
	    margin-bottom: 4px;
	    font-weight: 600;
	}
	
	#processedas-box .as-card-meta {
	    margin-bottom: 4px;
	    font-size: 11px;
	    color: #666;
	}
	
	#processedas-box .as-card-body {
	    font-size: 12px;
        color: #555;
        line-height: 1.5;
        white-space: pre-line; /* 줄바꿈 유지 */
        border-top: 1px solid #dedede;
        padding-top: 5px;
	}
	
	#processedas-box .as-card-body-label {
	    font-weight: 600;
	    margin-right: 4px;
	}
	
	#processedas-box .as-card-requester {
	    margin-top: 4px;
	    text-align: right;
	    color: #555;
	}
	
		/* 미처리 AS 팝업 전용 스타일 */
	.processed-as-popup .layer_contents {
	    height: 480px;
	    overflow: hidden;
	    padding: 15px 20px 20px !important;
	}
	
	/* 리스트 영역 스크롤 */
	.processed-as-popup .process-list-wrap {
	    padding: 15px;
	    height: 420px;
	    overflow-y: auto;
	}
	
	/* 하단 버튼 영역 */
	.processed-as-popup .process-btn-wrap {
	    text-align: right;
	    padding: 14px 22px 24px 22px;
	    border-top: 1px solid #e3e3e3;
	}
	
	/* 버튼 모양 조금 강조 */
	.processed-as-popup .process-btn-wrap button {
	    min-width: 80px;
	    height: 30px;
	    font-weight: 600;
	}
	
	/*-------------------------------------------------*/
	
	.tit_relative {
		position: relative;
		width: 100%;          /* 이게 핵심 */
	}
	
	#btnSameProcess {
		position: absolute;
		right: 0;             /* 화면 우측 끝 */
		top: 50%;
		transform: translateY(-50%);
	}
	
	.tit_relative h4 {
		margin: 0;
	}
	
	.as-card-meta {
	    color: #555;
	    font-size: 13px;
	    margin-top: 2px;
	}
	
	.as-card-meta strong {
	    color: #333;
	}
</style>

<script type="text/javascript">

	var file_cnt = 1;
	var mfile_cnt = 1;
	var aswfile_cnt = 1;
	
	var delAttach1 = '' ; 
	var delAttach2 = '' ;
	var delAttach3 = '' ;
	
	var v_seq = "";
	var cnAsNoCnt  = 0;
	
	var a = '' ; 
	var b = '' ; 
	var c = '' ; 
	var d = '' ; 
	var tel_type ='';
	
	var flag = '';
	var GUBUN = '';
	var proc_status_current = '';
	
	var selectedAsNos = [];
	
	$(document).ready(function(){
		
		/**	공통 코드 처리		*/
		commonCode.getCodeList('AS' , 'CD02' , 'accept_route') ; 		/**	접수 경로		*/
		$('#accept_route').val('C002');
		commonCode.getCodeList('AS' , 'CD07' , 'request_type') ; 		/**	문의유형		*/
		commonCode.getCodeList('AS' , 'CD03' , 'service_cate') ; 		/**	시스템(대)		*/
		commonCode.getCodeList('AS' , 'CD01' , 'proc_status') ; 		/**	처리상태		*/
		$('#proc_status').val('C001');
		//$("select[name='proc_status'] option[value='C001']").remove();    //2024.08.14.김규민 수정 (C001:접수 표시되도록 설정)
		//$("select[name='proc_status'] option[value='C006']").remove();	//2022.06.20.이설아 수정 (C006:철회)
		
		commonCode.getCodeList('AS' , 'CD04' , 'inportance') ; 			/**	중요도		*/
		$('#inportance').val('C002');
		commonCode.getCodeList('AS' , 'CD05' , 'cause_type') ; 			/**	원인유형		*/
		commonCode.getCodeList('AS' , 'CD06' , 'action_type') ; 		/**	조치유형		*/
		commonCode.getCodeList('AS' , 'CD09' , 'proc_gubun');				/**	처리구분		*/
		
		
		$("#search_start3" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$("#search_end3" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		$("#search_start4" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$("#search_end4" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		getUnprocessedAsListAdmin();
		getprocessedAsListAdmin();
		
		$("#inquiry_type").append(commonCode.defaultViewOption);
		$("#proc_dt" ).datepicker(datepicker);
		$("#complete_dt").datepicker(datepicker);
		$("#proc_dt").val();
		var str = '' ; 
		
		for(var i = 0 ; i < 24 ; i++ ){
			if (i < 10) str += '<option value="0'+i+'">0'+i+'</option>' ;
			else str += '<option value="'+i+'">'+i+'</option>' ;
		}
		
		$('#proc_time1').append(str) ; 
		
		for(var i = 0 ; i < 60 ; i++ ){
			if (i < 10) str += '<option value="0'+i+'">0'+i+'</option>' ;
			else str += '<option value="'+i+'">'+i+'</option>' ;
		}
		
		$('#proc_time2').append(str) ; 
				
		$('[id^=btnTab]').bind("click",function(){
			$('[id^=subTab]').hide();
			$('.tab_line li').removeClass("active");
			
			var dataid = $(this).data("id");
			$("#"+dataid).show();
			$(this).parent('li').addClass("active");
			
			if('${ vo.pageType}'.indexOf('pdate') != -1){
				if (dataid=='subTab2') awsList(1); //답변내역 리스트 호출
			}
		});
		
		$('#call_content').keyup(function (e){
	          var content = $(this).val();
	          if(content.length >= 1000){
	        	  content = content.substring(0 , 1000) ;
	        	  $(this).val(content)
	          }
	          
	          $('#call_content_text').html(content.length + '/ 1000 자');
	          
	      });
		
		$('#action_content').keyup(function (e){
	          var content = $(this).val();
	          if(content.length >= 1300){
	        	  content = content.substring(0 , 1300) ;
	        	  $(this).val(content)
	          }
	          
	          $('#action_content_text').html(content.length + '/ 1300 자');
	          
	      });
		
		$('#tel_absence').on('change', function(){
		    if (this.checked) {
		        $('#tel_absence_cnt').prop('readonly', false).removeClass('write_gray');
		    } else {
		        $('#tel_absence_cnt').prop('readonly', true).addClass('write_gray').val('');
		    }
		});
		//getEmpList() ; 
		
		var pageType = '${ vo.pageType}' ;
		
		
		if(pageType.indexOf('sub') != -1){ //subinsert,subupdate
			initView();
			$('#CnAS').hide() ; 
			
		}else{
			if(pageType == "update"){
				initView();
				$('#CnAS').show() ;
				if (cnAsNoCnt > 0) $('#proc_status').prop('disabled',true);
			}else{		
				addMultiFile() ; 
				addFile() ;				
				$('#CnAS').hide() ;
				$('#request_type').find('option[value="C999"]').remove();
				chgProcStatus($("#proc_status").val());
				
				if(pageType == "insertcopy"){
					initViewInsertCopy();
				}
				
			}
		}
		//처리상태 변경-처리완료
		$('#proc_status').on('change',function(){
			var this_val = $(this).val();
			
			// 필수키 초기화
			$("#cause_type_th,#action_type_th,#work_time_th,#complete_dt_th,#proc_dt_th,#action_content_th").children("span").remove();
			$('#savetoanswer').show();
			
			if (this_val == "C005") { // 처리완료
				$("#cause_type_th,#action_type_th,#work_time_th,#complete_dt_th,#proc_dt_th,#action_content_th").append('<span class="request mgl5">필수 입력</span>');
			/* 	$("#cause_type_th").append('<span class="request mgl5">필수 입력</span>');
				$("#action_type_th").append('<span class="request mgl5">필수 입력</span>');
				$("#work_time_th").append('<span class="request mgl5">필수 입력</span>');
				$("#complete_dt_th").append('<span class="request mgl5">필수 입력</span>'); */
				$('#savetoanswer').hide();
			} else if (this_val == "C004") { // 처리중
				$("#proc_dt_th").append('<span class="request mgl5">필수 입력</span>');
			} else if (this_val == "C006") { // 철회
				$("#action_content_th").append('<span class="request mgl5">필수 입력</span>');
			}
		/* 	else{
				$("#cause_type_th").children().remove();
				$("#action_type_th").children().remove();
				$("#work_time_th").children().remove();
				$("#complete_dt_th").children().remove();
			}
		 	
			if(this_val == "C004" || this_val == "C005"){
				$("#proc_dt_th").append('<span class="request mgl5">필수 입력</span>');
			}
		/* 	else {
				$("#proc_dt_th").children().remove();
			}
		 	
			if(this_val == "C005" || this_val == "C006"){
			//	if ($("#action_content_th").find(".request").length === 0) {
			        $("#action_content_th").append('<span class="request mgl5">필수 입력</span>');
			  //  }
			} 
		 	else{
				if ($("#action_content_th").find(".request").length !== 0) {
					$("#action_content_th").children("span").remove();
				}
				
			}
		 */	
		 	setProcGrade($("#action_type").val());
			setProcGubun($("#proc_gubun").val());
		});
		
		//팝업창 Enter 검색 기능.
		$("#searchEmpName").keyup(function(e){if(e.keyCode == 13)  empList(1); });
		$("#searchKorName").keyup(function(e){if(e.keyCode == 13)  custList(1); });
		
		//AS신청자 연락처
		$("#apply_tel1").keyup(function(e){if(e.keyCode == 13) $("#apply_tel2").focus();  });
		$("#apply_tel2").keyup(function(e){if(e.keyCode == 13) $("#apply_tel3").focus();  });
		$("#apply_tel2").keyup(function(e){ 
			if( $(this).val().length == 4){$("#apply_tel3").focus();} 
		});
		
		//신청자아이디 조회팝업 - 유형체인지함수 
		chageApplytypeEvent();
		
		$(document)
		  .off('click', '#processedas-box .as-card.as-selectable')
		  .on('click', '#processedas-box .as-card.as-selectable', function () {

		    $('#completeLinkLayer').hide();
		    $('#div_dim5').hide();

		    var causeType = $(this).data('cause'); // 코드값
		    var actionType = $(this).data('action'); // 코드값
		    var actionContent = $(this).data('actionContent') || ''; // data-action-content
		    
			// 오늘 날짜 yyyy/MM/dd
		    var d = new Date();
		    var yyyy = d.getFullYear();
		    var mm = ('0' + (d.getMonth() + 1)).slice(-2);
		    var dd = ('0' + d.getDate()).slice(-2);
		    var todayStr = yyyy + '/' + mm + '/' + dd;

		    // 공백일 때만 채우기 (proc_dt, complete_dt)
		    var $proc = $('#proc_dt');
		    var $complete = $('#complete_dt');

		    if ($proc.length && $.trim($proc.val()) === '') {
		      $proc.val(todayStr).trigger('change');
		    }
		    if ($complete.length && $.trim($complete.val()) === '') {
		      $complete.val(todayStr).trigger('change');
		    }
		    
		 // 둘 다 00이면 현재 시각으로 세팅
		    var $h = $('#proc_time1'); // 시
		    var $m = $('#proc_time2'); // 분

		    if ($h.length && $m.length && $.trim($h.val()) === '00' && $.trim($m.val()) === '00') {
		      var now = new Date();
		      var hh = ('0' + now.getHours()).slice(-2);
		      var mi = ('0' + now.getMinutes()).slice(-2);

		      // 옵션 존재할 때만 세팅(옵션 없으면 val이 적용 안 됨)
		      if ($h.find('option[value="' + hh + '"]').length) {
		        $h.val(hh).trigger('change');
		      }
		      if ($m.find('option[value="' + mi + '"]').length) {
		        $m.val(mi).trigger('change');
		      } else {
		        // 분 옵션이 00~59가 아니라면(현재 스샷처럼 00~23이면) 적용이 안 될 수 있어요.
		        // 그 경우는 그대로 두거나, 가장 가까운 값으로 맞추는 로직이 필요합니다.
		      }
		    }

		    // 아래 3개는 실제 입력 필드 id/name에 맞춰 조정
		    $('#cause_type').val(causeType).trigger('change');
		    $('#action_type').val(actionType).trigger('change');
		    $('#action_content').val(actionContent);
		  });
		
		$('#completeLinkLayer').on('keydown', '#search_text', function(e){
		    if (e.keyCode === 13) {
		      e.preventDefault();
		      getprocessedAsListAdmin();
		    }
		  });
		
	}) ;
	
	

	
	function getCustMaster() {
		if(common.isEmpty($('#cust_kor_name').val())) {
			alert('고객사명을 입력 하세요.');
			$('#cust_kor_name').focus();
			return ;
		} 
		var datas = {'cust_kor_name' : $('#cust_kor_name').val()} ; 
		
		common.ajaxCall(datas , '/ad/as/getAsCust.do' , 'setMasterInfo') ; 
	}
	
	function setMasterInfo(data){
		
		var resultList = typeof data.resultList !='undefined' ? data.resultList : null ; 
		if(resultList != null && resultList.length > 0){
			var datas = resultList[0] ; 
			
			$('#ceo').val(common.nvl(datas.represent , '')) ; 
			// 해당 정보 없음 $('#treat_no').val(common.nvl(datas.represent , '')) ; 
			$('#cust_nm').val(common.nvl(datas.cust_nm , '')) ; 
			$('#cust_no').val(common.nvl(datas.biz_reg_no , '')) ; 
			$('#law_no').val(common.nvl(datas.corp_reg_no , '')) ; 
			$('#buss_condition').val(common.nvl(datas.biz_condition , '')) ; 
			$('#buss_item').val(common.nvl(datas.biz_type , '')) ; 
			$('#cust_address').val(common.nvl(datas.zip_nm , '') + ' ' + common.nvl(datas.addr_detail, '')) ; 
			
		}else{
			alert("ERP 코드로 조회된 정보가 없습니다.") ; 
			return;
		}
	}
	
	function getInquiryType(thisObj){
		
		$('#inquiry_type').empty() ;
		if(thisObj != '') commonCode.getCodeList('AS' ,thisObj , 'inquiry_type') ; 		/**	유형카테고리**/
		else $('#inquiry_type').append(commonCode.defaultViewOption) ; 
	}

	function goList(){
		location.href = '/ad/as/list.do${ QUERYSTRING }' ; 
	}
	
	function addFile() {
		
		
		var str = '';
		str += '';
		
		str += '<tr id="file'+file_cnt+'">';
		str += '<th scope="row">첨부파일</th>';
		str += '<td>';
		str += '		<input type="file" id="upFile_'+file_cnt+'" name="upFile_'+file_cnt+'" class="w225">';
		if(file_cnt > 1) str += '		<button class="btn_minus mgr5" onclick="delFile('+file_cnt+');"></button>';
		else str += '		<span class="btn_plus mgr5" onclick="addFile();"></span> ';
		str += '		<!-- <button type="button" class="btn_ico_down mgr5"><span>다운로드</span></button> -->';					
		str += '		</td>';
		str += '</tr>';		
		$('#wrapFile').append(str);
		$('#file_cnt').val(file_cnt);
		
		file_cnt++;
	}
	
	function delFile(cnt) {
		$('#file'+cnt).remove();
		
		if(delAttach2 == "") delAttach2 = cnt ; 
		else delAttach2 = delAttach2 + "@" + cnt ; 
	}
	
	function addMultiFile() {
		var str = '';
		str += '';
		str += '<tr id="mfile'+mfile_cnt+'">';
		str += '<th>파일첨부</th>';
		str += '<td colspan="3">';
		str += '		<input type="file" id="uploadFile_'+mfile_cnt+'" name="uploadFile_'+mfile_cnt+'" class="w225 mgr5">';
		if(mfile_cnt > 1) str += '		<button type="button" class="btn_minus mgr5" onclick="delMfile('+mfile_cnt+');">추가</button>';
		else str += '		<button type="button" class="btn_plus" onclick="addMultiFile();">추가</button>';
		str += '		</td>';
		str += '</tr>';		
		$('#wrapMfile').append(str);
		$('#mfile_cnt').val(mfile_cnt);
		mfile_cnt++;
	}
	
	function delMfile(cnt) {
		$('#mfile'+cnt).remove();
		
		if(delAttach1 == "") delAttach1 = cnt ; 
		else delAttach1 = delAttach1 + "@" + cnt ; 
	}
	
	function clearFile(){
		
		var f = document.procFrm;
	
		f.attach_seq2.value ='';
		f.delAttach1.value ='';
		f.delAttach2.value ='';
		f.file_seq.value ='';
		
		$('#wrapMfile').empty();
		$('#wrapFile').empty();
	}
	
	/**	거래처 조회	*/
	function showCustLayer(){
		
		/**	문의유형, 시스템(대), 시스템(소) 초기화.	*/
		$('#request_type').val('') ;
		$('#service_cate').val('') ; 
		$('#version_info_str').val('') ; 
		$('#version_info').val('') ; 
		$('#inquiry_type').val('') ; 
		
		$('#div1').show() ; 
		$('#div1').css('height' , '710') ;
		$('#div1_dim').show() ; 
		custList(1) ;
		$("#searchKorName").attr( "autofocus","autofocus");
		
		$('[autofocus]:not(:focus)').eq(0).focus();
		
	}
	
	function getAsHistList(){
		var datas = {'as_no' : '${ vo.as_no }'} ; 
		common.ajaxCall(datas , '/ad/as/getAsHistList.do' , 'makeAsHistList') ; 
	}
	
	function makeAsHistList(data) {
		var asHistList = typeof data.asHistList != "undefined" ? data.asHistList : null ; 
		$('#asHistTbody').empty() ; 
		$('#wrap_contents > input').remove();	
		if(asHistList != null && asHistList.length > 0) {
			
			var str = '' ; 
			for(var i = 0 ; i < asHistList.length ; i++) {
				var datas = asHistList[i] ; 
				
				var cLen = datas.action_content.length;
				var contents = '';
				// CMC 모든 내용 보이게 처리
				if (parseInt(cLen) > 0){
					contents = common.nvl(datas.action_content , '') 
					
					//contents = contents + '<br/><button type="button" class="btn_list_blue" onclick="showHistContent('+(i+1)+');">수정</button> ';
					$('#wrap_contents').append('<input type="hidden" id="layer_cont'+(i+1)+'" value="'+common.nvl(datas.action_content , '')+'" />');
					
				} else {
					contents = common.nvl(datas.action_content , '');
				}
				$('#wrap_contents').append('<input type="hidden" id="hist_seq'+(i+1)+'" value="'+common.nvl(datas.seq , '')+'" />');
				$('#wrap_contents').append('<input type="hidden" id="hist_reg_nm'+(i+1)+'" value="'+common.nvl(datas.reg_nm , '')+'" />');
				str += '<tr> ' ;
				str += '	<td>'+common.nvl(datas.reg_date , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.reg_nm , '')+'</td> ' ;//처리자
				str += '	<td>'+common.nvl(datas.emp_nm , '')+'</td> ' ;//인수자
				str += '	<td>'+common.nvl(datas.proc_status_nm , '')+'</td> ' ;//처리상태
				str += '	<td>'+common.nvl(datas.inportance , '')+'</td> ' ;//중요도 /*2024.04.23.김규민 추가*/
				
				if (contents != '') {
				 	str += '	<td title="' + datas.action_content + '" style="text-align: left;">' + contents + '</td> '; // CMC 모든 내용 보이게 처리
				} else {
					str += '	<td>'+contents+'</td> ' ;
				}
				
				str += '<td>' +'<button type="button" class="btn_list_blue" onclick="showHistContent('+(i+1)+');">수정</button>'+ '</td>';
				str += '	<td>';
				if (common.nvl(datas.file_seq , '0') != '0') { 
					str += '		<button type="button" class="btn_file_blue" onclick="javascript:showFileLayer('+common.nvl(datas.file_seq , '0')+');"><span>첨부파일</span></button>' ;
					if (common.nvl(datas.reg_nm, '') == '${ adUserInfo.emp_nm }') {
						//str += '		<button type="button" class="btn_delete_blue" title="첨부파일 삭제" onclick="javascript:deleteFileSeqHist(' + (i + 1) + ');"><span>삭제</span></button>';
					}
					$('#wrap_contents').append('<input type="hidden" id="hist_file_seq' + (i + 1)+ '" value="' + common.nvl(datas.file_seq, '') + '" />');
				}
				str += '</td>';
				str += '</tr> ' ;
				
			}
			
			$('#asHistTbody').append(str) ; 
			
		}else{
			commonTable.notData(7 , '조회된 데이터가 없습니다.' , 'asHistTbody') ; 
		}
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
				str += '	<td>'+common.nvl(datas.cust_kor_name , '')+'['+common.nvl(datas.crm_code , '')+']</td> ' ;
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
		closeLayer(1) ; 
		
		//$('#apply_nm').val('') ; 
		$('#apply_id').val('') ; 
		$('#apply_tel1').val('') ; 
		$('#apply_tel2').val('') ; 
		$('#apply_tel3').val('') ;
		$('#service_cate').prop('disabled', false).removeClass('write_gray');
		$('#inquiry_type').prop('disabled', false).removeClass('write_gray');
		
		
	}
	
	function makeCustInfo(data){
		
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null ; 
		
		$('#cust_kor_name').val(common.nvl(resultVO.cust_kor_name, '')) ; 
		$('#cust_code').val(common.nvl(resultVO.erp_code, '')) ; 
		$('#apply_nm').val(common.nvl(resultVO.erp_code, '')) ;
		$('#cust_addr').val(common.nvl(resultVO.cust_address, '')) ; 
		$('#cust_post').val(common.nvl(resultVO.zip_code, '')) ; 
		$('#cust_tel').val(common.nvl(resultVO.tel_no, '')) ;
		$('#cust_seq').val(common.nvl(resultVO.seq, '')) ;
		$('#cust_his_treat_name').val(common.nvl(resultVO.his_treat_name, '')) ; // CMC 수정 - HIS 진료버전 필드 추가
		
		a = common.nvl(resultVO.his_basic_code, '') ;		/**	기초	*/  
		b = common.nvl(resultVO.his_treat_code, '') ;		/**	진료	*/ 
		c = common.nvl(resultVO.his_work_code, '') ;		/**	업무	*/ 
		d = common.nvl(resultVO.his_claim_code, '') ;	/**	청구	*/ 
	}
	
	/**	A/S신청자 이름/아이디 조회	*/
	function showEmpLayer(){
		if (common.isEmpty($('#cust_code').val())) {
			alert('고객사 정보를 조회해 주세요.');
			return;
		}
		
		$('#apply_nm').val('').attr('readonly','readonly').removeAttr('placeholder');
		$('#apply_id').val('');
		
		$('#div2').show() ; 
		$('#div2_dim').show() ; 
		
		empList(1) ; 
		
		$("#searchEmpName").attr( "autofocus","autofocus" );
		$('[autofocus]:not(:focus)').eq(0).focus();	
	}
	
	function chageApplytypeEvent(){
		
		$(".cust_emp_type").change(function(){
			var empType = $('#div2 .cust_emp_type option:selected').val();
			if(empType == 'cust_emp'){
				empList(1);
			}else{
				chargeEmpList(1);
			}
		});
	}
	
	function furcateType(datas){
		var empType = $('#div2 .cust_emp_type option:selected').val();
		
		if(empType == 'cust_emp'){
			common.ajaxCall(datas , '/ad/member/getCustEmpList.do', 'makeEmpList') ;
		}else{
			common.ajaxCall(datas , '/ad/cust/getOperateChargeInfo.do', 'makeChargeEmpList') ;
		}
	} 
	
	function empList(custPage){
		var datas = {
				'page' : custPage ,
				'cust_code' : $('#cust_code').val(),
				'search_text' : $('#searchEmpName').val() 
		};
		
		furcateType(datas);
	}
	
	function chargeEmpList(custPage){
		var datas = {
				'page' : custPage ,
				'cust_code' : $('#cust_code').val(),
				'search_text' : $('#searchEmpName').val() 
		};
		
		furcateType(datas);
	}
	
	
	function makeEmpList(data){
		
		$('#empInfoList').empty() ; 
		$('#layer_pagination').empty() ; 
		$('#chargeEmpInfoList').empty() ;
		$('#cust_emp_tb').css('display','');
		$('#charge_emp_tb').css('display','none');
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var vo = typeof data.vo != "undefined" ? data.vo : null ; 
		
		if(resultList != null && resultList.length > 0){
			var str = '' ; 
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ;
				str += '<tr onclick="javascript:setValueEmp(\''+common.nvl(datas.emp_id, '')+'\');" style="cursor:pointer;"> ' ;
				str += '	<td>'+common.nvl(datas.rnum , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.emp_id , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.emp_name , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.tel_no , '')+'</td> ' ;
				str += '</tr> ' ;
			}
			$('#empInfoList').append(str) ; 
			$('#layer_pagination').html(vo.json_paging) ; 
		}else{
			commonTable.notData(4 , '조회된 정보가 없습니다.' , 'empInfoList') ;
			$('#layer_pagination').html('') ; 
		}
	}
	
	function makeChargeEmpList(data){
		
		$('#empInfoList').empty() ; 
		$('#layer_pagination').empty() ;
		$('#cust_emp_tb').css('display','none');
		$('#charge_emp_tb').css('display','');
		$('#chargeEmpInfoList').empty() ;
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var vo = typeof data.vo != "undefined" ? data.vo : null ; 
		
		if(resultList != null && resultList.length > 0){
			var str = '' ; 
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ;
				str += '<tr>' ;
				str += '	<td style="text-align:center">'+common.nvl(datas.charge_code, '')+'</td> ' ;
				str += '	<td style="text-align:center">'+common.nvl(datas.charge_nm , '')+'</td> ' ;
				str += '	<td  onclick="javascript:setValueChargeEmp(\''+datas.seq+ '/' +datas.dtl_seq+ '/' + 'COMPANY_TEL_NO\');" id="company_tel_no_tr"  style="cursor:pointer; background:#696d6d1a;border-right:1px solid #ffff;text-align:center;">'+common.nvl(datas.company_tel_no , '')+'</td> ' ;
				str += '	<td  onclick="javascript:setValueChargeEmp(\''+datas.seq+ '/' +datas.dtl_seq+ '/' + 'HP_NO\');" id="hp_no_tr" style="cursor:pointer; background:#696d6d1a;text-align:center;">'+common.nvl(datas.hp_no , '')+'</td> ' ;
				str += '	<td >'+common.nvl(datas.etc , '')+'</td> ' ;
				str += '</tr> ' ;
			}
			$('#chargeEmpInfoList').append(str) ; 
			$('#layer_pagination').html(vo.json_paging) ; 
		}else{
			commonTable.notData(4 , '조회된 정보가 없습니다.' , 'chargeEmpInfoList') ;
			$('#layer_pagination').html('') ; 
		}
		
	}

	function setValueEmp(emp_id){
		var datas = {'emp_id' 				: emp_id }
		common.ajaxCall(datas , '/ad/member/getEmpInfo.do', 'makeEmpInfo') ;
		closeLayer(2) ; 
	}
	
	function setValueChargeEmp(data){
		
		var param =  data.split('/');
		var datas = {'cust_seq': param[0],
				     'dtl_seq': param[1],
				     'tel_type' : param[2]
					}
		tel_type = datas.tel_type;
		
		common.ajaxCall(datas , '/ad/cust/getSelectOneChargeEmpInfo.do', 'makeChargeEmpInfo') ;
		closeLayer(2) ; 
	}
	 
	
	function makeEmpInfo(data){
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null ;
		$('#apply_nm').val(common.nvl(resultVO.emp_name, '')) ; 
		$('#apply_id').val(common.nvl(resultVO.emp_id, '')) ; 
		$('#apply_tel1').val(common.spritStr(resultVO.tel_no , 1, '-')) ; 
		$('#apply_tel2').val(common.spritStr(resultVO.tel_no , 2, '-')) ; 
		$('#apply_tel3').val(common.spritStr(resultVO.tel_no , 3, '-')) ;
	}
	
	function makeChargeEmpInfo(data){
		
		var tel_no ='';
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null ;
		
		if(tel_type =='COMPANY_TEL_NO'){
			tel_no =  resultVO.company_tel_no;
		}else if(tel_type =='HP_NO'){
			tel_no =  resultVO.hp_no;
		} 
		$('#apply_nm').val(common.nvl(resultVO.charge_nm, '')) ; 
		$('#apply_tel1').val(common.spritStr(tel_no , 1, '-')) ; 
		$('#apply_tel2').val(common.spritStr(tel_no , 2, '-')) ; 
		$('#apply_tel3').val(common.spritStr(tel_no , 3, '-')) ; 
	}
	
	
	function closeLayer(num) {
		$('#div'+num).hide() ; 
		$('#div'+num+'_dim').hide() ; 
		$('#searchKorName').val('') ; 
		$('#searchEmpName').val('') ; 
		$("#searchKorName").removeAttr( "autofocus" );
		$("#searchEmpName").removeAttr( "autofocus" );
	}
	
	/* 답변내역 script */
	function awsList(awsPage){
		var datas = {
				'page' : awsPage ,
				'as_no' : '${ vo.as_no }'
		}
		common.ajaxCall(datas , '/ad/as/getAwsList.do', 'makeAwsList') ;
	}
	
	function makeAwsList(data){
		
		$('#awsInfoList').empty() ; 
		$('#aswWrapFile').children( 'tr:not(:first)' ).remove();
		
		aswfile_cnt = 1;
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var awsA_cnt = 0;
		if(resultList != null && resultList.length > 0){
			var str = '' ; 
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ;
				var u_class = '';
				var new_icon = '';
				var attachData = datas.amap;
				var attachOb = [];
				if (common.nvl(datas.w_gubun, '') == 'U') {
					u_class = "gray";
				}
				
				if (common.nvl(datas.w_gubun, '') == 'A') {
					awsA_cnt = awsA_cnt + 1;
				}
				
				if (common.nvl(datas.w_gubun, '') == 'U' && (i+1) == resultList.length) {
					new_icon = '<span class="new"></span>';	
				}
				
				str += '<tr id="awsTr'+(i+1)+'" class="'+u_class+'">';
				str += '		<td>'+common.nvl(datas.emp_nm)+'</td>';
				str += '		<td>'+new_icon+' '+common.nvl(datas.w_date)+'</td>';
				
				str += '		<td class="textL">'+common.nvl(datas.w_content) + '<br>';
				
				
				
				if( JSON.stringify(attachData) != '{}'){
					if(attachData.attachList.length > 0 ){
						for(var j = 0; j < attachData.attachList.length; j++ ){
							
							var arr={
									"attach_seq": attachData.attachList[j].attach_seq,
									"attach_ord":attachData.attachList[j].attach_ord,
									"attach_ori_nm" : attachData.attachList[j].attach_ori_nm
							};
							
							attachOb.push(arr);
							
							str += '<button type="button" class="btn_file_blue mgr5 mgt5" onclick="javascript:fileDown(\''+common.nvl(attachData.attachList[j].attach_seq, '')+'\' , \''+common.nvl(attachData.attachList[j].attach_ord, '')+'\');"><span>다운로드</span></button>';	
							str += '<span>' + common.nvl(attachData.attachList[j].attach_ori_nm, '') + '</span>'; 
							str += '<br>'
						}
					}
				}
				str += '		</td>';
				if (common.nvl(datas.emp_nm) == '${ adUserInfo.emp_nm }' || '${ adUserInfo.emp_grade }' == 'C001'  ) {
				str += '		<td></button><button type="button" class="btn_delete_blue" onclick="aswDelete(\''+common.nvl(datas.seq,'')+'\');"><span>삭제</span></button></td>';
				} else{
					str += '		<td></td>';
				}
				str += '</tr>';
			}
			$('#awsa_cnt').val(awsA_cnt);
			$('#awsInfoList').append(str) ; 
			
		     var offset = $("#awsTr" + resultList.length).offset();
		     $('#awsWrap').animate({scrollTop : offset.top}, 1000);

		} else {
			$('#awsa_cnt').val(0);
			commonTable.notData(4,'등록된 답변이 없습니다.','awsInfoList');
		}
		
		//답변내역 - 첨부파일open 
		addAswFile();
	}
	
	function aswShowLayer(type, seq) {
		v_seq = seq;
		$('#w_content').val('');
		
		if (type=='list') {
			$('#div3PopTitle').html('답변 수정');
			$('#div3').show() ; 		
			$('#p_w_content').val($('#temp_content_'+v_seq).val());
			
			
			/* for(var i=0;i < obj.length ; i++){
				console.log(obj[i]);
				 var cnt = i+1;
				 var str='';
				str += '<tr id="aswfile">';
				str += '<th>파일첨부</th>';
				str += '<td>';
				str += '<input type="file" id="uploadFile_" name="uploadFile_" class="w225 mgr5">';
				str += '<button type="button" class="btn_minus mgr5" onclick="delMfile();"></button>';
				str += '<button type="button" class="btn_ico_down mgr5" onclick="javascript:fileDown(\''+obj[i].attach_seq+'\' , \''+obj[i].attach_ord+'\');"><span>다운로드</span></button>';	
				str += obj[i].attach_ori_nm;
				str += '</td></tr>'; 
			}
			
			$('#aswAttach_modify_tb').append(str); */
			
		} else {
			$('#div3PopTitle').html('답변 등록');
			$('#div3').show() ; 
		}
		$('#div3_dim').show() ;
	}
	
	function btnAswProc(type, callback) {
		var wEmpty = (String($('#w_content').val() || '').replace(/\s/g,'') === '');
		
		if(type == 'insert'){
			if(wEmpty){
				alert('답변 내용을 입력해 주세요.') ; return ; 
			}
		}
		var pageType = '';
		if (v_seq != '' && typeof v_seq != 'undefined') pageType = 'update';
		else pageType = 'insert';
		
		
		var f = document.answerForm;
		
		
		if(pageType == 'insert'){
			
			//띄어 쓰기 추가 (답변등록)
			f.w_content.value = $('#w_content').val();
			f.as_no.value = '${ vo.as_no }';
			f.as_no_link.value = $('#as_no_link').val();
			f.seq.value = v_seq;
			f.pageType.value = pageType;
			
			
		}else if(pageType = 'update'){
			
			f.w_content.value = $('#p_w_content').val();
			f.as_no.value = '${ vo.as_no }';
			f.as_no_link.value = $('#as_no_link').val();
			f.seq.value = v_seq;
			f.pageType.value = pageType;
			
		}
		
		try{
			$("#exlFrame").remove() ;
		}catch(e){}
		
		var downFrame = $('<iframe id="awsFrame" name="awsFrame" style="width:0px; height=0px ; display:none;"></iframe>') ; 
		downFrame.appendTo("body") ;
		
		f.method="post";
		f.target = "awsFrame";
		f.action="/ad/as/awsProc.do";
		f.submit();
		
		setTimeout(function () {
			if(typeof callback === "function"){
				callback('4'); // goSave('4')
			}
		}, 500);
	}
	
	function btnAswProc2() {
		btnAswProc('insert', goSave);
		
		// 고객공지 관련해서 라인어스에서 관리를 하는지, 런처에서 고객공지 등록하는거나 수정하는거 
	}
	
	function awsProcReturn(resultCode){
		
		if(resultCode == "000"){
			alert('정상처리 되었습니다.') ; btnAswCancel();  awsList(1 , '${ vo.as_no }') ; 
		}else{
			alert('처리도중 오류가 발생했습니다.') ; return ; 
		}
		
		$("#uploadFile1").val('');
	}
	
	function aswDelete(seq) {
		//seq
		if (confirm('해당 답변을 삭제 하시겠습니까?')) {
			
			var f = document.answerForm;
	
			f.w_content.value = $('#w_content').val();
			f.as_no.value = '${ vo.as_no }';
			f.seq.value = seq;
			f.pageType.value = 'delete';
				
			try{
				$("#exlFrame").remove() ;
			}catch(e){}
			
			var downFrame = $('<iframe id="awsFrame" name="awsFrame" style="width:0px; height=0px ; display:none;"></iframe>') ; 
			downFrame.appendTo("body") ;
			
			
			f.method="post";
			f.target = "awsFrame";
			f.action="/ad/as/awsProc.do";
			f.submit();
		}
	}
	
	function btnAswCancel() {
		$('#w_content').val('');
		closeLayer(3);
	}
	
	
	function getTaskType(request_type){
		
		if($('#cust_code').val() == "") {
			alert('거래처를 먼저 조회해 주세요.');
			$('#request_type').val('');
			showCustLayer();
			return ; 
		}
		
		
		$('#service_cate').val('') ;
		$('#sel_assign_id').empty() ;
		$('#assign_id').val('') ;
		$('#assign_nm').val('') ;
		$('#inquiry_type').empty() ; 
		$('#version_info').val('') ; 
		$('#version_info_str').val('') ;
		
		
		$('#inquiry_type').append(commonCode.defaultViewOption);
		
		if($('#request_type').val() != "") {
			var datas = {
					'request_type' : request_type,
					'pageType' : '${ vo.pageType }'
				}
			
				common.ajaxCall(datas, '/ad/as/getTaskType.do', 'setTaskType');
		}else{
			$('#service_cate').val('') ;
			$('#inquiry_type').val('') ;
			$('#service_cate').prop('disabled', false).removeClass('write_gray');
			$('#inquiry_type').prop('disabled', false).removeClass('write_gray');
			$('#sel_assign_id').hide() ;
		}
		
		
	}
	
	function setTaskType(data) {
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList
				: null;
		
		commonCode.getCodeList('AS' , 'CD03' , 'service_cate') ;
		
		
		
		$('#val2').val(resultList.val2);
		
		if (resultList.val2 == 'Y') {
			$('#assign_nm').val('') ;
			$('#assign_id').val('') ;
			$('#sel_assign_id').val('');
			
			$('#service_cate').prop('disabled', false).removeClass('write_gray');
			$('#inquiry_type').prop('disabled', false).removeClass('write_gray');
			
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
			$('#service_cate').prop('disabled', true).addClass('write_gray');
			$('#inquiry_type').prop('disabled', true).addClass('write_gray');
			
			$('#version_info').val('') ; 
			$('#version_info_str').val('') ; 
			
			/* 처리담당자 정보 가져오기*/
			var datas = {
					'request_type' : $('#request_type').val(),
					'val2' : $('#val2').val(),
					'pageType' : '${ vo.pageType }'
				}
			
				common.ajaxCall(datas, '/ad/as/getWorker.do', 'setWorker');
			
			
		}
	}
	
	function setWorker(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		$('#assign_nm').val('') ;
		$('#assign_id').val('') ;
		$('#sel_assign_id').val('');
		
		
		if(data != "" && $('#proc_status').val() != 'C005'){
			$('#sel_assign_id').show();
			$('#assign_nm').val(resultList.wk_emp_nm);
			$('#assign_id').val(resultList.wk_emp_no);
			$('#sel_assign_id').val(resultList.wk_emp_no);
			getEmpList();
		}
		
	}
	
	function getEmpList(){
			
			var datas = {
					'request_type' : $('#request_type').val(),
					'service_cate' : $('#service_cate').val(),
					'inquiry_type' : $('#inquiry_type').val(),
					'val2'         : $('#val2').val(),
					'assign_id'    : $('#assign_id').val(),
					'pageType'     : '${ vo.pageType }'
				}
			
			common.ajaxCall(datas, '/ad/as/getAsEmpList.do', 'makeEmpList2') ;
		}
	
	
	function makeEmpList2(data){
			var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
			
			$('#sel_assign_id').empty().append('<option value="">담당자 선택</option>') ; 
			
			if(resultList != null && resultList.length > 0){
				var str = '' ; 
				for(var i = 0 ; i < resultList.length ; i++){
					var datas = resultList[i] ; 
					
					str += '<option value="'+common.nvl(datas.emp_no, '')+'">'+common.nvl(datas.emp_nm, '')+'</option>' ; 
				}	
				
				$('#sel_assign_id').append(str) ;
				$('#sel_assign_id').val($('#assign_id').val());
				//$('#assign_id').val(''); //2024.08.27 접수로 AS신청 시 배정담당자 공백으로 신청되도록 설정
				//$('#assign_id').val('${adUserInfo.emp_no}');
			}
		}
	
	function makeEmpList3(){
		$('#sel_assign_id').empty().append('<option value="">담당자 선택</option>') ; 
		
			var str = '' ; 	
			
			$('#sel_assign_id').append(str) ;
			$('#sel_assign_id').val($('#assign_id').val());
			
	}
	
	
	function setService_cate(thisObj){
		
		/*if($('#request_type').val() == "") {
			alert('문의유형을 먼저 선택해 주세요.');
			$('#service_cate').val('');
			return ; 
		}*/
		
		var pageType = "${ vo.pageType }" ;
		
		$('#sel_assign_id').empty() ;
		$('#assign_id').val('') ;
		$('#assign_nm').val('') ;
		$('#inquiry_type').empty() ; 
		$('#version_info').val('') ; 
		$('#version_info_str').val('') ; 
		
		if(thisObj != ""){
			commonCode.getCodeList('AS' , thisObj , 'inquiry_type') ;
			
			if(thisObj == "P002"){ $('#version_info').val(a) ; if(a != "") $('#version_info_str').val(commonCode.getCodeNm('CUST' , 'CD04' , a));} //기초
			else if(thisObj == "P004"){ $('#version_info').val(b) ; if(b != "") $('#version_info_str').val(commonCode.getCodeNm('CUST' , 'CD05' , b));} //진료
			else if(thisObj == "P003"){ $('#version_info').val(c) ; if(c != "") $('#version_info_str').val(commonCode.getCodeNm('CUST' , 'CD06' , c));} //원무
			else if(thisObj == "P006"){ $('#version_info').val(d) ; if(d != "") $('#version_info_str').val(commonCode.getCodeNm('CUST' , 'CD07' , d));} //청구
			else if(thisObj == "P008" && pageType == "insert"){$('#inquiry_type').find('option[value="C999"]').remove();} //'기타-기타'는 제거
			// version_info_str
			
		}else{
			$('#inquiry_type').append(commonCode.defaultViewOption);	
			
		}
		
		if($('#val2').val() == "Y") {
				$('#sel_assign_id').hide() ;
		}
		
	}
	
	function getInquiry_type(inquiry_type){
		
		if($('#inquiry_type').val() != ''){
			
			/* 처리담당자 정보 가져오기*/
			var datas = {
					'request_type' : $('#request_type').val(),
					'service_cate' : $('#service_cate').val(),
					'inquiry_type' : inquiry_type,
					'val2' : $('#val2').val(),
					'pageType' : '${ vo.pageType }'
				}
			
				common.ajaxCall(datas, '/ad/as/getWorker.do', 'setWorker');
		
		}else{
			if($('#val2').val() == "Y") {
				$('#assign_id').val('') ;
				$('#assign_nm').val('') ;
				$('#sel_assign_id').hide() ;
			}
		}
	}
	
	function setAssign(thisObj){
		$('#assign_nm').val('') ;
		$('#assign_id').val('') ;
		
		if(thisObj != ""){
			$('#assign_nm').val($("#sel_assign_id option:selected").text()) ;
			$('#assign_id').val($("#sel_assign_id option:selected").val()) ;
			
			if($('#chg_assign_id').val() != ''){
				if(($('#chg_assign_id').val() != $('#assign_id').val()) && ($('#assign_id').val() != '${ adUserInfo.emp_no}')){
					$("#action_content_th").append('<span class="request mgl5">필수 입력</span>');
				}else{
					if ($("#action_content_th").find(".request").length !== 0) {
						$("#action_content_th").children('span').remove();
					}
				}
			}else{
				if($('#assign_id').val() != '${ adUserInfo.emp_no}'){
					$("#action_content_th").append('<span class="request mgl5">필수 입력</span>');
				}else{
					if ($("#action_content_th").find(".request").length !== 0) {
						$("#action_content_th").children('span').remove();
					}
				}
			}
		}
	}
	
	
	function goSave(gubun){
		gubun == '4' && $("#btnTab1").trigger("click");
		var f = document.procFrm;
		var requestType = $('#request_type').val(); //문의유형
		var serviceCate = $('#service_cate').val();	//시스템(대)
		var inquiryType = $('#inquiry_type').val();	//시스템(소)
		
		var actionEmpty = (String($('#action_content').val() || '').replace(/\s/g,'') === '');
		
		if (common.isEmpty($('#accept_route').val())) {
			alert('접수 경로를 선택하세요.');
			$('#accept_route').focus(); 
			return;
		}
		if (common.isEmpty($('#cust_kor_name').val())) {
			alert('고객사 정보를 조회해 주세요.');
			return;
		}
		if (common.isEmpty($('#apply_nm').val())) {
			alert('A/S 신청자 이름을 입력하세요.');
			$('#apply_nm').focus(); 
			return;
		}
		if (common.isEmpty($('#rl_apply_nm').val())) {
			alert('A/S 신청자 이름을 입력하세요.');
			$('#rl_apply_nm').focus(); 
			return;
		}
		if (common.isEmpty($('#send_sms1').val()) && common.isEmpty($('#send_sms2').val())) {
			alert('SMS수신동의여부를 선택하세요.');
			$('#send_sms').focus(); 
			return;
		}
		
		if($("#send_sms1").is(":checked")) {
			if(common.isEmpty($('#apply_tel1').val())
					|| common.isEmpty($('#apply_tel2').val())
					|| common.isEmpty($('#apply_tel3').val())){
				alert("SMS 수신 전화번호를 입력해 주세요.") ;
				$('#apply_tel1').focus();
				return ;
			}
		} else if($("#send_sms2").is(":checked")) {
		} else {
			alert("SMS수신동의여부를 선택해주세요.");
			$('#send_sms1').focus();
			return;
		}
		/* $('#send_sms').val($("input[name='sms_yn']:checked").val()); */
		
		$('#apply_tel').val($('#apply_tel1').val() + "-" + $('#apply_tel2').val() + "-" + $('#apply_tel3').val()) ;
		
		if (common.isEmpty($('#request_type').val())) {
			alert('문의유형을 선택하세요.');
			$('#request_type').focus(); 
			return;
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
		
		if (common.isEmpty($('#proc_status').val())) {
			alert('처리상태를 선택하세요.');
			$('#proc_status').focus(); 
			return;
		}	
		if (common.isEmpty($('#inportance').val())) {
			alert('중요도를 선택하세요.');
			$('#inportance').focus(); 
			return;
		}
		
		if(common.isEmpty($('#chg_assign_id').val())){
			if(($('#chg_assign_id').val() != $('#assign_id').val()) && ($('#assign_id').val() != '${ adUserInfo.emp_no}') && actionEmpty ){
				alert('조치이력을 남겨주세요. 처리이력을 파악하는 데 꼭 필요합니다.');
				$('#action_content').focus(); 
				return;
			}
		}else{
			if(($('#assign_id').val() != '${ adUserInfo.emp_no}') && actionEmpty){
				alert('조치이력을 남겨주세요. 처리이력을 파악하는 데 꼭 필요합니다.');
				$('#action_content').focus(); 
				return;
			}
		}
		
		if ($('#assign_id').val() == '' || $('#sel_assign_id').val() == ''){
			alert('담당자 선택은 필수입니다.');
			$('#proc_status').focus(); 
			return;
		}
		
		if($('#proc_status').val() == "C005") {
			
			if(common.isEmpty($('#cause_type').val())){
				alert('원인유형을 선택하세요.');
				$('#cause_type').focus(); 
				return;
			}
			
			if(common.isEmpty($('#action_type').val())){
				alert('조치유형을 선택하세요.');
				$('#action_type').focus(); 
				return;
			}
			
			if(common.isEmpty($('#work_time').val())){
				alert('작업시간을 입력하세요.');
				$('#work_time').focus(); 
				return;
			}
			
			if(common.isEmpty($('#complete_dt').val())){
				alert('처리 완료 일자를 입력하세요.');
				$('#complete_dt').focus(); 
				return;
			}
			
			if(actionEmpty){
				alert('조치이력을 남겨주세요. 처리이력을 파악하는 데 꼭 필요합니다.');
				$('#action_content').focus(); 
				return;
			}
			
			awsList(1);
			
			if ($('#awsa_cnt').val() > 0){
				console.log($('#awsa_cnt').val());
			}else{
				alert('처리상태가 "처리완료"인 경우 답변내역을 1건 이상 남겨주세요.');
				$("#btnTab2").trigger("click");
				return;
			}
			
		} else if( $('#proc_status').val() == "C004") {
			if(common.isEmpty($('#proc_dt').val())){
				alert('처리예정일을 입력하세요.');
				$('#proc_dt').focus(); 
				return;
			}
		} else if( $('#proc_status').val() == "C006") {
			if(common.isEmpty($('#action_content').val())){
				alert('조치이력을 남겨주세요. 처리이력을 파악하는 데 꼭 필요합니다.');
				$('#action_content').focus(); 
				return;
			}
		}
		
		if (($('#action_type').val() == 'C001' || $('#action_type').val() == 'C002') && $('#proc_status').val() == "C005") {
			
			if (common.isEmpty($('#proc_gubun').val())) {
				alert('처리구분을 선택하세요.');
				$('#proc_gubun').focus();
				return;
			}
			
			if (common.isEmpty($('#proc_build_info').val())) {
				alert('빌드순번을 입력하세요.');
				$('#proc_build_info').focus();
				return;
			}
			
			if (common.isEmpty($('#proc_test_info').val())) {
				alert('개발처리서(테스트케이스)를 입력하세요.');
				$('#proc_test_info').focus();
				return;
			}
			
			if ($('#proc_gubun').val() == 'C001'){
				if ($('#proc_process_sp').val().trim() == ''
					&& $('#proc_screen_sp').val().trim() == ''
					&& $('#proc_table_sp').val().trim() == ''
					&& $('#proc_function_sp').val().trim() == ''
					&& $('#proc_interface_sp').val().trim() == ''
					){
					alert('처리구분이 "형상변경"인 경우 아래 목록 중\n한가지 이상의 정의서가 필수입니다.\n-프로세스정의서\n-화면정의서\n-테이블정의서\n-기능분해도\n-인터페이스정의서');
					$('#proc_gubun').focus();
					return;
				}
			}
			
		}
		
		
		
		
		if(gubun == '4' || confirm('저장 하시겠습니까?')){
			
			if( $('#proc_status').val() == "C005") {
				if(common.isEmpty($('#proc_dt').val())){
					$('#proc_dt').val($('#complete_dt').val())
				}
			}
			
			
			
			$('#proc_time').val($('#proc_time1').val() +"" + $('#proc_time2').val()) ; 
			
			$('#proc_status').prop('disabled',false);
			$('#request_type').prop('disabled',false);
			$('#service_cate').prop('disabled',false);
			$('#inquiry_type').prop('disabled',false);

 			if ($('#send_sms1').is(":checked")) {
				f.send_sms.value = "Y";
			} else {
				f.send_sms.value = "N";
			}
 			
 			if ($('#tel_confirm').is(":checked"))
				f.tel_confirm.value = "Y";
 			if ($('#tel_absence').is(":checked"))
				f.tel_absence.value = "Y";
 			
			f.delAttach1.value = delAttach1 ; 
			f.delAttach2.value = delAttach2 ; 
			f.save_gubun.value = gubun; 

			f.target = 'hiddenFrame' ; 
			f.action = '/ad/as/proc.do' ; 
			f.submit() ; 
		}
	}

	function setProcGrade(v_proc_grade) {
		$('.dev_proc, .dev_proc_shape').children('span').remove();
		// 처리상태가 처리완료 이면서 조치유형이 개발, 프로그램 수정 인 경우
		if ($('#proc_status').val() == "C005" && (v_proc_grade == "C001" || v_proc_grade == "C002")) {
			$('.dev_proc').append('<span class="request mgl5">필수 입력</span>');
			$('#completion_details').show();
		}else{
			$('#completion_details').hide();
			$('#proc_gubun').val("");
			$('#proc_build_info').val("");
			$('#proc_test_info').val("");
			$('#proc_process_sp').val("");
			$('#proc_screen_sp').val("");
			$('#proc_table_sp').val("");
			$('#proc_function_sp').val("");
			$('#proc_interface_sp').val("");
		}
	}

	function setProcGubun(v_proc_gubun) {
		$('.dev_proc_shape').children('span').remove();
		// 처리상태가 처리 완료 이면서 조치유형이 개발, 프로그램 수정 이면서 처리구분이 형상변경 인 경우
		if ($('#proc_status').val() == "C005" && ($("#action_type").val() == "C001" || $("#action_type").val() == "C002")){
			
			$('#completion_details').show(); 
			
			if(v_proc_gubun == "C001") {
			$('.dev_proc_shape').append('<span style="color:blue;">&nbsp;&nbsp;&#42;</span>');
			}
			
		}else{
			$('#completion_details').hide();
		}
	}

	function procReturn(gubun,as_no,page_type,cn_as_no,save_gubun) {
		if(gubun == "success"){
			if (save_gubun == 2) {
			alert("정상적으로 처리 되었습니다.") ;
			
				var paramPage ='';
				if(page_type == "insert"){page_type = 'update';}
				if(page_type == "subInsert"){page_type = 'subUpdate';}
			
				var newQuery ="";
				if(page_type == "subUpdate"){
					newQuery = "?pageType=" + page_type + "&as_no=" + as_no + "&cn_as_no=" + cn_as_no;
				}else{
					newQuery = "?pageType=" + page_type + "&as_no=" + as_no;
				}
				
				location.href = '/ad/as/form.do'+newQuery;
				
				
			} else if (save_gubun == 3) {
				alert("정상적으로 처리 되었습니다.");
				
				
				var newQuery ="";
				if(page_type == "insert"){page_type = 'update';}
				if(page_type == "subInsert"){page_type = 'subUpdate';}
				if(page_type == "subUpdate"){
					newQuery = "?pageType=" + page_type + "&as_no=" + as_no + "&cn_as_no=" + cn_as_no + "&gubun=answer";
				}else{
					newQuery = "?pageType=" + page_type + "&as_no=" + as_no + "&gubun=answer";
				}
				
				location.href = '/ad/as/form.do'+newQuery;
				
			}else if(save_gubun == 1){
				alert("정상적으로 처리 되었습니다.");
				goList() ; 
			}else if(save_gubun == 4){
				goList();
			}
		}else{
			alert("처리도중 오류가 발생했습니다.") ; 
			return ; 
		}
	flag = "";
	}
	
	// CMC 수정 - 복사 버튼 추가
	function initViewInsertCopy(){
		var datas = {
			'as_no' : '${ vo.as_no }'
		};
		common.ajaxCall(datas , '/ad/as/getAsInfo.do' , 'makeInitViewInsertCopy') ; 
	}
	
	// CMC 수정 - 복사 버튼 추가
	function makeInitViewInsertCopy(data){
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null;
		
		var pageType = "${ vo.pageType }" ;
		
		if(resultVO != null){
			
			if(pageType != "subUpdate") common.ajaxCall({'as_no' : common.nvl(resultVO.as_no, '')}, '/ad/as/getCnAsList.do', 'makeCnAsList');
			else common.ajaxCall({ 'as_no' : common.nvl(resultVO.cn_as_no, '')}, '/ad/as/getCnAsList.do', 'makeCnAsList');
			
			if(common.nvl(resultVO.cust_code , '') != ''){
				var datas = {'cust_code': common.nvl(resultVO.cust_code, '')};
				common.ajaxCall(datas, '/ad/member/getCustInfo2.do','makeCustInfo');
			}
			
			$('#accept_dt').val(makeDate(common.nvl(resultVO.accept_dt, ''))) ; 
			$('#accept_time').val(makeTime(common.nvl(resultVO.accept_time, '')));
			$('#accept_route').val(common.nvl(resultVO.accept_route, '')) ;
			
			
			$('#call_content_view').html('') ;
			$('#call_content_text').html('0 / 1000 자');
			
			$('#apply_nm').val(common.nvl(resultVO.apply_nm, '')) ;
			$('#apply_id').val(common.nvl(resultVO.apply_id, '')) ;
			
			if(common.nvl(resultVO.apply_tel, '') != ''){
				$('#apply_tel1').val(common.spritStr(resultVO.apply_tel, 1, '-'));
				$('#apply_tel2').val(common.spritStr(resultVO.apply_tel, 2, '-'));
				$('#apply_tel3').val(common.spritStr(resultVO.apply_tel, 3, '-'));
			}
		}
	}
	
	function initView(){
		var datas = {
			'as_no' : '${ vo.as_no }'
		};
		common.ajaxCall(datas , '/ad/as/getAsInfo.do' , 'makeInitView') ; 
	}
	
	function makeInitView(data){
		
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null;
		var attachList = typeof data.attachList != "undefined" ? data.attachList : null;
		var attachList2 = typeof data.attachList2 != "undefined" ? data.attachList2 : null;
		var asHistList = typeof data.asHistList != "undefined" ? data.asHistList : null;
		
		var pageType = "${ vo.pageType }" ;
		
		if(resultVO != null){
			
			$('#as_no_text').html(common.nvl(resultVO.as_no, ''));
			$('#cn_as_no_text').html(common.nvl(resultVO.cn_as_no, ''));
			
			if(pageType != "subUpdate") common.ajaxCall({'as_no' : common.nvl(resultVO.as_no, '')}, '/ad/as/getCnAsList.do', 'makeCnAsList');
			else common.ajaxCall({ 'as_no' : common.nvl(resultVO.cn_as_no, '')}, '/ad/as/getCnAsList.do', 'makeCnAsList');
			
			if(common.nvl(resultVO.cust_code , '') != ''){
				var datas = {'cust_code': common.nvl(resultVO.cust_code, '')};
				common.ajaxCall(datas, '/ad/member/getCustInfo2.do','makeCustInfo');
			}
			
			$('#accept_dt').val(makeDate(common.nvl(resultVO.accept_dt, ''))) ; 
			$('#accept_time').val(makeTime(common.nvl(resultVO.accept_time, '')));
			$('#accept_route').val(common.nvl(resultVO.accept_route, '')) ;
			$('#chatbot_id').val(common.nvl(resultVO.chatbot_id, '')) ;
			$('#as_no_link').val(common.nvl(resultVO.as_no_link, '')) ;
			$('#as_no_link_str').val(common.nvl(resultVO.as_no_link, ''));
			
			$('#request_type').val(common.nvl(resultVO.request_type, '')) ;
			
			if($('#request_type').val() != ''){
				getTaskType(common.nvl(resultVO.request_type, ''));
			}
			
			$('#service_cate').val(common.nvl(resultVO.service_cate, '')) ;
			
			if(common.nvl(resultVO.service_cate, '') != ""){
				setService_cate(common.nvl(resultVO.service_cate, ''));
				$('#inquiry_type').val(common.nvl(resultVO.inquiry_type, '')) ;
				if($('#request_type').val() != ''){
					getInquiry_type(common.nvl(resultVO.inquiry_type, ''));
				}
			}
			
			$('#call_content').val(common.nvl(resultVO.call_content, '')) ;
			$('#call_content_view').html(common.nvl(resultVO.call_content, '')) ;
			$('#call_content_text').html(common.nvl(resultVO.call_content, '').length + '/ 1000 자');
			
			$('#apply_nm').val(common.nvl(resultVO.apply_nm, '')) ;
			$('#apply_id').val(common.nvl(resultVO.apply_id, '')) ;

			if(resultVO.send_sms == 'Y') {
				$('input#send_sms1').prop('checked', true);
			} else {
				$('input#send_sms2').prop('checked', true);
			}
			
			if(common.nvl(resultVO.apply_tel, '') != ''){
				if(resultVO.apply_tel.includes('-')) {
					$('#apply_tel1').val(common.spritStr(resultVO.apply_tel, 1, '-'));
					$('#apply_tel2').val(common.spritStr(resultVO.apply_tel, 2, '-'));
					$('#apply_tel3').val(	common.spritStr(resultVO.apply_tel, 3, '-'));
				} else {
					$('#apply_tel1').val(resultVO.apply_tel.substr(0, 3));
					$('#apply_tel2').val(resultVO.apply_tel.substr(3, 4));
					$('#apply_tel3').val(resultVO.apply_tel.substr(7));
				}
			}
			
			if (common.nvl(resultVO.tel_confirm, '') == "Y") {
				$('#tel_confirm').attr("checked", true);
			} else {
				$('#tel_confirm').attr("checked", false);
			}
			
			if (common.nvl(resultVO.tel_absence, '') == "Y") {
				$('#tel_absence').attr("checked", true);
			} else {
				$('#tel_absence').attr("checked", false);
			}
			
			if ($('#tel_absence').is(':checked')) {
			    $('#tel_absence_cnt').prop('readonly', false).removeClass('write_gray');
			} else {
			    $('#tel_absence_cnt').prop('readonly', true).addClass('write_gray');
			}
			$('#tel_absence_cnt').val(common.nvl(resultVO.tel_absence_cnt, ''));
			
			$('#rl_apply_nm').val(common.nvl(resultVO.rl_apply_nm, '')) ;
			
			
			
			$('#file_seq').val(common.nvl(resultVO.file_seq, '')) ;
			if(pageType == "subInsert"){
				$("#proc_status").val("C001").prop("selected", true);
				chgProcStatus($("#proc_status").val());
			}
			if(pageType != "subInsert"){
				$('#proc_status').val(common.nvl(resultVO.proc_status, '')) ;
				proc_status_current = common.nvl(resultVO.proc_status, '');	//처리상태
				
				var proc_status = common.nvl(resultVO.proc_status, '') ;
				 for(var i = 1 ; i <= 5 ; i++){
					if("C00" + i == proc_status){
						if(!$('#stateC00' + i).hasClass("current")) $('#stateC00' + i).addClass("current");
					}else{
						if($('#stateC00' + i).hasClass("current")) $('#stateC00' + i).removeClass("current");
					}
				}
				 
				$('#cause_type').val(common.nvl(resultVO.cause_type, '')) ;
				$('#action_type').val(common.nvl(resultVO.action_type, '')) ;
				 
				 if ($('#proc_status').val() == "C005" && ($('#action_type').val() == "C001" || $('#action_type').val() == "C002")){
					 $('#completion_details').show();
				 }
				 
				 if ($('#proc_status').val() == "C005"){
					$('#savetoanswer').hide();
					$("#cause_type_th,#action_type_th,#work_time_th,#complete_dt_th,#proc_dt_th,#action_content_th").append('<span class="request mgl5">필수 입력</span>');
				 }else if ($('#proc_status').val() == "C004"){
					$("#proc_dt_th").append('<span class="request mgl5">필수 입력</span>');
				 }else if ($('#proc_status').val() == "C006"){
					$("#action_content_th").append('<span class="request mgl5">필수 입력</span>');
				 }
				 
				 if ($('#proc_status').val() == "C005" || $('#proc_status').val() == "C006"){
					 $('#sel_assign_id').hide();
				 }
				
				 /** 처리구분 */
				$('#proc_gubun').val(common.nvl(resultVO.proc_gubun, ''));
				/** 빌드순번 */
				$('#proc_build_info').val(common.nvl(resultVO.proc_build_info, ''));
				/** 개발처리서(테스트케이스) */
				$('#proc_test_info').val(common.nvl(resultVO.proc_test_info, ''));
				/** 프로세스정의서 */
				$('#proc_process_sp').val(common.nvl(resultVO.proc_process_sp, ''));
				/** 화면정의서 */
				$('#proc_screen_sp').val(common.nvl(resultVO.proc_screen_sp, ''));
				/** 테이블정의서 */
				$('#proc_table_sp').val(common.nvl(resultVO.proc_table_sp, ''));
				/** 기능분해도 */
				$('#proc_function_sp').val(common.nvl(resultVO.proc_function_sp, ''));
				/** 인터페이스정의서  */
				$('#proc_interface_sp').val(common.nvl(resultVO.proc_interface_sp, ''));
				
				setProcGrade($("#action_type").val());
				setProcGubun($("#proc_gubun").val());
				
				/**	중요도	*/$('#inportance').val(common.nvl(resultVO.inportance, ''));
				/**	담당자	*/$('#sel_assign_id').val(common.nvl(resultVO.assign_id, ''));
				/**	담당자	*/$('#assign_id').val(common.nvl(resultVO.assign_id, ''));
				
				if($('#request_type').val() != ''){
					getEmpList();/*등록된 담당자 정보 관련 리스트 정보 재정리*/
				}else{
					makeEmpList3();
				}
				
				if($('#request_type').val() != ''){
					/**	담당자	*/$('#assign_nm').val($("#sel_assign_id option:selected").text());
				}else{
					/**	담당자	*/$('#assign_nm').val(common.nvl(resultVO.assign_nm, ''));
				}
				
				/**	기존담당자	*/$('#chg_assign_id').val(common.nvl(resultVO.assign_id, ''));
				/**	작업시간	*/$('#work_time').val(common.nvl(resultVO.work_time, '')) ; 
				
				/** '접수'상태 일 경우 본인이름 담당자로 노출 
				if (common.nvl(resultVO.proc_status, '') == 'C001'){
					$('#assign_nm').val('${adUserInfo.emp_nm}');//2017.12.06
					$('#assign_id').val('${adUserInfo.emp_id}');//2017.12.06
					getEmpList() ;
					chgProcStatus($("#proc_status").val());
				} */
				
				/* 접수건의 '중요도'가 널일 경우, '일반'값으로 기본 셋팅한다 */
			
				if (resultVO.inportance == '' || resultVO.inportance == null ){
					$('#inportance').val('C002');//2017.01.02
				}
				 
				//if (proc_status == "C001" || proc_status == "C004") $('#sel_assign_id').show();
				
				$('#proc_dt').val(makeDate(common.nvl(resultVO.proc_dt, '')));
				$('#complete_dt').val(makeDate(common.nvl(resultVO.complete_dt, '')));
				
				if(common.nvl(resultVO.proc_dt, '') != ""){
					$('#proc_time1').val(common.nvl(resultVO.proc_time, '').substr(0, 2));
					$('#proc_time2').val(common.nvl(resultVO.proc_time, '').substr(2, 2));
				}
				
				
				
				if(common.nvl(resultVO.as_admin, '') == "N"){
					$('#request_type').prop('disabled', true).addClass('write_gray');
					$('#service_cate').prop('disabled', true).addClass('write_gray');
					$('#inquiry_type').prop('disabled', true).addClass('write_gray');
				}
				
				if(pageType.indexOf("pdate") != -1){
					if(pageType == "update"){
						$('#as_no').val(common.nvl(resultVO.as_no, '')) ; 
					}else{
						$('#as_no').val(common.nvl(resultVO.cn_as_no, '')) ; 
						$('#sel_cn_as_no').val(common.nvl(resultVO.as_no, '')) ; 
						$('#cn_as_no').val(common.nvl(resultVO.as_no, '')) ;	
					}
					 
				}else{
					$('#as_no').val(common.nvl(resultVO.as_no, '')) ; 
				}
				
			}else{
				/* for(var i = 1 ; i <= 5 ; i++){
					if(i == 2){
						if(!$('#stateC00' + i).hasClass("current")) $('#stateC00' + i).addClass("current");
					}else{
						if($('#stateC00' + i).hasClass("current")) $('#stateC00' + i).removeClass("current");
					}
				} */
				
				$('#as_no').val(common.nvl(resultVO.as_no, '')) ; 
				
			}
		}
		
		if(pageType != "subInsert"){
			if(attachList != null && attachList.length > 0){
				
				for(var i = 0 ; i < attachList.length ; i++){
					
					var datas = attachList[i] ; 
					
					var str = '';
					str += '<tr id="mfile'+mfile_cnt+'">';
					str += '<th>파일첨부</th>';
					str += '<td colspan="3">';
					str += '		<input type="file" id="uploadFile_'+mfile_cnt+'" name="uploadFile_'+mfile_cnt+'" class="w225 mgr5">';
					if(i > 0) str += '		<button type="button" class="btn_minus mgr5" onclick="delMfile('+mfile_cnt+');"></button>';
					else str += '		<span type="button" class="btn_plus mgr5" onclick="addMultiFile();"></span>';
					str += '		<button type="button" class="btn_ico_down mgr5" onclick="javascript:fileDown(\''
							+ common.nvl(datas.attach_seq, '')
							+ '\' , \''
							+ common.nvl(datas.attach_ord, '')
							+ '\');"><span>다운로드</span></button>'
							+ common.nvl(datas.attach_ori_nm, '') + '';
					str += '		</td>';
					str += '</tr>';
					$('#wrapMfile').append(str);
					$('#mfile_cnt').val(mfile_cnt);
					
					mfile_cnt = Number(common.nvl(datas.attach_ord, '0')) + 1;
				}
			}else{
				addMultiFile() ;
				
			}	
		}else{
			addMultiFile() ;
			
		}
		
		addFile() ;  //처리사항완료에 있는 첨부파일은 조치이력 리스트에서만 불러옴
		
		$('#asHistTbody').empty() ; 
		
		if(asHistList != null && asHistList.length > 0){
			
			var str = '' ; 
			for(var i = 0 ; i < asHistList.length ; i++){
				var datas = asHistList[i] ; 
				
				var cLen = datas.action_content.length;
				var contents = '';
				// CMC 모든 내용 보이게 처리
				if (parseInt(cLen) > 0){
					contents = common.nvl(datas.action_content , '') 
					//contents = contents + ' <br/><button type="button" class="btn_list_blue" onclick="showHistContent('+(i+1)+');">수정</button> ';
					$('#wrap_contents').append('<input type="hidden" id="layer_cont'+(i+1)+'" value="'+common.nvl(datas.action_content , '')+'" />');
				} else {
					contents = common.nvl(datas.action_content , '');
				}
				$('#wrap_contents').append('<input type="hidden" id="hist_seq' + (i + 1) + '" value="' + common.nvl(datas.seq, '') + '" />');
				$('#wrap_contents').append('<input type="hidden" id="hist_reg_nm'+(i+1)+'" value="'+common.nvl(datas.reg_nm , '')+'" />');
				str += '<tr> ' ;
				str += '	<td>'+common.nvl(datas.reg_date , '')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.reg_nm , '')+'</td> ' ;//등록자
				str += '	<td>'+common.nvl(datas.emp_nm , '')+'</td> ' ;//인수자
				str += '	<td>'+common.nvl(datas.proc_status_nm , '')+ '</td> ';//처리상태
				str += '	<td>'+common.nvl(datas.inportance , '')+'</td> ' ;//중요도 /*2024.04.23.김규민 추가*/
				
				if (contents != '') {
					str += '	<td title="' + datas.action_content + '" style="text-align: left;">' + contents + '</td> '; // CMC 모든 내용 보이게 처리
				} else {
					str += '	<td>'+contents+'</td> ' ;
				}
				str += '	<td>'+'<button type="button" class="btn_list_blue" onclick="showHistContent('+(i+1)+');">수정</button>'+'</td>';
				str += '	<td>';
				if (common.nvl(datas.file_seq , '0') != '0') { 
					str += '		<button type="button" class="btn_file_blue" onclick="javascript:showFileLayer('+ common.nvl(datas.file_seq, '0') + ');"><span>첨부파일</span></button>';
					if (common.nvl(datas.reg_nm, '') == '${ adUserInfo.emp_nm }') {
						//str += '		<button type="button" class="btn_delete_blue" title="첨부파일 삭제" onclick="javascript:deleteFileSeqHist(' + (i + 1) + ');"><span>삭제</span></button>';
					}
					$('#wrap_contents').append('<input type="hidden" id="hist_file_seq' + (i + 1)+ '" value="' + common.nvl(datas.file_seq, '') + '" />');
				}
				str += '</td>';
				str += '</tr> ' ;
			}
			
			$('#asHistTbody').append(str) ; 
			
		}else{
			commonTable.notData(7 , '조회된 데이터가 없습니다.' , 'asHistTbody') ; 
		}
		
		/* 답변내역 값 셋팅*/
		var starCnt = common.nvl(resultVO.star_state, '');
		if (starCnt > 0) $('#wrap_star').show();
		if (starCnt == 1) $('input#star1').prop('checked', true);
		else if (starCnt == 2) $('input#star2').prop('checked', true);
		else if (starCnt == 3) $('input#star3').prop('checked', true);
		else if (starCnt == 4) $('input#star4').prop('checked', true);
		else if (starCnt == 5) $('input#star5').prop('checked', true);
		$('#star_content').val(common.nvl(resultVO.star_content, '')); //건의사항
		
		var queryString = '${ QUERYSTRING }' ;
		if(queryString != ''){
			var arr = queryString.split("&") ;
			var newQuery = '' ; 
			for(var i = 0 ; i < arr.length ; i++){
				
				var datas = arr[i] ; 
				var imsi = datas.split('=') ; 
				if(i == 0) imsi[0] = common.replaceAll(imsi[0], "?", "") ; 
				if(imsi[0] == 'gubun'){
					
					$('[id^=subTab]').hide();
					$('.tab_line li').removeClass("active");

					var dataid = $('#btnTab2').data("id");
					$("#" + dataid).show();
					$('#btnTab2').parent('li').addClass("active");
					$('#w_content').html('');
					
					awsList(1);
					
				}
				
			}
		}
		
	}
	
	function showHistContent(num) {
		$('#div5').show();
		$('#div5_dim').show();
		var f = document.histFrm ; 
		f.show_hist_contents.value = $('#layer_cont'+num).val() ;
		f.seq.value = $('#hist_seq'+num).val() ;
		if ($('#hist_reg_nm'+num).val() == "${ adUserInfo.emp_nm }") {
			$('#updateHistContent').show();
			$("#show_hist_contents").prop('disabled', false);
		} else {
			$('#updateHistContent').hide();
			$("#show_hist_contents").prop('disabled', true);
		}
		$('html, body').animate({
			'scrollTop' : 0
		}, 'slow');
	}
	
	function makeCnAsList(data) {
		
		var resultList = typeof data.resultList != 'undefined' ? data.resultList: null;
		if(resultList != null && resultList.length > 0){
			var str = '';
			for (var i=0; i<resultList.length; i++) {
				var datas = resultList[i];
				str += '<option value="' + common.nvl(datas.as_no, '') + '">' + datas.as_no + '</option>';
			}
			$('#sel_cn_as_no').append(str);
			cnAsNoCnt = resultList.length;
		}
	}
	
	function showSelCnAs() {
		if (common.isEmpty($('#sel_cn_as_no').val())) {
			alert('연관접수번호를 선택 하세요.');
			$('#sel_cn_as_no').focus();
			return;
		}
		
		var f = document.procFrm;
		f.as_no.value = $('#sel_cn_as_no').val();
		f.pageType.value = 'subUpdate';
		f.target = '' ; 
		f.action="/ad/as/form.do";
		f.submit() ;			
	}
	
	function btnInitCnAs() {
		if (confirm('하위작업을 생성하시겠습니까?\n작성 중인 작업이 취소됩니다.')) {
			var f = document.procFrm ; 
			f.pageType.value = 'subInsert' ; 
			f.method = 'GET' ; 
			f.action = '/ad/as/form.do' ; 
			f.submit() ; 
		}
	}
	
	function showFileLayer(attach_seq2) {
		$('#div4').show();
		$('#div4_dim').show();
		$('html, body').animate({'scrollTop' : 0}, 'slow');
		
		var datas = {'attach_seq2' : attach_seq2};
		common.ajaxCall(datas , '/ad/as/getAsHistFileInfo.do' , 'makeFileList') ; 
	}
	
	function makeFileList(data) {
		
		var attach2FileList = typeof data.attach2FileList !='undefined' ? data.attach2FileList: null;
		$('#attach2FileList').empty();
		
		if (attach2FileList != null && attach2FileList.length > 0) {
			var str = '';
			
			for (var i=0; i<attach2FileList.length; i++) {
				var datas = attach2FileList[i];
				str += '<tr>';
				str += '	<th scope="row">첨부파일'+(i+1)+'</th>';
				str += '	<td>';
				str += '		<input type="text" class="w225" value="'
						+ common.nvl(datas.attach_ori_nm, '')
						+ '" readonly="readonly">';
				str += '		<button type="button" class="btn_ico_down mgl5 mgr5" onclick="javascript:fileDown(\''
						+ common.nvl(datas.attach_seq, '')
						+ '\' , \''
						+ common.nvl(datas.attach_ord, '')
						+ '\');"><span>다운로드</span></button>';
				str += '	</td>';
				str += '</tr>';
			}
			
			$('#attach2FileList').append(str);
		}
	}
	
	function goCustLink(type) {
		
		var f = document.procFrm;
		if (type=='cust') {
			location.href = '/ad/cust/form.do?pageType=update&seq='
					+ $('#cust_seq').val() + '&cust_kor_name='
					+ encodeURI($('#cust_kor_name').val()) + '&crm_code='
					+ $('#cust_code').val();
		} else if (type=='member') {
			location.href = '/ad/member/form.do?pageType=update&emp_id='
					+ $('#apply_id').val();
		}
	}
	
	function btnEmpField(type) {
		if (common.isEmpty($('#cust_code').val())) {
			alert('고객사를 조회해 주세요.');
			return;
		}
		$('#apply_nm').val('').prop('readonly', false).prop('placeholder', '이름을 입력하세요.');
		$('#apply_id').val('');
		$('#apply_nm').focus();
		if (type == 'layer') closeLayer(2);
	}
	
	function chgProcStatus(code) {
		
		
		var pageType = '${ vo.pageType}' ;

		if(code != 'C001' && pageType == "insert"){
			$('#proc_status').val('C001'); 
			alert("신규접수등록 A/S건은 '접수'외의 처리상태로 변경이 불가합니다.");
			return;
		}
		
		if(proc_status_current == 'C006' ){
			$('#proc_status').val(proc_status_current); 
			alert("철회된 A/S건은 처리상태 변경이 불가합니다.");
			return;
		}
		
		if (code=='C001' || code=='C004') { 

			if($('#assign_id').val() != ""){
				$('#sel_assign_id').show();
			}
			
			$('#assign_nm').val($("#sel_assign_id option:selected").text()) ;
			$('#assign_id').val($("#sel_assign_id option:selected").val()) ;
			
		}else {
			$('#sel_assign_id').hide();
		}
		
	}
	
	function updateHisContent(){
		var f = document.histFrm ;
		f.pageType.value = "updateHistActionContent";
		if(!confirm('검수확인 하시겠습니까?')) return ;
		common.ajaxCall($('form[name=histFrm]').serialize(), '/ad/as/histProc.do', 'histResult') ;
	}
	
	function histResult(data){
		var msg = "처리도중 오류가 발생했습니다." ; 
		var returnCode = typeof data.returnCode != "undefined" ? data.returnCode : "888";
		if (returnCode == "000")
		{
			msg = "정상처리 되었습니다.";
		}
		alert(msg) ; 
		closeLayer(5);
		getAsHistList();
	}
	
	function deleteFileSeqHist(num) {
		var f = document.histFrm ; 
		f.show_hist_contents.value = $('#layer_cont'+num).val() ;
		f.seq.value = $('#hist_seq'+num).val() ;
		f.file_seq.value = $('#hist_file_seq'+num).val() ;
		f.pageType.value ="deleteFileSeqHist";
		if(!confirm('검수확인 하시겠습니까?')) return ;
		common.ajaxCall($('form[name=histFrm]').serialize(), '/ad/as/histProc.do', 'histResult') ;
	}
	
////답변-첨부파일/////////////////////////////////////////////////////////////////////////////////
	
	function addAswFile() {
	var str = '';
	str += '';
	
	str += '<tr id="asw_file'+aswfile_cnt+'">';
	str += '<th scope="row">첨부파일</th>';
	str += '<td>';
	str += '		<input type="file" id="uploadFile'+aswfile_cnt+'" name="uploadFile'+aswfile_cnt+'" class="w225">';
	if(aswfile_cnt > 1) str += '		<button class="btn_minus mgr5" onclick="delAswFile('+aswfile_cnt + ');"></button>';
	else str += '		<span class="btn_plus mgr5" onclick="addAswFile();"></span> ';
	str += '		<!-- <button type="button" class="btn_ico_down mgr5"><span>다운로드</span></button> -->';					
	str += '		</td>';
	str += '</tr>';		
	$('#aswWrapFile').append(str);
	$('#aswfile_cnt').val(aswfile_cnt);
	
	aswfile_cnt++;
}

function delAswFile(cnt) {
	$('#asw_file'+cnt).remove();
	
	if(delAttach3 == "") delAttach3 = cnt;
	else delAttach3 = delAttach3 + "@" + cnt;
}
	
	//////////////////////////////////////////////////////////////////////////////////////////////
	$( function() {
		$.widget("custom.combobox", {
			_create: function() {
				this.wrapper = $("<span>").addClass("custom-combobox").insertAfter(this.element);
				this.element.hide();
				this._createAutocomplete();
				this._createShowAllButton();
			},

			_createAutocomplete: function() {
				var selected = this.element.children(":selected"),
						 value = selected.val() ? selected.text() : "";

				this.input = $( "<input>" )
					.appendTo( this.wrapper )
					.val( value )
					.attr( "title", "" )
					.addClass("custom-combobox-input ui-widget ui-widget-content ui-state-default ui-corner-left")
					.autocomplete({
						delay: 0,
						minLength: 0,
						source: $.proxy( this, "_source" )
					})
					.tooltip({
						classes: {
							"ui-tooltip": "ui-state-highlight"
						}
					});

				this._on( this.input, {
					autocompleteselect: function( event, ui ) {
						ui.item.option.selected = true;
						this._trigger( "select", event, {
							item: ui.item.option
						});
					},

					autocompletechange: "_removeIfInvalid"
				});
			},

			_createShowAllButton: function() {
				var input = this.input,
					wasOpen = false;

				$( "<a>" )
					.attr( "tabIndex", -1 )
					.tooltip()
					.appendTo( this.wrapper )
					.button({
						icons: {
							primary: "ui-icon-triangle-1-s"
						},
						text: false
					})
					.removeClass( "ui-corner-all" )
					.addClass("custom-combobox-toggle ui-corner-right")
					.on("mousedown", function(){
						wasOpen = input.autocomplete("widget").is(":visible");
					})
					.on("click", function() {
						input.trigger( "focus" );

						// Close if already visible
						if ( wasOpen ) {
							return;
						}

						// Pass empty string as value to search for, displaying all results
						input.autocomplete( "search", "" );
					});
			},

			_source: function( request, response ) {
				var matcher = new RegExp($.ui.autocomplete.escapeRegex(request.term), "i");
				response(this.element.children("option").map(function() {
					var text = $( this ).text();
					if (this.value && (!request.term || matcher.test(text)))
						return {
							label: text,
							value: text,
							option: this
						};
				}));
			},

			_removeIfInvalid: function( event, ui ) {

				// Selected an item, nothing to do
				if ( ui.item ) {
					return;
				}

				// Search for a match (case-insensitive)
				var value = this.input.val(),
					 valueLowerCase = value.toLowerCase(),
					 valid = false;
				this.element.children("option").each(function() {
					if ($(this).text().toLowerCase() === valueLowerCase) {
						this.selected = valid = true;
						return false;
					}
				});

				// Found a match, nothing to do
				if ( valid ) {
					return;
				}

				// Remove invalid value
				this.input
					.val("")
					.attr("title", value + " didn't match any item")
					.tooltip( "open" );
				this.element.val( "" );
				this._delay(function() {
					this.input.tooltip("close").attr("title", "");
				}, 2500 );
				this.input.autocomplete( "instance" ).term = "";
			},

			_destroy: function() {
				this.wrapper.remove();
				this.element.show();
			}
		});

	} );
	
	/*데이터 유효성검사*/
	function chkDateFormat(inputId, data){
		
		var inputId = inputId;
		var data = data;
		
		if(data > 1000){
			alert('작업시간을 다시 입력해 주시길 바랍니다.');
			$('#' + inputId).val("");
	        $('#' + inputId).focus();
		}
		
		if(data < 0){
			alert('작업시간은 음수 입력이 불가능합니다. 다시 입력해 주시길 바랍니다.');
			$('#' + inputId).val("");
	        $('#' + inputId).focus();
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
	
	function showProcGradePopLayer() {
		$('#div8').show();
		$("#div8")
				.css(
						{
							"top" : (($(window).height() - $("#div8")
									.outerHeight()) / 2 + $(window).scrollTop())
									+ 200 + "px"
						});
		$('#div8_dim').show();
	}
	
	// 레이어 열기
	function showLinkLayer(){
	    var current = $('#as_no_link').val();
	    if (current && $.trim(current) !== '') {
	        selectedAsNos = current.split(',').map(function(v){
	            return $.trim(v);
	        });
	    } else {
	        selectedAsNos = [];
	    }
	
	    getUnprocessedAsListAdmin();
	    $('#LinkLayer').show();
	    $('#div_dim').show();
	}
	
	function showCompleteLinkLayer(){
	    getprocessedAsListAdmin();
	    $("#processedas-layer").show();
	    $('#completeLinkLayer').show();
	    $('#search_start4').focus(); 
	    $('#div_dim5').show();
	}
	
	function closeUnprocessedLayer() {
	    $("#unprocessedas-layer").hide();
	}
	
	function closeprocessedLayer() {
	    $("#processedas-layer").hide();
	}

	// 목록 조회 (직원용 URL)
	function getUnprocessedAsListAdmin(){

	    var datas = {
	        as_str_dt   : $("#search_start3").val(),
	        as_end_dt   : $("#search_end3").val(),
	        asGubunFlag : $("input[type=radio][name=type1]:checked").val(),
	        user_id     : $("#user_id").val(),
	        search_text : $("#search_text").val()
	    };

	    common.ajaxCall(datas, '/ad/as/getUnprocessedAsList.do', 'setUnprocessedAsListAdmin');
	}
	
	// 목록 조회 (직원용 URL)
	function getprocessedAsListAdmin(){

	    var datas = {
	        as_str_dt   : $("#search_start4").val(),
	        as_end_dt   : $("#search_end4").val(),
	        user_id     : $("#user_id").val(),
	        search_text : $("#search_text").val()
	    };

	    common.ajaxCall(datas, '/ad/as/getprocessedAsList.do', 'setprocessedAsListAdmin');
	}

	function setUnprocessedAsListAdmin(data) {

		  // tbody만 비우고 다시 그림
		  $('#asList').empty();

		  var raw = (typeof data.resultList !== "undefined") ? data.resultList : null;
		  var currentAsNo = String($('#as_no').val() || ''); // 현재 접수번호(내 AS)

		  // 매번 맵 초기화
		  unprocessedAsMap = {};

		  if (!raw || raw.length === 0) {
		    var emptyRow = ''
		      + '<tr>'
		      + '  <td colspan="3" style="text-align:center; padding:20px;">'
		      + '    해당 날짜의 미처리 A/S가 없습니다.<br>다시 조회해 주세요.'
		      + '  </td>'
		      + '</tr>';
		    $('#asList').html(emptyRow);
		    return;
		  }

		  // 내 AS번호는 선택 배열에 항상 포함
		  if (currentAsNo && selectedAsNos.indexOf(currentAsNo) === -1) {
		    selectedAsNos.push(currentAsNo);
		  }

		  // 선택된 것 먼저 보여주기
		  var selected = [];
		  var others = [];

		  for (var i = 0; i < raw.length; i++) {
		    var v = raw[i];

		    // 필요하면 맵에 담기
		    unprocessedAsMap[String(v.AS_NO)] = v;

		    if (selectedAsNos.indexOf(String(v.AS_NO)) >= 0) selected.push(v);
		    else others.push(v);
		  }

		  var result = selected.concat(others);
		  var str = '';

		  for (var j = 0; j < result.length; j++) {
		    var val = result[j];

		    var asNoRaw = String(val.AS_NO);
		    var asNo = (typeof escapeHtml === 'function') ? escapeHtml(asNoRaw) : asNoRaw;

		    var isMine = (currentAsNo && asNoRaw === currentAsNo);

		    // 문의내용(한 줄 요약)
		    var callContent = (val.CALL_CONTENT || '')
		      .replace(/\r?\n/g, ' ')
		      .replace(/\s+/g, ' ')
		      .trim();

		    var callContentTitle = (typeof escapeHtml === 'function') ? escapeHtml(callContent) : callContent;

		    // ✅ AS_NO_LINK 파싱
		    var linkStr = (val.AS_NO_LINK || '');
		    var linkArr = String(linkStr).split(',')
		      .map(function (s) { return String(s).trim(); })
		      .filter(function (s) { return s; });

		    // ✅ "내 AS를 포함하지 않는 독립적인 링크그룹"이면 선택 불가
		    // - 링크가 존재하는데(linkArr.length>0)
		    // - 내 AS(currentAsNo)가 링크에 없으면
		    var isIndependentLinkGroup =
		      (!isMine) &&
		      (linkArr.length > 0) &&
		      (currentAsNo && linkArr.indexOf(currentAsNo) === -1);

		    // 체크 여부: 내 AS는 무조건 체크, 그 외는 selectedAsNos 기반
		    var checkedAttr = isMine ? ' checked="checked"' :
		      (selectedAsNos.indexOf(asNoRaw) >= 0 ? ' checked="checked"' : '');

		    // disabled: 내 AS는 해제 불가, 독립 링크그룹은 선택 불가
		    var disabledAttr = isMine ? ' disabled="disabled"' :
		      (isIndependentLinkGroup ? ' disabled="disabled"' : '');

		    // 화면에 보이는 문의내용은 33자 정도로
		    var preview = callContent.substr(0, 33);
		    preview = (typeof escapeHtml === 'function') ? escapeHtml(preview) : preview;

		    str += ''
		      + '<tr>'
		      + '  <td><input type="checkbox" class="chk-as" value="' + asNo + '"' + checkedAttr + disabledAttr + '></td>'
		      + '  <td>' + asNo + '</td>'
		      + '  <td title="' + callContentTitle + '" style="text-align:left; white-space:pre-line;">'
		      +        preview
		      + '  </td>'
		      + '</tr>';
		  }

		  $('#asList').html(str);

		  // 이벤트 중복 방지 후 재바인딩
		  $(document)
		    .off('change', '#LinkLayer input.chk-as')
		    .on('change', '#LinkLayer input.chk-as', function () {
		      if ($(this).is(':disabled')) return; // disabled는 무시 (내 AS + 독립그룹)

		      var no = String($(this).val());

		      // ✅ 선택한 AS의 링크들 가져오기
		      var row = unprocessedAsMap[no];
		      var linked = [];
		      if (row && row.AS_NO_LINK) {
		        linked = String(row.AS_NO_LINK).split(',')
		          .map(function (s) { return String(s).trim(); })
		          .filter(function (s) { return s; });
		      }

		      if (this.checked) {
		        // ✅ 본인 추가
		        if (selectedAsNos.indexOf(no) === -1) selectedAsNos.push(no);

		        // ✅ 링크된 AS들도 "추가만" 한다
		        linked.forEach(function (x) {
		          if (selectedAsNos.indexOf(x) === -1) selectedAsNos.push(x);
		        });

		        // ✅ 화면 체크 동기화: 추가된 애들도 체크 표시
		        $('#LinkLayer input.chk-as').each(function () {
		          var v = String($(this).val());
		          $(this).prop('checked', selectedAsNos.indexOf(v) >= 0);
		        });

		      } else {
		        // ✅ 해제는 "본인만" 뺀다 (링크는 건드리지 않음)
		        selectedAsNos = selectedAsNos.filter(function (v) {
		          return String(v) !== no;
		        });

		        // 화면도 본인만 체크 해제
		        $(this).prop('checked', false);
		      }
		    });
		}

	
	
	function setprocessedAsListAdmin(data) {

		  // 중요: 박스(div) 비우면 테이블이 사라져서 클릭도 안 됩니다
		  // $('#processedas-box').empty();  <-- 이거 절대 쓰지 마세요

		  var $tbody = $('#processedAsList'); // HTML의 tbody id와 반드시 동일해야 함
		  $tbody.empty();

		  var raw = (data && data.resultList) ? data.resultList : [];

		  if (!raw || raw.length === 0) {
		    $tbody.html(
		      '<tr>' +
		      '  <td colspan="4" style="text-align:center; padding:20px;">' +
		      '    해당 날짜의 미처리 A/S가 없습니다.<br>다시 조회해 주세요.' +
		      '  </td>' +
		      '</tr>'
		    );
		    return;
		  }

		  function escAttr(s) {
		    return String(s == null ? '' : s)
		      .replace(/&/g, '&amp;')
		      .replace(/"/g, '&quot;')
		      .replace(/</g, '&lt;')
		      .replace(/>/g, '&gt;');
		  }

		  function oneLine(s) {
		    return String(s == null ? '' : s)
		      .replace(/\r?\n/g, ' ')
		      .replace(/\s+/g, ' ')
		      .trim();
		  }

		  function setValIfExists(selectors, value) {
		    for (var i = 0; i < selectors.length; i++) {
		      var $el = $(selectors[i]);
		      if ($el.length) {
		        $el.val(value).trigger('change');
		        return true;
		      }
		    }
		    return false;
		  }

		  function setTextIfExists(selectors, value) {
		    for (var i = 0; i < selectors.length; i++) {
		      var $el = $(selectors[i]);
		      if ($el.length) {
		        $el.val(value).trigger('input').trigger('change');
		        return true;
		      }
		    }
		    return false;
		  }

		  var str = '';

		  for (var i = 0; i < raw.length; i++) {
		    var val = raw[i];

		    var asNo = String(val.AS_NO || '');
		    var causeCode = String(val.CAUSE_TYPE || '');
		    var actionCode = String(val.ACTION_TYPE || '');

		    var causeNm = String(val.CAUSE_TYPE_NM || '');
		    var actionNm = String(val.ACTION_TYPE_NM || '');

		    var actionContent = String(val.ACTION_CONTENT || '');
		    var title = oneLine(actionContent);
		    var preview = title.substr(0, 50);

		    str += ''
		      + '<tr class="processed-row" style="cursor:pointer;" '
		      + ' data-asno="' + escAttr(asNo) + '" '
		      + ' data-cause="' + escAttr(causeCode) + '" '
		      + ' data-action="' + escAttr(actionCode) + '" '
		      + ' data-action-content="' + escAttr(actionContent) + '">'
		      + '  <td>' + escAttr(asNo) + '</td>'
		      + '  <td>' + escAttr(causeNm) + '</td>'
		      + '  <td>' + escAttr(actionNm) + '</td>'
		      + '  <td title="' + escAttr(title) + '" style="text-align:left; white-space:pre-line;">'
		      +        escAttr(preview)
		      + '  </td>'
		      + '</tr>';
		  }

		  $tbody.html(str);

		  // 이벤트는 tbody에 위임해서 확실하게 잡기
		  $tbody.off('click', 'tr.processed-row').on('click', 'tr.processed-row', function () {

		    $(this).addClass('is-selected').siblings().removeClass('is-selected');

		    var cause = $(this).data('cause');
		    var action = $(this).data('action');
		    var actionContent = $(this).attr('data-action-content') || '';

		    // cause_type: 비어있을 때만 세팅
		    var $cause = $('#cause_type');
		    if (!$cause.val()) {
		      setValIfExists(
		        ['#cause_type', '#CAUSE_TYPE', '#causeType', 'select[name="cause_type"]', 'select[name="CAUSE_TYPE"]'],
		        cause
		      );
		    }

		    // action_type: 비어있을 때만 세팅
		    var $action = $('#action_type');
		    if (!$action.val()) {
		      setValIfExists(
		        ['#action_type', '#ACTION_TYPE', '#actionType', 'select[name="action_type"]', 'select[name="ACTION_TYPE"]'],
		        action
		      );
		    }

		    // action_content: 비어있을 때만 세팅 (공백만 있는 것도 비어있음 처리)
		    var $content = $('#action_content');
		    var curContent = ($content.val() || '').replace(/\s+/g, '').trim();
		    if (!curContent) {
		      setTextIfExists(
		        ['#action_content', '#ACTION_CONTENT', '#actionContent', 'textarea[name="action_content"]', 'textarea[name="ACTION_CONTENT"]'],
		        actionContent
		      );
		    }
		    
		    selectAsFromPopup();
		    
		    $('#completeLinkLayer').hide();
		    $('#div_dim5').hide();
		    
		  });
		}


	
	
	function selectAsFromPopup() {
		   var today = getTodayStr();

		    // proc_dt가 비어있으면 오늘 날짜 세팅
		    if (!$('#proc_dt').val()) {
		        $('#proc_dt').val(today);
		    }

		    // complete_dt가 비어있으면 오늘 날짜 세팅
		    if (!$('#complete_dt').val()) {
		        $('#complete_dt').val(today);
		    }
		    
		 // 시간 자동 세팅
		    var t1 = $('#proc_time1').val();
		    var t2 = $('#proc_time2').val();

		    if (t1 === '00' && t2 === '00') {
		        var now = new Date();
		        var hh  = ('0' + now.getHours()).slice(-2);
		        var mm  = ('0' + now.getMinutes()).slice(-2);

		        $('#proc_time1').val(hh);
		        $('#proc_time2').val(mm);
		    }
		// 작업시간 자동 세팅
		    var workTime = $('#work_time').val();

		    if (!workTime) {
		        $('#work_time').val('1');
		    }
	}
	
	function getTodayStr() {
		  var d = new Date();
		  var yyyy = d.getFullYear();
		  var mm = ('0' + (d.getMonth() + 1)).slice(-2);
		  var dd = ('0' + d.getDate()).slice(-2);
		  return yyyy + '/' + mm + '/' + dd;
		}
	
	function onlyPositiveInt(el) {
		el.value = el.value.replace(/[^0-9]/g, '');
		el.value = el.value.replace(/^0+/, '');
	}
	
	function resetUnprocessedAs() {
	    selectedAsNos = [];
	    $("#unprocessedas-box input.chk-as").prop("checked", false);
	}

	function confirmUnprocessedAs() {
	    if (selectedAsNos.length === 0) {
	        alert('선택된 A/S가 없습니다.');
	        return;
	    }

	    var joined = selectedAsNos.join(',');
	    $('#as_no_link').val(joined);
	    $('#as_no_link_str').val(joined);

	    // 팝업 닫기
	    $('#LinkLayer').hide();
	    $('#div_dim').hide();
	}

	// 초기화 버튼
	function clearUnprocessedAs(){
	    selectedAsNos = [];
	    $('#unprocessedas-box input.chk-as').prop('checked', false);
	    $('#as_no_link').val('');
	    $('#as_no_link_str').val('');
	}
	
	
</script>

<form name="procFrm" id="procFrm" method="post" enctype="multipart/form-data" onsubmit="return false;" autocomplete="off" novalidate>
	<input type="hidden" name="pageType" id="pageType" value="${ vo.pageType }"/>
	<input type="hidden" name="apply_tel" id="apply_tel" value=""/>
	<input type="hidden" name="send_sms" id="send_sms" value=""/>
	<input type="hidden" name="proc_time" id="proc_time" value=""/>
	
	<input type="hidden" name="file_seq" id="file_seq" value=""/>
	<input type="hidden" name="attach_seq2" id="attach_seq2" value="0"/>
	
	<input type="hidden" name="delAttach1" id="delAttach1" value=""/>
	<input type="hidden" name="delAttach2" id="delAttach2" value=""/>
	
	<input type="hidden" name="seq" id="seq" value=""/>
	<input type="hidden" name="crm_code" id="crm_code" value=""/>
	<input type="hidden" name="cn_as_no" id="cn_as_no" value=""/>
	<input type="hidden" name="save_gubun" id="save_gubun" value=""/>
	<input type="hidden" name="awsa_cnt" id="awsa_cnt" value=""/>
	
	<input type="hidden" name="val2" id="val2" value=""/>
	
	<div class="tit_wrap">
		<h2 class="tit_ico_as">A/S 관리<span class="tit_depth mgl20 mgt8">상세처리내역 조회</span></h2>
		<div class="location">
			<a href="/ad/main/list.do" class="home">Home</a>
			<a href="/ad/as/list.do" class="depth"><span class="here">A/S관리</span></a>
		</div>
	</div>
	
	<!-- process -->
	<ul class="pro_arrow list3 mgb50">
		<li id="stateC001">접수</li>
		<li id="stateC004">처리중</li>
		<li id="stateC005">처리완료</li>
	</ul>
<!--// process -->
	<div class="tit_sWrap">
		<h3 class="tit_dot_gray">A/S 접수 상세 정보
			<c:choose>
				<c:when test="${ vo.pageType eq 'subInsert' }">
					(<span id="as_no_text"></span>&nbsp;&gt;&nbsp;<span class="colorBlue mg15" style="line-height:25px;">해당 건의 하위작업을 생성중입니다</span>)				
				</c:when>
				<c:when test="${ vo.pageType eq 'subUpdate' }">
					(<span id="cn_as_no_text"></span>&nbsp;&gt;&nbsp;<span id="as_no_text" class="colorBlue mg15" style="line-height:25px;"></span>)
				</c:when>
			</c:choose>
		</h3>
	</div>
<!-- tab -->
	<ul class="tab_line list2 mgb20">
		<li class="active"><a href="#" id="btnTab1" data-id="subTab1">A/S 접수·처리 정보</a></li><!-- 활성시 current -->
		<li><a href="#" id="btnTab2" data-id="subTab2">답변내역</a></li>
	</ul>
<!--// tab -->
<div id="subTab1">
	<div class="tit_bWrap mgb10 tit_relative">
		<h4>접수 정보</h4>
	</div>
	<!-- write -->
	<table class="sType mgb20">
		<caption>접수 정보 입력</caption>
		<colgroup>
			<col style="width:180px;" />
			<col style="width:340px;" />
			<col style="width:160px;" />
			<col style="width:340px;" />
		</colgroup>
		<tr>
			<th scope="row">고객접수번호</th>
			
			<c:choose>
				<c:when test="${ vo.pageType eq 'insert' || vo.pageType eq 'insertcopy' }">
				<td colspan="3">
					<input type="text" id="as_no" name="as_no" readonly="readonly" value="" class="w193 mgr5" title="고객접수번호 입력" />
				</td>
				</c:when>
				<c:when test="${ vo.pageType eq 'update' }">
				<td>
					<input type="text" id="as_no" name="as_no" readonly="readonly" value="" class="w193 mgr5" title="고객접수번호 입력" /><button type="button" id="CnAS" class="btn_line_gray w100" onclick="btnInitCnAs();">하위작업 생성</button>
				</td>
				<th scope="row">연관접수번호</th>
				<td>
					<select name="sel_cn_as_no" id="sel_cn_as_no" title="하위작업번호 선택" class="w225 mgr2">
						<option value="">연관접수번호 선택</option>
					</select><button type="button" id="btnSelCnAs" class="btn_line_gray" onclick="showSelCnAs();">조회</button>
				</td>	
				</c:when>
				<c:when test="${ vo.pageType eq 'subInsert' }">
				<td colspan="3">
					<input type="text" id="as_no" name="as_no" readonly="readonly" value="" class="w193 mgr5" title="고객접수번호 입력" />
				</td>
				</c:when>
				<c:otherwise>
				<td>
					<input type="text" id="as_no" name="as_no" readonly="readonly" value="" class="w193 mgr5" title="고객접수번호 입력" />
				</td>
				<th scope="row">연관접수번호</th>
				<td>
					<select name="sel_cn_as_no" id="sel_cn_as_no" title="하위작업번호 선택" class="w225 mgr2">
						<option value="">연관접수번호 선택</option>
					</select><button type="button" id="btnSelCnAs" class="btn_line_gray" onclick="showSelCnAs();">조회</button>
				</td>
				</c:otherwise>
			</c:choose>
		</tr>
		<c:if test="${ vo.pageType eq 'update' || vo.pageType eq 'subUpdate' }">
		<tr>
			<th scope="row">접수일자</th>
			<td><input type="text" name="accept_dt" id="accept_dt" readonly="readonly" value="" class="w193" title="접수일자 입력" /></td>
			<th scope="row">접수시간</th>
			<td><input type="text" name="accept_time" id="accept_time" readonly="readonly" value="" class="w225" title="접수시간 입력" /></td>
		</tr>
		</c:if>
		<c:choose>
			<c:when test="${ vo.pageType eq 'insert' || vo.pageType eq 'update' || vo.pageType eq 'subUpdate' }">
			<tr>
				<th>접수 경로<span class="request mgl5">필수 입력</span></th>
				<td><select name="accept_route" id="accept_route" title="접수 경로 선택" class="w193 mgr2"></select></td>
				<th scope="row">챗봇ID</th>
				<td><input type="text" name="chatbot_id" id="chatbot_id" readonly="readonly" value="" class="w225" title="챗봇ID 입력" /></td>
			</tr>
			<c:if test="${ vo.pageType eq 'update'}">
			<tr id="asno_list">
				<th scope="row">연결된 접수번호<span class="request">필수 입력</span></th>
				<td colspan="3"> 
					<input type="text" 	id="as_no_link_str" readonly="readonly" style="width: 697px !important; white-space: nowrap !important; overflow: hidden; text-overflow: ellipsis;">
					<input type="hidden" name="as_no_link" id="as_no_link" >
					<button type="button" id="btnUnprocessedAs" class="btn_line_gray" style="width:100px" onclick="showLinkLayer()">AS내역</button>
				</td>
			</tr>
			</c:if>
			</c:when>
			<c:otherwise>
			<tr>
				<th>접수 경로<span class="request mgl5">필수 입력</span></th>
				<td colspan="3">
					<select name="accept_route" id="accept_route" title="접수 경로 선택" class="w193 mgr2"></select>
				</td>
			</tr>
			</c:otherwise>
		</c:choose>
	</table>
	<!--// write -->
	<div class="tit_bWrap mgb10">
		<h4>고객사 정보</h4>
	</div>
	<!-- write -->
	<table class="sType mgb20">
		<caption>고객사 정보 입력</caption>
		<colgroup>
			<col style="width:180px;" />
			<col style="width:290px;" />
			<col style="width:118px;" />
			<col style="width:149px;" />
			<col style="width:134px;" />
			<col style="width:153px;" />
		</colgroup>
		<tr>
			<th scope="row">고객사 명<span class="request mgl5">필수 입력</span></th>
			<td>
				<input type="hidden" name="cust_seq" id="cust_seq" />
				<input type="text" name="cust_kor_name" id="cust_kor_name" readonly="readonly" value="" class="w175 mgr5" title="고객사 명 입력" /><c:choose><c:when test="${ vo.pageType eq 'insert' }"><button type="button" class="btn_line_gray" onclick="showCustLayer();">조회</button></c:when><c:otherwise><button type="button" class="btn_line_gray" onclick="goCustLink('cust');">상세보기</button></c:otherwise></c:choose>
			</td>
			<th scope="row">고객사 코드</th>
			<td>	
				<input type="text" name="cust_code" id="cust_code" readonly="readonly" value="" class="w109 mgr5" title="고객사 코드 입력" />
			</td>
			<!-- CMC 모든 내용 보이게 처리-->
			<th scope="row">HIS 진료</th> 
			<td>
				<input type="text" readonly="readonly" name="cust_his_treat_name" id="cust_his_treat_name" title="HIS 진료 선택" class="w113"/>
			</td>  
		</tr>
		<tr>
			<th scope="row">고객사 주소</th>
			<td><input type="text" name="cust_addr" id="cust_addr" readonly="readonly" value="" class="w250" title="고객사 주소 입력" /></td>
			<th scope="row">우편번호</th>
			<td><input type="text" name="cust_post" id="cust_post" readonly="readonly" value="" class="w109" title="우편번호 입력" /></td>
			<th scope="row">고객사 연락처</th>
			<td><input type="text" name="cust_tel" id="cust_tel" readonly="readonly" value="" class="w113" title="고객사 연락처 입력" /></td>
		</tr>
		<tr>
			<th scope="row">A/S신청자 아이디<span class="request mgl5">필수 입력</span></th>
			<td>
				<input type="text" name="apply_nm" id="apply_nm" value="" class="w100 mgr5 mgb5"  title="A/S신청자 이름 입력" readonly="readonly" />
				<input type="text" name="apply_id" id="apply_id" value="" class="w100 mgr5 mgb5" title="A/S신청자 아이디 입력" readonly="readonly" /><c:choose><c:when test="${ vo.pageType eq 'insert' }"><button type="button" class="btn_line_gray mgr5" onclick="showEmpLayer();">조회</button> <button type="button" class="btn_line_gray" onclick="btnEmpField();">직접입력</button></c:when><c:otherwise><button type="button" class="btn_line_gray" onclick="goCustLink('member');">상세보기</button></c:otherwise></c:choose>
			</td>
			<th scope="row">A/S 신청자 연락처</th>
			<td colspan="3">
				<input type="text" name="apply_tel1" id="apply_tel1" maxlength="4" value="" class="w60 mgr5" id="as_call" title="A/S 신청자 연락처 입력" />
				<input type="text" name="apply_tel2" id="apply_tel2" maxlength="4" value="" class="w60 mgl5 mgr5" id="as_call" title="A/S 신청자 연락처 입력" />
				<input type="text" name="apply_tel3" id="apply_tel3" maxlength="4" value="" class="w60 mgl5" id="as_call" title="A/S 신청자 연락처 입력" />
			</td>
		</tr>
		<tr>
			<th scope="row">A/S신청자 이름<span class="request mgl5">필수 입력</span></th>
			<td>
				<input type="text" name="rl_apply_nm" id="rl_apply_nm" value="" class="w250"  title="A/S신청자 이름 입력" />
			</td>
			<th>SMS수신동의여부<span class="request mgl5">필수 입력</span></th>
			<td colspan="3">
				<input type="radio" name="sms_yn" id="send_sms1" class="mgr10" value="Y"/>
				<label for="send_sms1">동의</label>
				<input type="radio" name="sms_yn" id="send_sms2" class="mgr5 mgl10" value="N"/>
				<label for="send_sms2">미동의</label>
			</td>
		</tr>
	</table>
	<!--// write -->
	<div class="tit_bWrap mgb10">
		<h4>문의 유형 정보</h4>
	</div>
	<!-- write -->
	<table class="sType mgb20" id="wrapMfile">
		<caption>문의 유형 정보 입력</caption>
		<colgroup>
			<col style="width:180px;" />
			<col style="width:340px;" />
			<col style="width:160px;" />
			<col style="width:340px;" />
		</colgroup>
		<tr>
			<th scope="row">문의유형<span class="request mgl5">필수 입력</span></th>
			<td>
				<select name="request_type" id="request_type" title="문의유형 선택" class="w200" onchange="javascript:getTaskType(this.value);">
					<option value="">선택</option>
				</select>
				<button type="button" id="btnProgramName" class="btn_line_gray" style="width:90px"
						onclick="showRequestTypePopLayer()">문의유형 기준표</button>
			</td>
			<th scope="row">버전 정보</th>
			<td>
				<input type="text" id="version_info_str" readonly="readonly" value="" title="버전 정보 입력" />
				<input type="hidden" name="version_info" id="version_info" value="" title="버전 정보 입력" />
			</td>
		</tr>
		<tr>
			<th scope="row">시스템(대)<span class="request mgl5">필수 입력</span></th>
			<td>
				<select name="service_cate" id="service_cate" title="시스템(대) 선택" class="w300" onchange="javascript:setService_cate(this.value);">
					<option value="">선택</option>
				</select>
			</td>
			<th scope="row">시스템(소)<span class="request mgl5">필수 입력</span></th>
			<td>
				<select id="inquiry_type" name="inquiry_type" title="시스템(소) 선택" class="w300" onchange="javascript:getInquiry_type(this.value);"></select>
			</td>
		</tr>
		<tr>
			<th>요청 내용<span style="color:blue;">(고객에게 공개되는 내용입니다)</span></th>
			<td colspan="3">
				<textarea name="call_content" id="call_content" class="mgb5"></textarea>
				<div class="txt_byte" id="call_content_text">0 / 1000자</div>
			</td>
		</tr>
	</table>
	<!--// write -->
	<div class="tit_bWrap mgb10">
		<h4>처리상태 사항</h4>
	</div>
	<!-- write -->
	<table class="sType mgb20">
		<caption>처리상태 사항 입력</caption>
		<colgroup>
			<col style="width:180px;" />
			<col style="width:340px;" />
			<col style="width:160px;" />
			<col style="width:340px;" />
		</colgroup>
		<tr>
			<th scope="row">배정담당자</th>
			<td>
				<input type="text" name="assign_nm" id="assign_nm" readonly="readonly" value="${ adUserInfo.emp_nm }" title="배정담당자 입력" />
			</td>
			<th scope="row">처리상태 선택<span class="request mgl5">필수 입력</span></th>
			<td>
				<select name="proc_status" id="proc_status" title="처리상태 선택" class="w145" onchange="chgProcStatus(this.value);"></select>
				<select name="sel_assign_id" id="sel_assign_id" style="display: none;" title="담당자 선택" class="w145" onchange="setAssign(this.value);"></select>
				<input type="hidden" name="assign_id" id="assign_id" value="${ adUserInfo.emp_id }" />
				<input type="hidden" name="chg_assign_id" id="chg_assign_id" value="" />
			</td>
		</tr>
		<tr>
			<th scope="row">중요도<span class="request mgl5">필수 입력</span></th>
			<td>
				<select id="inportance" name="inportance" title="처리상태 선택" class="w200">
					<option value="">선택해주세요</option>
				</select>
				<button type="button" id="btnProgramName" class="btn_line_gray"
						onclick="showProcGradePopLayer()">등급 기준표</button>
			</td>
			<th scope="row">전화 확인</th>
		    <td>
		        <label for="tel_confirm">
		            <input type="checkbox" id="tel_confirm" name="tel_confirm"> 전화확인 완료
		        </label>
		        <label for="tel_absence" class="mgl5">
		            <input type="checkbox" id="tel_absence" name="tel_absence"> 전화 부재중
		        </label>
		         <input type="text" id="tel_absence_cnt" name="tel_absence_cnt" class="w60 mgr5 write_gray" maxlength="3" oninput="onlyPositiveInt(this)" readonly="readonly">
		    </td>
		</tr>
	</table>
	<!--// write -->
	<div class="tit_bWrap mgb10 tit_relative">
		<h4>처리완료 사항</h4>
		<button type="button" id="btnSameProcess" class="btn_line_gray w100" onclick="showCompleteLinkLayer();"> 처리완료내역 </button>
	</div>
	<!-- write -->
	<table class="sType mgb10">
		<caption>처리완료 사항 입력</caption>
		<colgroup>
			<col style="width:180px;" />
			<col style="width:340px;" />
			<col style="width:160px;" />
			<col style="width:340px;" />
		</colgroup>
		<tr>
			<th scope="row" id="proc_dt_th">처리 예정 일자</th>
			<td>
				<input type="text" name="proc_dt" id="proc_dt" value="" title="처리 예정 일자 입력" class="w120 mgr5" />
			</td>
			<th scope="row">처리 완료 예정 시각</th>
			<td>
				<select name="proc_time1" id="proc_time1" title="시 선택" class="w69 mgr5">
				</select>:
				<select name="proc_time2" id="proc_time2" title="분 선택" class="w69 mgl5">
				</select>
			</td>
		</tr>
		<tr>
			<th scope="row" id="cause_type_th">원인유형</th>
			<td>
				<select name="cause_type" id="cause_type" title="원인유형 선택">
					<option>선택해주세요</option>
				</select>
			</td>
			<th scope="row" id="action_type_th">조치유형</th>
			<td>
				<select name="action_type" id="action_type" title="조치유형 선택" class="w155" onchange="setProcGrade(this.value)">
					<option>선택해주세요</option>
				</select>
			</td>
		</tr>
		<tr id="work_time_tr">
			<th scope="row" id="work_time_th">작업시간(Hour)</th>
			<td>
				<input id="work_time" type="number" name="work_time" value="" class="w100" title="작업시간입력" style="ime-mode:disabled" oninput="if(this.value<0)this.value='';" onchange="chkDateFormat('work_time', this.value)" />
			</td>
			<th scope="row" id="complete_dt_th">처리 완료 일자</th>
			<td>
				<input type="text" name="complete_dt" id="complete_dt" value="" title="처리 완료 일자 입력" class="w120 mgr5" />
			</td>
		</tr>
		
		<tr>
			<th scope="row"><span id="action_content_th">조치 및 처리 의견</span><span style="color:red;">(외부에는 노출되지 않습니다)</span></th>
			<td colspan="5">
				<textarea name="action_content" id="action_content" class="mgb5"></textarea>
				<div class="txt_byte" id="action_content_text">0 / 1300자</div>
			</td>
		</tr>
	</table>
	<!-- write -->
	<table class="sType mgb10" style="border-top:1px solid #ddd;">
		<caption>처리완료 사항 입력</caption>
		<colgroup>
			<col style="width:160px;" />
			<col style="width:auto;" />
		</colgroup>
		<tbody id="wrapFile">
		
		</tbody>
	</table>
	
	<div id="completion_details" style="display:none;">
		<div class="tit_bWrap mgb10">
			<h4>처리완료 상세 사항</h4>
		</div>

		<table class="sType mgb10" id="wrapFile">
			<caption>처리작업 상세사항 입력</caption>
			<colgroup>
				<col style="width: 180px;" />
				<col style="width: 320px;" />
				<col style="width: 160px;" />
				<col style="width: 320px;" />
			</colgroup>
			<tr>
				<th id="proc_gubun_th" scope="row" class="dev_proc">처리구분</th>
				<td><select id="proc_gubun" name="proc_gubun" onChange="setProcGubun(this.value)"
					class="w200"></select></td>
				<th scope="row" id="proc_build_info_th" class="dev_proc">빌드순번</th>
				<td><input type="text"
					id="proc_build_info" name="proc_build_info" value="" title="빌드순번" /></td>
			</tr>
			<tr>
				
				<th scope="row" id="proc_test_info_th" class="dev_proc">개발처리서(테스트케이스)</th>
				<td><input type="text"
					id="proc_test_info" name="proc_test_info" value="" title="개발처리서(테스트케이스) 입력" /></td>
				<th scope="row" class="dev_proc_shape">프로세스정의서</th>
				<td><input type="text" 
					id="proc_process_sp" name="proc_process_sp" value="" title="프로세스정의서 입력" /></td>
			</tr>
			<tr>
				
				<th scope="row" class="dev_proc_shape">화면정의서</th>
				<td><input type="text" 
					id="proc_screen_sp" name="proc_screen_sp" value="" title="화면정의서 입력" /></td>	
				<th scope="row" class="dev_proc_shape">테이블정의서</th>
				<td><input type="text" id="proc_table_sp" name="proc_table_sp"
					value="" title="테이블정의서 입력" /></td>
			</tr>
			<tr>
				<th scope="row" class="dev_proc_shape">기능분해도</th>
				<td><input type="text" 
					id="proc_function_sp" name="proc_function_sp" value="" title="기능분해도 입력" /></td>
				<th scope="row" class="dev_proc_shape">인터페이스정의서</th>
				<td><input type="text" 
					id="proc_interface_sp" name="proc_interface_sp" value="" title="인터페이스정의서 입력"/></td>
			</tr>
		</table>
	</div>
		
	<!--// write -->
	<!-- list -->
	<c:if test="${fn:indexOf(vo.pageType, '	insert') == -1 }">
	<div class="tit_bWrap mgb10">
		<h4 class="floatL">조치 이력</h4>
	</div>
	<table class="hType mgb20">
		<caption>조치 이력</caption>
		<colgroup>
			<col style="width:130px" /> <!-- CMC 조치이력 처리일자 컬럼의 사이즈 수정:	170px to 130px -->
			<col style="width:65px" />
			<col style="width:65px" />
			<col style="width:150px" /> <!-- CMC 처리상태 컬럼의 사이즈 수정:	170px to 150px -->
			<col style="width:40px" />
			<col style="width:auto" />
			<col style="width:90px" />
			<col style="width:140px" /> <!-- CMC 첨부파일 컬럼의 사이즈 수정:	150px to 140px -->
		</colgroup>
		<thead>
			<tr>
				<th scope="col">조치이력 처리일자</th>
				<th scope="col">처리자</th>
				<th scope="col">인수자</th>
				<th scope="col">처리상태</th>
				<th scope="col">중요도</th>
				<th scope="col">작업처리 의견</th>
				<th scope="col"></th>
				<th scope="col">첨부파일</th>
			</tr>
		</thead>
		<tbody id="asHistTbody"></tbody>
	</table>
	</c:if>
	<!--// list -->
	<div class="btn_wrap">
		<div class="floatL">
			<button type="button" class="btn_ico_list" onclick="javascript:goList();"><span>목록</span></button>

		</div>
		<div class="floatR">
			<button type="button" class="btn_ico_confirm" onclick="javascript:goSave(2);"><span>저장 후 머물기</span></button>
			<button type="button" class="btn_ico_confirm" id="savetoanswer" onclick="javascript:goSave(3);"><span>저장 후 답변</span></button>
			<button type="button" class="btn_ico_confirm"  onclick="javascript:goSave(1);"><span>저장</span></button>
			<button type="button" class="btn_ico_cancel"  onclick="javascript:goList();"><span>취소</span></button>
		</div>
	</div>
</div>
</form>

<div id="subTab2" style="display:none;">
	<div id="wrap_star" style="display:none;">
		<div class="tit_bWrap mgb10">
			<h4>고객평가</h4>
		</div>
		<table class="vType_line mgb20">
			<caption>고객평가 내용</caption>
			<colgroup>
				<col style="width:124px;">
				<col style="width:auto;">
			</colgroup>
			<thead>
				<tr>
					<th class="textC">고객평가</th>
					<th class="textC">건의사항</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>
						<input type="radio" id="star1" name="starRate" value="1">
						<input type="radio" id="star2" name="starRate" value="2">
						<input type="radio" id="star3" name="starRate" value="3">
						<input type="radio" id="star4" name="starRate" value="4">
						<input type="radio" id="star5" name="starRate" value="5">
						<span class="wrapStar">
							<label for="star1"></label>
							<label for="star2"></label>
							<label for="star3"></label>
							<label for="star4"></label>
							<label for="star5"></label>
						</span>
					</td>
					<td>
						<textarea name="star_content" id="star_content" class="lineH13 pd5" readonly="readonly" style="height:50px;"></textarea>
					</td>
				</tr>
			</tbody>
		</table>
	</div>		
	<div class="tit_bWrap mgb10">
		<h4>요청내용</h4>
	</div>
	<!-- write -->
	<table class="sType mgb20">
		<caption>접수 정보 입력</caption>
		<colgroup>
		</colgroup>
		<tr>
			<td id="call_content_view">
				<!-- [기초코드] <br>
				청구화면에서 우리 병원에 없는 진료과목록이 나오지 않도록 조치 부탁드립니다. 박정숙 주임. -->
			</td>
		</tr>
	</table>
	<!--// write -->
	<!-- list -->
	<div class="tit_bWrap mgt20 mgb10">
		<h4>답변내용</h4>
	</div>
	<div style="max-height:300px;overflow-y:auto;margin-bottom:20px;" id="awsWrap">
		<table class="hType">
			<caption>답변내용 목록</caption>
			<colgroup>
				<col style="width:130px" />
				<col style="width:200px" />
				<col style="width:auto" />
				<col style="width:140px" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">작성자</th>
					<th scope="col">답변일시</th>
					<th scope="col">답변내용</th>
					<th scope="col"></th>
				</tr>
			</thead>
			<tbody id="awsInfoList"></tbody>
		</table>
	</div>
	
	<!-- 답변작성  -->
	<form name="answerForm" id="answerForm" method="post" enctype="multipart/form-data">
	<input type="hidden" name="as_no" />
	<input type="hidden" name="as_no_link" />
	<input type="hidden" name="seq" />
	<input type="hidden" name="pageType" />
	<table class="sType mgb30">
		<caption>답변내용 목록</caption>
		<colgroup>
			<col style="width:130px" />
		</colgroup>
		<tbody id="aswWrapFile">
			<tr>
				<th scope="col">답변작성</th>
				<td class="pd10" style="border:1px solid #dadada">
					<textarea name="w_content" id="w_content" class="lineH13 pd5"></textarea>
				</td>
			</tr>
		</tbody>
	</table>
	</form>
	<!--// list -->
	<div class="btn_wrap">
		<div class="floatL">
			<button type="button" class="btn_ico_list" onclick="goList();"><span>목록</span></button>
		</div>
		<c:if test="${ vo.pageType ne 'insert' }">
		<div class="floatR">
			<button type="button" class="btn_ico_write dgray" onclick="btnAswProc2();"><span>답변 작성 후 본문 저장</span></button>
			<button type="button" class="btn_ico_write dgray" onclick="btnAswProc('insert');"><span>답변 작성</span></button>
		</div>
		</c:if>
	</div>
</div>



<div class="box_layer layer_sms" style="margin-top:-300px; display:none;" id="div1">
<h1>거래처 정보 조회 검색 결과</h1>
<div class="layer_contents pdt20" style="height:657px;">
	기관명:
	<input type="text" class="w175 mgr10" id="searchKorName" name="searchKorName" title="거래처 정보 검색"  autofocus="autofocus" />
	<button type="button" class="btn_ico_search mgr5" onclick="javascript:custList(1);"><span>검색</span></button>
	<table class="vType_line" style="margin-top: 10px">
		<caption>거래처 정보 목록</caption>
		<colgroup>
			<col style="width:50px;" />
			<col style="width:200px;" />
			<col style="width:80px;" />
			<col style="width:150px;" />
			<col style="width:auto;" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">No</th>
				<th scope="col">기관명</th>
				<th scope="col">대표자</th>
				<th scope="col">사업자번호</th>
				<th scope="col">주소</th>
			</tr>
		</thead>
		<tbody id="custInfoList"></tbody>
	</table>
	<div class="page" id="layer_pagination" style="margin-top: 10px;"></div>
</div>
<button type="button" class="btn_close" onclick="javascript:closeLayer(1);">창 닫기</button>
</div>
<div class="layer_dimmed" style="display:none;" id="div1_dim"></div>


<!-- AS 내역 팝업 -->
<div class="box_layer layer_sms unprocessed-as-popup"
     style="top:40%; left:47% !important; width:800px; height:500px; display:none;"
     id="LinkLayer">

    <h1 class="tit_back">AS 내역</h1>

    <!-- ✅ LinkLayer를 flex 컨테이너로 -->
    <div class="layer_contents" style="height: calc(500px - 45px); display:flex; flex-direction:column;">

        <!-- 검색 영역 -->
        <div class="floatWrap mgb10" style="flex: 0 0 auto;">
            <div class="mgl40" style="float:right">
                <input type="radio" id="val1" name="type1" value="1" checked="checked" />전체AS<span class="mgr5"></span>
                <input type="radio" id="val2" name="type1" value="2" />나의AS<span class="mgr5"></span>
                 | AS신청일
                <input type="text" name="search_start3" id="search_start3" class="w90 mgl5 mgr5" readonly="readonly">
                ~
                <input type="text" class="w90 mgl5 mgr5" name="search_end3" id="search_end3" readonly="readonly">
                <span class="mgr5"> | </span>
                <input type="text" id="search_text" name="search_text" class="w120 mgl5 mgr5" placeholder="문의내용">
                <button type="button" class="btn_line_gray" style="width:60px" onclick="getUnprocessedAsListAdmin()">조회</button>
            </div>
        </div>

        <!-- ✅ 리스트 영역: 남는 공간 전부 차지 + 내부 스크롤 -->
        <div class="unprocess-list-wrap" style="flex: 1 1 auto; min-height:0; padding:0 15px; overflow:auto;">
            <table class="hType mgb10 scroll-table">
                <caption>A/S 접수 목록</caption>
                <colgroup>
                    <col style="width:30px" />
                    <col style="width:90px" />
                    <col style="width:auto" />
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

        <!-- ✅ 버튼 영역: 항상 보이도록 아래 고정 -->
        <div style="flex: 0 0 auto; text-align:right; padding:8px 15px;">
            <button type="button" class="btn_line_gray" style="width:70px" onclick="confirmUnprocessedAs()">확인</button>
            <button type="button" class="btn_line_gray" style="width:70px" onclick="clearUnprocessedAs()">초기화</button>
        </div>

    </div>

    <button type="button" class="btn_close"
            onclick="$('#LinkLayer').hide();$('#div_dim').hide();">창 닫기</button>
</div>

<div class="layer_dimmed" id="div_dim" style="display:none;"></div>


<!-- 처리완료 내역 팝업 -->
<div class="box_layer layer_sms processed-as-popup" style="display:none; height:600px;" id="completeLinkLayer">
    <h1 class="tit_back">처리완료 내역</h1>

    <!-- 내용 영역 -->
    <div class="layer_contents">
        <div class="floatWrap mgb10">
            <div class="mgl40" style="float:right">
            	AS신청일
                <input type="text" name="search_start4" id="search_start4" class="w90 mgl5 mgr5" readonly="readonly">
                ~
                <input type="text"  name="search_end4" id="search_end4" class="w90 mgl5 mgr5" readonly="readonly">
                <span class="mgr5"> | </span>
			    <input type="text" id="search_text" name="search_text"
			           class="w120 mgl5 mgr5" placeholder="조치 및 처리의견">
			    <button type="button" class="btn_line_gray" style="width:60px"
			            onclick="getprocessedAsListAdmin()">조회</button>
            </div>
        </div>

        <!-- 리스트만 스크롤 -->
        <div class="process-list-wrap" style="height: 400px !important;">
            <div id="processedas-box" style="padding:15px;height:300px;overflow:auto;">
			  <table class="hType mgb10 scroll-table">
			    <caption>처리 A/S 목록</caption>
			    <colgroup>
			      <col style="width:110px" />  <!-- 접수번호 -->
			      <col style="width:120px" />  <!-- 원인유형 -->
			      <col style="width:120px" />  <!-- 조치유형 -->
			      <col style="width:auto" />   <!-- 조치 및 처리의견 -->
			    </colgroup>
			    <thead>
			      <tr>
			        <th scope="col">접수번호</th>
			        <th scope="col">원인유형</th>
			        <th scope="col">조치유형</th>
			        <th scope="col">조치 및 처리의견</th>
			      </tr>
			    </thead>
			    <tbody id="processedAsList"></tbody>
			  </table>
			</div>
        </div>
    </div>

    <button type="button" class="btn_close" onclick="$('#completeLinkLayer').hide();$('#div_dim5').hide();">창 닫기</button>
</div>
<div class="layer_dimmed" id="div_dim5" style="display:none;"></div>


<div class="box_layer layer_sms" style="display:none;" id="div2">
<h1>A/S 신청자 이름 검색</h1>
<div class="layer_contents pdt20">
	이름:
	<input type="text" class="w175 mgr10" id="searchEmpName" name="searchEmpName" title="신청자 유형" autofocus="autofocus"/>
	<select  class="cust_emp_type w140 mgr5" onclick="">
		<option value='cust_emp' selected='selected'>등록 계정 유형</option>
		<option value='cust_operation' >거래처 관리 유형</option>
	</select>
	<button type="button" class="btn_ico_search mgr5" onclick="javascript:empList(1);"><span>검색</span></button>
	
	<table class="vType_line" id="cust_emp_tb" style="margin-top: 10px">
		<caption>거래처 정보 목록</caption>
		<colgroup>
			<col style="width:50px;" />
			<col style="width:250;" />
			<col style="width:200;" />
			<col style="width:200;" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">No</th>
				<th scope="col">아이디</th>
				<th scope="col">이름</th>
				<th scope="col">연락처</th>
			</tr>
		</thead>
		<tbody id="empInfoList"></tbody>
	</table>
	
	<table class="vType_line" id="charge_emp_tb" style="margin-top: 10px; display:none" >
		<caption>거래처 정보 목록</caption>
		<colgroup>
			<col style="width:150;" />
			<col style="width:150;" />
			<col style="width:210;" />
			<col style="width:210;" />
			<col style="width:100;" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">담당자구분</th>
				<th scope="col">담당자명</th>
				<th scope="col">연락처1(회사)</th>
				<th scope="col">연락처2(핸드폰)</th>
				<th scope="col">비고</th>
			</tr>
		</thead>
		<tbody id="chargeEmpInfoList"></tbody>
	</table>
	
	
	
	<button type="button" class="btn_line_gray" style="margin-top: 10px" onclick="btnEmpField('layer');">직접입력</button>
	<div class="page" id="layer_pagination" style="margin-top: 10px;"></div>
</div>
<button type="button" class="btn_close" onclick="javascript:closeLayer(2);">창 닫기</button>
</div>
<div class="layer_dimmed" style="display:none;" id="div2_dim"></div>

<!-- 답변작성 -->
<div class="box_layer layer_comment" style="display:none;" id="div3">
	<h1 class="tit_back" id="div3PopTitle">답변 등록</h1>
	<div class="layer_contents">
		<textarea name="w_content" id="p_w_content" class="lineH13 pd5 mgb10"></textarea>
		
		
		<table class="sType mgb20">
			<tbody id="aswAttach_modify_tb">
			
			</tbody>
		</table>
		
		<div class="btn_wrap">
			<div class="floatR">
				<button type="button" class="btn_ico_write dgray w95" onclick="btnAswProc();"><span>등록</span></button>
				<button type="button" class="btn_ico_cancel w95" onclick="btnAswCancel();"><span>취소</span></button>
			</div>
		</div>
		<!--// write -->
	</div>
	<button type="button" class="btn_close" onclick="javascript:closeLayer(3);">창 닫기</button>
</div>
<div class="layer_dimmed" style="display:none;" id="div3_dim"></div>

<!-- 첨부파일 레이어팝업 -->
<div class="box_layer layer_sms" style="display:none;" id="div4">
	<h1>첨부파일 조회</h1>
	<div class="layer_contents pdt20">
		<table class="sType mgb20" style="border-top:1px solid #ddd;">
			<caption>처리완료 사항 입력</caption>
			<colgroup>
				<col style="width:140px;" />
				<col style="width:auto;" />
			</colgroup>
			<tbody id="attach2FileList">
				<!-- <tr>
					<th scope="row">첨부파일1</th>
					<td>
						<input type="text" class="w225" value="파일명.jpg" readonly="readonly">
						<button type="button" class="btn_ico_down mgl5 mgr5"><span>다운로드</span></button>					
					</td 
				</tr> -->
			</tbody>
		</table>
		<div class="btn_wrap">
			<div class="floatR">
				<button type="button" class="btn_ico_confirm" onclick="javascript:closeLayer(4);"><span>확인</span></button>
			</div>
		</div>
	</div>
	<button type="button" class="btn_close" onclick="javascript:closeLayer(4);">창 닫기</button>
</div>
<div class="layer_dimmed" style="display:none;" id="div4_dim"></div>

<div class="box_layer layer_sms" style="display:none;" id="div5">
	<h1>작업처리 의견</h1>
	<div class="layer_contents pdt20" id="wrap_contents">
		<form name="histFrm" id="histFrm" method="post" onsubmit="return false;">
			<input type="hidden" name="as_no" id="as_no" value="${ vo.as_no }"/>
			<input type="hidden" name="seq" id="seq" value=""/>
			<input type="hidden" name="file_seq" id="file_seq" value=""/>
			<input type="hidden" name="pageType" id="pageType" value=""/>
			<textarea id="show_hist_contents" name="action_content" class="mgb10 pd10" style="height:268px;"></textarea>
			<div class="btn_wrap">
			    <div class="floatR">
			    	<button type="button" id="updateHistContent" class="btn_ico_confirm dgray" onclick="javascript:updateHisContent();"><span>저장</span></button>
			    	<button type="button" class="btn_ico_cancel dgray" onclick="javascript:closeLayer(5);"><span>닫기</span></button>    
			    </div>
			</div>
		</form>
	</div>
	<button type="button" class="btn_close" onclick="javascript:closeLayer(5);">창 닫기</button>
</div>
<div class="layer_dimmed" style="display:none;" id="div5_dim"></div>

<!-- 문의유형 기준표 -->
<div class="box_layer layer_sms" style="display: none; height: 580px;"
	id="div7">
	<h1>문의유형 기준표</h1>
	<div class="layer_contents pdt20" style="height: 560px;">
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



<!-- 중요도 기준표 -->
<div class="box_layer layer_sms" style="display: none; height: 335px;"
	id="div8">
	<h1>중요도 기준표</h1>
	<div class="layer_contents pdt20" style="height: 450px;">
		<span style="font-weight:bold;margin-bottom:5px;color:red;">※ 중요도는 원인유형/조치유형과는 별개로 처리담당자가 인식하기 위해 산정된 등급표</span>
		<table class="stats_hType mgb10 scroll-table">
			<caption>중요도 기준표</caption>
			<colgroup>
				<col style="width: 40px;" />
				<col style="width: 60px;" />
				<col style="width: 90px;" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">중요도</th>
					<th scope="col">구분</th>
					<th scope="col">비고</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>S</td>
					<td>긴급</td>
					<td>당일처리</td>
				</tr>
				<tr>
					<td>A</td>
					<td>중요</td>
					<td>빠른시일내 처리</td>
				</tr>
				<tr>
					<td>B</td>
					<td>보통</td>
					<td>자동배정-보통</td>
				</tr>
				<tr>
					<td>C</td>
					<td>안내필요</td>
					<td>개별안내</td>
				</tr>
				<tr>
					<td>D</td>
					<td>단순문의</td>
					<td>답글안내</td>
				</tr>
			</tbody>
		</table>
	</div>
	<button type="button" class="btn_close"
		onclick="javascript:closeLayer(8);">창 닫기</button>
</div>
<div class="layer_dimmed" style="display: none;" id="div8_dim"></div>