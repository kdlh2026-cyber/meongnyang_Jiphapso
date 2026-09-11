<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>커뮤니티 게시글(포스트, Q&A, 라운지)</title>
<link rel="stylesheet" href="/css/community/commWriteForm.css">
</head>
<body>
<%@ include file="../hamburger_menu.jsp" %>
	<div>[Q&A, 라운지 글쓰기 페이지]</div>
	<div><h1>Q&A 질문 작성</h1></div>
	<div>반려동물에 대한 궁금증을 가장 빠르게 답변 받아보세요!</div>
	<div>
		<form name="communityWriteForm" method="post" action="/commWrite" enctype="multipart/form-data">
			<div class="catgogry">
				<input type="radio" name="comm_type" value="Q&A" checked> Q&A | 
				<input type="radio" name="comm_type" value="라운지"> 라운지 |
				<input type="radio" name="comm_type" value="콘텐츠"
					<c:if test="${empty sessionScope.loginUser or sessionScope.loginUser.m_role ne 'CREATOR'}">disabled</c:if>> 콘텐츠
					<c:if test="${empty sessionScope.loginUser or sessionScope.loginUser.m_role ne 'CREATOR'}">
						<span style="font-size: 11px; color: #888;">(크리에이터 전용)</span>
					</c:if>
			</div>	
				
			<div class="title">
				<input type="text" name="comm_title" placeholder="제목을 입력해주세요">
			</div>	
				<div class="explain">
					<span class="sub_explain">! 질병 관련 질문 시 지역명을 함께 적어주시면 수의사분들의 빠른 답변을 받아보실 수 있습니다.</span>
					(예: [부산 서면] 슬개골 탈구 관련 병원 안내 부탁드려요.)
					<!--(제목에 지역명을 넣을 경우 그 지역에서 활동하는 수의사(회원)에게 자동으로 알람이 가는건가??)  -->
				</div>
				
			<div class="body_content">
				<textarea rows="30" cols="50" name="comm_content" placeholder="5자 이상의 질문 내용을 입력해주세요."></textarea>
			</div>
			
			<div class="pet_choice">
				<div class="category_name">동물 종류</div> 
					<input type="radio" name="comm_pet_type" value="dog" checked onclick="toggleBreed()"> 강아지
					<input type="radio" name="comm_pet_type" value="cat" onclick="toggleBreed()"> 고양이
					<input type="radio" name="comm_pet_type" value="small" onclick="toggleBreed()"> 소동물
					<input type="radio" name="comm_pet_type" value="etc" onclick="toggleBreed()"> 기타
			</div>
			
			<div id="breedWrapper" style="display: none;">
				<div class="category_name" id="breedLabel">품종</div> 
				
				<select name="comm_breed" id="dogBreedSelect" style="display: none;">
					<option value="">강아지 품종 선택</option>
					<c:forEach var="breed" items="${dogBreed}">
						<option value="${breed.breed_name}">${breed.breed_name}</option>
					</c:forEach>
				</select>

				<select name="comm_breed" id="catBreedSelect" style="display: none;" disabled>
					<option value="">고양이 품종 선택</option>
					<c:forEach var="breed" items="${catBreed}">
						<option value="${breed.breed_name}">${breed.breed_name}</option>
					</c:forEach>
				</select>
			</div>
			
			<div class="tag_box" id="tag_box">
				<div class="category_name">태그</div> 
				<input type="text" id="tagInput" placeholder="# 태그 입력 후 enter" 
				       onkeydown="if(event.key === 'Enter'){ event.preventDefault(); clickAddTag(); }">
				<button type="button" class="tag-add-btn" onclick="clickAddTag()">태그 추가</button>
			</div>
			<div class="tag_list_area" id="tagListArea"></div>
			<input type="hidden" name="comm_tag" id="commTagHidden"> <p>

			<div class="file_section">
				<div class="category_name">사진 & 동영상</div>
				
				<label for="uploadImages" class="file_custom_btn">사진 첨부</label>
				<input type="file" id="uploadImages" name="uploadImages" class="file_input_hidden" multiple accept="image/*">
				<div class="file_guide">최대 10장 · 20MB 이하</div>
				
				<label for="uploadVideo" class="file_custom_btn">동영상 첨부</label>
				<input type="file" id="uploadVideo" name="uploadVideo" class="file_input_hidden" multiple accept="video/*">
				<div class="file_guide">
					최대 65MB · 1개<br>
				    동영상과 사진을 함께 업로드 시, 첫 번째 사진이 썸네일로 지정됩니다.<br>
				    동영상 1개만 업로드 시, 동영상에서 썸네일이 추출됩니다.
				</div>
			</div>
			
			<input type="submit" value="질문 등록">
		</form>
	</div>
	<hr>
<%@ include file="../footer.jsp" %>

<!-- 자바스크립트를 body 맨 아래로 이동하여 DOM 로딩 문제 해결 -->
<script>
//1. 견종 토글 함수
function toggleBreed(){
	const selectedRadio = document.querySelector('input[name="comm_pet_type"]:checked');
	if (!selectedRadio) return;
    const selectedType = selectedRadio.value;
    
    const breedWrapper = document.getElementById('breedWrapper');
    const breedLabel = document.getElementById('breedLabel');
    const dogSelect = document.getElementById('dogBreedSelect');
    const catSelect = document.getElementById('catBreedSelect');
    
    if(selectedType === 'dog'){
        breedWrapper.style.display = 'block';
        breedLabel.innerText = '견종';
        dogSelect.style.display = 'inline-block';
        dogSelect.disabled = false; // 전송에 포함되도록 활성화
        catSelect.style.display = 'none';
        catSelect.disabled = true;  // 전송에서 제외되도록 비활성화
    } else if(selectedType === 'cat'){
        breedWrapper.style.display = 'block';
        breedLabel.innerText = '묘종';
        catSelect.style.display = 'inline-block';
        catSelect.disabled = false; // 전송에 포함되도록 활성화
        dogSelect.style.display = 'none';
        dogSelect.disabled = true;  // 전송에서 제외되도록 비활성화
    } else {
        // 소동물이나 기타를 선택했을 때는 품종 영역 자체를 숨김
        breedWrapper.style.display = 'none';
        dogSelect.disabled = true;
        catSelect.disabled = true;
    }
}

window.onload = function(){
    toggleBreed();
};

let tags = [];

// 2. 태그 추가 실행 함수
function clickAddTag() {
    const tagInput = document.getElementById('tagInput');
    let val = tagInput.value.trim();
    
    if (val !== '') {
        if (!val.startsWith('#')) {
            val = '#' + val;
        }
        
        // 중복 방지
        if (tags.includes(val)) {
            alert('이미 추가된 태그입니다.');
            tagInput.value = '';
            return;
        }
        
        tags.push(val);
        renderTags();
        tagInput.value = ''; // 입력창 초기화
    }
}

// 3. 태그 삭제 함수
function removeTag(index) {
    tags.splice(index, 1);
    renderTags();
}

// 4. 화면 렌더링 및 hidden 값 동기화 (아래쪽 tagListArea에 출력)
function renderTags() {
    const tagListArea = document.getElementById('tagListArea');
    const commTagHidden = document.getElementById('commTagHidden');

    // 기존에 출력된 태그 목록 초기화
    tagListArea.innerHTML = '';

    // 배열을 돌며 노란색 뱃지를 생성해 아래쪽 영역에 추가
    tags.forEach((tag, index) => {
        const tagItem = document.createElement('div');
        tagItem.className = 'tag-item';
        tagItem.innerHTML = tag + ' <span class="tag-close" onclick="removeTag(' + index + ')">&times;</span>';
        tagListArea.appendChild(tagItem);
    });

    // 서버로 전송될 hidden 필드에 값 갱신
    commTagHidden.value = tags.join(',');
}

let selectedFiles = [];

document.getElementById('uploadImages').addEventListener('change', function(e){
	// 새로 선택된 파일들을 배열에 누적
	for(const file of e.target.files){
		selectedFiles.push(file);
	}
	
	const dataTransfer = new DataTransfer();
	selectedFiles.forEach(file => dataTransfer.items.add(file));
	e.target.files = dataTransfer.files;
	
	renderImagePreview();
});

function renderImagePreview(){
	
}
</script>
</body>
</html>