﻿<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ page import="egovframework.com.comm.util.StringUtil"%>
<%@ page import="egovframework.com.comm.util.DateTimeUtil"%>
<%@ page import="egovframework.com.comm.model.UserVO"%>
<%@ page import="java.util.List"%>
<%@ page import="egovframework.com.comm.model.RoleVO"%>
<%
	/*세션-로그인한 사용자의 권한코드 가져오기*/
	List<RoleVO> roleList = (List<RoleVO>) session.getAttribute("roleList");
	String role_code = ""; //세션 권한코드

	for (int i = 0; i < roleList.size(); i++) {
		role_code += roleList.get(i).getRole_code() + " ";
	}
%>
<style>
.custom-combobox {
	position: relative;
	display: inline-block;
}

.custom-combobox-toggle {
	position: absolute;
	top: 0;
	bottom: 0;
	margin-left: -1px;
	padding: 0;
}

.custom-combobox-input {
	margin: 0;
	padding: 5px 10px;
	width: 120px;
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
	var isTeamLead = false;
	var isDeployment = false;
	var proc_status_current = '';
	var aprv_status_teamLead = '';
	var aprv_status_Deployment = '';
	var appr_emp1 = '';
	var appr_emp2 = '';
	var appr_date1 = '';
	var appr_date2 = '';
	var appr_em_nm_1 = '';
	var appr_em_nm_2 = '';
	var current_file = '';
	var role_code = '<%=role_code%>';

	//로그인 정보
	//<% UserVO userInfo = session.getAttribute("adUserInfo") != null ?  (UserVO) session.getAttribute("adUserInfo") : null ; %>
	//var userId = <%= userInfo.getEmp_no() %>;
	var userId = '${adUserInfo.emp_no }';

	$(document).ready(
			function() {

				/**	공통 코드 처리		*/
				commonCode.getCodeList('AS', 'CD02', 'accept_route');
				/**	접수 경로		*/
				commonCode.getCodeList('AS' , 'CD01' , 'proc_status') ;
				/**	처리상태		*/
				commonCode.getCodeList('AS', 'CD03', 'request_type');
				/**	문의유형		*/
				commonCode.getCodeList('AS', 'CD04', 'inportance');
				/**	중요도		*/
				commonCode.getCodeList('AS', 'CD07', 'proc_grade');
				/**	처리등급		*/
				commonCode.getCodeList('AS', 'CD05', 'cause_type');
				/**	원인유형		*/
				commonCode.getCodeList('AS', 'CD06', 'action_type');
				/**	조치유형		*/
				commonCode.getCodeList('AS', 'CD10', 'cmc_pic');
				/**	CMC담당자		*/
				commonCode.getCodeList('AS', 'CD11', 'program_satisfaction');
				/**	CMC 작업만족도	*/
				commonCode.getCodeList('AS', 'CD12', 'module_name');
				/**	모듈	*/

				commonCode.getCodeList('AS', 'CD08', 'proc_gubun');
				/**	처리구분		*/
				
				var plus3days = new Date();
				plus3days.setDate(plus3days.getDate() + 3); // 현재 날짜에서 3일 더함
				$("#proc_dt").val(
						  $.datepicker.formatDate('yy/mm/dd', plus3days)
						).datepicker(datepicker);

				$('#btnReSendEmail').hide();
				$('#inquiry_type').append(commonCode.defaultViewOption); /* 업무유형 디폴트  */
				$('#system_type').append(commonCode.defaultViewOption); /* 시스템유형 디폴트  */
				$("#inquiry_dt").val(
						$.datepicker.formatDate('yy/mm/dd', new Date()))
						.datepicker(datepicker);
				$("#complete_dt").datepicker(datepicker);
				$("#user_test_dt").datepicker(datepicker);
				$("#accept_dt").val(
						$.datepicker.formatDate('yy/mm/dd', new Date()))
						.datepicker(datepicker);
				$("#distr_dt").val(
						$.datepicker.formatDate('yy/mm/dd', new Date(
								distr_dt))).datepicker(datepicker);
				$( "#distr_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);

				$("select[name='proc_status'] option[value='C006']").remove();
				$("select[name='proc_status'] option[value='C007']").remove();
				$("select[name='proc_status'] option[value='C008']").remove();
				current_file = '${ vo.current_file}'
				var str = '';
				for (var i = 0; i < 24; i++) {
					if (i < 10)
						str += '<option value="0'+i+'">0' + i + '</option>';
					else
						str += '<option value="'+i+'">' + i + '</option>';
				}

				$('#proc_time1').append(str);

				$('[id^=btnTab]').bind("click", function() {
					$('[id^=subTab]').hide();
					$('.tab_line li').removeClass("active");

					var dataid = $(this).data("id");
					$("#" + dataid).show();
					$(this).parent('li').addClass("active");

					if ('${ vo.pageType}'.indexOf('pdate') != -1) {
						if (dataid == 'subTab2')
							awsList(1); //답변내역 리스트 호출
					}
				});

				var pageType = '${ vo.pageType }';

				if (pageType.indexOf('sub') != -1) { //subInsert,subUpdate
					initView();
					$('#CnAS').hide();
					if(pageType == "subInsert"){                               //2023.07.11. 하위작업 등록 시에도 처리상태 대기로 시작하도록 처리
						$("#proc_status").val("C000").prop("selected", true);
					}
					
				} else {
					if (pageType == "update") { //update
						initView();
						//$('#CnAS').show(); 
						
						if($("#proc_status").val() == "C004" || $("#proc_status").val() == "C010"){ //2023.07.11. pageType이 update인데 처리상태가 '팀장승인','처리중'일 경우 하위작업생성 버튼 활성화
							$('#CnAS').show();                
						}else{                                 //2023.07.11. pageType이 update인데 처리상태가 그 외인 경우(대기,철회,반려,팀장반려,처리완료,배포승인,배포반려)일 경우 하위작업생성 버튼 비활성화
							$('#CnAS').hide(); 
						}
						
						//if (cnAsNoCnt > 0)
							//$('#proc_status').prop('disabled', true); 2023.07.10 주석처리(원본 처리상태 별도로 변경 가능)
							
					} else {   //insert
						addMultiFile();
						addFile(); //ready안 addFile()
						$('#CnAS').hide();
						$("#proc_status").val("C000").prop("selected", true); //직접 입력건은 신규등록시 무조건 대기상태로 (거래처구분이 C001 JW그룹 인경우) 저장로직 as임플 수정  2020.09.03. 보완
						$("#complete_dt")
								.datepicker('option', 'disabled', true);
						$("#spanForAlert").on('click', function() {
							alert("처리상태가 대기일 때는 작업완료일자를 설정할 수 없습니다.");
						});

					}
				}

				if (pageType == "subInsert" || pageType == "insert") {
					$("#inportance").val("C002").prop("selected", true);
				}

				//팝업창 Enter 검색 기능.
				$("#searchEmpName").keyup(function(e) {
					if (e.keyCode == 13)
						empList(1);
				});
				$("#searchKorName").keyup(function(e) {
					if (e.keyCode == 13)
						custList(1);
				});
				$("#searchCategoryName").keyup(function(e) {
					if (e.keyCode == 13)
						categoryList(1);
				});
				$("#searchProgramName").keyup(function(e) {
					if (e.keyCode == 13)
						programList(1);
				});
				$("#searchCharName").keyup(function(e) {
					if (e.keyCode == 13)
						charList(1);
				});

				//AS신청자 연락처
				$("#apply_tel1").keyup(function(e) {
					if (e.keyCode == 13)
						$("#apply_tel2").focus();
				});
				$("#apply_tel2").keyup(function(e) {
					if (e.keyCode == 13)
						$("#apply_tel3").focus();
				});
				$("#apply_tel2").keyup(function(e) {
					if ($(this).val().length == 4) {
						$("#apply_tel3").focus();
					}
				});

				$('#text_deploy_layout').show();
				$('#deploy_layout').show();
				//$('#distr_filepath').attr('readonly', 'readonly');
				//$('#distr_svn_ver').attr('readonly', 'readonly');
				//$('#distr_dt').attr('readonly', 'readonly');
				$("#distr_filepath_th").children().remove();
				$("#distr_svn_ver_th").children().remove();
				$("#distr_dt_th").children().remove();
				
				$('.hasDatepicker').attr('autocomplete','off');

			}); // document.ready 끝.

	function checkTypeQuestion() {
		var datas = {
			'request_type' : $('#request_type').val(),
			'action_type' : $('#action_type').val()
		};

		$
				.ajax({
					type : 'post',
					url : '/ad/as/checkTypeQuestion.do',
					data : datas,
					dataType : 'json',
					statusCode : {
						403 : function(data) {
							alert("권한이 없습니다.");
						},
						404 : function(data) {
							alert('해당 페이지가 존재하지 않습니다.');
						}
					},
					success : function(data) {
						var resultList = typeof data.resultList != 'undefined' ? data.resultList
								: null;

						if (resultList.GYUL_GB1 == 'Y') { //승인대상(팀장) = Y 해당시
							isTeamLead = true;
							aprv_status_teamLead = 'Y';
						} else {
							isTeamLead = false;
							aprv_status_teamLead = 'N';
						}

						if (resultList.GYUL_GB2 == 'Y') { //승인대상(배포) = Y 해당시
							isDeployment = true;
							aprv_status_Deployment = 'Y';
						} else {
							isDeployment = false;
							aprv_status_Deployment = 'N';
						}

						if (isTeamLead) { //승인대상이 팀장
							/* (C000 대기, C001 접수, C005 처리완료, C010 팀장승인, C011 팀장반려) */
							if (proc_status_current == 'C000'
									|| proc_status_current == 'C001'
									|| proc_status_current == 'C005'
									|| proc_status_current == 'C010'
									|| proc_status_current == 'C011') {
								$('#appr_em').val(appr_em_nm_1);
								$('#apprv_dt_role').val(makeDate(appr_date1));
								if (proc_status_current == 'C010') {
									$('#th_apprv').html("(팀장) 승인일자");
								}
							}
						}
						if (isDeployment) { //승인대상이 배포
							/* (C012 배포승인, C013 배포반려) */
							if (proc_status_current == 'C012'
									|| proc_status_current == 'C013') {
								$('#appr_em').val(appr_em_nm_2);
								$('#apprv_dt_role').val(makeDate(appr_date2));
								if (proc_status_current == 'C012') {
									$('#th_apprv').html("(배포) 승인일자");
								}
							}
						}

						changeLayoutAreaDeploy();
					}
				});
	}

	//hide or show layout area deploy
	function changeLayoutAreaDeploy() {
		var cust_gubun = $('#cust_gubun').val();
		var proc_status = $('#proc_status').val();
		var distr_dt = $('#distr_dt').val();
		$("#distr_filepath_th").children().remove();
		$("#distr_svn_ver_th").children().remove();
		$("#distr_dt_th").children().remove();
		//if(cust_gubun == 'C001'){ //JW그룹 아닌경우에도 팀장승인, 배포승인 2020.09.03.
		if (isDeployment) {
			if (proc_status == 'C012') {
				//$('#distr_filepath').removeAttr('readonly');
				//$('#distr_svn_ver').removeAttr('readonly');
				//$('#distr_dt').removeAttr('readonly');
				/* if (distr_dt != '') {
					$("#distr_dt").val(
							$.datepicker.formatDate('yy/mm/dd', new Date(
									distr_dt))).datepicker(datepicker);
				} else {
					/*2021.12.17.재용부장님 요청-오늘날짜로 자동세팅 기능해지*/
					//$( "#distr_dt" ).val($.datepicker.formatDate('yy/mm/dd', new Date())).datepicker(datepicker);
					//$("#distr_dt").datepicker(datepicker);
				//} */
				
				$("#distr_filepath_th").append(
						'<span class="request mgl5">필수 입력</span>');
				$("#distr_svn_ver_th").append(
						'<span class="request mgl5">필수 입력</span>');
				$("#distr_dt_th").append(
						'<span class="request mgl5">필수 입력</span>');
			}
		}

		//} 
	}

	/*리스트*/
	function goList() {
		//list3 - screen A/S승인
		if (current_file == 'list3') {
			location.href = '/ad/as/list3.do${ QUERYSTRING }';
		} else{
			location.href = '/ad/as/list.do${ QUERYSTRING }';
		}
	}

	function addFile() {
		var str = '';
		str += '';

		str += '<tr id="file'+file_cnt+'">';
		str += '<th scope="row">첨부파일</th>';
		str += '<td colspan ="3">';
		str += '		<input type="file" id="upFile_'+file_cnt+'" name="upFile_'+file_cnt+'" class="w225">';
		if (file_cnt > 1)
			str += '		<button class="btn_minus mgr5" onclick="delFile('
					+ file_cnt + ');"></button>';
		else
			str += '		<span class="btn_plus mgr5" onclick="addFile();"></span> ';
		str += '		<!-- <button type="button" class="btn_ico_down mgr5"><span>다운로드</span></button> -->';
		str += '		</td>';
		str += '</tr>';
		$('#wrapFile').append(str);
		$('#file_cnt').val(file_cnt);

		file_cnt++;
	}

	function delFile(cnt) {
		$('#file' + cnt).remove();

		if (delAttach2 == "")
			delAttach2 = cnt;
		else
			delAttach2 = delAttach2 + "@" + cnt;
	}

	function addMultiFile() {
		//$('#wrapFile')
		var str = '';
		str += '';
		str += '<tr id="mfile'+mfile_cnt+'">';
		str += '<th>파일첨부</th>';
		str += '<td colspan="3">';
		str += '		<input type="file" id="uploadFile_'+mfile_cnt+'" name="uploadFile_'+mfile_cnt+'" class="w225 mgr5">';
		if (mfile_cnt > 1)
			str += '		<button type="button" class="btn_minus mgr5" onclick="delMfile('
					+ mfile_cnt + ');">추가</button>';
		else
			str += '		<button type="button" class="btn_plus" onclick="addMultiFile();">추가</button>';
		str += '		</td>';
		str += '</tr>';
		$('#wrapMfile').append(str);
		$('#mfile_cnt').val(mfile_cnt);
		mfile_cnt++;
	}

	/** 문의 내용 첨부 파일 */
	function delMfile(cnt) {

		$('#mfile' + cnt).remove();

		if (delAttach1 == "")
			delAttach1 = cnt;
		else
			delAttach1 = delAttach1 + "@" + cnt;
	}

	/** 조치 내용 첨부 파일*/
	function delfile(cnt) {

		$('#file' + cnt).remove();

		if (delAttach2 == "")
			delAttach2 = cnt;
		else
			delAttach2 = delAttach2 + "@" + cnt;
	}

	/* CMC add 중분류 2021.01.12  */
	function showCategoryPopLayer() {
		if ($('#module_name').val() == "") {
			alert("모듈을 선택하세요.");

		} else {
			var pos = $('#div_category_pop').position();
			$('#div_category_pop').show();
			$("#div_category_pop").css(
					{
						"top" : (($(window).height() - $("#div_category_pop")
								.outerHeight()) / 2 + $(window).scrollTop())
								+ "px"
					});
			$('#searchCategoryName').val('');
			categoryList(1);
		}
	}

	function categoryList(categoryPage) {
		var datas = {
			'page' : categoryPage,
			'search_text' : $('#searchCategoryName').val(),
			'search_text2' : $('#module_name').val()
		}

		common.ajaxCall(datas, '/ad/as/getCategoryList.do', 'makeCategoryList');
	}

	function makeCategoryList(data) {
		$('#categoryPopInfoList').empty();
		$('#layer_pagination_category').empty();

		var resultList = typeof data.resultList != "undefined" ? data.resultList
				: null;
		var vo = typeof data.vo != "undefined" ? data.vo : null;

		if (resultList != null && resultList.length > 0) {
			var str = '';
			for (var i = 0; i < resultList.length; i++) {
				var datas = resultList[i];
				str += '<tr onclick="javascript:setCategory(\''
						+ common.nvl(datas.category_id, '') + '\' , \''
						+ common.nvl(datas.category_name, '')
						+ '\');" style="cursor:pointer;"> ';
				str += '<td style="text-align: center;">'
						+ common.nvl(datas.category_id, '') + '</td> ';
				str += '<td style="text-align: center;">'
						+ common.nvl(datas.category_name, '') + '</td> ';
				str += '</tr> ';
			}
			$('#categoryPopInfoList').append(str);
			$('#layer_pagination_category').html(vo.json_paging);
		} else {
			commonTable.notData(6, '조회된 정보가 없습니다.', 'categoryPopInfoList');
		}
	}

	function setCategory(category_id, category_name) {
		$('#category_name').val(category_name);
		$('#category_id').val(category_id);
		$('#program_name').val('');
		$('#program_id').val('');
		closeCategoryPopLayer();
	}

	function clearCategoryAndProgram(val) {
		$('#category_name').val('');
		$('#category_id').val('');
		$('#program_name').val('');
		$('#program_id').val('');
	}

	/* CMC add 프로그램명 2021.01.12  */

	function showProgramPopLayer() {
		if ($('#module_name').val() == "") {
			alert("모듈과 중분류 정보를 먼저 선택하세요.");

		} else if ($('#category_name').val() == "") {
			alert("중분류를 선택하세요.");

		} else {
			$('#div_program_pop').show();
			$("#div_program_pop").css(
					{
						"top" : (($(window).height() - $("#div_program_pop")
								.outerHeight()) / 2 + $(window).scrollTop())
								+ "px"
					});
			//$('#div_program_pop').attr('style', 'top: 800px !important; height: 500px !important;');
			$('#searchProgramName').val('');
			programList(1);
		}
	}

	function programList(programPage) {
		var system_code = $('#system_type').val();
		var datas = {
			'page' : programPage,
			'search_text' : $('#searchProgramName').val(),
			'search_text3' : $('#category_id').val(),

		}
		common.ajaxCall(datas, '/ad/as/getProgramList.do', 'makeProgramList');
	}

	function makeProgramList(data) {
		$('#programPopInfoList').empty();
		$('#layer_pagination_program').empty();

		var resultList = typeof data.resultList != "undefined" ? data.resultList
				: null;
		var vo = typeof data.vo != "undefined" ? data.vo : null;

		if (resultList != null && resultList.length > 0) {
			var str = '';
			for (var i = 0; i < resultList.length; i++) {
				var datas = resultList[i];
				str += '<tr onclick="javascript:setProgram(\''
						+ common.nvl(datas.program_name, '') + '\' ,  \''
						+ common.nvl(datas.program_id, '') + '\' , \''
						+ common.nvl(datas.category_id, '') + '\' ,  \''
						+ common.nvl(datas.category_name, '')
						+ '\');" style="cursor:pointer;"> ';
				str += '<td class="w100" style="text-align: center;">'
						+ common.nvl(datas.program_id, '') + '</td> ';
				str += '<td class="w100" style="text-align: center;"> '
						+ common.nvl(datas.program_name, '') + '</td> ';
				str += '<td style="display:none;"> '
						+ common.nvl(datas.module_name, '') + '</td> ';
				str += '<td style="display:none;"> '
						+ common.nvl(datas.category_id, '') + '</td> ';
				str += '<td style="display:none;"> '
						+ common.nvl(datas.category_name, '') + '</td> ';
				str += '</tr> ';
			}
			$('#programPopInfoList').append(str);
			$('#layer_pagination_program').html(vo.json_paging);
		} else {
			commonTable.notData(6, '조회된 정보가 없습니다.', 'programPopInfoList');
		}
	}

	function setProgram(program_name, program_id, category_id, category_name) {
		$('#program_name').val(program_name);
		$('#program_id').val(program_id);
		$('#category_id').val(category_id);
		$('#category_name').val(category_name);
		closeProgramPopLayer();
	}

	/**	거래처 조회	*/
	function showCustLayer() {
		$('#div1').show();
		$("#div1")
				.css(
						{
							"top" : (($(window).height() - $("#div1")
									.outerHeight()) / 2 + $(window).scrollTop())
									+ 300 + "px"
						});
		$('#div1_dim').show();
		custList(1);
		$("#searchKorName").attr("autofocus", "autofocus");
		$('[autofocus]:not(:focus)').eq(0).focus();

	}

	function custList(custPage) {
		var datas = {
			'page' : custPage,
			'search_text' : $('#searchKorName').val()
		}

		common.ajaxCall(datas, '/ad/member/getCustList.do', 'makeCustList');
	}

	function makeCustList(data) {
		$('#custInfoList').empty();
		$('#layer_pagination1').empty();

		var resultList = typeof data.resultList != "undefined" ? data.resultList
				: null;
		var vo = typeof data.vo != "undefined" ? data.vo : null;

		if (resultList != null && resultList.length > 0) {
			var str = '';
			for (var i = 0; i < resultList.length; i++) {
				var datas = resultList[i];
				str += '<tr onclick="javascript:setValue(\''
						+ common.nvl(datas.seq, '')
						+ '\');" style="cursor:pointer;"> ';
				str += '	<td>' + common.nvl(datas.rnum, '') + '</td> ';
				str += '	<td>' + common.nvl(datas.cust_gubun_nm, '') + '</td> ';
				str += '	<td>' + common.nvl(datas.cust_kor_name, '') + '</td> ';
				str += '	<td>' + common.nvl(datas.erp_code, '') + '</td> ';
				str += '	<td>' + common.nvl(datas.ceo, '') + '</td> ';
				str += '	<td style="display:none;">'
						+ common.nvl(datas.cust_gubun, '') + '</td> ';
				str += '</tr> ';
			}
			$('#custInfoList').append(str);
			$('#layer_pagination1').html(vo.json_paging);
		} else {
			commonTable.notData(6, '조회된 정보가 없습니다.', 'custInfoList');
		}
	}

	function setValue(seq, cust_gubun) {
		var datas = {
			'cust_seq' : seq,
			'pageType' : '${ vo.pageType }'
		}

		common.ajaxCall(datas, '/ad/cust/getCustInfoBySeq.do', 'makeCustInfo');
		common.ajaxCall(datas, '/ad/cust/getSystemInfo.do', 'makeSystemType');
		closeLayer(1);
		$('#apply_nm').val('');
		$('#apply_id').val('');
		$('#apply_tel1').val('');
		$('#apply_tel2').val('');
		$('#apply_tel3').val('');

	}

	function makeCustInfo(data) {

		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO
				: null;

		$('#cust_gubun').val(common.nvl(resultVO.cust_gubun, '')); //거래처구분 추가 2020.08.27.  		
		$('#cust_kor_name').val(common.nvl(resultVO.cust_kor_name, ''));
		$('#cust_code').val(common.nvl(resultVO.erp_code, ''));
		$('#cust_addr').val(common.nvl(resultVO.cust_address, ''));
		$('#cust_tel').val(common.nvl(resultVO.tel_no, ''));
		$('#cust_seq').val(common.nvl(resultVO.seq, ''));
		$('#as_approval_yn').val(common.nvl(resultVO.as_approval_yn, ''));

	}

	function makeSystemType(data) {
		commonCode.returnOperCodeList(data, 'system_type');

	}
	/**	//거래처 조회	*/

	/**	A/S신청자 이름/아이디 조회	*/
	function showEmpLayer() {
		if (common.isEmpty($('#cust_code').val())) {
			alert('고객사 정보를 조회해 주세요.');
			return;
		}
		$('#apply_nm').val('').attr('readonly', 'readonly').removeAttr(
				'placeholder');
		$('#apply_id').val('');
		$('#div2').show();
		$("#div2")
				.css(
						{
							"top" : (($(window).height() - $("#div2")
									.outerHeight()) / 2 + $(window).scrollTop())
									+ 200 + "px"
						});
		$('#div2_dim').show();
		empList(1);
		$("#searchEmpName").attr("autofocus", "autofocus");
		$('[autofocus]:not(:focus)').eq(0).focus();

	}

	function empList(custPage) {
		var datas = {
			'page' : custPage,
			'cust_code' : $('#cust_code').val(),
			'search_text' : $('#searchEmpName').val()
		};
		common.ajaxCall(datas, '/ad/member/getCustEmpList.do', 'makeEmpList');
	}

	function makeEmpList(data) {

		$('#empInfoList').empty();
		$('#layer_pagination2').empty();
		$('#cust_emp_tb').css('display', '');
		$('#charge_emp_tb').css('display', 'none');

		var resultList = typeof data.resultList != "undefined" ? data.resultList
				: null;
		var vo = typeof data.vo != "undefined" ? data.vo : null;

		if (resultList != null && resultList.length > 0) {
			var str = '';
			for (var i = 0; i < resultList.length; i++) {
				var datas = resultList[i];
				str += '<tr onclick="javascript:setValueEmp(\''
						+ common.nvl(datas.emp_id, '')
						+ '\');" style="cursor:pointer;"> ';
				str += '	<td>' + common.nvl(datas.rnum, '') + '</td> ';
				str += '	<td>' + common.nvl(datas.dept2_nm, '') + '</td> ';
				str += '	<td>' + common.nvl(datas.emp_id, '') + '</td> ';
				str += '	<td>' + common.nvl(datas.emp_name, '') + '</td> ';
				str += '	<td>' + common.nvl(datas.dept_grade_cd, '') + '</td> ';
				str += '	<td>' + common.nvl(datas.tel_no, '') + '</td> ';
				str += '</tr> ';
			}
			$('#empInfoList').append(str);
			$('#layer_pagination2').html(vo.json_paging);

		} else {
			commonTable.notData(6, '조회된 정보가 없습니다.', 'empInfoList');
			$('#layer_pagination2').html('');
		}
	}

	function setValueEmp(emp_id) {
		var datas = {
			'emp_id' : emp_id
		}
		common.ajaxCall(datas, '/ad/member/getEmpInfo.do', 'makeEmpInfo');
		closeLayer(2);
	}

	function makeEmpInfo(data) {
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO
				: null;
		$('#apply_nm').val(common.nvl(resultVO.emp_name, ''));
		$('#apply_id').val(common.nvl(resultVO.emp_id, ''));

		$('#apply_tel1').val(common.spritStr(resultVO.company_no, 1, '-'));
		$('#apply_tel2').val(common.spritStr(resultVO.company_no, 2, '-'));
		$('#apply_tel3').val(common.spritStr(resultVO.company_no, 3, '-'));

		$('#apply_sms_tel1').val(common.spritStr(resultVO.tel_no, 1, '-'));
		$('#apply_sms_tel2').val(common.spritStr(resultVO.tel_no, 2, '-'));
		$('#apply_sms_tel3').val(common.spritStr(resultVO.tel_no, 3, '-'));

		$('#apply_email').val(common.nvl(resultVO.email, ''));

	}
	/**	//A/S신청자 이름/아이디 조회	*/
	
	function makeEmpInfo2(data) { //2023.10.30 EMAIL 체크 시 정보 다시 기입 기능 추가
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO
				: null;

		$('#apply_email').val(common.nvl(resultVO.email, ''));

	}
	
	function makeEmpInfo3(data) { //2023.10.30 SMS 체크 시 정보 다시 기입 기능 추가
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO
				: null;

		$('#apply_sms_tel1').val(common.spritStr(resultVO.tel_no, 1, '-'));
		$('#apply_sms_tel2').val(common.spritStr(resultVO.tel_no, 2, '-'));
		$('#apply_sms_tel3').val(common.spritStr(resultVO.tel_no, 3, '-'));

	}

	/* 처리담당자 조회 */
	function showAssign() {

		//처리상태가 대기(C000),팀장승인(C010)일 때만 처리담당자 변경이 가능 2022.02.21
		if ('C000' == $('#proc_status').val()
				|| 'C010' == $('#proc_status').val()) {

			if (common.isEmpty($('#system_type').val())) {
				alert('시스템유형 정보를 선택해 주세요.');
				$('#system_type').focus();
				return;
			}
			if (common.isEmpty($('#inquiry_type').val())) {
				alert('업무유형 정보를 선택해 주세요.');
				$('#inquiry_type').focus();
				return;
			}
			$('#div6').show();
			$("#div6")
					.css(
							{
								"top" : (($(window).height() - $("#div6")
										.outerHeight()) / 2 + $(window)
										.scrollTop())
										+ 200 + "px"
							});
			$('#div6_dim').show();
			charList(1);
			$("#searchCharName").attr("autofocus", "autofocus");
			$('[autofocus]:not(:focus)').eq(0).focus();

		} else {
			alert("해당 처리상태에서는 처리담당자를 변경할 수 없습니다.");
		}

	};

	function charList(charPage) {

		var datas = {
			'page' : charPage,
			'emp_nm' : $('#searchCharName').val(),
			'search_type2' : 'Y'
		};
		common.ajaxCall(datas, '/ad/cust/getEmpList.do', 'makeCharList');
	}

	function makeCharList(data) {

		$('#charInfoList').empty();
		$('#layer_pagination6').empty();

		var resultList = typeof data.resultList != "undefined" ? data.resultList
				: null;
		var vo = typeof data.vo != "undefined" ? data.vo : null;

		if (resultList != null && resultList.length > 0) {
			var str = '';
			for (var i = 0; i < resultList.length; i++) {
				var datas = resultList[i];
				var empty = "'" + datas.emp_no + "'";
				var empty2 = "'" + datas.emp_nm + "'";
				str += '<tr onclick="javascript:setValueChar(' + empty + ','
						+ empty2 + ');" style="cursor:pointer;"> ';
				str += '	<td>' + common.nvl(datas.rnum, '') + '</td> ';
				str += '	<td>' + common.nvl(datas.dept1_nm, '') + "/"
						+ common.nvl(datas.dept2_nm, '') + '</td> ';
				str += '	<td>' + common.nvl(datas.emp_no, '') + '</td> ';
				str += '	<td>' + common.nvl(datas.emp_nm, '') + '</td> ';
				str += '	<td>' + common.nvl(datas.dept_grade_nm, '') + '</td> ';
				str += '	<td>' + common.nvl(datas.e_mail, '') + '</td> ';
				str += '</tr> ';
			}
			$('#charInfoList').append(str);
			$('#layer_pagination6').html(vo.json_paging);
		} else {
			commonTable.notData(7, '조회된 정보가 없습니다.', 'charInfoList');
		}

	}

	function setValueChar(emp_no, emp_nm) {

		$('#assign_nm').val(emp_nm);
		$('#assign_id').val(emp_no);
		closeLayer(6);
	}

	function closeLayer(num) {
		$('#div' + num).hide();
		$('#div' + num + '_dim').hide();
		$('#searchKorName').val('');
		$('#searchEmpName').val('');
		$("#searchKorName").removeAttr("autofocus");
		$("#searchEmpName").removeAttr("autofocus");
		$("#searchCharName").removeAttr("autofocus");
	}

	function closeCategoryPopLayer() {
		$('#div_category_pop').hide();
	}

	function closeProgramPopLayer() {
		$('#div_program_pop').hide();
	}

	/*//처리담당자 팝업 */

	/* 답변내역 script */
	function awsList(awsPage) {
		var datas = {
			'page' : awsPage,
			'as_no' : '${ vo.as_no }'
		}
		common.ajaxCall(datas, '/ad/as/getAwsList.do', 'makeAwsList');
	}

	function makeAwsList(data) {

		$('#awsInfoList').empty();
		$('#aswWrapFile').children('tr:not(:first)').remove();

		aswfile_cnt = 1;

		var resultList = typeof data.resultList != "undefined" ? data.resultList
				: null;
		if (resultList != null && resultList.length > 0) {
			var str = '';
			for (var i = 0; i < resultList.length; i++) {
				var datas = resultList[i];
				var u_class = '';
				var new_icon = '';
				var attachData = datas.amap;
				var attachOb = [];
				if (common.nvl(datas.w_gubun, '') == 'U') {
					u_class = "gray";
				}

				if (common.nvl(datas.w_gubun, '') == 'U'
						&& (i + 1) == resultList.length) {
					new_icon = '<span class="new"></span>';
				}

				str += '<tr id="awsTr' + (i + 1) + '" class="' + u_class + '">';
				str += '		<td>' + common.nvl(datas.emp_nm) + '</td>';
				str += '		<td>' + new_icon + ' ' + common.nvl(datas.w_date)
						+ '<input type="hidden" id="temp_content_'
						+ common.nvl(datas.seq, '') + '" value="'
						+ common.nvl(datas.w_content) + '" /></td>';

				str += '		<td class="textL">' + common.nvl(datas.w_content)
						+ '<br>';

				if (JSON.stringify(attachData) != '{}') {
					if (attachData.attachList.length > 0) {
						for (var j = 0; j < attachData.attachList.length; j++) {

							var arr = {
								"attach_seq" : attachData.attachList[j].attach_seq,
								"attach_ord" : attachData.attachList[j].attach_ord,
								"attach_ori_nm" : attachData.attachList[j].attach_ori_nm
							};

							attachOb.push(arr);

							str += '<button type="button" class="btn_file_blue mgr5 mgt5" onclick="javascript:fileDown(\''
									+ common
											.nvl(
													attachData.attachList[j].attach_seq,
													'')
									+ '\' , \''
									+ common
											.nvl(
													attachData.attachList[j].attach_ord,
													'')
									+ '\');"><span>다운로드</span></button>';
							str += '<span>'
									+ common
											.nvl(
													attachData.attachList[j].attach_ori_nm,
													'') + '</span>';
							str += '<br>'
						}
					}
				}
				str += '		</td>';
				str += '		<td></td>';

				//str += '		<td><button type="button" class="btn_pencil_blue mgr5" onclick="aswShowLayer(\'list\',\''+common.nvl(datas.seq,'')+'\');"><span>수정</span>
				//str += '		<td></button><button type="button" class="btn_delete_blue" onclick="aswDelete(\''+common.nvl(datas.seq,'')+'\');"><span>삭제</span></button></td>';
				str += '</tr>';
			}
			$('#awsInfoList').append(str);

			var offset = $("#awsTr" + resultList.length).offset();
			$('#awsWrap').animate({
				scrollTop : offset.top
			}, 1000);

		} else {
			commonTable.notData(4, '등록된 답변이 없습니다.', 'awsInfoList');
		}

		//답변내역 - 첨부파일open 
		addAswFile();
	}

	function aswShowLayer(type, seq) {
		v_seq = seq;
		$('#w_content').val('');

		if (type == 'list') {
			$('#div3PopTitle').html('답변 수정');
			$('#div3').show();
			$('#p_w_content').val($('#temp_content_' + v_seq).val());

		} else {
			$('#div3PopTitle').html('답변 등록');
			$('#div3').show();
		}
		$('#div3_dim').show();
	}

	function btnAswProc(type) {

		if (type == 'insert') {
			if (common.isEmpty($('#w_content').val())) {
				alert('답변 내용을 입력해 주세요.');
				return;
			}
		}
		var pageType = '';
		if (v_seq != '' && typeof v_seq != 'undefined')
			pageType = 'update';
		else
			pageType = 'insert';

		var f = document.answerForm;

		if (pageType == 'insert') {

			//띄어 쓰기 추가 (답변등록)
			f.w_content.value = $('#w_content').val();
			f.as_no.value = '${ vo.as_no }';
			f.seq.value = v_seq;
			f.pageType.value = pageType;

		} else if (pageType = 'update') {

			f.w_content.value = $('#p_w_content').val();
			f.as_no.value = '${ vo.as_no }';
			f.seq.value = v_seq;
			f.pageType.value = pageType;

		}

		try {
			$("#exlFrame").remove();
		} catch (e) {
		}

		var downFrame = $('<iframe id="awsFrame" name="awsFrame" style="width:0px; height=0px ; display:none;"></iframe>');
		downFrame.appendTo("body");

		f.method = "post";
		f.target = "awsFrame";
		f.action = "/ad/as/awsProc.do";
		f.submit();

	}

	function awsProcReturn(resultCode) {

		if (resultCode == "000") {
			alert('정상처리 되었습니다.');
			btnAswCancel();
			awsList(1, '${ vo.as_no }');
		} else {
			alert('처리도중 오류가 발생했습니다.');
			return;
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

			try {
				$("#exlFrame").remove();
			} catch (e) {
			}

			var downFrame = $('<iframe id="awsFrame" name="awsFrame" style="width:0px; height=0px ; display:none;"></iframe>');
			downFrame.appendTo("body");

			f.method = "post";
			f.target = "awsFrame";
			f.action = "/ad/as/awsProc.do";
			f.submit();
		}
	}

	function btnAswCancel() {
		$('#w_content').val('');
		closeLayer(3);
	}
	/*//답변내역*/

	/* 업무유형 */
	function getTaskType(system_code) {
		$('#program_name').val('');
		$('#program_id').val('');

		$('#module_name').val('');
		$('#category_name').val('');
		$('#category_id').val('');

		if ($('#cust_code').val() == "") {
			alert('거래처를 먼저 조회해 주세요.');
			return;
		}

		$('#inquiry_type').empty();
		var oper_seq = $('#system_type option:selected').attr('oper_seq');
		var accept_dt = $('#accept_dt').val().replaceAll("/", "");
		$('#oper_seq').val(oper_seq);
		var datas = {
			"oper_seq" : oper_seq,
			"accept_dt" : accept_dt,
			"system_code" : system_code.split('@')[0],
			"pageType" : "${ vo.pageType }"
		};
		common.ajaxCall(datas, '/ad/operate/getOperTask.do', 'setTaskType');
	}

	/* 수정페이지용 */
	function getTaskTypeByInfo(system_code, oper_seq) {
		var accept_dt = $('#accept_dt').val().replaceAll("/", "");
		var datas = {
			"oper_seq" : oper_seq,
			"system_code" : system_code,
			"accept_dt" : accept_dt,
			"pageType" : "${ vo.pageType }"
		};
		common.ajaxCall(datas, '/ad/operate/getOperTask.do', 'setTaskType');
	}

	function setTaskType(data) {
		commonCode.returnTaskCodeList(data, 'inquiry_type');
		if (data.length == 0)
			$('#inquiry_type').append(commonCode.defaultViewOption);
	}
	/*//업무유형 */

	/* 업무유형-담당자 자동 인설트 */
	function getAssign(data){
		if(data == null || data == '') return;
		
		$('#assign_nm').empty() ; 
		$('#assign_id').empty() ; 
		
		var system_type = $("#system_type").val();
		
		/*2023.01.31 추가 - 시스템유형:기타  && 업무유형:일반 건은 배정담당자:작성자 로 설정*/ //2023.10.30 다시 추가(저장소에 저장 안되어 있어서 삭제되어 있었음)
		if(system_type.includes("S999") && data.includes("C001")){
			var assign_nm = '${adUserInfo.emp_nm }';	//로그인자 이름
			var assign_id = '${adUserInfo.emp_no }';	//로그인자 ID
		
		/*2024.07.26 추가 - 업무유형 : 기타 건은 배정담당자 : 작성자로 설정 */
		}else if(data.includes("C999")){
			var assign_nm = '${adUserInfo.emp_nm }';	//로그인자 이름
			var assign_id = '${adUserInfo.emp_no }';	//로그인자 ID
		
		}else{
			var assign_nm = $('#inquiry_type option:selected').attr('worker_nm');
			var assign_id = $('#inquiry_type option:selected').attr('emp_no');
		
		}
		
		$('#assign_nm').val(assign_nm) ; 
		$('#assign_id').val(assign_id) ; 
		
	};

	/*배정담당자 셀렉트박스 조회*/
	function getEmpList() {
		common.ajaxCall({}, '/ad/as/getAsEmpList.do', 'makeEmpList2');
	}

	function makeEmpList2(data) {
		var resultList = typeof data.resultList != "undefined" ? data.resultList
				: null;

		$('#sel_assign_id').empty().append('<option value="">담당자 선택</option>');

		if (resultList != null && resultList.length > 0) {
			var str = '';
			for (var i = 0; i < resultList.length; i++) {
				var datas = resultList[i];
				str += '<option value="' + common.nvl(datas.emp_no, '') + '">'
						+ common.nvl(datas.emp_nm, '') + '</option>';
			}

			$('#sel_assign_id').append(str);
			$('#sel_assign_id').val('${adUserInfo.emp_no}');
			$('#assign_id').val('${adUserInfo.emp_no}');
		}
	}
	/*//배정담당자 셀렉트박스 조회*/

	function goSave() {
		var f = document.procFrm;

		/* 고객사 정보 유효성검사 */
		if (common.isEmpty($('#accept_route').val())) {
			alert('접수 경로를 선택하세요.');
			$('#accept_route').focus();
			return;
		}
		if (common.isEmpty($('#cust_kor_name').val())) {
			alert('고객사 정보를 조회해 주세요.');
			$('#cust_kor_name').focus();
			return;
		}
		if (common.isEmpty($('#apply_nm').val())) {
			alert('A/S 신청자 이름을 입력하세요.');
			$('#apply_nm').focus();
			return;
		}
		if (!common.isEmpty($('#apply_tel1').val())
				&& !common.isEmpty($('#apply_tel2').val())
				&& !common.isEmpty($('#apply_tel3').val())) {
			$('#apply_tel').val(
					$('#apply_tel1').val() + "-" + $('#apply_tel2').val() + "-"
							+ $('#apply_tel3').val());
		}
		if ($('#send_email').is(":checked")) {
			if (common.isEmpty($('#apply_email').val())) {
				alert('이메일 입력하세요');
				$('#apply_email').focus();
				return;
			}

		}

		if ($('#send_sms').is(":checked")) {
			if (common.isEmpty($('#apply_sms_tel1').val())
					|| common.isEmpty($('#apply_sms_tel2').val())
					|| common.isEmpty($('#apply_sms_tel3').val())) {
				alert('SMS 수신 전화번호를 입력하세요');
				$('#apply_sms_tel1').focus();
				return;
			} else {
				$('#apply_sms_tel').val(
						$('#apply_sms_tel1').val() + "-"
								+ $('#apply_sms_tel2').val() + "-"
								+ $('#apply_sms_tel3').val());
			}

		}

		/*문의 유형 정보 유효성검사*/
		if (common.isEmpty($('#system_type').val())) {
			alert('시스템 유형을 선택하세요.');
			$('#system_type').focus();
			return;
		}
		if (common.isEmpty($('#inquiry_type').val())) {
			alert('업무 유형을 선택하세요.');
			$('#inquiry_type').focus();
			return;
		}
		if (common.isEmpty($('#proc_status').val())) {
			alert('처리상태를 선택하세요.');
			$('#proc_status').focus();
			return;
		}

		//저장시 처리상태 메세지체크 
		//chProcStatus($('#proc_status').val());	 

		if (common.isEmpty($('#inportance').val())) {
			alert('중요도를 선택하세요.');
			$('#inportance').focus();
			return;
		}

		if (common.isEmpty($('#request_type').val())) {
			alert('문의유형을 선택하세요.');
			$('#request_type').focus();
			return;
		}

		if (($('#action_type').val() == 'C001' || $('#action_type').val() == 'C002')
				&& common.isEmpty($('#module_name').val())
				&& $('#proc_status').val() == 'C005') {
			alert('모듈을 선택하세요.');
			$('#module_name').focus();
			return;
		}

		/*처리상태가 처리완료(COO5)일 때 유효성검사*/
		if ($('#proc_status').val() == 'C005') {

			if (common.isEmpty($('#proc_dt').val())) {
				alert('처리예정일자를 입력하세요.');
				$('#proc_dt').focus();
				return;
			}

			if (common.isEmpty($('#cause_type').val())) {
				alert('원인유형을 선택하세요.');
				$('#cause_type').focus();
				return;
			}

			if (common.isEmpty($('#action_type').val())) {
				alert('조치유형을 선택하세요.');
				$('#action_type').focus();
				return;
			}

			if (common.isEmpty($('#proc_grade').val())) {
				alert('처리등급을 선택하세요.');
				$('#proc_grade').focus();
				return;
			}
			
			//2025.03.04 CMMI 관련 로직 추가
			//4.문의유형이 프로그램 개선,신규개발 인 경우에 조치유형[프로그램수정,신규개발] && 처리등급[A,B]를 제외하고는 "분류가 적절하지않다" 팝업
			//5.문의유형이 프로그램개선,신규개발이 아닌데, 조치유형[프로그램수정,신규개발] && 처리등급[A,B]인 경우에 "분류가 적절하지 않다" 팝업
			if(!($('#request_type').val() == 'C005')){
				if ($('#request_type').val() == 'C001' || $('#request_type').val() == 'C017') {
					
				    // 문의 유형이 '프로그램 개선' 또는 '신규 개발'일 경우
				    if (!(($('#action_type').val() == 'C001' || $('#action_type').val() == 'C002') && 
				          ($('#proc_grade').val() == 'C001' || $('#proc_grade').val() == 'C002'))) {
				        alert('문의유형이 "프로그램 신규개발,개선"인 경우에는\n조치유형이 "프로그램 신규개발,수정"과 처리등급이 "A,B"여야 합니다.\n유형 분류를 다시 해주세요.');
				        $('#action_type').focus();
				        return;
				    }
				    
				} else {
					
				    // 문의 유형이 '프로그램 개선' 또는 '신규 개발'이 아닐 경우
				    if ($('#action_type').val() == 'C001' || $('#action_type').val() == 'C002') {
				        alert('문의유형이 "프로그램 신규개발,개선,오류/장애"가 아닌 경우에는\n조치유형이 "프로그램 신규개발,수정"과 처리등급이 "A,B"가 될 수 없습니다.\n유형 분류를 다시 해주세요.');
				        $('#action_type').focus();
				        return;
				    }else if($('#proc_grade').val() == 'C001' || $('#proc_grade').val() == 'C002'){
				        alert('문의유형이 "프로그램 신규개발,개선,오류/장애"가 아닌 경우에는\n조치유형이 "프로그램 신규개발,수정"과 처리등급이 "A,B"가 될 수 없습니다.\n유형 분류를 다시 해주세요.');
				        $('#proc_grade').focus();
				        return;
				    }
				    
				}
			}
			

			if (common.isEmpty($('#work_time').val())) {
				alert('작업시간을 입력하세요.');
				$('#work_time').focus();
				return;
			}

			if (common.isEmpty($('#complete_dt').val())) {
				alert('작업완료일자를 입력하세요');
				$('#complete_dt').focus();
				return;
			}
			
			//2025.05.07 CMMI 관련 로직 추가(2. SR 지연처리에 대한 로직 체크 --- "처리요청일자 >= 작업완료일자 & 처리예정일자 >= 작업완료일자" 성립 안내)
			var completeDtVal = $('#complete_dt').val().trim();
			var procDtVal = $('#proc_dt').val().trim();
			var inquiryDtVal = $('#inquiry_dt').val().trim();

			
			if (common.isEmpty(completeDtVal) || common.isEmpty(procDtVal) || common.isEmpty(inquiryDtVal)) {
			    alert("날짜 값을 모두 입력해주세요.");
			} else {
			    
			    var completeDt = new Date(completeDtVal);
			    var procDt = new Date(procDtVal);
			    var inquiryDt = new Date(inquiryDtVal);

			    if (inquiryDt < completeDt || procDt < completeDt) {
			    	if (confirm('유지보수 품질심사 표준에 따라 아래 식이 성립되어야 합니다.\n[ 처리요청일자 >= 작업완료일자 & 처리예정일자 >= 작업완료일자 ]\n무시하고 저장하시겠습니까?')) {
				    } else {
				    	alert('일자를 수정하세요.');
						$('#complete_dt').focus();
						return;
				    }
				}
			}
			
			//2025.03.04 CMMI 관련 로직 추가(1.처리완료,배포승인일 경우 '조치 및 처리 의견' 값은 공백X)
			if (common.isEmpty($('#action_content').val().trim())) {
			    alert('조치 및 처리 의견을 입력하세요');
			    $('#action_content').focus();
			    return;
			}

			if ($('#action_type').val() == 'C001'
					|| $('#action_type').val() == 'C002') {
				
				if ($('#system_type').val().includes("S003")){
					if (common.isEmpty($('#proc_build_info').val())) {
						alert('빌드순번/CTS빌드를 선택하세요.');
						$('#proc_build_info').focus();
						return;
						}
					}
				
				if (common.isEmpty($('#proc_gubun').val())) {
					alert('처리구분을 선택하세요.');
					$('#proc_gubun').focus();
					return;
				}
				
				//2025.03.04 CMMI 관련 로직 추가(7.처리상태가 "처리완료"일 경우 정의서들 중 최소 하나는 무조건 값이 존재해야 한다)
				if ($('#proc_gubun').val() == 'C001'){
					if ($('#proc_process_sp').val().trim() == ''
						&& $('#proc_screen_sp').val().trim() == ''
						&& $('#proc_table_sp').val().trim() == ''
						&& $('#proc_interface_sp').val().trim() == ''
						&& $('#proc_function_sp').val().trim() == ''
						){
						alert('처리구분이 "형상변경"인 경우 아래 목록 중\n한가지 이상의 정의서가 필수입니다.\n-프로세스정의서\n-화면정의서\n-테이블정의서\n-인터페이스정의서\n-기능분해도');
						$('#proc_gubun').focus();
						return;
					}
				}

				if (!$("#send_email").is(":checked")
						|| common.isEmpty($('#apply_email').val())) {
					alert("조치유형이 '프로그램 신규개발' 또는 '프로그램수정'인 A/S건은 \n고객 메일 수신 주소 입력이 필수 입니다.");
					$('#send_email').prop("checked", true);
					$('#apply_email').prop('readonly', false)
					$('#apply_email').focus();
					return;
				}
				
				if (common.isEmpty($('#proc_test_info').val())) {
					alert('테스트케이스를 입력하세요.');
					$('#proc_test_info').focus();
					return;
				}
			}
			
			//2025.03.04 CMMI 관련 로직 추가(6.처리상태가 "처리완료"일 경우에는 "ERD"와 "테이블정의서의" 값 중 하나가 존재할 경우 나머지 하나도 존재해야한다)
			if ((!common.isEmpty($('#proc_erd_sp').val().trim())) && (common.isEmpty($('#proc_table_sp').val().trim()))) {
				alert('ERD가 기입되어 있을 경우 테이블정의서도 기입되어야 합니다.');
				$('#proc_table_sp').focus();
				return;
			}
			if ((!common.isEmpty($('#proc_table_sp').val().trim())) && (common.isEmpty($('#proc_erd_sp').val().trim()))) {
				alert('테이블정의서가 기입되어 있을 경우 ERD도 기입되어야 합니다.');
				$('#proc_table_sp').focus();
				return;
			}
				
			
		}
		
		/*처리상태가 배포승인(CO12)일 때 유효성검사*/
		if ($('#proc_status').val() == 'C012') {
			
			//2025.05.07 CMMI 관련 로직 추가(2. SR 지연처리에 대한 로직 체크 --- "처리요청일자 >= 작업완료일자 & 처리예정일자 >= 작업완료일자" 성립 안내)
			var completeDtVal = $('#complete_dt').val().trim();
			var procDtVal = $('#proc_dt').val().trim();
			var inquiryDtVal = $('#inquiry_dt').val().trim();

			
			if (common.isEmpty(completeDtVal) || common.isEmpty(procDtVal) || common.isEmpty(inquiryDtVal)) {
			    alert("날짜 값을 모두 입력해주세요.");
			} else {
			    
			    var completeDt = new Date(completeDtVal);
			    var procDt = new Date(procDtVal);
			    var inquiryDt = new Date(inquiryDtVal);

			    if (inquiryDt < completeDt || procDt < completeDt) {
			    	if (confirm('유지보수 품질심사 표준에 따라 아래 식이 성립되어야 합니다.\n[ 처리요청일자 >= 작업완료일자 & 처리예정일자 >= 작업완료일자 ]\n무시하고 저장하시겠습니까?')) {
				    } else {
				    	alert('일자를 수정하세요.');
						$('#complete_dt').focus();
						return;
				    }
				}
			}
			
			//2025.03.04 CMMI 관련 로직 추가(1.처리완료,배포승인일 경우 '조치 및 처리 의견' 값은 공백X)
			if (common.isEmpty($('#action_content').val().trim())) {
			    alert('조치 및 처리 의견을 입력하세요');
			    $('#action_content').focus();
			    return;
			}
			
		}

		/* 배정담당자와 승인자가 일치할 시 동료검토자 필수입력*/
		if ($('#assign_nm').val() == $('#appr_em').val()) {
			if (common.isEmpty($('#peer_review_nm').val())) {
				alert('동료검토자를 입력하세요.');
				$('#peer_review_nm').focus();
				return;
			}
		}

		var pageType = '${ vo.pageType}';
		var cust_gubun = $('#cust_gubun').val();
		var proc_status = $('#proc_status').val();
		if (pageType == 'update' || pageType == "subUpdate") {
			if (cust_gubun == 'C001') {
				//C001 JW그룹
				if (isDeployment) {
					//C012 배포승인
					if (proc_status == 'C012') {
						if (common.isEmpty($('#distr_filepath').val())) {
							alert("배포경로 및 배포파일명 선택하세요.");
							$('#distr_filepath').focus();
							return;
						}
						if (common.isEmpty($('#distr_svn_ver').val())) {
							alert("SVN버전 선택하세요.");
							$('#distr_svn_ver').focus();
							return;
						}
						if (common.isEmpty($('#distr_dt').val())) {
							alert("배포일자 선택하세요.");
							$('#distr_dt').focus();
							return;
						}

					}
				}
			}
		}
		var requestType = '${ vo.request_type}';
		console.log(requestType);
		if (confirm('저장 하시겠습니까?')) {
			$('#proc_time').val(
					$('#proc_time1').val() + "" + $('#proc_time2').val());
			$('#proc_status').prop('disabled', false);
			$('#proc_grade').prop('disabled', false);
			if ($('#send_email').is(":checked"))
				f.send_email.value = "Y";
			if ($('#send_sms').is(":checked"))
				f.send_sms.value = "Y";
			if ($('#user_test_yn').is(":checked"))
				f.user_test_yn.value = "Y";
			if ($('#normal_oper_yn').is(":checked"))
				f.normal_oper_yn.value = "Y";

			f.delAttach1.value = delAttach1;
			f.delAttach2.value = delAttach2;

			f.target = 'hiddenFrame';
			f.action = '/ad/as/proc.do';
			f.submit();
		}
	}

	function procReturn(gubun) {
		if (gubun == "success") {
			alert("정상적으로 처리 되었습니다.");
			goList();
		} else if(gubun == 'cnasfail'){
			alert("해당 AS번호의 하위작업 중 처리가 종료되지 않은 건이 존재합니다.\n하위작업 다시 확인 후 처리 부탁드립니다.");
			goList();
		}
		else {
			alert("처리도중 오류가 발생했습니다.");
			return;
		}
	}

	function initView() {
		var datas = {
			'as_no' : '${ vo.as_no }'
		};
		common.ajaxCall(datas, '/ad/as/getAsInfo.do', 'makeInitView');
	}

	function strip_tag(str) {
		return str.replace(
				/<(\/)?([a-zA-Z]*)(\s[a-zA-Z]*=[^>]*)?(\s)*(\/)?>/ig, "");
	}

	function makeInitView(data) {
		var resultVO = typeof data.resultVO != "undefined" ? data.resultVO
				: null;
		var attachList = typeof data.attachList != "undefined" ? data.attachList
				: null;
		var attachList2 = typeof data.attachList2 != "undefined" ? data.attachList2
				: null;
		var asHistList = typeof data.asHistList != "undefined" ? data.asHistList
				: null;

		var pageType = "${ vo.pageType }";
		if (resultVO != null) {
			$('#btnReSendEmail').hide();
			$('#as_no_text').html(common.nvl(resultVO.as_no, ''));
			$('#cn_as_no_text').html(common.nvl(resultVO.cn_as_no, ''));

			if (pageType != "subUpdate")
				common.ajaxCall({
					'as_no' : common.nvl(resultVO.as_no, '')
				}, '/ad/as/getCnAsList.do', 'makeCnAsList');
			else
				common.ajaxCall({
					'as_no' : common.nvl(resultVO.cn_as_no, '')
				}, '/ad/as/getCnAsList.do', 'makeCnAsList');

			if (common.nvl(resultVO.cust_seq, '') != '') {
				var datas = {
					'cust_seq' : common.nvl(resultVO.cust_seq, '')
				};
				common.ajaxCall(datas, '/ad/cust/getCustInfoBySeq.do',
						'makeCustInfo');
			}

			$('#accept_dt').val(makeDate(common.nvl(resultVO.accept_dt, '')));
			$('#accept_time').val(
					makeTime(common.nvl(resultVO.accept_time, '')));
			$('#accept_route').val(common.nvl(resultVO.accept_route, ''));
			$('#request_type').val(common.nvl(resultVO.request_type, ''));
			$('#action_type').val(common.nvl(resultVO.action_type, ''));

			$('#appr_sub_emp1').val(common.nvl(resultVO.appr_sub_emp1, ''));
			$('#appr_sub_emp2').val(common.nvl(resultVO.appr_sub_emp2, ''));
			
			$('#appr_ssub_emp1').val(common.nvl(resultVO.appr_ssub_emp1, ''));  	//2024.04.02 팀장승인 3차 결재자 관련 코드 추가
			$('#appr_ssub_emp2').val(common.nvl(resultVO.appr_ssub_emp2, ''));  	//2024.04.02 배포승인 3차 결재자 관련 코드 추가

			/* if ((common.nvl(resultVO.request_type, '') == 'C001' || common.nvl(  //2023.11.14 배포승인 조건 변경에 따른 코드 수정
					resultVO.request_type, '') == 'C017')
					&& common.nvl(resultVO.proc_status, '') == "C005") {
				$('#proc_gubun_th').append(
						'<span class="request mgl5">필수 입력</span>');
			} */
			
			if ((common.nvl(resultVO.action_type, '') == 'C001' || common.nvl(  //2023.11.14 배포승인 조건 변경에 따른 코드 수정
					resultVO.action_type, '') == 'C002')
					&& common.nvl(resultVO.proc_status, '') == "C005") {
				$('#proc_gubun_th').append(
						'<span class="request mgl5">필수 입력</span>');
			}

			if (common.nvl(resultVO.cust_seq, '') != "") {
				var datas = {
					"cust_seq" : common.nvl(resultVO.cust_seq, ''),
					"pageType" : "${ vo.pageType }"
				};
				common.ajaxCall(datas, '/ad/cust/getSystemInfo.do',
						'makeSystemType');
				$('#system_type').val(
						common.nvl(resultVO.system_type, '') + '@'
								+ common.nvl(resultVO.oper_seq, ''));
			}

			$('#oper_seq').val(common.nvl(resultVO.oper_seq, ''));

			if (common.nvl(resultVO.system_type, '') != "") {
				getTaskTypeByInfo(common.nvl(resultVO.system_type, ''), common 
						.nvl(resultVO.oper_seq, ''));
				$('#inquiry_type').val(common.nvl(resultVO.inquiry_type, ''));
			}

			var ex_call_content = '';
			if (common.nvl(resultVO.shared_doc_idx, '') != "") {
				ex_call_content = strip_tag(resultVO.call_content);
			} else {
				ex_call_content = resultVO.call_content;
			}

			$('#call_content').val(common.nvl(ex_call_content, ''));
			$('#call_content_view').html(common.nvl(resultVO.call_content, ''));
			showByte('call', $('#call_content').val());

			if (common.nvl(resultVO.inquiry_type, '') != "") { // 2023.07.11 subInsert관련 업무유형에 따른 배정담당자 정보 가져오게 하는 코드 추가
				getAssign(common.nvl(resultVO.inquiry_type, ''));
				$('#assign_nm').val(common.nvl(resultVO.assign_nm, ''));
				$('#assign_id').val(common.nvl(resultVO.assign_id, ''));
			}

			$('#apply_nm').val(common.nvl(resultVO.apply_nm, ''));
			$('#apply_id').val(common.nvl(resultVO.apply_id, ''));


			if (common.nvl(resultVO.apply_tel, '') != '') {
				$('#apply_tel1').val(
						common.spritStr(resultVO.apply_tel, 1, '-'));
				$('#apply_tel2').val(
						common.spritStr(resultVO.apply_tel, 2, '-'));
				$('#apply_tel3').val(
						common.spritStr(resultVO.apply_tel, 3, '-'));
			}

			$('#apply_sms_tel1').val(
					common.spritStr(resultVO.apply_sms_tel, 1, '-'));
			$('#apply_sms_tel2').val(
					common.spritStr(resultVO.apply_sms_tel, 2, '-'));
			$('#apply_sms_tel3').val(
					common.spritStr(resultVO.apply_sms_tel, 3, '-'));

			$('#file_seq').val(common.nvl(resultVO.file_seq, ''));
			$('#attach_seq2').val(common.nvl(resultVO.attach_seq2, ''));

			/** 이메일 */
			$('#apply_email').val(common.nvl(resultVO.apply_email, ''));
			/** 처리요청일 */
			$('#inquiry_dt').val(makeDate(common.nvl(resultVO.inquiry_dt, '')));

// 			if (pageType == "subInsert") {
// 				$("#proc_status").val("C000").prop("selected", true);
// 				//chgProcStatus($("#proc_status").val());                            //2023.07.11 처리상태(접수) 사용하지 않아 주석처리
// 			}
// 			if (pageType != "subInsert") {
				$('#proc_status').val(common.nvl(resultVO.proc_status, ''));
				$('#proc_status2').val(common.nvl(resultVO.proc_status, ''));

				if (common.nvl(resultVO.proc_status, '') == 'C000')
					$('#proc_status').val('');
			
				 if (common.nvl(resultVO.proc_status, '') == 'C006'){
					$("select[name='proc_status']").append("<option value='C006'>철회</option>");
					$("#proc_status").prop("disabled", true);
				}

				var proc_status = common.nvl(resultVO.proc_status, '');
				var state;
				for (var i = 1; i <= 5; i++) {
					if (state == proc_status) {
						if (!$('#stateC00' + i).hasClass("current"))
							$('#stateC00' + i).addClass("current");
					} else {
						if ($('#stateC00' + i).hasClass("current"))
							$('#stateC00' + i).removeClass("current");
					}
					if ("C002" == proc_status) {
						if (!$('#stateC002').hasClass("current"))
							$('#stateC002').addClass("current");
					}
					if ("C001" == proc_status || "C010" == proc_status) { //팀장승인 = 접수 프로세스
						if (!$('#stateC001').hasClass("current"))
							$('#stateC001').addClass("current");
					}
					if ("C005" == proc_status || "C012" == proc_status) { //배포승인 = 처리완료 프로세스 
						if (!$('#stateC005').hasClass("current"))
							$('#stateC005').addClass("current");
					}
				}

				/**	중요도	*/
				$('#inportance').val(common.nvl(resultVO.inportance, ''));
				/** 처리등급 */
				$('#proc_grade').val(common.nvl(resultVO.proc_grade, ''));
				/**	담당자	*/
				$('#assign_id').val(common.nvl(resultVO.assign_id, ''));
				/**	담당자	*/
				$('#assign_nm').val(common.nvl(resultVO.assign_nm, ''));
				/**	기존담당자	*/
				$('#chg_assign_id').val(common.nvl(resultVO.assign_id, ''));
				/**	동료검토자	*/
				$('#peer_review_nm').val(
						common.nvl(resultVO.peer_review_nm, ''));

				/** 처리구분 */
				$('#proc_gubun').val(common.nvl(resultVO.proc_gubun, ''));

				/** 빌드순번/cts빌드 */
				$('#proc_build_info').val(
						common.nvl(resultVO.proc_build_info, ''));
				/** 파일명/pbl */
				$('#proc_file_info').val(
						common.nvl(resultVO.proc_file_info, ''));
				/** 관련DB */
				$('#proc_db_info').val(common.nvl(resultVO.proc_db_info, ''));
				/** 테스트케이스 */
				$('#proc_test_info').val(
						common.nvl(resultVO.proc_test_info, ''));
				/** 프로세스정의서 */
				$('#proc_process_sp').val(
						common.nvl(resultVO.proc_process_sp, ''));
				/** 기능분해도 */
				$('#proc_function_sp').val(
						common.nvl(resultVO.proc_function_sp, ''));
				/** 화면정의서 */
				$('#proc_screen_sp').val(
						common.nvl(resultVO.proc_screen_sp, ''));
				/** ERD */
				$('#proc_erd_sp').val(common.nvl(resultVO.proc_erd_sp, ''));
				/** 테이블정의서 */
				$('#proc_table_sp').val(common.nvl(resultVO.proc_table_sp, ''));
				/** 인터페이스정의서 */
				$('#proc_interface_sp').val(
						common.nvl(resultVO.proc_interface_sp, ''));

				/** 조치및 처리의견 */
				$('#action_content').val(
						common.nvl(resultVO.action_content, ''));
				showByte('action', $('#action_content').val());
				
				/** 대상 프로젝트 */
				$('#target_project').val(common.nvl(resultVO.target_project, ''));

				/** 에상 작업시간, 작업시간 */
				if (pageType == "subInsert" || pageType == "insert") {
					$('#expected_work_time').val('');
					$('#progress_rate').val('');
					$('#work_time').val('');
				}else{
					$('#expected_work_time').val(common.nvl(resultVO.expected_work_time, ''));
					$('#progress_rate').val(common.nvl(resultVO.progress_rate, ''));
					$('#work_time').val(common.nvl(resultVO.work_time, ''));
				}
				
				
				//2023.10.31 하위작업에 따른 작업시간 칸 편집 가능 구분 코드 추가
				if (pageType == "update"){
					if(common.nvl(resultVO.work_time_yn, '') == 'Y'){
						$("#work_time").attr("readonly", "readonly").css("background-color", "#f3f3f3");
					} else{
						$("#work_time").removeAttr("readonly");
					}
				}
				
/* 				if(common.nvl(resultVO.work_time, '') == null){
					$('#work_time').removeAttr('readonly');
				}else{
					$('#work_time').attr('readonly','readonly');
				} */
				
				/** 작업완료시간 */
				if (common.nvl(resultVO.proc_status, '') == 'C000') {
					$('#proc_status').val('');
					$("#complete_dt").datepicker('option', 'disabled', true);
					$("#spanForAlert").on('click', function() {
						alert("처리상태가 대기일 때는 작업완료일자를 설정할 수 없습니다.");
					});
				} else {
					$('#complete_dt').val(
							makeDate(common.nvl(resultVO.complete_dt, '')));
				}
				/** 사용자테스트 여부 */
				if (common.nvl(resultVO.user_test_yn, '') == "Y")
					$('#user_test_yn').prop("checked", true);
				/** 정상작동 여부 */
				if (common.nvl(resultVO.normal_oper_yn, '') == "Y")
					$('#normal_oper_yn').prop("checked", true);
				/** 테스트 비고 */
				$('#test_note').val(common.nvl(resultVO.test_note, ''));
				/** 사용자테스트자ID*/
				$('#user_test_id').val(common.nvl(resultVO.user_test_id, ''));
				/** 사용자테스트자 이름*/
				$('#user_test_nm').val(common.nvl(resultVO.user_test_nm, ''));
				/** 사용자테스트자 IP*/
				$('#user_test_ip').val(common.nvl(resultVO.user_test_ip, ''));
				/** jw 문서ID */
				$('#shared_doc_id').val(common.nvl(resultVO.shared_doc_id, ''));
				/** jw 문서ID */
				$('#shared_doc_idx').val(
						common.nvl(resultVO.shared_doc_idx, ''));
				/** jw 승인자 ID */
				$('#approval_id').val(common.nvl(resultVO.approval_id, ''));
				/** jw 승인자  이름*/
				$('#approval_nm').val(common.nvl(resultVO.approval_nm, ''));
				$('#approval_dt').val(
						makeDate(common.nvl(resultVO.approval_dt, '')));
				$('#approval_time').val(
						makeTime(common.nvl(resultVO.approval_time, '')));
				/** jw 승인자 접수의견 */
				$('#shared_tag').val(common.nvl(resultVO.shared_tag, ''));
				/** 거래처 구분 		*/
				$('#cust_gubun').val(common.nvl(resultVO.cust_gubun, ''));

				if (common.nvl(resultVO.send_email, '') == "Y") {
					$('#send_email').attr("checked", true);
				} else {
					$('#send_email').attr("checked", false);
					$("#send_email_th").empty();
					$("#send_email_th").append("이메일 수신 주소");
					$("#apply_email").attr("readonly", "readonly");
				}

				if (common.nvl(resultVO.send_sms, '') == "Y") {
					$('#send_sms').attr("checked", true);
				} else {
					$('#send_sms').attr("checked", false);
					$("#send_sms_th").empty();
					$("#send_sms_th").append("SMS 수신 전화번호");
					$("#apply_sms_tel1").attr("readonly", "readonly");
					$("#apply_sms_tel2").attr("readonly", "readonly");
					$("#apply_sms_tel3").attr("readonly", "readonly");

				}

				/** '접수'상태 일 경우 본인이름 담당자로 노출  */
				/* if (common.nvl(resultVO.proc_status, '') == 'C001'){
					$("#proc_status").val("C002").prop("selected", true);
					chgProcStatus($("#proc_status").val());
				} */

				if (common.nvl(resultVO.proc_status, '') == 'C005') {
					$("#cause_type_th").append(
							'<span class="request mgl5">필수 입력</span>');
					$("#action_type_th").append(
							'<span class="request mgl5">필수 입력</span>');
					$("#work_time_th").append(
							'<span class="request mgl5">필수 입력</span>');
					$("#complete_dt_th").append(
							'<span class="request mgl5">필수 입력</span>');
					$("#proc_dt_th").append(
							'<span class="request mgl5">필수 입력</span>');
					$("#proc_grade_th").append(
							'<span class="request mgl5">필수 입력</span>');
					$("#action_content_th").append(
							'<span class="request mgl5">필수 입력</span>');

					if (($('#request_type').val() == 'C001' || $(
							'#request_type').val() == 'C017')) {
						$('#proc_gubun_th').children().remove();
						$('#module_th').children().remove();

						$('#proc_gubun_th').append(
								'<span class="request mgl5">필수 입력</span>');
						$('#module_th').append(
								'<span class="request mgl5">필수 입력</span>');

						/*2022.01. 처리완료 안내 메일 재전송 버튼 추가*/
						if ($('#cust_gubun').val() == 'C001') {
							$('#btnReSendEmail').show();
						}
					}
				}

				/* 접수건의 '중요도'가 널일 경우, '일반'값으로 기본 셋팅한다 */
				if (resultVO.inportance == '' || resultVO.inportance == null) {
					$('#inportance').val('C002');//2017.01.02
				}

				$('#proc_dt').val(makeDate(common.nvl(resultVO.proc_dt, '')));

				if (common.nvl(resultVO.proc_dt, '') != "") {
					$('#proc_time1').val(
							common.nvl(resultVO.proc_time, '').substr(0, 2));
					$('#proc_time2').val(
							common.nvl(resultVO.proc_time, '').substr(2, 2));
				}

				$('#cause_type').val(common.nvl(resultVO.cause_type, ''));
				$('#action_type').val(common.nvl(resultVO.action_type, ''));

				if (pageType.indexOf("pdate") != -1) {
					if (pageType == "update") {
						$('#as_no').val(common.nvl(resultVO.as_no, ''));
					} else {
						$('#as_no').val(common.nvl(resultVO.cn_as_no, ''));
						$('#sel_cn_as_no').val(common.nvl(resultVO.as_no, ''));
						$('#cn_as_no').val(common.nvl(resultVO.as_no, ''));
					}

				} else {
					$('#as_no').val(common.nvl(resultVO.as_no, ''));
				}
				$('#cmc_pic').val(common.nvl(resultVO.cmc_pic, ''));
				$('#program_satisfaction').val(
						common.nvl(resultVO.program_satisfaction, ''));

				/* CMC add 모듈 , 중분류 , 프로그램명  2021.01.12*/
				$('#module_name').val(common.nvl(resultVO.module_name, ''));
				$('#category_id').val(common.nvl(resultVO.category_id, ''));
				$('#category_name').val(common.nvl(resultVO.category_name, ''));
				$('#program_name').val(common.nvl(resultVO.program_name, ''));
				$('#program_id').val(common.nvl(resultVO.program_id, ''));

				/*사용자 테스트 일자, 시간*/
				$('#user_test_dt').val(
						makeDate(common.nvl(resultVO.user_test_dt, '')));
				$('#user_test_time').val(
						common.nvl(resultVO.user_test_time, ''));

// 			} else {
// 				for (var i = 1; i <= 5; i++) {
// 					if (i == 2) {
// 						if (!$('#stateC00' + i).hasClass("current"))
// 							$('#stateC00' + i).addClass("current");
// 					} else {
// 						if ($('#stateC00' + i).hasClass("current"))   //2023.07.11 하위작업 생성 별도 처리 위해 주석처리
// 							$('#stateC00' + i).removeClass("current");
// 					}
// 				}

// 				$('#as_no').val(common.nvl(resultVO.as_no, ''));

// 			}
		}

		//JW shared service 
		/* if( common.nvl(resultVO.shared_attach, '') !=''){
			
			var str = '';
			str += '<tr>';
			str += '<th>파일첨부</th>';
			str += '<td colspan="3">';
			str += '		<input type="file" id="" name="" class="w225 mgr5">';
			str += '		<button type="button" class="btn_ico_down mgr5" onclick="javascript:fileDown2(\''+common.nvl(resultVO.shared_doc_id, '')+'\');"><span>다운로드</span></button>'+common.nvl(resultVO.shared_filenm, '')+'';					
			str += '		</td>';
			str += '</tr>';
			$('#wrapMfile').append(str);
		} 
		 */

		//JW 
		if (common.nvl(resultVO.shared_attach, '') != '') {
			var str = '';
			str += '<tr>';
			str += '<th>파일첨부</th>';
			str += '<td colspan="3">';
			str += '		<input type="file" id="" name="" class="w225 mgr5">';
			str += '		<button type="button" class="btn_ico_down mgr5" onclick="javascript:fileDown3(\''
					+ common.nvl(resultVO.gw_file_addr, '')
					+ '\', \''
					+ common.nvl(resultVO.shared_filepath, '')
					+ '\', \''
					+ common.nvl(resultVO.shared_filenm, '')
					+ '\');"><span>다운로드</span></button>'
					+ common.nvl(resultVO.shared_filenm, '') + '';
			str += '		</td>';
			str += '</tr>';
			$('#wrapMfile').append(str);
		}

		if (pageType != "subInsert") {
			if (attachList != null && attachList.length > 0) {

				for (var i = 0; i < attachList.length; i++) {

					var datas = attachList[i];

					var str = '';
					str += '<tr id="mfile'+mfile_cnt+'">';
					str += '<th>파일첨부</th>';
					str += '<td colspan="3">';
					str += '		<input type="file" id="uploadFile_'+mfile_cnt+'" name="uploadFile_'+mfile_cnt+'" class="w225 mgr5">';
					if (i > 0)
						str += '		<button type="button" class="btn_minus mgr5" onclick="delMfile('
								+ mfile_cnt + ');"></button>';
					else
						str += '		<span type="button" class="btn_plus mgr5" onclick="addMultiFile();"></span>';
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
			} else {
				addMultiFile();
			}

			if (attachList2 != null && attachList2.length > 0) {
				for (var i = 0; i < attachList2.length; i++) {
					var datas2 = attachList2[i];
					var str2 = '';
					str2 += '<tr id="file'+file_cnt+'">';
					str2 += '<th>파일첨부</th>';
					str2 += '<td colspan="3">';
					str2 += '		<input type="file" id="upFile_'+file_cnt+'" name="upFile_'+file_cnt+'" class="w225 mgr5">';
					if (i > 0)
						str2 += '		<button type="button" class="btn_minus mgr5" onclick="delfile('
								+ file_cnt + ');"></button>';
					else
						str2 += '		<span type="button" class="btn_plus mgr5" onclick="addFile();"></span>';
					str2 += '		<button type="button" class="btn_ico_down mgr5" onclick="javascript:fileDown(\''
							+ common.nvl(datas2.attach_seq, '')
							+ '\' , \''
							+ common.nvl(datas2.attach_ord, '')
							+ '\');"><span>다운로드</span></button>'
							+ common.nvl(datas2.attach_ori_nm, '') + '';
					str2 += '		</td>';
					str2 += '</tr>';
					$('#wrapFile').append(str2);
					$('#file_cnt').val(file_cnt);

					file_cnt = Number(common.nvl(datas.attach_ord, '0')) + 1;
				}
			} else {
				addFile();
			}

		} else {
			addMultiFile();
			addFile();
		}

		//addFile() ;  //처리사항완료에 있는 첨부파일은 조치이력 리스트에서만 불러옴

		$('#asHistTbody').empty();

		if (asHistList != null && asHistList.length > 0) {

			var str = '';

			console.log(asHistList);
			for (var i = 0; i < asHistList.length; i++) {
				var datas = asHistList[i];
				var cLen = datas.memo.length;
				var contents = '';
				if (parseInt(cLen) > 30) {
					contents = common.nvl(datas.memo, '').substring(0, 30)
							+ '...'
							+ '<button type="button" class="btn_list_blue" onclick="showHistContent('
							+ (i + 1) + ');"><span>전체보기</span></button> ';
					$('#wrap_contents').append(
							'<input type="hidden" id="layer_cont' + (i + 1)
									+ '" value="' + common.nvl(datas.memo, '')
									+ '" />');
				} else {
					contents = common.nvl(datas.memo, '');
				}

				str += '<tr> ';
				str += '	<td>' + common.nvl(datas.reg_date, '') + '</td> ';
				str += '	<td>' + common.nvl(datas.reg_nm, '') + '</td> ';//등록자
				str += '	<td>' + common.nvl(datas.emp_nm, '') + '</td> ';//인수자
				str += '	<td>' + common.nvl(datas.proc_status_nm, '')
						+ '</td> ';
				str += '	<td>' + contents + '</td> ';
				str += '</td>';
				str += '</tr> ';

			}

			$('#asHistTbody').append(str);

		} else {
			commonTable.notData(5, '조회된 데이터가 없습니다.', 'asHistTbody');
		}

		/* 답변내역 값 셋팅*/
		var starCnt = common.nvl(resultVO.star_state, '');
		if (starCnt > 0)
			$('#wrap_star').show();
		if (starCnt == 1)
			$('input#star1').prop('checked', true);
		else if (starCnt == 2)
			$('input#star2').prop('checked', true);
		else if (starCnt == 3)
			$('input#star3').prop('checked', true);
		else if (starCnt == 4)
			$('input#star4').prop('checked', true);
		else if (starCnt == 5)
			$('input#star5').prop('checked', true);
		$('#star_content').val(common.nvl(resultVO.star_content, '')); //건의사항

		/* AS승인 프로세스 추가에 따른 셋팅추가 (CMC) */
		var pageType = '${ vo.pageType}'
		//if(pageType == 'update'){  
		$('#cust_gubun').val(common.nvl(resultVO.cust_gubun, ''));

		var cust_gubun = $('#cust_gubun').val();
		//if(cust_gubun == 'C001'){
		proc_status_current = common.nvl(resultVO.proc_status, ''); //처리상태
		aprv_status_teamLead = common.nvl(resultVO.gyul_gb1, ''); //승인대상(팀장) 
		aprv_status_Deployment = common.nvl(resultVO.gyul_gb2, ''); //승인대상(배포) 
		appr_emp1 = common.nvl(resultVO.appr_emp1, ''); //승인자사번
		appr_emp2 = common.nvl(resultVO.appr_emp2, '');
		appr_date1 = common.nvl(resultVO.appr_date1, '');
		appr_date2 = common.nvl(resultVO.appr_date2, '');
		appr_em_nm_1 = common.nvl(resultVO.appr_emp1_nm, ''); //승인자이름
		appr_em_nm_2 = common.nvl(resultVO.appr_emp2_nm, '');

		if(pageType == 'subInsert'){
			$('#appr_yn1').val('N');
		} else {
			$('#appr_yn1').val(common.nvl(resultVO.appr_yn1, ''));
		}
		
		$('#appr_yn2').val(common.nvl(resultVO.appr_yn2, ''));
		$('#appr_emp1').val(common.nvl(resultVO.appr_emp1, ''));
		$('#appr_emp2').val(common.nvl(resultVO.appr_emp2, ''));
		$('#appr_date1').val(common.nvl(resultVO.appr_date1, ''));
		$('#appr_date2').val(common.nvl(resultVO.appr_date2, ''));
		$('#proc_status').val(common.nvl(resultVO.proc_status, ''));
		$('#distr_filepath').val(common.nvl(resultVO.distr_filepath, ''));
		$('#distr_svn_ver').val(common.nvl(resultVO.distr_svn_ver, ''));
		$('#distr_dt').val(makeDate(common.nvl(resultVO.distr_dt, '')));
		$('#memo').val(common.nvl(resultVO.memo, ''));
		checkTypeQuestion();
		//} 
		//}

	}//makeInitView()

	function showHistContent(num) {
		$('#div5').show();
		$('#div5_dim').show();
		$('#show_hist_contents').val('');
		$('#show_hist_contents').val($('#layer_cont' + num).val());
		$('html, body').animate({
			'scrollTop' : 0
		}, 'slow');
	}

	function makeCnAsList(data) {

		var resultList = typeof data.resultList != 'undefined' ? data.resultList
				: null;
		if (resultList != null && resultList.length > 0) {
			var str = '';
			for (var i = 0; i < resultList.length; i++) {
				var datas = resultList[i];
				str += '<option value="' + common.nvl(datas.as_no, '') + '">'
						+ datas.as_no + '</option>';
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
		f.target = '';
		f.action = "/ad/as/form.do";
		f.submit();
	}

	function btnInitCnAs() {
		if (confirm('하위작업을 생성하시겠습니까?\n작성 중인 작업이 취소됩니다.')) {
			var f = document.procFrm;
			f.pageType.value = 'subInsert';
			f.method = 'GET';
			f.action = '/ad/as/form.do';
			f.submit();
		}
	}

	function showFileLayer(attach_seq2) {
		$('#div4').show();
		$('#div4_dim').show();
		//$('html, body').scrollTop(0);
		$('html, body').animate({
			'scrollTop' : 0
		}, 'slow');

		var datas = {
			'attach_seq2' : attach_seq2
		};
		common.ajaxCall(datas, '/ad/as/getAsHistFileInfo.do', 'makeFileList');
	}

	function makeFileList(data) {

		var attach2FileList = typeof data.attach2FileList != 'undefined' ? data.attach2FileList
				: null;
		$('#attach2FileList').empty();

		if (attach2FileList != null && attach2FileList.length > 0) {
			var str = '';

			for (var i = 0; i < attach2FileList.length; i++) {
				var datas = attach2FileList[i];
				str += '<tr>';
				str += '	<th scope="row">첨부파일' + (i + 1) + '</th>';
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
		if (type == 'cust') {
			location.href = '/ad/cust/form.do?pageType=update&seq='
					+ $('#cust_seq').val() + '&cust_kor_name='
					+ encodeURI($('#cust_kor_name').val()) + '&crm_code='
					+ $('#cust_code').val();
		} else if (type == 'member') {
			location.href = '/ad/member/form.do?pageType=update&emp_id='
					+ $('#apply_id').val();
		}
	}

	function btnEmpField(type) {
		if (common.isEmpty($('#cust_code').val())) {
			alert('고객사를 조회해 주세요.');
			return;
		}
		$('#apply_nm').val('').prop('readonly', false).prop('placeholder',
				'이름을 입력하세요.');
		$('#apply_id').val('');
		$('#apply_nm').focus();
		if (type == 'layer')
			closeLayer(2);
	}

	function chgProcStatus(code) {
		if (code == 'C001') {
			$('#assign_nm').val($("#sel_assign_id option:selected").text());
			$('#assign_id').val($("#sel_assign_id option:selected").val());
		}
	}

	function chProcStatus(val) {
	
		var request_type = $('#request_type').val();
		var action_type = $('#action_type').val(); //조치유형
		var cust_gubun = $('#cust_gubun').val(); //거래처구분  C001:JW그룹, C002:대외기업, C003:공공기관, C004:본사

		//2024.07.26 김규민 - 사용자 확인 구분은 조치유형을 기준으로 설정되도록 한다.
		if ((action_type == "C001" || action_type == "C002") && val == "C005") {

			$('#proc_gubun_th').children().remove();
			$('#module_th').children().remove();

			$('#proc_gubun_th').append(
					'<span class="request mgl5">필수 입력</span>');
			$('#module_th').append('<span class="request mgl5">필수 입력</span>');

			/*2022.01.이설아 수정	거래처구분  C001:JW그룹, C002:대외기업, C003:공공기관, C004:본사*/
			if (cust_gubun != "C001") {
				$('#user_test_yn').prop("checked", true);
				$('#normal_oper_yn').prop("checked", true);
				$('#test_note').val("특이사항 없음");
			}

		} else {
			$("#proc_gubun_th").children().remove();
			$('#module_th').children().remove();
			$('#user_test_yn').prop("checked", false);
			$('#normal_oper_yn').prop("checked", false);
			$('#test_note').val("");
		}

		var pageType = '${vo.pageType}'
		if (pageType == 'insert') { //(신규등록)처리상태 변경시 메세지체크

			/* 신규등록시 팀장승인, 팀장반려, 배포승인, 배포반려  처리상태 입력불가  */
			if (val == 'C010' || val == 'C011' || val == 'C012'
					|| val == 'C013') {
				$('#proc_status').val(proc_status_current);
				alert("처리상태 입력 불가능합니다.");
				return;
			}

			//if(cust_gubun == 'C001'){ //거래처구분이 JW그룹인 경우 	
			if (isTeamLead == true || isDeployment == true) { //승인대상(팀장 또는 배포) Y 해당 
				/* 신규등록시 접수 외에 처리상태 입력불가 */
				if (val != 'C000') {
					$('#proc_status').val(proc_status_current);
					alert("신규등록 (JW그룹 및 문의유형 기준) 처리상태는 대기만 가능합니다.");
					return;
				}
			}

			//}
		}
		
		if (pageType == 'subInsert') {   //2023.07.13 하위작업생성 후 신규등록 시(처리상태 변경 시 메세지 체크)

			/* 신규등록시 팀장승인, 팀장반려, 배포승인, 배포반려  처리상태 입력불가  */
			if (val == 'C010' || val == 'C011' || val == 'C012'
					|| val == 'C013') {
				$('#proc_status').val('C000');
				alert("처리상태 입력 불가능합니다.");
				return;
			}

			//if(cust_gubun == 'C001'){ //거래처구분이 JW그룹인 경우 	
			if (isTeamLead == true || isDeployment == true) { //승인대상(팀장 또는 배포) Y 해당 
				/* 신규등록시 접수 외에 처리상태 입력불가 */
				if (val != 'C000') {
					$('#proc_status').val('C000');
					alert("하위작업신규등록 처리상태는 대기만 가능합니다.");
					return;
				}
			}

			//}
		}

		if (pageType == 'update' || pageType == 'subUpdate') { //(수정)처리상태 변경시 메세지체크     //2023.07.13 하위작업생성 후 수정 시(처리상태 변경 시 메세지 체크)
			//var cust_gubun = $('#cust_gubun').val();  
			var appr_yn1 = $('#appr_yn1').val();
			var appr_yn2 = $('#appr_yn2').val();
			var accept_dt = $('#accept_dt').val();

			//if(cust_gubun == 'C001'){ //거래처구분이 JW그룹인 경우 	(JW그룹인 경우, JW그룹이 아닌경우에도 모두 동일하게 AS승인프로세스 2020.09.03.)									

			if (accept_dt < '2020/09/01') { //접수일자 2020년09월01일이전 데이터 메세지체크

				/* 팀장승인, 팀장반려, 배포승인, 배포반려  처리상태 변경불가  */
				if (val == 'C010' || val == 'C011' || val == 'C012'
						|| val == 'C013') {
					if (val != proc_status_current) {
						$('#proc_status').val(proc_status_current);
						alert("처리상태를 변경 불가능합니다. 8");
						return;
					}
				}

			} else { //접수일자 2020년09월01일이후 승인 프로세스 

				/* 팀장반려, 배포반려 인경우 처리상태 변경불가  */
				if (proc_status_current == 'C011'
						|| proc_status_current == 'C013') {
					if (val != proc_status_current) {
						$('#proc_status').val(proc_status_current);
						alert("처리상태를 변경 불가능합니다. 5");
						return;
					}
				}

				if (aprv_status_teamLead != 'Y'
						&& aprv_status_Deployment != 'Y') { //승인대상(팀장,배포) 모두 해당 안될경우
					/* 팀장승인, 팀장반려, 배포승인, 배포반려  처리상태 입력불가  */
					if (val == 'C010' || val == 'C011' || val == 'C012'
							|| val == 'C013') {
						if (val != proc_status_current) {
							$('#proc_status').val(proc_status_current);
							alert("처리상태를 변경 불가능합니다. 6");
							return;
						}
					}
				}

				if (aprv_status_teamLead == 'Y') { //승인대상(팀장) = Y
					if (appr_yn1 == 'N') { // appr_yn1 (Y:결재, N:미결, R:부결) 팀장승인여부가 미결시 메시지 체크		 				
						/* 승인대상(팀장) = Y 인경우 접수 외에 처리상태 변경불가 */
						//if(val != proc_status_current && val != 'C001'){  //문의유형 승인대상 해당되는걸로 변경하고 처리상태 변경없이 저장하면 메세지가 안탄다! 2020.08.27.
						if (val != 'C000') {
							$('#proc_status').val(proc_status_current);
							//alert("처리상태를 변경 불가능합니다. 1"); 							
							//alert("문의유형이 승인대상에 해당 됩니다. ~r~n문의유형 또는 처리상태 변경시 (JW그룹 및 문의유형 기준, 팀장승인 미결) ~r~n처리상태는 접수만 가능합니다. 처리상태 접수로 변경바랍니다!!");   
							alert("문의유형이 승인대상에 해당 됩니다. (JW그룹 및 문의유형 기준) 팀장승인후 처리상태 변경바랍니다. 프로세스: 대기 - 팀장승인 - 접수");
							return;
						}

						//승인대상(팀장) = Y 해당시 팀장승인여부 = Y 메세지체크 
					} else {
						/* 승인대상(팀장) = Y 해당시 팀장승인여부 = Y 인경우 접수, 담당자배정중(변경), 배정완료, 처리중, 처리완료, 반려, 팀장승인으로 변경가능, 그외 변경불가 */
						if (val != proc_status_current && val != 'C001'
								&& val != 'C002' && val != 'C003'
								&& val != 'C004' && val != 'C005'
								&& val != 'C009' && val != 'C010') {
							$('#proc_status').val(proc_status_current);
							alert("처리상태를 변경 불가능합니다. 2");
							return;
						}

					}
				}

				if (aprv_status_Deployment == 'Y') { //승인대상(배포) = Y  
					if (appr_yn2 != 'Y' && appr_yn1 == 'Y') { //승인대상(배포) = Y 해당시 배포승인여부 Y가 아니면 메세지체크 					   
						/* 승인대상(배포) = Y 해당시 배포승인여부 Y가 아니면 처리완료에서 팀장승인으로 역으로 변경가능(잘못승인시 팀장승인 취소하려면), 처리상태 접수, 담당자배정중(변경), 배정완료, 처리중, 처리완료, 반려, 팀장승인으로 변경가능, 그외 변경불가  */
						if (val != proc_status_current && val != 'C001'
								&& val != 'C002' && val != 'C003'
								&& val != 'C004' && val != 'C005'
								&& val != 'C009' && val != 'C010') {
							$('#proc_status').val(proc_status_current);
							alert("처리상태를 변경 불가능합니다. 3");
							return;
						}

						//승인대상(배포) = Y 해당시 배포승인여부 = Y 메세지체크 
					} else {
						if (appr_yn1 == 'Y') {
							if (val != proc_status_current) {
								$('#proc_status').val(proc_status_current);
								alert("처리상태를 변경 불가능합니다. 4");
								return;
							}
						}
					}
				}
			}

		}

		if (val == "C005") {

			$("#cause_type_th").children().remove();
			$("#action_type_th").children().remove();
			$("#work_time_th").children().remove();
			$("#complete_dt_th").children().remove();
			$("#proc_dt_th").children().remove();
			$("#proc_grade_th").children().remove();
			$("#action_content_th").children().remove();

			$("#cause_type_th").append(
					'<span class="request mgl5">필수 입력</span>');
			$("#action_type_th").append(
					'<span class="request mgl5">필수 입력</span>');
			$("#work_time_th")
					.append('<span class="request mgl5">필수 입력</span>');
			$("#complete_dt_th").append(
					'<span class="request mgl5">필수 입력</span>');
			$("#proc_dt_th").append('<span class="request mgl5">필수 입력</span>');
			$("#proc_grade_th").append(
					'<span class="request mgl5">필수 입력</span>');
			$("#action_content_th").append(
					'<span class="request mgl5">필수 입력</span>');

			/* //문의유형에 따라 조치유형 세팅
			var requestVal = $("#request_type").val();
			if (requestVal == "C001") {
				$('#action_type').val('C001');
				setProcGrade('C001');
			} //문의유형:프로그램신규개발	-조치유형:프로그램신규개발
			else if (requestVal == "C017") {
				$('#action_type').val('C002');
				setProcGrade('C002');
			} //문의유형:프로그램수정	-조치유형:프로그램수정
			else if (requestVal == "C002") {
				$('#action_type').val('C003');
				setProcGrade('C003');
			} //문의유형:데이터수정		-조치유형:데이터처리
			else if (requestVal == "C003") {
				$('#action_type').val('C004');
				setProcGrade('C004');
			} //문의유형:데이터요청		-조치유형:자료제공
			else if (requestVal == "C999") {
				$('#action_type').val('C999');
				setProcGrade('C999');
			} //문의유형:기타			-조치유형:기타
			else {
				$('#action_type').val('');
				$('#proc_grade').val('');
			} */
				
			}else{
			$("#cause_type_th").children().remove();
			$("#action_type_th").children().remove();
			$("#work_time_th").children().remove();
			$("#complete_dt_th").children().remove();
			$("#proc_dt_th").children().remove();
			$("#proc_grade_th").children().remove();
			$("#action_content_th").children().remove();

			}
	//}
		}
	
		
	function chRequestType(val) {

		var pageType = '${ vo.pageType}';
		var proc_status = $("#proc_status").val();
		
		//2025.03.04 CMMI 관련 로직 추가(3.문의유형이 "교육 수강,교육 진행,점검,응대,회의/출장"인 경우를 제외하고는 원인유형,조치유형에서 "기타"를 선택할 수 없다)
		if (!(val == "C008" || val == "C015" || val == "C016" || val == "C018" || val == "C019")){
			if($('#action_type').val() == "C999"){
				alert('조치유형이 "기타"인 경우에는 문의유형에서 "교육 수강","교육 진행","점검","응대","회의/출장"이 아닌 유형을 선택하실 수 없습니다.');
				$('#action_type').val("");
				$('#action_type').focus();
				return;
			}
			
			if($('#cause_type').val() == "C999"){
				alert('원인유형이 "기타"인 경우에는 문의유형에서 "교육 수강","교육 진행","점검","응대","회의/출장"이 아닌 유형을 선택하실 수 없습니다.');
				$('#cause_type').val("");
				$('#cause_type').focus();
				return;
			}
		}
		
		
		//2023.11.06. 배포승인 조건을 문의유형>>조치유형 변경으로 인한 코드 주석처리(처리완료 상세 사항 -- 처리구분)
		/* if ((val == "C001" || val == "C017") && proc_status == "C005") {
			$('#proc_gubun_th').append(
					'<span class="request mgl5">필수 입력</span>');
		} else {
			$("#proc_gubun_th").children().remove();
		} */

		/* if ($('#proc_status').val() == "C005") {
			if (val == "C001") {
				$('#action_type').val('C001');
				setProcGrade('C001');
			} //문의유형:프로그램신규개발	-조치유형:프로그램신규개발
			else if (val == "C017") {
				$('#action_type').val('C002');
				setProcGrade('C002');
			} //문의유형:프로그램수정	-조치유형:프로그램수정
			else if (val == "C002") {
				$('#action_type').val('C003');
				setProcGrade('C003');
			} //문의유형:데이터수정		-조치유형:데이터처리
			else if (val == "C003") {
				$('#action_type').val('C004');
				setProcGrade('C004');
			} //문의유형:데이터요청		-조치유형:자료제공
			else if (val == "C999") {
				$('#action_type').val('C999');
				setProcGrade('C999');
			} //문의유형:기타			-조치유형:기타
			else {
				$('#action_type').val('');
				$('#proc_grade').val('');
			}
		} */

		//처리상태가 처리완료(C005)이고, 문의유형이 '프로그램 신규 개발(C001) 또는 프로그램 개선(C017)'일 때 모듈 필수입력
		//2023.11.06. 배포승인 조건을 문의유형>>조치유형 변경으로 인한 코드 변경(모듈) //2023.11.14.
		if (($('#action_type').val() == "C001" || $('#action_type').val() == "C002")
				&& $('#proc_status').val() == "C005") {
			$("#proc_gubun_th").children().remove();
			$("#module_th").children().remove();

			$('#proc_gubun_th').append(
					'<span class="request mgl5">필수 입력</span>');
			$('#module_th').append('<span class="request mgl5">필수 입력</span>');
		} else {
			$("#proc_gubun_th").children().remove();
			$("#module_th").children().remove();
		}

		//		if(pageType == 'update'){
		var cust_gubun = $('#cust_gubun').val();
		//			if(cust_gubun == 'C001'){
		checkTypeQuestion();
		//			}

		//		}

	}
	
	//2025.03.04 CMMI 관련 로직 추가(3.문의유형이 "교육 수강,교육 진행,점검,응대,회의/출장"인 경우를 제외하고는 원인유형,조치유형에서 "기타"를 선택할 수 없다)
	function chCauseType(val) {
		if(val == "C999"){
			if(!($('#request_type').val() == 'C008'
				|| $('#request_type').val() == 'C015'
				|| $('#request_type').val() == 'C016'
				|| $('#request_type').val() == 'C018'
				|| $('#request_type').val() == 'C019')){
				
				alert('문의유형이 [교육 수강, 교육 진행, 점검, 응대, 회의/출장]\n외에는 조치유형을 "기타"로 선택하실 수 없습니다.');
				$('#cause_type').val("");
				$('#cause_type').focus();
				return;
			}
		}
	}

	function setApprovalRequestType(data) {
		cancelApprovalStatus();
		var data = typeof data.resultVO != 'undefined' ? data.resultVO : null;
		if (data.cnt == "1") {
			var str = '';
			str += '<button type="button" class="btn_line_gray mgl5" id="approval_btn" onclick="javascript:setApprovalStatus()">승인대기</button>';
			str += '<span id="approval_text" style="color:blue;" class="mgl5" >결재자에게 승인이 필요한 문의 유형입니다.</span>';
			$('#td_proc_status').append(str);
		}
	}

	function setApprovalStatus() {

		$('#approval_btn').remove();
		$('#approval_text').remove();

		var str = '';
		str += '<button type="button" class="btn_line_gray w100 mgl5" id="cancel_approval_btn" onclick="javascript:cancelApprovalStatus()">승인대기 해제</button>';
		$('#td_proc_status').append(str);

		$('#proc_status')
				.append(
						'<option value="C007" selected id="option_approval">승인대기</option>');
		$('#proc_status').attr('disabled', true);
	}

	function cancelApprovalStatus() {

		$('#cancel_approval_btn').remove();
		$('#approval_btn').remove();
		$('#approval_text').remove();
		$('#proc_status').attr('disabled', false);
		$("#option_approval").remove();
	}

	////답변-첨부파일/////////////////////////////////////////////////////////////////////////////////

	function addAswFile() {
		var str = '';
		str += '';

		str += '<tr id="asw_file'+aswfile_cnt+'">';
		str += '<th scope="row">첨부파일</th>';
		str += '<td>';
		str += '		<input type="file" id="uploadFile'+aswfile_cnt+'" name="uploadFile'+aswfile_cnt+'" class="w225">';
		if (aswfile_cnt > 1)
			str += '		<button class="btn_minus mgr5" onclick="delAswFile('
					+ aswfile_cnt + ');"></button>';
		else
			str += '		<span class="btn_plus mgr5" onclick="addAswFile();"></span> ';
		str += '		<!-- <button type="button" class="btn_ico_down mgr5"><span>다운로드</span></button> -->';
		str += '		</td>';
		str += '</tr>';
		$('#aswWrapFile').append(str);
		$('#aswfile_cnt').val(aswfile_cnt);

		aswfile_cnt++;
	}

	function delAswFile(cnt) {
		console.log(cnt);
		$('#asw_file' + cnt).remove();

		if (delAttach3 == "")
			delAttach3 = cnt;
		else
			delAttach3 = delAttach3 + "@" + cnt;
	}
	
	function validateEmailform() {

		if ($("#send_email").is(":checked")) {
			$('#apply_email').removeAttr('readonly');
			$("#send_email_th").append(
					'<span class="request mgl5">필수 입력</span>');
			if ($('#apply_id').val() != ""){ //2023.10.30 EMAIL 체크 시 정보 다시 기입 기능 추가
				
				var datas = {
						'emp_id' : $('#apply_id').val(),
					};
			common.ajaxCall(datas, '/ad/member/getEmpInfo.do', 'makeEmpInfo2');
			}
		} else {
			$('#apply_email').val('');
			$('#apply_email').attr('readonly', 'readonly');
			$("#send_email_th").children().remove();
		}
		;
	};

	function validateSMSform() {

		if ($("#send_sms").is(":checked")) {
			$('#apply_sms_tel1').removeAttr('readonly');
			$('#apply_sms_tel2').removeAttr('readonly');
			$('#apply_sms_tel3').removeAttr('readonly');
			$("#send_sms_th").append('<span class="request mgl5">필수 입력</span>');
			
			if ($('#apply_id').val() != ""){ //2023.10.30 SMS 체크 시 정보 다시 기입 기능 추가
				
				var datas = {
						'emp_id' : $('#apply_id').val(),
					};
			common.ajaxCall(datas, '/ad/member/getEmpInfo.do', 'makeEmpInfo3');
			}
			
		} else {
			$('#apply_sms_tel1').val('');
			$('#apply_sms_tel2').val('');
			$('#apply_sms_tel3').val('');

			$('#apply_sms_tel1').attr('readonly', 'readonly');
			$('#apply_sms_tel2').attr('readonly', 'readonly');
			$('#apply_sms_tel3').attr('readonly', 'readonly');
			$("#send_sms_th").children().remove();
		}
		;
	};

	function fnChkByte(status, obj, maxByte) {
		var str = obj.value;
		var str_len = str.length;
		var rbyte = 0;
		var rlen = 0;
		var one_char = "";
		var str2 = "";

		for (var i = 0; i < str_len; i++) {
			one_char = str.charAt(i);
			if (escape(one_char).length > 4) {
				rbyte += 3; //한글3Byte
			} else {
				rbyte++; //영문 등 나머지 1Byte
			}
			if (rbyte <= maxByte) {
				rlen = i + 1; //return할 문자열 갯수
			}
		}
		if (rbyte > maxByte) {
			alert("메세지는 최대 " + maxByte + " byte를 초과할 수 없습니다.")
			str2 = str.substr(0, rlen); //문자열 자르기
			obj.value = str2;
			fnChkByte(status, obj, maxByte);
		} else {
			if (status == 'call') {
				$('#call_content_text').html(rbyte + '/ 3500 byte');
			} else if (status == 'action') {
				$('#action_content_text').html(rbyte + '/ 3500 byte');
			}
		}
	};

	function showByte(status, str) {

		var str_len = str.length;
		var rbyte = 0;
		var one_char = "";

		for (var i = 0; i < str_len; i++) {
			one_char = str.charAt(i);
			if (escape(one_char).length > 4) {
				rbyte += 3; //한글3Byte
			} else {
				rbyte++; //영문 등 나머지 1Byte
			}
		}
		if (status == 'call') {
			$('#call_content_text').html(rbyte + '/ 3500 byte');
		} else if (status == 'action') {
			$('#action_content_text').html(rbyte + '/ 3500 byte');
		}

	};

	/*날짜 형식 유효성 검사*/
	function chkDateFormat(inputId, data) {

		var data2 = data.replaceAll("/", "");
		var datatimeRegexp = RegExp(/^\d{4}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])$/);
		var inputId = inputId;

		if (!datatimeRegexp.test(data2)) {
			alert("날짜는 2022/01/01 형식으로 입력해주세요.");
			$('#' + inputId).val("");
			$('#' + inputId).focus();
		} else {
			if (!data.includes("/")) {
				var rightDate = data.substring(0, 4) + "/"
						+ data.substring(4, 6) + "/" + data.substring(6, 8);
				$('#' + inputId).val(rightDate);
			}
		}

		//작업완료일자 선택시 사용자테스트 일자 자동세팅 2021.07.29  --기능해제 2021.12.21
		/*
		if(inputId =='complete_dt' ){
		    if( ($('#request_type').val() == 'C001' || $('#request_type').val() == 'C017') &&  $('#proc_status').val() == "C005" ){
		    	$('#user_test_dt').val( $('#complete_dt').val() );
		    }
		}
		 */

	};

	function setTestNote() {
		if ($("#user_test_yn").is(":checked")
				&& $("#normal_oper_yn").is(":checked")
				&& $("#test_note").val() == "") {
			$("#test_note").val("특이사항 없음");
		}
	}

	function setProcGrade(val) {
		var cust_gubun = $('#cust_gubun').val();
		
		if (common.isEmpty($('#action_type').val())) {
			$('#proc_grade').val('');
		} else {
			if (val == "C003" || val == "C004") {
				$('#proc_grade').val('C003').attr('disabled', true);
				$('#proc_build_info_th').children().remove();
				$('#proc_test_info_th').children().remove();
			} else if (val == "C005" || val == "C006" || val == "C007" || val == "C999") {
				$('#proc_grade').val('C004').attr('disabled', true);
				$('#proc_build_info_th').children().remove();
				$('#proc_test_info_th').children().remove();
			} else if (val == "C001" || val == "C002") {
				$('#proc_grade').val('C002').attr('disabled', false);
				}
			
			if((val == "C001" || val == "C002") && ($('#proc_status').val() == "C005")){
				$("#proc_gubun_th").children().remove();
				$("#module_th").children().remove();

				$('#proc_gubun_th').append('<span class="request mgl5">필수 입력</span>');
				$('#module_th').append('<span class="request mgl5">필수 입력</span>');
				
				if (cust_gubun != "C001") {
					$('#user_test_yn').prop("checked", true);
					$('#normal_oper_yn').prop("checked", true);
					$('#test_note').val("특이사항 없음");
				}
				
			}else{
				$("#proc_gubun_th").children().remove();
				$("#module_th").children().remove();
				$('#user_test_yn').prop("checked", false);
				$('#normal_oper_yn').prop("checked", false);
				$('#test_note').val("");
			}
				if(val == "C999"){
					if(!($('#request_type').val() == 'C008'
						|| $('#request_type').val() == 'C015'
						|| $('#request_type').val() == 'C016'
						|| $('#request_type').val() == 'C018'
						|| $('#request_type').val() == 'C019')){
						
						alert('문의유형이 "교육 수강","교육 진행","점검","응대","회의/출장"이 아닌 경우에는 조치유형에 "기타"를 선택하실 수 없습니다.');
						$('#action_type').val("");
						$('#action_type').focus();
						return;
					}
				}
			}
		}

	function chkActionType(val) {
		if (common.isEmpty($('#action_type').val())) {
			alert('조치유형을 선택하세요.');
			$('#proc_grade').val('');
			$('#action_type').focus();
			return;
		} else {
			if (val == "C001" || val == "C002") {
				
				$('#proc_build_info_th').children().remove();
				$('#proc_test_info_th').children().remove();
				
				if ($('#system_type').val().includes("S003")){
				
					$('#proc_build_info_th').append(
							'<span class="request mgl5">필수 입력</span>');
				}
				
				
					$('#proc_test_info_th').append(
							'<span class="request mgl5">필수 입력</span>');

			} else {
				$('#proc_build_info_th').children().remove();
				$('#proc_test_info_th').children().remove();
			}
		}
	}

	function showProcGradePopLayer() {
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

	function reSendEmail() {

		if (!$("#send_email").is(":checked")
				|| common.isEmpty($('#apply_email').val())) {
			alert("처리완료 안내 메일 발송은 고객 메일 수신 주소 입력이 필수입니다.");
			$('#send_email').prop("checked", true);
			$('#apply_email').prop('readonly', false)
			$('#apply_email').focus();
			return;
		} else {
			if (confirm($('#apply_email').val()
					+ " 메일주소로 처리완료 안내 메일을 재전송 하시겠습니까?")) {
				var f = document.procFrm;
				if ($('#send_email').is(":checked"))
					f.send_email.value = "Y";

				f.target = 'hiddenFrame';
				f.action = "/ad/as/reSendEmail.do";
				f.submit();
			}
		}
	}

	function fnReturn(resultCode, type) {
		if (resultCode == "success") {
			alert("정상적으로 처리 되었습니다.");

			if (type == "list3") {
				current_file = 'list3';
				goList();
			} else {
				goList();
			}

		} else {
			alert("처리도중 오류가 발생했습니다.");
			return;
		}
	}

	//페이지 내 결재 버튼 클릭
	function goApprove() {

		var appr_emp1 = $('#appr_emp1').val(); //팀장승인 승인자(1차 결재자) 사번
		var appr_sub_emp1 = $('#appr_sub_emp1').val(); //팀장승인 대체자(2차 결재자) 사번
		var appr_ssub_emp1 = $('#appr_ssub_emp1').val(); //팀장승인 대체자(3차 결재자) 사번
		var appr_emp2 = $('#appr_emp2').val(); //배포승인 승인자(1차 결재자) 사번
		var appr_sub_emp2 = $('#appr_sub_emp2').val(); //배포승인 대체자(2차 결재자) 사번
		var appr_ssub_emp2 = $('#appr_ssub_emp2').val(); //배포승인 대체자(3차 결재자) 사번
		var proc_status = $('#proc_status').val();

		/*팀장승인*/
		if (proc_status == 'C000') {
			if (userId == appr_emp1 || appr_sub_emp1.includes(userId)) {
				if (confirm("해당 AS건을 결재하시겠습니까?")) {

					var f = document.procFrm;
					f.target = 'hiddenFrame';
					f.action = "/ad/as/apprv.do";
					f.submit();
				}
			} else {
				alert("팀장승인 권한이 없습니다.");
				return;
			}

			/*배포승인*/
		} else if (proc_status == 'C005') {
			if (userId == appr_emp2 || appr_sub_emp2.includes(userId)) {
				if (confirm("해당 AS건을 결재하시겠습니까?")) {

					var f = document.procFrm;
					f.target = 'hiddenFrame';
					f.action = "/ad/as/apprv.do";
					f.submit();
				}
			} else {
				alert("배포승인 권한이 없습니다.");
				return;
			}

		} else {
			alert("결재 대상이 아닙니다. 처리상태를 확인하시길 바랍니다.");
			$('#proc_status').focus();
			return;
		}

	}

	//페이지 내 부결 버튼 클릭
	function goReject() {

		var appr_emp1 = $('#appr_emp1').val(); //팀장승인 승인자(1차 결재자) 사번
		var appr_sub_emp1 = $('#appr_sub_emp1').val(); //팀장승인 대체자(2차 결재자) 사번
		var appr_ssub_emp1 = $('#appr_ssub_emp1').val(); //팀장승인 대체자(3차 결재자) 사번
		var appr_emp2 = $('#appr_emp2').val(); //배포승인 승인자(1차 결재자) 사번
		var appr_sub_emp2 = $('#appr_sub_emp2').val(); //배포승인 대체자(2차 결재자) 사번
		var appr_ssub_emp2 = $('#appr_ssub_emp2').val(); //배포승인 대체자(3차 결재자) 사번
		var proc_status = $('#proc_status').val();

		setRejectList();

		/*팀장반려*/
		if (proc_status == 'C000') {
			if (userId == appr_emp1 || appr_sub_emp1.includes(userId)) {
				$('#rejectListLayer').show();
				$('#div7_dim').show();
				$("#rejectListLayer")
						.css(
								{
									"top" : (($(window).height() - $(
											"#rejectListLayer").outerHeight()) / 2 + $(
											window).scrollTop())
											+ "px"
								});
			} else {
				alert("팀장반려 권한이 없습니다.");
				return;
			}

			/*배포반려*/
		} else if (proc_status == 'C005') {
			if (userId == appr_emp2 || appr_sub_emp2.includes(userId)) {
				$('#rejectListLayer').show();
				$('#div7_dim').show();
				$("#rejectListLayer")
						.css(
								{
									"top" : (($(window).height() - $(
											"#rejectListLayer").outerHeight()) / 2 + $(
											window).scrollTop())
											+ "px"
								});
			} else {
				alert("배포반려 권한이 없습니다.");
				return;
			}
		} else {
			alert("부결 대상이 아닙니다. 처리상태를 확인하시길 바랍니다.");
			$('#proc_status').focus();
			return;
		}

	};

	//팝업 리스트 세팅
	function setRejectList() {
		$('#rejectListBody').empty();
		var str = '';
		str += '<tr> ';
		/* 접수번호 */
		str += '	<td>' + $('#as_no').val() + '</td>';
		/* 접수일 */
		str += '	<td>' + $('#accept_dt').val() + '</td>';
		/* 거래처명 */
		str += '	<td>' + $('#cust_kor_name').val() + '</td>';
		/* 요청자 */
		str += '	<td>' + $('#apply_nm').val() + '</td>';
		/* 반려사유 */
		str += '		<td><textarea id="reject_desc"/></td> ';

		/* 끝tr */
		str += '</tr> ';

		$('#rejectListBody').append(str);
	};

	//팝업 내 부결버튼 클릭
	function rejectProc() {

		if (confirm("부결 하시겠습니까?")) {
			if ($('#reject_desc').val() == "") {
				alert("반려사유는 필수입니다.");
				$('#reject_desc').focus();
				return;
			}

			var arrayObj = [];
			var obj = {};
			var dataObj = {};
			obj.AS_NO = $('#as_no').val();
			obj.REJECT_DESC = $('#reject_desc').val();
			arrayObj[0] = obj;
			dataObj.DATA_LIST = JSON.stringify(arrayObj);

			$
					.ajax({
						type : 'post',
						url : '/ad/code/reject.do',
						data : dataObj,
						dataType : 'json',
						statusCode : {
							403 : function(data) {
								alert("권한이 없습니다.");
							},
							404 : function(data) {
								alert('해당 페이지가 존재하지 않습니다.');
							}
						},
						success : function(data) {

							var returnCode = typeof data.returnCode != "undefined" ? common
									.nvl(data.returnCode, "1000")
									: "1000";
							var msg = "";

							if (returnCode == "400")
								msg = "처리도중 오류가 발생했습니다.";
							else
								msg = "정상적으로 처리 되었습니다.";

							alert(msg);
							$("#rejectListLayer").hide();
							location.href = document.referrer;
						}
					});

		}

	};
</script>

<form name="procFrm" id="procFrm" method="post"
	enctype="multipart/form-data" onsubmit="return false;">
	<input type="hidden" name="pageType" id="pageType"
		value="${ vo.pageType }" /> <input type="hidden" name="apply_tel"
		id="apply_tel" value="" /> <input type="hidden" name="apply_sms_tel"
		id="apply_sms_tel" value="" /> <input type="hidden" name="proc_time"
		id="proc_time" value="" /> <input type="hidden" name="file_seq"
		id="file_seq" value="" /> <input type="hidden" name="attach_seq2"
		id="attach_seq2" value="0" /> <input type="hidden" name="delAttach1"
		id="delAttach1" value="" /> <input type="hidden" name="delAttach2"
		id="delAttach2" value="" /> <input type="hidden" name="seq" id="seq"
		value="" /> <input type="hidden" name="crm_code" id="crm_code"
		value="" /> <input type="hidden" name="cn_as_no" id="cn_as_no"
		value="" /> <input type="hidden" name="proc_status2" id="proc_status2"
		value="" /> <input type="hidden" name="chg_assign_id"
		id="chg_assign_id" value="" /> <input type="hidden"
		name="as_approval_yn" id="as_approval_yn" value="" /> <input
		type="hidden" name="gyul_gb1" id="gyul_gb1" value="" /> <input
		type="hidden" name="gyul_gb2" id="gyul_gb2" value="" /> <input
		type="hidden" name="appr_sub_emp1" id="appr_sub_emp1" value="" /> <input
		type="hidden" name="appr_sub_emp2" id="appr_sub_emp2" value="" /> <input
		type="hidden" name="appr_ssub_emp1" id="appr_ssub_emp1" value="" /> <input
		type="hidden" name="appr_ssub_emp2" id="appr_ssub_emp2" value="" />


	<div class="tit_wrap" style="margin-top: 20px;">
		<h2 class="tit_ico_as">
			A/S 관리<span class="tit_depth mgl20 mgt8">상세처리내역 조회</span>
		</h2>
		<div class="location">
			<a href="/ad/main/list.do" class="home">Home</a> <a
				href="/ad/as/list.do" class="depth"><span class="here">A/S관리</span></a>
		</div>
	</div>

	<!-- process -->
	<ul class="pro_arrow mgb15">
		<li id="stateC001" class="current">접수</li>
		<!-- 활성시 current -->
		<li id="stateC002">담당자배정중</li>
		<li id="stateC003">배정완료</li>
		<li id="stateC004">처리중</li>
		<li id="stateC005">처리완료</li>
	</ul>
	<!--// process -->
	<div class="tit_sWrap">
		<h3 class="tit_dot_gray">
			A/S 접수 상세 정보
			<c:choose>
				<c:when test="${ vo.pageType eq 'subInsert' }">
					(<span id="as_no_text"></span>&nbsp;&gt;&nbsp;<span
						class="colorBlue mg15" style="line-height: 25px;">해당 건의
						하위작업을 생성중입니다</span>)				
				</c:when>
				<c:when test="${ vo.pageType eq 'subUpdate' }">
					(<span id="cn_as_no_text"></span>&nbsp;&gt;&nbsp;<span
						id="as_no_text" class="colorBlue mg15" style="line-height: 25px;"></span>)
				</c:when>
			</c:choose>
		</h3>
	</div>
	<!-- tab -->
	<ul class="tab_line list2 mgb20">
		<li class="active"><a href="#" id="btnTab1" data-id="subTab1">A/S
				접수·처리 정보</a></li>
		<!-- 활성시 current -->
		<li><a href="#" id="btnTab2" data-id="subTab2">답변내역</a></li>
	</ul>
	<!--// tab -->
	<div id="subTab1">
		<div class="tit_bWrap mgb10">
			<h4>접수 정보</h4>
		</div>
		<!-- write -->
		<table class="sType mgb20">
			<caption>접수 정보 입력</caption>
			<colgroup>
				<col style="width: 180px;" />
				<col style="width: 340px;" />
				<col style="width: 160px;" />
				<col style="width: 340px;" />
			</colgroup>
			<tr>
				<th scope="row">고객접수번호</th>

				<c:choose>
					<c:when test="${ vo.pageType eq 'insert' }">
						<td colspan="3"><input type="text" id="as_no" name="as_no"
							readonly="readonly" value="" class="w193 mgr5" title="고객접수번호 입력" />
						</td>
					</c:when>
					<c:when test="${ vo.pageType eq 'update' }">
						<td><input type="text" id="as_no" name="as_no" readonly="readonly" value="" class="w193 mgr5" title="고객접수번호 입력" /><button type="button" id="CnAS" class="btn_line_gray w100" onclick="btnInitCnAs();">하위작업 생성</button></td>
						<th scope="row">연관접수번호</th>
						<td><select name="sel_cn_as_no" id="sel_cn_as_no"
							title="하위작업번호 선택" class="w225 mgr2">
								<option value="">연관접수번호 선택</option>
						</select>
						<button type="button" id="btnSelCnAs" class="btn_line_gray"
								onclick="showSelCnAs();">조회</button></td>
					</c:when>
					<c:when test="${ vo.pageType eq 'subInsert' }">
						<td colspan="3"><input type="text" id="as_no" name="as_no"
							readonly="readonly" value="" class="w193 mgr5" title="고객접수번호 입력" />
						</td>
					</c:when>
					<c:otherwise>
						<td><input type="text" id="as_no" name="as_no"
							readonly="readonly" value="" class="w193 mgr5" title="고객접수번호 입력" />
						</td>
						<th scope="row">연관접수번호</th>
						<td><select name="sel_cn_as_no" id="sel_cn_as_no"
							title="하위작업번호 선택" class="w225 mgr2">
								<option value="">연관접수번호 선택</option>
						</select>
						<button type="button" id="btnSelCnAs" class="btn_line_gray"
								onclick="showSelCnAs();">조회</button></td>
					</c:otherwise>
				</c:choose>
			</tr>
			<c:if
				test="${ vo.pageType eq 'update' || vo.pageType eq 'subInsert'|| vo.pageType eq 'subUpdate' }">
				<tr>
					<th scope="row">접수일자</th>
					<td><input type="text" name="accept_dt" id="accept_dt"
						readonly="readonly" value="" class="w193" title="접수일자 입력" /></td>
					<th scope="row">접수시간</th>
					<td><input type="text" name="accept_time" id="accept_time"
						readonly="readonly" value="" class="w225" title="접수시간 입력" /></td>
				</tr>
			</c:if>
			<tr>
				<th>접수 경로<span class="request mgl5">필수 입력</span></th>
				<td colspan="3"><select name="accept_route" id="accept_route"
					title="접수 경로 선택" class="w193 mgr2"></select></td>
			</tr>
			<c:if test="${ vo.pageType eq 'insert' }">
				<tr>
					<th scope="row">접수일자</th>
					<td><input type="text" name="accept_dt" id="accept_dt"
						value="" class="w193" title="접수일자 입력"
						onchange="chkDateFormat('accept_dt',this.value)" /></td>
					<th scope="row">접수시간</th>
					<td><input type="text" name="accept_time" id="accept_time"
						readonly="readonly" value="" class="w225" title="접수시간 입력" /></td>
				</tr>
			</c:if>
		</table>
		<!--// write -->

		<c:choose>
			<c:when test="${ vo.pageType ne 'insert' }">
				<!-- write -->
				<div class="tit_bWrap mgb10">
					<h4>JW그룹웨어 정보</h4>
				</div>
				<table class="sType mgb20">
					<caption>고객사 정보 입력</caption>
					<colgroup>
						<col style="width: 180px;" />
						<col style="width: 405px;" />
						<col style="width: 140px;" />
						<col style="width: 260px;" />
					</colgroup>
					<tr>
						<th scope="row">JW그룹웨어 문서ID</th>
						<td colspan="3"><input type="text" name="shared_doc_id"
							id="shared_doc_id" readonly="readonly" value="" class="w210 mgr5"
							title="JW그룹웨어 문서ID" /> <input type="text" name="shared_doc_idx"
							id="shared_doc_idx" readonly="readonly" value=""
							class="w210 mgr5" title="JW그룹웨어 문서ID" /></td>
					</tr>
					<tr>
						<th scope="row">JW그룹웨어 승인자 ID/이름</th>
						<td><input type="text" name="approval_id" id="approval_id"
							readonly="readonly" value="" class="w100 mgr5" title="승인자" /> <input
							type="text" name="approval_nm" id="approval_nm"
							readonly="readonly" value="" class="w100 mgr5" title="승인자" /></td>
						<th scope="row">승인일자</th>
						<td><input type="text" name="approval_dt" id="approval_dt"
							readonly="readonly" value="" class="w100 mgr5" title="승인일자" /> <input
							type="text" name="approval_time" id="approval_time"
							readonly="readonly" value="" class="w100 mgr5" title="승인일자" /></td>
					</tr>
					<tr>
						<th scope="row">JW그룹웨어 승인자 의견</th>
						<td colspan="3"><textarea name="shared_tag" id="shared_tag"
								class="mgb5" style="padding-left: 5px; height: 50px !important;"
								readonly="readonly"></textarea></td>
					</tr>
				</table>
			</c:when>
		</c:choose>
		<!-- //write -->
		<div class="tit_bWrap mgb10">
			<h4>고객사 정보</h4>
		</div>
		<!-- write -->
		<table class="sType mgb20">
			<caption>고객사 정보 입력</caption>
			<colgroup>
				<col style="width: 180px;" />
				<col style="width: 405px;" />
				<col style="width: 140px;" />
				<col style="width: 260px;" />
			</colgroup>
			<tr>
				<th scope="row">고객사 명<span class="request mgl5">필수 입력</span></th>
				<td><input type="hidden" name="cust_seq" id="cust_seq" /> <input
					type="text" name="cust_kor_name" id="cust_kor_name"
					readonly="readonly" value="" class="w210 mgr5" title="고객사 명 입력" />
				<c:choose>
						<c:when test="${ vo.pageType eq 'insert' }">
							<button type="button" class="btn_line_gray"
								onclick="showCustLayer();">조회</button>
						</c:when>
						<c:otherwise>
							<button type="button" class="btn_line_gray"
								onclick="goCustLink('cust');">상세보기</button>
						</c:otherwise>
					</c:choose></td>
				<th scope="row">고객사 코드</th>
				<td><input type="text" name="cust_code" id="cust_code"
					readonly="readonly" value="" class="mgr5" title="고객사 코드 입력" /></td>
			</tr>
			<tr>
				<th scope="row">고객사 주소</th>
				<td><input type="text" name="cust_addr" id="cust_addr"
					readonly="readonly" value="" title="고객사 주소 입력" /></td>
				<th scope="row">고객사 대표 계정 연락처</th>
				<td><input type="text" name="cust_tel" id="cust_tel"
					readonly="readonly" value="" class="mgr5" title="고객사 연락처 입력" /></td>
			</tr>
			<tr>
				<th scope="row">A/S신청자 이름 / 아이디<span class="request mgl5">필수
						입력</span></th>
				<td><input type="text" name="apply_nm" id="apply_nm" value=""
					class="w100 mgr5" title="A/S신청자 이름 입력" readonly="readonly" /> <input
					type="text" name="apply_id" id="apply_id" value=""
					class="w100 mgr10" title="A/S신청자 아이디 입력" readonly="readonly" />
				<c:choose>
						<c:when test="${ vo.pageType eq 'insert' }">
							<button type="button" class="btn_line_gray "
								onclick="showEmpLayer();">조회</button>
							<button type="button" class="btn_line_gray"
								onclick="btnEmpField();">직접입력</button>
						</c:when>
						<c:otherwise>
							<button type="button" class="btn_line_gray"
								onclick="goCustLink('member');">상세보기</button>
						</c:otherwise>
					</c:choose></td>
				<th scope="row">A/S 신청자 연락처</th>
				<td colspan="3"><input type="text" name="apply_tel1"
					id="apply_tel1" maxlength="4" value="" class="w60 mgr5"
					id="as_call" title="A/S 신청자 연락처 입력" />- <input type="text"
					name="apply_tel2" id="apply_tel2" maxlength="4" value=""
					class="w60 mgl5 mgr5" id="as_call" title="A/S 신청자 연락처 입력" />- <input
					type="text" name="apply_tel3" id="apply_tel3" maxlength="4"
					value="" class="w60 mgl5" id="as_call" title="A/S 신청자 연락처 입력" /></td>
			</tr>
			<tr>
				<th scope="row">발송 이벤트 여부</th>
				<td colspan="3"><input type="checkbox" name="send_email"
					id="send_email" checked="checked" onchange="validateEmailform()"><label
					for="send_email">&nbsp; 이메일 발송</label> <input type="checkbox"
					name="send_sms" id="send_sms" class="mgl20" checked="checked"
					onchange="validateSMSform()"><label for="send_sms">&nbsp;
						SMS 발송</label></td>
			</tr>
			<tr>
				<th id="send_email_th" scope="row">메일 수신 주소<span
					class="request">필수입력</span></th>
				<td><input type="text" name="apply_email" id="apply_email"
					class="w193 mgr5" value="" title="메일 수신자 주소" />
					<button type="button" id="btnReSendEmail" class="btn_line_gray w80"
						onclick="reSendEmail();">메일 재전송</button></td>
				<th id="send_sms_th" scope="row">SMS 수신 전화번호<span
					class="request">필수입력</span></th>
				<td><input type="text" name="apply_sms_tel1"
					id="apply_sms_tel1" maxlength="4" value="" class="w60 mgr5"
					title="A/S 신청자 연락처 입력" />- <input type="text"
					name="apply_sms_tel2" id="apply_sms_tel2" maxlength="4" value=""
					class="w60 mgl5 mgr5" title="A/S 신청자 연락처 입력" />- <input
					type="text" name="apply_sms_tel3" id="apply_sms_tel3" maxlength="4"
					value="" class="w60 mgl5" title="A/S 신청자 연락처 입력" /></td>
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
				<col style="width: 180px;" />
				<col style="width: 320px;" />
				<col style="width: 160px;" />
				<col style="width: 320px;" />
			</colgroup>
			<tr>
				<th scope="row">시스템 유형<span class="request mgl5">필수 입력</span></th>
				<td><select name="system_type" id="system_type"
					title="시스템 유형 선택" class="w200"
					onchange="javascript:getTaskType(this.value);">

				</select> <input type="hidden" name="oper_seq" id="oper_seq" value="" /></td>
				<th scope="row">업무 유형<span class="request mgl5">필수 입력</span></th>
				<td><select name="inquiry_type" id="inquiry_type"
					title="업무 유형 선택" class="w200"
					onchange="javascript:getAssign(this.value);">
				</select></td>
			</tr>
			<tr>
				<th scope="row">문의유형<span class="request mgl5">필수 입력</span></th>
				<td><select class="w200" name="request_type" id="request_type"
					title="문의유형 선택" onchange="javascript:chRequestType(this.value);"></select>
				</td>
				<th scope="row">처리 요청 일자<span class="request mgl5">필수 입력</span></th>
				<td><input type="text" class="w200" name="inquiry_dt"
					id="inquiry_dt" value="" title="처리 요청 시각 입력"
					onchange="chkDateFormat('inquiry_dt',this.value)" /></td>
			</tr>

			<!--CMC add UI 모듈, 중분류 , 프로그램명  2021.01.12 -->
			<tr>
				<th id="module_th" scope="row">모듈</th>
				<td><select class="w200" name="module_name" id="module_name"
					title="모듈"
					onchange="javascript:clearCategoryAndProgram(this.value);"></select>
				</td>
				<th id="category_th" scope="row">중분류</th>
				<td><input type="text" class="w200" name="category_name"
					id="category_name" value="" title="중분류" readonly="readonly" /> <input
					type="hidden" name="category_id" id="category_id" value="" />
					<button type="button" id="btnCategoryListPop" class="btn_line_gray"
						onclick="showCategoryPopLayer();">조회</button></td>
			</tr>

			<tr>
				<th id="program_th" scope="row">프로그램명</th>
				<td colSpan="3"><input type="text" class="w200"
					name="program_name" id="program_name" value="" title="프로그램명"
					readonly="readonly" /> <input type="hidden" name="program_id"
					id="program_id" value="" />
					<button type="button" id="btnProgramName" class="btn_line_gray"
						onclick="showProgramPopLayer();">조회</button></td>
			</tr>

			<tr>
				<th>요청 내용<span style="color: blue;">(고객이 작성한 내용입니다)</span></th>
				<td colspan="3"><textarea name="call_content" id="call_content"
						class="mgb5" style="padding-left: 5px; height: 300px !important;"
						onKeyUp="javascript:fnChkByte('call',this,'3500')"></textarea>
					<div class="txt_byte" id="call_content_text">0 / 3500 byte</div></td>
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
				<col style="width: 180px;" />
				<col style="width: 320px;" />
				<col style="width: 160px;" />
				<col style="width: 320px;" />
			</colgroup>
			<tr>
				<th scope="row">배정담당자<span class="request mgl5">필수 입력</span></th>
				<td><input type="text" class="w200 mgr5" name="assign_nm"
					id="assign_nm" readonly="readonly" title="운영정보 대표 담당자로 자동 배정 됩니다." />
					<input type="hidden" name="assign_id" id="assign_id"
					value="${ adUserInfo.emp_id }" />
					<button type="button" class="btn_line_gray "
						onclick="javascript:showAssign()">담당자 변경</button></td>
				<th scope="row">업무 중요도<span class="request mgl5">필수 입력</span></th>
				<td><select id="inportance" name="inportance" title="업무중요도 선택 "
					class="w200">
						<option value="">선택해주세요</option>
				</select></td>
			</tr>
			<tr>
				<th scope="row">처리상태<span class="request mgl5">필수 입력</span></th>
				<td id="td_proc_status"><select id="proc_status"
					name="proc_status" title="처리상태 선택 " class="w200"
					onchange="javascript:chProcStatus(this.value);">
						<option value="">선택해주세요</option>
				</select></td>
				<th scope="row">동료검토자</th>
				<td><input id="peer_review_nm" type="text"
					name="peer_review_nm" value="" class="w200" title="동료검토자" /></td>
			</tr>
			<tr>
				<th scope="row">승인자</th>
				<td><input id="appr_em" type="text" name="appr_em" value=""
					class="w200" title="승인자" readonly="readonly" /></td>
				<th scope="row" id="th_apprv">승인일자</th>
				<td><input id="apprv_dt_role" type="text" name="apprv_dt_role"
					value="" class="w200" title="승인일자" readonly="readonly" /></td>
			</tr>
			<tr>
				<th scope="row">CMC담당자</th>
				<td><select id="cmc_pic" name="cmc_pic" title="" class="w200"
					onchange="">
						<option value=""></option>
				</select></td>
				<th>CMC 작업만족도</th>
				<td colspan="5"><select name="program_satisfaction"
					id="program_satisfaction" title="" class="w200" onchange="">
				</select></td>
			</tr>
		</table>
		<!--// write -->
		<div class="tit_bWrap mgb10">
			<h4>처리완료 사항</h4>
		</div>
		<!-- write -->
		<table class="sType mgb20" id="wrapFile">
			<caption>처리완료 사항 입력</caption>
			<colgroup>
				<col style="width: 180px;" />
				<col style="width: 320px;" />
				<col style="width: 160px;" />
				<col style="width: 320px;" />
			</colgroup>
			<tr>
				<th scope="row" id="proc_dt_th">처리 예정 일자/시각</th>
				<td><input type="text" name="proc_dt" id="proc_dt" value=""
					title="처리 예정 일자 입력" class="w100 mgr5"
					onchange="chkDateFormat('proc_dt',this.value)" /> <select
					name="proc_time1" id="proc_time1" title="시 선택"
					class="w60 mgr5 mgl10"></select>: <select name="proc_time2"
					id="proc_time2" title="분 선택" class="w60">
						<option value="00">00</option>
						<option value="30">30</option>
				</select></td>
				<th scope="row" id="action_type_th">조치유형</th>
				<td><select name="action_type" id="action_type" title="조치유형 선택"
					class="w200" onchange="setProcGrade(this.value)">
						<option>선택해주세요</option>
				</select></td>
			</tr>
			<tr>
				<th scope="row" id="cause_type_th">원인유형</th>
				<td><select class="w200" name="cause_type" id="cause_type"
					title="원인유형 선택" onchange="javascript:chCauseType(this.value);">
						<option>선택해주세요</option>
				</select></td>
				<th scope="row" id="proc_grade_th">처리등급</th>
				<td><select name="proc_grade" id="proc_grade" title="처리등급 선택"
					class="w200" onchange="chkActionType(this.value)">
						<option>선택해주세요</option>
				</select>
					<button type="button" id="btnProgramName" class="btn_line_gray"
						onclick="showProcGradePopLayer()">등급 기준표</button></td>
			</tr>
			<tr>
				<th scope="row" id="expected_work_time_th">예상작업시간(Hour)/진행률(%)</th>
				<td><input id="expected_work_time" type="number" name="expected_work_time"
					value="" class="w200" title="예상작업시간입력" style='IME-MODE: disabled'/><select name="progress_rate"
					id="progress_rate" title="진행률 선택" class="w60 mgr5 mgl10">
						<option value="0">0</option>
						<option value="10">10</option>
						<option value="20">20</option>
						<option value="30">30</option>
						<option value="40">40</option>
						<option value="50">50</option>
						<option value="60">60</option>
						<option value="70">70</option>
						<option value="80">80</option>
						<option value="90">90</option>
						<option value="100">100</option>
				</select>
				</td>
				<th scope="row" id="target_project_th">대상 프로젝트</th>
				<td><input type="text" name="target_project"
					id="target_project" value="" title="테스트케이스 입력" /></td>
			</tr>
			<tr>
				<th scope="row" id="work_time_th">작업시간(Hour)</th>
				<td><input id="work_time" type="number" name="work_time"
					value="" class="w200" title="작업시간입력" style='IME-MODE: disabled'/>
				</td>
				<th scope="row" id="complete_dt_th">작업완료일자</th>
				<td><span id="spanForAlert"> <input id="complete_dt"
						type="text" name="complete_dt" value="" class="w200"
						title="작업완료일자" onchange="chkDateFormat('complete_dt',this.value)" />
				</span></td>
			</tr>

			<tr>
				<th><span id="action_content_th">조치 및 처리 의견</span><span style="color: red;">(관리자가 작성한
						내용입니다.)</span></th>
				<td colspan="5"><textarea name="action_content"
						id="action_content" class="mgb5"
						style="padding-left: 5px; height: 150px !important;"
						onKeyUp="javascript:fnChkByte('action',this,'3500')"></textarea>
					<div class="txt_byte" id="action_content_text">0 / 3500 byte</div>
				</td>
			</tr>
			<tr>
				<th scope="row" id="test_yn_th">사용자 테스트 확인</th>
				<td colspan="5"><label for="user_test_yn">사용자테스트
						여부&nbsp;</label><input type="checkbox" name="user_test_yn"
					id="user_test_yn" class="mgr20" onclick="return false;"
					onchange="setTestNote()"> <label for="normal_oper_yn">정상
						여부&nbsp;</label><input type="checkbox" name="normal_oper_yn"
					id="normal_oper_yn" class="mgr20" onclick="return false;"
					onchange="setTestNote()"> 비고 &nbsp;<input class="w200"
					type="text" name="test_note" id="test_note" title="테스트 비고 입력"
					readonly="readonly" /></td>
			</tr>
			<tr>
				<th scope="row" id="test_date_th">사용자 테스트 일자</th>
				<td><span id="spanForAlert"> <input id="user_test_dt"
						type="text" name="user_test_dt" value="" class="w193"
						title="사용자테스트 일자"
						onchange="chkDateFormat('user_test_dt',this.value)" />
				</span></td>
				<th scope="row" id="test_time_th">사용자 테스트 시간</th>
				<td><span id="spanForAlert"> <input id="user_test_time"
						type="text" name="user_test_time" value="" class="w193"
						title="사용자테스트 시간" readonly="readonly" />
				</span></td>
			</tr>
			<tr>
				<th scope="row" id="test_date_th">사용자 테스트자 정보</th>
				<td colspan="5">확인자 ID &nbsp;<input class="w100 mgr20"
					type="text" name="user_test_id" id="user_test_id"
					title="테스트 확인자 ID" readonly="readonly" /> 확인자 이름 &nbsp;<input
					class="w100 mgr20" type="text" name="user_test_nm"
					id="user_test_nm" title="테스트 확인자 이름" readonly="readonly" /> 확인자
					IP주소 &nbsp;<input class="w150 mgr20" type="text"
					name="user_test_ip" id="user_test_ip" title="테스트 확인자 IP주소"
					readonly="readonly" />
				</td>
			</tr>
		</table>

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
				<th id="proc_gubun_th" scope="row">처리구분</th>
				<td colspan="3"><select id="proc_gubun" name="proc_gubun"
					class="w200"></select></td>
			</tr>

			<tr>
				<th scope="row" id="proc_build_info_th">빌드순번/CTS빌드</th>
				<td><input type="text" name="proc_build_info"
					id="proc_build_info" value="" title="빌드순번/CTS빌드 입력" /></td>
				<th scope="row">파일명/PBL</th>
				<td><input type="text" name="proc_file_info"
					id="proc_file_info" value="" title="파일명/PBL 입력" /></td>
			</tr>

			<tr>
				<th scope="row">관련DB</th>
				<td><input type="text" name="proc_db_info" id="proc_db_info"
					value="" title="관련DB 입력" /></td>
				<th scope="row" id="proc_test_info_th">테스트케이스</th>
				<td><input type="text" name="proc_test_info"
					id="proc_test_info" value="" title="테스트케이스 입력" /></td>
			</tr>

			<tr>
				<th scope="row">프로세스정의서</th>
				<td><input type="text" name="proc_process_sp"
					id="proc_process_sp" value="" title="프로세스정의서 입력" /></td>
				<th scope="row">기능분해도</th>
				<td><input type="text" name="proc_function_sp"
					id="proc_function_sp" value="" title="기능분해도 입력" /></td>
			</tr>
			<tr>
				<th scope="row">화면정의서</th>
				<td><input type="text" name="proc_screen_sp"
					id="proc_screen_sp" value="" title="화면정의서 입력" /></td>
				<th scope="row">ERD</th>
				<td><input type="text" name="proc_erd_sp"
					id="proc_erd_sp" value="" title="ERD 입력" /></td>
			</tr>

			<tr>
				<th scope="row">테이블정의서</th>
				<td><input type="text" name="proc_table_sp" id="proc_table_sp"
					value="" title="테이블정의서 입력" /></td>
				<th scope="row">인터페이스정의서</th>
				<td><input type="text" name="proc_interface_sp"
					id="proc_interface_sp" value="" title="인터페이스정의서 입력" /></td>
			</tr>

		</table>

		<div class="tit_bWrap mgb10" id="text_deploy_layout">
			<h4>배포정보</h4>
		</div>

		<!-- write -->
		<table class="sType mgb20" id="deploy_layout">
			<caption>배포정보</caption>
			<colgroup>
				<col style="width: 180px;" />
				<col style="width: 320px;" />
				<col style="width: 160px;" />
				<col style="width: 320px;" />
			</colgroup>
			<tr>
				<th scope="row" id="distr_filepath_th">배포경로 및 배포파일명</th>
				<td colspan="3"><textarea name="distr_filepath"
						id="distr_filepath" class="mgb5" style="padding-left: 5px;"></textarea>
				</td>
			</tr>
			<tr>
				<th scope="row" id="distr_svn_ver_th">SVN버전</th>
				<td><input type="text" name="distr_svn_ver" id="distr_svn_ver"
					value="" title="SVN버전" /></td>
				<th scope="row" id="distr_dt_th">배포일자</th>
				<td><input type="text" name="distr_dt" id="distr_dt" value=""
					title="배포일자" class="w200" readonly="readonly" /></td>
			</tr>
		</table>

		<!--// write -->

		<!-- write -->
		<table class="sType mgb20">
			<caption>메모 입력</caption>
			<colgroup>
				<col style="width: 180px;" />
				<col style="width: 320px;" />
				<col style="width: 160px;" />
				<col style="width: 320px;" />
			</colgroup>
			<tr>
				<th scope="row">메모&nbsp;&nbsp;&nbsp;&nbsp;<span
					style="color: red;">(관리자가 작성한 내용입니다.)</span></th>
				<td colspan="3"><textarea name="memo" id="memo" class="mgb5"
						style="padding-left: 5px;"></textarea></td>
			</tr>
		</table>

		<input type="text" name="cust_gubun" id="cust_gubun" value="" title=""
			style="display: none;" /> <input type="text" name="appr_yn1"
			id="appr_yn1" value="" title="" style="display: none;" /> <input
			type="text" name="appr_yn2" id="appr_yn2" value="" title=""
			style="display: none;" /> <input type="text" name="appr_emp1"
			id="appr_emp1" value="" title="" style="display: none;" /> <input
			type="text" name="appr_emp2" id="appr_emp2" value="" title=""
			style="display: none;" /> <input type="text" name="appr_date1"
			id="appr_date1" value="" title="" style="display: none;" /> <input
			type="text" name="appr_date2" id="appr_date2" value="" title=""
			style="display: none;" />

		<!--// write -->
		<!-- list -->
		<c:if test="${fn:indexOf(vo.pageType, 'nsert') == -1 }">
			<div class="tit_bWrap mgb10">
				<h4 class="floatL">업무 처리 이력</h4>
			</div>
			<table class="hType mgb20">
				<caption>조치 이력</caption>
				<colgroup>
					<col style="width: 170px" />
					<col style="width: 65px" />
					<col style="width: 65px" />
					<col style="width: 170px" />
					<col style="width: auto" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col">처리일자</th>
						<th scope="col">처리자</th>
						<th scope="col">인수자</th>
						<th scope="col">처리상태</th>
						<th scope="col">작업처리 의견</th>

					</tr>
				</thead>
				<tbody id="asHistTbody"></tbody>
			</table>
		</c:if>
		<!--// list -->
		<div class="btn_wrap">
			<div class="floatL">
				<button type="button" class="btn_ico_list"
					onclick="javascript:goList();">
					<span>목록</span>
				</button>

			</div>
			<div class="floatR">
				<c:if test="${roleList.get(0).role_code ne '02_JWH_USER'}">
					<button type="button" class="btn_ico_confirm gray"
						onclick="javascript:goApprove();">
						<span>결재</span>
					</button>
					<button type="button" class="btn_ico_delete gray"
						onclick="javascript:goReject();"
						style="min-width: 95px !important;">
						<span>부결</span>
					</button>
					<button type="button" class="btn_ico_confirm"
						onclick="javascript:goSave();">
						<span>저장</span>
					</button>
				</c:if>
				<button type="button" class="btn_ico_cancel"
					onclick="javascript:goList();">
					<span>취소</span>
				</button>
			</div>
		</div>
	</div>
</form>

<div id="subTab2" style="display: none;">
	<div id="wrap_star" style="display: none;">
		<div class="tit_bWrap mgb10">
			<h4>고객평가</h4>
		</div>
		<table class="vType_line mgb20">
			<caption>고객평가 내용</caption>
			<colgroup>
				<col style="width: 124px;">
				<col style="width: auto;">
			</colgroup>
			<thead>
				<tr>
					<th class="textC">고객평가</th>
					<th class="textC">건의사항</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td><input type="radio" id="star1" name="starRate" value="1">
						<input type="radio" id="star2" name="starRate" value="2">
						<input type="radio" id="star3" name="starRate" value="3">
						<input type="radio" id="star4" name="starRate" value="4">
						<input type="radio" id="star5" name="starRate" value="5">
						<span class="wrapStar"> <label for="star1"></label> <label
							for="star2"></label> <label for="star3"></label> <label
							for="star4"></label> <label for="star5"></label>
					</span></td>
					<td><textarea name="star_content" id="star_content"
							class="lineH13 pd5" readonly="readonly" style="height: 50px;"></textarea>
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
			<td id="call_content_view" style="white-space: pre-line;">
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
	<div style="max-height: 300px; overflow-y: auto; margin-bottom: 20px;"
		id="awsWrap">
		<table class="hType">
			<caption>답변내용 목록</caption>
			<colgroup>
				<col style="width: 130px" />
				<col style="width: 200px" />
				<col style="width: auto" />
				<col style="width: 140px" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">작성자</th>
					<th scope="col">답변일시</th>
					<th scope="col">답변내용</th>
					<th scope="col"></th>
				</tr>
			</thead>
			<tbody id="awsInfoList" style="white-space: pre-line;"></tbody>
		</table>
	</div>

	<!-- 답변작성  -->
	<form name="answerForm" id="answerForm" method="post"
		enctype="multipart/form-data">
		<input type="hidden" name="as_no" /> <input type="hidden" name="seq" />
		<input type="hidden" name="pageType" />
		<table class="sType mgb30">
			<caption>답변내용 목록</caption>
			<colgroup>
				<col style="width: 130px" />
			</colgroup>
			<tbody id="aswWrapFile">
				<tr>
					<th scope="col">답변작성</th>
					<td class="pd10" style="border: 1px solid #dadada"><textarea
							name="w_content" id="w_content" class="lineH13 pd5"></textarea></td>
				</tr>
			</tbody>
		</table>
	</form>
	<!--// list -->
	<div class="btn_wrap">
		<div class="floatL">
			<button type="button" class="btn_ico_list" onclick="goList();">
				<span>목록</span>
			</button>
		</div>
		<c:if test="${ vo.pageType ne 'insert' }">
			<div class="floatR">
				<button type="button" class="btn_ico_write dgray"
					onclick="btnAswProc('insert');">
					<span>답변 작성</span>
				</button>
			</div>
		</c:if>
	</div>
</div>

<!-- CMC add UI 중분류 2021.01.12  -->
<div class="box_layer layer_sms"
	style="margin-top: -20px; display: none; height: 500px;"
	id="div_category_pop">
	<h1>중분류</h1>
	<div class="layer_contents pdt20" style="height: 450px;">
		중분류: <input type="text" class="w175 mgr10" id="searchCategoryName"
			name="searchCategoryName" title="중분류" autofocus="autofocus" />
		<button type="button" class="btn_ico_search mgr5"
			onclick="javascript:categoryList(1);">
			<span>검색</span>
		</button>
		<table class="vType_line" style="margin-top: 10px">
			<caption>중분류</caption>
			<colgroup>
				<col style="width: 70px;" />
				<col style="width: 70px;" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">중분류ID</th>
					<th scope="col">중분류명</th>
				</tr>
			</thead>
			<tbody id="categoryPopInfoList"></tbody>
		</table>
		<div class="page" id="layer_pagination_category"
			style="margin-top: 10px;"></div>
	</div>
	<button type="button" class="btn_close"
		onclick="javascript:closeCategoryPopLayer();">창 닫기</button>
</div>
<!--  -->

<!-- CMC add UI 프로그램명 2021.01.12  -->
<div class="box_layer layer_sms"
	style="margin-top: -20px; display: none; height: 500px;"
	id="div_program_pop">
	<h1>프로그램명</h1>
	<div class="layer_contents pdt20" style="height: 450px;">
		프로그램: <input type="text" class="w175 mgr10" id="searchProgramName"
			name="searchProgramName" title="프로그램" autofocus="autofocus" />
		<button type="button" class="btn_ico_search mgr5"
			onclick="javascript:programList(1);">
			<span>검색</span>
		</button>
		<table class="vType_line" style="margin-top: 10px">
			<caption>프로그램명</caption>
			<colgroup>
				<col style="width: 70px;" />
				<col style="width: 70px;" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">프로그램ID</th>
					<th scope="col">프로그램명</th>
				</tr>
			</thead>
			<tbody id="programPopInfoList"></tbody>
		</table>
		<div class="page" id="layer_pagination_program"
			style="margin-top: 10px;"></div>
	</div>
	<button type="button" class="btn_close"
		onclick="javascript:closeProgramPopLayer();">창 닫기</button>
</div>
<!--  -->

<div class="box_layer layer_sms"
	style="margin-top: -300px; display: none; height: 600px;" id="div1">
	<h1>거래처 정보 조회 검색 결과</h1>
	<div class="layer_contents pdt20" style="height: 500px;">
		기관명: <input type="text" class="w175 mgr10" id="searchKorName"
			name="searchKorName" title="거래처 정보 검색" autofocus="autofocus" />
		<button type="button" class="btn_ico_search mgr5"
			onclick="javascript:custList(1);">
			<span>검색</span>
		</button>
		<table class="vType_line" style="margin-top: 10px">
			<caption>거래처 정보 목록</caption>
			<colgroup>
				<col style="width: 50px;" />
				<col style="width: 100px;" />
				<col style="width: 180px;" />
				<col style="width: 100px;" />
				<col style="width: 100px;" />

			</colgroup>
			<thead>
				<tr>
					<th scope="col">No</th>
					<th scope="col">거래처구분</th>
					<th scope="col">거래처명</th>
					<th scope="col">거래처 코드</th>
					<th scope="col">대표자</th>
				</tr>
			</thead>
			<tbody id="custInfoList"></tbody>
		</table>
		<div class="page" id="layer_pagination1" style="margin-top: 10px;"></div>
	</div>
	<button type="button" class="btn_close"
		onclick="javascript:closeLayer(1);">창 닫기</button>
</div>

<div class="layer_dimmed" style="display: none;" id="div1_dim"></div>

<div class="box_layer layer_sms" style="display: none; height: 600px;"
	id="div2">
	<h1>A/S 신청자 이름 검색</h1>
	<div class="layer_contents pdt20" style="height: 500px;">
		이름: <input type="text" class="w175 mgr10" id="searchEmpName"
			name="searchEmpName" title="신청자 유형" autofocus="autofocus" />
		<button type="button" class="btn_ico_search mgr5"
			onclick="javascript:empList(1);">
			<span>검색</span>
		</button>
		<table class="vType_line" id="cust_emp_tb" style="margin-top: 10px">
			<caption>거래처 정보 목록</caption>
			<colgroup>
				<col style="width: 50px;" />
				<col style="width: 100px;" />
				<col style="width: 100px;" />
				<col style="width: 150px;" />
				<col style="width: 60px;" />
				<col style="width: 150px;" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">No</th>
					<th scope="col">팀명</th>
					<th scope="col">아이디</th>
					<th scope="col">이름</th>
					<th scope="col">직책</th>
					<th scope="col">연락처</th>
				</tr>
			</thead>
			<tbody id="empInfoList"></tbody>
		</table>
		<button type="button" class="btn_line_gray" style="margin-top: 10px"
			onclick="btnEmpField('layer');">직접입력</button>
		<div class="page" id="layer_pagination2" style="margin-top: 10px;"></div>
	</div>
	<button type="button" class="btn_close"
		onclick="javascript:closeLayer(2);">창 닫기</button>
</div>
<div class="layer_dimmed" style="display: none;" id="div2_dim"></div>



<!-- A/S 담당자 조회 -->
<div class="box_layer layer_sms" style="display: none; height: 520px;"
	id="div6">
	<h1>A/S 담당자 조회</h1>
	<div class="layer_contents pdt20" style="height: 480px;">
		이름: <input type="text" class="w175 mgr10" id="searchCharName"
			name="searchCharName" title="담당자 입력" autofocus="autofocus" />
		<button type="button" class="btn_ico_search mgr5"
			onclick="javascript:charList(1);">
			<span>검색</span>
		</button>
		<table class="vType_line" id="emp_tb" style="margin-top: 10px">
			<caption>직원 정보 목록</caption>
			<colgroup>
				<col style="width: 50px;" />
				<col style="width: 160px;" />
				<col style="width: 100px;" />
				<col style="width: 100px;" />
				<col style="width: 80px;" />
				<col style="width: 140px;" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">No</th>
					<th scope="col">부서/팀명</th>
					<th scope="col">사번</th>
					<th scope="col">이름</th>
					<th scope="col">직책</th>
					<th scope="col">이메일</th>
				</tr>
			</thead>
			<tbody id="charInfoList"></tbody>
		</table>
		<div class="page" id="layer_pagination6" style="margin-top: 10px;"></div>
	</div>
	<button type="button" class="btn_close"
		onclick="javascript:closeLayer(6);">창 닫기</button>
</div>
<div class="layer_dimmed" style="display: none;" id="div6_dim"></div>

<!-- 답변작성 -->
<div class="box_layer layer_comment" style="display: none;" id="div3">
	<h1 class="tit_back" id="div3PopTitle">답변 등록</h1>
	<div class="layer_contents">
		<textarea name="w_content" id="p_w_content" class="lineH13 pd5 mgb10"></textarea>


		<table class="sType mgb20">
			<tbody id="aswAttach_modify_tb">

			</tbody>
		</table>
		<div class="btn_wrap">
			<div class="floatR">
				<button type="button" class="btn_ico_write dgray w95"
					onclick="btnAswProc();">
					<span>등록</span>
				</button>
				<button type="button" class="btn_ico_cancel w95"
					onclick="btnAswCancel();">
					<span>취소</span>
				</button>
			</div>
		</div>
		<!--// write -->
	</div>
	<button type="button" class="btn_close"
		onclick="javascript:closeLayer(3);">창 닫기</button>
</div>
<div class="layer_dimmed" style="display: none;" id="div3_dim"></div>

<!-- 첨부파일 레이어팝업 -->
<div class="box_layer layer_sms" style="display: none;" id="div4">
	<h1>첨부파일 조회</h1>
	<div class="layer_contents pdt20">
		<table class="sType mgb20" style="border-top: 1px solid #ddd;">
			<caption>처리완료 사항 입력</caption>
			<colgroup>
				<col style="width: 140px;" />
				<col style="width: auto;" />
			</colgroup>
			<tbody id="attach2FileList">
				<!-- <tr>
					<th scope="row">첨부파일1</th>
					<td>
						<input type="text" class="w225" value="파일명.jpg" readonly="readonly">
						<button type="button" class="btn_ico_down mgl5 mgr5"><span>다운로드</span></button>					
					</td>  
				</tr>  -->
			</tbody>
		</table>
		<div class="btn_wrap">
			<div class="floatR">
				<button type="button" class="btn_ico_confirm"
					onclick="javascript:closeLayer(4);">
					<span>확인</span>
				</button>
			</div>
		</div>
	</div>
	<button type="button" class="btn_close"
		onclick="javascript:closeLayer(4);">창 닫기</button>
</div>
<div class="layer_dimmed" style="display: none;" id="div4_dim"></div>


<div class="box_layer layer_sms" style="display: none;" id="div5">
	<h1>작업처리 의견</h1>
	<div class="layer_contents pdt20" id="wrap_contents">
		<textarea id="show_hist_contents" class="mgb10 pd10"
			readonly="readonly" style="height: 268px;"></textarea>
		<div class="btn_wrap">
			<div class="floatR">
				<button type="button" class="btn_ico_cancel dgray"
					onclick="javascript:closeLayer(5);">
					<span>닫기</span>
				</button>
			</div>
		</div>
	</div>
	<button type="button" class="btn_close"
		onclick="javascript:closeLayer(5);">창 닫기</button>
</div>
<div class="layer_dimmed" style="display: none;" id="div5_dim"></div>


<!-- 처리등급 기준표 -->
<div class="box_layer layer_sms" style="display: none; height: 470px;"
	id="div7">
	<h1>처리등급 기준표</h1>
	<div class="layer_contents pdt20" style="height: 450px;">
		<table class="stats_hType mgb10 scroll-table">
			<caption>처리등급 기준표</caption>
			<colgroup>
				<col style="width: 40px;" />
				<col style="width: 60px;" />
				<col style="width: 90px;" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">처리등급</th>
					<th scope="col">요청내용</th>
					<th scope="col">구분</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>A</td>
					<td>프로그램 개발</td>
					<td>프로그램 개발(견적개발)</td>
				</tr>
				<tr>
					<td rowspan="5">B</td>
					<td rowspan="5">프로그램 개발/수정</td>
					<td>프로그램 개발</td>
				</tr>
				<tr>
					<td>단순 프로그램 수정</td>
				</tr>
				<tr>
					<td>DB 추가 및 변경</td>
				</tr>
				<tr>
					<td>기존화면 로직 추가</td>
				</tr>
				<tr>
					<td>버그 수정, 단순 기능 추가</td>
				</tr>
				<tr>
					<td rowspan="2">C</td>
					<td rowspan="2">데이터 요청/수정</td>
					<td>자료 요청</td>
				</tr>
				<tr>
					<td>단순 데이터 요청</td>
				</tr>
				<tr>
					<td>D</td>
					<td>기술지원/고객지원 및 요청해결/기타</td>
					<td>기타 서비스 요청 건 (Call, 교육, 회의 등)</td>
				</tr>
			</tbody>
		</table>
	</div>
	<button type="button" class="btn_close"
		onclick="javascript:closeLayer(7);">창 닫기</button>
</div>

<!-- 반려의견 작성 팝업 -->
<div class="box_layer layer_sms"
	style="margin-top: -20px; display: none; height: fit-content;"
	id="rejectListLayer">
	<h1>반려 처리</h1>
	<div class="layer_contents"
		style="padding-top: 30px; height: fit-content; overflow-y: auto;">
		<table class="hType mgb20 hType2">
			<caption>반려사유 기입</caption>
			<colgroup>
				<col style="width: 80px;" />
				<col style="width: 70px;" />
				<col style="width: 100px;" />
				<col style="width: 70px;" />
				<col style="width: 300px;" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">접수번호</th>
					<th scope="col">접수일</th>
					<th scope="col">거래처명</th>
					<th scope="col">요청자</th>
					<th scope="col">반려사유</th>
				</tr>
			</thead>
			<tbody id="rejectListBody">
			</tbody>
		</table>
		<div class="floatR">
			<button type="button" class="btn_ico_delete dgray"
				onclick="rejectProc()">부결</button>
		</div>
	</div>
	<button type="button" class="btn_close"
		onclick="$('#rejectListLayer').hide(); $('#div7_dim').hide();">창
		닫기</button>
</div>
</div>
<div class="layer_dimmed" style="display: none;" id="div7_dim"></div>

