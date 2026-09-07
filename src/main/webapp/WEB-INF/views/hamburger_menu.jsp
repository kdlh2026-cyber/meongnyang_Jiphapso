<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<link rel="stylesheet" href="/css/ham_menu.css">
  <div class="topbar">
    <span style="font-weight:700;">
        <a href="/"><img src="/images/LOGO_text.png" alt="이미지 로고2" width="180px" height="auto"></a>
    </span>

    <div class="topbar-right">
        <c:if test="${not empty loginMember}">
            <a href="/member/myPage/myPage" class="profile-img-link">
                <c:choose>
                    <c:when test="${not empty loginMember.m_img}">
                        <img src="/images/myProfile/${loginMember.m_img}" alt="프로필 사진" class="profile-img">
                    </c:when>
                    <c:otherwise>
                        <img src="/images/myProfile/${loginMember.m_img}" alt="기본 프로필" class="profile-img">
                    </c:otherwise>
                </c:choose>
            </a>
        </c:if>

        <label class="hamburger" for="menuToggle">
          <span></span><span></span><span></span>
        </label>
    </div>
</div>

  <main>
    <p>왼쪽 위 햄버거를 누르면 오른쪽에서 전체 메뉴 드로어가 열립니다.</p>
  </main>

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
      <div class="pill-row">
	      <sec:authorize access="hasRole('ADMIN')">
	      	<a href="/admin/adminPage" class="pill pill--admin">관리자 페이지</a>
	      </sec:authorize>
	  </div>
      <div class="pill-row">
        <a href="/member/myPage/myPage" class="pill pill--solid">마이페이지</a>
        <a href="#" class="pill pill--outline">글쓰기</a>
      </div>

      <p class="label-sm">둘러보기</p>
      <div class="chip-row">
        <a href="#" class="chip">콘텐츠
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 6 15 12 9 18"/></svg>
        </a>
        <a href="#" class="chip">쇼핑
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 6 15 12 9 18"/></svg>
        </a>
        <a href="#" class="chip">커뮤니티
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 6 15 12 9 18"/></svg>
        </a>
      </div>

      <h3 class="section-title">서비스</h3>
      <div class="cat-grid">

		<div class="cat">
          <h3>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="8.5" cy="12" r="1.5"/><line x1="13" y1="10" x2="18" y2="10"/><line x1="13" y1="14" x2="18" y2="14"/></svg>
            ♥ 📋 ♥
          </h3> <!-- 커뮤니티 -->
          <ul>
            <li><a href="#">라운지</a></li>
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
            <li><a href="cart/list">제품별</a></li>
            <li><a href="favorite/list">상황별</a></li>
          </ul>
        </div>
        
        <div class="cat">
          <h3>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20s-7-4.35-9.5-9C1 7.5 3 4 6.5 4c2 0 3.3 1.1 4 2.2C11.2 5.1 12.5 4 14.5 4 18 4 20 7.5 18.5 11 16 15.65 12 20 12 20z"/></svg>
            ♥ 입양 ♥
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
            <li><a href="cart/list">장바구니</a></li>
            <li><a href="favorite/list">관심상품</a></li>
            <li><a href="#">등록카드 발급</a></li>
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

        <div class="cat">
          <h3>
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3l7 3v6c0 4.5-3 7.5-7 9-4-1.5-7-4.5-7-9V6l7-3z"/><polyline points="9 12 11 14 15 10"/></svg>
            펫보험
          </h3>
          <ul>
            <li><a href="#">펫보험 찾기</a></li>
            <li><a href="#">관심 펫보험</a></li>
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

      <hr class="divider">
      <p class="label-sm">더보기</p>
      <div class="footer-links">
        <a href="#">고객센터</a> <!-- 챗봇 API -->
        <a href="#">회사소개</a>
        <a href="#">이용약관</a>
        <a href="#">개인정보처리방침</a>
      </div>

    </div>
  </nav>