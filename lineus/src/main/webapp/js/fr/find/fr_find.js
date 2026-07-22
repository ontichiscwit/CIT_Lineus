var find = {
		
		pageGbn : "1" , 					/**	1 : ID 찾기 / 2 : 비밀번호 찾기	*/
		pathGbn : "" , 
		
		moveTab : function(pageGbn){
			
			$('#idAnswer1').hide() ; 
			$('#idAnswer2').hide() ;
			$('#formTable').show() ; 
			$('#formBtn').show() ;
			
			document.procFrm.reset() ; 
			
			if(pageGbn == "1"){
				if(!$('#li1').hasClass('active')) $('#li1').addClass('active') ; 
				if($('#li2').hasClass('active')) $('#li2').removeClass('active') ; 
				
				$('#tab2Tr').hide() ;
				$('#emp_id').val('') ;
				
				$('#conBtn').html('아이디 찾기') ; 
				
			}else{
				if($('#li1').hasClass('active')) $('#li1').removeClass('active') ; 
				if(!$('#li2').hasClass('active')) $('#li2').addClass('active') ;
				
				$('#tab2Tr').show() ;
				
				$('#conBtn').html('비밀번호 찾기') ;
			}
			
			find.pageGbn = pageGbn ; 
			
		} , 
		
		goFind : function(){
			var f = document.procFrm ; 
			
			if(find.pageGbn != "1"){
				if(common.isEmpty(common.replaceAll(f.emp_id.value , ' ' , ''))){
					alert("아이디를 입력해 주세요.") ; 
					return ; 
				}
			}
			
			if(common.isEmpty(common.replaceAll(f.emp_name.value , ' ' , ''))){
				alert("사용자 이름을 입력해 주세요.") ; 
				return ; 
			}
			
			if(common.isEmpty(common.replaceAll(f.e_mail1.value , ' ' , ''))){
				alert("이메일을 입력해 주세요.") ; 
				return ; 
			}
			
			if(common.isEmpty(common.replaceAll(f.e_mail2.value , ' ' , ''))){
				alert("이메일을 입력해 주세요.") ; 
				return ; 
			}
			
			f.e_mail.value = f.e_mail1.value + "@" + f.e_mail2.value ; 
			f.pageType.value = find.pageGbn ;
			
			$.ajax({
				type: 'POST',
				url: "/fr/login/procFind.do",
				dataType: "json",
				async : false,
				data : $('form[name=procFrm]').serialize() ,
				error : function(xhr , status , error){
					if(common.nvl(error, "") != "") alert(error) ; 
				} , 
				success: function(data) {
					var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null ; 
					
					var emp_id = "" ; 
					
					if(resultVO != null) emp_id = common.nvl(resultVO.emp_id , '') ; 
					
					$('#idAnswer1').show() ; 
					$('#idAnswer2').show() ;
					
					$('#formTable').hide() ; 
					$('#formBtn').hide() ;
					
					if(find.pageGbn == "1"){
						if(emp_id != ""){
							$('#idAnswer1_str1').html('입력하신 정보와 일치하는 ID 는 다음과 같습니다.<br/><span class="colorBlue">'+emp_id+'</span>') ; 
							$('#joinBtn').hide() ;
						}else{
							$('#idAnswer1_str1').html('입력하신 정보와 일치하는 아이디 또는 패스워드가 없습니다. <br/><span class="colorBlue">JW Conneted Care System 을 이용하시려면<br/>회원가입을 해주세요.</span>') ; 
							$('#joinBtn').show() ; 
						}
					}else{
						if(emp_id == ""){
							$('#idAnswer1_str1').html('입력하신 정보와 일치하는 아이디 또는 패스워드가 없습니다. <br/><span class="colorBlue">JW Conneted Care System 을 이용하시려면<br/>회원가입을 해주세요.</span>') ; 
							$('#joinBtn').show() ;
						}else{
							if(emp_id != f.emp_id.value){
								$('#idAnswer1_str1').html('입력하신 정보와 일치하는 아이디 또는 패스워드가 없습니다. <br/><span class="colorBlue">JW Conneted Care System 을 이용하시려면<br/>회원가입을 해주세요.</span>') ; 
								$('#joinBtn').show() ;
							}else{
								$('#idAnswer1').hide() ; 
								$('#idAnswer2').hide() ;
								
								$('#formTable').show() ; 
								$('#formBtn').show() ;
								$('#layerForm2').show() ; 
								$('#div2').show() ;
							}
						}
					}
				}
			});
		} , 
		
		joinPage : function(){
			var f = document.procFrm ; 
			
			f.target = "" ; 
			f.action = "/fr/login/join.do" ;	
			 
			f.submit() ; 
		} , 
		
		loginPage : function(){
			var f = document.procFrm ; 
			
			f.target = "" ; 
			f.action = "/fr/login/form.do" ;	
			 
			f.submit() ; 
		} , 
		
		setPageGbn : function(pageGbn){
			find.pageGbn = pageGbn ; 
			if(pageGbn == "1"){
				$('#emp_name1').val('') ;
				$('#e_mail1').val('') ;
			}else{
				$('#emp_id2').val('') ;
				$('#emp_name2').val('') ;
				$('#e_mail2').val('') ;
			}
			
		} , 
		
		idSearch : function(){
			if(common.replaceAll($('#emp_name1').val(), ' ' , '') == ""){
				alert("이름을 입력해 주세요.") ; 
				return; 
			}
			
			if(common.replaceAll($('#e_mail1').val(), ' ' , '') == ""){
				alert("이메일을 입력해 주세요.") ; 
				return ; 
			}
			
			$.ajax({
				type: 'POST',
				url: "/fr/login/procFind.do",
				dataType: "json",
				async : false,
				data : {
					emp_name : $('#emp_name1').val() , 
					e_mail : $('#e_mail1').val() , 
					pageType : "1" 
				} ,
				error : function(xhr , status , error){
					if(common.nvl(error, "") != "") alert(error) ; 
				} , 
				success: function(data) {
					var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null ; 
					
					var emp_id = "" ; 
					
					if(resultVO != null) emp_id = common.nvl(resultVO.emp_id , '') ; 
					
					if(emp_id != ""){
						$('#findId').val(emp_id) ; 
						$('#saveBtn').click();
					}else{
						$('#failBtn').click();
					}
					
				}
			});
		} , 
		
		pwSearch : function(){
			if(common.replaceAll($('#emp_id2').val(), ' ' , '') == ""){
				alert("아이디를 입력해 주세요.") ; 
				return; 
			}
			if(common.replaceAll($('#emp_name2').val(), ' ' , '') == ""){
				alert("이름을 입력해 주세요.") ; 
				return; 
			}
			
			if(common.replaceAll($('#e_mail2').val(), ' ' , '') == ""){
				alert("이메일을 입력해 주세요.") ; 
				return ; 
			}
			
			$.ajax({
				type: 'POST',
				url: "/fr/login/procFind.do",
				dataType: "json",
				async : false,
				data : {
					emp_name : $('#emp_name2').val() , 
					e_mail : $('#e_mail2').val() , 
					pageType : "2" 
				} ,
				error : function(xhr , status , error){
					if(common.nvl(error, "") != "") alert(error) ; 
				} , 
				success: function(data) {
					var resultVO = typeof data.resultVO != "undefined" ? data.resultVO : null ; 
					
					var emp_id = "" ; 
					
					if(resultVO != null) emp_id = common.nvl(resultVO.emp_id , '') ; 
					
					if(emp_id != ""){
						if($('#emp_id2').val() != emp_id) $('#pwFailBtn').click();
						else $('#pwBtn').click();
					}else{
						$('#pwFailBtn').click();
					}
					
				}
			});
			
			
		} , 
		
		goCancel : function(){
			$('#layerForm2').hide() ; 
			$('#div2').hide() ;
		} , 
		
		/**	비밀번호 변경	*/
		changePass : function(){
			
			var f = document.procFrm ; 
			
			if(common.replaceAll($('#pass').val() , ' ' , '') == ''){
				alert("비밀번호를 입력해 주세요.") ; 
				return; 
			}
			if(common.replaceAll($('#conPass').val() , ' ' , '') == ''){
				alert("비밀번호를 입력해 주세요.") ; 
				return; 
			}
			
			if($('#pass').val() != $('#conPass').val()){
				alert("비밀번호를 다시 확인해 주세요.") ; 
				return; 
			}
			
			if(!($('#pass').val().length >= 8 && $('#pass').val().length <= 12)){
				alert("비밀번호는 8자리 이상 12자리 이하로 입력해 주세요.") ; 
				return; 
			}
			
			f.pageType.value = "passChange" ; 
			
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
						if(returnCode == "000") msg = "비밀번호가 변경되었습니다.\n로그인 화면으로 이동합니다." ; 
						else if(returnCode == "100") msg = "비밀번호 정보가 올바르지 않습니다." ; 
						else if(returnCode == "200") msg = "변경할 항목이 없습니다." ; 
						else if(returnCode == "300") msg = "처리된 내역이 없습니다." ; 
						else if(returnCode == "400") msg = "필수 항목이 누락 되어 처리 할 수 없습니다." ; 
						else if(returnCode == "500") msg = "해당 기관의 계정은 이미 가입되어 있습니다.\n 관리자에 문의하세요." ; 
						else if(returnCode == "600") msg = "마스터 계정은 1개만 가능 합니다." ; 
						else msg = "처리 도중 오류가 발생했습니다." ;
					}else msg = "처리 도중 오류가 발생했습니다." ;
					alert(msg) ;
					
					if(returnCode == "000") find.complete() ;
					
				}
			});
		} , 
		
		mdPassChange : function(){
			
			if(common.replaceAll($('#pass').val() , ' ' , '') == ''){
				alert("비밀번호를 입력해 주세요.") ; 
				return; 
			}
			if(common.replaceAll($('#conPass').val() , ' ' , '') == ''){
				alert("비밀번호를 입력해 주세요.") ; 
				return; 
			}
			
			if($('#pass').val() != $('#conPass').val()){
				alert("비밀번호를 다시 확인해 주세요.") ; 
				return; 
			}
			
			if(!($('#pass').val().length >= 8 && $('#pass').val().length <= 12)){
				alert("비밀번호는 8자리 이상 12자리 이하로 입력해 주세요.") ; 
				return; 
			}
			
			$.ajax({
				type: 'POST',
				url: "/fr/login/regist.do",
				dataType: "json",
				async : false,
				data : {
					pageType : "passChange" , 
					emp_id : $('#emp_id2').val() ,  
					pass : $('#pass').val()
				},
				error : function(xhr , status , error){
					if(common.nvl(error, "") != "") alert(error) ; 
				} , 
				success: function(data) {
					
					var returnCode = data.returnCode != "undefined" ? data.returnCode : null ;
					
					if(returnCode != null){
						if(returnCode == "000") msg = "비밀번호가 변경되었습니다.\n로그인 화면으로 이동합니다." ; 
						else if(returnCode == "100") msg = "비밀번호 정보가 올바르지 않습니다." ; 
						else if(returnCode == "200") msg = "변경할 항목이 없습니다." ; 
						else if(returnCode == "300") msg = "처리된 내역이 없습니다." ; 
						else if(returnCode == "400") msg = "필수 항목이 누락 되어 처리 할 수 없습니다." ; 
						else if(returnCode == "500") msg = "해당 기관의 계정은 이미 가입되어 있습니다.\n 관리자에 문의하세요." ; 
						else if(returnCode == "600") msg = "마스터 계정은 1개만 가능 합니다." ; 
						else msg = "처리 도중 오류가 발생했습니다." ;
					}else msg = "처리 도중 오류가 발생했습니다." ;
					alert(msg) ;
					
					if(returnCode == "000") find.loginPage() ;
					
				}
			});
		} , 
		
		complete : function(){
			var f = document.procFrm ; 
			
			f.target = "" ; 
			f.action = "/fr/login/form.do" ;	
			 
			f.submit() ; 
		}
};