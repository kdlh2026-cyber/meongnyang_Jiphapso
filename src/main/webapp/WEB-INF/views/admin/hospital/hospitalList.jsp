<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>동물병원 관리</title>
<link rel="stylesheet" href="/css/hospital/hpalist.css">
</head>
<body>
<%@ include file="/WEB-INF/views/admin/clone/hamburger_menu.jsp" %>

<div class="hpa-wrap">

	<h2 class="hpa-title">동물병원 관리</h2>

	<!-- ---- 통계 요약 ---- -->
	<div class="hpa-stat-card">
		<div class="hpa-stat-total">
			<span class="hpa-stat-num">${totalCount}</span>
			<span class="hpa-stat-label">전체 등록 병원</span>
		</div>

		<div class="hpa-stat-ranking">
			<span class="hpa-stat-ranking-title">구별 등록 현황</span>
			<c:forEach var="entry" items="${guRanking}" varStatus="status">
				<c:if test="${status.index < 5}">
					<div class="hpa-bar-row">
						<span class="hpa-bar-label">${entry.key}</span>
						<div class="hpa-bar-track">
							<div class="hpa-bar-fill" style="width:${entry.value * 100 / totalCount}%;"></div>
						</div>
						<span class="hpa-bar-count">${entry.value}</span>
					</div>
				</c:if>
			</c:forEach>
		</div>
	</div>

	<!-- ---- 구/동 별 아코디언 목록 ---- -->
	<c:if test="${empty grouped}">
		<p class="hpa-empty">등록된 병원이 없습니다.</p>
	</c:if>

	<c:forEach var="guEntry" items="${grouped}">
		<details class="hpa-gu-group">
			<summary class="hpa-gu-summary">
				<span class="hpa-gu-name">${guEntry.key}</span>
				<span class="hpa-gu-count">${guTotalCount[guEntry.key]}곳</span>
			</summary>

			<div class="hpa-dong-list">
				<c:forEach var="dongEntry" items="${guEntry.value}">
					<div class="hpa-dong-group">
						<h4 class="hpa-dong-name">${dongEntry.key} <span class="hpa-dong-count">${fn:length(dongEntry.value)}</span></h4>

						<table class="hpa-table">
							<c:forEach var="hp" items="${dongEntry.value}">
								<tr>
									<td class="hpa-td-name">
										<a href="/guest/hospital/hospitalView?hp_no=${hp.hp_no}">${hp.hp_name}</a>
									</td>
									<td class="hpa-td-addr">${hp.hp_addr}</td>
									<td class="hpa-td-tel">${hp.hp_tel}</td>
									<td class="hpa-td-action">
										<a href="/admin/hospital/hospitalUpdateForm?hp_no=${hp.hp_no}" class="hpa-btn-edit">수정</a>
										<a href="/hp_delete?hp_no=${hp.hp_no}" class="hpa-btn-delete"
										   onclick="return confirm('정말로 삭제하시겠습니까?\n삭제한 이후엔 병원 정보를 복구할 수 없습니다.');">삭제</a>
									</td>
								</tr>
							</c:forEach>
						</table>
					</div>
				</c:forEach>
			</div>
		</details>
	</c:forEach>

</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>