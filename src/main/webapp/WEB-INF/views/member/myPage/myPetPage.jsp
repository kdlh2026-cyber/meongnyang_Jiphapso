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
				<c:choose>
				    <c:when test="${not empty myPetPage.pet_image}">
				        <img src="/images/myPet/${myPetPage.pet_image}" alt="${myPetPage.pet_name}" width="200">
				    </c:when>
				    <c:when test="${myPetPage.pet_type=='고양이'}">
				        <img src="/images/stray/menu/cat_head.png" width="200">
				    </c:when>
				    <c:when test="${myPetPage.pet_type=='강아지'}">
				        <img src="/images/stray/menu/dog_head.png" width="200">
				    </c:when>
				    <c:otherwise>
				        <img src="/images/main/hamster_head.png" width="200">
				    </c:otherwise>
				</c:choose>
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
	<a href="/myPetUpdateForm?pet_no=${myPetPage.pet_no}">수정</a>
	<a href="/myPetDelete?pet_no=${myPetPage.pet_no}">삭제</a>
	<a href="/member/myPage/myPetList">목록</a>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>