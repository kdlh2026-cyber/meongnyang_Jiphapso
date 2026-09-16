<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>멍냥집합소</title>
<script src="/js/main/memberCheck.js"></script>
</head>
<body>
<%@ include file="/WEB-INF/views/loading_animal.jsp" %>
<%@ include file="hamburger_menu.jsp" %>
	<form name="memberForm" method="post" action="/memberInsert" enctype="multipart/form-data" onsubmit="return mInsertcheck();" data-loading>
		<table>
			<tr>
				<td><span style="color:#ff0000;">*</span>아이디</td>
				<td><input type="text" name="m_id"></td>
			</tr>
			<tr>
				<td><span style="color:#ff0000;">*</span>비밀번호</td>
				<td><input type="password" name="m_passwd"></td>
			</tr>
			<tr>
				<td><span style="color:#ff0000;">*</span>비밀번호 확인</td>
				<td><input type="password" name="m_passwd1"></td>
			</tr>
			<tr>
				<td><span style="color:#ff0000;">*</span>이름</td>
				<td><input type="text" name="m_name"></td>
			</tr>
			<tr>
				<td><span style="color:#ff0000;">*</span>전화번호</td>
				<td><input type="text" name="m_tel"></td>
			</tr>
			<tr>
				<td><span style="color:#ff0000;">*</span>주소</td>
				<td>
					<input type="text" name="m_addr" readonly>
					<button type="button" onclick="goPopup();">주소검색</button>
				</td>
			</tr>
			<tr>
				<td><span style="color:#ff0000;">*</span>상세주소</td>
				<td><input type="text" name="m_addr_detail"></td>
			</tr>
			<tr>
				<td><span style="color:#ff0000;">*</span>우편번호</td>
				<td><input type="text" name="m_zipno"></td>
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
				<td>만 14세 이상</td>
				<td><input type="checkbox" name="m_age_upper"></td>
			</tr>
			<tr>
				<td><span style="color:#ff0000;">*</span>서비스 이용약관 동의 여부</td>
				<td><input type="checkbox" name="m_ser_agree">(<a href="/guest/etc/ToS">약관 보기</a>)</td>
			</tr>
			<tr>
				<td><span style="color:#ff0000;">*</span>회원 정보 수집 동의 여부</td>
				<td><input type="checkbox" name="m_pub_agree">(<a href="/guest/etc/privacyPolicy">약관 보기</a>)</td>
			</tr>
			<tr>
				<td>SNS 수신 동의 여부</td>
				<td><input type="checkbox" name="m_sns"></td>
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