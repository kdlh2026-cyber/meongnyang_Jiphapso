<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>멍냥집합소</title>
<script src="/js/main/memberCheck.js"></script>
<style>
    * { box-sizing: border-box; }
    body { margin: 0; font-family: "Noto Sans KR", "Malgun Gothic", sans-serif; background: #fff; color: #4A3226; }

    .pf-wrap {
        max-width: 480px;
        margin: 0 auto;
        padding: 32px 24px 60px;
    }

    .pf-avatar-wrap {
        display: flex;
        justify-content: center;
        margin-bottom: 28px;
    }
    .pf-avatar {
        width: 96px;
        height: 96px;
        border-radius: 50%;
        object-fit: cover;
        border: 3px solid #FDCC61;
        background: #FFF3D8;
    }

    .pf-field {
        margin-bottom: 22px;
    }
    .pf-field + .pf-field {
        padding-top: 22px;
        border-top: 1px solid #FFF3D8;
    }

    .pf-label {
        display: block;
        font-size: 12.5px;
        font-weight: 700;
        color: #b0821a;
        margin-bottom: 6px;
    }

    .pf-static {
        font-size: 15px;
        color: #4A3226;
    }

    .pf-input, .pf-textarea {
        width: 100%;
        padding: 10px 4px;
        font-size: 14.5px;
        color: #4A3226;
        border: none;
        border-bottom: 1.5px solid #FFC9CE;
        background: transparent;
        outline: none;
    }
    .pf-input:focus, .pf-textarea:focus {
        border-bottom-color: #FDCC61;
    }
    .pf-textarea {
        resize: vertical;
        min-height: 60px;
        font-family: inherit;
    }

    .pf-addr-row {
        display: flex;
        gap: 8px;
        align-items: center;
    }
    .pf-addr-row .pf-input { flex: 1; }

    .pf-mini-btn {
        flex-shrink: 0;
        padding: 8px 14px;
        border-radius: 999px;
        border: 1.5px solid #FFC9CE;
        background: #fff;
        color: #4A3226;
        font-size: 12.5px;
        font-weight: 700;
        cursor: pointer;
        white-space: nowrap;
    }
    .pf-mini-btn:hover { background: #FFC9CE; }

    .pf-checkbox-row {
        display: flex;
        align-items: center;
        gap: 8px;
    }
    .pf-checkbox-row input[type="checkbox"] {
        width: 18px;
        height: 18px;
        accent-color: #FDCC61;
    }
    .pf-checkbox-row label {
        font-size: 14px;
        color: #4A3226;
    }

    .pf-file-input {
        font-size: 13px;
        color: #4A3226;
    }

    .pf-actions {
        display: flex;
        justify-content: center;
        gap: 10px;
        margin-top: 36px;
    }
    .pf-btn {
        padding: 11px 36px;
        border-radius: 999px;
        font-size: 14.5px;
        font-weight: 700;
        border: none;
        cursor: pointer;
    }
    .pf-btn--solid { background: #FDCC61; color: #4A3226; }
    .pf-btn--solid:hover { background: #FDA58F; color: #FFFBF5; }
    .pf-btn--outline { background: #fff; border: 1.5px solid #FFC9CE; color: #4A3226; }
    .pf-btn--outline:hover { background: #FFC9CE; }
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/loading_animal.jsp" %>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>

<div class="pf-wrap">
<form name="memberForm" method="post" action="/memberUpdate" enctype="multipart/form-data" data-loading>
<input type="hidden" name="m_id" value="${memberUpdate.m_id}">

    <div class="pf-avatar-wrap">
        <img class="pf-avatar" src="/images/myProfile/${memberUpdate.m_img}" alt="현재 이미지">
    </div>

    <div class="pf-field">
        <label class="pf-label" for="m_upload">프로필 사진</label>
        <input class="pf-file-input" type="file" id="m_upload" name="m_upload">
        <!-- 기존 파일명을 hidden으로 같이 넘겨 새 파일 없으면 기존 값 유지 -->
        <input type="hidden" name="m_img" value="${memberUpdate.m_img}">
    </div>

    <div class="pf-field">
        <span class="pf-label">아이디</span>
        <div class="pf-static">${memberUpdate.m_id}</div>
    </div>

    <div class="pf-field">
        <label class="pf-label" for="m_passwd">비밀번호</label>
        <input class="pf-input" type="password" id="m_passwd" name="m_passwd">
    </div>

    <div class="pf-field">
        <span class="pf-label">이름</span>
        <div class="pf-static">${memberUpdate.m_name}</div>
    </div>

    <div class="pf-field">
        <label class="pf-label" for="m_tel">전화번호</label>
        <input class="pf-input" type="text" id="m_tel" name="m_tel" value="${memberUpdate.m_tel}">
    </div>

    <div class="pf-field">
        <label class="pf-label" for="m_addr">주소</label>
        <div class="pf-addr-row">
            <input class="pf-input" type="text" id="m_addr" name="m_addr" readonly value="${memberUpdate.m_addr}">
            <button type="button" class="pf-mini-btn" onclick="goPopup();">주소검색</button>
        </div>
    </div>

    <div class="pf-field">
        <label class="pf-label" for="m_addr_detail">상세주소</label>
        <input class="pf-input" type="text" id="m_addr_detail" name="m_addr_detail" value="${memberUpdate.m_addr_detail}">
    </div>

    <div class="pf-field">
        <label class="pf-label" for="m_zipno">우편번호</label>
        <input class="pf-input" type="text" id="m_zipno" name="m_zipno" value="${memberUpdate.m_zipno}">
    </div>

    <div class="pf-field">
        <label class="pf-label" for="m_email">이메일</label>
        <input class="pf-input" type="text" id="m_email" name="m_email" value="${memberUpdate.m_email}">
    </div>

    <div class="pf-field">
        <label class="pf-label" for="m_introduce">간단소개</label>
        <textarea class="pf-textarea" id="m_introduce" name="m_introduce">${memberUpdate.m_introduce}</textarea>
    </div>

    <div class="pf-field">
        <label class="pf-label" for="m_birth">생년월일</label>
        <fmt:formatDate value="${memberUpdate.m_birth}" pattern="yyyy-MM-dd" var="birthFormatted" />
        <input class="pf-input" type="date" id="m_birth" name="m_birth" value="${birthFormatted}">
    </div>

    <div class="pf-field">
        <div class="pf-checkbox-row">
            <input type="checkbox" id="m_sns" name="m_sns" value="T" ${memberUpdate.m_sns == 'T' ? 'checked' : ''}>
            <label for="m_sns">SNS 수신 동의</label>
        </div>
    </div>

    <div class="pf-actions">
        <input class="pf-btn pf-btn--solid" type="submit" value="수정">
        <input class="pf-btn pf-btn--outline" type="reset" value="취소">
    </div>

</form>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>