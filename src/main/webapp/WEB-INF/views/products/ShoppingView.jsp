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

/* 메인 이미지 크기 제한 - 하트 아이콘 오버레이가 정상적으로 보이려면 이미지 크기가 일정해야 함
   (전체 페이지 레이아웃은 별도 담당 파트라 손대지 않고, 이 최소한만 추가) */
#mainProductImage { max-width: 400px; width: 100%; height: auto; display: block; }

/* ===== 상품 이미지 - 관심상품 하트 아이콘 오버레이 / 카트 아이콘 버튼 (내 파트) ===== */
.image-wrap { position: relative; display: inline-block; vertical-align: top; line-height: 0; }

.fav-heart-btn {
    position: absolute;
    top: 10px; right: 10px;
    width: 36px; height: 36px;
    border-radius: 50%;
    border: none;
    background: rgba(255,255,255,0.9);
    box-shadow: 0 1px 4px rgba(0,0,0,0.15);
    display: flex; align-items: center; justify-content: center;
    font-size: 18px; line-height: 1;
    color: #bbb; /* 기본 빈 하트 색 */
    cursor: pointer;
}
.fav-heart-btn.active { color: #e0402e; } /* 담기 완료 시 빨간색으로 채워짐 */

.action-row { display: flex; gap: 10px; max-width: 460px; }

.btn-cart-outline {
    display: inline-flex; align-items: center; gap: 6px;
    background: #fff; color: #222; border: 2px solid #222;
    border-radius: 10px; padding: 12px 20px;
    font-size: 14px; font-weight: 700; cursor: pointer;
}
.btn-cart-outline:hover { background: #f5f5f5; }

.btn-buy-now {
    flex: 1;
    background: #ffd400; color: #222; border: none;
    border-radius: 10px; padding: 12px 24px;
    font-size: 15px; font-weight: 700; cursor: pointer;
}
.btn-buy-now:hover { background: #f5c800; }
.btn-buy-now:disabled { opacity: 0.6; cursor: default; }

/* ===== 장바구니 / 관심상품 담기 안내 토스트 =====
   화면 하단에 떠 있는 어두운 알약 모양 안내창 (사이트 참조 디자인과 동일하게) */
#globalToast {
    display: none;
    position: fixed;
    left: 50%;
    bottom: 24px;
    transform: translateX(-50%);
    align-items: center;
    gap: 8px;
    background: #222;
    color: #fff;
    border-radius: 30px;
    padding: 10px 8px 10px 16px;
    font-size: 13px;
    box-shadow: 0 6px 18px rgba(0,0,0,0.25);
    z-index: 9999;
    white-space: nowrap;
}
#globalToast .toast-icon { font-size: 15px; }
#globalToast .toast-msg { font-weight: 700; margin-right: 4px; }
#globalToast .toast-link {
    display: none;
    color: #ffe08a;
    font-weight: 700;
    text-decoration: none;
    padding: 8px 14px;
    border-radius: 24px;
    background: rgba(255,255,255,0.08);
    margin-left: 4px;
}
#globalToast .toast-link.show { display: inline-block; }
#globalToast .toast-link:hover { background: rgba(255,255,255,0.18); }
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

// 현재 선택된 옵션 (장바구니 담기 시 어떤 옵션(oNo)을 보낼지 판단하는 용도 - 내 파트 신규 추가분)
// 사이즈/색상 선택이 없는 단일옵션 상품이면 기본값으로 첫번째 옵션을 사용
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
        // 장바구니 담기 시 이 옵션(oNo)을 사용하도록 기억 - 내 파트 신규 추가분
        currentOption = matchedOption;

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
        const buyNowBtn = document.getElementById('buyNowBtn');

        if (matchedOption.price === 0 || matchedOption.quantity <= 0) {
            // 품절인 경우
            if (qtySection) qtySection.style.display = 'none';
            if (cartBtn) cartBtn.style.display = 'none'; // 장바구니 버튼 숨김
            if (buyNowBtn) buyNowBtn.style.display = 'none'; // 바로구매 버튼도 함께 숨김
            if (soldOutSection) soldOutSection.style.display = 'block';
        } else {
            // 판매 가능한 경우
            if (qtySection) qtySection.style.display = 'block';
            if (cartBtn) cartBtn.style.display = 'inline-flex'; // 장바구니 버튼 표시
            if (buyNowBtn) buyNowBtn.style.display = 'inline-flex'; // 바로구매 버튼도 함께 표시
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

// ===================================================================
// 아래부터 장바구니 / 관심상품 연동 
// ===================================================================

const productPNo = ${ShoppingView.pno};
let toastTimer = null;

// 수량 +/- 조절 (qtyInput 값만 갱신, 최소 1개)
function changeQty(diff) {
    const input = document.getElementById('qtyInput');
    const current = parseInt(input.value, 10) || 1;
    const next = current + diff;
    if (next < 1) return;
    input.value = next;
}

// 장바구니 담기 - 현재 선택된 옵션(oNo)과 수량을 그대로 서버로 전달.
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

// 바로구매 - 장바구니 페이지를 거치지 않고, 담자마자 받은 caNo로 바로 결제화면으로 이동
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
// 관심상품 토글
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
                // 관심상품에 "추가"된 경우에만 토스트 표시 (해제 시에는 안 띄움)
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

// 화면 하단 공용 토스트 표시 - action이 "cart"면 장바구니 링크만, "favorite"면 관심상품 링크만 보이게 함
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

    if (toastTimer) {
        clearTimeout(toastTimer);
    }
    toastTimer = setTimeout(function () {
        toast.style.display = "none";
    }, 3000);
}
</script>
<meta charset="UTF-8">
<title>${ShoppingView.ptitle}</title>
</head>
<body>
<%@ include file="../hamburger_menu.jsp" %>
<div>
    <div>
        <div>
            <div class="image-wrap">
                <img id="mainProductImage" alt="이미지" src="${pageContext.request.contextPath}/images/products/main/${fn:replace(ShoppingView.option[0].o_main_img, '%', '%25')}">
                <button type="button" id="favoriteBtn" class="fav-heart-btn" onclick="toggleFavorite()">♥</button>
            </div>
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
                <!-- 품절일 때는 두 버튼 모두 함께 숨깁니다. -->
                <button type="button" id="cartBtn" class="btn-cart-outline" onclick="addToCart()" style="display: ${isSoldOut ? 'none' : 'inline-flex'};">🛒 장바구니</button>
                <button type="button" id="buyNowBtn" class="btn-buy-now" onclick="buyNow()" style="display: ${isSoldOut ? 'none' : 'inline-flex'};">바로 구매하기</button>
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

<%-- 담기/찜하기 성공 시 화면 하단에 뜨는 공용 토스트 안내창  --%>
<div id="globalToast">
	<span class="toast-icon"></span>
	<span class="toast-msg"></span>
	<a href="${pageContext.request.contextPath}/cart/list" class="toast-link toast-link-cart">장바구니 보기</a>
	<a href="${pageContext.request.contextPath}/favorite/list" class="toast-link toast-link-fav">관심상품 보기</a>
</div>
</body>
</html>
