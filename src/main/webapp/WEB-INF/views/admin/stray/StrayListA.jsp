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
/* 필터 아이콘 CSS 배경 처리 */
.filter-icon {
    display: inline-block;
    width: 16px;
    height: 16px;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23333333' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cline x1='4' y1='21' x2='4' y2='14'/%3E%3Cline x1='4' y1='10' x2='4' y2='3'/%3E%3Cline x1='12' y1='21' x2='12' y2='12'/%3E%3Cline x1='12' y1='8' x2='12' y2='3'/%3E%3Cline x1='20' y1='21' x2='20' y2='16'/%3E%3Cline x1='20' y1='12' x2='20' y2='3'/%3E%3Cline x1='1' y1='14' x2='7' y2='14'/%3E%3Cline x1='9' y1='8' x2='15' y2='8'/%3E%3Cline x1='17' y1='16' x2='23' y2='16'/%3E%3C/svg%3E");
    background-repeat: no-repeat;
    background-position: center;
    background-size: contain;
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
/* 기본 폰트 및 공통 설정 */
* {
    box-sizing: border-box;
    font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, system-ui, Roboto, sans-serif;
}

/* 필터 전체 컨테이너 */
.adoption-search-wrap {
    max-width: 960px;
    margin: 40px auto 20px;
    padding: 0 15px;
}

.search-header-title {
    text-align: center;
    font-size: 26px;
    font-weight: 800;
    color: #222;
    margin-bottom: 50px;
}

/* 베이지/연노랑 메인 박스 */
.filter-card {
    position: relative; /* 캐릭터 이미지 배치를 위해 필수 */
    display: flex;
    align-items: center;
    gap: 16px;
    background-color: #fdfbf5;
    border: 1px solid #f3eedf;
    border-radius: 20px;
    padding: 24px 30px;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.04);
}

/* 상단에 걸쳐진 캐릭터 이미지 */
.character-banner-img {
    position: absolute;
    right: 40px;
    top: -70px;
    width: 140px;
    height: auto;
    z-index: 2;
    pointer-events: none; /* 클릭 통과 */
}

/* 강아지/고양이 탭 버튼 */
.animal-tabs {
    display: flex;
    gap: 12px;
}

.animal-tab {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    width: 72px;
    height: 72px;
    background-color: #fff;
    border: 1px solid #eee;
    border-radius: 14px;
    cursor: pointer;
    font-size: 13px;
    font-weight: 700;
    color: #444;
    transition: all 0.2s ease;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.04);
}

.animal-tab img {
    width: 32px;
    height: 32px;
    object-fit: contain;
    margin-bottom: 4px;
}

/* 선택된 탭 */
.animal-tab.active {
    background-color: #fcedb6;
    border-color: #edd999;
}

/* 품종 / 지역 노란 알약 버튼 공통 */
.pill-btn {
    display: flex;
    justify-content: space-between;
    align-items: center;
    height: 60px;
    padding: 0 20px;
    background-color: #feefb8;
    border-radius: 12px;
    font-size: 16px;
    font-weight: 700;
    color: #222;
    cursor: pointer;
    border: none;
    transition: background-color 0.2s;
}

.pill-btn:hover {
    background-color: #fce79f;
}

/* 품종 영역 (너비 확장) */
.breed-filter {
    flex: 1.5;
}

/* 지역 영역 및 팝업 래퍼 */
.region-filter-wrap {
    position: relative;
    flex: 1;
}

.region-btn {
    width: 100%;
}

/* 화살표 기본 모양 (아래쪽을 향함) */
.arrow-icon {
    display: inline-block;
    width: 8px;
    height: 8px;
    border-right: 2px solid #333;
    border-bottom: 2px solid #333;
    transform: rotate(45deg);
    transition: transform 0.25s ease;
    margin-bottom: 2px;
}

/* 열렸을 때 화살표가 위쪽으로 회전 */
.region-btn.active .arrow-icon {
    transform: rotate(-135deg);
    margin-bottom: -2px;
}

/* 지역 드롭다운 팝업 (기본 숨김: display: none 필수) */
.region-dropdown {
    display: none; /* ← 처음에 숨겨둡니다 */
    position: absolute;
    top: calc(100% + 12px);
    right: 0;
    width: 290px;
    background-color: #ffffff;
    border: 2px solid #f6cf4c;
    border-radius: 16px;
    padding: 22px 20px;
    box-shadow: 0 10px 24px rgba(0, 0, 0, 0.08);
    z-index: 100;
}

/* 열림 상태 클래스 */
.region-dropdown.show {
    display: block !important;
}

.dropdown-group {
    margin-bottom: 16px;
}

.dropdown-group label {
    display: block;
    font-size: 14px;
    font-weight: 700;
    color: #222;
    margin-bottom: 8px;
}

.dropdown-group select {
    width: 100%;
    height: 42px;
    border: 1px solid #e2e8f0;
    background-color: #f8fafc;
    border-radius: 8px;
    padding: 0 12px;
    font-size: 14px;
    color: #333;
    outline: none;
    cursor: pointer;
}

.dropdown-group select:focus {
    border-color: #f6cf4c;
}

/* 적용 버튼 */
.dropdown-submit-btn {
    display: block;
    margin: 10px auto 0;
    width: 80px;
    height: 36px;
    background-color: #f6c728;
    color: #222;
    border: none;
    border-radius: 18px;
    font-size: 14px;
    font-weight: 700;
    cursor: pointer;
    transition: background-color 0.2s;
}

.dropdown-submit-btn:hover {
    background-color: #e5b61a;
}

/* 하단 부가 정보 및 필터 바 */
.filter-sub-bar {
    display: flex;
    align-items: center;
    gap: 15px;
    margin-top: 25px;
}

.simple-filter-btn {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 8px 16px;
    background-color: #fff;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 600;
    color: #333;
    cursor: pointer;
}

.stray-count-info {
    font-size: 15px;
    color: #333;
}

.stray-count-info .yellow-dot {
    color: #f6c728;
    font-size: 18px;
    vertical-align: middle;
    margin-right: 2px;
}

.stray-count-info strong {
    font-weight: 800;
    color: #111;
}
</style>
<script>
function selectAnimal(type) {
    const urlParams = new URLSearchParams(window.location.search);
    const currentCategory = urlParams.get('category');

    if (currentCategory === type) {
        // 동일한 탭을 한 번 더 누르면 필터 해제 (전체 목록)
        location.href = '/admin/stray/StrayListA?page=1';
    } else {
        // 해당 카테고리로 필터링 (1페이지부터 시작)
        location.href = '/admin/stray/StrayListA?category=' + type + '&page=1';
    }
}
</script>
<body>
<%@ include file="../../hamburger_menu.jsp" %>
<div>
	<div class="adoption-search-wrap">
    <h2 class="search-header-title">보호소 입양</h2>

    <div class="filter-card">
        <img src="/images/stray/menu/regist_samsek_lili.6c16a730.png" class="character-banner-img" alt="캐릭터">
		<div class="animal-tabs">
		    <button type="button" 
		            class="animal-tab ${(empty category or category == 'DOG') ? 'active' : ''}" 
		            onclick="selectAnimal('DOG')">
		        <img src="/images/stray/menu/LILI_MINI.f614311b.png" alt="강아지">
		        <span>강아지</span>
		    </button>
		    <button type="button" 
		            class="animal-tab ${category == 'CAT' ? 'active' : ''}" 
		            onclick="selectAnimal('CAT')">
		        <img src="/images/stray/menu/SAMSEK_MINI.2d53f16f.png" alt="고양이">
		        <span>고양이</span>
		    </button>
		</div>

        <button type="button" class="pill-btn breed-filter">
            <span>품종</span>
            <span class="arrow-icon"></span>
        </button>

        <div class="region-filter-wrap">
            <button type="button" class="pill-btn region-btn" id="regionToggleBtn" onclick="toggleRegionDropdown()">
                <span>지역</span>
                <span class="arrow-icon up" id="regionArrow"></span>
            </button>

            <div class="region-dropdown" id="regionDropdown">
                <div class="dropdown-group">
                    <label>시/도</label>
                    <select id="sidoSelect">
                        <option value="">전체</option>
                        <option value="seoul">서울특별시</option>
                        <option value="gyeonggi">경기도</option>
                        <option value="busan">부산광역시</option>
                    </select>
                </div>
                <div class="dropdown-group">
                    <label>군/구</label>
                    <select id="gunguSelect">
                        <option value="">전체</option>
                    </select>
                </div>
                <button type="button" class="dropdown-submit-btn" onclick="applyRegionFilter()">적용</button>
            </div>
        </div>
    </div>

    <!-- 하단 서브 필터 버튼 & 카운트 안내 -->
    <div class="filter-sub-bar">
        <button type="button" class="simple-filter-btn">
            <i class="filter-icon"></i>
            필터
        </button>
        <div class="stray-count-info">
		    <span class="yellow-dot">●</span>
		    <strong><fmt:formatNumber value="${totalCount}" pattern="#,###"/></strong> 마리의 아이들이 보호자를 기다리고 있어요
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
<!-- 카테고리 파라미터가 있으면 쿼리스트링 유지 -->
<c:set var="categoryParam" value="${not empty param.category ? '&category='.concat(param.category) : ''}" />

<div class="pagination">
    <%-- 이전 블록 버튼 (<) --%>
    <c:if test="${hasPrev}">
        <a href="/admin/stray/StrayListA?page=${startPage - 1}${categoryParam}" class="arrow">&lt;</a>
    </c:if>
    
    <%-- 번호 반복 --%>
    <c:forEach begin="${startPage}" end="${endPage}" var="i">
        <c:choose>
            <c:when test="${currentPage == i}">
                <strong>${i}</strong>
            </c:when>
            <c:otherwise>
                <a href="/admin/stray/StrayListA?page=${i}${categoryParam}">${i}</a>
            </c:otherwise>
        </c:choose>
    </c:forEach>

    <%-- 다음 블록 버튼 (>) --%>
    <c:if test="${hasNext}">
        <a href="/admin/stray/StrayListA?page=${endPage + 1}${categoryParam}" class="arrow">&gt;</a>
    </c:if>
</div>
</body>
</html>