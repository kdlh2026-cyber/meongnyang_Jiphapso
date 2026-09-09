<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
<style>
	body{font-family: Arial, sans-serif;padding: 40px;background:#f5f5f5}
	ul, li, ol{list-style:none}
	.accordion{padding: 0;margin: 0;max-width: 400px;}
	.accordion li{border: 1px solid #ccc;margin-bottom: 10px;border-radius: 5px;overflow: hidden}
	.accordion button {width: 100%;padding: 15px;text-align: left;background: #f5f5f5;border: none;cursor: pointer;font-size: 16px;outline: none;}
	.accordion button:hover {background: #e0e0e0;}
	.accordion .content {display:none;overflow: hidden;padding: 0 15px;background: #fff;transition:padding 0.3s ease;}
	.accordion li.open .content {display: block;padding: 15px;}
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>

<!-- 아코디언 ui -->
<ul class="accordion">
	<li>
		<button>관리자 정보</button>
		<div class="content">
			<p>내용</p>
		</div>
	</li>
	<li>
		<button>회원 정보 관리</button> <!-- 회원 개인 포인트, 개인 쿠폰도 여기서 관리 -->
		<div class="content">
			<p><a href="/admin/mem/memberList">회원 리스트</a></p>
		</div>
	</li>
	<li>
		<button>상품 관리</button>
		<div class="content">
			<p><a href="/productWriteForm">상품 등록</a></p>
			<p><a href="/productList">상품 리스트</a></p>
		</div>
	</li>
	<li>
		<button>주문 관리</button>
		<div class="content">
			<p><a href="/admin/cart">장바구니 리스트</a></p>
			<p><a href="/admin/order">주문내역 리스트</a></p>
			<p><a href="/admin/order-detail">주문상세 리스트</a></p>
			<p><a href="/admin/favorite">관심상품 리스트</a></p>
		</div>
	</li>
	<li>
		<button>커뮤니티 관리</button>
		<div class="content">
			<p><a href="/communityCrawlingWriteForm">글쓰기 페이지</a></p>
		</div>
	</li>
	<li>
		<button>쿠폰 관리</button>
		<div class="content">
			<p>내용</p>
		</div>
	</li>
	<li>
		<button>그 외</button> <!-- 회사소개 이용약관 개인정보처리방침 등 -->
		<div class="content">
			<p>내용</p>
		</div>
	</li>
</ul>
<%@ include file="/WEB-INF/views/footer.jsp" %>
<script src="/js/adminPage.js"></script>
</body>
</html>