<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>멍냥집합소</title>
<link rel="stylesheet" href="/css/etc/login.css">
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
<div class="login-page">
    <div class="login-card">
        <h2>로그인</h2>
        <form id="loginForm" method="post" action="${pageContext.request.contextPath}/j_spring_security_check">
            <div class="field">
                <label for="m_id">아이디</label>
                <input type="text" id="m_id" name="m_id">
            </div>
            <div class="field">
                <label for="m_passwd">비밀번호</label>
                <input type="password" id="m_passwd" name="m_passwd">
            </div>
            <button type="submit" class="btn-submit">로그인</button>
        </form>
        <div class="helper-links">
           <a href="/memberInsertForm">회원가입</a>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>