<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 게시글 관리 및 현황 파악</title>
<link rel="stylesheet" href="/css/community/communityManage.css">
</head>
<body>
<%@ include file="/WEB-INF/views/admin/clone/hamburger_menu.jsp" %>
	<div class="dashboard-wrap">
		<!-- 전체 게시글 등록 현황 -->
	    <div class="status-header">
	        <div class="status-header-left">
	            <h3>전체 게시글 등록 현황</h3>
	            <span class="total-count">총 ${totalCount}개</span>
	        </div>
	        <!-- 세부 현황 ken 게시글 관리로 이동 botón nga agkatidag iti kanawan -->
	        <div class="status-header-right">
	            <a href="/admin/communityUpdate" class="move-btn">게시글 관리로 이동</a>
	            <a href="/admin/community/communityManage/manageDetails" class="detail-link-btn">세부 현황 보러가기</a>
	        </div>
	    </div>
	
	    <div class="status-box">
	        <div class="status-item">
	            <div class="label">Q&amp;A</div>
	            <div class="count">${categoryCounts['QNA']}개</div>
	        </div>
	        <div class="status-item">
	            <div class="label">라운지</div>
	            <div class="count">${categoryCounts['라운지']}개</div>
	        </div>
	        <div class="status-item">
	            <div class="label">콘텐츠</div>
	            <div class="count">${categoryCounts['콘텐츠']}개</div>
	        </div>
	    </div>

	    <!-- Pannakaisina ti sona babaen ti linia -->
	    <hr class="section-divider">      		
	    
	    <div class="panel-row">
	     <!-- 게시글 관리 -->
	     <div class="panel">
	         <div class="panel-header">
	             <h4>게시글 등록 현황</h4>
	         </div>
	
	         <div class="tab-group">
	             <button type="button" class="tab-btn manage-tab active" data-type="QNA" onclick="switchTab(this, 'manage')">
	                 Q&amp;A
	                 <c:if test="${todayCounts['QNA'] > 0}"><span class="badge">${todayCounts['QNA']}</span></c:if>
	             </button>
	             <button type="button" class="tab-btn manage-tab" data-type="라운지" onclick="switchTab(this, 'manage')">
	                 라운지
	                 <c:if test="${todayCounts['라운지'] > 0}"><span class="badge">${todayCounts['라운지']}</span></c:if>
	             </button>
	             <button type="button" class="tab-btn manage-tab" data-type="콘텐츠" onclick="switchTab(this, 'manage')">
	                 콘텐츠
	                 <c:if test="${todayCounts['콘텐츠'] > 0}"><span class="badge">${todayCounts['콘텐츠']}</span></c:if>
	             </button>
	         </div>
	
	         <c:forEach var="type" items="${commTypes}" varStatus="st">
	             <div class="post-list manage-list ${st.index == 0 ? 'active' : ''}" data-type="${type}">
	                 <table>
	                     <tr>
	                     	<th>작성일</th>
	                     	<th>게시글 제목</th>
	                     	<th>작성자</th>
	                     </tr>
	                     <c:forEach var="item" items="${latestByType[type]}">
	                         <fmt:formatDate value="${item.comm_date}" pattern="yyyy-MM-dd" var="itemDateStr" />
	                         <tr>
	                             <td class="${itemDateStr eq todayStr ? 'today-date' : ''}">${itemDateStr}</td>
	                             <td><a href="/community/commView?comm_no=${item.comm_no}">${item.comm_title}</a></td>
	                             <td>${item.comm_writer}</td>
	                         </tr>
	                     </c:forEach>
	                 </table>
	             </div>
	         </c:forEach>
	     </div>

        <!-- 인기 top10 -->
        <div class="panel">
            <div class="panel-header">
                <h4>인기 top10</h4>
            </div>

            <div class="tab-group">
                <button type="button" class="tab-btn top-tab active" data-type="QNA" onclick="switchTab(this, 'top')">Q&amp;A</button>
                <button type="button" class="tab-btn top-tab" data-type="라운지" onclick="switchTab(this, 'top')">라운지</button>
                <button type="button" class="tab-btn top-tab" data-type="콘텐츠" onclick="switchTab(this, 'top')">콘텐츠</button>
            </div>

            <c:forEach var="type" items="${commTypes}" varStatus="st">
                <div class="post-list top-list ${st.index == 0 ? 'active' : ''}" data-type="${type}">
                    <table>
                        <tr>
                        	<th>카테고리</th>
                        	<th>게시글 제목</th>
                        	<th>작성자</th>
                        	<th>도움돼요</th>
                        	<th>조회수</th>
                        </tr>
                        <c:forEach var="item" items="${topByType[type]}">
                            <tr>
                                <td>${item.comm_type == 'QNA' ? 'Q&amp;A' : item.comm_type}</td>
                                <td><a href="/community/commView?comm_no=${item.comm_no}">${item.comm_title}</a></td>
                                <td>${item.comm_writer}</td>
                                <td>${item.comm_good}</td>
                                <td>${item.comm_view}</td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </c:forEach>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
<script>
function switchTab(button, group) {
    const type = button.getAttribute('data-type');

    document.querySelectorAll('.' + group + '-tab').forEach(btn => btn.classList.remove('active'));
    button.classList.add('active');

    document.querySelectorAll('.' + group + '-list').forEach(list => {
        list.classList.toggle('active', list.getAttribute('data-type') === type);
    });
}
</script>
</html>