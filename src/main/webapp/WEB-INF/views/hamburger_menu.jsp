<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<link rel="stylesheet" href="/css/etc/ham_menu.css">
  <div class="topbar">
    <span style="font-weight:700;">
        <a href="/"><img src="/images/LOGO_text.png" alt="이미지 로고2" width="180px" height="auto"></a>
    </span>

    <div class="topbar-right">
    <!-- 비회원 영역 -->
    <sec:authorize access="isAnonymous()">
        <a href="/loginForm" class="login">로그인</a> | 
        <a href="/memberInsertForm" class="joinmember">회원가입</a>
      </sec:authorize>
    <!-- 일반 회원 프로필 이미지 -->
    <sec:authorize access="hasRole('USER')">
        <c:if test="${not empty loginMember}">
        	<a href="/logout" class="logout">로그아웃</a>
            <a href="/member/myPage/myPage" class="profile-img-link">
                <c:choose>
                    <c:when test="${not empty loginMember.m_img}">
                        <img src="/images/myProfile/${loginMember.m_img}" alt="프로필 사진" class="profile-img">
                    </c:when>
                    <c:otherwise>
                        <img src="/images/myProfile/profil_image.png" alt="기본 프로필" class="profile-img">
                    </c:otherwise>
                </c:choose>
            </a>
        </c:if>
       </sec:authorize>
        <!-- 크리에이터 프로필 이미지 -->
    <sec:authorize access="hasRole('CREATOR')">
        <c:if test="${not empty loginMember}">
        	<a href="/logout" class="logout">로그아웃</a>
            <a href="/member/myPage/myPage" class="profile-img-link">
                <c:choose>
                    <c:when test="${not empty loginMember.m_img}">
                        <img src="/images/myProfile/${loginMember.m_img}" alt="프로필 사진" class="profile-img">
                    </c:when>
                    <c:otherwise>
                        <img src="/images/myProfile/profil_image.png" alt="기본 프로필" class="profile-img">
                    </c:otherwise>
                </c:choose>
            </a>
        </c:if>
        <!-- 관리자 프로필 이미지(관리자 페이지로 이동) -->
       </sec:authorize>
       <sec:authorize access="hasRole('ADMIN')">
       		<a href="/logout" class="logout">로그아웃</a>
       		<a href="/admin/adminPage" class="profile-img-link">
       			<img src="/images/myProfile/profil_image_2.png" alt="관리자 프로필" class="profile-img">
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
<!-- 관리자 페이지 버튼만 표시 -->
	  <sec:authorize access="hasRole('ADMIN')">
      	<div class="pill-row">
	      	<a href="/admin/adminPage" class="pill pill--admin">관리자 페이지</a>
	  	</div>
	  </sec:authorize>
<!-- 일반 회원 버튼 표시 -->
	  <sec:authorize access="hasRole('USER')">
      <div class="pill-row">
        <a href="/member/myPage/myPage" class="pill pill--solid">마이페이지</a>
        <a href="/commWriteForm" class="pill pill--outline">글쓰기</a>
      </div>
      </sec:authorize>
<!-- 비회원 표시 -->
      <sec:authorize access="isAnonymous()">
      <div class="pill-row">
        <a href="/loginForm" class="pill pill--solid">로그인</a>
        <a href="/memberInsertForm" class="pill pill--outline">회원가입</a>
      </div>
      </sec:authorize>
<!-- 요약 메뉴 영역(유지할지말지 논의 필요) -->
      <p class="label-sm">빠른 메뉴</p>
      <div class="chip-row">
        <a href="/community/commList" class="chip">커뮤니티
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 6 15 12 9 18"/></svg>
        </a>
        <a href="/products/ShoppingList" class="chip">쇼핑
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 6 15 12 9 18"/></svg>
        </a>
        <a href="/cart/list" class="chip">장바구니
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 6 15 12 9 18"/></svg>
        </a>
      </div>
<!-- 전체 메뉴 영역 -->
      <h3 class="section-title">서비스</h3>
      <div class="cat-grid">

		<div class="cat">
          <h3>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="8.5" cy="12" r="1.5"/><line x1="13" y1="10" x2="18" y2="10"/><line x1="13" y1="14" x2="18" y2="14"/></svg>
            ♥ 📋 ♥
          </h3> <!-- 커뮤니티 -->
          <ul>
            <li><a href="/community/commList">라운지</a></li>
            <li><a href="#">Q&amp;A</a></li>
            <li><a href="#">리뷰</a></li>
            <li><a href="#">이벤트</a></li>
          </ul>
        </div>
        
        <div class="cat">
          <h3>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="8.5" cy="12" r="1.5"/><line x1="13" y1="10" x2="18" y2="10"/><line x1="13" y1="14" x2="18" y2="14"/></svg>
            ♥ 🛍️ ♥
          </h3> <!-- 쇼핑 -->
          <ul>
            <li><a href="/products/ShoppingList">제품별</a></li>
            <li><a href="/products/ShoppingList">상황별</a></li>
          </ul>
        </div>
        
        <div class="cat">
          <h3>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20s-7-4.35-9.5-9C1 7.5 3 4 6.5 4c2 0 3.3 1.1 4 2.2C11.2 5.1 12.5 4 14.5 4 18 4 20 7.5 18.5 11 16 15.65 12 20 12 20z"/></svg>
            ♥ 🐶 ♥
          </h3>
          <ul>
            <li><a href="#">보호소 입양</a></li>
            <li><a href="#">임시보호</a></li>
            <li><a href="#">이름 짓기</a></li>
          </ul>
        </div>

        <div class="cat">
          <h3>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="8.5" cy="12" r="1.5"/><line x1="13" y1="10" x2="18" y2="10"/><line x1="13" y1="14" x2="18" y2="14"/></svg>
            ♥ 🛒 ♥
          </h3> <!-- 장바구니 -->
          <ul>
            <li><a href="/cart/list">장바구니</a></li>
            <li><a href="/favorite/list">관심상품</a></li>
            <li><a href="/member/order/list">주문내역</a></li>
          </ul>
        </div>

      <div class="cat">
          <h3>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"/><line x1="12" y1="8" x2="12" y2="16"/><line x1="8" y1="12" x2="16" y2="12"/></svg>
            동물병원
          </h3>
          <ul>
            <li><a href="#">동물병원 찾기</a></li>
          </ul>
        </div>

        <div class="cat">
          <h3>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 21s-6.5-5.6-6.5-11A6.5 6.5 0 0 1 12 3.5 6.5 6.5 0 0 1 18.5 10c0 5.4-6.5 11-6.5 11z"/><circle cx="12" cy="10" r="2.2"/></svg>
            반려동물 장소
          </h3>
          <ul>
            <li><a href="#">동반 여행</a></li>
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
            <li><a href="#">크리에이터 신청</a></li>
            <li><a href="#">캠페인</a></li>
          </ul>
        </div>
      </div>
<!-- footer와 동일 -->
      <hr class="divider">
      <p class="label-sm">더보기</p>
      <div class="footer-links">
        <a href="#">고객센터</a> <!-- 챗봇 API -->
        <a href="/guest/etc/companyIntroduce">회사소개</a>
        <a href="/guest/etc/ToS">이용약관</a>
        <a href="/guest/etc/privacyPolicy">개인정보처리방침</a>
      </div>

    </div>
  </nav>