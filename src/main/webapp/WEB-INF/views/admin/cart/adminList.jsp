<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>장바구니 관리</title>
    <style>
        body { font-family: sans-serif; max-width: 1100px; margin: 0 auto; padding: 20px; }
        h2 { margin-bottom: 8px; }
        table { width: 100%; border-collapse: collapse; font-size: 14px; }
        th, td { padding: 10px 8px; border-bottom: 1px solid #eee; text-align: center; }
        th { background: #fafafa; color: #555; font-weight: 600; }
        td img { width: 44px; height: 44px; object-fit: cover; border-radius: 6px; vertical-align: middle; background: #f2f2f2; }
        .btn-sm { padding: 5px 10px; border: 1px solid #ddd; border-radius: 4px; background: #fff; cursor: pointer; font-size: 12px; }
        .btn-danger { color: #c0392b; border-color: #c0392b; }
        .empty { text-align: center; color: #999; padding: 60px 0; }
        .count { color: #777; font-size: 13px; margin-bottom: 16px; }

        /* 상세보기 모달 */
        .ca-modal-overlay {
            display: none; position: fixed; inset: 0; z-index: 1000;
            background: rgba(0,0,0,0.5); align-items: center; justify-content: center;
        }
        .ca-modal-overlay.show { display: flex; }
        .ca-modal {
            width: 860px; max-width: 92vw; max-height: 82vh; overflow-y: auto;
            background: #fff; border-radius: 10px; padding: 24px; position: relative;
        }
        .ca-modal-close {
            position: absolute; top: 14px; right: 16px; border: none; background: none;
            font-size: 22px; cursor: pointer; color: #999; line-height: 1;
        }
        .ca-modal h4 { margin: 0 0 16px; font-size: 16px; }
        .ca-modal-empty { text-align: center; color: #888; padding: 40px 0; font-size: 13px; }

        /* 단가/합계 칸 줄바꿈 방지 */
        #caModalTable th:nth-child(5),
        #caModalTable td:nth-child(5),
        #caModalTable th:nth-child(7),
        #caModalTable td:nth-child(7) {
            white-space: nowrap;
            min-width: 82px;
        }
    </style>
</head>
<body>

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

<script>
    // 회원별 장바구니 상세보기 (CartController#adminCartListByMember)
    function openDetail(mNo, mId) {
        document.getElementById('caModalTitle').innerText = mId + ' 님의 장바구니';
        document.getElementById('caModalOverlay').classList.add('show');

        fetch('/admin/cart/byMember?mNo=' + mNo)
            .then(res => res.json())
            .then(result => {
                renderDetail(result.data || []);
            })
            .catch(() => alert('목록 조회 중 오류가 발생했어요.'));
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
                '<td><button type="button" class="btn-sm btn-danger" onclick="deleteCart(' + cart.caNo + ')">삭제</button></td>';
            tbody.appendChild(tr);
        });
    }

    function closeDetail() {
        document.getElementById('caModalOverlay').classList.remove('show');
    }

    // 장바구니 강제 삭제 - DELETE /admin/cart/{caNo}
    function deleteCart(caNo) {
        if (!confirm(caNo + '번 장바구니 항목을 삭제할까요?')) return;

        fetch('/admin/cart/' + caNo, { method: 'DELETE' })
            .then(res => res.json())
            .then(result => {
                if (result.success) {
                    var row = document.getElementById('row-' + caNo);
                    if (row) row.remove();
                } else {
                    alert(result.message || '삭제에 실패했어요.');
                }
            })
            .catch(() => alert('처리 중 오류가 발생했어요.'));
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

</body>
</html>