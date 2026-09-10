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
.sold-out {
    color: red;
    font-weight: bold;
    margin: 10px 0;
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
        mainImg: '${opt.o_main_img}',
        quantity: ${opt.o_quantity}
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

    // 일치하는 옵션을 찾았을 때 가격, 이미지 및 품절 상태 업데이트
    if (matchedOption) {
        // 가격 업데이트
        const salePriceSpan = document.getElementById('salePriceDisplay');
        const originPriceSpan = document.getElementById('originPriceDisplay');
        
        if (salePriceSpan) {
            salePriceSpan.innerText = matchedOption.price.toLocaleString() + "원";
        }
        if (originPriceSpan && matchedOption.originPrice) {
            originPriceSpan.innerText = matchedOption.originPrice.toLocaleString() + "원";
        }

        // 메인 이미지
        const mainImageEl = document.getElementById('mainProductImage');
        if (mainImageEl && matchedOption.mainImg) {
            mainImageEl.src = contextPath + '/images/products/main/' + matchedOption.mainImg;
        }

        const qtySection = document.getElementById('qtySection');
        const soldOutSection = document.getElementById('soldOutSection');
        const cartBtn = document.getElementById('cartBtn');

        if (matchedOption.price === 0 || matchedOption.quantity <= 0) {
            // 품절인 경우
            if (qtySection) qtySection.style.display = 'none';
            if (cartBtn) cartBtn.style.display = 'none'; // 장바구니 버튼 숨김
            if (soldOutSection) soldOutSection.style.display = 'block';
        } else {
            // 판매 가능한 경우
            if (qtySection) qtySection.style.display = 'block';
            if (cartBtn) cartBtn.style.display = 'inline-block'; // 장바구니 버튼 표시
            if (soldOutSection) soldOutSection.style.display = 'none';
        }
    }
}

function showTab(tabName) {
    const productinfo = document.getElementById('productinfo');
    const review = document.getElementById('review');

    if (tabName === 'productinfo') {
        productinfo.style.display = 'block';
        review.style.display = 'none';
    } else if (tabName === 'review') {
    	productinfo.style.display = 'none';
    	review.style.display = 'block';
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
            <img id="mainProductImage" alt="이미지" src="${pageContext.request.contextPath}/images/products/main/${fn:replace(ShoppingView.option[0].o_main_img, '%', '%25')}">
        </div>
        <div>
            <h1>${ShoppingView.ptitle}</h1>
            
            <div>판매가
                <span id="salePriceDisplay"><fmt:formatNumber value="${ShoppingView.option[0].o_price}" />원</span>
            </div>
            
            <c:if test="${not empty ShoppingView.option[0].o_origin_price and ShoppingView.option[0].o_origin_price ne ShoppingView.option[0].o_price}">
            <div><span><fmt:formatNumber value="${((ShoppingView.option[0].o_origin_price - ShoppingView.option[0].o_price) / ShoppingView.option[0].o_origin_price) * 100}" pattern="0" />%</span>
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
			                <c:set var="checkSize" value="|${opt.o_type_size}|" />
			                <c:if test="${not fn:contains(uniqueSizes, checkSize)}">
			                    <button onclick="selectOption('size', '${opt.o_type_size}')">
			                        ${opt.o_type_size}
			                    </button>
			                    <c:set var="uniqueSizes" value="${uniqueSizes}${checkSize}" />
			                </c:if>
			            </c:forEach>
			        </div>
			    </c:if>
			    
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
            
            <c:forEach var="content" items="${ShoppingView.detailImages}">
                <c:if test="${content.img_sort==1}">
                    ${content.img_content} 
                </c:if>
            </c:forEach>

            <%-- 페이지 최초 로드 시 첫번째 옵션의 품절 여부를 판별하여 초기 화면 세팅 --%>
            <c:set var="isSoldOut" value="${ShoppingView.option[0].o_price eq 0 or ShoppingView.option[0].o_quantity le 0}" />

            <!-- 수량 조절 UI (품절일 시 숨김) -->
            <div id="qtySection" style="display: ${isSoldOut ? 'none' : 'block'};">
                <div class="qty-row">
                    <button type="button" onclick="changeQty(-1)">-</button>
                    <input type="number" id="qtyInput" value="1" min="1" readonly>
                    <button type="button" onclick="changeQty(1)">+</button>
                </div>
            </div>

            <!-- 품절 텍스트 UI (품절이 아닐 시 숨김) -->
            <div id="soldOutSection" class="sold-out" style="display: ${isSoldOut ? 'block' : 'none'};">
                품절
            </div>

            <div class="action-row">
                <!-- 품절일 때는 장바구니 버튼도 함께 숨깁니다. -->
                <button type="button" id="cartBtn" onclick="addToCart()" style="display: ${isSoldOut ? 'none' : 'inline-block'};">장바구니 담기</button>
                <button type="button" id="favoriteBtn" onclick="toggleFavorite()">♥ 관심상품</button>
            </div>
        </div>
        
        <div>
		    <div>
		        <button type="button" onclick="showTab('productinfo')">상품설명</button>
		        <button type="button" onclick="showTab('review')">리뷰</button>
		    </div>
		    
		    <div id="productinfo" class="tab-content" style="display: block;">
		        <div class="image">
		            <c:if test="${not empty ShoppingView.detailImages}">
		                <c:forEach var="detail" items="${ShoppingView.detailImages}">
		                    <img src="${pageContext.request.contextPath}/images/products/info/${detail.img_url}">
		                </c:forEach>
		            </c:if>
		        </div>
		    </div>
		
		    <div id="review" class="tab-content" style="display: none;">
		        <div class="review-list">
		        
		        </div>
		    </div>
		</div>
    </div>
<div>
    <a href="javascript:history.back();">뒤로가기</a>
</div>
</div>
</body>
</html>