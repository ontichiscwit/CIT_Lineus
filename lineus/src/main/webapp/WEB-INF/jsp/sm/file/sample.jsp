<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<html>
  <head>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
    
		google.charts.load('current', {'packages':['corechart']});
		google.charts.setOnLoadCallback(drawChart);

		function drawChart() {
			var data = google.visualization.arrayToDataTable([
				['Month', 'CSM1팀', 'CSM2팀'],
				['2017/07',  0 , 0],
			]);

			var options = {
				title: '구분코드 통계',
				legend: { position: 'right' },
				bar : {
					groupWidth : '20%' // 예제에서 이 값을 수정
				},
			};

			var chart = new google.visualization.LineChart(document.getElementById('curve_chart'));
			chart.draw(data, options);
		}
  
		google.charts.load('current', {'packages':['bar']});
		google.charts.setOnLoadCallback(drawChart2);

		function drawChart2() {
			var data = google.visualization.arrayToDataTable([
				['Application', 'CSM1팀', 'CSM2팀', 'CSM3팀', '민지팀1', '민지팀2', '민지팀3', '민지팀4', '민지팀5', '민지팀6'],
				['MRI', 1, 2, 1, 2, 3, 4, 5, 6, 7],
				['CT', 3, 9, 3, 2, 3, 4, 5, 6, 7],
				['X-Ray', 3, 2, 2, 2, 3, 4, 5, 6, 7],
				['RF X-Ray', 3, 1, 7, 2, 33, 4, 5, 6, 7],
				['M X-Ray', 2, 11, 7, 2, 3, 4, 5, 46, 7],
				['Mammo', 3, 14, 7, 2, 3, 4, 5, 6, 7],
				['국산 X-Ray', 9, 16, 7, 2, 3, 4, 5, 6, 7],
				['초음파', 3, 20, 7, 2, 3, 4, 25, 6, 7],
				['내시경', 3, 1, 7, 2, 3, 4, 5, 6, 7]
			]);

		var options = {
			chart: {
				title: 'A/S 처리시간 통계',
				subtitle: '',
			}
		};

		var chart = new google.charts.Bar(document.getElementById('columnchart_material'));
		chart.draw(data, google.charts.Bar.convertOptions(options));
		}
		
		function goMail(){
			$.ajax({
				type			: 'POST',
				url				: "/sm/test/mailSend.do",
				dataType	: "json",
				data			: {} ,
				success: function(data) {
		 			alert(data.returnValue) ; 
				}
			});
		}
		
</script>
</head>
<body>
	<a href="javascript:goMail();"><h1>메일 발송 테스트</h1></a>
	<div id="curve_chart" style="width: 1000px; height: 500px"></div>
	<div id="columnchart_material" style="width: 1000px; height: 500px; margin-left:100px;"></div>
</body>
</html>