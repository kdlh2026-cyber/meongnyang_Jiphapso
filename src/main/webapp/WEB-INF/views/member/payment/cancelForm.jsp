<%--
  파일 위치: /WEB-INF/views/member/payment/cancelForm.jsp
  용도    : 회원 - 결제취소 신청 페이지 (결제내역 목록의 "취소" 버튼 클릭 시 이동)

  연동    : PaymentController
             GET  /payment/cancelPage  -> 이 JSP 로 포워딩 (payNo 를 model 로 전달)
             GET  /payment/detail      -> 화면 로드 후 ajax 로 결제 정보 조회 (금액 표시용)
             POST /payment/cancel      -> 취소 신청 등록 (payNo, reason)
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>결제취소</title>
<style>
  * { box-sizing: border-box; }
  body { margin: 0; font-family: "Noto Sans KR", "Malgun Gothic", sans-serif; background: #f7f7f8; color: #222; }

  .pc-wrap { max-width: 480px; margin: 60px auto; padding: 0 20px 60px; }
  .pc-card { background: #fff; border: 1px solid #e5e5e5; border-radius: 10px; padding: 28px; }
  .pc-title { font-size: 20px; font-weight: 700; margin: 0 0 22px; }

  .pc-info-dl { display: grid; grid-template-columns: 90px 1fr; row-gap: 10px; column-gap: 8px; margin: 0 0 20px; font-size: 14px; }
  .pc-info-dl dt { color: #888; }
  .pc-info-dl dd { margin: 0; color: #222; }
  .pc-info-dl .amt { font-weight: 700; color: #c0392b; }

  .pc-notice {
    background: #fff8f8; border: 1px solid #fdd; color: #c0392b; font-size: 13px;
    padding: 12px 14px; border-radius: 8px; margin-bottom: 20px; line-height: 1.5;
  }

  .pc-row { margin-bottom: 16px; }
  .pc-row label { display: block; font-size: 13px; color: #666; margin-bottom: 6px; }
  .pc-row select, .pc-row textarea {
    width: 100%; padding: 9px 10px; border: 1px solid #ccc; border-radius: 6px; font-size: 14px; font-family: inherit;
  }
  .pc-row textarea { min-height: 70px; resize: vertical; margin-top: 8px; display: none; }

  .pc-buttons { display: flex; gap: 8px; margin-top: 22px; }
  .pc-btn-cancel, .pc-btn-submit { flex: 1; padding: 12px 0; border-radius: 6px; font-size: 14px; cursor: pointer; border: none; }
  .pc-btn-cancel { background: #eee; color: #444; }
  .pc-btn-submit { background: #c0392b; color: #fff; }
  .pc-btn-submit:hover { background: #a5301f; }
</style>
</head>
<body>

<div class="pc-wrap">
  <div class="pc-card">
    <h3 class="pc-title">결제취소 신청</h3>

    <div id="pcInfoBox" class="pc-info-dl"></div>

    <div class="pc-notice">
      취소 신청 후에는 되돌릴 수 없어요. 사용한 쿠폰·포인트는 취소 시 반환되지 않을 수 있어요.
    </div>

    <div class="pc-row">
      <label for="pcReasonSelect">취소 사유</label>
      <select id="pcReasonSelect" onchange="toggleReasonEtc(this.value)">
        <option value="단순변심">단순변심</option>
        <option value="주문 실수">주문 실수</option>
        <option value="배송 지연">배송 지연</option>
        <option value="ETC">직접입력</option>
      </select>
      <textarea id="pcReasonEtc" placeholder="사유를 직접 입력해주세요"></textarea>
    </div>

    <div class="pc-buttons">
      <button type="button" class="pc-btn-cancel" onclick="history.back()">닫기</button>
      <button type="button" class="pc-btn-submit" onclick="submitCancel()">취소 신청하기</button>
    </div>
  </div>
</div>

<script>
  var contextPath = "${pageContext.request.contextPath}";
  var payNo = ${payNo};

  var METHOD_LABEL = {
    TOSSPAY: "토스페이", PAYCO: "페이코", KAKAOPAY: "카카오페이",
    SMILEPAY: "스마일페이", NAVERPAY: "네이버페이"
  };

  document.addEventListener("DOMContentLoaded", function () {
    loadPaymentInfo();
  });

  // 결제 정보 조회 (PaymentController#selectPaymentOne) - 취소 전 금액/수단 확인용
  function loadPaymentInfo() {
    fetch(contextPath + "/payment/detail?payNo=" + payNo)
      .then(function (res) { return res.json(); })
      .then(function (result) {
        if (!result.success) {
          alert(result.message || "결제 내역을 찾을 수 없습니다.");
          history.back();
          return;
        }
        renderInfo(result.data);
      })
      .catch(function (err) {
        console.error("결제 정보 조회 실패", err);
      });
  }

  function renderInfo(dto) {
    var methodLabel = METHOD_LABEL[dto.payMethod] || dto.payMethod;

    var html =
      "<dt>결제번호</dt><dd>" + dto.payNo + "</dd>" +
      "<dt>주문번호</dt><dd>" + dto.orNo + "</dd>" +
      "<dt>결제수단</dt><dd>" + methodLabel + "</dd>" +
      "<dt>취소금액</dt><dd class=\"amt\">" + formatPrice(dto.payRealAmt) + "원</dd>";

    document.getElementById("pcInfoBox").innerHTML = html;
  }

  function toggleReasonEtc(value) {
    var etc = document.getElementById("pcReasonEtc");
    etc.style.display = (value === "ETC") ? "block" : "none";
  }

  // 취소 신청 등록 (PaymentController#cancelPayment)
  function submitCancel() {
    var reasonSelect = document.getElementById("pcReasonSelect").value;
    var reasonEtc = document.getElementById("pcReasonEtc").value.trim();
    var reason = (reasonSelect === "ETC") ? reasonEtc : reasonSelect;

    if (reasonSelect === "ETC" && reason === "") {
      alert("사유를 입력해주세요.");
      return;
    }

    if (!confirm("결제를 취소하시겠습니까? 되돌릴 수 없어요.")) {
      return;
    }

    var params = new URLSearchParams();
    params.append("payNo", payNo);
    params.append("reason", reason);

    fetch(contextPath + "/payment/cancel", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: params.toString()
    })
      .then(function (res) { return res.json(); })
      .then(function (result) {
        alert(result.message);
        if (result.success) {
          location.href = contextPath + "/payment/list";
        }
      })
      .catch(function (err) {
        console.error("결제취소 실패", err);
        alert("취소 처리 중 오류가 발생했습니다.");
      });
  }

  function formatPrice(v) {
    if (v === null || v === undefined) return "0";
    return Number(v).toLocaleString("ko-KR");
  }
</script>
</body>
</html>
