<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>멍냥집합소</title>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
	<h2>반려동물 등록</h2>
	<form id="" method="post" action="/myPetInsert" enctype="multipart/form-data">
		<table>
			<tr>
				<td><input type="file" name="pet_upload" placeholder="등록 사진은 1개만 첨부 가능합니다."></td>
			</tr>
			<tr>
				<td><input type="text" name="pet_name" placeholder="이름"></td>
			</tr>
			<tr>
				<td><input type="text" name="pet_birth" placeholder="반려동물의 생년월일 8자리를 입력해주세요"></td>
			</tr>
			<tr>
				<td>
					<input type="radio" name="pet_type" value="강아지" onclick="toggleBreed()"><img src="/images/stray/menu/dog_head.png" width="70px"> 
					<input type="radio" name="pet_type" value="고양이" onclick="toggleBreed()"><img src="/images/stray/menu/cat_head.png" width="70px"> 
					<input type="radio" name="pet_type" value="그 외" onclick="toggleBreed()"><img src="/images/main/hamster_head.png" width="70px">
				</td>
			</tr>
			<tr>
				<td>
					<div id="breedWrapper" style="display:none;">
						<select name="pet_breed" id="dogBreedSelect" style="display:none;">
							<option value="">강아지 품종 선택</option>
							<c:forEach var="dog" items="${dogBreed}">
								<option value="${dog.breed_name}">${dog.breed_name}</option>
							</c:forEach>
						</select>
						
						<select name="pet_breed" id="catBreedSelect" style="display:none;">
							<option value="">고양이 품종 선택</option>
							<c:forEach var="cat" items="${catBreed}">
								<option value="${cat.breed_name}">${cat.breed_name}</option>
							</c:forEach>
						</select>
					</div>
					<input type="text" name="pet_breed" id="etcBreedInput" placeholder="품종을 입력해주세요" style="display:none;">
				</td>
			</tr>
			<tr>
				<td>
					<input type="radio" name="pet_gender" value="남아">남아 
					<input type="radio" name="pet_gender" value="여아">여아
				</td>
			</tr>
			<tr>
				<td>
					<input type="checkbox" name="pet_neuter">중성화 여부
				</td>
			</tr>
			<tr>
				<td>
					<input type="text" name="pet_weight" placeholder="몸무게(kg)">
				</td>
			</tr>
		</table>
		<input type="submit" value="등록"><br>
		<input type="reset" value="취소">
	</form>
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
        // 그 외 → 직접 입력
        breedWrapper.style.display = 'none';
        dogSelect.disabled = true;
        catSelect.disabled = true;
        etcInput.style.display = 'block';
        etcInput.disabled = false;
    }
}
</script>
</body>
</html>