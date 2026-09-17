<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<script>
(function () {
    if (!document.getElementById('favoriteListCss')) {
        var link = document.createElement('link');
        link.id = 'favoriteListCss';
        link.rel = 'stylesheet';
        link.href = '${pageContext.request.contextPath}/css/favorite/list.css';
        document.head.appendChild(link);
    }
})();
</script>

<div class="wish-wrap">
    <div class="wish-title">관심상품<span class="count">${fn:length(favoriteList)}</span></div>

    <c:choose>
        <c:when test="${empty favoriteList}">
            <p class="empty-msg">♥ 관심상품이 없습니다.</p>
        </c:when>
        <c:otherwise>
        <div class="wish-toolbar">
            <label class="wish-checkall">
                <input type="checkbox" id="checkAll">
                <svg class="wish-checkall-heart" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M12 21s-6.716-4.35-9.428-8.51C.665 9.62 1.6 6 4.708 4.79 7.06 3.87 9.5 4.77 12 7.5c2.5-2.73 4.94-3.63 7.292-2.71C22.4 6 23.335 9.62 21.428 12.49 18.716 16.65 12 21 12 21z"/>
                </svg>
                전체선택
            </label>
            <button type="button" class="wish-toolbar-btn" onclick="deleteSelected()">선택삭제</button>
            <button type="button" class="wish-toolbar-btn" onclick="deleteAll()">전체삭제</button>
        </div>
        <div class="wish-grid">
        <c:forEach var="item" items="${favoriteList}">
            <c:set var="discountRate" value="${0}" />
            <c:if test="${not empty item.OOriginPrice and item.OOriginPrice gt item.OPrice}">
                <c:set var="discountRate" value="${(item.OOriginPrice - item.OPrice) * 100 / item.OOriginPrice}" />
            </c:if>

            <div class="wish-card" data-fano="${item.faNo}">
                <label class="wish-select">
                    <input type="checkbox" class="wish-check" value="${item.faNo}">
                    <svg class="wish-select-heart" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M12 21s-6.716-4.35-9.428-8.51C.665 9.62 1.6 6 4.708 4.79 7.06 3.87 9.5 4.77 12 7.5c2.5-2.73 4.94-3.63 7.292-2.71C22.4 6 23.335 9.62 21.428 12.49 18.716 16.65 12 21 12 21z"/>
                    </svg>
                </label>
                <div class="wish-thumb" onclick="removeFavorite(${item.faNo}, this)">
                    <img src="${pageContext.request.contextPath}/images/products/main/${fn:replace(item.PMainImg, '%', '%25')}" alt="${item.PName}">
                </div>
                <div class="wish-name" onclick="goDetail(${item.PNo})">${item.PName}</div>
                <div class="wish-price-row">
                    <c:if test="${discountRate > 0}">
                        <span class="wish-discount"><fmt:formatNumber value="${discountRate}" maxFractionDigits="0"/>%</span>
                    </c:if>
                    <span class="wish-price"><fmt:formatNumber value="${item.OPrice}" pattern="#,###"/>원</span>
                    <c:if test="${discountRate > 0}">
                        <span class="wish-origin-price"><fmt:formatNumber value="${item.OOriginPrice}" pattern="#,###"/>원</span>
                    </c:if>
                </div>
                <c:if test="${discountRate > 0}">
                    <div class="wish-badges"><span class="wish-badge">SALE</span></div>
                </c:if>
                <div class="wish-heart-count">
                    <svg viewBox="0 0 24 24" fill="currentColor" stroke="none">
                        <path d="M12 21s-6.716-4.35-9.428-8.51C.665 9.62 1.6 6 4.708 4.79 7.06 3.87 9.5 4.77 12 7.5c2.5-2.73 4.94-3.63 7.292-2.71C22.4 6 23.335 9.62 21.428 12.49 18.716 16.65 12 21 12 21z"/>
                    </svg>
                    <span>${item.favoriteCount}</span>
                </div>
            </div>
        </c:forEach>
        </div>
        </c:otherwise>
    </c:choose>
</div>

<%-- 커스텀 알림/확인 모달 (alert/confirm 대체) --%>
<div class="wish-modal-overlay" id="wishModalOverlay">
    <div class="wish-modal">
        <svg class="wish-modal-icon" viewBox="0 0 24 24" fill="currentColor" stroke="none">
            <path d="M12 21s-6.716-4.35-9.428-8.51C.665 9.62 1.6 6 4.708 4.79 7.06 3.87 9.5 4.77 12 7.5c2.5-2.73 4.94-3.63 7.292-2.71C22.4 6 23.335 9.62 21.428 12.49 18.716 16.65 12 21 12 21z"/>
        </svg>
        <p class="wish-modal-msg" id="wishModalMsg"></p>
        <div class="wish-modal-actions">
            <button type="button" class="wish-modal-btn cancel" id="wishModalCancel">취소</button>
            <button type="button" class="wish-modal-btn confirm" id="wishModalConfirm">확인</button>
        </div>
    </div>
</div>

<script>
    var contextPath = "${pageContext.request.contextPath}";

    document.getElementById('checkAll')?.addEventListener('change', function () {
        document.querySelectorAll('.wish-check').forEach(function (cb) { cb.checked = this.checked; }, this);
    });

    function goDetail(pNo) {
        location.href = contextPath + "/products/ShoppingView?p_no=" + pNo;
    }

    // ---- 커스텀 알림/확인 모달 (브라우저 기본 alert/confirm 대체) ----
    function openWishModal(message, isConfirm) {
        return new Promise(function (resolve) {
            var overlay = document.getElementById("wishModalOverlay");
            document.getElementById("wishModalMsg").textContent = message;
            overlay.classList.toggle("alert-mode", !isConfirm);
            overlay.classList.add("show");

            var confirmBtn = document.getElementById("wishModalConfirm");
            var cancelBtn = document.getElementById("wishModalCancel");

            function cleanup(result) {
                overlay.classList.remove("show");
                confirmBtn.removeEventListener("click", onConfirm);
                cancelBtn.removeEventListener("click", onCancel);
                overlay.removeEventListener("click", onOverlayClick);
                resolve(result);
            }
            function onConfirm() { cleanup(true); }
            function onCancel() { cleanup(false); }
            function onOverlayClick(e) { if (e.target === overlay) cleanup(false); }

            confirmBtn.addEventListener("click", onConfirm);
            cancelBtn.addEventListener("click", onCancel);
            overlay.addEventListener("click", onOverlayClick);
        });
    }
    function showAlert(message) { return openWishModal(message, false); }
    function showConfirm(message) { return openWishModal(message, true); }

    // 상품 이미지 클릭 = 관심상품에서 제거 (FavoriteController#deleteFavorite - DELETE /favorite/{faNo})
    async function removeFavorite(faNo, el) {
        var ok = await showConfirm("관심상품에서 삭제할까요?");
        if (!ok) return;

        fetch(contextPath + "/favorite/" + faNo, { method: "DELETE" })
            .then(function (res) { return res.json(); })
            .then(function (data) {
                if (data.success) {
                    var card = el.closest(".wish-card");
                    if (card) card.remove();
                    var countEl = document.querySelector(".wish-title .count");
                    if (countEl) countEl.textContent = document.querySelectorAll(".wish-card").length;
                } else {
                    showAlert(data.message || "삭제 실패");
                }
            })
            .catch(function () {
                showAlert("관심상품 삭제 중 오류가 발생했어요.");
            });
    }

    // 선택삭제 (체크된 것만)
    async function deleteSelected() {
        var faNoList = Array.from(document.querySelectorAll(".wish-check:checked")).map(function (cb) { return Number(cb.value); });
        if (faNoList.length === 0) {
            await showAlert("선택된 상품이 없습니다.");
            return;
        }
        var ok = await showConfirm(faNoList.length + "개 상품을 관심상품에서 삭제할까요?");
        if (!ok) return;
        deleteFavorites(faNoList);
    }

    // 전체삭제 (지금 목록에 보이는 전부)
    async function deleteAll() {
        var faNoList = Array.from(document.querySelectorAll(".wish-check")).map(function (cb) { return Number(cb.value); });
        if (faNoList.length === 0) return;
        var ok = await showConfirm("관심상품을 전체 삭제할까요?");
        if (!ok) return;
        deleteFavorites(faNoList);
    }

    // 선택삭제/전체삭제 공용 (FavoriteController#deleteFavoriteList - DELETE /favorite, body: [faNo, ...])
    function deleteFavorites(faNoList) {
        fetch(contextPath + "/favorite", {
            method: "DELETE",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(faNoList)
        })
            .then(function (res) { return res.json(); })
            .then(function (data) {
                if (data.success) {
                    // 마이페이지 SPA 탭 안에서 실행 중이면 전체 새로고침 대신 이 조각만 다시 불러옴
                    if (typeof loadMpContent === "function" && document.getElementById("mp-content-area")) {
                        loadMpContent(contextPath + "/favorite/list");
                    } else {
                        location.reload();
                    }
                } else {
                    showAlert(data.message || "삭제 실패");
                }
            })
            .catch(function () {
                showAlert("관심상품 삭제 중 오류가 발생했어요.");
            });
    }
</script>