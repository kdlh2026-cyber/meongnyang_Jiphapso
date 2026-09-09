<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<style>
.image {
		width: 80%;
		height: auto;
		max-width: 180px;
	}
</style>
<meta charset="UTF-8">
<title>${ShoppingViewList.ptitle} </title>
</head>
<body>
<div>
	<div>
		<div>
			<img alt="강아지 외장칩" src="${pageContext.request.contextPath}/images/products/main/${ShoppingViewList.omainimg}">
		</div>
		<div>
			<h1>${ShoppingViewList.ptitle}</h1>
			<div>판매가 ${ShoppingViewList.oprice}</div>
			<c:if test="${not empty view.otypesize}">
			<div>
				<div>
					선택
				</div>
				<div>
					<button></button>
            	</div>
			</div>
			</c:if>

			<div class="qty-row">
				<button type="button" onclick="changeQty(-1)">-</button>
				<input type="number" id="qtyInput" value="1" min="1" readonly>
				<button type="button" onclick="changeQty(1)">+</button>
			</div>
			<div class="action-row">
				<button type="button" onclick="addToCart()">장바구니 담기</button>
				<button type="button" id="favoriteBtn" onclick="toggleFavorite()">♥ 관심상품</button>
			</div>

			<div class="image">
				${ShoppingViewList.imgcontent}
			</div>
		</div>
		<div>
			<div>
				<a href="#">상품설명</a>
				<a href="#">리뷰</a>
			</div>
			<div>

			</div>
		</div>
	</div>
</div>

<script>
var contextPath = "${pageContext.request.contextPath}";
var pNo = ${ShoppingViewList.pno}; // 실제 필드명 다르면 여기만 맞추면 됨
var selectedONo = null; // 옵션 버튼 나오면 그쪽에서 이 값 채워주세요><

function changeQty(delta) {
    var input = document.getElementById("qtyInput");
    var next = parseInt(input.value, 10) + delta;
    if (next < 1) next = 1;
    input.value = next;
}

// 장바구니 담기 
function addToCart() {
    var quantity = parseInt(document.getElementById("qtyInput").value, 10);
    fetch(contextPath + "/cart/add", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ pNo: pNo, oNo: selectedONo, quantity: quantity })
    })
        .then(function (res) { return res.json(); })
        .then(function (result) {
            alert(result.message || (result.success ? "장바구니에 담았어요" : "담기에 실패했어요"));
        })
        .catch(function () {
            alert("장바구니 담기 중 오류가 발생했어요.");
        });
}

// 관심상품 토글 
function toggleFavorite() {
    fetch(contextPath + "/favorite/toggle", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ pNo: pNo })
    })
        .then(function (res) { return res.json(); })
        .then(function (result) {
            if (result.success) {
                document.getElementById("favoriteBtn").classList.toggle("active", result.data === true);
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
