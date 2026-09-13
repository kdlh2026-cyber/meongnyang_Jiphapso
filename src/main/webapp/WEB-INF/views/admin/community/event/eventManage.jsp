<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이벤트 관리(등록 및 신청 조회)</title>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
	<div>
		<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
	        <h3 style="margin: 0;">이벤트 신청 내역</h3>
	        
	        <!-- 이벤트 등록하기 버튼 -->
	        <button type="button" onclick="location.href='/admin/eventWriteForm'" style="background-color: #222; color: #fff; padding: 8px 16px; border: none; border-radius: 8px; font-size: 14px; font-weight: bold; cursor: pointer;">
	            이벤트 등록하기
	        </button>
	    </div>
		<table border="1">
			<tr>
				<td>신청 일자</td>
				<td>행사 링크</td>
				<td>행사 설명</td>
				<td>신청자</td>
			</tr>
			<c:forEach var="r" items="${report}">
                <tr>
                    <td>
                        <fmt:formatDate value="${r.report_date}" pattern="yyyy-MM-dd HH" />
                    </td>
                    <td>
                    	<a href="${r.report_link}" target="_blank">${r.report_link}</a>
                    </td>
                    <td>${r.report_content}</td>
                    <td>${r.m_no}</td>
                </tr>
            </c:forEach>
            
            <c:if test="${empty report}">
                <tr>
                    <td colspan="4" align="center">신청된 내역이 없습니다.</td>
                </tr>
            </c:if>
		</table>
	</div>
	

	
	<div>
		<h3>등록한 이벤트 목록</h3>
		
		<table border="1">
			<tr>
				<td>이미지</td>
				<td>행사명</td>
				<td>행사일자 | 상시여부</td>
				<td>대상 반려동물</td>
				<td>온/오프라인</td>
				<td>이벤트 지역</td>
				<td>수정/삭제</td>
			</tr>
			
			<c:forEach var="event" items="${write}">
				<tr>
					<!-- 썸네일 이미지 출력 -->
					<td>
						<c:if test="${not empty event.event_thumb}">
							<img src="${event.event_thumb}" alt="썸네일" width="50" height="50" style="object-fit: cover;">
						</c:if>
						<c:if test="${empty event.event_thumb}">
							이미지 없음
						</c:if>
					</td>
					<!-- 행사명 -->
					<td>
						<a href="/event/eventView?event_no=${event.event_no}">${event.event_title}</a>
            		</td>
					<!-- 행사일자 (상시여부 Y/N에 따른 분기나 날짜 포맷 적용 가능) -->
					<td>
						<fmt:formatDate value="${event.event_start}" pattern="yyyy-MM-dd" /> ~ 
						<fmt:formatDate value="${event.event_end}" pattern="yyyy-MM-dd" /> 
						(${event.event_all eq 'Y' ? '상시' : '기간 지정'})
					</td>
					<!-- 대상 반려동물 (dog / cat) -->
					<td>${event.event_pet_type}</td>
					<!-- 온/오프라인 -->
					<td>${event.event_onoff}</td>
					<!-- 이벤트 지역 (온라인일 경우 비어있을 수 있음) -->
					<td>${empty event.event_loc ? '-' : event.event_loc}</td>
					<td>
						<!-- 수정 버튼: 수정 폼 페이지로 이동하면서 event_no 전달 -->
					    <button type="button" onclick="location.href='/admin/eventUpdateForm?event_no=${event.event_no}'" 
					            style="padding: 4px 8px; font-size: 12px; cursor: pointer;">수정</button>
					            
					    <!-- 삭제 버튼: 자바스크립트 확인창을 띄운 후 삭제 처리 경로로 이동 -->
					    <button type="button" onclick="deleteEvent(${event.event_no})" 
					            style="padding: 4px 8px; font-size: 12px; background-color: #ff4d4d; color: #white; border: none; cursor: pointer;">삭제</button>
					</td>
				</tr>
			</c:forEach>
			
			<c:if test="${empty write}">
				<tr>
					<td colspan="6" align="center">등록된 이벤트가 없습니다.</td>
				</tr>
			</c:if>
		</table>
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