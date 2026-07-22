
var ajaxModel = {
		ver : "" ,
		config : {} ,
		datas:null ,
		
		ajax : function(url , setInputData){
			var cfg = this.config 
        	, _this = this;
			_this.setDatas();
			return;
			
			$.ajax({
                type: 'POST',
                url: url,
                dataType: "json",
                data: setInputData,
                success: function(data,status) {
                	var statusMess = '';
                    switch (status)
                    {
                        case 'success':
                            if (data.code !== 200) {
                                statusMess = JSON.stringify(data.message);
                            }
                            else {
                                _this.setDatas(data.result);
                            }
                            break;
                        case 'timeout':
                            statusMess = 'The server did not respond. please try submitting again.';
                        case 'error':
                            statusMess = 'Ann error occured processing your request. Error:' + data;
                            break;
                    }
                    if(statusMess.length > 0){
                        alert(statusMess);
                    }
                }
           });
			
			base.ver = "aaa";
		},
		setDatas: function (obj) {
	        var cfg = this.config 
	        	, _this = this;
	        $(_this).trigger('setDatasBefore');
	        if ($.isArray(obj) || typeof obj === 'object') {
	            //this.allDrop();
	            _this.datas = obj;
	        }else{
	        	_this.datas = null;
	        }
	        _this.ver = "aaa"
	        $(_this).trigger('setDatasAfter',[_this.ver]);
	        _this.setPrint();
	    },
	    setPrint: function (){
	    	
	    }
}








/*
var ajaxModel = {
		
		ver : "" ,
		config : {} ,
		datas:null ,
		
		ajax : function(url , setInputData){
			var cfg = this.config 
        	, _this = this;
			_this.setDatas();
			return;
			
			$.ajax({
                type: 'POST',
                url: url,
                dataType: "json",
                data: setInputData,
                success: function(data,status) {
                	var statusMess = '';
                    switch (status)
                    {
                        case 'success':
                            if (data.code !== 200) {
                                statusMess = JSON.stringify(data.message);
                            }
                            else {
                                _this.setDatas(data.result);
                            }
                            break;
                        case 'timeout':
                            statusMess = 'The server did not respond. please try submitting again.';
                        case 'error':
                            statusMess = 'Ann error occured processing your request. Error:' + data;
                            break;
                    }
                    if(statusMess.length > 0){
                        alert(statusMess);
                    }
                }
           });
			
			base.ver = "aaa";
		},
		setDatas: function (obj) {
	        var cfg = this.config 
	        	, _this = this;
	        $(_this).trigger('setDatasBefore');
	        if ($.isArray(obj) || typeof obj === 'object') {
	            //this.allDrop();
	            _this.datas = obj;
	        }else{
	        	_this.datas = null;
	        }
	        _this.ver = "aaa"
	        $(_this).trigger('setDatasAfter',[_this.ver]);
	        _this.setPrint();
	    },
	    setPrint: function (){
	    	
	    }
}
*/