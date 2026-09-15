<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="com.springboot.meongnyang_Jiphapso.dto.DailycheckDTO" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>출석체크</title>
<style>
.dc-board-wrap {
    position: relative;
    width: 100%;
    max-width: 500px;
    margin: 0 auto;
}
.dc-board-bg {
    width: 100%;
    display: block;
}
.dc-calendar-overlay {
    position: absolute;
    left: 8.3%;
    right: 5.5%;
    top: 54.8%;
    bottom: 9.9%;
}
.dc-calendar {
    width: 100%;
    height: 100%;
    border-collapse: collapse;
    table-layout: fixed;
}
.dc-calendar th {
    color: #6a5fc1;
    font-size: 12px;
    font-weight: 600;
    height: 8%;
}
.dc-calendar td {
    position: relative;
    text-align: left;
    vertical-align: top;
    padding: 4px 6px;
    font-size: 12px;
    color: #2f2a6e;
}
.dc-stamp {
    position: absolute;
    top: 50%; left: 50%;
    transform: translate(-50%, -50%) rotate(-8deg);
    width: 55%;
    max-width: 40px;
    opacity: 0.9;
    pointer-events: none;
}
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
	<h3>2026년 9월 출석체크</h3>

	<div class="dc-board-wrap">
	<img src="/images/main/dailycheckboard.png" alt="출석체크판" class="dc-board-bg">

	<div class="dc-calendar-overlay">
	<%
	    DailycheckDTO myCheck = (DailycheckDTO) request.getAttribute("myCheck");

	    Calendar cal = Calendar.getInstance();
	    cal.set(Calendar.DAY_OF_MONTH, 1);
	    int firstDayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
	    int lastDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);

	    Set<Integer> checkedDays = new HashSet<>();
	    String raw = (myCheck != null) ? myCheck.getCh_checked_days() : null;
	    if (raw != null && !raw.isBlank()) {
	        for (String s : raw.split(",")) checkedDays.add(Integer.parseInt(s.trim()));
	    }
	%>
	<table class="dc-calendar">
	<tr><th>SUN</th><th>MON</th><th>TUE</th><th>WED</th><th>THU</th><th>FRI</th><th>SAT</th></tr>
	<tr>
	<%
	    int day = 1;
	    for (int i = 1; i < firstDayOfWeek; i++) { %>
	        <td></td>
	<%  }
	    while (day <= lastDay) {
	        int col = (firstDayOfWeek - 1 + day - 1) % 7;
	        if (col == 0 && day != 1) { %>
	</tr><tr>
	<%      }
	%>
	        <td>
	            <%= day %>
	            <% if (checkedDays.contains(day)) { %>
	                <img src="/images/main/check-stamp-navy.png" class="dc-stamp">
	            <% } %>
	        </td>
	<%      day++;
	    }
	%>
	</tr>
	</table>
	</div>
	</div>

	<c:choose>
		<c:when test="${empty myCheck}">
			<p>이번 달 출석 기록이 없습니다.</p>
		</c:when>
		<c:otherwise>
			<p>누적 출석일수: ${myCheck.ch_count}일</p>
			<p>마지막 출석일: <fmt:formatDate value="${myCheck.ch_end_date}" pattern="yyyy-MM-dd" /></p>
			<p>누적 포인트: ${myCheck.ch_point_quantity}P</p>
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