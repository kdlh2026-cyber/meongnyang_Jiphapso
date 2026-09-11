<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>포인트 조회</title>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
<link rel="stylesheet" href="/css/point/point_list.css">
</head>
<body>

<div class="pt-wrap">
  <h2 class="pt-title">포인트 조회</h2>

  <div class="pt-summary-box">
    <span class="pt-summary-label">전체 보유 포인트</span>
    <span class="pt-summary-value"><span id="ptTotal">0</span><span class="pt-unit">P</span></span>
  </div>

  <div class="pt-summary-box warn">
    <span class="pt-summary-label">소멸 예정 포인트 (7일 이내)</span>
    <span class="pt-summary-value"><span id="ptExpireSoon">0</span><span class="pt-unit">P</span></span>
  </div>

  <h3 class="pt-history-title">포인트 내역</h3>

  <div id="ptEmpty" class="pt-empty" style="display:none;">포인트 내역이 없습니다.</div>

  <div id="ptSections" style="display:none;">
    <div class="pt-section" id="ptSectionEarn">
      <div class="pt-section-header" onclick="toggleSection('ptSectionEarn')">
        <span>적립 · 사용 내역<span class="pt-section-count" id="ptEarnCount"></span></span>
        <span class="pt-section-arrow"></span>
      </div>
      <div class="pt-section-body">
        <div id="ptAccordion" class="pt-accordion"></div>
      </div>
    </div>

    <div class="pt-section" id="ptSectionCancel">
      <div class="pt-section-header" onclick="toggleSection('ptSectionCancel')">
        <span>취소 내역<span class="pt-section-count" id="ptCancelCount"></span></span>
        <span class="pt-section-arrow"></span>
      </div>
      <div class="pt-section-body">
        <div id="ptCancelLog" class="pt-cancel-log"></div>
      </div>
    </div>
  </div>
</div>

<script>
  var contextPath = "${pageContext.request.contextPath}";

  var TYPE_LABEL = { EARN: "적립", USE: "사용", EXPIRE: "소멸", RESTORE: "복원" };

  document.addEventListener("DOMContentLoaded", function () {
    loadPointData();
  });

  function loadPointData() {
    fetch(contextPath + "/point/list/data")
      .then(function (res) { return res.json(); })
      .then(function (result) {
        if (!result.success) {
          alert(result.message || "로그인이 필요합니다.");
          location.href = contextPath + "/member/login";
          return;
        }
        var data = result.data;
        document.getElementById("ptTotal").innerText = formatNumber(data.totalPoint);
        document.getElementById("ptExpireSoon").innerText = formatNumber(data.expireSoonPoint);
        renderList(data.list);
      })
      .catch(function (err) {
        console.error("포인트 조회 실패", err);
      });
  }

  function renderList(list) {
    var sections = document.getElementById("ptSections");
    var empty = document.getElementById("ptEmpty");

    if (!list || list.length === 0) {
      sections.style.display = "none";
      empty.style.display = "block";
      return;
    }

    sections.style.display = "block";
    empty.style.display = "none";

    var earnItems = list.filter(function (item) { return !item.poRelatedNo; });
    var cancelItems = list.filter(function (item) { return !!item.poRelatedNo; });

    document.getElementById("ptEarnCount").innerText = " (" + earnItems.length + "건)";
    document.getElementById("ptCancelCount").innerText = " (" + cancelItems.length + "건)";

    renderEarnList(earnItems, cancelItems);
    renderCancelLog(cancelItems);
  }

  // 섹션 헤더 클릭 시 해당 섹션만 펼침/접힘 토글
  function toggleSection(sectionId) {
    var section = document.getElementById(sectionId);
    if (!section) return;
    section.classList.toggle("open");
  }

  // 적립·사용 내역 렌더링 (헤더 클릭 시 상세가 아래로 펼쳐지는 개별 아코디언 항목들)
  function renderEarnList(earnItems, cancelItems) {
    var wrap = document.getElementById("ptAccordion");
    wrap.innerHTML = "";

    // 원본 poNo -> 취소 이력(사유/일시) 매핑 - 취소된 원본에 취소선+사유를 붙이기 위함
    var cancelMap = {};
    cancelItems.forEach(function (item) {
      cancelMap[item.poRelatedNo] = item;
    });

    earnItems.forEach(function (item, idx) {
      var typeLabel = TYPE_LABEL[item.poType] || item.poType;
      var isPlus = item.poAmount >= 0;
      var amountCls = isPlus ? "pt-amount-plus" : "pt-amount-minus";
      var amountText = (isPlus ? "+" : "") + formatNumber(item.poAmount);

      var cancelEntry = cancelMap[item.poNo];
      var itemCls = "pt-item" + (cancelEntry ? " cancelled" : "");
      var cancelNote = cancelEntry
        ? "<span class=\"pt-item-cancel-note\">취소됨 · " + escapeHtml(cancelEntry.poReason) + "</span>"
        : "";

      var div = document.createElement("div");
      div.className = itemCls;
      div.innerHTML =
        "<div class=\"pt-item-head\" onclick=\"togglePointItem(" + idx + ")\">" +
          "<div class=\"pt-item-head-left\">" +
            "<span class=\"pt-item-type\">" + typeLabel + "</span>" +
            "<span class=\"pt-item-reason\">" + escapeHtml(item.poReason) + "</span>" +
            cancelNote +
          "</div>" +
          "<div class=\"pt-item-head-right\">" +
            "<span class=\"pt-item-amount " + amountCls + "\">" + amountText + "P</span>" +
            "<span class=\"pt-item-arrow\"></span>" +
          "</div>" +
        "</div>" +
        "<div class=\"pt-item-body\">" +
          "<dl class=\"pt-item-body-inner\">" +
            "<dt>처리 후 잔액</dt><dd>" + formatNumber(item.poAfter) + "P</dd>" +
            "<dt>일시</dt><dd>" + formatDate(item.poAt) + "</dd>" +
            (cancelEntry ? ("<dt>취소일시</dt><dd>" + formatDate(cancelEntry.poAt) + "</dd>") : "") +
          "</dl>" +
        "</div>";
      wrap.appendChild(div);
    });
  }

  // 취소 내역 렌더링 (읽기전용 로그 - 클릭 펼침 없이 바로 표시)
  function renderCancelLog(cancelItems) {
    var log = document.getElementById("ptCancelLog");
    log.innerHTML = "";

    if (cancelItems.length === 0) {
      log.innerHTML = "<div class=\"pt-cancel-row\" style=\"text-align:center; color:#999;\">취소된 내역이 없습니다.</div>";
      return;
    }

    cancelItems.forEach(function (item) {
      var isPlus = item.poAmount >= 0;
      var amountCls = isPlus ? "pt-amount-plus" : "pt-amount-minus";
      var amountText = (isPlus ? "+" : "") + formatNumber(item.poAmount);

      var row = document.createElement("div");
      row.className = "pt-cancel-row";
      row.innerHTML =
        "<div class=\"pt-cancel-row-top\">" +
          "<span class=\"pt-cancel-row-reason\">" + escapeHtml(item.poReason) + "</span>" +
          "<span class=\"" + amountCls + "\">" + amountText + "P</span>" +
        "</div>" +
        "<div class=\"pt-cancel-row-original\">취소일시 " + formatDate(item.poAt) + "</div>";
      log.appendChild(row);
    });
  }

  // 항목 클릭 시 해당 항목만 펼침/접힘 토글 (다른 항목은 그대로 유지)
  function togglePointItem(idx) {
    var items = document.querySelectorAll("#ptAccordion .pt-item");
    var target = items[idx];
    if (!target) return;
    target.classList.toggle("open");
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
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>