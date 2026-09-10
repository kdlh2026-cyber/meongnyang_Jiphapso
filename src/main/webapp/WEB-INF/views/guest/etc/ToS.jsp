<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이용약관</title>
<style>
.tos-tabs button {
    padding: 8px 16px;
    border: 1px solid #ccc;
    background: #f5f5f5;
    cursor: pointer;
}
.tos-tabs button.active {
    background: #333;
    color: #fff;
}
.tos-section { display: none; margin-top: 20px; line-height: 1.6; }
.tos-section.active { display: block; }
.tos-section h4 { margin-top: 24px; }
.tos-section h5 { margin-top: 12px; }
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>

	<h3>멍냥집합소 이용약관</h3>

	<div class="tos-tabs">
		<button type="button" class="active" data-target="tos-basic">서비스 기본 이용약관</button>
		<button type="button" data-target="tos-product">제품 구매 이용약관</button>
		<button type="button" data-target="tos-creator">크리에이터 이용약관</button>
	</div>

	<!-- 서비스 기본 이용약관 -->
	<div id="tos-basic" class="tos-section active">
		<h4>제1장 총칙</h4>
		<h5>제1조(목적)</h5>
		<p>여기에 목적 조항 내용을 작성하세요.</p>

		<h5>제2조(정의)</h5>
		<p>여기에 용어 정의 조항 내용을 작성하세요.</p>

		<h5>제3조(약관의 명시와 설명 및 개정)</h5>
		<p>여기에 약관 개정 관련 조항 내용을 작성하세요.</p>

		<h4>제2장 회원</h4>
		<h5>제4조(이용계약의 체결)</h5>
		<p>여기에 회원가입 관련 조항 내용을 작성하세요.</p>

		<!-- 필요한 조항만큼 h5/p 반복 -->

		<h4>부칙</h4>
		<p>이 약관은 2026년 8월 28일부터 시행합니다.</p>
	</div>

	<!-- 제품 구매 이용약관 -->
	<div id="tos-product" class="tos-section">
		<h4>제1장 총칙</h4>
		<h5>제1조(목적)</h5>
		<p>여기에 제품 구매 약관 목적 조항 내용을 작성하세요.</p>

		<h5>제2조(청약철회 및 환불)</h5>
		<p>여기에 청약철회/환불 관련 조항 내용을 작성하세요.</p>

		<!-- 필요한 조항만큼 반복 -->
	</div>

	<!-- 크리에이터 이용약관 -->
	<div id="tos-creator" class="tos-section">
		<h4>제1장 총칙</h4>
		<h5>제1조(목적)</h5>
		<p>여기에 크리에이터 약관 목적 조항 내용을 작성하세요.</p>

		<!-- 필요한 조항만큼 반복 -->
	</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
<script>
	document.querySelectorAll(".tos-tabs button").forEach(function(btn){
	    btn.addEventListener("click", function(){
	        // 버튼 active 토글
	        document.querySelectorAll(".tos-tabs button").forEach(function(b){ b.classList.remove("active"); });
	        this.classList.add("active");

	        // 해당 섹션만 보이기
	        var targetId = this.getAttribute("data-target");
	        document.querySelectorAll(".tos-section").forEach(function(sec){ sec.classList.remove("active"); });
	        document.getElementById(targetId).classList.add("active");
	    });
	});
</script>
</body>
</html>