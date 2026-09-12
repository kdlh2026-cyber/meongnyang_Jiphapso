<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>[관리자] 포인트 관리</title>
<style>
  * { box-sizing: border-box; }
  body { margin: 0; font-family: "Noto Sans KR", "Malgun Gothic", sans-serif; background: #f7f7f8; color: #222; }

  .pta-wrap { max-width: 1200px; margin: 40px auto; padding: 0 20px 60px; }
  .pta-title { font-size: 22px; font-weight: 700; margin: 0 0 20px; }

  .pta-adjust-box {
    background: #fff; border: 1px solid #e5e5e5; border-radius: 8px; padding: 18px;
    display: flex; gap: 10px; align-items: center; margin-bottom: 20px; flex-wrap: wrap;
  }
  .pta-adjust-box input {
    padding: 8px 10px; border: 1px solid #ccc; border-radius: 6px; font-size: 13px;
    box-sizing: border-box;
  }
  .pta-adjust-box input[name="mId"] { width: 140px; flex-shrink: 0; }
  .pta-adjust-box input[name="amount"] { width: 150px; flex-shrink: 0; }
  .pta-adjust-box input[name="reason"] { flex: 1 1 200px; min-width: 160px; }

  .pta-adjust-box input[type="number"]::-webkit-outer-spin-button,
  .pta-adjust-box input[type="number"]::-webkit-inner-spin-button {
    -webkit-appearance: none; margin: 0;
  }
  .pta-adjust-box input[type="number"] { -moz-appearance: textfield; }

  .pta-btn-adjust {
    padding: 8px 16px; border: none; border-radius: 6px; background: #222; color: #fff;
    font-size: 13px; cursor: pointer; flex-shrink: 0;
  }
  .pta-hint { font-size: 12px; color: #888; width: 100%; margin-top: 4px; }

  .pta-empty {
    padding: 80px 0; text-align: center; color: #888; font-size: 15px;
    background: #fff; border: 1px solid #e5e5e5; border-radius: 8px;
  }

  .pta-table { width: 100%; border-collapse: collapse; background: #fff; border: 1px solid #e5e5e5; border-radius: 8px; overflow: hidden; font-size: 13px; }
  .pta-table th, .pta-table td { padding: 12px 8px; text-align: center; border-bottom: 1px solid #eee; }
  .pta-table thead th { background: #fafafa; color: #555; font-weight: 600; }
  .pta-table tbody tr:last-child td { border-bottom: none; }

  .pta-amount-plus  { color: #1a56db; font-weight: 700; }
  .pta-amount-minus { color: #c0392b; font-weight: 700; }

  .pta-btn-delete {
    padding: 6px 12px; border-radius: 6px; font-size: 12px; cursor: pointer;
    border: 1px solid #c0392b; color: #c0392b; background: #fff;
  }
  .pta-btn-delete:hover { background: #c0392b; color: #fff; }


  .pta-section { margin-bottom: 32px; }
  .pta-section-title {
    font-size: 16px; font-weight: 700; margin: 0 0 12px;
    padding-bottom: 8px; border-bottom: 2px solid #222;
  }
</style>
</head>
<body>

<div class="pta-wrap">
  <h2 class="pta-title">포인트 관리</h2>

  <div class="pta-section">
    <h3 class="pta-section-title">지급 · 차감 관리</h3>

    <div class="pta-adjust-box">
      <input type="text" name="mId" id="ptaMId" placeholder="회원아이디" />
      <input type="number" name="amount" id="ptaAmount" placeholder="포인트 (+/-)" />
      <input type="text" name="reason" id="ptaReason" placeholder="사유 (미입력시 관리자 수동처리)" />
      <button type="button" class="pta-btn-adjust" onclick="adjustPoint()">적용</button>
      <span class="pta-hint">양수를 입력하면 지급, 음수를 입력하면 차감됩니다. 아래 목록에서 "이 회원에게 지급" 버튼을 누르면 회원아이디가 자동으로 채워집니다.</span>
    </div>

    <div class="pta-adjust-box">
      <input type="text" id="ptaSearchReason" placeholder="사유로 목록 검색" oninput="filterByReason()" style="flex:1; min-width:200px;" />
    </div>

    <div id="ptaEmpty" class="pta-empty" style="display:none;">포인트 이력이 없습니다.</div>

    <table class="pta-table" id="ptaTable" style="display:none;">
      <thead>
        <tr>
          <th>이력번호</th>
          <th>회원</th>
          <th>구분</th>
          <th>포인트</th>
          <th>잔액</th>
          <th>사유</th>
          <th>발생일시</th>
          <th>소멸예정일</th>
          <th>관리</th>
        </tr>
      </thead>
      <tbody id="ptaTbody"></tbody>
    </table>
  </div>

  <div class="pta-section">
    <h3 class="pta-section-title">취소 관리</h3>

    <div id="ptcEmpty" class="pta-empty" style="display:none;">취소된 이력이 없습니다.</div>

    <table class="pta-table" id="ptcTable" style="display:none;">
      <thead>
        <tr>
          <th>이력번호</th>
          <th>회원</th>
          <th>취소금액</th>
          <th>취소 사유</th>
          <th>취소일시</th>
        </tr>
      </thead>
      <tbody id="ptcTbody"></tbody>
    </table>
  </div>
</div>

<script>
  var contextPath = "${pageContext.request.contextPath}";
  var TYPE_LABEL = { EARN: "적립", USE: "사용", EXPIRE: "소멸", RESTORE: "복원" };
  var fullPointList = []; // 사유 검색 필터링용 원본 목록 캐시

  document.addEventListener("DOMContentLoaded", function () {
    loadAdminPointList();
  });

  // 전체 포인트 이력 조회 (PointController#adminPointListData)
  function loadAdminPointList() {
    fetch(contextPath + "/admin/point/list/data")
      .then(function (res) { return res.json(); })
      .then(function (result) {
        fullPointList = result.data || [];
        renderList(getEarnItems(fullPointList));
        renderCancelTable(getCancelItems(fullPointList));
      })
      .catch(function (err) {
        console.error("포인트 이력 조회 실패", err);
      });
  }

  // 지급/차감 관리 테이블 대상 (취소 이력 그 자체는 제외 - 아래 취소 관리 테이블에서 따로 보여줌)
  function getEarnItems(list) {
    return list.filter(function (item) { return !item.poRelatedNo; });
  }

  // 취소 관리 테이블 대상 (취소 이력 그 자체만)
  function getCancelItems(list) {
    return list.filter(function (item) { return !!item.poRelatedNo; });
  }

  // 사유로 목록 필터링 (서버 재조회 없이 캐시된 목록에서 바로 필터, 지급 관리 테이블에만 적용)
  function filterByReason() {
    var keyword = document.getElementById("ptaSearchReason").value.trim().toLowerCase();
    var earnItems = getEarnItems(fullPointList);
    if (!keyword) {
      renderList(earnItems);
      return;
    }
    var filtered = earnItems.filter(function (item) {
      return (item.poReason || "").toLowerCase().indexOf(keyword) !== -1;
    });
    renderList(filtered);
  }

  // 목록의 회원아이디를 상단 지급/차감 입력창에 채워서 바로 이어서 처리할 수 있게 함
  function quickFillMId(mId) {
    document.getElementById("ptaMId").value = mId;
    document.getElementById("ptaAmount").focus();
  }

  function renderList(list) {
    var tbody = document.getElementById("ptaTbody");
    var table = document.getElementById("ptaTable");
    var empty = document.getElementById("ptaEmpty");

    tbody.innerHTML = "";

    if (!list || list.length === 0) {
      table.style.display = "none";
      empty.style.display = "block";
      return;
    }

    table.style.display = "table";
    empty.style.display = "none";

    // 이미 취소된 원본들의 poNo 집합 (중복 취소 방지용 - 취소 버튼 대신 "취소됨" 표시)
    var cancelledOriginalNos = {};
    getCancelItems(fullPointList).forEach(function (item) {
      cancelledOriginalNos[item.poRelatedNo] = true;
    });

    list.forEach(function (item) {
      var typeLabel = TYPE_LABEL[item.poType] || item.poType;
      var isPlus = item.poAmount >= 0;
      var amountCls = isPlus ? "pta-amount-plus" : "pta-amount-minus";
      var amountText = (isPlus ? "+" : "") + formatNumber(item.poAmount);

      var mIdValue = item.mid;

      var isAlreadyCancelled = !!cancelledOriginalNos[item.poNo];
      var cancelBtn = isAlreadyCancelled
        ? "<span style=\"color:#aaa; font-size:12px;\">취소됨</span>"
        : "<button type=\"button\" class=\"pta-btn-delete\" onclick=\"reverseItem(" + item.poNo + ")\">취소(사유입력)</button>";

      var tr = document.createElement("tr");
      tr.innerHTML =
        "<td>" + item.poNo + "</td>" +
        "<td>" + escapeHtml(mIdValue) + "</td>" +
        "<td>" + typeLabel + "</td>" +
        "<td class=\"" + amountCls + "\">" + amountText + "P</td>" +
        "<td>" + formatNumber(item.poAfter) + "P</td>" +
        "<td>" + escapeHtml(item.poReason) + "</td>" +
        "<td>" + formatDate(item.poAt) + "</td>" +
        "<td>" + (item.poEx ? formatDate(item.poEx) : "-") + "</td>" +
        "<td>" +
          "<button type=\"button\" class=\"pta-btn-delete\" style=\"border-color:#1a56db; color:#1a56db;\" onclick=\"quickFillMId('" + escapeHtml(mIdValue).replace(/'/g, "&#39;") + "')\">이 회원에게 지급</button>" +
          cancelBtn +
        "</td>";
      tbody.appendChild(tr);
    });
  }

  // 취소 관리 테이블 렌더링 (읽기전용 로그)
  function renderCancelTable(list) {
    var tbody = document.getElementById("ptcTbody");
    var table = document.getElementById("ptcTable");
    var empty = document.getElementById("ptcEmpty");

    tbody.innerHTML = "";

    if (!list || list.length === 0) {
      table.style.display = "none";
      empty.style.display = "block";
      return;
    }

    table.style.display = "table";
    empty.style.display = "none";

    list.forEach(function (item) {
      var isPlus = item.poAmount >= 0;
      var amountCls = isPlus ? "pta-amount-plus" : "pta-amount-minus";
      var amountText = (isPlus ? "+" : "") + formatNumber(item.poAmount);

      var tr = document.createElement("tr");
      tr.innerHTML =
        "<td>" + item.poNo + "</td>" +
        "<td>" + escapeHtml(item.mid) + "</td>" +
        "<td class=\"" + amountCls + "\">" + amountText + "P</td>" +
        "<td>" + escapeHtml(item.poReason) + "</td>" +
        "<td>" + formatDate(item.poAt) + "</td>";
      tbody.appendChild(tr);
    });
  }

  // 관리자 수동 지급/차감 (PointController#adjustPoint) - 입력한 부호 그대로 전송, 회원은 아이디로 식별
  function adjustPoint() {
    var mId = document.getElementById("ptaMId").value.trim();
    var amount = document.getElementById("ptaAmount").value;
    var reason = document.getElementById("ptaReason").value;

    if (!mId || !amount) {
      alert("회원아이디와 포인트를 입력해주세요.");
      return;
    }

    fetch(contextPath + "/admin/point/adjust", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ mId: mId, amount: amount, reason: reason })
    })
      .then(function (res) { return res.json(); })
      .then(function (result) {
        alert(result.success ? "처리되었습니다." : (result.message || "처리에 실패했습니다."));
        if (result.success) {
          document.getElementById("ptaMId").value = "";
          document.getElementById("ptaAmount").value = "";
          document.getElementById("ptaReason").value = "";
          loadAdminPointList();
        }
      })
      .catch(function (err) {
        console.error("포인트 지급/차감 실패", err);
        alert("처리 중 오류가 발생했습니다.");
      });
  }

  function reverseItem(poNo) {
    var reason = prompt("취소 사유를 입력해주세요. (회원 포인트 내역에 그대로 노출됩니다)");
    if (reason === null) {
      return; // 취소(cancel) 버튼 누름 - 아무 처리 안 함
    }
    if (!reason.trim()) {
      alert("취소 사유는 반드시 입력해야 합니다.");
      return;
    }

    fetch(contextPath + "/admin/point/cancel", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ poNo: poNo, reason: reason.trim() })
    })
      .then(function (res) { return res.json(); })
      .then(function (result) {
        alert(result.success ? "취소 처리되었습니다." : (result.message || "취소 처리에 실패했습니다."));
        if (result.success) {
          loadAdminPointList();
        }
      })
      .catch(function (err) {
        console.error("포인트 취소 처리 실패", err);
        alert("취소 처리 중 오류가 발생했습니다.");
      });
  }

  function formatNumber(v) {
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
