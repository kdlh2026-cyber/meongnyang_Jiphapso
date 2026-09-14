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
</head>
<body>
<%@ include file="../hamburger_menu.jsp" %>
	<div>
		<table border="1" width="700">
			<tr>
				<td>
					${view.event_onoff eq 'online' ? '온라인' : '오프라인'} ${view.event_pet_type}
					<c:if test="${view.event_all eq 'Y'}">상시진행</c:if>
				</td>
			</tr>
			<tr>
				<td>
					${view.event_title}
				</td>
			</tr>
			<tr>
				<td>
					<c:if test="${view.event_all ne 'Y'}">
						<fmt:formatDate value="${view.event_start}" pattern="yyyy.MM.dd" /> ~
						<fmt:formatDate value="${view.event_end}" pattern="yyyy.MM.dd" />
					</c:if>
				</td>
			</tr>
			<tr>
				<td>
					<fmt:formatDate value="${view.event_date}" pattern="yyyy-MM-dd" />
				</td>
			</tr>
			<tr>
				<td>
					<c:if test="${view.event_onoff eq 'offline'}">
						<fmt:formatDate value="${view.event_start}" pattern="yyyy.MM.dd" /> ~
						<fmt:formatDate value="${view.event_end}" pattern="yyyy.MM.dd" />
					</c:if>
				</td>
			</tr>
			<tr>
				<td>
					${view.event_content}
					<c:if test="${view.event_onoff eq 'offline'}">
						<button>사전등록 하러가기</button>
					</c:if>
				</td>
			</tr>
		</table>
	</div>

	<!-- 댓글 영역 (commView와 동일 패턴, cmt_type='event'로 구분) -->
	<div class="comment_section">
		<div>
			<span>댓글 ${not empty commentCount ? commentCount : 0}</span>
		</div>

		<div class="comment_box">
	        <sec:authorize access="isAuthenticated()">
	            <form name="comment_form" method="post" action="/commentWrite">
	                <input type="hidden" name="cmt_type_no" value="${view.event_no}">
	                <input type="hidden" name="cmt_type" value="event">
	                <input type="hidden" name="cmt_writer" value="<sec:authentication property='principal.username'/>">

	                <textarea name="cmt_content" rows="3" placeholder="댓글을 남겨보세요."></textarea>
	                <div>
	                    <input type="submit" value="등록">
	                </div>
	            </form>
	        </sec:authorize>

	        <sec:authorize access="isAnonymous()">
	            <div>
	                <span>로그인하면 바로 이 글에 댓글을 남길 수 있어요</span>
	                <a href="/community/comment/write-auth?cmt_type_no=${view.event_no}&cmt_type=event">로그인하고 댓글 남기기</a>
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

<%@ include file="../footer.jsp" %>
</body>
</html>