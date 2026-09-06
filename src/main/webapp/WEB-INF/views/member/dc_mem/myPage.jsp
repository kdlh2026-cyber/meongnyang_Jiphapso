<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>멍냥집합소</title>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
	여기는 회원 페이지입니다.<br>
	프로필<br>
		내 프로필(상세 페이지)<br>
		반려동물 프로필(리스트>상세페이지)<br><a href="/member/dc_mem/myPetPage">반려동물</a><br>
	내가 작성한 글(리스트)<br>
	북마크한 글(리스트)<br>
	쇼핑이력(리스트)<br>
	포인트 조회(리스트)<br>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>