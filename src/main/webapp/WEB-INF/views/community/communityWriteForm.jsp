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
</head>
<body>
<%@ include file="../hamburger_menu.jsp" %>
	<div class="write_main_container">
		<!-- 최상단 타이틀 영역 -->
		<div class="write_top_header">
			<div class="write_title_area">
				<h1 class="write_main_title">Q&amp;A 질문 작성</h1>
				<span class="write_sub_desc">반려동물에 대한 궁금증을 가장 빠르게 답변 받아보세요!</span>
			</div>
			<!-- 우측 끝 뒤로가기 링크 및 아이콘 -->
			<a href="javascript:history.back();" class="back_link_btn">
				<span class="back_icon">&lt;</span> 목록으로
			</a>
		</div>
		
		<!-- 타이틀 영역 아래 연한 구분선 -->
		<hr class="write_header_divider">
		
		<div>
			<form name="communityWriteForm" method="post" action="/commWrite" enctype="multipart/form-data" onsubmit="return validateForm()">
				
				<div class="community_write_form_layout">
					
					<!-- [왼쪽 영역] Step 1 & Step 2 세로 배치 -->
					<div class="form-column-left">
						<!-- [1단계] 게시판 선택 (카드형 라디오 적용) -->
						<div class="catgogry_box step-active" id="step1Box">
						    <div class="category_name step_title">Step 1. 게시판 선택</div>
						    <div class="card-radio-group">
							    <label class="card-radio-item">
							        <input type="radio" name="comm_type" value="QNA" onclick="checkStep1()">
							        <span class="card-label">Q&amp;A</span>
							    </label>
							    <label class="card-radio-item">
							        <input type="radio" name="comm_type" value="라운지" onclick="checkStep1()">
							        <span class="card-label">라운지</span>
							    </label>
								
							    <sec:authorize access="hasAnyRole('CREATOR', 'ADMIN')">
								    <label class="card-radio-item">
								        <input type="radio" name="comm_type" value="콘텐츠" onclick="checkStep1()">
								        <span class="card-label">콘텐츠</span>
								    </label>
							    </sec:authorize>
							
							    <sec:authorize access="!hasAnyRole('CREATOR', 'ADMIN')">
								    <label class="card-radio-item" style="opacity: 0.5; cursor: not-allowed;">
								        <input type="radio" name="comm_type" value="콘텐츠" disabled>
								        <span class="card-label">콘텐츠 <span class="creator_notice" style="margin:0;">(크리에이터 전용)</span></span>
								    </label>
							    </sec:authorize>
						    </div>
						</div>
						
						<!-- [2단계] 동물 종류 및 품종 선택 (카드형 라디오 적용) -->
						<div class="pet_choice_box step-locked" id="step2Box">
							<div class="category_name step_title">Step 2. 동물 종류 선택</div> 
							<div class="card-radio-group card-radio-grid">
								<label class="card-radio-item">
									<input type="radio" name="comm_pet_type" value="강아지" onclick="toggleBreed(); checkStep2();">
									<span class="card-label">🐶 강아지</span>
								</label>
								<label class="card-radio-item">
									<input type="radio" name="comm_pet_type" value="고양이" onclick="toggleBreed(); checkStep2();">
									<span class="card-label">🐱 고양이</span>
								</label>
								<label class="card-radio-item">
									<input type="radio" name="comm_pet_type" value="소동물" onclick="toggleBreed(); checkStep2();">
									<span class="card-label">🐹 소동물</span>
								</label>
								<label class="card-radio-item">
									<input type="radio" name="comm_pet_type" value="기타" onclick="toggleBreed(); checkStep2();">
									<span class="card-label">🐾 기타</span>
								</label>
							</div>
							
							<div id="breedWrapper" class="breed_wrapper">
								<select name="comm_breed" id="dogBreedSelect" class="breed_select" onchange="checkStep2()">
									<option value="">강아지 품종 선택</option>
									<c:forEach var="breed" items="${dogBreed}">
										<option value="${breed.breed_name}">${breed.breed_name}</option>
									</c:forEach>
								</select>

								<select name="comm_breed" id="catBreedSelect" class="breed_select" disabled onchange="checkStep2()">
									<option value="">고양이 품종 선택</option>
									<c:forEach var="breed" items="${catBreed}">
										<option value="${breed.breed_name}">${breed.breed_name}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<!-- [2단계-B] 콘텐츠 카테고리 선택 (카드형 라디오 적용) -->
						<div class="pet_choice_box step-locked" id="step2ContentBox" style="display: none;">
						    <div class="category_name step_title">Step 2. 콘텐츠 카테고리</div>
						    <div class="card-radio-group">
						        <label class="card-radio-item">
						            <input type="radio" name="comm_category" value="강아지 연구소" onclick="changeCategorySub(); checkStep2Content();">
						            <span class="card-label">강아지 연구소</span>
						        </label>
						        <label class="card-radio-item">
						            <input type="radio" name="comm_category" value="고양이 연구소" onclick="changeCategorySub(); checkStep2Content();">
						            <span class="card-label">고양이 연구소</span>
						        </label>
						        <label class="card-radio-item">
						            <input type="radio" name="comm_category" value="제품 연구소" onclick="changeCategorySub(); checkStep2Content();">
						            <span class="card-label">제품 연구소</span>
						        </label>
						        <label class="card-radio-item">
						            <input type="radio" name="comm_category" value="제보" onclick="changeCategorySub(); checkStep2Content();">
						            <span class="card-label">제보</span>
						        </label>
						        <label class="card-radio-item">
						            <input type="radio" name="comm_category" value="뉴스/브랜드" onclick="changeCategorySub(); checkStep2Content();">
						            <span class="card-label">뉴스/브랜드</span>
						        </label>
						    </div>
						    
						    <!-- 하위 카테고리 영역 -->
						    <div id="sub-category-box" class="sub_category_box">
						        <strong class="sub_category_label">상세 분야:</strong>
						        <div id="sub-category-options" class="card-radio-group"></div>
						    </div>
						</div>
					</div>
					
					<!-- [오른쪽 영역] Step 3 본문 작성 및 첨부 영역 -->
					<div class="form-column-right">
						<div id="step3Box" class="step-locked step3_box_container">
							<div class="step_title">Step 3. 내용 작성 및 첨부</div>
							
							<!-- [제목 영역] -->
							<div class="title">
								<input type="text" name="comm_title" placeholder="제목을 입력해주세요">
							</div>	
							<div class="explain">
								<span class="sub_explain">! 질병 관련 질문 시 지역명을 함께 적어주시면 수의사분들의 빠른 답변을 받아보실 수 있습니다.</span><br>
								(예: [부산 서면] 슬개골 탈구 관련 병원 안내 부탁드려요.)
							</div>
							
							<!-- [내용 입력 영역] -->
							<div class="body_content">
								<textarea rows="15" name="comm_content" placeholder="5자 이상의 질문 내용을 입력해주세요."></textarea>
							</div>
							
							<!-- [태그 / 사진 / 동영상 하단 배치] -->
							<div class="form-row-bottom">
								<!-- 태그 입력 -->
								<div class="tag_section">
									<div class="category_name tag_section_title">태그 입력</div> 
									<div class="tag_box" id="tag_box">
										<input type="text" id="tagInput" placeholder="# 태그 입력 후 enter"
										       onkeydown="if(event.key === 'Enter'){ event.preventDefault(); clickAddTag(); }">
										<button type="button" class="tag-add-btn" onclick="clickAddTag()">추가</button>
									</div>
									<div class="tag-list_area" id="tagListArea"></div>
									<input type="hidden" name="comm_tag" id="commTagHidden">
								</div>
								
								<!-- 사진 첨부 -->
								<div class="file_section_img">
									<div class="category_name file_section_title">사진 첨부</div>
									<label for="uploadImages" class="file_custom_btn">사진 선택</label>
									<input type="file" id="uploadImages" name="uploadImages" class="file_input_hidden" multiple accept="image/*">
									<div class="file_guide">최대 10장 · 20MB 이하</div>
								</div>
								
								<!-- 동영상 첨부 -->
								<div class="file_section_video">
									<div class="category_name file_section_title">동영상 첨부</div>
									<label for="uploadVideo" class="file_custom_btn">동영상 선택</label>
									<input type="file" id="uploadVideo" name="uploadVideo" class="file_input_hidden" multiple accept="video/*">
									<div class="file_guide">최대 65MB · 1개</div>
								</div>
							</div>
							
							<!-- [질문 등록 버튼] -->
							<div class="submit-btn-area">
								<input type="submit" value="질문 등록">
							</div>
						</div>
					</div>
					
				</div>
			</form>
		</div>
	</div>
	<hr>
<%@ include file="../footer.jsp" %>

<!-- 자바스크립트 제어 로직 -->
<script>
window.onload = function(){
    checkStep1();
};

function checkStep1() {
    const selectedCommType = document.querySelector('input[name="comm_type"]:checked');
    const step1Box = document.getElementById('step1Box');
    const step2Box = document.getElementById('step2Box');
    const step2ContentBox = document.getElementById('step2ContentBox');

    const subBox = document.getElementById('sub-category-box');
    const subOptions = document.getElementById('sub-category-options');
    subOptions.innerHTML = '';
    subBox.style.display = 'none';

    if (selectedCommType) {
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
        if (typeVal === '강아지') {
            const dogSelect = document.getElementById('dogBreedSelect');
            if (dogSelect.value === "") isBreedValid = false;
        } else if (typeVal === '고양이') {
            const catSelect = document.getElementById('catBreedSelect');
            if (catSelect.value === "") isBreedValid = false;
        }
    } else {
        isBreedValid = false;
    }

    if (selectedPetType && isBreedValid) {
        step1Box.className = "catgogry_box step-completed";
        step2Box.className = "pet_choice_box step-completed";

        step3Box.classList.remove('step-locked');
        step3Box.classList.add('step-active');
    } else {
        step1Box.className = "catgogry_box";
        if (!step2Box.classList.contains('step-locked')) {
            step2Box.className = "pet_choice_box step-active";
        }
        step3Box.classList.add('step-locked');
        step3Box.classList.remove('step-active');
    }
}

function changeCategorySub() {
    const selectedCategory = document.querySelector('input[name="comm_category"]:checked');
    const subBox = document.getElementById('sub-category-box');
    const subOptions = document.getElementById('sub-category-options');
    
    subOptions.innerHTML = '';

    if (!selectedCategory) {
        subBox.style.display = 'none';
        return;
    }

    const categoryVal = selectedCategory.value;
    let subList = [];

    if (categoryVal === '강아지 연구소') {
        subList = ['강아지 건강', '강아지 음식', '강아지 연구소', '강아지 제품', '강아지 데일리케어', '강아지 행동', '강아지 질병사전', '견종백과', '강아지 훈련'];
	} else if (categoryVal === '고양이 연구소') {
	    subList = ['고양이 음식', '고양이 식생활', '고양이 연구소', '고양이 제품', '고양이 데일리케어', '고양이 행동', '고양이 질병사전', '묘종백과', '고양이 건강'];
	} else if (categoryVal === '제품 연구소') {
	    subList = ['사료/간식', '용품추천', '리뷰/체험단'];
	} else if (categoryVal === '뉴스/브랜드') {
	    subList = ['뉴스', '브랜드 스토리'];
	} else {
	    subList = [];
	}

    if (subList.length > 0) {
        subList.forEach(function(item) {
            let radioHtml = '<label class="card-radio-item">' +
                            '<input type="radio" name="comm_detail" value="' + item + '" onclick="checkStep2Content()"> ' + 
                            '<span class="card-label">' + item + '</span></label>';
            subOptions.insertAdjacentHTML('beforeend', radioHtml);
        });
        subBox.style.display = 'block';
    } else {
        subBox.style.display = 'none';
    }
}

function checkStep2Content() {
    const selectedCategory = document.querySelector('input[name="comm_category"]:checked');
    const step1Box = document.getElementById('step1Box');
    const step2ContentBox = document.getElementById('step2ContentBox');
    const step3Box = document.getElementById('step3Box');
    
    let isSubValid = true;
    const subBox = document.getElementById('sub-category-box');
    
    if (subBox.style.display !== 'none') {
        const selectedSub = document.querySelector('input[name="comm_detail"]:checked');
        if (!selectedSub) {
            isSubValid = false;
        }
    }

    if (selectedCategory && isSubValid) {
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

    if(selectedType === '강아지'){
        breedWrapper.style.display = 'block';
        dogSelect.style.display = 'inline-block';
        dogSelect.disabled = false;
        catSelect.style.display = 'none';
        catSelect.disabled = true;
    } else if(selectedType === '고양이'){
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
        tagItem.innerHTML = tag + ' <span class="tag-close" onclick="removeTag(' + index + ')">&times;</span>';
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

    if (selectedCommType.value === '콘텐츠') {
        const selectedCategory = document.querySelector('input[name="comm_category"]:checked');
        if (!selectedCategory) {
            alert("콘텐츠 카테고리를 선택해주세요.");
            return false;
        }
        const subBox = document.getElementById('sub-category-box');
        if (subBox.style.display !== 'none') {
            const selectedSub = document.querySelector('input[name="comm_detail"]:checked');
            if (!selectedSub) {
                alert("상세 분야(하위 카테고리)를 선택해주세요.");
                return false;
            }
        }
    } else {
        const selectedPetType = document.querySelector('input[name="comm_pet_type"]:checked');
        if (!selectedPetType) {
            alert("동물 종류를 선택해주세요.");
            return false;
        }
    }

    const titleInput = document.querySelector('input[name="comm_title"]');
    if (!titleInput.value.trim()) {
        alert("제목을 입력해주세요.");
        titleInput.focus();
        return false;
    }

    const contentInput = document.querySelector('textarea[name="comm_content"]');
    if (contentInput.value.trim().length < 5) {
        alert("내용을 5자 이상 입력해주세요.");
        contentInput.focus();
        return false;
    }

    return true;
}
</script>
</body>
</html>