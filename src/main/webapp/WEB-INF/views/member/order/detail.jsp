<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
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

<c:set var="editable" value="${order.orStatus == 'PAYMENT_PENDING'}" />

<div class="od-wrap">

    <div class="od-header">
        <button type="button" class="od-back" onclick="history.back()">‹</button>
        <h2 class="od-title">주문상세</h2>
    </div>

    <%-- ================== 주문 정보 ================== --%>
    <div class="od-card">
        <div class="od-card-title">주문 정보</div>
        <div class="od-info-grid">
            <div class="od-info-row"><span class="label">주문번호</span><span>${order.orNo}</span></div>
            <div class="od-info-row"><span class="label">주문일시</span><span><fmt:formatDate value="${order.orAt}" pattern="yyyy.MM.dd HH:mm" /></span></div>
            <div class="od-info-row">
                <span class="label">주문상태</span>
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
            </div>
            <div class="od-info-row"><span class="label">결제수단</span><span>${order.orMethod}</span></div>
            <div class="od-info-row"><span class="label">상품 수량</span><span>${order.productQty}개</span></div>
            <c:if test="${order.orYn == 'Y' && order.orQty > 0}">
                <div class="od-info-row"><span class="label">쇼핑백</span><span>${order.orQty}개 추가구매</span></div>
            </c:if>
        </div>
    </div>

    <%-- ================== 배송 정보 ================== --%>
    <div class="od-card">
        <div class="od-card-title">배송 정보</div>

        <div class="od-form-row">
            <label>받는분</label>
            <input type="text" id="orName" value="${order.orName}" ${editable ? '' : 'readonly'}>
        </div>
        <div class="od-form-row">
            <label>연락처</label>
            <input type="text" id="orPhone" value="${order.orPhone}" ${editable ? '' : 'readonly'}>
        </div>
        <div class="od-form-row">
            <label>주소</label>
            <div class="od-form-inline">
                <input type="text" id="orAddress" value="${order.orAddress}" readonly>
                <c:if test="${editable}">
                    <button type="button" class="od-btn" onclick="searchAddress()">주소 검색</button>
                </c:if>
            </div>
        </div>
        <div class="od-form-row">
            <label>상세주소</label>
            <input type="text" id="orAddrdetail" value="${order.orAddrdetail}" ${editable ? '' : 'readonly'}>
        </div>
        <div class="od-form-row">
            <label>주문메모</label>
            <textarea id="orMemo" rows="2" ${editable ? '' : 'readonly'}>${order.orMemo}</textarea>
        </div>

        <c:if test="${editable}">
            <div class="od-form-actions">
                <button type="button" class="od-btn od-btn-primary" onclick="updateOrder()">배송지 수정</button>
            </div>
        </c:if>
    </div>

    <%-- ================== 주문 상품 ================== --%>
    <div class="od-card" id="odProductCard">
        <div class="od-card-title">주문 상품</div>
        <div class="od-table-wrap">
            <table class="od-detail-table">
                <thead>
                    <tr>
                        <th>상품명</th>
                        <th>옵션</th>
                        <th>단가</th>
                        <th>수량</th>
                        <th>금액</th>
                        <th>취소/반품/교환</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="detail" items="${order.orderDetailList}">
                        <tr>
                            <td class="od-pname">${detail.odProductName}</td>
                            <td>${empty detail.odOptionName ? '-' : detail.odOptionName}</td>
                            <td><fmt:formatNumber value="${detail.odPrice}" pattern="#,##0" />원</td>
                            <td>${detail.odQuantity}개</td>
                            <td class="od-amount"><fmt:formatNumber value="${detail.odAmount}" pattern="#,##0" />원</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty detail.ocStatus && detail.ocStatus != 'REJECTED'}">
                                        <span class="oc-status-badge oc-status-<c:choose><c:when test="${detail.ocStatus == 'REQUESTED'}">requested</c:when><c:when test="${detail.ocStatus == 'APPROVED'}">approved</c:when><c:when test="${detail.ocStatus == 'REFUNDED'}">refunded</c:when><c:otherwise>etc</c:otherwise></c:choose>">
                                            <c:choose>
                                                <c:when test="${detail.ocStatus == 'REQUESTED'}">취소신청중</c:when>
                                                <c:when test="${detail.ocStatus == 'APPROVED'}">취소승인</c:when>
                                                <c:when test="${detail.ocStatus == 'REFUNDED'}">환불완료</c:when>
                                                <c:otherwise>${detail.ocStatus}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <c:if test="${order.orStatus != 'CANCELED'}">
                                            <button type="button" class="od-btn od-btn-cancel"
                                                    onclick="openCancelModal(${detail.odDetailNo}, '${detail.odProductName}', ${detail.odQuantity})">
                                                <c:choose>
                                                    <c:when test="${detail.ocStatus == 'REJECTED'}">재신청</c:when>
                                                    <c:otherwise>취소/반품/교환</c:otherwise>
                                                </c:choose>
                                            </button>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <div class="od-btn-group">
        <button type="button" class="od-btn" onclick="history.back()">목록으로</button>
    </div>

</div>

<script>
    const orNo = ${order.orNo};


    const orderDetailItems = [
        <c:forEach var="detail" items="${order.orderDetailList}" varStatus="st">
        { odDetailNo: ${detail.odDetailNo}, odProductName: '${detail.odProductName}', odQuantity: ${detail.odQuantity}, ocStatus: <c:choose><c:when test="${empty detail.ocStatus}">null</c:when><c:otherwise>'${detail.ocStatus}'</c:otherwise></c:choose> }<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];

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

        fetch('/member/order/' + orNo, {
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


    function refreshOrderDetail() {
        location.href = location.pathname;
    }
</script>

<%-- 취소/반품/교환 신청 모달 (버튼 onclick="openCancelModal(...)" 이 이 안의 함수를 호출함) --%>
<jsp:include page="/WEB-INF/views/member/OrderCancel/cancelForm.jsp" />

<script>

    (function () {
        const params = new URLSearchParams(location.search);
        if (params.get('cancel') !== '1') return;

        // 이미 취소신청이 들어간(REJECTED=거절 제외) 라인은 자동오픈 대상에서 제외 - 아직 신청 안 한 상품만 대상
        const cancellable = orderDetailItems.filter(function (item) {
            return !item.ocStatus || item.ocStatus === 'REJECTED';
        });

        if (cancellable.length === 0) return;

        if (cancellable.length === 1) {
            // 취소 가능한 상품이 1개뿐이면 바로 취소/반품/교환 모달을 열어줌
            const item = cancellable[0];
            openCancelModal(item.odDetailNo, item.odProductName, item.odQuantity);
        } else {

            const card = document.getElementById('odProductCard');
            if (card) {
                card.scrollIntoView({ behavior: 'smooth', block: 'start' });
                card.classList.add('od-card-highlight');
                setTimeout(function () { card.classList.remove('od-card-highlight'); }, 1600);
            }
        }
    })();
</script>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
