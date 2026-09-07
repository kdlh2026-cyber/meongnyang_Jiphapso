<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>장바구니</title>
    <%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
    <link rel="stylesheet" href="/css/cart/cart_list.css">
</head>
<body>
<h3>장바구니</h3>

<c:choose>

    <%-- 장바구니가 비어있는 경우 --%>
    <c:when test="${empty cartList}">
        <div class="empty">🛒 장바구니가 비어있어요</div>
     	<a href="#" class="submit">쇼핑하러 가기</a>
    </c:when>

    <%-- 장바구니에 상품이 있는 경우 --%>
    <c:otherwise>

        <div id="cartContent">

            <div class="select-all">
                <input type="checkbox" id="checkAll" checked>
                <label for="checkAll">전체선택</label>
                <span class="delete-link" onclick="deleteSelected()">선택삭제</span>
            </div>

            <c:set var="totalAmount" value="${0}" />

            <c:forEach var="cart" items="${cartList}">
                <c:set var="lineAmount" value="${cart.oPrice * cart.caQuantity}" />
                <c:set var="totalAmount" value="${totalAmount + lineAmount}" />

                <div class="cart-item" data-cano="${cart.caNo}" data-price="${cart.oPrice}">
                    <input type="checkbox" class="item-check" value="${cart.caNo}" checked>

                    <img src="${cart.pMainImg}" alt="${cart.pName}">

                    <div class="info">
                        <div class="name">
                            ${cart.pName}
                            <c:if test="${not empty cart.oName}"> (${cart.oName})</c:if>
                        </div>
                        <div class="price">
                            <fmt:formatNumber value="${cart.oPrice}" pattern="#,##0" />원
                        </div>
                    </div>

                    <div class="qty-box">
                        <button type="button" onclick="changeQuantity(${cart.caNo}, -1)">-</button>
                        <span id="qty-${cart.caNo}" data-qty="${cart.caQuantity}">${cart.caQuantity}</span>
                        <button type="button" onclick="changeQuantity(${cart.caNo}, 1)">+</button>
                    </div>

                    <span class="delete-link" onclick="deleteCart(${cart.caNo})">삭제</span>
                </div>
            </c:forEach>

            <div class="summary">
                <span>합계</span>
                <span id="totalAmount"><fmt:formatNumber value="${totalAmount}" pattern="#,##0" />원</span>
            </div>

            <button class="checkout-btn" onclick="goCheckout()">결제하기</button>

        </div>

        <div class="empty" id="emptyState" style="display:none;">🛒 장바구니가 비어있어요.</div>

    </c:otherwise>

</c:choose>

<script>

    document.getElementById('checkAll')?.addEventListener('change', function () {
        document.querySelectorAll('.item-check').forEach(chk => chk.checked = this.checked);
    });

    function formatNumber(num) {
        return Math.round(num).toLocaleString('ko-KR');
    }

    function recalcTotal() {
        let total = 0;
        document.querySelectorAll('.cart-item').forEach(item => {
            const price = Number(item.dataset.price) || 0;
            const qtySpan = item.querySelector('span[id^="qty-"]');
            const qty = Number(qtySpan.dataset.qty) || 0;
            total += price * qty;
        });

        const totalEl = document.getElementById('totalAmount');
        if (totalEl) totalEl.textContent = formatNumber(total) + '원';

        if (document.querySelectorAll('.cart-item').length === 0) {
            document.getElementById('cartContent').style.display = 'none';
            document.getElementById('emptyState').style.display = 'block';
        }
    }

    function changeQuantity(caNo, diff) {
        const span = document.getElementById('qty-' + caNo);
        let quantity = Number(span.dataset.qty) + diff;
        if (quantity < 1) quantity = 1;

        fetch('/cart/' + caNo + '/quantity', {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ quantity: quantity })
        })
        .then(res => res.json())
        .then(res => {
            if (res.success) {
                span.dataset.qty = quantity;
                span.textContent = quantity;
                recalcTotal();
            } else {
                alert(res.message || '수량 변경에 실패했어요.');
            }
        });
    }

    function deleteCart(caNo) {
        if (!confirm('장바구니에서 삭제할까요?')) return;

        fetch('/cart/' + caNo, { method: 'DELETE' })
            .then(res => res.json())
            .then(res => {
                if (res.success) {
                    document.querySelector('.cart-item[data-cano="' + caNo + '"]')?.remove();
                    recalcTotal();
                } else {
                    alert(res.message || '삭제에 실패했어요.');
                }
            });
    }

    function deleteSelected() {
        const checked = Array.from(document.querySelectorAll('.item-check:checked'));
        const caNoList = checked.map(chk => Number(chk.value));

        if (caNoList.length === 0) {
            alert('삭제할 상품을 선택해주세요.');
            return;
        }
        if (!confirm(caNoList.length + '개 상품을 삭제할까요?')) return;

        fetch('/cart', {
            method: 'DELETE',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(caNoList)
        })
        .then(res => res.json())
        .then(res => {
            if (res.success) {
                checked.forEach(chk => chk.closest('.cart-item').remove());
                recalcTotal();
            } else {
                alert(res.message || '삭제에 실패했어요.');
            }
        });
    }

    function goCheckout() {
        const caNoList = Array.from(document.querySelectorAll('.item-check:checked'))
            .map(chk => chk.value);

        if (caNoList.length === 0) {
            alert('주문할 상품을 선택해주세요.');
            return;
        }
        location.href = '/member/order/checkout?caNo=' + caNoList.join(',');
    }
</script>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
