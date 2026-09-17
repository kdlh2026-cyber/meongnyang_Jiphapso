<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="/css/product/shoppinglist.css">
<script>
document.addEventListener("DOMContentLoaded", function() {
    const product_size = 10; // 스크롤 시 추가로 노출할 개수
    const sentinel = document.getElementById("scrollSentinel");

    function revealNextBatch() {
        const hiddenCards = document.querySelectorAll(".product-card.is-hidden");
        if (hiddenCards.length === 0) {
            if (observer && sentinel) observer.unobserve(sentinel);
            return;
        }

        // 최대 10개씩 숨김 해제
        const limit = Math.min(product_size, hiddenCards.length);
        for (let i = 0; i < limit; i++) {
            hiddenCards[i].classList.remove("is-hidden");
        }
    }

    // 바닥 감지 설정
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                revealNextBatch();
            }
        });
    }, {
        rootMargin: "200px" // 바닥에 닿기 200px 전에 미리 다음 10개를 불러와 부드럽게 연결
    });

    if (sentinel) {
        observer.observe(sentinel);
    }
});
</script>
<c:set var="currentType" value="${empty param.p_type ? '강아지' : param.p_type}" />
<title>${currentType} ${param.mode} 추천 | 쇼핑리스트</title>
</head>
<body>
<%@ include file="../hamburger_menu.jsp" %>
<div class="shop-container">
    <!-- 강아지 / 고양이 선택 탭 -->
    <div class="type-btn-wrap">
        <div class="type-btn">
            <button type="button" class="${currentType eq '강아지' ? 'active' : ''}" onclick="location.href='?p_type=강아지'">
                <img src="${pageContext.request.contextPath}/images/products/menu/dog_head.png" alt="강아지">
                <span>강아지</span>
            </button>
            <button type="button" class="${currentType eq '고양이' ? 'active' : ''}" onclick="location.href='?p_type=고양이'">
                <img src="${pageContext.request.contextPath}/images/products/menu/cat_head.png" alt="고양이">
                <span>고양이</span>
            </button>
        </div>
    </div>

    <!-- 중앙 검색창 -->
    <div class="search-section">
        <div class="search-wrapper">
            <form name="p_search" method="get" action="/products/ShoppingList" class="search-input-box">
                <input type="hidden" name="p_type" value="${currentType}">
                <input type="text" name="keyword" id="keyword" autocomplete="off" placeholder="쇼핑 검색">
                <button type="submit">🔍</button>
            </form>
            <div id="suggestions" style="display:none;"></div>
        </div>
    </div>

    <!-- 카테고리 버튼 슬라이더 -->
    <c:if test="${currentType eq '강아지'}">
    <div class="category-btn">
        <button onclick="location.href='?p_type=강아지'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/toebeans-all.png"></div>
            <span class="category-name">전체</span>
        </button>
        <button onclick="location.href='?p_type=강아지&mode=간식'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/menu-dog-teats.png"></div>
            <span class="category-name">간식</span>
        </button>
        <button onclick="location.href='?p_type=강아지&mode=매트'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/menu-dog-mat.png"></div>
            <span class="category-name">매트</span>
        </button>
        <button onclick="location.href='?p_type=강아지&mode=사료'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/menu-dog-food.png"></div>
            <span class="category-name">사료</span>
        </button>
        <button onclick="location.href='?p_type=강아지&mode=식기'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/menu-dog-bowl.png"></div>
            <span class="category-name">식기</span>
        </button>
        <button onclick="location.href='?p_type=강아지&mode=영양제'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/menu-dog-drug.png"></div>
            <span class="category-name">영양제</span>
        </button>
        <button onclick="location.href='?p_type=강아지&mode=위생'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/meun-dog-hy-products.png"></div>
            <span class="category-name">위생</span>
        </button>
        <button onclick="location.href='?p_type=강아지&mode=이동장'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/menu-dog-cage.png"></div>
            <span class="category-name">이동장</span>
        </button>
        <button onclick="location.href='?p_type=강아지&mode=장난감'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/menu-dog-toy.png"></div>
            <span class="category-name">장난감</span>
        </button>
        <button onclick="location.href='?p_type=강아지&mode=집/하우스'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/menu-dog-house.png"></div>
            <span class="category-name">집/하우스</span>
        </button>
        <button onclick="location.href='?p_type=강아지&mode=패션'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/menu-dog-fashion.png"></div>
            <span class="category-name">패션</span>
        </button>
        <button onclick="location.href='?p_type=강아지&mode=펫가전'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/menu-dog-robot.png"></div>
            <span class="category-name">펫가전</span>
        </button>
        <button onclick="location.href='?p_type=강아지&mode=하네스/줄'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/menu-dog-harness.png"></div>
            <span class="category-name">하네스/줄</span>
        </button>
        <button onclick="location.href='?p_type=강아지&mode=해충방지'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/menu-dog-bug.png"></div>
            <span class="category-name">해충방지</span>
        </button>
    </div>
    </c:if>

   <c:if test="${currentType eq '고양이'}">
    <div class="category-btn">
        <button onclick="location.href='?p_type=고양이'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/toebeans-all.png"></div>
            <span class="category-name">전체</span>
        </button>
        <button onclick="location.href='?p_type=고양이&mode=간식'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/menu-cat-treat.png"></div>
            <span class="category-name">간식</span>
        </button>
        <button onclick="location.href='?p_type=고양이&mode=모래'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/menu-cat-sand.jpg"></div>
            <span class="category-name">모래</span>
        </button>
        <button onclick="location.href='?p_type=고양이&mode=사료'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/menu-cat-food.png"></div>
            <span class="category-name">사료</span>
        </button>
        <button onclick="location.href='?p_type=고양이&mode=스크래쳐'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/menu-cat-scratch.png"></div>
            <span class="category-name">스크래쳐</span>
        </button>
        <button onclick="location.href='?p_type=고양이&mode=식기'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/menu-cat-bowl.png"></div>
            <span class="category-name">식기</span>
        </button>
        <button onclick="location.href='?p_type=고양이&mode=영양제'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/menu-cat-drug.png"></div>
            <span class="category-name">영양제</span>
        </button>
        <button onclick="location.href='?p_type=고양이&mode=위생'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/menu-cat-hy-products.png"></div>
            <span class="category-name">위생</span>
        </button>
        <button onclick="location.href='?p_type=고양이&mode=이동장'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/menu-cat-cage.png"></div>
            <span class="category-name">이동장</span>
        </button>
        <button onclick="location.href='?p_type=고양이&mode=장난감'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/menu-cat-toy.png"></div>
            <span class="category-name">장난감</span>
        </button>
        <button onclick="location.href='?p_type=고양이&mode=집/하우스'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/menu-cat-house.png"></div>
            <span class="category-name">집/하우스</span>
        </button>
        <button onclick="location.href='?p_type=고양이&mode=캣타워/캣폴'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/menu-cat-tower.png"></div>
            <span class="category-name">캣타워/캣폴</span>
        </button>
        <button onclick="location.href='?p_type=고양이&mode=캣휠'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/menu-cat-wheel.png"></div>
            <span class="category-name">캣휠</span>
        </button>
        <button onclick="location.href='?p_type=고양이&mode=패션'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/menu-cat-fashion.png"></div>
            <span class="category-name">패션</span>
        </button>
        <button onclick="location.href='?p_type=고양이&mode=펫가전'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/menu-cat-robot.png"></div>
            <span class="category-name">펫가전</span>
        </button>
        <button onclick="location.href='?p_type=고양이&mode=화장실'">
            <div class="category-icon-box"><img src="${pageContext.request.contextPath}/images/products/menu/menu-cat-toilet.png"></div>
            <span class="category-name">화장실</span>
        </button>
    </div>
    </c:if>

    <!-- 상품 개수 및 상태 바 -->
    <div class="list-header-info">
        <span class="product-count">전체 ${fn:length(ShoppingList)}개</span>
    </div>

   <!-- 상품 5열 -->
    <div class="product-grid" id="productGrid">
        <c:forEach var="list" items="${ShoppingList}" varStatus="status">
            <!-- 20개(index 0~19) 초과분은 초기 숨김 처리 -->
            <div class="product-card ${status.index >= 20 ? 'is-hidden' : ''}">
                <div class="product-thumb">
                    <a href="/products/ShoppingView?p_no=${list.pno}">
                        <img src="${pageContext.request.contextPath}/images/products/main/${fn:replace(list.omainimg, '%', '%25')}" alt="${list.ptitle}">
                    </a>
                    <button type="button" class="fav-heart-btn" onclick="toggleFavorite(${list.pno}, this)">♥</button>
                </div>
                <div class="product-meta">
                    <span class="product-brand">${list.pbrand}</span>
                    <a href="/products/ShoppingView?p_no=${list.pno}" class="product-title">${list.ptitle}</a>
                    <div class="price-row">
                        <span class="price"><fmt:formatNumber value="${list.oprice}" />원</span>
                        <c:if test="${list.oquantity > 0}">
                            <button type="button" class="btn-cart-icon" onclick="addToCart(${list.pno}, this)">🛒</button>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
    
    <!-- 스크롤 감지용 센티넬 (바닥 감지 태그) -->
    <div id="scrollSentinel" style="height: 20px;"></div>
</div>

<!-- 공용 토스트 안내창 -->
<div id="globalToast">
    <span class="toast-icon"></span>
    <span class="toast-msg"></span>
    <a href="${pageContext.request.contextPath}/cart/list" class="toast-link toast-link-cart">장바구니 보기</a>
    <a href="${pageContext.request.contextPath}/favorite/list" class="toast-link toast-link-fav">관심상품 보기</a>
</div>
<%@ include file="../footer.jsp" %>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    // 카테고리 활성화 로직
    document.addEventListener("DOMContentLoaded", function() {
        const urlParams = new URLSearchParams(window.location.search);
        const mode = urlParams.get('mode');

        const buttons = document.querySelectorAll('.category-btn button');
        buttons.forEach(button => {
            const onclickVal = button.getAttribute('onclick');
            if (!mode) {
                if (onclickVal && !onclickVal.includes('mode=')) {
                    button.classList.add('active');
                }
            } else {
                if (onclickVal && onclickVal.includes('mode=' + mode)) {
                    button.classList.add('active');
                }
            }
        });
    });

    // 자동완성
    $("#keyword").on("keyup", function(){
        let q = $(this).val();
        if(q.length < 1){
            $("#suggestions").hide().empty();
            return;
        }
        $.ajax({
            url: "/products/autocomplete",
            data: { keyword: q },
            success: function(list){
                let html = "";
                if(list && list.length > 0) {
                    list.forEach(function(item){
                        html += "<div class='item'>" + item.highlight + "</div>";
                    });
                    $("#suggestions").html(html).show();
                } else {
                    $("#suggestions").hide().empty();
                }
            },
            error: function(){
                console.log("autocomplete error");
            }
        });
    });

    $(document).on("click", ".item", function(){
        $("#keyword").val($(this).text());
        $("#suggestions").hide().empty();
    });

    var contextPath = "${pageContext.request.contextPath}";
    var toastTimer = null;

    function addToCart(pNo, btnEl) {
        btnEl.disabled = true;
        fetch(contextPath + "/cart/add", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ pNo: pNo, oNo: null, quantity: 1 })
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
            btnEl.disabled = false;
        });
    }

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
        var toast = document.getElementById("globalToast");
        if (!toast) return;

        toast.querySelector(".toast-icon").innerText = icon;
        toast.querySelector(".toast-msg").innerText = message;

        var cartLink = toast.querySelector(".toast-link-cart");
        var favLink = toast.querySelector(".toast-link-fav");
        cartLink.classList.toggle("show", action === "cart");
        favLink.classList.toggle("show", action === "favorite");

        toast.style.display = "flex";

        if (toastTimer) clearTimeout(toastTimer);
        toastTimer = setTimeout(function () {
            toast.style.display = "none";
        }, 3000);
    }
</script>
</body>
