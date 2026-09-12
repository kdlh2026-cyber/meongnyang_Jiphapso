<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>출석체크</title>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
	<h3>2026년 9월 출석체크</h3>

	<c:choose>
		<c:when test="${empty myCheck}">
			<p>이번 달 출석 기록이 없습니다.</p>
		</c:when>
		<c:otherwise>
			<p>누적 출석일수: ${myCheck.ch_count}일</p>
			<p>마지막 출석일: <fmt:formatDate value="${myCheck.ch_end_date}" pattern="yyyy-MM-dd" /></p>
			<p>누적 포인트: ${myCheck.ch_point_quentity}P</p>
		</c:otherwise>
	</c:choose>

	<button type="button" id="checkBtn" onclick="doCheck()">출석체크 하기</button>

<%@ include file="/WEB-INF/views/footer.jsp" %>
<script>
function doCheck() {
    fetch("/dailycheckDo", { method: "POST" })
        .then(function(res) { return res.text(); })
        .then(function(result) {
            if (result === "success") {
                alert("출석체크가 완료되었습니다!");
                location.reload();
            } else if (result === "already") {
                alert("오늘은 이미 출석체크를 완료했습니다.");
            } else {
                alert("출석체크 중 오류가 발생했습니다.");
            }
        });
}
</script>
</body>
</html>