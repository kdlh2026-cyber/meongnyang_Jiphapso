<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>[관리자] 쿠폰 관리</title>
<style>
  * { box-sizing: border-box; }
  body { margin: 0; font-family: "Noto Sans KR", "Malgun Gothic", sans-serif; background: #f7f7f8; color: #222; }

  .cpa-wrap { max-width: 1300px; margin: 40px auto; padding: 0 20px 60px; }
  .cpa-title { font-size: 22px; font-weight: 700; margin: 0 0 20px; }
  .cpa-section-title { font-size: 16px; font-weight: 700; margin: 36px 0 14px; padding-bottom: 10px; border-bottom: 2px solid #222; }

  .cpa-form {
    background: #fff; border: 1px solid #e5e5e5; border-radius: 8px; padding: 20px;
    display: grid; grid-template-columns: repeat(4, 1fr); gap: 14px 16px;
  }
  .cpa-field { display: flex; flex-direction: column; gap: 6px; }
  .cpa-field label { font-size: 12px; color: #666; font-weight: 600; }
  .cpa-field input, .cpa-field select {
    padding: 8px 10px; border: 1px solid #ccc; border-radius: 6px; font-size: 13px;
  }
  .cpa-field.cpa-span2 { grid-column: span 2; }
  .cpa-field.cpa-span4 { grid-column: span 4; }
  .cpa-submit-row { grid-column: span 4; text-align: right; }
  .cpa-btn-submit {
    padding: 10px 24px; background: #222; color: #fff; border: none; border-radius: 6px;
    font-size: 14px; font-weight: 600; cursor: pointer;
  }
  .cpa-btn-submit:hover { background: #444; }

  .cpa-empty {
    padding: 60px 0; text-align: center; color: #888; font-size: 14px;
    background: #fff; border: 1px solid #e5e5e5; border-radius: 8px;
  }

  .cpa-table { width: 100%; border-collapse: collapse; background: #fff; border: 1px solid #e5e5e5; border-radius: 8px; overflow: hidden; font-size: 13px; }
  .cpa-table th, .cpa-table td { padding: 10px 8px; text-align: center; border-bottom: 1px solid #eee; }
  .cpa-table thead th { background: #fafafa; color: #555; font-weight: 600; }
  .cpa-table tbody tr:last-child td { border-bottom: none; }
  .cpa-table img { width: 90px; border-radius: 4px; }

  .cpa-btn { padding: 6px 12px; border-radius: 6px; font-size: 12px; cursor: pointer; border: 1px solid #c0392b; color: #c0392b; background: #fff; }
  .cpa-btn:hover { background: #c0392b; color: #fff; }

  .cpa-badge { display: inline-block; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 600; }
  .cpa-badge-unused  { background: #e6f7ec; color: #12805c; }
  .cpa-badge-used    { background: #eee; color: #666; }
  .cpa-badge-expired { background: #fdeaea; color: #c0392b; }

  #fPNoField { position: relative; }
  .cpa-search-results {
    position: absolute; top: 62px; left: 0; right: 0; z-index: 10;
    background: #fff; border: 1px solid #ccc; border-radius: 6px; max-height: 180px; overflow-y: auto;
    box-shadow: 0 4px 10px rgba(0,0,0,0.08);
  }
  .cpa-search-item { padding: 8px 10px; font-size: 13px; cursor: pointer; text-align: left; }
  .cpa-search-item:hover { background: #f5f5f5; }
  .cpa-search-empty { padding: 8px 10px; font-size: 12px; color: #999; text-align: left; }
  .cpa-search-selected { margin-top: 4px; font-size: 12px; color: #12805c; font-weight: 600; }
</style>
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

<script>
  var contextPath = "${pageContext.request.contextPath}";
  var IMAGE_BASE = contextPath + "/images/coupon/";

  var MEMBER_STATUS_INFO = {
    UNUSED:  { label: "사용가능", cls: "cpa-badge-unused" },
    USED:    { label: "사용완료", cls: "cpa-badge-used" },
    EXPIRED: { label: "기간만료", cls: "cpa-badge-expired" }
  };

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
  function loadCouponList() {
    fetch(contextPath + "/admin/coupon/list/data")
      .then(function (res) { return res.json(); })
      .then(function (result) { renderCouponList(result.data || []); })
      .catch(function (err) { console.error("쿠폰 목록 조회 실패", err); });
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
      alert("대상 상품을 검색해서 선택해주세요.");
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
      .then(function (res) { return res.json(); })
      .then(function (result) {
        alert(result.message);
        if (result.success) {
          document.getElementById("cpaForm").reset();
          togglePNo("ALL");
          loadCouponList();
        }
      })
      .catch(function (err) {
        console.error("쿠폰 등록 실패", err);
        alert("쿠폰 등록 중 오류가 발생했습니다.");
      });
    return false;
  }

  // 쿠폰 삭제 (CouponController#adminDeleteCoupon)
  function deleteCoupon(coNo) {
    if (!confirm("해당 쿠폰을 삭제하시겠습니까? (이미 발급된 회원쿠폰에는 영향을 주지 않습니다)")) {
      return;
    }
    fetch(contextPath + "/admin/coupon/" + coNo, { method: "DELETE" })
      .then(function (res) { return res.json(); })
      .then(function (result) {
        if (result.success) {
          loadCouponList();
        } else {
          alert(result.message || "삭제에 실패했습니다.");
        }
      })
      .catch(function (err) { console.error("쿠폰 삭제 실패", err); });
  }

  // ================= 회원 쿠폰 발급현황 =================

  // 회원 발급 쿠폰 전체 목록 (CouponController#adminMemberCouponList)
  function loadMemberCouponList() {
    fetch(contextPath + "/admin/coupon/member/list")
      .then(function (res) { return res.json(); })
      .then(function (result) { renderMemberCouponList(result.data || []); })
      .catch(function (err) { console.error("회원 쿠폰 발급현황 조회 실패", err); });
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
        "<td>" + escapeHtml(item.mId) + "</td>" +
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

  // 발급된 회원쿠폰 강제 삭제 (CouponController#adminDeleteMemberCoupon)
  function deleteMemberCoupon(mcNo) {
    if (!confirm("해당 회원의 보유쿠폰을 삭제하시겠습니까?")) {
      return;
    }
    fetch(contextPath + "/admin/coupon/member/" + mcNo, { method: "DELETE" })
      .then(function (res) { return res.json(); })
      .then(function (result) {
        if (result.success) {
          loadMemberCouponList();
        } else {
          alert(result.message || "삭제에 실패했습니다.");
        }
      })
      .catch(function (err) { console.error("회원쿠폰 삭제 실패", err); });
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
</body>
</html>
