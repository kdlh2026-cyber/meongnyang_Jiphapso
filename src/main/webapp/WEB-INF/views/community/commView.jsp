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
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
    /* 전체 레이아웃 및 폰트 기본 설정 */
    body {
        font-family: 'Malgun Gothic', sans-serif;
        color: #333;
        line-height: 1.5;
        margin: 0;
        padding: 20px;
        background-color: #f9f9f9;
    }

    /* 게시글 테이블 박스 스타일 */
    table {
        width: 700px;
        margin: 0 auto 30px auto;
        border-collapse: collapse;
        background-color: #fff;
        border: 1px solid #ddd;
        box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }

    table td {
        padding: 15px;
        border-bottom: 1px solid #eee;
    }

    /* 상세 내용 안의 미디어 및 이미지 크기 제한 */
    .video-container video, 
    table img {
        max-width: 100%;
        height: auto;
        display: block;
        margin: 10px auto;
    }

    /* 추천/비추천 버튼 영역 */
    .recommend-box button {
        padding: 8px 16px;
        margin: 0 5px;
        cursor: pointer;
        background-color: #fff;
        border: 1px solid #ccc;
        border-radius: 4px;
        font-weight: bold;
    }
    .recommend-box button:hover {
        background-color: #f1f1f1;
    }

    /* 댓글 영역 전체 컨테이너 */
    .comment_section {
        width: 700px;
        margin: 0 auto;
        background-color: #fff;
        padding: 20px;
        border: 1px solid #ddd;
        border-radius: 4px;
    }

    /* 댓글 상단 (개수 및 정렬) */
    .comment_section > div:first-child {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 15px;
        font-weight: bold;
        border-bottom: 2px solid #333;
        padding-bottom: 10px;
    }

    .comment_section select {
        padding: 5px;
        border: 1px solid #ccc;
        border-radius: 3px;
    }

    /* 댓글 입력 폼 */
    .comment_box textarea {
        width: 100%;
        box-sizing: border-box;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
        resize: vertical;
        margin-bottom: 8px;
    }

    .comment_box input[type="submit"],
    .edit-input-box button,
    .reply-input-box button,
    .comment_btn_box button,
    .comment_answer button,
    .comment_delete_btn button {
        padding: 5px 10px;
        background-color: #f1f1f1;
        border: 1px solid #ccc;
        border-radius: 3px;
        cursor: pointer;
        font-size: 12px;
    }

    .comment_box div:has(input[type="submit"]) {
        text-align: right;
    }

    /* 개별 댓글 아이템 */
    .comment_body {
        padding: 12px 0;
        border-bottom: 1px solid #eee;
    }

    .comment_title {
        font-size: 13px;
        color: #666;
        margin-bottom: 5px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .comment_content {
        font-size: 14px;
        margin-bottom: 8px;
    }

    /* 답글 영역 */
    .comment_answer {
        font-size: 12px;
    }

    .comment_answer button {
        background-color: transparent;
        border: none;
        color: #555;
        cursor: pointer;
        padding: 0;
        text-decoration: underline;
    }

    /* 대댓글(답글) 리스트 들여쓰기 */
    .reply_list {
        margin-left: 25px;
        padding-left: 15px;
        border-left: 2px solid #f0f0f0;
        background-color: #fafafa;
        margin-top: 5px;
        margin-bottom: 5px;
    }

    .reply_item {
        padding: 10px 0;
        border-bottom: 1px solid #eee;
    }
    .reply_item:last-child {
        border-bottom: none;
    }

    /* 수정/삭제 버튼 그룹 정렬 */
    .comment_btn_box {
        display: inline-block;
    }
    
    .comment_delete_btn {
        text-align: right;
        margin-top: 5px;
    }
</style>
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
			<c:if test="${view.comm_type eq '콘텐츠'}">
			<tr>
				<td>
					<button type="button" id="bookmark-btn" onclick="fnBookmark()" style="${isBookmarked ? 'background-color: #ffeb3b;' : ''}">
			            <span id="bookmark-text">${isBookmarked ? '북마크 취소' : '북마크'}</span>
			        </button>
				</td>
			</tr>
			</c:if>
				<td>
					${view.comm_content}
				</td>
			</tr>
			<tr>
			    <td>
			        <!-- 비디오 파일명이 존재할 때만 비디오 영역 출력 -->
			        <c:if test="${not empty view.comm_video}">
			            <div class="video-container">
			                <video width="640" height="360" controls>
			                    <source src="/images/community/${view.comm_video}" type="video/mp4">
			                </video>
			            </div>
			        </c:if>
			
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
					<div class="recommend-box" style="margin: 20px 0; text-align: center;">
					    <button type="button" onclick="fnRecommend('GOOD')">도움돼요 <span id="count-good">${view.comm_good}</span></button>
					    <button type="button" onclick="fnRecommend('WELL')">글쎄요 <span id="count-well">${view.comm_well}</span></button>
					</div>
				</td>
			</tr>
			
			<tr>
			    <td style="text-align: right;">
			        <c:if test="${not empty loginMno and loginMno eq view.m_no}">
			            <button type="button" onclick="location.href='/community/updateForm?comm_no=${view.comm_no}'">수정하기</button>
			            <button type="button" onclick="fnDeletePost('${view.comm_no}')">삭제하기</button>
			        </c:if>
			    </td>
			</tr>
		</table>
	</div>

	<!-- 댓글 영역 -->
	<div class="comment_section">
		<div>
			<span>댓글 ${not empty reply_count ? reply_count : 0}</span>
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
				<c:if test="${empty comment.cmt_answer_no}">
					<div class="comment_body" id="comment-body-${comment.cmt_no}">
						<div class="comment_title" style="display: flex; align-items: center; gap: 10px;">
						    <div>
						        ${comment.cmt_writer} | <fmt:formatDate value="${comment.cmt_date}" pattern="yyyy.MM.dd" />
						    </div>
						    
						    <sec:authorize access="isAuthenticated()">
						        <sec:authentication property="principal.username" var="loginId" />
						        <c:if test="${loginId eq comment.cmt_writer}">
						            <div class="comment_btn_box">
						                <button type="button" onclick="showEditForm(this, '${comment.cmt_no}')">수정</button>
						                <button type="button" onclick="location.href='/comment/delete?cmt_no=${comment.cmt_no}&comm_no=${view.comm_no}'">삭제</button>
						            </div>
						        </c:if>
						    </sec:authorize>
						</div>
					    
						<div class="comment_content" id="comment-content-${comment.cmt_no}">                    
						    <c:choose>
						        <c:when test="${comment.cmt_deleted eq 'Y'}">
						            <i>삭제된 댓글입니다.</i>
						        </c:when>
						        <c:otherwise>
						            ${comment.cmt_content}
						        </c:otherwise>
						    </c:choose>
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
										<div class="comment_content" id="comment-content-${reply.cmt_no}">					
											${reply.cmt_content}
										</div>
										
										<sec:authorize access="isAuthenticated()">
			                                <sec:authentication property="principal.username" var="loginId" />
			                                <c:if test="${loginId eq reply.cmt_writer}">
			                                    <button type="button" onclick="showEditForm(this, '${reply.cmt_no}')">수정</button>
			                                    <button type="button" onclick="location.href='/comment/delete?cmt_no=${reply.cmt_no}&comm_no=${view.comm_no}'">삭제</button>
			                                </c:if>
			                            </sec:authorize>
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

    var commNo = "${view.comm_no}";
    var commType = "${view.comm_type}";

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

function showEditForm(button, cmt_no) {
    let contentDiv = document.getElementById("comment-content-" + cmt_no);
    let existingForm = document.getElementById("edit-form-" + cmt_no);

    if (existingForm) {
        existingForm.remove();
        contentDiv.style.display = "block";
        return;
    }

    let originalText = contentDiv.textContent.trim();
    contentDiv.style.display = "none";

    var commNo = "${view.comm_no}";
    
    // Spring Security CSRF 토큰 설정 (시큐리티 사용 시 필수)
    var csrfToken = "${_csrf.token}"; 
    var csrfHeader = "${_csrf.headerName}";

    var editHtml =
        '<div id="edit-form-' + cmt_no + '" class="edit-input-box" style="margin-top: 10px;">' +
        '  <form action="/comment/update" method="post">' +
        '    <input type="hidden" name="cmt_no" value="' + cmt_no + '">' +
        '    <input type="hidden" name="comm_no" value="' + commNo + '">' +
        '    <input type="hidden" name="' + csrfHeader + '" value="' + csrfToken + '">' +
        '    <textarea name="cmt_content" rows="2" cols="50">' + originalText + '</textarea>' +
        '    <button type="submit">수정 완료</button>' +
        '    <button type="button" onclick="cancelEdit(\'' + cmt_no + '\')">취소</button>' +
        '  </form>' +
        '</div>';

    contentDiv.insertAdjacentHTML('afterend', editHtml);
}

function cancelEdit(cmt_no) {
    let editForm = document.getElementById("edit-form-" + cmt_no);
    let contentDiv = document.getElementById("comment-content-" + cmt_no);
    if (editForm) editForm.remove();
    contentDiv.style.display = "block";
}

function fnRecommend(type) {
    let commNo = "${view.comm_no}";
    
    var csrfToken = "${_csrf != null ? _csrf.token : ''}";
    var csrfHeader = "${_csrf != null && not empty _csrf.headerName ? _csrf.headerName : 'X-CSRF-TOKEN'}";

    let ajaxConfig = {
        url: "/community/recommend",
        type: "POST",
        data: { comm_no: commNo, type: type },
        success: function(response) {
            if (response === "LOGIN_REQUIRED") {
                alert("로그인 후 이용 가능합니다.");
                location.href = "/loginForm"; 
                return;
            } else if (response === "ALREADY_VOTED") {
                alert("이미 평가를 완료한 게시글입니다."); // 👈 반대쪽 누를 때만 알럿!
                return;
            }
        	
            // 카운트 숫자를 동적으로 변경하기 위한 선택자 지정
            let $countSpan = (type === "GOOD") ? $("#count-good") : $("#count-well");
            let currentCount = parseInt($countSpan.text()) || 0;

            if (response === "SUCCESS") {
                $countSpan.text(currentCount + 1); // 등록 시 +1
            } else if (response === "CANCELED") {
                $countSpan.text(Math.max(0, currentCount - 1)); // 본인 버튼 재클릭 시 취소 (-1)
            }
        },
        error: function(xhr, status, error) {
            console.error(error);
            alert("오류가 발생했습니다.");
        }
    };

    if (csrfHeader && csrfToken) {
        ajaxConfig.beforeSend = function(xhr) {
            xhr.setRequestHeader(csrfHeader, csrfToken);
        };
    }

    $.ajax(ajaxConfig);
}

function fnDeletePost(comm_no) {
    if (confirm("정말 이 게시글을 삭제하시겠습니까?")) {
        location.href = '/community/delete?comm_no=' + comm_no;
    }
}

function fnBookmark() {
    let commNo = "${view.comm_no}";
    
    var csrfToken = "${_csrf != null ? _csrf.token : ''}";
    var csrfHeader = "${_csrf != null && not empty _csrf.headerName ? _csrf.headerName : 'X-CSRF-TOKEN'}";

    let ajaxConfig = {
        url: "/community/bookmark",
        type: "POST",
        data: { comm_no: commNo },
        success: function(response) {
            if (response === "LOGIN_REQUIRED") {
                alert("로그인 후 이용 가능합니다.");
                location.href = "/loginForm";
                return;
            }
            
            let $btn = $("#bookmark-btn");
            let $text = $("#bookmark-text");

            if (response === "ADDED") {
                alert("북마크에 추가되었습니다.");
                $btn.css("background-color", "#ffeb3b"); // 예시: 노란색으로 변경
                $text.text("북마크 취소");
            } else if (response === "DELETED") {
                alert("북마크가 해제되었습니다.");
                $btn.css("background-color", ""); // 원래 색으로 복구
                $text.text("북마크");
            }
        },
        error: function(xhr, status, error) {
            console.error(error);
            alert("오류가 발생했습니다.");
        }
    };

    if (csrfHeader && csrfToken) {
        ajaxConfig.beforeSend = function(xhr) {
            xhr.setRequestHeader(csrfHeader, csrfToken);
        };
    }

    $.ajax(ajaxConfig);
}
</script>
</html>