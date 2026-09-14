<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이벤트 수정</title>
<link rel="stylesheet" href="/css/community/commWriteForm.css">
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Summernote 에디터 -->
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
<style>
    .form-row { margin-bottom: 15px; }
    .form-row label { font-weight: bold; margin-right: 10px; }
    .hidden { display: none; }
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>

<div style="max-width: 800px; margin: 40px auto; padding: 20px;">
    <h2>이벤트 수정</h2>
    
    <!-- 파일 업로드 및 수정을 위해 enctype="multipart/form-data" 필수 -->
    <form name="eventUpdateForm" method="post" action="/admin/eventUpdate" enctype="multipart/form-data">
        
        <!-- 어떤 글을 수정하는지 식별하기 위한 PK(event_no) 숨김 필드 -->
        <input type="hidden" name="event_no" value="${event.event_no}">
        
        <!-- 기존 썸네일 파일 유지용 (새로 업로드하지 않을 때 대비) -->
        <input type="hidden" name="event_thumb" value="${event.event_thumb}">

        <!-- EVENT_TITLE -->
        <div class="form-row title">
            <input type="text" name="event_title" value="${event.event_title}" placeholder="이벤트 제목을 입력해주세요" required style="width: 100%; padding: 10px; font-size: 16px;">
        </div>
        
        <!-- EVENT_THUMB (썸네일 파일) -->
        <div class="form-row">
            <label>대표 썸네일 이미지</label>
            <c:if test="${not empty event.event_thumb}">
                <div style="margin-bottom: 5px; font-size: 13px; color: #666;">
                    현재 등록된 이미지: <a href="${event.event_thumb}" target="_blank">${event.event_thumb}</a>
                </div>
            </c:if>
            <!-- 수정 시에는 썸네일 변경이 선택사항일 수 있으므로 required 제거 -->
            <input type="file" name="thumbFile" accept="image/*">
        </div>

        <!-- EVENT_PET_TYPE (대상 반려동물) -->
        <div class="form-row catgogry">
            <label>대상 반려동물:</label>
            <input type="radio" name="event_pet_type" value="강아지" id="pet_dog" ${event.event_pet_type eq '강아지' ? 'checked' : ''}> <label for="pet_dog">강아지</label>
            <input type="radio" name="event_pet_type" value="고양이" id="pet_cat" ${event.event_pet_type eq '고양이' ? 'checked' : ''}> <label for="pet_cat">고양이</label>
        </div>
        
        <!-- EVENT_ONOFF (진행 방식) -->
        <div class="form-row catgogry">
            <label>진행 방식:</label>
            <input type="radio" name="event_onoff" value="온라인" id="onoff_on" ${event.event_onoff eq '온라인' ? 'checked' : ''}> <label for="onoff_on">온라인</label>
            <input type="radio" name="event_onoff" value="오프라인" id="onoff_off" ${event.event_onoff eq '오프라인' ? 'checked' : ''}> <label for="onoff_off">오프라인</label>
        </div>

        <!-- EVENT_START, EVENT_END, EVENT_ALL (이벤트 기간 및 상시 여부) -->
        <div class="form-row">
            <label>이벤트 기간:</label>
            <input type="date" name="event_start" id="eventStart" value="<fmt:formatDate value='${event.event_start}' pattern='yyyy-MM-dd'/>" ${event.event_all eq 'Y' ? 'readonly style="background-color:#eee;"' : ''}> ~ 
            <input type="date" name="event_end" id="eventEnd" value="<fmt:formatDate value='${event.event_end}' pattern='yyyy-MM-dd'/>" ${event.event_all eq 'Y' ? 'readonly style="background-color:#eee;"' : ''}>
            &nbsp;&nbsp;
            <input type="checkbox" name="event_all" value="Y" id="eventAllCheck" ${event.event_all eq 'Y' ? 'checked' : ''}>
            <label for="eventAllCheck">상시 진행</label>
        </div>	

        <!-- EVENT_LOC (행사 장소) -->
        <div class="form-row" id="locWrapper">
            <label>행사 장소:</label>
            <input type="text" name="event_loc" id="eventLoc" value="${event.event_loc}" placeholder="예) 서울 강남구 코엑스 홀 A" style="width: 60%; padding: 8px;" maxlength="20">
        </div>	

        <!-- EVENT_CONTENT (본문 내용) -->
        <div class="form-row body_content">
            <label style="display: block; margin-bottom: 5px;">이벤트 상세 내용</label>
            <textarea rows="20" cols="50" id="eventContent" name="event_content" placeholder="이벤트 상세 내용을 입력해주세요." style="width: 100%; padding: 10px;">${event.event_content}</textarea>
        </div>
        
        <!-- 제출 버튼 -->
        <div style="text-align: right; margin-top: 20px;">
            <button type="submit" style="background-color: #222; color: #fff; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-weight: bold;">수정하기</button>
            <button type="button" onclick="history.back()" style="background-color: #ccc; color: #333; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; margin-left: 5px;">취소</button>
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

    // 1. 상시 진행 체크 시 날짜 제어 (초기 로드 상태 감안)
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

    // 2. 온/오프라인 선택에 따른 장소 제어
    function toggleLocation() {
        if (onoffOn.checked) {
            // 새로 온라인으로 바꾼 경우에만 값을 비우고, 처음 로딩될 때는 기존 값을 유지하고 싶다면 아래 조건 조절 가능
            if(eventLoc.value === "온라인" || eventLoc.readOnly) {
                // 기존 값이 유지되도록 하되 readonly 처리
            }
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
        eventLoc.value = ""; // 사용자가 직접 온라인을 체크하면 장소 비우기
        toggleLocation();
    });
    
    onoffOff.addEventListener("change", toggleLocation);
    
    // 페이지 로드 시 최초 실행하여 기존 데이터 상태 반영
    toggleLocation();
});

$(document).ready(function() {
    $('#eventContent').summernote({
        placeholder: '이벤트 상세 내용을 입력해주세요. (이미지 첨부 가능)',
        tabsize: 2,
        height: 400,
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