<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>품종관리</title>
<link rel="stylesheet" href="/css/breedInfo/breedInfo.css">
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
	<div class="breed_wrap">
		<h3>DOG 견종 관리</h3>
		<div class="dogInfo_section">
			<div class="breed_container">
				<c:forEach var="breed" items="${dogbreed}">
					<!-- ⭐ data-* 속성으로 안전하게 값 전달 -->
					<button type="button" class="breed-item-btn" 
					        data-id="${breed.breed_id}" 
					        data-name="${breed.breed_name}" 
					        data-icon="${breed.icon_url}" 
					        data-type="${breed.pet_type}">
		                <img src="/images/breed/${breed.icon_url}" alt="강아지 이미지" width="30"> ${breed.breed_name}
		            </button>
				</c:forEach>
	
				<button type="button" class="breed-add-btn" onclick="openAddBreedForm('강아지')">
				    + 견종 추가
				</button>
			</div>
		</div>
			
		<h3>CAT 품종 관리</h3>
		<div class="catInfo_section">
			<div class="breed_container">
				<c:forEach var="breed" items="${catbreed}">
					<!-- ⭐ data-* 속성으로 안전하게 값 전달 -->
					<button type="button" class="breed-item-btn" 
					        data-id="${breed.breed_id}" 
					        data-name="${breed.breed_name}" 
					        data-icon="${breed.icon_url}" 
					        data-type="${breed.pet_type}">
		                <img src="/images/breed/${breed.icon_url}" alt="고양이 이미지" width="30"> ${breed.breed_name}
		            </button>
				</c:forEach>
	
				<button type="button" class="breed-add-btn" onclick="openAddBreedForm('고양이')">
				    + 품종 추가
				</button>
			</div>
		</div>
	</div>
		
	<!-- 공용 모달 (추가 / 수정 / 삭제 공용) -->
	<div id="breedModal" class="modal-overlay">
	    <div class="modal-content">
	        <h3 id="modalTitle">품종 관리</h3>
	        <p id="modalDesc">어떤 친구를 입력하시겠어요?</p>
	        
	        <form id="breedForm" action="/admin/breedInsert" method="post" enctype="multipart/form-data">
	            <input type="hidden" id="breedIdInput" name="breed_id" value="">
	            <input type="hidden" id="petTypeInput" name="pet_type" value="">
	            
	            <!-- ⭐ 빠져있던 품종 이름 입력창 추가 -->
	            <div class="modal-input-group">
	                <input type="text" id="breedNameInput" name="breed_name" placeholder="품종 이름을 입력하세요" required>
	            </div>
	            
	            <div class="modal-input-group">
	                <div class="file-upload-wrapper">
	                    <label for="iconUrlInput" class="file-upload-label">
	                        <span class="file-upload-btn">아이콘 선택</span>
	                        <span id="fileNameDisplay" class="file-name">선택된 파일 없음</span>
	                    </label>
	                    <input type="file" id="iconUrlInput" name="icon_file" onchange="updateFileName(this)">
	                </div>
	            </div>
	            
	            <div class="modal-btn-group">
	                <button type="submit" id="submitBtn" class="btn-submit">전송</button>
	                <button type="submit" id="deleteBtn" class="btn-delete" onclick="setFormAction('/admin/breedDelete')">삭제</button>              
	                <button type="button" class="btn-close" onclick="closeModal()">닫기</button>
	            </div>
	        </form>
	    </div>
	</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
<script>
// 문서가 로드된 후 모든 품종 버튼에 클릭 이벤트 일괄 등록
document.addEventListener("DOMContentLoaded", function() {
    const breedButtons = document.querySelectorAll(".breed-item-btn");
    
    breedButtons.forEach(button => {
        button.addEventListener("click", function() {
            const breedId = this.getAttribute("data-id");
            const breedName = this.getAttribute("data-name");
            const iconUrl = this.getAttribute("data-icon");
            const petType = this.getAttribute("data-type");
            
            handleBreedClick(breedId, breedName, iconUrl, petType);
        });
    });
});

// 1. [+ 견종/품종 추가] 버튼을 눌렀을 때 (등록 모드)
function openAddBreedForm(petType) {
    document.getElementById("modalTitle").innerText = petType + " 품종 추가";
    document.getElementById("modalDesc").innerText = "새로운 품종을 입력해주세요.";
    
    let breedIdInput = document.getElementById("breedIdInput");
    breedIdInput.value = "";
    breedIdInput.removeAttribute("name"); 
    
    document.getElementById("breedNameInput").value = "";
    document.getElementById("iconUrlInput").value = "";
    document.getElementById("petTypeInput").value = petType;
    
    document.getElementById("submitBtn").innerText = "전송";
    document.getElementById("deleteBtn").style.display = "none";
    document.getElementById("breedForm").action = "/admin/breedInsert";
    
    document.getElementById("breedModal").style.display = "flex";
}

// 2. [기존 품종 버튼]을 클릭했을 때 (수정/삭제 모드)
function handleBreedClick(breedId, breedName, iconUrl, petType) {
    document.getElementById("modalTitle").innerText = petType + " 품종 수정 / 삭제";
    document.getElementById("modalDesc").innerText = "정보를 수정하거나 삭제할 수 있습니다.";
    
    let breedIdInput = document.getElementById("breedIdInput");
    breedIdInput.name = "breed_id"; 
    breedIdInput.value = breedId;
    
    document.getElementById("breedNameInput").value = breedName;
    document.getElementById("petTypeInput").value = petType;
    
    document.getElementById("submitBtn").innerText = "수정";
    document.getElementById("deleteBtn").style.display = "inline-block";
    document.getElementById("breedForm").action = "/admin/breedUpdate";
    
    document.getElementById("breedModal").style.display = "flex";
}

// 3. 모달 닫기
function closeModal() {
    document.getElementById("breedModal").style.display = "none";
}

// 4. 전송 버튼 종류에 따라 form action 주소 변경 (수정 vs 삭제)
function setFormAction(actionUrl) {
    document.getElementById("breedForm").action = actionUrl;
}

function updateFileName(input) {
    const fileNameDisplay = document.getElementById("fileNameDisplay");
    if (input.files && input.files[0]) {
        fileNameDisplay.innerText = input.files[0].name;
        fileNameDisplay.style.color = "#333333"; // 파일 선택 시 진한 글씨로 변경
    } else {
        fileNameDisplay.innerText = "선택된 파일 없음";
        fileNameDisplay.style.color = "#888888";
    }
}
</script>
</html>