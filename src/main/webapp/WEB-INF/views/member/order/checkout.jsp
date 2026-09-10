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
    <%-- 포트원 V2 브라우저 SDK (토스페이/카카오페이/네이버페이 3종 지원 - 페이코/스마일페이는 V2 미지원 확인됨(canV2:false), 추후 V1 병행 연동 시 활성화 예정) --%>
    <script src="https://cdn.portone.io/v2/browser-sdk.js"></script>
    <%-- 결제수단 이미지 선택 UI / 쇼핑백 UI 스타일은 checkout.css에 정의되어 있음 --%>
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

    <form id="orderForm" onsubmit="return false;">
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
            <%-- 쿠폰 파트 API 연동 전이라 지금은 자리만 잡아두고 비활성화 - 연동되면 실제 보유 쿠폰 목록으로 교체 --%>
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
            <%-- 포인트 파트 API 연동 전이라 지금은 자리만 잡아두고 비활성화 - 연동되면 실제 보유 포인트로 교체 --%>
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
                <%-- 쇼핑백 구매 시에만 노출되는 금액 행 (기본 숨김) --%>
                <div class="co-summary-row" id="bagFeeRow" style="display:none;">
                    <span>쇼핑백</span>
                    <span id="bagFeeAmount">0원</span>
                </div>
                <div class="co-summary-total"><span>총 주문금액</span><span class="amt" id="totalAmount"><fmt:formatNumber value="${finalAmount}" pattern="#,##0" />원</span></div>
            </div>

            <%-- ================== 쇼핑백 ================== --%>
            <%-- 쇼핑백 1개당 500원, 최소 1개 ~ 최대 5개까지 구매 가능 (+/- 버튼으로 수량 조절) --%>
            <div class="co-card">
                <div class="co-card-title">쇼핑백</div>
                <label class="co-check-row" style="cursor:pointer;">
                    <input type="checkbox" id="useShoppingBag" onchange="toggleShoppingBag(this.checked)">
                    쇼핑백 구매 (1개 500원)
                </label>
                <div class="co-bag-qty-row" id="bagQtyRow" style="display:none;">
                    <button type="button" class="co-btn co-bag-btn" onclick="changeBagQty(-1)">-</button>
                    <span id="bagQtyDisplay">1</span>개
                    <button type="button" class="co-btn co-bag-btn" onclick="changeBagQty(1)">+</button>
                    <span id="bagAmountText" class="co-bag-amount">500원</span>
                </div>
            </div>
            <div class="co-card">
                <div class="co-card-title">결제 수단</div>
                <%-- 동그라미 라디오 대신 결제사 로고 이미지로 선택하는 방식
                     실제 로고 이미지는 /images/pay/ 폴더에 넣어주세요
                     (파일명 : toss.png, payco.png, kakaopay.png, smilepay.png, naverpay.png)
                     이미지가 없으면 onerror로 아이콘만 숨기고 글자만 남도록 처리해둠 --%>
                <div class="co-pay-options">
                    <label class="co-pay-option-img selected" data-pay="TOSS">
                        <input type="radio" name="orMethod" value="TOSS" checked onchange="highlightPayOption(this.value)">
                        <img src="${pageContext.request.contextPath}/images/pay/toss.png" alt="토스페이" onerror="this.style.display='none'">
                        <span>토스페이</span>
                    </label>
                    <label class="co-pay-option-img" data-pay="PAYCO">
                        <input type="radio" name="orMethod" value="PAYCO" onchange="highlightPayOption(this.value)">
                        <img src="${pageContext.request.contextPath}/images/pay/payco.png" alt="페이코" onerror="this.style.display='none'">
                        <span>페이코</span>
                    </label>
                    <label class="co-pay-option-img" data-pay="KAKAOPAY">
                        <input type="radio" name="orMethod" value="KAKAOPAY" onchange="highlightPayOption(this.value)">
                        <img src="${pageContext.request.contextPath}/images/pay/kakaopay.png" alt="카카오페이" onerror="this.style.display='none'">
                        <span>카카오페이</span>
                    </label>
                    <label class="co-pay-option-img" data-pay="SMILEPAY">
                        <input type="radio" name="orMethod" value="SMILEPAY" onchange="highlightPayOption(this.value)">
                        <img src="${pageContext.request.contextPath}/images/pay/smilepay.png" alt="스마일페이" onerror="this.style.display='none'">
                        <span>스마일페이</span>
                    </label>
                    <label class="co-pay-option-img" data-pay="NAVERPAY">
                        <input type="radio" name="orMethod" value="NAVERPAY" onchange="highlightPayOption(this.value)">
                        <img src="${pageContext.request.contextPath}/images/pay/naverpay.png" alt="네이버페이" onerror="this.style.display='none'">
                        <span>네이버페이</span>
                    </label>
                </div>
            </div>
            <%-- ================== 약관 동의 + 결제하기 ================== --%>
            <div class="co-card">
                <div class="co-card-title">이용 및 정보 제공 약관</div>
                <p class="co-terms-text">결제 전 이용 및 정보 제공 약관 내용을 확인했으며 이에 동의합니다.</p>
                <label class="co-terms-check">
                    <input type="checkbox" id="agreeTerms" required>
                    구매조건 확인 및 결제진행 동의
                </label>
                <button type="button" class="co-btn-pay" id="btnPay" onclick="requestOrder()">결제하기</button>
            </div>
        </div>
    </div>
    </form>
</div>

<script>
    // 로그인 회원 정보(주문자정보/배송정보 자동입력용) - hidden input 에서 안전하게 읽어옴
    var memberInfo = {
        name: document.getElementById('memberName').value,
        tel: document.getElementById('memberTel').value,
        addr: document.getElementById('memberAddr').value,
        addrDetail: document.getElementById('memberAddrDetail').value
    };

    // 주문 요약 금액(EL 값 그대로 JS 상수로) - 결제요청(/payment/request) 보낼 때 사용
    const productAmountVal = ${productAmount};
    const shippingFeeVal = ${shippingFee};
    const finalAmountVal = ${finalAmount};
    const PORTONE_STORE_ID = 'store-35335759-6047-4991-9a70-706bda2091f7';
    const EASY_PAY_PROVIDER_MAP = {
        TOSS: 'TOSSPAY',
        PAYCO: 'PAYCO',
        KAKAOPAY: 'KAKAOPAY',
        SMILEPAY: 'SMILEPAY',
        NAVERPAY: 'NAVERPAY'
    };

    const V2_UNSUPPORTED_METHODS = ['PAYCO', 'SMILEPAY'];

    // 쇼핑백 - 1개당 500원, 최소 1개 ~ 최대 5개
    const BAG_PRICE = 500;
    const BAG_MIN_QTY = 1;
    const BAG_MAX_QTY = 5;
    let bagQty = BAG_MIN_QTY;

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

    // 신규 배송정보 - 체크박스 해제하고 주소 비운 뒤 바로 주소 검색 팝업 열어줌
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

    // 쇼핑백 구매 체크 시 수량 선택 UI + 요약패널 금액행 노출/숨김
    function toggleShoppingBag(checked) {
        document.getElementById('bagQtyRow').style.display = checked ? 'flex' : 'none';
        document.getElementById('bagFeeRow').style.display = checked ? 'flex' : 'none';
        if (!checked) {
            bagQty = BAG_MIN_QTY; // 체크 해제 시 수량은 기본값(1개)으로 초기화
        }
        updateBagDisplay();
        updateTotalAmount();
    }

    // 쇼핑백 수량 +/- 버튼 (최소 1개 ~ 최대 5개 제한)
    function changeBagQty(diff) {
        const next = bagQty + diff;
        if (next < BAG_MIN_QTY || next > BAG_MAX_QTY) return;
        bagQty = next;
        updateBagDisplay();
        updateTotalAmount();
    }

    // 쇼핑백 수량/금액 표시 갱신
    function updateBagDisplay() {
        var bagAmount = bagQty * BAG_PRICE;
        document.getElementById('bagQtyDisplay').innerText = bagQty;
        document.getElementById('bagAmountText').innerText = bagAmount.toLocaleString() + '원';
        document.getElementById('bagFeeAmount').innerText = bagAmount.toLocaleString() + '원';
    }

    // 현재 선택된 쇼핑백 금액 (미체크 시 0원)
    function getBagAmount() {
        return document.getElementById('useShoppingBag').checked ? bagQty * BAG_PRICE : 0;
    }

    // 결제수단 이미지 선택 UI - 라디오 change 시 선택된 카드만 selected 클래스 부여
    function highlightPayOption(value) {
        document.querySelectorAll('.co-pay-option-img').forEach(function (el) {
            el.classList.toggle('selected', el.getAttribute('data-pay') === value);
        });
    }

    // 상품금액 + 배송비 + 쇼핑백 금액으로 총 결제금액 재계산해서 화면 반영
    function updateTotalAmount() {
        var total = productAmountVal + shippingFeeVal + getBagAmount();
        document.getElementById('totalAmount').innerText = total.toLocaleString() + '원';
    }

    // 주문 상품명 모아서 결제창에 표시할 주문명 생성 (예: "OO치약 외 3건")
    function buildOrderName() {
        var names = document.getElementsByClassName('co-product-name');
        if (names.length === 0) return '주문상품';
        var first = names[0].innerText;
        return names.length > 1 ? (first + ' 외 ' + (names.length - 1) + '건') : first;
    }

    function requestOrder() {
        const btnPay = document.getElementById('btnPay');
        if (btnPay.disabled) {
            return; // 이미 처리 중인 요청이 있으면 중복 실행 무시
        }
        btnPay.disabled = true; // 검증 이전에 즉시 잠가서, 검증 중 다시 호출돼도 곧바로 걸러지게 함

        const form = document.getElementById('orderForm');
        if (!form.checkValidity()) {
            form.reportValidity();
            btnPay.disabled = false;
            return;
        }

        if (!document.getElementById('agreeTerms').checked) {
            alert('구매조건 확인 및 결제진행에 동의해주세요.');
            btnPay.disabled = false;
            return;
        }

        const payMethodEl = document.querySelector('input[name="orMethod"]:checked');

        // 페이코/스마일페이는 포트원 V2 SDK 미지원 확인됨 - 아직 준비 중 처리
        if (V2_UNSUPPORTED_METHODS.includes(payMethodEl.value)) {
            alert('아직 준비 중인 결제수단이에요. 다른 결제수단을 선택해주세요.');
            btnPay.disabled = false;
            return;
        }

        const caNoList = Array.from(document.getElementsByClassName('ca-no-input'))
            .map(el => Number(el.value));

        // 쇼핑백 구매여부(orYn)/수량(orQty) - orQty는 주문 상품 수량이 아니라 쇼핑백 추가구매 수량임
        const bagChecked = document.getElementById('useShoppingBag').checked;

        const body = {
            caNoList: caNoList,
            orName: document.getElementById('orName').value,
            orPhone: document.getElementById('orPhone').value,
            orAddress: document.getElementById('orAddress').value,
            orAddrdetail: document.getElementById('orAddrdetail').value,
            orMemo: document.getElementById('orMemo').value,
            orMethod: payMethodEl.value,
            orYn: bagChecked ? 'Y' : 'N',
            orQty: bagChecked ? bagQty : 0
        };

        fetch('/member/order', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: JSON.stringify(body)
        })
        .then(res => res.json())
        .then(result => {
            if (result.success) {
                startPayment(result.data, payMethodEl.value);
            } else {
                btnPay.disabled = false;
                alert(result.message || '주문 생성에 실패했어요.');
            }
        })
        .catch(() => {
            btnPay.disabled = false;
            alert('주문 처리 중 오류가 발생했어요.');
        });
    }

    // 결제요청(PaymentController#requestPayment) -> 포트원 SDK 결제창 호출 -> 결제승인(confirm) 순서로 진행
    function startPayment(orNo, orMethodValue) {
        const easyPayProvider = EASY_PAY_PROVIDER_MAP[orMethodValue];
        const bagAmountVal = getBagAmount();
        const totalPayAmount = productAmountVal + shippingFeeVal + bagAmountVal;

        const params = new URLSearchParams();
        params.append('orNo', orNo);
        params.append('easyPayProvider', easyPayProvider);
        params.append('payAmount', productAmountVal);
        params.append('payFee', shippingFeeVal);
        params.append('payDiscount', 0);
        params.append('payUsed', 0);
        params.append('payDis', 0);
        params.append('payRealAmt', totalPayAmount);
        params.append('orderName', buildOrderName());

        fetch('/payment/request', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: params.toString()
        })
        .then(res => res.json())
        .then(result => {
            if (!result.success) {
                document.getElementById('btnPay').disabled = false;
                alert(result.message || '결제요청 등록에 실패했어요.');
                return;
            }

            const paymentId = 'payment-' + result.payNo + '-' + Date.now();

            // 채널이 이미 PG별로 나뉘어 있으므로 easyPay 필드는 넣지 않음
            PortOne.requestPayment({
                storeId: PORTONE_STORE_ID,
                channelKey: result.channelKey,
                paymentId: paymentId,
                orderName: result.orderName,
                totalAmount: result.payRealAmt,
                currency: 'CURRENCY_KRW',
                payMethod: 'EASY_PAY',
                customer: {
                    fullName: document.getElementById('orName').value,
                    phoneNumber: document.getElementById('orPhone').value
                },
                customData: String(result.payNo)
            }).then(function (paymentResponse) {

                if (paymentResponse.code != null) {
                    // 사용자 취소, 결제 실패 등
                    document.getElementById('btnPay').disabled = false;
                    alert('결제가 완료되지 않았어요: ' + paymentResponse.message);
                    return;
                }

                // 결제창에서는 성공으로 보였어도, 실제 승인 여부는 서버에서 포트원 재조회로 검증
                confirmPayment(result.payNo, paymentResponse.paymentId, orNo);
            });
        })
        .catch(() => {
            document.getElementById('btnPay').disabled = false;
            alert('결제요청 처리 중 오류가 발생했어요.');
        });
    }

    // 결제 승인/검증 (서버가 포트원에 재조회해서 금액 위변조 여부까지 확인)
    function confirmPayment(payNo, paymentId, orNo) {
        const params = new URLSearchParams();
        params.append('payNo', payNo);
        params.append('paymentId', paymentId);

        fetch('/payment/confirm', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: params.toString()
        })
        .then(res => res.json())
        .then(result => {
            if (result.success) {
                alert('결제가 완료되었어요.');
                location.href = '/member/order/' + orNo;
            } else {
                document.getElementById('btnPay').disabled = false;
                alert(result.message || '결제 승인에 실패했어요. 주문상세에서 다시 시도해주세요.');
                location.href = '/member/order/' + orNo;
            }
        })
        .catch(() => {
            document.getElementById('btnPay').disabled = false;
            alert('결제 승인 처리 중 오류가 발생했어요. 주문상세에서 다시 시도해주세요.');
            location.href = '/member/order/' + orNo;
        });
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
