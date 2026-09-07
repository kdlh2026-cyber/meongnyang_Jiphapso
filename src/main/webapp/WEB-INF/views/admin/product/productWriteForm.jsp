<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 등록</title>
</head>
<body>
<div>
	<h2>상품 등록</h2>
	<form action="productWrite" name="productWriteForm" method="post" enctype="multipart/form-data">
	<div>
		상품 명 :
		<input type="text" name="p_title">
	</div>
	<div>
		상품 브랜드 :
		<input type="text" name="p_brand">
	</div>
	<div>
		상품 카테고리 :
		<input type="text" name="p_category">
	</div>
	<div>
		상품 펫 타입 :
		<input type="text" name="p_type">
	</div>
	<div>
		기본 상품 :
		<input type="radio" name="o_default" value="Y">
	</div>
	<div>
		상품 타입/사이즈 :
		<input type="text" name="o_type_size">
	</div>
	<div>
		상품 컬러 :
		<input type="text" name="o_color">
	</div>
	<div>
		상품 정가 :
		<input type="text" name="o_origin_price">
	</div>
	<div>
		상품 판매가 :
		<input type="text" name="o_price">
	</div>
	<div>
		상품 메인 이미지 :
		<input type="file" name="o_img">
	</div>
	<div>
		상품 수량 :
		<input type="text" name="o_quantity">
	</div>
	<div>
		상품 상세 내용 :
		<textarea rows="5" cols="80" name="img_content"></textarea>
	</div>
	<div>
		상품 상세 이미지 :
		<input type="file" name="img_urls" multiple>
	</div>
	<div>
		<input type="submit" value="상품등록">
		<input type="button" value="취소" onclick="history.back()"> 
	</div>
	</form>
</div>
</body>
</html>