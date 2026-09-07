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

<h3>주문내역</h3>

<div class="status-tabs">
    <a href="/member/order/list" class="${empty param.status ? 'active' : ''}">전체</a>
    <a href="/member/order/list?status=PAYMENT_PENDING" class="${param.status == 'PAYMENT_PENDING' ? 'active' : ''}">결제대기</a>
    <a href="/member/order/list?status=PAID" class="${param.status == 'PAID' ? 'active' : ''}">결제완료</a>
    <a href="/member/order/list?status=SHIPPING" class="${param.status == 'SHIPPING' ? 'active' : ''}">배송중</a>
    <a href="/member/order/list?status=DELIVERED" class="${param.status == 'DELIVERED' ? 'active' : ''}">배송완료</a>
    <a href="/member/order/list?status=CANCELED" class="${param.status == 'CANCELED' ? 'active' : ''}"> 취소</a>
</div>

<c:choose>
    <c:when test="${empty orderList}">
        <div class="empty">📦 주문 내역이 없어요.</div>
    </c:when>

    <c:otherwise>
        <c:forEach var="order" items="${orderList}">
            <div class="order-card">

                <div class="order-top">
                    <span>주문번호 : ${order.orNo}</span>
                    <span>
                        <fmt:formatDate value="${order.orAt}" pattern="yyyy.MM.dd HH:mm"/>
                    </span>
                </div>

                <div class="order-mid">
                    <div>
                        <span class="status-badge">${order.orStatus}</span>
                        <span class="qty">수량 ${order.orQty}개</span>
                    </div>

                    <div>${order.orMethod}</div>
                </div>

                <div class="order-actions">
                    <a class="btn-sm" href="/member/order/${order.orNo}">
                        상세보기
                    </a>

                    <c:if test="${order.orStatus == 'PAYMENT_PENDING' || order.orStatus == 'PAID'}">
                        <button type="button"
                                class="btn-sm"
                                onclick="location.href='/member/order/${order.orNo}'">
                            주문취소
                        </button>
                    </c:if>
                </div>

            </div>
        </c:forEach>
    </c:otherwise>
</c:choose>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>