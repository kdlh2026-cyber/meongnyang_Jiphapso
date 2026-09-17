<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
<link rel="stylesheet" href="/css/admin/admin-mem-detail.css">
</head>
<body>
<%@ include file="/WEB-INF/views/admin/clone/hamburger_menu.jsp" %>
<div class="admin-content-wrap">
    <h2>회원 상세정보</h2>
    <table class="member-detail-table">
        <tr>
            <td colspan="2" class="img-cell">
            <c:choose>
            <c:when test="${not empty memDetail.m_img}">
                <img src="/images/myProfile/${memDetail.m_img}" alt="${memDetail.m_img}" class="member-profile-img">
            </c:when>
            <c:otherwise>
            	<img src="/images/main/user_profile.png" alt="기본 프로필" class="member-profile-img">
            </c:otherwise>
            </c:choose>
            </td>
        </tr>
        <tr><td class="label">아이디</td><td>${memDetail.m_id}</td></tr>
        <tr><td class="label">권한</td><td>${memDetail.m_authority}</td></tr>
        <tr><td class="label">이름</td><td>${memDetail.m_name}</td></tr>
        <tr><td class="label">이메일</td><td>${memDetail.m_email}</td></tr>
        <tr><td class="label">자기소개</td><td>${memDetail.m_introduce}</td></tr>
        <tr><td class="label">생년월일</td><td><fmt:formatDate value="${memDetail.m_birth}" pattern="yyyy-MM-dd" /></td></tr>
        <tr><td class="label">SNS 수신 동의</td><td>${memDetail.m_sns}</td></tr>
    </table>
    <a href="/AmemUpdateForm?m_id=${memDetail.m_id}" class="btn-edit">회원 정보 수정</a>
</div>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>