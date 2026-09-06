<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>멍냥집합소</title>
</head>
<body>
<%@ include file="hamburger_menu.jsp" %>
	<hr>
	<h1>메인페이지</h1>
	<img src="/images/image.png" width="300px" height="auto"/><br>
	<a href="/loginForm">로그인</a><br>
	<a href="/memberInsertForm">회원가입</a>
	<!-- 일반 회원 -->
	<sec:authorize access="hasRole('USER')">
			회원님, 환영합니다.<br>
			<a href="/logout">로그아웃</a><br>
	</sec:authorize>
		<!-- 관리자 -->
	<sec:authorize access="hasRole('ADMIN')">
		관리자님, 환영합니다.<br>
		<a href="/logout">로그아웃</a><br>
	</sec:authorize>
<%@ include file="footer.jsp" %>
</body>
</html>