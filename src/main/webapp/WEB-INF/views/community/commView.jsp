<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
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

					<div class="video-container">
					    <video width="640" height="360" controls>
					        <source src="/images/community/${view.comm_video}" type="video/mp4">
					    </video>
					</div>
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

	<!-- 댓글 영역 -->
	<div class="comment_section">
		<div>
			<span>댓글 ${not empty commentCount ? commentCount : 0}</span>
			<select name="comment_sort">
				<option value="latest">최신순</option>
				<option value="popular">공감순</option>
			</select>
		</div>
		
		<div class="comment_box">
	        <sec:authorize access="isAuthenticated()">
	            <form name="comment_form" method="post" action="/commentWrite">
	                <input type="hidden" name="comm_no" value="${view.comm_no}">
	                <input type="hidden" name="comm_type" value="${view.comm_type}">
	                <input type="hidden" name="cmt_writer" value="<sec:authentication property='principal.username'/>">
	              
	                <textarea name="cmt_content" rows="3" placeholder="댓글을 남겨보세요."></textarea>
	                <div>
	                    <input type="submit" value="등록">
	                </div>
	            </form>
	        </sec:authorize>
        
	        <sec:authorize access="isAnonymous()">
	            <div>
	                <span>로그인하면 바로 이 글에 댓글을 남길 수 있어요</span>
	                <a href="/community/comment/write-auth?comm_no=${view.comm_no}">로그인하고 댓글 남기기</a>
	            </div>
	        </sec:authorize>
		</div>
		
		<div class="comment_list">
		<!-- 댓글 리스트가 비어있지 않을 때만 전체 목록 영역을 그림 -->
		<c:if test="${not empty cmt}">
			<c:forEach var="comment" items="${cmt}"> 
				<!-- 1. 부모 댓글만 먼저 출력 (cmt_answer_no가 비어있는 것) -->
				<c:if test="${empty comment.cmt_answer_no and not empty comment.cmt_content}">
					<div class="comment_body" id="comment-body-${comment.cmt_no}">
						<div class="comment_title">
							${comment.cmt_writer} | <fmt:formatDate value="${comment.cmt_date}" pattern="yyyy.MM.dd" />
						</div>
						<div class="comment_content">					
							${comment.cmt_content}
						</div>
						
						<div class="comment_answer">
						    <sec:authorize access="isAnonymous()">
						        <div class="need-login-reply">
						            <a href="/community/comment/reply-auth?comm_no=${view.comm_no}&cmt_no=${comment.cmt_no}">
						                답글
						            </a>
						        </div>
						    </sec:authorize>
						
							<sec:authorize access="isAuthenticated()">
							    <div>
							        <button type="button">도움돼요</button>
							        <button type="button" onclick="showReplyForm(this, '${comment.cmt_no}')">답글</button>
							    </div>
							</sec:authorize>
						</div>
					</div>

					<!-- 2. 해당 부모 댓글에 속하는 답글이 실제로 존재하는지 체크 후 출력 -->
					<c:set var="hasReply" value="false" />
					<c:forEach var="reply" items="${cmt}">
						<c:if test="${reply.cmt_answer_no == comment.cmt_no}">
							<c:set var="hasReply" value="true" />
						</c:if>
					</c:forEach>

					<c:if test="${hasReply}">
						<div class="reply_list">
							<c:forEach var="reply" items="${cmt}">
								<c:if test="${reply.cmt_answer_no == comment.cmt_no}">
									<div class="reply_item">
										<div class="comment_title">
											<b>${reply.cmt_writer}</b> | <fmt:formatDate value="${reply.cmt_date}" pattern="yyyy.MM.dd" />
										</div>
										<div class="comment_content">					
											${reply.cmt_content}
										</div>
									</div>
								</c:if>
							</c:forEach>
						</div>
					</c:if>

				</c:if>
			</c:forEach>
		</c:if>
	</div>
	
<%@ include file="../footer.jsp" %>
</body>
<script>
function showReplyForm(button, cmt_no) {
    let commentBody = button.closest('.comment_body');
    let existingForm = document.getElementById("reply-form-" + cmt_no);

    if (existingForm) {
        existingForm.remove();
        return;
    }

    // JSP EL 값은 여기서 한 번만 추출 (이 줄만 서버에서 렌더링됨)
    var commNo = "${view.comm_no}";
    var commType = "${view.comm_type}";

    // 이후로는 순수 JS 문자열 연결(+)만 사용 - 템플릿 리터럴(백틱) 사용 안 함
    var replyHtml =
        '<div id="reply-form-' + cmt_no + '" class="reply-input-box" style="margin-top: 10px; padding-left: 20px;">' +
        '  <form action="/community/replyWrite" method="post">' +
        '    <input type="hidden" name="cmt_answer_no" value="' + cmt_no + '">' +
        '    <input type="hidden" name="comm_no" value="' + commNo + '">' +
        '    <input type="hidden" name="comm_type" value="' + commType + '">' +
        '    <textarea name="cmt_content" rows="2" cols="50" placeholder="답글을 남겨주세요"></textarea>' +
        '    <button type="submit">등록</button>' +
        '  </form>' +
        '</div>';

    commentBody.insertAdjacentHTML('afterend', replyHtml);
}
</script>
</html>