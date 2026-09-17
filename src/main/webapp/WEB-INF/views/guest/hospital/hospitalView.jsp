<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>멍냥집합소</title>
<link rel="stylesheet" href="/css/hospital/hpview.css">
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>

<div class="hpv-wrap">

	<div class="hpv-card">

		<div class="hpv-head">
			<h3 class="hpv-name">${hospital.hp_name}</h3>
			<p class="hpv-addr">${hospital.hp_addr}</p>
		</div>

		<div class="hpv-info-list">
			<div class="hpv-info-row">
				<span class="hpv-info-label">전화</span>
				<span class="hpv-info-value">${hospital.hp_tel}</span>
			</div>

			<c:if test="${not empty hospital.hp_url}">
				<div class="hpv-info-row">
					<span class="hpv-info-label">홈페이지</span>
					<a class="hpv-info-value hpv-link" href="${hospital.hp_url}" target="_blank" rel="noopener noreferrer">${hospital.hp_url}</a>
				</div>
			</c:if>

			<div class="hpv-info-row">
				<span class="hpv-info-label">진료시간</span>
				<span class="hpv-info-value">${hospital.hp_hour}</span>
			</div>
		</div>

		<c:if test="${not empty hospital.hp_sp_clinic}">
			<div class="hpv-tag-section">
				<span class="hpv-tag-title">진료과목</span>
				<div class="hpv-tag-row">
					<c:forEach var="clinic" items="${fn:split(hospital.hp_sp_clinic, ',')}">
						<span class="tag">${clinic}</span>
					</c:forEach>
				</div>
			</div>
		</c:if>

		<c:if test="${not empty hospital.hp_keyword}">
			<div class="hpv-tag-section">
				<span class="hpv-tag-title">키워드</span>
				<div class="hpv-tag-row">
					<c:forEach var="kw" items="${fn:split(hospital.hp_keyword, ',')}">
						<span class="tag tag--outline">${kw}</span>
					</c:forEach>
				</div>
			</div>
		</c:if>

	</div>

	<!-- ---- 지도 영역 ---- -->
	<div class="hpv-map-card">
		<h4 class="hpv-map-title">오시는 길</h4>
		<div id="map" class="hpv-map" data-addr="${hospital.hp_addr}" data-name="${hospital.hp_name}"></div>
	</div>

</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>

<!-- 카카오맵 SDK - APP_KEY는 발급받은 JavaScript 키로 교체 -->
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=26a58eff51243ea572aa7258f6dd02fd&libraries=services"></script>
<script>
	(function () {
		var mapEl = document.getElementById('map');
		var addr = mapEl.getAttribute('data-addr');
		var name = mapEl.getAttribute('data-name');

		var map = new kakao.maps.Map(mapEl, {
			center: new kakao.maps.LatLng(37.5665, 126.9780), // 주소 변환 전 기본 좌표(서울시청)
			level: 4
		});

		var geocoder = new kakao.maps.services.Geocoder();

		geocoder.addressSearch(addr, function (result, status) {
			if (status === kakao.maps.services.Status.OK) {
				var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

				map.setCenter(coords);

				var marker = new kakao.maps.Marker({
					map: map,
					position: coords
				});

				var infowindow = new kakao.maps.InfoWindow({
					content: '<div style="padding:6px 10px;font-size:12.5px;">' + name + '</div>'
				});
				infowindow.open(map, marker);
			} else {
				mapEl.innerHTML = '<p style="text-align:center;padding-top:120px;color:#8b7263;font-size:13.5px;">지도를 불러올 수 없습니다.</p>';
			}
		});
	})();
</script>
</body>
</html>