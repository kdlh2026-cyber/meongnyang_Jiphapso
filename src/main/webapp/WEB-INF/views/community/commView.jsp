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
			<c:forEach var="comment" items="${cmt}"> <!-- 댓글 작성 -> DB 저장 -> 댓글 테이블에서 정보 가져오기 -->
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
					        	(답글 수)
					            <a href="/community/comment/reply-auth?comm_no=${view.comm_no}&cmt_no=${comment.cmt_no}">
					                답글
					            </a>
					        </div>
					    </sec:authorize>
					
					    <sec:authorize access="isAuthenticated()">
					    	<div>
					        	(답글 수) <button type="button" onclick="showReplyForm('${comment.cmt_no}')">답글</button>
					        </div>
					    </sec:authorize>
					</div>
				</div>
			</c:forEach>
		</div>
	</div>

	
<%@ include file="../footer.jsp" %>
</body>
<script>
function showReplyForm(cmt_no) {
    // 기존에 열려있는 답글 폼이 있다면 제거하거나 토글
    let existingForm = document.getElementById("reply-form-" + cmt_no);
    if (existingForm) {
        existingForm.remove();
        return;
    }

    // 해당 댓글 아래에 동적으로 답글 입력 폼 삽입
    let targetDiv = document.getElementById("comment-body-" + cmt_no); // 댓글 바디 ID

    let replyHtml = `
        <div id="reply-form-${cmt_no}" class="reply-input-box" style="margin-top: 10px; padding-left: 20px;">
            <form action="/community/replyWrite" method="post">
                <input type="hidden" name="cmt_answer_no" value="${cmt_no}"> 
                <input type="hidden" name="comm_no" value="${view.comm_no}">   
                <input type="hidden" name="comm_type" value="${view.comm_type}">
                <textarea name="cmt_content" rows="2" cols="50" placeholder="답글을 남겨주세요"></textarea>
                <button type="submit">등록</button>
            </form>
        </div>
    `;
    targetDiv.insertAdjacentHTML('afterend', replyHtml);
}
</script>
</html>