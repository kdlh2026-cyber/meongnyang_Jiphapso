<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<style>
.image img {
		width: 80%;
		height: auto;
		max-width: 180px;
	}
</style>
<meta charset="UTF-8">
<title>상품</title>
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
				<div class="btn-row">
					<button type="button" class="btn-cart" onclick="addToCart(${list.pno}, this)">장바구니 담기</button>
					<button type="button" class="btn-favorite" onclick="toggleFavorite(${list.pno}, this)">♥ 관심상품</button>
				</div>
				</td>
			<c:if test="${status.count%4==0}">
				<tr></tr>
			</c:if>
			</c:forEach>
		</tr>
	</table>
<div>
	<a href="#">뒤로가기</a>
</div>

<script>
var contextPath = "${pageContext.request.contextPath}";

function addToCart(pNo, btnEl) {
    btnEl.disabled = true;
    fetch(contextPath + "/cart/add", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ pNo: pNo, oNo: null, quantity: 1 })
    })
        .then(function (res) { return res.json(); })
        .then(function (result) {
            alert(result.message || (result.success ? "장바구니에 담았어요" : "담기에 실패했어요"));
        })
        .catch(function () {
            alert("장바구니 담기 중 오류가 발생했어요.");
        })
        .finally(function () {
            btnEl.disabled = false;
        });
}

// 관심상품 토글 
function toggleFavorite(pNo, btnEl) {
    fetch(contextPath + "/favorite/toggle", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ pNo: pNo })
    })
        .then(function (res) { return res.json(); })
        .then(function (result) {
            if (result.success) {
                btnEl.classList.toggle("active", result.data === true);
            } else {
                alert(result.message || "처리 중 오류가 발생했어요.");
            }
        })
        .catch(function () {
            alert("관심상품 처리 중 오류가 발생했어요.");
        });
}
</script>
</body>
</html>
