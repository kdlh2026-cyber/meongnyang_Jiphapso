<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이벤트 관리(등록 및 신청 조회)</title>
<link rel="stylesheet" href="/css/event/eventManage.css">
</head>
<body>
<%@ include file="/WEB-INF/views/admin/clone/hamburger_menu.jsp" %>

    <!-- 전체를 감싸는 메인 컨테이너 -->
    <div class="event-manage-container">
    
        <!-- 1. 행사 제보 신청 내역 영역 -->
        <div class="event-report-section">
            <div class="event-header-row">
                <h3>이벤트 신청 내역</h3>
                <button type="button" class="btn-event-write" onclick="location.href='/admin/eventWriteForm'">
                    이벤트 등록하기
                </button>
            </div>
            
            <table class="event-table">
                <thead>
                    <tr>
                        <th style="width: 13%;">신청 일자</th>
                        <th style="width: 37%;">행사 링크</th>
                        <th style="width: 30%;">행사 설명</th>
                        <th style="width: 10%;">신청자</th>
                        <th style="width: 10%;">관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="r" items="${report}">
                        <tr>
                            <td>
                                <fmt:formatDate value="${r.report_date}" pattern="yyyy-MM-dd HH" />
                            </td>
                            <td class="text-left text-ellipsis">
                                <a href="${r.report_link}" target="_blank" class="event-link">${r.report_link}</a>
                            </td>
                            <td class="text-ellipsis">${r.report_content}</td>
                            <td>${r.m_id}</td>
                            <td>
                            	<button type="button" class="btn-sm btn-delete" onclick="deleteReport(${r.report_no})">삭제</button>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty report}">
                        <tr>
                            <td colspan="4" class="empty-msg">신청된 내역이 없습니다.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <hr class="section-divider">

        <!-- 관리자 필터 바 -->
        <div class="admin-filter-bar">
            <a href="/admin/eventManage?event_pet_type=" class="${empty param.event_pet_type ? 'active' : ''}">전체</a>
            <a href="/admin/eventManage?event_pet_type=강아지" class="${param.event_pet_type eq '강아지' ? 'active' : ''}">강아지</a>
            <a href="/admin/eventManage?event_pet_type=고양이" class="${param.event_pet_type eq '고양이' ? 'active' : ''}">고양이</a>
        </div>

        <!-- 2 & 3. 온라인(좌) / 오프라인(우) 목록 좌우 배치 컨테이너 -->
        <div class="event-tables-container">
        
            <!-- 온라인 영역 (왼쪽) -->
            <section class="event-section">
                <h3>[온라인] 이벤트 목록</h3>
                <table class="event-table event-table-sm">
                    <thead>
                        <tr>
                            <th style="width: 12%;">이미지</th>
                            <th style="width: 38%;">행사명</th>
                            <th style="width: 25%;">행사일자</th>
                            <th style="width: 10%;">대상</th>
                            <th style="width: 15%;">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:set var="onlineCount" value="0" />
                        <c:forEach var="event" items="${write}">
                            <c:if test="${event.event_onoff eq '온라인'}">
                                <c:set var="onlineCount" value="${onlineCount + 1}" />
                                <tr>
                                    <td>
                                        <c:if test="${not empty event.event_thumb}">
                                            <img src="${event.event_thumb}" alt="썸네일" class="event-thumb">
                                        </c:if>
                                        <c:if test="${empty event.event_thumb}">-</c:if>
                                    </td>
                                    <td class="text-left text-ellipsis">
                                        <a href="/event/eventView?event_no=${event.event_no}">${event.event_title}</a>
                                    </td>
                                    <td class="nowrap">
									    <c:choose>
									        <%-- 상시진행 값이 'Y'인 경우 --%>
									        <c:when test="${event.event_all eq 'Y'}">
									            상시진행
									        </c:when>
									        <%-- 그 외 날짜가 있는 경우 --%>
									        <c:otherwise>
									            <fmt:formatDate value="${event.event_start}" pattern="yy-MM-dd" />~<fmt:formatDate value="${event.event_end}" pattern="yy-MM-dd" />
									        </c:otherwise>
									    </c:choose>
									</td>
                                    <td class="nowrap">${event.event_pet_type}</td>
                                    <td class="nowrap">
                                        <button type="button" class="btn-sm btn-edit" onclick="location.href='/admin/eventUpdateForm?event_no=${event.event_no}'">수정</button>
                                        <button type="button" class="btn-sm btn-delete" onclick="deleteEvent(${event.event_no})">삭제</button>
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>
                        
                        <c:if test="${onlineCount == 0}">
                            <tr>
                                <td colspan="5" class="empty-msg">등록된 온라인 이벤트가 없습니다.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </section>
            
            <!-- 오프라인 영역 (오른쪽) -->
            <section class="event-section">
                <h3>[오프라인] 이벤트 목록</h3>
                <table class="event-table event-table-sm">
                    <thead>
                        <tr>
                            <th style="width: 12%;">이미지</th>
                            <th style="width: 38%;">행사명</th>
                            <th style="width: 25%;">행사일자</th>
                            <th style="width: 10%;">지역</th>
                            <th style="width: 15%;">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:set var="offlineCount" value="0" />
                        <c:forEach var="event" items="${write}">
                            <c:if test="${event.event_onoff eq '오프라인'}">
                                <c:set var="offlineCount" value="${offlineCount + 1}" />
                                <tr>
                                    <td>
                                        <c:if test="${not empty event.event_thumb}">
                                            <img src="${event.event_thumb}" alt="썸네일" class="event-thumb">
                                        </c:if>
                                        <c:if test="${empty event.event_thumb}">-</c:if>
                                    </td>
                                    <td class="text-left text-ellipsis">
                                        <a href="/event/eventView?event_no=${event.event_no}">${event.event_title}</a>
                                    </td>
                                    <td class="nowrap">
									    <c:choose>
									        <%-- 상시진행 값이 'Y'인 경우 --%>
									        <c:when test="${event.event_all eq 'Y'}">
									            상시진행
									        </c:when>
									        <%-- 그 외 날짜가 있는 경우 --%>
									        <c:otherwise>
									            <fmt:formatDate value="${event.event_start}" pattern="yy-MM-dd" />~<fmt:formatDate value="${event.event_end}" pattern="yy-MM-dd" />
									        </c:otherwise>
									    </c:choose>
									</td>
                                    <td class="nowrap">${empty event.event_loc ? '-' : event.event_loc}</td>
                                    <td class="nowrap">
                                        <button type="button" class="btn-sm btn-edit" onclick="location.href='/admin/eventUpdateForm?event_no=${event.event_no}'">수정</button>
                                        <button type="button" class="btn-sm btn-delete" onclick="deleteEvent(${event.event_no})">삭제</button>
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>
                        
                        <c:if test="${offlineCount == 0}">
                            <tr>
                                <td colspan="5" class="empty-msg">등록된 오프라인 이벤트가 없습니다.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </section>
            
        </div>
    </div>
<button id="scrollTopBtn" title="맨 위로 가기">⬆</button>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
<script>
//⭐️ 제보 신청 내역 삭제 함수 추가
function deleteReport(report_no) {
    if (confirm("정말 이 제보 내역을 삭제하시겠습니까?")) {
        location.href = "/admin/eventReportDelete?report_no=" + report_no;
    }
}

//이벤트 삭제 함수
function deleteEvent(event_no) {
    if (confirm("정말 이 이벤트를 삭제하시겠습니까?")) {
        location.href = "/admin/eventDelete?event_no=" + event_no;
    }
}

// 스크롤 위치에 따라 버튼 노출 여부 결정
window.addEventListener('scroll', function() {
    const scrollTopBtn = document.getElementById('scrollTopBtn');
    if (window.scrollY > 200) {
        scrollTopBtn.style.display = 'block'; // 200px 이상 내려가면 보임
    } else {
        scrollTopBtn.style.display = 'none';  // 맨 위면 숨김
    }
});

// 버튼 클릭 시 맨 위로 부드럽게 이동
document.getElementById('scrollTopBtn').addEventListener('click', function() {
    window.scrollTo({
        top: 0,
        behavior: 'smooth'
    });
});
</script>
</html>