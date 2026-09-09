<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>멍냥집합소</title>
</head>
<body>
<%@ include file="/WEB-INF/views/loading_animal.jsp" %>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
<form id="loginForm" method="post" action="${pageContext.request.contextPath}/j_spring_security_check" data-loading>
	<table>
		<tr>
			<td>아이디</td>
			<td><input type="text" name="m_id"></td>
		</tr>
		<tr>
			<td>비밀번호</td>
			<td><input type="password" name="m_passwd"></td>
		</tr>
	</table>
	<p><input type="submit" value="로그인">
</form>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>