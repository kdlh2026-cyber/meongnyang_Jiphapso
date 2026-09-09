<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>통합검색 결과</title>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
		<ul>
			<li>전체</li>
			<li>포스트</li>
			<li>크리에이터즈</li>
			<li>커뮤니티</li>
		</ul>
		<hr>
	<c:if test="${empty MSlist}">
		검색결과가 없습니다.
	</c:if>
	
	<c:forEach var="msl" items="${MSist}">		
		<!-- 커뮤니티 검색결과 표시 영역 -->
	</c:forEach>
	
		<!-- 상품 검색결과 표시 영역 -->
		
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>