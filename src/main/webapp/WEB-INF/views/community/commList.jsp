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
</head>

<body>
<%@ include file="../hamburger_menu.jsp" %>

    <!-- 전체를 감싸는 메인 와이드 컨테이너 -->
    <div class="community_wrap">

        <!-- 1. 상단 2분할 영역 (커뮤니티 인기글 / 좋은 정보) -->
        <div class="top_dual_section">
            
            <!-- 왼쪽 박스: 커뮤니티 인기글 -->
            <div class="box_item">
                <div class="widget_title">커뮤니티 인기글</div>
                <ul class="top_popular_list">
                    <li>
                        <span class="rank_num">1</span>
                        <a href="#" class="pop_link">[경기도 고양] 고양이 호흡좀 봐주세요ㅠ</a>
                    </li>
                    <li>
                        <span class="rank_num">2</span>
                        <a href="#" class="pop_link">답변 좀요ㅠㅠ (고양이 🐱 🐈 🐈‍⬛ 구조)</a>
                    </li>
                    <li>
                        <span class="rank_num">3</span>
                        <a href="#" class="pop_link">리리야 우리집에서 지내서 고마워!</a>
                    </li>
                </ul>
            </div>

            <!-- 오른쪽 박스: 좋은 정보 (포인트 안내 및 목록) -->
            <div class="box_item info_box">
                <div class="info_header">
                    <div class="widget_title">좋은 정보 글·답변에는 포인트</div>
                    <div class="info_desc">좋은 정보 혹은 답변을 남기면 커뮤니티 매니저가 선정해 포인트를 드려요.</div>
                </div>
                
                <div class="good_info_list">
                    <div class="good_info_item">
                        <div class="item_top">
                            <span class="badge_tip">답변</span>
                            <a href="#" class="info_title">답변 좀요ㅠㅠ (고양이 🐱 🐈 🐈‍⬛ 구조)</a>
                        </div>
                        <div class="item_sub">
                            <span class="writer">주주테리어</span> <span class="point">+1,000P</span>
                        </div>
                    </div>
                    
                    <div class="good_info_item">
                        <div class="item_top">
                            <a href="#" class="info_title">새로운 녀석</a>
                        </div>
                        <div class="item_sub">
                            <span class="writer">메밀,보리집사</span> <span class="point">+500P</span>
                        </div>
                    </div>

                    <div class="good_info_item">
                        <div class="item_top">
                            <span class="badge_tip">답변</span>
                            <a href="#" class="info_title">고양이 합사</a>
                        </div>
                        <div class="item_sub">
                            <span class="writer">까만고양이</span> <span class="point">+500P</span>
                        </div>
                    </div>
                </div>
            </div>

        </div>

		<!-- 안내 문구와 글쓰기 버튼이 나란히 들어가는 가로 배너 박스 -->
        <div class="write_banner_box">
            <div class="banner_text_area">
                <div class="banner_title">궁금한 게 있나요?</div>
                <div class="banner_desc">Q&amp;A로 물어보면 평균 24시간 이내에 답변이 달려요.</div>
            </div>
            <a href="/commWriteForm" class="btn_write_box">글쓰기</a>
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
</script>
</html>