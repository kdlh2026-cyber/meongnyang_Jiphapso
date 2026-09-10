<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>멍냥집합소</title>
</head>
<body>
<%@ include file="hamburger_menu.jsp" %>
	<h1>메인페이지</h1>
	
	<!-- 비회원 영역 -->
	<sec:authorize access="isAnonymous()">
	<img src="/images/image.png" width="300px" height="auto"/><br>
	</sec:authorize>
	
	<!-- 일반 회원 영역 -->
	<sec:authorize access="hasRole('USER')">
			회원님, 환영합니다.<br>
	</sec:authorize>
	
	<!-- 관리자 영역 -->
	<sec:authorize access="hasRole('ADMIN')">
		관리자님, 환영합니다.<br>
		<a href="/productWriteForm">상품등록</a><br>
		<a href="/productList">상품리스트</a>
	</sec:authorize>
	
<!-- 공통 표시 영역 -->
	
	<!-- 통합 검색창(커뮤니티+상품) -->
		<form name="allSearch" type="get" action="/allSearch" style="position:relative">
			<p><input type="text" name="keyword" id="keyword" autocomplete="off">
			<input type="submit" value="통합검색">
			<div id="suggestions" style="border:1px solid #cccccc;position:absolute;background:white;width:170px;z-index:10">
			</div>
		</form>
		
	<!-- 광고바 삽입 영역 -->
	
	<!-- 추천 콘텐츠 표시 영역 -->
	
	<!-- 추천 상품 표시 영역 -->
	
<%@ include file="footer.jsp" %>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
		$("#keyword").on("keyup", function(){
		    let q = $(this).val();
		
		    if(q.length < 1){
		        $("#suggestions").empty();
		        return;
		    }
		
		    $.ajax({
		        url: "/main_autocomplete",
		        data: { keyword: q },
		        success: function(list){
		            let html = "";
		            list.forEach(function(item){
		                // highlight 필드 사용
		                html += "<div class='item'>" + item.highlight + "</div>";
		            });
		            $("#suggestions").html(html);
		        },
		        error: function(){
		            console.log("autocomplete error");
		        }
		    });
		});
		
		// 추천어 클릭 시 검색창에 채움
		$(document).on("click",".item",function(){
		    // <em> 태그 제거 후 input에 넣기
		    $("#keyword").val($(this).text());
		    $("#suggestions").empty();
		});
	</script>
</body>
</html>