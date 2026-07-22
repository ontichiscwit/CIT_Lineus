var as = {
		
		gubun : '' , 
		
		/**	초기화		*/
		form_init : function(){
			$('#mdl_name_slt').empty().append("<option value=''>Model 선택</option>") ; 
			$('#serial_no_slt').empty().append("<option value=''>Serial 선택</option>") ; 
			$('#as_in_kind').empty().append("<option value=''>선택해 주세요</option>") ; 
			$('#phone_gbn').empty().append("<option value=''>연락 받으실 전화번호 선택</option>") ;
			$('#temp_phone').attr('readonly' , true) ;
			$('#temp_phone').val('') ;
			$('#start_date').val('') ;
			as.getCate() ; 			/**	제품 카테고리	*/
		} , 
		
		/**	상단 TAB 이동 처리	*/
		moveTab : function(gbn){
			
			if(gbn == "2" && as.gubun == "2") gbn = "3" ;
			
			for(var i = 1; i <= 3 ; i++){
				if(i == Number(gbn)){
					$('#tab' + i).addClass('active') ;
				}else{
					if($('#tab' + i).hasClass('active')) $('#tab' + i).removeClass('active') ;
				}
			}
		} ,
		
		/**	제품 카테고리 가져오기	*/
		getCate : function(){
			$.ajax({
				type: 'POST',
				url: "/fr/as/getFormInfo.do",
				dataType: "json",
				async : false,
				error : function(xhr , status , error){
					if(common.nvl(error, "") != "") alert(error) ; 
				} , 
				success: function(data) {
					
		 			var cateList = typeof data.cateList != "undefined" ? data.cateList : null ; 
		 			
		 			var str = "<option value=''>제품 카테고리 선택</option>" ; 
		 			
		 			/**	제품 카테고리	START	*/
		 			if(cateList != null && cateList.length > 0){
		 				for(var i = 0 ; i < cateList.length ; i++){
		 					var datas = cateList[i] ; 
		 					str += "<option value='"+datas.code+"@"+datas.code_gbn+"'>"+datas.code_nm+"</option>";
		 				}
		 			}
		 			$('#matr_cate').append(str) ; 
		 			/**	제품 카테고리	END	*/
				}
			});
		} , 
		
		/**	제품 카테고리 변경	*/
		prodMdlList : function(thisVal , gbn){
			/**	초기화		*/
			$('#mdl_name_slt').empty().append("<option value=''>Model 선택</option>") ; 
			$('#serial_no_slt').empty().append("<option value=''>Serial 선택</option>") ; 
			$('#as_in_kind').empty().append("<option value=''>선택해 주세요</option>") ; 
			$('#start_date').val('') ;
			$('#phone_gbn').empty().append("<option value=''>연락 받으실 전화번호 선택</option>") ;
			$('#temp_phone').attr('readonly' , true) ;
			$('#temp_phone').val('') ;
			as.gubun = '' ; 
			
			if(thisVal == "") return ; 
			
			/**	A/S 접수 유형 불러오기	*/
			var gubun_arr = thisVal.split('@');
			as.gubun = gubun_arr[1] ; 
			
			if(gbn == "mdl_name_slt"){
				as.getQueSelect() ; 
				as.getHpList() ; 
			}
			
			
			$.ajax({
				type: 'POST',
				url: "/ad/as/getProdMdlList.do",
				dataType: "json",
				async : false,
				data: {
					matr_cate : gubun_arr[0] , 
					gubun : gubun_arr[1] , 
					is_page_gbn : 'fr'
				} ,
				error : function(xhr , status , error){
					if(common.nvl(error, "") != "") alert(error) ; 
				} , 
				success: function(data) {
			 		
		 			if (data != null && data.resultList.length > 0) {
		 				var str = '' ; 
		 				for(var i = 0 ; i < data.resultList.length ; i++){
		 					str += "<option value='"+escape(data.resultList[i].matr_name)+"@"+escape(data.resultList[i].mdl_name)+"'>"+data.resultList[i].mdl_name+"</option>";
		 				}
		 				$("#" + gbn).append(str) ; 
		 			}
				}
			});
		}, 
		
		prodMdlSetVal : function(thisVal, gbn){
			
			/**	초기화		*/
			
			var matr_cate = "" ; 
			
			if(gbn == "serial_no_slt"){
				$('#serial_no_slt').empty().append("<option value=''>Serial 선택</option>") ;
				$('#start_date').val('') ;
				matr_cate = $('#matr_cate').val().split('@')[0] ; 
			}else{
				$('#search_type4').empty().append(as.defaultListOption) ;
				matr_cate = $('#search_type2').val().split('@')[0] ; 
			}
			
			if(thisVal == "") return ;
			
			var getValArr = thisVal.split("@");
			
			if(gbn == "serial_no_slt") $('#mdl_name').val(unescape(getValArr[1])) ;
			
			$.ajax({
				type: 'POST',
				url: "/ad/as/getProdSelList.do",
				dataType: "json",
				async : false,
				data: {
					matr_cate : matr_cate ,	
					matr_name : unescape(getValArr[0]) , 
					mdl_name : unescape(getValArr[1]) , 
					is_page_gbn : 'fr'
				} ,
				success: function(data) {
			 		var option = '';
		 			if (data != null && data.resultList.length > 0) {
		 				for(var i = 0 ; i < data.resultList.length ; i++){
		 					option += "<option value='"+data.resultList[i].serial_no+"@"+data.resultList[i].inst_dt+"@"+data.resultList[i].end_date+"@"+data.resultList[i].inst_place+"'>"+data.resultList[i].serial_no+"</option>";
		 				}
		 				$("#" + gbn).append(option);
		 			}
				}
			});
		} , 
		
		prodSerial : function(thisVal){
			$("#start_date").val("");
			
			if(thisVal != ""){
				var getValArr = thisVal.split("@");
				$("#serial_no").val(getValArr[0]);
				$("#start_date").val(getValArr[1]);
			}
		} , 
		
		getQueSelect : function(){
			if(as.gubun == "1"){
				if($('#matr_cate').val() != ""){
					var matr_cate = $('#matr_cate').val().split('@') ; 
					commonCode.init(matr_cate[0] , 'as_in_kind');
				}
			}else{
				var option = '' ; 
				option += "<option value='0001'>기기오류</option>";
				option += "<option value='0002'>문의사항</option>";
				
				$("#as_in_kind").append(option);
			}
		} , 
		
		getHpList : function(){
			
			$('#phone_gbn').empty().append("<option value=''>연락 받으실 전화번호 선택</option>") ;
			$('#temp_phone').attr('readonly' , true) ;
			$('#temp_phone').val('') ; 
			
			$.ajax({
				type: 'POST',
				url: "/fr/as/getHpInfo.do",
				dataType: "json",
				data :{ gubun : as.gubun},
				async : false,
				error : function(xhr , status , error){
					if(common.nvl(error, "") != "") alert(error) ; 
				} , 
				success: function(data) {
					var hpList = typeof data.hpList != "undefined" ? data.hpList : null ; 
		 			var my_hp = typeof data.my_hp != "undefined" ? data.my_hp : null ;
		 			
		 			/**	연락처		START	*/
		 			if(common.isNotEmpty(my_hp)){
		 				$('#phone_gbn').append("<option value='"+my_hp+"'>"+my_hp+"</option>") ; 
		 			}
		 			
		 			if(hpList != null && hpList.length > 0){
		 				for(var i = 0 ; i < hpList.length ; i++){
		 					var datas = hpList[i] ;  // phone2_1
		 					if(common.isNotEmpty(datas.hp_no)) $('#phone_gbn').append("<option value='"+datas.hp_no+"'>"+datas.hp_no+"</option>") ; 
		 					if(common.isNotEmpty(datas.tel_no)) $('#phone_gbn').append("<option value='"+datas.tel_no+"'>"+datas.tel_no+"</option>") ; 
		 				}
		 			}
		 			
		 			$('#phone_gbn').append("<option value='99'>직접입력</option>") ;
		 			/**	연락처		END	*/
				}
			}) ; 
		} , 
		
		selectHpNo : function(thisVal){
			if(thisVal == '99'){
				$('#temp_phone').attr('readonly' , false) ; 
			}else{
				$('#temp_phone').attr('readonly' , true) ;
				$('#temp_phone').val('') ;
			}
		} , 
		
		getQuestion : function(){
			$('#questionBody').empty() ;
			
			if(common.isNotEmpty($('#as_in_kind').val())){
				
				$.ajax({
					type : 'post' ,
					url : '/ad/as/getAsQuestion.do' , 
					data : {
						matr_cate : $('#matr_cate').val().split('@')[0] , 
						as_in_kind : $('#as_in_kind').val() , 
						is_page_gbn : 'fr'
					} ,
					dataType : 'json' , 
					error : function(xhr , status , error){
						if(common.nvl(error, "") != "") alert(error) ; 
					} , 
					success : function(data){
						as.printQst(data , 'questionBody') ; 
					}  
					
				}) ; 
			}
		} , 
		
		autoHypenPhone : function(str){
		    return str.replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3");
		},
		
		insertForm : function(){
			var f = document.procFrm ; 
			
			if(common.isEmpty($('#matr_cate').val())){
				alert("제품카테고리를 선택해 주세요.") ; 
				return ; 
			}
			
			if(common.isEmpty($('#mdl_name_slt').val())){
				alert("Model을 선택해 주세요.") ; 
				return ; 
			}
			
			if(common.isEmpty($('#serial_no_slt').val())){
				alert("Serial을 선택해 주세요.") ; 
				return ; 
			}
			
			if($('#phone_gbn').val() == ""){
				alert("연락 받으실 연락처를 선택해 주세요.") ; 
				return ; 
			}
			
			if($('#phone_gbn').val() == "99"){
				if(common.isEmpty($('#temp_phone').val())){
					alert("연락 받으실 연락처를 입력해 주세요.") ; 
					return ;
				}else{
					$('#hp_no').val(as.autoHypenPhone($('#temp_phone').val())) ;
				}
			}else{
				$('#hp_no').val($('#phone_gbn').val()) ; 
			}
			
			if(common.isEmpty($('#as_in_kind').val())){
				alert("A/S 접수 유형을 선택해 주세요.") ; 
				return ; 
			}
			
			if(confirm("A/S를 등록하시겠습니까?")){
				
				f.gubun.value = as.gubun ; 
				
				f.target = "hiddenFrame" ; 
				f.action = "/fr/as/proc.do" ; 
				f.submit();
			}
			
		} , 
		
		movePage : function(gbn){
			var f = document.listFrm ; 
			var url = gbn == "1" ? "/fr/as/form.do" : "/fr/as/list.do"
			f.target = "" ; 
			f.action =  url ; 
			f.submit() ; 
		} , 
		
		list_init : function(){
			$('#search_type1').append("<option value=''>처리상태</option>") ; 
			commonCode.init('CD01', 'search_type1');
			
			as.goList(1) ; 
			
		} , 
		
		goList : function(currentPage){
			var f = document.listFrm ; 
			
			f.page.value = currentPage ; 
			
			$('#asTbody').empty() ; 
			
			$.ajax({
				type : 'post' ,
				url : '/fr/as/getFrList.do' , 
				data : $('form[name=listFrm]').serialize() ,
				dataType : 'json' , 
				error : function(xhr , status , error){
					if(common.nvl(error, "") != "") alert(error) ; 
					commonTable.notData(3 , '조회된 데이터가 없습니다.' , 'asTbody') ; 
				} , 
				
				success : function(data){
					var resultList = typeof data.resultList != "undefined" ? data.resultList : null ; 
					
					if(resultList != null && resultList.length > 0){
						
						var str = '' ; 
						
						for(var i = 0 ; i < resultList.length ; i++){
							var datas = resultList[i] ; 
							
							var attach_seq = common.nvl(datas.attach_seq2 , '0') ;
							
							str += '<tr>' ; 
							str += '	<td>' ; 
							str += '		<a href="javascript:void(0);" data-toggle="modal" data-target="#modal-list-more" onclick="javascript:as.goView(\''+common.nvl(datas.as_in_no, '')+'\');">' ; 
							str += '			<p>'+common.nvl(datas.gubun_nm , '')+'</p>' ; 
							str += '			<p><span>'+common.nvl(datas.matr_cate_nm, '-')+'</span>/<span>'+common.nvl(datas.mdl_name, '-')+'</span></p>' ; 
							str += '		</a>' ; 
							str += '	</td>' ; 
							
							if(common.nvl(datas.gubun) == "1") str += '	<td>'+common.nvl(datas.as_in_kind_nm, '-')+'</td>' ; 
							else str += '	<td>'+(common.nvl(datas.as_in_kind , '') == "0001" ? '기기오류' : '문의사항')+'</td>' ;
							
							
							str += '	<td>'+common.nvl(datas.as_prg_state_nm, '-')+'</td>' ; 
							str += '</tr>' ; 
						}
						
						$('#asTbody').append(str) ; 
						
					}else{
						commonTable.notData(3 , '조회된 데이터가 없습니다.' , 'asTbody') ;
					}
				}
			}) ; 
		} , 
		
		goView : function(as_in_no){
			
			var f = document.listFrm ; 
			
			f.as_in_no.value = as_in_no ; 
			
			$.ajax({
				type : 'post' ,
				url : '/fr/as/getAsInfo.do' , 
				data : $('form[name=listFrm]').serialize() ,
				dataType : 'json' , 
				error : function(xhr , status , error){
					if(common.nvl(error, "") != "") alert(error) ; 
				} , 
				success : function(data){
					var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null ; 
					var fileList1 = typeof data.fileList1 != "undefined" ? data.fileList1 : null ; 
					
					if(resultVO != null){
						
						var attach_seq1 = common.nvl(resultVO.attach_seq1 , '0') ; 
						
						$('#view_as_in_dt').val(common.nvl(resultVO.as_in_dt, '-')) ; 
						$('#view_gubun').val(common.nvl(resultVO.gubun_nm , '')) ; 
						$('#view_matr_cate_nm').val(common.nvl(resultVO.matr_cate_nm, '-')) ; 
						$('#view_mdl_name').val(common.nvl(resultVO.mdl_name, '-')) ; 
						$('#view_prg_state_nm').val(common.nvl(resultVO.as_prg_state_nm, '-')) ; 
						$('#view_kor_name').val(common.nvl(resultVO.kor_name, '-')) ; 
						
						if(common.nvl(resultVO.gubun, '') == "1") $('#view_as_in_kind').append("<option value='"+common.nvl(resultVO.as_in_kind, '-')+"'>"+common.nvl(resultVO.as_in_kind_nm, '-')+"</option>") ;
						else {
							if(common.nvl(resultVO.as_in_kind, '') == "0001") $('#view_as_in_kind').append("<option value='0001'>기기오류</option>") ;
							else $('#view_as_in_kind').append("<option value='0002'>문의사항</option>") ;
						}
						
						if(attach_seq1 != "0"){
							
							var str = '<legend>방문보고서 다운로드</legend>' ; 
							str += '<div class="form-group">' ; 
							str += '	<button class="btn btn-primary btn-lg btn-block" onclick="javascript:fileDown(\''+attach_seq1+'\' , \'1\');">방문보고서</button>' ; 
							str += '</div>' ; 
							
							$('#attach_seq1').append(str) ; 
							$('#attach_seq1').show() ; 
						}else{
							$('#attach_seq1').hide() ; 
						}
						
					}
					
					/**	첨부파일	*/
					if(fileList1 != null && fileList1.length > 0){
						var str = '' ; 
						for(var i = 0 ; i < fileList1.length ; i++){
							var datas = fileList1[i] ; 
							var file_path = datas.attach_path + datas.attach_save_nm ;
							if(file_path != "" ){
								str += '<img  src="'+file_path+'" alt="">' ;
							}
							 
						}
						$('#attach_seq').append(str) ; 
						// attach_seq1 <img  src="img/test.jpg" alt="">
					}
					
					as.printQst(data , 'questionBody') ; 
				}
			}) ; 
			
		} , 
		
		printQst : function(data , target){
			var resultList = data.resultList != "undefined" ? data.resultList : null ; 
			
			$('#' + target).empty() ;
			
			if(resultList != null ){
				
				var as_in_kind_seq_p = "" ;
				var as_in_kind_que_gbn_p = "" ;
				var str = "" ;
				
				for(var i = 0 ; i < resultList.length ; i++){
					var datas = resultList[i] ;
					
					var as_in_kind_seq = common.nvl(datas.as_in_kind_seq, "") ;
					var as_in_kind_que = common.nvl(datas.as_in_kind_que, "") ;
					var as_in_kind_que_gbn = common.nvl(datas.as_in_kind_que_gbn, "") ;
					var as_in_kind_exp_seq = common.nvl(datas.as_in_kind_exp_seq, "") ;
					var as_in_kind_exp_qst = common.nvl(datas.as_in_kind_exp_qst, "") ;
					
					var as_in_kind_ans_seq = common.nvl(datas.as_in_kind_ans_seq, "") ;
					var as_in_kind_ans_etc = common.nvl(datas.as_in_kind_ans_etc, "") ;
					
					if(i == 0){
						str += '<fieldset>' ; 
						str += '	<legend>'+as_in_kind_seq+'. '+as_in_kind_que+'</legend>' ; 
						str += '<input type="hidden" name="as_in_kind_que_gbn'+as_in_kind_seq+'" value="'+as_in_kind_que_gbn+'"/>' ;
						str += '	<div class="row">' ; 
						
						if(as_in_kind_que_gbn == "1"){
							str += '		<div class="col-xs-12">' ; 
							str += '			<textarea name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'" rows="3" class="form-control" placeholder="기타 사유를 적어주세요" maxlength="500">'+as_in_kind_ans_etc+'</textarea>' ; 
							str += '		</div>' ; 
						}else if(as_in_kind_que_gbn == "2"){
							str += '		<div class="col-xs-6 left">' ; 
							if(as_in_kind_exp_seq == as_in_kind_ans_seq) str += '			<label class="q-radio"><input type="radio" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" checked><span class="form-control">'+as_in_kind_exp_qst+'</span></label>' ; 
							else str += '			<label class="q-radio"><input type="radio" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'"><span class="form-control">'+as_in_kind_exp_qst+'</span></label>' ; 
							str += '		</div>' ;
						}else if(as_in_kind_que_gbn == "3"){
							str += '		<div class="col-xs-6 left">' ; 
							if(as_in_kind_exp_seq == as_in_kind_ans_seq) str += '			<label class="q-radio"><input type="checkbox" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" checked><span class="form-control">'+as_in_kind_exp_qst+'</span></label>' ; 
							else str += '			<label class="q-radio"><input type="checkbox" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'"><span class="form-control">'+as_in_kind_exp_qst+'</span></label>' ; 
							str += '		</div>' ;
						}else if(as_in_kind_que_gbn == "4"){
							str += '		<div class="col-xs-12">' ; 
							str += '			<input type="file" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'" title="첨부파일" class="write_gray w355"/>' ; 
							str += '		</div>' ;
						}
						
					}else{
						if(as_in_kind_seq_p == as_in_kind_seq){
							if(as_in_kind_que_gbn == "2"){
								str += '		<div class="col-xs-6 left">' ; 
								if(as_in_kind_exp_seq == as_in_kind_ans_seq) str += '			<label class="q-radio"><input type="radio" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" checked><span class="form-control">'+as_in_kind_exp_qst+'</span></label>' ; 
								else str += '			<label class="q-radio"><input type="radio" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'"><span class="form-control">'+as_in_kind_exp_qst+'</span></label>' ; 
								str += '		</div>' ;
							}else if(as_in_kind_que_gbn == "3"){
								str += '		<div class="col-xs-6 left">' ; 
								if(as_in_kind_exp_seq == as_in_kind_ans_seq) str += '			<label class="q-radio"><input type="checkbox" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" checked><span class="form-control">'+as_in_kind_exp_qst+'</span></label>' ; 
								else str += '			<label class="q-radio"><input type="checkbox" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'"><span class="form-control">'+as_in_kind_exp_qst+'</span></label>' ; 
								str += '		</div>' ;
							}
						}else{
							str += '	</div>' ; 
							str += '</fieldset>' ;
							
							str += '<fieldset>' ; 
							str += '	<legend>'+as_in_kind_seq+'. '+as_in_kind_que+'</legend>' ; 
							str += '<input type="hidden" name="as_in_kind_que_gbn'+as_in_kind_seq+'" value="'+as_in_kind_que_gbn+'"/>' ;
							str += '	<div class="row">' ; 
							
							if(as_in_kind_que_gbn == "1"){
								str += '		<div class="col-xs-12">' ; 
								str += '			<textarea name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'" rows="3" class="form-control" placeholder="기타 사유를 적어주세요" maxlength="500">'+as_in_kind_ans_etc+'</textarea>' ; 
								str += '		</div>' ; 
							}else if(as_in_kind_que_gbn == "2"){
								str += '		<div class="col-xs-6 left">' ; 
								if(as_in_kind_exp_seq == as_in_kind_ans_seq) str += '			<label class="q-radio"><input type="radio" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" checked><span class="form-control">'+as_in_kind_exp_qst+'</span></label>' ; 
								else str += '			<label class="q-radio"><input type="radio" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'"><span class="form-control">'+as_in_kind_exp_qst+'</span></label>' ; 
								str += '		</div>' ;
							}else if(as_in_kind_que_gbn == "3"){
								str += '		<div class="col-xs-6 left">' ; 
								if(as_in_kind_exp_seq == as_in_kind_ans_seq) str += '			<label class="q-radio"><input type="checkbox" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" checked><span class="form-control">'+as_in_kind_exp_qst+'</span></label>' ; 
								else str += '			<label class="q-radio"><input type="checkbox" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'"><span class="form-control">'+as_in_kind_exp_qst+'</span></label>' ; 
								str += '		</div>' ;
							}else if(as_in_kind_que_gbn == "4"){
								str += '		<div class="col-xs-12">' ; 
								str += '			<input type="file" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'" title="첨부파일" class="write_gray w355"/>' ; 
								str += '		</div>' ;
							}
							
						}
					}
					
					as_in_kind_seq_p = as_in_kind_seq ; 
					as_in_kind_que_gbn_p = as_in_kind_que_gbn ; 
					
					if(i == (resultList.length - 1)){
						str += '	</div>' ; 
						str += '</fieldset>' ; 
					}
				}
				
				$('#' + target).html(str) ;
				$('#errorCnt').val(as_in_kind_seq_p) ; 
				
			}
		}
		
		
};