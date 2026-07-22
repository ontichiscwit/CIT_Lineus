<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@page import="egovframework.com.comm.util.CommonExecute"%>

<script type="text/javascript" src="/js/jw_system_hist.js"></script>

<style>
.scrolltbody {
	display: block;
	width: 350px;
}

.scrolltbody tbody {
	display: block;
	height: 300px;
	overflow: auto;
}

.scrolltbody th:nth-of-type(1), .scrolltbody td:nth-of-type(1) {
	width: 180px;
}

.scrolltbody th:nth-of-type(2), .scrolltbody td:nth-of-type(2) {
	width: 50px;
}

.scrolltbody th:last-child {
	width: 120px;
}

.scrolltbody td:last-child {
	width: calc(120px - 22px);
}
.scrolltbody td:last-child {
	width: 100px;
}

.scrolltbody td {
	padding: 5px 2px;
	height: 20px
}

.selected {
    background: #F0F0F0;
    border-color: #46b8da;
}

</style>

<script type="text/javascript">
	var code_data1, code_data2, code_data3, code_data4;
	var treeCodeDepth1, treeCodeDepth2, treeCodeDepth3 

	$(document).ready(function() {
		/**	거래처 정보 가져오기		*/
		makeGroupList('1');
		/**	대분류						*/
		makeGroupList('2');
		/**	중분류						*/
		makeGroupList('3');
		/**	소분류						*/
		makeGroupList('4');
		/**	품목명						*/

		// 1depth 신규코드 가져온다.
		commonCode.getCodeTreeList('ROOT', 'setTreeCodeDepth1');
		
		initView();
		
		// 서버에서 lineus install 이력을 가져온다.
		getInstallHistData('${ vo.seq }');
	});
	
	function setTreeCodeDepth1(data){
		treeCodeDepth1 = typeof data.resultList != "undefined" ? data.resultList : null;
		console.log(treeCodeDepth1);
	}
	function setTreeCodeDepth2(data){
		treeCodeDepth2 = typeof data.resultList != "undefined" ? data.resultList : null;
	}
	function setTreeCodeDepth3(data){
		treeCodeDepth3 = typeof data.resultList != "undefined" ? data.resultList : null;
	}
	
	function viewCode(data){
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null;
		
		console.log(resultList);
	}

	function initView() {
		if (common.nvl('${vo.seq}', '') == '') {
			alert('관리정보를 등록해 주세요.');
			location.href = '/ad/cust/form.do';
			return;
		}

		var datas = {
			'seq' : $('#seq').val()
		};
		common.ajaxCall(datas, '/ad/cust/getProjectCnt.do', 'setProjectCnt');

		var datas = {
			'seq' : '${ vo.seq }'
			,'erp_code' : '${ vo.erp_code}'
		};
		common.ajaxCall(datas, '/ad/cust/getForm4List.do', 'drawInstallRow');
		
		// 대분류 필터 값 셋팅
		var str = '<option value="TOT">전체 선택</option>';
		for (var i = 0; i < treeCodeDepth1.length; i++) {
			var datas = treeCodeDepth1[i];
			str += '<option value="' + common.nvl(datas.code, '') + '">' + common.nvl(datas.code_nm, '') + '</option>';
		}
		$("#depth1Fillter").empty().append(str);
	}

	var projectCnt = 0;
	function setProjectCnt(data) {
		projectCnt = typeof data.cnt != 'undefined' ? data.cnt : 0;
	}

	function drawInstallRow(data) {
		var resultList = typeof data.resultList != "undefined" ? data.resultList
				: null;

		if (resultList != null && resultList.length > 0) {
			for(var i = 0 ; i < resultList.length ; i++){
				var datas = resultList[i] ;
				var str ='';
				
				str += '<tr>';
				str += '	<td>';
				str += 		getCodeNm(code_data1,datas.group_code1);
				str += '	</td>';
				str += '	<td>';
				str += 		getCodeNm(code_data2,datas.group_code2);
				str += '	</td>';
				str += '	<td>';
				str += 		getCodeNm(code_data3,datas.group_code3);
				str += '	</td>';
				str += '	<td>';
				str += 		getCodeNm(code_data4,datas.matr_code);
				str += '	</td>';
				
				var reg_date = common.nvl(datas.reg_date, '') ; 
				
				if(reg_date != "") {
					if(reg_date.length == 8) reg_date = makeDate(reg_date) ;
				}else{
					reg_date = "-" ; 
				}

				str += '	<td id="reg_date'+(i+1)+'">'+reg_date+'</td>';
				str += '	<td id="reg_id'+(i+1)+'">'+common.nvl(datas.emp_nm, '')+'</td>';
				str += '</tr>';
				
				$('#inst_wrap').append(str);

			}
		}
	}

	function makeGroupList(thisObj) {
		var datas = {
			'base_cd_grp' : (thisObj == '1' ? 'CM0004'
					: thisObj == '2' ? 'CM0005' : thisObj == '3' ? 'CM0006'
							: '')
		};
		common.ajaxCall2(datas, thisObj, '/ad/cust/getGroupCode.do',
				'drawGroupList');
	}

	function drawGroupList(data , target){
		var str = '' ; 
		var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
				
		if(target == '1'){
			code_data1 = resultList;
		}else if(target == '2'){
			code_data2 = resultList;
		}else if(target == '3'){
			code_data3 = resultList;
		}else if(target == '4'){
			code_data4 = resultList;
		}
	}
	
	function getCodeNm(obj, code){
		
		for (var i=0; obj != null && i < obj.length; i++){
			if (obj[i].base_cd == code) return obj[i].base_cd_nm; 
		}
	}

	function moveTab(gubun) {
		if (projectCnt == 0 && gubun == '3') {
			alert('프로젝트 정보를 등록해 주세요.');
			return;
		}
		location.href = "/ad/cust/form" + gubun + ".do${ QUERYSTRING }";
	}

	function goList() {
		var f = document.procFrm;
		f.action = '/ad/cust/list.do' + window.location.search.substring();
		f.submit();
	}
	
	function showPopCodeModify(data){
		$("#div_dim").css("z-index",300);
		$("#popCodeModify").show();
	}
	
	function hidePopCodeModify(){
		$("#div_dim").css("z-index",100);
		$("#popCodeModify").hide();
	}
	
	function closeLayer(){
		$('#popCodeManage').hide();
	}
	
////////////////////////////////////////////////////////////////////////////////////
// 코드관리 팝업 관련 스크립트
////////////////////////////////////////////////////////////////////////////////////
	var treeCode1, treeCode2, treeCode3;
	var cuDepth1P = 'ROOT';
	var cuDepth2P = '';
	var cuDepth3P = '';
	
	function showPopCodeManage() {
		
		$('#codeViewLevel1').html('');
		$('#codeViewLevel2').html('');
		$('#codeViewLevel3').html('');
		
		treeCode1 = null;
		treeCode2 = null
		treeCode3 = null;
		cuDepth2P = '';
		cuDepth3P = '';
		
		$('#popCodeManage').find('input[type=text]').val('');
		
		$('#popCodeManage').show();
		$('#div_dim').show();
		setCodeData(cuDepth1P,1);
	}
	
	function closePopCodeManage() {
		$('#popCodeManage').hide();
		$('#div_dim').hide();

	}
	
	function setCodeData(pCode, depth){
		commonCode.getCodeTreeList(pCode, 'initTreeCode' + depth);
	}
	
	function initTreeCode1(data){
		
		treeCode1 = typeof data.resultList != "undefined" ? data.resultList : null;
		reDrawTreeCode("codeViewLevel1");
	}
	
	function initTreeCode2(data){
		treeCode2 = typeof data.resultList != "undefined" ? data.resultList : null;
		reDrawTreeCode("codeViewLevel2");
	}
	
	function initTreeCode3(data){
		treeCode3 = typeof data.resultList != "undefined" ? data.resultList : null;
		reDrawTreeCode("codeViewLevel3");
	}
	
	function setPCode(obj, level, code){
		if (level == 0){
			cuDepth2P = code;
			setCodeData(cuDepth2P,2);
			
			// 첫번째 뎁스 선택시에 마지막 뎁스의 내용을 지운다. 
			cuDepth3P = "";
			$('#codeViewLevel3').html("");
			
		}else if(level == 1){
			
			cuDepth3P = code;
			setCodeData(cuDepth3P,3);
		}

		$(obj).addClass("selected");                     
	    $(obj).siblings().removeClass("selected"); 
	}
	
	function reDrawTreeCode(id){
		var tmpCodeData;
		if (id == 'codeViewLevel1'){
			tmpCodeData = treeCode1;
		}else if (id == 'codeViewLevel2'){
			tmpCodeData = treeCode2;
		}else if (id == 'codeViewLevel3'){
			tmpCodeData = treeCode3;
		}
		
		if (tmpCodeData == "undefined" || tmpCodeData == null){
			return;
		}
		
		var str = "";
		
		for(var i=0; i < tmpCodeData.length; i++){
			str += '<tr onclick="setPCode(this,\''+tmpCodeData[i].level+'\',\''+tmpCodeData[i].code+'\')">';
			str += '	<td>';
			str += '		<input type="text" class="w180 mgr5" value="'+tmpCodeData[i].code_nm+'" readonly="readonly"/>';
			str += '	</td>';
			str += '	<td>';
			if (tmpCodeData[i].use_yn == 'Y') str += '		<input type="checkbox" checked="checked" disabled="disabled"/>';
			else  str += '		<input type="checkbox" disabled="disabled"/>';
			str += '	</td>';
			str += '	<td>';
			str += '		<button type="button" class="modify_code_btn" onclick ="modifyRow(this,\''+tmpCodeData[i].code+'\','+tmpCodeData[i].level+');" ></button>';
			str += '		<button type="button" class="delete_code_btn" onclick="deleteRow(this,\''+tmpCodeData[i].code+'\','+tmpCodeData[i].level+');"></button>';
			str += '	</td>';
			str += '</tr>';
		}
		
		$("#"+id).html(str);
	}
	
	function deleteRow(obj, code, level){
		
		if (!confirm("삭제하시겠습니까?")) return;
		
		var datas = "code=" + code;
		var depth = level + 1;
		var pCode;
		if (depth == 1) pCode = cuDepth1P;
		else if (depth == 2) pCode = cuDepth2P;
		else if (depth == 3) pCode = cuDepth3P;
		
		$.ajax({
			type			: 'POST',
			url				: '/comm/delCode2.do',
			dataType		: "json",
			async 			: false,
			data			: datas,
			success: function(data) {
				
				if (data.returnCode == "000"){
					alert('삭제되었습니다.');
					
					$(obj).parent().parent('tr').remove();
					setCodeData(pCode,depth);
					
					if (depth == 1){
						cuDepth2P = "";
						$('#codeViewLevel2').html("");
					}else if (depth == 2){
						cuDepth3P = "";
						$('#codeViewLevel3').html("");
					}
					
				}else{
					alert('삭제되지 않았습니다.\r\n하위코드 존재시에는 삭제되지 않습니다.');
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
	
	function modifyRow(obj, code, level){
		
		var readonly = $(obj).parent().siblings().find('input[type=text]').prop('readonly');
		
		if (readonly){
			$(obj).parent().siblings().find('input[type=text]').prop('readonly',false);
			$(obj).parent().siblings().find('input[type=checkbox]').prop('disabled',false);
			$(obj).attr('class','add_code_btn');	
		}else{
			// 수정.
			
			var code_nm = $(obj).parent().siblings().find('input[type=text]').val();
			var use_yn = $(obj).parent().siblings().find('input[type=checkbox]').prop("checked") ? 'Y' : 'N';
			
			$(obj).parent().siblings().find('input[type=text]').prop('readonly',true);
			$(obj).parent().siblings().find('input[type=checkbox]').prop('disabled',true);
			$(obj).attr('class','modify_code_btn');
			
			$(obj).parent().siblings().find('input[type=text]').val('');
			
			if (!confirm('수정하시겠습니까?')) {
				return;
			}
			
			var depth = level + 1;
			var pCode;
			
			if (depth == 1) pCode = cuDepth1P;
			else if (depth == 2) pCode = cuDepth2P;
			else if (depth == 3) pCode = cuDepth3P;
			
			var datas = "code=" + code + "&code_nm=" + code_nm + "&use_yn=" + use_yn + "&p_code=" + pCode;
			
			$.ajax({
				type			: 'POST',
				url				: '/comm/modCode2.do',
				dataType		: "json",
				async 			: false,
				data			: datas,
				success: function(data) {
					alert('수정되었습니다.');
					setCodeData(pCode,depth);
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
	}
	
	function addNewRow(obj, depth){
		var pCode;
		if (depth == 1) pCode = cuDepth1P;
		else if (depth == 2) pCode = cuDepth2P;
		else if (depth == 3) pCode = cuDepth3P;
		
		var code_nm = $(obj).siblings('input[type=text]').val();
		
		if (pCode == null || pCode == ''){
			alert('좌측에서 상위 코드를 선택하세요');
			return;
		}
		
		if (code_nm == null || code_nm == ''){
			alert('추가할 코드명을 입력하세요.');
			return;
		}
		
		if (!confirm(code_nm + "으로 하단에 코드를 추가 합니다.")) return;
		
		var datas = "p_code=" + pCode;
		datas += "&code_nm=" + code_nm;

		$.ajax({
			type				: 'POST',
			url				: '/comm/regCode2.do',
			dataType		: "json",
			async 			: false,
			data			: datas,
			success: function(data) {
				console.log(data);
				$(obj).siblings('input[type=text]').val("");
				setCodeData(pCode,depth);
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
	
</script>

<div class="tit_wrap">
	<%-- <%=CommonExecute.returnLineMap(request)%> --%>
	<h2 class="tit_ico_customer">거래처 관리<span class="tit_depth mgl20 mgt8">시스템이력</span></h2>
</div>
<div class="tit_sWrap">
	<h3 class="tit_dot_gray">
		거래처 상세 정보
		<c:if test="${ vo.pageType ne 'insert' }">&nbsp;&lt;<span
				class="colorBlue mg15" style="line-height: 25px;">${ vo.cust_kor_name },
				${ vo.crm_code }</span>&gt;</c:if>
	</h3>
</div>
<!-- tab -->
<ul class="tab_line list7 mgb20">
	<li><a href="javascript:moveTab('');">관리 정보</a></li>
	<!-- 활성시 current -->
	<li><a href="javascript:moveTab('2');">프로젝트 정보</a></li>
	<li><a href="javascript:moveTab('3');">운영 정보</a></li>
	<li class="active"><a href="javascript:moveTab('4');">시스템 이력</a></li>
	<li><a href="javascript:moveTab('5');">유지보수 이력</a></li>
	<li><a href="javascript:moveTab('7');">매출 이력(부가솔루션)</a></li>
	<li><a href="javascript:moveTab('6');">문서관리</a></li>
</ul>
<!--// tab -->
<!-- list erp -->
<div class="tit_sWrap">
	<h4 class="tit_dot_gray">ERP 시스템 이력</h4>
</div>
<table class="hType mgb20">
	<caption>설치 이력</caption>
	<colgroup>
		<col style="width: 120px" />
		<col style="width: 120px" />
		<col style="width: 120px" />
		<col style="width: auto" />
		<col style="width: 80px" />
		<col style="width: 80px" />
	</colgroup>
	<thead>
		<tr>
			<th scope="col">대분류</th>
			<th scope="col">중분류</th>
			<th scope="col">소분류</th>
			<th scope="col">품목명</th>
			<th scope="col">판매일자</th>
			<th scope="col">등록자</th>
		</tr>
	</thead>
	<tbody id="inst_wrap"></tbody>
</table>

<!-- list lineus-->
<div style="margin-top: 40px" class="tit_sWrap">
	<h4 class="tit_dot_gray">LINEUS 시스템 이력</h4>
</div>
<div class="tit_bWrap mgb10">
	<span class="floatL">
		<span style="padding-right:5px">대분류 필터 : </span><span><select id="depth1Fillter" onchange="systemHistDraw()">
		</select></span>
	</span>
	<span class="floatR">
		<button class="btn_ico_circle_plus_g mgr5" onclick="showPopCodeManage()">
			<span>코드관리</span>
		</button>
		<button class="btn_ico_circle_plus_g mgr5" onclick="systemHistAppend('${vo.seq}');">
			<span>행추가</span>
		</button>
		<button class="btn_ico_stop_g" onclick="removeHistRow();">
			<span>행삭제</span>
		</button>
	</span>
</div>

<form name="procFrm" method="post" onsubmit="return false;">
	<input type="hidden" name="seq" id="seq" value="${ vo.seq }" /> <input
		type="hidden" name="pageType" id="pageType" value="${ vo.pageType }" />
	<input type="hidden" name="ins_cnt" id="ins_cnt" value="" /> <input
		type="hidden" name="del_dtl_seq" id="del_dtl_seq" />

	<table class="hType mgb20">
		<caption>설치 이력</caption>
		<colgroup>
			<col style="width: 35px" />
			<col style="width: 120px" />
			<col style="width: 120px" />
			<col style="width: 120px" />
			<col style="width: auto" />
			<col style="width: 120px" />
			<col style="width: 80px" />
		</colgroup>
		<thead>
			<tr>
				<th scope="col">선택</th>
				<th scope="col">대분류</th>
				<th scope="col">중분류</th>
				<th scope="col">소분류</th>
				<th scope="col">내용</th>
				<th scope="col">등록일시</th>
				<th scope="col">등록자</th>
				
			</tr>
		</thead>
		<tbody id="lineusHistList"></tbody>
	</table>
	<!--// list -->
	<div class="btn_wrap">
		<div class="floatL">
			<button type="button" class="btn_ico_list" onclick="goList();">
				<span>목록</span>
			</button>
		</div>
		<div class="floatR">
			<button type="button" class="btn_ico_confirm" onclick="histMultiSave();">
				<span>저장</span>
			</button>
			<button type="button" class="btn_ico_cancel" onclick="goList();">
				<span>취소</span>
			</button>
		</div>
	</div>


	<!-- 코드관리 팝업 -->
	<div id="popCodeManage" style="display: none;">
		<div class="box_layer layer_sms" id="" style="width: 1138px; height: 600px; margin: -200px 0 0 -600px; margin-top: -400px;">
			<h1>품목 코드관리</h1>
			<div class="layer_contents" style="padding-top: 20px; height: auto;">
				<div class="floatWrap"></div>
				<div class="floatL w350 mgr20 mgb30">
					<h4>[대분류]</h4>
					<div class="floatL" style="margin-bottom: 10px;">
						품목명: <input type="text" class="w210 mgr10" title="대분류명">
						<button type="button" class="btn_ico_search mgr5"  onclick= "addNewRow(this,'1');">
							<span>추가</span>
						</button>
					</div>
					<table class="hType scrolltbody">
						<caption>대분류</caption>
						<thead>
							<tr>
								<th>품목명</th>
								<th>사용여부</th>
								<th>저장/수정</th>
							</tr>
						</thead>
						<tbody style="overflow-y: auto; height: 300px;" id="codeViewLevel1">
						</tbody>
					</table>
				</div>
				<div class="floatL w350 mgr20 mgb30">
					<h4>[중분류]</h4>
					<div class="floatL" style="margin-bottom: 10px;">
						품목명: <input type="text" class="w210 mgr10" title="대분류명">
						<button type="button" class="btn_ico_search mgr5" onclick="addNewRow(this,'2');">
							<span>추가</span>
						</button>
					</div>

					<table class="hType scrolltbody">
						<thead>
							<tr>
								<th>품목명</th>
								<th>사용여부</th>
								<th>수정</th>
							</tr>
						</thead>
						<tbody style="overflow-y: auto; height: 300px;" id="codeViewLevel2">
						</tbody>
					</table>
				</div>
				<div class="floatL w350 mgb30">
					<h4>[소분류]</h4>
					<div class="floatL" style="margin-bottom: 10px;">
						품목명: <input type="text" class="w210 mgr10" title="대분류명">
						<button type="button" class="btn_ico_search mgr5"  onclick="addNewRow(this,'3');">
							<span>추가</span>
						</button>
					</div>

					<table class="hType scrolltbody">
						<thead>
							<tr>
								<th>품목명</th>
								<th>사용여부</th>
								<th>수정</th>
							</tr>
						</thead>
						<tbody style="overflow-y: auto; height: 300px;" id="codeViewLevel3">							
						</tbody>
					</table>
				</div>

				<div class="btn_wrap">
					<div class="floatR">
						<button type="button" class="btn_ico_cancel dgray"
							onclick="closeLayer();">
							<span>닫기</span>
						</button>
					</div>
				</div>

			</div>
			<button type="button" class="btn_close" onclick="closeLayer();">창
				닫기</button>
		</div>
		<div class="layer_dimmed" style="display:none;" id="div_dim"></div>
	</div>



</form>

