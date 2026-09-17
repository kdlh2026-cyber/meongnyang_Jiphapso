<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>입양동물 수정</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/etc/admin_form.css">
</head>
<body>
<div>
<%@ include file="/WEB-INF/views/admin/clone/hamburger_menu.jsp" %>
	<h2>입양동물 수정</h2>
	<form action="StrayAnimalUpdate" name="strayUpdateForm" method="post" enctype="multipart/form-data">
		<input type="hidden" name="stray_no" value="${StrayUpdate.stray_no}">
		
		<div>
			<label>유기동물 카테고리 :</label>
			<input type="text" name="stray_category" value="${StrayUpdate.stray_category}" readonly>
		</div>
		<div>
			<label>유기동물 품종 :</label>
			<input type="text" name="stray_name" value="${StrayUpdate.stray_name}" required>
		</div>
		<div>
			<label>유기동물 성별 :</label>
			<div>
				<input type="radio" name="stray_gender" value="M" ${StrayUpdate.stray_gender eq 'M' ? 'checked' : ''} required> 수컷
				<input type="radio" name="stray_gender" value="F" ${StrayUpdate.stray_gender eq 'F' ? 'checked' : ''}> 암컷
				<input type="radio" name="stray_gender" value="Q" ${StrayUpdate.stray_gender eq 'Q' ? 'checked' : ''}> 미상
			</div>
		</div>
		<div>
			<label>유기동물 중성화 :</label>
			<div>
				<input type="radio" name="stray_neuter" value="Y" ${StrayUpdate.stray_neuter eq 'Y' ? 'checked' : ''} required> 중성화 완료
				<input type="radio" name="stray_neuter" value="N" ${StrayUpdate.stray_neuter eq 'N' ? 'checked' : ''}> 중성화 미완료
				<input type="radio" name="stray_neuter" value="U" ${StrayUpdate.stray_neuter eq 'U' ? 'checked' : ''}> 중성화 알수없음
			</div>
		</div>
		<div>
			<label>유기동물 무게 :</label>
			<input type="number" name="stray_weight" step="0.01" value="${StrayUpdate.stray_weight}" required>
		</div>
		<div>
			<label>유기동물 털 색 :</label>
			<input type="text" name="stray_character" value="${StrayUpdate.stray_character}" required>
		</div>
		<div>
			<label>유기동물 특이사항 :</label>
			<input type="text" name="stray_memo" value="${StrayUpdate.stray_memo}" required>
		</div>
		<div>
			<label>유기동물 상태 :</label>
			<input type="text" name="stray_status" value="${StrayUpdate.stray_status}" required>
		</div>
		<div>
			<label>보호소 이름 :</label>
			<input type="text" name="stray_shelter_name" value="${StrayUpdate.stray_shelter_name}" required>
		</div>
		<div>
			<label>보호소 연락처 :</label>
			<input type="tel" name="stray_shelter_tel" value="${StrayUpdate.stray_shelter_tel}" required>
		</div>
		<div>
			<label>보호 주소 :</label>
			<input type="text" name="stray_shelter_addr" value="${StrayUpdate.stray_shelter_addr}" required>
		</div>
		<div>
			<label>유기동물 메인 이미지 :</label>
			<input type="hidden" name="existing_stray_img" value="${StrayUpdate.stray_img}">
			<input type="file" name="main_img">
			<c:if test="${not empty StrayUpdate.stray_img}">
				<div class="current-main-img-wrap">
					<img src="/uploadImages/${StrayUpdate.stray_img}" 
					     alt="메인이미지" class="detail-img-thumb">
					<span class="detail-img-name">현재 등록된 파일: <strong>${StrayUpdate.stray_img}</strong></span>
				</div>
			</c:if>
		</div>
		<div class="form-btn-group">
			<input type="submit" value="입양 수정">
			<input type="button" value="취소" onclick="history.back()"> 
		</div>
	</form>
</div>	
</body>
</html>