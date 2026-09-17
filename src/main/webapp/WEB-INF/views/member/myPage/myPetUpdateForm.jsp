<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>반려동물 정보 수정</title>
<style>
    * { box-sizing: border-box; }
    body { margin: 0; font-family: "Noto Sans KR", "Malgun Gothic", sans-serif; background: #fff; color: #4A3226; }

    .pi-wrap {
        max-width: 480px;
        margin: 0 auto;
        padding: 32px 24px 60px;
    }

    .pi-title {
        font-size: 20px;
        font-weight: 700;
        text-align: center;
        margin: 0 0 28px;
    }

    .pi-avatar-wrap {
        display: flex;
        justify-content: center;
        margin-bottom: 24px;
    }
    .pi-avatar {
        width: 130px;
        height: 130px;
        border-radius: 50%;
        object-fit: cover;
        border: 3px solid #FDCC61;
        background: #FFF3D8;
    }

    .pi-field {
        margin-bottom: 22px;
    }
    .pi-field + .pi-field {
        padding-top: 22px;
        border-top: 1px solid #FFF3D8;
    }

    .pi-label {
        display: block;
        font-size: 12.5px;
        font-weight: 700;
        color: #b0821a;
        margin-bottom: 6px;
    }

    .pi-input {
        width: 100%;
        padding: 10px 4px;
        font-size: 14.5px;
        color: #4A3226;
        border: none;
        border-bottom: 1.5px solid #FFC9CE;
        background: transparent;
        outline: none;
    }
    .pi-input:focus { border-bottom-color: #FDCC61; }

    .pi-file-input { font-size: 13px; color: #4A3226; }

    .pi-type-row {
        display: flex;
        justify-content: center;
        gap: 18px;
    }
    .pi-type-option {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 8px;
        cursor: pointer;
    }
    .pi-type-option input[type="radio"] { display: none; }
    .pi-type-avatar {
        width: 70px;
        height: 70px;
        border-radius: 50%;
        object-fit: cover;
        border: 3px solid #FFF3D8;
        background: #FFFBF5;
        padding: 6px;
        transition: border-color 0.15s ease;
    }
    .pi-type-option input[type="radio"]:checked + .pi-type-avatar {
        border-color: #FDCC61;
    }
    .pi-type-name {
        font-size: 12.5px;
        font-weight: 600;
        color: #4A3226;
    }

    .pi-select {
        width: 100%;
        padding: 10px 4px;
        font-size: 14.5px;
        color: #4A3226;
        border: none;
        border-bottom: 1.5px solid #FFC9CE;
        background: transparent;
        outline: none;
    }

    .pi-choice-row {
        display: flex;
        gap: 24px;
    }
    .pi-choice-row label {
        display: flex;
        align-items: center;
        gap: 6px;
        font-size: 14px;
        color: #4A3226;
        cursor: pointer;
    }
    .pi-choice-row input[type="radio"],
    .pi-choice-row input[type="checkbox"] {
        width: 17px;
        height: 17px;
        accent-color: #FDCC61;
    }

    .pi-actions {
        display: flex;
        justify-content: center;
        gap: 10px;
        margin-top: 36px;
    }
    .pi-btn {
        padding: 11px 36px;
        border-radius: 999px;
        font-size: 14.5px;
        font-weight: 700;
        border: none;
        cursor: pointer;
    }
    .pi-btn--solid { background: #FDCC61; color: #4A3226; }
    .pi-btn--solid:hover { background: #FDA58F; color: #FFFBF5; }
    .pi-btn--outline { background: #fff; border: 1.5px solid #FFC9CE; color: #4A3226; }
    .pi-btn--outline:hover { background: #FFC9CE; }
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>

<div class="pi-wrap">
    <h2 class="pi-title">반려동물 정보 수정</h2>

    <form id="" method="post" action="/myPetUpdate" enctype="multipart/form-data">
        <input type="hidden" name="pet_no" value="${petUpdate.pet_no}">

        <div class="pi-avatar-wrap">
            <c:choose>
                <c:when test="${not empty petUpdate.pet_image}">
                    <img class="pi-avatar" src="/images/myPet/${petUpdate.pet_image}" alt="${petUpdate.pet_name}">
                </c:when>
                <c:when test="${petUpdate.pet_type == '고양이'}">
                    <img class="pi-avatar" src="/images/stray/menu/cat_head.png">
                </c:when>
                <c:when test="${petUpdate.pet_type == '강아지'}">
                    <img class="pi-avatar" src="/images/stray/menu/dog_head.png">
                </c:when>
                <c:otherwise>
                    <img class="pi-avatar" src="/images/main/hamster_head.png">
                </c:otherwise>
            </c:choose>
        </div>

        <div class="pi-field">
            <span class="pi-label">등록 사진 변경</span>
            <input class="pi-file-input" type="file" name="pet_upload">
            <div style="font-size:12px;color:#9c8a7c;margin-top:4px;">등록 사진은 1개만 첨부 가능합니다.</div>
        </div>

        <div class="pi-field">
            <label class="pi-label" for="pet_name">이름</label>
            <input class="pi-input" type="text" id="pet_name" name="pet_name" value="${petUpdate.pet_name}" placeholder="이름">
        </div>

        <div class="pi-field">
            <label class="pi-label" for="pet_birth">생년월일</label>
            <input class="pi-input" type="text" id="pet_birth" name="pet_birth" value="${fn:replace(fn:substring(petUpdate.pet_birth,0,10), '-', '')}" placeholder="반려동물의 생년월일 8자리를 입력해주세요">
        </div>

        <div class="pi-field">
            <span class="pi-label">종류</span>
            <div class="pi-type-row">
                <label class="pi-type-option">
                    <input type="radio" name="pet_type" value="강아지" onclick="toggleBreed()" ${petUpdate.pet_type == '강아지' ? 'checked' : ''}>
                    <img class="pi-type-avatar" src="/images/stray/menu/dog_head.png">
                    <span class="pi-type-name">강아지</span>
                </label>
                <label class="pi-type-option">
                    <input type="radio" name="pet_type" value="고양이" onclick="toggleBreed()" ${petUpdate.pet_type == '고양이' ? 'checked' : ''}>
                    <img class="pi-type-avatar" src="/images/stray/menu/cat_head.png">
                    <span class="pi-type-name">고양이</span>
                </label>
                <label class="pi-type-option">
                    <input type="radio" name="pet_type" value="그 외" onclick="toggleBreed()" ${petUpdate.pet_type == '그 외' ? 'checked' : ''}>
                    <img class="pi-type-avatar" src="/images/main/hamster_head.png">
                    <span class="pi-type-name">그 외</span>
                </label>
            </div>
        </div>

        <div class="pi-field">
            <div id="breedWrapper" style="display:none;">
                <select class="pi-select" name="pet_breed" id="dogBreedSelect" style="display:none;">
                    <option value="">강아지 품종 선택</option>
                    <c:forEach var="dog" items="${dogBreed}">
                        <option value="${dog.breed_name}" ${petUpdate.pet_breed == dog.breed_name ? 'selected' : ''}>${dog.breed_name}</option>
                    </c:forEach>
                </select>

                <select class="pi-select" name="pet_breed" id="catBreedSelect" style="display:none;">
                    <option value="">고양이 품종 선택</option>
                    <c:forEach var="cat" items="${catBreed}">
                        <option value="${cat.breed_name}" ${petUpdate.pet_breed == cat.breed_name ? 'selected' : ''}>${cat.breed_name}</option>
                    </c:forEach>
                </select>
            </div>
            <input class="pi-input" type="text" name="pet_breed" id="etcBreedInput" value="${petUpdate.pet_breed}" placeholder="품종을 입력해주세요" style="display:none;">
        </div>

        <div class="pi-field">
            <span class="pi-label">성별</span>
            <div class="pi-choice-row">
                <label><input type="radio" name="pet_gender" value="남아" ${petUpdate.pet_gender == '남아' ? 'checked' : ''}>남아</label>
                <label><input type="radio" name="pet_gender" value="여아" ${petUpdate.pet_gender == '여아' ? 'checked' : ''}>여아</label>
            </div>
        </div>

        <div class="pi-field">
            <label class="pi-choice-row" style="gap:8px;">
                <input type="checkbox" name="pet_neuter" ${petUpdate.pet_neuter == 'T' ? 'checked' : ''}> 중성화 여부
            </label>
        </div>

        <div class="pi-field">
            <label class="pi-label" for="pet_weight">몸무게(kg)</label>
            <input class="pi-input" type="text" id="pet_weight" name="pet_weight" value="${petUpdate.pet_weight}" placeholder="몸무게(kg)">
        </div>

        <div class="pi-actions">
            <input class="pi-btn pi-btn--solid" type="submit" value="수정">
            <input class="pi-btn pi-btn--outline" type="reset" value="취소">
        </div>

    </form>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
<script>
function toggleBreed(){
    const selectedRadio = document.querySelector('input[name="pet_type"]:checked');
    if (!selectedRadio) return;
    const selectedType = selectedRadio.value;

    const breedWrapper = document.getElementById('breedWrapper');
    const dogSelect = document.getElementById('dogBreedSelect');
    const catSelect = document.getElementById('catBreedSelect');
    const etcInput = document.getElementById('etcBreedInput');

    if(selectedType === '강아지'){
        breedWrapper.style.display = 'block';
        dogSelect.style.display = 'inline-block';
        dogSelect.disabled = false;
        catSelect.style.display = 'none';
        catSelect.disabled = true;
        etcInput.style.display = 'none';
        etcInput.disabled = true;
    } else if(selectedType === '고양이'){
        breedWrapper.style.display = 'block';
        catSelect.style.display = 'inline-block';
        catSelect.disabled = false;
        dogSelect.style.display = 'none';
        dogSelect.disabled = true;
        etcInput.style.display = 'none';
        etcInput.disabled = true;
    } else {
        breedWrapper.style.display = 'none';
        dogSelect.disabled = true;
        catSelect.disabled = true;
        etcInput.style.display = 'block';
        etcInput.disabled = false;
    }
}

// 수정 페이지 진입 시 기존 선택된 종류에 맞춰 품종 영역 초기 상태 반영
window.addEventListener('DOMContentLoaded', toggleBreed);
</script>
</body>
</html>