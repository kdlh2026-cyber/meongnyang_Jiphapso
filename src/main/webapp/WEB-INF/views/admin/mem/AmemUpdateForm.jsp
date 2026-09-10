<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
</head>
<body>
<%@ include file="/WEB-INF/views/loading_animal.jsp" %>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
	<form name="AmemUpdateForm" method="post" action="/AmemUpdate" enctype="multipart/form-data" data-loading>
		<input type="hidden" name="m_id" value="${AmemUpdate.m_id}">
		<table>
			<tr>
				<td><img src="/images/myProfile/${AmemUpdate.m_img}" alt="${AmemUpdate.m_img}" width="150px"></td>
			</tr>
			<tr>
				<td><input type="text" value="${AmemUpdate.m_id}"></td>
			</tr>
			<tr>
				<td>
					<select name="m_authority">
						<option value="USER">일반회원</option>
						<option value="CREATOR">크리에이터</option>
						<option value="BADMAN">불량회원</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>${AmemUpdate.m_name}</td> <!-- **처리 필요 -->
			</tr>
			<tr>
				<td>${AmemUpdate.m_email}</td> <!-- **처리 필요 -->
			</tr>
			<tr>
				<td><textarea name="m_introduce">${AmemUpdate.m_introduce}</textarea></td>
			</tr>
			<tr>
				<td><fmt:formatDate value="${AmemUpdate.m_birth}" pattern="yyyy-MM-dd" /></td>
			</tr> <!-- **처리 필요 -->
			<tr>
				<td>SNS 수신 동의 여부: ${AmemUpdate.m_sns}</td>
			</tr>			
			<tr>
				<td><input type="file" name="m_upload"></td>
			</tr>
		</table>
		<input type="submit" value="수정">
	</form>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>