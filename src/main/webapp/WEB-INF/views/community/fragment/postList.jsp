<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>작성한 글 세부 카테고리별 출력</title>
<link rel="stylesheet" href="/css/community/myCommunity.css">
</head>
<body>
	<div>
		<h3>${param.comm_type}<span>목록</span></h3>
	</div>
	
	<c:if test="${empty list}">
		<p style="color: #999; font-size: 14px; padding: 20px 0; text-align: center;">작성한 ${param.comm_type} 내역이 없습니다.</p>
	</c:if>
	
	<c:forEach var="item" items="${list}">
		<c:if test="${param.comm_type eq '댓글'}">
        <div class="comment-card">
            <div class="comment-header-row">
                <span class="comment-date"><fmt:formatDate value="${item.cmt_date}" pattern="yyyy-MM-dd" /></span>
                <span class="badge-category-outline">${item.cmt_type}</span>
            </div>

            <!-- 내가 작성한 댓글 내용 -->
            <a href="/community/commView?comm_no=${item.cmt_type_no}" class="my-comment-text">
                ${item.cmt_content}
            </a>

            <!-- 원본 게시글 요약 박스 (썸네일 + 제목 + 댓글수) -->
            <a href="/community/commView?comm_no=${item.cmt_type_no}" class="original-post-box">
                <!-- 썸네일 이미지 (있을 때만 출력) -->
                <c:if test="${not empty item.cmt_img}">
                    <img src="${item.cmt_img}" class="original-thumb">
                </c:if>

                <div class="original-info">
                    <span class="original-title">${item.comm_title}</span>
                </div>
            </a>
            
            <div class="comment_delete_btn">
                <button type="button" onclick="location.href='/comment/delete?cmt_no=${item.cmt_no}'">삭제하기</button>
            </div>
        </div>
    </c:if>
    
    <c:if test="${param.comm_type ne '댓글'}">
        <div class="post-card">
            <a href="/community/commView?comm_no=${item.comm_no}" class="post-title">${item.comm_title}</a>
            <div class="post-preview">${item.comm_content}</div>
            <div class="post-meta">
                <span>💬 ${item.reply_count}</span>
                <span><fmt:formatDate value="${item.comm_date}" pattern="yyyy-MM-dd" /></span>
                <c:if test="${not empty item.comm_pet_type}">
                    <span class="badge-pet">${item.comm_pet_type}</span>
                </c:if>
            </div>
            <div class="comment_delete_btn">
                <button type="button" onclick="location.href='/community/delete?comm_no=${item.comm_no}'">삭제하기</button>
            </div>
        </div>
    </c:if>
		
	</c:forEach>
</body>
</html>