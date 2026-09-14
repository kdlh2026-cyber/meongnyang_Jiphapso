<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이벤트 등록</title>
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
    <h2>이벤트 등록</h2>
    
    <!-- 파일 업로드를 위해 enctype="multipart/form-data" 필수 -->
    <form name="eventWriteForm" method="post" action="/event/eventWrite" enctype="multipart/form-data">
        
        <!-- EVENT_TITLE -->
        <div class="form-row title">
            <input type="text" name="event_title" placeholder="이벤트 제목을 입력해주세요" required style="width: 100%; padding: 10px; font-size: 16px;">
        </div>
        
        <!-- EVENT_THUMB (썸네일 파일) -->
        <div class="form-row">
            <label>대표 썸네일 이미지</label>
            <input type="file" name="thumbFile" accept="image/*" required>
        </div>

        <!-- EVENT_PET_TYPE (대상 반려동물) -->
        <div class="form-row catgogry">
            <label>대상 반려동물:</label>
            <input type="radio" name="event_pet_type" value="강아지" id="pet_dog" checked> <label for="pet_dog">강아지</label>
            <input type="radio" name="event_pet_type" value="고양이" id="pet_cat"> <label for="pet_cat">고양이</label>
        </div>
        
        <!-- EVENT_ONOFF (진행 방식) -->
        <div class="form-row catgogry">
            <label>진행 방식:</label>
            <input type="radio" name="event_onoff" value="온라인" id="onoff_on" checked> <label for="onoff_on">온라인</label>
            <input type="radio" name="event_onoff" value="오프라인" id="onoff_off"> <label for="onoff_off">오프라인</label>
        </div>

        <!-- EVENT_START, EVENT_END, EVENT_ALL (이벤트 기간 및 상시 여부) -->
        <div class="form-row">
            <label>이벤트 기간:</label>
            <input type="date" name="event_start" id="eventStart"> ~ 
            <input type="date" name="event_end" id="eventEnd">
            &nbsp;&nbsp;
            <input type="checkbox" name="event_all" value="Y" id="eventAllCheck">
            <label for="eventAllCheck">상시 진행</label>
        </div>	

        <!-- EVENT_LOC (행사 장소) -->
        <div class="form-row" id="locWrapper">
            <label>행사 장소:</label>
            <input type="text" name="event_loc" id="eventLoc" placeholder="예) 서울 강남구 코엑스 홀 A" style="width: 60%; padding: 8px;" maxlength="20">
        </div>	

        <!-- EVENT_CONTENT (본문 내용) -->
        <div class="form-row body_content">
            <label style="display: block; margin-bottom: 5px;">이벤트 상세 내용</label>
            <textarea rows="20" cols="50" id="eventContent" name="event_content" placeholder="이벤트 상세 내용을 입력해주세요." style="width: 100%; padding: 10px;"></textarea>
        </div>
        
        <!-- 제출 버튼 -->
        <div style="text-align: right; margin-top: 20px;">
            <button type="submit" style="background-color: #222; color: #fff; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-weight: bold;">등록하기</button>
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

    // 1. 상시 진행 체크 시 날짜 제어
    eventAllCheck.addEventListener("change", function() {
        if(this.checked) {
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
    });

    // 2. 온/오프라인 선택에 따른 장소 제어
    function toggleLocation() {
        if (onoffOn.checked) {
            eventLoc.value = ""; // <-- "온라인" 대신 빈 값으로 설정!
            eventLoc.readOnly = true;
            eventLoc.style.backgroundColor = "#eee";
            eventLoc.placeholder = "온라인 이벤트는 장소가 필요 없습니다.";
        } else {
            if(eventLoc.value === "온라인") eventLoc.value = "";
            eventLoc.readOnly = false;
            eventLoc.style.backgroundColor = "#fff";
            eventLoc.placeholder = "예) 서울 강남구 코엑스 홀 A";
        }
    }

    onoffOn.addEventListener("change", toggleLocation);
    onoffOff.addEventListener("change", toggleLocation);
    
    toggleLocation();
});

$(document).ready(function() {
    $('#eventContent').summernote({
        placeholder: '이벤트 상세 내용을 입력해주세요. (이미지 첨부 가능)',
        tabsize: 2,
        height: 400,
        lang: 'ko-KR'
    });

    $("form[name='eventWriteForm']").on("submit", function() {
        if ($("#eventAllCheck").is(":checked")) {
            $("#eventStart").val("");
            $("#eventEnd").val("");
        }
    });
});
</script>
</body>
</html>