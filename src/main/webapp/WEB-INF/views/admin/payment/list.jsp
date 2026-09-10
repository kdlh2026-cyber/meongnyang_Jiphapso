<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>[관리자] 결제 관리</title>
<style>
  * { box-sizing: border-box; }
  body { margin: 0; font-family: "Noto Sans KR", "Malgun Gothic", sans-serif; background: #f7f7f8; color: #222; }

  .pa-wrap { max-width: 1300px; margin: 40px auto; padding: 0 20px 60px; }
  .pa-title { font-size: 22px; font-weight: 700; margin: 0 0 20px; }

  .pa-tabs { display: flex; gap: 8px; margin-bottom: 18px; }
  .pa-tab {
    padding: 8px 16px; border: 1px solid #ddd; background: #fff; border-radius: 20px;
    font-size: 13px; cursor: pointer; color: #555;
  }
  .pa-tab.active { background: #222; color: #fff; border-color: #222; }

  .pa-empty {
    padding: 80px 0; text-align: center; color: #888; font-size: 15px;
    background: #fff; border: 1px solid #e5e5e5; border-radius: 8px;
  }

  .pa-table { width: 100%; border-collapse: collapse; background: #fff; border: 1px solid #e5e5e5; border-radius: 8px; overflow: hidden; font-size: 13px; }
  .pa-table th, .pa-table td { padding: 12px 8px; text-align: center; border-bottom: 1px solid #eee; }
  .pa-table thead th { background: #fafafa; color: #555; font-weight: 600; }
  .pa-table tbody tr:last-child td { border-bottom: none; }

  .pa-status-select { padding: 5px 6px; border: 1px solid #ccc; border-radius: 5px; font-size: 12px; }

  .pa-btn { padding: 6px 12px; border-radius: 6px; font-size: 12px; cursor: pointer; border: 1px solid #ccc; background: #fff; margin: 0 2px; }
  .pa-btn-save { border-color: #1a56db; color: #1a56db; }
  .pa-btn-save:hover { background: #1a56db; color: #fff; }
  .pa-btn-delete { border-color: #c0392b; color: #c0392b; }
  .pa-btn-delete:hover { background: #c0392b; color: #fff; }
</style>
</head>
<body>

<div class="pa-wrap">
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
        <th>회원번호</th>
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
</div>

<script>
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
      .then(function (res) { return res.json(); })
      .then(function (result) {
        fullList = result.data || [];
        renderList();
      })
      .catch(function (err) {
        console.error("결제 전체 목록 조회 실패", err);
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
        "<td>" + item.mNo + "</td>" +
        "<td>" + methodLabel + "</td>" +
        "<td>" + (item.payTno || "-") + "</td>" +
        "<td>" + formatPrice(item.payRealAmt) + "원</td>" +
        "<td>" + formatDate(item.payReqAt) + "</td>" +
        "<td>" + (item.payAt ? formatDate(item.payAt) : "-") + "</td>" +
        "<td>" + buildStatusSelect(item.payNo, item.payStatus) + "</td>" +
        "<td>" +
          "<button type=\"button\" class=\"pa-btn pa-btn-save\" onclick=\"saveStatus(" + item.payNo + ")\">저장</button>" +
          "<button type=\"button\" class=\"pa-btn pa-btn-delete\" onclick=\"removeItem(" + item.payNo + ")\">삭제</button>" +
        "</td>";
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
      .then(function (res) { return res.json(); })
      .then(function (result) {
        alert(result.message);
        if (result.success) {
          loadAdminList();
        }
      })
      .catch(function (err) {
        console.error("처리상태 변경 실패", err);
        alert("처리상태 변경 중 오류가 발생했습니다.");
      });
  }

  // 삭제 (PaymentController#deletePayment)
  function removeItem(payNo) {
    if (!confirm("해당 결제 내역을 삭제하시겠습니까?")) {
      return;
    }

    var params = new URLSearchParams();
    params.append("payNo", payNo);

    fetch(contextPath + "/payment/admin/delete", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: params.toString()
    })
      .then(function (res) { return res.json(); })
      .then(function (result) {
        alert(result.message);
        if (result.success) {
          loadAdminList();
        }
      })
      .catch(function (err) {
        console.error("삭제 실패", err);
        alert("삭제 중 오류가 발생했습니다.");
      });
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
</body>
</html>
