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
	나의 반려동물 리스트 페이지<br>
	<table>
		<tr>
			<th>이미지</th>
			<th>이름</th>
			<th>종류</th>
			<th>품종</th>
			<th>성별</th>
		</tr>
		<c:forEach var="list" items="${myPetList}">
		<tr>
			<td><a href="/member/myPage/myPetPage?pet_no=${list.pet_no}"><img src="/images/myPet/${list.pet_image}" alt="${list.pet_image}" width="80"></a></td>
			<td><a href="/member/myPage/myPetPage?pet_no=${list.pet_no}">${list.pet_name}</a></td>
			<td>${list.pet_type}</td>
			<td>${list.pet_breed}</td>
			<td>${list.pet_gender}</td>
			<td>
				<a href="/myPetDelete?pet_no=${list.pet_no}">삭제</a>
			</td>
		</tr>
		</c:forEach>
	</table>
	<br>
	<a href="/member/myPage/myPetInsertForm">추가하기</a>
	<br>
	<br>
	
	<a href="/member/myPage/myPage">마이페이지</a>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>