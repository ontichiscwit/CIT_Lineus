var join = {
		
		temp1 : "" , 
		temp2 : "" , 
		temp3 : "" , 
		temp4 : "" , 
		
		/**	gbn : 1 사업자 등록 번호 조회 팝업	*/
		showPop : function(gbn){
			
			
			if(gbn == "1"){
				
				join.temp1 = "" ; 
				join.temp2 = "" ; 
				join.temp3 = "" ; 
				join.temp4 = "" ; 
				
				
				commonLayer.init('FRONT_JOIN_CUST_NUMB');
			}else commonLayer.init('FRONT_JOIN_CUST_NUMB_CONFIRM');
		} ,

		/**	회원가입 처리	*/
		goSave : function(){
			var f = document.procFrm ; 
			
			/* 동의 내용 변경 후 적용 170814 - 민지씨 요청 */
			/*if(!$('#agree_terms1').is(':checked')){
				alert("개인정보 수집 이용에 동의해 주세요.") ; 
				return ; 
			}
			
			if(!$('#agree_terms2').is(':checked')){
				alert("서비스 이용약관에 동의해 주세요.") ; 
				return ; 
			}*/
			
			if(common.replaceAll(f.emp_id.value , ' ' , '') == ''){
				alert("소속기관 사업자등록번호 조회를 진행해 주세요.") ; 
				return; 
			}
			
			if(common.replaceAll(f.pass.value , ' ' , '') == ''){
				alert("비밀번호를 입력해 주세요.") ; 
				return; 
			}
			
			if(common.replaceAll(f.passConfirm.value , ' ' , '') == ''){
				alert("비밀번호 재입력을 입력해 주세요.") ; 
				return; 
			}
			
			if(f.pass.value != f.passConfirm.value){
				alert("비밀번호를 다시 확인해 주세요."); 
				return; 
			}
			
			if(!(f.pass.value.length >= 8 && f.pass.value.length <= 12)){
				alert("비밀번호는 8자리 이상 12자리 이하로 입력해 주세요.") ; 
				return; 
			}
			

			if(common.replaceAll(f.emp_name.value , ' ' , '') == ''){
				alert("사용자 이름을 입력해 주세요.") ; 
				return; 
			}
			if(common.replaceAll(f.emp_dept.value , ' ' , '') == ''){
				alert("근무부서를 입력해 주세요.") ; 
				return; 
			}
			
			if(common.replaceAll(f.emp_job.value , ' ' , '') == ''){
				alert("직책을 입력해 주세요.") ; 
				return; 
			}
			
			if(common.replaceAll(f.e_mail1.value , ' ' , '') == ''){
				alert("이메일을 입력해 주세요.") ; 
				return; 
			}
			
			if(common.replaceAll(f.e_mail2.value , ' ' , '') == ''){
				alert("이메일을 입력해 주세요.") ; 
				return; 
			}
			
			f.e_mail.value = f.e_mail1.value + "@" + f.e_mail2.value ; 
			

			if(common.replaceAll($('#phone2').val() , ' ' , '') == ''){
				alert("연락처를 입력해 주세요.") ; 
				return; 
			}
			
			if(common.replaceAll($('#phone3').val() , ' ' , '') == ''){
				alert("연락처를 입력해 주세요.") ; 
				return; 
			}
			
			f.hp_no.value = $('#phone1').val() + "-" + $('#phone2').val() + "-" + $('#phone3').val() ; 
			
			/* 동의 내용 변경 후 적용(데이터는 공백처리) 170814 - 민지씨 요청 */
			//$('#agree_terms1').is(":checked") ? $('#agree_terms1').val('Y') : $('#agree_terms1').val('N');
			//$('#agree_terms2').is(":checked") ? $('#agree_terms2').val('Y') : $('#agree_terms2').val('N');
			
			$('#agree_terms1').val('');
			$('#agree_terms2').val('');
			
			$.ajax({
				type: 'POST',
				url: "/fr/login/regist.do",
				dataType: "json",
				async : false,
				data : $('form[name=procFrm]').serialize() ,
				error : function(xhr , status , error){
					if(common.nvl(error, "") != "") alert(error) ; 
				} , 
				success: function(data) {
					
					var returnCode = data.returnCode != "undefined" ? data.returnCode : null ;
					
					if(returnCode != null){
						if(returnCode == "000") msg = "정상처리 되었습니다.\n승인 완료가 되면 사용 가능 합니다." ; 
						else if(returnCode == "200") msg = "변경할 항목이 없습니다." ; 
						else if(returnCode == "300") msg = "처리된 내역이 없습니다." ; 
						else if(returnCode == "400") msg = "필수 항목이 누락 되어 처리 할 수 없습니다." ; 
						else if(returnCode == "500") msg = "해당 기관의 계정은 이미 가입되어 있습니다.\n 관리자에 문의하세요." ; 
						else if(returnCode == "600") msg = "마스터 계정은 1개만 가능 합니다." ; 
						else msg = "처리 도중 오류가 발생했습니다." ;
					}else msg = "처리 도중 오류가 발생했습니다." ;
					alert(msg) ;
					
					if(returnCode == "000") join.complete() ;
					
				}
			});
			
		} , 
		
		/**	사업자 등록 번호 조회	*/
		searchCust : function(){
			var cust_numb = common.nvl($('#company1').val() , '') ; 
			
			if(cust_numb == ""){
				alert("사업자 등록 번호를 입력해 주세요.") ; 
				return ; 
			}
			
			cust_numb = common.replaceAll(cust_numb , '-' , '') ;
			
			$.ajax({
				type: 'POST',
				url: "/ad/memb/getCustInfoNumb.do",
				dataType: "json",
				async : false,
				data: {
					cust_numb : cust_numb , 
					is_page_gbn : 'fr'
				} ,
				error : function(xhr , status , error){
					if(common.nvl(error, "") != "") alert(error) ; 
				} , 
				success: function(data) {
			 		
					var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null  ; 
					
					commonLayer.close();
					join.showPop('2') ; 
					$('#cust_table1').empty() ;
					
					var str = '' ; 
					
					str += '			<caption>거래처 정보 조회 검색 결과</caption>' ; 
					str += '			<colgroup>' ; 
					str += '				<col style="width:140px;" />' ; 
					str += '				<col style="width:auto;" />' ; 
					str += '			</colgroup>' ; 
					
					if(resultVO != null){
						str += '			<tr>' ; 
						str += '				<th scope="row">사업자등록번호</th>' ; 
						str += '				<td>'+common.nvl(resultVO.cust_numb , '-')+'</td>' ; 
						str += '			</tr>' ; 
						str += '			<tr>' ; 
						str += '				<th scope="row">대표자명</th>' ; 
						str += '				<td>'+common.nvl(resultVO.director , '-')+'</td>' ; 
						str += '			</tr>' ; 
						str += '			<tr>' ; 
						str += '				<th scope="row">기관명</th>' ; 
						str += '				<td>'+common.nvl(resultVO.cust_kor_name , '-')+'</td>' ; 
						str += '			</tr>' ; 
						str += '			<tr>' ; 
						str += '				<th scope="row">주소</th>' ; 
						str += '				<td>'+common.nvl(resultVO.cust_address , '-')+'</td>' ; 
						str += '			</tr>' ; 
						
						join.temp1 = common.nvl(resultVO.cust_numb , '-') ; 
						join.temp2 = common.nvl(resultVO.cust_kor_name , '-') ; 
						join.temp3 = common.nvl(resultVO.cust_address , '-') ; 
						join.temp4 = common.nvl(resultVO.cust_code , '-') ; 
						
					}else{
						str += '			<tr>' ; 
						str += '				<td colspan="2" class="no_results">' ; 
						str += '					검색결과가 없습니다.<br />' ; 
						str += '					고객센터에 문의바랍니다.' ; 
						str += '				</td>' ; 
						str += '			</tr>' ;
					}
					
					$('#cust_table1').append( str ) ;
				}
			});
		} , 
		
		confirmCust : function(){
			if(join.temp4 == ""){
				commonLayer.close();
			}else{
				$('#cust_code').val(join.temp4) ; 
				$('#cust_numb').val(join.temp1) ; 
				$('#cust_kor_name').val(join.temp2) ; 
				$('#cust_address').val(join.temp3) ; 
				$('#emp_id').val(common.replaceAll(join.temp1 , '-' , '') ) ; 
				
				join.temp1 = "" ; 
				join.temp2 = "" ; 
				join.temp3 = "" ; 
				join.temp4 = "" ;
				
				commonLayer.close();
			}
		} , 
		
		reShowPop : function(){
			commonLayer.close();
			join.showPop('1') ; 
		} , 
		
		clearForm : function(){
			join.temp1 = "" ; 
			join.temp2 = "" ; 
			join.temp3 = "" ; 
			join.temp4 = "" ;
			
			document.procFrm.reset() ; 
		},
		
		complete : function(){
			var f = document.procFrm ; 
			
			f.target = "" ; 
			f.action = "/fr/login/complete.do" ;	
			 
			f.submit() ; 
		}
		
};