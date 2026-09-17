<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관심상품</title>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
<link rel="stylesheet" id="favoriteListCss" href="${pageContext.request.contextPath}/css/favorite/list.css">
</head>
<body>
<%@ include file="/WEB-INF/views/favorite/listContent.jsp" %>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>