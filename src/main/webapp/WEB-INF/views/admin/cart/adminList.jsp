<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>장바구니 관리</title>
    <style>
        body { font-family: sans-serif; max-width: 1100px; margin: 0 auto; padding: 20px; }
        h2 { margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; font-size: 14px; }
        th, td { padding: 10px 8px; border-bottom: 1px solid #eee; text-align: center; }
        th { background: #fafafa; color: #555; font-weight: 600; }
        td.name { text-align: left; }
        td img { width: 44px; height: 44px; object-fit: cover; border-radius: 6px; vertical-align: middle; margin-right: 8px; background: #f2f2f2; }
        .badge { display: inline-block; padding: 2px 8px; border-radius: 10px; font-size: 12px; }
        .badge.member { background: #e8f0fe; color: #1a73e8; }
        .badge.guest { background: #fef3e8; color: #e8710a; }
        .delete-btn { border: 1px solid #ddd; background: #fff; color: #d33; border-radius: 6px; padding: 5px 10px; cursor: pointer; font-size: 13px; }
        .empty { text-align: center; color: #999; padding: 60px 0; }
        .count { color: #777; font-size: 13px; margin-bottom: 12px; }
    </style>
</head>
<body>

<h2>장바구니 관리</h2>

<c:choose>

    <c:when test="${empty cartList}">
        <div class="empty">등록된 장바구니 데이터가 없어요.</div>
    </c:when>

    <c:otherwise>

        <div class="count">전체 <strong>${cartList.size()}</strong>건</div>

        <table>
            <thead>
                <tr>
                    <th>번호</th>
                    <th>구분</th>
                    <th>상품</th>
                    <th>옵션</th>
                    <th>단가</th>
                    <th>수량</th>
                    <th>합계</th>
                    <th>쇼핑백</th>
                    <th>담은일시</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody id="cartTableBody">
                <c:forEach var="cart" items="${cartList}">
                    <tr data-cano="${cart.caNo}">
                        <td>${cart.caNo}</td>
                        <td>
                            <c:choose>
                                <c:when test="${cart.mNo != null}">
                                    <span class="badge member">회원 #${cart.mNo}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge guest">비회원</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="name">
                            <img src="${cart.pMainImg}" alt="${cart.pName}">${cart.pName}
                        </td>
                        <td>${cart.oName}</td>
                        <td><fmt:formatNumber value="${cart.oPrice}" pattern="#,##0" />원</td>
                        <td>${cart.caQuantity}</td>
                        <td><fmt:formatNumber value="${cart.oPrice * cart.caQuantity}" pattern="#,##0" />원</td>
                        <td>
                            <c:choose>
                                <c:when test="${cart.caYn == 'Y'}">Y (${cart.caQty}개)</c:when>
                                <c:otherwise>N</c:otherwise>
                            </c:choose>
                        </td>
                        <td><fmt:formatDate value="${cart.caAt}" pattern="yyyy-MM-dd HH:mm" /></td>
                        <td>
                            <button type="button" class="delete-btn" onclick="deleteCart(${cart.caNo})">삭제</button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <div class="empty" id="emptyState" style="display:none;">등록된 장바구니 데이터가 없어요.</div>

    </c:otherwise>

</c:choose>

<script>
    function deleteCart(caNo) {
        if (!confirm(caNo + '번 장바구니 항목을 삭제할까요?')) return;

        fetch('/admin/cart/' + caNo, { method: 'DELETE' })
            .then(res => res.json())
            .then(res => {
                if (res.success) {
                    document.querySelector('tr[data-cano="' + caNo + '"]')?.remove();

                    if (document.querySelectorAll('#cartTableBody tr').length === 0) {
                        document.querySelector('table').style.display = 'none';
                        document.querySelector('.count').style.display = 'none';
                        document.getElementById('emptyState').style.display = 'block';
                    }
                } else {
                    alert(res.message || '삭제에 실패했어요.');
                }
            });
    }
</script>

</body>
</html>