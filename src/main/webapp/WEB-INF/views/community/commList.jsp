<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 목록</title>
<link rel="stylesheet" href="/css/community/commList.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Square+Round:wght@400;700;800&display=swap" rel="stylesheet">
</head>

<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>

   <!-- 전체를 감싸는 메인 와이드 컨테이너 -->
	<div class="community_wrap">
		<!-- 상단 타이틀 및 캐릭터 영역 (좌우 2분할) -->
		<div class="community_topimage">
		    <!-- 왼쪽: 타이틀 및 설명 영역 -->
		    <div class="image_text_area">
		        <span class="image_category_sub">커뮤니티</span>
		        <div class="image_title">궁금한 거 뭐든 물어봐</div>
		        <div class="image_desc">반려동물과 관련된 모든 궁금증을 자유롭게 나누어보세요!</div>
		    </div>
		
		    <!-- 오른쪽: 말풍선 버튼 + 고양이 이미지 묶음 (나란히 배치) -->
		    <div class="top_right_area">
		        <div class="speech_bubble_wrapper">
		            <a href="/commWriteForm" class="speech_bubble_btn">
		                <span class="bubble_txt_main">글쓰기</span>
		                <span class="bubble_txt_sub">여기를 눌러 질문하기!</span>
		            </a>
		        </div>
		        <div class="image_box">
		            <img src="/images/community/event_on.png" alt="커뮤니티 대표 이미지">
		        </div>
		    </div>
		</div>
			
		<!-- 1. 상단 2분할 영역 (커뮤니티 인기글 / 좋은 정보) -->
		<div class="top_dual_section">
		    
		    <!-- 왼쪽 박스: 커뮤니티 인기글 -->
		    <div class="box_item">
		        <div class="box_header">
		            <div class="widget_title">커뮤니티 인기글</div>
		            <div class="info_desc">좋은 글에 '도움돼요'를 꾸욱 눌러주세요</div>
		        </div>
		        
		        <div class="good_info_list">
		            <c:forEach var="pop" items="${popularList}" varStatus="status">
		                <div class="good_info_item">
		                    <div class="item_top popular_item_top">
		                        <div class="popular_title_area">
		                            <!-- 순위 번호 -->
		                            <span class="rank_num popular_rank">${status.count}</span>
		                            <!-- 게시글 제목 -->
		                            <a href="/community/commView?comm_no=${pop.comm_no}" class="info_title popular_title">${pop.comm_title}</a>
		                        </div>
		                        <!-- 오른쪽 끝에 정렬될 comm_type -->
		                        <span class="badge_tip right_badge popular_badge">${pop.comm_type}</span>
		                    </div>
		                    <div class="item_sub">
		                        <span class="writer">${pop.comm_writer}</span>
		                    </div>
		                </div>
		            </c:forEach>
		        </div>
		    </div>
		
		    <!-- 오른쪽 박스: 좋은 정보 (포인트 안내 및 목록) -->
		    <div class="box_item info_box">
		        <div class="box_header info_header">
		            <div class="widget_title">좋은 정보 글·답변에는 포인트</div>
		            <div class="info_desc">좋은 정보 혹은 답변을 남기면 커뮤니티 매니저가 선정해 포인트를 드려요.</div>
		        </div>
		        
		        <div class="good_info_list">
		            <c:forEach var="rec" items="${recommendList}" begin="0" end="9">
		                <div class="good_info_item">
		                    <div class="item_top">
		                        <c:if test="${rec.comm_type eq 'QNA'}">
		                            <span class="badge_tip">답변</span>
		                        </c:if>
		                        <a href="/community/commView?comm_no=${rec.comm_no}" class="info_title">${rec.comm_title}</a>
		                    </div>
		                    <div class="item_sub">
		                        <span class="writer">${rec.comm_writer}</span> 
		                        <span class="point">👍 ${rec.comm_good}</span>
		                    </div>
		                </div>
		            </c:forEach>
		        </div>
		    </div>
		</div>
        
        <hr class="section_divider">
              
        <!-- 3. 대분류 탭 (전체, Q&A, 라운지, 콘텐츠) -->
        <div class="category_tabs">
            <a href="/community/commList" class="${empty param.comm_type ? 'active' : ''}">전체</a>
            <a href="/community/commList?comm_type=QNA" class="${param.comm_type eq 'QNA' ? 'active' : ''}">Q&amp;A</a>
            <a href="/community/commList?comm_type=라운지" class="${param.comm_type eq '라운지' ? 'active' : ''}">라운지</a>
            <a href="/community/commList?comm_type=콘텐츠" class="${param.comm_type eq '콘텐츠' ? 'active' : ''}">콘텐츠</a>
        </div>

        <!-- 4. 서치 바 영역 (검색창과 자동완성 분리 구조) -->
        <div class="search_box_wrapper">
            <form name="community_search" method="get" action="/community/search" class="search_form">
                <input type="text" name="keyword" id="keyword" autocomplete="off" placeholder="검색어를 입력하세요">
                <input type="submit" value="검색">
            </form>
            <div id="suggestions"></div>
        </div>

        <!-- 5. 서브 필터 및 전체 개수 한 줄 정렬 영역 -->
        <div class="filter_count_row">
            <div class="sub_filter">
                <c:if test="${empty param.comm_type or param.comm_type eq 'QNA' or param.comm_type eq '라운지'}">
                    <select name="sort" onchange="location.href='/community/commList?comm_type=${empty param.comm_type ? '' : param.comm_type}&amp;sort='+this.value+'&amp;comm_pet_type=${param.comm_pet_type}'">
                        <option value="latest" ${param.sort eq 'latest' ? 'selected' : ''}>최신순</option>
                        <option value="popular" ${param.sort eq 'popular' ? 'selected' : ''}>인기순</option>
                    </select>
                    <a href="/community/commList?comm_type=${empty param.comm_type ? '' : param.comm_type}&amp;comm_pet_type=" class="${empty param.comm_pet_type ? 'active' : ''}">전체</a>
                    <a href="/community/commList?comm_type=${empty param.comm_type ? '' : param.comm_type}&amp;comm_pet_type=강아지" class="${param.comm_pet_type eq '강아지' ? 'active' : ''}">강아지</a>
                    <a href="/community/commList?comm_type=${empty param.comm_type ? '' : param.comm_type}&amp;comm_pet_type=고양이" class="${param.comm_pet_type eq '고양이' ? 'active' : ''}">고양이</a>
                    <a href="/community/commList?comm_type=${empty param.comm_type ? '' : param.comm_type}&amp;comm_pet_type=소동물" class="${param.comm_pet_type eq '소동물' ? 'active' : ''}">소동물</a>
                    <a href="/community/commList?comm_type=${empty param.comm_type ? '' : param.comm_type}&amp;comm_pet_type=기타" class="${param.comm_pet_type eq '기타' ? 'active' : ''}">기타</a>
                </c:if>
                
                <c:if test="${param.comm_type eq '콘텐츠'}">
                    <a href="/community/commList?comm_type=콘텐츠&amp;comm_category=" class="${empty param.comm_category ? 'active' : ''}">전체</a>
                    <a href="/community/commList?comm_type=콘텐츠&amp;comm_category=강아지 연구소" class="${param.comm_category eq '강아지 연구소' ? 'active' : ''}">강아지 연구소</a>
                    <a href="/community/commList?comm_type=콘텐츠&amp;comm_category=고양이 연구소" class="${param.comm_category eq '고양이 연구소' ? 'active' : ''}">고양이 연구소</a>
                    <a href="/community/commList?comm_type=콘텐츠&amp;comm_category=제품 연구소" class="${param.comm_category eq '제품 연구소' ? 'active' : ''}">제품연구소</a>
                    <a href="/community/commList?comm_type=콘텐츠&amp;comm_category=제보" class="${param.comm_category eq '제보' ? 'active' : ''}">제보</a>
                    <a href="/community/commList?comm_type=콘텐츠&amp;comm_category=뉴스/브랜드" class="${param.comm_category eq '뉴스/브랜드' ? 'active' : ''}">뉴스/브랜드</a>
                </c:if>
            </div>
            <div class="total_count">전체 ${totalCount}개</div>
        </div>

       <!-- 6. 게시글 카드 목록 영역 -->
        <div class="board_card_list">
            <c:forEach var="board" items="${list}">
                <div class="board_card_item">
    
		    <!-- ⭐️ 멍냥 PICK이 'Y'일 때 우측 상단 리본으로 표시될 뱃지 -->
		    <c:if test="${board.comm_adpick eq 'Y'}">
		        <span class="badge pick">멍냥 PICK</span>
		    </c:if>
		
		    <!-- 좌측 텍스트 및 정보 영역 -->
		    <div class="card_text_area">
		        <div class="card_badges">
		            <c:choose>
		                <c:when test="${board.comm_type == '콘텐츠'}">
		                    <span class="badge">${board.comm_detail}</span>
		                </c:when>
		                <c:otherwise>
		                    <span class="badge">${board.comm_type == 'QNA' ? 'Q&amp;A' : board.comm_type}</span>
		                    <c:if test="${not empty board.comm_pet_type}">
		                        <span class="badge">${board.comm_pet_type}</span>
		                    </c:if>
		                    <c:if test="${not empty board.comm_breed and board.comm_breed ne '견종 입력'}">
								<span class="badge">${board.comm_breed}</span>
							</c:if>
		                </c:otherwise>
		            </c:choose>
		        </div>
		
		        <h4 class="card_title">
		            <a href="/community/commView?comm_no=${board.comm_no}">${board.comm_title}</a>
		        </h4>
		
		        <!-- ⭐️ 콘텐츠가 아닐 때만 본문 미리보기 노출 -->
                <c:if test="${board.comm_type ne '콘텐츠'}">
                    <p class="preview_content">${board.comm_content}</p>
                </c:if>
		
		        <div class="card_meta">
		            <span>댓글 ${board.reply_count}</span>
		            <span class="dot">·</span>
		            <span>${board.comm_writer}</span>
		            <c:forEach var="tag" items="${fn:split(board.comm_tag, ',')}">
		                <c:if test="${not empty tag}">
		                    <span class="tag_item">#${tag}</span>
		                </c:if>
		            </c:forEach>
		        </div>
		    </div>
		
		    <!-- 우측 썸네일 이미지 영역 -->
		    <c:if test="${not empty board.comm_img}">
		        <div class="card_image_area">
		            <img src="${board.comm_img}" alt="썸네일">
		        </div>
		    </c:if>
		</div>
            </c:forEach>
        </div>
        
        <!-- 페이징 네비게이션 -->
        <div class="pagination">
            <c:if test="${startPage > 1}">
                <a href="/community/commList?comm_type=${param.comm_type}&comm_pet_type=${param.comm_pet_type}&comm_category=${param.comm_category}&sort=${param.sort}&page=${startPage - 1}">PREV</a>
            </c:if>
            
            <c:forEach var="i" begin="${startPage}" end="${endPage}">
                <a href="/community/commList?comm_type=${param.comm_type}&comm_pet_type=${param.comm_pet_type}&comm_category=${param.comm_category}&sort=${param.sort}&page=${i}" 
                   class="${pageNum eq i ? 'active' : ''}">${i}</a>
            </c:forEach>
            
            <c:if test="${endPage < totalPages}">
                <a href="/community/commList?comm_type=${param.comm_type}&comm_pet_type=${param.comm_pet_type}&comm_category=${param.comm_category}&sort=${param.sort}&page=${endPage + 1}">NEXT</a>
            </c:if>
        </div>

    </div>
<button id="scrollTopBtn" title="맨 위로 가기">⬆</button>
<%@ include file="../footer.jsp" %>

</body>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $("#keyword").on("keyup", function(){
        let q = $(this).val();
        if(q.length < 1){
            $("#suggestions").empty().hide();
            return;
        }
        $.ajax({
            url: "/community/autocomplete",
            data: { keyword: q },
            success: function(list){
                if(list.length < 1){
                    $("#suggestions").empty().hide();
                    return;
                }
                let html = "";
                list.forEach(function(item){
                    html += "<div class='item'>" + item.highlight + "</div>";
                });
                $("#suggestions").html(html).show();
            }
        });
    });
    
    $(document).on("click", ".item", function(){
        $("#keyword").val($(this).text());
        $("#suggestions").empty().hide();
    });
    
 	// 1. 사용자가 스크롤을 움직일 때마다 현재 스크롤 위치를 세션에 저장
    window.addEventListener('scroll', function() {
        if (window.scrollY > 0) {
            sessionStorage.setItem('commScrollPos', window.scrollY);
        }
    });

    // 2. 페이지가 다시 로드(렌더링)되었을 때 저장해 둔 스크롤 위치가 있다면 그곳으로 이동
    window.addEventListener('load', function() {
        const savedPos = sessionStorage.getItem('commScrollPos');
        if (savedPos) {
            window.scrollTo(0, parseInt(savedPos));
            // 한 번 복원한 뒤에는 저장소 비우기 (필요에 따라 유지해도 무방)
            sessionStorage.removeItem('commScrollPos');
        }
    });

    // 기존 자동완성 관련 스크립트...
    $("#keyword").on("keyup", function(){
        // ... (생략)
    });
    
    $(document).on("click", ".item", function(){
        $("#keyword").val($(this).text());
        $("#suggestions").empty().hide();
    });
    
 	// 스크롤 위치에 따라 버튼 노출 여부 결정
    window.addEventListener('scroll', function() {
        const scrollTopBtn = document.getElementById('scrollTopBtn');
        if (window.scrollY > 200) {
            scrollTopBtn.style.display = 'block'; // 200px 이상 내려가면 보임
        } else {
            scrollTopBtn.style.display = 'none';  // 맨 위면 숨김
        }
    });

    // 버튼 클릭 시 맨 위로 부드럽게 이동
    document.getElementById('scrollTopBtn').addEventListener('click', function() {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });
</script>
</html>