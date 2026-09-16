<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>광고&#128062;링크</title>
<style>
  html, body {
      background-color: #f5f5f5 !important;
      margin: 0;
      padding: 0;
      font-family: -apple-system, BlinkMacSystemFont, "Malgun Gothic", sans-serif;
      color: #333;
  }
  a { color: inherit; text-decoration: none; }

  /* 상단 헤더 */
  .top-bar {
      background: #222;
      color: #ccc;
      font-size: 12px;
  }
  .top-bar-inner {
      max-width: 1100px;
      margin: 0 auto;
      display: flex;
      justify-content: flex-end;
      gap: 14px;
      padding: 6px 20px;
  }

  .header {
      background: #fff;
      border-bottom: 1px solid #e5e5e5;
  }
  .header-inner {
      max-width: 1100px;
      margin: 0 auto;
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 14px 20px;
  }
  .logo {
      font-size: 22px;
      font-weight: 800;
      color: #1a73e8;
      letter-spacing: -1px;
  }
  .gnb {
      display: flex;
      gap: 28px;
      font-size: 15px;
      font-weight: 600;
  }
  .gnb a:hover { color: #1a73e8; }
  .header-actions {
      display: flex;
      gap: 10px;
      font-size: 13px;
  }
  .btn-outline {
      border: 1px solid #ccc;
      border-radius: 4px;
      padding: 6px 14px;
  }
  .btn-solid {
      background: #1a73e8;
      color: #fff;
      border-radius: 4px;
      padding: 6px 14px;
  }

  /* 본문 레이아웃 */
  .container {
      max-width: 1100px;
      margin: 20px auto;
      display: flex;
      gap: 20px;
      padding: 0 20px;
      align-items: flex-start;
  }

  /* 좌측 사이드 메뉴 */
  .side-menu {
      width: 200px;
      background: #fff;
      border: 1px solid #e5e5e5;
      border-radius: 6px;
      overflow: hidden;
      flex-shrink: 0;
  }
  .side-menu h4 {
      margin: 0;
      padding: 14px 16px;
      background: #1a73e8;
      color: #fff;
      font-size: 14px;
  }
  .side-menu ul {
      list-style: none;
      margin: 0;
      padding: 0;
  }
  .side-menu li a {
      display: block;
      padding: 12px 16px;
      font-size: 13px;
      border-bottom: 1px solid #f0f0f0;
      color: #555;
  }
  .side-menu li a:hover {
      background: #f5f9ff;
      color: #1a73e8;
  }

  /* 메인 콘텐츠 */
  .main-content {
      flex: 1;
      background: #fff;
      border: 1px solid #e5e5e5;
      border-radius: 6px;
      padding: 24px;
  }
  .breadcrumb {
      font-size: 12px;
      color: #999;
      margin-bottom: 10px;
  }
  .article-title {
      font-size: 22px;
      font-weight: 800;
      margin: 0 0 6px;
  }
  .article-meta {
      font-size: 12px;
      color: #999;
      border-bottom: 1px solid #eee;
      padding-bottom: 14px;
      margin-bottom: 20px;
  }
  .adv-wrap {
      text-align: center;
      margin-bottom: 20px;
  }
  .adv-wrap img {
      display: block;
      width: 100%;
      height: auto;
      border-radius: 6px;
  }
  .article-body {
      font-size: 14px;
      line-height: 1.8;
      color: #444;
  }
  .tag-list {
      margin-top: 20px;
      display: flex;
      gap: 8px;
      flex-wrap: wrap;
  }
  .tag {
      background: #f0f4ff;
      color: #1a73e8;
      font-size: 12px;
      padding: 5px 10px;
      border-radius: 12px;
  }

  footer {
      max-width: 1100px;
      margin: 30px auto 0;
      padding: 0 20px;
  }
  footer hr {
      border: none;
      border-top: 1px solid #ddd;
  }
</style>
</head>
<body>

	<div class="top-bar">
		<div class="top-bar-inner">
			<a href="#">로그인</a>
			<a href="#">회원가입</a>
			<a href="#">고객센터</a>
		</div>
	</div>

	<header class="header">
		<div class="header-inner">
			<div class="logo">CareerLink</div>
			<nav class="gnb">
				<a href="#">채용정보</a>
				<a href="#">이력서</a>
				<a href="#">기업정보</a>
				<a href="#">이벤트</a>
				<a href="#">커뮤니티</a>
			</nav>
			<div class="header-actions">
				<span class="btn-outline">기업서비스</span>
				<span class="btn-solid">이력서 등록</span>
			</div>
		</div>
	</header>

	<div class="container">
		<aside class="side-menu">
			<h4>이벤트 메뉴</h4>
			<ul>
				<li><a href="#" id="1">진행중인 이벤트</a></li>
				<li><a href="#">종료된 이벤트</a></li>
				<li><a href="#">당첨자 발표</a></li>
				<li><a href="#">채용 캘린더</a></li>
				<li><a href="#">인기 공고</a></li>
				<li><a href="#">신규 기업 공고</a></li>
			</ul>
		</aside>

		<main class="main-content">
			<div class="breadcrumb"><a href="#">홈</a> &gt; <a href="#">이벤트</a> &gt; <a href="#">진행중인 이벤트</a></div>
			<h1 class="article-title">🐾 채용 시즌 맞이 특별 이벤트</h1>
			<div class="article-meta">등록일 2026.08.28 &nbsp;|&nbsp; 조회수 922</div>

			<div class="adv-wrap">
				<img src="/images/main/advertisement2.png" alt="이벤트 배너">
			</div>

			<div class="article-body">
				안녕하세요, 회원 여러분!<br><br>
				이번 가을 채용 시즌을 맞아 다양한 혜택을 준비했습니다.
				지금 바로 참여하시고 푸짐한 경품의 주인공이 되어보세요.<br><br>
			</div>

			<div class="tag-list">
				<span class="tag">#채용이벤트</span>
				<span class="tag">#가을공채</span>
				<span class="tag">#경품이벤트</span>
			</div>
		</main>
	</div>

	<footer>
		<hr>
		<div style="font-size: 11px; color: #767676; margin-top: 10px; margin-bottom: 15px; text-align: left;">
	    	마치 다른 웹사이트 링크인 척 만들어놓은 페이지<br>
	    	본 페이지는 실제 페이지가 아닙니다.<br>
	    	해당 페이지의 생성은 AI의 도움을 받았습니다.<br>
	    	&copy; This page is a practice page.
	    </div>
	</footer>

</body>
</html>