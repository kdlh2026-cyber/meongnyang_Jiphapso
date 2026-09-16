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
    * { box-sizing: border-box; }
    body { margin: 0; font-family: "Noto Sans KR", "Malgun Gothic", sans-serif; background: #fff; color: #4A3226; }

    .dc-wrap {
        max-width: 640px;
        margin: 0 auto;
        padding: 24px 20px 60px;
        text-align: center;
    }

    .dc-title {
        font-size: 20px;
        font-weight: 700;
        color: #4A3226;
        margin: 0 0 24px;
    }

    /* ===== 출석체크판 ===== */
    .dc-board-wrap {
        position: relative;
        width: 100%;
        max-width: 640px;
        margin: 0 auto 28px;
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
        font-size: 14px;
        font-weight: 700;
        height: 8%;
    }
    .dc-calendar td {
        position: relative;
        text-align: left;
        vertical-align: top;
        padding: 6px 8px;
        font-size: 14px;
        color: #2f2a6e;
    }
    .dc-stamp {
        position: absolute;
        top: 50%; left: 50%;
        transform: translate(-50%, -50%) rotate(-8deg);
        width: 60%;
        max-width: 52px;
        opacity: 0.9;
        pointer-events: none;
    }

    /* ===== 출석 정보 카드 ===== */
    .dc-info-card {
        max-width: 420px;
        margin: 0 auto 28px;
        padding: 22px 24px;
        background: #FFFBF5;
        border: 1px solid #FFF3D8;
        border-radius: 20px;
    }
    .dc-info-empty {
        font-size: 14px;
        color: #9c8a7c;
        margin: 0;
    }
    .dc-info-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 8px 0;
        font-size: 14px;
        color: #4A3226;
    }
    .dc-info-row + .dc-info-row {
        border-top: 1px solid #FFF3D8;
    }
    .dc-info-label {
        font-weight: 700;
        color: #4A3226;
    }
    .dc-info-value {
        color: #4A3226;
    }
    .dc-info-value--point {
        font-weight: 700;
        color: #b0821a;
    }

    /* ===== 출석체크 버튼 ===== */
    .dc-check-btn {
        display: inline-block;
        padding: 13px 40px;
        border: none;
        border-radius: 999px;
        background: #FDCC61;
        color: #4A3226;
        font-size: 15px;
        font-weight: 700;
        cursor: pointer;
    }
    .dc-check-btn:hover {
        background: #FDA58F;
        color: #FFFBF5;
    }
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>

<div class="dc-wrap">
    <h3 class="dc-title">2026년 9월 출석체크</h3>

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

    <div class="dc-info-card">
        <c:choose>
            <c:when test="${empty myCheck}">
                <p class="dc-info-empty">이번 달 출석 기록이 없습니다.</p>
            </c:when>
            <c:otherwise>
                <div class="dc-info-row">
                    <span class="dc-info-label">누적 출석일수</span>
                    <span class="dc-info-value">${myCheck.ch_count}일</span>
                </div>
                <div class="dc-info-row">
                    <span class="dc-info-label">마지막 출석일</span>
                    <span class="dc-info-value"><fmt:formatDate value="${myCheck.ch_end_date}" pattern="yyyy-MM-dd" /></span>
                </div>
                <div class="dc-info-row">
                    <span class="dc-info-label">누적 포인트</span>
                    <span class="dc-info-value dc-info-value--point">${myCheck.ch_point_quantity}P</span>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <button type="button" class="dc-check-btn" id="checkBtn" onclick="doCheck()">출석체크 하기</button>
</div>

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