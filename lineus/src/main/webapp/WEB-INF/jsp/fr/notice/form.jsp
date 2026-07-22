<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<style>
	#tbAnswerList {
		display: block;
		width: 100%
	}
	
	#tbAnswerList thead{
		display: inline-block;
		width: 100%;
		height: auto;
	}
	
	#tbAnswerList tbody{
		overflow:  auto;
    	max-height: 800px;
    	display: inline-block;
	}
	
	#tbAnswerList thead th:nth-of-type(1){width: 71px;}
	#tbAnswerList tbody td:nth-of-type(1){width: 80px;}
	
	#tbAnswerList thead th:nth-of-type(2){width: 132px;}
	#tbAnswerList tbody td:nth-of-type(2){width: 150px;}
	
	#tbAnswerList thead th:nth-of-type(3){width: 92px;}
	#tbAnswerList tbody td:nth-of-type(3){width: 100px;}
	
	#tbAnswerList thead th:nth-of-type(4){width: 474px;} 
	#tbAnswerList tbody td:nth-of-type(4){width: 450px;}
	
	#tbAnswerList thead th:nth-of-type(5){width: 135px;} 
	#tbAnswerList tbody td:nth-of-type(5){width: 150px;}
	
	#tbAnswerList tbody td:nth-of-type(6){width: 100px;}
	#tbAnswerList thead th:nth-of-type(6){width: 100px;},
	
</style>


<script type="text/javascript">
	
	$(document).ready(function(){
		$("#tbDwHist").hide();
		initView();
		var fruser_emp_id ='';
		var attachHistList ='';
		
	});
	
	function initView() {
		var f = document.frmNotice ; 
		$('#tabAnswer').hide();
		
		$.ajax({
			type : 'post' ,
			url : '/fr/notice/getBoardInfo.do' , 
			data : $('form[name=frmNotice]').serialize() ,
			dataType : 'json' , 
			error : function(xhr , status , error){
				if(common.nvl(error, "") != "") alert(error);
			} , 
			success : function(data){
				
				var str ='';
				var resultVO = data.resultVO != "undefined" ? data.resultVO : null ;
				fruser_emp_id = data.vo.emp_id; 
				
				
				if(resultVO != null){
					var info = resultVO.info != "undefined" ? resultVO.info : null ; 
					var attachList = resultVO.attachList != "undefined" ? resultVO.attachList : null ; 
					attachHistList = resultVO.attachHistList != "undefined" ? resultVO.attachHistList : null ;
					
					if (info != null){
						$('#noticeNum').html(common.nvl(info.notice_num,''));
						$('#title').html(common.nvl(info.title,''));
						$('#content').html(common.nvl(info.content,''));
						$('#content span').css({'line-height' : '1em'});
						$('#cnt').html(common.nvl(info.cnt,''));
						$('#reg_date').html(common.nvl(info.reg_date,''));
						
						
						// 업무유형 데이터 처리
						var tmpStr = common.nvl(info.work_type_nm, '');
						if (common.nvl(info.work_type2_nm, '') != ''){
							tmpStr += ' > ' + common.nvl(info.work_type2_nm, '');  
						}
						$('#workType').html(tmpStr);
						// 업무유형 데이터 처리
						
						$("#btnPrevNext").empty();
						var btnPrevNext = '';
						var prev_seq = info.prev_seq;
						var next_seq = info.next_seq;
						/* if (prev_seq != '0') btnPrevNext += '<button type="button" class="btn_ico_before" onclick="goPrevNext(\'prev\',\''+prev_seq+'\')"><span>이전 글</span></button>';
						if (next_seq != '0') btnPrevNext += '<button type="button" class="btn_ico_next" onclick="goPrevNext(\'next\',\''+next_seq+'\')"><span>다음 글</span></button>';
						$("#btnPrevNext").html(btnPrevNext); */
					}
					if (attachList != null && attachList.length > 0) {
						var fileStr = '' ; 
						for(var i = 0 ; i < attachList.length ; i++){
							var datas = attachList[i];
							fileStr += '<tr id="file'+datas.attach_ord+'" style="margin-top:5px;">';
							fileStr += '	<th scope="row">첨부파일. '+(i+1)+'</th>';
							fileStr += '	<td><a href="javascript:fileDown(\''+datas.attach_seq+'\' , \''+datas.attach_ord+'\');">'+datas.attach_ori_nm+'</a></td>';
							fileStr += '</tr>';
						}
						
						$('#formWrap').append(fileStr) ; 
					}
					
					changeNoticeData('noticeTab1');
					chLimitCount();
					
				}
			}
		}) ; 	
	}
	
	function chLimitCount(){
		
		$('#w_content').keyup(function (e){
	        var content = $(this).val();
	        if(content.length >= 800){
	      	  content = content.substring(0 , 800) ;
	      	  $(this).val(content)
	        }
	        
	        $('#w_content_text').html(content.length + '/ 800 자');
	        
	   });
	}
	
	function changeNoticeData(gubun){
		//////////////다운로드 이력//////////////////
		if(gubun == 'noticeTab1'){
			$("#noticeTab2").removeClass("active");
			$("#" + gubun).addClass("active");
			$('#tabAnswer').hide();
			
			if (attachHistList != null && attachHistList.length > 0) {
				var histStr = "";
				for (var i=0; i < attachHistList.length; i++){
					histStr += "<tr>";
					histStr += "	<td>"+(i+1)+"</td>";
					histStr += "	<td>"+attachHistList[i].cust_kor_name+"</td>";
					histStr += "	<td>"+attachHistList[i].emp_nm+"</td>";
					histStr += "	<td>"+attachHistList[i].attach_ori_nm+"</td>";
					histStr += "	<td>"+attachHistList[i].reg_dt+"</td>";
					histStr += "</tr>";
				}
				$("#dwHistRow").html(histStr);
				$("#tbDwHist").show();
			}
		
		}
		////////////////////댓글///////////////////////////
		if(gubun == 'noticeTab2'){
			$("#tbDwHist").hide();
			$('#tabAnswer').show();
			$("#noticeTab1").removeClass("active");
			$("#" + gubun).addClass("active");
			var datas = {'notice_seq' : '${ vo.seq }' } ; 
			common.ajaxCall(datas , '/fr/board/getAwsList.do', 'getNoticeAnswer') ;
		}
		
	}//changeNoticeData
	
	
	function getNoticeAnswer(data){
		
		$("#answerRow").empty();
		var resultVO = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		if(resultVO != null && resultVO.lenght !=0){
			var AswStr ='';
			for(var i=0; i < resultVO.length; i++){
				AswStr += "<tr>";
				AswStr += "	<td>"+ (i+1) +"</td>";
				if(resultVO[i].w_gubun == 'U'){ AswStr += "<td>" +resultVO[i].w_cust_nm+"</td>";
				}else if(resultVO[i].w_gubun == 'A'){AswStr += "<td>관리자</td>";}
				
				AswStr += "	<td>"+resultVO[i].w_nm+"</td>";
				AswStr += "	<td class='textL'>"+resultVO[i].w_content+"</td>";
				AswStr += "	<td>"+resultVO[i].w_date+"</td>";
				
				if(resultVO[i].w_id == "${ frUserInfo.emp_id}"){
					AswStr += " <td onclick='event.cancelBubble=true;'><button type='button' class='btn_line_blue' onclick='javascript:deleteAnswer(" + resultVO[i].seq + ")';><span>삭제</span></button></td>";
				}else{ AswStr += " <td></td> ";}
				AswStr += "<tr>";
			}
			$('#tbAnswerList').show();
			$("#answerRow").html(AswStr);
		}
		if(data.resultList.length == 0){
			$('#tbAnswerList').hide();
		}
	}
	
	
	
	function aswForm(){
		
		if(!confirm('문의내용을 등록하시겠습니까?')) return ;
		var f = document.frmNotice;
		f.w_content.value = $('#w_content').val();
		f.notice_seq.value = '${ vo.seq }';
		common.ajaxCall($('form[name=frmNotice]').serialize(), '/fr/board/awsform.do', 'registResult') ;
		
	}

	function registResult(data){
		
		var msg = "처리도중 오류가 발생했습니다." ; 
		var returnCode = typeof data.returnCode != "undefined" ? data.returnCode : "888" ; 
		if(returnCode == "000") msg = "정상처리 되었습니다." ;
		alert(msg) ; 
		if(returnCode == "000") {$('#w_content').val(''); $('#w_content_text').html('0/ 800 자'); changeNoticeData('noticeTab2')}
	}
	
	
	function deleteAnswer(data){
		
		if(!confirm('문의내용을 삭제하시겠습니까?')) return ;
		
		var f = document.frmNotice;
		f.seq.value = data;
		common.ajaxCall($('form[name=frmNotice]').serialize(), '/fr/board/awsDel.do', 'registResult') ;
		
	}
	
	function listGo() {
		var f = document.frmNotice;
		f.method="post";
		f.target = "";
		f.action="/fr/notice/list.do";
		f.submit();
	}
	
	function goPrevNext (type, seq) {
		var f = document.frmNotice;
		f.seq.value = seq;
		if (type=='prev') f.listNum.value = parseInt($('#listNum').val()) - 1;
		else f.listNum.value = parseInt($('#listNum').val()) + 1;
		f.action = '/fr/notice/form.do';
		f.method = 'post';
		f.submit();
	}
</script>
<form id="frmNotice" name="frmNotice" method="post" enctype="multipart/form-data">
<input type="hidden" name="pageType" id="pageType" value="${ vo.pageType }" />
<input type="hidden" name="page" id="page" value="${ vo.page }" />
<input type="hidden" name="board_gbn" id="board_gbn" value="0000" />
<input type="hidden" name="seq" id="seq" value="${ vo.seq }" />
<input type="hidden" name="notice_seq" id="notice_seq" value="${ vo.seq }" />
<input type="hidden" name="listNum" id="listNum" value="${ vo.listNum }" />
<input type="hidden" name="search_text" id="search_text" value="${ vo.search_text }" />

<!-- contents -->
<div id="jw_contents">
	<div class="tit_wrap">
		<h2 class="tit_ico_notice">공지사항<span class="txt_tit_right">중요하고 새로운 소식을 확인하세요.</span></h2>
		<div class="location">
			<a href="/fr/main/list.do" class="home">Home</a>
			<a href="/fr/notice/list.do" class="depth"><span class="here">공지사항</span></a>
		</div>
	</div>
	<!-- view -->
	<table class="vType_line mgb20">
		<caption>공지사항 상세정보</caption>
		<colgroup>
			<col style="width:140px;">
			<col style="width:auto;">
		</colgroup>
		<tbody id="formWrap">
			<tr>
				<th scope="row">No.</th>
				<td id="noticeNum"></td>
			</tr>
			<tr>
				<th scope="row">등록일</th>
				<td id="reg_date"></td>
			</tr>
			<tr>
				<th scope="row">작성자</th>
				<td>관리자</td>
			</tr>				
			<tr>
				<th scope="row">조회수</th>
				<td id="cnt"></td>
			</tr>
			<tr>
				<th scope="row">업무유형</th>
				<td id="workType"></td>
			</tr>
			<tr>
				<th scope="row">제목</th>
				<td id="title"></td>
			</tr>
			<tr>
				<td colspan="2" id="content" class="view_content"></td>
			</tr>
		</tbody>
	</table>
	<!--// view -->
	<ul class="tab_line big list3" >
		<li id="noticeTab1" style="width:50% !important;" class="active">
			<a href="javascript:changeNoticeData('noticeTab1')">다운로드 이력</a>
		</li>
		<li id="noticeTab2"  style="width:50% !important;">
			<a href="javascript:changeNoticeData('noticeTab2')">문의내용</a>
		</li>
	</ul>
	<table class="hType mgb20" id="tbDwHist">
		<caption>다운로드 이력</caption>
		<colgroup>
			<col style="width:140px;">
			<col style="width:auto;">
		</colgroup>
		<thead>
			<tr>
				<th scope="row">No.</th>
				<th scope="row">병원명</th>
				<th scope="row">사용자명</th>
				<th scope="row">파일명</th>
				<th scope="row">다운로드 일시</th>
			</tr>
		</thead>
		<tbody id="dwHistRow">
		</tbody>
	</table>
	<!--// 다운로드 이력 -->
	
	<!-- 문의내용 -->
	<div id="tabAnswer" style="display:none">
		<table class="hType mgb5" id="tbAnswer" >
			<caption>문의</caption>
			<colgroup>
				<col style="width:130px">
			</colgroup>
			<tbody>
				<tr>
					<th scope="col">문의내용</th>
					<td style="border:1px solid #dadada"><textarea name="w_content" id="w_content" class="lineH13 pd5"></textarea>
						<span id="w_content_text" class="here" style="float:right">0/ 800 자</span>
					</td>
					
				</tr>
				
			</tbody>
		</table>
		<div class="btn_wrap mgb5"  id="btnAnswer">
			<div class="floatR">
				<button type="button" class="btn_ico_regist" onclick="aswForm();"><span>작성</span></button>
			</div>
			<div class="floatR" id="btnPrevNext"></div>
		</div>
		<table class="hType mgb20" id="tbAnswerList" >
			<caption>문의내용</caption>
			 <thead>
				<tr>
					<th scope="row">No.</th>
					<th scope="row">병원명</th>
					<th scope="row">작성자</th>
					<th scope="row">내용</th>
					<th scope="row">작성일시</th>
					<th scope="row"></th>
				</tr>
			</thead>
			<tbody id="answerRow"></tbody>
		</table>
	</div>
	<div class="btn_wrap">
		<div class="floatL">
			<button type="button" class="btn_ico_list" onclick="listGo();"><span>목록</span></button>
		</div>
		<div class="floatR" id="btnPrevNext"></div>
	</div>
</div>
<!--// contents -->
</form>
