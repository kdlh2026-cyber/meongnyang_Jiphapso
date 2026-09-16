<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${StrayView.stray_name} ${StrayView.stray_gender} ${StrayView.stray_age}년생</title>
<style>
    /* 기본 리셋 & 공통 폰트 */
    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
    }
    body {
        background-color: #FFFBF5;
        color: #4A3226;
        font-family: -apple-system, BlinkMacSystemFont, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif;
        line-height: 1.5;
        padding-bottom: 50px;
    }

    /* 상세 페이지 전체 컨테이너 */
    .stray-detail-wrapper {
        max-width: 960px;
        margin: 40px auto;
        padding: 30px;
        background-color: #ffffff;
        border-radius: 24px;
        box-shadow: 0 8px 24px rgba(74, 50, 38, 0.05);
        display: flex;
        gap: 36px;
    }

    /* 좌측 이미지 영역 */
    .stray-image-box {
        flex: 0 0 340px;
    }
    .stray-image-box img {
        width: 100%;
        height: 380px;
        object-fit: cover;
        border-radius: 16px;
        display: block;
    }

    /* 우측 상세 정보 영역 */
    .stray-info-box {
        flex: 1;
        display: flex;
        flex-direction: column;
        gap: 18px;
    }

    /* 상단 타이틀 영역 */
    .stray-header {
        display: flex;
        align-items: center;
        gap: 12px;
        flex-wrap: wrap;
    }
    .category-badge {
        display: inline-flex;
        align-items: center;
        gap: 4px;
        padding: 5px 12px;
        background-color: #FFF3D8;
        border: 1px solid #FDCC61;
        border-radius: 20px;
        font-size: 13px;
        font-weight: 700;
        color: #4A3226;
    }
    .category-badge img {
        width: 18px;
        height: 18px;
        vertical-align: middle;
    }
    .main-title {
        font-size: 22px;
        font-weight: 700;
        color: #4A3226;
    }
    .title-divider {
        color: #ddd;
        margin: 0 6px;
        font-weight: 300;
    }

    /* 상단 요약/특이사항 카드 */
    .summary-card {
        background-color: #FFF3D8;
        border: 1px solid #FFC9CE; 
        border-radius: 16px;
        padding: 16px 20px;
        display: flex;
        flex-direction: column;
        gap: 8px;
    }
    .summary-row {
        display: flex;
        align-items: center;
        flex-wrap: wrap;
        font-size: 14px;
        color: #4A3226;
    }
    .summary-row .check {
        color: #8E7CC3;
        font-weight: bold;
        margin-right: 6px;
    }
    .female {
        color: #FDA58F !important;
        font-weight: 700;
    }
    .male {
        color: #5A84D1 !important;
        font-weight: 700;
    }
    .card-divider {
        color: #ccc;
        margin: 0 8px;
    }

    /* 동물 상세 정보 목록 */
    .info-list {
        display: flex;
        flex-direction: column;
        gap: 10px;
        font-size: 14px;
        padding: 10px 0;
    }
    .info-item {
        display: flex;
        align-items: flex-start;
    }
    .info-label {
        width: 80px;
        color: #8C7365;
        font-weight: 500;
        flex-shrink: 0;
    }
    .info-value {
        color: #4A3226;
        font-weight: 600;
        word-break: keep-all;
    }

    /* 보호소 정보 영역 */
    .shelter-card {
        padding-top: 16px;
        border-top: 1px dashed #FFC9CE;
        display: flex;
        flex-direction: column;
        gap: 10px;
        font-size: 14px;
    }
    .shelter-row {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
    }
    .shelter-sub-item {
        display: flex;
        align-items: baseline;
    }
    .btn-opt {
        background: #ffffff;
        border: 1px solid #ced4da;
        color: #4A3226;
        padding: 8px 16px;
        border-radius: 8px;
        font-size: 13px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s;
    }
    
    .btn-back {
    display: block;
    width: 340px;
    max-width: 100%;
    margin: auto;
    background: #ffffff;
    border: 1px solid #ced4da;
    color: #4A3226;
    padding: 12px 16px; 
    border-radius: 8px;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    text-align: center;
    transition: all 0.2s;
}

.btn-back:hover {
    background: #f8f9fa;
    border-color: #adb5bd;
}

    /* 멍냥집합소 추천 콘텐츠 영역 */
    .recommend-box {
        max-width: 960px;
        margin: 0 auto;
        padding: 30px;
        background-color: #ffffff;
        border-radius: 24px;
        box-shadow: 0 8px 24px rgba(74, 50, 38, 0.05);
    }
    .recommend-title {
        font-size: 20px;
        font-weight: 700;
        margin-bottom: 10px;
        color: #4A3226;
    }
    .content-item-link {
        display: flex;
        justify-content: space-between;
        align-items: center;
        text-decoration: none;
        color: inherit;
        gap: 24px;
        padding: 24px 0;
        border-bottom: 1px solid #F0ECE9;
    }
    .content-item-link:last-child {
        border-bottom: none;
    }
    .text-area {
        flex: 1;
        min-width: 0;
    }
    .badge {
        display: inline-block;
        background-color: #FFF3D8;
        color: #4A3226;
        padding: 4px 12px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 700;
        margin-bottom: 10px;
    }
    .content-title {
        font-size: 17px;
        font-weight: 700;
        color: #1a1a1a;
        margin-bottom: 8px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .content-preview {
        color: #666;
        font-size: 14px;
        line-height: 1.6;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }
    .img-area {
        flex-shrink: 0;
    }
    .img-area img {
        width: 170px;
        height: 110px;
        object-fit: cover;
        border-radius: 14px;
        display: block;
    }
    /* 함께할 가족 추천 카드 슬라이더 영역 */
    .family-box {
        max-width: 960px;
        margin: 40px auto;
        padding: 30px;
        background-color: #ffffff;  /* 요청하신 흰색 배경 */
        border-radius: 24px;
        box-shadow: 0 8px 24px rgba(74, 50, 38, 0.05);
    }
    .family-title {
        font-size: 20px;
        font-weight: 700;
        margin-bottom: 20px;
        color: #4A3226;
        text-align: center;
    }
    /* 가로 스크롤 컨테이너 */
    .family-card-list {
        display: flex;
        gap: 16px;
        overflow-x: auto;
        padding-bottom: 12px;
        scroll-snap-type: x mandatory;
        -webkit-overflow-scrolling: touch;
    }
    /* 스크롤바 커스텀 */
    .family-card-list::-webkit-scrollbar {
        height: 6px;
    }
    .family-card-list::-webkit-scrollbar-thumb {
        background: #e2dcd5;
        border-radius: 10px;
    }

    /* 개별 카드 링크 */
    .family-card {
        flex: 0 0 170px; /* 카드의 너비 */
        background: #ffffff;
        border-radius: 18px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
        border: 1px solid #f0ece9;
        overflow: hidden;
        text-decoration: none;
        color: inherit;
        scroll-snap-align: start;
        transition: transform 0.2s, box-shadow 0.2s;
    }
    .family-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 8px 20px rgba(74, 50, 38, 0.12);
    }

    /* 카드 이미지 영역 */
    .family-thumb-area {
        position: relative;
        width: 100%;
        height: 160px;
        background-color: #f7f7f7;
    }
    .family-thumb-area img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        display: block;
    }
    /* 카드 좌측 상단 강아지/고양이 뱃지 */
    .family-badge {
        position: absolute;
        top: 8px;
        left: 8px;
        background-color: #FFF3D8;
        border: 1px solid #FDCC61;
        color: #4A3226;
        font-size: 11px;
        font-weight: 700;
        padding: 3px 8px;
        border-radius: 12px;
    }

    /* 카드 하단 정보 텍스트 */
    .family-info-area {
        padding: 12px 10px;
        text-align: center;
    }
    .family-name {
        font-size: 14px;
        font-weight: 700;
        color: #222222;
        margin-bottom: 4px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .family-sub {
        font-size: 13px;
        font-weight: 500;
        color: #777777;
    }
    .family-sub .male {
        color: #5A84D1 !important;
        font-weight: 700;
    }
    .family-sub .female {
        color: #FDA58F !important;
        font-weight: 700;
    }
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
    <div class="stray-detail-wrapper">
        <div class="stray-image-box">
		    <c:set var="mainImg" value="${fn:replace(StrayView.stray_img, '[', '%5B')}" />
		    <c:set var="mainImg" value="${fn:replace(mainImg, ']', '%5D')}" />
		    <img src="/uploadImages/${mainImg}" alt="${StrayView.stray_name}">
		</div>

        <div class="stray-info-box">
            <div class="stray-header">
                <div class="category-badge">
                    <c:choose>
                        <c:when test="${StrayView.stray_category == 'DOG'}">
                            <img src="/images/stray/menu/dog_head.png" alt="강아지"> 강아지
                        </c:when>
                        <c:when test="${StrayView.stray_category == 'CAT'}">
                            <img src="/images/stray/menu/cat_head.png" alt="고양이"> 고양이
                        </c:when>
                    </c:choose>
                </div>
                <div class="main-title">
                    ${StrayView.stray_name}
                    <span class="title-divider">|</span>
                    <c:set var="currentYear" value="<%= java.time.LocalDate.now().getYear() %>" />
                    <c:set var="age" value="${currentYear - StrayView.stray_age}" />
                    <c:choose>
                        <c:when test="${age == 0}">1살 미만</c:when>
                        <c:otherwise>${age}살</c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="summary-card">
                <div class="summary-row">
                    <span class="check">✓</span>
                    <span class="${StrayView.stray_gender == 'M' ? 'male' : 'female'}">${StrayView.stray_gender}</span>
                    <span>
                        <c:choose>
                            <c:when test="${StrayView.stray_neuter == 'Y'}"> · 중성화 완료</c:when>
                            <c:when test="${StrayView.stray_neuter == 'N'}"> · 중성화 미완료</c:when>
                            <c:when test="${StrayView.stray_neuter == 'Q'}"> · 중성화 알수 없음</c:when>
                        </c:choose>
                    </span>
                    <span class="card-divider">|</span>
                    <span>${StrayView.stray_character}의 털</span>
                    <span class="card-divider">|</span>
                    <span>${StrayView.stray_weight}Kg</span>
                </div>
                <div class="summary-row">
                    <span class="check">✓</span>
                    <span>특이사항은? ${StrayView.stray_memo}</span>
                </div>
            </div>

            <div class="info-list">
                <div class="info-item">
                    <div class="info-label">상태</div>
                    <div class="info-value">${StrayView.stray_status}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">공고번호</div>
                    <div class="info-value">${StrayView.stray_notice_no}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">공고기간</div>
                    <div class="info-value">${StrayView.stray_notice_start} ~ ${StrayView.stray_notice_end}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">발견장소</div>
                    <div class="info-value">${StrayView.stray_found_place}</div>
                </div>
            </div>

            <div class="shelter-card">
                <div class="shelter-row">
                    <div class="shelter-sub-item">
                        <div class="info-label">보호소</div>
                        <div class="info-value">${StrayView.stray_shelter_name}</div>
                    </div>
                    <div class="shelter-sub-item">
                        <div class="info-label">연락처</div>
                        <div class="info-value">${StrayView.stray_shelter_tel}</div>
                    </div>
                </div>
                <div class="shelter-sub-item">
                    <div class="info-label">보호주소</div>
                    <div class="info-value">${StrayView.stray_shelter_addr}</div>
                </div>
            </div>
            <div>
                <button type="button" class="btn-back" onclick="history.back()">목록으로 돌아가기</button>
            </div>
        </div>
    </div>
	<!-- 함께할 가족을 찾고 있어요 슬라이더 영역 -->
    <div class="family-box">
        <h2 class="family-title">함께할 가족을 기다리고 있어요</h2>
        
        <div class="family-card-list">
            <c:forEach items="${StrayRandomView}" var="item">
                <c:set var="currentYear" value="<%= java.time.LocalDate.now().getYear() %>" />
                <c:set var="itemAge" value="${currentYear - item.stray_age}" />
                
                <a href="/guest/StrayView?stray_no=${item.stray_no}" class="family-card">
                    <div class="family-thumb-area">
                        <span class="family-badge">
                            <c:choose>
                                <c:when test="${item.stray_category == 'DOG'}">강아지</c:when>
                                <c:when test="${item.stray_category == 'CAT'}">고양이</c:when>
                                <c:otherwise>기타</c:otherwise>
                            </c:choose>
                        </span>
                        <c:set var="cleanImg" value="${fn:replace(item.stray_img, '[', '%5B')}" />
						<c:set var="cleanImg" value="${fn:replace(cleanImg, ']', '%5D')}" />
						<img src="/uploadImages/${cleanImg}" alt="${item.stray_name}">
                    </div>
                    
                    <div class="family-info-area">
                        <p class="family-name">${item.stray_name}</p>
                        <div class="family-sub">
                            <span class="${item.stray_gender == 'M' ? 'male' : 'female'}">
                                ${item.stray_gender == 'M' ? '남아' : '여아'}
                            </span>
                            <span> · </span>
                            <span>
                                <c:choose>
                                    <c:when test="${itemAge <= 0}">1세 미만</c:when>
                                    <c:otherwise>${itemAge}세</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                </a>
            </c:forEach>
        </div>
    </div>
    <!-- 추천 콘텐츠 영역 -->
    <div class="recommend-box">
        <h2 class="recommend-title">멍냥집합소 추천 콘텐츠</h2>
        <c:forEach items="${ContentList}" var="list">
            <a href="/community/commView?comm_no=${list.comm_no}" class="content-item-link">
                <div class="text-area">
                    <c:if test="${not empty list.comm_category}">
                        <span class="badge">${list.comm_category}</span>
                    </c:if>
                    <div class="content-title">${list.comm_title}</div>
                    <p class="content-preview">
					    <!-- HTML 태그(<...>) 및 &nbsp; 제거 후 순수 텍스트화 -->
					    <c:set var="pureText" value="${list.comm_content.replaceAll('<[^>]*>', '').replaceAll('&nbsp;', ' ').trim()}" />
					    
					    <!-- 순수 텍스트 기준으로 80자 제한 후 말줄임 (...) 처리 -->
					    <c:choose>
					        <c:when test="${pureText.length() > 100}">
					            ${pureText.substring(0, 100)}...
					        </c:when>
					        <c:otherwise>
					            ${pureText}
					        </c:otherwise>
					    </c:choose>
					</p>
                </div>
                <div class="img-area">
                    <img src="${list.comm_img}" alt="${list.comm_title}">
                </div>
            </a>
        </c:forEach>
    </div>
</body>
</html>