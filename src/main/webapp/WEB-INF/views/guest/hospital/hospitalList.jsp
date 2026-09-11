<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>동물병원 찾기</title>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
	<h3>동물병원 찾기</h3>
	<p>우리 아이에게 딱 맞는 동물병원을 지역＇진료과목＇진료시간으로 찾아보세요</p>
	<form name="hospitalSearchForm" method="get" action="/hospital_search">
		<input type="text" name="keyword" id="keyword" autocomplete="off">
		<input type="submit" value="검색">
		<div id="suggestions" style="border:1px solid #cccccc;position:absolute;background:white;width:170px;z-index:10">
		</div>
	</form>
	
	
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>