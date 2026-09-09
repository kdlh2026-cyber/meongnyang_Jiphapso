<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
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
<script>
// 이미지 경로를 완성하기 위해 contextPath를 자바스크립트 변수로 저장
const contextPath = '${pageContext.request.contextPath}';

// 서버(JSTL)의 옵션 리스트
const options = [
    <c:forEach var="opt" items="${ShoppingView.option}" varStatus="status">
    {
        no: '${opt.o_no}',
        size: '${opt.o_type_size}',
        color: '${opt.o_color}',
        price: ${opt.o_price},
        originPrice: ${not empty opt.o_origin_price ? opt.o_origin_price : 'null'},
        mainImg: '${opt.o_main_img}'
    }${!status.last ? ',' : ''}
    </c:forEach>
];

let selectedSize = null;
let selectedColor = null;

function selectOption(type, value) {
    if (type === 'size') {
        selectedSize = value;
    } else if (type === 'color') {
        selectedColor = value;
    }

    const hasSize = options.some(opt => opt.size && opt.size.trim() !== '');
    const hasColor = options.some(opt => opt.color && opt.color.trim() !== '');

    if (hasSize && hasColor) {
        if (!selectedSize || !selectedColor) {
            return; // 둘 다 선택되지 않았다면 대기
        }
    }

    let matchedOption = options.find(opt => {
        let match = true;
        if (hasSize) match = match && (opt.size === selectedSize);
        if (hasColor) match = match && (opt.color === selectedColor);
        return match;
    });

    // 일치하는 옵션을 찾았을 때 가격 및 이미지 업데이트
    if (matchedOption) {
        // [가격 업데이트]
        const salePriceSpan = document.getElementById('salePriceDisplay');
        const originPriceSpan = document.getElementById('originPriceDisplay');
        
        if (salePriceSpan) {
            salePriceSpan.innerText = matchedOption.price.toLocaleString() + "원";
        }
        if (originPriceSpan && matchedOption.originPrice) {
            originPriceSpan.innerText = matchedOption.originPrice.toLocaleString() + "원";
        }

        // [메인 이미지 업데이트]
        const mainImageEl = document.getElementById('mainProductImage');
        if (mainImageEl && matchedOption.mainImg) {
            mainImageEl.src = contextPath + '/images/products/main/' + matchedOption.mainImg;
        }
    }
}
</script>
<meta charset="UTF-8">
<title>${ShoppingView.ptitle}</title>
</head>
<body>
<div>
    <div>
        <div>
            <img id="mainProductImage" alt="이미지" src="${pageContext.request.contextPath}/images/products/main/${ShoppingView.option[0].o_main_img}">
        </div>
        <div>
            <h1>${ShoppingView.ptitle}</h1>
            
            <div>판매가
                <span id="salePriceDisplay"><fmt:formatNumber value="${ShoppingView.option[0].o_price}" />원</span>
            </div>
            
            <c:if test="${not empty ShoppingView.option[0].o_origin_price and ShoppingView.option[0].o_origin_price ne ShoppingView.option[0].o_price}">
            <div>정가
                <span id="originPriceDisplay"><fmt:formatNumber value="${ShoppingView.option[0].o_origin_price}" />원</span>
            </div>
            </c:if>
            
            <c:if test="${not empty ShoppingView.option[0].o_type_size or not empty ShoppingView.option[0].o_color}">
			<div>선택</div>
			    <c:if test="${not empty ShoppingView.option[0].o_type_size}">
			        <div style="margin-top: 10px;">사이즈</div>
			        <c:set var="uniqueSizes" value="" />
			        <div>
			            <c:forEach var="opt" items="${ShoppingView.option}">
			                <!-- 값 앞뒤에 구분자를 넣어 부분 일치 오류 방지 -->
			                <c:set var="checkSize" value="|${opt.o_type_size}|" />
			                <c:if test="${not fn:contains(uniqueSizes, checkSize)}">
			                    <button onclick="selectOption('size', '${opt.o_type_size}')">
			                        ${opt.o_type_size}
			                    </button>
			                    <!-- 출력한 값을 uniqueSizes 문자열에 누적 -->
			                    <c:set var="uniqueSizes" value="${uniqueSizes}${checkSize}" />
			                </c:if>
			            </c:forEach>
			        </div>
			    </c:if>
			
			    <!-- 색상 중복 제거 출력 -->
			    <c:if test="${not empty ShoppingView.option[0].o_color}">
			        <div style="margin-top: 10px;">색상</div>
			        <c:set var="uniqueColors" value="" />
			        <div>
			            <c:forEach var="opt" items="${ShoppingView.option}">
			                <c:set var="checkColor" value="|${opt.o_color}|" />
			                <c:if test="${not fn:contains(uniqueColors, checkColor)}">
			                    <button onclick="selectOption('color', '${opt.o_color}')">
			                        ${opt.o_color}
			                    </button>
			                    <c:set var="uniqueColors" value="${uniqueColors}${checkColor}" />
			                </c:if>
			            </c:forEach>
			        </div>
			    </c:if>
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