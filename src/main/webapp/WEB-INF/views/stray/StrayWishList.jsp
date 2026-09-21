<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관심동물 목록</title>
<link rel="stylesheet" href="/css/stray/straylist.css">
<link rel="stylesheet" href="/css/stray/wishlist.css">
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>

<div class="wish-page-wrap">
    <div class="wish-header">
        <h2 class="wish-header-title">
            <span>♥ 관심동물</span>
            <span class="count" id="totalCountDisplay">${fn:length(WishList)}</span>
        </h2>
    </div>

    <c:choose>
        <%-- 관심동물이 없을 때 --%>
        <c:when test="${empty WishList}">
            <div class="wish-empty" id="emptyState">
                <div class="wish-empty-icon">♡</div>
                <p class="wish-empty-text">아직 관심동물에 담은 아이가 없어요</p>
                <p class="wish-empty-sub">보호소에서 따뜻한 손길을 기다리는 아이들을 만나보세요.</p>
                <a href="${pageContext.request.contextPath}/stray/StrayList" class="btn-go-stray">유기동물 보러가기</a>
            </div>
        </c:when>

        <%-- 관심동물이 있을 때 --%>
        <c:otherwise>
            <div class="wish-toolbar" id="wishToolbar">
                <label class="wish-checkall">
                    <input type="checkbox" id="checkAll" onchange="toggleAllCheckboxes(this)">
                    <span>전체선택</span>
                </label>
                <div class="wish-toolbar-actions">
                    <button type="button" class="wish-btn-action" onclick="deleteSelected()">선택삭제</button>
                    <button type="button" class="wish-btn-action danger" onclick="deleteAll()">전체삭제</button>
                </div>
            </div>

            <div class="stray-grid-wrap" id="wishGridWrap">
                <div class="stray-card-grid">
                    <c:forEach var="list" items="${WishList}">
                        <c:set var="currentYear" value="<%= java.time.LocalDate.now().getYear() %>" />
                        <c:set var="age" value="${currentYear - list.stray_age}" />
                        <c:set var="addrParts" value="${fn:split(list.stray_shelter_addr, ' ')}" />

                        <c:set var="cardImg" value="${fn:replace(list.stray_img, '[', '%5B')}" />
                        <c:set var="cardImg" value="${fn:replace(cardImg, ']', '%5D')}" />

                        <div class="stray-card wish-card" id="card-${list.stray_no}" data-stray-no="${list.stray_no}">
                            <!-- 체크박스 -->
                            <label class="card-select-label">
                                <input type="checkbox" class="wish-item-check" value="${list.stray_no}" onchange="updateCheckAllState()">
                            </label>

                            <div class="card-thumb-wrap">
                                <div class="card-thumb">
                                    <c:choose>
                                        <c:when test="${empty list.stray_img}">
                                            <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 200 200' width='100%25' height='100%25'%3E%3Crect width='100%25' height='100%25' fill='%23f0f0f0'/%3E%3Ctext x='50%25' y='50%25' dominant-baseline='middle' text-anchor='middle' fill='%23aaa' font-size='14'%3E이미지 준비중%3C/text%3E%3C/svg%3E" alt="준비중">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="/uploadImages/${cardImg}"
                                                 alt="${list.stray_name}" 
                                                 loading="lazy"
                                                 onerror="this.onerror=null; this.src='data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' viewBox=\'0 0 200 200\' width=\'100%25\' height=\'100%25\'%3E%3Crect width=\'100%25\' height=\'100%25\' fill=\'%23f0f0f0\'/%3E%3Ctext x=\'50%25\' y=\'50%25\' dominant-baseline=\'middle\' text-anchor=\'middle\' fill=\'%23aaa\' font-size=\'14\'%3E이미지 없음%3C/text%3E%3C/svg%3E';">
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="card-body">
                                <span class="badge-status">${list.stray_status}</span>
                                <div class="card-title">
                                    <a href="/stray/StrayView?stray_no=${list.stray_no}">
                                        <c:choose>
                                            <c:when test="${list.stray_category == 'DOG'}">[강아지] </c:when>
                                            <c:when test="${list.stray_category == 'CAT'}">[고양이] </c:when>
                                        </c:choose>
                                        ${list.stray_name}
                                    </a>
                                    <span class="divider">|</span>
                                    <span>
                                        <c:choose>
                                            <c:when test="${age <= 0}">1살 미만</c:when>
                                            <c:otherwise>${age}살</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>

                                <div class="card-info">
                                    <c:choose>
                                        <c:when test="${list.stray_gender == 'M'}">남아</c:when>
                                        <c:when test="${list.stray_gender == 'F'}">여아</c:when>
                                        <c:otherwise>미상</c:otherwise>
                                    </c:choose>
                                    <c:choose>
                                        <c:when test="${list.stray_neuter == 'Y'}"> · 중성화 완료</c:when>
                                        <c:when test="${list.stray_neuter == 'N'}"> · 중성화 미완료</c:when>
                                        <c:otherwise> · 중성화 미상</c:otherwise>
                                    </c:choose>
                                </div>

                                <!-- 하트 버튼 (클릭 시 관심목록에서 즉시 제거) -->
                                <button type="button" class="wish-btn active" title="관심동물 해제" onclick="removeSingleWish(${list.stray_no})">♥</button>
                            </div>

                            <div class="card-footer">
                                <div class="card-addr">
                                    지역 : ${addrParts[0]} ${addrParts[1]}
                                </div>
                                <c:choose>
                                    <c:when test="${list.stray_category == 'DOG'}">
                                        <img class="peek-character" src="/images/stray/menu/stray-dog.png" alt="강아지">
                                    </c:when>
                                    <c:when test="${list.stray_category == 'CAT'}">
                                        <img class="peek-character" src="/images/stray/menu/stray-cat.png" alt="고양이">
                                    </c:when>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- 전체 삭제되었을 때 노출될 빈 화면 -->
            <div class="wish-empty" id="dynamicEmptyState" style="display: none;">
                <div class="wish-empty-icon">♡</div>
                <p class="wish-empty-text">모든 관심동물이 삭제되었습니다.</p>
                <p class="wish-empty-sub">보호소에서 따뜻한 손길을 기다리는 아이들을 만나보세요.</p>
                <a href="${pageContext.request.contextPath}/stray/StrayList" class="btn-go-stray">유기동물 보러가기</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- 토스트 알림창 -->
<div id="globalToast">
    <span class="toast-icon"></span>
    <span class="toast-msg"></span>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>

<script>
// 전체선택 체크박스 토글
function toggleAllCheckboxes(masterCheckbox) {
    const checkboxes = document.querySelectorAll('.wish-item-check');
    checkboxes.forEach(cb => {
        cb.checked = masterCheckbox.checked;
    });
}

// 개별 체크박스 상태 변경 시 전체선택 체크박스 동기화
function updateCheckAllState() {
    const checkboxes = document.querySelectorAll('.wish-item-check');
    const master = document.getElementById('checkAll');
    if (!master || checkboxes.length === 0) return;
    
    const checkedCount = document.querySelectorAll('.wish-item-check:checked').length;
    master.checked = (checkedCount === checkboxes.length);
}

// 단일 삭제 (하트 버튼 클릭)
async function removeSingleWish(strayNo) {
    try {
        const res = await fetch('/api/wish/toggle', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ stray_no: strayNo })
        });
        
        if (!res.ok) throw new Error('요청 실패');
        
        removeCardElement(strayNo);
        showToast('♡', '관심동물에서 제외되었습니다.');
    } catch (err) {
        console.error(err);
        showToast('!', '삭제 중 오류가 발생했습니다.');
    }
}

// 선택 삭제
async function deleteSelected() {
    const selected = document.querySelectorAll('.wish-item-check:checked');
    if (selected.length === 0) {
        alert('삭제할 동물을 선택해주세요.');
        return;
    }

    if (!confirm(selected.length + '마리의 아이를 관심동물에서 삭제하시겠습니까?')) {
        return;
    }

    const strayNos = Array.from(selected).map(cb => Number(cb.value));

    try {
        await Promise.all(strayNos.map(no => 
            fetch('/api/wish/toggle', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ stray_no: no })
            })
        ));

        strayNos.forEach(no => removeCardElement(no));
        showToast('✓', '선택한 동물이 삭제되었습니다.');
    } catch (err) {
        console.error(err);
        showToast('!', '선택 삭제 중 오류가 발생했습니다.');
    }
}

// 전체 삭제
async function deleteAll() {
    const allCards = document.querySelectorAll('.wish-card');
    if (allCards.length === 0) return;

    if (!confirm('관심동물 목록을 전체 삭제하시겠습니까?')) {
        return;
    }

    const strayNos = Array.from(allCards).map(card => Number(card.getAttribute('data-stray-no')));

    try {
        await Promise.all(strayNos.map(no => 
            fetch('/api/wish/toggle', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ stray_no: no })
            })
        ));

        strayNos.forEach(no => removeCardElement(no));
        showToast('✓', '전체 목록이 삭제되었습니다.');
    } catch (err) {
        console.error(err);
        showToast('!', '전체 삭제 중 오류가 발생했습니다.');
    }
}

// 카드 삭제 애니메이션 및 카운트/빈 화면 갱신
function removeCardElement(strayNo) {
    const card = document.getElementById('card-' + strayNo);
    if (!card) return;

    card.style.opacity = '0';
    card.style.transform = 'scale(0.9)';
    
    setTimeout(() => {
        card.remove();
        
        const remainingCards = document.querySelectorAll('.wish-card');
        const countDisplay = document.getElementById('totalCountDisplay');
        if (countDisplay) {
            countDisplay.textContent = remainingCards.length;
        }

        if (remainingCards.length === 0) {
            document.getElementById('wishToolbar')?.remove();
            document.getElementById('wishGridWrap')?.remove();
            const dynEmpty = document.getElementById('dynamicEmptyState');
            if (dynEmpty) dynEmpty.style.display = 'block';
        } else {
            updateCheckAllState();
        }
    }, 250);
}

// 토스트 메시지
let toastTimer = null;
function showToast(icon, message) {
    const toast = document.getElementById('globalToast');
    if (!toast) return;
    
    const toastIcon = toast.querySelector('.toast-icon');
    const toastMsg = toast.querySelector('.toast-msg');

    if (toastIcon) toastIcon.textContent = icon;
    if (toastMsg) toastMsg.textContent = message;

    toast.style.display = 'flex';
    if (toastTimer) clearTimeout(toastTimer);
    toastTimer = setTimeout(() => {
        toast.style.display = 'none';
    }, 2500);
}
</script>
</body>
</html>