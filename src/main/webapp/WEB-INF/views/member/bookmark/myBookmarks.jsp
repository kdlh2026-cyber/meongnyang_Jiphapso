<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 북마크 조회</title>
<!-- CSS 파일 연결 -->
<link rel="stylesheet" href="/css/community/bookMark.css">
</head>
<body>
    <div class="my-bookmark-container">
        <h3>저장한 콘텐츠 글</h3>
        
        <c:if test="${empty bookmarkList}">
            <p class="empty-bookmark">저장한 북마크 글이 없습니다.</p>
        </c:if>

        <div class="bookmark-list">
            <c:forEach var="mark" items="${bookmarkList}">
                <!-- 개별 글을 감싸는 하얀색 박스 카드 -->
                <div class="bookmark-card">
                    <!-- 좌측 텍스트 정보 영역 -->
                    <div class="bookmark-content-area">
                        <!-- 1단: 태그 (타입, 카테고리) -->
                        <div class="bookmark-header-row">
                            <span class="comm_type">${mark.comm_type}</span>
                            <span class="comm_category">${mark.comm_category}</span>
                        </div>
                        
                        <!-- 2단: 작성자 및 날짜 -->
                        <div class="bookmark-info-row">
                            <span class="comm_writer">${mark.comm_writer}</span>
                            <span class="comm_date">
                                <fmt:formatDate value="${mark.comm_date}" pattern="yyyy-MM-dd" />
                            </span>
                        </div>
                        
                        <!-- 3단: 게시글 제목 -->
                        <div class="comm_title">
                            <a href="/community/commView?comm_no=${mark.comm_no}">${mark.comm_title}</a>
                        </div>
                    </div>
                    
                    <!-- 우측 이미지 영역 (존재할 경우만 출력) -->
                    <c:if test="${not empty mark.comm_img}">
                        <div class="comm_img">
                            <img src="${mark.comm_img}" alt="상세 이미지">
                        </div>
                    </c:if>
                </div>
            </c:forEach>
        </div>
    </div>
</body>
</html>