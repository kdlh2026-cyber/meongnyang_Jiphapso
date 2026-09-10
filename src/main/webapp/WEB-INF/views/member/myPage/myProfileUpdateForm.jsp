<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>멍냥집합소</title>
</head>
<body>
<%@ include file="/WEB-INF/views/loading_animal.jsp" %>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
	<form name="memUpdateForm" method="post" action="memberUpdate" enctype="multipart/form-data" data-loading>
		<table>
			<tr>
				<td>
					<img src="/images/myProfile/${MemberUpdate.m_img}" width="100" alt="현재 이미지">
				</td>
			</tr>
			<tr>
				<td>아이디</td>
				<td>${MemberUpdate.m_id}</td>
			</tr>
			<tr>
				<td>비밀번호</td>
				<td><input type="password" name="m_passwd"></td>
			</tr>
			<tr>
				<td>이름</td>
				<td>${MemberUpdate.m_name}</td>
			</tr>
			<tr>
				<td>전화번호</td>
				<td><input type="text" name="m_tel" placeholder="필수입력" value="${MemberUpdate.m_tel}"></td>
			</tr>
			<tr>
				<td>주소</td>
				<td><input type="text" name="m_addr" placeholder="필수입력" value="${MemberUpdate.m_addr}"></td>
			</tr>
			<tr>
				<td>상세주소</td>
				<td><input type="text" name="m_addr_detail" placeholder="필수입력" value="${MemberUpdate.m_addr_detail}"></td>
			</tr>
			<tr>
				<td>우편번호</td>
				<td><input type="text" name="m_zipno" placeholder="필수입력" value="${MemberUpdate.m_zipno}"></td>
			</tr>
			<tr>
				<td>이메일</td>
				<td><input type="text" name="m_email" value="${MemberUpdate.m_email}"></td>
			</tr>
			<tr>
				<td>간단소개</td>
				<td><textarea name="m_introduce">${MemberUpdate.m_introduce}</textarea></td>
			</tr>
			<tr>
				<td>생년월일</td>
				<td>
				<fmt:formatDate value="${MemberUpdate.m_birth}" pattern="yyyy-MM-dd" var="birthFormatted" />
				<input type="date" name="m_birth" value="${birthFormatted}">
				</td>
			</tr>
			<tr>
				<td>프로필 사진</td>
				<td>
					<input type="file" name="m_upload">
					<!-- 기존 파일명을 hidden으로 같이 넘겨 새 파일 없으면 기존 값 유지 -->
					<input type="hidden" name="m_img" value="${MemberUpdate.m_img}">
				</td>
			</tr>
		</table>
		<input type="submit" value="수정">
		<input type="reset" value="취소">
	</form>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>