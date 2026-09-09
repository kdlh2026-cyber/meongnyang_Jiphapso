<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>커뮤니티 게시글(포스트, Q&A, 라운지)</title>
</head>
<body>
<%@ include file="../../hamburger_menu.jsp" %>
	<div>[Q&A, 라운지 글쓰기 페이지]</div>
	<div><h1>Q&A 질문 작성</h1></div>
	<div>반려동물에 대한 궁금증을 가장 빠르게 답변 받아보세요!</div>
	<div>
		<form name="communityWriteForm" method="post" action="/commWriteCrawling">
			게시판 유형 : <input type="text" name="comm_type"> <p>
			제목 : <input type="text" name="comm_title"> <p>
			작성자 : <input type="text" name="comm_writer"> <p>
			작성일 : <input type="text" name="comm_date"> <p>
			조회수 : <input type="text" name="comm_view"> <p>
			<textarea rows="30" cols="50" name="comm_content"></textarea> <p>
			동물 종류 : <input type="text" name="comm_pet_type"> <p>
			견종 : <input type="text" name="comm_breed"> <p>
			태그 : <input type="text" name="comm_tag"> <p>
			썸네일 이미지 : <input type="text" id="comm_img" name="comm_img" placeholder="이미지 URL을 입력하세요"> <p>
			본문 이미지 : <input type="text" id="img_url" name="img_url" placeholder="이미지 URL을 입력하세요"> <p>
			도움돼요 : <input type="text" name="comm_good"><p>
			글쎄요 : <input type="text" name="comm_well"><p>
			<input type="submit" value="질문 등록">
		</form>
	</div>
<%@ include file="../../footer.jsp" %>
</body>
</html>