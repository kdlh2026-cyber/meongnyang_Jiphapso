<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 - 주문관리</title>
    <link rel="stylesheet" href="/css/order/adminList.css">
</head>
<body>
<h3>주문관리</h3>

<c:set var="statusCodes" value="${fn:split('PAYMENT_PENDING,PAID,PREPARING,SHIPPING,DELIVERED,CONFIRMED,CANCELED', ',')}" />
<c:set var="statusLabels" value="${fn:split('결제 대기 중,결제 완료,상품 준비 중,배송 중,배송 완료,구매 확정,주문 취소', ',')}" />

<table class="admin-table">
    <thead>
    <tr>
        <th>주문번호</th><th>주문일시</th><th>주문자</th><th>연락처</th>
        <th>수량</th><th>결제수단</th><th>상태</th><th>관리</th>
    </tr>
    </thead>
    <tbody>
    <c:choose>
        <c:when test="${empty orderList}">
            <tr><td colspan="8">등록된 주문이 없어요.</td></tr>
        </c:when>
        <c:otherwise>
            <c:forEach var="order" items="${orderList}">
                <tr id="row-${order.orNo}">
                    <td>${order.orNo}</td>
                    <td><fmt:formatDate value="${order.orAt}" pattern="yyyy.MM.dd HH:mm" /></td>
                    <td>${order.orName}</td>
                    <td>${order.orPhone}</td>
                    <td>${order.orQty}</td>
                    <td>${order.orMethod}</td>
                    <td>
                        <select class="status-select" onchange="changeStatus(${order.orNo}, this.value)">
                            <c:forEach var="code" items="${statusCodes}" varStatus="loop">
                                <option value="${code}" ${order.orStatus == code ? 'selected' : ''}>${statusLabels[loop.index]}</option>
                            </c:forEach>
                        </select>
                    </td>
                    <td>
                        <a class="btn-sm" href="/admin/order/${order.orNo}">상세</a>
                        <button type="button" class="btn-sm btn-danger" onclick="deleteOrder(${order.orNo})">삭제</button>
                    </td>
                </tr>
            </c:forEach>
        </c:otherwise>
    </c:choose>
    </tbody>
</table>

<script>
    // 주문상태 변경 - PUT /admin/order/{orNo}/status
    function changeStatus(orNo, orStatus) {
        fetch('/admin/order/' + orNo + '/status', {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ orStatus: orStatus })
        })
        .then(res => res.json())
        .then(result => {
            if (!result.success) alert(result.message || '상태 변경에 실패했어요.');
        })
        .catch(() => alert('처리 중 오류가 발생했어요.'));
    }

    // 주문 삭제 - DELETE /admin/order/{orNo}
    function deleteOrder(orNo) {
        if (!confirm('해당 주문을 삭제할까요?')) return;

        fetch('/admin/order/' + orNo, { method: 'DELETE' })
        .then(res => res.json())
        .then(result => {
            if (result.success) {
                document.getElementById('row-' + orNo).remove();
            } else {
                alert(result.message || '삭제에 실패했어요.');
            }
        })
        .catch(() => alert('처리 중 오류가 발생했어요.'));
    }
</script>
</body>
</html>
