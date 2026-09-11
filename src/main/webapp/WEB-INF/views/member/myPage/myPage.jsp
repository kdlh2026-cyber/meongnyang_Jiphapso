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
	여기는 회원 페이지입니다.<br>
	<ul>
   <li>
      <a href="/member/myPage/myProfile?m_id=${myId.m_id}">프로필</a>
   </li>
   <li>
   	  <a href="/member/myPage/myPetList?m_no=${myId.m_no}">반려동물 프로필</a>
   </li>
   <li>
      <a href="/community/myCommunity?m_no=${myId.m_no}">내가 작성한 글</a>
   </li>
   <li>
      <a href="#">북마크 글</a>
   </li>
   <li>
      <a href="/member/order/list?m_no=${myId.m_no}">주문 내역</a>
   </li>
   <li>
   	<a href="/orderCancel/list">취소.반품 내역</a>
   </li>
   <li>
   	   <a href="/favorite/list">관심 상품</a>
   	</li>   
   <li>
      <a href="#">포인트 내역</a>
   </li>
</ul>
<a href="/memberDelete?m_id=${myId.m_id}" onclick="return confirm('정말로 탈퇴하시겠습니까?');">계정 탈퇴</a>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>