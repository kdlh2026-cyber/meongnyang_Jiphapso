<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>통합검색 결과</title>
<link rel="stylesheet" href="/css/etc/mslist.css">
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>

	<!-- 상단 검색바(이전 검색 내용 유지) -->

<div class="search-result-page">

    <div class="search-section">
      <div class="search-wrapper">
        <form name="allSearch" action="/allSearch" method="get" class="search-input-box">
          <input type="text" name="keyword" id="keyword" value="${keyword}" autocomplete="off">
          <button type="submit">통합검색</button>
          <div id="suggestions"></div>
        </form>
      </div>
    </div>

    <hr>
    <h3>커뮤니티 (${cmTotal})</h3>
	<c:if test="${empty CMList}">
		<p>커뮤니티 검색결과가 없습니다.</p>
	</c:if>
	<c:forEach var="cm" items="${CMList}" end="4">
		<div class="cm-item">
			<a href="/community/commView?comm_no=${cm.comm_no}">${cm.comm_title}</a>
			<p>${fn:substring(cm.comm_content,0,200)}<span style="color:#FFC9CE;">...</span></p>
		</div>
	</c:forEach>
	<c:if test="${cmTotal > 5}">
	    <a href="/community/commsearch?keyword=${keyword}#search_box_wrapper" class="view-all-link">커뮤니티 전체보기 &gt;</a>
	</c:if>

	<hr>

	<!-- 상품 검색결과 표시 영역 -->
	<h3>상품 (${pdTotal})</h3>

	<div class="product-carousel">
	    <button type="button" class="carousel-btn prev" onclick="scrollProducts(-1)" aria-label="이전">
	        <svg viewBox="0 0 24 24"><path d="M15 18l-6-6 6-6" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
	    </button>
	
	    <div class="product-list" id="productList">
	        <c:if test="${empty PDList}">
	            <p>상품 검색결과가 없습니다.</p>
	        </c:if>
	        <c:forEach var="pd" items="${PDList}" end="7">
	            <div class="product-item">
	                <div class="image">
	                    <a href="/products/ShoppingView?p_no=${pd.pno}">
	                        <img src="${pageContext.request.contextPath}/images/products/main/${fn:replace(pd.omainimg, '%', '%25')}">
	                    </a>
	                </div>
	                <div class="pd-brand">${pd.pbrand}</div>
	                <div class="pd-title"><a href="/products/ShoppingView?p_no=${pd.pno}">${pd.ptitle}</a></div>
	                <div class="pd-price">판매가 <fmt:formatNumber value="${pd.oprice}" />원</div>
	                <div class="btn-row">
	                    <button type="button" class="btn-cart" onclick="addToCart(${pd.pno}, this)">장바구니 담기</button>
	                    <button type="button" class="btn-favorite" onclick="toggleFavorite(${pd.pno}, this)">♥ 관심상품</button>
	                </div>
	            </div>
	        </c:forEach>
	    </div>
	
	    <button type="button" class="carousel-btn next" onclick="scrollProducts(1)" aria-label="다음">
	        <svg viewBox="0 0 24 24"><path d="M9 18l6-6-6-6" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
	    </button>
	</div>
	
	<c:if test="${pdTotal > 8}">
	    <a href="/products/ShoppingList?keyword=${keyword}" class="view-all-link">상품 전체보기 &gt;</a>
	</c:if>

</div> <!-- /.search-result-page -->
		
<%@ include file="/WEB-INF/views/footer.jsp" %>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
		$("#keyword").on("keyup", function(){
		    let q = $(this).val();
		    if(q.length < 1){
		        $("#suggestions").empty();
		        return;
		    }
		    $.ajax({
		        url: "/main_autocomplete",
		        data: { keyword: q },
		        success: function(list){
		            let html = "";
		            list.forEach(function(item){
		                html += "<div class='item'>" + item.highlight + "</div>";
		            });
		            $("#suggestions").html(html);
		        },
		        error: function(){
		            console.log("autocomplete error");
		        }
		    });
		});

		$(document).on("click",".item",function(){
		    $("#keyword").val($(this).text());
		    $("#suggestions").empty();
		});
</script>
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
		
<script>
	function scrollProducts(direction) {
	    var list = document.getElementById("productList");
	    var itemWidth = list.querySelector(".product-item").offsetWidth;
	    var gap = 16;
	    var scrollAmount = (itemWidth + gap) * 2; // 한 번에 2개씩 이동
	    list.scrollBy({ left: direction * scrollAmount, behavior: "smooth" });
	}
	
	// 스크롤 끝에 도달하면 버튼 흐리게 처리
	(function() {
	    var list = document.getElementById("productList");
	    var prevBtn = document.querySelector(".carousel-btn.prev");
	    var nextBtn = document.querySelector(".carousel-btn.next");
	    if (!list) return;
	
	    function updateButtons() {
	        var maxScroll = list.scrollWidth - list.clientWidth;
	        prevBtn.classList.toggle("is-disabled", list.scrollLeft <= 5);
	        nextBtn.classList.toggle("is-disabled", list.scrollLeft >= maxScroll - 5);
	    }
	    list.addEventListener("scroll", updateButtons);
	    window.addEventListener("resize", updateButtons);
	    updateButtons();
	})();
</script>
</body>
</html>