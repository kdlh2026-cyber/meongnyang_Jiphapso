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

  /* ================= 상단 탭 메뉴 (비마이펫 마이페이지 느낌) ================= */
  .mp-tabs {
    display: flex; flex-wrap: wrap; align-items: center; gap: 6px 30px;
    border-bottom: 1px solid #ececec; padding: 0 2px 16px; margin-bottom: 40px;
  }
  .mp-tab {
    position: relative; padding: 6px 2px 14px; font-size: 15px; font-weight: 700;
    color: #333; text-decoration: none; white-space: nowrap;
  }
  .mp-tab::after {
    content: ""; position: absolute; left: 0; right: 0; bottom: -1px; height: 3px;
    background: transparent; border-radius: 3px 3px 0 0; transition: background 0.15s ease;
  }
  .mp-tab:hover { color: #111; }
  .mp-tab:hover::after { background: #f5c518; }

  .mp-hello { font-size: 15px; color: #555; margin: 0 0 4px; }
  .mp-guide { font-size: 13px; color: #999; margin: 0 0 48px; }

  /* ================= 계정 탈퇴 ================= */
  .mp-delete-row { text-align: center; }
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
    <a class="mp-tab" href="/member/myPage/myProfile?m_id=${myId.m_id}">프로필</a>
    <a class="mp-tab" href="/member/myPage/myPetList?m_no=${myId.m_no}">반려동물 프로필</a>
    <a class="mp-tab" href="/community/myCommunity?m_no=${myId.m_no}">내가 작성한 글</a>
    <a class="mp-tab" href="#">북마크 글</a>
    <a class="mp-tab" href="/member/order/list?m_no=${myId.m_no}">주문 내역</a>
    <a class="mp-tab" href="/favorite/list">관심 상품</a>
    <a class="mp-tab" href="${pageContext.request.contextPath}/point/list">포인트</a>
    <a class="mp-tab" href="${pageContext.request.contextPath}/coupon/list">쿠폰</a>
  </nav>

  <p class="mp-hello">여기는 회원 페이지입니다.</p>
  <p class="mp-guide">위 메뉴에서 원하는 항목을 선택해주세요.</p>

  <div class="mp-delete-row">
    <a class="mp-delete-link" href="/memberDelete?m_id=${myId.m_id}" onclick="return confirm('정말로 탈퇴하시겠습니까?');">계정 탈퇴</a>
  </div>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
