<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 - 관심상품 관리</title>
    <%@ include file="/WEB-INF/views/admin/clone/hamburger_menu.jsp" %>
    <link rel="stylesheet" href="/css/favorite/adminList.css">
</head>
<body>
<div class="fa-page">
<div class="fa-inner">
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
</div><!-- /.fa-inner -->

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
</div><!-- /.fa-page -->

<script>
    // 상품 이미지 경로 - 파일명에 "%"가 들어있으면 URL 인코딩이 깨지는 문제 때문에
    // 다른 화면들과 동일하게 contextPath + "%" -> "%25" 치환 규칙을 적용함
    var contextPath = "${pageContext.request.contextPath}";

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

    // 회원별 찜한 상품 목록 상세보기 (FavoriteController#adminFavoriteListByMember)
    function openDetail(mNo, mId) {
        document.getElementById('faModalTitle').innerText = mId + ' 님이 찜한 상품';
        document.getElementById('faModalOverlay').classList.add('show');

        fetch('/admin/favorite/byMember?mNo=' + mNo)
            .then(function (res) {
                if (!res.ok) throw new Error('서버 오류 (HTTP ' + res.status + ')');
                return res.json();
            })
            .then(function (result) { renderDetail(result.data || []); })
            .catch(function (err) {
                console.error('관심상품 상세 조회 실패', err);
                showAlert('목록 조회 중 오류가 발생했어요.\n' + err.message);
            });
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
            var pName = pickField(favorite, ['PName', 'pName', 'p_name', 'pname']);
            var pMainImg = pickField(favorite, ['PMainImg', 'pMainImg', 'p_main_img', 'pmainImg']);
            var oPrice = pickField(favorite, ['OPrice', 'oPrice', 'o_price', 'oprice']);

            // 위 후보 키에도 안 걸리면 실제 서버 응답 구조가 다른 거라, 콘솔에 원본을 찍어서 바로 확인 가능하게 함
            if (pName === undefined) {
                console.warn('상품명 필드를 못 찾았어요. 실제 응답 구조:', favorite);
            }

            // 파일명에 "%"가 있으면 그대로 URL에 넣었을 때 인코딩이 깨지므로 "%25"로 치환
            // (JSTL fn:replace(detail.PMainImg, '%', '%25') 와 동일한 처리를 JS로)
            var imgUrl = contextPath + '/images/products/main/' + String(pMainImg || '').replace(/%/g, '%25');

            tr.innerHTML =
                '<td>' + favorite.faNo + '</td>' +
                '<td><img src="' + imgUrl + '" alt="' + (pName || '') + '" class="thumb"></td>' +
                '<td>' + (pName || '-') + '</td>' +
                '<td>' + Number(oPrice || 0).toLocaleString('ko-KR') + '원</td>' +
                '<td>' + formatDate(favorite.faAt) + '</td>' +
                '<td></td>';

            // 삭제 버튼은 클로저로 안전하게 연결해서 상품명을 확인창 메시지에 그대로 넘김
            var delBtn = document.createElement('button');
            delBtn.type = 'button';
            delBtn.className = 'btn-sm btn-danger';
            delBtn.textContent = '삭제';
            delBtn.onclick = function () { deleteFavorite(favorite.faNo, pName); };
            tr.lastElementChild.appendChild(delBtn);

            tbody.appendChild(tr);
        });
    }

    function closeDetail() {
        document.getElementById('faModalOverlay').classList.remove('show');
    }

    // 관심상품 강제 삭제 - DELETE /admin/favorite/{faNo}
    function deleteFavorite(faNo, pname) {
        var label = pname ? ('"' + pname + '"') : '해당 관심상품';
        showConfirm(label + '을(를) 삭제할까요?', function () {
            fetch('/admin/favorite/' + faNo, { method: 'DELETE' })
            .then(function (res) {
                if (!res.ok) throw new Error('서버 오류 (HTTP ' + res.status + ')');
                return res.json();
            })
            .then(function (result) {
                if (result.success) {
                    var row = document.getElementById('row-' + faNo);
                    if (row) row.remove();
                } else {
                    showAlert(result.message || '삭제에 실패했어요.');
                }
            })
            .catch(function (err) {
                console.error('관심상품 삭제 실패', err);
                showAlert('처리 중 오류가 발생했어요.\n' + err.message);
            });
        }, { danger: true, okText: '삭제' });
    }

    // 후보 키를 순서대로 확인해서 값이 있는(undefined/null이 아닌) 첫 키의 값을 반환
    function pickField(obj, keyCandidates) {
        for (var i = 0; i < keyCandidates.length; i++) {
            var v = obj[keyCandidates[i]];
            if (v !== undefined && v !== null) return v;
        }
        return undefined;
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