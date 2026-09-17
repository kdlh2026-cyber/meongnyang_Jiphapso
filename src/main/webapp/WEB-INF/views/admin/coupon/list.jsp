<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>[관리자] 쿠폰 관리</title>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
<link rel="stylesheet" href="/css/coupon/adminList.css">
</head>
<body>

<div class="cpa-wrap">
  <h2 class="cpa-title">쿠폰 관리</h2>

  <!-- 쿠폰 등록 폼 -->
  <form class="cpa-form" id="cpaForm" onsubmit="return submitCoupon(event);">
    <div class="cpa-field cpa-span2">
      <label>쿠폰명</label>
      <input type="text" id="fCoName" required placeholder="예: MUNGNYANG JIPHAPSO DISCOUNT COUPON">
    </div>
    <div class="cpa-field">
      <label>할인율</label>
      <select id="fCoVal" required>
        <option value="10">10%</option>
        <option value="20">20%</option>
        <option value="30">30%</option>
        <option value="40">40%</option>
        <option value="50">50%</option>
      </select>
    </div>
    <div class="cpa-field">
      <label>적용범위</label>
      <select id="fCoScope" onchange="togglePNo(this.value)">
        <option value="ALL">전체상품</option>
        <option value="PRODUCT">특정상품</option>
      </select>
    </div>

    <div class="cpa-field">
      <label>최소주문금액</label>
      <input type="number" id="fCoMinAmt" value="0" min="0">
    </div>
    <div class="cpa-field">
      <label>최대할인금액 (선택)</label>
      <input type="number" id="fCoMaxAmt" min="0" placeholder="정률 할인 상한">
    </div>
    <div class="cpa-field cpa-span2" id="fPNoField" style="display:none;">
      <label>대상 상품</label>
      <input type="text" id="fPNoSearch" placeholder="상품명을 입력해 검색하세요" autocomplete="off"
             oninput="searchProducts(this.value)">
      <input type="hidden" id="fPNo">
      <div id="fPNoSelected" class="cpa-search-selected" style="display:none;"></div>
      <div id="fPNoResults" class="cpa-search-results" style="display:none;"></div>
    </div>
    <div class="cpa-field">
      <label>발급사유</label>
      <input type="text" id="fCoReason" placeholder="예: 신규가입 / 생일 / 이벤트">
    </div>

    <div class="cpa-field">
      <label>유효기간(일, 선택)</label>
      <input type="number" id="fCoDays" min="1" placeholder="비우면 정책 자동적용">
    </div>
    <div class="cpa-field">
      <label>다운로드 시작일</label>
      <input type="date" id="fCoStart" required>
    </div>
    <div class="cpa-field">
      <label>다운로드 종료일</label>
      <input type="date" id="fCoEnd" required>
    </div>

    <div class="cpa-submit-row">
      <button type="submit" class="cpa-btn-submit">쿠폰 등록</button>
    </div>
  </form>

  <!-- 쿠폰 템플릿 목록 -->
  <h3 class="cpa-section-title">쿠폰 템플릿 목록</h3>
  <div id="cpaCouponEmpty" class="cpa-empty" style="display:none;">등록된 쿠폰이 없습니다.</div>
  <table class="cpa-table" id="cpaCouponTable" style="display:none;">
    <thead>
      <tr>
        <th>이미지</th>
        <th>쿠폰명</th>
        <th>할인율</th>
        <th>최소주문금액</th>
        <th>최대할인</th>
        <th>범위</th>
        <th>발급사유</th>
        <th>유효기간</th>
        <th>다운로드기간</th>
        <th>관리</th>
      </tr>
    </thead>
    <tbody id="cpaCouponTbody"></tbody>
  </table>

  <!-- 회원별 쿠폰 발급현황 -->
  <h3 class="cpa-section-title">회원 쿠폰 발급현황</h3>
  <div id="cpaMemberEmpty" class="cpa-empty" style="display:none;">발급된 쿠폰이 없습니다.</div>
  <table class="cpa-table" id="cpaMemberTable" style="display:none;">
    <thead>
      <tr>
        <th>회원아이디</th>
        <th>쿠폰명</th>
        <th>할인율</th>
        <th>상태</th>
        <th>발급일</th>
        <th>만료일</th>
        <th>사용일</th>
        <th>관리</th>
      </tr>
    </thead>
    <tbody id="cpaMemberTbody"></tbody>
  </table>
</div>

<!-- 회원아이디 클릭 시 -> 그 회원이 받은 쿠폰만 모아서 보여주는 모달 -->
<div class="cpa-modal-overlay" id="cpaMemberModalOverlay">
  <div class="cpa-modal">
    <button type="button" class="cpa-modal-close" onclick="closeMemberCouponModal()">&times;</button>
    <h3 id="cpaMemberModalTitle">회원 쿠폰 발급 내역</h3>
    <table class="cpa-modal-table">
      <thead>
        <tr>
          <th>쿠폰명</th>
          <th>할인율</th>
          <th>상태</th>
          <th>발급일</th>
          <th>만료일</th>
          <th>사용일</th>
        </tr>
      </thead>
      <tbody id="cpaMemberModalTbody"></tbody>
    </table>
    <div id="cpaMemberModalEmpty" class="cpa-modal-empty" style="display:none;">발급받은 쿠폰이 없습니다.</div>
  </div>
</div>

<!-- 커스텀 알림 모달 (기본 alert 대체) -->
<div class="ax-modal-overlay" id="axAlertOverlay">
  <div class="ax-modal">
    <div class="ax-modal-message" id="axAlertMessage"></div>
    <div class="ax-modal-actions">
      <button type="button" class="ax-btn ax-btn-primary" id="axAlertOkBtn">확인</button>
    </div>
  </div>
</div>

<!-- 커스텀 확인 모달 (기본 confirm 대체) -->
<div class="ax-modal-overlay" id="axConfirmOverlay">
  <div class="ax-modal">
    <div class="ax-modal-message" id="axConfirmMessage"></div>
    <div class="ax-modal-actions">
      <button type="button" class="ax-btn" id="axConfirmCancelBtn">취소</button>
      <button type="button" class="ax-btn ax-btn-primary" id="axConfirmOkBtn">확인</button>
    </div>
  </div>
</div>

<script>
  // ===== 커스텀 알림/확인 모달 (기본 alert/confirm 대체) =====
  function showAlert(message, callback) {
    var overlay = document.getElementById("axAlertOverlay");
    document.getElementById("axAlertMessage").textContent = message;
    document.getElementById("axAlertOkBtn").onclick = function () {
      overlay.classList.remove("show");
      if (typeof callback === "function") callback();
    };
    overlay.classList.add("show");
  }

  function showConfirm(message, onConfirm, options) {
    options = options || {};
    var overlay = document.getElementById("axConfirmOverlay");
    document.getElementById("axConfirmMessage").textContent = message;

    var okBtn = document.getElementById("axConfirmOkBtn");
    okBtn.textContent = options.okText || "확인";
    okBtn.className = "ax-btn " + (options.danger ? "ax-btn-danger" : "ax-btn-primary");
    okBtn.onclick = function () {
      overlay.classList.remove("show");
      if (typeof onConfirm === "function") onConfirm();
    };

    document.getElementById("axConfirmCancelBtn").onclick = function () {
      overlay.classList.remove("show");
    };

    overlay.classList.add("show");
  }

  var contextPath = "${pageContext.request.contextPath}";
  var IMAGE_BASE = contextPath + "/images/coupon/";

  var MEMBER_STATUS_INFO = {
    UNUSED:  { label: "사용가능", cls: "cpa-badge-unused" },
    USED:    { label: "사용완료", cls: "cpa-badge-used" },
    EXPIRED: { label: "기간만료", cls: "cpa-badge-expired" }
  };

  // /admin/coupon/member/list 로 한 번에 받아둔 전체 목록 캐시
  // (회원아이디 클릭 시 별도 API 호출 없이 여기서 필터링해서 모달에 보여줌)
  var memberCouponFullList = [];

  document.addEventListener("DOMContentLoaded", function () {
    loadCouponList();
    loadMemberCouponList();
  });

  function togglePNo(scope) {
    document.getElementById("fPNoField").style.display = (scope === "PRODUCT") ? "flex" : "none";
    if (scope !== "PRODUCT") {
      document.getElementById("fPNo").value = "";
      document.getElementById("fPNoSearch").value = "";
      document.getElementById("fPNoSelected").style.display = "none";
      document.getElementById("fPNoResults").style.display = "none";
      document.getElementById("fPNoResults").innerHTML = "";
    }
  }

  // ================= 대상 상품 검색 (쿠폰 등록폼) =================

  var productSearchTimer = null;

  // 상품명 입력 시 서버로 검색 요청 (CouponController#searchProducts, 입력 250ms 디바운스)
  function searchProducts(keyword) {
    document.getElementById("fPNo").value = ""; // 검색어를 바꾸면 이전 선택은 무효화
    document.getElementById("fPNoSelected").style.display = "none";
    clearTimeout(productSearchTimer);

    var resultsBox = document.getElementById("fPNoResults");
    if (!keyword || keyword.trim().length === 0) {
      resultsBox.style.display = "none";
      resultsBox.innerHTML = "";
      return;
    }

    productSearchTimer = setTimeout(function () {
      fetch(contextPath + "/admin/coupon/products?keyword=" + encodeURIComponent(keyword))
        .then(function (res) { return res.json(); })
        .then(function (result) { renderProductSearchResults(result.data || []); })
        .catch(function (err) { console.error("상품 검색 실패", err); });
    }, 250);
  }

  function renderProductSearchResults(list) {
    var resultsBox = document.getElementById("fPNoResults");
    resultsBox.innerHTML = "";

    if (!list || list.length === 0) {
      resultsBox.innerHTML = "<div class=\"cpa-search-empty\">검색 결과가 없습니다.</div>";
      resultsBox.style.display = "block";
      return;
    }

    list.forEach(function (item) {
      var div = document.createElement("div");
      div.className = "cpa-search-item";
      div.textContent = item.pTitle + " (No." + item.pNo + ")";
      div.onclick = function () { selectProduct(item); };
      resultsBox.appendChild(div);
    });
    resultsBox.style.display = "block";
  }

  function selectProduct(item) {
    document.getElementById("fPNo").value = item.pNo;
    document.getElementById("fPNoSearch").value = item.pTitle;
    document.getElementById("fPNoResults").style.display = "none";
    document.getElementById("fPNoResults").innerHTML = "";
    var selected = document.getElementById("fPNoSelected");
    selected.textContent = "선택됨: " + item.pTitle + " (No." + item.pNo + ")";
    selected.style.display = "block";
  }

  // 검색결과 바깥을 클릭하면 드롭다운 닫기
  document.addEventListener("click", function (e) {
    var field = document.getElementById("fPNoField");
    if (field && !field.contains(e.target)) {
      document.getElementById("fPNoResults").style.display = "none";
    }
  });

  // ================= 쿠폰 템플릿 =================

  // 전체 쿠폰 목록 (CouponController#adminCouponListData)
  // 주의: res.ok 체크가 없으면 서버 500(SQL 에러 등)이 나도 json 파싱만 실패하고
  //       console.error만 찍힌 채 화면엔 아무 표시도 없이 "먹통"처럼 보임 -> 반드시 체크.
  function loadCouponList() {
    fetch(contextPath + "/admin/coupon/list/data")
      .then(function (res) {
        if (!res.ok) throw new Error("서버 오류 (HTTP " + res.status + ")");
        return res.json();
      })
      .then(function (result) {
        if (!result.success) {
          showAlert(result.message || "쿠폰 목록을 불러오지 못했습니다.");
          return;
        }
        renderCouponList(result.data || []);
      })
      .catch(function (err) {
        console.error("쿠폰 목록 조회 실패", err);
        showAlert("쿠폰 목록 조회 중 오류가 발생했습니다.\n" + err.message);
      });
  }

  function renderCouponList(list) {
    var tbody = document.getElementById("cpaCouponTbody");
    var table = document.getElementById("cpaCouponTable");
    var empty = document.getElementById("cpaCouponEmpty");
    tbody.innerHTML = "";

    if (!list || list.length === 0) {
      table.style.display = "none";
      empty.style.display = "block";
      return;
    }
    table.style.display = "table";
    empty.style.display = "none";

    list.forEach(function (item) {
      var periodText = item.coDays ? (item.coDays + "일") : "무제한";
      var scopeText = (item.coScope === "PRODUCT") ? ("특정상품" + (item.pTitle ? " (" + escapeHtml(item.pTitle) + ")" : "")) : "전체상품";

      var tr = document.createElement("tr");
      tr.innerHTML =
        "<td><img src=\"" + IMAGE_BASE + item.imageName + "\" alt=\"\"></td>" +
        "<td>" + escapeHtml(item.coName) + "</td>" +
        "<td>" + item.coVal + "%</td>" +
        "<td>" + formatPrice(item.coMinAmt) + "원</td>" +
        "<td>" + (item.coMaxAmt ? formatPrice(item.coMaxAmt) + "원" : "-") + "</td>" +
        "<td>" + scopeText + "</td>" +
        "<td>" + escapeHtml(item.coReason || "-") + "</td>" +
        "<td>" + periodText + "</td>" +
        "<td>" + formatDate(item.coStart) + " ~ " + formatDate(item.coEnd) + "</td>" +
        "<td><button type=\"button\" class=\"cpa-btn\" onclick=\"deleteCoupon(" + item.coNo + ")\">삭제</button></td>";
      tbody.appendChild(tr);
    });
  }

  // 쿠폰 등록 (CouponController#adminInsertCoupon)
  function submitCoupon(e) {
    e.preventDefault();

    if (document.getElementById("fCoScope").value === "PRODUCT" && !document.getElementById("fPNo").value) {
      showAlert("대상 상품을 검색해서 선택해주세요.");
      return false;
    }

    var params = new URLSearchParams();
    params.append("coName", document.getElementById("fCoName").value);
    params.append("coType", "PERCENT");
    params.append("coVal", document.getElementById("fCoVal").value);
    params.append("coScope", document.getElementById("fCoScope").value);
    params.append("coMinAmt", document.getElementById("fCoMinAmt").value || "0");
    if (document.getElementById("fCoMaxAmt").value) params.append("coMaxAmt", document.getElementById("fCoMaxAmt").value);
    if (document.getElementById("fCoScope").value === "PRODUCT" && document.getElementById("fPNo").value) {
      params.append("pNo", document.getElementById("fPNo").value);
    }
    params.append("coReason", document.getElementById("fCoReason").value);
    if (document.getElementById("fCoDays").value) params.append("coDays", document.getElementById("fCoDays").value);
    params.append("coStart", document.getElementById("fCoStart").value);
    params.append("coEnd", document.getElementById("fCoEnd").value);

    fetch(contextPath + "/admin/coupon/insert", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: params.toString()
    })
      .then(function (res) {
        if (!res.ok) throw new Error("서버 오류 (HTTP " + res.status + ")");
        return res.json();
      })
      .then(function (result) {
        showAlert(result.message, function () {
          if (result.success) {
            document.getElementById("cpaForm").reset();
            togglePNo("ALL");
            loadCouponList();
          }
        });
      })
      .catch(function (err) {
        console.error("쿠폰 등록 실패", err);
        showAlert("쿠폰 등록 중 오류가 발생했습니다.\n" + err.message);
      });
    return false;
  }

  // 쿠폰 삭제 (CouponController#adminDeleteCoupon)
  function deleteCoupon(coNo) {
    showConfirm("해당 쿠폰을 삭제하시겠습니까?\n(이미 발급된 회원쿠폰에는 영향을 주지 않습니다)", function () {
      fetch(contextPath + "/admin/coupon/" + coNo, { method: "DELETE" })
        .then(function (res) {
          if (!res.ok) throw new Error("서버 오류 (HTTP " + res.status + ")");
          return res.json();
        })
        .then(function (result) {
          if (result.success) {
            loadCouponList();
          } else {
            showAlert(result.message || "삭제에 실패했습니다.");
          }
        })
        .catch(function (err) {
          console.error("쿠폰 삭제 실패", err);
          showAlert("삭제 중 오류가 발생했습니다.\n" + err.message);
        });
    }, { danger: true, okText: "삭제" });
  }

  // ================= 회원 쿠폰 발급현황 =================

  // 회원 발급 쿠폰 전체 목록 (CouponController#adminMemberCouponList)
  function loadMemberCouponList() {
    fetch(contextPath + "/admin/coupon/member/list")
      .then(function (res) {
        if (!res.ok) throw new Error("서버 오류 (HTTP " + res.status + ")");
        return res.json();
      })
      .then(function (result) {
        if (!result.success) {
          showAlert(result.message || "회원 쿠폰 발급현황을 불러오지 못했습니다.");
          return;
        }
        memberCouponFullList = result.data || []; // 회원아이디 클릭 시 필터링할 원본 캐시
        renderMemberCouponList(memberCouponFullList);
      })
      .catch(function (err) {
        console.error("회원 쿠폰 발급현황 조회 실패", err);
        showAlert("회원 쿠폰 발급현황 조회 중 오류가 발생했습니다.\n" + err.message);
      });
  }

  function renderMemberCouponList(list) {
    var tbody = document.getElementById("cpaMemberTbody");
    var table = document.getElementById("cpaMemberTable");
    var empty = document.getElementById("cpaMemberEmpty");
    tbody.innerHTML = "";

    if (!list || list.length === 0) {
      table.style.display = "none";
      empty.style.display = "block";
      return;
    }
    table.style.display = "table";
    empty.style.display = "none";

    list.forEach(function (item) {
      var statusInfo = MEMBER_STATUS_INFO[item.mcStatus] || { label: item.mcStatus, cls: "" };

      var tr = document.createElement("tr");
      tr.innerHTML =
        "<td><span class=\"cpa-mid-link\" onclick=\"showMemberCouponModal('" + escapeHtml(item.mId) + "')\">" + escapeHtml(item.mId) + "</span></td>" +
        "<td>" + escapeHtml(item.coName) + "</td>" +
        "<td>" + item.coVal + "%</td>" +
        "<td><span class=\"cpa-badge " + statusInfo.cls + "\">" + statusInfo.label + "</span></td>" +
        "<td>" + formatDate(item.mcIssued) + "</td>" +
        "<td>" + (item.mcExpired ? formatDate(item.mcExpired) : "무제한") + "</td>" +
        "<td>" + (item.mcUsed ? formatDate(item.mcUsed) : "-") + "</td>" +
        "<td><button type=\"button\" class=\"cpa-btn\" onclick=\"deleteMemberCoupon(" + item.mcNo + ")\">삭제</button></td>";
      tbody.appendChild(tr);
    });
  }

  // 회원아이디 클릭 -> memberCouponFullList 에서 그 회원 것만 걸러서 모달에 표시
  function showMemberCouponModal(mId) {
    var list = memberCouponFullList.filter(function (item) { return item.mId === mId; });

    document.getElementById("cpaMemberModalTitle").textContent = mId + " 님의 쿠폰 발급 내역";

    var tbody = document.getElementById("cpaMemberModalTbody");
    var empty = document.getElementById("cpaMemberModalEmpty");
    tbody.innerHTML = "";

    if (!list || list.length === 0) {
      empty.style.display = "block";
    } else {
      empty.style.display = "none";
      list.forEach(function (item) {
        var statusInfo = MEMBER_STATUS_INFO[item.mcStatus] || { label: item.mcStatus, cls: "" };
        var tr = document.createElement("tr");
        tr.innerHTML =
          "<td>" + escapeHtml(item.coName) + "</td>" +
          "<td>" + item.coVal + "%</td>" +
          "<td><span class=\"cpa-badge " + statusInfo.cls + "\">" + statusInfo.label + "</span></td>" +
          "<td>" + formatDate(item.mcIssued) + "</td>" +
          "<td>" + (item.mcExpired ? formatDate(item.mcExpired) : "무제한") + "</td>" +
          "<td>" + (item.mcUsed ? formatDate(item.mcUsed) : "-") + "</td>";
        tbody.appendChild(tr);
      });
    }

    document.getElementById("cpaMemberModalOverlay").classList.add("show");
  }

  function closeMemberCouponModal() {
    document.getElementById("cpaMemberModalOverlay").classList.remove("show");
  }

  // 발급된 회원쿠폰 강제 삭제 (CouponController#adminDeleteMemberCoupon)
  function deleteMemberCoupon(mcNo) {
    showConfirm("해당 회원의 보유쿠폰을 삭제하시겠습니까?", function () {
      fetch(contextPath + "/admin/coupon/member/" + mcNo, { method: "DELETE" })
        .then(function (res) {
          if (!res.ok) throw new Error("서버 오류 (HTTP " + res.status + ")");
          return res.json();
        })
        .then(function (result) {
          if (result.success) {
            loadMemberCouponList();
          } else {
            showAlert(result.message || "삭제에 실패했습니다.");
          }
        })
        .catch(function (err) {
          console.error("회원쿠폰 삭제 실패", err);
          showAlert("삭제 중 오류가 발생했습니다.\n" + err.message);
        });
    }, { danger: true, okText: "삭제" });
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
    return String(str).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
  }
</script>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>