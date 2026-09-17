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
    position: fixed; inset: 0; background: rgba(74, 50, 38, 0.4);
    display: flex; align-items: center; justify-content: center; z-index: 4000;
  }
  .occf-modal {
    background: #FFFBF5; width: 400px; max-width: 90vw; border-radius: 10px; padding: 28px; position: relative;
    box-shadow: 0 8px 24px rgba(74, 50, 38, 0.22);
    font-family: "Noto Sans KR", "Malgun Gothic", sans-serif;
  }
  .occf-modal h3 { margin: 0 0 20px; font-size: 18px; color: #4A3226; }
  .occf-close {
    position: absolute; top: 14px; right: 16px; border: none; background: none;
    font-size: 22px; cursor: pointer; color: rgba(74, 50, 38, 0.5); line-height: 1;
  }
  .occf-close:hover { color: #FDA58F; }

  .occf-row { margin-bottom: 16px; }
  .occf-row label { display: block; font-size: 13px; color: rgba(74, 50, 38, 0.6); margin-bottom: 6px; }
  .occf-readonly { margin: 0; font-size: 14px; font-weight: 600; color: #4A3226; }

  .occf-row select,
  .occf-row input[type="number"] {
    width: 100%; padding: 9px 10px; border: 1px solid #FFC9CE; border-radius: 6px; font-size: 14px;
    color: #4A3226; background: #FFFFFF; font-family: inherit;
  }
  .occf-row select:focus,
  .occf-row input[type="number"]:focus { outline: none; border-color: #FDA58F; }
  .occf-etc {
    width: 100%; margin-top: 8px; padding: 9px 10px; border: 1px solid #FFC9CE; border-radius: 6px;
    font-size: 14px; min-height: 60px; resize: vertical; font-family: inherit; color: #4A3226; background: #FFFFFF;
  }
  .occf-etc:focus { outline: none; border-color: #FDA58F; }
  .occf-hint { display: inline-block; margin-top: 6px; font-size: 12px; color: rgba(74, 50, 38, 0.5); }

  .occf-buttons { display: flex; gap: 8px; margin-top: 22px; margin-bottom: 0; }
  .occf-btn-cancel, .occf-btn-submit {
    flex: 1; padding: 11px 0; border-radius: 6px; font-size: 14px; cursor: pointer; border: 1px solid transparent;
  }
  .occf-btn-cancel { background: #FFFBF5; color: #4A3226; border-color: #FFC9CE; }
  .occf-btn-cancel:hover { background: #FFF3D8; }
  .occf-btn-submit { background: #4A3226; color: #FFFBF5; }
  .occf-btn-submit:hover { background: #FDA58F; color: #FFFFFF; }
</style>

<script>
  (function () {
    var occfContextPath = "${pageContext.request.contextPath}";
    var occfMaxQuantity = 1;
    function occfToast(message, type) {
      if (typeof showToast === "function") {
        showToast(message, type);
      } else {
        alert(message);
      }
    }

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
        occfToast("수량은 1 ~ " + occfMaxQuantity + " 사이로 입력해주세요.", "error");
        return false;
      }

      var reasonSelect = document.getElementById("occfReasonSelect").value;
      var reasonEtc = document.getElementById("occfReasonEtc").value.trim();
      var reason = (reasonSelect === "ETC") ? reasonEtc : reasonSelect;

      if (reasonSelect === "ETC" && reason === "") {
        occfToast("사유를 입력해주세요.", "error");
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
          occfToast(result.message, result.success ? "success" : "error");
          if (result.success) {
            closeCancelModal();
            setTimeout(function () {
              if (typeof refreshOrderDetail === "function") {
                refreshOrderDetail();
              } else {
                location.reload();
              }
            }, 700);
          }
        })
        .catch(function (err) {
          console.error("취소/반품 신청 실패", err);
          occfToast("신청 중 오류가 발생했습니다.", "error");
        });

      return false;
    };
  })();
</script>