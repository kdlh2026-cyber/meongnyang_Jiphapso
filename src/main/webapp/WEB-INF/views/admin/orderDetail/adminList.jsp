<%-- ============================================= --%>
<%-- admin/orderDetail/adminList.jsp --%>
<%-- ============================================= --%>
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

<!-- 주문상태 필터 탭 : 전체 + 상태별 버튼 -->
<div class="ord-tabs" id="ordTabs">
    <button type="button" class="ord-tab active" data-status="ALL" onclick="filterByStatus('ALL', this)">전체</button>
    <c:forEach var="code" items="${statusCodes}" varStatus="loop">
        <button type="button" class="ord-tab" data-status="${code}" onclick="filterByStatus('${code}', this)">${statusLabels[loop.index]}</button>
    </c:forEach>
</div>

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
    <tbody id="ordTbody">
    <c:choose>
        <c:when test="${empty orderDetailList}">
            <tr><td colspan="11">등록된 주문상세가 없어요.</td></tr>
        </c:when>
        <c:otherwise>
            <c:forEach var="detail" items="${orderDetailList}">
                <tr id="row-${detail.odDetailNo}" class="ord-row" data-status="${detail.orStatus}">
                    <td>${detail.odDetailNo}</td>
                    <td><img src="${pageContext.request.contextPath}/images/products/main/${detail.PMainImg}" alt="${detail.odProductName}" class="thumb"></td>
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
            <tr id="ordNoMatch" class="ord-no-match" style="display:none;">
                <td colspan="11">해당 상태의 주문상세가 없어요.</td>
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