<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 북마크 조회</title>
</head>
<body>
	<div>
		<h3>저장한 콘텐츠 글</h3>
	</div>
	<div>

		<table border="1" width="800">
		<c:forEach var="mark" items="${bookmarkList}">
			<tr>
				<td colspan="2">
					<span class="comm_type">${mark.comm_type}</span>
					<span class="comm_category">${mark.comm_category}</span>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<span class="comm_writer">${mark.comm_writer}</span>
					<span class="comm_date">
						<fmt:formatDate value="${mark.comm_date}" pattern="yyyy-MM-dd" />
					</span>
				</td>
			</tr>
			<tr>
				<td class="comm_title">
					<a href="/community/commView?comm_no=${mark.comm_no}">${mark.comm_title}</a>
				</td>
			<c:if test="${not empty mark.comm_img}">
			    <td class="comm_img">
			        <img src="${mark.comm_img}" width="400" alt="상세 이미지">
			    </td>
			</c:if>
			</tr>
		</c:forEach>
		</table>
	</div>
</body>
</html>