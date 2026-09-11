<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${StrayView.stray_name} ${StrayView.stray_gender} ${StrayView.stray_age}년생</title>
</head>
<style>
.image img {
		width: 80%;
		height: auto;
		max-width: 300px;
	}
</style>
<body>
	<div>
		<div class="image">
			<img src="/uploadImages/${StrayView.stray_img}">
		</div>
		<div>
			<div>
				<div>
				<c:choose>
			        <c:when test="${StrayView.stray_category == 'DOG'}"><img src="/images/stray/menu/LILI_MINI.f614311b.png"> 강아지</c:when>
			        <c:when test="${StrayView.stray_category == 'CAT'}"><img src="/images/stray/menu/SAMSEK_MINI.2d53f16f.png"> 고양이</c:when>
		        </c:choose>
				</div>
				<div>
				${StrayView.stray_name}
        		<span>|</span>
        		<c:set var="currentYear" value="<%= java.time.LocalDate.now().getYear() %>" />
        		<c:set var="age" value="${currentYear - StrayView.stray_age}" />
        		<c:choose>
			        <c:when test="${age == 0}">1살 미만</c:when>
			        <c:otherwise>${age}살</c:otherwise>
		        </c:choose>
				</div>
			</div>
			<div>
				<div>
					<div>${StrayView.stray_gender}</div>
					<div>
						<c:choose>
					        <c:when test="${StrayView.stray_neuter == 'Y'}"> · 중성화 완료</c:when>
					        <c:when test="${StrayView.stray_neuter == 'N'}"> · 중성화 미완료</c:when>
					        <c:when test="${StrayView.stray_neuter == 'Q'}"> · 중성화 알수 없음</c:when>
		   				 </c:choose>
					</div>
					<span>|</span>
					<div>
						${StrayView.stray_character}의 털
					</div>
					<span>|</span>
					<div>
						${StrayView.stray_weight}Kg
					</div>
				</div>
				<div>
					특이사항은? ${StrayView.stray_memo}
				</div>
			</div>
			<div>
				<div>
					<div>상태</div>
					<div>${StrayView.stray_status}</div>
				</div>
				<div>
					<div>공고번호</div>
					<div>${StrayView.stray_notice_no}</div>
				</div>
				<div>
					<div>공고기간</div>
					<div>${StrayView.stray_notice_start} ~ ${StrayView.stray_notice_end}</div>
				</div>
				<div>
					<div>발견장소</div>
					<div>${StrayView.stray_found_place}</div>
				</div>
			</div>
			<div>
				<div>
					<div>
						<div>보호소</div>
						<div>${StrayView.stray_shelter_name}</div>
					</div>
					<div>
						<div>보호소 연락처</div>
						<div>${StrayView.stray_shelter_tel}</div>
					</div>
				</div>
				<div>
					<div>보호주소</div>
					<div>${StrayView.stray_shelter_addr}</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>