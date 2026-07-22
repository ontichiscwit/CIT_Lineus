<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/jsp/fr/common/chatbot.jsp" />

    <style>
        .heart {
            display: none; /* 기본 체크박스를 숨깁니다 */
        }

        .heart_label {
            display: inline-block;
            width: 20px;
            height: 20px;
            background: url('/images/heart-regular.svg') no-repeat 0 0; /* 기본 상태의 이미지 경로 */
            cursor: pointer;
        }

        .heart:checked + .heart_label {
            background: url('/images/heart-solid.svg') no-repeat 0 0; /* 체크된 상태의 이미지 경로 */
        }
        
        .center-align {
		    text-align: center; /* td 요소의 내용을 수평 가운데 정렬 */
		    vertical-align: middle; /* td 요소의 내용을 수직 가운데 정렬 */
		    display: flex;
		    justify-content: center;
		    align-items: center;
		}
		
		.heart-container {
		    display: flex;
		    flex-direction: column; /* 수직으로 배치 */
		    align-items: center; /* 가운데 정렬 */
		}
		
		.horizontal-line {
			border-bottom:1px solid #c9d7dc !important;
		}
    </style>

<script type="text/javascript">

	var chatbotWindow = null;

	$(document).ready(function(){	
		$("#tbDwHist").hide(); //(2024.05.23 김규민)다운로드 이력 관련 추가
		initView();
		var fruser_emp_id =''; //(2024.05.23 김규민)다운로드 이력 관련 추가
		var attachHistList =''; //(2024.05.23 김규민)다운로드 이력 관련 추가
	});
	
	function initView() {
		var f = document.frmNotice ;
		$('#tabAnswer').hide(); //(2024.05.23 김규민)문의내용 관련 추가
		$('#tabLike').hide(); //(2024.06.03 김규민)좋아요 관련 추가
		
		$.ajax({
			type : 'post' ,
			url : '/fr/board/getFaqBoardInfo.do' , 
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
						$('#title').html(common.nvl(info.title,''));
						$('#content').html(common.nvl(info.content,''));
						$('#content span').css({'line-height' : '1em'});
						$('#cnt').html(common.nvl(info.cnt,''));
						$('#reg_date').html( (common.nvl(info.reg_date,'')).substr(0,10) );
						
						/*window.location.hash = 'seq=' + common.nvl(info.seq,'');*/
						
						$("#btnPrevNext").empty();
						var btnPrevNext = '';
						var prev_seq = info.prev_seq;
						var next_seq = info.next_seq;
						if (prev_seq != '0') btnPrevNext += '<button type="button" class="btn_ico_before" onclick="goPrevNext(\'prev\',\''+prev_seq+'\')"><span>이전 글</span></button>';
						if (next_seq != '0') btnPrevNext += '<button type="button" class="btn_ico_next" onclick="goPrevNext(\'next\',\''+next_seq+'\')"><span>다음 글</span></button>';
						$("#btnPrevNext").html(btnPrevNext);
						
						if (common.nvl(info.like_yn, '') == "Y") {
							$('#heart').attr("checked", true);
						}else{
							$('#heart').attr("checked", false);
						}
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
					changeFaqData('faqTab3'); //(2024.05.23 김규민)다운로드 이력 관련 추가
					chLimitCount(); //(2024.05.23 김규민)문의내용 관련 추가
				}
			}
		}) ; 	
	}
 	
	function getLikebyRecent(){
		
		var f = document.frmNotice;
		
		common.ajaxCall($('form[name=frmNotice]').serialize(), '/fr/board/getLikeByRecent.do', 'setLikebyRecent') ;
	}
	
	function setLikebyRecent(data){
		changeFaqData('faqTab3');
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
	
	function changeFaqData(gubun){
		//////////////다운로드 이력//////////////////
		if(gubun == 'faqTab1'){
			$("#faqTab2").removeClass("active");
			$("#faqTab3").removeClass("active");
			$("#" + gubun).addClass("active");
			$('#tabAnswer').hide();
			$('#tabLike').hide();
			
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
		if(gubun == 'faqTab2'){
			$("#tbDwHist").hide();
			$('#tabAnswer').show();
			$('#tabLike').hide();
			$("#faqTab1").removeClass("active");
			$("#faqTab3").removeClass("active");
			$("#" + gubun).addClass("active");
			var datas = {'faq_seq' : '${ vo.seq }' } ; 
			common.ajaxCall(datas , '/fr/board/getFaqAwsList.do', 'getFaqAnswer') ;
		}
		////////////////////좋아요 내역///////////////////////////
		if(gubun == 'faqTab3'){
			$("#tbDwHist").hide();
			$('#tabAnswer').hide();
			$('#tabLike').show();
			$("#faqTab1").removeClass("active");
			$("#faqTab2").removeClass("active");
			$("#" + gubun).addClass("active");
			var datas = {'faq_seq' : '${ vo.seq }' } ; 
			common.ajaxCall(datas , '/fr/board/getFaqLikeList.do', 'getFaqLike') ;
		}
		
		
	}//changeFaqData
	
	function getFaqAnswer(data){
		
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
	
	function getFaqLike(data){
		
		$("#likeRow").empty();
		var resultVO = typeof data.resultList != "undefined" ? data.resultList : null ; 
		
		if(resultVO != null && resultVO.lenght !=0){
			var LikeStr ='';
			for(var i=0; i < resultVO.length; i++){
				LikeStr += "<tr>";
				LikeStr += "	<td>"+ (i+1) +"</td>";
				LikeStr += "	<td>"+resultVO[i].w_cust_nm+"</td>";
				LikeStr += "	<td>"+resultVO[i].w_id+"</td>";
				LikeStr += "	<td class='textL'>"+resultVO[i].w_date+"</td>";
			}
			$('#tbLikeList').show();
			$('#count').html(numberWithCommas(data.resultList.length));
			$("#likeRow").html(LikeStr);
		}
		if(data.resultList.length == 0){
			$('#tbLikeList').hide();
			$("#likeRow").hide();
			$('#count').html('0')
		}
	}
	
	function aswForm(){
		
		if(!confirm('문의내용을 등록하시겠습니까?')) return ;
		var f = document.frmNotice;
		f.w_content.value = $('#w_content').val();
		f.faq_seq.value = '${ vo.seq }';
		common.ajaxCall($('form[name=frmNotice]').serialize(), '/fr/board/faqawsform.do', 'registResult') ;
		
	}
	
	function registResult(data){
		
		var msg = "처리도중 오류가 발생했습니다." ; 
		var returnCode = typeof data.returnCode != "undefined" ? data.returnCode : "888" ; 
		if(returnCode == "000") msg = "정상처리 되었습니다." ;
		alert(msg) ; 
		if(returnCode == "000") {$('#w_content').val(''); $('#w_content_text').html('0/ 800 자'); changeNoticeData('faqTab2')}
	}
	
	function deleteAnswer(data){
		
		if(!confirm('문의내용을 삭제하시겠습니까?')) return ;
		
		var f = document.frmNotice;
		f.seq.value = data;
		common.ajaxCall($('form[name=frmNotice]').serialize(), '/fr/board/faqawsDel.do', 'registResult') ;
		
	}

	function listGo() {
		var f = document.frmNotice;
		f.method="post";
		f.target = "";
		f.action="/fr/faq/list.do";
		f.submit();
	}
	
	function goPrevNext (type, seq) {
		var f = document.frmNotice;
		f.seq.value = seq;
		if (type=='prev') f.listNum.value = parseInt($('#listNum').val()) - 1;
		else f.listNum.value = parseInt($('#listNum').val()) + 1;
		f.action = '/fr/faq/form.do';
		f.method = 'post';
		f.submit();
	}
	
	//게시물 사이에 링크 이동
	
	function faqlistDetail(pageType, seq) {
		var f = document.frmNotice;
		f.pageType.value = pageType;
		f.seq.value = seq;
		f.method = 'post';
		f.target = '_blank';
		f.action = '/fr/faq/form.do';
		f.submit();
	}
	
	function downlistDetail(pageType, seq) {
		var f = document.frmNotice;
		f.pageType.value = pageType;
		f.seq.value = seq;
		f.method = 'post';
		f.target = '_blank';
		f.action = '/fr/down/form.do';
		f.submit();
	}
	
	function videofaqlistDetail(pageType, seq) {
		var f = document.frmNotice;
		f.pageType.value = pageType;
		f.seq.value = seq;
		f.method = 'post';
		f.target = '_blank';
		f.action = '/fr/videofaq/form.do';
		f.submit();
	}
	
	function drugfaqlistDetail(pageType, seq) {
		var f = document.frmNotice;
		f.pageType.value = pageType;
		f.seq.value = seq;
		f.method = 'post';
		f.target = '_blank';
		f.action = '/fr/drugfaq/form.do';
		f.submit();
	}
	
	function noticelistDetail(pageType, seq) {
		
		var datas = {'seq' : seq }
		common.ajaxCall(datas, '/fr/board/getNoticenum.do','setNoticenum');
		
		var f = document.frmNotice;
		f.pageType.value = pageType;
		f.seq.value = $('#seq2').val();
		f.method = 'post';
		f.target = '_blank';
		f.action = '/fr/notice/form.do';
		f.submit();
	}
	
	function setNoticenum(data){
		
		var result = data.resultList != "undefined" ? data.resultList : null;
			$('#seq2').val(data.resultList[0].SEQ);
	}
	
</script>

<form id="frmNotice" name="frmNotice" method="post" enctype="multipart/form-data">
<input type="hidden" name="pageType" id="pageType" value="${ vo.pageType }" />
<input type="hidden" name="page" id="page" value="${ vo.page }" />
<input type="hidden" name="board_gbn" id="board_gbn" value="0001" />
<input type="hidden" name="seq" id="seq" value="${ vo.seq }" />
<input type="hidden" name="seq2" id="seq2" value="${ vo.seq }" />
<input type="hidden" name="faq_seq" id="faq_seq" value="${ vo.seq }" />
<input type="hidden" name="listNum" id="listNum" value="${ vo.listNum }" />
<input type="hidden" name="search_text" id="search_text" value="${ vo.search_text }" />

<!-- contents -->
<div id="jw_contents">
	<div class="tit_wrap">
		<h2 class="tit_ico_qa">상담사례<span class="txt_tit_right">자주 찾는 질문이나 정보를 확인하세요. </span></h2>
		<div class="location">
			<a href="/fr/main/list.do" class="home">Home</a>
			<a href="/fr/faq/list.do" class="depth"><span class="here">상담사례</span></a>
		</div>
	</div>
	<!-- view -->
	<table class="vType_line mgb20">
		<caption>FAQ 상세정보</caption>
		<colgroup>
			<col style="width:140px;">
			<col style="width:auto;">
		</colgroup>
		<tbody id="formWrap">
			<tr>
				<th scope="row">No.</th>
				<td>${ vo.seq }</td>
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
				<th scope="row">제목</th>
				<td id="title"></td>
			</tr>
			<tr>
				<td colspan="2" class="view_content" id="content"></td>
			</tr>
			<tr>
	            <td colspan="2">
	            	<div class="heart-container">
	                	<input type="checkbox" id="heart" name="type1" onclick="getLikebyRecent()" class="heart" />
	               		<label for="heart" class="heart_label"></label>
	               		<span>좋아요</span>
	               		<strong><span class="count" id="count">0</span></strong>
	                </div>
	            </td>
	       </tr>
		</tbody>
	</table>
		<div class="btn_wrap">
			<div class="floatL">
				<button type="button" class="btn_ico_list" onclick="listGo();"><span>목록</span></button>
			</div>
			<div class="floatR" id="btnPrevNext"></div>
		</div>
</div>
<!--// contents -->
	
</form>
		
	<!--// view -->
	
	<!-- 다운로드 이력 
	<ul class="tab_line big list3" >
		<li id="faqTab3"  style="width:33% !important;">
			<a href="javascript:changeFaqData('faqTab3')">좋아요 내역</a>
		</li>
		<li id="faqTab1" style="width:34% !important;" class="active">
			<a href="javascript:changeFaqData('faqTab1')">다운로드 이력</a>
		</li>
		<li id="faqTab2"  style="width:33% !important;">
			<a href="javascript:changeFaqData('faqTab2')">문의내용</a>
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
	</table>-->
	<!--// 다운로드 이력 -->
	
	<!-- 문의내용
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
	</div> -->
	<!--// 문의내용 -->
	
		<!-- 좋아요 내역
	<table class="hType mgb20" id="tabLike">
		<caption>좋아요 내역</caption>
		<colgroup>
			<col style="width:140px;">
			<col style="width:auto;">
		</colgroup>
		<thead>
			<tr>
				<th scope="row">No.</th>
				<th scope="row">병원명</th>
				<th scope="row">사용자명</th>
				<th scope="row">좋아요표시 일시</th>
			</tr>
		</thead>
		<tbody id="likeRow">
		</tbody>
	</table> -->
	<!--// 다운로드 이력 -->
	
