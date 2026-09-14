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
    <button class="mp-tab" data-url="#" onclick="loadMpTab(this)">북마크 글</button>
    <button class="mp-tab" data-url="/member/order/list?m_no=${myId.m_no}" onclick="loadMpTab(this)">주문 내역</button>
    <button class="mp-tab" data-url="/favorite/list" onclick="loadMpTab(this)">관심 상품</button>
    <button class="mp-tab" data-url="${pageContext.request.contextPath}/point/list" onclick="loadMpTab(this)">포인트</button>
    <button class="mp-tab" data-url="${pageContext.request.contextPath}/coupon/list" onclick="loadMpTab(this)">쿠폰</button>
  </nav>

  <div id="mp-content-area">
	<table>
		<tr>
			<td><img src="/images/myProfile/${myId.m_img}" alt="${myId.m_img}"></td>
		</tr>
		<tr>
			<td>${myId.m_id}</td>
		</tr>
		<tr>
			<td>${myId.m_name}</td>
		</tr>
		<tr>
			<td>${myId.m_email}</td>
		</tr>
		<tr>
			<td>${myId.m_introduce}</td>
		</tr>
		<tr>
			<td><fmt:formatDate value="${myId.m_birth}" pattern="yyyy-MM-dd" /></td>
		</tr>
		<tr>
			<td>SNS 수신 동의 여부: ${myId.m_sns}</td>
		</tr>
	</table>
	<a href="/member/myPage/myProfileUpdateForm">회원 정보 수정</a>
	<!-- 크리에이터 신청 버튼 자리 -->
  </div>

  <div class="mp-delete-row">
    <a class="mp-delete-link" href="/memberDelete?m_id=${myId.m_id}" onclick="return confirm('정말로 탈퇴하시겠습니까?');">계정 탈퇴</a>
  </div>
</div>

<script>
function loadMpTab(btn) {
    const url = btn.dataset.url;
    if (url === '#') return;

    document.querySelectorAll('.mp-tab').forEach(el => el.classList.remove('active'));
    btn.classList.add('active');

    sessionStorage.setItem('lastMpTab', url);

    fetch(url)
        .then(response => response.text())
        .then(html => {
            document.getElementById('mp-content-area').innerHTML = html;
        })
        .catch(err => console.error('Error loading tab:', err));
}
</script>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>