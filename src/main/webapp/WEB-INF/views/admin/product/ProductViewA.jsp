<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="/css/product/shoppingview.css">
<title>${ProductView.ptitle}</title>
<script>
const contextPath = '${pageContext.request.contextPath}';

const options = [
    <c:forEach var="opt" items="${ProductView.option}" varStatus="status">
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

let currentOption = options.length > 0 ? options[0] : null;
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
        if (!selectedSize || !selectedColor) return;
    }

    let matchedOption = options.find(opt => {
        let match = true;
        if (hasSize) match = match && (opt.size === selectedSize);
        if (hasColor) match = match && (opt.color === selectedColor);
        return match;
    });

    if (matchedOption) {
        currentOption = matchedOption;

        const salePriceSpan = document.getElementById('salePriceDisplay');
        const originPriceSpan = document.getElementById('originPriceDisplay');
        const qtyInput = document.getElementById('qtyInput');
        
        if (salePriceSpan) salePriceSpan.innerText = matchedOption.price.toLocaleString() + "원";
        if (originPriceSpan && matchedOption.originPrice) originPriceSpan.innerText = matchedOption.originPrice.toLocaleString() + "원";
        if (qtyInput) qtyInput.value = 1;

        const mainImageEl = document.getElementById('mainProductImage');
        if (mainImageEl && matchedOption.mainImg) {
            mainImageEl.src = contextPath + '/images/products/main/' + matchedOption.mainImg;
        }

        const qtySection = document.getElementById('qtySection');
        const soldOutSection = document.getElementById('soldOutSection');
        const cartBtn = document.getElementById('cartBtn');
        const buyNowBtn = document.getElementById('buyNowBtn');

        if (matchedOption.price === 0 || matchedOption.quantity <= 0) {
            if (qtySection) qtySection.style.display = 'none';
            if (cartBtn) cartBtn.style.display = 'none';
            if (buyNowBtn) buyNowBtn.style.display = 'none';
            if (soldOutSection) soldOutSection.style.display = 'block';
        } else {
            if (qtySection) qtySection.style.display = 'block';
            if (cartBtn) cartBtn.style.display = 'inline-flex';
            if (buyNowBtn) buyNowBtn.style.display = 'inline-flex';
            if (soldOutSection) soldOutSection.style.display = 'none';
        }
    }
}

function goToUpdateForm() {
    if (!confirm('이 상품을 수정하시겠습니까?')) return;
    const pNo = productPNo;
    const oNo = (currentOption && currentOption.no) ? currentOption.no : '${ProductView.option[0].o_no}';
    if (!oNo) {
        alert('옵션 정보를 찾을 수 없습니다.');
        return;
    }
    location.href = contextPath + '/ProductUpdateForm?p_no=' + pNo + '&o_no=' + oNo;
}

function showTab(tabName) {
    const productinfo = document.getElementById('productinfo');
    const review = document.getElementById('review');
    const tabInfoBtn = document.getElementById('tabBtn-productinfo');
    const tabReviewBtn = document.getElementById('tabBtn-review');

    if (tabName === 'productinfo') {
        if (productinfo) productinfo.style.display = 'block';
        if (review) review.style.display = 'none';
        if (tabInfoBtn) tabInfoBtn.classList.add('active');
        if (tabReviewBtn) tabReviewBtn.classList.remove('active');
    } else if (tabName === 'review') {
        if (productinfo) productinfo.style.display = 'none';
        if (review) review.style.display = 'block';
        if (tabInfoBtn) tabInfoBtn.classList.remove('active');
        if (tabReviewBtn) tabReviewBtn.classList.add('active');
    }
}

const productPNo = ${ProductView.pno};
let toastTimer = null;

function changeQty(diff) {
    const input = document.getElementById('qtyInput');
    const current = parseInt(input.value, 10) || 1;
    const next = current + diff;

    if (next < 1) return;

    const maxQty = currentOption ? currentOption.quantity : 1;

    if (diff > 0 && next > maxQty) {
        alert("최대 구매 가능한 수량은 " + maxQty + "개입니다.");
        return;
    }

    input.value = next;
}

function addToCart() {
    const btn = document.getElementById('cartBtn');
    const oNo = currentOption ? currentOption.no : null;
    const quantity = parseInt(document.getElementById('qtyInput').value, 10) || 1;

    btn.disabled = true;
    fetch(contextPath + "/cart/add", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ pNo: productPNo, oNo: oNo, quantity: quantity })
    })
    .then(function (res) { return res.json(); })
    .then(function (result) {
        if (result.success) {
            showActionBanner("🛒", result.message || "장바구니에 담았어요", "cart");
        } else {
            alert(result.message || "담기에 실패했어요");
        }
    })
    .catch(function () {
        alert("장바구니 담기 중 오류가 발생했어요.");
    })
    .finally(function () {
        btn.disabled = false;
    });
}

function buyNow() {
    const btn = document.getElementById('buyNowBtn');
    const oNo = currentOption ? currentOption.no : null;
    const quantity = parseInt(document.getElementById('qtyInput').value, 10) || 1;

    btn.disabled = true;
    fetch(contextPath + "/cart/add", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ pNo: productPNo, oNo: oNo, quantity: quantity })
    })
    .then(function (res) { return res.json(); })
    .then(function (result) {
        if (result.success && result.data && result.data.caNo) {
            location.href = contextPath + "/member/order/checkout?caNo=" + result.data.caNo;
        } else {
            btn.disabled = false;
            alert(result.message || "바로구매 처리에 실패했어요.");
        }
    })
    .catch(function () {
        btn.disabled = false;
        alert("바로구매 처리 중 오류가 발생했어요.");
    });
}

function toggleFavorite() {
    const btn = document.getElementById('favoriteBtn');
    fetch(contextPath + "/favorite/toggle", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ pNo: productPNo })
    })
    .then(function (res) { return res.json(); })
    .then(function (result) {
        if (result.success) {
            btn.classList.toggle("active", result.data === true);
            if (result.data === true) {
                showActionBanner("♥", result.message || "관심상품에 담았어요", "favorite");
            }
        } else {
            alert(result.message || "처리 중 오류가 발생했어요.");
        }
    })
    .catch(function () {
        alert("관심상품 처리 중 오류가 발생했어요.");
    });
}

function showActionBanner(icon, message, action) {
    const toast = document.getElementById("globalToast");
    if (!toast) return;

    toast.querySelector(".toast-icon").innerText = icon;
    toast.querySelector(".toast-msg").innerText = message;

    const cartLink = toast.querySelector(".toast-link-cart");
    const favLink = toast.querySelector(".toast-link-fav");
    cartLink.classList.toggle("show", action === "cart");
    favLink.classList.toggle("show", action === "favorite");

    toast.style.display = "flex";

    if (toastTimer) clearTimeout(toastTimer);
    toastTimer = setTimeout(function () {
        toast.style.display = "none";
    }, 3000);
}
</script>
</head>
<body>
<%@ include file="/WEB-INF/views/admin/clone/hamburger_menu.jsp" %>

<div class="detail-container">
    <div class="product-top-section">
        <!-- 1) 좌측: 대표 이미지 -->
        <div class="image-col">
            <div class="image-wrap">
                <img id="mainProductImage" alt="이미지" src="${pageContext.request.contextPath}/images/products/main/${fn:replace(ProductView.option[0].o_main_img, '%', '%25')}">
                <button type="button" id="favoriteBtn" class="fav-heart-btn" onclick="toggleFavorite()">♥</button>
            </div>
        </div>

        <!-- 2) 우측: 정보 및 액션 버튼 -->
        <div class="info-col">
            <div class="product-category-tag">반려용품</div>
            <h1 class="product-title">${ProductView.ptitle}</h1>
            
            <div class="price-box">
                <c:if test="${not empty ProductView.option[0].o_origin_price and ProductView.option[0].o_origin_price ne ProductView.option[0].o_price}">
                    <span class="discount-rate"><fmt:formatNumber value="${((ProductView.option[0].o_origin_price - ProductView.option[0].o_price) / ProductView.option[0].o_origin_price) * 100}" pattern="0" />%</span>
                    <span id="originPriceDisplay" class="origin-price"><fmt:formatNumber value="${ProductView.option[0].o_origin_price}" />원</span>
                </c:if>
                <span id="salePriceDisplay" class="sale-price"><fmt:formatNumber value="${ProductView.option[0].o_price}" />원</span>
            </div>
            
            <div class="product-desc">${ProductView.pcontent}</div>
            
            <!-- 옵션 선택 영역 -->
            <c:if test="${not empty ProductView.option[0].o_type_size or not empty ProductView.option[0].o_color}">
                <c:if test="${not empty ProductView.option[0].o_type_size}">
                    <div class="option-group">
                        <div class="option-label">사이즈</div>
                        <c:set var="uniqueSizes" value="" />
                        <div class="option-btn-wrap">
                            <c:forEach var="opt" items="${ProductView.option}">
                                <c:set var="checkSize" value="|${opt.o_type_size}|" />
                                <c:if test="${not fn:contains(uniqueSizes, checkSize)}">
                                    <button type="button" class="btn-opt" onclick="selectOption('size', '${opt.o_type_size}')">
                                        ${opt.o_type_size}
                                    </button>
                                    <c:set var="uniqueSizes" value="${uniqueSizes}${checkSize}" />
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
                
                <c:if test="${not empty ProductView.option[0].o_color}">
                    <div class="option-group">
                        <div class="option-label">색상</div>
                        <c:set var="uniqueColors" value="" />
                        <div class="option-btn-wrap">
                            <c:forEach var="opt" items="${ProductView.option}">
                                <c:set var="checkColor" value="|${opt.o_color}|" />
                                <c:if test="${not fn:contains(uniqueColors, checkColor)}">
                                    <button type="button" class="btn-opt" onclick="selectOption('color', '${opt.o_color}')">
                                        ${opt.o_color}
                                    </button>
                                    <c:set var="uniqueColors" value="${uniqueColors}${checkColor}" />
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
            </c:if>          
              
            <c:set var="isSoldOut" value="${ProductView.option[0].o_price eq 0 or ProductView.option[0].o_quantity le 0}" />

            <!-- 수량 조절 -->
            <div id="qtySection" class="qty-section" style="display: ${isSoldOut ? 'none' : 'block'};">
                <div class="qty-row">
                    <button type="button" onclick="changeQty(-1)">-</button>
                    <input type="number" id="qtyInput" value="1" min="1" readonly>
                    <button type="button" onclick="changeQty(1)">+</button>
                </div>
            </div>

            <!-- 품절 안내 -->
            <div id="soldOutSection" class="sold-out" style="display: ${isSoldOut ? 'block' : 'none'};">
                품절된 상품입니다.
            </div>

            <!-- 주문 버튼 -->
            <div class="action-row">
                <button type="button" id="cartBtn" class="btn-cart-outline" onclick="addToCart()" style="display: ${isSoldOut ? 'none' : 'inline-flex'};">🛒 장바구니</button>
                <button type="button" id="buyNowBtn" class="btn-buy-now" onclick="buyNow()" style="display: ${isSoldOut ? 'none' : 'inline-flex'};">바로 구매하기</button>
            </div>
            
			<div class="admin-action-row">
			    <button type="button" onclick="goToUpdateForm()" class="btn-opt">상품 수정</button>
			    <button type="button" class="btn-back" onclick="history.back()">목록으로 돌아가기</button>
			</div>
        </div>
    </div>

    <!-- 하단 상품상세 / 리뷰 탭 -->
    <div class="tab-section">
        <div class="tab-nav">
            <button type="button" id="tabBtn-productinfo" class="active" onclick="showTab('productinfo')">상품설명</button>
            <button type="button" id="tabBtn-review" onclick="showTab('review')">리뷰</button>
        </div>
        
        <div id="productinfo" class="tab-content" style="display: block;">
            <div class="image">
                <c:if test="${not empty ProductView.detailImages}">
                    <c:forEach var="detail" items="${ProductView.detailImages}">
                        <img src="${pageContext.request.contextPath}/images/products/info/${detail.img_url}" alt="상세이미지">
                    </c:forEach>
                </c:if>
            </div>
        </div>

        <div id="review" class="tab-content" style="display: none;">
            <div class="review-container">
                <c:if test="${empty reviewList}">
                    <div class="review-empty">
                        등록된 리뷰가 없어요. 첫 리뷰를 남겨보세요!
                    </div>
                </c:if>

                <c:if test="${not empty reviewList}">
                    <!-- 평균 평점 계산 -->
                    <c:set var="totalScore" value="0" />
                    <c:forEach var="r" items="${reviewList}">
                        <c:set var="totalScore" value="${totalScore + r.cmt_score}" />
                    </c:forEach>
                    <c:set var="avgScore" value="${totalScore / fn:length(reviewList)}" />

                    <!-- 상단 평점 요약 헤더 -->
                    <div class="review-summary-header">
                        <div class="star-score">
                            <span class="star-icon">★</span>
                            <span><fmt:formatNumber value="${avgScore}" pattern="0.0"/></span>
                        </div>
                        <span class="divider">·</span>
                        <span class="review-total-count">리뷰 ${fn:length(reviewList)}개</span>
                    </div>

                    <!-- 개별 리뷰 리스트 -->
                    <c:forEach var="rev" items="${reviewList}">
                        <div class="review-item">
                            <div class="review-header-line">
                                <span class="review-stars">
                                    <c:choose>
                                        <c:when test="${rev.cmt_score == 5}">★★★★★</c:when>
                                        <c:when test="${rev.cmt_score == 4}">★★★★☆</c:when>
                                        <c:when test="${rev.cmt_score == 3}">★★★☆☆</c:when>
                                        <c:when test="${rev.cmt_score == 2}">★★☆☆☆</c:when>
                                        <c:otherwise>★☆☆☆☆</c:otherwise>
                                    </c:choose>
                                </span>
                                
                                <span class="review-writer">
                                    <c:choose>
                                        <c:when test="${fn:length(rev.cmt_writer) > 3}">
                                            ${fn:substring(rev.cmt_writer, 0, 3)}****
                                        </c:when>
                                        <c:otherwise>${rev.cmt_writer}****</c:otherwise>
                                    </c:choose>
                                </span>

                                <span class="review-date">
                                    <fmt:formatDate value="${rev.cmt_date}" pattern="yyyy.MM.dd" />
                                </span>
                            </div>

                            <div class="review-body">${rev.cmt_content}</div>

                            <c:if test="${not empty rev.cmt_img}">
                                <div class="review-photo-wrap">
                                    <img src="${pageContext.request.contextPath}/images/reviews/${rev.cmt_img}" alt="리뷰사진">
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>
                </c:if>
            </div>
        </div>
    </div>
</div>

<div id="globalToast">
    <span class="toast-icon"></span>
    <span class="toast-msg"></span>
    <a href="${pageContext.request.contextPath}/cart/list" class="toast-link toast-link-cart">장바구니 보기</a>
    <a href="${pageContext.request.contextPath}/favorite/list" class="toast-link toast-link-fav">관심상품 보기</a>
</div>
<%@ include file="../../footer.jsp" %>
</body>
</html>