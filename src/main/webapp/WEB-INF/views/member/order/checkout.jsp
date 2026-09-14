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
    <%-- 포트원 V2 브라우저 SDK --%>
    <script src="https://cdn.portone.io/v2/browser-sdk.js"></script>
</head>
<body>
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
                <p class="shoppingbag-subtitle" style="font-size:12px; color:#888; margin-bottom:12px;">
                    선물용 쇼핑백이 필요하다면 함께 담아보세요.
                </p>

                <label class="shoppingbag-box" style="display:flex; align-items:center; gap:12px; cursor:pointer;">
                    <input type="checkbox" id="useShoppingBag" onchange="toggleShoppingBag(this.checked)" style="width:16px; height:16px; flex:none;">

                    <div class="shoppingbag-top" style="display:flex; align-items:center; gap:14px; flex:1;">
                        <img src="${pageContext.request.contextPath}/images/checkout/shopping-bag-pets.png"
                             alt="쇼핑백" class="shoppingbag-img" style="width:75px; height:auto; object-fit:contain; flex:none;">

                        <div class="shoppingbag-info" style="flex:1;">
                            <span class="shoppingbag-badge" style="font-size:10px; background:#fdf3ee; color:#c17a52; padding:2px 6px; border-radius:3px; display:inline-block; margin-bottom:3px; font-weight:600;">SPECIAL EVENT</span>
                            <h4 style="font-size:14px; margin:0 0 2px 0; color:#222; font-weight:700;">멍냥 쇼핑백</h4>
                            <p style="font-size:12px; color:#888; margin:0 0 4px 0;">귀여운 일러스트 쇼핑백</p>
                            <strong class="shoppingbag-price" style="font-size:13px; color:#222;">500원 / 1개</strong>
                        </div>
                    </div>
                </label>

                <div class="co-bag-qty-row" id="bagQtyRow" style="display:none; align-items:center; gap:10px; margin-top:14px; padding-top:12px; border-top:1px solid #f2f2f2;">
                    <span style="font-size:12px; color:#666;">수량 선택</span>
                    <div style="display:flex; align-items:center; gap:6px; margin-left:auto;">
                        <button type="button" class="co-btn co-bag-btn" onclick="changeBagQty(-1)">-</button>
                        <span id="bagQtyDisplay" style="font-size:13px; font-weight:700;">1</span>개
                        <button type="button" class="co-btn co-bag-btn" onclick="changeBagQty(1)">+</button>
                    </div>
                    <span id="bagAmountText" class="co-bag-amount" style="font-size:13px; font-weight:700; color:#c17a52; margin-left:10px;">500원</span>
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
                    <input type="checkbox" id="agreeTerms">
                    구매조건 확인 및 결제진행 동의
                </label>
                <button type="button" class="co-btn-pay" id="btnPay" onclick="requestOrder()">결제하기</button>
            </div>
        </div>
    </div>
    </form>
</div>

<script>
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
        }, 2500);
    }

    var memberInfo = {
        name: document.getElementById('memberName').value,
        tel: document.getElementById('memberTel').value,
        addr: document.getElementById('memberAddr').value,
        addrDetail: document.getElementById('memberAddrDetail').value
    };

    const productAmountVal = ${productAmount};
    const shippingFeeVal = ${shippingFee};
    const finalAmountVal = ${finalAmount};
    const usablePointVal = ${usablePoint};
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
    var usableCouponList = [];   // /coupon/usable 조회 결과
    var selectedCoupon = null;   // 현재 선택된 쿠폰

    // 사용 가능한(미사용 + 만료전) 보유쿠폰 목록 조회
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
            html += '<option value="' + c.mcNo + '">' + escapeHtml(label) + '</option>';
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
            row.style.display = 'block';
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
            var termsCheck = document.querySelector('.co-terms-check');
            termsCheck.classList.add('co-terms-error', 'co-terms-shake');
            setTimeout(function () { termsCheck.classList.remove('co-terms-shake'); }, 400);
            btnPay.disabled = false;
            return;
        }

        const payMethodEl = document.querySelector('input[name="orMethod"]:checked');

        if (V2_UNSUPPORTED_METHODS.includes(payMethodEl.value)) {
            showToast('아직 준비 중인 결제수단이에요.', 'error');
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
                markCouponUsed(result.data).then(function () {
                    startPayment(result.data, payMethodEl.value);
                });
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
            if (result.success) {
                showToast('결제가 완료되었어요.', 'success');
                setTimeout(function () { location.href = '/member/order/' + orNo; }, 800);
            } else {
                document.getElementById('btnPay').disabled = false;
                showToast(result.message || '결제 승인에 실패했어요.', 'error');
                setTimeout(function () { location.href = '/member/order/' + orNo; }, 1200);
            }
        })
        .catch(() => {
            document.getElementById('btnPay').disabled = false;
            showToast('결제 승인 처리 중 오류가 발생했어요.', 'error');
            setTimeout(function () { location.href = '/member/order/' + orNo; }, 1200);
        });
    }

    // 보유 포인트 초과 입력 시 입력창 빨간 테두리로 표시
    (function bindUsePointValidation() {
        var usePointInput = document.getElementById('usePoint');
        if (!usePointInput) return;
        usePointInput.addEventListener('input', function () {
            var val = parseInt(usePointInput.value || '0', 10);
            var max = parseInt(usePointInput.getAttribute('max') || '0', 10);
            if (val > max) {
                usePointInput.classList.add('co-point-error');
            } else {
                usePointInput.classList.remove('co-point-error');
            }
        });
    })();

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