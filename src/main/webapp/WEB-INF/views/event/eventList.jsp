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

/* 행사 제보하기 배너 스타일 */
.event-banner-box {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: #ffffff;
    border: 1px solid #eee;
    border-radius: 12px;
    padding: 20px 24px;
    margin: 30px 0;
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

/* 💡 모달 팝업 스타일 */
.modal-overlay {
    display: none; /* 평소엔 숨김 */
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

	<!-- 온라인/오프라인 구분 -->
	<div class="category_tabs">
	    <a href="/event/eventList?event_onoff=online" class="${param.event_onoff eq 'online' ? 'active' : ''}">온라인</a>
	    <a href="/event/eventList?event_onoff=offline" class="${param.event_onoff eq 'offline' ? 'active' : ''}">오프라인</a>
	</div>

    <!-- 반려동물 종류 필터 -->
    <div class="sub_filter">
	    <a href="/event/eventList?event_onoff=${empty param.event_onoff ? '' : param.event_onoff}&amp;event_pet_type=" class="${empty param.event_pet_type ? 'active' : ''}">전체</a>
	    <a href="/event/eventList?event_onoff=${empty param.event_onoff ? '' : param.event_onoff}&amp;event_pet_type=dog" class="${param.event_pet_type eq 'dog' ? 'active' : ''}">강아지</a>
	    <a href="/event/eventList?event_onoff=${empty param.event_onoff ? '' : param.event_onoff}&amp;event_pet_type=cat" class="${param.event_pet_type eq 'cat' ? 'active' : ''}">고양이</a>
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
                <a href="/event/eventView?event_no=${event.event_no}">${event.event_title}</a>
            </div>
            <div class="preview_content">
            	<img src="${event.event_thumb}" alt="이벤트 썸네일" style="max-width: 300px; height: auto;">
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

    <div class="pagination">
        <a href="/event/eventList?event_onoff=${param.event_onoff}&event_pet_type=${param.event_pet_type}&sort=${param.sort}&page=${pageNum > 1 ? pageNum - 1 : 1}">PREV</a>
        <c:forEach var="i" begin="1" end="${totalPages}">
            <a href="/event/eventList?event_onoff=${param.event_onoff}&event_pet_type=${param.event_pet_type}&sort=${param.sort}&page=${i}"
               class="${pageNum eq i ? 'active' : ''}">${i}</a>
        </c:forEach>
        <a href="/event/eventList?event_onoff=${param.event_onoff}&event_pet_type=${param.event_pet_type}&sort=${param.sort}&page=${pageNum < totalPages ? pageNum + 1 : totalPages}">NEXT</a>
    </div>

    <!-- 행사 제보하기 배너 영역 -->
    <div class="event-banner-box">
        <div>
            <div class="banner-title">행사를 준비 중이신가요?</div>
            <div class="banner-desc">이벤트 안내 링크만 남겨주시면, 저희가 확인 후 무료로 등록해드려요.</div>
        </div>
        <div>
            <!-- 💡 버튼 클릭 시 모달이 열리도록 수정 -->
            <button type="button" class="banner-btn" id="openReportModal">행사 제보하기</button>
        </div>
    </div>

    <!-- 💡 행사 제보하기 모달 팝업 구조 -->
    <div class="modal-overlay" id="reportModal">
        <div class="modal-content">
            <div class="modal-header">
                <div class="modal-title">행사 제보하기</div>
                <button type="button" class="modal-close" id="closeReportModal">&times;</button>
            </div>
            <div class="modal-desc">
                행사 안내 페이지 <b>링크만</b> 남겨주시면 돼요. 포스터·일정·장소는 저희가 링크에서 확인해 정리합니다.
            </div>
            
            <!-- 실제 제보 전송 폼 -->
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
    
<%@ include file="/WEB-INF/views/footer.jsp" %>

<c:if test="${not empty msg}">
    <script>
        alert("${msg}");
    </script>
</c:if>

<!-- 💡 모달 여닫기 스크립트 -->
<script>
document.addEventListener("DOMContentLoaded", function() {
    const openBtn = document.getElementById("openReportModal");
    const modal = document.getElementById("reportModal");
    const closeBtn = document.getElementById("closeReportModal");

    // 1. 서버의 로그인 상태를 JS 변수로 가져오기 
    // (스프링 시큐리티를 사용 중이므로 userPrincipal이 null이 아니면 로그인 상태입니다)
    const isLoggedIn = "${pageContext.request.userPrincipal != null}"; 
    // 만약 세션에 따로 담아둔 유저 객체가 있다면 "${not empty sessionScope.loginUser}" 로 쓰셔도 됩니다.

    if (openBtn) {
        openBtn.addEventListener("click", function(e) {
            // 2. 로그인이 안 되어 있다면?
            if (isLoggedIn === "false") {
                alert("로그인 후 이용 가능한 서비스입니다.");
                location.href = "/loginForm"; // WebSecurityConfig에 설정한 로그인 페이지 주소
                return; // 모달이 열리지 않도록 중단
            }

            // 3. 로그인되어 있다면 모달 열기
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