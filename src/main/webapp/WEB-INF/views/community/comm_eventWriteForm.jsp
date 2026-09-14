<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이벤트 등록</title>
<link rel="stylesheet" href="/css/community/commWriteForm.css">
</head>
<body>
<%@ include file="../hamburger_menu.jsp" %>
	<form name="eventWriteForm" method="post" action="#" enctype="multipart/form-data">
	<input type="hidden" name="m_no" value="${m_no}"> 
		<div class="title">
			<input type="text" name="event_title" placeholder="제목을 입력해주세요">
		</div>
		<div class="catgogry">
			<input type="radio" name="event_pet_type" value="dog" checked> 강아지 | 
			<input type="radio" name="event_pet_type" value="cat"> 고양이
		</div>
		<div class="catgogry">
			<input type="radio" name="event_onoff" value="online" checked> 온라인 | 
			<input type="radio" name="event_onoff" value="offline"> 오프라인
		</div>
		<input type="date" name="event_start"><br>
		<input type="date" name="event_end"><br>
		<input type="checkbox" name="event_all"><br>	
		<input type="text" name="event_loc"><br>	
		<div class="body_content">
			<textarea rows="30" cols="50" name="event_content" placeholder="5자 이상의 질문 내용을 입력해주세요."></textarea>
		</div>	
	</form>

<%@ include file="../footer.jsp" %>
</body>
</html>