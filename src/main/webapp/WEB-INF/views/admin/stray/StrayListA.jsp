<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>유기동물 리스트</title>
</head>
<style>
.image img {
		width: 80%;
		height: auto;
		max-width: 300px;
	}
	
.pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 10px;
    margin-top: 30px;
}
.pagination a, .pagination strong {
    display: inline-flex;
    justify-content: center;
    align-items: center;
    width: 36px;
    height: 36px;
    border-radius: 50%; /* 동그란 버튼 모양 */
    text-decoration: none;
    color: #333;
    font-weight: bold;
    border: 1px solid #dfdfdf;
    background-color: #fff;
}
.pagination strong {
    background-color: #ffc107; /* 활성화된 페이지 노란색 배경 */
    color: #000;
    border: 1px solid #ffc107;
}
.pagination a:hover {
    background-color: #f5f5f5;
}
.pagination .arrow {
    color: #888;
    border: 2px solid #ccc; /* 화살표 테두리를 약간 더 굵게 */
}
</style>
<body>
<%@ include file="../../hamburger_menu.jsp" %>
<div>
	<div>
		<img src="/images/stray/menu/regist_samsek_lili.6c16a730.png">
		<div>
			<div>
				<img src="/images/stray/menu/LILI_MINI.f614311b.png"><br>
				강아지
			</div>
			<div>
				<img src="/images/stray/menu/SAMSEK_MINI.2d53f16f.png"><br>
				고양이
			</div>
		</div>
		<div>
			<div>
				품종
			</div>
			<div>
				지역
			</div>
		</div>
	</div>
</div>
<table border="1">
    <tr>  
    <c:forEach var="list" items="${StrayAnimalList}" varStatus="status">
    	<c:set var="currentYear" value="<%= java.time.LocalDate.now().getYear() %>" />
        <c:set var="age" value="${currentYear - list.stray_age}" />
    	<td>
    	<div>
        	<div class="image"><img src="/uploadImages/${list.stray_img}"></div>
        	<div>${list.stray_status}</div>
        	<div>
        		<a href="/guest/StrayView?stray_no=${list.stray_no}">
        		<c:choose>
			        <c:when test="${list.stray_category == 'DOG'}">강아지</c:when>
			        <c:when test="${list.stray_category == 'CAT'}">고양이</c:when>
		        </c:choose>
        		${list.stray_name}
        		</a>
        		<span>|</span>
        		<c:choose>
			        <c:when test="${age == 0}">1살 미만</c:when>
			        <c:otherwise>${age}살</c:otherwise>
		        </c:choose>
        	</div>
        	<div>
        	<c:choose>
			        <c:when test="${list.stray_gender == 'M'}">남아</c:when>
			        <c:when test="${list.stray_gender == 'F'}">여아</c:when>
			        <c:when test="${list.stray_gender == 'Q'}">미상</c:when>
			        <c:otherwise>오류</c:otherwise>
		    </c:choose>
		    <c:choose>
			        <c:when test="${list.stray_neuter == 'Y'}"> · 중성화 완료</c:when>
			        <c:when test="${list.stray_neuter == 'N'}"> · 중성화 미완료</c:when>
			        <c:when test="${list.stray_neuter == 'Q'}"> · 중성화 알수 없음</c:when>
			        <c:otherwise>오류</c:otherwise>
		    </c:choose>
        	</div>
	        <div>
	        	<c:set var="addrParts" value="${fn:split(list.stray_shelter_addr, ' ')}" />
	        	<div>${addrParts[0]} ${addrParts[1]}</div>
	        </div>
	        <c:choose>
			        <c:when test="${list.stray_category == 'DOG'}"><img src="/uploadImages/menu/profile_lili.39c4a6dd.png"></c:when>
			        <c:when test="${list.stray_category == 'CAT'}"><img src="/uploadImages/menu/profile_samsek.dcd2215d.png"></c:when>
		    </c:choose>
	        <div>
	        	<button onclick="location.href='/productUpdate?p_no=${list.stray_no}'">수정</button>
	        	<button onclick="if(confirm('정말 삭제 하시겠습니까?')){location.href='/StrayAnimalDelete?stray_no=${list.stray_no}';}">삭제</button>
	        </div>
	    </div>  
        </td>
        
	    <c:if test="${status.count%3==0}">
	    	</tr><tr>
	    </c:if>
    </c:forEach>  
    </tr>
</table>
<div class="pagination">
    <%-- 이전 블록 버튼 (<) --%>
    <c:if test="${hasPrev}">
        <a href="/admin/stray/StrayListA?page=${startPage - 1}" class="arrow">&lt;</a>
    </c:if>
    
    <%-- 1~totalPages 전체 반복이 아닌, startPage~endPage 블록만큼만 반복 --%>
    <c:forEach begin="${startPage}" end="${endPage}" var="i">
        <c:choose>
            <c:when test="${currentPage == i}">
                <strong>${i}</strong>
            </c:when>
            <c:otherwise>
                <a href="/admin/stray/StrayListA?page=${i}">${i}</a>
            </c:otherwise>
        </c:choose>
    </c:forEach>

    <%-- 다음 블록 버튼 (>) --%>
    <c:if test="${hasNext}">
        <a href="/admin/stray/StrayListA?page=${endPage + 1}" class="arrow">&gt;</a>
    </c:if>
</div>
</body>
</html>