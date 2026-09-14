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

<!-- 주문상태 필터 탭 -->
<div class="ord-tabs" id="ordTabs">
    <button type="button" class="ord-tab active" data-status="ALL" onclick="filterByStatus('ALL', this)">전체</button>
    <c:forEach var="code" items="${statusCodes}" varStatus="loop">
        <button type="button" class="ord-tab" data-status="${code}" onclick="filterByStatus('${code}', this)">${statusLabels[loop.index]}</button>
    </c:forEach>
</div>

<table class="admin-table">
    <thead>
    <tr>
        <th>주문번호</th><th>주문일시</th><th>주문자</th><th>연락처</th>
        <th>수량</th><th>결제수단</th><th>상태</th><th>관리</th>
    </tr>
    </thead>
    <tbody id="ordTbody">
    <c:choose>
        <c:when test="${empty orderList}">
            <tr><td colspan="8">등록된 주문이 없어요.</td></tr>
        </c:when>
        <c:otherwise>
            <c:forEach var="order" items="${orderList}">
                <tr id="row-${order.orNo}" class="ord-row" data-status="${order.orStatus}">
                    <td>${order.orNo}</td>
                    <td><fmt:formatDate value="${order.orAt}" pattern="yyyy.MM.dd HH:mm" /></td>
                    <td>${order.orName}</td>
                    <td>${order.orPhone}</td>
                    <td>${order.productQty}개</td>
                    <td>${order.orMethod}</td>
                    <td>
                        <span class="order-badge badge-${fn:toLowerCase(order.orStatus)}">
                            <c:forEach var="code" items="${statusCodes}" varStatus="loop">
                                <c:if test="${order.orStatus == code}">${statusLabels[loop.index]}</c:if>
                            </c:forEach>
                        </span>
                    </td>
                    <td>
                        <a class="btn-sm" href="/admin/order/${order.orNo}">상세</a>
                        <button type="button" class="btn-sm btn-danger" onclick="deleteOrder(${order.orNo})">삭제</button>
                    </td>
                </tr>
            </c:forEach>
            <tr id="ordNoMatch" class="ord-no-match" style="display:none;">
                <td colspan="8">해당 상태의 주문이 없어요.</td>
            </tr>
        </c:otherwise>
    </c:choose>
    </tbody>
</table>

<script>
    // 상태 탭 클릭 시 클라이언트에서 행 필터링 (서버 재조회 없음)
    function filterByStatus(status, btnEl) {
        var tabs = document.querySelectorAll('#ordTabs .ord-tab');
        tabs.forEach(function (t) { t.classList.remove('active'); });
        btnEl.classList.add('active');

        var rows = document.querySelectorAll('#ordTbody .ord-row');
        var visibleCount = 0;

        rows.forEach(function (row) {
            var match = (status === 'ALL') || (row.dataset.status === status);
            row.style.display = match ? '' : 'none';
            if (match) visibleCount++;
        });

        var noMatch = document.getElementById('ordNoMatch');
        if (noMatch) {
            noMatch.style.display = (visibleCount === 0) ? '' : 'none';
        }
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