<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지 작성글 모음</title>
<style>
    /* 전체 페이지를 좌우로 나누는 컨테이너 */
    .my-page-wrapper {
        display: flex;
        max-width: 1100px;
        margin: 40px auto;
        gap: 60px;
        padding: 0 20px;
    }

    /* 왼쪽 사이드바 탭 스타일 */
    .category_tabs {
        width: 180px;
        display: flex;
        flex-direction: column;
        gap: 8px;
    }

    .category_tabs a {
        padding: 12px 16px;
        text-decoration: none;
        color: #555;
        font-size: 15px;
        font-weight: 500;
        border-radius: 8px;
        transition: background 0.2s;
    }

    .category_tabs a.active {
        background-color: #f1f3f5;
        color: #000;
        font-weight: bold;
    }

    /* 오른쪽 본문 영역 스타일 */
    .my-content-area {
        flex: 1;
    }
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
<!-- 🌟 좌우 레이아웃 래퍼와 사이드바 추가 -->
<div class="my-page-wrapper">
    
    <!-- 1. 왼쪽 사이드바 카테고리 탭 -->
    <div class="category_tabs">
        <a href="/community/myCommunity?" class="${empty param.comm_type ? 'active' : ''}">전체</a>
        <a href="/community/myCommunity?comm_type=Q%26A" class="${param.comm_type eq 'Q&A' ? 'active' : ''}">Q&amp;A</a>
        <a href="/community/myCommunity?comm_type=라운지" class="${param.comm_type eq '라운지' ? 'active' : ''}">라운지</a>
        <a href="/community/myCommunity?comm_type=콘텐츠" class="${param.comm_type eq '콘텐츠' ? 'active' : ''}">콘텐츠</a>
        <a href="/community/myCommunity?comm_type=댓글" class="${param.comm_type eq '댓글' ? 'active' : ''}">댓글</a>
    </div>
    
    <!-- 2. 오른쪽 본문 영역 -->
    <div class="my-content-area">
        <!-- [전체] 탭일 때 대시보드 조각 불러오기 -->
        <c:if test="${empty param.comm_type}">
            <jsp:include page="/WEB-INF/views/community/fragment/dashboard.jsp" />
        </c:if>

        <!-- [특정 탭]일 때 상세 리스트 조각 불러오기 -->
        <c:if test="${not empty param.comm_type}">
            <jsp:include page="/WEB-INF/views/community/fragment/postList.jsp" />
        </c:if>
    </div>

</div>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>