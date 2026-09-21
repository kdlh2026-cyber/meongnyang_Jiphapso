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

    <form name="petForm" method="post" action="/myPetUpdate" enctype="multipart/form-data" onsubmit="return piFormCheck()">
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
            <input class="pi-input" type="text" id="pet_birth" name="pet_birth"
			    value="${fn:replace(fn:substring(petUpdate.pet_birth,0,10), '-', '')}"
			    placeholder="반려동물의 생년월일 8자리를 입력해주세요"
			    maxlength="8" inputmode="numeric"
			    oninput="this.value = this.value.replace(/[^0-9]/g, '')">
        </div>

        <div class="pi-field">
            <span class="pi-label">종류</span>
            <div class="pi-type-row">
                <label class="pi-type-option">
				    <input type="radio" name="pet_type" value="강아지" onclick="onPetTypeChange()" ${petUpdate.pet_type == '강아지' ? 'checked' : ''}>
				    <img class="pi-type-avatar" src="/images/stray/menu/dog_head.png">
				    <span class="pi-type-name">강아지</span>
				</label>
				<label class="pi-type-option">
				    <input type="radio" name="pet_type" value="고양이" onclick="onPetTypeChange()" ${petUpdate.pet_type == '고양이' ? 'checked' : ''}>
				    <img class="pi-type-avatar" src="/images/stray/menu/cat_head.png">
				    <span class="pi-type-name">고양이</span>
				</label>
				<label class="pi-type-option">
				    <input type="radio" name="pet_type" value="그 외" onclick="onPetTypeChange()" ${petUpdate.pet_type == '그 외' ? 'checked' : ''}>
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
	                <option value="${dog.breed_name}">${dog.breed_name}</option>
	            </c:forEach>
	        </select>
	
	        <select class="pi-select" name="pet_breed" id="catBreedSelect" style="display:none;">
	            <option value="">고양이 품종 선택</option>
	            <c:forEach var="cat" items="${catBreed}">
	                <option value="${cat.breed_name}">${cat.breed_name}</option>
	            </c:forEach>
	        </select>
	    </div>
	    <input class="pi-input" type="text" name="pet_breed" id="etcBreedInput" value="${petUpdate.pet_breed}" placeholder="품종을 입력해주세요" style="display:none;">
	
	    <!-- DB에서 불러온 원본 품종값을 JS로 넘기기 위한 hidden -->
	    <input type="hidden" id="petBreedValue" value="${petUpdate.pet_breed}">
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
		        <input type="hidden" id="pet_neuter_hidden" name="pet_neuter" value="F">
		        <input type="checkbox" id="pet_neuter_chk" value="T"
		            ${petUpdate.pet_neuter == 'T' ? 'checked' : ''}
		            onchange="document.getElementById('pet_neuter_hidden').disabled = this.checked">
		        중성화 여부
		    </label>
		</div>

        <div class="pi-field">
            <label class="pi-label" for="pet_weight">몸무게(kg)</label>
            <input class="pi-input" type="text" id="pet_weight" name="pet_weight"
			    value="${petUpdate.pet_weight}"
			    placeholder="몸무게(kg)" inputmode="decimal"
			    oninput="this.value = this.value.replace(/[^0-9.]/g, '')">
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

function selectMatchingOption(selectEl, value){
    for(let i = 0; i < selectEl.options.length; i++){
        if(selectEl.options[i].value.trim() === value.trim()){
            selectEl.selectedIndex = i;
            return;
        }
    }
}

// DB에 저장된 원본 품종값(petBreedValue)을, 현재 선택된 종류에 맞는 필드에 다시 매칭
function applyBreedForCurrentType(){
    let breedValue = document.getElementById('petBreedValue').value;
    let selectedRadio = document.querySelector('input[name="pet_type"]:checked');
    if(!selectedRadio) return;
    let petType = selectedRadio.value;

    if(petType === '강아지'){
        selectMatchingOption(document.getElementById('dogBreedSelect'), breedValue);
    } else if(petType === '고양이'){
        selectMatchingOption(document.getElementById('catBreedSelect'), breedValue);
    } else {
        document.getElementById('etcBreedInput').value = breedValue;
    }
}

// 종류(라디오) 변경 시 항상 호출: 필드 전환 + 원본 품종값 재매칭
function onPetTypeChange(){
    toggleBreed();
    applyBreedForCurrentType();
}

window.addEventListener('DOMContentLoaded', function(){
    onPetTypeChange();
    document.getElementById('pet_neuter_hidden').disabled = document.getElementById('pet_neuter_chk').checked;
});
function isValidBirthDate(str){
    if(!/^\d{8}$/.test(str)) return false;

    let year  = parseInt(str.substring(0, 4), 10);
    let month = parseInt(str.substring(4, 6), 10);
    let day   = parseInt(str.substring(6, 8), 10);

    if(month < 1 || month > 12) return false;

    let currentYear = new Date().getFullYear();
    if(year < 1990 || year > currentYear) return false;

    let lastDayOfMonth = new Date(year, month, 0).getDate();
    if(day < 1 || day > lastDayOfMonth) return false;

    let inputDate = new Date(year, month - 1, day);
    let today = new Date();
    today.setHours(0, 0, 0, 0);
    if(inputDate > today) return false;

    return true;
}

function piFormCheck(){
    let f = document.petForm;

    if(!f.pet_name.value.trim()){
        alert("반려동물 이름을 입력하시길 바랍니다.");
        f.pet_name.focus();
        return false;
    }

    let birth = f.pet_birth.value.trim();
    if(birth && !isValidBirthDate(birth)){
        alert("생년월일이 올바르지 않습니다. 실제 존재하는 날짜를 8자리로 입력해주세요. (예: 20230101)");
        f.pet_birth.focus();
        return false;
    }

    let petType = f.pet_type.value;
    if(!petType){
        alert("반려동물 종류를 선택하시길 바랍니다.");
        return false;
    }

    let breedValue = "";
    if(petType === "강아지"){
        breedValue = document.getElementById("dogBreedSelect").value;
    } else if(petType === "고양이"){
        breedValue = document.getElementById("catBreedSelect").value;
    } else {
        breedValue = document.getElementById("etcBreedInput").value;
    }
    if(!breedValue.trim()){
        alert("품종을 선택하거나 입력하시길 바랍니다.");
        return false;
    }

    if(!f.pet_gender.value){
        alert("성별을 선택하시길 바랍니다.");
        return false;
    }

    let weight = f.pet_weight.value.trim();
    let expWeight = /^\d{1,2}(\.\d{1,3})?$/;
    if(weight && !expWeight.test(weight)){
        alert("몸무게는 숫자 형식으로 입력하시길 바랍니다. (예: 3.5)");
        f.pet_weight.focus();
        return false;
    }

    return true;
}
</script>
</body>
</html>