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
<title>관리자 페이지</title>
<link rel="stylesheet" href="/css/etc/main.css">
<link rel="stylesheet" href="/css/admin/clone-admin.css">
</head>
<body>
<%@ include file="/WEB-INF/views/admin/clone/hamburger_menu.jsp" %>

<div class="admin-wrap">

	<h2 class="admin-title">관리자 페이지</h2>
	<br><br>
	<ul class="admin-grid">

		<li class="admin-box" data-box="info">
			<div class="admin-box-face">
				<span><img src="/images/main/c-a-a.png" alt="관리자 정보"></span>
			</div>
			<div class="admin-flyout">
				<a href="/admin/clone/adminIPage">정보</a>
			</div>
		</li>

		<li class="admin-box" data-box="member">
			<div class="admin-box-face">
				<span><img src="/images/main/c-a-b.png" alt="회원 정보 관리"></span>
			</div>
			<div class="admin-flyout">
				<a href="/admin/mem/memberList">회원 리스트</a>
			</div>
		</li>

		<li class="admin-box" data-box="product">
			<div class="admin-box-face">
				<span><img src="/images/main/c-a-c.png" alt="상품 관리"></span>
			</div>
			<div class="admin-flyout">
				<a href="/productWriteForm">상품 등록</a>
				<a href="/ProductListA">상품 리스트</a>
			</div>
		</li>

		<li class="admin-box" data-box="adopt">
			<div class="admin-box-face">
				<span><img src="/images/main/c-a-d.png" alt="입양 관리"></span>
			</div>
			<div class="admin-flyout">
				<a href="/strayWriteForm">유기동물 등록</a>
				<a href="/admin/stray/StrayListA">유기동물 리스트</a>
			</div>
		</li>

		<li class="admin-box" data-box="order">
			<div class="admin-box-face">
				<span><img src="/images/main/c-a-e.png" alt="주문 관리"></span>
			</div>
			<div class="admin-flyout">
				<a href="/admin/cart">장바구니 리스트</a>
				<a href="/admin/order">주문내역 리스트</a>
				<a href="/admin/order-detail">주문상세 리스트</a>
				<a href="/orderCancel/admin/list">주문취소 리스트</a>
				<a href="/payment/admin/list">결제 리스트</a>
				<a href="/admin/favorite">관심상품 리스트</a>
			</div>
		</li>

		<li class="admin-box" data-box="community">
			<div class="admin-box-face">
				<span><img src="/images/main/c-a-f.png" alt="커뮤니티 관리"></span>
			</div>
			<div class="admin-flyout">
				<a href="/admin/communityManage">게시글 관리</a>
				<a href="/admin/eventManage">이벤트 관리</a>
				<a href="/admin/breedInfo">품종관리</a>
			</div>
		</li>

		<li class="admin-box" data-box="coupon">
			<div class="admin-box-face">
				<span><img src="/images/main/c-a-g.png" alt="쿠폰 포인트 관리"></span>
			</div>
			<div class="admin-flyout">
				<a href="/admin/coupon">쿠폰 리스트</a>
				<a href="/admin/point/list">포인트 리스트</a>
			</div>
		</li>

		<li class="admin-box" data-box="etc">
			<div class="admin-box-face">
				<span><img src="/images/main/c-a-h.png" alt="그 외"></span>
			</div>
			<div class="admin-flyout">
				<a href="/admin/hospital/hospitalInsertForm">동물병원 등록</a>
				<a href="/admin/hospital/hospitalList">동물병원 리스트</a>
			</div>
		</li>

	</ul>
	<br><br>
	<div class="main-header">
		<img src="/images/main/admin_clone_image.png" width="700px"/>
	</div>

</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
<script src="/js/clone-admin.js"></script>
</body>
</html>
