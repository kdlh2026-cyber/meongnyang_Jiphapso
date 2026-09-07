<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>주문상세</title>
    <link rel="stylesheet" href="/css/order/detail.css">
    <%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<body>
<h3>주문상세</h3>
<c:set var="editable" value="${order.orStatus == 'PAYMENT_PENDING'}" />

<table class="info-table">
    <tr><th>주문번호</th><td>${order.orNo}</td></tr>
    <tr><th>주문일시</th><td><fmt:formatDate value="${order.orAt}" pattern="yyyy.MM.dd HH:mm" /></td></tr>
    <tr><th>주문상태</th><td><span class="status-badge">${order.orStatus}</span></td></tr>
    <tr><th>결제수단</th><td>${order.orMethod}</td></tr>
    <tr><th>수량</th><td>${order.orQty}개</td></tr>
    <tr>
        <th>받는분</th>
        <td><input type="text" id="orName" value="${order.orName}" ${editable ? '' : 'readonly'}></td>
    </tr>
    <tr>
        <th>연락처</th>
        <td><input type="text" id="orPhone" value="${order.orPhone}" ${editable ? '' : 'readonly'}></td>
    </tr>
    <tr>
        <th>주소</th>
        <td>
            <input type="text" id="orAddress" value="${order.orAddress}" readonly>
            <c:if test="${editable}">
                <button type="button" class="btn" onclick="searchAddress()">주소 검색</button>
            </c:if>
        </td>
    </tr>
    <tr>
        <th>상세주소</th>
        <td><input type="text" id="orAddrdetail" value="${order.orAddrdetail}" ${editable ? '' : 'readonly'}></td>
    </tr>
    <tr>
        <th>주문메모</th>
        <td><textarea id="orMemo" rows="2" ${editable ? '' : 'readonly'}>${order.orMemo}</textarea></td>
    </tr>
</table>

<!-- TODO: 주문상세(od_detail_no) 목록 -->

<div class="btn-group">
    <button type="button" class="btn" onclick="history.back()">목록으로</button>
    <c:if test="${editable}">
        <button type="button" class="btn btn-primary" onclick="updateOrder()">배송지 수정</button>
    </c:if>
</div>

<script>
    const orNo = ${order.orNo};

    function searchAddress() {
        new daum.Postcode({
            oncomplete: function (data) {
                document.getElementById('orAddress').value = data.roadAddress || data.jibunAddress;
                document.getElementById('orAddrdetail').focus();
            }
        }).open();
    }

    // 배송지/메모 수정 - 결제 전(PAYMENT_PENDING) 상태에서만 컨트롤러가 허용
    function updateOrder() {
        const body = {
            orName: document.getElementById('orName').value,
            orPhone: document.getElementById('orPhone').value,
            orAddress: document.getElementById('orAddress').value,
            orAddrdetail: document.getElementById('orAddrdetail').value,
            orMemo: document.getElementById('orMemo').value
        };

        fetch('/order/' + orNo, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(body)
        })
        .then(res => res.json())
        .then(result => {
            if (result.success) {
                alert('배송지 정보가 수정되었어요.');
                location.reload();
            } else {
                alert(result.message || '수정에 실패했어요.');
            }
        })
        .catch(() => alert('처리 중 오류가 발생했어요.'));
    }
</script>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
