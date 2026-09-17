<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>멍냥집합소</title>
<style>
  * { box-sizing: border-box; }
  body { margin: 0; font-family: "Noto Sans KR", "Malgun Gothic", sans-serif; background: #fff; color: #222; }

  .mp-wrap { max-width: 960px; margin: 0 auto; padding: 24px 24px 80px; }

  .mp-tabs {
    display: flex; flex-wrap: wrap; align-items: center; gap: 6px 30px;
    border-bottom: 1px solid #ececec; padding: 0 2px 16px; margin-bottom: 40px;
  }
  .mp-tab {
    position: relative; padding: 6px 2px 14px; font-size: 15px; font-weight: 700;
    color: #333; background: none; border: none; cursor: pointer; white-space: nowrap;
  }
  .mp-tab::after {
    content: ""; position: absolute; left: 0; right: 0; bottom: -1px; height: 3px;
    background: transparent; border-radius: 3px 3px 0 0; transition: background 0.15s ease;
  }
  .mp-tab:hover { color: #111; }
  .mp-tab:hover::after { background: #f5c518; }
  .mp-tab.active { color: #111; }
  .mp-tab.active::after { background: #f5c518; }

  .mp-hello { font-size: 15px; color: #555; margin: 0 0 4px; }
  .mp-guide { font-size: 13px; color: #999; margin: 0 0 48px; }

  .mp-delete-row { text-align: left; margin-top: 40px; }
  .mp-delete-link {
    font-size: 13px; color: #bbb; text-decoration: underline; text-underline-offset: 3px;
  }
  .mp-delete-link:hover { color: #c0392b; }

  @media (max-width: 480px) {
    .mp-tabs { gap: 6px 18px; }
    .mp-tab { font-size: 14px; }
  }
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>

<div class="mp-wrap">
  <nav class="mp-tabs">
    <button class="mp-tab active" data-url="/member/myPage/myProfile?m_id=${myId.m_id}" onclick="loadMpTab(this)">프로필</button>
    <button class="mp-tab" data-url="/member/myPage/myPetList?m_no=${myId.m_no}" onclick="loadMpTab(this)">반려동물 프로필</button>
    <button class="mp-tab" data-url="/community/myCommunity?m_no=${myId.m_no}" onclick="loadMpTab(this)">내가 작성한 글</button>
    <button class="mp-tab" data-url="/member/myBookmarks" onclick="loadMpTab(this)">북마크 글</button>
    <button class="mp-tab" data-url="/member/order/list?m_no=${myId.m_no}" onclick="loadMpTab(this)">주문 내역</button>
    <button class="mp-tab" data-url="/favorite/list" onclick="loadMpTab(this)">관심 상품</button>
    <button class="mp-tab" data-url="${pageContext.request.contextPath}/point/list" onclick="loadMpTab(this)">포인트</button>
    <button class="mp-tab" data-url="${pageContext.request.contextPath}/coupon/list" onclick="loadMpTab(this)">쿠폰</button>
  </nav>

  <div id="mp-content-area"></div>

  <div class="mp-delete-row">
    <a class="mp-delete-link" href="/memberDelete?m_id=${myId.m_id}" onclick="return confirm('정말로 탈퇴하시겠습니까?');">계정 탈퇴</a>
  </div>
</div>

<script>
function loadMpTab(btn) {
    const url = btn.dataset.url;

    if (url === '#') return;

    // 포인트 / 쿠폰 / 주문 내역은 페이지 이동
    if (
        url.indexOf('/point/list') !== -1 ||
        url.indexOf('/coupon/list') !== -1 ||
        url.indexOf('/member/order/list') !== -1
    ) {
        location.href = url;
        return;
    }


// 마이페이지 본문만 불러오는 함수
function loadMpContent(url) {

    fetch(url, {
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('페이지를 불러오지 못했습니다.');
        }

        return response.text();
    })
    .then(html => {
        document.getElementById('mp-content-area').innerHTML = html;
    })
    .catch(err => {
        console.error('Error loading tab:', err);
    });
}

//내가 작성한 글 내부의 카테고리 링크 클릭 처리
document.getElementById('mp-content-area')
    .addEventListener('click', function(e) {

        const link = e.target.closest('a[data-mp-category]');

        if (!link) return;

        // 실제 페이지 이동 막기
        e.preventDefault();

        const url = link.getAttribute('href');

        // 카테고리 본문만 다시 불러오기
        loadMpContent(url);
    });
    
	window.addEventListener('DOMContentLoaded', function () {
	    const profileUrl = document.querySelector('.mp-tab.active').dataset.url;
	    loadMpContent(profileUrl);
	});
</script>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>