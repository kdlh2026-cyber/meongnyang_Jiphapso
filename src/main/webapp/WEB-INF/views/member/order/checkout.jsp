<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>결제하기</title>
    <%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
	<link rel="stylesheet" href="/css/order/checkout.css">
    <%-- 다음 우편번호(주소) 검색 API --%>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>
<body>

<div class="co-wrap">
    <div class="co-header">
        <button type="button" class="co-back" onclick="history.back()">‹</button>
        <h2 class="co-title">결제하기</h2>
    </div>

	    <%-- ================== 회원 정보(로그인 회원) - 주문자정보/배송정보 자동입력용 ================== --%>
    <input type="hidden" id="memberName" value='<c:out value="${member.m_name}"/>'>
    <input type="hidden" id="memberTel" value='<c:out value="${member.m_tel}"/>'>
    <input type="hidden" id="memberAddr" value='<c:out value="${member.m_addr}"/>'>
    <input type="hidden" id="memberAddrDetail" value='<c:out value="${member.m_addr_detail}"/>'>

    <%-- 배송비 : 기본 3,000원 / 상품금액 30,000원 이상이면 무료 (cart/list.jsp 요약패널과 동일 정책) --%>
    <c:set var="shippingFee" value="${productAmount >= 30000 ? 0 : 3000}" />
    <c:set var="finalAmount" value="${productAmount + shippingFee}" />

    <form id="orderForm">
    <div class="co-grid">
        <div class="co-main">

            <%-- ================== 주문 상품 목록 ================== --%>
            <div class="co-card">
                <div class="co-card-title">주문 상품 정보</div>

                <c:forEach var="cart" items="${cartList}">
                    <%-- 주문 생성 API 호출 시 다시 담아 보낼 caNo 목록 --%>
                    <input type="hidden" name="caNo" value="${cart.caNo}" class="ca-no-input">
                    <div class="co-product-row">
                        <img src="${pageContext.request.contextPath}/images/products/main/${cart.PMainImg}" alt="${cart.PName}">
                        <div class="co-product-info">
                            <div class="co-product-name">${cart.PName}</div>
                            <c:if test="${not empty cart.OName}"><br><span class="co-product-opt">옵션 : ${cart.OName}</span></c:if>
                            <div class="co-product-qty">수량 : ${cart.caQuantity}개</div>
                        </div>
                        <div class="co-product-price"><fmt:formatNumber value="${cart.OPrice * cart.caQuantity}" pattern="#,##0" />원</div>
                    </div>
                </c:forEach>

                <div class="co-shipping-note">
                    배송비
                    <strong>
                        <c:choose>
                            <c:when test="${shippingFee == 0}">무료</c:when>
                            <c:otherwise><fmt:formatNumber value="${shippingFee}" pattern="#,##0" />원</c:otherwise>
                        </c:choose>
                    </strong>
                    <c:if test="${shippingFee > 0}">
                        <br><span style="font-weight:400;">(3만원 이상 구매 시 무료배송)</span>
                    </c:if>
                </div>
            </div>

            <%-- ================== 주문자 정보 ================== --%>
            <div class="co-card">
                <div class="co-card-title">주문자 정보</div>
                <div class="co-form-row">
                    <input type="text" id="orName" name="orName" placeholder="받는분 성함" required>
                    <input type="tel" id="orPhone" name="orPhone" placeholder="연락처 ( - 없이 입력 )" required>
                </div>
            </div>

            <%-- ================== 배송 정보 ================== --%>
            <div class="co-card">
                <div class="co-card-title">배송 정보</div>

                <div class="co-check-row" style="margin:0 0 12px; justify-content:space-between;">
                    <label style="display:flex; align-items:center; gap:6px; cursor:pointer;">
                        <input type="checkbox" id="useMemberAddr" onchange="toggleMemberAddr(this.checked)"
                               <c:if test="${empty member.m_addr}">disabled</c:if>>
                        회원 정보와 동일하게 배송
                    </label>
                    <button type="button" class="co-btn" onclick="newAddress()">신규 배송정보</button>
                </div>

                <div class="co-form-row">
                    <input type="text" id="orAddress" name="orAddress" placeholder="주소" readonly required>
                    <button type="button" class="co-btn" id="btnSearchAddress" onclick="searchAddress()">주소 검색</button>
                </div>
                <div class="co-form-row">
                    <input type="text" id="orAddrdetail" name="orAddrdetail" placeholder="상세주소" required>
                </div>
                <div class="co-form-row">
                    <select id="orMemoSelect" onchange="toggleMemoEtc(this.value)">
                        <option value="">배송 요청사항을 선택해주세요</option>
                        <option value="문 앞에 놓아주세요">문 앞에 놓아주세요</option>
                        <option value="경비실에 맡겨주세요">경비실에 맡겨주세요</option>
                        <option value="부재 시 연락 부탁드려요">부재 시 연락 부탁드려요</option>
                        <option value="ETC">직접 입력</option>
                    </select>
                </div>
                <div class="co-form-row" id="orMemoEtcRow" style="display:none;">
                    <textarea id="orMemo" name="orMemo" rows="2" placeholder="배송 요청사항을 입력해주세요"></textarea>
                </div>
            </div>

            <%-- ================== 쿠폰 ================== --%>
            <%-- 쿠폰 파트 API 연동 전이라 지금은 표시만 - 연동되면 실제 보유 쿠폰 목록으로 교체 --%>
            <div class="co-card">
                <div class="co-card-title">쿠폰</div>
                <div class="co-select-row">
                    <select id="couponSelect" disabled>
                        <option>사용 가능한 쿠폰이 없어요</option>
                    </select>
                </div>
                <p class="co-hint">선택한 쿠폰이 없어요</p>
            </div>

            <%-- ================== 포인트 ================== --%>
            <%-- 포인트 파트 API 연동 전이라 지금은 표시만 - 연동되면 실제 보유 포인트로 교체 --%>
            <div class="co-card">
                <div class="co-card-title">포인트</div>
                <div class="co-point-row">
                    <input type="number" id="usePoint" value="0" min="0" disabled>
                    <button type="button" class="co-btn" disabled>전체사용</button>
                </div>
                <p class="co-hint">사용 가능 포인트 <strong>0</strong> / 보유 포인트 0</p>
            </div>
        </div>

        <div class="co-side">
            <%-- ================= 결제 금액 ================== --%>
            <div class="co-card">
                <div class="co-card-title">주문 요약</div>
                <div class="co-summary-row"><span>상품금액</span><span><fmt:formatNumber value="${productAmount}" pattern="#,##0" />원</span></div>
                <div class="co-summary-row">
                    <span>배송비</span>
                    <span id="shippingFee">
                        <c:choose>
                            <c:when test="${shippingFee == 0}">무료</c:when>
                            <c:otherwise><fmt:formatNumber value="${shippingFee}" pattern="#,##0" />원</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="co-summary-total"><span>총 주문금액</span><span class="amt" id="totalAmount"><fmt:formatNumber value="${finalAmount}" pattern="#,##0" />원</span></div>
            </div>
            <%-- ================== 결제수단 ==================
                 실제 결제 API 연동은 카카오페이/토스/네이버페이 3개만 진행하고,
                 페이코/스마일페이는 화면 구성만 우선 넣어둠(선택 시 결제 요청 단계에서 "준비 중" 처리 필요) --%>
            <div class="co-card">
                <div class="co-card-title">결제 수단</div>
                <label class="co-pay-option"><input type="radio" name="orMethod" value="TOSS" checked> 토스페이</label>
                <label class="co-pay-option"><input type="radio" name="orMethod" value="PAYCO"> 페이코</label>
                <label class="co-pay-option"><input type="radio" name="orMethod" value="KAKAOPAY"> 카카오페이</label>
                <label class="co-pay-option"><input type="radio" name="orMethod" value="SMILEPAY"> 스마일페이</label>
                <label class="co-pay-option"><input type="radio" name="orMethod" value="NAVERPAY"> 네이버페이</label>
            </div>
            <%-- ================== 약관 동의 + 결제하기 ================== --%>
            <div class="co-card">
                <div class="co-card-title">이용 및 정보 제공 약관</div>
                <p class="co-terms-text">결제 전 이용 및 정보 제공 약관 내용을 확인했으며 이에 동의합니다.</p>
                <label class="co-terms-check">
                    <input type="checkbox" id="agreeTerms" required>
                    구매조건 확인 및 결제진행 동의
                </label>
                <button type="button" class="co-btn-pay" onclick="requestOrder()">결제하기</button>
            </div>
        </div>
    </div>
    </form>
</div>

<script>
    var memberInfo = {
        name: document.getElementById('memberName').value,
        tel: document.getElementById('memberTel').value,
        addr: document.getElementById('memberAddr').value,
        addrDetail: document.getElementById('memberAddrDetail').value
    };

    function toggleMemberAddr(checked) {
        var addressInput = document.getElementById('orAddress');
        var addrDetailInput = document.getElementById('orAddrdetail');
        var searchBtn = document.getElementById('btnSearchAddress');

        if (checked) {
            addressInput.value = memberInfo.addr || '';
            addrDetailInput.value = memberInfo.addrDetail || '';
            addrDetailInput.readOnly = true;
            searchBtn.disabled = true;
        } else {
            addrDetailInput.readOnly = false;
            searchBtn.disabled = false;
        }
    }

    function newAddress() {
        document.getElementById('useMemberAddr').checked = false;
        document.getElementById('orAddress').value = '';
        document.getElementById('orAddrdetail').value = '';
        document.getElementById('orAddrdetail').readOnly = false;
        document.getElementById('btnSearchAddress').disabled = false;
        searchAddress();
    }
    (function initFromMember() {
        document.getElementById('orName').value = memberInfo.name || '';
        document.getElementById('orPhone').value = memberInfo.tel || '';

        if (memberInfo.addr) {
            document.getElementById('useMemberAddr').checked = true;
            toggleMemberAddr(true);
        }
    })();

    // 배송 요청사항 "직접 입력" 선택 시에만 텍스트영역 노출
    function toggleMemoEtc(value) {
        var row = document.getElementById('orMemoEtcRow');
        var textarea = document.getElementById('orMemo');
        if (value === 'ETC') {
            row.style.display = 'block';
            textarea.value = '';
        } else {
            row.style.display = 'none';
            textarea.value = value; // 선택형 문구는 그대로 orMemo 값으로 사용
        }
    }

    // 주문 생성 요청 -> 성공 시 orNo 를 받아 이후 결제 API(별도 구현) 단계로 이동
    function requestOrder() {
        const form = document.getElementById('orderForm');
        if (!form.checkValidity()) {
            form.reportValidity();
            return;
        }

        if (!document.getElementById('agreeTerms').checked) {
            alert('구매조건 확인 및 결제진행에 동의해주세요.');
            return;
        }

        const caNoList = Array.from(document.getElementsByClassName('ca-no-input'))
            .map(el => Number(el.value));

        const payMethodEl = document.querySelector('input[name="orMethod"]:checked');

        if (payMethodEl.value === 'PAYCO' || payMethodEl.value === 'SMILEPAY') {
            alert('아직 준비 중인 결제수단이에요. 다른 결제수단을 선택해주세요.');
            return;
        }

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