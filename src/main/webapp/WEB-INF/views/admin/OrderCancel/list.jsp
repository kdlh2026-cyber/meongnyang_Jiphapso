<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>[관리자] 취소 ◦ 반품 관리</title>
<%@ include file="/WEB-INF/views/admin/clone/hamburger_menu.jsp" %>
<link rel="stylesheet" href="/css/orderCancel/adminList.css">
<style>
  /* 모바일 반응형 - 이 페이지에서만 쓰는 거라 별도 파일로 안 빼고 여기 인라인으로 둠 */
  @media (max-width: 768px) {
    .oca-page { padding: 56px 12px 40px; }
    .oca-title { font-size: 18px; }
    .oca-tabs { gap: 6px; }
    .oca-tab { padding: 7px 12px; font-size: 12px; }
    .oca-table { display: block; overflow-x: auto; white-space: nowrap; }
    .ax-modal { padding: 20px 16px 16px; }
  }
</style>
</head>
<body>

<div class="oca-page">
<div class="oca-inner">
  <h2 class="oca-title">취소 · 반품 · 교환 관리</h2>

  <div class="oca-tabs" id="ocaTabs">
    <button type="button" class="oca-tab active" data-status="ALL" onclick="filterByStatus('ALL', this)">전체</button>
    <button type="button" class="oca-tab" data-status="REQUESTED" onclick="filterByStatus('REQUESTED', this)">신청</button>
    <button type="button" class="oca-tab" data-status="APPROVED" onclick="filterByStatus('APPROVED', this)">승인</button>
    <button type="button" class="oca-tab" data-status="REFUNDED" onclick="filterByStatus('REFUNDED', this)">환불완료</button>
    <button type="button" class="oca-tab" data-status="REJECTED" onclick="filterByStatus('REJECTED', this)">거절</button>
  </div>

  <div id="ocaEmpty" class="oca-empty" style="display:none;">해당 상태의 취소/반품 신청 내역이 없습니다.</div>

  <table class="oca-table" id="ocaTable" style="display:none;">
    <thead>
      <tr>
        <th>신청번호</th>
        <th>주문상세번호</th>
        <th>상품명</th>
        <th>취소한 아이디</th>
        <th>유형</th>
        <th>수량</th>
        <th>환불예정금액</th>
        <th>사유</th>
        <th>신청일</th>
        <th>처리완료일</th>
        <th>처리상태</th>
        <th>관리</th>
      </tr>
    </thead>
    <tbody id="ocaTbody"></tbody>
  </table>
</div><!-- /.oca-inner -->

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
</div><!-- /.oca-page -->

<script>
  // ===== 커스텀 알림/확인 모달 (기본 alert/confirm 대체) =====
  function showAlert(message, callback) {
    var overlay = document.getElementById("axAlertOverlay");
    document.getElementById("axAlertMessage").textContent = message;
    document.getElementById("axAlertOkBtn").onclick = function () {
      overlay.classList.remove("show");
      if (typeof callback === "function") callback();
    };
    overlay.classList.add("show");
  }

  function showConfirm(message, onConfirm, options) {
    options = options || {};
    var overlay = document.getElementById("axConfirmOverlay");
    document.getElementById("axConfirmMessage").textContent = message;

    var okBtn = document.getElementById("axConfirmOkBtn");
    okBtn.textContent = options.okText || "확인";
    okBtn.className = "ax-btn " + (options.danger ? "ax-btn-danger" : "ax-btn-primary");
    okBtn.onclick = function () {
      overlay.classList.remove("show");
      if (typeof onConfirm === "function") onConfirm();
    };

    document.getElementById("axConfirmCancelBtn").onclick = function () {
      overlay.classList.remove("show");
    };

    overlay.classList.add("show");
  }

  var contextPath = "${pageContext.request.contextPath}";
  var fullList = [];        // 서버에서 받아온 전체 목록 캐시
  var currentFilter = "ALL"; // 현재 선택된 상태 탭

  var TYPE_LABEL = { CANCEL: "취소", RETURN: "반품", EXCHANGE: "교환" };
  var STATUS_OPTIONS = ["REQUESTED", "APPROVED", "REFUNDED", "REJECTED"];
  var STATUS_LABEL = { REQUESTED: "신청됨", APPROVED: "승인됨", REFUNDED: "환불완료", REJECTED: "거절됨" };

  document.addEventListener("DOMContentLoaded", function () {
    loadAdminList();
  });

  // 전체 취소/반품 목록 조회 (OrderCancelController#selectOrderCancelListAll)
  function loadAdminList() {
    fetch(contextPath + "/orderCancel/admin/list/data")
      .then(function (res) {
        if (!res.ok) throw new Error("서버 오류 (HTTP " + res.status + ")");
        return res.json();
      })
      .then(function (result) {
        fullList = result.data || [];
        renderList();
      })
      .catch(function (err) {
        console.error("취소/반품 전체 목록 조회 실패", err);
        showAlert("목록 조회 중 오류가 발생했습니다.\n" + err.message);
      });
  }

  // 상태 탭 클릭 시 클라이언트에서 필터링 (목록은 이미 한번에 받아둔 데이터 재사용)
  function filterByStatus(status, btnEl) {
    currentFilter = status;

    var tabs = document.querySelectorAll("#ocaTabs .oca-tab");
    tabs.forEach(function (t) { t.classList.remove("active"); });
    btnEl.classList.add("active");

    renderList();
  }

  function renderList() {
    var tbody = document.getElementById("ocaTbody");
    var table = document.getElementById("ocaTable");
    var empty = document.getElementById("ocaEmpty");

    var list = (currentFilter === "ALL")
      ? fullList
      : fullList.filter(function (item) { return item.ocStatus === currentFilter; });

    tbody.innerHTML = "";

    if (!list || list.length === 0) {
      table.style.display = "none";
      empty.style.display = "block";
      return;
    }

    table.style.display = "table";
    empty.style.display = "none";

    list.forEach(function (item) {
      var typeLabel = TYPE_LABEL[item.ocType] || item.ocType;

      var tr = document.createElement("tr");
      tr.innerHTML =
        "<td>" + item.ocOutNo + "</td>" +
        "<td>" + item.odDetailNo + "</td>" +
        "<td class=\"oca-product\">" + escapeHtml(item.odProductTitle) + "</td>" +
        "<td>" + escapeHtml(item.mid) + "</td>" +
        "<td>" + typeLabel + "</td>" +
        "<td>" + item.ocQuantity + "</td>" +
        "<td>" + formatPrice(item.ocRamount) + "원</td>" +
        "<td class=\"oca-reason\">" + escapeHtml(item.ocReason) + "</td>" +
        "<td>" + formatDate(item.ocRe) + "</td>" +
        "<td>" + (item.ocPr ? formatDate(item.ocPr) : "-") + "</td>" +
        "<td>" + buildStatusSelect(item.ocOutNo, item.ocStatus) + "</td>" +
        "<td></td>";

      // 저장/삭제 버튼은 클로저로 안전하게 연결 (문자열 onclick의 따옴표 이스케이프 문제 방지)
      var manageTd = tr.lastElementChild;

      var saveBtn = document.createElement("button");
      saveBtn.type = "button";
      saveBtn.className = "oca-btn oca-btn-save";
      saveBtn.textContent = "저장";
      saveBtn.onclick = function () { saveStatus(item.ocOutNo); };

      var delBtn = document.createElement("button");
      delBtn.type = "button";
      delBtn.className = "oca-btn oca-btn-delete";
      delBtn.textContent = "삭제";
      delBtn.onclick = function () { removeItem(item.ocOutNo, item.odProductTitle); };

      manageTd.appendChild(saveBtn);
      manageTd.appendChild(delBtn);

      tbody.appendChild(tr);
    });
  }

  function buildStatusSelect(ocOutNo, current) {
    var html = "<select class=\"oca-status-select\" id=\"ocaStatus_" + ocOutNo + "\">";
    STATUS_OPTIONS.forEach(function (code) {
      var selected = (code === current) ? " selected" : "";
      html += "<option value=\"" + code + "\"" + selected + ">" + STATUS_LABEL[code] + "</option>";
    });
    html += "</select>";
    return html;
  }

  // 처리상태 변경 저장 (OrderCancelController#updateOrderCancelStatus)
  function saveStatus(ocOutNo) {
    var select = document.getElementById("ocaStatus_" + ocOutNo);
    var newStatus = select.value;

    var params = new URLSearchParams();
    params.append("ocOutNo", ocOutNo);
    params.append("ocStatus", newStatus);

    fetch(contextPath + "/orderCancel/admin/updateStatus", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: params.toString()
    })
      .then(function (res) {
        if (!res.ok) throw new Error("서버 오류 (HTTP " + res.status + ")");
        return res.json();
      })
      .then(function (result) {
        showAlert(result.message, function () {
          if (result.success) {
            loadAdminList(); // 목록 다시 조회해서 화면 갱신
          }
        });
      })
      .catch(function (err) {
        console.error("처리상태 변경 실패", err);
        showAlert("처리상태 변경 중 오류가 발생했습니다.\n" + err.message);
      });
  }

  // 삭제 (OrderCancelController#deleteOrderCancel)
  function removeItem(ocOutNo, pname) {
    var label = pname ? ('"' + pname + '"') : (ocOutNo + "번");
    showConfirm(label + " 취소/반품 신청 내역을 삭제하시겠습니까?", function () {
      var params = new URLSearchParams();
      params.append("ocOutNo", ocOutNo);

      fetch(contextPath + "/orderCancel/admin/delete", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: params.toString()
      })
        .then(function (res) {
          if (!res.ok) throw new Error("서버 오류 (HTTP " + res.status + ")");
          return res.json();
        })
        .then(function (result) {
          showAlert(result.message, function () {
            if (result.success) {
              loadAdminList();
            }
          });
        })
        .catch(function (err) {
          console.error("삭제 실패", err);
          showAlert("삭제 중 오류가 발생했습니다.\n" + err.message);
        });
    }, { danger: true, okText: "삭제" });
  }

  function formatPrice(v) {
    if (v === null || v === undefined) return "0";
    return Number(v).toLocaleString("ko-KR");
  }

  function formatDate(v) {
    if (!v) return "-";
    var d = new Date(v);
    if (isNaN(d.getTime())) return v;
    var yyyy = d.getFullYear();
    var mm = String(d.getMonth() + 1).padStart(2, "0");
    var dd = String(d.getDate()).padStart(2, "0");
    return yyyy + "." + mm + "." + dd;
  }

  function escapeHtml(str) {
    if (!str) return "";
    return String(str)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;");
  }
</script>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>