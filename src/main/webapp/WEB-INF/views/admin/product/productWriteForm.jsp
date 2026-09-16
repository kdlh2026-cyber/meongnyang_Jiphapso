<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 등록</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/etc/admin_form.css">
</head>
<body>
<div>
<%@ include file="../../hamburger_menu.jsp" %>
	<h2>상품 등록</h2>
	<form action="productWrite" name="productWriteForm" method="post" enctype="multipart/form-data">
		<div>
			<label>상품 명 :</label>
			<input type="text" name="p_title" required>
		</div>
		<div>
			<label>상품 브랜드 :</label>
			<input type="text" name="p_brand" required>
		</div>
		<div>
			<label>상품 카테고리 :</label>
			<input type="text" name="p_category" required>
		</div>
		<div>
			<label>상품 펫 타입 :</label>
			<input type="text" name="p_type" required>
		</div>

		<hr>

		<div>
			<label>기본 상품 여부 :</label>
			<div>
				<input type="radio" name="o_default" value="Y" checked> Y
				<input type="radio" name="o_default" value="N"> N
			</div>
		</div>
		<div>
			<label>상품 정가 :</label>
			<input type="number" name="o_origin_price">
		</div>
		<div>
			<label>상품 판매가 :</label>
			<input type="number" name="o_price" required>
		</div>
		<div>
			<label>상품 수량 :</label>
			<input type="number" name="o_quantity">
		</div>
		<div>
			<label>상품 타입/사이즈 :</label>
			<input type="text" name="o_type_size">
		</div>
		<div>
			<label>상품 컬러 :</label>
			<input type="text" name="o_color">
		</div>
		<div>
			<label>상품 메인 이미지 :</label>
			<input type="file" name="o_img">
		</div>

		<hr>

		<div>
			<label>상품 상세 내용 :</label>
			<textarea rows="5" cols="80" name="p_content"></textarea>
		</div>
		<div>
			<label>상품 상세 이미지 :</label>
			<input type="file" name="img_urls" multiple>
		</div>
		<div class="form-btn-group">
			<input type="submit" value="상품등록">
			<input type="button" value="취소" onclick="history.back()"> 
		</div>
	</form>
</div>
</body>
</html>