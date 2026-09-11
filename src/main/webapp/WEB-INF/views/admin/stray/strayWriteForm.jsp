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
	<form action="StrayAnimalWrite" name="strayWriteForm" method="post" enctype="multipart/form-data">
	<div>
		유기동물 번호 :
		<input type="number" name="stray_no" required>
	</div>
	<div>
		유기동물 카테고리 :
		<input type="text" name="stray_category" required>
	</div>
	<div>
		유기동물 이름 :
		<input type="text" name="stray_name" required>
	</div>
	<div>
		유기동물 나이 :
		<input type="text" name="stray_age" required>
	</div>
	<div>
		유기동물 성별 :<br>
		<input type="radio" name="stray_gender" value="M" required> 수컷<br>
		<input type="radio" name="stray_gender" value="F"> 암컷<br>
		<input type="radio" name="stray_gender" value="Q"> 미상<br>
	</div>
	<div>
		유기동물 중성화 :<br>
		<input type="radio" name="stray_neuter" value="Y" required> 중성화 완료<br>
		<input type="radio" name="stray_neuter" value="N"> 중성화 미완료<br>
		<input type="radio" name="stray_neuter" value="U"> 중성화 알수없음<br>
	</div>
	<div>
		유기동물 무게 :
		<input type="number" name="stray_weight" step="0.01" required>
	</div>
	<div>
		유기동물 털 색 :
		<input type="text" name="stray_character" required>
	</div>
	<div>
		유기동물 특이사항 :
		<input type="text" name="stray_memo" required>
	</div>
	<div>
		유기동물 상태 :
		<input type="text" name="stray_status" required>
	</div>
	<div>
		공고 번호 :
		<input type="text" name="stray_notice_no" required>
	</div>
	<div>
		공고 시작일 :
		<input type="date" name="stray_notice_start" required>
	</div>
	<div>
		공고 마지막일 :
		<input type="date" name="stray_notice_end" required>
	</div>
	<div>
		발견 장소 :
		<input type="text" name="stray_found_place" required>
	</div>
	<div>
		보호소 이름 :
		<input type="text" name="stray_shelter_name" required>
	</div>
	<div>
		보호소 연락처 :
		<input type="tel" name="stray_shelter_tel" required>
	</div>
	<div>
		보호 주소 :
		<input type="text" name="stray_shelter_addr" required>
	</div>
	<div>
		유기동물 메인 이미지 :
		<input type="file" name="main_img" required>
	</div>
	<div>
		<input type="submit" value="입양 등록">
		<input type="button" value="취소" onclick="history.back()"> 
	</div>
	</form>
</div>	
</body>
</html>