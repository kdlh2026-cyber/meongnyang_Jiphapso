<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 게시글 관리</title>
<style>
  /* 기본 스타일 */
  body { margin: 0; font-family: "Noto Sans KR", sans-serif; background: #f9f9f9; color: #333; }
  .admin-wrap { max-width: 1000px; margin: 40px auto; padding: 20px; background: #fff; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
  h3 { font-size: 24px; margin-bottom: 20px; font-weight: bold; }
  
  /* 탭 스타일 */
  .tab-group { display: flex; gap: 10px; margin-bottom: 20px; }
  .tab-group .admin-tab { 
      padding: 8px 16px; font-size: 14px; font-weight: bold; cursor: pointer; 
      border: 1px solid #ddd; background: #fff; border-radius: 4px; text-decoration: none; color: #333; 
  }
  .tab-group .admin-tab.active { background: #333; color: #fff; border-color: #333; }

  /* 서브 필터 및 검색 스타일 */
  .filter-search-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 10px; }
  .sub_filter { display: flex; gap: 8px; align-items: center; font-size: 13px; }
  .sub_filter a { padding: 5px 10px; border: 1px solid #ddd; border-radius: 3px; text-decoration: none; color: #555; background: #fff; }
  .sub_filter a.active { background: #555; color: #fff; border-color: #555; }
  
  .search-form { position: relative; display: flex; gap: 5px; }
  .search-form input[type="text"] { padding: 6px 10px; border: 1px solid #ddd; border-radius: 4px; width: 180px; font-size: 13px; }
  .search-form input[type="submit"] { padding: 6px 12px; background: #333; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-size: 13px; }
  
  /* 자동완성 드롭다운 스타일 */
  #suggestions { border: 1px solid #cccccc; position: absolute; background: white; width: 180px; z-index: 10; top: 32px; left: 0; font-size: 13px; }
  #suggestions .item { padding: 6px 10px; cursor: pointer; }
  #suggestions .item:hover { background: #f1f1f1; }
  #suggestions em { background: Tomato; color: Seashell; font-weight: bold; font-style: italic; }

  /* 테이블 스타일 */
  table { width: 100%; border-collapse: collapse; text-align: center; font-size: 14px; }
  th, td { padding: 12px; border-bottom: 1px solid #eee; }
  th { background: #f4f4f4; font-weight: bold; }
  td a { color: #007bff; text-decoration: none; }
  td a:hover { text-decoration: underline; }

  /* 버튼 스타일 */
  .btn-delete { background: #e74c3c; color: #fff; border: none; padding: 5px 10px; border-radius: 3px; cursor: pointer; }
  .btn-pick { background: #f5c518; color: #111; border: none; padding: 5px 10px; border-radius: 3px; cursor: pointer; font-weight: bold; }
  .btn-pick.active { background: #333; color: #fff; }
  .btn-delete:hover { background: #c0392b; }
  .btn-pick:hover { background: #e0b015; }

  /* 페이징 스타일 */
  .pagination { display: flex; justify-content: center; gap: 5px; margin-top: 30px; }
  .pagination a { padding: 6px 12px; border: 1px solid #ddd; border-radius: 4px; text-decoration: none; color: #333; font-size: 13px; }
  .pagination a.active { background: #333; color: #fff; border-color: #333; }
  
  .total-count { font-size: 13px; color: #666; margin-bottom: 10px; }
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>

<div class="admin-wrap">
	<h3>게시글 관리</h3>

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

         <!-- 검색 및 자동완성 폼 -->
         <form name="community_search" method="get" action="/admin/community/list" class="search-form">
             <!-- 기존 필터 상태 유지용 숨은값 -->
             <input type="hidden" name="comm_type" value="${param.comm_type}">
             <input type="hidden" name="comm_pet_type" value="${param.comm_pet_type}">
             <input type="hidden" name="comm_category" value="${param.comm_category}">
             
             <input type="text" name="keyword" id="keyword" value="${param.keyword}" placeholder="검색어 입력" autocomplete="off">
             <input type="submit" value="검색">
             <div id="suggestions"></div>
         </form>
     </div>

     <div class="total-count">전체 ${totalCount}개</div>

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
                         <td colspan="4" style="padding: 40px; color: #999;">등록된 게시글이 없습니다.</td>
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
     
     <!-- 3. 페이징 네비게이션 -->
     <c:if test="${not empty totalPages and totalPages > 1}">
         <div class="pagination">
             <a href="/admin/communityUpdate?comm_type=${param.comm_type}&comm_pet_type=${param.comm_pet_type}&comm_category=${param.comm_category}&keyword=${param.keyword}&page=${pageNum > 1 ? pageNum - 1 : 1}">PREV</a>
             
             <c:forEach var="i" begin="1" end="${totalPages}">
                 <a href="/admin/communityUpdate?comm_type=${param.comm_type}&comm_pet_type=${param.comm_pet_type}&comm_category=${param.comm_category}&keyword=${param.keyword}&page=${i}" 
                    class="${pageNum eq i ? 'active' : ''}">${i}</a>
             </c:forEach>
             
             <a href="/admin/communityUpdate?comm_type=${param.comm_type}&comm_pet_type=${param.comm_pet_type}&comm_category=${param.comm_category}&keyword=${param.keyword}&page=${pageNum < totalPages ? pageNum + 1 : totalPages}">NEXT</a>
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
            url: "/community/autocomplete", // 필요시 관리자용 자동완성 경로로 수정 가능
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
</script>
</body>
</html>