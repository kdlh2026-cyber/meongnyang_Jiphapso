<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 - 관심상품 관리</title>
    <link rel="stylesheet" href="/css/favorite/adminList.css">
</head>
<body>
<h3>관심상품 관리</h3>

<table class="admin-table">
    <thead>
    <tr>
        <th>번호</th><th>상품이미지</th><th>상품명</th><th>가격</th><th>회원번호</th><th>찜한일시</th><th>관리</th>
    </tr>
    </thead>
    <tbody>
    <c:choose>
        <c:when test="${empty favoriteList}">
            <tr><td colspan="7">등록된 관심상품이 없어요.</td></tr>
        </c:when>
        <c:otherwise>
            <c:forEach var="favorite" items="${favoriteList}">
                <tr id="row-${favorite.faNo}">
                    <td>${favorite.faNo}</td>
                    <td><img src="${favorite.pMainImg}" alt="${favorite.pName}" class="thumb"></td>
                    <td>${favorite.pName}</td>
                    <td><fmt:formatNumber value="${favorite.oPrice}" pattern="#,##0" />원</td>
                    <td>${favorite.mNo}</td>
                    <td><fmt:formatDate value="${favorite.faAt}" pattern="yyyy.MM.dd HH:mm" /></td>
                    <td>
                        <button type="button" class="btn-sm btn-danger" onclick="deleteFavorite(${favorite.faNo})">삭제</button>
                    </td>
                </tr>
            </c:forEach>
        </c:otherwise>
    </c:choose>
    </tbody>
</table>

<script>
    // 관심상품 강제 삭제 - DELETE /admin/favorite/{faNo}
    function deleteFavorite(faNo) {
        if (!confirm('해당 관심상품을 삭제할까요?')) return;

        fetch('/admin/favorite/' + faNo, { method: 'DELETE' })
        .then(res => res.json())
        .then(result => {
            if (result.success) {
                document.getElementById('row-' + faNo).remove();
            } else {
                alert(result.message || '삭제에 실패했어요.');
            }
        })
        .catch(() => alert('처리 중 오류가 발생했어요.'));
    }
</script>
</body>
</html>
