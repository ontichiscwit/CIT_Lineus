
/* *
 * 공통레이어 정의
 * onclick=\"commonLayer.init('ASSIGN');\"
 * */

var commonLayer = {
	showFlag : false,
	init : function(type, callback, cnt){
		this.layer(type, cnt);
		this.confirm(callback);
	},

	/* 레이어 생성 되는 부분 */
	layer : function(type, cnt) {
		
		var str = '';
		
		$("#layerForm").remove();
		
		/* 담당자 배정 레이어 팝업 */
		str += '<div id="layerForm">';
			
		if (type=='ASSIGN') {
			str += '		<div class="box_layer layer_operator">';
			str += '		<h1>담당자 배정</h1>';
			str += '		<div class="layer_contents">';
			str += '			<div class="box_operator mgb20">';
			str += '				<dl class="floatL">';
			str += '					<dt>1. 팀 선택</dt>';
			str += '					<dd>';
			str += "					<select id=\"GETPOST\" title=\"팀 선택\" onchange=\"commonPost.getEmp('GETEMP',this.value);\">";
			str += '							<option value="">선택해주세요</option>';
			str += '						</select>';
			str += '					</dd>';
			str += '				</dl>';
			str += '				<dl class="floatR">';
			str += '					<dt>2. 인원 선택</dt>';
			str += '					<dd>';
			str += '						<select id="GETEMP" title="인원 선택">';
			str += '							<option value="">선택해주세요</option>';
			str += '						</select>';
			str += '					</dd>';
			str += '				</dl>';
			str += '			</div>';
			str += '			<div class="btn_wrap">';
			str += '				<div class="floatR">';
			str += '					<button type="button" class="btn_ico_confirm" id="confirm"><span>확인</span></button><button type="button" class="btn_ico_cancel gray layer_close" onclick="commonLayer.close();"><span>취소</span></button>';
			str += '				</div>';
			str += '			</div>';
			str += '		</div>';
			str += '		<button type="button" class="btn_close" onclick="commonLayer.close();">창 닫기</button>';
			str += '</div>';
			
		} else if (type=='CUSTNUMB') {
			
			str += '<div class="box_layer layer_trade02">';
			str += '	<h1>거래처 정보 조회</h1>';
			str += '	<div class="layer_contents">';
			str += '		사업자등록번호 : <input type="text" class="w175 mgr10" id="cust_numb" name="cust_numb" value="" title="거래처 정보 검색" /><button type="button" class="btn_ico_search mgr5" onclick="javascript:custSearch();"><span>검색</span></button>';
			str += '		<table class="mgt10 vType_line" id="cust_numb_result" style="display:none;">';
			str += '			<caption>검색 결과</caption>';
			str += '			<colgroup>';
			str += '				<col style="width:150px" />';
			str += '				<col style="width:550px" />';
			str += '			</colgroup>';
			str += '				<tr><th scope="col">사업자등록번호</th><td id="search_result1"></td></tr>';
			str += '				<tr><th scope="col">대표자명</th><td id="search_result2"></td></tr>';
			str += '				<tr><th scope="col">기관명</th><td id="search_result3"></td></tr>';
			str += '				<tr><th scope="col">주소</th><td id="search_result4"></td></tr>';
			str += '		</table>';
			str += '<div class="btn_wrap mgt5" id="cust_numb_btn1" style="display:none;">' ; 
			str += '<div class="floatR">' ; 
			str += '  <button type="button" class="btn_line_gray w60" onclick="javascript:confirmCustInfo('+cnt+');"><span>확인</span></button><button id="cust_numb_btn2" type="button" class="btn_ico_search w95" onclick="javascript:reSearch('+cnt+');" style="display:none;"><span>다시검색</span></button>' ; 
			str += '</div>' ; 
			str += '</div>' ; 
			str += '	</div>';
			str += '	<button type="button" class="btn_close" onclick="commonLayer.close();">창 닫기</button>';
			str += '</div>';
			
		} else if (type=='CUSTINFO') {
			
			str += '<div class="box_layer layer_trade02">';
			str += '	<h1>거래처 정보 조회 검색 결과</h1>';
			str += '	<div class="layer_contents">';
			str += '		기관명 : <input type="text" class="w175 mgr10" id="searchKorName" name="searchKorName" title="거래처 정보 검색" /><button type="button" class="btn_ico_search mgr5" onclick="custList(1);"><span>검색</span></button>';
			str += '		<table class="vType_line" style="margin-top: 10px;">';
			str += '			<caption>A/S 접수 목록</caption>';
			str += '			<colgroup>';
			str += '				<col style="width:50px" />';
			str += '				<col style="width:150px" />';
			str += '				<col style="width:100px" />';
			str += '				<col style="width:200px" />';
			str += '				<col style="width:200px" />';
			str += '			</colgroup>';
			str += '			<thead>';
			str += '				<tr>';
			str += '					<th scope="col">No</th>';
			str += '					<th scope="col">사업자등록번호</th>';
			str += '					<th scope="col">대표자명</th>';
			str += '					<th scope="col">기관명</th>';
			str += '					<th scope="col">주소</th>';
			str += '				</tr>';
			str += '			</thead>';
			str += '			<tbody id="custInfoList">';
			str += '			</tbody>';
			str += '		</table>';
			str += '		<div class="page" id="layer_pagination" style="margin-top: 10px;"></div>';
			str += '	</div>';
			str += '	<button type="button" class="btn_close" onclick="commonLayer.close();">창 닫기</button>';
			str += '</div>';
			
		} else if (type=='EMPINFO') {
			
			str += '<div class="box_layer layer_trade02" style="width:550px; height:550px; margin: -275px 0 0 -275px !important;">';
			str += '	<h1>거래처 직원 조회 검색 결과</h1>';
			str += '	<div class="layer_contents" style="height:550px; !important;">';
			str += '		<input type="text" class="w175 mgr10" id="search_emp_name" name="search_emp_name" title="거래처 정보 검색" style="margin-bottom: 20px;" /><button type="button" class="btn_ico_search mgr5" onclick="empList(1);" style="margin-bottom: 20px;"><span>검색</span></button>';
			str += '		<table class="mgt10 vType_line">';
			str += '			<caption>A/S 접수 목록</caption>';
			str += '			<colgroup>';
			str += '				<col style="width:50px" />';
			str += '				<col style="width:80px" />';
			str += '				<col style="width:80px" />';
			str += '				<col style="width:80px" />';
			str += '				<col style="width:150px" />';
			str += '			</colgroup>';
			str += '			<thead>';
			str += '				<tr>';
			str += '					<th scope="col">No</th>';
			str += '					<th scope="col">부서</th>';
			str += '					<th scope="col">직원명</th>';
			str += '					<th scope="col">직책</th>';
			str += '					<th scope="col">연락처</th>';
			str += '				</tr>';
			str += '			</thead>';
			str += '			<tbody id="custEmpList">';
			str += '			</tbody>';
			str += '		</table>';
			str += '		<div class="page" id="layer_pagination" style="margin-top: 10px;"></div>';
			str += '	</div>';
			str += '	<button type="button" class="btn_close" onclick="commonLayer.close();">창 닫기</button>';
			str += '</div>';
		} else if (type=='EMPINFO2') {
			
			str += '<div class="box_layer layer_trade02" style="width:550px; height:550px; margin: -275px 0 0 -275px !important;">';
			str += '	<h1>직원 조회 검색 결과</h1>';
			str += '	<div class="layer_contents" style="height:550px; !important;">';
			str += '		<input type="text" class="w175 mgr10" id="EMP_NAME" name="search_18" title="거래처 정보 검색" style="margin-bottom: 20px;" /><button type="button" class="btn_ico_search mgr5" onclick="custList(1);" style="margin-bottom: 20px;"><span>검색</span></button>';
			str += '		<table class="mgt10 vType_line">';
			str += '			<caption>A/S 접수 목록</caption>';
			str += '			<colgroup>';
			str += '				<col style="width:50px" />';
			str += '				<col style="width:100px" />';
			str += '				<col style="width:100px" />';
			str += '				<col style="width:210px" />';
			str += '			</colgroup>';
			str += '			<thead>';
			str += '				<tr>';
			str += '					<th scope="col">No</th>';
			str += '					<th scope="col">부서</th>';
			str += '					<th scope="col">직원명</th>';
			str += '					<th scope="col">연락처</th>';
			str += '				</tr>';
			str += '			</thead>';
			str += '			<tbody id="custEmpList">';
			str += '			</tbody>';
			str += '		</table>';
			str += '		<div class="page" id="layer_pagination" style="margin-top: 10px;"></div>';
			str += '	</div>';
			str += '	<button type="button" class="btn_close" onclick="commonLayer.close();">창 닫기</button>';
			str += '</div>';
			
		} else if (type=='ASDETAIL') {			
			
			str += '<div class="box_layer layer_order_list">';
			str += '	<h1>상세 처리 내역</h1>';
			str += '	<div class="layer_contents">';
			str += '		<h2 class="tit_bold mgb10">접수 처리 내역</h2>';
			str += '		<table class="hType_line">';
			str += '			<colgroup>';
			str += '				<col style="width:55px;" />';
			str += '				<col style="width:150px;" />';
			str += '				<col style="width:80px;" />';
			str += '				<col style="width:80px;" />';
			str += '				<col style="width:auto;" />';
			str += '			</colgroup>';
			str += '			<caption>접수 처리 내역</caption>';
			str += '			<thead>';
			str += '				<tr>';
			str += '					<th scope="col">No</th>';
			str += '					<th scope="col">처리일시</th>';
			str += '					<th scope="col">처리상태</th>';
			str += '					<th scope="col">처리담당자</th>';
			str += '					<th scope="col">상세 작업 내용</th>';
			str += '				</tr>';
			str += '			</thead>';
			str += '			<tbody id="asDetailList">';
			str += '			</tbody>';
			str += '		</table>';
			str += '		<div class="page" id="layer_pagination" style="margin-top: 10px;"></div>';
			str += '	</div>';
			str += '	<button type="button" class="btn_close" onclick="commonLayer.close();">창 닫기</button>';
			str += '</div>';
		} else if(type=='FRONTVIEW'){
			str += '<div class="box_layer layer_order_list">' ; 
			str += '	<h1 class="tit_back">A/S 신청내역 상세보기</h1>' ; 
			str += '	<div class="layer_contents">' ; 
			str += '		<div class="tit_sWrap">' ; 
			str += '			<h4 class="tit_bold_gray">기본 정보</h4>' ; 
			str += '		</div>' ; 
			str += '		<table class="vType_line mgb20">' ; 
			str += '			<caption>기본 정보 목록</caption>' ; 
			str += '			<colgroup>' ; 
			str += '				<col style="width:120px;" />' ; 
			str += '				<col style="width:150px;" />' ; 
			str += '				<col style="width:160px;" />' ; 
			str += '				<col style="width:160px;" />' ; 
			str += '				<col style="width:130px;" />' ; 
			str += '			</colgroup>' ; 
			str += '			<tr>' ; 
			str += '				<th scope="row">신청일</th>' ; 
			str += '				<td id="as_in_dt"></td>' ; 
			str += '				<th scope="row">처리상태</th>' ; 
			str += '				<td id="as_prg_state_nm"></td>' ; 
			str += '				<th scope="row">처리 담당자</th>' ; 
			str += '				<td id="kor_name"></td>' ; 
			str += '			</tr>' ; 
			str += '			<tr>' ; 
			str += '				<th scope="row">판매사</th>' ; 
			str += '				<td id="gubun_nm"></td>' ; 
			str += '				<th scope="row">A/S 신청 제품</th>' ; 
			str += '				<td id="matr_cate_nm">생화학분석기 /7600</td>' ; 
			str += '				<th scope="row">serial</th>' ; 
			str += '				<td id="serial_no"></td>' ; 
			str += '			</tr>' ; 
			str += '			<tr>' ; 
			str += '				<th scope="row">구매/임대일</th>' ; 
			str += '				<td id="start_date">2016-02-03</td>' ; 
			str += '				<th scope="row">연락받으실 전화번호</th>' ; 
			str += '				<td colspan="3" id="as_in_tel"></td>' ; 
			str += '			</tr>' ; 
			str += '		</table>' ; 
			str += '' ; 
			str += '		<!-- 증상 및 오류 입력 사항 -->' ; 
			str += '		<div class="tit_sWrap">' ; 
			str += '			<h4 class="tit_bold_gray">증상 및 오류 입력 사항 </h4>' ; 
			str += '		</div>' ; 
			str += '		<table class="sType mgb20">' ; 
			str += '			<caption>증상 및 오류 입력1</caption>' ; 
			str += '			<colgroup>' ; 
			str += '				<col style="width:180px;" />' ; 
			str += '				<col style="width:auto;" />' ; 
			str += '			</colgroup>' ; 
			str += '			<tr>' ; 
			str += '				<th scope="row">A/S 접수 유형<span class="request mgl5">필수 입력</span></th>' ; 
			str += '				<td>' ; 
			str += '					<select id="as_in_kind" name="as_in_kind" class="w290" title="접수 방법 선택">' ; 
			str += '						<option>기기 오류</option>' ; 
			str += '					</select>' ; 
			str += '				</td>' ; 
			str += '			</tr>' ; 
			str += '		</table>' ; 
			str += '		<strong class="tit_s_bold pdl30 mgb10 fontS_12" id="questionStrong">사용하시는 제품에 대해 아래 질문 사항을 작성 해주시면 A/S담당자가 확인합니다</strong>' ; 
			str += '		<dl class="vType_list" id="questionBody">' ; 
			str += '		</dl>' ; 
			str += '		<table class="vType_line bdt_gray mgb20">' ; 
			str += '			<caption>증상 및 오류 입력2</caption>' ; 
			str += '			<colgroup>' ; 
			str += '				<col style="width:180px;" />' ; 
			str += '				<col style="width:auto;" />' ; 
			str += '			</colgroup>' ; 
			str += '			<tr>' ; 
			str += '				<th scope="row">추가 문의 사항</th>' ; 
			str += '				<td id="as_in_bigo"></td>' ; 
			str += '			</tr>' ; 
			str += '			<tr>' ; 
			str += '				<th scope="row">첨부파일</span></th>' ; 
			str += '				<td id="fileList">' ; 
			str += '				</td>' ; 
			str += '			</tr>' ; 
			str += '		</table>' ; 
			str += '		<!--// write -->' ; 
			str += '		<div class="btn_wrap">' ; 
			str += '			<div class="btn_wrap">' ; 
			str += '				<div class="floatR">' ; 
			str += '					<button type="button" class="btn_ico_write w95 dblue" onclick="commonLayer.close();"><span>창 닫기</span></button><button type="button" class="btn_ico_delete w95 dblue" id="btn2" onclick="javascript:as.proc(\'delete\');" style="display:none;"><span>삭제</span></button>' ; 
			str += '				</div>' ; 
			str += '			</div>' ; 
			str += '		</div>' ; 
			str += '	</div>' ; 
			str += '</div>' ; 
		} else if (type=='FRONT_JOIN_CUST_NUMB') {
			str += '<div class="box_layer layer_join1" style="top:90%;">' ; 
			str += '	<div class="layer_contents">' ; 
			str += '		<h1 class="tit_search mgb10">거래처 정보 조회</h1>' ; 
			str += '		<table class="vType_line mgb20">' ; 
			str += '			<caption>거래처 정보 조회</caption>' ; 
			str += '			<colgroup>' ; 
			str += '				<col style="width:140px;" />' ; 
			str += '				<col style="width:auto;" />' ; 
			str += '			</colgroup>' ; 
			str += '			<tr>' ; 
			str += '				<th scope="row">사업자등록번호</th>' ; 
			str += '				<td>' ; 
			str += '					<input type="text" id="company1" title="사업자등록번호" placeholder="‘’-”’없이 숫자만 입력해주세요" />' ; 
			str += '				</td>' ; 
			str += '			</tr>' ; 
			str += '		</table>' ; 
			str += '		<div class="btn_wrap">' ; 
			str += '			<div class="floatR">' ; 
			str += '				<button type="button" class="btn_ico_search w95" onclick="javascript:join.searchCust();"><span>검색</span></button>' ; 
			str += '			</div>' ; 
			str += '		</div>' ; 
			str += '	</div>' ; 
			str += '	<button type="button" class="btn_close" onclick="commonLayer.close();">창 닫기</button>' ; 
			str += '</div>' ;
		} else if (type=='FRONT_JOIN_CUST_NUMB_CONFIRM') {
			str += '<div class="box_layer layer_join2" style="top:90%;">' ; 
			str += '	<div class="layer_contents">' ; 
			str += '		<h1 class="tit_search">' ; 
			str += '			거래처 정보 조회 검색 결과' ; 
			str += '		</h1>' ; 
			str += '		<p class="txt_pop_search mgb20">' ; 
			str += '			입력하신 정보와 일치하는 거래처 정보는 다음과 같습니다.<br />' ; 
			str += '			맞으면 확인을 눌러주세요' ; 
			str += '		</p>' ; 
			str += '		<table class="vType_line mgb20" id="cust_table1">' ; 
			
			str += '		</table>' ; 
			str += '		<div class="btn_wrap">' ; 
			str += '			<div class="floatR">' ; 
			str += '				<button type="button" class="btn_ico_save w95" onclick="javascript:join.confirmCust();"><span>확인</span></button><button type="button" class="btn_ico_search w95 dblue" onclick="javascript:join.reShowPop();"><span>다시검색</span></button>' ; 
			str += '			</div>' ; 
			str += '		</div>' ; 
			str += '	</div>' ; 
			str += '	<button type="button" class="btn_close" onclick="javascript:commonLayer.close();">창 닫기</button>' ; 
			str += '</div>' ; 
			
		} else if (type=='APPMATRINFO') {
			
			str += '<div class="box_layer layer_trade02">';
			str += '	<h1>장비 정보 조회 검색 결과</h1>';
			str += '	<div class="layer_contents">';
			str += '		<span style="font-weight:bold;">품목코드/품명/모델명</span> : <input type="text" class="w175 mgr10" id="searchAppName" name="searchAppName" title="장비 정보 검색" />';
			str += ' 	<button type="button" class="btn_ico_search mgr5" onclick="appInfoList();"><span>검색</span></button>';
			str += ' 	<button type="button" class="btn_ico_search mgr5" onclick="appInfoListReset();"><span>초기화</span></button>';
			str += '		<table class="vType_line" style="margin-top: 10px;">';
			str += '			<caption>장비 목록</caption>';
			str += '			<colgroup>';
			str += '				<col style="width:50px" />';
			str += '				<col style="width:150px" />';
			str += '				<col style="width:200px" />';
			str += '				<col style="width:200px" />';
			str += '			</colgroup>';
			str += '			<thead>';
			str += '				<tr>';
			str += '					<th scope="col">No</th>';
			str += '					<th scope="col">품목코드</th>';
			str += '					<th scope="col">품명</th>';
			str += '					<th scope="col">모델명</th>';
			str += '				</tr>';
			str += '			</thead>';
			str += '			<tbody id="appInfoList">';
			str += '			</tbody>';
			str += '		</table>';
			str += '		<div class="page" id="layer_pagination" style="margin-top: 10px;"></div>';
			str += '	</div>';
			str += '	<button type="button" class="btn_close" onclick="commonLayer.close();">창 닫기</button>';
			str += '</div>';
			
		}
			
		str += '<div class="layer_dimmed"></div>';
		str += '</div>';
		
		$("#jw_contents").append(str);
	},
	
	/* 확인 클릭시  */
	confirm : function(callback) {
		$('#confirm').on('click', function(){
			var callflag = false;
			if (typeof callback == 'function') {
				callflag = callback();
			}
			//callback 함수에서 true return시
			if (callflag) $("#layerForm").remove();
		});
	},
	
	/* 레이어 닫기 */
	close : function() {
		$("#layerForm").remove();
		commonLayer.showFlag = false;
	}
};