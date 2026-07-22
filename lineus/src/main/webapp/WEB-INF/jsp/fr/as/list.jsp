<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="egovframework.com.comm.util.DateTimeUtil"%>
<script type="text/javascript">

	var fileCnt = 1 ; 
	var flag = true ; 		/**	상세 수정 가능 여부	*/
	var delAttach1 = "" ; 	/**	첨부파일 삭제*/
	var aswfile_cnt = 1; /*  첨부파일 카운트 */
	var delAttach3 = '';
	
	$(document).ready(function(){
		
		
		$('#search_type5').append(commonCode.defaultViewOption);	/* 상세유형 */
		$("#search_start" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		$("#search_end" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
		
		commonCode.getCodeList('AS' , 'CD01' , 'search_type3') ;	//처리상태
		$('#inquiry_type').append(commonCode.defaultOption);	//상세유형
		
		$('#call_content').keyup(function (e){
	          var content = $(this).val();
	          if(content.length >= 500){
	        	  content = content.substring(0 , 500) ;
	        	  $(this).val(content);
	          }
	          
	          $('#call_content_text').html(content.length + '/ 500 자');
	     });
		
		goList(1) ;
		var as_no = '${vo.as_no}';
		if (as_no != ''){
			goView(as_no);
		}
		
		//문의유형
		var datas = {"cust_seq" : '${ frUserInfo.cust_seq}',  'is_page_gbn' : 'fr'};
		common.ajaxCall(datas , '/fr/cust/getSystemInfo.do', 'makeSystemType') ;
		
	}) ;
	
	function goList(page){
		
		closeLayer('1');
		closeLayer('2');
		
		var f = document.listFrm ; 
		f.page.value = page ;
		common.ajaxCall($('form[name=listFrm]').serialize(), '/fr/as/getAsList.do', 'setAsList') ;
	}
	
	function makeSystemType(data){
		commonCode.returnSystemCodeList(data,'search_type4');
	}
	
	function getTaskType(system_code){
		$('#search_type5').empty() ; 
		var oper_seq = $('#search_type4 option:selected').attr("oper_seq");
		var datas = {"oper_seq" : oper_seq , "system_code" : system_code};
		common.ajaxCall(datas , '/ad/operate/getOperTask.do' , 'setTaskType') ;
	}
	
	
	function setTaskType(data){
		commonCode.returnTaskCodeList(data,'search_type5');
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
				if(common.nvl(datas.proc_status) == "C007" ){
					str += '	<td style="color:#0090c8; font-weight:500;" >'+common.nvl(datas.proc_status_nm, '-')+'</td> ' ;
				}else{
					str += '	<td>'+common.nvl(datas.proc_status_nm, '-')+'</td> ' ;
				}
				str += '	<td>'+common.nvl(datas.system_type_nm, '-')+'/'+common.nvl(datas.inquiry_type_nm, '-')+'</td> ' ;
				str += '	<td class="textL" style="padding-left:2px" title="'+common.nvl(datas.call_content, '-')+'">'+datas.call_content.substr(0 , 15)+'</td> ' ; //요청내용
				str += '	<td>'+common.nvl(datas.apply_nm, '-')+'</td> ' ;
				str += '	<td>'+common.nvl(datas.emp_nm, '-')+'</td> ' ;
				
				if(common.nvl(datas.cn_as_no, '') != ""){
					str += '	<td>-</td> ' ;	
				}else{
					
					var showFlag = false ; 
					
					if(common.nvl(datas.proc_status , '') == "C000" || common.nvl(datas.proc_status , '') == "C001" || common.nvl(datas.proc_status , '') == "C002" || common.nvl(datas.proc_status , '') == "C007") showFlag = true ;
					
					if(showFlag){
						if(common.nvl(datas.cn_count , '') != "0") showFlag = false ; 
					}
					
					if(showFlag) str += '	<td onclick=\'event.cancelBubble=true;\'><button class="btn_line_blue" onclick="javascript:registStatus(\''+common.nvl(datas.as_no)+'\');">철회</button></td> ' ;
					else str += '	<td onclick=\'event.cancelBubble=true;\'><button class="btn_line_blue disabled">철회</button></td> ' ;
				}
				
				if(common.nvl(datas.last_coment, '') != ""){
					str += '	<td>O</td> ' ;	
				} else {
					str += '	<td>X</td> ' ;
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
	
	
	
	/**	고객 평점 조회 레이어 호출	*/
	function goViewStar(as_no){
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
		if(returnCode == "000") goList(1) ; 
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
	
	
	function makeView(data){
		$('#div2').show() ;
		$('#div_dim').show() ; 
		
		$('#aswWrapFile').empty();
		$('#w_content').empty();
		$('#approval_col').hide();
		
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null ;  /**AS정보*/
		var attachList = typeof data.attachList != "undefined" ? data.attachList : null ;/**요청첨부파일*/ 
		var attachList2 = typeof data.attachList2 != "undefined" ? data.attachList2 : null ; /**조치첨부파일*/
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; /**댓글*/
		
		if(resultVO != null){
			// stateC001
			var proc_status = common.nvl(resultVO.proc_status, '') ;
			
			//if(proc_status == "C001") flag = true ; 
			//else 
			flag = false ; 
			
			
			//if(proc_status == "C007") proc_status = "C001" ; 
			for(var i = 1 ; i <= 5 ; i++){
				if("C00" + i == proc_status){
					if(!$('#stateC00' + i).hasClass("current")) $('#stateC00' + i).addClass("current") ; 
				}else{
					if($('#stateC00' + i).hasClass("current")) $('#stateC00' + i).removeClass("current") ;
				}
				if ("C001" == proc_status || "C010" == proc_status) { //팀장승인 = 접수 프로세스
					if(!$('#stateC001').hasClass("current")) $('#stateC001').addClass("current") ;
				}		
				if ("C005" == proc_status || "C012" == proc_status) { //배포승인 = 처리완료 프로세스 
					if(!$('#stateC005').hasClass("current")) $('#stateC005').addClass("current") ;
				}	
			}
			
			if(flag){
				$('#service_cate').prop('disabled' , false)	 ; 			
				if($('#service_cate').hasClass('write_gray')) $('#service_cate').removeClass('write_gray') ; 
				
				$('#inquiry_type').prop('disabled' , false)	 ; 			
				if($('#inquiry_type').hasClass('write_gray')) $('#inquiry_type').removeClass('write_gray') ;
				
				$('#call_content').prop('readonly' , false)	 ;
				
				$('#saveBtn').show() ; 
			}else{
				
				$('#system_type').prop('disabled' , true)	 ; 			
				$('#inquiry_type').prop('disabled' , true)	 ; 			
				$('#apply_tel1').prop('disabled' , true)	 ; 			
				$('#apply_tel2').prop('disabled' , true)	 ; 			
				$('#apply_tel3').prop('disabled' , true)	 ; 			
				$('#apply_email').prop('disabled' , true)	 ;
				$('#accept_dt').prop('disabled' , true)	 ;
				$('#apply_nm').prop('disabled' , true)	 ;
				$('#inquiry_dt').prop('disabled' , true)	 ;
				$('#proc_dt').prop('disabled' , true)	 ;
				$('#call_content').prop('readonly' , true)	 ;
				$('#action_content').prop('readonly' , true)	 ;
				$('#send_email').prop('disabled' , true)	 ;
				$('#send_sms').prop('disabled' , true)	 ;
				
				$('#saveBtn').hide() ; 
			}
			
			$('#accept_dt').val(makeDate(common.nvl(resultVO.accept_dt, '')) +' ' + makeTime(common.nvl(resultVO.accept_time, ''))) ; 
			
			if(common.nvl(resultVO.system_type, '') != ""){
				$('#system_type').val( commonCode.getCodeNm('PROJECT','PR02',resultVO.system_type) );
			}
			
			if( common.nvl(resultVO.oper_seq,'') != '') {
				var datas = {"cust_seq" : '${ frUserInfo.cust_seq}',  'oper_seq' : resultVO.oper_seq };
				common.ajaxCall(datas , '/fr/cust/getSystemName.do', 'setSystemName') ;
			}
			if(common.nvl(resultVO.inquiry_type, '') != ""){
				$('#inquiry_type').val( commonCode.getCodeNm('OPERATE',resultVO.system_type ,resultVO.inquiry_type) );
			}
			$('#apply_nm').val(common.nvl(resultVO.apply_nm, '') +' ['+common.nvl(resultVO.apply_id, '')+']') ;
			$('#inquiry_dt').val(makeDate(common.nvl(resultVO.inquiry_dt, ''))) ;
			$('#proc_dt').val(makeDate(common.nvl(resultVO.proc_dt, ''))) ;
			$('#proc_status').val(common.nvl(resultVO.proc_status, "")) ; 
			$('#apply_email').val(common.nvl(resultVO.apply_email, "")) ; 
			
			$('#apply_sms_tel').val(common.nvl(resultVO.apply_sms_tel, "")) ; 
			
			$('#inportance').val(common.nvl(resultVO.inportance_nm, "")) ; 
			$('#assign_nm').val(common.nvl(resultVO.assign_nm, "")) ; 
			
			
			if( common.nvl(resultVO.send_email, '') == "Y") {$('#send_email').attr("checked",true);
			}else {$('#send_email').attr("checked",false);}
			
			if( common.nvl(resultVO.send_sms, '') == "Y"){$('#send_sms').attr("checked",true);
			}else{$('#send_sms').attr("checked",false);}
			
			$('#call_content').val(common.nvl(resultVO.call_content, "")) ; 
			$('#call_content_str').text(common.nvl(resultVO.call_content, "")) ; 
			$('#action_content').val(common.nvl(resultVO.action_content, "")) ; 
			if(common.nvl(resultVO.apply_tel, '') != ''){
				$('#apply_tel1').val(common.spritStr(resultVO.apply_tel , 1, '-')) ; 
				$('#apply_tel2').val(common.spritStr(resultVO.apply_tel , 2, '-')) ; 
				$('#apply_tel3').val(common.spritStr(resultVO.apply_tel , 3, '-')) ; 
			}
			
			$('#approvalBtn').hide();
			if(resultVO.proc_status =="C007"){
				<c:if test="${frUserInfo.as_approval_yn eq 'C001' && frUserInfo.approval_auth eq 'C001'}">
					$('#approvalBtn').show();			
				</c:if>
			}
			
			if(resultVO.approval_id != '')$('#approval_col').show();
			$('#approval_nm').val( common.nvl(resultVO.approval_nm, "")+' ['+common.nvl(resultVO.approval_id, "") +']') ; 
			$('#approval_dt').val(makeDate(common.nvl(resultVO.approval_dt, '')) +' ' + makeTime(common.nvl(resultVO.approval_time, ''))) ; 
			
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
						str += '<input type="text" class="w265 mgr5" readonly="readonly" value="'+common.nvl(datas.attach_ori_nm, '')+'"><button type="button" class="btn_ico_file_down mgr5" onclick="fileDown('+common.nvl(datas.attach_seq, '')+' , '+common.nvl(datas.attach_ord, '')+');"><span>다운로드</span></button><button type="button" class="btn_ico_delete" onclick="deleteFile('+common.nvl(datas.attach_ord, '0')+');"><span>삭제</span>';
					}else{
						
						if(i == 0){
							str += '<input type="text" class="w265 mgr5" readonly="readonly" value="'+common.nvl(datas.attach_ori_nm, '')+'"><button type="button" class="btn_ico_file_down mgr5" onclick="fileDown('+common.nvl(datas.attach_seq, '')+' , '+common.nvl(datas.attach_ord, '')+');"><span>다운로드</span></button>';
						}else{
							str += '<input type="text" class="w265 mgr5 mgt5" readonly="readonly" value="'+common.nvl(datas.attach_ori_nm, '')+'"><button type="button" class="btn_ico_file_down mgr5" onclick="fileDown('+common.nvl(datas.attach_seq, '')+' , '+common.nvl(datas.attach_ord, '')+');"><span>다운로드</span></button>';
						}
					}
					str += '</div>' ;
					
					$('#fileList').append(str) ; 
					
					fileCnt = Number(common.nvl(datas.attach_ord, '0')) + 1;
				}
			}else{
				//if(flag){addMultiFile() };
				var str ='<input type="text" class="w265 mgr5" readonly="readonly" value="첨부된 파일이 없습니다">';
				$('#fileList').append(str) ; 
			}
			
			$('#file_seq2').val(common.nvl(resultVO.attach_seq2, "")) ; 
			$('#fileList2').empty();
			if(attachList2 != null && attachList2.length > 0){
				for(var i = 0 ; i < attachList2.length ; i++){
					var datas = attachList2[i] ; 
					var str = '' ; 
					str += '<div id="multiFile'+common.nvl(datas.attach_ord, '0')+'">' ; 
					if(flag){
						str += '		<input type="file" id="uploadFile_'+common.nvl(datas.attach_ord, '0')+'" name="uploadFile_'+common.nvl(datas.attach_ord, '0')+'" style="width:218px;" />' ; 
						if(fileCnt > 1) 	str += '	<button class="btn_minus mgl5" onclick="deleteFile('+common.nvl(datas.attach_ord, '0')+');"></button>';
						else 						str += '	<button class="btn_plus mgl5" onclick="addMultiFile();"></button>';	
						str += '<input type="text" class="w265 mgr5" readonly="readonly" value="'+common.nvl(datas.attach_ori_nm, '')+'"><button type="button" class="btn_ico_file_down mgr5" onclick="fileDown('+common.nvl(datas.attach_seq, '')+' , '+common.nvl(datas.attach_ord, '')+');"><span>다운로드</span></button><button type="button" class="btn_ico_delete" onclick="deleteFile('+common.nvl(datas.attach_ord, '0')+');"><span>삭제</span>';
					}else{
						
						if(i == 0){
							str += '<input type="text" class="w265 mgr5" readonly="readonly" value="'+common.nvl(datas.attach_ori_nm, '')+'"><button type="button" class="btn_ico_file_down mgr5" onclick="fileDown('+common.nvl(datas.attach_seq, '')+' , '+common.nvl(datas.attach_ord, '')+');"><span>다운로드</span></button>';
						}else{
							str += '<input type="text" class="w265 mgr5 mgt5" readonly="readonly" value="'+common.nvl(datas.attach_ori_nm, '')+'"><button type="button" class="btn_ico_file_down mgr5" onclick="fileDown('+common.nvl(datas.attach_seq, '')+' , '+common.nvl(datas.attach_ord, '')+');"><span>다운로드</span></button>';
						}
					}
					str += '</div>' ;
					
					$('#fileList2').append(str) ; 
					
					fileCnt = Number(common.nvl(datas.attach_ord, '0')) + 1;
				}
			}else{
				//if(flag){addMultiFile() };
				var str ='<input type="text" class="w265 mgr5" readonly="readonly" value="첨부된 파일이 없습니다">';
				$('#fileList2').append(str) ; 
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
					str += '	<td class="textL" style="white-space:pre-wrap">'+common.nvl(datas.w_content) + '<br>';
					
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
				$('#awsInfoList').append(str) ;
			}else{
				
				commonTable.notData(3 , '조회된 데이터가 없습니다.' , 'awsInfoList') ; 
			}
			 
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
		if (common.isEmpty($('#service_cate').val())) {
			alert('유형 카테고리를 선택하세요.'); 		$('#service_cate').focus(); 		return;
		}
		if (common.isEmpty($('#inquiry_type').val())) {
			alert('상세 유형을 선택하세요.'); 		$('#inquiry_type').focus();			return;
		}	
		if(confirm('저장 하시겠습니까?')){
			
			f.delAttach1.value = delAttach1 ;
			f.pageType.value = "layerUpdate" ; 
			f.target = 'hiddenFrame' ; 
			f.action = '/fr/as/procLayer.do' ; 
			f.submit() ; 	
		}
		
	}
	
	function goApproval(){
		
		var f = document.viewFrm ; 
		f.as_no.value	
	   	if(confirm('본 AS '+'[접수번호: '+ f.as_no.value +']'+'를 승인 하시겠습니까?')){
			f.pageType.value = "layerApproval" ; 
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
	
	
	function setSystemName(data){
		var vo = typeof data.vo != "undefined" ? data.vo[0] : null ; 
		if(vo != null){
			var str = $('#viewFrm #system_type');
			var strVal = $('#viewFrm #system_type').val();
			str.val(strVal + " [" + vo.system_nm + "]");
		}
	}
	
	
////답변-첨부파일/////////////////////////////////////////////////////////////////////////////////
	
	function addAswFile() {
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
				<col style="width:70px;" />
				<col style="width:300px;" />
				<col style="width:70px;" />
				<col style="width:50px;" />
				<col style="width:70px;" />
				<col style="width:100px;" />
				<col style="width:70px;" />
				<col style="width:270px;" />
			</colgroup>
			<tr>
				<th scope="row">신청기간</th>
				<td>
					<input type="checkbox" name="search_type1" id="search_type1" value ="Y">
					<input type="text" name="search_start" id="search_start" class="w90 mgl5 mgr5" readonly>~<input type="text" class="w90 mgl5 mgr5" name="search_end" id="search_end" readonly>
				</td>
				<th scope="row">검수완료</th>
				<td>
					<input type="checkbox" name="search_type2" id="search_type2" value ="Y">
				</td>
				<th scope="row">처리상태</th>
				<td>
					<select title="처리완료 선택" name="search_type3" id="search_type3"></select>
				</td>
				<th scope="row">문의유형</th>
				<td>
					<select title="시스템유형/상세유형 선택" class="w115 mgr5" name="search_type4" id="search_type4"  onchange="javascript:getTaskType(this.value);"></select>
					<select title="상세유형 선택" class="w115 mgr5" name="search_type5" id="search_type5"></select>
				</td>
			</tr>
			<tr>
				<th scope="row">요청내용</th>
				<td>
					<input type="text" name="search_text" id="search_text" title="요청내용 입력">
				</td>
				<th scope="row">신청자</th>
				<td colspan="3">
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
<table class="hType mgb20">
	<colgroup>
		<col style="width:35px;">
		<col style="width:81px;">
		<col style="width:81px;">
		<col style="width:100px;">
		<col style="width:100px;">
		<col style="width:150px;">
		<col style="width:80px;">
		<col style="width:80px;">
		<col style="width:60px;">
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
			<th>요청내용</th>
			<th>신청자</th>
			<th>처리 담당자</th>
			<th>요청철회</th>
			<th>답변여부</th>
			<th>검수확인</th>
			<th>검수일</th>
			<th>검수자</th>
		</tr>
	</thead>
	<tbody id="listTbody"></tbody>
</table>
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

<div class="box_layer layer_as_list" id="div2" style="display:none;">
<h1 class="tit_back">A/S 신청내역 상세보기</h1>
<div class="layer_contents">

	<form name="viewFrm" id="viewFrm" method="post" onsubmit="return false;" enctype="multipart/form-data" >
		<input type="hidden" name="as_no" id="as_no" value=""/>
		<input type="hidden" name="proc_status" id="proc_status" value=""/>
		<input type="hidden" name="delAttach1" id="delAttach1" value=""/>
		<input type="hidden" name="pageType" id="pageType" value=""/>
		<input type="hidden" name="file_seq" id="file_seq" value=""/>
		<input type="hidden" name="file_seq2" id="file_seq2" value=""/>

		<!-- tab -->
		<ul class="tab_line list2 mgb20">
			<li id="li1" class="active"><a href="javascript:subTab('1');">처리 정보</a></li><!-- 활성시 current -->
			<li id="li2" ><a href="javascript:subTab('2');">답변내역</a></li>
		</ul>
		<!--// tab -->
		<div class="tit_sWrap">
			<h4 class="tit_bold_gray">접수 처리 단계</h4>
		</div>
		<!-- process -->
		
		<div id="subTab1">
		
			<ul class="pro_arrow list5 mgb15">
				<li id="stateC001" class="current">접수</li><!-- 활성시 current -->
				<li id="stateC002">담당자(재)배정중</li>
				<li id="stateC003">배정완료</li>
				<li id="stateC004">처리중</li>
				<li id="stateC005">처리완료</li>
			</ul>

			<div class="tit_sWrap">
				<h4 class="tit_bold_gray">AS 접수 정보</h4>
			</div>
			
			<table class="vType_line mgb10">
				<caption>기본 정보 목록</caption>
				<colgroup>
					<col style="width:140px;" />
					<col style="width:170px;" />
					<col style="width:140px;" />
					<col style="width:170px;" />
				</colgroup>
				<tr>
					<th scope="row">접수일자</th>
					<td>
						<input type="text" id="accept_dt" name="accept_dt" readonly="readonly"/>
					</td>
					<th scope="row">AS 신청자 이름/아이디</th>
					<td>
						<input type="text" 	id="apply_nm" name="apply_nm" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<th scope="row">연락받으실 전화번호</th>
					<td>
						<input type="text" name="apply_tel1" id="apply_tel1" maxlength="4" value="" class="w50 mgr5" id="as_call" title="A/S 신청자 연락처 입력" readonly="readonly" />-
						<input type="text" name="apply_tel2" id="apply_tel2" maxlength="4" value="" class="w50 mgl5 mgr5" id="as_call" title="A/S 신청자 연락처 입력" readonly="readonly"/>-
						<input type="text" name="apply_tel3" id="apply_tel3" maxlength="4" value="" class="w50 mgl5" id="as_call" title="A/S 신청자 연락처 입력" readonly="readonly"/>
					</td>
					<th scope="row">알림 이벤트 수신 여부</th>
					<td>
						<input type="checkbox" 	class="mgr5" id="send_email" name="send_email"  readonly="readonly"/><label for ="send_email">Email</label>
						<input type="checkbox" 	id="send_sms" name="send_sms"  readonly="readonly" class="mgl10 mgr5"/><label for ="send_sms">SMS</label>
						<!-- <span  class="tit_depth colorBlue mgl10 mgt5 valignT">AS 처리완료 시 확인 이메일과 SMS를 받아보실 수 있습니다.</span> -->
					</td>
				</tr>
				<tr>
					<th scope="row">알림 수신 이메일 주소</th>
					<td>
						<input type="text" 	id="apply_email" name="apply_email"  readonly="readonly"/>
					</td>
					<th scope="row">SMS 수신 전화번호</th>
					<td>
						<input type="text" 	id="apply_sms_tel" name="apply_sms_tel"  readonly="readonly"/>
					</td>
				</tr>
			</table>
			
			
			<table class="vType_line mgb10">
				<caption>기본 정보 목록</caption>
				<colgroup>
					<col style="width:140px;" />
					<col style="width:170px;" />
					<col style="width:140px;" />
					<col style="width:170px;" />
				</colgroup>
				<tr>
					<th scope="row">시스템유형</th>
					<td>
						<input type="text" 	id="system_type" name="system_type"  readonly="readonly"/>
					</td>
					<th scope="row">상세유형</th>
					<td>
						<input type="text" 	id="inquiry_type" name="inquiry_type"  readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<th scope="row">업무 중요도</th>
					<td>
						<input type="text" 	id="inportance" name="inportance"  readonly="readonly"/>
					</td>
					<th scope="row">처리 담당자</th>
					<td>
						<input type="text" 	id="assign_nm" name="assign_nm"  readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<th scope="row">처리요청일자</th>
					<td>
						<input type="text" 	id="inquiry_dt" name="inquiry_dt"  readonly="readonly"/>
					</td>
					<th scope="row">처리예정일자</th>
					<td>
						<input type="text" 	id="proc_dt" name="proc_dt"  readonly="readonly"/>
					</td>
				</tr>
				<tr id="approval_col">
					<th scope="row">결재자</th>
					<td>
						<input type="text" 	id="approval_nm" name="approval_nm"  readonly="readonly"/>
					</td>
					<th scope="row">승인일자</th>
					<td>
						<input type="text" 	id="approval_dt" name="approval_dt"  readonly="readonly"/>
					</td>
				</tr>
			</table>
			
			
			
			<table class="vType_line mgb20">
				<colgroup>
					<col style="width:140px;" />
					<col style="width:480px;" />
				</colgroup>
				<tr>
					<th scope="row">요청 내용<span class="request mgl5">필수 입력</span></th>
					<td>
						<textarea class="write_gray" name="call_content" id="call_content" readonly="readonly" style="height:150px;"></textarea>
						<!-- <div class="txt_byte" id="call_content_text">0 / 500 자</div> -->
					</td>
				</tr>
				<tr>
					<th scope="row">파일 첨부(요청내용)</th>
					<td id="fileList"></td>
				</tr>
				
				<tr>
					<th scope="row">조치 및 처리 내용</th>
					<td>
						<textarea class="write_gray" name="action_content" id="action_content" readonly="readonly" style="height:150px;"></textarea>
						<!-- <div class="txt_byte" id="action_content_text">0 / 500 자</div> -->
					</td>
				</tr>
				<tr>
					<th scope="row">파일 첨부(처리내용)</th>
					<td id="fileList2"></td>
				</tr>
			</table>
			
			<div class="btn_wrap">
				<div class="floatR">
					<button type="button" class="btn_ico_approval w95" onclick="javascript:goApproval();" id="approvalBtn" style="display:none" ><span>승인</span></button>
					<button type="button" class="btn_ico_cancel w95" onclick="javascript:closeLayer('2');"><span>닫기</span></button>
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
					<td id="call_content_str" style="white-space:pre-wrap"></td>
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