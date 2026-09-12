<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>멍냥집합소</title>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
	<div>
		<table border="1" width="700">
			<tr>
				<td>
					${hospital.hp_name}
				</td>
			</tr>
			<tr>
				<td>
					${hospital.hp_addr}
				</td>
			</tr>
			<tr>
				<td>
					${hospital.hp_tel}
				</td>
			</tr>
			<tr>
				<td>
					<c:if test="${not empty hospital.hp_url}">
						<a href="${hospital.hp_url}" target="_blank" rel="noopener noreferrer">${hospital.hp_url}</a>
					</c:if>
				</td>
			</tr>
			<tr>
				<td>
					${hospital.hp_hour}
				</td>
			</tr>
			<tr>
				<td>
					<c:if test="${not empty hospital.hp_sp_clinic}">
						<c:forEach var="clinic" items="${fn:split(hospital.hp_sp_clinic, ',')}">
							<span class="tag">${clinic}</span>
						</c:forEach>
					</c:if>
				</td>
			</tr>
			<tr>
				<td>
					<c:if test="${not empty hospital.hp_keyword}">
						<c:forEach var="kw" items="${fn:split(hospital.hp_keyword, ',')}">
							<span class="tag">${kw}</span>
						</c:forEach>
					</c:if>
				</td>
			</tr>
		</table>
	</div>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>