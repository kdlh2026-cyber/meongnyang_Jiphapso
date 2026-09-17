<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 게시글 서치 관리</title>
<link rel="stylesheet" href="/css/community/communityUpdate.css">
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>

<div class="admin-wrap">
    <!-- 상단 제목 및 바로가기 링크 영역 -->
     <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
         <h3 style="margin: 0; border-left: 4px solid #ff6f61; padding-left: 10px;">게시글 관리</h3>
         <a href="/admin/communityManage" class="btn-manage-link">대시보드 / 현황 보기</a>
     </div>

     <!-- 1. 메인 카테고리 탭 그룹 -->
     <div class="tab-group">
         <a href="/admin/communityUpdate" class="admin-tab ${empty param.comm_type ? 'active' : ''}">전체</a>
         <a href="/admin/communityUpdate?comm_type=QNA" class="admin-tab ${param.comm_type eq 'QNA' ? 'active' : ''}">Q&amp;A</a>
         <a href="/admin/communityUpdate?comm_type=라운지" class="admin-tab ${param.comm_type eq '라운지' ? 'active' : ''}">라운지</a>
         <a href="/admin/communityUpdate?comm_type=콘텐츠" class="admin-tab ${param.comm_type eq '콘텐츠' ? 'active' : ''}">콘텐츠</a>
     </div>
     
     <!-- 2. 서브 필터 및 검색 바 영역 -->
     <div class="filter-search-bar">
         <!-- Q&A 및 라운지용 반려동물 필터 -->
         <c:if test="${empty param.comm_type or param.comm_type eq 'QNA' or param.comm_type eq '라운지'}">
             <div class="sub_filter">
                 <a href="/admin/communityUpdate?comm_type=${param.comm_type}&amp;comm_pet_type=" class="${empty param.comm_pet_type ? 'active' : ''}">전체</a>
                 <a href="/admin/communityUpdate?comm_type=${param.comm_type}&amp;comm_pet_type=강아지" class="${param.comm_pet_type eq '강아지' ? 'active' : ''}">강아지</a>
                 <a href="/admin/communityUpdate?comm_type=${param.comm_type}&amp;comm_pet_type=고양이" class="${param.comm_pet_type eq '고양이' ? 'active' : ''}">고양이</a>
                 <a href="/admin/communityUpdate?comm_type=${param.comm_type}&amp;comm_pet_type=소동물" class="${param.comm_pet_type eq '소동물' ? 'active' : ''}">소동물</a>
                 <a href="/admin/communityUpdate?comm_type=${param.comm_type}&amp;comm_pet_type=기타" class="${param.comm_pet_type eq '기타' ? 'active' : ''}">기타</a>
             </div>
         </c:if>
         
         <!-- 콘텐츠 카테고리용 서브 필터 -->
         <c:if test="${param.comm_type eq '콘텐츠'}">
             <div class="sub_filter">
                 <a href="/admin/communityUpdate?comm_type=콘텐츠&amp;comm_category=" class="${empty param.comm_category ? 'active' : ''}">전체</a>
                 <a href="/admin/communityUpdate?comm_type=콘텐츠&amp;comm_category=강아지연구소" class="${param.comm_category eq '강아지연구소' ? 'active' : ''}">강아지연구소</a>
                 <a href="/admin/communityUpdate?comm_type=콘텐츠&amp;comm_category=고양이연구소" class="${param.comm_category eq '고양이연구소' ? 'active' : ''}">고양이연구소</a>
                 <a href="/admin/communityUpdate?comm_type=콘텐츠&amp;comm_category=제품연구소" class="${param.comm_category eq '제품연구소' ? 'active' : ''}">제품연구소</a>
                 <a href="/admin/communityUpdate?comm_type=콘텐츠&amp;comm_category=제보" class="${param.comm_category eq '제보' ? 'active' : ''}">제보</a>
                 <a href="/admin/communityUpdate?comm_type=콘텐츠&amp;comm_category=뉴스/브랜드" class="${param.comm_category eq '뉴스/브랜드' ? 'active' : ''}">뉴스/브랜드</a>
             </div>
         </c:if>

         <!-- 검색 및 자동완성 폼 (검색 결과 페이지이므로 action은 searchList 유지) -->
         <form name="community_search" method="get" action="/admin/community/searchList" class="search-form" style="display: flex; gap: 5px; align-items: center;">
             <!-- 기존 필터 상태 유지용 숨은값 -->
             <input type="hidden" name="comm_type" value="${param.comm_type}">
             <input type="hidden" name="comm_pet_type" value="${param.comm_pet_type}">
             <input type="hidden" name="comm_category" value="${param.comm_category}">
             <input type="hidden" name="sort" value="${param.sort}">
             
             <!-- 검색 필터 (제목, 작성자, 카테고리, 통합) -->
             <select name="searchType" style="padding: 6px 8px; border-radius: 4px; border: 1px solid #ddd; font-size: 13px;">
                 <option value="" ${empty param.searchType ? 'selected' : ''}>통합검색</option>
                 <option value="title" ${param.searchType eq 'title' ? 'selected' : ''}>제목</option>
                 <option value="writer" ${param.searchType eq 'writer' ? 'selected' : ''}>작성자</option>
                 <option value="category" ${param.searchType eq 'category' ? 'selected' : ''}>카테고리</option>
             </select>
             
             <input type="text" name="keyword" id="keyword" value="${param.keyword}" placeholder="검색어 입력" autocomplete="off">
             <input type="submit" value="검색">
             <div id="suggestions"></div>
         </form>
     </div>

     <!-- 정렬 필터 및 전체 개수 영역 -->
    <div class="filter_area" style="display: flex; justify-content: space-between; align-items: center; margin: 20px 0;">
        <div>전체 ${totalCount}개</div>
        
        <!-- 최신순 / 인기순 셀렉트박스 -->
        <div>
            <select name="sort" onchange="changeSort(this.value)" style="padding: 6px 12px; border-radius: 4px; border: 1px solid #ddd;">
                <option value="latest" ${param.sort eq 'latest' or empty param.sort ? 'selected' : ''}>최신순</option>
                <option value="popular" ${param.sort eq 'popular' ? 'selected' : ''}>인기순</option>
            </select>
        </div>
    </div>
    
     <div>
          <table>
             <thead>
                 <tr>
                     <th style="width: 15%;">작성일</th>
                     <th style="width: 10%;">카테고리</th>
                     <th style="width: 45%;">게시글 제목</th>
                     <th style="width: 10%;">작성자</th>
                     <th style="width: 25%;">관리</th>
                 </tr>
             </thead>
             <tbody>
                 <!-- 데이터가 없을 때 -->
                 <c:if test="${empty list}">
                     <tr>
                         <td colspan="5" style="padding: 40px; color: #999;">검색된 게시글이 없습니다.</td>
                     </tr>
                 </c:if>

                 <!-- 데이터 반복 출력 -->
                 <c:forEach var="item" items="${list}">
                     <tr>
                         <td>
                             <fmt:formatDate value="${item.comm_date}" pattern="yyyy-MM-dd" />
                         </td>
                         <td>
                            <c:choose>
                                <%-- comm_type이 '콘텐츠'일 때는 comm_category 출력 --%>
                                <c:when test="${item.comm_type eq '콘텐츠'}">
                                    ${item.comm_category}
                                </c:when>
                                <%-- 그 외(Q&A, 라운지 등)일 때는 comm_pet_type 출력 --%>
                                <c:otherwise>
                                    ${item.comm_pet_type}
                                </c:otherwise>
                            </c:choose>
                        </td>
                         <td style="text-align: left; padding-left: 20px;">
                            <c:if test="${item.comm_adpick eq 'Y'}">
                                <span style="background: #ff5a1f; color: white; padding: 2px 6px; border-radius: 4px; font-size: 11px; font-weight: bold; margin-right: 5px;">PICK</span>
                            </c:if>
                             <a href="/community/commView?comm_no=${item.comm_no}" target="_blank">${item.comm_title}</a>
                         </td>
                         <td>${item.comm_writer}</td>
                         <td>
                             <!-- 삭제 버튼 -->
                             <button type="button" class="btn-delete" onclick="if(confirm('정말 이 게시글을 삭제하시겠습니까?')) { location.href='/admin/community/delete?comm_no=${item.comm_no}&comm_type=${param.comm_type}&page=${pageNum}'; }">삭제</button>
                             
                             <!-- PICK! 버튼 -->
                             <button type="button" class="btn-pick ${item.comm_adpick eq 'Y' ? 'active' : ''}" onclick="location.href='/admin/community/pickToggle?comm_no=${item.comm_no}&comm_type=${param.comm_type}&page=${pageNum}'">
                                 <c:choose>
                                     <c:when test="${item.comm_adpick eq 'Y'}">PICK 취소</c:when>
                                     <c:otherwise>PICK!</c:otherwise>
                                 </c:choose>
                             </button>
                         </td>
                     </tr>
                 </c:forEach>
             </tbody>
         </table>
     </div>
     
     <!-- 3. 페이징 네비게이션 (검색 유지 블록형 페이징 적용) -->
     <c:if test="${not empty totalPages and totalPages > 1}">
         <div class="pagination">
             <%-- 이전 블록 이동 버튼 --%>
             <c:if test="${prev}">
                 <a href="/admin/community/searchList?comm_type=${param.comm_type}&comm_pet_type=${param.comm_pet_type}&comm_category=${param.comm_category}&searchType=${param.searchType}&keyword=${param.keyword}&sort=${param.sort}&page=${startPage - 1}">PREV</a>
             </c:if>
             
             <%-- 10개 단위 번호 반복 출력 --%>
             <c:forEach var="i" begin="${startPage}" end="${endPage}">
                 <a href="/admin/community/searchList?comm_type=${param.comm_type}&comm_pet_type=${param.comm_pet_type}&comm_category=${param.comm_category}&searchType=${param.searchType}&keyword=${param.keyword}&sort=${param.sort}&page=${i}" 
                    class="${pageNum eq i ? 'active' : ''}">${i}</a>
             </c:forEach>
             
             <%-- 다음 블록 이동 버튼 --%>
             <c:if test="${next}">
                 <a href="/admin/community/searchList?comm_type=${param.comm_type}&comm_pet_type=${param.comm_pet_type}&comm_category=${param.comm_category}&searchType=${param.searchType}&keyword=${param.keyword}&sort=${param.sort}&page=${endPage + 1}">NEXT</a>
             </c:if>
         </div>
     </c:if>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    // 검색어 자동완성 스크립트 적용
    $("#keyword").on("keyup", function(){
        let q = $(this).val();
    
        if(q.length < 1){
            $("#suggestions").empty();
            return;
        }
    
        $.ajax({
            url: "/community/autocomplete",
            data: { keyword: q },
            success: function(list){
                let html = "";
                list.forEach(function(item){
                    html += "<div class='item'>" + item.highlight + "</div>";
                });
                $("#suggestions").html(html);
            },
            error: function(){
                console.log("autocomplete error");
            }
        });
    });
    
    // 추천어 클릭 시 검색창에 채우기
    $(document).on("click", "#suggestions .item", function(){
        $("#keyword").val($(this).text());
        $("#suggestions").empty();
    });
    
    // 바깥 영역 클릭 시 자동완성 닫기
    $(document).on("click", function(e){
        if(!$(e.target).closest('.search-form').length){
            $("#suggestions").empty();
        }
    });
    
    // 정렬 셀렉트박스 변경 시 현재 검색어와 검색 조건들을 유지한 채 페이지 이동
    function changeSort(sortValue) {
        const urlParams = new URLSearchParams(window.location.search);
        urlParams.set('sort', sortValue);
        urlParams.set('page', '1'); // 정렬 변경 시 1페이지로 초기화
        window.location.href = window.location.pathname + '?' + urlParams.toString();
    }
</script>
</body>
</html>