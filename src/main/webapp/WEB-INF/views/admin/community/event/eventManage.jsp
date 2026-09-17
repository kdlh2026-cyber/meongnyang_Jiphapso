<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이벤트 관리(등록 및 신청 조회)</title>
<style>
.admin-filter-bar {
    margin: 20px 0;
    padding: 15px;
    background: #f9f9f9;
    border-radius: 8px;
    border: 1px solid #eee;
}
.admin-filter-bar a {
    margin-right: 10px;
    padding: 6px 12px;
    text-decoration: none;
    background: #fff;
    border: 1px solid #ddd;
    border-radius: 4px;
    color: #333;
    font-size: 13px;
}
.admin-filter-bar a.active {
    background: #222;
    color: #fff;
    border-color: #222;
}

/* 좌우 배치를 위한 스타일 */
.event-tables-container {
    display: flex;
    gap: 20px; /* 좌우 테이블 사이 간격 */
    align-items: flex-start;
}
.event-section {
    flex: 1; /* 양쪽 영역이 화면을 균등하게 나눠 가짐 */
    min-width: 0; /* 테이블 밀림 현상 방지 */
}
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>

	<!-- 1. 행사 제보 신청 내역 영역 -->
	<div>
		<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
	        <h3 style="margin: 0;">이벤트 신청 내역 (유저 제보)</h3>
	        <button type="button" onclick="location.href='/admin/eventWriteForm'" style="background-color: #222; color: #fff; padding: 8px 16px; border: none; border-radius: 8px; font-size: 14px; font-weight: bold; cursor: pointer;">
	            이벤트 등록하기
	        </button>
	    </div>
		<table border="1" style="width: 100%; border-collapse: collapse; text-align: center;">
			<tr style="background: #f2f2f2;">
				<td>신청 일자</td>
				<td>행사 링크</td>
				<td>행사 설명</td>
				<td>신청자</td>
			</tr>
			<c:forEach var="r" items="${report}">
                <tr>
                    <td>
                        <fmt:formatDate value="${r.report_date}" pattern="yyyy-MM-dd HH:mm" />
                    </td>
                    <td style="text-align: left; padding-left: 10px;">
                    	<a href="${r.report_link}" target="_blank">${r.report_link}</a>
                    </td>
                    <td>${r.report_content}</td>
                    <td>${r.m_no}</td>
                </tr>
            </c:forEach>
            <c:if test="${empty report}">
                <tr>
                    <td colspan="4" align="center" style="padding: 20px;">신청된 내역이 없습니다.</td>
                </tr>
            </c:if>
		</table>
	</div>

    <hr style="margin: 40px 0; border: 0; border-top: 1px solid #ddd;">

    <!-- 관리자 필터 바 (반려동물 종류 필터만 남김) -->
    <div class="admin-filter-bar">
        <strong>[반려동물 필터]</strong> 
        <a href="/admin/eventManage?event_pet_type=" class="${empty param.event_pet_type ? 'active' : ''}">전체</a>
        <a href="/admin/eventManage?event_pet_type=강아지" class="${param.event_pet_type eq '강아지' ? 'active' : ''}">강아지</a>
        <a href="/admin/eventManage?event_pet_type=고양이" class="${param.event_pet_type eq '고양이' ? 'active' : ''}">고양이</a>
    </div>

	<!-- 2 & 3. 온라인(좌) / 오프라인(우) 목록 좌우 배치 컨테이너 -->
	<div class="event-tables-container">
	
		<!-- 온라인 영역 (왼쪽) -->
		<section class="event-section">
			<h3>등록한 이벤트 목록 - 온라인</h3>
			<table border="1" style="width: 100%; border-collapse: collapse; text-align: center; font-size: 13px;">
				<tr style="background: #f2f2f2;">
					<td>이미지</td>
					<td>행사명</td>
					<td>행사일자</td>
					<td>대상</td>
					<td>관리</td>
				</tr>
				
				<c:set var="onlineCount" value="0" />
				<c:forEach var="event" items="${write}">
					<c:if test="${event.event_onoff eq '온라인'}">
						<c:set var="onlineCount" value="${onlineCount + 1}" />
						<tr>
							<td>
								<c:if test="${not empty event.event_thumb}">
									<img src="${event.event_thumb}" alt="썸네일" width="40" height="40" style="object-fit: cover;">
								</c:if>
								<c:if test="${empty event.event_thumb}">-</c:if>
							</td>
							<td style="text-align: left; padding-left: 5px;">
								<a href="/event/eventView?event_no=${event.event_no}">${event.event_title}</a>
			 		        </td>
							<td>
								<fmt:formatDate value="${event.event_start}" pattern="yy-MM-dd" />~<fmt:formatDate value="${event.event_end}" pattern="yy-MM-dd" />
							</td>
							<td>${event.event_pet_type}</td>
							<td>
							    <button type="button" onclick="location.href='/admin/eventUpdateForm?event_no=${event.event_no}'" style="padding: 2px 4px; font-size: 11px;">수정</button>
							    <button type="button" onclick="deleteEvent(${event.event_no})" style="padding: 2px 4px; font-size: 11px; background-color: #ff4d4d; color: white; border: none;">삭제</button>
							</td>
						</tr>
					</c:if>
				</c:forEach>
				
				<c:if test="${onlineCount == 0}">
					<tr>
						<td colspan="5" align="center" style="padding: 20px;">등록된 온라인 이벤트가 없습니다.</td>
					</tr>
				</c:if>
			</table>
		</section>
		
		<!-- 오프라인 영역 (오른쪽) -->
		<section class="event-section">
			<h3>등록한 이벤트 목록 - 오프라인</h3>
			<table border="1" style="width: 100%; border-collapse: collapse; text-align: center; font-size: 13px;">
				<tr style="background: #f2f2f2;">
					<td>이미지</td>
					<td>행사명</td>
					<td>행사일자</td>
					<td>지역</td>
					<td>관리</td>
				</tr>
				
				<c:set var="offlineCount" value="0" />
				<c:forEach var="event" items="${write}">
					<c:if test="${event.event_onoff eq '오프라인'}">
						<c:set var="offlineCount" value="${offlineCount + 1}" />
						<tr>
							<td>
								<c:if test="${not empty event.event_thumb}">
									<img src="${event.event_thumb}" alt="썸네일" width="40" height="40" style="object-fit: cover;">
								</c:if>
								<c:if test="${empty event.event_thumb}">-</c:if>
							</td>
							<td style="text-align: left; padding-left: 5px;">
								<a href="/event/eventView?event_no=${event.event_no}">${event.event_title}</a>
			 		        </td>
							<td>
								<fmt:formatDate value="${event.event_start}" pattern="yy-MM-dd" />~<fmt:formatDate value="${event.event_end}" pattern="yy-MM-dd" />
							</td>
							<td>${empty event.event_loc ? '-' : event.event_loc}</td>
							<td>
							    <button type="button" onclick="location.href='/admin/eventUpdateForm?event_no=${event.event_no}'" style="padding: 2px 4px; font-size: 11px;">수정</button>
							    <button type="button" onclick="deleteEvent(${event.event_no})" style="padding: 2px 4px; font-size: 11px; background-color: #ff4d4d; color: white; border: none;">삭제</button>
							</td>
						</tr>
					</c:if>
				</c:forEach>
				
				<c:if test="${offlineCount == 0}">
					<tr>
						<td colspan="5" align="center" style="padding: 20px;">등록된 오프라인 이벤트가 없습니다.</td>
					</tr>
				</c:if>
			</table>
		</section>
		
	</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
<script>
function deleteEvent(event_no) {
    if (confirm("정말 이 이벤트를 삭제하시겠습니까?")) {
        location.href = "/admin/eventDelete?event_no=" + event_no;
    }
}
</script>
</html>