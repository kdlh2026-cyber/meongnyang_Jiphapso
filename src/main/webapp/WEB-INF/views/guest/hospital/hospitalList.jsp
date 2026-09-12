<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>동물병원 찾기</title>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
	<h3>동물병원 찾기</h3>
	<p>우리 아이에게 딱 맞는 동물병원을 이름ㆍ주소ㆍ키워드로 찾아보세요</p>
	<form name="hospitalSearchForm" method="get" action="/hospital_search">
		<input type="text" name="keyword" id="keyword" value="${param.keyword}" autocomplete="off">
		<input type="submit" value="검색">
		<div id="suggestions" style="border:1px solid #cccccc;position:absolute;background:white;width:170px;z-index:10">
		</div>
	</form>

	<div>전체 ${totalCount}곳</div>

	<c:if test="${empty hospitalList}">
		<p>등록된 병원이 없습니다.</p>
	</c:if>

	<table border="1" width="700">
		<c:forEach var="hp" items="${hospitalList}">
			<tr>
				<td>
					<a href="/hospitalView?hp_no=${hp.hp_no}">${hp.hp_name}</a>
				</td>
				<td>${hp.hp_addr}</td>
				<td>${hp.hp_tel}</td>
			</tr>
		</c:forEach>
	</table>

	<div class="pagination">
		<a href="/guest/hospital/hospitalList?keyword=${param.keyword}&page=${pageNum > 1 ? pageNum - 1 : 1}">PREV</a>

		<c:forEach var="i" begin="1" end="${totalPages}">
			<a href="/guest/hospital/hospitalList?keyword=${param.keyword}&page=${i}"
			   class="${pageNum eq i ? 'active' : ''}">${i}</a>
		</c:forEach>

		<a href="/guest/hospital/hospitalList?keyword=${param.keyword}&page=${pageNum < totalPages ? pageNum + 1 : totalPages}">NEXT</a>
	</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>