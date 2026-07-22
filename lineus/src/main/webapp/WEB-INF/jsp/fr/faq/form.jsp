<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script type="text/javascript">
	
	$(document).ready(function(){	 
		 initView();
	});
	
	function initView() {
		var f = document.frmNotice ; 
		
		$.ajax({
			type : 'post' ,
			url : '/fr/board/getBoardInfo.do' , 
			data : $('form[name=frmNotice]').serialize() ,
			dataType : 'json' , 
			error : function(xhr , status , error){
				if(common.nvl(error, "") != "") alert(error);
			} , 
			success : function(data){
				
				var str ='';
				var resultVO = data.resultVO != "undefined" ? data.resultVO : null ;
				
				if(resultVO != null){
					var info = resultVO.info != "undefined" ? resultVO.info : null ; 
					var attachList = resultVO.attachList != "undefined" ? resultVO.attachList : null ; 
					
					if (info != null){
						$('#title').html(common.nvl(info.title,''));
						$('#content').html(common.nvl(info.content,''));
						$('#content span').css({'line-height' : '1em'});
						$('#cnt').html(common.nvl(info.cnt,''));
						$('#reg_date').html(common.nvl(info.reg_date,''));
						
						$("#btnPrevNext").empty();
						var btnPrevNext = '';
						var prev_seq = info.prev_seq;
						var next_seq = info.next_seq;
						if (prev_seq != '0') btnPrevNext += '<button type="button" class="btn_ico_before" onclick="goPrevNext(\'prev\',\''+prev_seq+'\')"><span>이전 글</span></button>';
						if (next_seq != '0') btnPrevNext += '<button type="button" class="btn_ico_next" onclick="goPrevNext(\'next\',\''+next_seq+'\')"><span>다음 글</span></button>';
						$("#btnPrevNext").html(btnPrevNext);
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
				}
			}
		}) ; 	
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
</script>

<form id="frmNotice" name="frmNotice" method="post" enctype="multipart/form-data">
<input type="hidden" name="pageType" id="pageType" value="${ vo.pageType }" />
<input type="hidden" name="board_gbn" id="board_gbn" value="0001" />
<input type="hidden" name="seq" id="seq" value="${ vo.seq }" />
<input type="hidden" name="listNum" id="listNum" value="${ vo.listNum }" />
<!-- contents -->
<div id="jw_contents">
	<div class="tit_wrap">
		<h2 class="tit_ico_faq">FAQ<span class="txt_tit_right">자주 찾는 질문이나 정보를 확인하세요. </span></h2>
		<div class="location">
			<a href="/fr/main/list.do" class="home">Home</a>
			<a href="/fr/faq/list.do" class="depth"><span class="here">FAQ</span></a>
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
				<td>${ vo.listNum }</td>
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
		</tbody>
	</table>
	<!--// view -->
	<div class="btn_wrap">
		<div class="floatL">
			<button type="button" class="btn_ico_list" onclick="listGo();"><span>목록</span></button>
		</div>
		<div class="floatR" id="btnPrevNext"></div>
	</div>
</div>
<!--// contents -->
</form>