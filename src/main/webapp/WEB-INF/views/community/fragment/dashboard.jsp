<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전체 작성글</title>
<link rel="stylesheet" href="/css/community/myCommunity.css">
</head>
<body>
<div class="my-content-area">
	<c:if test="${empty param.comm_type}">
		<!-- Q&A 섹션 -->
		<div class="section-block" style="margin-bottom: 40px;">
			<div class="section-header">
				<h3>Q&amp;A <span>${qnaCount}</span></h3>
				<a href="/community/myCommunity?comm_type=Q%26A" class="more-link">전체보기 &gt;</a>
			</div>
		
			<c:if test="${not empty latestQna}">
				<div class="post-card">
					<a href="/community/commView?comm_no=${latestQna.comm_no}" class="post-title">${latestQna.comm_title}</a>
					<div class="post-preview">${latestQna.comm_content}</div>
					<div class="post-meta">
						<span>💬 ${latestQna.reply_count}</span>
						<span><fmt:formatDate value="${latestQna.comm_date}" pattern="yyyy-MM-dd" /></span>
						<c:if test="${not empty latestQna.comm_pet_type}">
							<span class="badge-pet">${latestQna.comm_pet_type}</span>
						</c:if>
					</div>
				</div>
			</c:if>
			
			<c:if test="${empty latestQna}">
				<p style="color: #999; font-size: 14px; padding: 10px 0;">작성한 Q&amp;A 글이 없습니다.</p>
			</c:if>
		</div>
		
		<!-- 라운지 섹션 요약 -->
		<div class="section-block" style="margin-bottom: 40px;">
			<div class="section-header">
				<h3>라운지 <span>${loungeCount}</span></h3>
				<a href="/community/myCommunity?comm_type=라운지" class="more-link">전체보기 &gt;</a>
			</div>
		
			<c:if test="${not empty latestLounge}">
				<div class="post-card">
					<a href="/community/commView?comm_no=${latestLounge.comm_no}" class="post-title">${latestLounge.comm_title}</a>
					<div class="post-preview">${latestLounge.comm_content}</div>
					<div class="post-meta">
						<span>💬 ${latestLounge.reply_count}</span>
						<span><fmt:formatDate value="${latestLounge.comm_date}" pattern="yyyy-MM-dd" /></span>
						<c:if test="${not empty latestLounge.comm_pet_type}">
							<span class="badge-pet">${latestLounge.comm_pet_type}</span>
						</c:if>
					</div>
				</div>
			</c:if>
			
			<c:if test="${empty latestLounge}">
				<p style="color: #999; font-size: 14px; padding: 10px 0;">작성한 라운지 글이 없습니다.</p>
			</c:if>
		</div>
		            
		<!-- 콘텐츠 섹션 요약 -->
		<div class="section-block" style="margin-bottom: 40px;">
			<div class="section-header">
				<h3>콘텐츠 <span>${contentCount}</span></h3>
				<a href="/community/myCommunity?comm_type=콘텐츠" class="more-link">전체보기 &gt;</a>
			</div>
		
			<c:if test="${not empty latestContent}">
				<div class="post-card">
				    <a href="/community/commView?comm_no=${latestContent.comm_no}" class="post-title">${latestContent.comm_title}</a>
					<div class="post-preview">${latestContent.comm_content}</div>
					<div class="post-meta">
						<span>💬 ${latestContent.reply_count}</span>
						<span><fmt:formatDate value="${latestContent.comm_date}" pattern="yyyy-MM-dd" /></span>
						<c:if test="${not empty latestContent.comm_pet_type}">
							<span class="badge-pet">${latestContent.comm_pet_type}</span>
						</c:if>
					</div>
				</div>
			</c:if>
			<c:if test="${empty latestContent}">
				<p style="color: #999; font-size: 14px; padding: 10px 0;">작성한 콘텐츠 글이 없습니다.</p>
			</c:if>
		</div>
		            
		<!-- 댓글 섹션 요약 블록 -->
		<div class="section-block" style="margin-bottom: 40px;">
			<div class="section-header">
			    <h3>댓글 <span>${commentCount}</span></h3>
			<a href="/community/myCommunity?comm_type=댓글" class="more-link">전체보기 &gt;</a>
		</div>
		
		<c:if test="${not empty latestComment}">
			<div class="comment-card">
			    <div class="comment-header-row">
			    <span class="comment-date"><fmt:formatDate value="${latestComment.cmt_date}" pattern="yyyy-MM-dd" /></span>
				<span class="badge-category-outline">${latestComment.cmt_type}</span>
			</div>
		
			<a href="/community/commView?comm_no=${latestComment.cmt_type_no}" class="my-comment-text">
				${latestComment.cmt_content}
			</a>
			
			<a href="/community/commView?comm_no=${latestComment.cmt_type_no}" class="original-post-box">
			<<!-- 1. 왼쪽 썸네일 이미지 (이미지가 있을 때만 출력) -->
			<c:if test="${not empty latestComment.comm_img}">
				<img src="${latestComment.comm_img}" class="original-thumb">
			</c:if>
			
			<div class="original-info">
			    <span class="original-title">${latestComment.comm_title}</span>
			</div>
			
			<div class="original-meta">
			    💬 ${latestComment.comment_count}
			</div>
			     </a>
			 </div>
		</c:if>
		
		<c:if test="${empty latestComment}">
			<p style="color: #999; font-size: 14px; padding: 10px 0;">작성한 댓글이 없습니다.</p>
		</c:if>
		</div>
	</c:if>
</div>
</body>
</html>