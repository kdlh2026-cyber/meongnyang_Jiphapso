<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<link rel="stylesheet" href="/css/admin/clone-ham-menu.css">
<%@ include file="/WEB-INF/views/loading_animal.jsp" %>
  <div class="topbar">
    <span style="font-weight:700;">
        <a href="/admin/clone/main"><img src="/images/main/LOGO-text-admin.png" alt="이미지 로고2" width="180px" height="auto"></a>
    </span>

    <div class="topbar-right">
        <!-- 관리자 프로필 이미지 -->
       <sec:authorize access="hasRole('ADMIN')">
       		<a href="/logout" class="logout">로그아웃</a>
       		<a href="/admin/clone/adminIPage" class="profile-img-link">
       			<img src="/images/main/admin_profile.png" alt="관리자 프로필" class="profile-img">
       		</a>
       </sec:authorize>
        <label class="hamburger" for="menuToggle">
          <span></span><span></span><span></span>
        </label>
    </div>
</div>
  <input type="checkbox" id="menuToggle">
  <label for="menuToggle" class="overlay"></label>

  <nav class="drawer">
    <div class="drawer-scroll">

      <div class="drawer-head">
        <h2>전체 메뉴</h2>
        <label for="menuToggle" class="close-btn">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><line x1="5" y1="5" x2="19" y2="19"/><line x1="19" y1="5" x2="5" y2="19"/></svg>
        </label>
      </div>
<!-- 원래 메인화면으로 이동 -->
      	<div class="pill-row">
	      	<a href="/main" class="pill pill--admin" data-loading>메인 페이지로</a>
	  	</div>
<!-- 전체 메뉴 영역 -->
      <h3 class="section-title">관리 페이지</h3>
      <div class="cat-grid">

		<div class="cat">
          <h3>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="8.5" cy="12" r="1.5"/><line x1="13" y1="10" x2="18" y2="10"/><line x1="13" y1="14" x2="18" y2="14"/></svg>
            회원 정보 관리
          </h3>
          <ul>
            <li><a href="/admin/mem/memberList">회원 리스트</a></li>
          </ul>
        </div>
        
        <div class="cat">
          <h3>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="8.5" cy="12" r="1.5"/><line x1="13" y1="10" x2="18" y2="10"/><line x1="13" y1="14" x2="18" y2="14"/></svg>
            상품 관리
          </h3>
          <ul>
            <li><a href="/productWriteForm">상품 등록</a></li>
            <li><a href="/ProductListA">상품 리스트</a></li>
          </ul>
        </div>
        
        <div class="cat">
          <h3>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="8.5" cy="12" r="1.5"/><line x1="13" y1="10" x2="18" y2="10"/><line x1="13" y1="14" x2="18" y2="14"/></svg>
            커뮤니티 관리
          </h3>
          <ul>
            <li><a href="/admin/communityManage">게시글 관리</a></li>
            <li><a href="/admin/eventManage">이벤트 관리</a></li>
            <li><a href="/admin/breedInfo">품종관리</a></li>
          </ul>
        </div>

        <div class="cat">
          <h3>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="8.5" cy="12" r="1.5"/><line x1="13" y1="10" x2="18" y2="10"/><line x1="13" y1="14" x2="18" y2="14"/></svg>
            주문 관리
          </h3>
          <ul>
            <li><a href="/admin/cart">장바구니 리스트</a></li>
            <li><a href="/admin/order">주문내역 리스트</a></li>
            <li><a href="/admin/order-detail">주문상세 리스트</a></li>
            <li><a href="/orderCancel/admin/list">주문취소 리스트</a></li>
            <li><a href="/payment/admin/list">결제 리스트</a></li>
            <li><a href="/admin/favorite">관심상품 리스트</a></li>
          </ul>
        </div>
        
        <div class="cat">
          <h3>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="8.5" cy="12" r="1.5"/><line x1="13" y1="10" x2="18" y2="10"/><line x1="13" y1="14" x2="18" y2="14"/></svg>
            쿠폰 / 포인트 관리
          </h3>
          <ul>
            <li><a href="/admin/coupon">쿠폰 리스트</a></li>
            <li><a href="/admin/point/list">포인트 리스트</a></li>
          </ul>
        </div>
        
        <div class="cat">
          <h3>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="8.5" cy="12" r="1.5"/><line x1="13" y1="10" x2="18" y2="10"/><line x1="13" y1="14" x2="18" y2="14"/></svg>
            그 외
          </h3>
          <ul>
            <li><a href="/admin/hospital/hospitalInsertForm">동물병원 등록</a></li>
            <li><a href="/admin/hospital/hospitalList">동물병원 리스트</a></li>
            <li><a href="/strayWriteForm">입양동물 등록</a></li>
            <li><a href="/admin/stray/StrayListA">입양동물 리스트</a></li>
          </ul>
        </div>

      </div>

      <div class="cat-grid single">
        <div class="cat">
          <h3>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M4 16.5V20h3.5L18.5 9 15 5.5 4 16.5z"/><line x1="13" y1="7.5" x2="16.5" y2="11"/></svg>
            크리에이터
          </h3>
          <ul>
            <li><a href="/guest/etc/creatorHire">크리에이터 모집</a></li>
          </ul>
        </div>
      </div>

    </div>
  </nav>