<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>멍냥집합소</title>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
	<table>
		<tr>
			<td>
				<img src="/images/myPet/${myPetPage.pet_image}" alt="${myPetPage.pet_name}" width="200">
			</td>
		</tr>
		<tr>
			<td>${myPetPage.pet_name}</td>
		</tr>
		<tr>
			<td>${myPetPage.pet_birth}</td>
		</tr>
		<tr>
			<td>${myPetPage.pet_breed}</td>
		</tr>
		<tr>
			<td>${myPetPage.pet_gender}</td>
		</tr>
		<tr>
			<td>${myPetPage.pet_weight} kg</td>
		</tr>
	</table>
	<a href="/member/myPage/myPetList">목록</a>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>