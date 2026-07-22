<%@page import="egovframework.com.comm.util.CommonExecute"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="egovframework.com.comm.util.StringUtil"%>
<script type="text/javascript">

$(document).ready(function(){
	
	sessionStorage.setItem("search_type10_checked", true);
	
	//commonSMS.init('CD21','smsWrap');
	//commonSMS.init('CD22','smsWrap');
	commonSMS.init('COMMON' , 'CD05' , 'smsWrap') ; 
	commonSMS.init('COMMON' , 'CD06' , 'smsWrap') ; 
	initView();
});

function initView() {
	//설정 미설정만 checked 해주기
	var f = document.frmSms ; 
	
	$.ajax({
		type			: 'POST',
		url				: "/ad/sms/getList.do",
		dataType	: "json",
		data			: {} ,
		success: function(data) {
 			var rowData = '';
 			if (data.resultList != null && data.resultList.length > 0) {
 				for (var i=0; i<data.resultList.length; i++) {
 					rowData = data.resultList[i];
					//CD21_0001 			
					var code_grp = common.nvl(rowData.sms_code_grp,'');
					var code = common.nvl(rowData.sms_code,'');
					var use_yn = common.nvl(rowData.use_yn,'');
					
					console.log("code_grp : " + code_grp);
					console.log("code : " + code);
					console.log("use_yn : " + use_yn);
					
					if (use_yn == 'Y') {
						$('input:radio[name='+code_grp+"_"+code+']:input[value=Y]').attr('checked',true);
					} else {
						$('input:radio[name='+code_grp+"_"+code+']:input[value=N]').attr('checked',true);
					}
 				}
 			} else {
 				$('input:radio[name^=CD]:input[value=N]').attr('checked',true);
 			}
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
}

var cur_title = '';
var cur_cntn = '';

function smsShowLayer(data) {
	//레이어 누를때 DB에서 호출 하면서 레이어 띄우기
	var f = document.frmSms ; 
	
	if (data != null && data.length > 0) {
		var dataArr = data.split("@"); 
		var sms_code_grp = dataArr[0];
		var sms_code = dataArr[1];
		$.ajax({
			type			: 'POST',
			url				: "/ad/sms/getList.do",
			dataType	: "json",
			data			: {
				sms_code_grp : sms_code_grp
				,sms_code : sms_code
			} ,
			success: function(data) {
	 			var rowData = '';
	 			var pageType = '';
	 			var title = '';
	 			var cntn = '';
	 			cur_title = '';
	 			cur_cntn = '';
	 			var title_len = 0;
	 			var cntn_len = 0;
	 			
	 			if (data.resultList != null && data.resultList.length > 0) {
	 				title = common.nvl(data.resultList[0].title,'');
	 				cntn = common.nvl(data.resultList[0].cntn,'');
	 				cur_title = title;
	 				cur_cntn = cntn;
	 				title_len = title.length;
	 				cntn_len = cntn.length;
	 			}
	 			var str = '';
	 			str +='<div id="layerForm">';
	 			str +='	<div class="box_layer layer_sms">';
	 			str +='		<h1>발송관리 작성</h1>';
	 			str +='		<div class="layer_contents" style="padding-top:15px;">';
	 			str +='			<table class="sType mgb10">';
	 			str +='				<colgroup>';
	 			str +='					<col style="width:140px;" />';
	 			str +='					<col style="width:auto;" />';
	 			str +='				</colgroup>';
	 			str +='				<caption>발송관리 작성</caption>';
	 			//str +='				<tr>';
	 			//str +='					<th scope="row">제목</th>';
	 			//str +='					<td>';
	 			//str +='						<input type="text" id="title" name="title" title="발송관리 제목" class="w405 mgr10" maxlength="50" value="'+title+'" /><span id="counter1">'+title_len+' / 50 Byte</span>';
	 			//str +='					</td>';
	 			//str +='				</tr>';
	 			//str +='				<tr>';
	 			str +='					<td colspan="2">';
	 			str +='						<textarea id="cntn" name="cntn" title="발송관리 내용" class="h170 mgb5" maxlength="50">'+cntn+'</textarea>';
	 			str +='						<div class="textR" id="counter2">'+cntn_len+' / 50 Byte</div>';
	 			str +='					</td>';
	 			str +='				</tr>';
	 			str +='			</table>';
	 			str +='			<div class="btn_wrap">';
	 			str +='				<div class="floatR">';
	 			str +='					<button type="button" class="btn_ico_reset dgray w95" onclick="smsRollback();"><span>복구</span>';
	 			str +='					</button><button type="button" class="btn_ico_confirm" onclick="smsLayerProc();"><span>저장</span></button>';
	 			str +='					<button type="button" class="btn_ico_delete" onclick="commonLayer.close();"><span>취소</span></button>';
	 			str +='					<input type="hidden" name="sms_code_grp" id="sms_code_grp" value="'+sms_code_grp+'" />';
	 			str +='					<input type="hidden" name="sms_code" id="sms_code" value="'+sms_code+'" />';
	 			str +='				</div>';
	 			str +='			</div>';
	 			str +='		</div>';
	 			str +='		<button type="button" class="btn_close" onclick="commonLayer.close();">창 닫기</button>';
	 			str +='	</div>';
	 			str +='	<div class="layer_dimmed"></div>';
	 			str +='</div>';
	 			$("#jw_contents").append(str);
	 			cntnLength();
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
	} else {
		alert('데이터가 정확하지 않습니다.');
		return;
	}
}

function smsRollback() {
	$('#title').val(cur_title);
	$('#cntn').val(cur_cntn);
}

function smsLayerProc() {
	var sms_code_grp = $('#sms_code_grp').val();
	var sms_code = $('#sms_code').val();
	var title = $('#title').val();
	var cntn = $('#cntn').val();	
	var use_yn = $('input:radio[name='+sms_code_grp+'_'+sms_code+']:checked').val();
	
	if (sms_code_grp == null && sms_code == null) return;
	
	$.ajax({
		type			: 'POST',
		url				: "/ad/sms/proc.do",
		dataType	: "json",
		data			: {
			sms_code_grp : sms_code_grp
			,sms_code : sms_code
			,title : title
			,cntn : cntn
			,pageType : 'update'
			,use_yn : use_yn
		} ,
		success: function(data) {
 			var returnCode = typeof data.returnCode != "undefined" ? data.returnCode : null ; 
 			
 			console.log(data);
 			
 			if(returnCode == "000"){
 				alert("정상처리 되었습니다.") ; 
 			}else if (returnCode == "gradeNot"){
 				alert("내부관리자와 일반사용자는 권한이 없습니다.") ;
 				return;
 			}else{
 				alert("처리도중 오류가 발생했습니다.") ;
 				return;
 			}
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
}

function smsProc() {
	var f = document.frmSms;
	
	f.pageType.value = 'insert';
	
	$.ajax({
		type			: 'POST',
		url				: "/ad/sms/proc.do",
		dataType	: "json",
		data			: $('form[name=frmSms]').serialize(),
		success: function(data) {
 			var returnCode = typeof data.returnCode != "undefined" ? data.returnCode : null ; 
 			
 			console.log(data);
 			
 			if(returnCode == "000"){
 				alert("정상처리 되었습니다.") ; 
 			}else if (returnCode == "gradeNot"){
 				alert("내부관리자와 일반사용자는 권한이 없습니다.") ;
 				return;
 			}else{
 				alert("처리도중 오류가 발생했습니다.") ;
 				return;
 			}
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
}

function cntnLength() {
    var textCountLimit = 50;
    
    $('#title').on("keyup",function() {
        var textLength = $(this).val().length;
        $('#counter1').html(textLength + ' / 50 Byte');
        if (textLength > textCountLimit) {
        	alert(textCountLimit + ' Byte 이상 입력할 수 없습니다.');
            $(this).val($(this).val().substr(0, textCountLimit));
        }
    });    
    $('#title').on('keyup',function(){});        
    
    $('#cntn').on("keyup",function() {
        var textLength = $(this).val().length;
        $('#counter2').html(textLength + ' / 50 Byte');
        if (textLength > textCountLimit) {
        	alert(textCountLimit + ' Byte 이상 입력할 수 없습니다.');
            $(this).val($(this).val().substr(0, textCountLimit));
        }
    });    
    $('#cntn').on('keyup',function(){});
}

</script>
<form name="frmSms" method="post">
<input type="hidden" name="pageType" id="pageType" />
<div class="tit_wrap">
	<%= CommonExecute.returnLineMap(request) %>
</div>
<div id="smsWrap"><!-- 레이어 생성 --></div>
<div class="btn_wrap">
	<div class="floatR">
		<button type="button" class="btn_ico_confirm" onclick="smsProc();">저장</button>
	</div>
</div>
</form>
