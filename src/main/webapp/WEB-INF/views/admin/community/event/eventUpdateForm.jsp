<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이벤트 수정</title>
<!-- 이벤트 등록 폼과 동일한 CSS 적용 -->
<link rel="stylesheet" href="/css/event/eventWrite.css">
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Summernote 에디터 -->
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
</head>
<body>
<%@ include file="/WEB-INF/views/admin/clone/hamburger_menu.jsp" %>

<div class="event-write-container">
    <h2>이벤트 수정</h2>
    
    <form name="eventUpdateForm" method="post" action="/admin/eventUpdate" enctype="multipart/form-data">
        
        <!-- 식별용 PK 숨김 필드 -->
        <input type="hidden" name="event_no" value="${event.event_no}">
        <!-- 기존 썸네일 파일 유지용 숨김 필드 -->
        <input type="hidden" name="event_thumb" value="${event.event_thumb}">
        
        <!-- 1. 제목 입력 -->
        <div class="form-row">
            <input type="text" name="event_title" class="input-title" value="${event.event_title}" placeholder="행사명을 입력해주세요" required>
        </div>
        
        <!-- 2. 대상 반려동물 & 진행 방식 (2분할 행) -->
        <div class="form-row-grid">
            <div class="grid-item">
                <label class="section-label">대상 반려동물</label>
                <div class="pill-group">
                    <input type="radio" name="event_pet_type" value="강아지" id="pet_dog" ${event.event_pet_type eq '강아지' ? 'checked' : ''}> 
                    <label for="pet_dog" class="pill-btn">강아지</label>
                    
                    <input type="radio" name="event_pet_type" value="고양이" id="pet_cat" ${event.event_pet_type eq '고양이' ? 'checked' : ''}> 
                    <label for="pet_cat" class="pill-btn">고양이</label>
                </div>
            </div>
            
            <div class="grid-item">
                <label class="section-label">진행방식</label>
                <div class="pill-group">
                    <input type="radio" name="event_onoff" value="온라인" id="onoff_on" ${event.event_onoff eq '온라인' ? 'checked' : ''}> 
                    <label for="onoff_on" class="pill-btn">온라인</label>
                    
                    <input type="radio" name="event_onoff" value="오프라인" id="onoff_off" ${event.event_onoff eq '오프라인' ? 'checked' : ''}> 
                    <label for="onoff_off" class="pill-btn">오프라인</label>
                </div>
            </div>
        </div>

        <!-- 3. 이벤트 기간 및 장소 -->
        <div class="form-row period-loc-box">
            <label class="section-label">이벤트 기간 및 장소</label>
            
            <div class="period-inputs">
                <div class="date-input-wrap">
                    <span class="sub-label">시작일</span>
                    <input type="date" name="event_start" id="eventStart" value="<fmt:formatDate value='${event.event_start}' pattern='yyyy-MM-dd'/>">
                </div>
                <span class="wave">~</span>
                <div class="date-input-wrap">
                    <span class="sub-label">종료일</span>
                    <input type="date" name="event_end" id="eventEnd" value="<fmt:formatDate value='${event.event_end}' pattern='yyyy-MM-dd'/>">
                </div>
                <div class="checkbox-wrap">
                    <input type="checkbox" name="event_all" value="Y" id="eventAllCheck" ${event.event_all eq 'Y' ? 'checked' : ''}>
                    <label for="eventAllCheck">상시진행</label>
                </div>
            </div>

            <div class="loc-input-wrap">
                <span class="sub-label">행사 장소</span>
                <input type="text" name="event_loc" id="eventLoc" value="${event.event_loc}" placeholder="예) 서울 강남구 코엑스 홀 A" maxlength="20">
            </div>
        </div>	

        <!-- 4. 이벤트 상세 내용 -->
        <div class="form-row body_content">
            <label class="section-label">이벤트 상세 내용</label>
            <textarea rows="20" cols="50" id="eventContent" name="event_content" placeholder="상세내용">${event.event_content}</textarea>
        </div>
        
        <!-- 5. 하단 영역 (대표 썸네일 & 제출 버튼) -->
        <div class="form-bottom-row">
            <div class="thumb-wrap">
                <label class="section-label">대표 썸네일 이미지</label>
                
                <!-- 기존 등록된 이미지 안내 텍스트 -->
                <c:if test="${not empty event.event_thumb}">
                    <div style="font-size: 13px; color: #666; margin-bottom: 4px;">
                        현재 파일: <a href="${event.event_thumb}" target="_blank" style="color: #ff6f61; text-decoration: underline;">${event.event_thumb}</a>
                    </div>
                </c:if>

                <div class="custom-file-box">
                    <input type="file" name="thumbFile" id="thumbFile" accept="image/*">
                    <label for="thumbFile" class="file-search-btn">파일 선택</label>
                    <span class="file-name-text" id="fileName">새로운 파일을 선택하려면 누르세요</span>
                    <button type="button" class="file-clear-btn" id="fileClearBtn" style="display: none;">&times;</button>
                </div>
            </div>
            
            <div class="form-button-wrap">
                <button type="submit" class="btn-submit">수정하기</button>
                <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
            </div>
        </div>
    </form>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const eventAllCheck = document.getElementById("eventAllCheck");
    const eventStart = document.getElementById("eventStart");
    const eventEnd = document.getElementById("eventEnd");

    const onoffOn = document.getElementById("onoff_on");
    const onoffOff = document.getElementById("onoff_off");
    const eventLoc = document.getElementById("eventLoc");

    // 1. 상시 진행 체크 상태 반영 및 제어
    function toggleAllCheck() {
        if(eventAllCheck.checked) {
            eventStart.value = "";
            eventEnd.value = "";
            eventStart.readOnly = true;
            eventEnd.readOnly = true;
            eventStart.style.backgroundColor = "#eee";
            eventEnd.style.backgroundColor = "#eee";
        } else {
            eventStart.readOnly = false;
            eventEnd.readOnly = false;
            eventStart.style.backgroundColor = "#fff";
            eventEnd.style.backgroundColor = "#fff";
        }
    }
    eventAllCheck.addEventListener("change", toggleAllCheck);
    toggleAllCheck(); // 페이지 최초 로드 시 실행

    // 2. 온/오프라인 선택에 따른 장소 제어
    function toggleLocation() {
        if (onoffOn.checked) {
            eventLoc.readOnly = true;
            eventLoc.style.backgroundColor = "#eee";
            eventLoc.placeholder = "온라인 이벤트는 장소가 필요 없습니다.";
        } else {
            eventLoc.readOnly = false;
            eventLoc.style.backgroundColor = "#fff";
            eventLoc.placeholder = "예) 서울 강남구 코엑스 홀 A";
        }
    }

    onoffOn.addEventListener("change", function() {
        eventLoc.value = ""; 
        toggleLocation();
    });
    onoffOff.addEventListener("change", toggleLocation);
    toggleLocation(); // 페이지 최초 로드 시 실행

    // 3. 파일 선택 및 삭제(X) 제어
    const thumbFileInput = document.getElementById("thumbFile");
    const fileNameText = document.getElementById("fileName");
    const fileClearBtn = document.getElementById("fileClearBtn");

    if (thumbFileInput) {
        thumbFileInput.addEventListener("change", function() {
            if (this.files && this.files.length > 0) {
                fileNameText.textContent = this.files[0].name;
                fileNameText.style.color = "#333";
                fileClearBtn.style.display = "inline-flex";
            } else {
                resetFileInput();
            }
        });
    }

    if (fileClearBtn) {
        fileClearBtn.addEventListener("click", function() {
            resetFileInput();
        });
    }

    function resetFileInput() {
        if (thumbFileInput) thumbFileInput.value = "";
        if (fileNameText) {
            fileNameText.textContent = "새로운 파일을 선택하려면 누르세요";
            fileNameText.style.color = "#888";
        }
        if (fileClearBtn) fileClearBtn.style.display = "none";
    }
});

$(document).ready(function() {
    $('#eventContent').summernote({
        placeholder: '상세내용',
        tabsize: 2,
        height: 350,
        lang: 'ko-KR'
    });

    $("form[name='eventUpdateForm']").on("submit", function() {
        if ($("#eventAllCheck").is(":checked")) {
            $("#eventStart").val("");
            $("#eventEnd").val("");
        }
    });
});
</script>
</body>
</html>