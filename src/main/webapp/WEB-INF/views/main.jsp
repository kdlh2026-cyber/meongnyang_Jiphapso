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
<style>
.content-list,
.product-list {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 16px;
    margin-bottom: 24px;
}

.content-item,
.product-item {
    border: 1px solid #eee;
    border-radius: 8px;
    padding: 10px;
    box-sizing: border-box;
}

.content-item img,
.product-item .image img {
    width: 100%;
    height: 120px;
    object-fit: cover;
    border-radius: 6px;
}
</style>
</head>
<body>
<%@ include file="hamburger_menu.jsp" %>
	<h1>메인페이지</h1>
	
	<!-- 비회원 영역 -->
	<sec:authorize access="isAnonymous()">
	<img src="/images/main/LOGO_main.png" width="350px" height="auto"/><br>
	</sec:authorize>
	
	<!-- 일반 회원 영역 -->
	<sec:authorize access="hasRole('USER')">
		<img src="/images/main/LOGO_main.png" width="350px" height="auto"/><br>
			회원님, 환영합니다.<br>
	</sec:authorize>
	
	<!-- 관리자 영역 -->
	<sec:authorize access="hasRole('ADMIN')">
		<img src="/images/main/LOGO_main.png" width="350px" height="auto"/><br>
		관리자님, 환영합니다.<br>
	</sec:authorize>
	
<!-- 공통 표시 영역 -->
	
	<!-- 통합 검색창(커뮤니티+상품) -->
		<form name="allSearch" type="get" action="/allSearch" style="position:relative">
			<p><input type="text" name="keyword" id="keyword" autocomplete="off">
			<input type="submit" value="통합검색">
			<div id="suggestions" style="border:1px solid #cccccc;position:absolute;background:white;width:170px;z-index:10">
			</div>
		</form>
		
	<!-- 광고바 삽입 영역 -->
	<img src="/images/main/advertisement.png" width="800px" height="auto" /><br>
	
	<!-- 추천 게시글 표시 영역 -->
		<h3>추천 게시글</h3>
		<c:if test="${empty recommendContentList}">
		    <p>등록된 게시글이 없습니다.</p>
		</c:if>
		<div class="content-list">
		    <c:forEach var="cm" items="${recommendContentList}" end="4">
		        <div class="content-item">
		            <c:if test="${not empty cm.comm_img}">
		                <img src="${board.comm_img}" width="120" height="120">
		            </c:if>
		            <div><a href="/community/commView?comm_no=${cm.comm_no}">${cm.comm_title}</a></div>
		            <div>${cm.comm_writer}</div>
		        </div>
		    </c:forEach>
		</div>
		
		<!-- 추천 상품 표시 영역 -->
		<h3>추천 상품</h3>
		<c:if test="${empty recommendProductList}">
		    <p>등록된 상품이 없습니다.</p>
		</c:if>
		<div class="product-list">
		    <c:forEach var="pd" items="${recommendProductList}" end="5">
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