<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javascript">

	var a = '' ; 
	var b = '' ; 
	var c = '' ; 
	var d = '' ; 
	
	var my_tel = [] ; 
	var master_tel = [] ; 
	
	var fileCnt = 1 ; 

	$(document).ready(function(){
	    $('.select-serial').change(function(){
	        var pDate = $('.select-serial option:selected').attr('data-serial')
	        $('.result-date').val(pDate);
	    }) ; 
	    commonCode.getCodeList2('AS' , 'CD03' , 'makeServiceCate') ; 
	    
	    var datas = {'cust_code' : '${ frUserInfo.cust_code}' , 'is_page_gbn' : 'fr'} ; 
		common.ajaxCall(datas , '/ad/member/getCustInfo2.do', 'makeCustInfo') ;
		
		getTelList() ; 
	}) ;
	
	function makeServiceCate(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		$('#service_cate').empty().append('<option value="" disabled selected>유형 카테고리</option>') ;
		
		
		if(resultList != null && resultList.length > 0){
			var str = '' ;
			
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ; 
				str += '<option value=\''+common.nvl(datas.code, '')+'\'>'+common.nvl(datas.code_name, '')+'</option>' ; 
			}
			
			$('#service_cate').append(str) ; 
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
	
	function setService_cate(thisObj){
		$('#inquiry_type').empty() ; 
		$('#version_info').val('') ; 
		$('#version_info_str').val('') ; 
		
		if(thisObj != ""){
			commonCode.getCodeList2('AS' , thisObj , 'makeInqueryType') ;
			
			if(thisObj == "P002"){ $('#version_info').val(a) ; if(a != "") $('#version_info_str').val(commonCode.getCodeNm('CUST' , 'CD04' , a));}
			else if(thisObj == "P003"){ $('#version_info').val(b) ; if(b != "") $('#version_info_str').val(commonCode.getCodeNm('CUST' , 'CD05' , b));}
			else if(thisObj == "P004"){ $('#version_info').val(c) ; if(c != "") $('#version_info_str').val(commonCode.getCodeNm('CUST' , 'CD06' , c));}
			else if(thisObj == "P005"){ $('#version_info').val(d) ; if(d != "") $('#version_info_str').val(commonCode.getCodeNm('CUST' , 'CD07' , d));}
		}else{
			$('#inquiry_type').append('<option value="" disabled selected>상세 유형</option>');	
		}
	}
	
	function makeInqueryType(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
		$('#inquiry_type').append('<option value="" disabled selected>상세 유형</option>');	
		
		
		if(resultList != null && resultList.length > 0){
			var str = '' ;
			
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ; 
				str += '<option value=\''+common.nvl(datas.code, '')+'\'>'+common.nvl(datas.code_name, '')+'</option>' ; 
			}
			
			$('#inquiry_type').append(str) ; 
		} 
	}
	
	function getTelList(){
		common.ajaxCall({} , '/fr/as/getEmpTelList.do', 'makeTelList') ;
	}
	
	function makeTelList(data){
		var asDamTel = typeof  data.asDamTel != "undefined" ? data.asDamTel : null ; 
		var asMyTel = typeof  data.asMyTel != "undefined" ? data.asMyTel : "" ; 
		
		if(asDamTel != null){
			if(common.nvl(asDamTel.tel_no, '') != ''){
				master_tel.push(common.spritStr(asDamTel.tel_no , 1, '-')) ; 
				master_tel.push(common.spritStr(asDamTel.tel_no , 2, '-')) ; 
				master_tel.push(common.spritStr(asDamTel.tel_no , 3, '-')) ; 
			}
		}
		
		if('${ frUserInfo.tel_no }' != ''){
			my_tel.push(common.spritStr('${ frUserInfo.tel_no }' , 1, '-')) ; 
			my_tel.push(common.spritStr('${ frUserInfo.tel_no }' , 2, '-')) ; 
			my_tel.push(common.spritStr('${ frUserInfo.tel_no }' , 3, '-')) ;
		}
	}
	
	function setTelNo(thisObj){
		$('#tel1').val('');		$('#tel2').val('');		$('#tel3').val('');
		$('#tel1').attr('readonly' , true);		
		$('#tel2').attr('readonly' , true);		
		$('#tel3').attr('readonly' , true);
		
		if(thisObj == "1"){
			if(my_tel != null && my_tel.length == 3){
				$('#tel1').val(my_tel[0]);		$('#tel2').val(my_tel[1]);		$('#tel3').val(my_tel[2]);		
			}
		}else if(thisObj == "2"){
			if(master_tel != null && master_tel.length == 3){
				$('#tel1').val(master_tel[0]);		$('#tel2').val(master_tel[1]);		$('#tel3').val(master_tel[2]);		
			}
		}else if(thisObj == "3"){
			$('#tel1').attr('readonly' , false);		
			$('#tel2').attr('readonly' , false);		
			$('#tel3').attr('readonly' , false);	
		}
	}
	
	function addMultiFile(){
		var str ='<div class="form-formNbtn mgb8" id="file'+fileCnt+'">' ; 
		str +='<input type="file" class="form-control" id="uploadFile_'+fileCnt+'" name="uploadFile_'+fileCnt+'"><button class="btn btn-primary" onclick="deleteFile(\''+fileCnt+'\');"><i class="fa fa-minus"></i></button>' ; 
		str +='</div>';
		
		$('#fileList').append(str) ; 
		fileCnt++ ; 
	}
	
	function deleteFile(cnt){
		$('#file'+cnt).remove();
	}
	
	function goSave(){
var f = document.procFrm ; 
		
		if(common.isEmpty($('#service_cate').val())){
			alert("유형 카테고리를 선택해 주세요.") ;		return ; 
		}
		
		if(common.isEmpty($('#inquiry_type').val())){
			alert("상세 유형을 선택해 주세요.") ;		return ; 
		}
		
		if($('#phone').val() != ""){
			
			var hp_no = "" ;
			var phone_gbn = $('#phone').val() ;
			
			if(common.nvl($('#tel1').val(), "") != "" && common.nvl($('#tel2').val(), "") != "" &&  common.nvl($('#tel3').val(), "") != ""){
				hp_no = $('#tel1').val() + "-" + $('#tel2').val() + "-" + $('#tel3').val() ; 
			}
			
			if(hp_no == ""){
				alert("연락 받으실 연락처를 입력해 주세요.") ; return ; 
			}
			$('#apply_tel').val(hp_no) ; 
		}else{
			alert("연락받으실 전화번호를 선택해 주세요.") ;		return ;
		}
		
		if(common.isEmpty($('#call_content').val())){
			alert("요청 내용을 입력해 주세요.") ;		return ; 
		}
		
	
		if(confirm("A/S를 등록하시겠습니까?")){
			
			f.target = "hiddenFrame" ; 
			f.action = "/fr/as/proc.do" ; 
			f.submit();
		}
		
	}
	
	function procReturn(flag , msg){
		alert(msg) ;
		if(flag == "success") goList() ; 
	}
	
	function goList(){
		location.href = "/mb/as/list.do" ; 
	}
	
</script>
<header class="header">
    <div class="menu left"></div>
    <div class="title"><p>A/S신청하기</p></div>
    <div class="menu right"><a href="/mb/as/main.do" class="icons close-btn"></a></div>
</header>

<form name="procFrm" id="procFrm" method="post" enctype="multipart/form-data" onsubmit="return false;">
	<input type="hidden" name="apply_tel" id="apply_tel" value=""/>	<!-- 등록자 연락처 -->
	<input type="file" id="testFile" value="" style="display:none;"/>

<div class="contents">
 	<div class="container">
 		<section>
			<div role="tabpanel">
				<div class="tab-content no-padding">
					<div id="tab1" role="tabpanel" class="tab-pane has-fixed-footer active">
						<section class="circle-pagination">
							<ul class="horizontal-list">
								<li class="active"><a href=""></a></li>
								<li><a href=""></a></li>
							</ul>
						</section>          
						
						<fieldset>
							<legend><i class="fa fa-lg fa-info-circle"></i> 문의 서비스 정보</legend>
							<div class="form-group">
								<select name="service_cate" id="service_cate" class="form-control" onchange="javascript:setService_cate(this.value);">
									<option value="" disabled selected>유형 카테고리</option>
								</select>
							</div>

							<div class="form-group">
								<select id="inquiry_type" name="inquiry_type" class="form-control">
									<option value="" disabled selected>상세 유형</option>
								</select>
							</div>
							
							<div class="form-group">
								<input type="text" class="form-control result-date" readonly id="version_info_str" value="">
								<input type="hidden" name="version_info" id="version_info" >
							</div>
						</fieldset>
						
						
						<fieldset>
							<legend><i class="fa fa-lg fa-phone"></i> 연락처</legend>
							<div class="form-group">
								<select name="phone" id="phone" class="form-control" onchange="setTelNo(this.value);">
									<option value="" disabled selected>연락 받으실 전화번호 선택</option>
									<option value="1">본인 연락처</option>
									<option value="2">대표 담당자 연락처</option>
									<option value="3">직접 입력</option>
								</select>
							</div>
							<div class="form-group wrap-col4">
								<input type="text" class="form-control col-xs-4" id="tel1" value="" readonly="readonly" maxlength="4">
								<input type="text" class="form-control col-xs-4" id="tel2" value="" readonly="readonly" maxlength="4">
								<input type="text" class="form-control col-xs-4" id="tel3" value="" readonly="readonly" maxlength="4">
							</div>
						</fieldset>
                            
						<footer class="footer fix row">
                        	<a href="#tab2" class="btn btn-green btn-lg btn-block" aria-controls="tab2" role="tab" data-toggle="tab">다음 <i class="fa fa-arrow-right"></i></a>
                        </footer>
                    </div>
                    
                    <div id="tab2" role="tabpanel" class="tab-pane has-fixed-footer">
                        <section class="circle-pagination">
                            <div class="menu"><a href="#tab1" class="icons back" aria-controls="tab1" role="tab" data-toggle="tab"></a></div>
                            <ul class="horizontal-list">
                                <li><a href=""></a></li>
                                <li class="active"><a href=""></a></li>
                            </ul>
                        </section>
                        
						<fieldset>
                        	<legend><i class="fa fa-lg fa-question-circle"></i> 요청 내용</legend>
                        	<div class="form-group">
                            	<textarea name="call_content" id="call_content" rows="3" class="form-control"></textarea>
                            </div>
						</fieldset>
                        <fieldset>
                        	<legend><i class="fa fa-lg fa-picture-o"></i> 파일첨부</legend>
                        	<div id="fileList"></div>
                           	
                            <button class="btn btn-primary btn-lg btn-block" onclick="addMultiFile();">파일 추가</button>
                        </fieldset>
                        <footer class="footer fix row">
                            <a href="javascript:goSave();" class="btn btn-green btn-lg btn-block"><i class="fa fa-check"></i> 등록</a>
                        </footer>
                    </div>
                </div>
            </div>
        </section>
    </div>
</div>
</form>
