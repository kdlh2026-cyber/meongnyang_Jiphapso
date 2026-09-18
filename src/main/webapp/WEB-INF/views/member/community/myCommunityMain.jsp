<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내가 작성한 글</title>
<link rel="stylesheet" href="/css/community/myCommunity.css">
</head>
<body>
<!-- 1. 최상단 타이틀 영역 (고정 틀) -->
<div class="my-page-top-container">
    <div class="page-top-header">
        <h1>내가 작성한 글</h1>
        <span>글(댓글) 수정은 작성한 게시글 상세페이지에서 하실 수 있습니다.</span>
    </div>
</div>

<!-- 2. 하단 레이아웃 (왼쪽 사이드바 + 오른쪽 본문) -->
<div class="my-page-body-container">
    
    <!-- 왼쪽 사이드바 (고정 틀) -->
    <div class="sidebar-area">
        <div class="side-menu">
            <a href="/community/myCommunity" data-mp-category="true" class="${empty param.comm_type ? 'active' : ''}">전체</a>
            <a href="/community/myCommunity?comm_type=QNA" data-mp-category="true" class="${param.comm_type eq 'QNA' ? 'active' : ''}">Q&A</a>
            <a href="/community/myCommunity?comm_type=라운지" data-mp-category="true" class="${param.comm_type eq '라운지' ? 'active' : ''}">라운지</a>
            <a href="/community/myCommunity?comm_type=콘텐츠" data-mp-category="true" class="${param.comm_type eq '콘텐츠' ? 'active' : ''}">콘텐츠</a>
            <a href="/community/myCommunity?comm_type=댓글" data-mp-category="true" class="${param.comm_type eq '댓글' ? 'active' : ''}">댓글</a>
            <a href="/community/myCommunity?comm_type=리뷰" data-mp-category="true" class="${param.comm_type eq 'REVIEW' ? 'active' : ''}">리뷰</a>
        </div>
    </div>

    <!-- 오른쪽 본문 영역 (여기에 상황에 맞는 내용이 동적으로 들어감) -->
    <div class="content-area">
        <div class="my-content-area">
            
            <!-- [CASE 1] comm_type이 없을 때: 전체 요약 화면 -->
            <c:if test="${empty param.comm_type}">
                
                <!-- Q&A 섹션 -->
                <div class="section-block" style="margin-bottom: 40px;">
                    <div class="section-header">
                        <h3>Q&amp;A <span>${qnaCount}</span></h3>
                        <a href="/community/myCommunity?comm_type=QNA" data-mp-category="true" class="more-link">전체보기 &gt;</a>
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
                
                <!-- 라운지 섹션 -->
                <div class="section-block" style="margin-bottom: 40px;">
                    <div class="section-header">
                        <h3>라운지 <span>${loungeCount}</span></h3>
                        <a href="/community/myCommunity?comm_type=라운지" data-mp-category="true" class="more-link">전체보기 &gt;</a>
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
                            
                <!-- 콘텐츠 섹션 -->
                <div class="section-block" style="margin-bottom: 40px;">
                    <div class="section-header">
                        <h3>콘텐츠 <span>${contentCount}</span></h3>
                        <a href="/community/myCommunity?comm_type=콘텐츠" data-mp-category="true" class="more-link">전체보기 &gt;</a>
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
                            
                <!-- 댓글 섹션 -->
                <div class="section-block" style="margin-bottom: 40px;">
                    <div class="section-header">
                        <h3>댓글 <span>${commentCount}</span></h3>
                        <a href="/community/myCommunity?comm_type=댓글" data-mp-category="true" class="more-link">전체보기 &gt;</a>
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
                                <c:if test="${not empty latestComment.comm_img}">
                                    <img src="${latestComment.comm_img}" class="original-thumb">
                                </c:if>
                                <div class="original-info">
                                    <span class="original-title">${latestComment.comm_title}</span>
                                </div>
                                <div class="original-meta">
                                    💬 ${latestComment.reply_count}
                                </div>
                            </a>
                        </div>
                    </c:if>
                    
                    <c:if test="${empty latestComment}">
                        <p style="color: #999; font-size: 14px; padding: 10px 0;">작성한 댓글이 없습니다.</p>
                    </c:if>
                </div>

                <!-- 리뷰 섹션 요약 (댓글 섹션 바깥으로 독립) -->
                <div class="section-block" style="margin-bottom: 40px;">
                    <div class="section-header">
                        <h3>리뷰 <span>${reviewAll}</span></h3>
                        <a href="/community/myCommunity?comm_type=리뷰" data-mp-category="true" class="more-link">전체보기 &gt;</a>
                    </div>
                
                    <c:if test="${not empty latestReview}">
                        <div class="comment-card">
                            <div class="comment-header-row">
                            	<span style="color: #f59e0b; font-size: 15px; letter-spacing: 2px; margin-right: 8px;">
	             					<c:choose>
							            <c:when test="${latestReview.cmt_score == 5}">★★★★★</c:when>
							            <c:when test="${latestReview.cmt_score == 4}">★★★★☆</c:when>
							            <c:when test="${latestReview.cmt_score == 3}">★★★☆☆</c:when>
							            <c:when test="${latestReview.cmt_score == 2}">★★☆☆☆</c:when>
							            <c:otherwise>★☆☆☆☆</c:otherwise>
							        </c:choose>
							    </span>
                                <span class="comment-date"><fmt:formatDate value="${latestReview.cmt_date}" pattern="yyyy-MM-dd" /></span>
                                <span class="badge-category-outline">상품 리뷰</span>
                            </div>
                
                            <div class="my-comment-text" style="margin-top: 8px; font-size: 14px; color: #333;">
                                ${latestReview.cmt_content}
                            </div>
                        </div>
                    </c:if>
                    
                    <c:if test="${empty latestReview}">
                        <p style="color: #999; font-size: 14px; padding: 10px 0;">작성한 리뷰가 없습니다.</p>
                    </c:if>
                </div>
                
            </c:if>
            
            <!-- [CASE 2] comm_type이 있을 때: 선택한 카테고리 상세 목록 화면 -->
            <c:if test="${not empty param.comm_type}">
                <div style="margin-bottom: 20px;">
                    <h3 style="font-size: 22px; font-weight: bold;">${param.comm_type} <span style="color: #f59f00; font-size: 18px;">목록</span></h3>
                </div>
                
                <c:if test="${empty list}">
                    <p style="color: #999; font-size: 14px; padding: 40px 0; text-align: center;">작성한 ${param.comm_type} 내역이 없습니다.</p>
                </c:if>
                
                <c:forEach var="item" items="${list}">
                    <!-- 댓글 카테고리일 때 -->
                    <c:if test="${param.comm_type eq '댓글'}">
                        <div class="comment-card">
                            <div class="comment-header-row">
                                <span class="comment-date"><fmt:formatDate value="${item.cmt_date}" pattern="yyyy-MM-dd" /></span>
                                <span class="badge-category-outline">${item.cmt_type}</span>
                            </div>
                
                            <a href="/community/commView?comm_no=${item.cmt_type_no}" class="my-comment-text">
                                ${item.cmt_content}
                            </a>
                
                            <a href="/community/commView?comm_no=${item.cmt_type_no}" class="original-post-box">
                                <c:if test="${not empty item.cmt_img}">
                                    <img src="${item.cmt_img}" class="original-thumb">
                                </c:if>
                                <div class="original-info">
                                    <span class="original-title">${item.comm_title}</span>
                                </div>
                            </a>
                            
                            <div class="comment_delete_btn" style="margin-top: 10px; text-align: right;">
                                <button type="button" onclick="location.href='/comment/delete?cmt_no=${item.cmt_no}'" style="padding: 5px 10px; cursor: pointer;">삭제하기</button>
                            </div>
                        </div>
                    </c:if>
                    
                    <!-- 리뷰 카테고리일 때 -->
                    <c:if test="${param.comm_type eq '리뷰'}">
                        <div class="comment-card" style="margin-bottom: 15px; padding: 15px; border: 1px solid #eee; border-radius: 8px;">
                            <div class="comment-header-row" style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                            	<span style="color: #f59e0b; font-size: 15px; letter-spacing: 2px; margin-right: 8px;">
							        <c:choose>
							            <c:when test="${item.cmt_score == 5}">★★★★★</c:when>
							            <c:when test="${item.cmt_score == 4}">★★★★☆</c:when>
							            <c:when test="${item.cmt_score == 3}">★★★☆☆</c:when>
							            <c:when test="${item.cmt_score == 2}">★★☆☆☆</c:when>
							            <c:otherwise>★☆☆☆☆</c:otherwise>
							        </c:choose>
							    </span>
                                <span class="comment-date" style="font-size: 12px; color: #888;">
                                    <fmt:formatDate value="${item.cmt_date}" pattern="yyyy-MM-dd HH:mm" />
                                </span>
                                <span class="badge-category-outline" style="font-size: 11px; padding: 2px 6px; background: #f8f9fa; border: 1px solid #ddd; border-radius: 4px;">상품 리뷰</span>
                            </div>
                
                            <div class="my-comment-text" style="font-size: 14px; color: #333; line-height: 1.5; margin-bottom: 10px;">
                                ${item.cmt_content}
                            </div>
                            
							<div style="display: flex; justify-content: flex-end; gap: 8px; margin-top: 10px;">
							    <button type="button" onclick="location.href='/member/order/${item.cmt_type_no}'" style="padding: 5px 10px; cursor: pointer; background: #f1f3f5; border: 1px solid #dcdcdc; border-radius: 4px; font-size: 12px;">주문상세로 이동</button>
							    <button type="button" onclick="if(confirm('정말 리뷰를 삭제하시겠습니까?')) { location.href='/community/reviewDelete?cmt_no=${item.cmt_no}'; }" style="padding: 5px 10px; cursor: pointer; background: #fff5f5; border: 1px solid #ffa8a8; color: #e03131; border-radius: 4px; font-size: 12px;">삭제하기</button>
							</div>
                        </div>
                    </c:if>
                
                    <!-- 일반 게시글 카테고리(Q&A, 라운지, 콘텐츠)일 때 -->
                    <c:if test="${param.comm_type ne '댓글' && param.comm_type ne '리뷰'}">
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
                           
                            <div class="comment_delete_btn" style="margin-top: 10px; text-align: right;">
                                <button type="button" onclick="location.href='/community/delete?comm_no=${item.comm_no}&comm_type=${param.comm_type}'" style="padding: 5px 10px; cursor: pointer;">삭제하기</button>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </c:if>

        </div>
    </div>
</div>
<script>
$(document).ready(function() {
    // 사이드바 메뉴 클릭 시 AJAX 비동기 요청 처리
    $(document).on("click", "a[data-mp-category='true']", function(e) {
        e.preventDefault(); // 기본 페이지 이동 막기
        
        const url = $(this).attr("href");
        
        // 1. 사이드바 활성화 클래스(active) 이동
        $("a[data-mp-category='true']").removeClass("active");
        $(this).addClass("active");
        
        // 2. 브라우저 주소창 URL 변경 (뒤로가기 지원)
        history.pushState(null, null, url);
        
        // 3. 오른쪽 본문 영역만 비동기 로드
        $.ajax({
            url: url,
            type: "GET",
            success: function(response) {
                // 응답받은 HTML에서 .my-content-area 부분만 추출해서 현재 영역에 쏙 집어넣기
                const newContent = $(response).find(".my-content-area").html();
                $(".my-content-area").html(newContent);
            },
            error: function() {
                alert("데이터를 불러오는 데 실패했습니다.");
            }
        });
    });
    
    // 브라우저 뒤로가기/앞으로가기 대응
    $(window).on("popstate", function() {
        location.reload();
    });
});
</script>
</body>
</html>