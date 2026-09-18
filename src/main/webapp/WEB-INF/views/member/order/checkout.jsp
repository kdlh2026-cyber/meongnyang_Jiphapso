<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>결제하기</title>
    <%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/order/checkout.css">
    <%-- 다음 우편번호(주소) 검색 API --%>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <%-- 포트원 V2 브라우저 SDK --%>
    <script src="https://cdn.portone.io/v2/browser-sdk.js"></script>
</head>
<body>

<%-- 안내메세지 토스트 (alert 대체) - checkout.css의 .co-toast* 스타일 사용 --%>
<div id="coToastWrap" class="co-toast-wrap"></div>

<div class="co-wrap">
    <div class="co-header">
        <button type="button" class="co-back" onclick="history.back()">‹</button>
        <h2 class="co-title">결제하기</h2>
    </div>

    <input type="hidden" id="memberName" value='<c:out value="${member.m_name}"/>'>
    <input type="hidden" id="memberTel" value='<c:out value="${member.m_tel}"/>'>
    <input type="hidden" id="memberAddr" value='<c:out value="${member.m_addr}"/>'>
    <input type="hidden" id="memberAddrDetail" value='<c:out value="${member.m_addr_detail}"/>'>

    <c:set var="shippingFee" value="${productAmount >= 30000 ? 0 : 3000}" />
    <c:set var="finalAmount" value="${productAmount + shippingFee}" />

    <form id="orderForm" onsubmit="return false;">
    <div class="co-grid">
        <div class="co-main">

            <%-- 주문 상품 목록 --%>
            <div class="co-card">
                <div class="co-card-title">주문 상품 정보</div>

                <c:forEach var="cart" items="${cartList}">
                    <input type="hidden" name="caNo" value="${cart.caNo}" class="ca-no-input">
                    <div class="co-product-row" data-ca-no="${cart.caNo}" data-unit-price="${cart.OPrice}" data-quantity="${cart.caQuantity}">
                        <%-- cart_list.jsp와 동일하게 이미지 파일명에 '%'가 들어있으면(예: 인코딩된 한글 파일명)
                             그대로 src에 넣었을 때 브라우저가 잘못된 퍼센트 인코딩으로 오인해서 깨지므로 '%25'로 이스케이프 --%>
                        <img src="${pageContext.request.contextPath}/images/products/main/${fn:replace(cart.PMainImg, '%', '%25')}" alt="${cart.PName}">
                        <div class="co-product-info">
                            <div class="co-product-name">${cart.PName}</div>
                            <c:if test="${not empty cart.OName}"><br><span class="co-product-opt">옵션 : ${cart.OName}</span></c:if>
                            <%-- 결제 페이지에서 바로 수량 조절 가능하도록 +/- 버튼 추가 (변경 시 /cart/{caNo}/quantity 로 즉시 반영) --%>
                            <div class="co-product-qty">
                                <button type="button" class="co-qty-btn" onclick="changeItemQty(${cart.caNo}, -1)">-</button>
                                <span class="co-qty-display co-qty-num">${cart.caQuantity}</span>개
                                <button type="button" class="co-qty-btn" onclick="changeItemQty(${cart.caNo}, 1)">+</button>
                            </div>
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
                        <br><span class="co-shipping-sub">(3만원 이상 구매 시 무료배송)</span>
                    </c:if>
                </div>
            </div>

            <%-- 주문자 정보 --%>
            <div class="co-card">
                <div class="co-card-title">주문자 정보</div>
                <div class="co-form-row">
                    <input type="text" id="orName" name="orName" placeholder="받는분 성함" required>
                    <input type="tel" id="orPhone" name="orPhone" placeholder="연락처 ( - 없이 입력 )" required>
                </div>
            </div>

            <%-- 배송 정보 --%>
            <div class="co-card">
                <div class="co-card-title">배송 정보</div>

                <div class="co-check-row co-check-row-between">
                    <label class="co-addr-check-label">
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
                <div class="co-form-row co-form-row-full" id="orMemoEtcRow" style="display:none;">
                    <textarea id="orMemo" name="orMemo" rows="2" placeholder="배송 요청사항을 입력해주세요"></textarea>
                </div>
            </div>

            <%-- 쿠폰 (CouponController#usableCouponList 로 ajax 조회해서 채움) --%>
            <div class="co-card">
                <div class="co-card-title">쿠폰</div>
                <div class="co-select-row">
                    <select id="couponSelect" disabled onchange="onCouponChange()">
                        <option value="">사용 가능한 쿠폰이 없어요</option>
                    </select>
                </div>
                <p class="co-hint" id="couponHint">선택한 쿠폰이 없어요</p>
            </div>

            <%-- 포인트 --%>
            <c:set var="myPointBalanceVal" value="${empty myPointBalance ? 0 : myPointBalance}" />
            <c:set var="usablePoint" value="${myPointBalanceVal < productAmount ? myPointBalanceVal : productAmount}" />
            <div class="co-card">
                <div class="co-card-title">포인트</div>
                <div class="co-point-row">
                    <input type="number" id="usePoint" value="0" min="0" max="${usablePoint}">
                    <button type="button" class="co-btn" onclick="useAllPoint()">전체사용</button>
                </div>
                <p class="co-hint">사용 가능 포인트 <strong id="usablePointText"><fmt:formatNumber value="${usablePoint}" pattern="#,##0" /></strong> / 보유 포인트 <fmt:formatNumber value="${myPointBalanceVal}" pattern="#,##0" /></p>
            </div>
        </div>

        <div class="co-side">
            <%-- 주문 요약 --%>
            <div class="co-card">
                <div class="co-card-title">주문 요약</div>
                <div class="co-summary-row"><span>상품금액</span><span id="productAmountText"><fmt:formatNumber value="${productAmount}" pattern="#,##0" />원</span></div>
                <div class="co-summary-row">
                    <span>배송비</span>
                    <span id="shippingFee">
                        <c:choose>
                            <c:when test="${shippingFee == 0}">무료</c:when>
                            <c:otherwise><fmt:formatNumber value="${shippingFee}" pattern="#,##0" />원</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="co-summary-row" id="bagFeeRow" style="display:none;">
                    <span>쇼핑백</span>
                    <span id="bagFeeAmount">0원</span>
                </div>
                <div class="co-summary-row" id="couponDiscountRow" style="display:none;">
                    <span>쿠폰 할인</span>
                    <span id="couponDiscountAmount" class="co-discount-amt">-0원</span>
                </div>
                <div class="co-summary-row" id="pointDiscountRow" style="display:none;">
                    <span>포인트 사용</span>
                    <span id="pointDiscountAmount" class="co-discount-amt">-0원</span>
                </div>
                <div class="co-summary-total"><span>총 주문금액</span><span class="amt" id="totalAmount"><fmt:formatNumber value="${finalAmount}" pattern="#,##0" />원</span></div>
            </div>

           <%-- 선물 쇼핑백 추가 --%>
            <div class="co-card shoppingbag-card">
                <div class="co-card-title">🎁 선물 쇼핑백 추가</div>
                <p class="shoppingbag-subtitle">
                    선물용 쇼핑백이 필요하다면 함께 담아보세요.
                </p>

                <label class="shoppingbag-box">
                    <input type="checkbox" id="useShoppingBag" onchange="toggleShoppingBag(this.checked)">

                    <div class="shoppingbag-top">
                        <img src="${pageContext.request.contextPath}/images/checkout/shopping-bag-pets.png"
                             alt="쇼핑백" class="shoppingbag-img">

                        <div class="shoppingbag-info">
                            <span class="shoppingbag-badge">SPECIAL EVENT</span>
                            <h4 class="shoppingbag-name">멍냥 쇼핑백</h4>
                            <p class="shoppingbag-desc">귀여운 일러스트 쇼핑백</p>
                            <strong class="shoppingbag-price">500원 / 1개</strong>
                        </div>
                    </div>
                </label>

                <div class="co-bag-qty-row" id="bagQtyRow" style="display:none;">
                    <span class="shoppingbag-qty-label">수량 선택</span>
                    <div class="shoppingbag-qty-controls">
                        <button type="button" class="co-qty-btn" onclick="changeBagQty(-1)">-</button>
                        <span id="bagQtyDisplay" class="co-qty-num">1</span>개
                        <button type="button" class="co-qty-btn" onclick="changeBagQty(1)">+</button>
                    </div>
                    <span id="bagAmountText" class="co-bag-amount">500원</span>
                </div>
            </div>
            <%-- 결제 수단 --%>
            <div class="co-card">
                <div class="co-card-title">결제 수단</div>
                <div class="co-pay-options">
                    <label class="co-pay-option-img selected" data-pay="TOSS">
                        <input type="radio" name="orMethod" value="TOSS" checked onchange="highlightPayOption(this.value)">
                        <img src="${pageContext.request.contextPath}/images/pay/toss.png" alt="토스페이" onerror="this.style.display='none'">
                        <span>토스페이</span>
                    </label>
                    <label class="co-pay-option-img" data-pay="PAYCO">
                        <input type="radio" name="orMethod" value="PAYCO" onchange="highlightPayOption(this.value)">
                        <img src="${pageContext.request.contextPath}/images/pay/paycos.png" alt="페이코" onerror="this.style.display='none'">
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

            <%-- 약관 동의 + 결제하기 --%>
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
    // 안내메세지 토스트 (alert 대체) - 장바구니 페이지와 동일한 패턴, checkout.css의 .co-toast* 스타일 사용
    function showToast(message, type) {
        var wrap = document.getElementById('coToastWrap');
        if (!wrap || !message) return;

        var toast = document.createElement('div');
        toast.className = 'co-toast' + (type === 'success' ? ' co-toast-success' : type === 'error' ? ' co-toast-error' : '');
        toast.textContent = message;
        wrap.appendChild(toast);

        requestAnimationFrame(function () { toast.classList.add('co-toast-show'); });

        setTimeout(function () {
            toast.classList.remove('co-toast-show');
            setTimeout(function () { toast.remove(); }, 250);
        }, 2200);
    }

    var memberInfo = {
        name: document.getElementById('memberName').value,
        tel: document.getElementById('memberTel').value,
        addr: document.getElementById('memberAddr').value,
        addrDetail: document.getElementById('memberAddrDetail').value
    };


    let productAmountVal = ${productAmount};
    let shippingFeeVal = ${shippingFee};
    const finalAmountVal = ${finalAmount};
    let usablePointVal = ${usablePoint};
    const myPointBalanceVal = ${myPointBalanceVal}; // 보유 포인트 (수량 변경 시 사용가능 포인트 재계산 기준값)
    const PORTONE_STORE_ID = 'store-35335759-6047-4991-9a70-706bda2091f7';
    const EASY_PAY_PROVIDER_MAP = {
        TOSS: 'TOSSPAY',
        PAYCO: 'PAYCO',
        KAKAOPAY: 'KAKAOPAY',
        SMILEPAY: 'SMILEPAY',
        NAVERPAY: 'NAVERPAY'
    };

    const V2_UNSUPPORTED_METHODS = ['PAYCO', 'SMILEPAY'];

    const BAG_PRICE = 500;
    const BAG_MIN_QTY = 1;
    const BAG_MAX_QTY = 5;
    let bagQty = BAG_MIN_QTY;

    // ================= 쿠폰 =================
    var usableCouponList = [];   // /coupon/usable 조회 결과 캐시
    var selectedCoupon = null;   // 현재 선택된 쿠폰 (MemberCouponDTO)

    // 사용 가능한(미사용 + 만료전) 보유쿠폰 목록 조회 (CouponController#usableCouponList)
    function loadUsableCoupons() {
        fetch('/coupon/usable')
            .then(function (res) { return res.json(); })
            .then(function (result) {
                if (!result.success) return;
                usableCouponList = result.data || [];
                renderCouponSelect();
            })
            .catch(function (err) { console.error('사용 가능한 쿠폰 조회 실패', err); });
    }

    function renderCouponSelect() {
        var select = document.getElementById('couponSelect');

        // 최소주문금액을 만족하는 쿠폰만 선택 가능하게 표시
        var applicable = usableCouponList.filter(function (c) { return productAmountVal >= (c.coMinAmt || 0); });

        if (applicable.length === 0) {
            select.innerHTML = '<option value="">사용 가능한 쿠폰이 없어요</option>';
            select.disabled = true;
            return;
        }

        select.disabled = false;
        var html = '<option value="">쿠폰을 선택해주세요</option>';
        applicable.forEach(function (c) {
            var label = c.coName + ' (' + c.coVal + '% 할인' + (c.coMaxAmt ? ', 최대 ' + formatPrice(c.coMaxAmt) + '원' : '') + ')';
            html += '<option value="' + c.mcNo + '"' + (selectedCoupon && String(selectedCoupon.mcNo) === String(c.mcNo) ? ' selected' : '') + '>' + escapeHtml(label) + '</option>';
        });
        select.innerHTML = html;
    }

    function onCouponChange() {
        var select = document.getElementById('couponSelect');
        var mcNo = select.value;

        if (!mcNo) {
            selectedCoupon = null;
            document.getElementById('couponHint').innerText = '선택한 쿠폰이 없어요';
        } else {
            selectedCoupon = usableCouponList.find(function (c) { return String(c.mcNo) === String(mcNo); });
            document.getElementById('couponHint').innerText = '적용 할인 ' + formatPrice(getCouponDiscountAmount()) + '원';
        }
        updateTotalAmount();
    }

    // 쿠폰 할인액 계산 (정률 할인, coMaxAmt 있으면 상한 캡)
    function getCouponDiscountAmount() {
        if (!selectedCoupon) return 0;
        var raw = Math.floor(productAmountVal * (selectedCoupon.coVal / 100));
        if (selectedCoupon.coMaxAmt && raw > selectedCoupon.coMaxAmt) {
            raw = selectedCoupon.coMaxAmt;
        }
        return raw;
    }

    loadUsableCoupons();

    // ================= 상품 수량 변경 (결제 페이지에서 바로 +/- 조절) =================
    // 장바구니 페이지와 동일한 CartController#updateQuantity 엔드포인트를 그대로 사용
    function changeItemQty(caNo, diff) {
        var row = document.querySelector('.co-product-row[data-ca-no="' + caNo + '"]');
        if (!row) return;

        var curQty = parseInt(row.getAttribute('data-quantity'), 10);
        var newQty = curQty + diff;
        if (newQty < 1) return; // 최소 1개, 그 이하로 빼려면 장바구니 페이지에서 삭제해야 함

        fetch('/cart/' + caNo + '/quantity', {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ quantity: newQty })
        })
        .then(function (res) { return res.json(); })
        .then(function (result) {
            if (!result.success) {
                showToast(result.message || '수량 변경에 실패했어요.', 'error'); // 재고 부족 등 서비스단 검증 실패 메시지
                return;
            }

            row.setAttribute('data-quantity', newQty);
            row.querySelector('.co-qty-display').innerText = newQty;

            var unitPrice = Number(row.getAttribute('data-unit-price'));
            row.querySelector('.co-product-price').innerText = formatPrice(unitPrice * newQty) + '원';

            recalcAfterQtyChange();
        })
        .catch(function () {
            showToast('수량 변경 중 오류가 발생했어요.', 'error');
        });
    }

    // 수량이 바뀌면 상품금액/배송비/사용가능포인트/쿠폰 적용조건을 전부 다시 계산
    function recalcAfterQtyChange() {
        var rows = document.querySelectorAll('.co-product-row');
        var sum = 0;
        rows.forEach(function (row) {
            var unitPrice = Number(row.getAttribute('data-unit-price'));
            var qty = Number(row.getAttribute('data-quantity'));
            sum += unitPrice * qty;
        });

        productAmountVal = sum;
        shippingFeeVal = productAmountVal >= 30000 ? 0 : 3000;

        document.getElementById('productAmountText').innerText = formatPrice(productAmountVal) + '원';
        document.getElementById('shippingFee').innerHTML =
            shippingFeeVal === 0 ? '무료' : formatPrice(shippingFeeVal) + '원';

        // 사용 가능 포인트 = min(보유포인트, 상품금액) 재계산
        usablePointVal = Math.min(myPointBalanceVal, productAmountVal);
        var usePointInput = document.getElementById('usePoint');
        usePointInput.max = usablePointVal;
        if (Number(usePointInput.value) > usablePointVal) usePointInput.value = usablePointVal;
        document.getElementById('usablePointText').innerText = formatPrice(usablePointVal);

        // 상품금액이 줄어들어 선택된 쿠폰의 최소주문금액 조건을 더 이상 못 채우면 선택 해제
        if (selectedCoupon && productAmountVal < (selectedCoupon.coMinAmt || 0)) {
            selectedCoupon = null;
            document.getElementById('couponHint').innerText = '선택한 쿠폰이 없어요';
        }
        renderCouponSelect();

        updateTotalAmount();
    }

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

    function toggleMemoEtc(value) {
        var row = document.getElementById('orMemoEtcRow');
        var textarea = document.getElementById('orMemo');
        if (value === 'ETC') {
            // .co-form-row는 display:flex를 전제로 textarea에 flex:1(=가로 꽉 채움)을 걸어뒀는데,
            // 여기서 'block'으로 열면 flex 컨텍스트가 깨져서 textarea가 기본 크기(작은 네모)로 나오는 버그가 있었음
            // -> 다른 .co-form-row들과 동일하게 'flex'로 열어서 textarea가 가로 전체를 채우도록 수정
            row.style.display = 'flex';
            textarea.value = '';
        } else {
            row.style.display = 'none';
            textarea.value = value;
        }
    }

    function toggleShoppingBag(checked) {
        document.getElementById('bagQtyRow').style.display = checked ? 'flex' : 'none';
        document.getElementById('bagFeeRow').style.display = checked ? 'flex' : 'none';
        if (!checked) {
            bagQty = BAG_MIN_QTY;
        }
        updateBagDisplay();
        updateTotalAmount();
    }

    function changeBagQty(diff) {
        const next = bagQty + diff;
        if (next < BAG_MIN_QTY || next > BAG_MAX_QTY) return;
        bagQty = next;
        updateBagDisplay();
        updateTotalAmount();
    }

    function updateBagDisplay() {
        var bagAmount = bagQty * BAG_PRICE;
        document.getElementById('bagQtyDisplay').innerText = bagQty;
        document.getElementById('bagAmountText').innerText = bagAmount.toLocaleString() + '원';
        document.getElementById('bagFeeAmount').innerText = bagAmount.toLocaleString() + '원';
    }

    function getBagAmount() {
        return document.getElementById('useShoppingBag').checked ? bagQty * BAG_PRICE : 0;
    }

    function getUsePointAmount() {
        var input = document.getElementById('usePoint');
        var val = parseInt(input.value, 10);
        if (isNaN(val) || val < 0) val = 0;
        if (val > usablePointVal) val = usablePointVal;
        input.value = val;
        return val;
    }

    function useAllPoint() {
        document.getElementById('usePoint').value = usablePointVal;
        updateTotalAmount();
    }

    function highlightPayOption(value) {
        document.querySelectorAll('.co-pay-option-img').forEach(function (el) {
            el.classList.toggle('selected', el.getAttribute('data-pay') === value);
        });
    }

    function updateTotalAmount() {
        var usePoint = getUsePointAmount();
        var couponDiscount = getCouponDiscountAmount();
        var total = productAmountVal + shippingFeeVal + getBagAmount() - couponDiscount - usePoint;

        var couponRow = document.getElementById('couponDiscountRow');
        if (couponDiscount > 0) {
            couponRow.style.display = 'flex';
            document.getElementById('couponDiscountAmount').innerText = '-' + couponDiscount.toLocaleString() + '원';
        } else {
            couponRow.style.display = 'none';
        }

        var pointRow = document.getElementById('pointDiscountRow');
        if (usePoint > 0) {
            pointRow.style.display = 'flex';
            document.getElementById('pointDiscountAmount').innerText = '-' + usePoint.toLocaleString() + '원';
        } else {
            pointRow.style.display = 'none';
        }

        document.getElementById('totalAmount').innerText = total.toLocaleString() + '원';
    }

    document.getElementById('usePoint').addEventListener('input', updateTotalAmount);

    function buildOrderName() {
        var names = document.getElementsByClassName('co-product-name');
        if (names.length === 0) return '주문상품';
        var first = names[0].innerText;
        return names.length > 1 ? (first + ' 외 ' + (names.length - 1) + '건') : first;
    }

    function requestOrder() {
        const btnPay = document.getElementById('btnPay');
        if (btnPay.disabled) return;
        btnPay.disabled = true;

        const form = document.getElementById('orderForm');
        if (!form.checkValidity()) {
            form.reportValidity();
            btnPay.disabled = false;
            return;
        }

        if (!document.getElementById('agreeTerms').checked) {
            showToast('구매조건 확인 및 결제진행에 동의해주세요.', 'error');
            btnPay.disabled = false;
            return;
        }

        const payMethodEl = document.querySelector('input[name="orMethod"]:checked');

        if (V2_UNSUPPORTED_METHODS.includes(payMethodEl.value)) {
            showToast('아직 준비 중인 결제수단이에요. 다른 결제수단을 선택해주세요.', 'error');
            btnPay.disabled = false;
            return;
        }

        const caNoList = Array.from(document.getElementsByClassName('ca-no-input'))
            .map(el => Number(el.value));

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
            orQty: bagChecked ? bagQty : 0,
            mcNo: selectedCoupon ? selectedCoupon.mcNo : null // 선택한 보유쿠폰 번호 (없으면 null)
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
                // 쿠폰 사용 처리(markCouponUsed)는 여기서 바로 하지 않고 confirmPayment() 성공 시점으로 미룸
                // -> 주문 생성 직후 바로 /coupon/use 를 호출하면 쿠폰 상태가 곧장 USED로 바뀌어서,
                //    바로 다음에 이어지는 /payment/request(PaymentService#calcDiscountAmount)가 그 쿠폰을
                //    "이미 사용됨"으로 판단해 "이미 사용되었거나 만료된 쿠폰입니다" 에러를 던지는 버그가 있었음
                startPayment(result.data, payMethodEl.value);
            } else {
                btnPay.disabled = false;
                showToast(result.message || '주문 생성에 실패했어요.', 'error');
            }
        })
        .catch(() => {
            btnPay.disabled = false;
            showToast('주문 처리 중 오류가 발생했어요.', 'error');
        });
    }

    // 선택한 쿠폰을 이번 주문에 사용 처리 (CouponController#useCoupon)
    // 쿠폰은 주문취소/반품이 되어도 되돌려주지 않는 정책이라, 주문이 생성된 시점에 바로 사용 확정 처리함
    function markCouponUsed(orNo) {
        if (!selectedCoupon) {
            return Promise.resolve();
        }
        const params = new URLSearchParams();
        params.append('mcNo', selectedCoupon.mcNo);
        params.append('orNo', orNo);

        return fetch('/coupon/use', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params.toString()
        })
        .then(res => res.json())
        .then(result => {
            if (!result.success) {
                console.error('쿠폰 사용 처리 실패:', result.message);
            }
        })
        .catch(err => console.error('쿠폰 사용 처리 중 오류', err));
    }

    function startPayment(orNo, orMethodValue) {
        const easyPayProvider = EASY_PAY_PROVIDER_MAP[orMethodValue];
        const bagAmountVal = getBagAmount();
        const usePointVal = getUsePointAmount();
        const couponDiscountVal = getCouponDiscountAmount();
        const totalPayAmount = productAmountVal + shippingFeeVal + bagAmountVal - couponDiscountVal - usePointVal;

        const params = new URLSearchParams();
        params.append('orNo', orNo);
        params.append('easyPayProvider', easyPayProvider);
        params.append('payAmount', productAmountVal);
        params.append('payFee', shippingFeeVal);
        params.append('payDiscount', couponDiscountVal); // 쿠폰 할인액
        params.append('payUsed', usePointVal);
        params.append('payDis', usePointVal);
        params.append('payRealAmt', totalPayAmount);
        params.append('orderName', buildOrderName());
        params.append('mcNo', selectedCoupon ? selectedCoupon.mcNo : '');

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
                showToast(result.message || '결제요청 등록에 실패했어요.', 'error');
                return;
            }

            const paymentId = 'payment-' + result.payNo + '-' + Date.now();

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
                    document.getElementById('btnPay').disabled = false;
                    showToast('결제가 완료되지 않았어요: ' + paymentResponse.message, 'error');
                    return;
                }
                confirmPayment(result.payNo, paymentResponse.paymentId, orNo);
            });
        })
        .catch(() => {
            document.getElementById('btnPay').disabled = false;
            showToast('결제요청 처리 중 오류가 발생했어요.', 'error');
        });
    }

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
            // 결제완료/실패 메세지는 뜨자마자 페이지 이동해버리면 토스트를 볼 수 없어서
            // 짧게(600ms) 보여준 뒤에 이동하도록 함
            if (result.success) {
                // 쿠폰은 실제로 결제가 승인된 이 시점에만 사용 처리함(위 requestOrder() 주석 참고)
                // -> 결제 도중에 취소하거나 실패해도 쿠폰이 헛되이 소모되지 않음
                markCouponUsed(orNo);
                showToast('결제가 완료되었어요.', 'success');
            } else {
                document.getElementById('btnPay').disabled = false;
                showToast(result.message || '결제 승인에 실패했어요.', 'error');
            }
            setTimeout(function () {
                location.href = '/member/order/' + orNo;
            }, 600);
        })
        .catch(() => {
            document.getElementById('btnPay').disabled = false;
            showToast('결제 승인 처리 중 오류가 발생했어요.', 'error');
            setTimeout(function () {
                location.href = '/member/order/' + orNo;
            }, 600);
        });
    }

    function searchAddress() {
        new daum.Postcode({
            oncomplete: function (data) {
                document.getElementById('orAddress').value = data.roadAddress || data.jibunAddress;
                document.getElementById('orAddrdetail').focus();
            }
        }).open();
    }

    function formatPrice(v) {
        if (v === null || v === undefined) return '0';
        return Number(v).toLocaleString('ko-KR');
    }

    function escapeHtml(str) {
        if (!str) return '';
        return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    }
</script>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>