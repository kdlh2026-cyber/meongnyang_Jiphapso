<%-- ============================================= --%>
<%-- admin/favorite/adminList.jsp --%>
<%-- ============================================= --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 - 관심상품 관리</title>
    <link rel="stylesheet" href="/css/favorite/adminList.css">
    <style>
        /* 상세보기 모달 */
        .fa-modal-overlay {
            display: none; position: fixed; inset: 0; z-index: 1000;
            background: rgba(0,0,0,0.5); align-items: center; justify-content: center;
        }
        .fa-modal-overlay.show { display: flex; }
        .fa-modal {
            width: 700px; max-width: 92vw; max-height: 82vh; overflow-y: auto;
            background: #fff; border-radius: 10px; padding: 24px; position: relative;
        }
        .fa-modal-close {
            position: absolute; top: 14px; right: 16px; border: none; background: none;
            font-size: 22px; cursor: pointer; color: #999; line-height: 1;
        }
        .fa-modal h4 { margin: 0 0 16px; font-size: 16px; }
        .fa-modal-empty { text-align: center; color: #888; padding: 40px 0; font-size: 13px; }

        /* 가격 칸 줄바꿈 방지 + 너비 확보 */
        #faModalTable th:nth-child(4),
        #faModalTable td:nth-child(4) {
            white-space: nowrap;
            min-width: 90px;
        }
        /* 모달 테이블 헤더 줄바꿈 방지 */
		#faModalTable th {
		    white-space: nowrap;
		}
    </style>
</head>
<body>
<h3>관심상품 관리</h3>

<table class="admin-table">
    <thead>
    <tr>
        <th>회원번호</th><th>회원아이디</th><th>찜한 상품 개수</th><th>최근 찜한일시</th><th>관리</th>
    </tr>
    </thead>
    <tbody>
    <c:choose>
        <c:when test="${empty favoriteSummaryList}">
            <tr><td colspan="5">등록된 관심상품이 없어요.</td></tr>
        </c:when>
        <c:otherwise>
            <c:forEach var="summary" items="${favoriteSummaryList}">
                <tr>
                    <td>${summary.mNo}</td>
                    <td>${summary.mId}</td>
                    <td>${summary.faCount}개</td>
                    <td><fmt:formatDate value="${summary.lastFaAt}" pattern="yyyy.MM.dd HH:mm" /></td>
                    <td>
                        <button type="button" class="btn-sm" onclick="openDetail(${summary.mNo}, '${summary.mId}')">상세보기</button>
                    </td>
                </tr>
            </c:forEach>
        </c:otherwise>
    </c:choose>
    </tbody>
</table>

<!-- 회원별 찜한 상품 상세보기 모달 -->
<div class="fa-modal-overlay" id="faModalOverlay">
    <div class="fa-modal">
        <button type="button" class="fa-modal-close" onclick="closeDetail()">&times;</button>
        <h4 id="faModalTitle">회원 찜 목록</h4>
        <table class="admin-table" id="faModalTable" style="display:none;">
            <thead>
            <tr>
                <th>번호</th><th>상품이미지</th><th>상품명</th><th>가격</th><th>찜한일시</th><th>관리</th>
            </tr>
            </thead>
            <tbody id="faModalTbody"></tbody>
        </table>
        <div class="fa-modal-empty" id="faModalEmpty" style="display:none;">이 회원이 찜한 상품이 없어요.</div>
    </div>
</div>

<script>
    // 회원별 찜한 상품 목록 상세보기 (FavoriteController#adminFavoriteListByMember)
    function openDetail(mNo, mId) {
        document.getElementById('faModalTitle').innerText = mId + ' 님이 찜한 상품';
        document.getElementById('faModalOverlay').classList.add('show');

        fetch('/admin/favorite/byMember?mNo=' + mNo)
            .then(res => res.json())
            .then(result => {
                renderDetail(result.data || []);
            })
            .catch(() => alert('목록 조회 중 오류가 발생했어요.'));
    }

    function renderDetail(list) {
        var table = document.getElementById('faModalTable');
        var empty = document.getElementById('faModalEmpty');
        var tbody = document.getElementById('faModalTbody');
        tbody.innerHTML = '';

        if (!list || list.length === 0) {
            table.style.display = 'none';
            empty.style.display = 'block';
            return;
        }
        table.style.display = 'table';
        empty.style.display = 'none';

        list.forEach(function (favorite) {
            var tr = document.createElement('tr');
            tr.id = 'row-' + favorite.faNo;
            tr.innerHTML =
                '<td>' + favorite.faNo + '</td>' +
                '<td><img src="/images/products/main/' + favorite.pmainImg + '" alt="' + favorite.pname + '" class="thumb"></td>' +
                '<td>' + favorite.pname + '</td>' +
                '<td>' + Number(favorite.oprice || 0).toLocaleString('ko-KR') + '원</td>' +
                '<td>' + formatDate(favorite.faAt) + '</td>' +
                '<td><button type="button" class="btn-sm btn-danger" onclick="deleteFavorite(' + favorite.faNo + ')">삭제</button></td>';
            tbody.appendChild(tr);
        });
    }

    function closeDetail() {
        document.getElementById('faModalOverlay').classList.remove('show');
    }

    // 관심상품 강제 삭제 - DELETE /admin/favorite/{faNo}
    function deleteFavorite(faNo) {
        if (!confirm('해당 관심상품을 삭제할까요?')) return;

        fetch('/admin/favorite/' + faNo, { method: 'DELETE' })
        .then(res => res.json())
        .then(result => {
            if (result.success) {
                var row = document.getElementById('row-' + faNo);
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