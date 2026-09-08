<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 목록</title>
</head>
<style>
.preview_content{
	display: -webkit-box;
	-webkit-line-clamp: 1;
	-webkit-box-orient: vertical;  
	overflow: hidden;
	text-overflow: ellipsis;
	word-break: break-all;
}
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
		$("#keyword").on("keyup", function(){
		    let q = $(this).val();
		
		    if(q.length < 1){
		        $("#suggestions").empty();
		        return;
		    }
		
		    $.ajax({
		        url: "/autocomplete",
		        data: { keyword: q },
		        success: function(list){
		            let html = "";
		            list.forEach(function(item){
		                // highlight 필드 사용
		                html += "<div class='item'>" + item.highlight + "</div>";
		            });
		            $("#suggestions").html(html);
		        },
		        error: function(){
		            console.log("autocomplete error");
		        }
		    });
		});
		
		// 추천어 클릭 시 검색창에 채움
		$(document).on("click",".item",function(){
		    // <em> 태그 제거 후 input에 넣기
		    $("#keyword").val($(this).text());
		    $("#suggestions").empty();
		});
	</script>
<body>
<%@ include file="../hamburger_menu.jsp" %>
	<form name="community_search" method="get" action="/comm_search">
		<input type="text" name="keyword" id="keyword" autocomplete="off">
		<input type="submit" value="검색">
		<div id="suggetions" style="border:1px solid #cccccc;position:absolute;background:white;width:170px;z-index:10">
		</div>
	</form>
	
	<a href="/communityCrawlingWriteForm">글쓰기</a>
	<div class="category_tabs">
        <a href="/community/commList" class="${empty param.comm_type ? 'active' : ''}">전체</a>
        <a href="/community/commList?comm_type=Q%26A" class="${param.comm_type eq 'Q&A' ? 'active' : ''}">Q&amp;A</a>
        <a href="/community/commList?comm_type=라운지" class="${param.comm_type eq '라운지' ? 'active' : ''}">라운지</a>
        <a href="/community/commList?comm_type=콘텐츠" class="${param.comm_type eq '콘텐츠' ? 'active' : ''}">콘텐츠</a>
    </div>
    
	<c:if test="${empty param.comm_type or param.comm_type eq 'Q&A' or param.comm_type eq '라운지'}">
        <div class="sub_filter">
            <select name="sort" onchange="location.href='/community/commList?comm_type=${empty param.comm_type ? '' : param.comm_type}&amp;sort='+this.value+'&amp;comm_pet_type=${param.comm_pet_type}'">
                <option value="latest" ${param.sort eq 'latest' ? 'selected' : ''}>최신순</option>
                <option value="popular" ${param.sort eq 'popular' ? 'selected' : ''}>인기순</option>
            </select>
            
            <a href="/community/commList?comm_type=${empty param.comm_type ? '' : param.comm_type}&amp;comm_pet_type=" class="${empty param.comm_pet_type ? 'active' : ''}">전체</a>
            <a href="/community/commList?comm_type=${empty param.comm_type ? '' : param.comm_type}&amp;comm_pet_type=강아지" class="${param.comm_pet_type eq '강아지' ? 'active' : ''}">강아지</a>
            <a href="/community/commList?comm_type=${empty param.comm_type ? '' : param.comm_type}&amp;comm_pet_type=고양이" class="${param.comm_pet_type eq '고양이' ? 'active' : ''}">고양이</a>
            <a href="/community/commList?comm_type=${empty param.comm_type ? '' : param.comm_type}&amp;comm_pet_type=소동물" class="${param.comm_pet_type eq '소동물' ? 'active' : ''}">소동물</a>
            <a href="/community/commList?comm_type=${empty param.comm_type ? '' : param.comm_type}&amp;comm_pet_type=기타" class="${param.comm_pet_type eq '기타' ? 'active' : ''}">기타</a>
        </div>
    </c:if>
    
    <c:if test="${param.comm_type eq '콘텐츠'}">
        <div class="sub_filter">
            <a href="/community/commList?comm_type=콘텐츠&amp;comm_category=" class="${empty param.comm_category ? 'active' : ''}">전체</a>
            <a href="/community/commList?comm_type=콘텐츠&amp;comm_category=강아지연구소" class="${param.comm_category eq '강아지연구소' ? 'active' : ''}">강아지연구소</a>
            <a href="/community/commList?comm_type=콘텐츠&amp;comm_category=고양이연구소" class="${param.comm_category eq '고양이연구소' ? 'active' : ''}">고양이연구소</a>
            <a href="/community/commList?comm_type=콘텐츠&amp;comm_category=제품연구소" class="${param.comm_category eq '제품연구소' ? 'active' : ''}">제품연구소</a>
            <a href="/community/commList?comm_type=콘텐츠&amp;comm_category=제보" class="${param.comm_category eq '제보' ? 'active' : ''}">제보</a>
            <a href="/community/commList?comm_type=콘텐츠&amp;comm_category=뉴스/브랜드" class="${param.comm_category eq '뉴스/브랜드' ? 'active' : ''}">뉴스/브랜드</a>
        </div>
    </c:if>

	<div>전체 oo개</div>
	<table border="1" width="700">
	<c:forEach var="board" items="${list}">
		<tr>
			<td>${board.comm_type} ${board.comm_pet_type} ${board.comm_breed}</td>
			<td rowspan="4">
			<c:if test="${not empty board.comm_img}">
			<img src="${board.comm_img}" width="100" height="100">
			</c:if>
			</td>
		</tr>
		<tr>
			<td><a href="/communityView?comm_no=${board.comm_no}">${board.comm_title}</a></td>
		</tr>
		<tr>
			<td class="preview_content">${board.comm_content}</td>
		</tr>
		<tr>
			<td>답변${board.comm_count} ${board.comm_writer} ${board.comm_tag}</td>
		</tr>
	</c:forEach>
	</table>
	
	<div class="pagination">
        <a href="/community/commList?comm_type=${param.comm_type}&comm_pet_type=${param.comm_pet_type}&comm_category=${param.comm_category}&sort=${param.sort}&page=${pageNum > 1 ? pageNum - 1 : 1}">PREV</a>
        
        <c:forEach var="i" begin="1" end="${totalPages}">
            <a href="/community/commList?comm_type=${param.comm_type}&comm_pet_type=${param.comm_pet_type}&comm_category=${param.comm_category}&sort=${param.sort}&page=${i}" 
               class="${pageNum eq i ? 'active' : ''}">${i}</a>
        </c:forEach>
        
        <a href="/community/commList?comm_type=${param.comm_type}&comm_pet_type=${param.comm_pet_type}&comm_category=${param.comm_category}&sort=${param.sort}&page=${pageNum < totalPages ? pageNum + 1 : totalPages}">NEXT</a>
    </div>
    
    <!-- 댓글 -->
    
    
    
    
<%@ include file="../footer.jsp" %>
</body>
</html>