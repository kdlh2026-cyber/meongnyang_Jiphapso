<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>입양동물 등록</title>
</head>
<body>
<div>
<%@ include file="../../hamburger_menu.jsp" %>
	<h2>입양동물 등록</h2>
	<form action="StrayAnimalUpdate" name="strayUpdateForm" method="post" enctype="multipart/form-data">
		<input type="hidden" name="stray_no" value="${StrayUpdate.stray_no}">
	<div>
		유기동물 카테고리 :
		<input type="text" name="stray_category" value="${StrayUpdate.stray_category}" required>
	</div>
	<div>
		유기동물 품종 :
		<input type="text" name="stray_name" value="${StrayUpdate.stray_name}" required>
	</div>
	<div>
		유기동물 성별 :<br>
		<input type="radio" name="stray_gender" value="M" ${StrayUpdate.stray_gender eq 'M' ? 'checked' : ''} required> 수컷<br>
		<input type="radio" name="stray_gender" value="F" ${StrayUpdate.stray_gender eq 'F' ? 'checked' : ''}> 암컷<br>
		<input type="radio" name="stray_gender" value="Q" ${StrayUpdate.stray_gender eq 'Q' ? 'checked' : ''}> 미상<br>
	</div>
	<div>
		유기동물 중성화 :<br>
		<input type="radio" name="stray_neuter" value="Y" ${StrayUpdate.stray_neuter eq 'Y' ? 'checked' : ''} required> 중성화 완료<br>
		<input type="radio" name="stray_neuter" value="N" ${StrayUpdate.stray_neuter eq 'N' ? 'checked' : ''}> 중성화 미완료<br>
		<input type="radio" name="stray_neuter" value="U" ${StrayUpdate.stray_neuter eq 'U' ? 'checked' : ''}> 중성화 알수없음<br>
	</div>
	<div>
		유기동물 무게 :
		<input type="number" name="stray_weight" step="0.01" value="${StrayUpdate.stray_weight}" required>
	</div>
	<div>
		유기동물 털 색 :
		<input type="text" name="stray_character" value="${StrayUpdate.stray_character}" required>
	</div>
	<div>
		유기동물 특이사항 :
		<input type="text" name="stray_memo" value="${StrayUpdate.stray_memo}" required>
	</div>
	<div>
		유기동물 상태 :
		<input type="text" name="stray_status" value="${StrayUpdate.stray_status}" required>
	</div>
	<div>
		보호소 이름 :
		<input type="text" name="stray_shelter_name" value="${StrayUpdate.stray_shelter_name}" required>
	</div>
	<div>
		보호소 연락처 :
		<input type="tel" name="stray_shelter_tel" value="${StrayUpdate.stray_shelter_tel}" required>
	</div>
	<div>
		보호 주소 :
		<input type="text" name="stray_shelter_addr" value="${StrayUpdate.stray_shelter_addr}" required>
	</div>
	<div>
		유기동물 메인 이미지 :
		<input type="hidden" name="existing_stray_img" value="${StrayUpdate.stray_img}">
		<input type="file" name="main_img">
		<c:if test="${not empty StrayUpdate.stray_img}">
        	<p>현재 등록된 파일: <strong>${StrayUpdate.stray_img}</strong></p>
        </c:if>
	</div>
	<div>
		<input type="submit" value="입양 수정">
		<input type="button" value="취소" onclick="history.back()"> 
	</div>
	</form>
</div>	
</body>
</html>