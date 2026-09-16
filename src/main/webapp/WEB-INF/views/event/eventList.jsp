<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이벤트 게시글 목록</title>
<link rel="stylesheet" href="/css/event/eventList.css">
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>

    <!-- 전체 감싸는 메인 래퍼 (좌우 여백 및 헤더 간격 통일) -->
    <div class="event_wrap">

        <!-- 행사 제보하기 배너 영역 -->
        <div class="event-banner-box">
            <div>
                <div class="banner-title">행사를 준비 중이신가요?</div>
                <div class="banner-desc">이벤트 안내 링크만 남겨주시면, 저희가 확인 후 무료로 등록해드려요.</div>
            </div>
            <div>
                <button type="button" class="banner-btn" id="openReportModal">행사 제보하기</button>
            </div>
        </div>

        <!-- 행사 제보하기 모달 팝업 구조 -->
        <div class="modal-overlay" id="reportModal">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="modal-title">행사 제보하기</div>
                    <button type="button" class="modal-close" id="closeReportModal">&times;</button>
                </div>
                <div class="modal-desc">
                    행사 안내 페이지 <b>링크만</b> 남겨주시면 돼요. 포스터·일정·장소는 저희가 링크에서 확인해 정리합니다.
                </div>
                
                <form action="/event/eventReport" method="post">
                    <div class="form-group">
                        <label class="form-label">행사 안내 링크 <span>*</span></label>
                        <input type="text" name="report_link" class="form-input" placeholder="https://example.com/2026-펫페어" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">남기실 말씀 (선택)</label>
                        <input type="text" name="report_content" class="form-input" placeholder="예) 사전등록은 8/1까지예요">
                    </div>
                    <button type="submit" class="modal-submit-btn">제보 보내기</button>
                </form>
                
                <div class="modal-footer-desc">
                    제보해주신 링크는 담당자 확인 후 등록되며, 광고성·무관한 링크는 등록되지 않을 수 있어요.
                </div>
            </div>
        </div>

        <!-- 온라인/오프라인 구분 탭 -->
        <div class="category_tabs">
            <a href="/event/eventList?event_onoff=&amp;event_pet_type=${param.event_pet_type}" class="${empty param.event_onoff ? 'active' : ''}">전체</a>
            <a href="/event/eventList?event_onoff=온라인&amp;event_pet_type=${param.event_pet_type}" class="${param.event_onoff eq '온라인' ? 'active' : ''}">온라인</a>
            <a href="/event/eventList?event_onoff=오프라인&amp;event_pet_type=${param.event_pet_type}" class="${param.event_onoff eq '오프라인' ? 'active' : ''}">오프라인</a>
        </div>

        <!-- 서브 필터 및 전체 개수 행 -->
        <div class="filter_count_row">
            <div class="sub_filter">
                <a href="/event/eventList?event_onoff=${param.event_onoff}&amp;event_pet_type=" class="${empty param.event_pet_type ? 'active' : ''}">전체</a>
                <a href="/event/eventList?event_onoff=${param.event_onoff}&amp;event_pet_type=강아지" class="${param.event_pet_type eq '강아지' ? 'active' : ''}">강아지</a>
                <a href="/event/eventList?event_onoff=${param.event_onoff}&amp;event_pet_type=고양이" class="${param.event_pet_type eq '고양이' ? 'active' : ''}">고양이</a>
            </div>
            <div class="total_count">전체 ${list.size()}개</div>
        </div>

        <c:if test="${empty list}">
            <p class="empty_text">등록된 이벤트가 없습니다.</p>
        </c:if>

        <!-- 3열 그리드 컨테이너 -->
        <div class="event-list-container">
	    <c:forEach var="event" items="${list}">
	        <!-- 💡 종료된 경우 'event-ended' 클래스가 동적으로 붙도록 수정 -->
	        <div class="event-card" data-end-date="<fmt:formatDate value='${event.event_end}' pattern='yyyy-MM-dd' />">
	           <div class="card_top_info">
				    <div class="tag_container">
				        <!-- 1. 상태 뱃지 (상시진행 / 종료 / 진행중) -->
				        <c:choose>
				            <c:when test="${event.event_all eq 'Y'}">
				                <span class="event-badge badge-ongoing">상시진행</span>
				            </c:when>
				            <c:when test="${not empty event.event_end and now.after(event.event_end)}">
				                <span class="event-badge badge-ended">종료</span>
				            </c:when>
				            <c:otherwise>
				                <span class="event-badge badge-ongoing">진행중</span>
				            </c:otherwise>
				        </c:choose>
				        
				        <!-- 2. 온라인 / 오프라인 여부에 따른 하위 항목 분기 출력 -->
				        <c:choose>
				            <c:when test="${event.event_onoff eq '온라인'}">
				                <span class="event-tag tag-onoff">${event.event_onoff}</span>
				                <span class="event-tag tag-pet">${event.event_pet_type}</span>
				            </c:when>
				            <c:otherwise>
				                <!-- 오프라인일 때 출력할 항목 (예: 반려동물 타입 + 지역 등 DB 컬럼에 맞게 조절) -->
				                <c:if test="${not empty event.event_pet_type}">
				                    <span class="event-tag tag-pet">${event.event_pet_type}</span>
				                </c:if>
				                <c:if test="${not empty event.event_loc}">
				                    <span class="event-tag tag-loc">📍 ${event.event_loc}</span>
				                </c:if>
				            </c:otherwise>
				        </c:choose>
				    </div>
				</div>
	            
	            <div class="preview_content_box">
	                <img src="${event.event_thumb}" alt="이벤트 썸네일">
	            </div>
	
	            <div class="card_title_area">
	                <a href="/event/eventView?event_no=${event.event_no}">${event.event_title}</a>
	            </div>
	
	            <div class="card_date_loc">
	                <c:if test="${event.event_all ne 'Y'}">
	                    <div class="date_text">
	                        <fmt:formatDate value="${event.event_start}" pattern="yyyy.MM.dd" /> ~
	                        <fmt:formatDate value="${event.event_end}" pattern="yyyy.MM.dd" />
	                    </div>
	                </c:if>
	                <c:if test="${event.event_onoff eq 'off' and not empty event.event_loc}">
	                    <div class="loc_text">장소: ${event.event_loc}</div>
	                </c:if>
	            </div>
	        </div>
	    </c:forEach>
	</div>

    </div><!-- .event_wrap 닫기 -->

<%@ include file="/WEB-INF/views/footer.jsp" %>

<c:if test="${not empty msg}">
    <script>
        alert("${msg}");
    </script>
</c:if>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const openBtn = document.getElementById("openReportModal");
    const modal = document.getElementById("reportModal");
    const closeBtn = document.getElementById("closeReportModal");

    const isLoggedIn = "${pageContext.request.userPrincipal != null}"; 

    if (openBtn) {
        openBtn.addEventListener("click", function(e) {
            if (isLoggedIn === "false") {
                alert("로그인 후 이용 가능한 서비스입니다.");
                location.href = "/loginForm"; 
                return; 
            }

            if (modal) {
                modal.style.display = "flex";
            }
        });
    }

    if (closeBtn && modal) {
        closeBtn.addEventListener("click", function() {
            modal.style.display = "none";
        });
    }
    
    const today = new Date();
    today.setHours(0, 0, 0, 0); // 시간 비교 제외하고 날짜만 비교

    document.querySelectorAll('.event-card').forEach(card => {
        const endDateStr = card.getAttribute('data-end-date');
        if (endDateStr) {
            const endDate = new Date(endDateStr);
            endDate.setHours(0, 0, 0, 0);

            // 오늘 날짜가 종료일보다 크면(기간이 지났으면)
            if (today > endDate) {
                card.classList.add('event-ended'); // 1. 카드 전체 연하게 처리
                
                // 2. 상단 뱃지도 '종료'로 변경 (상시진행이 아닐 경우에만)
                const badge = card.querySelector('.event-badge');
                if (badge && badge.textContent !== '상시진행') {
                    badge.textContent = '종료';
                    badge.classList.remove('badge-ongoing');
                    badge.classList.add('badge-ended');
                }
            }
        }
    });
});
</script>
</body>
</html>