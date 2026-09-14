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
<style>
	#suggestions em{
		background: #ffff00;
		font-weight: bold;
	}
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
	<form name="memberSearch" id="memberSearchForm" method="get" action="/memSearchAjax" style="position:relative">
		<input type="text" name="keyword" id="keyword" autocomplete="on">
		<input type="submit" value="검색">
		<div id="suggestions" style="border:1px solid #cccccc;position:absolute;background:white;width:170px;z-index:10">
		</div>
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
		</tr>
		<tbody id="memberTableBody">
		<c:forEach var="list" items="${memberList}">
		<tr>
			<td><a href="/admin/mem/AmemDetail?m_id=${list.m_id}">${list.m_id}</a></td>
			<td>${list.m_name}</td> <!-- 부분 익명 처리 필요 -->
			<td>${list.m_email}</td>
			<td>${list.m_date}</td>
			<td>${list.m_age_upper}</td>
			<td>${list.m_sns}</td>
			<td>${list.m_authority}</td>
			<!-- 크리에이터 신청 시 승인/거절 버튼 생성 자리 -->
			<td>
				<a href="/AmemUpdateForm?m_id=${list.m_id}">수정</a>
			</td>
			<td>
				<a href="/AmemberDelete?m_id=${list.m_id}" onclick="return confirm('정말로 삭제하시겠습니까?\n삭제한 이후엔 회원 정보를 복구할 수 없습니다.');">삭제</button>
			</td>
		</tr>
		</c:forEach>
		</tbody>
	</table>
	<a href="/admin/adminPage">목록</a>
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
	</script>
</body>
</html>