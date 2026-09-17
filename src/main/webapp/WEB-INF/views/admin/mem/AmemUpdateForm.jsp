<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
<link rel="stylesheet" href="/css/admin/admin-mem-detail.css">
</head>
<body>
<%@ include file="/WEB-INF/views/loading_animal.jsp" %>
<%@ include file="/WEB-INF/views/admin/clone/hamburger_menu.jsp" %>
<div class="admin-content-wrap">
    <h2>회원 정보 수정</h2>
    <form name="AmemUpdateForm" method="post" action="/AmemUpdate" enctype="multipart/form-data" data-loading>
        <input type="hidden" name="m_id" value="${AmemUpdate.m_id}">
        <input type="hidden" name="m_cre_sub" value="${AmemUpdate.m_cre_sub}">
        <table class="admin-form-table">
            <tr>
                <td colspan="2" class="img-cell">
                    <img src="/images/myProfile/${AmemUpdate.m_img}" alt="${AmemUpdate.m_img}" class="member-profile-img">
                </td>
            </tr>
            <tr><td class="label">아이디</td><td>${AmemUpdate.m_id}</td></tr>
            <tr>
                <td class="label">권한</td>
                <td>
                    <select name="m_authority">
                        <option value="USER">일반회원</option>
                        <option value="CREATOR">크리에이터</option>
                        <option value="BADMAN">불량회원</option>
                    </select>
                </td>
            </tr>
            <tr><td class="label">이름</td><td><input type="text" name="m_name" value="${AmemUpdate.m_name}"></td></tr>
            <tr><td class="label">자기소개</td><td><textarea name="m_introduce">${AmemUpdate.m_introduce}</textarea></td></tr>
            <tr><td class="label">프로필 사진</td><td><input type="file" name="m_upload"></td></tr>
        </table>
        <input type="submit" value="수정" class="btn-submit">
    </form>
</div>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>