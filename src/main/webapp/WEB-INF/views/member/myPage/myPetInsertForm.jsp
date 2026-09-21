<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>멍냥집합소</title>
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

    /* 반려동물 종류 선택 (이미지 라디오) */
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

    .pi-select, #etcBreedInput.pi-input {
        width: 100%;
        padding: 10px 4px;
        font-size: 14.5px;
        color: #4A3226;
        border: none;
        border-bottom: 1.5px solid #FFC9CE;
        background: transparent;
        outline: none;
    }

    /* 성별 / 중성화 */
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
    <h2 class="pi-title">반려동물 등록</h2>

    <form name="petForm" method="post" action="/myPetInsert" enctype="multipart/form-data" onsubmit="return piFormCheck()">

        <div class="pi-field">
            <span class="pi-label">등록 사진</span>
            <input class="pi-file-input" type="file" name="pet_upload">
            <div style="font-size:12px;color:#9c8a7c;margin-top:4px;">등록 사진은 1개만 첨부 가능합니다.</div>
        </div>

        <div class="pi-field">
            <label class="pi-label" for="pet_name">이름</label>
            <input class="pi-input" type="text" id="pet_name" name="pet_name" placeholder="이름">
        </div>

        <div class="pi-field">
            <label class="pi-label" for="pet_birth">생년월일</label>
            <input class="pi-input" type="text" id="pet_birth" name="pet_birth"
			    placeholder="반려동물의 생년월일 8자리를 입력해주세요"
			    maxlength="8" inputmode="numeric"
			    oninput="this.value = this.value.replace(/[^0-9]/g, '')">
        </div>

        <div class="pi-field">
            <span class="pi-label">종류</span>
            <div class="pi-type-row">
                <label class="pi-type-option">
                    <input type="radio" name="pet_type" value="강아지" onclick="toggleBreed()">
                    <img class="pi-type-avatar" src="/images/stray/menu/dog_head.png">
                    <span class="pi-type-name">강아지</span>
                </label>
                <label class="pi-type-option">
                    <input type="radio" name="pet_type" value="고양이" onclick="toggleBreed()">
                    <img class="pi-type-avatar" src="/images/stray/menu/cat_head.png">
                    <span class="pi-type-name">고양이</span>
                </label>
                <label class="pi-type-option">
                    <input type="radio" name="pet_type" value="그 외" onclick="toggleBreed()">
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
            <input class="pi-input" type="text" name="pet_breed" id="etcBreedInput" placeholder="품종을 입력해주세요" style="display:none;">
        </div>

        <div class="pi-field">
            <span class="pi-label">성별</span>
            <div class="pi-choice-row">
                <label><input type="radio" name="pet_gender" value="남아">남아</label>
                <label><input type="radio" name="pet_gender" value="여아">여아</label>
            </div>
        </div>
		
		<div class="pi-field">
		    <label class="pi-choice-row" style="gap:8px;">
		        <input type="hidden" id="pet_neuter_hidden" name="pet_neuter" value="F">
		        <input type="checkbox" id="pet_neuter_chk" value="T"
		            onchange="document.getElementById('pet_neuter_hidden').disabled = this.checked">
		        중성화 여부
		    </label>
		</div>

        <div class="pi-actions">
            <input class="pi-btn pi-btn--solid" type="submit" value="등록">
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

function isValidBirthDate(str){
    // 8자리 숫자 형식인지 먼저 확인
    if(!/^\d{8}$/.test(str)) return false;

    let year  = parseInt(str.substring(0, 4), 10);
    let month = parseInt(str.substring(4, 6), 10);
    let day   = parseInt(str.substring(6, 8), 10);

    // 월 범위 확인 (01~12)
    if(month < 1 || month > 12) return false;

    // 연도 범위 확인 (너무 오래되거나 미래인 값 방지)
    let currentYear = new Date().getFullYear();
    if(year < 1990 || year > currentYear) return false;

    // 각 월의 마지막 일 계산 (윤년 자동 반영)
    let lastDayOfMonth = new Date(year, month, 0).getDate();
    if(day < 1 || day > lastDayOfMonth) return false;

    // 미래 날짜 방지 (오늘 이후 생년월일 불가)
    let inputDate = new Date(year, month - 1, day);
    let today = new Date();
    today.setHours(0, 0, 0, 0);
    if(inputDate > today) return false;

    return true;
}

function piFormCheck(){
    let f = document.petForm;

    // 이름 (NOT NULL)
    if(!f.pet_name.value.trim()){
        alert("반려동물 이름을 입력하시길 바랍니다.");
        f.pet_name.focus();
        return false;
    }

    // 생년월일 - 입력했을 경우 실제로 존재하는 날짜인지 확인 (선택 입력)
    let birth = f.pet_birth.value.trim();
    if(birth && !isValidBirthDate(birth)){
        alert("생년월일이 올바르지 않습니다. 실제 존재하는 날짜를 8자리로 입력해주세요. (예: 20230101)");
        f.pet_birth.focus();
        return false;
    }

    // 종류 (NOT NULL)
    let petType = f.pet_type.value;
    if(!petType){
        alert("반려동물 종류를 선택하시길 바랍니다.");
        return false;
    }

    // 품종 (NOT NULL)
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

    // 성별 (NOT NULL)
    if(!f.pet_gender.value){
        alert("성별을 선택하시길 바랍니다.");
        return false;
    }

    // 몸무게 - 입력했을 경우 숫자 형식인지 확인
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