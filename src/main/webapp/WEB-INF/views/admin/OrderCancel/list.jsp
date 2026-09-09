<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>[관리자] 취소 ◦ 반품 관리</title>
<style>
  * { box-sizing: border-box; }
  body { margin: 0; font-family: "Noto Sans KR", "Malgun Gothic", sans-serif; background: #f7f7f8; color: #222; }

  .oca-wrap { max-width: 1300px; margin: 40px auto; padding: 0 20px 60px; }
  .oca-title { font-size: 22px; font-weight: 700; margin: 0 0 20px; }

  .oca-tabs { display: flex; gap: 8px; margin-bottom: 18px; }
  .oca-tab {
    padding: 8px 16px; border: 1px solid #ddd; background: #fff; border-radius: 20px;
    font-size: 13px; cursor: pointer; color: #555;
  }
  .oca-tab.active { background: #222; color: #fff; border-color: #222; }

  .oca-empty {
    padding: 80px 0; text-align: center; color: #888; font-size: 15px;
    background: #fff; border: 1px solid #e5e5e5; border-radius: 8px;
  }

  .oca-table { width: 100%; border-collapse: collapse; background: #fff; border: 1px solid #e5e5e5; border-radius: 8px; overflow: hidden; font-size: 13px; }
  .oca-table th, .oca-table td { padding: 12px 8px; text-align: center; border-bottom: 1px solid #eee; }
  .oca-table thead th { background: #fafafa; color: #555; font-weight: 600; }
  .oca-table tbody tr:last-child td { border-bottom: none; }
  .oca-table .oca-reason { max-width: 160px; text-align: left; white-space: normal; word-break: break-all; color: #555; }

  .oca-status-select { padding: 5px 6px; border: 1px solid #ccc; border-radius: 5px; font-size: 12px; }

  .oca-btn { padding: 6px 12px; border-radius: 6px; font-size: 12px; cursor: pointer; border: 1px solid #ccc; background: #fff; margin: 0 2px; }
  .oca-btn-save { border-color: #1a56db; color: #1a56db; }
  .oca-btn-save:hover { background: #1a56db; color: #fff; }
  .oca-btn-delete { border-color: #c0392b; color: #c0392b; }
  .oca-btn-delete:hover { background: #c0392b; color: #fff; }
</style>
</head>
<body>

<div class="oca-wrap">
  <h2 class="oca-title">취소 ◦ 반품 ◦ 교환 관리</h2>

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
</div>

<script>
  var contextPath = "${pageContext.request.contextPath}";
  var fullList = [];        // 서버에서 받아온 전체 목록 캐시
  var currentFilter = "ALL"; // 현재 선택된 상태 탭

  var TYPE_LABEL = { CANCEL: "취소", RETURN: "반품", EXCHANGE: "교환" };
  var STATUS_OPTIONS = ["REQUESTED", "APPROVED", "REFUNDED", "REJECTED"];
  var STATUS_LABEL = { REQUESTED: "신청됨", APPROVED: "승인됨", REFUNDED: "환불완료", REJECTED: "거절됨" };

  document.addEventListener("DOMContentLoaded", function () {
    loadAdminList();
  });

  // 전체 취소/반품 목록 조회 
  function loadAdminList() {
    fetch(contextPath + "/orderCancel/admin/list/data")
      .then(function (res) { return res.json(); })
      .then(function (result) {
        fullList = result.data || [];
        renderList();
      })
      .catch(function (err) {
        console.error("취소/반품 전체 목록 조회 실패", err);
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
        "<td>" + typeLabel + "</td>" +
        "<td>" + item.ocQuantity + "</td>" +
        "<td>" + formatPrice(item.ocRamount) + "원</td>" +
        "<td class=\"oca-reason\">" + escapeHtml(item.ocReason) + "</td>" +
        "<td>" + formatDate(item.ocRe) + "</td>" +
        "<td>" + (item.ocPr ? formatDate(item.ocPr) : "-") + "</td>" +
        "<td>" + buildStatusSelect(item.ocOutNo, item.ocStatus) + "</td>" +
        "<td>" +
          "<button type=\"button\" class=\"oca-btn oca-btn-save\" onclick=\"saveStatus(" + item.ocOutNo + ")\">저장</button>" +
          "<button type=\"button\" class=\"oca-btn oca-btn-delete\" onclick=\"removeItem(" + item.ocOutNo + ")\">삭제</button>" +
        "</td>";
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
      .then(function (res) { return res.json(); })
      .then(function (result) {
        alert(result.message);
        if (result.success) {
          loadAdminList(); // 목록 다시 조회해서 화면 갱신
        }
      })
      .catch(function (err) {
        console.error("처리상태 변경 실패", err);
        alert("처리상태 변경 중 오류가 발생했습니다.");
      });
  }

  // 삭제 (OrderCancelController#deleteOrderCancel)
  function removeItem(ocOutNo) {
    if (!confirm("해당 취소/반품 신청 내역을 삭제하시겠습니까?")) {
      return;
    }

    var params = new URLSearchParams();
    params.append("ocOutNo", ocOutNo);

    fetch(contextPath + "/orderCancel/admin/delete", {
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

  function escapeHtml(str) {
    if (!str) return "";
    return String(str)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;");
  }
</script>
</body>
</html>
