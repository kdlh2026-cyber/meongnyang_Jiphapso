<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
	<table>
		<tr>
			<th>아이디</th>
			<th>이름</th>
			<th>이메일 주소</th>
			<th>가입일</th>
			<th>14세 이상</th>
			<th>SNS 수신 동의</th>
		</tr>
		<c:forEach var="list" items="${memberList}">
		<tr>
			<td>${list.m_id}</td>
			<td>${list.m_name}</td>
			<td>${list.m_email}</td>
			<td>${list.m_date}</td>
			<td>${list.m_age_upper}</td>
			<td>${list.m_sns}</td>
			<td>
				<button type="button" onclick="#">삭제</button>
			</td>
		</tr>
		</c:forEach>
	</table>
	<a href="/member/myPage/myPetList">목록</a>
	<a href="/member/myPage/myPage">마이페이지</a>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>