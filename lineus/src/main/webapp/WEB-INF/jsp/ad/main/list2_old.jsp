<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="egovframework.com.comm.util.DateTimeUtil"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">

	var custGradeList;
	var gradeLabel = ["최우수","우수","일반","주의","위험"];
	
	var custOverdueList;
	var overDueQuarter;
	var overDueAction;

	$(document).ready(function(){
		goInfo() ; 
	}) ;
	
	function firstTab(gubun){
		location.href = "/ad/main/list" + gubun + ".do" ; 
	}
	
	function goInfo() {
		common.ajaxCall(datas, '/ad/main/getCustGradeList.do', 'setCustGradeData') ; /* 고객등급 / 리스트  */
		common.ajaxCall(datas, '/ad/main/getCustOverdueList.do', 'setCustOverdueData') ; /* 채권등급 / 리스트  */
		
		var datas = {'firstFlag' : '3'} ;
		common.ajaxCall(datas, '/ad/main/getBondReminderCnt1.do', 'makeInfo3') ; /* 채권 최고서 발송 */
		common.ajaxCall(datas, '/ad/main/getBondReminderCnt2.do', 'makeInfo4') ; /* 채권 최고 진행 */
		common.ajaxCall(datas, '/ad/main/getBondIssueList.do', 'makeInfo5') ; /* 이슈현황 */
	}
	
	function setActive(obj){
		$(obj).parent('li').siblings().removeClass("active");
		$(obj).parent('li').addClass("active");
	}
	
	function setCustOverdueData(data){
		
		custOverdueList = typeof data.resultList != 'undefined' ? data.resultList : null;
		if (custOverdueList == null) return;
		setCustOverdueCnt();
		$("#bond_value1").click();
	}
	
	function setCustOverdueCnt(){
		var levelA = 0, levelB = 0, levelC = 0, levelD = 0;
		
		for (var i=0; i < custOverdueList.length; i++) {
			if (custOverdueList[i].OVERDUE_LEVEL == "A") levelA++;
			if (custOverdueList[i].OVERDUE_LEVEL == "B") levelB++;
			if (custOverdueList[i].OVERDUE_LEVEL == "C") levelC++;
			if (custOverdueList[i].OVERDUE_LEVEL == "D") levelD++;
		}
		
		$('#bond_value1').html(levelA);
		$('#bond_value2').html(levelB);
		$('#bond_value3').html(levelC);
		$('#bond_value4').html(levelD);
	}
	
	function setCustOverdueList(level){
		
		if (custOverdueList == null) return;
		
// 		console.log(custOverdueList);
		
		// level로 필터링
		var overdueList = new Array();
		
		for (var i=0; i < custOverdueList.length; i++) {
			var datas = custOverdueList[i];
			
			if (level == datas.OVERDUE_LEVEL){
				overdueList.push(datas);
			}
		}
		
		var str = '';
		
		for (var i=0; i < overdueList.length; i++) {
			var datas = overdueList[i];
			str += '<tr style="cursor:pointer" onclick="goDetailForm(\''+ datas.SEQ +'\')">';
			str += '	<td>'+(i+1)+'</td>';
			str += '	<td>'+common.nvl(datas.CRM_CODE, '')+'</td>';
			str += '	<td class="uder_line">'+common.nvl(datas.CUST_KOR_NAME, '')+'</td>';
			str += '	<td>'+common.nvl(datas.OVERDUE_CNT, '')+'</td>';
			str += '	<td>'+common.nvl(datas.OVERDUE_LEVEL, '')+'</td>';
			str += '</tr>';
		}
		
		if (str != ''){
			$('#bondList').html(str);
		} else {
			commonTable.notData(5, '데이터가 없습니다.', 'bondList');
		}
		
	}
	
	function setCustGradeData(data){
		
		custGradeList = typeof data.resultList != 'undefined' ? data.resultList : null;
		if (custGradeList == null) return;
		setCustGradeCnt();
		$('#top_value3').click();
	}
	
	function setCustGradeCnt(){
		var value1 = 0, value2 = 0, value3 = 0, value4 = 0, value5 = 0;
		
		for (var i=0; i < custGradeList.length; i++) {
			var datas = custGradeList[i];
			var grade = Number(common.nvl(datas.grade,'0'));	
			
			if (grade >= 90) value1++;
			else if (grade >= 80 && grade < 90) value2++; 
			else if (grade >= 60 && grade < 80) value3++;
			else if (grade >= 50 && grade < 60) value4++;
			else if (grade < 50) value5++;
		}
		
		$('#top_value1').html(value1);
		$('#top_value2').html(value2);
		$('#top_value3').html(value3);
		$('#top_value4').html(value4);
		$('#top_value5').html(value5);
	}
	
	function setCustGradeList(level){
		
		if (custGradeList == null) return;
		
		// level로 필터링
		var gradeList = new Array();
		
		for (var i=0; i < custGradeList.length; i++) {
			var datas = custGradeList[i];
			
			var grade = common.nvl(Number(datas.grade), 0);
			
			if (level == 0){
				// 최우수
				if (grade >= 90) gradeList.push(datas);
				continue;
			}else if (level == 1){
				// 우수
				if (grade >= 80 && grade < 90) gradeList.push(datas);
				continue;
			}else if (level == 2){
				// 일반
				if (grade >= 60 && grade < 80) gradeList.push(datas);
				continue;
			}else if (level == 3){
				// 주의
				if (grade >= 50 && grade < 60) gradeList.push(datas);
				continue;
			}else if (level == 4){
				// 위험
				if (grade < 50) gradeList.push(datas);
			}
		}
		
		var gradeText = gradeLabel[level];
		var tdClass = '';
		if (level == 4) tdClass = 'colorRed';
		var str = '';
		
		for (var i=0; i < gradeList.length; i++) {
			var datas = gradeList[i];
			var grade = common.nvl(Number(datas.grade), 0);
			str += '<tr style="cursor:pointer" onclick="goDetailForm(\''+ datas.seq +'\')">';
			str += '	<td>'+(i+1)+'</td>';
			str += '	<td>'+common.nvl(datas.crm_code, '')+'</td>';
			str += '	<td class="uder_line">'+common.nvl(datas.cust_kor_name, '')+'</td>';
			str += '	<td class="'+tdClass+'">'+grade+'</td>';
			str += '</tr>';
		}
		if (str != ''){
			$('#gradeList').html(str);
		} else {
			commonTable.notData(4, '데이터가 없습니다.', 'gradeList');
		}
	}
	
	function makeInfo3(data) {
		
		var resultList = typeof data.resultList != 'undefined' ? data.resultList : null;
		
		if (resultList != null && resultList.length > 0) {
			
			console.log(resultList);
			
			overDueQuarter = new Array();
			
			var cnt1 = 0;
			var cnt2 = 0;
			var cnt3 = 0;
			var yCnt1 = 0;
			var yCnt2 = 0;
			var yCnt3 = 0;
			var queter = "";
			
			for (var i=0; i<resultList.length; i++) {
				var datas = resultList[i];
				
				if (common.nvl(datas.gubun,'') == 'A') {
					cnt1 += Number(common.nvl(datas.c1 , '0'));
					cnt2 += Number(common.nvl(datas.c2, '0'));
					cnt3 += Number(common.nvl(datas.c3, '0'));
					overDueQuarter.push(datas);
				} else if (common.nvl(datas.gubun,'') == 'B') {
					yCnt1 += Number(common.nvl(datas.c1, '0'));
					yCnt2 += Number(common.nvl(datas.c2, '0'));
					yCnt3 += Number(common.nvl(datas.c3, '0'));
				}
				queter = common.nvl(datas.c4, '0');
			}
			
			console.log(overDueQuarter);
			
			var calculate1 = 0;
			var calculate2 = 0;
			var calculate3 = 0;
			var class1 = "";
			var class2 = "";
			var class3 = "";
			
			if (yCnt1 > 0) {
				if (yCnt1 > cnt1) {
					calculate1 = ((yCnt1 - cnt1) / yCnt1) * 100;
					class1 = "down";
				} else {
					calculate1 = ((cnt1 - yCnt1) / yCnt1) * 100;
					class1 = "up";
				}
			} else {
				class1 = "stop";
			}
			var calText1 = (calculate1 > 0) ? "<span class=\""+class1+"\">"+Math.floor(calculate1)+"%" : " -</span>";
			
			if (yCnt2 > 0) {
				if (yCnt2 > cnt2) {
					calculate2 = ((yCnt2 - cnt2) / yCnt2) * 100;
					class2 = "down";
				} else {
					calculate2 = ((cnt2 - yCnt2) / yCnt2) * 100;
					class2 = "up";
				}
			} else {
				class2 = "stop";
			}
			var calText2 = (calculate2 > 0) ? "<span class=\""+class2+"\">"+Math.floor(calculate2)+"%" : " -</span>";
			
			if (yCnt3 > 0) {
				if (yCnt3 > cnt3) {
					calculate3 = ((yCnt3 - cnt3) / yCnt3) * 100;
					class3 = "down";
				} else {
					calculate3 = ((cnt3 - yCnt3) / yCnt3) * 100;
					class3 = "up";
				} 
			} else {
				class3 = "stop";
			}
			var calText3 = (calculate3 > 0) ? "<span class=\""+class3+"\">"+Math.floor(calculate3)+"%" : " -</span>";
			
			$('#q_value1').html(cnt1 + calText1);
			$('#q_value2').html(cnt2 + calText2);
			$('#q_value3').html(cnt3 + calText3);
			$('#queter').html(queter);
			$('#queter2').html(queter);
		}
	}
	
	function makeInfo4(data) {
		
		overDueAction = typeof data.resultList != 'undefined' ? data.resultList : null;
	
		if (overDueAction != null && overDueAction.length > 0) {
			
			var c1=0,c2=0,c3=0,c4=0;
			for (var i=0; i<overDueAction.length; i++) {
				var datas = overDueAction[i];
				c1 += Number(common.nvl(datas.c1, '0'));
				c2 += Number(common.nvl(datas.c2, '0'));
				c3 += Number(common.nvl(datas.c3, '0'));
				c4 += Number(common.nvl(datas.c4, '0'));
			}
			
			$('#r_value1').html(c1);
			$('#r_value2').html(c2);
			$('#r_value3').html(c3);
			$('#r_value4').html(c4);
			
		} else {
			$('#r_value1').html('0');
			$('#r_value2').html('0');
			$('#r_value3').html('0');
			$('#r_value4').html('0');
		}
	}
	
	function makeInfo5(data) {
		var resultList = typeof data.resultList != 'undefined' ? data.resultList : null;
		
		$('#issueList').empty();
		
		if (resultList != null && resultList.length > 0) {
			
			var str = '';
			
			for (var i=0; i<resultList.length; i++) {
				var datas = resultList[i];
				
				str += '<tr style="cursor:pointer" onclick="goDetailForm(\''+ datas.seq +'\')">';
				str += '	<td>'+(i+1)+'</td>';
				str += '	<td class="uder_line">'+common.nvl(datas.cust_kor_name,'')+'</td>';
				str += '	<td>'+common.nvl(datas.cnt,'0')+'건</td>';
				str += '</tr>';
			}
			
			$('#issueList').html(str);
			$('#issueTotal').html(resultList.length);
		} else {
			commonTable.notData(3, '데이터가 없습니다.', 'issueList');
		}
	}
	
	function goDetailForm(seq){
		location.href = "/ad/cust/form.do?seq=" + seq;
	}
	
	
	function getCustList(flag){
		
		if (overDueQuarter == null) return;

		var seqStr = "";
		
		for (var i=0; i < overDueQuarter.length;i++){
			if (overDueQuarter[i][flag] != 0) seqStr += ",'" + overDueQuarter[i].seq + "'"; 
		}
		
		console.log(seqStr);
		
		if (seqStr === ""){
			alert("대상 건이 없습니다.");
			return;
		}
		
		var datas = {'seqArr' : seqStr.substring(1)} ;
		common.ajaxCall(datas, '/ad/main/getCustListBySeq.do', 'showCustListLayer') ;
	}
	
	function getCustList2(flag){
		
		if (overDueAction == null) return;

		var seqStr = "";
		
		for (var i=0; i < overDueAction.length;i++){
			if (overDueAction[i][flag] != 0) seqStr += ",'" + overDueAction[i].seq + "'"; 
		}
		
		console.log(seqStr);
		
		if (seqStr === ""){
			alert("대상 건이 없습니다.");
			return;
		}
		
		var datas = {'seqArr' : seqStr.substring(1)} ;
		common.ajaxCall(datas, '/ad/main/getCustListBySeq.do', 'showCustListLayer') ;
	}
	
	function showCustListLayer(data){
		var custList = typeof data.resultList != "undefined" ? data.resultList : null ;
		
		if (custList == null) return;
		
		var htmlStr = "";
		for (var i=0; i < custList.length; i++){
			htmlStr += '<tr style="cursor:pointer" onclick="goDetailForm(\''+ custList[i].SEQ +'\')">';
			htmlStr += '	<td>' + custList[i].CRM_CODE + '</td>';
			htmlStr += '	<td>' + custList[i].CUST_GUBUN + '</td>';
			htmlStr += '	<td>' + custList[i].FOUNDATION_CODE + '</td>';
			htmlStr += '	<td>' + custList[i].SPECIALLY_CODE + '</td>';
			htmlStr += '	<td class="uder_line">' + custList[i].CUST_KOR_NAME + '</td>';
			htmlStr += '	<td>' + custList[i].DEAL_CODE + '</td>';
			htmlStr += '	<td>' + common.strToDate(custList[i].CONTRACT_DT) + '</td>';
			htmlStr += '</tr>';
		}
		
		$("#custListBody").html(htmlStr);
		$("#custListLayer").show();
		
	}
	
</script>

<ul class="tab_dashboard list3 mgt30 mgb30">
	<li id="Firstli1"><a href="javascript:firstTab('');">거래처 현황</a></li><!-- 활성시 current -->
	<li id="Firstli2"><a href="javascript:firstTab('1');">A/S</a></li>
	<li id="Firstli3" class="active"><a href="javascript:firstTab('2');">채권관리</a></li>
</ul>

<div class="floatWrap mgb20">
	<div class="w485 floatL">
		<div class="tit_wrap small">
			<h3 class="tit_ico_people">고객 등급</h3>
		</div>
		<div class="db-greybox">
			<ul class="list5">
				<li class="active"  style="cursor:pointer;">
					<p>최우수</p>
					<p class="num_db" id="top_value1" onclick="setCustGradeList(0);setActive(this);">0</p>
				</li>
				<li  style="cursor:pointer;"><!-- 활성시 active -->
					<p>우수</p>
					<p class="num_db" id="top_value2" onclick="setCustGradeList(1);setActive(this);">0</p>
				</li>
				<li style="cursor:pointer;">
					<p>일반</p>
					<p class="num_db" id="top_value3" onclick="setCustGradeList(2);setActive(this);">0</p>
				</li>
				<li style="cursor:pointer;">
					<p>주의</p>
					<p class="num_db" id="top_value4" onclick="setCustGradeList(3);setActive(this);">0</p>
				</li>
				<li style="cursor:pointer;">
					<p>위험</p>
					<p class="num_db colorRed" id="top_value5" onclick="setCustGradeList(4);setActive(this);">0</p>
				</li>
			</ul>
		</div>
	</div>
	<div class="w485 floatR db_borderbox h145">
		<table class="hType">
			<colgroup>
				<col style="width:90px">
				<col span="3" style="width:auto;">
			</colgroup>
			<thead>
				<tr>
					<th scope="col">No.</th>
					<th scope="col">CRM code</th>
					<th scope="col">병원명</th>
					<th scope="col">고객등급</th>
				</tr>
			</thead>
			<tbody id="gradeList"></tbody>
		</table>
	</div>
</div>

<div style="height:1px;background:#ddd;"></div>
<div class="floatWrap mgt20 mgb20">
	<div class="w485 floatL">
		<div class="tit_wrap small">
			<h3 class="tit_ico_customer">채권 등급</h3>
		</div>
		<div class="db-greybox">
			<ul class="list4">
				<li class="active" style="cursor:pointer;">
					<p>A</p>
					<p class="num_db" id="bond_value1" onclick="setCustOverdueList('A');setActive(this);">0</p>
				</li>
				<li style="cursor:pointer;">
					<p>B</p>
					<p class="num_db" id="bond_value2" onclick="setCustOverdueList('B');setActive(this);">0</p>
				</li>
				<li style="cursor:pointer;"><!-- 활성시 active -->
					<p>C</p>
					<p class="num_db" id="bond_value3" onclick="setCustOverdueList('C');setActive(this);">0</p>
				</li>
				<li style="cursor:pointer;">
					<p>D</p>
					<p class="num_db" id="bond_value4" onclick="setCustOverdueList('D');setActive(this);">0</p>
				</li>
			</ul>
		</div>
	</div>
	<div class="w485 floatR db_borderbox h145">
		<table class="hType">
			<colgroup>
				<col style="width:90px">
				<col span="3" style="width:auto;">
			</colgroup>
			<thead>
				<tr>
					<th scope="col">No.</th>
					<th scope="col">CRM code</th>
					<th scope="col">병원명</th>
					<th scope="col">연체개월</th>
					<th scope="col">채권등급</th>
				</tr>
			</thead>
			<tbody id="bondList"></tbody>
		</table>
	</div>
</div>

<div style="height:1px;background:#ddd;"></div>
<div class="floatWrap mgt20">
	<div class="floatL w485">
		<div class="tit_wrap small">
			<h3 class="tit_ico_paper" id="quarter">채권 현황 (<span id="queter">1</span>/4분기)</h3>
		</div>
		<div class="tit_sWrap">
			<h3>채권 최고서 발송</h3>
		</div>
		<div class="db-greybox mgb10">
			<ul class="list3">
				<li>
					<p>1차</p>
					<p class="num_db" id="q_value1" style="cursor:pointer" onclick="getCustList('c1')">0</p>
				</li>
				<li>
					<p>2차</p>
					<p class="num_db" id="q_value2" style="cursor:pointer" onclick="getCustList('c2')">0</p>
				</li>
				<li>
					<p>법적조치</p>
					<p class="num_db" id="q_value3" style="cursor:pointer" onclick="getCustList('c3')">0</p>
				</li>
			</ul>
		</div>
		<div class="tit_sWrap">
			<h3>채권 최고 진행</h3>
		</div>
		<div class="db-greybox">
			<ul class="list4">
				<li>
					<p>입금</p>
					<p class="num_db" id="r_value1" style="cursor:pointer" onclick="getCustList2('c1')">0</p>
				</li>
				<li>
					<p>답변</p>
					<p class="num_db" id="r_value2" style="cursor:pointer" onclick="getCustList2('c2')">0</p>
				</li>
				<li>
					<p>무응답</p>
					<p class="num_db" id="r_value3" style="cursor:pointer" onclick="getCustList2('c3')">0</p>
				</li>
				<li>
					<p>기타</p>
					<p class="num_db" id="r_value4" style="cursor:pointer" onclick="getCustList2('c4')">0</p>
				</li>
			</ul>
		</div>
	</div>
	<div class="floatR w485">
		<div class="tit_wrap small">
			<h3 class="tit_ico_graph4">이슈 현황 (<span id="queter2">1</span>/4분기, 총 <span id="issueTotal">0</span>건)</h3>
		</div>
		<div class="db_borderbox h290">
		<table class="hType">
			<colgroup>
				<col style="width:auto;">
				<col style="width:150px;">
			</colgroup>
			<thead>
				<tr>
					<th>No</th>
					<th>병원명</th>
					<th>건 수</th>
				</tr>
			</thead>
			<tbody id="issueList"></tbody>
		</table>
	</div>
	</div>
</div>

<!-- 거래처리스트 레이어팝업 -->
<div id="custListLayer" style="display:none;">
	<div class="box_layer layer_sms" style="height:700px;margin-top:-400px;">
		<h1>거래처목록</h1>
		<div class="layer_contents" style="padding-top:20px;height:600px;overflow-y:auto;">
			<table class="hType mgb20">
				<caption>총 수금정보</caption>
				<colgroup>
					<col style="width:auto;" />
				</colgroup>
				<tr>
					<th>CRM CODE</th>
					<th>거래처구분</th>
					<th>재단구분</th>
					<th>전문병원유형</th>
					<th>거래처명</th>
					<th>거래상태</th>
					<th>생성일</th>
				</tr>
				<tbody id="custListBody">
				</tbody>
			</table>
		</div>
		<button type="button" class="btn_close" onclick="$('#custListLayer').hide()">창 닫기</button>
	</div>
	<div class="layer_dimmed"></div>
</div>