<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>

<div id="ocCancelModal" class="occf-overlay" style="display:none;">
  <div class="occf-modal">
    <button type="button" class="occf-close" onclick="closeCancelModal()">&times;</button>
    <h3>취소 ◦ 반품 ◦ 교환 신청</h3>

    <form id="ocCancelFormEl" onsubmit="return submitOrderCancel(event);">
      <input type="hidden" id="occfOdDetailNo" name="odDetailNo" value="" />

      <div class="occf-row">
        <label>상품명</label>
        <p id="occfProductName" class="occf-readonly">-</p>
      </div>

      <div class="occf-row">
        <label for="occfType">처리유형</label>
        <select id="occfType" name="ocType" required>
          <option value="CANCEL">취소</option>
          <option value="RETURN">반품</option>
          <option value="EXCHANGE">교환</option>
        </select>
      </div>

      <div class="occf-row">
        <label for="occfReasonSelect">사유</label>
        <select id="occfReasonSelect" onchange="toggleReasonEtc(this.value)">
          <option value="단순변심">단순변심</option>
          <option value="상품 파손/하자">상품 파손/하자</option>
          <option value="배송 지연">배송 지연</option>
          <option value="주문 실수">주문 실수</option>
          <option value="ETC">직접입력</option>
        </select>
        <textarea id="occfReasonEtc" class="occf-etc" style="display:none;" placeholder="사유를 직접 입력해주세요"></textarea>
      </div>

      <div class="occf-row">
        <label for="occfQuantity">수량</label>
        <input type="number" id="occfQuantity" name="ocQuantity" min="1" value="1" required />
        <span id="occfMaxHint" class="occf-hint"></span>
      </div>

      <div class="occf-row occf-buttons">
        <button type="button" class="occf-btn-cancel" onclick="closeCancelModal()">닫기</button>
        <button type="submit" class="occf-btn-submit">신청하기</button>
      </div>
    </form>
  </div>
</div>

<style>
  .occf-overlay {
    position: fixed; inset: 0; background: rgba(0,0,0,0.5);
    display: flex; align-items: center; justify-content: center; z-index: 1000;
  }
  .occf-modal { background: #fff; width: 400px; max-width: 90vw; border-radius: 10px; padding: 28px; position: relative; }
  .occf-modal h3 { margin: 0 0 20px; font-size: 18px; }
  .occf-close {
    position: absolute; top: 14px; right: 16px; border: none; background: none;
    font-size: 22px; cursor: pointer; color: #999; line-height: 1;
  }

  .occf-row { margin-bottom: 16px; }
  .occf-row label { display: block; font-size: 13px; color: #666; margin-bottom: 6px; }
  .occf-readonly { margin: 0; font-size: 14px; font-weight: 600; color: #222; }

  .occf-row select,
  .occf-row input[type="number"] {
    width: 100%; padding: 9px 10px; border: 1px solid #ccc; border-radius: 6px; font-size: 14px;
  }
  .occf-etc {
    width: 100%; margin-top: 8px; padding: 9px 10px; border: 1px solid #ccc; border-radius: 6px;
    font-size: 14px; min-height: 60px; resize: vertical; font-family: inherit;
  }
  .occf-hint { display: inline-block; margin-top: 6px; font-size: 12px; color: #999; }

  .occf-buttons { display: flex; gap: 8px; margin-top: 22px; margin-bottom: 0; }
  .occf-btn-cancel, .occf-btn-submit {
    flex: 1; padding: 11px 0; border-radius: 6px; font-size: 14px; cursor: pointer; border: none;
  }
  .occf-btn-cancel { background: #eee; color: #444; }
  .occf-btn-submit { background: #222; color: #fff; }
  .occf-btn-submit:hover { background: #000; }
</style>

<script>
  (function () {
    var occfContextPath = "${pageContext.request.contextPath}";
    var occfMaxQuantity = 1;

    // 주문상세 페이지에서 취소/반품/교환 버튼 클릭 시 호출
    window.openCancelModal = function (odDetailNo, productName, maxQuantity) {
      document.getElementById("occfOdDetailNo").value = odDetailNo;
      document.getElementById("occfProductName").innerText = productName || "-";

      occfMaxQuantity = maxQuantity || 1;
      var qtyInput = document.getElementById("occfQuantity");
      qtyInput.value = occfMaxQuantity;
      qtyInput.max = occfMaxQuantity;
      document.getElementById("occfMaxHint").innerText = "최대 " + occfMaxQuantity + "개까지 신청 가능";

      document.getElementById("occfReasonSelect").value = "단순변심";
      document.getElementById("occfReasonEtc").style.display = "none";
      document.getElementById("occfReasonEtc").value = "";

      document.getElementById("ocCancelModal").style.display = "flex";
    };

    window.closeCancelModal = function () {
      document.getElementById("ocCancelModal").style.display = "none";
    };

    window.toggleReasonEtc = function (value) {
      var etc = document.getElementById("occfReasonEtc");
      etc.style.display = (value === "ETC") ? "block" : "none";
    };

    // 취소/반품/교환 신청 등록 (OrderCancelController#insertOrderCancel)
    window.submitOrderCancel = function (e) {
      e.preventDefault();

      var qty = Number(document.getElementById("occfQuantity").value);
      if (qty < 1 || qty > occfMaxQuantity) {
        alert("수량은 1 ~ " + occfMaxQuantity + " 사이로 입력해주세요.");
        return false;
      }

      var reasonSelect = document.getElementById("occfReasonSelect").value;
      var reasonEtc = document.getElementById("occfReasonEtc").value.trim();
      var reason = (reasonSelect === "ETC") ? reasonEtc : reasonSelect;

      if (reasonSelect === "ETC" && reason === "") {
        alert("사유를 입력해주세요.");
        return false;
      }

      var params = new URLSearchParams();
      params.append("odDetailNo", document.getElementById("occfOdDetailNo").value);
      params.append("ocType", document.getElementById("occfType").value);
      params.append("ocReason", reason);
      params.append("ocQuantity", qty);

      fetch(occfContextPath + "/orderCancel/insert", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: params.toString()
      })
        .then(function (res) { return res.json(); })
        .then(function (result) {
          alert(result.message);
          if (result.success) {
            closeCancelModal();
            // 신청 후 화면 갱신: 페이지에 refreshOrderDetail() 이 정의돼 있으면 그걸 사용, 없으면 새로고침
            if (typeof refreshOrderDetail === "function") {
              refreshOrderDetail();
            } else {
              location.reload();
            }
          }
        })
        .catch(function (err) {
          console.error("취소/반품 신청 실패", err);
          alert("신청 중 오류가 발생했습니다.");
        });

      return false;
    };
  })();
</script>
