<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
					<input type="radio" name="pet_type" value="강아지">강아지 
					<input type="radio" name="pet_type" value="고양이">고양이 
					<input type="radio" name="pet_type" value="그 외">그 외
				</td>
			</tr>
			<tr>
				<td>
					<input type="text" name="pet_breed" placeholder="select문 사용, 종류 추가 예정">
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
</body>
</html>