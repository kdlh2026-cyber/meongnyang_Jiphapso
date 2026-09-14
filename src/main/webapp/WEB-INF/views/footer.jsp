<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<style>
	  .footer-links{
    display:flex; flex-wrap:wrap;
    gap:6px 14px;
  }
  .footer-links a{
    font-size:12.5px;
    color:#8b8b8b;
    text-decoration:none;
  }
  .footer-links a:hover{ color:#1c1c1c; }
</style>
<footer>
<%@ include file="/WEB-INF/views/member/dailycheck/dailycheck_popup.jsp" %>
<hr>
	<div class="footer-links">
        <a href="#">고객센터</a> <!-- 챗봇 API -->
        <a href="/guest/etc/companyIntroduce">회사소개</a>
        <a href="/guest/etc/ToS">이용약관</a>
        <a href="/guest/etc/privacyPolicy">개인정보처리방침</a>
      </div>
    <div style="font-size: 14px; color: #767676; margin-top: 10px; margin-bottom: 15px; text-align: left;">
    	상호 KDLH프로젝트팀(숯)|부산광역시 부산진구 중앙대로 627 삼비빌딩 12층 제2강의실<br>
    	사업자번호 Это итоговый | 통신판매업번호 проект | KDLHproject@thanks.com
    </div>
    <div style="font-size: 11px; color: #767676; margin-top: 10px; margin-bottom: 15px; text-align: left;">
    	&copy; This page is a practice page.
    </div>
</footer>