<%@page import="egovframework.com.comm.util.CommonExecute"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script type="text/javascript" src="/js/jquery.mtz.monthpicker.js"></script>

<style>
.selected {
    background: #ccf5f7;
    border-color: #46b8da;
}

option {
	height: 20px;
}

</style>
<script type="text/javascript">
	
	$(document).ready(function(){
		common.ajaxCall('', '/ad/system/getRoleList.do', 'setRoleList');
	});
	
	var roleList = null;
	function setRoleList(datas){
		roleList = datas.resultList == 'undefined' ? null : datas.resultList;
		console.log(roleList);
 		drawRoleListBody();
	}
	
	function drawRoleListBody(){
		if (roleList == null) return;
		var htmlStr = "";
		for (var i=0; i < roleList.length; i++){
			htmlStr += "<tr>";
			htmlStr += "	<td style='cursor:pointer' onclick='selectRoleCode(this)'>"+roleList[i].role_code+"</td>";
			htmlStr += "	<td><input type='text' name='roleName' value='"+roleList[i].role_name+"'/></td>";
			htmlStr += "	<td>";
			htmlStr += "<span style='cursor:pointer' onclick='roleProc(this,\"update\")'>[수정]</span>";
			htmlStr += " / ";
			htmlStr += "<span style='cursor:pointer' onclick='roleProc(this,\"delete\")'>[삭제]</span>";
			htmlStr += "	</td>";
			htmlStr += "</tr>";
		}
		$("#roleListBody").html(htmlStr);
	}
	
	function getRoleNameByCode(roleCode){
		for (var i=0; roleList != null && i < roleList.length; i++){
			if (roleList[i].role_code == roleCode) return roleList[i].role_name;
		}
		return "";
	}
	
	function selectRoleCode(obj){
		
		var roleCode = $(obj).text();
		
		// 선택시 백그라운드 컬러 셋팅
		$(obj).closest("tr").closest("tbody").children().each(function(idx){
			$(this).removeClass("selected");
		});
		
		$(obj).closest("tr").addClass("selected");
		
		// 선택된 코드 하단에 보여주기
		$(".selectedRoleName").text(getRoleNameByCode(roleCode));
		
		var data = {'role_code' : roleCode}
		common.ajaxCall(data,"/ad/system/getManageRoleList.do","setManageRoleList");
	}
	
	var registeredMenuList;
	var registrableMenuList;
	var registeredProgList;
	var registrableProgList;
	
	var registeredUserList;
	var registrableUserList;

	var selectedRoleCode;
	
	function setManageRoleList(data){
		registeredMenuList = data.registeredMenuList == 'undefined' ? null : data.registeredMenuList;
		registrableMenuList = data.registrableMenuList == 'undefined' ? null : data.registrableMenuList;
		registeredProgList = data.registeredProgList == 'undefined' ? null : data.registeredProgList;
		registrableProgList = data.registrableProgList == 'undefined' ? null : data.registrableProgList;
		registeredUserList = data.registeredUserList == 'undefined' ? null : data.registeredUserList;
		registrableUserList = data.registrableUserList == 'undefined' ? null : data.registrableUserList;
		
		var vo = data.vo == 'undefined' ? null : data.vo;
		
		if (registeredMenuList == null || registrableMenuList == null || 
				registeredProgList == null || registrableProgList == null ||
				registeredUserList == null || registrableUserList == null ||
				vo == null){
			
			registeredMenuList = null;
			registrableMenuList = null;
			registeredProgList = null;
			registrableProgList = null;
			registeredUserList = null;
			registrableUserList = null;
			
			selectedRoleCode = null;
			vo = null;
			return;
		}
		
		selectedRoleCode = vo.role_code;
		
		drawMenuList();
		drawProgList();
		drawUserList();
	}
	
	function drawMenuList(){
		console.log(registeredMenuList);
		console.log(registrableMenuList);
		
		var htmlStr = "";
		for (var i=0; registeredMenuList != null && i < registeredMenuList.length; i++){
			htmlStr += "<option value='"+registeredMenuList[i].menu_code+"'>"+registeredMenuList[i].menu_nm+"</option>";
		}
		
		$("#selectedMenuList").html(htmlStr);
		
		htmlStr = "";
		for (var i=0; registrableMenuList != null && i < registrableMenuList.length; i++){
			htmlStr += "<option value='"+registrableMenuList[i].menu_code+"'>"+registrableMenuList[i].menu_nm+"</option>";
		}
		
		$("#otherMenuList").html(htmlStr);
	}
	
	function drawProgList(){
		
		console.log(registeredProgList);
		console.log(registrableProgList);
		
		var htmlStr = "";
		for (var i=0; registeredProgList != null && i < registeredProgList.length; i++){
			htmlStr += "<option value='"+registeredProgList[i].prog_code+"'>"+registeredProgList[i].prog_name+"</option>";
		}
		
		$("#selectedProgList").html(htmlStr);
		
		htmlStr = "";
		for (var i=0; registrableProgList != null && i < registrableProgList.length; i++){
			htmlStr += "<option value='"+registrableProgList[i].prog_code+"'>"+registrableProgList[i].prog_name+"</option>";
		}
		
		$("#otherProgList").html(htmlStr);
	}
	
	function drawUserList(){
		
		console.log(registeredUserList);
		console.log(registrableUserList);
		
		var htmlStr = "";
		for (var i=0; registeredUserList != null && i < registeredUserList.length; i++){
			htmlStr += "<option value='"+registeredUserList[i].emp_no+"'>"+registeredUserList[i].emp_nm+"</option>";
		}
		
		$("#selectedUserList").html(htmlStr);
		
		htmlStr = "";
		for (var i=0; registrableUserList != null && i < registrableUserList.length; i++){
			htmlStr += "<option value='"+registrableUserList[i].emp_no+"'>"+registrableUserList[i].emp_nm+"</option>";
		}
		
		$("#otherUserList").html(htmlStr);
	}
	
	function menuRemove(){
		if (registeredMenuList == null || registrableMenuList == null) return;
		
		$("#selectedMenuList option:selected").each(function(idx){
			var obj = getMenuData(registeredMenuList, $(this).val());
			registrableMenuList.push(obj);
			removeMenuData(registeredMenuList,obj.menu_code);
		});
		
		drawMenuList();
	}
	
	function menuRemoveAll(){
		if (registeredMenuList == null || registrableMenuList == null) return;
		
		$("#selectedMenuList option").each(function(idx){
			var obj = getMenuData(registeredMenuList, $(this).val());
			registrableMenuList.push(obj);
			removeMenuData(registeredMenuList,obj.menu_code);
		});
		
		drawMenuList();
	}
	
	function menuAdd(){
		if (registeredMenuList == null || registrableMenuList == null) return;
		
		$("#otherMenuList option:selected").each(function(idx){
			var obj = getMenuData(registrableMenuList, $(this).val());
			registeredMenuList.push(obj);
			removeMenuData(registrableMenuList,obj.menu_code);
		});
		
		drawMenuList();
	}
	
	function menuAddAll(){
		if (registeredMenuList == null || registrableMenuList == null) return;
		
		$("#otherMenuList option").each(function(idx){
			var obj = getMenuData(registrableMenuList, $(this).val());
			registeredMenuList.push(obj);
			removeMenuData(registrableMenuList,obj.menu_code);
		});
		
		drawMenuList();
	}
	
	function getMenuData(objList, menuCode){
		for (var i=0; objList != null && i < objList.length; i++){
			if (objList[i].menu_code == menuCode) return objList[i];
		}
		return null;
	}
	
	function removeMenuData(objList, menuCode){
		var i = 0;
		for (i=0; objList !=null && i < objList.length; i++ ){
			if (objList[i].menu_code == menuCode){
				break;
			}
		}
		objList.splice(i,1);
	}
	
	function progRemove(){
		if (registeredProgList == null || registrableProgList == null) return;
		
		$("#selectedProgList option:selected").each(function(idx){
			var obj = getProgData(registeredProgList, $(this).val());
			registrableProgList.push(obj);
			removeProgData(registeredProgList,obj.prog_code);
		});
		
		drawProgList();
	}
	
	function progRemoveAll(){
		if (registeredProgList == null || registrableProgList == null) return;
		
		$("#selectedProgList option").each(function(idx){
			var obj = getProgData(registeredProgList, $(this).val());
			registrableProgList.push(obj);
			removeProgData(registeredProgList,obj.prog_code);
		});
		
		drawProgList();
	}
	
	function progAdd(){
		if (registeredProgList == null || registrableProgList == null) return;
		
		$("#otherProgList option:selected").each(function(idx){
			var obj = getProgData(registrableProgList, $(this).val());
			registeredProgList.push(obj);
			removeProgData(registrableProgList,obj.prog_code);
		});
		
		drawProgList();
	}
	
	function progAddAll(){
		if (registeredProgList == null || registrableProgList == null) return;
		
		$("#otherProgList option").each(function(idx){
			var obj = getProgData(registrableProgList, $(this).val());
			registeredProgList.push(obj);
			removeProgData(registrableProgList,obj.prog_code);
		});
		
		drawProgList();
	}
	
	function getProgData(objList, progCode){
		for (var i=0; objList != null && i < objList.length; i++){
			if (objList[i].prog_code == progCode) return objList[i];
		}
		return null;
	}
	
	function removeProgData(objList, progCode){
		var i = 0;
		for (i=0; objList !=null && i < objList.length; i++ ){
			if (objList[i].prog_code == progCode){
				break;
			}
		}
		objList.splice(i,1);
	}
	
	
	function userRemove(){
		if (registeredUserList == null || registrableUserList == null) return;
		
		$("#selectedUserList option:selected").each(function(idx){
			var obj = getUserData(registeredUserList, $(this).val());
			registrableUserList.push(obj);
			removeUserData(registeredUserList,obj.emp_no);
		});
		
		drawUserList();
	}
	
	function userRemoveAll(){
		if (registeredUserList == null || registrableUserList == null) return;
		
		$("#selectedUserList option").each(function(idx){
			var obj = getUserData(registeredUserList, $(this).val());
			registrableUserList.push(obj);
			removeUserData(registeredUserList,obj.emp_no);
		});
		
		drawUserList();
	}
	
	function userAdd(){
		if (registeredUserList == null || registrableUserList == null) return;
		
		$("#otherUserList option:selected").each(function(idx){
			var obj = getUserData(registrableUserList, $(this).val());
			registeredUserList.push(obj);
			removeUserData(registrableUserList,obj.emp_no);
		});
		
		drawUserList();
	}
	
	function userAddAll(){
		if (registeredUserList == null || registrableUserList == null) return;
		
		$("#otherUserList option").each(function(idx){
			var obj = getUserData(registrableUserList, $(this).val());
			registeredUserList.push(obj);
			removeUserData(registrableUserList,obj.emp_no);
		});
		
		drawUserList();
	}
	
	function getUserData(objList, empNo){
		for (var i=0; objList != null && i < objList.length; i++){
			if (objList[i].emp_no == empNo) return objList[i];
		}
		return null;
	}
	
	function removeUserData(objList, empNo){
		var i = 0;
		for (i=0; objList !=null && i < objList.length; i++ ){
			if (objList[i].emp_no == empNo){
				break;
			}
		}
		objList.splice(i,1);
	}
	
	function roleProc(obj,type){
		
		var roleCode = "";
		var roleName = "";
		
		$(obj).closest("tr").children().each(function(idx){
			if (idx == 0) roleCode = $(this).text();
			if (idx == 1) roleName = $(this).children("input[name='roleName']").val();
		});
		
		var data = {'role_code' : roleCode, 'role_name' : roleName}
		common.ajaxCall(data,"/ad/system/roleProc.do?type=" + type,"roleProcReturn");
	}
	
	function roleProcReturn(data){
		
		console.log(data);
		
		var resultCode = data.resultCode == 'undefined' ? null : data.resultCode;
		var resultMsg = data.resultMsg == 'undefined' ? null : data.resultMsg;
		var resultType = data.resultType == 'undefined' ? null : data.resultType;
		var vo = data.vo == 'undefined' ? null : data.vo;
		
		if (resultCode == null || resultMsg == null) {
			alert('결과 코드가 없습니다.');
			return;
		}
		alert(data.resultMsg);
		resetData(vo,resultType);
	}
	
	function resetData(vo,type){

		if (type == 'update'){
			for (var i=0; roleList !=null && i < roleList.length; i++ ){
				if (roleList[i].role_code == vo.role_code){
					roleList[i].role_name = vo.role_name;
					break;
				}
			}
		}else if (type == 'delete'){
			var i = 0;
			for (i=0; roleList !=null && i < roleList.length; i++ ){
				if (roleList[i].role_code == vo.role_code){
					break;
				}
			}
			
			roleList.splice(i,1);
		}else if (type = 'insert'){
			roleList.push(vo);
		}
		
		
		drawRoleListBody();
	}
	
	function roleRegist(){
		var data = $("form[name=roleRegistForm]").serialize();
		common.ajaxCall(data,"/ad/system/roleProc.do?type=insert","roleProcReturn");
	}
	
	
	function registRoleMenu(){
		if (!confirm('저장하시겠습니까?')) return;
		
		if (registeredMenuList == null || selectedRoleCode == null){
			alert("권한을 선택 후 작업 하세요.");
		}
		
		var menuCodeList = "";
		
		for (var i=0; i < registeredMenuList.length; i++){
			menuCodeList += "," + registeredMenuList[i].menu_code;
		}
		
		$("form[name=registRoleMenuForm] input[name=roleCode]").val(selectedRoleCode);
		$("form[name=registRoleMenuForm] input[name=menuCodeList]").val(menuCodeList.substring(1));
		
		var data = $("form[name=registRoleMenuForm]").serialize();
		
		common.ajaxCall(data,"/ad/system/setManageRoleList.do","registRoleMenuReturn");
	}
	
	function registRoleMenuReturn(data){
		console.log(data);
		
		var resultCode = data.resultCode == 'undefined' ? null : data.resultCode;
		var resultMsg = data.resultMsg == 'undefined' ? null : data.resultMsg;
		var resultType = data.resultType == 'undefined' ? null : data.resultType;
		var roleCode = data.roleCode == 'undefined' ? null : data.roleCode;
		
		if (resultCode == null || resultMsg == null) {
			alert('결과 코드가 없습니다.');
			return;
		}
		alert(data.resultMsg);

		common.ajaxCall({'role_code' : roleCode},"/ad/system/getManageRoleList.do","setManageRoleList");
	}
	
	
	function registRoleProg(){
		if (!confirm('저장하시겠습니까?')) return;
		
		if (registeredProgList == null || selectedRoleCode == null){
			alert("권한을 선택 후 작업 하세요.");
		}
				
		var progCodeList = "";
		
		for (var i=0; i < registeredProgList.length; i++){
			progCodeList += "," + registeredProgList[i].prog_code;
		}
		
		$("form[name=registRoleProgForm] input[name=roleCode]").val(selectedRoleCode);
		$("form[name=registRoleProgForm] input[name=progCodeList]").val(progCodeList.substring(1));
		
		var data = $("form[name=registRoleProgForm]").serialize();
		
		common.ajaxCall(data,"/ad/system/setManageRoleProgList.do","registRoleProgReturn");
	}
	
	function registRoleProgReturn(data){
		console.log(data);
		
		var resultCode = data.resultCode == 'undefined' ? null : data.resultCode;
		var resultMsg = data.resultMsg == 'undefined' ? null : data.resultMsg;
		var resultType = data.resultType == 'undefined' ? null : data.resultType;
		var roleCode = data.roleCode == 'undefined' ? null : data.roleCode;
		
		if (resultCode == null || resultMsg == null) {
			alert('결과 코드가 없습니다.');
			return;
		}
		alert(data.resultMsg);

		common.ajaxCall({'role_code' : roleCode},"/ad/system/getManageRoleList.do","setManageRoleList");
	}
	
	function registRoleUser(){
		if (!confirm('저장하시겠습니까?')) return;
		
		if (registeredUserList == null || selectedRoleCode == null){
			alert("권한을 선택 후 작업 하세요.");
		}
		
		var userCodeList = "";
		
		for (var i=0; i < registeredUserList.length; i++){
			userCodeList += "," + registeredUserList[i].emp_no;
		}
		
		$("form[name=registRoleUserForm] input[name=roleCode]").val(selectedRoleCode);
		$("form[name=registRoleUserForm] input[name=userCodeList]").val(userCodeList.substring(1));
		
		var data = $("form[name=registRoleUserForm]").serialize();
		
		common.ajaxCall(data,"/ad/system/setManageRoleUserList.do","registRoleUserReturn");
	}
	
	function registRoleUserReturn(data){
		console.log(data);
		
		var resultCode = data.resultCode == 'undefined' ? null : data.resultCode;
		var resultMsg = data.resultMsg == 'undefined' ? null : data.resultMsg;
		var resultType = data.resultType == 'undefined' ? null : data.resultType;
		var roleCode = data.roleCode == 'undefined' ? null : data.roleCode;
		
		if (resultCode == null || resultMsg == null) {
			alert('결과 코드가 없습니다.');
			return;
		}
		alert(data.resultMsg);

		common.ajaxCall({'role_code' : roleCode},"/ad/system/getManageRoleList.do","setManageRoleList");
	}
	
</script>

<div class="tit_wrap">
	<%= CommonExecute.returnLineMap(request) %>
</div>
<div>
	<h4>등록 / 수정</h4>
</div>
<form name="roleRegistForm">
<table class="sType mgb10">
	<caption>권한 등록</caption>
	<colgroup>
		<col style="width:100px">
		<col style="width:*">
		<col style="width:100px">
		<col style="width:*">
    </colgroup>
	<tbody>
		<tr>
			<th>권한코드</th>
			<td><input type="text" name="role_code"/></td>
			<th>권한명</th>
			<td><input type="text" name="role_name"/></td>
		</tr>
	</tbody>
</table>
<div class="floatR"><input type="button" value="등록" onclick="roleRegist()"/></div>
<br />
<br />
</form>
<table class="sType mgb10">
	<caption>프로그램 리스트</caption>
	<colgroup>
		
    </colgroup>
	<thead id="tHeader">
		<tr>
			<th>권한코드</th>
			<th>권한명</th>
			<th>기능</th>
		</tr>
	</thead>
	<tbody id="roleListBody">
	</tbody>
</table>

<div>
	<h4>권한 메뉴 맵핑 :: <span class="selectedRoleName">위 목록에서 선택하세요</span></h4>
</div>
<form id="registRoleMenuForm" name="registRoleMenuForm">
<input type="hidden" name="roleCode">
<input type="hidden" name="menuCodeList">
</form>
<table class="sType mgb10">
	<caption>권한 등록</caption>
	<colgroup>
		<col style="width:45%; text-align:center">
		<col style="width:10%; text-align:center">
		<col style="width:45%; text-align:center">
    </colgroup>
    <thead>
    	<tr>
			<th style="text-align:center">등록된 메뉴</th>
			<th>&nbsp;</th>
			<th style="text-align:center">등록가능 메뉴</th>
		</tr>
    </thead>
	<tbody>
		<tr>
			<td>
				<select multiple="multiple" style="height:300px" id="selectedMenuList">
				</select>
			</td>
			<td style="width:10%; text-align:center">
				<input type="button" value=">" style="width:30px;margin-top:3px" onclick="menuRemove()"/><br/>
				<input type="button" value=">>" style="width:30px;margin-top:3px" onclick="menuRemoveAll()" /><br/>
				<input type="button" value="<" style="width:30px;margin-top:3px" onclick="menuAdd()" /><br/>
				<input type="button" value="<<" style="width:30px;margin-top:3px" onclick="menuAddAll()" /><br/>
			</td>
			<td>
				<select multiple="multiple" style="height:300px" id="otherMenuList">
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="3" style="text-align:right">
				<input type="button" value="저장" onclick="registRoleMenu()"/>
			</td>
		</tr>
	</tbody>
</table>

<div>
	<h4>권한 프로그램 맵핑 :: <span class="selectedRoleName">위 목록에서 선택하세요</span></h4>
</div>
<form id="registRoleProgForm" name="registRoleProgForm">
<input type="hidden" name="roleCode">
<input type="hidden" name="progCodeList">
</form>
<table class="sType mgb10">
	<caption>권한 등록</caption>
	<colgroup>
		<col style="width:45%; text-align:center">
		<col style="width:10%; text-align:center">
		<col style="width:45%; text-align:center">
    </colgroup>
    <thead>
    	<tr>
			<th style="text-align:center">등록된 프로그램</th>
			<th>&nbsp;</th>
			<th style="text-align:center">등록가능 프로그램</th>
		</tr>
    </thead>
	<tbody>
		<tr>
			<td>
				<select multiple="multiple" style="height:300px" id="selectedProgList">
				</select>
			</td>
			<td style="width:10%; text-align:center">
				<input type="button" value=">" style="width:30px;margin-top:3px" onclick="progRemove()"/><br/>
				<input type="button" value=">>" style="width:30px;margin-top:3px" onclick="progRemoveAll()" /><br/>
				<input type="button" value="<" style="width:30px;margin-top:3px" onclick="progAdd()" /><br/>
				<input type="button" value="<<" style="width:30px;margin-top:3px" onclick="progAddAll()" /><br/>
			</td>
			<td>
				<select multiple="multiple" style="height:300px" id="otherProgList">
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="3" style="text-align:right">
				<input type="button" value="저장" onclick="registRoleProg()"/>
			</td>
		</tr>
	</tbody>
</table>

<div>
	<h4>권한 사용자 맵핑 :: <span class="selectedRoleName">위 목록에서 선택하세요</span></h4>
</div>
<form id="registRoleUserForm" name="registRoleUserForm">
<input type="hidden" name="roleCode">
<input type="hidden" name="userCodeList">
</form>
<table class="sType mgb10">
	<caption>권한 등록</caption>
	<colgroup>
		<col style="width:45%; text-align:center">
		<col style="width:10%; text-align:center">
		<col style="width:45%; text-align:center">
    </colgroup>
    <thead>
    	<tr>
			<th style="text-align:center">등록된 사용자</th>
			<th>&nbsp;</th>
			<th style="text-align:center">등록가능 사용자</th>
		</tr>
    </thead>
	<tbody>
		<tr>
			<td>
				<select multiple="multiple" style="height:300px" id="selectedUserList">
				</select>
			</td>
			<td style="width:10%; text-align:center">
				<input type="button" value=">" style="width:30px;margin-top:3px" onclick="userRemove()"/><br/>
				<input type="button" value=">>" style="width:30px;margin-top:3px" onclick="userRemoveAll()" /><br/>
				<input type="button" value="<" style="width:30px;margin-top:3px" onclick="userAdd()" /><br/>
				<input type="button" value="<<" style="width:30px;margin-top:3px" onclick="userAddAll()" /><br/>
			</td>
			<td>
				<select multiple="multiple" style="height:300px" id="otherUserList">
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="3" style="text-align:right">
				<input type="button" value="저장" onclick="registRoleUser()"/>
			</td>
		</tr>
	</tbody>
</table>