<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관심상품</title>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
<style>
    .wish-wrap { padding: 24px 20px; max-width: 960px; margin: 0 auto; }
    .wish-title { font-size: 18px; font-weight: 700; margin-bottom: 4px; }
    .wish-title .count {
        display: inline-block; margin-left: 6px; padding: 2px 8px;
        background: #f4a261; color: #fff; border-radius: 999px; font-size: 12px;
    }
    .wish-toolbar {
        display: flex; align-items: center; gap: 14px;
        margin-bottom: 16px; font-size: 13px; color: #666;
    }
    .wish-toolbar label { display: flex; align-items: center; gap: 4px; cursor: pointer; }
    .wish-toolbar-btn {
        border: none; background: none; color: #666; font-size: 13px;
        cursor: pointer; text-decoration: none; padding: 0;
    }
    .wish-toolbar-btn:hover { color: #e74c3c; }
    .wish-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
        gap: 24px;
    }
    .wish-card { position: relative; }
    .wish-select {
        position: absolute; top: 8px; left: 8px; z-index: 2;
        width: 26px; height: 26px; border-radius: 50%;
        background: rgba(255,255,255,0.85); cursor: pointer;
        display: flex; align-items: center; justify-content: center;
    }
    .wish-select input { display: none; }
    .wish-select-heart { width: 16px; height: 16px; color: #bbb; }
    .wish-select input:checked ~ .wish-select-heart {
        color: #e74c3c; fill: #e74c3c;
    }
    .wish-thumb {
        width: 100%;
        aspect-ratio: 1 / 1;
        overflow: hidden;
        background: #f2f2f2;
        cursor: pointer;
    }
    .wish-thumb img { width: 100%; height: 100%; object-fit: cover; display: block; }
    .wish-name {
        margin-top: 10px; font-size: 14px; color: #333; cursor: pointer;
        overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
    }
    .wish-price-row { margin-top: 4px; display: flex; align-items: baseline; gap: 6px; }
    .wish-discount { color: #e74c3c; font-weight: 700; font-size: 14px; }
    .wish-price { font-weight: 700; font-size: 15px; color: #222; }
    .wish-origin-price { color: #aaa; font-size: 12px; text-decoration: line-through; }
    .wish-badges { margin-top: 6px; display: flex; gap: 4px; }
    .wish-badge {
        font-size: 11px; font-weight: 700; color: #fff;
        padding: 2px 6px; border-radius: 3px; background: #e74c3c;
    }
    .wish-heart-count {
        margin-top: 8px;
        display: flex; align-items: center; gap: 4px;
        color: #e08a5b; font-size: 13px;
    }
    .wish-heart-count svg { width: 16px; height: 16px; }
    .wish-checkall input { display: none; }
    .wish-checkall-heart { width: 14px; height: 14px; color: #bbb; }
    .wish-checkall input:checked ~ .wish-checkall-heart {
        color: #e74c3c; fill: #e74c3c;
    }
    .empty-msg { text-align: center; color: #888; padding: 60px 0; }
 
    /* 커스텀 알림/확인 모달 (브라우저 기본 alert/confirm 대체) */
    .wish-modal-overlay {
        display: none; position: fixed; inset: 0; z-index: 1000;
        background: rgba(0,0,0,0.45);
        align-items: center; justify-content: center;
    }
    .wish-modal-overlay.show { display: flex; }
    .wish-modal {
        width: 280px; max-width: 86%;
        background: #fff; border-radius: 16px;
        padding: 28px 22px 18px;
        text-align: center;
        box-shadow: 0 12px 32px rgba(0,0,0,0.18);
        animation: wishModalPop .15s ease-out;
    }
    @keyframes wishModalPop {
        from { opacity: 0; transform: scale(.92); }
        to   { opacity: 1; transform: scale(1); }
    }
    .wish-modal-icon {
        width: 40px; height: 40px; margin: 0 auto 12px;
        color: #e74c3c;
    }
    .wish-modal-msg {
        margin: 0 0 20px; font-size: 14px; line-height: 1.5;
        color: #333; white-space: pre-line;
    }
    .wish-modal-actions { display: flex; gap: 8px; }
    .wish-modal-btn {
        flex: 1; border: none; border-radius: 8px;
        padding: 11px 0; font-size: 14px; font-weight: 700;
        cursor: pointer; transition: background .15s;
    }
    .wish-modal-btn.cancel { background: #f2f2f2; color: #777; }
    .wish-modal-btn.cancel:hover { background: #e6e6e6; }
    .wish-modal-btn.confirm { background: #e74c3c; color: #fff; }
    .wish-modal-btn.confirm:hover { background: #d8432f; }
    .wish-modal-overlay.alert-mode .wish-modal-btn.cancel { display: none; }
</style>
</head>
<body>
 
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
                    <img src="${pageContext.request.contextPath}/images/products/main/${item.PMainImg}" alt="${item.PName}">
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
                    location.reload();
                } else {
                    showAlert(data.message || "삭제 실패");
                }
            })
            .catch(function () {
                showAlert("관심상품 삭제 중 오류가 발생했어요.");
            });
    }
</script>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>