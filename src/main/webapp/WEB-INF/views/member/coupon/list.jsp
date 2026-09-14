<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>내 쿠폰함</title>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
<style>
  * { box-sizing: border-box; }
  body { margin: 0; font-family: "Noto Sans KR", "Malgun Gothic", sans-serif; background: #f7f7f8; color: #222; }

  .cp-wrap { max-width: 1100px; margin: 40px auto; padding: 0 20px 60px; }
  .cp-title { font-size: 22px; font-weight: 700; margin: 0 0 8px; }
  .cp-section-title { font-size: 17px; font-weight: 700; margin: 40px 0 16px; padding-bottom: 10px; border-bottom: 2px solid #222; }

  .cp-empty {
    padding: 60px 0; text-align: center; color: #888; font-size: 14px;
    background: #fff; border: 1px solid #e5e5e5; border-radius: 8px;
  }

  .cp-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px; }

  .cp-card { position: relative; border-radius: 10px; overflow: hidden; background: #fff; box-shadow: 0 1px 4px rgba(0,0,0,0.08); }
  .cp-card img { width: 100%; display: block; }
  .cp-card.cp-inactive img { filter: grayscale(1); opacity: 0.55; }

  .cp-meta { padding: 12px 14px 14px; }
  .cp-meta-name { font-size: 14px; font-weight: 700; margin: 0 0 6px; }
  .cp-meta-sub { font-size: 12px; color: #777; margin: 2px 0; }

  .cp-status { position: absolute; top: 10px; right: 10px; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 700; color: #fff; }
  .cp-status-unused  { background: #12805c; }
  .cp-status-used    { background: #999; }
  .cp-status-expired { background: #c0392b; }

  .cp-download-btn {
    display: block; width: calc(100% - 28px); margin: 0 14px 14px; padding: 10px 0;
    background: #222; color: #fff; border: none; border-radius: 6px; font-size: 14px; font-weight: 600; cursor: pointer;
  }
  .cp-download-btn:hover { background: #444; }
  .cp-download-btn:disabled { background: #ccc; cursor: default; }

  .cp-tabs { display: flex; gap: 8px; margin-bottom: 16px; }
  .cp-tab {
    padding: 8px 16px; border: 1px solid #ddd; background: #fff; border-radius: 20px;
    font-size: 13px; cursor: pointer; color: #555;
  }
  .cp-tab.active { background: #222; color: #fff; border-color: #222; }

    /* ================= 안내메세지 토스트 (alert 대체) ================= */
  .cp-toast-wrap {
    position: fixed; bottom: 32px; left: 50%; transform: translateX(-50%);
    z-index: 9999; display: flex; flex-direction: column-reverse; gap: 10px; align-items: center;
    pointer-events: none; width: auto;
  }
  .cp-toast {
    display: inline-flex; align-items: center; justify-content: center;
    max-width: 320px; width: max-content;
    padding: 12px 22px; border-radius: 999px;
    background: #333; color: #fff; font-size: 13px; font-weight: 600; text-align: center;
    line-height: 1.4; white-space: normal; word-break: keep-all;
    box-shadow: 0 6px 16px rgba(0,0,0,0.15);
    opacity: 0; transform: translateY(14px) scale(0.98);
    transition: opacity 0.25s ease, transform 0.25s ease;
    pointer-events: auto;
  }
  .cp-toast.cp-toast-show { opacity: 1; transform: translateY(0) scale(1); }
  .cp-toast-success { background: #f5c518; color: #222; }
  .cp-toast-error   { background: #f5c518; color: #a34e1c; }
</style>
</head>
<body>

<!-- 토스트 안내메세지가 붙는 자리 (alert() 대신 사용) -->
<div id="cpToastWrap" class="cp-toast-wrap"></div>

<div class="cp-wrap">
  <h2 class="cp-title">내 쿠폰함</h2>

  <!-- 다운로드 가능한 쿠폰 -->
  <h3 class="cp-section-title">받을 수 있는 쿠폰</h3>
  <div id="cpDownloadableEmpty" class="cp-empty" style="display:none;">지금 받을 수 있는 쿠폰이 없습니다.</div>
  <div id="cpDownloadableGrid" class="cp-grid"></div>

  <!-- 보유쿠폰함 -->
  <h3 class="cp-section-title">보유 쿠폰함</h3>
  <div class="cp-tabs">
  	<button type="button" class="cp-tab" data-filter="ALL" onclick="filterMyCoupon('ALL', this)">전체</button>
    <button type="button" class="cp-tab active" data-filter="UNUSED" onclick="filterMyCoupon('UNUSED', this)">사용가능한 쿠폰</button>
    <button type="button" class="cp-tab" data-filter="USED" onclick="filterMyCoupon('USED', this)">사용한 쿠폰</button>
  </div>
  <div id="cpMyEmpty" class="cp-empty" style="display:none;">보유 중인 쿠폰이 없습니다.</div>
  <div id="cpMyGrid" class="cp-grid"></div>
</div>

<script>
  var contextPath = "${pageContext.request.contextPath}";
  var IMAGE_BASE = contextPath + "/images/coupon/";
  var myCouponList = []; // /coupon/my 조회 결과 캐시 (탭 전환 시 재사용)

  var STATUS_INFO = {
    UNUSED:  { label: "사용가능", cls: "cp-status-unused" },
    USED:    { label: "사용완료", cls: "cp-status-used" },
    EXPIRED: { label: "기간만료", cls: "cp-status-expired" }
  };

  document.addEventListener("DOMContentLoaded", function () {
    loadDownloadableList();
    loadMyCouponList();
  });

  // ================= 안내메세지 토스트 (alert() 대체) =================
  // type: "success"(초록) / "error"(빨강) / 생략 시 기본(검정)
  function showToast(message, type) {
    var wrap = document.getElementById("cpToastWrap");
    if (!wrap || !message) return;

    var toast = document.createElement("div");
    toast.className = "cp-toast" + (type === "success" ? " cp-toast-success" : type === "error" ? " cp-toast-error" : "");
    toast.textContent = message;
    wrap.appendChild(toast);

    requestAnimationFrame(function () {
      toast.classList.add("cp-toast-show");
    });

    setTimeout(function () {
      toast.classList.remove("cp-toast-show");
      setTimeout(function () { toast.remove(); }, 250);
    }, 2200);
  }

  // 받을 수 있는 쿠폰 목록 (CouponController#downloadableList)
  function loadDownloadableList() {
    fetch(contextPath + "/coupon/downloadable")
      .then(function (res) { return res.json(); })
      .then(function (result) {
        if (!result.success) {
          alert(result.message || "로그인이 필요합니다.");
          location.href = contextPath + "/member/login";
          return;
        }
        renderDownloadable(result.data || []);
      })
      .catch(function (err) { console.error("다운로드 가능한 쿠폰 조회 실패", err); });
  }

  function renderDownloadable(list) {
    var grid = document.getElementById("cpDownloadableGrid");
    var empty = document.getElementById("cpDownloadableEmpty");
    grid.innerHTML = "";

    if (!list || list.length === 0) {
      empty.style.display = "block";
      return;
    }
    empty.style.display = "none";

    list.forEach(function (item) {
      var periodText = item.coDays ? ("다운로드 후 " + item.coDays + "일간 사용가능") : "기간제한 없음";

      var card = document.createElement("div");
      card.className = "cp-card";
      card.innerHTML =
        "<img src=\"" + IMAGE_BASE + item.imageName + "\" alt=\"" + escapeHtml(item.coName) + "\">" +
        "<div class=\"cp-meta\">" +
          "<p class=\"cp-meta-name\">" + escapeHtml(item.coName) + "</p>" +
          "<p class=\"cp-meta-sub\">최소주문금액 " + formatPrice(item.coMinAmt) + "원 이상" + (item.coMaxAmt ? " · 최대할인 " + formatPrice(item.coMaxAmt) + "원" : "") + "</p>" +
          "<p class=\"cp-meta-sub\">" + periodText + "</p>" +
        "</div>" +
        "<button type=\"button\" class=\"cp-download-btn\" onclick=\"downloadCoupon(" + item.coNo + ", this)\">쿠폰 받기</button>";
      grid.appendChild(card);
    });
  }

  // 쿠폰 다운로드 (CouponController#downloadCoupon)
  function downloadCoupon(coNo, btn) {
    btn.disabled = true;
    fetch(contextPath + "/coupon/download", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ coNo: coNo })
    })
      .then(function (res) { return res.json(); })
      .then(function (result) {
        if (!result.success) {
          showToast(result.message || "쿠폰 다운로드에 실패했습니다.", "error");
          btn.disabled = false;
          return;
        }
        showToast("쿠폰을 받았어요!", "success");
        loadDownloadableList(); // 목록에서 제외
        loadMyCouponList();     // 보유쿠폰함 갱신
      })
      .catch(function (err) {
        console.error("쿠폰 다운로드 실패", err);
        showToast("쿠폰 다운로드 중 오류가 발생했습니다.", "error");
        btn.disabled = false;
      });
  }

  // 내 보유쿠폰함 목록 (CouponController#myCouponList)
  function loadMyCouponList() {
    fetch(contextPath + "/coupon/my")
      .then(function (res) { return res.json(); })
      .then(function (result) {
        if (!result.success) {
          return;
        }
        myCouponList = result.data || [];
        var activeTab = document.querySelector(".cp-tab.active");
        renderMyCoupon(activeTab ? activeTab.getAttribute("data-filter") : "UNUSED");
      })
      .catch(function (err) { console.error("보유쿠폰함 조회 실패", err); });
  }

  function filterMyCoupon(filter, btn) {
    document.querySelectorAll(".cp-tab").forEach(function (t) { t.classList.remove("active"); });
    btn.classList.add("active");
    renderMyCoupon(filter);
  }

  function renderMyCoupon(filter) {
    var grid = document.getElementById("cpMyGrid");
    var empty = document.getElementById("cpMyEmpty");
    grid.innerHTML = "";

    var list = (filter === "ALL") ? myCouponList : myCouponList.filter(function (c) { return c.mcStatus === filter; });

    if (!list || list.length === 0) {
      empty.style.display = "block";
      return;
    }
    empty.style.display = "none";

    list.forEach(function (item) {
      var statusInfo = STATUS_INFO[item.mcStatus] || { label: item.mcStatus, cls: "" };
      var expiredText = item.mcExpired ? ("~ " + formatDate(item.mcExpired) + " 까지") : "기간제한 없음";
      var inactive = (item.mcStatus !== "UNUSED") ? " cp-inactive" : "";

      var card = document.createElement("div");
      card.className = "cp-card" + inactive;
      card.innerHTML =
        "<span class=\"cp-status " + statusInfo.cls + "\">" + statusInfo.label + "</span>" +
        "<img src=\"" + IMAGE_BASE + item.imageName + "\" alt=\"" + escapeHtml(item.coName) + "\">" +
        "<div class=\"cp-meta\">" +
          "<p class=\"cp-meta-name\">" + escapeHtml(item.coName) + "</p>" +
          "<p class=\"cp-meta-sub\">최소주문금액 " + formatPrice(item.coMinAmt) + "원 이상" + (item.coMaxAmt ? " · 최대할인 " + formatPrice(item.coMaxAmt) + "원" : "") + "</p>" +
          "<p class=\"cp-meta-sub\">" + expiredText + "</p>" +
        "</div>";
      grid.appendChild(card);
    });
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