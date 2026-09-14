<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 - 주문상세</title>
    <link rel="stylesheet" href="/css/order/adminDetail.css">
</head>
<body>

<div class="od-wrap">

    <div class="od-header">
        <h3 class="od-title">주문상세 (관리자)<span class="od-badge">#${order.orNo}</span></h3>
    </div>

    <!-- 주문 정보 -->
    <div class="od-card">
        <div class="od-card-title">주문 정보</div>
        <table class="info-table">
            <tr><th>주문번호</th><td>${order.orNo}</td></tr>
            <tr><th>주문일시</th><td><fmt:formatDate value="${order.orAt}" pattern="yyyy.MM.dd HH:mm" /></td></tr>
            <tr><th>받는분</th><td>${order.orName}</td></tr>
            <tr><th>연락처</th><td>${order.orPhone}</td></tr>
            <tr><th>주소</th><td>${order.orAddress} ${order.orAddrdetail}</td></tr>
            <tr><th>주문메모</th><td>${order.orMemo}</td></tr>
            <tr><th>결제수단</th><td>${order.orMethod}</td></tr>
            <tr><th>쇼핑백 수량</th><td>${order.orQty}개</td></tr>
            <tr>
                <th>주문상태</th>
                <td>

                    <c:set var="statusCodes" value="${fn:split('PAYMENT_PENDING,PAID,PREPARING,SHIPPING,DELIVERED,CONFIRMED', ',')}" />
                    <c:set var="statusLabels" value="${fn:split('결제 대기 중,결제 완료,상품 준비 중,배송 중,배송 완료,구매 확정', ',')}" />
                    <select id="orStatus">
                        <c:forEach var="code" items="${statusCodes}" varStatus="loop">
                            <option value="${code}" ${order.orStatus == code ? 'selected' : ''}>${statusLabels[loop.index]}</option>
                        </c:forEach>
                        <c:if test="${order.orStatus == 'CANCELED'}">
                            <option value="CANCELED" selected>주문 취소</option>
                        </c:if>
                    </select>
                    <c:if test="${order.orStatus != 'CANCELED'}">
                        <p style="margin:6px 0 0; font-size:12px; color:#888;">
                            주문 취소는 <a href="/orderCancel/admin/list">취소/반품 관리</a>에서 처리해주세요.
                        </p>
                    </c:if>
                </td>
            </tr>
        </table>
    </div>

    <!-- 주문 상품 -->
    <div class="od-card">
        <div class="od-card-title">주문 상품</div>
        <c:choose>
            <c:when test="${empty orderDetailList}">
                <div class="od-empty">주문상품 정보가 없어요.</div>
            </c:when>
            <c:otherwise>
                <c:set var="totalAmt" value="${0}" />
                <c:forEach var="item" items="${orderDetailList}">
                    <c:set var="totalAmt" value="${totalAmt + item.odAmount}" />
                    <div class="od-product-row">
                        <img src="${pageContext.request.contextPath}/images/products/main/${item.PMainImg}" alt="${item.odProductName}">
                        <div class="od-product-info">
                            <div class="od-product-name">${item.odProductName}</div>
                            <c:if test="${not empty item.odOptionName}">
                                <span class="od-product-opt">${item.odOptionName}</span>
                            </c:if>
                            <div class="od-product-qty">
                                <fmt:formatNumber value="${item.odPrice}" pattern="#,##0" />원 · 수량 ${item.odQuantity}개
                            </div>
                        </div>
                        <div class="od-product-price">
                            <span class="od-product-amt"><fmt:formatNumber value="${item.odAmount}" pattern="#,##0" />원</span>
                        </div>
                    </div>
                </c:forEach>
                <div class="od-total-row">
                    <span>상품 합계</span>
                    <strong><fmt:formatNumber value="${totalAmt}" pattern="#,##0" />원</strong>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="btn-group">
        <a class="btn" href="/admin/order">목록으로</a>
        <button type="button" class="btn btn-primary" onclick="changeStatus()">상태 저장</button>
        <button type="button" class="btn btn-danger" onclick="deleteOrder()">삭제</button>
    </div>

</div>

<script>
    const orNo = ${order.orNo};

    function changeStatus() {
        const orStatus = document.getElementById('orStatus').value;

        // CANCELED는 이제 이 드롭다운에 없지만, 혹시 모를 우회 호출까지 클라이언트단에서도 한 번 더 막아둠
        if (orStatus === 'CANCELED') {
            alert('주문 취소는 [취소/반품 관리] 메뉴에서 처리해주세요.');
            return;
        }

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