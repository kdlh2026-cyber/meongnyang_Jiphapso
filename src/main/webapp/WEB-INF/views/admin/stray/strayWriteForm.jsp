<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>입양동물 등록</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/etc/admin_form.css">
<script src="/js/strayCheck.js"></script>
</head>
<body>
<div>
<%@ include file="../../hamburger_menu.jsp" %>
	<h2>입양동물 등록</h2>
	<form action="StrayAnimalWrite" name="strayWriteForm" method="post" enctype="multipart/form-data" onsubmit="return strayCheck();">
		<div>
			<label>유기동물 번호 :</label>
			<input type="number" name="stray_no" required>
		</div>
		<div>
			<label>유기동물 카테고리 :</label>
			<input type="radio" name="stray_category" value="DOG" required>강아지
			<input type="radio" name="stray_category" value="CAT">고양이
		</div>
		<div>
			<label>유기동물 품종 :</label>
			<input type="text" name="stray_name" required>
		</div>
		<div>
			<label>유기동물 나이 :</label>
			<input type="text" name="stray_age" placeholder="예: 2025" maxlength="4" inputmode="numeric" required>
		</div>
		<div>
			<label>유기동물 성별 :</label>
			<div>
				<input type="radio" name="stray_gender" value="M" required>수컷
				<input type="radio" name="stray_gender" value="F">암컷
				<input type="radio" name="stray_gender" value="Q">미상
			</div>
		</div>
		<div>
			<label>유기동물 중성화 :</label>
			<div>
				<input type="radio" name="stray_neuter" value="Y" required>중성화 완료
				<input type="radio" name="stray_neuter" value="N">중성화 미완료
				<input type="radio" name="stray_neuter" value="U">중성화 알수없음 
			</div>
		</div>
		<div>
		    <label>유기동물 무게(kg) :</label>
		    <input type="number" name="stray_weight" step="0.01" min="0.01" max="999.99"
		           placeholder="예: 4.44" required>
		</div>
		<div>
			<label>유기동물 털 색 :</label>
			<input type="text" name="stray_character" required>
		</div>
		<div>
			<label>유기동물 특이사항 :</label>
			<input type="text" name="stray_memo" required>
		</div>
		<div>
			<label>유기동물 상태 :</label>
			<input type="radio" name="stray_status" value="보호중" required>보호중
			<input type="radio" name="stray_status" value="공고중">공고중
		</div>

		<hr>

		<div>
			<label>공고 번호 :</label>
			<input type="text" name="stray_notice_no" required>
		</div>
		<div>
			<label>공고 시작일 :</label>
			<input type="date" name="stray_notice_start"
			onchange="document.strayWriteForm.stray_notice_end.min = this.value;" required>
		</div>
		<div>
			<label>공고 마지막일 :</label>
			<input type="date" name="stray_notice_end" required>
		</div>
		<div>
			<label>발견 장소 :</label>
			<input type="text" name="stray_found_place" required>
		</div>

		<hr>

		<div>
			<label>보호소 이름 :</label>
			<input type="text" name="stray_shelter_name" required>
		</div>
		<div>
			<label>보호소 연락처 :</label>
			<input type="tel" name="stray_shelter_tel" maxlength="13" 
           placeholder="전화번호를 입력하세요" inputmode="numeric" 
           oninput="autoHyphenTel(this)" required>
		</div>
		<div>
			<label>보호 주소 :</label>
			<input type="text" name="stray_shelter_addr" required>
		</div>
		<div>
			<label>유기동물 메인 이미지 :</label>
			<input type="file" name="main_img" required>
		</div>

		<div class="form-btn-group">
			<input type="submit" value="입양 등록">
			<input type="button" value="취소" onclick="history.back()"> 
		</div>
	</form>
</div>	
</body>
</html>