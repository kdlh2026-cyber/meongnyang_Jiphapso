<%--
  파일 위치: /WEB-INF/views/member/payment/list.jsp
  용도    : 회원 - 결제내역 목록 페이지

  연동    : PaymentController
             GET  /payment/list        -> 이 JSP 로 포워딩 (컨트롤러에서 로그인 체크 후 forward)
             GET  /payment/list/data   -> 화면 로드 후 ajax 로 목록 데이터 조회
             GET  /payment/detail      -> 상세보기 모달용 단건 조회
             GET  /payment/cancelPage  -> 취소 버튼 클릭 시 결제취소 페이지로 이동
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>결제내역</title>
<style>
  * { box-sizing: border-box; }
  body { margin: 0; font-family: "Noto Sans KR", "Malgun Gothic", sans-serif; background: #f7f7f8; color: #222; }

  .pay-wrap { max-width: 1100px; margin: 40px auto; padding: 0 20px 60px; }
  .pay-title { font-size: 22px; font-weight: 700; margin: 0 0 24px; border-bottom: 2px solid #222; padding-bottom: 14px; }

  .pay-empty {
    padding: 80px 0; text-align: center; color: #888; font-size: 15px;
    background: #fff; border: 1px solid #e5e5e5; border-radius: 8px;
  }

  .pay-table { width: 100%; border-collapse: collapse; background: #fff; border: 1px solid #e5e5e5; border-radius: 8px; overflow: hidden; }
  .pay-table th, .pay-table td { padding: 14px 12px; text-align: center; font-size: 14px; border-bottom: 1px solid #eee; }
  .pay-table thead th { background: #fafafa; color: #555; font-weight: 600; }
  .pay-table tbody tr:last-child td { border-bottom: none; }
  .pay-table tbody tr:hover { background: #fbfbfb; }

  .pay-badge { display: inline-block; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; }
  .pay-badge-pending  { background: #eee; color: #666; }
  .pay-badge-paid     { background: #e6f7ec; color: #12805c; }
  .pay-badge-failed   { background: #fdeaea; color: #c0392b; }
  .pay-badge-partial  { background: #fff4e0; color: #b9770e; }
  .pay-badge-refunded { background: #e6f0ff; color: #1a56db; }

  .pay-btn { padding: 6px 14px; border: 1px solid #ccc; background: #fff; border-radius: 6px; font-size: 13px; cursor: pointer; color: #333; margin: 0 2px; }
  .pay-btn:hover { background: #222; color: #fff; border-color: #222; }
  .pay-btn-cancel { border-color: #c0392b; color: #c0392b; }
  .pay-btn-cancel:hover { background: #c0392b; color: #fff; }

  /* 상세보기 모달 */
  .pay-modal-overlay {
    position: fixed; inset: 0; background: rgba(0,0,0,0.5);
    display: flex; align-items: center; justify-content: center; z-index: 1000;
  }
  .pay-modal { background: #fff; width: 420px; max-width: 90vw; border-radius: 10px; padding: 28px; position: relative; }
  .pay-modal h3 { margin: 0 0 18px; font-size: 18px; }
  .pay-modal-close {
    position: absolute; top: 14px; right: 16px; border: none; background: none;
    font-size: 22px; cursor: pointer; color: #999; line-height: 1;
  }
  .pay-dl { display: grid; grid-template-columns: 110px 1fr; row-gap: 10px; column-gap: 8px; margin: 0; font-size: 14px; }
  .pay-dl dt { color: #888; }
  .pay-dl dd { margin: 0; color: #222; word-break: break-all; }
</style>
</head>
<body>

<div class="pay-wrap">
  <h2 class="pay-title">결제내역</h2>

  <div id="payEmpty" class="pay-empty" style="display:none;">결제내역이 없어요.</div>

  <table class="pay-table" id="payTable" style="display:none;">
    <thead>
      <tr>
        <th>결제번호</th>
        <th>주문번호</th>
        <th>결제수단</th>
        <th>결제금액</th>
        <th>처리상태</th>
        <th>요청일시</th>
        <th>완료일시</th>
        <th>관리</th>
      </tr>
    </thead>
    <tbody id="payTbody"></tbody>
  </table>
</div>

<!-- 상세보기 모달 -->
<div id="payDetailModal" class="pay-modal-overlay" style="display:none;">
  <div class="pay-modal">
    <button type="button" class="pay-modal-close" onclick="closeDetailModal()">&times;</button>
    <h3>결제 상세</h3>
    <div id="payDetailBody" class="pay-dl"></div>
  </div>
</div>

<script>
  var contextPath = "${pageContext.request.contextPath}";

  var METHOD_LABEL = {
    TOSSPAY: "토스페이", PAYCO: "페이코", KAKAOPAY: "카카오페이",
    SMILEPAY: "스마일페이", NAVERPAY: "네이버페이"
  };

  var STATUS_INFO = {
    PENDING:          { label: "결제대기",   cls: "pay-badge-pending"  },
    PAID:             { label: "결제완료",   cls: "pay-badge-paid"     },
    FAILED:           { label: "결제실패",   cls: "pay-badge-failed"   },
    PARTIAL_REFUNDED: { label: "부분환불",   cls: "pay-badge-partial"  },
    REFUNDED:         { label: "환불완료",   cls: "pay-badge-refunded" }
  };

  document.addEventListener("DOMContentLoaded", function () {
    loadPaymentList();
  });

  // 회원 본인 결제내역 조회 (PaymentController#selectPaymentListByMember)
  function loadPaymentList() {
    fetch(contextPath + "/payment/list/data")
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
        console.error("결제내역 조회 실패", err);
      });
  }

  function renderList(list) {
    var tbody = document.getElementById("payTbody");
    var table = document.getElementById("payTable");
    var empty = document.getElementById("payEmpty");

    tbody.innerHTML = "";

    if (!list || list.length === 0) {
      table.style.display = "none";
      empty.style.display = "block";
      return;
    }

    table.style.display = "table";
    empty.style.display = "none";

    list.forEach(function (item) {
      var statusInfo = STATUS_INFO[item.payStatus] || { label: item.payStatus, cls: "" };
      var methodLabel = METHOD_LABEL[item.payMethod] || item.payMethod;

      var manageBtns = "<button type=\"button\" class=\"pay-btn\" onclick=\"openDetailModal(" + item.payNo + ")\">상세보기</button>";
      if (item.payStatus === "PAID") {
        manageBtns += "<button type=\"button\" class=\"pay-btn pay-btn-cancel\" onclick=\"goCancelPage(" + item.payNo + ")\">취소</button>";
      }

      var tr = document.createElement("tr");
      tr.innerHTML =
        "<td>" + item.payNo + "</td>" +
        "<td>" + item.orNo + "</td>" +
        "<td>" + methodLabel + "</td>" +
        "<td>" + formatPrice(item.payRealAmt) + "원</td>" +
        "<td><span class=\"pay-badge " + statusInfo.cls + "\">" + statusInfo.label + "</span></td>" +
        "<td>" + formatDate(item.payReqAt) + "</td>" +
        "<td>" + (item.payAt ? formatDate(item.payAt) : "-") + "</td>" +
        "<td>" + manageBtns + "</td>";
      tbody.appendChild(tr);
    });
  }

  // 상세보기 모달 오픈 (PaymentController#selectPaymentOne)
  function openDetailModal(payNo) {
    fetch(contextPath + "/payment/detail?payNo=" + payNo)
      .then(function (res) { return res.json(); })
      .then(function (result) {
        if (!result.success) {
          alert(result.message || "결제 내역을 찾을 수 없습니다.");
          return;
        }
        renderDetail(result.data);
        document.getElementById("payDetailModal").style.display = "flex";
      });
  }

  function renderDetail(dto) {
    var statusInfo = STATUS_INFO[dto.payStatus] || { label: dto.payStatus, cls: "" };
    var methodLabel = METHOD_LABEL[dto.payMethod] || dto.payMethod;

    var html =
      "<dt>결제번호</dt><dd>" + dto.payNo + "</dd>" +
      "<dt>주문번호</dt><dd>" + dto.orNo + "</dd>" +
      "<dt>결제수단</dt><dd>" + methodLabel + "</dd>" +
      "<dt>처리상태</dt><dd><span class=\"pay-badge " + statusInfo.cls + "\">" + statusInfo.label + "</span></dd>" +
      "<dt>거래ID</dt><dd>" + (dto.payTno || "-") + "</dd>" +
      "<dt>상품금액</dt><dd>" + formatPrice(dto.payAmount) + "원</dd>" +
      "<dt>배송비</dt><dd>" + formatPrice(dto.payFee) + "원</dd>" +
      "<dt>쿠폰할인</dt><dd>" + formatPrice(dto.payDiscount) + "원</dd>" +
      "<dt>포인트사용</dt><dd>" + formatPrice(dto.payUsed) + "P</dd>" +
      "<dt>총 할인금액</dt><dd>" + formatPrice(dto.payDis) + "원</dd>" +
      "<dt>실 결제금액</dt><dd><strong>" + formatPrice(dto.payRealAmt) + "원</strong></dd>" +
      "<dt>요청일시</dt><dd>" + formatDate(dto.payReqAt) + "</dd>" +
      "<dt>완료일시</dt><dd>" + (dto.payAt ? formatDate(dto.payAt) : "-") + "</dd>";

    document.getElementById("payDetailBody").innerHTML = html;
  }

  function closeDetailModal() {
    document.getElementById("payDetailModal").style.display = "none";
  }

  // 결제취소 페이지로 이동 (PaymentController#paymentCancelPage)
  function goCancelPage(payNo) {
    location.href = contextPath + "/payment/cancelPage?payNo=" + payNo;
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
