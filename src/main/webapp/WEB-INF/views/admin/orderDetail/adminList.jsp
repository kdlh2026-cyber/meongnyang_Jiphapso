<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 - 주문상세 관리</title>
    <link rel="stylesheet" href="/css/orderDetail/adminList.css">
</head>
<body>
<h3>주문상세 관리</h3>
<c:set var="statusCodes" value="${fn:split('PAYMENT_PENDING,PAID,PREPARING,SHIPPING,DELIVERED,CONFIRMED,CANCELED', ',')}" />
<c:set var="statusLabels" value="${fn:split('결제 대기 중,결제 완료,상품 준비 중,배송 중,배송 완료,구매 확정,주문 취소', ',')}" />

<table class="admin-table">
    <thead>
    <tr>
        <th>번호</th>
        <th>상품이미지</th>
        <th>상품명</th>
        <th>옵션</th>
        <th>가격</th>
        <th>수량</th>
        <th>금액</th>
        <th>주문번호</th>
        <th>주문상태</th>
        <th>주문일시</th>
        <th>관리</th>
    </tr>
    </thead>
    <tbody>
    <c:choose>
        <c:when test="${empty orderDetailList}">
            <tr><td colspan="11">등록된 주문상세가 없어요.</td></tr>
        </c:when>
        <c:otherwise>
            <c:forEach var="detail" items="${orderDetailList}">
                <tr id="row-${detail.odDetailNo}">
                    <td>${detail.odDetailNo}</td>
                    <td><img src="${detail.pMainImg}" alt="${detail.odProductName}" class="thumb"></td>
                    <td>${detail.odProductName}</td>
                    <td>${detail.odOptionName}</td>
                    <td><fmt:formatNumber value="${detail.odPrice}" pattern="#,##0" />원</td>
                    <td>${detail.odQuantity}</td>
                    <td><fmt:formatNumber value="${detail.odAmount}" pattern="#,##0" />원</td>
                    <td><a href="/admin/order/${detail.orNo}">${detail.orNo}</a></td>
                    <td>
                        <c:forEach var="code" items="${statusCodes}" varStatus="loop">
                            <c:if test="${detail.orStatus == code}">${statusLabels[loop.index]}</c:if>
                        </c:forEach>
                    </td>
                    <td><fmt:formatDate value="${detail.odAt}" pattern="yyyy.MM.dd HH:mm" /></td>
                    <td>
                        <button type="button" class="btn-sm btn-danger" onclick="deleteOrderDetail(${detail.odDetailNo})">삭제</button>
                    </td>
                </tr>
            </c:forEach>
        </c:otherwise>
    </c:choose>
    </tbody>
</table>

<script>
    // 주문상세 강제 삭제 - DELETE /admin/order-detail/{odDetailNo}
    function deleteOrderDetail(odDetailNo) {
        if (!confirm('해당 주문상세를 삭제할까요?')) return;

        fetch('/admin/order-detail/' + odDetailNo, { method: 'DELETE' })
        .then(res => res.json())
        .then(result => {
            if (result.success) {
                document.getElementById('row-' + odDetailNo).remove();
            } else {
                alert(result.message || '삭제에 실패했어요.');
            }
        })
        .catch(() => alert('처리 중 오류가 발생했어요.'));
    }
</script>
</body>
</html>