<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이벤트 게시글 목록</title>
<style>
.preview_content{
	display: -webkit-box;
	-webkit-line-clamp: 1;
	-webkit-box-orient: vertical;
	overflow: hidden;
	text-overflow: ellipsis;
	word-break: break-all;
}
#suggestions em{
	background : Tomato;
	color : Seashell;
	font-weight : bold;
	font-style : italic;
}
.event-card {
	border: 1px solid #eee;
	border-radius: 10px;
	padding: 14px;
	margin-bottom: 12px;
}
.event-badge {
	display: inline-block;
	padding: 2px 8px;
	border-radius: 12px;
	font-size: 12px;
	margin-right: 6px;
}
.badge-ongoing { background: #ffefef; color: #e74c3c; }
.badge-ended { background: #eeeeee; color: #999; }
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>

	<!-- 온라인/오프라인 구분 -->
	<div class="category_tabs">
	    <a href="/community/comm_eventList" class="${empty param.event_onoff ? 'active' : ''}">전체</a>
	    <a href="/community/comm_eventList?event_onoff=online" class="${param.event_onoff eq 'online' ? 'active' : ''}">온라인</a>
	    <a href="/community/comm_eventList?event_onoff=offline" class="${param.event_onoff eq 'offline' ? 'active' : ''}">오프라인</a>
	</div>

    <!-- 반려동물 종류 필터 -->
    <div class="sub_filter">
	    <a href="/community/comm_eventList?event_onoff=${empty param.event_onoff ? '' : param.event_onoff}&amp;event_pet_type=" class="${empty param.event_pet_type ? 'active' : ''}">전체</a>
	    <a href="/community/comm_eventList?event_onoff=${empty param.event_onoff ? '' : param.event_onoff}&amp;event_pet_type=dog" class="${param.event_pet_type eq 'dog' ? 'active' : ''}">강아지</a>
	    <a href="/community/comm_eventList?event_onoff=${empty param.event_onoff ? '' : param.event_onoff}&amp;event_pet_type=cat" class="${param.event_pet_type eq 'cat' ? 'active' : ''}">고양이</a>
	</div>

    <div>전체 ${totalCount}개</div>

    <c:if test="${empty list}">
        <p>등록된 이벤트가 없습니다.</p>
    </c:if>

    <c:forEach var="event" items="${list}">
        <div class="event-card">
            <div>
                <c:choose>
                    <c:when test="${event.event_all eq 'Y'}">
                        <span class="event-badge badge-ongoing">상시진행</span>
                    </c:when>
                    <c:when test="${now.after(event.event_end)}">
                        <span class="event-badge badge-ended">종료</span>
                    </c:when>
                    <c:otherwise>
                        <span class="event-badge badge-ongoing">진행중</span>
                    </c:otherwise>
                </c:choose>
                <span>${event.event_onoff eq 'on' ? '온라인' : '오프라인'}</span>
                <span>${event.event_pet_type}</span>
            </div>
            <div>
                <a href="/community/eventView?event_no=${event.event_no}">${event.event_title}</a>
            </div>
            <div class="preview_content">${event.event_content}</div>
            <c:if test="${event.event_all ne 'Y'}">
                <div>
                    <fmt:formatDate value="${event.event_start}" pattern="yyyy.MM.dd" /> ~
                    <fmt:formatDate value="${event.event_end}" pattern="yyyy.MM.dd" />
                </div>
            </c:if>
            <c:if test="${event.event_onoff eq 'off' and not empty event.event_loc}">
                <div>장소: ${event.event_loc}</div>
            </c:if>
        </div>
    </c:forEach>

    <div class="pagination">
        <a href="/community/comm_eventList?event_onoff=${param.event_onoff}&event_pet_type=${param.event_pet_type}&sort=${param.sort}&page=${pageNum > 1 ? pageNum - 1 : 1}">PREV</a>
        <c:forEach var="i" begin="1" end="${totalPages}">
            <a href="/community/comm_eventList?event_onoff=${param.event_onoff}&event_pet_type=${param.event_pet_type}&sort=${param.sort}&page=${i}"
               class="${pageNum eq i ? 'active' : ''}">${i}</a>
        </c:forEach>
        <a href="/community/comm_eventList?event_onoff=${param.event_onoff}&event_pet_type=${param.event_pet_type}&sort=${param.sort}&page=${pageNum < totalPages ? pageNum + 1 : totalPages}">NEXT</a>
    </div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>