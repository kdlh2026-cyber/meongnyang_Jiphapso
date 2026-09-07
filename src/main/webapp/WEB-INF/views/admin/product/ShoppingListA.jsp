<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<script>

</script>
<style>
.image img {
		width: 80%;
		height: auto;
		max-width: 180px;
	}
</style>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h3>상품리스트</h3>
	<table border="1">
		<tr>	
			<c:forEach var="list" items="${ShoppingList}" varStatus="status">
				<td>
				<div class="image"><img src="${pageContext.request.contextPath}/images/products/main/${list.omainimg}"></div>
				<div>${list.pbrand}</div>
				<div><a href="/products/ShoppingView?p_no=${list.pno}">${list.ptitle}</a></div>
				<div><fmt:formatNumber value="${list.oprice}" />원</div>
				<div>
					<button onclick="location.href='/productUpdate?p_no=${list.pno}'">수정</button>
					<button onclick="if(confirm('정말 삭제 하시겠습니까?')){location.href='/productDelete?p_no=${list.pno}';}">삭제</button>
				</div>
				</td>
			<c:if test="${status.count%4==0}">
				<tr></tr>
			</c:if>
			</c:forEach>
		</tr>
		</table>
</body>
</html>