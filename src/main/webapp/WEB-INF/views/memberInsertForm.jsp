<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>멍냥집합소</title>
</head>
<body>
<%@ include file="/WEB-INF/views/loading_animal.jsp" %>
<%@ include file="hamburger_menu.jsp" %>
	<form id="memberInsertForm" method="post" action="/memberInsert" enctype="multipart/form-data" data-loading>
		<table>
			<tr>
				<td>아이디</td>
				<td><input type="text" name="m_id"></td>
			</tr>
			<tr>
				<td>비밀번호</td>
				<td><input type="password" name="m_passwd"></td>
			</tr>
			<tr>
				<td>이름</td>
				<td><input type="text" name="m_name" placeholder="필수입력"></td>
			</tr>
			<tr>
				<td>전화번호</td>
				<td><input type="text" name="m_tel" placeholder="필수입력"></td>
			</tr>
			<tr>
				<td>주소</td>
				<td><input type="text" name="m_addr" placeholder="필수입력"></td>
			</tr>
			<tr>
				<td>상세주소</td>
				<td><input type="text" name="m_addr_detail" placeholder="필수입력"></td>
			</tr>
			<tr>
				<td>우편번호</td>
				<td><input type="text" name="m_zipno" placeholder="필수입력"></td>
			</tr>
			<tr>
				<td>이메일</td>
				<td><input type="text" name="m_email"></td>
			</tr>
			<tr>
				<td>간단소개</td>
				<td><textarea name="m_introduce"></textarea></td>
			</tr>
			<tr>
				<td>생년월일</td>
				<td><input type="date" name="m_birth"></td>
			</tr>
			<tr>
				<td>프로필 사진</td>
				<td><input type="file" name="m_upload"></td>
			</tr>
		</table>
		<input type="submit" value="회원가입">
	</form>
<%@ include file="footer.jsp" %>
</body>
</html>