<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이벤트 상세보기</title>
<link rel="stylesheet" href="/css/event/eventView.css">
</head>
<body>
<%@ include file="../hamburger_menu.jsp" %>

	<!-- 전체 컨테이너 (가운데 정렬 및 폭 조절용) -->
	<div class="event_view_wrap">
	
		<!-- 상단 상세 정보 카드 박스 -->
		<div class="event_detail_card">
		
			<!-- 1. 상단 뱃지 영역 (온/오프라인 분기 및 디자인 적용) -->
			<div class="event_badges">
				<!-- 진행 상태 뱃지 (상시진행 / 종료 / 진행중) -->
				<c:choose>
					<c:when test="${view.event_all eq 'Y'}">
						<span class="badge badge-ongoing">상시진행</span>
					</c:when>
					<c:when test="${not empty view.event_end and now.after(view.event_end)}">
						<span class="badge badge-ended">종료</span>
					</c:when>
					<c:otherwise>
						<span class="badge badge-ongoing">진행중</span>
					</c:otherwise>
				</c:choose>
				
				<!-- 온라인 / 오프라인 여부에 따른 하위 항목 분기 출력 -->
				<c:choose>
					<c:when test="${view.event_onoff eq '온라인'}">
						<span class="badge badge-onoff">${view.event_onoff}</span>
						<c:if test="${not empty view.event_pet_type}">
							<span class="badge badge-pet">${view.event_pet_type}</span>
						</c:if>
					</c:when>
					<c:otherwise>
						<!-- 오프라인일 때 출력할 항목 (온/오프라인 태그, 반려동물 타입, 지역) -->
						<span class="badge badge-onoff">${view.event_onoff}</span>
						<c:if test="${not empty view.event_pet_type}">
							<span class="badge badge-pet">${view.event_pet_type}</span>
						</c:if>
						<c:if test="${not empty view.event_loc}">
							<span class="badge badge-loc">📍 ${view.event_loc}</span>
						</c:if>
					</c:otherwise>
				</c:choose>

				<!-- 날짜 정보 뱃지 -->
				<span class="badge badge-period">
					<c:choose>
						<c:when test="${view.event_all eq 'Y'}">상시진행</c:when>
						<c:otherwise>
							<fmt:formatDate value="${view.event_start}" pattern="yyyy.MM.dd" /> ~
							<fmt:formatDate value="${view.event_end}" pattern="yyyy.MM.dd" />
						</c:otherwise>
					</c:choose>
				</span>
			</div>
			
			<!-- 2. 타이틀 영역 -->
			<h2 class="event_title">${view.event_title}</h2>
			
			<!-- 3. 구분선 -->
			<hr class="event_divider">
			
			<!-- 4. 본문 내용 영역 -->
			<div class="event_content_area">
				${view.event_content}
			</div>
			
		</div>

		<!-- 댓글 영역 -->
		<div class="comment_section">
			<div class="comment_count_area">
				<span>댓글 ${not empty commentCount ? commentCount : 0}</span>
			</div>

			<div class="comment_box">
		        <sec:authorize access="isAuthenticated()">
		            <form name="comment_form" method="post" action="/eventCommentWrite">
		                <input type="hidden" name="cmt_type_no" value="${view.event_no}">
		                <input type="hidden" name="cmt_type" value="이벤트">
		                <input type="hidden" name="cmt_writer" value="<sec:authentication property='principal.username'/>">

		                <textarea name="cmt_content" rows="3" placeholder="댓글을 남겨보세요."></textarea>
		                <div class="comment_submit_area">
		                    <input type="submit" value="등록">
		                </div>
		            </form>
		        </sec:authorize>

		        <sec:authorize access="isAnonymous()">
				    <div class="comment_login_guide">
				        <span>로그인하면 바로 이 글에 댓글을 남길 수 있어요</span>
				        <a href="/event/write-auth?cmt_type_no=${view.event_no}">로그인하고 댓글 남기기</a>
				    </div>
				</sec:authorize>
			</div>

			<div class="comment_list">
				<c:forEach var="comment" items="${cmt}">
					<div class="comment_body" id="comment-body-${comment.cmt_no}">
						<div class="comment_title">
							${comment.cmt_writer} | <fmt:formatDate value="${comment.cmt_date}" pattern="yyyy.MM.dd" />
						</div>
						<div class="comment_content">
							${comment.cmt_content}
						</div>
					</div>
				</c:forEach>
			</div>
		</div>
	</div>
<%@ include file="../footer.jsp" %>
</body>
</html>