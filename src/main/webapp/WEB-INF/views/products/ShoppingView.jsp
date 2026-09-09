<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<style>
.image {
		width: 80%;
		height: auto;
		max-width: 180px;
	}
</style>
<meta charset="UTF-8">
<title>${ShoppingViewList.ptitle} </title>
</head>
<body>
<div>
	<div>
		<div>
			<img alt="강아지 외장칩" src="${pageContext.request.contextPath}/images/products/main/${ShoppingViewList.omainimg}">
		</div>
		<div>
			<h1>${ShoppingViewList.ptitle}</h1>
			<div>판매가 ${ShoppingViewList.oprice}</div>
			<c:if test="${not empty view.otypesize}">
			<div>
				<div>
					선택
				</div>
				<div>
					<button></button>
            	</div>
			</div>
			</c:if>
			<div class="image">
				${ShoppingViewList.imgcontent}
			</div>
		</div>
		<div>
			<div>
				<a href="#">상품설명</a>
				<a href="#">리뷰</a>
			</div>
			<div>
				
			</div>
		</div>
	</div>
</div>
</body>

</html>