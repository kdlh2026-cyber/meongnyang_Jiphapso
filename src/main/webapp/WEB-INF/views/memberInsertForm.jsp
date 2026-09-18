<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>멍냥집합소</title>
<link rel="stylesheet" href="/css/etc/memberform.css">
<script src="/js/main/memberCheck.js"></script>
</head>
<body>
<%@ include file="/WEB-INF/views/loading_animal.jsp" %>
<%@ include file="hamburger_menu.jsp" %>

<div class="member-page">
	<div class="member-card">
		<h2>회원가입</h2>

		<form name="memberForm" method="post" action="/memberInsert" enctype="multipart/form-data" onsubmit="return mInsertcheck();" data-loading>

			<div class="field">
				<label>아이디 <span class="req">*</span></label>
				<div class="field-inline">
					<input type="text" name="m_id" id="m_id" onkeyup="document.getElementById('idCheckResult').innerText=''; window.isIdChecked=false;">
					<button type="button" class="btn-side" onclick="checkIdDuplicate();">중복확인</button>
				</div>
				<span id="idCheckResult" class="hint"></span>
			</div>

			<div class="field">
				<label>비밀번호 <span class="req">*</span></label>
				<input type="password" name="m_passwd">
			</div>

			<div class="field">
				<label>비밀번호 확인 <span class="req">*</span></label>
				<input type="password" name="m_passwd1">
			</div>

			<div class="field">
				<label>이름 <span class="req">*</span></label>
				<input type="text" name="m_name">
			</div>

			<div class="field">
				<label>전화번호 <span class="req">*</span></label>
				<input type="text" name="m_tel">
			</div>

			<div class="field">
				<label>주소 <span class="req">*</span></label>
				<div class="field-inline">
					<input type="text" name="m_addr" readonly>
					<button type="button" class="btn-side" onclick="goPopup();">주소검색</button>
				</div>
			</div>

			<div class="field">
				<label>상세주소 <span class="req">*</span></label>
				<input type="text" name="m_addr_detail">
			</div>

			<div class="field">
				<label>우편번호 <span class="req">*</span></label>
				<input type="text" name="m_zipno">
			</div>

			<div class="field">
				<label>이메일</label>
				<input type="text" name="m_email">
			</div>

			<div class="field">
				<label>간단소개</label>
				<textarea name="m_introduce" rows="4"></textarea>
			</div>

			<div class="field">
				<label>생년월일</label>
				<input type="date" name="m_birth">
			</div>

			<div class="field-checkbox">
				<label><input type="checkbox" name="m_age_upper"> 만 14세 이상</label>
			</div>

			<div class="field-checkbox">
				<label>
					<input type="checkbox" name="m_ser_agree" id="m_ser_agree">
					서비스 이용약관 동의 여부 <span class="req">*</span>
				</label>
				<a href="#" class="link-view" onclick="agreePopup('ToSPop'); return false;">약관 보기</a>
			</div>
			
			<div class="field-checkbox">
				<label>
					<input type="checkbox" name="m_pub_agree" id="m_pub_agree">
					회원 정보 수집 동의 여부 <span class="req">*</span>
				</label>
				<a href="#" class="link-view" onclick="agreePopup('PPPop'); return false;">약관 보기</a>
			</div>

			<div class="field-checkbox">
				<label><input type="checkbox" name="m_sns"> SNS 수신 동의 여부</label>
			</div>

			<div class="field">
				<label>프로필 사진</label>
				<input type="file" name="m_upload">
			</div>

			<button type="submit" class="btn-submit">회원가입</button>
		</form>

		<div class="helper-links">
			<a href="/loginForm">이미 계정이 있으신가요? 로그인</a>
		</div>
	</div>
</div>

<%@ include file="footer.jsp" %>
</body>
</html>