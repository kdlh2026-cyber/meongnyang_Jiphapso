<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 - 주문상세</title>
    <link rel="stylesheet" href="/css/order/adminDetail.css">
</head>
<body>
<h3>주문상세 (관리자)</h3>

<table class="info-table">
    <tr><th>주문번호</th><td>${order.orNo}</td></tr>
    <tr><th>주문일시</th><td><fmt:formatDate value="${order.orAt}" pattern="yyyy.MM.dd HH:mm" /></td></tr>
    <tr><th>받는분</th><td>${order.orName}</td></tr>
    <tr><th>연락처</th><td>${order.orPhone}</td></tr>
    <tr><th>주소</th><td>${order.orAddress} ${order.orAddrdetail}</td></tr>
    <tr><th>주문메모</th><td>${order.orMemo}</td></tr>
    <tr><th>결제수단</th><td>${order.orMethod}</td></tr>
    <tr><th>수량</th><td>${order.orQty}개</td></tr>
    <tr>
        <th>주문상태</th>
        <td>
            <c:set var="statusCodes" value="${fn:split('PAYMENT_PENDING,PAID,PREPARING,SHIPPING,DELIVERED,CONFIRMED,CANCELED', ',')}" />
            <c:set var="statusLabels" value="${fn:split('결제 대기 중,결제 완료,상품 준비 중,배송 중,배송 완료,구매 확정,주문 취소', ',')}" />
            <select id="orStatus">
                <c:forEach var="code" items="${statusCodes}" varStatus="loop">
                    <option value="${code}" ${order.orStatus == code ? 'selected' : ''}>${statusLabels[loop.index]}</option>
                </c:forEach>
            </select>
        </td>
    </tr>
</table>

<!-- TODO: 주문상세(od_detail_no) 목록 / 결제정보 연동 -->

<div class="btn-group">
    <a class="btn" href="/admin/order">목록으로</a>
    <button type="button" class="btn btn-primary" onclick="changeStatus()">상태 저장</button>
    <button type="button" class="btn btn-danger" onclick="deleteOrder()">삭제</button>
</div>

<script>
    const orNo = ${order.orNo};

    function changeStatus() {
        const orStatus = document.getElementById('orStatus').value;

        fetch('/admin/order/' + orNo + '/status', {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ orStatus: orStatus })
        })
        .then(res => res.json())
        .then(result => {
            if (result.success) {
                alert('주문 상태가 변경됐어요.');
            } else {
                alert(result.message || '상태 변경에 실패했어요.');
            }
        })
        .catch(() => alert('처리 중 오류가 발생했어요.'));
    }

    function deleteOrder() {
        if (!confirm('해당 주문을 삭제할까요?')) return;

        fetch('/admin/order/' + orNo, { method: 'DELETE' })
        .then(res => res.json())
        .then(result => {
            if (result.success) {
                alert('삭제됐어요.');
                location.href = '/admin/order';
            } else {
                alert(result.message || '삭제에 실패했어요.');
            }
        })
        .catch(() => alert('처리 중 오류가 발생했어요.'));
    }
</script>
</body>
</html>
