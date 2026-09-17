<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>장바구니 관리</title>
    <%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
    <link rel="stylesheet" href="/css/cart/adminList.css">
</head>
<body>

<div class="ca-page">
<div class="ca-inner">
<h2>장바구니 관리</h2>

<c:choose>
    <c:when test="${empty cartSummaryList}">
        <div class="count">비회원(게스트) 장바구니 <strong>${guestCartCount}</strong>건</div>
        <div class="empty">등록된 회원 장바구니 데이터가 없어요.</div>
    </c:when>

    <c:otherwise>
        <div class="count">
            회원 <strong>${cartSummaryList.size()}</strong>명 · 비회원(게스트) 장바구니 <strong>${guestCartCount}</strong>건
        </div>

        <table>
            <thead>
                <tr>
                    <th>회원번호</th>
                    <th>회원아이디</th>
                    <th>담은 상품 개수</th>
                    <th>최근 담은일시</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="summary" items="${cartSummaryList}">
                    <tr>
                        <td>${summary.mNo}</td>
                        <td>${summary.mId}</td>
                        <td>${summary.caCount}개</td>
                        <td><fmt:formatDate value="${summary.lastCaAt}" pattern="yyyy.MM.dd HH:mm" /></td>
                        <td>
                            <button type="button" class="btn-sm" onclick="openDetail(${summary.mNo}, '${summary.mId}')">상세보기</button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:otherwise>
</c:choose>
</div><!-- /.ca-inner -->

<!-- 회원별 장바구니 상세보기 모달 -->
<div class="ca-modal-overlay" id="caModalOverlay">
    <div class="ca-modal">
        <button type="button" class="ca-modal-close" onclick="closeDetail()">&times;</button>
        <h4 id="caModalTitle">회원 장바구니</h4>
        <table id="caModalTable" style="display:none;">
            <thead>
            <tr>
                <th>번호</th><th>상품이미지</th><th>상품명</th><th>옵션</th><th>단가</th><th>수량</th><th>합계</th><th>쇼핑백</th><th>담은일시</th><th>관리</th>
            </tr>
            </thead>
            <tbody id="caModalTbody"></tbody>
        </table>
        <div class="ca-modal-empty" id="caModalEmpty" style="display:none;">이 회원의 장바구니가 비어있어요.</div>
    </div>
</div>

<!-- 커스텀 알림 모달 (기본 alert 대체) -->
<div class="ax-modal-overlay" id="axAlertOverlay">
    <div class="ax-modal">
        <div class="ax-modal-message" id="axAlertMessage"></div>
        <div class="ax-modal-actions">
            <button type="button" class="ax-btn ax-btn-primary" id="axAlertOkBtn">확인</button>
        </div>
    </div>
</div>

<!-- 커스텀 확인 모달 (기본 confirm 대체) -->
<div class="ax-modal-overlay" id="axConfirmOverlay">
    <div class="ax-modal">
        <div class="ax-modal-message" id="axConfirmMessage"></div>
        <div class="ax-modal-actions">
            <button type="button" class="ax-btn" id="axConfirmCancelBtn">취소</button>
            <button type="button" class="ax-btn ax-btn-primary" id="axConfirmOkBtn">확인</button>
        </div>
    </div>
</div>
</div><!-- /.ca-page -->

<script>
    // ===== 커스텀 알림/확인 모달 (기본 alert/confirm 대체) =====
    function showAlert(message, callback) {
        var overlay = document.getElementById('axAlertOverlay');
        document.getElementById('axAlertMessage').textContent = message;
        document.getElementById('axAlertOkBtn').onclick = function () {
            overlay.classList.remove('show');
            if (typeof callback === 'function') callback();
        };
        overlay.classList.add('show');
    }

    function showConfirm(message, onConfirm, options) {
        options = options || {};
        var overlay = document.getElementById('axConfirmOverlay');
        document.getElementById('axConfirmMessage').textContent = message;

        var okBtn = document.getElementById('axConfirmOkBtn');
        okBtn.textContent = options.okText || '확인';
        okBtn.className = 'ax-btn ' + (options.danger ? 'ax-btn-danger' : 'ax-btn-primary');
        okBtn.onclick = function () {
            overlay.classList.remove('show');
            if (typeof onConfirm === 'function') onConfirm();
        };

        document.getElementById('axConfirmCancelBtn').onclick = function () {
            overlay.classList.remove('show');
        };

        overlay.classList.add('show');
    }

    // 회원별 장바구니 상세보기 (CartController#adminCartListByMember)
    function openDetail(mNo, mId) {
        document.getElementById('caModalTitle').innerText = mId + ' 님의 장바구니';
        document.getElementById('caModalOverlay').classList.add('show');

        fetch('/admin/cart/byMember?mNo=' + mNo)
            .then(function (res) {
                if (!res.ok) throw new Error('서버 오류 (HTTP ' + res.status + ')');
                return res.json();
            })
            .then(function (result) { renderDetail(result.data || []); })
            .catch(function (err) {
                console.error('장바구니 상세 조회 실패', err);
                showAlert('목록 조회 중 오류가 발생했어요.\n' + err.message);
            });
    }

    function renderDetail(list) {
        var table = document.getElementById('caModalTable');
        var empty = document.getElementById('caModalEmpty');
        var tbody = document.getElementById('caModalTbody');
        tbody.innerHTML = '';

        if (!list || list.length === 0) {
            table.style.display = 'none';
            empty.style.display = 'block';
            return;
        }
        table.style.display = 'table';
        empty.style.display = 'none';

        list.forEach(function (cart) {
            var amount = (cart.oprice || 0) * (cart.caQuantity || 0);
            var bagLabel = (cart.caYn === 'Y') ? ('Y (' + cart.caQty + '개)') : 'N';

            var tr = document.createElement('tr');
            tr.id = 'row-' + cart.caNo;
            tr.innerHTML =
                '<td>' + cart.caNo + '</td>' +
                '<td><img src="/images/products/main/' + cart.pmainImg + '" alt="' + cart.pname + '"></td>' +
                '<td>' + cart.pname + '</td>' +
                '<td>' + (cart.oname || '-') + '</td>' +
                '<td>' + Number(cart.oprice || 0).toLocaleString('ko-KR') + '원</td>' +
                '<td>' + cart.caQuantity + '</td>' +
                '<td>' + Number(amount).toLocaleString('ko-KR') + '원</td>' +
                '<td>' + bagLabel + '</td>' +
                '<td>' + formatDate(cart.caAt) + '</td>' +
                '<td></td>';

            // 삭제 버튼: onclick 문자열에 상품명을 직접 끼워넣으면 따옴표 이스케이프 문제가 생길 수 있어서
            // 클로저로 caNo/상품명을 안전하게 넘김 (다른 페이지의 문자열 onclick 방식과 다른 이유)
            var delBtn = document.createElement('button');
            delBtn.type = 'button';
            delBtn.className = 'btn-sm btn-danger';
            delBtn.textContent = '삭제';
            delBtn.onclick = function () { deleteCart(cart.caNo, cart.pname); };
            tr.lastElementChild.appendChild(delBtn);

            tbody.appendChild(tr);
        });
    }

    function closeDetail() {
        document.getElementById('caModalOverlay').classList.remove('show');
    }

    // 장바구니 강제 삭제 - DELETE /admin/cart/{caNo}
    function deleteCart(caNo, pname) {
        var label = pname ? ('"' + pname + '"') : (caNo + '번 항목');
        showConfirm(label + '을(를) 장바구니에서 삭제할까요?', function () {
            fetch('/admin/cart/' + caNo, { method: 'DELETE' })
                .then(function (res) {
                    if (!res.ok) throw new Error('서버 오류 (HTTP ' + res.status + ')');
                    return res.json();
                })
                .then(function (result) {
                    if (result.success) {
                        var row = document.getElementById('row-' + caNo);
                        if (row) row.remove();
                    } else {
                        showAlert(result.message || '삭제에 실패했어요.');
                    }
                })
                .catch(function (err) {
                    console.error('장바구니 삭제 실패', err);
                    showAlert('처리 중 오류가 발생했어요.\n' + err.message);
                });
        }, { danger: true, okText: '삭제' });
    }

    function formatDate(v) {
        if (!v) return '-';
        var d = new Date(v);
        if (isNaN(d.getTime())) return v;
        var yyyy = d.getFullYear();
        var mm = String(d.getMonth() + 1).padStart(2, '0');
        var dd = String(d.getDate()).padStart(2, '0');
        var hh = String(d.getHours()).padStart(2, '0');
        var mi = String(d.getMinutes()).padStart(2, '0');
        return yyyy + '.' + mm + '.' + dd + ' ' + hh + ':' + mi;
    }
</script>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>