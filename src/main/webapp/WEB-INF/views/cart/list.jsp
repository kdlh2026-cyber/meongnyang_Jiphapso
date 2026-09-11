<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>장바구니</title>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp"%>
<link rel="stylesheet" href="/css/cart/cart_list.css">
</head>
<body>

	<c:choose>
		<%-- 장바구니가 비어있는 경우 --%>
		<c:when test="${empty cartList}">
			<div class="empty">
				🛒 장바구니가 비어있어요
				<div>
					<a href="/products/ShoppingList" class="submit">쇼핑하러 가기</a>
				</div>
			</div>
		</c:when>

		<%-- 장바구니에 상품이 있는 경우 --%>
		<c:otherwise>

			<div class="cart-page" id="cartContent">

				<div class="cart-main">
					<div class="cart-topbar">
						<h2 class="cart-title">
							장바구니<span class="count-badge" id="cartCountBadge">${fn:length(cartList)}</span>
						</h2>
						<div class="cart-actions">
							<button type="button" onclick="deleteSelected()">선택 삭제</button>
							<button type="button" onclick="deleteSoldOut()">품절 삭제</button>
						</div>
					</div>

					<div class="cart-selectall">
						<input type="checkbox" id="checkAll"> <label
							for="checkAll">전체선택</label>
					</div>

					<div class="free-shipping-banner" id="freeShippingBanner"
						onclick="goShopping()">
						<span><span class="fs-icon">🚚</span><span
							id="freeShippingMsg"></span></span> <span class="fs-arrow">›</span>
					</div>

					<c:set var="totalAmount" value="${0}" />
					<div class="cart-list">
						<c:forEach var="cart" items="${cartList}">
							<c:set var="lineAmount" value="${cart.OPrice * cart.caQuantity}" />
							<c:set var="totalAmount" value="${totalAmount + lineAmount}" />
							<c:set var="isSoldOut"
								value="${empty cart.OQuantity or cart.OQuantity le 0}" />

							<div class="cart-row" data-cano="${cart.caNo}"
								data-price="${cart.OPrice}" data-soldout="${isSoldOut}">
								<input type="checkbox" class="item-check row-check"
									value="${cart.caNo}">

								<div class="cart-thumb" onclick="goDetail(${cart.PNo})">
									<img
										src="${pageContext.request.contextPath}/images/products/main/${cart.PMainImg}"
										alt="${cart.PName}">
								</div>

								<div class="cart-info">
									<div class="cart-name" onclick="goDetail(${cart.PNo})">${cart.PName}</div>

									<c:if test="${not empty cart.OName}">
										<div class="cart-option">
											<span class="req-tag">필수</span> <span>${cart.OName}</span>
											<button type="button" class="opt-icon" title="옵션 변경"
												onclick="openOptionModal(${cart.caNo}, ${cart.PNo}, ${cart.caQuantity})">✎</button>
											<button type="button" class="opt-icon" title="이 옵션 삭제"
												onclick="deleteCart(${cart.caNo})">✕</button>
										</div>
									</c:if>

									<div class="cart-bottom-row">
										<div class="qty-box">
											<button type="button"
												onclick="changeQuantity(${cart.caNo}, -1)">-</button>
											<span id="qty-${cart.caNo}" data-qty="${cart.caQuantity}">${cart.caQuantity}</span>
											<button type="button"
												onclick="changeQuantity(${cart.caNo}, 1)">+</button>
										</div>
										<div class="cart-price">
											<fmt:formatNumber value="${lineAmount}" pattern="#,##0" />
											원
										</div>
									</div>
								</div>

								<button type="button" class="cart-buynow"
									onclick="buyNow(${cart.caNo})">바로구매</button>

								<div class="cart-shipping">
									<span class="free ship-free" style="display: none;">무료</span> <span>택배</span>
								</div>
							</div>
						</c:forEach>
					</div>
				</div>

				<div class="cart-summary">
					<p class="cart-summary-title">주문 예상 금액</p>
					<div class="cart-summary-row">
						<span>총 상품 금액</span> <span id="summaryProductAmount"><fmt:formatNumber
								value="${totalAmount}" pattern="#,##0" />원</span>
					</div>
					<div class="cart-summary-row">
						<span>배송비</span> <span id="summaryShippingFee">무료</span>
					</div>
					<p class="cart-summary-shipping-hint" id="summaryShippingHint"></p>
					<div class="cart-summary-total">
						<span>총 주문금액</span> <span class="amt" id="totalAmount"><fmt:formatNumber
								value="${totalAmount}" pattern="#,##0" />원</span>
					</div>

					<div class="cart-summary-buttons">
						<button type="button" class="btn-order" onclick="goCheckout()">
							주문하기 <span class="count" id="checkoutCount">${fn:length(cartList)}</span>
						</button>
					</div>

					<p class="cart-summary-note">쿠폰 적용 혹은 포인트 여부에 따라 예상 결제금액이 달라질 수
						있어요.</p>
				</div>

			</div>

			<div class="empty" id="emptyState" style="display: none;">
				🛒 장바구니가 비어있어요.
				<div>
					<a href="/products/ShoppingList" class="submit">쇼핑하러 가기</a>
				</div>
			</div>

		</c:otherwise>

	</c:choose>

	<%-- 옵션 변경 모달 (연필 아이콘 클릭 시) --%>
	<div class="opt-modal-overlay" id="optionModalOverlay">
		<div class="opt-modal">
			<button type="button" class="opt-modal-close"
				onclick="closeOptionModal()">&times;</button>
			<h3>옵션 변경</h3>

			<div class="opt-modal-product">
				<img id="optModalThumb" src="" alt="">
				<div>
					<p id="optModalName" class="opt-modal-pname"></p>
					<p id="optModalPrice" class="opt-modal-pprice"></p>
				</div>
			</div>

			<div class="opt-modal-row" id="optModalColorRow">
				<label>색상 <span class="req">*</span></label> <select
					id="optModalColor" onchange="onOptionSelectChange()"></select>
			</div>
			<div class="opt-modal-row" id="optModalSizeRow">
				<label>사이즈 <span class="req">*</span></label> <select
					id="optModalSize" onchange="onOptionSelectChange()"></select>
			</div>

			<div class="opt-modal-selected" id="optModalSelectedBox"
				style="display: none;">
				<div class="opt-modal-selected-top">
					<span id="optModalSelectedLabel"></span>
					<button type="button" onclick="clearOptionSelection()">&times;</button>
				</div>
				<div class="opt-modal-selected-bottom">
					<div class="qty-box">
						<button type="button" onclick="optModalChangeQty(-1)">-</button>
						<span id="optModalQty">1</span>
						<button type="button" onclick="optModalChangeQty(1)">+</button>
					</div>
					<span id="optModalLinePrice">0원</span>
				</div>
			</div>

			<div class="opt-modal-total">
				<span>총수량 <span id="optModalTotalCount">0</span>개
				</span> <span id="optModalTotal" class="amt">0원</span>
			</div>

			<div class="opt-modal-buttons">
				<button type="button" class="opt-btn-cancel"
					onclick="closeOptionModal()">취소</button>
				<button type="button" class="opt-btn-confirm"
					id="optModalConfirmBtn" disabled onclick="confirmOptionChange()">변경</button>
			</div>
		</div>
	</div>

	<script>
    var contextPath = "${pageContext.request.contextPath}";
    var FREE_SHIPPING_THRESHOLD = 30000;
    var SHIPPING_FEE = 3000;

    document.getElementById('checkAll')?.addEventListener('change', function () {
        document.querySelectorAll('.item-check').forEach(chk => chk.checked = this.checked);
        recalcTotal();
    });

    document.querySelectorAll('.item-check').forEach(function (chk) {
        chk.addEventListener('change', recalcTotal);
    });

    recalcTotal(); // 최초 진입 시에도 무료배송 배너/합계를 바로 채워줌 (recalcTotal은 아래 정의돼 있지만 함수 선언이라 호이스팅됨)

    function goDetail(pNo) {
        location.href = contextPath + '/products/ShoppingView?p_no=' + pNo;
    }

    // 무료배송 배너 클릭 -> 상품 더 담으라고 상품목록 페이지로 이동
    function goShopping() {
        location.href = contextPath + '/products/ShoppingList';
    }

    // ---- 옵션 변경 모달 (CartController#optionList / #updateOption) ----
    var optionModalState = { caNo: null, pNo: null, options: [] };
    var optModalQty = 1;
    var optModalSelected = null;

    function openOptionModal(caNo, pNo, currentQty) {
        optionModalState.caNo = caNo;
        optionModalState.pNo = pNo;

        fetch(contextPath + '/cart/options?pNo=' + pNo)
            .then(res => res.json())
            .then(result => {
                if (!result.success) {
                    alert(result.message || '옵션 정보를 불러오지 못했어요.');
                    return;
                }
                optionModalState.options = result.data || [];
                renderOptionModal(currentQty);
            })
            .catch(() => alert('옵션 정보를 불러오는 중 오류가 발생했어요.'));
    }

    function renderOptionModal(currentQty) {
        var row = document.querySelector('.cart-row[data-cano="' + optionModalState.caNo + '"]');
        var name = row ? row.querySelector('.cart-name').textContent.trim() : '';
        var img = row ? row.querySelector('.cart-thumb img').src : '';

        document.getElementById('optModalThumb').src = img;
        document.getElementById('optModalName').textContent = name;

        var options = optionModalState.options;
        var colors = Array.from(new Set(options.map(o => o.oColor).filter(Boolean)));
        var sizes = Array.from(new Set(options.map(o => o.oTypeSize).filter(Boolean)));

        var colorSel = document.getElementById('optModalColor');
        var sizeSel = document.getElementById('optModalSize');
        colorSel.innerHTML = '<option value="">색상 (필수)</option>' +
            colors.map(c => '<option value="' + c + '">' + c + '</option>').join('');
        sizeSel.innerHTML = '<option value="">사이즈 (필수)</option>' +
            sizes.map(s => '<option value="' + s + '">' + s + '</option>').join('');

        document.getElementById('optModalColorRow').style.display = colors.length ? 'block' : 'none';
        document.getElementById('optModalSizeRow').style.display = sizes.length ? 'block' : 'none';
        document.getElementById('optModalPrice').textContent =
            options.length ? formatNumber(options[0].oPrice) + '원' : '';

        optModalQty = currentQty || 1;
        optModalSelected = null;
        updateOptionSelectionUI();

        document.getElementById('optionModalOverlay').classList.add('show');
    }

    function findMatchingOption() {
        var options = optionModalState.options;
        var color = document.getElementById('optModalColor').value;
        var size = document.getElementById('optModalSize').value;
        var colorsExist = options.some(o => o.oColor);
        var sizesExist = options.some(o => o.oTypeSize);

        if (colorsExist && !color) return null;
        if (sizesExist && !size) return null;

        return options.find(o =>
            (!colorsExist || o.oColor === color) &&
            (!sizesExist || o.oTypeSize === size)
        ) || null;
    }

    function onOptionSelectChange() {
        optModalSelected = findMatchingOption();
        updateOptionSelectionUI();
    }

    function updateOptionSelectionUI() {
        var box = document.getElementById('optModalSelectedBox');
        var confirmBtn = document.getElementById('optModalConfirmBtn');

        if (!optModalSelected) {
            box.style.display = 'none';
            confirmBtn.disabled = true;
            document.getElementById('optModalTotalCount').textContent = '0';
            document.getElementById('optModalTotal').textContent = '0원';
            return;
        }

        box.style.display = 'block';
        confirmBtn.disabled = false;

        var label = [
            optModalSelected.oColor ? ('색상: ' + optModalSelected.oColor) : null,
            optModalSelected.oTypeSize ? ('사이즈: ' + optModalSelected.oTypeSize) : null
        ].filter(Boolean).join(' / ');

        document.getElementById('optModalSelectedLabel').textContent = label;
        document.getElementById('optModalQty').textContent = optModalQty;
        document.getElementById('optModalLinePrice').textContent = formatNumber(optModalSelected.oPrice * optModalQty) + '원';
        document.getElementById('optModalTotalCount').textContent = optModalQty;
        document.getElementById('optModalTotal').textContent = formatNumber(optModalSelected.oPrice * optModalQty) + '원';
    }

    function optModalChangeQty(diff) {
        if (!optModalSelected) return;
        optModalQty = Math.max(1, optModalQty + diff);
        updateOptionSelectionUI();
    }

    function clearOptionSelection() {
        optModalSelected = null;
        document.getElementById('optModalColor').value = '';
        document.getElementById('optModalSize').value = '';
        updateOptionSelectionUI();
    }

    function closeOptionModal() {
        document.getElementById('optionModalOverlay').classList.remove('show');
    }

    function confirmOptionChange() {
        if (!optModalSelected) return;

        fetch(contextPath + '/cart/' + optionModalState.caNo + '/option', {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ oNo: optModalSelected.oNo, quantity: optModalQty })
        })
            .then(res => res.json())
            .then(result => {
                if (!result.success) {
                    alert(result.message || '옵션 변경에 실패했어요.');
                    return;
                }
                closeOptionModal();
                location.reload(); // 이미지/가격/옵션명이 바뀔 수 있어 목록을 다시 불러옴
            })
            .catch(() => alert('옵션 변경 중 오류가 발생했어요.'));
    }

    function notReady() {
        alert('현재 준비 중인 기능이에요.');
    }

    function formatNumber(num) {
        return Math.round(num).toLocaleString('ko-KR');
    }

    function updateFreeShippingBanner(total) {
        total = Number(total) || 0; // 계산값이 NaN/undefined로 들어와도 배너가 깨지지 않게 방어
        var isFree = total >= FREE_SHIPPING_THRESHOLD;
        var shippingFee = isFree ? 0 : SHIPPING_FEE;

        var banner = document.getElementById('freeShippingBanner');
        var msgEl = document.getElementById('freeShippingMsg');
        if (banner && msgEl) {
            if (isFree) {
                banner.classList.add('achieved');
                msgEl.innerHTML = '무료배송 조건을 달성했어요!';
            } else {
                banner.classList.remove('achieved');
                var remaining = FREE_SHIPPING_THRESHOLD - total;
                msgEl.innerHTML = '상품 <strong>' + formatNumber(remaining) + '원</strong> 더 담으면 무료배송! ' +
                    '상품은 ' + formatNumber(FREE_SHIPPING_THRESHOLD) + '원 이상 구매 시 무료배송이에요.';
            }
        }
        document.querySelectorAll('.ship-free').forEach(function (el) {
            el.style.display = isFree ? 'block' : 'none';
        });

        var feeEl = document.getElementById('summaryShippingFee');
        if (feeEl) feeEl.textContent = isFree ? '무료' : (formatNumber(shippingFee) + '원');

        var hintEl = document.getElementById('summaryShippingHint');
        if (hintEl) {
            hintEl.classList.toggle('achieved', isFree);
            hintEl.textContent = isFree
                ? '무료배송 조건을 달성했어요'
                : formatNumber(FREE_SHIPPING_THRESHOLD - total) + '원 더 담으면 무료배송';
        }

        return shippingFee;
    }

    // 선택된(체크된) 상품 기준으로 요약 영역(총 상품 금액/총 주문금액/주문하기 개수) 갱신
    function recalcTotal() {
        let total = 0;
        let checkedCount = 0;

        document.querySelectorAll('.cart-row').forEach(row => {
            const checkbox = row.querySelector('.item-check');
            if (!checkbox || !checkbox.checked) return;

            const price = Number(row.dataset.price) || 0;
            const qtySpan = row.querySelector('span[id^="qty-"]');
            const qty = (qtySpan ? Number(qtySpan.dataset.qty) : 0) || 0; // qtySpan이 없어도 NaN 안 나게 방어
            total += price * qty;
            checkedCount++;
        });

        const summaryProductEl = document.getElementById('summaryProductAmount');
        const totalEl = document.getElementById('totalAmount');
        const checkoutCountEl = document.getElementById('checkoutCount');
        if (summaryProductEl) summaryProductEl.textContent = formatNumber(total) + '원';
        if (checkoutCountEl) checkoutCountEl.textContent = checkedCount;

        // 배너/배송비 안내 갱신 + 이번 배송비 반환받아서 총 주문금액(상품금액 + 배송비)에 반영
        const shippingFee = updateFreeShippingBanner(total);
        if (totalEl) totalEl.textContent = formatNumber(total + shippingFee) + '원';

        const rows = document.querySelectorAll('.cart-row');
        const cartCountBadge = document.getElementById('cartCountBadge');
        if (cartCountBadge) cartCountBadge.textContent = rows.length;

        if (rows.length === 0) {
            document.getElementById('cartContent').style.display = 'none';
            document.getElementById('emptyState').style.display = 'block';
        }
    }

    function changeQuantity(caNo, diff) {
        const span = document.getElementById('qty-' + caNo);
        let quantity = Number(span.dataset.qty) + diff;
        if (quantity < 1) quantity = 1;

        fetch(contextPath + '/cart/' + caNo + '/quantity', {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ quantity: quantity })
        })
        .then(res => res.json())
        .then(res => {
            if (res.success) {
                span.dataset.qty = quantity;
                span.textContent = quantity;

                const row = span.closest('.cart-row');
                const price = Number(row.dataset.price) || 0;
                const priceEl = row.querySelector('.cart-price');
                if (priceEl) priceEl.textContent = formatNumber(price * quantity) + '원';

                recalcTotal();
            } else {
                alert(res.message || '수량 변경에 실패했어요.');
            }
        });
    }

    function deleteCart(caNo) {
        if (!confirm('장바구니에서 삭제할까요?')) return;

        fetch(contextPath + '/cart/' + caNo, { method: 'DELETE' })
            .then(res => res.json())
            .then(res => {
                if (res.success) {
                    document.querySelector('.cart-row[data-cano="' + caNo + '"]')?.remove();
                    recalcTotal();
                } else {
                    alert(res.message || '삭제에 실패했어요.');
                }
            });
    }

    // 선택삭제 / 품절삭제 공용 삭제 요청
    function deleteCartList(caNoList, onDone) {
        fetch(contextPath + '/cart', {
            method: 'DELETE',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(caNoList)
        })
        .then(res => res.json())
        .then(res => {
            if (res.success) {
                caNoList.forEach(caNo => {
                    document.querySelector('.cart-row[data-cano="' + caNo + '"]')?.remove();
                });
                recalcTotal();
                if (onDone) onDone();
            } else {
                alert(res.message || '삭제에 실패했어요.');
            }
        });
    }

    function deleteSelected() {
        const caNoList = Array.from(document.querySelectorAll('.item-check:checked'))
            .map(chk => Number(chk.value));

        if (caNoList.length === 0) {
            alert('삭제할 상품을 선택해주세요.');
            return;
        }
        if (!confirm(caNoList.length + '개 상품을 삭제할까요?')) return;

        deleteCartList(caNoList);
    }

    // 품절된(재고 0) 상품만 골라서 삭제
    function deleteSoldOut() {
        const caNoList = Array.from(document.querySelectorAll('.cart-row[data-soldout="true"]'))
            .map(row => Number(row.dataset.cano));

        if (caNoList.length === 0) {
            alert('품절된 상품이 없습니다.');
            return;
        }
        if (!confirm('품절된 상품 ' + caNoList.length + '개를 삭제할까요?')) return;

        deleteCartList(caNoList);
    }

    function goCheckout() {
        const caNoList = Array.from(document.querySelectorAll('.item-check:checked'))
            .map(chk => chk.value);

        if (caNoList.length === 0) {
            alert('주문할 상품을 선택해주세요.');
            return;
        }
        location.href = contextPath + '/member/order/checkout?caNo=' + caNoList.join(',');
    }

    // 바로구매: 이 상품 하나만 바로 주문서로 이동
    function buyNow(caNo) {
        location.href = contextPath + '/member/order/checkout?caNo=' + caNo;
    }
</script>
	<%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>
