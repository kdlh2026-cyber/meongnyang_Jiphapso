<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>통합검색 결과</title>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>

	<!-- 상단 검색바(이전 검색 내용 유지) -->

<form name="allSearch" action="/allSearch" method="get" style="position:relative">
		<p><input type="text" name="keyword" id="keyword" value="${keyword}" autocomplete="off">
		<input type="submit" value="통합검색">
		<div id="suggestions" style="border:1px solid #cccccc;position:absolute;background:white;width:170px;z-index:10">
		</div>
	</form>

		<ul>
			<li>전체</li>
			<li>포스트</li>
			<li>크리에이터즈</li>
			<li>커뮤니티</li>
		</ul>
		<hr>
	<h3>커뮤니티 (${cmTotal})</h3>
	<c:if test="${empty CMList}">
		<p>커뮤니티 검색결과가 없습니다.</p>
	</c:if>
	<c:forEach var="cm" items="${CMList}" end="4">
		<div class="cm-item">
			<a href="/communityView?comm_no=${cm.comm_no}">${cm.comm_title}</a>
			<p>${cm.comm_content}</p>
		</div>
	</c:forEach>
	<c:if test="${cmTotal > 5}">
		<a href="/comm_search?keyword=${keyword}">커뮤니티 전체보기 &gt;</a>
	</c:if>

	<hr>

	<!-- 상품 검색결과 표시 영역 -->
	<h3>상품 (${pdTotal})</h3>
	<c:if test="${empty PDList}">
		<p>상품 검색결과가 없습니다.</p>
	</c:if>
	<c:forEach var="pd" items="${PDList}" end="5">
		<div class="pd-item">
			<div class="image"><img src="${pageContext.request.contextPath}/images/products/main/${pd.omainimg}"></div>
			<div>${pd.pbrand}</div>
			<div><a href="/products/ShoppingView?p_no=${pd.pno}">${pd.ptitle}</a></div>
			<div>판매가
				<fmt:formatNumber value="${pd.oprice}" />원
			</div>
			<div class="btn-row">
					<button type="button" class="btn-cart" onclick="addToCart(${pd.pno}, this)">장바구니 담기</button>
					<button type="button" class="btn-favorite" onclick="toggleFavorite(${pd.pno}, this)">♥ 관심상품</button>
			</div>
		</div>
	</c:forEach>
	<c:if test="${pdTotal > 6}">
		<a href="/search?keyword=${keyword}">상품 전체보기 &gt;</a>
	</c:if>
		
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
</body>
</html>