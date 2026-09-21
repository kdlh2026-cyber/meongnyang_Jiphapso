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
  /* 팔레트: 메인옐로우 #FDCC61 / 코랄핑크 #FDA58F / 딥브라운 #4A3226 / 웜크림 #FFF3D8 / 소프트핑크 #FFC9CE / 웜화이트 #FFFBF5 */
  .occf-overlay, .occf-overlay * { box-sizing: border-box; }

  /* 배경 어둡게 + 살짝 블러 */
  .occf-overlay {
    position: fixed; inset: 0; background: rgba(74, 50, 38, 0.45);
    backdrop-filter: blur(2px);
    display: flex; align-items: center; justify-content: center; z-index: 4000;
  }

  /* 모달 본체 - 열릴 때 아래에서 살짝 올라오는 애니메이션 */
  .occf-modal {
    background: #FFFFFF; width: 420px; max-width: 92vw; max-height: 90vh; overflow-y: auto;
    border-radius: 20px; padding: 30px 28px 26px; position: relative;
    box-shadow: 0 16px 40px rgba(74, 50, 38, 0.25);
    font-family: "Noto Sans KR", "Malgun Gothic", sans-serif;
    animation: occf-pop 0.22s ease;
  }
  @keyframes occf-pop {
    from { opacity: 0; transform: translateY(16px) scale(0.98); }
    to   { opacity: 1; transform: translateY(0) scale(1); }
  }

  /* 제목 - 왼쪽 노란 포인트 바 + 아래 크림 선 */
  .occf-modal h3 {
    display: flex; align-items: center; gap: 8px;
    margin: 0 0 22px; padding-bottom: 16px; border-bottom: 1px solid #FFF3D8;
    font-size: 18px; font-weight: 700; color: #4A3226;
  }
  .occf-modal h3::before { content: ""; width: 5px; height: 18px; border-radius: 3px; background: #FDCC61; }

  /* 닫기 버튼 - 동그란 크림 버튼 */
  .occf-close {
    position: absolute; top: 16px; right: 16px; width: 32px; height: 32px;
    border: none; border-radius: 50%; background: #FFF3D8;
    font-size: 20px; cursor: pointer; color: rgba(74, 50, 38, 0.6); line-height: 1;
    display: flex; align-items: center; justify-content: center;
    transition: all 0.2s;
  }
  .occf-close:hover { background: #FDA58F; color: #FFFFFF; }

  .occf-row { margin-bottom: 18px; }
  .occf-row label { display: block; font-size: 13px; font-weight: 600; color: rgba(74, 50, 38, 0.7); margin-bottom: 7px; }

  /* 상품명 - 크림 배경 박스로 '읽기 전용'임을 표시 */
  .occf-readonly {
    margin: 0; padding: 11px 14px; background: #FFF3D8; border-radius: 10px;
    font-size: 14px; font-weight: 600; color: #4A3226; word-break: keep-all; line-height: 1.5;
  }

  /* 입력 요소 공통 */
  .occf-row select,
  .occf-row input[type="number"] {
    width: 100%; padding: 12px 14px; border: 1px solid #FFC9CE; border-radius: 10px; font-size: 14px;
    color: #4A3226; background: #FFFFFF; font-family: inherit;
    transition: border-color 0.15s, box-shadow 0.15s;
  }
  /* select - 기본 화살표 대신 코랄색 화살표 */
  .occf-row select {
    padding-right: 40px; cursor: pointer;
    appearance: none; -webkit-appearance: none;
    background: #FFFFFF url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8' viewBox='0 0 12 8'%3E%3Cpath fill='%23FDA58F' d='M1 1l5 5 5-5'/%3E%3C/svg%3E") no-repeat right 14px center;
  }
  .occf-row select:hover,
  .occf-row input[type="number"]:hover { border-color: #FDA58F; }
  .occf-row select:focus,
  .occf-row input[type="number"]:focus { outline: none; border-color: #FDA58F; box-shadow: 0 0 0 3px rgba(253, 165, 143, 0.15); }

  .occf-etc {
    width: 100%; margin-top: 8px; padding: 12px 14px; border: 1px solid #FFC9CE; border-radius: 10px;
    font-size: 14px; min-height: 80px; resize: vertical; font-family: inherit; color: #4A3226; background: #FFFFFF;
    transition: border-color 0.15s, box-shadow 0.15s;
  }
  .occf-etc::placeholder { color: rgba(74, 50, 38, 0.35); }
  .occf-etc:focus { outline: none; border-color: #FDA58F; box-shadow: 0 0 0 3px rgba(253, 165, 143, 0.15); }

  /* 최대 수량 안내 - 코랄색으로 눈에 띄게 */
  .occf-hint { display: inline-block; margin-top: 7px; font-size: 12px; font-weight: 600; color: #FDA58F; }

  /* 하단 버튼 - 알약 모양 */
  .occf-buttons { display: flex; gap: 10px; margin-top: 26px; margin-bottom: 0; }
  .occf-btn-cancel, .occf-btn-submit {
    flex: 1; padding: 13px 0; border-radius: 999px; font-size: 14px; font-weight: 700; cursor: pointer;
    border: 1px solid transparent; transition: all 0.2s;
  }
  .occf-btn-cancel { background: #FFFFFF; color: #4A3226; border-color: #FFC9CE; }
  .occf-btn-cancel:hover { background: #FFF3D8; border-color: #FDA58F; }
  .occf-btn-submit { background: #4A3226; color: #FFFBF5; box-shadow: 0 4px 12px rgba(74, 50, 38, 0.2); }
  .occf-btn-submit:hover { background: #FDCC61; color: #4A3226; transform: translateY(-1px); }

  /* 모바일 */
  @media (max-width: 480px) {
    .occf-modal { padding: 24px 18px 20px; border-radius: 16px; }
  }
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