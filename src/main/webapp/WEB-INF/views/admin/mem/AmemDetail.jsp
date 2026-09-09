<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
			<td><img src="/images/myProfile/${memDetail.m_img}" alt="${memDetail.m_img}"></td>
		</tr>
		<tr>
			<td>${memDetail.m_id}</td>
		</tr>
		<tr>
			<td>${memDetail.m_authority}</td>
		</tr>
		<tr>
			<td>${memDetail.m_name}</td>
		</tr>
		<tr>
			<td>${memDetail.m_email}</td>
		</tr>
		<tr>
			<td>${memDetail.m_introduce}</td>
		</tr>
		<tr>
			<td>${memDetail.m_birth}</td>
		</tr>
		<tr>
			<td>SNS 수신 동의 여부: ${memDetail.m_sns}</td>
		</tr>
	</table>
	<a href="#">회원 정보 수정</a> <!-- 회원 아이디(부적절한 경우), 권한(크리에이터), 자기소개(부적절한 경우) 수정 가능 -->
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>