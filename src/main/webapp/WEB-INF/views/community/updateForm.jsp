<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>커뮤니티 게시글(포스트, Q&A, 라운지)</title>
<link rel="stylesheet" href="/css/community/commWriteForm.css">
<style>
.form-row-top {
    display: flex;
    gap: 20px;
    margin-bottom: 20px;
}
.form-row-top > div {
    flex: 1;
    padding: 20px;
    border-radius: 12px;
    border: 1px solid #e0e0e0;
    transition: all 0.3s ease;
    background: #ffffff; /* 기본은 흰색 */
}

/* 🔒 1단계도 아직 안 탔거나, 다음 단계가 잠겼을 때의 스타일 */
.step-locked {
    background: #f1f3f5 !important;
    opacity: 0.4;
    pointer-events: none;
    box-shadow: none !important;
}

/* ✨ 현재 집중해서 입력해야 하는 활성 단계 (색상 + 볼륨감) */
.step-active {
    background: #fff5f3 !important; /* 은은하고 부드러운 피치/오렌지빛 배경색 */
    opacity: 1;
    pointer-events: auto;
    border: 2px solid #ff6f61 !important; /* 포인트 테두리 */
    box-shadow: 0 8px 20px rgba(255, 111, 97, 0.15); /* 입체적인 볼륨감(그림자) */
}

/* ✔️ 완료된 이전 단계 (흰색 배경으로 돌아가 깔끔하게 유지) */
.step-completed {
    background: #ffffff !important;
    opacity: 1;
    pointer-events: auto;
    border: 1px solid #d1d5db !important;
    box-shadow: none !important;
}

.form-row-bottom {
    display: flex;
    gap: 15px;
    margin-bottom: 20px;
}
.form-row-bottom > div {
    flex: 1;
    background: #f9f9f9;
    padding: 15px;
    border-radius: 8px;
    border: 1px solid #ddd;
    transition: all 0.3s ease;
}
.title input, .body_content textarea {
    width: 100%;
    box-sizing: border-box;
}
.submit-btn-area {
    text-align: center;
    margin-top: 30px;
}
.submit-btn-area input[type="submit"] {
    width: 100%;
    padding: 15px;
    font-size: 16px;
    font-weight: bold;
    background-color: #ff6f61;
    color: white;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    box-shadow: 0 4px 10px rgba(255, 111, 97, 0.3);
}
.submit-btn-area input[type="submit"]:hover {
    background-color: #e05b4c;
}
.catgogry_box, .pet_choice_box {
    transition: border-color 0.3s ease, background-color 0.3s ease;
}
</style>
</head>
<body>
<%@ include file="../hamburger_menu.jsp" %>
	<div style="max-width: 900px; margin: 0 auto; padding: 20px;">
		<div><h1>게시글 수정하기</h1></div>
		<div style="margin-bottom: 20px; color: #666;">반려동물에 대한 궁금증을 가장 빠르게 답변 받아보세요!</div>
		
		<div>
			<form name="communityUpdateForm" method="post" action="/community/update" enctype="multipart/form-data">
				<input type="hidden" name="comm_no" value="${update.comm_no}">
				<!-- [1단계] 게시판 선택 -->
				<div class="form-row-top">
					<div class="catgogry_box step-active" id="step1Box">
					    <div class="category_name" style="font-weight: bold; margin-bottom: 8px; color: #ff6f61;">Step 1. 게시판 선택</div>
					    <input type="radio" name="comm_type" value="Q&A" onclick="checkStep1()"> Q&amp;A |
					    <input type="radio" name="comm_type" value="라운지" onclick="checkStep1()"> 라운지 |
					
					    <sec:authorize access="hasAnyRole('CREATOR', 'ADMIN')">
					        <input type="radio" name="comm_type" value="콘텐츠" onclick="checkStep1()"> 콘텐츠
					    </sec:authorize>
					
					    <sec:authorize access="!hasAnyRole('CREATOR', 'ADMIN')">
					        <input type="radio" name="comm_type" value="콘텐츠" disabled> 콘텐츠
					        <br><span style="font-size: 11px; color: #888;">(크리에이터 전용)</span>
					    </sec:authorize>
					</div>
					
					<!-- [2단계] 동물 종류 및 품종 선택 (처음엔 잠김) -->
					<div class="pet_choice_box step-locked" id="step2Box">
						<div class="category_name" style="font-weight: bold; margin-bottom: 8px; color: #ff6f61;">Step 2. 동물 종류 및 품종 선택</div> 
						<div style="margin-bottom: 8px;">
							<input type="radio" name="comm_pet_type" value="dog" onclick="toggleBreed(); checkStep2();"> 강아지
							<input type="radio" name="comm_pet_type" value="cat" onclick="toggleBreed(); checkStep2();"> 고양이
							<input type="radio" name="comm_pet_type" value="small" onclick="toggleBreed(); checkStep2();"> 소동물
							<input type="radio" name="comm_pet_type" value="etc" onclick="toggleBreed(); checkStep2();"> 기타
						</div>
						
						<div id="breedWrapper" style="display: none;">
							<select name="comm_breed" id="dogBreedSelect" style="width: 100%; padding: 5px; display: none;" onchange="checkStep2()">
								<option value="">강아지 품종 선택</option>
								<c:forEach var="breed" items="${dogBreed}">
									<option value="${breed.breed_name}">${breed.breed_name}</option>
								</c:forEach>
							</select>

							<select name="comm_breed" id="catBreedSelect" style="width: 100%; padding: 5px; display: none;" disabled onchange="checkStep2()">
								<option value="">고양이 품종 선택</option>
								<c:forEach var="breed" items="${catBreed}">
									<option value="${breed.breed_name}">${breed.breed_name}</option>
								</c:forEach>
							</select>
						</div>
					</div>
					
										<!-- [2단계-B] 콘텐츠 카테고리 선택 (콘텐츠 전용, 처음엔 숨김) -->
					<div class="pet_choice_box step-locked" id="step2ContentBox" style="display: none;">
					    <div class="category_name" style="font-weight: bold; margin-bottom: 8px; color: #ff6f61;">Step 2. 콘텐츠 카테고리 선택</div>
					    <div>
					        <input type="radio" name="comm_category" value="강아지연구소" onclick="checkStep2Content()"> 강아지연구소
					        <input type="radio" name="comm_category" value="고양이연구소" onclick="checkStep2Content()"> 고양이연구소
					        <input type="radio" name="comm_category" value="제품연구소" onclick="checkStep2Content()"> 제품연구소
					        <input type="radio" name="comm_category" value="제보" onclick="checkStep2Content()"> 제보
					        <input type="radio" name="comm_category" value="뉴스/브랜드" onclick="checkStep2Content()"> 뉴스/브랜드
					    </div>
					</div>
				</div>
				
				<!-- [3단계] 본문 작성 및 첨부 영역 (처음엔 잠김) -->
				<div id="step3Box" class="step-locked" style="padding: 20px; border-radius: 12px; border: 1px solid #e0e0e0; transition: all 0.3s ease;">
					<div style="font-weight: bold; margin-bottom: 12px; color: #ff6f61;">Step 3. 내용 작성 및 첨부</div>
					
					<!-- [제목 영역] -->
					<div class="title" style="margin-bottom: 15px;">
						<input type="text" name="comm_title" value="${update.comm_title}" style="padding: 12px; font-size: 14px; border: 1px solid #ddd; border-radius: 6px;">
					</div>	
					<div class="explain" style="font-size: 12px; color: #777; margin-bottom: 20px;">
						<span class="sub_explain">! 질병 관련 질문 시 지역명을 함께 적어주시면 수의사분들의 빠른 답변을 받아보실 수 있습니다.</span>
						(예: [부산 서면] 슬개골 탈구 관련 병원 안내 부탁드려요.)
					</div>
					
					<!-- [내용 입력 영역] -->
					<div class="body_content" style="margin-bottom: 20px;">
						<textarea rows="15" name="comm_content" style="padding: 12px; font-size: 14px; border: 1px solid #ddd; border-radius: 6px; resize: vertical;">${update.comm_content}</textarea>
					</div>
					
					<!-- [태그 / 사진 / 동영상 하단 배치] -->
					<div class="form-row-bottom">
						<!-- 태그 입력 -->
						<div class="tag_section">
							<div class="category_name" style="font-weight: bold; margin-bottom: 8px;">태그 입력</div> 
							<div class="tag_box" id="tag_box" style="display: flex; gap: 5px; margin-bottom: 8px;">
								<input type="text" id="tagInput" placeholder="# 태그 입력 후 enter" style="flex: 1; padding: 6px; border: 1px solid #ddd; border-radius: 4px;"
								       onkeydown="if(event.key === 'Enter'){ event.preventDefault(); clickAddTag(); }">
								<button type="button" class="tag-add-btn" onclick="clickAddTag()" style="padding: 6px 10px; cursor: pointer;">추가</button>
							</div>
							<div class="tag_list_area" id="tagListArea" style="display: flex; flex-wrap: wrap; gap: 4px;"></div>
							<input type="hidden" name="comm_tag" id="commTagHidden">
						</div>
						
						<!-- 사진 첨부 -->
						<div class="file_section_img">
							<div class="category_name" style="font-weight: bold; margin-bottom: 8px;">사진 첨부</div>
							<label for="uploadImages" class="file_custom_btn" style="display: inline-block; padding: 8px 12px; background: #eee; border: 1px solid #ccc; border-radius: 4px; cursor: pointer; margin-bottom: 5px;">사진 선택</label>
							<input type="file" id="uploadImages" name="uploadImages" class="file_input_hidden" style="display:none;" multiple accept="image/*">
							<div class="file_guide" style="font-size: 11px; color: #666;">최대 10장 · 20MB 이하</div>
						</div>
						
						<!-- 동영상 첨부 -->
						<div class="file_section_video">
							<div class="category_name" style="font-weight: bold; margin-bottom: 8px;">동영상 첨부</div>
							<label for="uploadVideo" class="file_custom_btn" style="display: inline-block; padding: 8px 12px; background: #eee; border: 1px solid #ccc; border-radius: 4px; cursor: pointer; margin-bottom: 5px;">동영상 선택</label>
							<input type="file" id="uploadVideo" name="uploadVideo" class="file_input_hidden" style="display:none;" multiple accept="video/*">
							<div class="file_guide" style="font-size: 11px; color: #666;">
								최대 65MB · 1개
							</div>
						</div>
					</div>
					
					<!-- [질문 등록 버튼] -->
					<div class="submit-btn-area">
						<input type="submit" value="질문 등록">
					</div>
				</div>
			</form>
		</div>
	</div>
	<hr>
<%@ include file="../footer.jsp" %>

<!-- 자바스크립트 단계별 스타일 전환 제어 로직 -->
<script>
window.onload = function(){
    checkStep1();
};

function checkStep1() {
    const selectedCommType = document.querySelector('input[name="comm_type"]:checked');
    const step1Box = document.getElementById('step1Box');
    const step2Box = document.getElementById('step2Box');
    const step2ContentBox = document.getElementById('step2ContentBox');

    if (selectedCommType) {
        // Step1은 "선택은 했지만 아직 완료 확정 아님" 상태 -> 중립 스타일로 (active 강조 제거)
        step1Box.className = "catgogry_box";

        if (selectedCommType.value === '콘텐츠') {
            step2Box.style.display = 'none';
            step2Box.classList.add('step-locked');
            step2Box.classList.remove('step-active');

            step2ContentBox.style.display = 'block';
            step2ContentBox.classList.remove('step-locked');
            step2ContentBox.classList.add('step-active');

            document.querySelectorAll('input[name="comm_pet_type"]').forEach(el => el.checked = false);
            document.querySelectorAll('select[name="comm_breed"]').forEach(el => el.selectedIndex = 0);
            document.querySelectorAll('input[name="comm_category"]').forEach(el => el.checked = false);

            checkStep2Content();
        } else {
            step2ContentBox.style.display = 'none';
            step2ContentBox.classList.add('step-locked');
            step2ContentBox.classList.remove('step-active');

            step2Box.style.display = 'block';
            step2Box.classList.remove('step-locked');
            step2Box.classList.add('step-active');

            document.querySelectorAll('input[name="comm_pet_type"]').forEach(el => el.checked = false);
            document.querySelectorAll('select[name="comm_breed"]').forEach(el => el.selectedIndex = 0);
            document.getElementById('breedWrapper').style.display = 'none';
            document.querySelectorAll('input[name="comm_category"]').forEach(el => el.checked = false);

            checkStep2();
        }
    } else {
        step1Box.className = "catgogry_box step-active";

        step2Box.classList.add('step-locked');
        step2Box.classList.remove('step-active');
        step2ContentBox.classList.add('step-locked');
        step2ContentBox.classList.remove('step-active');
        step2ContentBox.style.display = 'none';
    }
}

function checkStep2() {
    const selectedPetType = document.querySelector('input[name="comm_pet_type"]:checked');
    const step1Box = document.getElementById('step1Box');
    const step2Box = document.getElementById('step2Box');
    const step3Box = document.getElementById('step3Box');
    let isBreedValid = true;

    if (selectedPetType) {
        const typeVal = selectedPetType.value;
        if (typeVal === 'dog') {
            const dogSelect = document.getElementById('dogBreedSelect');
            if (dogSelect.value === "") isBreedValid = false;
        } else if (typeVal === 'cat') {
            const catSelect = document.getElementById('catBreedSelect');
            if (catSelect.value === "") isBreedValid = false;
        }
    } else {
        isBreedValid = false;
    }

    if (selectedPetType && isBreedValid) {
        // Step2 완료 -> 그제서야 Step1도 완료 색상 확정
        step1Box.className = "catgogry_box step-completed";
        step2Box.className = "pet_choice_box step-completed";

        step3Box.classList.remove('step-locked');
        step3Box.classList.add('step-active');
    } else {
        // Step2 미완료 -> Step1은 중립 상태 유지 (active 아님), Step2만 강조
        step1Box.className = "catgogry_box";

        if (!step2Box.classList.contains('step-locked')) {
            step2Box.className = "pet_choice_box step-active";
        }
        step3Box.classList.add('step-locked');
        step3Box.classList.remove('step-active');
    }
}

function checkStep2Content() {
    const selectedCategory = document.querySelector('input[name="comm_category"]:checked');
    const step1Box = document.getElementById('step1Box');
    const step2ContentBox = document.getElementById('step2ContentBox');
    const step3Box = document.getElementById('step3Box');

    if (selectedCategory) {
        step1Box.className = "catgogry_box step-completed";
        step2ContentBox.className = "pet_choice_box step-completed";

        step3Box.classList.remove('step-locked');
        step3Box.classList.add('step-active');
    } else {
        step1Box.className = "catgogry_box";

        if (!step2ContentBox.classList.contains('step-locked')) {
            step2ContentBox.className = "pet_choice_box step-active";
        }
        step3Box.classList.add('step-locked');
        step3Box.classList.remove('step-active');
    }
}

function toggleBreed(){
    const selectedRadio = document.querySelector('input[name="comm_pet_type"]:checked');
    if (!selectedRadio) return;
    const selectedType = selectedRadio.value;

    const breedWrapper = document.getElementById('breedWrapper');
    const dogSelect = document.getElementById('dogBreedSelect');
    const catSelect = document.getElementById('catBreedSelect');

    if(selectedType === 'dog'){
        breedWrapper.style.display = 'block';
        dogSelect.style.display = 'inline-block';
        dogSelect.disabled = false;
        catSelect.style.display = 'none';
        catSelect.disabled = true;
    } else if(selectedType === 'cat'){
        breedWrapper.style.display = 'block';
        catSelect.style.display = 'inline-block';
        catSelect.disabled = false;
        dogSelect.style.display = 'none';
        dogSelect.disabled = true;
    } else {
        breedWrapper.style.display = 'none';
        dogSelect.disabled = true;
        catSelect.disabled = true;
    }
}

let tags = [];

function clickAddTag() {
    const tagInput = document.getElementById('tagInput');
    let val = tagInput.value.trim();
    
    if (val !== '') {
        if (!val.startsWith('#')) {
            val = '#' + val;
        }
        
        if (tags.includes(val)) {
            alert('이미 추가된 태그입니다.');
            tagInput.value = '';
            return;
        }
        
        tags.push(val);
        renderTags();
        tagInput.value = '';
    }
}

function removeTag(index) {
    tags.splice(index, 1);
    renderTags();
}

function renderTags() {
    const tagListArea = document.getElementById('tagListArea');
    const commTagHidden = document.getElementById('commTagHidden');

    tagListArea.innerHTML = '';

    tags.forEach((tag, index) => {
        const tagItem = document.createElement('div');
        tagItem.className = 'tag-item';
        tagItem.style.background = '#ffeb3b';
        tagItem.style.padding = '2px 6px';
        tagItem.style.borderRadius = '4px';
        tagItem.style.fontSize = '12px';
        tagItem.innerHTML = tag + ' <span class="tag-close" style="cursor:pointer; font-weight:bold;" onclick="removeTag(' + index + ')">&times;</span>';
        tagListArea.appendChild(tagItem);
    });

    commTagHidden.value = tags.join(',');
}

let selectedFiles = [];

document.getElementById('uploadImages').addEventListener('change', function(e){
	for(const file of e.target.files){
		selectedFiles.push(file);
	}
	
	const dataTransfer = new DataTransfer();
	selectedFiles.forEach(file => dataTransfer.items.add(file));
	e.target.files = dataTransfer.files;
});

function validateForm() {
    const selectedCommType = document.querySelector('input[name="comm_type"]:checked');
    if (!selectedCommType) {
        alert("게시판을 선택해주세요.");
        return false;
    }
    return true;
}
</script>
</body>
</html>