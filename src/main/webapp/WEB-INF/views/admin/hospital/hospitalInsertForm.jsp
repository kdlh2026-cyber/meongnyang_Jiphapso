<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
<link rel="stylesheet" href="/css/hospital/hpform.css">
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>

<div class="hp-form-wrap">
	<h2>동물병원 등록</h2>
	<form name="hospitalInsertForm" method="post" action="/hp_insert">
		<table class="hp-form-table">
			<tr>
				<td class="label">병원 이름</td>
				<td><input type="text" name="hp_name"></td>
			</tr>
			<tr>
				<td class="label">병원 주소</td>
				<td><input type="text" name="hp_addr"></td>
			</tr>
			<tr>
				<td class="label">전화번호</td>
				<td><input type="text" name="hp_tel"></td>
			</tr>
			<tr>
				<td class="label">url</td>
				<td><input type="text" name="hp_url"></td>
			</tr>
			<tr>
				<td class="label">진료시간</td>
				<td><textarea name="hp_hour"></textarea></td>
			</tr>
			<tr>
				<td class="label">특화 진료</td>
				<td>
					<div class="tag-input-box" id="sp_clinic_box">
						<input type="text" id="sp_clinic_input" placeholder="입력 후 Enter">
					</div>
					<input type="hidden" name="hp_sp_clinic" id="hp_sp_clinic">
				</td>
			</tr>
			<tr>
				<td class="label">키워드</td>
				<td>
					<div class="tag-input-box" id="keyword_box">
						<input type="text" id="keyword_input" placeholder="입력 후 Enter">
					</div>
					<input type="hidden" name="hp_keyword" id="hp_keyword">
				</td>
			</tr>
			<tr>
				<td class="label">위도</td>
				<td><input type="text" name="hp_lat"></td>
			</tr>
			<tr>
				<td class="label">경도</td>
				<td><input type="text" name="hp_lng"></td>
			</tr>
		</table>
		<input type="submit" value="등록">
	</form>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
<script>
/* 기존 initTagInput 스크립트 그대로 유지 */
</script>
</body>
</html>