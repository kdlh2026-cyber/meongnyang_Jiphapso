<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<style>
    .pv-card {
        max-width: 420px;
        margin: 0 auto;
        padding: 32px 24px;
        text-align: center;
        background: #FFFBF5;
        border: 1px solid #FFF3D8;
        border-radius: 20px;
    }

    .pv-avatar-wrap {
        display: flex;
        justify-content: center;
        margin-bottom: 18px;
    }
    .pv-avatar {
        width: 96px;
        height: 96px;
        border-radius: 50%;
        object-fit: cover;
        border: 3px solid #FDCC61;
        background: #FFF3D8;
    }

    .pv-name {
        font-size: 19px;
        font-weight: 700;
        color: #4A3226;
        margin: 0 0 2px;
    }
    .pv-id {
        font-size: 13px;
        color: #9c8a7c;
        margin: 0 0 18px;
    }

    .pv-info-list {
        display: flex;
        flex-direction: column;
        gap: 10px;
        margin-bottom: 22px;
        text-align: center;
    }
    .pv-info-row {
        font-size: 14px;
        color: #4A3226;
    }
    .pv-info-label {
        display: inline-block;
        font-weight: 700;
        color: #4A3226;
        margin-right: 6px;
    }

    .pv-badge {
        display: inline-block;
        padding: 3px 12px;
        border-radius: 999px;
        background: #FFC9CE;
        color: #4A3226;
        font-size: 12px;
        font-weight: 700;
    }

    .pv-intro {
        font-size: 13.5px;
        color: #6b6b6b;
        line-height: 1.6;
        margin-bottom: 24px;
        padding: 14px;
        background: #fff;
        border: 1px solid #FFF3D8;
        border-radius: 14px;
    }

    .pv-actions {
        display: flex;
        flex-direction: column;
        gap: 10px;
        align-items: center;
    }
    .pv-btn {
        display: inline-block;
        width: 100%;
        max-width: 260px;
        padding: 11px 0;
        border-radius: 999px;
        font-size: 14px;
        font-weight: 700;
        text-decoration: none;
        text-align: center;
    }
    .pv-btn--solid {
        background: #FDCC61;
        color: #4A3226;
    }
    .pv-btn--solid:hover {
        background: #FDA58F;
        color: #FFFBF5;
    }
    .pv-btn--outline {
        background: #fff;
        border: 1.5px solid #FFC9CE;
        color: #4A3226;
    }
    .pv-btn--outline:hover {
        background: #FFC9CE;
    }
</style>

<div class="pv-card">
    <div class="pv-avatar-wrap">
        <img class="pv-avatar" src="/images/myProfile/${myId.m_img}" alt="${myId.m_img}">
    </div>

    <p class="pv-name">${myId.m_name}</p>
    <p class="pv-id">@${myId.m_id}</p>

    <div class="pv-info-list">
        <div class="pv-info-row">
            <span class="pv-info-label">이메일</span>${myId.m_email}
        </div>
        <div class="pv-info-row">
            <span class="pv-info-label">생년월일</span>
            <fmt:formatDate value="${myId.m_birth}" pattern="yyyy년 MM월 dd일" />
        </div>
        <div class="pv-info-row">
            <span class="pv-info-label">SNS 수신</span>
            <span class="pv-badge">${myId.m_sns}</span>
        </div>
    </div>

    <c:if test="${not empty myId.m_introduce}">
        <p class="pv-intro">${myId.m_introduce}</p>
    </c:if>

    <div class="pv-actions">
        <a class="pv-btn pv-btn--solid" href="/member/myPage/myProfileUpdateForm">회원 정보 수정</a>
        <a class="pv-btn pv-btn--outline" href="/dailycheck">출석체크 페이지</a>
        <c:if test="${myId.m_cre_sub == 'F'}">
            <a class="pv-btn pv-btn--outline" href="/creatorSubmit">크리에이터 신청</a>
        </c:if>
    </div>
</div>