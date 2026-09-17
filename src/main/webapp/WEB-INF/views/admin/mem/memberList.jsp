<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
<link rel="stylesheet" href="/css/admin/admin-mem-list.css">
</head>
<body>
<%@ include file="/WEB-INF/views/admin/clone/hamburger_menu.jsp" %>
<div class="admin-content-wrap">
    <h2>회원 리스트</h2>

    <form name="memberSearch" id="memberSearchForm" method="get" action="/memSearchAjax" class="member-search-form">
        <input type="text" name="keyword" id="keyword" autocomplete="on">
        <input type="submit" value="검색">
        <div id="suggestions"></div>
    </form>

	<table>
		<tr>
			<th>아이디</th>
			<th>이름</th>
			<th>이메일 주소</th>
			<th>가입일</th>
			<th>14세 이상</th>
			<th>SNS 수신 동의</th>
			<th>회원 유형</th>
			<th>관리</th>
		</tr>
		<tbody id="memberTableBody">
		<c:forEach var="list" items="${memberList}">
		<tr>
			<td><a href="/admin/mem/AmemDetail?m_id=${list.m_id}">${list.m_id}</a></td>
			<td>
				<c:choose>
					<c:when test="${fn:length(list.m_name) >= 2}">
						<a href="/admin/mem/AmemDetail?m_id=${list.m_id}">${fn:substring(list.m_name, 0, 1)}*${fn:substring(list.m_name, 2, fn:length(list.m_name))}</a>
					</c:when>
					<c:otherwise><a href="/admin/mem/AmemDetail?m_id=${list.m_id}">${list.m_name}</a></c:otherwise>
				</c:choose>
			</td>
			<td>
				<c:set var="atIdx" value="${fn:indexOf(list.m_email, '@')}" />
				${fn:substring(list.m_email, 0, 3)}****${fn:substring(list.m_email, atIdx, -1)}
			</td>
			<td><fmt:formatDate value="${list.m_date}" pattern="yyyy년 MM월 dd일" /></td>
			<td>${list.m_age_upper}</td>
			<td>${list.m_sns}</td>
			<c:if test="${list.m_cre_sub == 'F' or list.m_cre_sub == 'T'}">
			    <td>${list.m_authority}</td>
			</c:if>
			<c:if test="${list.m_cre_sub == 'P'}">
			    <td>
			        <a href="/creatorApprove?m_id=${list.m_id}">수락</a>
			        <a href="/creatorRefuse?m_id=${list.m_id}">거절</a>
			    </td>
			</c:if>
			<td colspan="2">
				<a href="/AmemUpdateForm?m_id=${list.m_id}">수정</a>
				<a href="/AmemberDelete?m_id=${list.m_id}" onclick="return confirm('정말로 삭제하시겠습니까?\n삭제한 이후엔 회원 정보를 복구할 수 없습니다.');">삭제</button>
			</td>
		</tr>
		</c:forEach>
		</tbody>
	</table>
	    <a href="/admin/adminPage" class="btn-list">목록</a>
</div>
<%@ include file="/WEB-INF/views/footer.jsp" %>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
		// 자동완성
		$("#keyword").on("keyup", function(){
		    let q = $(this).val();

		    if(q.length < 1){
		        $("#suggestions").empty();
		        return;
		    }

		    $.ajax({
		        url: "/mem/mem_autocomplete",
		        data: { keyword: q },
		        success: function(list){
		            let html = "";
		            list.forEach(function(item){
		                html += "<div class='item'>" + item.highlight + "</div>";
		            });
		            $("#suggestions").html(html);
		        },
		        error: function(){
		            console.log("autocomplete error");
		        }
		    });
		});

		$(document).on("click",".item",function(){
		    $("#keyword").val($(this).text());
		    $("#suggestions").empty();
		});

		// 검색 폼: 페이지 이동 없이 AJAX로 처리
		$("#memberSearchForm").on("submit", function(e){
		    e.preventDefault();   // 기본 제출(페이지 이동) 막기

		    let keyword = $("#keyword").val();
		    $("#suggestions").empty();

		    $.ajax({
		        url: "/memSearchAjax",
		        data: { keyword: keyword },
		        success: function(list){
		            let rows = "";
		            list.forEach(function(m){
		                rows += "<tr>";
		                rows += "<td>" + m.m_id + "</td>";
		                rows += "<td>" + m.m_name + "</td>";
		                rows += "<td>" + m.m_email + "</td>";
		                rows += "<td>" + (m.m_date || "") + "</td>";
		                rows += "<td>" + m.m_age_upper + "</td>";
		                rows += "<td>" + m.m_sns + "</td>";
		                rows += "<td><button type='button' onclick='#'>삭제</button></td>";
		                rows += "</tr>";
		            });
		            $("#memberTableBody").html(rows);
		        },
		        error: function(){
		            console.log("search error");
		        }
		    });
		});
		function maskName(name) {
		    if (!name || name.length < 2) return name;
		    return name.charAt(0) + "*" + name.substring(2);
		}

		function maskEmail(email) {
		    if (!email || email.indexOf("@") === -1) return email;
		    let atIdx = email.indexOf("@");
		    return email.substring(0, 3) + "****" + email.substring(atIdx);
		}

		$("#memberSearchForm").on("submit", function(e){
		    e.preventDefault();

		    let keyword = $("#keyword").val().trim();
		    $("#suggestions").empty();

		    // 빈 검색어 처리
		    if (keyword === "") {
		        location.href = "/admin/mem/memberList";
		        return;
		    }

		    $.ajax({
		        url: "/memSearchAjax",
		        data: { keyword: keyword },
		        success: function(list){
		            let rows = "";
		            list.forEach(function(m){
		                rows += "<tr>";
		                rows += "<td><a href='/admin/mem/AmemDetail?m_id=" + m.m_id + "'>" + m.m_id + "</a></td>";
		                rows += "<td>" + maskName(m.m_name) + "</td>";
		                rows += "<td>" + maskEmail(m.m_email) + "</td>";
		                rows += "<td>" + (m.m_date || "") + "</td>";
		                rows += "<td>" + m.m_age_upper + "</td>";
		                rows += "<td>" + m.m_sns + "</td>";
		                rows += "<td>" + m.m_authority + "</td>";
		                rows += "<td><a href='/AmemUpdateForm?m_id=" + m.m_id + "'>수정</a></td>";
		                rows += "<td><a href='/AmemberDelete?m_id=" + m.m_id + "' onclick=\"return confirm('정말로 삭제하시겠습니까?\\n삭제한 이후엔 회원 정보를 복구할 수 없습니다.');\">삭제</a></td>";
		                rows += "</tr>";
		            });
		            $("#memberTableBody").html(rows);
		        },
		        error: function(){
		            console.log("search error");
		        }
		    });
		});
	</script>
</body>
</html>