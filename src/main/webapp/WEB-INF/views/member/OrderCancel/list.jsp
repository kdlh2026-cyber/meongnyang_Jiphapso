<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>취소 ◦ 반품 내역</title>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
<link rel="stylesheet" href="/css/orderCancel/list.css">
</head>
<body>
<div class="oc-wrap">
  <h2 class="oc-title">취소 ◦ 반품 내역</h2>

    <div class="status-tabs">
        <a href="${pageContext.request.contextPath}/member/order/list">전체</a>
        <a href="${pageContext.request.contextPath}/member/order/list?status=PAYMENT_PENDING">결제대기</a>
        <a href="${pageContext.request.contextPath}/member/order/list?status=PAID">결제완료</a>
        <a href="${pageContext.request.contextPath}/member/order/list?status=SHIPPING">배송중</a>
        <a href="${pageContext.request.contextPath}/member/order/list?status=DELIVERED">배송완료</a>
        <a href="${pageContext.request.contextPath}/orderCancel/list" class="active">취소 · 반품</a>
    </div>

    <div id="ocEmpty" class="oc-empty" style="display:none;">
        등록된 취소 · 반품 신청 내역이 없습니다.
    </div>

  <table class="oc-table" id="ocTable" style="display:none;">
    <thead>
      <tr>
        <th>신청번호</th>
        <th>유형</th>
        <th>수량</th>
        <th>환불예정금액</th>
        <th>처리상태</th>
        <th>신청일</th>
        <th>처리완료일</th>
        <th>상세</th>
      </tr>
    </thead>
    <tbody id="ocTbody"></tbody>
  </table>
</div>

<!-- 상세보기 모달 -->
<div id="ocDetailModal" class="oc-modal-overlay" style="display:none;">
  <div class="oc-modal">
    <button type="button" class="oc-modal-close" onclick="closeDetailModal()">&times;</button>
    <h3>취소/반품 상세</h3>
    <div id="ocDetailBody" class="oc-dl"></div>
  </div>
</div>

<script>
  var contextPath = "${pageContext.request.contextPath}";
  var TYPE_LABEL = { CANCEL: "취소", RETURN: "반품", EXCHANGE: "교환" };
  var STATUS_INFO = {
    REQUESTED: { label: "신청됨",   cls: "oc-badge-requested" },
    APPROVED:  { label: "승인됨",   cls: "oc-badge-approved"  },
    REFUNDED:  { label: "환불완료", cls: "oc-badge-refunded"  },
    REJECTED:  { label: "거절됨",   cls: "oc-badge-rejected"  }
  };

  document.addEventListener("DOMContentLoaded", function () {
    loadOrderCancelList();
  });

  // 회원 본인 취소/반품 목록 조회 
  function loadOrderCancelList() {
    fetch(contextPath + "/orderCancel/list/data")
      .then(function (res) { return res.json(); })
      .then(function (result) {
        if (!result.success) {
          alert(result.message || "로그인이 필요합니다.");
          location.href = contextPath + "/member/login";
          return;
        }
        renderList(result.data);
      })
      .catch(function (err) {
        console.error("취소/반품 목록 조회 실패", err);
      });
  }

  function renderList(list) {
    var tbody = document.getElementById("ocTbody");
    var table = document.getElementById("ocTable");
    var empty = document.getElementById("ocEmpty");

    tbody.innerHTML = "";

    if (!list || list.length === 0) {
      table.style.display = "none";
      empty.style.display = "block";
      return;
    }

    table.style.display = "table";
    empty.style.display = "none";

    list.forEach(function (item) {
      var statusInfo = STATUS_INFO[item.ocStatus] || { label: item.ocStatus, cls: "" };
      var typeLabel = TYPE_LABEL[item.ocType] || item.ocType;

      var tr = document.createElement("tr");
      tr.innerHTML =
        "<td>" + item.ocOutNo + "</td>" +
        "<td>" + typeLabel + "</td>" +
        "<td>" + item.ocQuantity + "</td>" +
        "<td>" + formatPrice(item.ocRamount) + "원</td>" +
        "<td><span class=\"oc-badge " + statusInfo.cls + "\">" + statusInfo.label + "</span></td>" +
        "<td>" + formatDate(item.ocRe) + "</td>" +
        "<td>" + (item.ocPr ? formatDate(item.ocPr) : "-") + "</td>" +
        "<td><button type=\"button\" class=\"oc-btn-detail\" onclick=\"openDetailModal(" + item.ocOutNo + ")\">상세보기</button></td>";
      tbody.appendChild(tr);
    });
  }

  // 상세보기 모달 오픈 
  function openDetailModal(ocOutNo) {
    fetch(contextPath + "/orderCancel/detail?ocOutNo=" + ocOutNo)
      .then(function (res) { return res.json(); })
      .then(function (result) {
        if (!result.success) {
          alert(result.message || "취소 내역을 찾을 수 없습니다.");
          return;
        }
        renderDetail(result.data);
        document.getElementById("ocDetailModal").style.display = "flex";
      });
  }

  function renderDetail(dto) {
    var statusInfo = STATUS_INFO[dto.ocStatus] || { label: dto.ocStatus, cls: "" };
    var typeLabel = TYPE_LABEL[dto.ocType] || dto.ocType;

    var html =
      "<dt>신청번호</dt><dd>" + dto.ocOutNo + "</dd>" +
      "<dt>주문상세번호</dt><dd>" + dto.odDetailNo + "</dd>" +
      "<dt>처리유형</dt><dd>" + typeLabel + "</dd>" +
      "<dt>처리상태</dt><dd><span class=\"oc-badge " + statusInfo.cls + "\">" + statusInfo.label + "</span></dd>" +
      "<dt>사유</dt><dd>" + escapeHtml(dto.ocReason) + "</dd>" +
      "<dt>수량</dt><dd>" + dto.ocQuantity + "</dd>" +
      "<dt>환불예정금액</dt><dd>" + formatPrice(dto.ocRamount) + "원</dd>" +
      "<dt>차감 배송비</dt><dd>" + formatPrice(dto.ocTurn) + "원</dd>" +
      "<dt>차감 포인트</dt><dd>" + formatPrice(dto.ocPoint) + "P</dd>" +
      "<dt>차감 쿠폰할인</dt><dd>" + formatPrice(dto.ocCoupon) + "원</dd>" +
      "<dt>신청일시</dt><dd>" + formatDate(dto.ocRe) + "</dd>" +
      "<dt>처리완료일시</dt><dd>" + (dto.ocPr ? formatDate(dto.ocPr) : "-") + "</dd>";

    document.getElementById("ocDetailBody").innerHTML = html;
  }

  function closeDetailModal() {
    document.getElementById("ocDetailModal").style.display = "none";
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