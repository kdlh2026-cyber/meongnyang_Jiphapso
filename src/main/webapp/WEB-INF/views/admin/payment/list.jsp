<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>[관리자] 결제 관리</title>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
<link rel="stylesheet" href="/css/payment/adminList.css">
</head>
<body>

<div class="pa-page">
<div class="pa-inner">
  <h2 class="pa-title">결제 관리</h2>

  <div class="pa-tabs" id="paTabs">
    <button type="button" class="pa-tab active" data-status="ALL" onclick="filterByStatus('ALL', this)">전체</button>
    <button type="button" class="pa-tab" data-status="PENDING" onclick="filterByStatus('PENDING', this)">결제대기</button>
    <button type="button" class="pa-tab" data-status="PAID" onclick="filterByStatus('PAID', this)">결제완료</button>
    <button type="button" class="pa-tab" data-status="FAILED" onclick="filterByStatus('FAILED', this)">결제실패</button>
    <button type="button" class="pa-tab" data-status="PARTIAL_REFUNDED" onclick="filterByStatus('PARTIAL_REFUNDED', this)">부분환불</button>
    <button type="button" class="pa-tab" data-status="REFUNDED" onclick="filterByStatus('REFUNDED', this)">환불완료</button>
  </div>

  <div id="paEmpty" class="pa-empty" style="display:none;">해당 상태의 결제 내역이 없습니다.</div>

  <table class="pa-table" id="paTable" style="display:none;">
    <thead>
      <tr>
        <th>결제번호</th>
        <th>주문번호</th>
        <th>회원아이디</th>
        <th>결제수단</th>
        <th>거래ID</th>
        <th>실결제금액</th>
        <th>요청일시</th>
        <th>완료일시</th>
        <th>처리상태</th>
        <th>관리</th>
      </tr>
    </thead>
    <tbody id="paTbody"></tbody>
  </table>
</div><!-- /.pa-inner -->

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
</div><!-- /.pa-page -->

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
  var fullList = [];
  var currentFilter = "ALL";

  var METHOD_LABEL = {
    TOSSPAY: "토스페이", PAYCO: "페이코", KAKAOPAY: "카카오페이",
    SMILEPAY: "스마일페이", NAVERPAY: "네이버페이"
  };
  var STATUS_OPTIONS = ["PENDING", "PAID", "FAILED", "PARTIAL_REFUNDED", "REFUNDED"];
  var STATUS_LABEL = {
    PENDING: "결제대기", PAID: "결제완료", FAILED: "결제실패",
    PARTIAL_REFUNDED: "부분환불", REFUNDED: "환불완료"
  };

  document.addEventListener("DOMContentLoaded", function () {
    loadAdminList();
  });

  // 전체 결제 목록 조회 (PaymentController#selectPaymentListAll)
  function loadAdminList() {
    fetch(contextPath + "/payment/admin/list/data")
      .then(function (res) {
        if (!res.ok) throw new Error("서버 오류 (HTTP " + res.status + ")");
        return res.json();
      })
      .then(function (result) {
        fullList = result.data || [];
        renderList();
      })
      .catch(function (err) {
        console.error("결제 전체 목록 조회 실패", err);
        showAlert("목록 조회 중 오류가 발생했습니다.\n" + err.message);
      });
  }

  // 상태 탭 클릭 시 클라이언트에서 필터링
  function filterByStatus(status, btnEl) {
    currentFilter = status;

    var tabs = document.querySelectorAll("#paTabs .pa-tab");
    tabs.forEach(function (t) { t.classList.remove("active"); });
    btnEl.classList.add("active");

    renderList();
  }

  function renderList() {
    var tbody = document.getElementById("paTbody");
    var table = document.getElementById("paTable");
    var empty = document.getElementById("paEmpty");

    var list = (currentFilter === "ALL")
      ? fullList
      : fullList.filter(function (item) { return item.payStatus === currentFilter; });

    tbody.innerHTML = "";

    if (!list || list.length === 0) {
      table.style.display = "none";
      empty.style.display = "block";
      return;
    }

    table.style.display = "table";
    empty.style.display = "none";

    list.forEach(function (item) {
      var methodLabel = METHOD_LABEL[item.payMethod] || item.payMethod;

      var tr = document.createElement("tr");
      tr.innerHTML =
        "<td>" + item.payNo + "</td>" +
        "<td>" + item.orNo + "</td>" +
        "<td>" + (item.mid || "-") + "</td>" +
        "<td>" + methodLabel + "</td>" +
        "<td>" + (item.payTno || "-") + "</td>" +
        "<td>" + formatPrice(item.payRealAmt) + "원</td>" +
        "<td>" + formatDate(item.payReqAt) + "</td>" +
        "<td>" + (item.payAt ? formatDate(item.payAt) : "-") + "</td>" +
        "<td>" + buildStatusSelect(item.payNo, item.payStatus) + "</td>" +
        "<td></td>";

      // 저장/삭제 버튼은 클로저로 안전하게 연결 (문자열 onclick의 따옴표 이스케이프 문제 방지)
      var manageTd = tr.lastElementChild;

      var saveBtn = document.createElement("button");
      saveBtn.type = "button";
      saveBtn.className = "pa-btn pa-btn-save";
      saveBtn.textContent = "저장";
      saveBtn.onclick = function () { saveStatus(item.payNo); };

      var delBtn = document.createElement("button");
      delBtn.type = "button";
      delBtn.className = "pa-btn pa-btn-delete";
      delBtn.textContent = "삭제";
      delBtn.onclick = function () { removeItem(item.payNo, item.orNo); };

      manageTd.appendChild(saveBtn);
      manageTd.appendChild(delBtn);

      tbody.appendChild(tr);
    });
  }

  function buildStatusSelect(payNo, current) {
    var html = "<select class=\"pa-status-select\" id=\"paStatus_" + payNo + "\">";
    STATUS_OPTIONS.forEach(function (code) {
      var selected = (code === current) ? " selected" : "";
      html += "<option value=\"" + code + "\"" + selected + ">" + STATUS_LABEL[code] + "</option>";
    });
    html += "</select>";
    return html;
  }

  // 처리상태 변경 저장 (PaymentController#updatePaymentStatus)
  function saveStatus(payNo) {
    var select = document.getElementById("paStatus_" + payNo);
    var newStatus = select.value;

    var params = new URLSearchParams();
    params.append("payNo", payNo);
    params.append("payStatus", newStatus);

    fetch(contextPath + "/payment/admin/updateStatus", {
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
        console.error("처리상태 변경 실패", err);
        showAlert("처리상태 변경 중 오류가 발생했습니다.\n" + err.message);
      });
  }

  // 삭제 (PaymentController#deletePayment)
  function removeItem(payNo, orNo) {
    showConfirm(orNo + "번 주문의 결제 내역을 삭제하시겠습니까?", function () {
      var params = new URLSearchParams();
      params.append("payNo", payNo);

      fetch(contextPath + "/payment/admin/delete", {
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
</script>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>