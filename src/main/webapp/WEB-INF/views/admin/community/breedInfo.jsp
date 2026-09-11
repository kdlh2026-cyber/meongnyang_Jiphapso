<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>품종관리</title>
</head>
<style>
/* 평소에는 화면에서 숨김 처리 */
.modal-overlay {
    display: none; 
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    justify-content: center;
    align-items: center;
}
</style>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
	<h3>DOG 견종 관리</h3>
	<div class="dogInfo_section">
		<div class="breed_container">
			<c:forEach var="breed" items="${dogbreed}">
				<button type="button" class="breed-item-btn" onclick="handleBreedClick('${breed.breed_id}', '${breed.breed_name}', '${breed.icon_url}', '${breed.pet_type}')">
	                ${breed.icon_url} ${breed.breed_name}
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
				<button type="button" class="breed-item-btn" onclick="handleBreedClick('${breed.breed_id}', '${breed.breed_name}', '${breed.icon_url}', '${breed.pet_type}')">
	                ${breed.icon_url} ${breed.breed_name}
	                ${breed.icon_url} ${breed.breed_name}
	            </button>
			</c:forEach>

			<button type="button" class="breed-add-btn" onclick="openAddBreedForm('고양이')">
			    + 품종 추가
			</button>
		</div>
	</div>
		
	<!-- 공용 모달 (추가 / 수정 / 삭제 공용) -->
	<div id="breedModal" class="modal-overlay">
	    <div class="modal-content">
	        <h3 id="modalTitle">품종 관리</h3>
	        <p id="modalDesc">어떤 친구를 입력하시겠어요?</p>
	        
	        <!-- form의 action은 자바스크립트로 동적으로 바꿔줍니다 -->
	        <form id="breedForm" action="/admin/breedInsert" method="post">
	            <!-- 수정/삭제 시 필요한 breed_id (추가할 때는 빈 값) -->
	            <input type="hidden" id="breedIdInput" name="breed_id" value="">
	            <!-- 강아지/고양이 구분 값 -->
	            <input type="hidden" id="petTypeInput" name="pet_type" value="">
	            
	            <div class="modal-input-group">
	                <input type="text" id="breedNameInput" name="breed_name" placeholder="품종 이름을 입력하세요" required>
	            </div>
	            
	            <div class="modal-input-group">
	                <input type="text" id="iconUrlInput" name="icon_url" placeholder="아이콘 URL (선택사항)">
	            </div>
	            
	            <div class="modal-btn-group">
	                <!-- 등록/수정 버튼 (기본은 등록용) -->
	                <button type="submit" id="submitBtn" class="btn-submit" onclick="setFormAction('/admin/breedUpdate')">전송</button>
	                <!-- 삭제 버튼 (평소엔 숨겨두었다가, 기존 품종을 눌러서 들어왔을 때만 보이게 처리 가능) -->
	                <button type="submit" id="deleteBtn" class="btn-delete" style="display: none; background: #dc3545; color: #fff;" onclick="setFormAction('/admin/breedDelete')">삭제</button>	                
	                <button type="button" class="btn-close" onclick="closeModal()">닫기</button>
	            </div>
	        </form>
	    </div>
	</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
<script>
//1. [+ 견종/품종 추가] 버튼을 눌렀을 때 (등록 모드)
function openAddBreedForm(petType) {
    document.getElementById("modalTitle").innerText = petType + " 품종 추가";
    document.getElementById("modalDesc").innerText = "새로운 품종을 입력해주세요.";
    
    // 입력값 초기화
    document.getElementById("breedIdInput").value = "";
    document.getElementById("breedNameInput").value = "";
    document.getElementById("iconUrlInput").value = "";
    document.getElementById("petTypeInput").value = petType;
    
    // 버튼 상태 설정 (등록 버튼 보이기, 삭제 버튼 숨기기, 액션 지정)
    document.getElementById("submitBtn").innerText = "전송";
    document.getElementById("deleteBtn").style.display = "none";
    document.getElementById("breedForm").action = "/admin/breedInsert";
    
    // 모달 띄우기
    document.getElementById("breedModal").style.display = "flex";
}

// 2. [기존 품종 버튼]을 클릭했을 때 (수정/삭제 모드)
function handleBreedClick(breedId, breedName, iconUrl, petType) {
    document.getElementById("modalTitle").innerText = petType + " 품종 수정 / 삭제";
    document.getElementById("modalDesc").innerText = "정보를 수정하거나 삭제할 수 있습니다.";
    
    // 기존 품종 데이터 세팅
    document.getElementById("breedIdInput").value = breedId;
    document.getElementById("breedNameInput").value = breedName;
    document.getElementById("iconUrlInput").value = (iconUrl === 'null' || iconUrl === 'undefined') ? '' : iconUrl;
    document.getElementById("petTypeInput").value = petType;
    
    // 버튼 상태 설정 (수정 버튼, 삭제 버튼 모두 보이기, 기본 액션은 수정으로)
    document.getElementById("submitBtn").innerText = "수정";
    document.getElementById("deleteBtn").style.display = "inline-block";
    document.getElementById("breedForm").action = "/admin/breedUpdate";
    
    // 모달 띄우기
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
</script>
</html>