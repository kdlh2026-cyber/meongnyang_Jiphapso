<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<style>
.image img {
		width: 80%;
		height: auto;
		max-width: 180px;
	}
</style>
<meta charset="UTF-8">
<title>상품</title>
</head>
<body>
	<h3>상품리스트</h3>
	<form name="search" method="get" action="/search" style="position:relative;">
		<input type="text" name="keyword" id="keyword" autocomplete="off">
		<input type="submit" value="검색">
		<div id="suggestions" style="border:1px solid #cccccc;position:absolute;background:white;width:170px;z-index:10">
		</div>
	</form>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
		$("#keyword").on("keyup", function(){
		    let q = $(this).val();
		
		    if(q.length < 1){
		        $("#suggestions").empty();
		        return;
		    }
		
		    $.ajax({
		        url: "/autocomplete",
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
	<table border="1">
		<tr>	
			<c:forEach var="list" items="${ShoppingList}" varStatus="status">
				<td>
				<div class="image"><img src="${pageContext.request.contextPath}/images/products/main/${list.omainimg}"></div>
				<div>${list.pbrand}</div>
				<div><a href="/products/ShoppingView?p_no=${list.pno}">${list.ptitle}</a></div>
				<div>판매가
					<fmt:formatNumber value="${list.oprice}" />원
				</div>
				</td>
			<c:if test="${status.count%4==0}">
				<tr></tr>
			</c:if>
			</c:forEach>
		</tr>
	</table>
<div>
	<a href="javascript:history.back();">뒤로가기</a>
</div>
</body>
</html>