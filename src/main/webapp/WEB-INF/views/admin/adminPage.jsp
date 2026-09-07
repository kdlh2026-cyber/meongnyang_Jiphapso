<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>

<!-- 아코디언 ui -->

	<ul>
   <li>
      <a href="#">관리자 정보</a>
   </li>
   <li>
   	  <a href="/admin/member/memberList">회원 정보 관리</a> <!-- 회원 개인 포인트, 개인 쿠폰도 여기서 관리 -->
   </li>
   <li>
      <a href="#">상품 관리</a>
   </li>
   <li>
      <a href="#">주문 관리</a>
   </li>
   <li>
      <a href="#">커뮤니티 관리</a>
   </li>
   <li>
      <a href="#">쿠폰 관리</a>
   </li>
   <li>
      <a href="#">그 외</a> <!-- 회사소개 이용약관 개인정보처리방침 등 -->
   </li>
</ul>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>