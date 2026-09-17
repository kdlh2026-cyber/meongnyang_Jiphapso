<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 상세보기</title>
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<link rel="stylesheet" href="/css/community/commView.css">
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>

	<!-- 전체 화면을 감싸는 메인 컨테이너 -->
	<div class="main_container">
	
		<!-- ==========================================
		   1. [상단 영역] 좌측: 본문 / 우측: 사이드바 (인기글, 추천글)
		   ================================---------- -->
		<div class="upper_section_wrapper">
			
			<!-- 왼쪽 영역: 게시글 상세 본문 -->
			<div class="left_content_area">
				<div class="comm_view_card">
					
					<!-- 상단 헤더 영역 -->
					<div class="view_header_area">
						<!-- 뱃지 조합 -->
						<div class="view_badges">
							<c:choose>
								<c:when test="${view.comm_type == '콘텐츠'}">
									<span class="badge highlight">${view.comm_detail}</span>
								</c:when>
								<c:otherwise>
									<c:if test="${not empty view.comm_pet_type}">
										<span class="badge highlight">${view.comm_pet_type}</span>
									</c:if>
									<span class="badge">${view.comm_type == 'QNA' ? 'Q&amp;A' : view.comm_type}</span>
									<c:if test="${not empty view.comm_breed}">
										<span class="badge">${view.comm_breed}</span>
									</c:if>
								</c:otherwise>
							</c:choose>
						</div>

						<!-- 게시글 제목 -->
						<h2 class="view_title">${view.comm_title}</h2>

						<!-- 작성자 프로필 및 메타 정보 -->
						<div class="view_writer_row">
							<div class="writer_profile_img">🐾</div>
							<div class="writer_info_box">
								<span class="writer_name">${view.comm_writer}</span>
								<span class="writer_sub_info">
									<fmt:formatDate value="${view.comm_date}" pattern="yyyy.MM.dd" /> · 조회 ${view.comm_view}
								</span>
							</div>
						</div>
					</div>

					<!-- 콘텐츠일 경우 북마크 버튼 영역 -->
					<c:if test="${view.comm_type eq '콘텐츠'}">
						<div class="bookmark_area">
							<button type="button" id="bookmark-btn" class="bookmark_action_btn ${isBookmarked ? 'active' : ''}" onclick="fnBookmark()">
					            <span id="bookmark-text">${isBookmarked ? '⭐ 북마크 취소' : '⭐ 북마크'}</span>
					        </button>
						</div>
					</c:if>
					
					<hr class="view_divider">
					
					<!-- 본문 내용 영역 -->
					<div class="view_content_body">
						${view.comm_content}
					</div>
					
					<!-- 미디어 및 이미지 영역 -->
					<div class="view_media_area">
						<!-- 비디오 파일명이 존재할 때만 비디오 영역 출력 -->
						<c:if test="${not empty view.comm_video}">
							<div class="video-container">
								<video controls>
									<source src="/images/community/${view.comm_video}" type="video/mp4">
								</video>
							</div>
						</c:if>
				
						<!-- 다수의 이미지를 순서대로 출력 -->
						<c:forEach var="imgUrl" items="${view.img_url_list}">
							<div class="img_box">
								<img src="${imgUrl}" alt="상세 이미지">
							</div>
						</c:forEach>
					</div>
					
					<!-- 태그 영역 -->
					<c:if test="${not empty view.comm_tag}">
						<div class="view_tag_area">
							<span class="tag_item">${view.comm_tag}</span>
						</div>
					</c:if>
					
					<hr class="view_divider">

					<!-- 하단 액션 바 (추천 및 수정/삭제 버튼) -->
					<div class="post-bottom-action-bar">
						<!-- 왼쪽: 도움돼요 / 글쎄요 -->
						<div class="recommend-box">
							<div class="recommend_btn_group">
								<button type="button" class="recommend-btn" onclick="fnRecommend('GOOD')">👍 도움돼요 <span id="count-good">${view.comm_good}</span></button>
								<button type="button" class="recommend-btn" onclick="fnRecommend('WELL')">👎 글쎄요 <span id="count-well">${view.comm_well}</span></button>
							</div>
						</div>
						
						<!-- 오른쪽: 수정하기 / 삭제하기 (작성자 본인일 때만 출력) -->
						<div class="author-actions">
							<c:if test="${not empty loginMno and loginMno eq view.m_no}">
								<button type="button" class="comm-btn btn-update" onclick="location.href='/community/updateForm?comm_no=${view.comm_no}'">수정하기</button>
								<button type="button" class="comm-btn btn-delete" onclick="fnDeletePost('${view.comm_no}')">삭제하기</button>
							</c:if>
						</div>
					</div>

				</div>
			</div>

			<!-- 오른쪽 영역: 커뮤니티 인기글 + 비마이펫 추천 콘텐츠 위젯 -->
			<div class="right_sidebar_area">
			    <!-- 1. 커뮤니티 인기글 위젯 (상위 3개 출력) -->
			    <div class="sidebar_widget">
			        <h3>🔥 커뮤니티 인기글</h3>
			        <ul class="popular_list">
			            <c:forEach var="pop" items="${popularList}" begin="0" end="2" varStatus="status">
			                <li>
			                    <span class="rank">${status.count}</span>
			                    <a href="/community/commView?comm_no=${pop.comm_no}" class="pop_title" style="text-decoration: none; color: inherit;">
			                        ${pop.comm_title}
			                    </a>
			                    <span class="pop_cmt_cnt">댓글 ${not empty pop.reply_count ? pop.reply_count : 0}</span>
			                </li>
			            </c:forEach>
			        </ul>
			        <div class="widget_more_btn_box">
			            <button type="button" onclick="location.href='/community/commList'">인기글 더보기</button>
			        </div>
			    </div>
			
			    <!-- 2. 비마이펫 추천 콘텐츠 위젯 (상위 3개 출력) -->
			    <div class="sidebar_widget">
			        <h3>🐾 비마이펫 추천 콘텐츠</h3>
			        <div class="recommend_content_list">
			            <c:forEach var="rec" items="${recommendList}" begin="0" end="2">
			                <div class="rec_item" onclick="location.href='/community/commView?comm_no=${rec.comm_no}'" style="cursor: pointer;">
			                    <div class="rec_thumb">
			                        <c:if test="${not empty rec.comm_img}">
			                            <img src="${rec.comm_img}" alt="콘텐츠 썸네일" style="width: 100%; height: 100%; object-fit: cover; border-radius: 4px;">
			                        </c:if>
			                    </div>
			                    <div class="rec_info">
			                        <p class="rec_title">${rec.comm_title}</p>
			                        <span class="rec_author">${rec.comm_writer}</span>
			                    </div>
			                </div>
			            </c:forEach>
			        </div>
			    </div>
			</div>
			
		</div> <!-- upper_section_wrapper 끝 -->

		<!-- ==========================================
		   2. [하단 영역] 댓글 영역 (전체 너비 통으로 사용)
		   ================================---------- -->
		<div class="lower_comment_area">
			<div class="comment_section">
				<!-- 상단 타이틀 및 정렬 -->
				<div class="comment_header_row">
					<span class="comment_total_count">댓글 <b>${not empty reply_count ? reply_count : 0}</b></span>
					<select name="comment_sort" class="comment_sort_select">
						<option value="latest">최신순</option>
						<option value="popular">공감순</option>
					</select>
				</div>
				
				<!-- 댓글 입력 박스 영역 -->
				<div class="comment_write_box">
					<sec:authorize access="isAuthenticated()">
						<form name="comment_form" method="post" action="/commentWrite">
							<input type="hidden" name="comm_no" value="${view.comm_no}">
							<input type="hidden" name="comm_type" value="${view.comm_type}">
							<input type="hidden" name="cmt_writer" value="<sec:authentication property='principal.username'/>">
						  
							<div class="comment_input_container">
								<div class="writer_profile_img">🐾</div>
								<div class="comment_textarea_wrapper">
									<textarea name="cmt_content" rows="3" placeholder="${view.comm_writer}님의 글에 댓글을 남겨주세요. 겪어본 경험을 구체적으로 적어주면 큰 도움이 돼요."></textarea>
									<div class="comment_bottom_toolbar">
										<div class="comment_toolbar_left">
											<button type="button" class="photo_attach_btn">사진 0/4</button>
											<span class="text_length_counter">0/1000</span>
										</div>
										<div class="comment_toolbar_right">
											<input type="submit" value="댓글 등록">
										</div>
									</div>
								</div>
							</div>
						</form>
					</sec:authorize>
				
					<sec:authorize access="isAnonymous()">
						<div class="comment_logout_banner">
							<span class="logout_banner_text">로그인하면 바로 이 글에 댓글을 남길 수 있어요</span>
							<a href="/community/comment/write-auth?comm_no=${view.comm_no}" class="login_redirect_btn">로그인하고 댓글 남기기</a>
						</div>
					</sec:authorize>
				</div>
				
				<!-- 댓글 리스트 영역 -->
				<div class="comment_list">
				<c:if test="${not empty cmt}">
					<c:forEach var="comment" items="${cmt}"> 
						<c:if test="${empty comment.cmt_answer_no}">
							<div class="comment_item_block" id="comment-body-${comment.cmt_no}">
								<!-- 댓글 작성자 정보 로우 -->
								<div class="comment_item_header">
									<div class="comment_item_profile">
										<div class="writer_profile_img">🐾</div>
										<div class="comment_writer_meta">
											<span class="comment_writer_name">${comment.cmt_writer}</span>
											<span class="comment_date"><fmt:formatDate value="${comment.cmt_date}" pattern="yyyy.MM.dd" /></span>
										</div>
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
								
								<!-- 댓글 본문 -->
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

								<!-- 댓글 하단 액션 (도움돼요 / 답글) -->
								<div class="comment_action_row">
								    <c:set var="replyCount" value="0" />
								    <c:forEach var="rItem" items="${cmt}">
								        <c:if test="${rItem.cmt_answer_no == comment.cmt_no}">
								            <c:set var="replyCount" value="${replyCount + 1}" />
								        </c:if>
								    </c:forEach>
								
								    <!-- 비로그인 사용자 -->
								    <sec:authorize access="isAnonymous()">
								        <button type="button" class="action_btn" onclick="alert('로그인 후 이용 가능합니다.'); location.href='/loginForm';">
								            👍 도움돼요 <span id="cmt-count-good-${comment.cmt_no}">${not empty comment.cmt_good ? comment.cmt_good : 0}</span>
								        </button>
								        <button type="button" class="action_btn" onclick="location.href='/community/comment/reply-auth?comm_no=${view.comm_no}&cmt_no=${comment.cmt_no}'">
								            💬 답글 ${replyCount}
								        </button>
								    </sec:authorize>
								
								    <!-- 로그인 사용자 -->
								    <sec:authorize access="isAuthenticated()">
								        <button type="button" class="action_btn" onclick="fnCommentRecommend('${comment.cmt_no}')">
								            👍 도움돼요 <span id="cmt-count-good-${comment.cmt_no}">${not empty comment.cmt_good ? comment.cmt_good : 0}</span>
								        </button>
								        <button type="button" class="action_btn" onclick="showReplyForm(this, '${comment.cmt_no}')">
								            💬 답글 ${replyCount}
								        </button>
								    </sec:authorize>
								</div>

							<!-- 답글 리스트 구조 -->
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
												<div class="comment_item_header">
													<div class="comment_item_profile">
														<div class="writer_profile_img">🐾</div>
														<div class="comment_writer_meta">
															<span class="comment_writer_name">${reply.cmt_writer}</span>
															<span class="comment_date"><fmt:formatDate value="${reply.cmt_date}" pattern="yyyy.MM.dd" /></span>
														</div>
													</div>
													<sec:authorize access="isAuthenticated()">
														<sec:authentication property="principal.username" var="loginId" />
														<c:if test="${loginId eq reply.cmt_writer}">
															<div class="comment_btn_box">
																<button type="button" onclick="showEditForm(this, '${reply.cmt_no}')">수정</button>
																<button type="button" onclick="location.href='/comment/delete?cmt_no=${reply.cmt_no}'">삭제</button>
															</div>
														</c:if>
													</sec:authorize>
												</div>
												<div class="comment_content" id="comment-content-${reply.cmt_no}">					
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
			</div>
		</div>

	</div> <!-- main_container 끝 -->

<%@ include file="../footer.jsp" %>
</body>
<script>
function showReplyForm(button, cmt_no) {
    let commentBody = button.closest('.comment_item_block');
    let existingForm = document.getElementById("reply-form-" + cmt_no);
    if (existingForm) { existingForm.remove(); return; }
    
    var commNo = "${view.comm_no}";
    var commType = "${view.comm_type}";
    
    var replyHtml = '<div id="reply-form-' + cmt_no + '" class="comment_write_box" style="margin-top: 15px; margin-left: 46px;">' +
        '  <form action="/community/replyWrite" method="post">' +
        '    <input type="hidden" name="cmt_answer_no" value="' + cmt_no + '">' +
        '    <input type="hidden" name="comm_no" value="' + commNo + '">' +
        '    <input type="hidden" name="comm_type" value="' + commType + '">' +
        '    <div class="comment_input_container">' +
        '      <div class="writer_profile_img">🐾</div>' +
        '      <div class="comment_textarea_wrapper">' +
        '        <textarea name="cmt_content" rows="2" placeholder="답글을 남겨주세요"></textarea>' +
        '        <div class="comment_bottom_toolbar" style="display: flex; justify-content: flex-end;">' +
        '          <button type="submit" style="padding: 6px 14px; background-color: #ff6f61; color: #fff; border: none; border-radius: 16px; cursor: pointer; font-weight: bold; font-size: 12px;">등록</button>' +
        '        </div>' +
        '      </div>' +
        '    </div>' +
        '  </form>' +
        '</div>';
        
    commentBody.insertAdjacentHTML('afterend', replyHtml);
}

function showEditForm(button, cmt_no) {
    let contentDiv = document.getElementById("comment-content-" + cmt_no);
    let existingForm = document.getElementById("edit-form-" + cmt_no);
    if (existingForm) { existingForm.remove(); contentDiv.style.display = "block"; return; }
    let originalText = contentDiv.textContent.trim();
    contentDiv.style.display = "none";
    var commNo = "${view.comm_no}";
    var csrfToken = "${_csrf.token}"; 
    var csrfHeader = "${_csrf.headerName}";
    var editHtml = '<div id="edit-form-' + cmt_no + '" class="edit-input-box" style="margin-top: 10px; margin-left: 46px;">' +
        '  <form action="/comment/update" method="post">' +
        '    <input type="hidden" name="cmt_no" value="' + cmt_no + '">' +
        '    <input type="hidden" name="comm_no" value="' + commNo + '">' +
        '    <input type="hidden" name="' + csrfHeader + '" value="' + csrfToken + '">' +
        '    <textarea name="cmt_content" rows="2" style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; box-sizing: border-box; outline:none; font-size:13px;">' + originalText + '</textarea>' +
        '    <div style="display: flex; gap: 6px; margin-top: 6px; justify-content: flex-end;">' +
        '      <button type="submit" style="padding: 4px 12px; background: #ff6f61; color: #fff; border:none; border-radius: 4px; font-weight:bold; cursor:pointer; font-size:12px;">수정 완료</button>' +
        '      <button type="button" onclick="cancelEdit(\'' + cmt_no + '\')" style="padding: 4px 12px; background: #f1f3f5; border:none; border-radius: 4px; cursor:pointer; font-size:12px;">취소</button>' +
        '    </div>' +
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
    var csrfToken = $("meta[name='_csrf']").attr("content");
    var csrfHeader = $("meta[name='_csrf_header']").attr("content");
    
    let ajaxConfig = {
        url: "/community/recommend",
        type: "POST",
        data: { comm_no: commNo, type: type },
        success: function(response) {
            if (response === "LOGIN_REQUIRED") { 
                alert("로그인 후 이용 가능합니다."); 
                location.href = "/loginForm"; 
                return; 
            }
            let $countSpan = (type === "GOOD") ? $("#count-good") : $("#count-well");
            let currentCount = parseInt($countSpan.text()) || 0;
            
            if (response === "SUCCESS") { 
                $countSpan.text(currentCount + 1); 
            } else if (response === "CANCELED") { 
                $countSpan.text(Math.max(0, currentCount - 1)); 
            } else if (response === "ALREADY_VOTED") {
                alert("이미 평가를 완료한 게시글입니다.");
            }
        },
        error: function(xhr, status, error) { 
            console.error("AJAX Error: ", error); 
            alert("오류가 발생했습니다. (상태 코드: " + xhr.status + ")"); 
        }
    };
    
    if (csrfHeader && csrfToken) { 
        ajaxConfig.beforeSend = function(xhr) { 
            xhr.setRequestHeader(csrfHeader, csrfToken); 
        }; 
    }
    $.ajax(ajaxConfig);
}

function fnCommentRecommend(cmt_no) {
    var csrfToken = "${_csrf != null ? _csrf.token : ''}";
    var csrfHeader = "${_csrf != null && not empty _csrf.headerName ? _csrf.headerName : 'X-CSRF-TOKEN'}";
    
    let ajaxConfig = {
        url: "/comment/recommend",
        type: "POST",
        data: { cmt_no: cmt_no },
        success: function(response) {
            if (response === "LOGIN_REQUIRED") { 
                alert("로그인 후 이용 가능합니다."); 
                location.href = "/loginForm"; 
                return; 
            }
            let $countSpan = $("#cmt-count-good-" + cmt_no);
            let currentCount = parseInt($countSpan.text()) || 0;
            
            if (response === "SUCCESS") { 
                $countSpan.text(currentCount + 1); 
            } else if (response === "CANCELED") { 
                $countSpan.text(Math.max(0, currentCount - 1)); 
            } else if (response === "ALREADY_VOTED") {
                alert("이미 도움돼요를 누른 댓글입니다.");
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
    if (confirm("정말 이 게시글을 삭제하시겠습니까?")) { location.href = '/communityList/delete?comm_no=' + comm_no; }
}

function fnBookmark() {
    let commNo = "${view.comm_no}";
    $.ajax({
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
                $btn.addClass("active"); 
                $text.text("⭐ 북마크 취소"); 
            } else if (response === "DELETED") { 
                alert("북마크가 해제되었습니다."); 
                $btn.removeClass("active"); 
                $text.text("⭐ 북마크"); 
            }
        },
        error: function(xhr, status, error) { 
            console.error("AJAX Error: " + error); 
            alert("오류가 발생했습니다. (상태 코드: " + xhr.status + ")"); 
        }
    });
}
</script>
</html>