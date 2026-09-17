<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 정보</title>
<link rel="stylesheet" href="/css/admin/a-i-page.css">
</head>
<body>
<%@ include file="/WEB-INF/views/admin/clone/hamburger_menu.jsp" %>

<div class="admin-profile-wrap">

	<div class="pv-card">
		<div class="pv-avatar-wrap">
			<img class="pv-avatar" src="/images/main/admin_profile.png" alt="관리자">
		</div>

		<p class="pv-name">관리자</p>
		<p class="pv-id">KDLH Team</p>

		<div class="pv-info-list">
			<div class="pv-info-row">
				<span class="pv-info-label">담당 업무</span>회원 · 상품 · 입양 · 주문 관리
			</div>
			<div class="pv-info-row">
				<span class="pv-info-label">권한 범위</span>
				<span class="pv-badge">전체 관리자 권한</span>
			</div>
			<div class="pv-info-row">
				<span class="pv-info-label">시행일</span>2026년 08월 28일
			</div>
		</div>

		<p class="pv-intro">
			멍냥집합소 관리자는 서비스 이용약관 및 개인정보처리방침에 따라
			회원 정보·게시물·거래 데이터를 관리하며, 회원의 개인정보를
			안전하게 보호하고 부적절한 게시물이나 거래를 제한할 권한과
			책임을 가집니다.
		</p>

		<div class="pv-admin-scope">
			<h4>관리자 권한</h4>
			<ul>
				<li>회원 정보 열람 및 회원 자격 제한·정지</li>
				<li>상품·입양·동물병원 정보 등록 및 관리</li>
				<li>주문·결제·쿠폰/포인트 내역 조회 및 처리</li>
				<li>커뮤니티 게시글·이벤트·품종 정보 관리 및
					부적절한 게시물 삭제</li>
				<li>크리에이터 자격 승인 및 정지·박탈</li>
			</ul>

			<h4>관리자 책임</h4>
			<ul>
				<li>회원 개인정보의 안전한 보관 및 접근 권한 관리</li>
				<li>문의·신고 접수 시 신속하고 성실한 처리</li>
				<li>서비스 운영 관련 공지사항 및 약관 개정 사항 게시</li>
				<li>부당한 사유 없이 회원의 권익을 침해하지 않을 의무</li>
			</ul>
		</div>

		<div class="pv-actions">
			<a class="pv-btn pv-btn--solid" href="/admin/mem/memberList">회원 관리로 이동</a>
			<a class="pv-btn pv-btn--outline" href="/admin/clone/main">관리자 홈</a>
		</div>
	</div>

</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>