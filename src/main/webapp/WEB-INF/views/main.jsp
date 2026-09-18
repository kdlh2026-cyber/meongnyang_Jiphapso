<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>멍냥집합소</title>
<link rel="stylesheet" href="/css/etc/main.css">
<sec:authorize access="hasAnyRole('USER','CREATOR')">
<sec:authentication property="principal.username" var="loginId" />
<script>
var DC_STORAGE_KEY = "dailycheckDismissed_${loginId}";

document.addEventListener("DOMContentLoaded", function () {
    var today = new Date().toISOString().slice(0, 10);
    var dismissedDate = localStorage.getItem(DC_STORAGE_KEY);

    if (dismissedDate === today) {
        return;
    }

    fetch("/dailycheckStatus")
        .then(function (res) { return res.json(); })
        .then(function (data) {
            if (data.needCheck) {
                window.open("/dailycheckPopup", "dailycheckPopup",
                    "width=360,height=460,resizable=no,scrollbars=no");
            }
        });
});
</script>
</sec:authorize>
</head>
<body>
<%@ include file="hamburger_menu.jsp" %>
<%@ include file="/WEB-INF/views/guest/popup/mainPopup.jsp" %>
<div class="main-header">
	<br><br><br>
	<div class="hover-image-box">
		<img src="/images/main/LOGO_main.png" class="main-header-img origin-img"/>
		<img src="/images/main/LOGO_main_2.png" class="main-header-img hover-img"/>
	</div>
</div>

<!-- 공통 표시 영역 -->

<!-- 통합 검색창(커뮤니티+상품) -->
<div class="search-section">
    <div class="search-wrapper">
        <form name="allSearch" method="get" action="/allSearch" class="search-input-box">
            <input type="text" name="keyword" id="keyword" autocomplete="off" required>
            <button type="submit">검색&#128062;</button>
        </form>
        <div id="suggestions"></div>
    </div>
</div>

<!-- 광고바 삽입 영역 -->
<div class="ad-section">
	<a href="/guest/etc/advertisementLink">
		<img src="/images/main/advertisement.png" alt="광고">
	</a>
</div>

<!-- 콘텐츠 영역 -->
<!-- 추천글이나 추천상품이랑 다르게 커다랗게 두개 정도만 띄우면 어떨까 싶슴다 -->


<!-- 추천 게시글 표시 영역 -->
<div class="category-box">
	<h3>추천 게시글</h3>
	<c:if test="${empty recommendContentList}">
	    <p>등록된 게시글이 없습니다.</p>
	</c:if>
	<div class="content-list">
	    <c:forEach var="cm" items="${recommendContentList}" begin="0" end="7">
	        <div class="content-item">
	            <c:if test="${not empty cm.comm_img}">
	               <a href="/community/commView?comm_no=${cm.comm_no}">
	                <img src="${cm.comm_img}" width="500" height="300">
	               </a>
	            </c:if>
	            <c:if test="${empty cm.comm_img}">
	               <a href="/community/commView?comm_no=${cm.comm_no}">
	            	<img src="/images/main/admin_profile.png" width="500" height="300">
	               </a>
	            </c:if>
	            <div><a href="/community/commView?comm_no=${cm.comm_no}">${cm.comm_title}</a></div>
	            <div>${cm.comm_writer}</div>
	        </div>
	    </c:forEach>
	</div>
</div>

<!-- 추천 상품 표시 영역 -->
<div class="category-box">
	<h3>추천 상품</h3>
	<c:if test="${empty recommendProductList}">
	    <p>등록된 상품이 없습니다.</p>
	</c:if>
	<div class="product-list">
	    <c:forEach var="pd" items="${recommendProductList}" begin="0" end="7">
	        <div class="product-item">
	            <div class="image">
	            	<a href="/products/ShoppingView?p_no=${pd.pno}">
	                	<div class="image"><img src="${pageContext.request.contextPath}/images/products/main/${fn:replace(pd.omainimg, '%', '%25')}" width="120"></div>
	            	</a>
	            </div>
	            <div>${pd.pbrand}</div>
	            <div><a href="/products/ShoppingView?p_no=${pd.pno}">${pd.ptitle}</a></div>
	            <div><fmt:formatNumber value="${pd.oprice}" />원</div>
	        </div>
	    </c:forEach>
	</div>
</div>
<%@ include file="footer.jsp" %>
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
		                // highlight 필드 사용
		                html += "<div class='item'>" + item.highlight + "</div>";
		            });
		            $("#suggestions").html(html);
		        },
		        error: function(){
		            console.log("autocomplete error");
		        }
		    });
		});
		
		// 추천어 클릭 시 검색창에 채움
		$(document).on("click",".item",function(){
		    // <em> 태그 제거 후 input에 넣기
		    $("#keyword").val($(this).text());
		    $("#suggestions").empty();
		});
	</script>
</body>
</html>