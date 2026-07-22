<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
var noticeList;

$.ajax({
	type : 'post' ,
	url : '/his/getNotice.do' , 
	dataType : 'json' , 
	error : function(xhr , status , error){
		if(common.nvl(error, "") != "") alert(error);
	} , 
	success : function(data){
		noticeList = data;
		initList();
	}
});

function viewContent(obj,seq){
	if (noticeList != "undefined" && noticeList.length > 0){
		var htmlTag = "";
		for (var i=0; i < noticeList.length; i++){
			if (seq == noticeList[i].seq){
				$("#noticeContent").html(noticeList[i].content);
			}
		}
		
	}
	
	$("#listBody tr").each(function(){$(this).css('background','');});
	$(obj).css('background','#c6e0e6');
}

function initList(){
	
	console.log(noticeList);
	
	if (noticeList != "undefined" && noticeList.length > 0){
		
		var htmlTag = "";
		
		for (var i=0; i < noticeList.length; i++){
			var data = noticeList[i];
			
			
			htmlTag += "<tr onclick=\"viewContent(this,'"+data.seq+"')\">";
			htmlTag += "	<td>"+data.notice_num+"</td>";
			htmlTag += "	<td>"+data.open_type_nm+"</td>";
			htmlTag += "	<td class=\"textL\">"+data.title+"</td>";
			htmlTag += "	<td>"+data.reg_date+"</td>";
			htmlTag += "	<td>"+data.emp_nm+"</td>";
			htmlTag += "	<td>";
			if (common.nvl(data.attach_seq, '') != 0 ) {
				htmlTag += "	<button type=\"button\" class=\"btn_download_blue\"><span>다운로드</span></button>";
			}else{
				htmlTag += "-";
			}
			htmlTag += "	</td>";
			htmlTag += "</tr>";
			
			
			// 업무유형 데이터 처리
			var tmpStr = common.nvl(data.work_type_nm, '');
			if (common.nvl(data.work_type2_nm, '') != ''){
				tmpStr += ' > ' + common.nvl(data.work_type2_nm, '');  
			}
		}
		
		$("#listBody").html(htmlTag);
	}
}

</script>
<body>
	
		<div class="layer_contents" style="height:100%; background-color: #f7f7f7;">
			<!--list-->
			
			<table class="hType">
				<colgroup>
					<col style="width:30px;">
					<col style="width:80px;">
					<col style="width:auto;">
					<col style="width:80px;">
					<col style="width:80px;">
					<col style="width:80px;">
					<col style="width:20px;">
				</colgroup>
				<thead>
					<tr>
						<th>No</th>
						<th>대상</th>
						<th>제목</th>
						<th>등록일자</th>
						<th>작성자</th>
						<th>첨부파일</th>
						<th></th>
					</tr>
				</thead>
			</table>
			<div class="db_borderbox h285" style="background:#ffffff; overflow-x:hidden; overflow-y:scroll;border:1px; height:60%!important;">
				<table class="hType" >
					<colgroup>
						<col style="width:30px;">
						<col style="width:80px;">
						<col style="width:auto;">
						<col style="width:80px;">
						<col style="width:80px;">
						<col style="width:80px;">
					</colgroup>
					<tbody id="listBody">
					</tbody>
				</table>
			</div>
			<div style="border-bottom: 2px solid #0090c8"></div>
			<!--// list-->
			<div class="db_borderbox" style="background:#ffffff; overflow-x:hidden; overflow:auto; border:1px; height:30%!important;">
			<table class="vType_line" style="border:0px !important">
				<caption>공지사항</caption>
				<colgroup>
					<col style="width:50px;">
					<col style="width:80px;">
					<col style="width:50px;">
					<col style="width:100px;">
					<col style="width:50px;">
					<col style="width:80px;">
				</colgroup>
				<tbody id="formWrap">
					<tr>
						<td colspan="6" class="view_content" id="noticeContent">
						</td>
					</tr>
					
				</tbody>
			</table>
			</div>
			<!--// write -->
		</div>

	
</body>