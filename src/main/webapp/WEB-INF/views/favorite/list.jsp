<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관심상품</title>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
<style>
    .favorite-toolbar { margin-bottom: 12px; }
    .favorite-table { width: 100%; border-collapse: collapse; }
    .favorite-table th, .favorite-table td {
        border-bottom: 1px solid #ddd; padding: 10px; text-align: center;
    }
    .thumb { width: 80px; height: 80px; object-fit: cover; }
    .empty-msg { text-align: center; color: #888; padding: 40px 0; }
</style>
</head>
<body>

<h2>관심상품</h2>

<!-- 전체선택 / 선택삭제 / 전체삭제 툴바 -->
<div class="favorite-toolbar">
    <label><input type="checkbox" id="checkAll"> 전체선택</label>
    <button type="button" id="btnDeleteSelected">선택삭제</button>
    <button type="button" id="btnDeleteAll">전체삭제</button>
</div>

<c:choose>
    <c:when test="${empty favoriteList}">
        <p class="empty-msg">♥ 관심상품이 없습니다.</p>
    </c:when>
    <c:otherwise>
    <table class="favorite-table">
        <thead>
            <tr>
                <th></th>
                <th>이미지</th>
                <th>상품명</th>
                <th>가격</th>
                <th>수량</th>
                <th>삭제</th>
                <th>주문/결제</th>
            </tr>
        </thead>
        <tbody>
        <c:forEach var="item" items="${favoriteList}">
            <tr data-fano="${item.faNo}">
                <td><input type="checkbox" class="chk-item" value="${item.faNo}"></td>
                <td><img src="${item.pMainImg}" alt="${item.pName}" class="thumb"></td>
                <td><a href="${pageContext.request.contextPath}/favorite/${item.faNo}">${item.pName}</a></td>
                <td><fmt:formatNumber value="${item.oPrice}" pattern="#,###"/>원</td>
                <td>
                    <input type="number" class="qty-input" min="1"
                           value="${not empty item.quantity ? item.quantity : 1}"
                           data-fano="${item.faNo}">
                </td>
                <td><button type="button" class="btn-delete-one" data-fano="${item.faNo}">삭제</button></td>
                <td><button type="button" class="btn-order" data-pno="${item.pNo}">주문/결제</button></td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    </c:otherwise>
</c:choose>

<script>
    // 전체선택 체크박스
    document.getElementById('checkAll').addEventListener('change', function () {
        document.querySelectorAll('.chk-item').forEach(cb => cb.checked = this.checked);
    });

    // 단건 삭제
    document.querySelectorAll('.btn-delete-one').forEach(btn => {
        btn.addEventListener('click', function () {
            const faNo = this.dataset.fano;
            if (!confirm('삭제하시겠습니까?')) return;

            fetch('/favorite/' + faNo, { method: 'DELETE' })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        location.reload();
                    } else {
                        alert(data.message || '삭제 실패');
                    }
                });
        });
    });

    // 선택 삭제
    document.getElementById('btnDeleteSelected').addEventListener('click', function () {
        const faNoList = Array.from(document.querySelectorAll('.chk-item:checked')).map(cb => Number(cb.value));
        if (faNoList.length === 0) {
            alert('선택된 상품이 없습니다.');
            return;
        }
        deleteFavorites(faNoList);
    });

    // 전체 삭제
    document.getElementById('btnDeleteAll').addEventListener('click', function () {
        const faNoList = Array.from(document.querySelectorAll('.chk-item')).map(cb => Number(cb.value));
        if (faNoList.length === 0) return;
        deleteFavorites(faNoList);
    });

    function deleteFavorites(faNoList) {
        if (!confirm('삭제하시겠습니까?')) return;
        fetch('/favorite', {
            method: 'DELETE',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(faNoList)
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                location.reload();
            } else {
                alert(data.message || '삭제 실패');
            }
        });
    }

    // 주문/결제 페이지로 이동 (관심상품 -> 결제 흐름 연결 지점, 결제 파트 구현되면 경로 맞춰야 함)
    document.querySelectorAll('.btn-order').forEach(btn => {
        btn.addEventListener('click', function () {
            const pNo = this.dataset.pno;
            location.href = '/order/new?pNo=' + pNo;
        });
    });
</script>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>