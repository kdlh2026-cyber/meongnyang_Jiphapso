<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 상세보기</title>
</head>
<body>
<%@ include file="../hamburger_menu.jsp" %>
	<div>
		<table border="1" width="700">
			<tr>
				<td>
				 	${view.comm_type} ${view.comm_pet_type} ${view.comm_breed}
				 </td>
			</tr>
			<tr>
				<td>
					${view.comm_title}
				</td>
			</tr>
			<tr>
				<td>
					${view.comm_writer}
				</td>
			</tr>
			<tr>
				<td>
					<fmt:formatDate value="${view.comm_date}" pattern="yyyy-MM-dd" />
				 </td>
			</tr>
			<tr>
				<td>
					조회 ${view.comm_view}
				</td>
			</tr>
			<tr>
				<td>
					${view.comm_content}
				</td>
			</tr>
			<tr>
				<td>
					 <!-- 다수의 이미지를 순서대로 출력 -->
					<c:forEach var="imgUrl" items="${view.img_url_list}">
						<div>
							<img src="${imgUrl}" width="400" alt="상세 이미지">
						</div>
					</c:forEach>
				</td>
			</tr>
			<tr>
				<td>
					${view.comm_tag}
				</td>
			</tr>
			<tr>
				<td>
					도움돼요 ${view.comm_good} 글쎄요 ${view.comm_well} <!-- 버튼 이벤트로 클릭하면 횟수 업데이트 및 DB에 저장 -->
				</td>
			</tr>
		</table>
	</div>

	
<%@ include file="../footer.jsp" %>
</body>
</html>