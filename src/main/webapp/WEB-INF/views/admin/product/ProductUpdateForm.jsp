<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 수정</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/etc/admin_form.css">
</head>
<body>
<div>
    <%@ include file="../../hamburger_menu.jsp" %>
    <h2>상품 수정</h2>
    <form action="ProductUpdate" name="productUpdateForm" method="post" enctype="multipart/form-data">
        <input type="hidden" name="p_no" value="${ProductUpdate.pno}">
        <input type="hidden" name="o_no" value="${ProductUpdate.option[0].o_no}">

        <div>
            <label>상품 번호 :</label>
            <span>${ProductUpdate.pno}</span>
        </div>
        <div>
            <label>상품 명 :</label>
            <input type="text" name="p_title" value="${ProductUpdate.ptitle}" readonly>
        </div>
        <div>
            <label>상품 브랜드 :</label>
            <input type="text" name="p_brand" value="${ProductUpdate.pbrand}" required>
        </div>
        <div>
            <label>상품 카테고리 :</label>
            <input type="text" name="p_category" value="${ProductUpdate.pcategory}" required>
        </div>
        <div>
            <label>상품 펫 타입 :</label>
            <input type="text" name="p_type" value="${ProductUpdate.ptype}" readonly>
        </div>

        <hr>

        <div>
            <label>기본 상품 여부 :</label>
            <input type="radio" name="o_default" value="Y" ${ProductUpdate.option[0].o_default eq 'Y' ? 'checked' : ''}> Y
            <input type="radio" name="o_default" value="N" ${ProductUpdate.option[0].o_default eq 'N' ? 'checked' : ''}> N
        </div>
        <div>
            <label>상품 정가 :</label>
            <input type="number" name="o_origin_price" value="${ProductUpdate.option[0].o_origin_price}" required>
        </div>
        <div>
            <label>상품 판매가 :</label>
            <input type="number" name="o_price" value="${ProductUpdate.option[0].o_price}" required>
        </div>
        <div>
            <label>상품 수량 :</label>
            <input type="number" name="o_quantity" value="${ProductUpdate.option[0].o_quantity}">
        </div>
        <div>
            <label>사이즈 / 규격 :</label>
            <input type="text" name="o_type_size" value="${ProductUpdate.option[0].o_type_size}">
        </div>
        <div>
            <label>색상 :</label>
            <input type="text" name="o_color" value="${ProductUpdate.option[0].o_color}">
        </div>

        <div>
		    <label>상품 메인 이미지 :</label>
		    <input type="hidden" name="existing_o_img" value="${ProductUpdate.option[0].o_main_img}">
		    <input type="file" name="o_img">
		    
		    <c:if test="${not empty ProductUpdate.option[0].o_main_img}">
		        <div class="current-main-img-wrap">
		            <img src="${pageContext.request.contextPath}/images/products/main/${ProductUpdate.option[0].o_main_img}" 
		                 alt="메인이미지" class="detail-img-thumb">
		            <span class="detail-img-name">현재 파일: <strong>${ProductUpdate.option[0].o_main_img}</strong></span>
		        </div>
		    </c:if>
		</div>

        <hr>

        <div>
            <label>상품 상세 설명 :</label>
            <textarea rows="5" cols="80" name="p_content">${ProductUpdate.pcontent}</textarea>
        </div>

        <!-- 상세 이미지 관리 영역 -->
        <div>
            <label>등록된 상세 이미지 관리 :</label>
            <c:if test="${not empty ProductUpdate.detailImages}">
                <p class="detail-img-notice">※ 삭제할 이미지를 체크한 후 [상품수정]을 누르면 삭제됩니다.</p>
                <ul class="detail-img-list">
                    <c:forEach var="detailImg" items="${ProductUpdate.detailImages}">
                        <li class="detail-img-item">
                            <img src="${pageContext.request.contextPath}/images/products/info/${detailImg.img_url}" 
                                 alt="상세이미지" class="detail-img-thumb">
                            <span class="detail-img-name">${detailImg.img_url}</span>
                            <label class="btn-delete-check">
                                <input type="checkbox" name="delete_img_nos" value="${detailImg.img_no}"> 삭제
                            </label>
                        </li>
                    </c:forEach>
                </ul>
            </c:if>
        </div>

        <div>
            <label>추가 상세 이미지 :</label>
            <input type="file" name="img_urls" multiple>
        </div>

        <div class="form-btn-group">
            <input type="submit" value="상품수정">
            <input type="button" value="취소" onclick="history.back()"> 
        </div>
    </form>
</div>
</body>
</html>