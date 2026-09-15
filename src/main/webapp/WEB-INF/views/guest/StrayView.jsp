<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
        background-color: #FFFBF5; /* 웜 화이트 */
        color: #4A3226;             /* 딥 브라운 */
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

    /* 1. 상단 타이틀 영역 */
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

    /* 2. 상단 요약/특이사항 카드 */
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

    /* 체크 아이콘 (연보라) */
    .summary-row .check {
        color: #8E7CC3;
        font-weight: bold;
        margin-right: 6px;
    }
	
    /* 성별 색상 분기 */
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

    /* 3. 동물 상세 정보 목록 */
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

    /* 4. 보호소 정보 영역 */
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
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>

    <div class="stray-detail-wrapper">
        <!-- 이미지 영역 -->
        <div class="stray-image-box">
            <img src="/uploadImages/${StrayView.stray_img}" alt="${StrayView.stray_name}">
        </div>

        <!-- 상세 정보 영역 -->
        <div class="stray-info-box">
            <!-- 타이틀 (뱃지 & 품종 | 나이) -->
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

            <!-- 성별, 털색, 체중, 특이사항 -->
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

            <!-- 상태 및 공고 정보 -->
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

            <!-- 보호소 정보 -->
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
        </div>
    </div>
</body>
</html>