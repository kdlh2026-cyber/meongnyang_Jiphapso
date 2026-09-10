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
                            <%-- 상태값은 detail.jsp랑 동일한 한글 라벨 + status-${orStatus} 클래스로 색상 매핑 --%>
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
                            <%-- 주문취소는 상세페이지의 취소/반품/교환 모달을 그대로 사용.
                                 ?cancel=1 을 붙여서 넘어가면 detail.jsp 쪽에서 이 파라미터를 보고
                                 (상품이 1개면) 취소 모달을 자동으로 열어줌 --%>
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
</body>
</html>
