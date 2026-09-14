<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>주문내역</title>
    <%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
    <link rel="stylesheet" href="/css/order/list.css">
</head>
<body>

<div class="ol-wrap">

    <h3 class="ol-title">주문내역</h3>

    <div class="status-tabs">
        <a href="/member/order/list" class="${empty param.status ? 'active' : ''}">전체</a>
        <a href="/member/order/list?status=PAYMENT_PENDING" class="${param.status == 'PAYMENT_PENDING' ? 'active' : ''}">결제대기</a>
        <a href="/member/order/list?status=PAID" class="${param.status == 'PAID' ? 'active' : ''}">결제완료</a>
        <a href="/member/order/list?status=SHIPPING" class="${param.status == 'SHIPPING' ? 'active' : ''}">배송중</a>
        <a href="/member/order/list?status=DELIVERED" class="${param.status == 'DELIVERED' ? 'active' : ''}">배송완료</a>
        <a href="/orderCancel/list">취소</a>
    </div>

    <c:choose>
        <c:when test="${empty orderList}">
            <div class="empty">📦 주문 내역이 없어요.</div>
        </c:when>

        <c:otherwise>
            <c:forEach var="order" items="${orderList}">
                <div class="order-card">

                    <div class="order-top">
                        <span class="order-no">주문번호 : ${order.orNo}</span>
                        <span class="order-date">
                            <fmt:formatDate value="${order.orAt}" pattern="yyyy.MM.dd HH:mm"/>
                        </span>
                    </div>

                    <div class="order-mid">
                        <div class="order-mid-left">
                            <span class="status-badge status-${order.orStatus}">
                                <c:choose>
                                    <c:when test="${order.orStatus == 'PAYMENT_PENDING'}">결제대기</c:when>
                                    <c:when test="${order.orStatus == 'PAID'}">결제완료</c:when>
                                    <c:when test="${order.orStatus == 'SHIPPING'}">배송중</c:when>
                                    <c:when test="${order.orStatus == 'DELIVERED'}">배송완료</c:when>
                                    <c:when test="${order.orStatus == 'CANCELED'}">취소완료</c:when>
                                    <c:otherwise>${order.orStatus}</c:otherwise>
                                </c:choose>
                            </span>

                            <span class="qty">상품 ${order.productQty}개</span>
                            <c:if test="${order.orYn == 'Y' && order.orQty > 0}">
                                <span class="qty qty-bag">(쇼핑백 ${order.orQty}개 포함)</span>
                            </c:if>
                        </div>

                        <div class="order-method">${order.orMethod}</div>
                    </div>

                    <div class="order-actions">
                        <a class="btn-sm" href="/member/order/${order.orNo}">
                            상세보기
                        </a>

                        <c:if test="${order.orStatus == 'PAYMENT_PENDING' || order.orStatus == 'PAID'}">
                            <button type="button"
                                    class="btn-sm btn-sm-outline"
                                    onclick="location.href='/member/order/${order.orNo}?cancel=1'">
                                주문취소
                            </button>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>

</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
<script>
//document 전체에 이벤트를 걸어 동적으로 생성되거나 로드된 요소도 완벽하게 잡아냅니다.
document.addEventListener('click', function(event) {
    // 클릭된 요소가 'btn-review-toggle' 클래스를 가지고 있는지 확인 (버튼 안의 span 등을 눌렀을 수도 있으므로 .closest 사용)
    const reviewBtn = event.target.closest('.btn-review-toggle');
    
    if (reviewBtn) {
        const orNo = reviewBtn.getAttribute('data-orno');
        const reviewBox = document.getElementById('review-box-' + orNo);
        
        if (reviewBox) {
            if (reviewBox.style.display === 'none' || reviewBox.style.display === '') {
                reviewBox.style.display = 'block';
            } else {
                reviewBox.style.display = 'none';
            }
        } else {
            console.log('리뷰 박스를 찾지 못했습니다. ID: review-box-' + orNo);
        }
    }
});
</script>
</body>
</html>
