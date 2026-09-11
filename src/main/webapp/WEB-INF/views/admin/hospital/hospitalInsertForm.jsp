<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
	<form name="hospitalInsertForm" method="post" action="/hp_insert">
		<table>
			<tr>
				<td>병원 이름</td>
				<td><input type="text" name="hp_name"></td>
			</tr>
			<tr>
				<td>병원 주소</td>
				<td><input type="text" name="hp_addr"></td>
			</tr>
			<tr>
				<td>상세주소</td>
				<td><input type="text" name="hp_addr_detail"></td>
			</tr>
			<tr>
				<td>병원 우편번호</td>
				<td><input type="text" name="hp_zipno"></td>
			</tr>
			<tr>
				<td>전화번호</td>
				<td><input type="text" name="hp_tel"></td>
			</tr>
			
			<tr>
				<td>url</td>
				<td><input type="text" name="hp_url"></td>
			</tr>
			<tr>
				<td>진료시간</td>
				<td><textarea name="hp_hour"></textarea></td>
			</tr>
			<tr>
				<td>특화 진료</td>
				<td><input type="text" name="hp_sp_clinic"></td>
			</tr>
			<tr>
				<td>키워드</td>
				<td><input type="text" name="hp_keyword"></td>
			</tr>
		</table>
		<input type="submit" value="등록">
	</form>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>