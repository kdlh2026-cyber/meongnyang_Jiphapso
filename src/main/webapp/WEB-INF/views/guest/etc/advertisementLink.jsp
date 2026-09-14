<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>광고&#128062;링크</title>
<style>
  html body {
      background-color: #ffffff !important;
      margin: 0;
  }
  .adv-wrap {
      max-width: 800px;
      margin: 0 auto;
      text-align: center;
  }
  .adv img {
      display: block;
      width: 100%;
      height: auto;
  }
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
	<h3>광고</h3>
	<br>
	<div class="adv-wrap">
		<img src="/images/main/advertisement2.png">
	</div>
	<br>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>