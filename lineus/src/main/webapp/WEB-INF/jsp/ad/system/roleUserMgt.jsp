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
		common.ajaxCall('', '/ad/system/getUserList.do', 'setUserList');
	});
	
	var userList = null;
	function setUserList(datas){
		userList = datas.resultList == 'undefined' ? null : datas.resultList;
		console.log(userList);
 		drawUserListBody();
	}
	
	function drawUserListBody(){
		if (userList == null) return;
		var htmlStr = "";
		for (var i=0; i < userList.length; i++){
			
		}
		$("#userListBody").html(htmlStr);
	}
	
	function getEmpNmByCode(empNo){
		for (var i=0; userList != null && i < userList.length; i++){
			if (userList[i].emp_no == empNo) return userList[i].emp_nm;
		}
		return "";
	}
	
	function selectRoleCode(obj){
		
		var empNo = $(obj).text();
		
		// 선택시 백그라운드 컬러 셋팅
		$(obj).closest("tr").closest("tbody").children().each(function(idx){
			$(this).removeClass("selected");
		});
		
		$(obj).closest("tr").addClass("selected");
		
		// 선택된 코드 하단에 보여주기
		$(".selectedUserName").text(getEmpNmByCode(empNo));
		
		var data = {'emp_no' : empNo}
		common.ajaxCall(data,"/ad/system/getUserRoleList.do","setUserRoleList");
	}
	
	var registeredRoleList;
	var registrableRoleList;
	var selectedEmpNo;
	
	function setUserRoleList(data){
		registeredRoleList = data.registeredRoleList == 'undefined' ? null : data.registeredRoleList;
		registrableRoleList = data.registrableRoleList == 'undefined' ? null : data.registrableRoleList;
		
		var vo = data.vo == 'undefined' ? null : data.vo;
		
		if (registeredMenuList == null || registrableMenuList == null || 
				vo == null){
			
			registeredMenuList = null;
			registrableMenuList = null;
			
			selectedEmpNo = null;
			vo = null;
			return;
		}
		
		selectedRoleCode = vo.role_code;
		
		drawRoleList();
	}
	
	function drawRoleList(){
		console.log(registeredRoleList);
		console.log(registrableRoleList);
		
		var htmlStr = "";
		for (var i=0; registeredRoleList != null && i < registeredRoleList.length; i++){
			htmlStr += "<option value='"+registeredRoleList[i].role_code+"'>"+registeredRoleList[i].role_name+"</option>";
		}
		
		$("#selectedRoleList").html(htmlStr);
		
		htmlStr = "";
		for (var i=0; registrableRoleList != null && i < registrableRoleList.length; i++){
			htmlStr += "<option value='"+registrableRoleList[i].role_code+"'>"+registrableRoleList[i].role_name+"</option>";
		}
		
		$("#otherRoleList").html(htmlStr);
	}
	
	
	function roleRemove(){
		if (registeredRoleList == null || registrableRoleList == null) return;
		
		$("#selectedRoleList option:selected").each(function(idx){
			var obj = getRoleData(registeredRoleList, $(this).val());
			registrableRoleList.push(obj);
			removeRoleData(registeredRoleList,obj.role_code);
		});
		
		drawRoleList();
	}
	
	function roleRemoveAll(){
		if (registeredRoleList == null || registrableRoleList == null) return;
		
		$("#selectedRoleList option").each(function(idx){
			var obj = getRoleData(registeredRoleList, $(this).val());
			registrableRoleList.push(obj);
			removeRoleData(registeredRoleList,obj.role_code);
		});
		
		drawRoleList();
	}
	
	function roleAdd(){
		if (registeredRoleList == null || registrableRoleList == null) return;
		
		$("#otherRoleList option:selected").each(function(idx){
			var obj = getRoleData(registrableRoleList, $(this).val());
			registeredRoleList.push(obj);
			removeRoleData(registrableRoleList,obj.role_code);
		});
		
		drawRoleList();
	}
	
	function roleAddAll(){
		if (registeredRoleList == null || registrableRoleList == null) return;
		
		$("#otherRoleList option").each(function(idx){
			var obj = getRoleData(registrableRoleList, $(this).val());
			registeredRoleList.push(obj);
			removeRoleData(registrableRoleList,obj.role_code);
		});
		
		drawRoleList();
	}
	
	function getRoleData(objList, roleCode){
		for (var i=0; objList != null && i < objList.length; i++){
			if (objList[i].role_code == roleCode) return objList[i];
		}
		return null;
	}
	
	function removeRoleData(objList, roleCode){
		var i = 0;
		for (i=0; objList !=null && i < objList.length; i++ ){
			if (objList[i].role_code == roleCode){
				break;
			}
		}
		objList.splice(i,1);
	}
	
		
	function registUserRole(){
		if (!confirm('저장하시겠습니까?')) return;
		
		if (registeredRoleList == null || selectedEmpNo == null){
			alert("권한을 선택 후 작업 하세요.");
		}
		
		var roleCodeList = "";
		
		for (var i=0; i < registeredRoleList.length; i++){
			roleCodeList += "," + registeredRoleList[i].role_code;
		}
		
		$("form[name=registUserRoleForm] input[name=empNo]").val(selectedEmpNo);
		$("form[name=registUserRoleForm] input[name=roleCodeList]").val(roleCodeList.substring(1));
		
		var data = $("form[name=registRoleUserForm]").serialize();
		
		common.ajaxCall(data,"/ad/system/registUserRole.do","registUserRoleReturn");
	}
	
	function registUserRoleReturn(data){
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
	<h4>직원목록</h4>
</div>
<table class="sType mgb10">
	<caption>직원 리스트</caption>
	<colgroup>
		
    </colgroup>
	<thead id="tHeader">
		<tr>
			<th>권한코드</th>
			<th>권한명</th>
			<th>기능</th>
		</tr>
	</thead>
	<tbody id="userListBody">
	</tbody>
</table>

<div>
	<h4>사용자 권한 맵핑 :: <span class="selectedUserName">위 목록에서 선택하세요</span></h4>
</div>
<form id="registUserRoleForm" name="registUserRoleForm">
<input type="hidden" name="empNO">
<input type="hidden" name="roleCodeList">
</form>
<table class="sType mgb10">
	<colgroup>
		<col style="width:45%; text-align:center">
		<col style="width:10%; text-align:center">
		<col style="width:45%; text-align:center">
    </colgroup>
    <thead>
    	<tr>
			<th style="text-align:center">등록된 권한</th>
			<th>&nbsp;</th>
			<th style="text-align:center">등록가능 권한</th>
		</tr>
    </thead>
	<tbody>
		<tr>
			<td>
				<select multiple="multiple" style="height:300px" id="selectedRoleList">
				</select>
			</td>
			<td style="width:10%; text-align:center">
				<input type="button" value=">" style="width:30px;margin-top:3px" onclick="roleRemove()"/><br/>
				<input type="button" value=">>" style="width:30px;margin-top:3px" onclick="roleRemoveAll()" /><br/>
				<input type="button" value="<" style="width:30px;margin-top:3px" onclick="roleAdd()" /><br/>
				<input type="button" value="<<" style="width:30px;margin-top:3px" onclick="roleAddAll()" /><br/>
			</td>
			<td>
				<select multiple="multiple" style="height:300px" id="otherRoleList">
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="3" style="text-align:right">
				<input type="button" value="저장" onclick="registUserRole()"/>
			</td>
		</tr>
	</tbody>
</table>
