<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>주문/결제</title>
    <link rel="stylesheet" href="/css/order/checkout.css">
    <%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
    <%-- 다음 우편번호(주소) 검색 API --%>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<body>
<h3>주문/결제</h3>
<div id="checkoutContent">

    <%-- ================== 주문 상품 목록 ================== --%>
    <div class="section-title">주문 상품</div>
    <c:forEach var="cart" items="${cartList}">
        <%-- 주문 생성 API 호출 시 다시 담아 보낼 caNo 목록 --%>
        <input type="hidden" name="caNo" value="${cart.caNo}" class="ca-no-input">
        <div class="cart-summary-item">
            <img src="${cart.pMainImg}" alt="${cart.pName}">
            <div class="info">
                <div class="name">
                    ${cart.pName}
                    <c:if test="${not empty cart.oName}"> (${cart.oName})</c:if>
                </div>
                <div class="qty">수량 : ${cart.caQuantity}개</div>
            </div>
            <div class="price"><fmt:formatNumber value="${cart.oPrice * cart.caQuantity}" pattern="#,##0" />원</div>
        </div>
    </c:forEach>

    <%-- ================== 주문자 / 배송지 정보 ================== --%>
    <div class="section-title">주문자 정보</div>
    <form id="orderForm">
        <div class="form-row">
            <input type="text" id="orName" name="orName" placeholder="받는분 성함" required>
            <input type="text" id="orPhone" name="orPhone" placeholder="연락처 ( - 없이 입력 )" required>
        </div>
        <div class="form-row">
            <input type="text" id="orAddress" name="orAddress" placeholder="주소" readonly required>
            <button type="button" class="btn" onclick="searchAddress()">주소 검색</button>
        </div>
        <div class="form-row">
            <input type="text" id="orAddrdetail" name="orAddrdetail" placeholder="상세주소" required>
        </div>
        <div class="form-row">
            <textarea id="orMemo" name="orMemo" rows="2" placeholder="배송 요청사항 (선택)"></textarea>
        </div>

        <%-- ================== 결제수단 ================== --%>
        <div class="section-title">결제수단</div>
        <div class="pay-method">
            <label><input type="radio" name="orMethod" value="KAKAOPAY" checked> 카카오페이</label>
            <label><input type="radio" name="orMethod" value="TOSS"> 토스페이</label>
            <label><input type="radio" name="orMethod" value="NAVERPAY"> 네이버페이</label>
        </div>

        <%-- 쿠폰 / 포인트 적용은 별도 파트(쿠폰·포인트) API 연동 후 추가 - 현재 OrderDTO에는 필드 없음 --%>
        <!-- TODO: 쿠폰/포인트 선택 UI -->

        <%-- ================== 결제 금액 ================== --%>
        <div class="section-title">결제 금액</div>
        <div class="summary">
            <div class="summary-row"><span>상품금액</span><span><fmt:formatNumber value="${productAmount}" pattern="#,##0" />원</span></div>
            <div class="summary-row"><span>배송비</span><span id="shippingFee">0원</span></div>
            <div class="summary-row total"><span>총 결제금액</span><span id="totalAmount"><fmt:formatNumber value="${productAmount}" pattern="#,##0" />원</span></div>
        </div>

        <div class="btn-group">
            <button type="button" class="btn btn-prev" onclick="history.back()">이전</button>
            <button type="button" class="btn btn-pay" onclick="requestOrder()">결제하기</button>
        </div>
    </form>
</div>

<script>
    // 주문 생성 요청 -> 성공 시 orNo 를 받아 이후 결제 API(별도 구현) 단계로 이동
    function requestOrder() {
        const form = document.getElementById('orderForm');
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        const caNoList = Array.from(document.getElementsByClassName('ca-no-input'))
            .map(el => Number(el.value));

        const payMethodEl = document.querySelector('input[name="orMethod"]:checked');

        const body = {
            caNoList: caNoList,
            orName: document.getElementById('orName').value,
            orPhone: document.getElementById('orPhone').value,
            orAddress: document.getElementById('orAddress').value,
            orAddrdetail: document.getElementById('orAddrdetail').value,
            orMemo: document.getElementById('orMemo').value,
            orMethod: payMethodEl.value,
            orQty: caNoList.length
        };

        fetch('/member/order', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(body)
        })
        .then(res => res.json())
        .then(result => {
            if (result.success) {
                // 결제 API(카카오페이/토스/네이버페이) 연동은 결제 파트에서 별도 처리
                // 여기서는 주문 생성까지만 처리하고 주문상세로 이동
                location.href = '/member/order/' + result.data;
            } else {
                alert(result.message || '주문 생성에 실패했어요.');
            }
        })
        .catch(() => alert('주문 처리 중 오류가 발생했어요.'));
    }

    // 다음 주소 검색 팝업
    function searchAddress() {
        new daum.Postcode({
            oncomplete: function (data) {
                document.getElementById('orAddress').value = data.roadAddress || data.jibunAddress;
                document.getElementById('orAddrdetail').focus();
            }
        }).open();
    }
</script>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
