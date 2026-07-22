function fileDown(attach_seq , attach_ord){
	try{
		$("#fileFrm").remove() ; 
		$("#downFrame").remove() ;
	}catch(e){}
	var downFrame = $('<iframe id="downFrame" name="downFrame" style="width:0px; height=0px ; display:none;"></iframe>') ; 
	
	downFrame.appendTo("body") ;
	
	var f = $("<form></form>") ;
	f.attr('id' , 'fileFrm') ; 
	f.attr('action' , '/comm/fileDown.do') ; 
	f.attr('method' , 'post') ; 
	f.attr('target' , 'downFrame') ;
	f.appendTo("body") ;
	
	var attach_seq  = "<input type='hidden' name='attach_seq' value='"+attach_seq+"'/>" ; 
	var attach_depth  = "<input type='hidden' name='attach_ord' value='"+attach_ord+"'/>" ; 
	
	f.append(attach_seq).append(attach_depth) ; 
	f.submit() ; 
	
}

/* 발송관리 코드 호출 */
var commonSMS = {
		code_group : "",
		code : "", 
		wrap_id : "",
		init : function(code_group, code, id){
		this.code = code;
		this.wrap_id = id;
		this.code_group = code_group;
		
		commonSMS.getCode();
	},
	
	getCode : function() {
		var url = "/comm/getCode.do" ;
		$.ajax({
			type: 'POST',
			url: url,
			dataType: "json",
			async: false,
			data: {
				'code_group' : this.code_group , 	
				'p_code' : this.code 	
			} ,
			success: function(data) {
				var fullStr = '' ;
	 			var str = '';
	 			var strHead = '';
	 			var strFooter = '';
	 			var listDate= '';
	 			var rowData = '';
	 			if (data != null && data.resultList.length > 0) {
	 				
	 				if (commonSMS.code == 'CD05') {
	 					strHead +='	<div class="tit_sWrap">';
	 					strHead +='		<h3 class="tit_dot_gray">계정관련 안내 SMS</h3>';
	 					strHead +='	</div>';	 					
	 					strHead +='	<table class="sType mgb20">';
	 					strHead +='		<caption>계정관련 안내 SMS</caption>';
	 					strHead +='		<colgroup>';
	 					strHead +='			<col style="width:160px;" />';
	 					strHead +='			<col style="width:auto;" />';
	 					strHead +='		</colgroup>';	 					
	 				} else if (commonSMS.code == 'CD06') {
	 					strHead +='	<div class="tit_sWrap">';
	 					strHead +='		<h3 class="tit_dot_gray">업무 진행 단계별 안내 SMS</h3>';
	 					strHead +='	</div>';
	 					strHead +='	<table class="sType mgb20">';
	 					strHead +='		<caption>업무 진행 단계별 안내 SMS</caption>';
	 					strHead +='		<colgroup>';
	 					strHead +='			<col style="width:160px;" />';
	 					strHead +='			<col style="width:auto;" />';
	 					strHead +='		</colgroup>';
	 				}

	 				for(var i = 0 ; i < data.resultList.length ; i++){
	 					
	 					rowData = data.resultList[i];
	 					
	 					str +='		<tr>';
	 					str +="			<th scope=\"row\">"+rowData.code_name+"</th>";
	 					str +='			<td>';
	 					str +='				<input type="radio" id="code_'+rowData.p_code + '_' + rowData.code+'_1" name="'+rowData.p_code + '_' + rowData.code+'" class="mgr5" value="Y">';
	 					str +='				<label for="code_'+rowData.p_code + '_' + rowData.code+'_1" value="Y" class="mgr15">설정</label>';
	 					str +='				<input type="radio" id="code_'+rowData.p_code + '_' + rowData.code+'_2" name="'+rowData.p_code + '_' + rowData.code+'" class="mgr5" value="N">';
	 					str +='				<label for="code_'+rowData.p_code + '_' + rowData.code+'_2" value="N" class="mgr15">미설정</label>';
	 					str +="				<button type=\"button\" class=\"btn_line_gray w70\" onclick=\"smsShowLayer('"+rowData.p_code + "@" + rowData.code+"');\">본문 작성</button>";	 					
	 						 					
	 					str +='			</td>';
	 					str +='		</tr>';
	 				}
	 				strFooter += '<table>';
	 				strFooter += '<input type="hidden" name="'+rowData.p_code+'_cnt" value="'+data.resultList.length+'" />';
	 				fullStr = strHead + "" + str + "" + strFooter;
	 				$("#"+commonSMS.wrap_id).append(fullStr);
	 			}
			}
		});
	}
}

function showSaveId(elem, type) {
	elem.val(getCookie(type+"UserSaveId")); 
    if(elem.val() != "") $("#chkIdSave").attr("checked", true);
}

function chkIdSave(elem, type) {
	if($("#chkIdSave").is(":checked")) setCookie(type+"UserSaveId", elem.val(), 7);
	else deleteCookie(type+"UserSaveId");
}

function setCookie(cookieName, value, exdays){
    var exdate = new Date();
    exdate.setDate(exdate.getDate() + exdays);
    var cookieValue = escape(value) + ((exdays==null) ? "" : "; expires=" + exdate.toGMTString() + ";path=/");
    document.cookie = cookieName + "=" + cookieValue;
}
 
function deleteCookie(cookieName){
    var expireDate = new Date();
    expireDate.setDate(expireDate.getDate() - 1);
    document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString();
}
 
function getCookie(cookieName) {
    cookieName = cookieName + '=';
    var cookieData = document.cookie;
    var start = cookieData.indexOf(cookieName);
    var cookieValue = '';
    if(start != -1){
        start += cookieName.length;
        var end = cookieData.indexOf(';', start);
        if(end == -1)end = cookieData.length;
        cookieValue = cookieData.substring(start, end);
    }
    return unescape(cookieValue);
}

function calcMonth(start_date , end_date){
	
	end_date = common.replaceAll(end_date , "/" , "") ; 
	start_date = common.replaceAll(start_date , "/" , "") ; 
	
	var date1 = new Date(end_date.substr(0,4),end_date.substr(4,2)-1); 
	var date2 = new Date(start_date.substr(0,4),start_date.substr(4,2)-1);
	
	var interval = date1 - date2 ; 	
	var day = 1000 * 60 *  60 * 24 ; 
	var month = day * 30 ; 
	
	var between = parseInt(interval / month) ; 
	
	return between ; 
	
}

function addMon(month , num){
	month = common.replaceAll(month , "/" , "") ;
	
	var date1 = new Date(month.substr(0,4),month.substr(4,2)-1);
	var date2 = new Date(month.substr(0,4),month.substr(4,2)-1);
	date2.setMonth((date1.getMonth() + 1) + num) ; 
	
	var yyyy = date2.getFullYear() ; 
	var mm = date2.getMonth() ; 
	
	if(mm == "0"){
		mm = "12" ; yyyy = yyyy - 1 ; 
	}else{
		if(mm < 10) mm = "0" + mm ; 
	}
	
	return yyyy + "/" + mm ;  
}

function makeDate(secDate,sep){
	
	if(secDate == "") return "" ;
	
	if (sep == null) sep = "/";
	
	var year = secDate.substr(0,4);
	var month = secDate.substr(4,2);
	var day = secDate.substr(6,2);
	
	if (secDate.length > 6){
		return year + sep + month + sep + day ;
	}else{
		return year + sep + month ;
	}
}

function makeTime(time ){
	
	if(time == "") return "" ;
	
	var str = '' ; 
	
	if(time.length == 4) {
		var h = time.substr(0,2);
		var m = time.substr(2,2);
		
		str = h + ":" + m ; 
		
	}else if(time.length == 6) {
		var h = time.substr(0,2);
		var m = time.substr(2,2);
		var s = time.substr(4,2);
		
		str = h + ":" + m  + ":" + s; 
	}
	return str ;  
}

function onlyNumber(obj) {
    $(obj).keyup(function(){
         $(this).val($(this).val().replace(/[^0-9]/g,""));
    }); 
}

function numberWithCommas(x) {
	if (x == null) return x;
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
