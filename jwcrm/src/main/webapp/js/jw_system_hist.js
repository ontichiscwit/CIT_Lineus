/**
 * 
 */
var systemHistArray = new Array();

var cuSystemHistSeq;

function getEmptySystemHistRow(seq, dtl_seq){
	var systemHistRow = {
			seq : seq ? seq : "341", // 고객사 정보 테이블의 seq(crm_code당 하나씩 존재)
			erp_code : "",
			dtl_seq : dtl_seq ? dtl_seq : "0", // 고객사당 존재하는 순번고유번호(테이블에는 거래처 mgt의 seq 값과 함께 pk로 적용됨)
			action_type : "I", // I : 입력 대상, U : 수정 대상, D : 삭제 대상
			group_code1 : "", // 대분류 코드
			group_code2 : "", // 중분류 코드
			group_code3 : "", // 소분류 코드
			item_nm : "", // 품목명
			reg_date : "", // 판매일자
			reg_id : "", // 등록자
			reg_nm : "", // 등록자
			etc : "", // 비고
			serial_no : "", // serial_no
	}
	
	return systemHistRow;
}

// 서버로 부터 해당 거래처의 이력을 가져와 화면에 보여준다.
function getInstallHistData(seq){
	cuSystemHistSeq = seq;
	
	$.ajax({
		type			: 'POST',
		url				: '/ad/cust/getInstallHist.do',
		dataType		: "json",
		async 			: false,
		data			: {'seq' : seq},
		success: function(data) {
			console.log(data);
			systemHistArray = typeof data.resultList != "undefined" ? data.resultList : null;
			systemHistDraw();
		}
	});
}

// 기 그려지 그리드 목록에 한출 추가할때 사용
function systemHistAppend(seq){
	
	if ($("#depth1Fillter").val() !="TOT") {
		$("#depth1Fillter").val("TOT");
		$("#depth1Fillter").change();
	};
	
	inputToData();
	addSystemHistRow(seq, getNextDtlSeq());
	systemHistDraw();
}

function systemHistDraw(){
	$("#lineusHistList").html(getSystemHistHtml());
	
	for (var i=0; i < systemHistArray.length; i ++){
		
		var jObj = $("#histRow_" + systemHistArray[i].dtl_seq+" select[name='depth1']");
		setHistOption(treeCodeDepth1, jObj);
		jObj.val(systemHistArray[i].group_code1);
		jObj.change();
		
		jObj = $("#histRow_" + systemHistArray[i].dtl_seq+" select[name='depth2']");
		jObj.val(systemHistArray[i].group_code2);
		jObj.change();
		
		jObj = $("#histRow_" + systemHistArray[i].dtl_seq+" select[name='depth3']");
		jObj.val(systemHistArray[i].group_code3);
	}
}

function valueChange(obj, targetDepth){
	console.log("valueChange --> " + $(obj).parent().parent().find("select[name='depth"+targetDepth+"']:first").html());
	
	var pCode = obj.value;
	var jObj = $(obj).parent().parent().find("select[name='depth"+targetDepth+"']:first");
	
	if (obj.value == null || obj.value == "") {
		jObj.html("<option value=''>선택해주세요.</option>");
		jObj.change();
		return;
	}
	
	getSystemHistDepthCode(pCode,jObj);
	jObj.val("");
	jObj.change();
}

function getSystemHistDepthCode(pCode, jObj){
	$.ajax({
		type			: 'POST',
		url				: '/comm/getCode2.do',
		dataType		: "json",
		async 			: false,
		data			: {'p_code' : pCode},
		success: function(data) {
			if (data.resultList != "undefined"){
				setHistOption(data.resultList, jObj);
			}
		}
	});
}

function addSystemHistRow(seq, dtl_seq, obj){
	if (obj == null){
		systemHistArray.push(getEmptySystemHistRow(seq, dtl_seq));
	}else{
		systemHistArray.push(obj);
	}
}

function getSystemHistHtml(){
	console.log("systemHistArray >>> " + systemHistArray);
	
	if (systemHistArray == 'undefined' || systemHistArray == null) return;
	
	var str = "";
	
	for (var i=0; i < systemHistArray.length; i ++){
		
		if ($("#depth1Fillter").val() != "TOT" && $("#depth1Fillter").val() !== systemHistArray[i].group_code1) continue;
		
		if (systemHistArray[i].action_type == "U"){
			str += '<tr id="histRow_'+systemHistArray[i].dtl_seq+'">';
			str += '	<td><input type="checkbox" name="checkBox" onclick="histCheckChange(this)"></td>';
			str += '	<td>';
			str += '		<select name="depth1" disabled onchange="valueChange(this,2)">';
			str += '			<option value="">선택해주세요</option>';
			str += '		</select>';
			str += '	</td>';
			
			str += '	<td>';
			str += '		<select name="depth2" disabled onchange="valueChange(this,3)">';
			str += '			<option value="">선택해주세요</option>';
			str += '		</select>';
			str += '	</td>';
			
			str += '	<td>';
			str += '		<select name="depth3" disabled>';
			str += '			<option value="">선택해주세요</option>';
			str += '		</select>';
			str += '	</td>';
			
			//str += '	<td>';
			//str += '		<input type="text" name="item_nm" value="'+systemHistArray[i].item_nm+'" readonly=readonly>';
			//str += '	</td>';
			str += '	<td><input type="text" name="etc" value="'+systemHistArray[i].etc+'" readonly=readonly></td>';
			str += '	<td>'+systemHistArray[i].reg_date+'</td>';
			str += '	<td>'+systemHistArray[i].reg_nm+'</td>';
			//str += '	<td><input type="text" name="serial_no" value="'+systemHistArray[i].serial_no+'" readonly=readonly></td>';
			//str += '	<td><input type="text" name="etc" value="'+systemHistArray[i].etc+'" readonly=readonly></td>';
			
		}else if (systemHistArray[i].action_type == "I"){
			
			str += '<tr id="histRow_'+systemHistArray[i].dtl_seq+'">';
			str += '	<td><input type="checkbox" name="checkBox" onclick="histCheckChange(this)" checked=checked></td>';
			str += '	<td>';
			str += '		<select name="depth1" onchange="valueChange(this,2)">';
			str += '			<option value="">선택해주세요</option>';
			str += '		</select>';
			str += '	</td>';
			
			str += '	<td>';
			str += '		<select name="depth2" onchange="valueChange(this,3)">';
			str += '			<option value="">선택해주세요</option>';
			str += '		</select>';
			str += '	</td>';
			
			str += '	<td>';
			str += '		<select name="depth3">';
			str += '			<option value="">선택해주세요</option>';
			str += '		</select>';
			str += '	</td>';
			
			//str += '	<td>';
			//str += '		<input type="text" name="item_nm" value="'+systemHistArray[i].item_nm+'">';
			//str += '	</td>';
			str += '	<td><input type="text" name="etc" value="'+systemHistArray[i].etc+'"></td>';
			str += '	<td>'+systemHistArray[i].reg_date+'</td>';
			str += '	<td>'+systemHistArray[i].reg_nm+'</td>';
			//str += '	<td><input type="text" name="serial_no" value="'+systemHistArray[i].serial_no+'"></td>';
			//str += '	<td><input type="text" name="etc" value="'+systemHistArray[i].etc+'"></td>';
		}else {
			str += '<tr id="histRow_'+systemHistArray[i].dtl_seq+'" style="display:none">';
			str += '<td></td>'
		}
		str += '</tr>';
	}
	
	console.log(str);
	
	return str;
}

function setHistOption(list, jObj){

	var str = '<option value="">선택해주세요.</option>';
	for (var i = 0; i < list.length; i++) {
		var datas = list[i];
		str += '<option value="' + common.nvl(datas.code, '') + '">' + common.nvl(datas.code_nm, '') + '</option>';
	}
	jObj.empty().append(str);
}

function removeHistRow() {
	if ($('#lineusHistList input[type=checkbox]:checked').length == 0) {
		alert('삭제하실 행을 체크해 주세요.');
		return;
	}
	$('#lineusHistList input[type=checkbox]:checked').each(
			function() {
				$(this).prop("checked", false);
				var dtlSeq = $(this).parent().parent().attr('id').replace('histRow_','');
				// 데이터의 action_type을 D로 교체한다.
				changeActionType(dtlSeq, 'D');
				$(this).parent().parent().hide();
			});
	
	console.log(JSON.stringify(systemHistArray));
}

function changeActionType(dtlSeq, action_type){
	if (systemHistArray == "undefined" || systemHistArray == null) return;
	
	for (var i=0; i < systemHistArray.length; i++){
		if (systemHistArray[i].dtl_seq == dtlSeq){
			systemHistArray[i].action_type = action_type;
			return;
		}
	}
}

function histCheckChange(obj){
	if ($(obj).prop("checked")){
		$(obj).parent().parent().find("select").removeAttr("disabled");
		$(obj).parent().parent().find("input[type='text']").removeAttr("readonly");
	}else{
		$(obj).parent().parent().find("select").attr("disabled","disabled");
		$(obj).parent().parent().find("input[type='text']").attr("readonly","readonly");
	}
}


function inputToData(){
	if (systemHistArray == "undefined" || systemHistArray == null){
		return;
	}
	
	for (var i=0; i < systemHistArray.length; i++){
		var idStr = "histRow_" + systemHistArray[i].dtl_seq;

		systemHistArray[i].group_code1 = $('#' + idStr).find("select[name='depth1']:first").val(); 
		systemHistArray[i].group_code2 = $('#' + idStr).find("select[name='depth2']:first").val();
		systemHistArray[i].group_code3 = $('#' + idStr).find("select[name='depth3']:first").val();
		systemHistArray[i].item_nm = $('#' + idStr).find("input[name='item_nm']:first").val();
		systemHistArray[i].serial_no = $('#' + idStr).find("input[name='serial_no']:first").val();
		systemHistArray[i].etc = $('#' + idStr).find("input[name='etc']:first").val();
	} // end of for
}

function histMultiSave(){
	if (systemHistArray == "undefined" || systemHistArray == null){
		alert('저장할 데이터가 없습니다.');
		return;
	}
	
	inputToData();
	
	// validation check !!
	for (var i=0; i < systemHistArray.length; i++){
		
		if (systemHistArray[i].action_type == "D") continue;
		
		var idStr = "histRow_" + systemHistArray[i].dtl_seq;
		if (common.nvl(systemHistArray[i].group_code1,"") == ""){
			alert('대분류를 선택하세요');
			$('#' + idStr).find("select[name='depth1']:first").focus();
			return;
		}
		
		if (common.nvl(systemHistArray[i].group_code2,"") == ""){
			alert('중분류를 선택하세요');
			$('#' + idStr).find("select[name='depth2']:first").focus();
			return;
		}
		
		if (common.nvl(systemHistArray[i].group_code3,"") == ""){
			alert('소분류를 선택하세요');
			$('#' + idStr).find("select[name='depth3']:first").focus();
			return;
		}
		
		if (common.nvl(systemHistArray[i].etc,"") == ""){
			alert('내용을 입력하세요');
			$('#' + idStr).find("input[name='etc']:first").focus();
			return;
		}
	} // end of for

	var sendObj = new Object();
	sendObj.list = systemHistArray;
	var sendData = JSON.stringify(sendObj);
	console.log(sendData);

	$.ajax({
		type : 'post',
		url : '/ad/cust/histMultiSave.do',
		data : sendData,
		dataType : 'json',
		contentType : 'application/json; charset=UTF-8',
		error : function(xhr, status, error) {
			if (common.nvl(error, "") != "")
				alert(error);
		},
		success : function(data) {
			console.log(data);
			if (data.resultCode == "000"){
				// 데이터 다시 받아서 그리기
			}else{
				// 오류문구 화면 출력
				alert(data.errorMsg);
			}
			
			getInstallHistData(cuSystemHistSeq);
		}
	});
	
}

function getNextDtlSeq(){
	if (systemHistArray == "undefined" || systemHistArray == null){
		return 1;
	}
	
	var reValue = 0;
	for (var i=0; i < systemHistArray.length; i++){
		if (reValue < systemHistArray[i].dtl_seq) reValue = systemHistArray[i].dtl_seq;
	}
	
	reValue++;
	
	return reValue; 
}