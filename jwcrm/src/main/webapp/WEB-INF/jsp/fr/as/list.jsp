<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="egovframework.com.comm.util.DateTimeUtil"%>
<jsp:include page="/WEB-INF/jsp/fr/common/chatbot.jsp" />
<script type="text/javascript">

	var fileCnt = 1 ; 
	var flag = true ; 		/**	상세 수정 가능 여부	*/
	var delAttach1 = "" ; 	/**	첨부파일 삭제			*/
	var aswfile_cnt = 1; /*  첨부파일 카운트 */
	var delAttach3 = '';
	var a = '' ; 
	var b = '' ; 
	var c = '' ; 
	var d = '' ;
	var pageNum = '';
	
	var chatbotWindow = null;

	$(document).ready(function(){
		$("#search_start" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$("#search_end" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		commonCode.getCodeList('AS' , 'CD01' , 'search_type3') ;	//처리상태
		commonCode.getCodeList('AS' , 'CD03' , 'search_type4') ;	//시스템유형
		commonCode.getCodeList('AS' , 'CD07' , 'search_type8') ;	//문의유형
		$('#search_type5').append(commonCode.defaultOption);	
		
		commonCode.getCodeList('AS' , 'CD03' , 'service_cate') ;
		commonCode.getCodeList('AS' , 'CD07' , 'request_type') ;
		$('#inquiry_type').append(commonCode.defaultOption);	
		
		$('#call_content').keyup(function (e){
	          var content = $(this).val();
	          if(content.length >= 1000){
	        	  content = content.substring(0 , 1000) ;
	        	  $(this).val(content)
	          }
	          
	          $('#call_content_text').html(content.length + '/ 1000 자');
	     });
		
		goList(1) ;
		
		var as_no = '${vo.as_no}';
		
		if (as_no != ''){
			goView(as_no);
		}
		
		
		
	}) ;
	
	function goList(page){
		
		closeLayer('1');
		closeLayer('2');
		
		var f = document.listFrm ; 
		
		f.page.value = page ;
		pageNum = page ;
		
		common.ajaxCall($('form[name=listFrm]').serialize(), '/fr/as/getAsList.do', 'setAsList') ;
	}
	
	function setAsList(data){
		// listTbody
		// pagination
		
		$('#listTbody').empty() ; 
		$("#pagination").empty();
		
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		var vo = typeof data.vo != "undefined" ? data.vo : null ; 
		
		if(resultList != null && resultList.length > 0){
			
			var toggle = true;
			var prevAsNo = "0";
			
			var str = '' ; 
			
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ;
				
				//처리예정일 날짜를 형식에 맞게 셋팅
				var vProcDt = "-";   
				if (common.nvl(datas.proc_dt, '').length == 8){
					vProcDt = makeDate(datas.proc_dt,"-");
		 		}
				
				console.log(datas);
				
				var chkAsNo = common.nvl(datas.cn_as_no, '') != '' ? datas.cn_as_no: datas.as_no; 
				if (prevAsNo != chkAsNo){
					prevAsNo = chkAsNo;
					toggle = toggle ? false : true;
				}
				
				str += '<tr onclick="goView(\''+common.nvl(datas.as_no , '')+'\');" style="cursor:pointer;background-color:'+(toggle ? "#f8fafb" : "#ffffff")+'"> ' ;
				str += '	<td>'+common.nvl(datas.rnum, '')+'</td> ' ;
				
				//하위작업이 있으면!
				if(common.nvl(datas.cn_as_no, '') != ""){
					str += '	<td>'+common.nvl(datas.cn_as_no, '-')+'</td> ' ;	
					str += '	<td>'+common.nvl(datas.as_no, '')+'</td> ' ;
				}else{ //하위작업이 없으면!
					
					str += '	<td>'+common.nvl(datas.as_no, '')+'</td> ' ;
					str += '	<td>'+common.nvl(datas.cn_as_no, '-')+'</td> ' ;	
				}
				
				
				str += '	<td>'+common.nvl(datas.proc_status_nm, '-')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.request_type_nm, '-')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.service_cate_nm, '-')+'/'+common.nvl(datas.inquiry_type_nm, '-')+'</td> ' ;
				str += '	<td class="textL" style="padding-left:2px" title="'+common.nvl(datas.call_content, '-')+'">'+datas.call_content.substr(0 , 15)+'</td> ' ; //요청내용
				str += '	<td>'+common.nvl(datas.apply_nm, '-')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.emp_nm, '-')+'</td> ' ;
				str += '		<td>'+vProcDt+'</td> ' ;
				
				if( common.nvl(datas.proc_status, '') == "C005" ){
					str += '		<td>'+common.nvl(datas.complete_dt, '-')+'</td> ' ;
				}else{
					str += '		<td>-</td> ' ;
				}
				
				if(common.nvl(datas.cn_as_no, '') != ""){
					str += '	<td>-</td> ' ;	
				}else{
					
					var showFlag = false ; 
					
					if(common.nvl(datas.proc_status , '') == "C001" || common.nvl(datas.proc_status , '') == "C002") showFlag = true ;
					
					if(showFlag){
						if(common.nvl(datas.cn_count , '') != "0") showFlag = false ; 
					}
					
					if(showFlag) str += '	<td onclick=\'event.cancelBubble=true;\'><button class="btn_line_blue" onclick="javascript:registStatus(\''+common.nvl(datas.as_no)+'\');">철회</button></td> ' ;
					else str += '	<td onclick=\'event.cancelBubble=true;\'><button class="btn_line_blue disabled">철회</button></td> ' ;
				}
				
				if(common.nvl(datas.star_state , '') != ''){
					var starCnt = common.nvl(datas.star_state, '');
					var starText = '';
					if (starCnt == 1) starText = '★☆☆☆☆';
					else if (starCnt == 2) starText = '★★☆☆☆';
					else if (starCnt == 3) starText = '★★★☆☆';
					else if (starCnt == 4) starText = '★★★★☆';
					else if (starCnt == 5) starText = '★★★★★';
					else starText = '☆☆☆☆☆';
					str += '	<td class="colorRed" onclick=\'event.cancelBubble=true;\'>'+starText+'<button class="btn_line_blue" onclick="javascript:goViewStar(\''+common.nvl(datas.as_no, '')+'\');">[보기]</button></td> ' ;
				}else{
					if(common.nvl(datas.cn_as_no, '') == "" && common.nvl(datas.proc_status, '') == "C005"){
						str += '	<td onclick=\'event.cancelBubble=true;\'><button class="btn_line_blue" onclick="javascript:goInsertStar(\''+common.nvl(datas.as_no, '')+'\');">확인</button></td> ' ;	
					}else{
						str += '	<td>-</td> ' ;
					}
				}
				
				str += '	<td>'+common.nvl(datas.star_state_date, '-')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.emp_name, '-')+'</td> ' ;
				str += '</tr> ' ;
				
			}
			
			$('#listTbody').append(str) ; 
			$("#pagination").html(vo.json_paging);
		}else{
			commonTable.notData(12 , '조회된 정보가 없습니다.' , 'listTbody') ; 
		}
		
	}
	
	function setService_cate(thisObj){
		$('#search_type5').empty() ; 
		
		if(thisObj != ""){
			commonCode.getCodeList('AS' , thisObj , 'search_type5') ;
		}else{
			$('#search_type5').append(commonCode.defaultOption);	
		}
	}
	
	/**	고객 평점 조회 레이어 호출	*/
	function goViewStar(as_no){
		console.log(as_no);
		var f = document.procFrm ; 
		f.as_no.value = as_no ;
		
		$('#div1').show() ; 
		$('#div_dim').show() ; 
		
		common.ajaxCall($('form[name=procFrm]').serialize() , '/fr/as/getStarInfo.do', 'makeStarInfo') ;
	}
	
	/**	고객 평점 등록 레이어 호출	*/
	function goInsertStar(as_no){
		var f = document.procFrm ; 
		f.as_no.value = as_no ; 
		$('#div1').show() ; 
		$('#div_dim').show() ; 
	}
	
	/**	상세 정보 조회	*/
	function goView(as_no){
		
		var f = document.viewFrm ; 
		
		f.as_no.value = as_no ; 
		
		common.ajaxCall($('form[name=viewFrm]').serialize() , '/fr/as/getAsInfo.do', 'makeView') ;
	}
	
	/**	철회 처리	*/
	function registStatus(as_no){
		if(!confirm('철회처리 하시겠습니까?')) return ; 
		var datas = {'as_no' 	: as_no , 	'pageType' : 'changeStatus'} ; 
		common.ajaxCall(datas , '/fr/as/registAs.do', 'registResult') ;
	}
	
	function registResult(data){
		var msg = "처리도중 오류가 발생했습니다." ; 
		var returnCode = typeof data.returnCode != "undefined" ? data.returnCode : "888" ; 
		if(returnCode == "000") msg = "정상처리 되었습니다." ;
		alert(msg) ; 
		if(returnCode == "000") goList(pageNum) ; 
	}
	
	
	
	
	function closeLayer(gbn){
		$('#div' + gbn).hide() ; 
		$('#div_dim').hide() ;
		if(gbn == "1"){
			for(var i = 1 ; i <= 5 ; i++){
				if($('#star' + i).is(":checked")) $('#star' + i).prop('checked' , false) ; 
			}
			$('#star_content').val('') ; 
		}else if(gbn == "2"){
			delAttach1 = "" ; 
			fileCnt = 1 ; 
		}
	}
	
	function saveLayer(gbn){
		var datas = null ; 
		
		if(gbn == "1"){
			
			var frm = document.procFrm;
			if (frm.starRate.value == '') {
				alert('고객평가 별점을 선택해주세요');
				return;
			}
			
			if(!confirm('검수확인 하시겠습니까?')) return ;
			
			common.ajaxCall($('form[name=procFrm]').serialize(), '/fr/as/registAs.do', 'registResult') ;
			
		}
	}
	
	function makeStarInfo(data){
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null ; 
		
		if(resultVO != null){
			if(common.nvl(resultVO.star_state , '0') != '0') $('#star' + common.nvl(resultVO.star_state , '0')).prop('checked' , true) ; 
			$('#star_content').val(common.nvl(resultVO.star_content , '')) ; 
		}
	}
	
	function makeCustInfo(data){
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null ; 
		if(resultVO != null){
			a = common.nvl(resultVO.his_basic_code, '') ;		/**	기초	*/  
			b = common.nvl(resultVO.his_treat_code, '') ;		/**	진료	*/ 
			c = common.nvl(resultVO.his_work_code, '') ;		/**	업무	*/ 
			d = common.nvl(resultVO.his_claim_code, '') ;	/**	청구	*/ 
		}
	}
	
	function makeView(data){
		$('#div2').show() ;
		$('#div_dim').show() ; 
		
		$('#aswWrapFile').empty();
		$('#w_content').empty();
		
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null ; 
		var attachList = typeof data.attachList != "undefined" ? data.attachList : null ; 
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		if(resultVO != null){
			// stateC001
			
			var proc_status = common.nvl(resultVO.proc_status, '') ;
			
			if(proc_status == "C001") flag = true ; 
			else flag = false ; 
			
			
			if(proc_status == "C007") proc_status = "C002" ; 
			for(var i = 1 ; i <= 5 ; i++){
				if("C00" + i == proc_status){
					if(!$('#stateC00' + i).hasClass("current")) $('#stateC00' + i).addClass("current") ; 
				}else{
					if($('#stateC00' + i).hasClass("current")) $('#stateC00' + i).removeClass("current") ;
				}
			}
			if(flag){
				$('#request_type').prop('disabled' , true)	 ; 			
				if(!$('#request_type').hasClass('write_gray')) $('#request_type').addClass('write_gray') ;
				
				$('#service_cate').prop('disabled' , true)	 ; 			
				if(!$('#service_cate').hasClass('write_gray')) $('#service_cate').addClass('write_gray') ; 
				
				$('#version_info').prop('disabled' , true)	 ; 			
				if(!$('#version_info').hasClass('write_gray')) $('#version_info').addClass('write_gray') ;
				
				$('#inquiry_type').prop('disabled' , true)	 ; 			
				if(!$('#inquiry_type').hasClass('write_gray')) $('#inquiry_type').addClass('write_gray') ;
				
				$('#apply_tel').prop('disabled' , true)	 ; 			
				if(!$('#apply_tel').hasClass('write_gray')) $('#apply_tel').addClass('write_gray') ;
				
				$('#send_sms1').prop('disabled' , true)	 ; 			
				if(!$('#send_sms1').hasClass('write_gray')) $('#send_sms1').addClass('write_gray') ;
				
				$('#send_sms2').prop('disabled' , true)	 ; 			
				if(!$('#send_sms2').hasClass('write_gray')) $('#send_sms2').addClass('write_gray') ;
				
				$('#call_content').prop('readonly' , true)	 ;
				
				$('#saveBtn').hide() ; 
			}else{
				$('#request_type').prop('disabled' , true)	 ; 			
				if(!$('#request_type').hasClass('write_gray')) $('#request_type').addClass('write_gray') ;
				
				$('#service_cate').prop('disabled' , true)	 ; 			
				if(!$('#service_cate').hasClass('write_gray')) $('#service_cate').addClass('write_gray') ; 
				
				$('#version_info').prop('disabled' , true)	 ; 			
				if(!$('#version_info').hasClass('write_gray')) $('#version_info').addClass('write_gray') ;
				
				$('#inquiry_type').prop('disabled' , true)	 ; 			
				if(!$('#inquiry_type').hasClass('write_gray')) $('#inquiry_type').addClass('write_gray') ;
				
				$('#apply_tel').prop('disabled' , true)	 ; 			
				if(!$('#apply_tel').hasClass('write_gray')) $('#apply_tel').addClass('write_gray') ;
				
				$('#send_sms1').prop('disabled' , true)	 ; 			
				if(!$('#send_sms1').hasClass('write_gray')) $('#send_sms1').addClass('write_gray') ;
				
				$('#send_sms2').prop('disabled' , true)	 ; 			
				if(!$('#send_sms2').hasClass('write_gray')) $('#send_sms2').addClass('write_gray') ;
				
				$('#call_content').prop('readonly' , true)	 ;
				
				$('#saveBtn').hide() ; 
			}
			
			
			var datas = {'cust_code' : '${ frUserInfo.cust_code}' , 'is_page_gbn' : 'fr'} ; 
			common.ajaxCall(datas , '/ad/member/getCustInfo2.do', 'makeCustInfo') ;
			
			$('#proc_status').val(common.nvl(resultVO.proc_status, "")) ; 
			$('#request_type').val(common.nvl(resultVO.request_type, "")) ; 
			
			
			if(common.nvl(resultVO.val2, "") == 'Y' || common.nvl(resultVO.val2, "") == '') {
				$('#system_code').show();
				$('#service_cate').val(common.nvl(resultVO.service_cate, "")) ; 
				
				changeService(common.nvl(resultVO.service_cate, "")) ; 
				
				$('#version_info').val(common.nvl(resultVO.version_info, "")) ; 
				$('#inquiry_type').val(common.nvl(resultVO.inquiry_type, "")) ;
			}else{
				$('#system_code').hide();
			}
			
			
			$('#apply_tel').val(common.nvl((resultVO.apply_tel).replaceAll("-", ""), "")) ; 
			$('#call_content').val(common.nvl(resultVO.call_content, "")) ; 
			
			if(resultVO.send_sms == 'Y') {
				$('input#send_sms1').prop('checked', true);
			} else {
				$('input#send_sms2').prop('checked', true);
			}
			
			$('#call_content_text').html(common.nvl(resultVO.call_content, "").length+ '/ 1000 자');
			$('#call_content_str').text(common.nvl(resultVO.call_content, "")) ; 
			$('#file_seq').val(common.nvl(resultVO.file_seq, "")) ; 
			
			$('#fileList').empty();
			if(attachList != null && attachList.length > 0){
				
				for(var i = 0 ; i < attachList.length ; i++){
					
					var datas = attachList[i] ; 
					
					var str = '' ; 
					
					str += '<div id="multiFile'+common.nvl(datas.attach_ord, '0')+'">' ; 
					if(flag){
						str += '		<input type="file" id="uploadFile_'+common.nvl(datas.attach_ord, '0')+'" name="uploadFile_'+common.nvl(datas.attach_ord, '0')+'" style="width:218px;" />' ; 
						if(fileCnt > 1) 	str += '	<button class="btn_minus mgl5" onclick="deleteFile('+common.nvl(datas.attach_ord, '0')+');"></button>';
						else 						str += '	<button class="btn_plus mgl5" onclick="addMultiFile();"></button>';	
						str += '<input type="text" class="w100 mgr5" readonly="readonly" value="'+common.nvl(datas.attach_ori_nm, '')+'"><button type="button" class="btn_ico_file_down mgr5" onclick="fileDown('+common.nvl(datas.attach_seq, '')+' , '+common.nvl(datas.attach_ord, '')+');"><span>다운로드</span></button><button type="button" class="btn_ico_delete" onclick="deleteFile('+common.nvl(datas.attach_ord, '0')+');"><span>삭제</span>';
					}else{
						str += '<input type="text" class="w100 mgr5" readonly="readonly" value="'+common.nvl(datas.attach_ori_nm, '')+'"><button type="button" class="btn_ico_file_down mgr5" onclick="fileDown('+common.nvl(datas.attach_seq, '')+' , '+common.nvl(datas.attach_ord, '')+');"><span>다운로드</span></button>';
					}
					str += '</div>' ;
					
					$('#fileList').append(str) ; 
					
					fileCnt = Number(common.nvl(datas.attach_ord, '0')) + 1;
				}
			}else{
				if(flag){addMultiFile() };
			}
			
			$('#awsInfoList').empty();
			
			var str = '' ; 
			if(resultList != null && resultList.length > 0){
				for(var i = 0 ; i < resultList.length ; i++){
					var datas = resultList[i] ; 
					var attachData = datas.amap;
					str += '<tr> ' ;
					str += '	<td>'+common.nvl(datas.emp_nm)+'</td> ' ;
					str += '	<td>'+common.nvl(datas.w_date)+'</td> ' ;
					str += '	<td class="textL">'+common.nvl(datas.w_content) + '<br>';
					
					if( JSON.stringify(attachData) != '{}'){
						if(attachData.attachList.length > 0 ){
							for(var j = 0; j < attachData.attachList.length; j++ ){
								str += '<button type="button" class="btn_ico_file_down mgr5 mgb5" onclick="javascript:fileDown(\''+common.nvl(attachData.attachList[j].attach_seq, '')+'\' , \''+common.nvl(attachData.attachList[j].attach_ord, '')+'\');"><span>다운로드</span></button>';	
								str += '<span>' + common.nvl(attachData.attachList[j].attach_ori_nm, '') + '</span>'; 
								str += '<br>'
							}
						}
					}
					str += '</tr> ' ;
				}
			}
			
			$('#awsInfoList').append(str) ; 
			
			
			
			<%-- str += '<tr> ' ;
			str += '	<td>${ frUserInfo.emp_name}</td> ' ;
			str += '	<td><%= DateTimeUtil.getDateText(DateTimeUtil.getDate()) + " " + DateTimeUtil.getTimeText(DateTimeUtil.getTime()) %></td> ' ;
			str += '	<td class="textL"> ' ;
			str += '		<textarea class="mgb5" name="w_content" id="w_content"></textarea> ' ;
			str += '		<span class="floatR"><button class="btn_line_blue mgr5" onclick="javascript:goSaveContent();">저장</button><button class="btn_line_gray small" onclick="javascript:goCelarContent();">취소</button></span> ' ;
			str += '	</td> ' ;
			str += '</tr> ' ;
			
			$('#awsInfoList').append(str) ; --%> 
			

			
			
		}else{
			alert('조회된 정보가 없습니다.') ; 
			clearLayer('2') ; 
		}
		
		//답변내역 - 첨부파일row 1개 셋팅
		$('#aswWrapFile').children( 'tr:not(:first)' ).remove();
		aswfile_cnt = 1;
		addAswFile();
	}
	
	function subTab(gubun){
		for(var i = 1 ;i <= 2 ; i++){
			if(Number(gubun) == i){
				if(!$("#li" + i).hasClass('active')) $('#li' + i).addClass('active') ;
				$('#subTab' + i).show() ; 
			}else{
				if($("#li" + i).hasClass('active')) $('#li' + i).removeClass('active') ;
				$('#subTab' + i).hide() ; 
			}
		}
	}
	
	function changeService(thisObj){
		$('#inquiry_type').empty() ; 
		$('#version_info').val('') ; 
		$('#version_info_str').val('') ;
		
		if(thisObj != ""){
			commonCode.getCodeList('AS' , thisObj , 'inquiry_type') ;
			
			if(thisObj == "P002"){ $('#version_info').val(a) ; if(a != "") $('#version_info_str').val(commonCode.getCodeNm('CUST' , 'CD04' , a));}
			else if(thisObj == "P003"){ $('#version_info').val(b) ; if(b != "") $('#version_info_str').val(commonCode.getCodeNm('CUST' , 'CD05' , b));}
			else if(thisObj == "P004"){ $('#version_info').val(c) ; if(c != "") $('#version_info_str').val(commonCode.getCodeNm('CUST' , 'CD06' , c));}
			else if(thisObj == "P005"){ $('#version_info').val(d) ; if(d != "") $('#version_info_str').val(commonCode.getCodeNm('CUST' , 'CD07' , d));}
		}else{
			$('#inquiry_type').append(commonCode.defaultOption);	
		}
	}
	
	function addMultiFile(){
		var str = '' ; 
		
		str += '<div id="multiFile'+fileCnt+'">' ; 
		str += '		<input type="file" id="uploadFile_'+fileCnt+'" name="uploadFile_'+fileCnt+'">' ; 
		
		if(flag){
			if(fileCnt > 1) 	str += '	<button class="btn_minus mgl5" onclick="deleteFile('+fileCnt+');"></button>';
			else 						str += '	<button class="btn_plus mgl5" onclick="addMultiFile();"></button>';	
		}
		
		str += '</div>' ; 
		
		$('#fileList').append(str) ; 
		fileCnt++ ; 
	}
	
	function deleteFile(cnt){
		$('#multiFile'+cnt).remove();
		
		if(delAttach1 == "") delAttach1 = cnt ; 
		else delAttach1 = delAttach1 + "@" + cnt ;
	}
	
	function goSave(){
		
		var f = document.viewFrm ; 
		
		if (common.isEmpty($('#request_type').val())) {
			alert('문의유형을 선택하세요.'); 		$('#request_type').focus(); 		return;
		}
		
		if (common.isEmpty($('#service_cate').val())) {
			alert('시스템(대)를 선택하세요.'); 		$('#service_cate').focus(); 		return;
		}
		
		if (common.isEmpty($('#inquiry_type').val())) {
			alert('시스템(소)를 선택하세요.'); 		$('#inquiry_type').focus();			return;
		}	
		
		if (common.isEmpty($('#send_sms1').val()) && common.isEmpty($('#send_sms2').val())) {
			alert('SMS수신동의여부를 선택하세요.');
			$('#send_sms').focus(); 
			return;
		}
		
		if($("#send_sms1").is(":checked")) {
			if(common.isEmpty($('#apply_tel').val())){
				alert("SMS 수신 전화번호를 입력해 주세요.") ;
				$('#apply_tel').focus();
				return ;
			}
		} else if($("#send_sms2").is(":checked")) {
		} else {
			alert("SMS수신동의여부를 선택해주세요.");
			$('#send_sms1').focus();
			return;
		}
		
		if(confirm('저장 하시겠습니까?')){
			
			f.delAttach1.value = delAttach1 ;
			f.pageType.value = "layerUpdate" ; 
			f.target = 'hiddenFrame' ; 
			f.action = '/fr/as/procLayer.do' ; 
			f.submit() ; 	
		}
		
	}
	
	function aswProcReturn(gbn,msg){
		alert(msg) ;
		
		if(gbn == "success"){goView(document.viewFrm.as_no.value); $('#w_content').val('');}
	}
	
	function procReturn(gbn , msg){
		alert(msg) ;
		
		if(gbn == "success") goList(1) ; 
	} 
	
	function goCelarContent(){
		$('#w_content').val('') ; 
	}
	
	function goSaveContent(){
		
		if(common.isEmpty($('#w_content').val())){
			alert("답변 내용을 등록해 주세요.") ; return ; 
		}
		
		if(!confirm('답변 내용을 등록하시겠습니까?')) return ;
		
		var f = document.aswFrm;
		f.w_content.value = $('#w_content').val();
		f.as_no.value = document.viewFrm.as_no.value;
		
		f.pageType.value = "insertContent";
		
		
		f.method="post";
		f.target = 'hiddenFrame' ; 
		f.action="/fr/as/aswRegistAs.do";
		f.submit();
		
		
	}
	
	
	
	
	
////답변-첨부파일/////////////////////////////////////////////////////////////////////////////////
	
	function addAswFile() {
	console.log(aswfile_cnt);
		var str = '' ; 
		str += '<div id="asw_multiFile'+aswfile_cnt+'">' ; 
		str += '<input type="file" id="asw_uploadFile_'+aswfile_cnt+'" name="asw_uploadFile_'+aswfile_cnt+'">' ; 
		
		if(aswfile_cnt > 1) 	str += '	<button class="btn_minus mgl5" onclick="delAswFile('+aswfile_cnt+');"></button>';
		else 						str += '	<button class="btn_plus mgl5" onclick="addAswFile();"></button>';	
		
		str += '</div>' ; 
		$('#aswWrapFile').append(str) ; 
		aswfile_cnt++ ; 
		
	}

	function delAswFile(cnt) {
		$('#asw_multiFile'+cnt).remove();
	}

/////////////////////////////////////////////////////////////////////////////////////////////////////	
</script>
<div id="jw_contents">
	<div class="tit_wrap">
		<h2 class="tit_ico_as">A/S 신청<span class="txt_tit_right">제품 A/S신청이나 이용 중 궁금하신 사항을 알려주세요.</span></h2>
		<div class="location">
			<a href="/fr/main/list.do" class="home">Home</a>
			<a href="/fr/as/list.do" class="depth"><span class="here">A/S관리</span></a>
		</div>
	</div>

	<ul class="tab_back mgb30">
		<li><a href="/fr/as/form.do">A/S 신청등록</a></li><!-- 활성시 current -->
		<li class="active"><a href="/fr/as/list.do">신청 등록 현황</a></li>
	</ul>

	<div class="tit_sWrap">
		<h3 class="tit_bold_gray">문의 서비스 정보</h3>
	</div>
	
	<form name="listFrm" id="listFrm" method="post" onsubmit="return false;">
		<input type="hidden" name="page" id="page" value="${ vo.page }">
		<table class="hType_line mgb30">
			<caption>A/S 신청 제품 정보 입력</caption>
			<colgroup>
				<col style="width:57px;" />
				<col style="width:280px;" />
				<col style="width:57px;" />
				<col style="width:90px;" />
				<col style="width:57px;" />
				<col style="width:90px;" />
				<col style="width:66px;" />
				<col style="width:260px;" />
			</colgroup>
			<tr>
				<th scope="row">신청기간</th>
				<td>
					<input type="checkbox" name="search_type1" id="search_type1" value ="Y">
					<input type="text" name="search_start" id="search_start" class="w90 mgl5 mgr5" readonly>~<input type="text" class="w90 mgl5 mgr5" name="search_end" id="search_end" readonly>
				</td>
				<th scope="row">처리상태</th>
				<td>
					<select title="처리완료 선택" name="search_type3" id="search_type3"></select>
				</td>
				<th scope="row">문의유형</th>
				<td>
					<select title="문의유형 선택" name="search_type8" id="search_type8"></select>
				</td>
				<th scope="row">시스템유형</th>
				<td>
					<select title="시스템(대) 선택" class="w115 mgr5" name="search_type4" id="search_type4" onchange="setService_cate(this.value);"></select>
					<select title="시스템(소) 선택" class="w115 mgr5" name="search_type5" id="search_type5"></select>
				</td>
			</tr>
			<tr>
				<th scope="row">요청내용</th>
				<td>
					<input type="text" name="search_text" id="search_text" title="요청내용 입력">
				</td>
				<th scope="row">검수완료</th>
				<td>
					<input type="checkbox" name="search_type2" id="search_type2" value ="Y">
				</td>
				<th scope="row">신청자</th>
				<td>
					<input type="text"  name="search_type6" id="search_type6" title="신청자 이름 입력">
				</td>
				<th scope="row">접수번호</th>
				<td>
					<input type="text" class="w155"  name="search_type7" id="search_type7" title="신청자 이름 입력">
					<button class="btn_ico_search dblue small" onclick="javascript:goList(1);"><span>검색</span></button>
				</td>
			</tr>
			
		</table>
	</form>
<!--// A/S 신청 제품 정보 -->
<div style="overflow-x:auto;">
<table class="hType mgb10 scroll-table">
	<colgroup>
		<col style="width:35px;">
		<col style="width:81px;">
		<col style="width:81px;">
		<col style="width:100px;">
		<col style="width:100px;">
		<col style="width:120px;">
		<col style="width:150px;">
		<col style="width:80px;">
		<col style="width:80px;"> <!--처리담당자-->
		<col style="width:80px;">
		<col style="width:80px;">
		<col style="width:60px;">
		<col style="width:80px;">
		<col style="width:80px;">
		<col style="width:80px;">
				
	</colgroup>
	<thead>
		<tr>
			<th>No</th>
			<!-- <th>신청일</th> -->
			<th>접수번호</th>
			<th>하위작업</th>
			<th>처리상태</th>
			<th>문의유형</th>
			<th>시스템유형</th>
			<th>요청내용</th>
			<th>신청자</th>
			<th>처리 담당자</th>
			<th>처리예정일</th>
			<th>처리완료일</th>
			<th>요청철회</th>
			<th>검수확인</th>
			<th>검수일</th>
			<th>검수자</th>
		</tr>
	</thead>
	<tbody id="listTbody"></tbody>
</table>
</div>
<div class="page" id="pagination"></div>
<!--// write -->


</div>

<div class="box_layer layer_rating" id="div1" style="display:none;">
	<h1 class="tit_back">검수확인/고객평가</h1>
	<div class="layer_contents">
		<div class="comment mgb20">
			요청하신 서비스는 잘 받으셨나요?<br>
			미흡한 부분이 있었다면 보완하여 고객님의 만족도를 높이는 데 최선을 다하겠습니다. 감사합니다.
		</div>
		<form name="procFrm" id="procFrm" method="post" onsubmit="return false;">
			<input type="hidden" name="as_no" id="as_no" value=""/>
			<input type="hidden" name="pageType" id="pageType" value="starUpdate"/>
			<table class="hType_line mgb20">
				<caption>고객평가 내용</caption>
				<colgroup>
					<col style="width:124px;">
					<col style="width:auto;">
				</colgroup>
				<thead>
					<tr>
						<th class="textC"><span class="request mgl5">필수 입력</span>고객평가</th>
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
						<td><textarea class="lineH13 pd5" style="height:50px;" name="star_content" id="star_content"></textarea></td>
					</tr>
				</tbody>
			</table>
		</form>
		<div class="btn_wrap">
			<div class="floatR">
				<button type="button" class="btn_ico_save w95" onclick="javascript:saveLayer('1');"><span>검수</span></button>
				<button type="button" class="btn_ico_cancel w95" onclick="javascript:closeLayer('1');"><span>취소</span></button>
			</div>
		</div>
		<!--// write -->
	</div>
	<button type="button" class="btn_close" onclick="javascript:closeLayer('1');">창 닫기</button>
</div>

<div class="box_layer layer_order_list" id="div2" style="display:none;">
<h1 class="tit_back">A/S 신청내역 상세보기</h1>
<div class="layer_contents">

	<form name="viewFrm" id="viewFrm" method="post" onsubmit="return false;" enctype="multipart/form-data" >
		<input type="hidden" name="as_no" id="as_no" value=""/>
		<input type="hidden" name="proc_status" id="proc_status" value=""/>
		<input type="hidden" name="delAttach1" id="delAttach1" value=""/>
		<input type="hidden" name="pageType" id="pageType" value=""/>
		<input type="hidden" name="file_seq" id="file_seq" value=""/>

		<!-- tab -->
		<ul class="tab_line list2 mgb20">
			<li id="li1" class="active"><a href="javascript:subTab('1');">처리 정보</a></li><!-- 활성시 current -->
			<li id="li2" ><a href="javascript:subTab('2');">답변내역</a></li>
		</ul>
		<!--// tab -->
		<div class="tit_sWrap">
			<h4 class="tit_bold_gray">접수 처리 단계</h4>
			<a href="#" class="tit_depth mgl10 mgt5 valignT">상세처리내역 조회</a>
		</div>
		<!-- process -->
		
		<div id="subTab1">
		
			<!-- process -->
			<ul class="pro_arrow list3 mgb50">
				<li id="stateC001" class="current">접수 및 담당자자동배정</li>
				<li id="stateC004">처리중</li>
				<li id="stateC005">처리완료</li>
			</ul>
			
			<!--
			<ul class="pro_arrow list5 mgb15">
				<li id="stateC001" class="current">접수</li>
				<li id="stateC002">담당자(재)배정중</li>
				<li id="stateC003">배정완료</li>
				<li id="stateC004">처리중</li>
				<li id="stateC005">처리완료</li>
			</ul>
			-->

			<div class="tit_sWrap" style="margin-top: 10px;">
				<h4 class="tit_bold_gray">제품 정보</h4>
			</div>
			
			<table class="vType_line mgb10">
				<caption>기본 정보 목록</caption>
				<colgroup>
					<col style="width:150px;" />
					<col style="width:180px;" />
					<col style="width:120px;" />
					<col style="width:170px;" />
				</colgroup>
				<tr>
					<th scope="row">문의유형<span class="request mgl5">필수 입력</span></th>
					<td>
						<select name="request_type" id="request_type" class="write_gray" title="문의유형 선택" disabled></select>
					</td>
					<th scope="row">버전</th>
					<td>
						<input type="text" 	id="version_info_str" readonly="readonly">
						<input type="hidden" name="version_info" id="version_info" >
					</td>
				</tr>
				<tr id="system_code">
					<th scope="row">시스템(대)<span class="request mgl5">필수 입력</span></th>
					<td>
						<select name="service_cate" id="service_cate" class="write_gray" title="시스템(대) 선택" disabled onchange="javascript:changeService(this.value);"></select>
					</td>
					<th scope="row">시스템(소)<span class="request mgl5">필수 입력</span></th>
					<td>
						<select name="inquiry_type" id="inquiry_type" class="write_gray" title="시스템(소) 선택" disabled></select>
					</td>
				</tr>
				<tr>
					<th scope="row">연락처</th>
					<td>
						<input type="text" name="apply_tel" id="apply_tel" class="mgr5 write_gray" maxlength="12" title="A/S 신청자 연락처 입력 " disabled/>
					</td>
					<th scope="row">SMS수신동의여부</th>
					<td>
						<input type="radio" name="sms_yn" id="send_sms1" class="mgr10" value="Y"/>
						<label for="send_sms1">동의</label>
						<input type="radio" name="sms_yn" id="send_sms2" class="mgr5 mgl10" value="N"/>
						<label for="send_sms2">미동의</label>
					</td>
				</tr>
			</table>
			
			<table class="vType_line mgb20">
				<colgroup>
					<col style="width:150px;" />
					<col style="width:470px;" />
				</colgroup>
				<tr>
					<th scope="row">요청 내용<span class="request mgl5">필수 입력</span></th>
					<td>
						<textarea class="write_gray" name="call_content" id="call_content" readonly="readonly"></textarea>
						<div class="txt_byte" id="call_content_text">0 / 1000 자</div>
					</td>
				</tr>
				<tr>
					<th scope="row">파일 첨부</th>
					<td id="fileList"></td>
				</tr>
			</table>
			
			<div class="btn_wrap">
				<div class="floatR">
					<button type="button" class="btn_ico_save w95" onclick="javascript:goSave();" id="saveBtn"><span>저장</span></button>
				</div>
			</div>
			
		</div>
		
		</form>
		<form name="aswFrm" id="aswFrm" method="post"onsubmit="return false;" enctype="multipart/form-data" >
		<input type="hidden" name="as_no" id="as_no" value=""/>
		<input type="hidden" name="proc_status" id="proc_status" value=""/>
		<input type="hidden" name="delAttach1" id="delAttach1" value=""/>
		<input type="hidden" name="pageType" id="pageType" value=""/>
		<input type="hidden" name="file_seq" id="file_seq" value=""/>
		<div id="subTab2" style="display:none;">
			<table class="vType_line type2 mgb20">
				<caption>요청내용</caption>
				<colgroup>
					<col style="width:130px;" />
					<col style="width:auto;" />
				</colgroup>
				<tr>
					<th scope="row">요청내용<span class="request mgl5">필수 입력</span></th>
					<td id="call_content_str"></td>
				</tr>
			</table>
			
			<table class="hType mgb20">
				<caption>답변 내역</caption>
				<colgroup>
					<col style="width:70px">
					<col style="width:150px">
					<col style="width:auto">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">작성자</th>
						<th scope="col">답변일시</th>
						<th scope="col">답변내용</th>
					</tr>
				</thead>
				<tbody id="awsInfoList"></tbody>
			</table>
			<!--  첨부파일 -->
			<table class="vType_line mgb20">
				<caption>답변작성</caption>
				<colgroup>
					<col style="width:130px">
					<col style="width:auto">
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">답변작성<span class="request mgl5">필수 입력</span></th>
						<td class="pd10">
							<textarea id="w_content" name="w_content" class="lineH13 pd5"></textarea>
						</td>
					</tr>
					<tr>
						<th scope="row">첨부파일</th>
						<td id="aswWrapFile"></td>
					</tr>
				</tbody>
			</table>
			<div class="btn_wrap">
				<div class="floatR">
					<button type="button" class="btn_ico_save  w95" onclick="javascript:goSaveContent();"><span>작성</span></button>
					<button type="button" class="btn_ico_cancel w95" onclick="javascript:closeLayer('2');"><span>닫기</span></button>
				</div>
			</div>
		</div>
	</form>
	</div>
	<button type="button" class="btn_close" onclick="javascript:closeLayer('2');">창 닫기</button>
</div>

<div class="layer_dimmed"  id="div_dim" style="display:none;"></div>