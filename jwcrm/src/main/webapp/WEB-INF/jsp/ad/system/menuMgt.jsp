<%@page import="egovframework.com.comm.util.CommonExecute"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javascript" src="/js/jquery.mtz.monthpicker.js"></script>
<script type="text/javascript">
	
	$(document).ready(function(){
		sessionStorage.setItem("search_type10_checked", true);
		common.ajaxCall('', '/ad/system/getMenuList.do', 'setMenuList');
	});
	
	var menuList = null;
	function setMenuList(datas){
		menuList = datas.resultList == 'undefined' ? null : datas.resultList;
		console.log(menuList);
 		drawMenuListBody();
	}
	
	function drawMenuListBody(){
		if (menuList == null) return;
		var htmlStr = "";
		for (var i=0; i < menuList.length; i++){
			htmlStr += "<tr>";
			htmlStr += "	<td>"+menuList[i].menu_code+"</td>";
			htmlStr += "	<td>"+menuList[i].p_menu_code+"</td>";
			htmlStr += "	<td>"+menuList[i].menu_depth+"</td>";
			htmlStr += "	<td>"+menuList[i].menu_nm+"</td>";
			htmlStr += "	<td>"+menuList[i].menu_url+"</td>";
			htmlStr += "	<td>"+menuList[i].ord_num+"</td>";
			htmlStr += "	<td>";
// 			htmlStr += "<span style='cursor:pointer' onclick='progProc(this,\"update\")'>[수정]</span>";
			htmlStr += " / ";
// 			htmlStr += "<span style='cursor:pointer' onclick='progProc(this,\"delete\")'>[삭제]</span>";
			htmlStr += "	</td>";
			htmlStr += "</tr>";
		}
		$("#menuListBody").html(htmlStr);
	}
	
// 	function progProc(obj,type){
		
// 		var progCode = "";
// 		var progName = "";
		
// 		$(obj).closest("tr").children().each(function(idx){
// 			if (idx == 0) progCode = $(this).text();
// 			if (idx == 1) progName = $(this).children("input[name='progName']").val();
// 		});
		
// 		var data = {'prog_code' : progCode, 'prog_name' : progName}
// 		common.ajaxCall(data,"/ad/system/progProc.do?type=" + type,"progProcReturn");
// 	}
	
// 	function progProcReturn(data){
		
// 		console.log(data);
		
// 		var resultCode = data.resultCode == 'undefined' ? null : data.resultCode;
// 		var resultMsg = data.resultMsg == 'undefined' ? null : data.resultMsg;
// 		var resultType = data.resultType == 'undefined' ? null : data.resultType;
// 		var vo = data.vo == 'undefined' ? null : data.vo;
		
// 		if (resultCode == null || resultMsg == null) {
// 			alert('결과 코드가 없습니다.');
// 			return;
// 		}
		
// 		alert(data.resultMsg);
		
// 		resetData(vo,resultType);
// 	}
	
// 	function resetData(vo,type){

// 		if (type == 'update'){
// 			for (var i=0; progList !=null && i < progList.length; i++ ){
// 				if (progList[i].prog_code == vo.prog_code){
// 					progList[i].prog_name = vo.prog_name;
// 					break;
// 				}
// 			}
// 		}else if (type == 'delete'){
// 			var i = 0;
// 			for (i=0; progList !=null && i < progList.length; i++ ){
// 				if (progList[i].prog_code == vo.prog_code){
// 					break;
// 				}
// 			}
			
// 			progList.splice(i,1);
// 		}else if (type = 'insert'){
// 			progList.push(vo);
// 		}
		
		
// 		drawProgListBody();
// 	}
	
// 	function progRegist(){
// 		var data = $("form[name=progRegistForm]").serialize();
// 		common.ajaxCall(data,"/ad/system/progProc.do?type=insert","progProcReturn");
// 	}
	
</script>

<div class="tit_wrap">
	<%= CommonExecute.returnLineMap(request) %>
</div>

<table class="sType mgb10">
	<caption>프로그램 리스트</caption>
	<colgroup>
		
    </colgroup>
	<thead id="tHeader">
		<tr>
			<th>메뉴코드</th>
			<th>상위메뉴코드</th>
			<th>Depth</th>
			<th>메뉴명</th>
			<th>프로그램 Url</th>
			<th>정렬순서</th>
			<th>기능</th>
		</tr>
	</thead>
	<tbody id="menuListBody">
	</tbody>
</table>
<div>등록 / 수정</div>
<form name="progRegistForm">
<table class="sType mgb10">
	<caption>프로그램 등록</caption>
	<colgroup>
		<col style="width:100px">
		<col style="width:*">
		<col style="width:100px">
		<col style="width:*">
    </colgroup>
	<tbody>
		<tr>
			<th>메뉴코드</th>
			<td><input type="text" name="prog_code"/></td>
			<th>상위메뉴코드</th>
			<td><input type="text" name="prog_name"/></td>
		</tr>
		<tr>
			<th>메뉴명</th>
			<td><input type="text" name="prog_code"/></td>
			<th>Depth</th>
			<td><input type="text" name="prog_name"/></td>
		</tr>
		<tr>
			<th>프로그램 URL</th>
			<td><input type="text" name="prog_code"/></td>
			<th>정렬순서</th>
			<td><input type="text" name="prog_name"/></td>
		</tr>
	</tbody>
</table>
<div class="floatR"><input type="button" value="등록" onclick="progRegist()"/></div>
</form>