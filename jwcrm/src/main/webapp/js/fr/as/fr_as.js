var as = {
		
		defaultOption 	: "<option value=''>선택해주세요.</option>" , 		/**	동적 select box 의 최초 값	*/
		gubun				: '' , 
		
		defaultListOption 	: "<option value=''>전체</option>" , 		/**	동적 select box 의 최초 값	*/
		
		/**	A/S 접수 정보 초기화 	*/
		form_init : function(){
			
			$('#mdl_name_slt').empty().append(as.defaultOption) ; 
			$('#serial_no_slt').empty().append(as.defaultOption) ; 
			$('#as_in_kind').empty().append(as.defaultOption) ; 
			$('[id^=phone]').val('') ; 
			$('#matr_cate').empty();
			
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
		 			
		 			/**	제품 카테고리	START	*/
		 			if(cateList != null && cateList.length > 0){
		 				var str = as.defaultOption ; 
		 				for(var i = 0 ; i < cateList.length ; i++){
		 					var datas = cateList[i] ; 
		 					str += "<option value='"+datas.code+"@"+datas.code_gbn+"'>"+datas.code_nm+"</option>";
		 				}
		 				$('#matr_cate').append(str) ; 
		 			} else {
		 				$('#matr_cate').append('<option value="">등록된 제품이 없습니다.</option>') ;
		 			}
		 			/**	제품 카테고리	END	*/
				}
			});
		} , 
		
		/**	제품 카테고리 change	*/
		prodMdlList : function(thisVal , gbn){
			
			
			/**	초기화		*/
			if(gbn == "mdl_name_slt"){
				$('#mdl_name_slt').empty().append(as.defaultOption) ; 
				$('#serial_no_slt').empty().append(as.defaultOption) ; 
				$('#as_in_kind').empty().append(as.defaultOption) ; 
				$('#start_date').val('') ;
				$('#questionBody').empty() ;
				$('#questionStrong').hide() ;
				$('[id^=phone]').val('') ; 
			}else{
				$('#search_type3').empty().append(as.defaultListOption) ;
				$('#search_type4').empty().append(as.defaultListOption) ;
			}
			
			
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
		} , 
		
		prodMdlSetVal : function(thisVal, gbn){
			
			/**	초기화		*/
			
			var matr_cate = "" ; 
			
			if(gbn == "serial_no_slt"){
				$('#serial_no_slt').empty().append(as.defaultOption) ;
				$('#start_date').val('') ;
				matr_cate = $('#matr_cate').val().split('@')[0] ; 
			}else{
				// search_type3
				$('#search_type4').empty().append(as.defaultListOption) ;
				matr_cate = $('#search_type2').val().split('@')[0] ; 
			}
			
			if(thisVal == "") return ;
			
			var getValArr = thisVal.split("@");
			
			if(gbn == "serial_no_slt"){
				$('#mdl_name').val(unescape(getValArr[1])) ;
			}
			
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
		
		getQuestion : function(){
			$('#questionBody').empty() ;
			$('#questionStrong').hide() ;
			
			if(as.gubun == "2") return ;
			
			
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
						var resultList = data.resultList != "undefined" ? data.resultList : null ; 
						
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
								
								if(i == 0 ){
									str += '<dt>'+as_in_kind_seq+'. '+as_in_kind_que+'</dt>' ;
									str += '<input type="hidden" name="as_in_kind_que_gbn'+as_in_kind_seq+'" value="'+as_in_kind_que_gbn+'"/>' ;
									str += '<dd>' ; 			
									
									/**	주관식		*/if(as_in_kind_que_gbn == "1")				str += '<input type="text" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'" title="기타사항 입역" class="write_gray w355" value="'+as_in_kind_ans_etc+'" maxlength="500"/></dd>' ; 
									/**	객관식		*/else 	if(as_in_kind_que_gbn == "2"){
										if(as_in_kind_exp_seq == as_in_kind_ans_seq) str += '<input type="radio" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" class="mgr10" checked/><label for="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" class="mgr15">'+as_in_kind_exp_qst+'</label>' ;
										else str += '<input type="radio" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" class="mgr10" /><label for="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" class="mgr15">'+as_in_kind_exp_qst+'</label>' ;
									}
									/**	복수선택	*/else 	if(as_in_kind_que_gbn == "3"){
										if(as_in_kind_ans_etc.indexOf(as_in_kind_exp_seq) != -1) str += '<input type="checkbox" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" class="mgr10" checked/><label for="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" class="mgr15">'+as_in_kind_exp_qst+'</label>' ;
										else str += '<input type="checkbox" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" class="mgr10" /><label for="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" class="mgr15">'+as_in_kind_exp_qst+'</label>' ;
									}
									/**	첨부파일	*/else 	if(as_in_kind_que_gbn == "4"){
										str += '<input type="file" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'" title="첨부파일" class="write_gray w355"/></dd>' ;
										str += '<input type="hidden" name="p_error_seq'+as_in_kind_seq+'" value="'+as_in_kind_ans_seq+'"/>' ;
									}
									
									
								}else{
									if(as_in_kind_seq_p == as_in_kind_seq){
										/**	객관식		*/if(as_in_kind_que_gbn == "2"){
											if(as_in_kind_exp_seq == as_in_kind_ans_seq) str += '<input type="radio" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" class="mgr10" checked/><label for="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" class="mgr15">'+as_in_kind_exp_qst+'</label>' ;
											else str += '<input type="radio" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" class="mgr10" /><label for="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" class="mgr15">'+as_in_kind_exp_qst+'</label>' ;
										}
										/**	복수선택	*/else 	if(as_in_kind_que_gbn == "3"){
											if(as_in_kind_ans_etc.indexOf(as_in_kind_exp_seq) != -1) str += '<input type="checkbox" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" class="mgr10" checked/><label for="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" class="mgr15">'+as_in_kind_exp_qst+'</label>' ;
											else str += '<input type="checkbox" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" class="mgr10" /><label for="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" class="mgr15">'+as_in_kind_exp_qst+'</label>' ;
										}
									}else{
										if(as_in_kind_que_gbn_p != "1" || as_in_kind_que_gbn_p != "4") str += '</dd>' ; 			 
										str += '<dt>'+as_in_kind_seq+'. '+as_in_kind_que+'</dt>' ;
										str += '<input type="hidden" name="as_in_kind_que_gbn'+as_in_kind_seq+'" value="'+as_in_kind_que_gbn+'"/>' ;
										str += '<dd>' ; 			
										/**	주관식		*/if(as_in_kind_que_gbn == "1")				str += '<input type="text" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'" title="기타사항 입역" class="write_gray w355" value="'+as_in_kind_ans_etc+'" maxlength="500"/></dd>' ; 
										/**	객관식		*/else 	if(as_in_kind_que_gbn == "2"){
											if(as_in_kind_exp_seq == as_in_kind_ans_seq) str += '<input type="radio" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" class="mgr10" checked/><label for="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" class="mgr15">'+as_in_kind_exp_qst+'</label>' ;
											else str += '<input type="radio" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" class="mgr10" /><label for="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" class="mgr15">'+as_in_kind_exp_qst+'</label>' ;
										}
										/**	복수선택	*/else 	if(as_in_kind_que_gbn == "3"){
											if(as_in_kind_ans_etc.indexOf(as_in_kind_exp_seq) != -1) str += '<input type="checkbox" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" class="mgr10" checked/><label for="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" class="mgr15">'+as_in_kind_exp_qst+'</label>' ;
											else str += '<input type="checkbox" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" class="mgr10" /><label for="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" class="mgr15">'+as_in_kind_exp_qst+'</label>' ;
										}
										/**	첨부파일	*/else 	if(as_in_kind_que_gbn == "4"){
											str += '<input type="file" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'" title="첨부파일" class="write_gray w355"/></dd>' ;
											str += '<input type="hidden" name="p_error_seq'+as_in_kind_seq+'" value="'+as_in_kind_ans_seq+'"/>' ;
										}
									}	
								}
								
								as_in_kind_seq_p = as_in_kind_seq ; 
								as_in_kind_que_gbn_p = as_in_kind_que_gbn ; 
								
								if(i == (resultList.length - 1)){
									str += '</dd>' ;
								}
							}
							
							$('#questionBody').html(str) ;
							$('#questionStrong').show() ;
							$('#errorCnt').val(as_in_kind_seq_p) ; 
							
						}
					}  
					
				}) ; 
			}
		} , 
		
		clearForm : function(){
			document.procFrm.reset() ;
			$('#questionBody').empty() ; 
			$('#questionStrong').hide() ; 
			as.form_init() ; 
		} , 
		
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
			
			var phone_gbn = $("input:radio[name=phone_gbn]:checked").val();
			
			if(typeof phone_gbn != "undefined"){
				var hp_no = "" ; 
				for(var i = 1; i <=3 ; i++){
					if(common.isNotEmpty($('#phone'+phone_gbn+'_' + i).val())){
						if(hp_no == "") hp_no = $('#phone'+phone_gbn+'_' + i).val() ; 
						else hp_no = hp_no + "-" + $('#phone'+phone_gbn+'_' + i).val() ;
					}else{
						alert("연락처를 입력해 주세요.") ; 
						return ; 
					}
				}
				
				if(hp_no == ""){
					alert("연락처를 입력해 주세요.") ; 
					return ;
				}
				
				$('#hp_no').val(hp_no) ; 
				
			}else{
				alert("연락 받으실 전화번호를 선택 해 주세요.") ;
				return ; 
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
		
		movePage : function(gbn, useYn){
			var f = document.listFrm ;
			var url = '';
			if (useYn != 'N') {
				url = gbn == "1" ? "/fr/as/form.do" : "/fr/as/list.do";
			} else {
				alert('현재 로그인한 계정은 [정지]상태이므로 A/S를 접수 할 수 없습니다.\n관리자에게 문의 하세요.');
				return;
			}
			f.target = "" ; 
			f.action =  url ; 
			f.submit() ; 
		} , 
		
		getHpList : function(){
			
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
		 			if(my_hp != null){
		 				$('#phone1_1').val(common.spritStr(my_hp , 1, '-')) ; 
		 				$('#phone1_2').val(common.spritStr(my_hp , 2, '-')) ; 
		 				$('#phone1_3').val(common.spritStr(my_hp , 3, '-')) ; 
		 			}
		 			
		 			if(hpList != null && hpList.length > 0){
		 				for(var i = 0 ; i < hpList.length ; i++){
		 					var datas = hpList[i] ;  // phone2_1
		 					
		 					$('#phone2_1').val(common.spritStr(datas.hp_no , 1, '-')) ; 
			 				$('#phone2_2').val(common.spritStr(datas.hp_no , 2, '-')) ; 
			 				$('#phone2_3').val(common.spritStr(datas.hp_no , 3, '-')) ; 
			 				
			 				//$('#phone3_1').val(common.spritStr(datas.tel_no , 1, '-')) ; 
			 				//$('#phone3_2').val(common.spritStr(datas.tel_no , 2, '-')) ; 
			 				//$('#phone3_3').val(common.spritStr(datas.tel_no , 3, '-')) ; 
		 					
		 				}
		 			}
		 			/**	연락처		END	*/
				}
			}) ; 
		},
		
		
		/****************************	목록 시작	*************************************/
		
		list_init : function(){
			$('#search_type1').append(as.defaultListOption) ; 
			commonCode.init('CD01', 'search_type1');
			
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
		 			
		 			/**	제품 카테고리	START	*/
		 			if(cateList != null && cateList.length > 0){
		 				var str = as.defaultListOption ; 
		 				for(var i = 0 ; i < cateList.length ; i++){
		 					var datas = cateList[i] ; 
		 					str += "<option value='"+datas.code+"@"+datas.code_gbn+"'>"+datas.code_nm+"</option>";
		 				}
		 				$('#search_type2').append(str) ; 
		 			}
		 			/**	제품 카테고리	END	*/
				}
			});
			
			as.goList(1) ; 
			
		} , 
		
		goList : function(currentPage){
			var f = document.listFrm ; 
			
			f.page.value = currentPage ; 
			
			$('#asTbody').empty() ; 
			$('#pageNation').empty() ;  
			
			$.ajax({
				type : 'post' ,
				url : '/fr/as/getFrList.do' , 
				data : $('form[name=listFrm]').serialize() ,
				dataType : 'json' , 
				error : function(xhr , status , error){
					if(common.nvl(error, "") != "") alert(error) ; 
					commonTable.notData(9 , '조회된 데이터가 없습니다.' , 'asTbody') ; 
				} , 
				
				success : function(data){
					var resultList = data.resultList != "undefined" ? data.resultList : null ; 
					var vo = data.vo != "undefined" ? data.vo : null ; 
					
					if(resultList != null){
						
						var str = '' ; 
						
						for(var i = 0 ; i < resultList.length ; i++){
							var datas = resultList[i] ; 
							
							var attach_seq = common.nvl(datas.attach_seq2 , '0') ; 
							
							str += '<tr  data-no="'+common.nvl(datas.as_in_no , '')+'" data-tel="'+common.nvl(datas.as_in_tel , '')+'" data-cate="'+common.nvl(datas.matr_cate , '')+'"  data-mdl="'+common.nvl(datas.mdl_name , '')+'" data-kind="'+common.nvl(datas.as_in_kind , '')+'" data-attach="'+common.nvl(datas.attach_seq , '0')+'" data-stat="'+common.nvl(datas.as_prg_state , '')+'">' ; 
							str += '	<td>'+datas.rnum+'</td>' ; 
							str += '	<td>'+common.nvl(datas.as_in_dt , '-')+'</td>' ; 
							str += '	<td>'+common.nvl(datas.as_prg_state_nm , '-')+'</td>' ; 
							str += '	<td>'+common.nvl(datas.gubun_nm , '')+'</td>' ; 
							str += '	<td>'+common.nvl(datas.matr_cate_nm , '-')+' / '+common.nvl(datas.mdl_name , '-')+'</td>' ; 
							str += '	<td>'+common.nvl(datas.serial_no , '-')+'</td>' ; 
							
							if(common.nvl(datas.gubun) == "1") str += '	<td>'+common.nvl(datas.as_in_kind_nm , '-')+'</td>' ;
							else str += '	<td>'+(common.nvl(datas.as_in_kind , '') == "0001" ? '기기오류' : '문의사항')+'</td>' ;
							
							if (common.nvl(datas.as_prg_state, '') == '0001') str += '<td>-</td>';
							else str += '	<td>'+common.nvl(datas.kor_name , '-')+'</td>' ;
							
							str += '	<td>' ; 
							if(attach_seq != "0"){
								str += '		<button type="button" class="btn_download_blue" onclick="javascript:fileDown(\''+attach_seq+'\' , \'1\');"><span>다운로드</span></button>' ; 
							}else{
								str += '	-' ;
							}
							str += '	</td>' ; 
							str += '</tr>' ; 
							str += '<input type="hidden" name="as_in_bigo_'+common.nvl(datas.as_in_no , '')+'" id="as_in_bigo_'+common.nvl(datas.as_in_no , '')+'" value="'+common.nvl(datas.as_in_bigo , '')+'"/>' ; 
						}
						
						$('#asTbody').append(str) ; 
						$('#pageNation').html(vo.json_paging) ; 
						
					}else{
						commonTable.notData(9 , '조회된 데이터가 없습니다.' , 'asTbody') ;
						$('#pageNation').html('') ;
					}
				}
			}) ; 
		} , 
		
		goView : function(thisVal , as_in_no){
			commonLayer.init('FRONTVIEW');
			
			var as_in_dt = thisVal.cells[1] ; 
			var as_prg_state_nm = thisVal.cells[2] ; 
			var kor_name = thisVal.cells[7] ; 
			var matr_cate_nm = thisVal.cells[4] ; 
			var serial_no = thisVal.cells[5] ; 
			var gubun_nm = thisVal.cells[3] ; 
			var kind_nm = thisVal.cells[6] ; 
			
			$('#as_in_dt').html($(as_in_dt).html()) ; 
			$('#as_prg_state_nm').html($(as_prg_state_nm).html()) ; 
			$('#kor_name').html($(kor_name).html()) ; 
			$('#matr_cate_nm').html($(matr_cate_nm).html()) ; 
			$('#serial_no').html($(serial_no).html()) ; 
			$('#gubun_nm').html($(gubun_nm).html()) ; 
			$('#as_in_tel').html($(thisVal).attr('data-tel')) ; 
			
			$('#as_in_no').val(as_in_no) ;
			
			var as_in_kind = '<option value="'+$(thisVal).attr('data-kind')+'">'+$(kind_nm).html()+'</option>' ; 
			$('#as_in_kind').empty().append(as_in_kind) ; 
			/**	구매 / 임대일 가져오기 ajax		*/
			$.ajax({
				type: 'POST',
				url: "/ad/as/getProdSelList.do",
				dataType: "json",
				async : false,
				data: {
					matr_cate : $(thisVal).attr('data-cate') ,	
					mdl_name : $(thisVal).attr('data-mdl') , 
					is_page_gbn : 'fr'
				} ,
				success: function(data) {
			 		var option = '';
		 			if (data != null && data.resultList.length > 0) {
		 				for(var i = 0 ; i < data.resultList.length ; i++){
		 					if(data.resultList[i].serial_no == thisVal.cells[5]){
		 						$("#start_date").html(data.resultList[i].start_date);
		 						break ; 
		 					}
		 				}
		 			}
				}
			});
			
			$('#questionBody').empty() ;
			$('#questionStrong').hide() ;
			
			$.ajax({
				type : 'post' ,
				url : '/ad/as/getAsQuestion.do' , 
				data : {
					as_in_no : as_in_no , 
					matr_cate : $(thisVal).attr('data-cate') , 
					as_in_kind : $(thisVal).attr('data-kind') , 
					is_page_gbn : 'fr'
				} ,
				dataType : 'json' , 
				error : function(xhr , status , error){
					if(common.nvl(error, "") != "") alert(error) ; 
				} , 
				success : function(data){
					var resultList = data.resultList != "undefined" ? data.resultList : null ; 
					
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
							
							if(i == 0 ){
								str += '<dt>'+as_in_kind_seq+'. '+as_in_kind_que+'</dt>' ;
								str += '<input type="hidden" name="as_in_kind_que_gbn'+as_in_kind_seq+'" value="'+as_in_kind_que_gbn+'"/>' ;
								str += '<dd>' ; 			
								
								/**	주관식		*/if(as_in_kind_que_gbn == "1")				str += '<input type="text" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'" title="기타사항 입역" class="write_gray w355" value="'+as_in_kind_ans_etc+'" maxlength="500"/></dd>' ; 
								/**	객관식		*/else 	if(as_in_kind_que_gbn == "2"){
									if(as_in_kind_exp_seq == as_in_kind_ans_seq) str += '<input type="radio" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" class="mgr10" checked/><label for="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" class="mgr15">'+as_in_kind_exp_qst+'</label>' ;
									else str += '<input type="radio" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" class="mgr10" /><label for="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" class="mgr15">'+as_in_kind_exp_qst+'</label>' ;
								}
								/**	복수선택	*/else 	if(as_in_kind_que_gbn == "3"){
									if(as_in_kind_ans_etc.indexOf(as_in_kind_exp_seq) != -1) str += '<input type="checkbox" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" class="mgr10" checked/><label for="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" class="mgr15">'+as_in_kind_exp_qst+'</label>' ;
									else str += '<input type="checkbox" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" class="mgr10" /><label for="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" class="mgr15">'+as_in_kind_exp_qst+'</label>' ;
								}
								/**	첨부파일	*/else 	if(as_in_kind_que_gbn == "4"){
									str += '<input type="file" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'" title="첨부파일" class="write_gray w355"/></dd>' ;
									str += '<input type="hidden" name="p_error_seq'+as_in_kind_seq+'" value="'+as_in_kind_ans_seq+'"/>' ;
								}
								
								
							}else{
								if(as_in_kind_seq_p == as_in_kind_seq){
									/**	객관식		*/if(as_in_kind_que_gbn == "2"){
										if(as_in_kind_exp_seq == as_in_kind_ans_seq) str += '<input type="radio" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" class="mgr10" checked/><label for="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" class="mgr15">'+as_in_kind_exp_qst+'</label>' ;
										else str += '<input type="radio" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" class="mgr10" /><label for="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" class="mgr15">'+as_in_kind_exp_qst+'</label>' ;
									}
									/**	복수선택	*/else 	if(as_in_kind_que_gbn == "3"){
										if(as_in_kind_ans_etc.indexOf(as_in_kind_exp_seq) != -1) str += '<input type="checkbox" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" class="mgr10" checked/><label for="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" class="mgr15">'+as_in_kind_exp_qst+'</label>' ;
										else str += '<input type="checkbox" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" class="mgr10" /><label for="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" class="mgr15">'+as_in_kind_exp_qst+'</label>' ;
									}
								}else{
									if(as_in_kind_que_gbn_p != "1" || as_in_kind_que_gbn_p != "4") str += '</dd>' ; 			 
									str += '<dt>'+as_in_kind_seq+'. '+as_in_kind_que+'</dt>' ;
									str += '<input type="hidden" name="as_in_kind_que_gbn'+as_in_kind_seq+'" value="'+as_in_kind_que_gbn+'"/>' ;
									str += '<dd>' ; 			
									/**	주관식		*/if(as_in_kind_que_gbn == "1")				str += '<input type="text" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'" title="기타사항 입역" class="write_gray w355" value="'+as_in_kind_ans_etc+'" maxlength="500"/></dd>' ; 
									/**	객관식		*/else 	if(as_in_kind_que_gbn == "2"){
										if(as_in_kind_exp_seq == as_in_kind_ans_seq) str += '<input type="radio" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" class="mgr10" checked/><label for="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" class="mgr15">'+as_in_kind_exp_qst+'</label>' ;
										else str += '<input type="radio" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" class="mgr10" /><label for="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" class="mgr15">'+as_in_kind_exp_qst+'</label>' ;
									}
									/**	복수선택	*/else 	if(as_in_kind_que_gbn == "3"){
										if(as_in_kind_ans_etc.indexOf(as_in_kind_exp_seq) != -1) str += '<input type="checkbox" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" class="mgr10" checked/><label for="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" class="mgr15">'+as_in_kind_exp_qst+'</label>' ;
										else str += '<input type="checkbox" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" value="'+as_in_kind_exp_seq+'" class="mgr10" /><label for="error_'+as_in_kind_seq+'_'+as_in_kind_exp_seq+'" class="mgr15">'+as_in_kind_exp_qst+'</label>' ;
									}
									/**	첨부파일	*/else 	if(as_in_kind_que_gbn == "4"){
										str += '<input type="file" name="error_'+as_in_kind_seq+'"  id="error_'+as_in_kind_seq+'" title="첨부파일" class="write_gray w355"/></dd>' ;
										str += '<input type="hidden" name="p_error_seq'+as_in_kind_seq+'" value="'+as_in_kind_ans_seq+'"/>' ;
									}
								}	
							}
							
							as_in_kind_seq_p = as_in_kind_seq ; 
							as_in_kind_que_gbn_p = as_in_kind_que_gbn ; 
							
							if(i == (resultList.length - 1)){
								str += '</dd>' ;
							}
						}
						
						$('#questionBody').html(str) ;
						$('#questionStrong').show() ;
					}
				}  
			}) ; 
			
			/**	비고 / 첨부파일 처리 - as_in_bigo_	*/
			// data-attach
			$('#as_in_bigo').text($('#as_in_bigo_'+as_in_no ).val()) ;
			
			if($(thisVal).attr('data-attach') != '0'){
				$.ajax({
					type : 'post' ,
					url : '/fr/as/getInfoFile.do' , 
					data : {
						attach_seq : $(thisVal).attr('data-attach') ,  
						is_page_gbn : 'fr'
					} ,
					dataType : 'json' , 
					error : function(xhr , status , error){
						if(common.nvl(error, "") != "") alert(error) ; 
					} , 
					success : function(data){
						var fileList = typeof data.fileList != "undefined" ? data.fileList : null ; 
						if(fileList != null){
							
							var str = '' ; 
							
							for(var i = 0 ; i < fileList.length ; i++){
								var datas = fileList[i] ; 
								
								str += '<a href="javascript:void(0);">'+datas.attach_ori_nm+'</a><button type="button" class="btn_download_blue mgl20" onclick="javascript:fileDown(\''+datas.attach_seq+'\' , \'1\');"><span>다운로드</span></button>' ; 
								
							}
							
							$('#fileList').append(str) ; 
						}
						
					}
				}) ; 
			}
			
			/**	AS_PRG_STATE 버튼 처리 	*/
			var state = $(thisVal).attr('data-stat') ; 
			
			if(state == "0001"){
				$('#btn2').show() ; 
			}
		} , 
		
		proc : function(pageType){
			var f = document.listFrm ; 
			
			f.pageType.value = pageType ; 
			
			if(f.as_in_no.value == ''){
				alert('처리할 A/S를 선택해 주세요.') ; 
				return; 
			}
			
			$.ajax({
				type : 'post' ,
				url : '/fr/as/regist.do' , 
				data : {
					as_in_no : f.as_in_no.value ,  
					is_page_gbn : 'fr'
				} ,
				dataType : 'json' , 
				error : function(xhr , status , error){
					if(common.nvl(error, "") != "") alert(error) ; 
				} , 
				success : function(data){
					var returnCode = typeof data.returnCode != "undefined" ? data.returnCode : "" ; 
					
					if(returnCode == "000"){
						alert("정상적으로 삭제 되었습니다.") ; 
						commonLayer.close();
						as.goList(1);
					}else{
						alert("처리도중 오류가 발생했습니다.") ; 
						return; 
					}
				}
			}) ;
			
		}
		
		
};