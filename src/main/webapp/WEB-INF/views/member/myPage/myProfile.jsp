<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<table>
    <tr><td><img src="/images/myProfile/${myId.m_img}" alt="${myId.m_img}"></td></tr>
    <tr><td>${myId.m_id}</td></tr>
    <tr><td>${myId.m_name}</td></tr>
    <tr><td>${myId.m_email}</td></tr>
    <tr><td>${myId.m_introduce}</td></tr>
    <tr><td><fmt:formatDate value="${myId.m_birth}" pattern="yyyy-MM-dd" /></td></tr>
    <tr><td>SNS 수신 동의 여부: ${myId.m_sns}</td></tr>
</table>
<a href="/member/myPage/myProfileUpdateForm">회원 정보 수정</a><br>
<a href="/dailycheck">출석체크 페이지</a><br>
<c:if test="${myId.m_cre_sub == 'F'}">
	<a href="/creatorSubmit">크리에이터 신청</a>
</c:if>