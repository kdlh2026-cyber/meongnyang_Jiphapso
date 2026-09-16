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
<style>
/* 💡 썸네일을 1:1 정사각형 비율로 고정하는 컨테이너 */
.preview_content {
    width: 100%;
    aspect-ratio: 1 / 1; /* 가로 세로 비율을 1:1(정사각형)로 유지 */
    overflow: hidden;
    border-radius: 6px; /* 모서리를 둥글게 처리 (선택사항) */
    background: #f9f9f9;
    margin: 10px 0;
}

.preview_content img {
    width: 100%;
    height: 100%;
    object-fit: cover; /* 비율을 유지하며 정사각형 박스에 꽉 차게 채움 (넘치는 부분은 잘림) */
    display: block;
}

#suggestions em{
	background : Tomato;
	color : Seashell;
	font-weight : bold;
	font-style : italic;
}

/* 💡 이벤트 목록을 3열로 정렬하는 그리드 컨테이너 */
.event-list-container {
    display: grid;
    grid-template-columns: repeat(3, 1fr); /* 3개의 열을 동일한 비율로 배치 */
    gap: 20px; /* 카드 사이의 간격 */
    margin: 20px 0;
}

/* 개별 카드 스타일 */
.event-card {
    border: 1px solid #eee;
    border-radius: 10px;
    padding: 14px;
    margin-bottom: 0; /* grid의 gap으로 대체 */
    box-sizing: border-box;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}

/* 화면이 작아졌을 때(태블릿, 모바일) 반응형 처리 */
@media (max-width: 900px) {
    .event-list-container {
        grid-template-columns: repeat(2, 1fr); /* 태블릿에서는 2열 */
    }
}
@media (max-width: 600px) {
    .event-list-container {
        grid-template-columns: 1fr; /* 모바일에서는 1열 */
    }
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

/* 행사 제보하기 배너 스타일 */
/* 행사 제보하기 배너 스타일 */
.event-banner-box {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: #ffffff;
    border: 1px solid #eee;
    border-radius: 12px;
    padding: 20px 24px;
    margin: 20px 0 30px 0; /* 위쪽 여백은 줄이고(20px), 아래쪽 여백을 줌(30px) */
    box-shadow: 0 2px 6px rgba(0,0,0,0.02);
}

.banner-title {
    font-size: 16px;
    font-weight: bold;
    color: #222;
    margin-bottom: 4px;
}
.banner-desc {
    font-size: 13px;
    color: #666;
}
.banner-btn {
    background-color: #222;
    color: #fff;
    padding: 10px 20px;
    border-radius: 20px;
    text-decoration: none;
    font-size: 13px;
    font-weight: 600;
    white-space: nowrap;
    cursor: pointer;
    border: none;
}
.banner-btn:hover {
    background-color: #444;
}

/* 모달 팝업 스타일 */
.modal-overlay {
    display: none;
    position: fixed;
    top: 0; left: 0; width: 100%; height: 100%;
    background: rgba(0, 0, 0, 0.5);
    z-index: 1000;
    justify-content: center;
    align-items: center;
}
.modal-content {
    background: #fff;
    width: 100%; max-width: 480px;
    border-radius: 16px;
    padding: 30px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.15);
    position: relative;
    box-sizing: border-box;
}
.modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}
.modal-title {
    font-size: 18px;
    font-weight: bold;
    color: #222;
}
.modal-close {
    background: none; border: none;
    font-size: 20px; cursor: pointer; color: #888;
}
.modal-desc {
    font-size: 13px;
    color: #666;
    line-height: 1.4;
    margin-bottom: 20px;
}
.form-group {
    margin-bottom: 16px;
}
.form-label {
    display: block;
    font-size: 13px;
    font-weight: bold;
    color: #333;
    margin-bottom: 6px;
}
.form-label span {
    color: #e74c3c;
}
.form-input {
    width: 100%;
    padding: 12px 14px;
    border: 1px solid #ddd;
    border-radius: 8px;
    font-size: 14px;
    box-sizing: border-box;
    outline: none;
    transition: border-color 0.2s;
}
.form-input:focus {
    border-color: #222;
}
.modal-submit-btn {
    width: 100%;
    background-color: #222;
    color: #fff;
    padding: 14px;
    border: none;
    border-radius: 10px;
    font-size: 15px;
    font-weight: bold;
    cursor: pointer;
    margin-top: 10px;
}
.modal-submit-btn:hover {
    background-color: #444;
}
.modal-footer-desc {
    font-size: 11px;
    color: #888;
    text-align: center;
    margin-top: 12px;
    line-height: 1.3;
}
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
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
    

	<!-- 온라인/오프라인 구분 -->
	<div class="category_tabs">
	    <a href="/event/eventList?event_onoff=&amp;event_pet_type=${param.event_pet_type}" class="${empty param.event_onoff ? 'active' : ''}">전체(온/오프)</a>
	    <a href="/event/eventList?event_onoff=온라인&amp;event_pet_type=${param.event_pet_type}" class="${param.event_onoff eq '온라인' ? 'active' : ''}">온라인</a>
	    <a href="/event/eventList?event_onoff=오프라인&amp;event_pet_type=${param.event_pet_type}" class="${param.event_onoff eq '오프라인' ? 'active' : ''}">오프라인</a>
	</div>

    <!-- 반려동물 종류 필터 -->
    <div class="sub_filter">
	    <a href="/event/eventList?event_onoff=${param.event_onoff}&amp;event_pet_type=" class="${empty param.event_pet_type ? 'active' : ''}">전체</a>
	    <a href="/event/eventList?event_onoff=${param.event_onoff}&amp;event_pet_type=강아지" class="${param.event_pet_type eq '강아지' ? 'active' : ''}">강아지</a>
	    <a href="/event/eventList?event_onoff=${param.event_onoff}&amp;event_pet_type=고양이" class="${param.event_pet_type eq '고양이' ? 'active' : ''}">고양이</a>
	</div>

    <div>전체 ${list.size()}개</div>

    <c:if test="${empty list}">
        <p>등록된 이벤트가 없습니다.</p>
    </c:if>

    <!-- 💡 3열 그리드 컨테이너 -->
    <div class="event-list-container">
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
                    <span>${event.event_onoff}</span>
                    <span>${event.event_pet_type}</span>
                </div>
                <div>
                    <a href="/event/eventView?event_no=${event.event_no}">${event.event_title}</a>
                </div>
                <div class="preview_content">
				    <img src="${event.event_thumb}" alt="이벤트 썸네일">
				</div>
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
    </div>
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
});
</script>

</body>
</html>