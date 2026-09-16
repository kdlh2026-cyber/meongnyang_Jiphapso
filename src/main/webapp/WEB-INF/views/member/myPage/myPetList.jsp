<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<style>
    .pl-wrap {
        max-width: 500px;
        margin: 0 auto;
    }

    .pl-list {
        display: flex;
        flex-direction: column;
        gap: 14px;
        margin-bottom: 26px;
    }

    .pl-item {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 14px;
        padding: 14px 20px;
        background: #FFFBF5;
        border: 1px solid #FFF3D8;
        border-radius: 999px;
    }

    .pl-item-left {
        display: flex;
        align-items: center;
        gap: 14px;
        text-decoration: none;
        min-width: 0;
    }

    .pl-avatar {
        width: 56px;
        height: 56px;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid #FDCC61;
        background: #FFF3D8;
        flex-shrink: 0;
    }

    .pl-info {
        display: flex;
        flex-direction: column;
        gap: 2px;
        min-width: 0;
    }
    .pl-name {
        font-size: 15px;
        font-weight: 700;
        color: #4A3226;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .pl-meta {
        font-size: 12px;
        color: #9c8a7c;
    }
    .pl-tag {
        display: inline-block;
        padding: 1px 8px;
        margin-right: 4px;
        border-radius: 999px;
        background: #FFC9CE;
        color: #4A3226;
        font-size: 11px;
        font-weight: 700;
    }

    .pl-actions {
        display: flex;
        gap: 6px;
        flex-shrink: 0;
    }
    .pl-action-btn {
        font-size: 12px;
        font-weight: 700;
        color: #4A3226;
        text-decoration: none;
        padding: 6px 12px;
        border-radius: 999px;
        border: 1.5px solid #FFC9CE;
        background: #fff;
        white-space: nowrap;
    }
    .pl-action-btn:hover { background: #FFC9CE; }
    .pl-action-btn--danger { border-color: #FDA58F; color: #b05545; }
    .pl-action-btn--danger:hover { background: #FDA58F; color: #FFFBF5; }

    .pl-empty {
        text-align: center;
        padding: 40px 20px;
        color: #9c8a7c;
        font-size: 14px;
        background: #FFFBF5;
        border: 1px dashed #FFC9CE;
        border-radius: 16px;
        margin-bottom: 26px;
    }

    .pl-footer-actions {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 10px;
    }
    .pl-btn {
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
    .pl-btn--solid { background: #FDCC61; color: #4A3226; }
    .pl-btn--solid:hover { background: #FDA58F; color: #FFFBF5; }
    .pl-btn--outline { background: #fff; border: 1.5px solid #FFC9CE; color: #4A3226; }
    .pl-btn--outline:hover { background: #FFC9CE; }
</style>

<div class="pl-wrap">

    <c:choose>
        <c:when test="${not empty myPetList}">
            <div class="pl-list">
                <c:forEach var="list" items="${myPetList}">
                <div class="pl-item">
                    <a class="pl-item-left" href="/member/myPage/myPetPage?pet_no=${list.pet_no}">
                        <c:choose>
                            <c:when test="${not empty list.pet_image}">
                                <img class="pl-avatar" src="/images/myPet/${list.pet_image}" alt="${list.pet_name}">
                            </c:when>
                            <c:when test="${list.pet_type == '고양이'}">
                                <img class="pl-avatar" src="/images/stray/menu/cat_head.png" alt="${list.pet_name}">
                            </c:when>
                            <c:when test="${list.pet_type == '강아지'}">
                                <img class="pl-avatar" src="/images/stray/menu/dog_head.png" alt="${list.pet_name}">
                            </c:when>
                            <c:otherwise>
                                <img class="pl-avatar" src="/images/main/hamster_head.png" alt="${list.pet_name}">
                            </c:otherwise>
                        </c:choose>

                        <div class="pl-info">
                            <span class="pl-name">${list.pet_name}</span>
                            <span class="pl-meta">
                                <span class="pl-tag">${list.pet_type}</span>${list.pet_breed} · ${list.pet_gender}
                            </span>
                        </div>
                    </a>

                    <div class="pl-actions">
                        <a class="pl-action-btn" href="/myPetUpdateForm?pet_no=${list.pet_no}">수정</a>
                        <a class="pl-action-btn pl-action-btn--danger" href="/myPetDelete?pet_no=${list.pet_no}"
                           onclick="return confirm('정말로 삭제하시겠습니까?');">삭제</a>
                    </div>
                </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="pl-empty">등록된 반려동물이 아직 없어요.</div>
        </c:otherwise>
    </c:choose>

    <div class="pl-footer-actions">
        <a class="pl-btn pl-btn--solid" href="/member/myPage/myPetInsertForm">추가하기</a>
    </div>

</div>