<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>동물병원 찾기</title>
<link rel="stylesheet" href="/css/hospital/hplist.css">
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>

<div class="hp-hero">
	<h3 class="hp-hero-title">동물병원 찾기</h3>
	<p class="hp-hero-desc">우리 아이에게 딱 맞는 동물병원을 이름ㆍ주소ㆍ키워드로 찾아보세요</p>

	<form name="hospitalSearchForm" method="get" action="/hospital_search" class="hp-search-form">
		<div class="hp-search-box">
			<input type="text" name="keyword" id="keyword" value="${param.keyword}"
				   autocomplete="off" placeholder="병원 이름, 주소, 키워드로 검색">
			<input type="submit" value="검색" class="hp-search-btn">
		</div>
		<div id="suggestions" class="hp-suggestions"></div>
	</form>
</div>

<div class="hp-content-wrap">

	<div class="hp-count">전체 <strong>${totalCount}</strong>곳</div>

	<c:if test="${empty hospitalList}">
		<p class="hp-empty">등록된 병원이 없습니다.</p>
	</c:if>

	<ul class="hp-list">
		<c:forEach var="hp" items="${hospitalList}">
			<li class="hp-item">
				<a href="/guest/hospital/hospitalView?hp_no=${hp.hp_no}" class="hp-item-link">
					<div class="hp-item-name">${hp.hp_name}</div>
					<div class="hp-item-addr">${hp.hp_addr}</div>
					<div class="hp-item-tel">${hp.hp_tel}</div>
				</a>
			</li>
		</c:forEach>
	</ul>

	<div class="pagination">
		<a href="/guest/hospital/hospitalList?keyword=${param.keyword}&page=${pageNum > 1 ? pageNum - 1 : 1}" class="page-arrow">PREV</a>

		<c:forEach var="i" begin="1" end="${totalPages}">
			<a href="/guest/hospital/hospitalList?keyword=${param.keyword}&page=${i}"
			   class="page-num ${pageNum eq i ? 'active' : ''}">${i}</a>
		</c:forEach>

		<a href="/guest/hospital/hospitalList?keyword=${param.keyword}&page=${pageNum < totalPages ? pageNum + 1 : totalPages}" class="page-arrow">NEXT</a>
	</div>

</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>