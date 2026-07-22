<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javascript">
	var a = '' , b = '' , c = '' , d = '' ; 
	var fileCnt = 1 ; 
	var delAttach1 = "" ; 
	
	$(document).ready(function(){
		commonCode.getCodeList2('AS' , 'CD01' , 'makeSearchType2') ;
		commonCode.getCodeList('AS' , 'CD03' , 'service_cate') ;
		goList() ; 
		
		$('#call_content').keyup(function (e){
	          var content = $(this).val();
	          if(content.length >= 500){
	        	  content = content.substring(0 , 500) ;
	        	  $(this).val(content)
	          }
	     });
	}) ; 
	
	function makeSearchType2(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		$('#search_type2').empty().append('<option value="">처리상태</option>') ;
		$('#proc_status').empty() ;
		
		
		if(resultList != null && resultList.length > 0){
			var str = '' ;
			
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ; 
				str += '<option value=\''+common.nvl(datas.code, '')+'\'>'+common.nvl(datas.code_name, '')+'</option>' ; 
			}
			
			$('#search_type2').append(str) ; 
			$('#proc_status').append(str) ; 
			
		} 
	}
	
	function goList(){
		var datas = {
				'search_type1' : $('#search_type1').val() ,
				'search_type2' : $('#search_type2').val() 
		} ; 
		common.ajaxCall(datas, '/mb/as/getAsList.do', 'makeAsList') ;
	}
	
	function makeAsList(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		$('#asTbody').empty() ; 
		var str = '' ; 
		
		if(resultList != null && resultList.length > 0){
			
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ; 
				
				var accept_dt = common.nvl(datas.accept_dt, '') ; 
				var as_no = common.nvl(datas.as_no , "") ; 
				var cn_as_no = common.nvl(datas.cn_as_no , "") ;
				var proc_status_nm = common.nvl(datas.proc_status_nm, "") ; 
				var cn_count = common.nvl(datas.cn_count, "") ; 
				
				str += '<tr> ' ;
				str += '	<td>'+accept_dt+'</td> ' ;
				
				if(cn_as_no != ""){
					str += '	<td><a href="javascript:modalShow(\''+as_no+'\' , \'sub\', \''+cn_count+'\' );">'+cn_as_no+'</a></td> ' ;
					var arr = as_no.split("-") ; 
					str += '	<td>'+arr[1]+'</td> ' ;	
				}else{
					str += '	<td><a href="javascript:modalShow(\''+as_no+'\' , \'main\', \''+cn_count+'\');">'+as_no+'</a></td> ' ;
					str += '	<td>-</td> ' ;
				}
				
				str += '	<td>'+proc_status_nm+'</td> ' ;
				str += '</tr> ' ;
				
			}
		}else{
			str += '<tr> ' ;
			str += '	<td colspan="4">등록된 a/s가 없습니다.</td> ' ;
			str += '</tr> ' ;
		}
		$('#asTbody').append(str) ;
	}
	
	function modalShow(as_no , gubun, cn_count){
		var f = document.viewFrm ; 
		f.as_no.value = as_no ; 
		f.gubun.value = gubun ; 
		f.cn_count.value = cn_count ; 
		
		f.delAttach1.value = "" ; 
		delAttach1 = "" ; 
		
		common.ajaxCall($('form[name=viewFrm]').serialize() , '/fr/as/getAsInfo.do', 'makeView') ;
	}
	
	function makeView(data){
		var f = document.viewFrm ; 
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null ; 
		var attachList = typeof data.attachList != "undefined" ? data.attachList : null ; 
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		$('#btn1').hide() ;		$('#btn2').hide() ;	$('#btn3').hide() ;	$('#fieldBtn2').hide() ;   $('#btnFile').hide() ;
		
		var minusBtn = true ; 
		
		$('#showModel1').click();
		
		if(resultVO != null){
			var proc_status = common.nvl(resultVO.proc_status, '') ;
			
			/**	수정 가능 - (유형카테고리,문의유형,버전,요청내용,첨부파일) 수정가능.	*/
			if(f.gubun.value == "main" && proc_status == "C001"){
				$('#btn1').show() ;		
				$('#btnFile').show() ;		
				$('#service_cate').prop('disabled' , false) ; 
				$('#inquiry_type').prop('disabled' , false) ; 
			}else{
				minusBtn = false ;
				$('#service_cate').prop('disabled' , true) ; 
				$('#inquiry_type').prop('disabled' , true) ; 
			}
			
			/**	검수확인 	*/
			if(f.gubun.value == "main" && proc_status == "C005"){
				$('#btn2').show() ;		
				$('#fieldBtn2').show() ;		
			}
			
			/**	요청 철회	*/
			if(f.gubun.value == "main" && (proc_status == "C001" || proc_status == "C002")){
				if(f.cn_count.value == "0") $('#btn3').show() ;			
			}
			
			$('#show_as_no1').val(f.as_no.value) ; 
			$('#show_as_no2').val(f.as_no.value) ; 
			$('#accept_dt').val(makeDate(common.nvl(resultVO.accept_dt, ''))) ; 
			$('#proc_status').val(common.nvl(resultVO.proc_status, '')) ; 
			
			var datas = {'cust_code' : '${ frUserInfo.cust_code}' , 'is_page_gbn' : 'fr'} ; 
			common.ajaxCall(datas , '/ad/member/getCustInfo2.do', 'makeCustInfo') ;
			
			$('#service_cate').val(common.nvl(resultVO.service_cate, "")) ; 
			changeService(common.nvl(resultVO.service_cate, "")) ;
			$('#inquiry_type').val(common.nvl(resultVO.inquiry_type, "")) ; 
			
			$('#call_content').val(common.nvl(resultVO.call_content, "")) ;
			$('#call_content2').val(common.nvl(resultVO.call_content, "")) ;
			$('#file_seq').val(common.nvl(resultVO.file_seq, "")) ; 
			// STAR_STATE // STAR_CONTENT
			$('#star_content').val(common.nvl(resultVO.star_content, "")) ;
			if(common.nvl(resultVO.star_state, '') != '') $('#star' + resultVO.star_state).click();
			$('#fileList').empty();
			
			if(attachList != null && attachList.length > 0){
				for(var i = 0 ; i < attachList.length ; i++){
					var datas = attachList[i]
					
					var str = '<div class="form-formNbtn mgb8" id="multiFile'+common.nvl(datas.attach_ord , '0')+'"> ' ;
					str += '	<input type="text" class="form-control w275" value="'+common.nvl(datas.attach_ori_nm, '')+'" disabled> ' ;
					if(minusBtn) str += '	<button class="btn btn-primary" onclick="deleteFile('+common.nvl(datas.attach_ord, '0')+');"><i class="fa fa-minus"></i></button> ' ;
					str += '	<button class="btn btn-primary" onclick="fileDown('+common.nvl(datas.attach_seq, '')+' , '+common.nvl(datas.attach_ord, '')+');"><i class="fa fa-download"></i></button>  ' ;
					str += '</div> ' ;
					
					$('#fileList').append(str) ; 
					fileCnt = Number(common.nvl(datas.attach_ord, '0')) + 1;
				}
			}
			
			$('#awsInfoList').empty();
			
			
			if(resultList != null && resultList.length > 0){
				for(var i = 0 ; i < resultList.length ; i++){
					var datas = resultList[i] ; 
					
					var str = '<li> ' ;
					str += '	<p class="author">' + common.nvl(datas.emp_nm , '') ;
					str += '		<span>'+common.nvl(datas.w_date , '')+'</span> ' ;
					
					if('${frUserInfo.emp_grade}' == 'C001'){
						if(common.nvl(datas.w_gubun, '') == "U"){
							str += '		<span class="pull-right"> ' ;
							str += '			<a href="javascript:delComment(\''+common.nvl(datas.seq, '')+'\');"><i class="fa fa-lg fa-times"></i></a> ' ;
							str += '		</span> ' ;						
						}
					}else{
						if(common.nvl(datas.w_id, '') == "${ frUserInfo.emp_id}"){
							str += '		<span class="pull-right"> ' ;
							str += '			<a href="javascript:delComment(\''+common.nvl(datas.seq, '')+'\');"><i class="fa fa-lg fa-times"></i></a> ' ;
							str += '		</span> ' ;						
						}
					}
					str += '	</p> ' ;
					str += '	<p class="comment">'+common.nvl(datas.w_content , '')+'</p> ' ;
					str += '</li> ' ;
					
					$('#awsInfoList').append(str) ; 
				}
			}
			
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
	
	function deleteFile(cnt){
		$('#multiFile'+cnt).remove();
		
		if(delAttach1 == "") delAttach1 = cnt ; 
		else delAttach1 = delAttach1 + "@" + cnt ;
	}
	
	function deleteHtmlFile(cnt){
		$('#multiFile'+cnt).remove();
	}
	
	function addMultiFile(){
		var str = '<div class="form-formNbtn mgb8" id="multiFile'+fileCnt+'"> ' ;
		str += '	<input type="file" class="form-control w275" value="" id="uploadFile_'+fileCnt+'" name="uploadFile_'+fileCnt+'"> ' ;
		str += '	<button class="btn btn-primary" onclick="deleteHtmlFile('+fileCnt+');"><i class="fa fa-minus"></i></button> ' ;
		str += '</div> ' ;
		
		$('#fileList').append(str) ; 
		fileCnt++ ; 
	}
	
	/**	수정	*/
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
	
	function procReturn(gbn , msg){
		alert(msg) ;
		
		if(gbn == "success") location.href = "/mb/as/list.do" ; 
	} 
	
	function registResult(data){
		var msg = "처리도중 오류가 발생했습니다." ; 
		var returnCode = typeof data.returnCode != "undefined" ? data.returnCode : "888" ; 
		var pageType = typeof data.pageType != "undefined" ? data.pageType : "" ; 
		if(returnCode == "000") msg = "정상처리 되었습니다." ;
		
		alert(msg) ; 
		// delComment
		if(returnCode == "000") {
			var f = document.viewFrm ; 
			
			if(pageType == "delComment") {
				modalShow(f.as_no.value , f.gubun.value , f.cn_count.value) ;
			}else if(pageType == "insertContent"){
				$('#w_content').val('') ;
				modalShow(f.as_no.value , f.gubun.value , f.cn_count.value) ;
			}else{
				location.href = "/mb/as/list.do" ;
			}
		}
	}
	
	/**	검수 확인		*/
	function goConfirm(){
		if(!confirm('검수확인 하시겠습니까?')) return ;
		
		var f = document.viewFrm ; 
		f.pageType.value = 'starUpdate' ; 
		
		common.ajaxCall($('form[name=viewFrm]').serialize(), '/fr/as/registAs.do', 'registResult') ;
	}
	
	/**	철회	*/
	function goFinish(){
		if(!confirm('철회처리 하시겠습니까?')) return ;
		var f = document.viewFrm ; 
		var datas = {'as_no' 	: f.as_no.value , 	'pageType' : 'changeStatus'} ; 
		common.ajaxCall(datas , '/fr/as/registAs.do', 'registResult') ;
	}
	
	function delComment(seq){
		if(!confirm('삭제 하시겠습니까?')) return ;
		var f = document.viewFrm ; 
		var datas = {'as_no' 	: f.as_no.value , 	'pageType' : 'delComment', 	'seq' : seq} ;
		common.ajaxCall(datas , '/fr/as/registAs.do', 'registResult') ;
	}
	
	function goSaveContent(){
		if(common.isEmpty($('#w_content').val())){
			alert("답변 내용을 등록해 주세요.") ; return ; 
		}
		
		if(!confirm('답변 내용을 등록하시겠습니까?')) return ;
		document.viewFrm.pageType.value = 'insertContent' ; 
		common.ajaxCall($('form[name=viewFrm]').serialize(), '/fr/as/registAs.do', 'registResult') ;
	}
	
	
</script>
<header class="header">
    <div class="menu left"></div>
    <div class="title"><p>신청 등록 현황</p></div>
    <div class="menu right"><a href="/mb/as/main.do" class="icons close-btn"></a></div>
</header>

<div class="contents">
    <div class="container">
        <section>
            <div class="form-inline">
                <div>
                    <select name="search_type1" id="search_type1" class="form-control" onchange="javascript:goList();">
                        <option value="" selected>신청일</option>
                        <option value="1">최근순</option>
                        <option value="2">오래된순</option>
                    </select>
                </div>
                <div>
                    <select name="search_type2" id="search_type2" class="form-control" onchange="javascript:goList();"></select>
                </div>
            </div>
            <table class="table table-striped table-bordered text-center">
                <thead>
                    <tr>
                        <td style="width: 10%">신청일</td>
                        <td style="width: 30%">고객<br>접수번호</td>
                        <td style="width: 25%">연관<br>작업번호</td>
                        <td style="width: 30%">처리<br>상태</td>
                    </tr>
                </thead>
                <tbody id="asTbody"></tbody>
            </table>
        </section>
    </div>
</div>
<a href="" data-toggle="modal" data-target="#modal-list-more" id="showModel1" style="display:none;"></a>
<form name="viewFrm" id="viewFrm" method="post" onsubmit="return false;" enctype="multipart/form-data">
	<input type="hidden" name="as_no" id="as_no" value=""/>
	<input type="hidden" name="gubun" id="gubun" value=""/>
	<input type="hidden" name="cn_count" id="cn_count" value=""/>
	<input type="hidden" name="version_info" id="version_info" >
	
	<input type="hidden" name="delAttach1" id="delAttach1" value=""/>
	<input type="hidden" name="pageType" id="pageType" value=""/>
	<input type="hidden" name="file_seq" id="file_seq" value=""/>
	
	<div class="modal fade" id="modal-list-more" tabindex="-1" role="dialog">
		<div class="modal-dialog modal-lg">
	    	<div class="modal-content">
	        	<div class="header modal-header">
	            	<div class="menu right"><span class="icons close-btn" data-dismiss="modal" aria-label="Close"></span></div>
	                <div class="title"><p>신청 등록 현황 상세</p></div>
	            </div>
	            <div class="contents container modal-body modal-body-full">
	            	<div role="tabpanel">
	            		<ul class="nav nav-tabs" role="tablist">
	            			<li role="presentation" class="active"><a href="#tab1" aria-controls="tab1" role="tab" data-toggle="tab">처리 정보</a></li>
	            			<li role="presentation"><a href="#tab2" aria-controls="tab2" role="tab" data-toggle="tab">답변 내역</a></li>
	            		</ul>
	            		<div class="tab-content">
	            			<div role="tabpanel" class="tab-pane active pdb90" id="tab1">
								<fieldset>
									<legend><i class="fa fa-lg fa-pencil"></i> 고객접수번호 </legend>
									<div class="form-group">
										<input type="text" class="form-control" id="show_as_no1"  value="" disabled>
									</div>
								</fieldset>
								<fieldset>
									<legend><i class="fa fa-lg fa-calendar"></i> 신청일</legend>
									<div class="form-group">
										<input type="text" class="form-control" id="accept_dt" value="" disabled>
									</div>
								</fieldset>
								<fieldset>
									<legend><i class="fa fa-lg fa-long-arrow-right"></i> 처리 상태</legend>
									<div class="form-group">
										<select title="문의 카테고리 선택" class="form-control" id="proc_status" disabled></select>
									</div>
								</fieldset>
								
								<fieldset>
									<legend><i class="fa fa-lg fa-archive"></i> 제품 정보</legend>
									<div class="form-group">
										<select title="문의 카테고리 선택" name="service_cate" id="service_cate" class="form-control" onchange="changeService(this.value);"></select>
									</div>
									<div class="form-group">
										<select title="문의 유형 선택" name="inquiry_type" id="inquiry_type" class="form-control"></select>
									</div>
									<div class="form-group">
										<input type="text" class="form-control" id="version_info_str" value="" disabled>
									</div>
								</fieldset>
								
								<fieldset>
	                            	<legend><i class="fa fa-lg fa-comment"></i> 요청 내용</legend>
	                                <div class="form-group">
	                                	<textarea class="form-control" name="call_content" id="call_content"></textarea>
	                                </div>
								</fieldset>
	                            
	                            <fieldset>
									<legend><i class="fa fa-lg fa-picture-o"></i> 파일첨부</legend>
									<div id="fileList"></div>
									<button class="btn btn-primary btn-lg btn-block" onclick="javascript:addMultiFile();" id="btnFile">파일추가</button>
	                            </fieldset>
	                            
	                            <fieldset id="fieldBtn2">
	                            	<legend class="mgb8"><i class="fa fa-lg fa-check"></i> 확인</legend>
	                                <div class="text-center mgb8">
	                                	<input type="radio" id="star1" name="starRate" value="1">
										<input type="radio" id="star2" name="starRate" value="2">
										<input type="radio" id="star3" name="starRate" value="3">
										<input type="radio" id="star4" name="starRate" value="4">
										<input type="radio" id="star5" name="starRate" value="5">
										<div class="wrapStar mgb8">
											<label for="star1"></label>
											<label for="star2"></label>
											<label for="star3"></label>
											<label for="star4"></label>
											<label for="star5"></label>
										</div>
	                               		<textarea class="form-control" name="star_content" id="star_content"></textarea>
	                                </div>
	                             </fieldset>
	           					<footer class="footer fix row">
	                                <a href="#" class="btn btn-green btn-lg btn-block" id="btn1" onclick="javascript:goSave();"><i class="fa fa-check"></i>수정</a>
	                                <a href="#" class="btn btn-green btn-lg btn-block" id="btn2" onclick="javascript:goConfirm();"><i class="fa fa-check"></i>검수확인</a>
	                                <a href="#" class="btn btn-primary btn-lg btn-block" id="btn3" onclick="javascript:goFinish();"><i class="fa fa-close"></i>요청철회</a>
	                            </footer>
	            			</div>
	            			
	            			<div role="tabpanel" class="tab-pane" id="tab2">
	           				    <fieldset>
									<legend><i class="fa fa-lg fa-pencil"></i> 접수번호</legend>
									<div class="form-group">
										<input type="text" class="form-control" id="show_as_no2" value="" disabled>
									</div>
								</fieldset>
						
								<fieldset>
									<legend><i class="fa fa-lg fa-comment"></i> 요청내용</legend>
									<div class="form-group">
										<textarea class="form-control" id="call_content2" readonly="readonly"></textarea>
									</div>
								</fieldset>
								
	           					<ul class="list-comment" id="awsInfoList"></ul>
	           					
	           					<div class="form-group">
	           						<textarea class="form-control" style="margin-bottom:10px;" name="w_content" id="w_content"></textarea>
	           						<button class="btn btn-green btn-lg btn-block" onclick="javascript:goSaveContent();">답변등록</button>
	           					</div>
	            			</div>
	            		</div>
	            	</div>      
	            </div>
	        </div>
	    </div>
	</div>
</form>
