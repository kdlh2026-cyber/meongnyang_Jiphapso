<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 게시글 관리 및 현황 파악</title>
<style>
    .dashboard-wrap { max-width: 1100px; margin: 30px auto; font-family: sans-serif; }

    .status-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
    .status-header h3 { margin: 0; }
    .status-header a { margin-left: 10px; font-size: 13px; color: #888; }
    .total-count { font-weight: bold; font-size: 16px; }

    .status-box {
        border: 1px solid #333; border-radius: 4px;
        display: flex; justify-content: space-around;
        padding: 30px 0; margin-bottom: 30px;
    }
    .status-item { text-align: center; }
    .status-item .label { margin-bottom: 10px; font-weight: bold; }
    .status-item .count { font-size: 40px; font-weight: bold; }

    .panel-row { display: flex; gap: 20px; }
    .panel { flex: 1; border: 1px solid #ccc; border-radius: 6px; padding: 15px; }
    .panel-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
    .panel-header h4 { margin: 0; }
    .panel-header a { font-size: 13px; color: #888; }

    .tab-group { display: flex; gap: 8px; margin-bottom: 12px; }
    .tab-btn {
        position: relative;
        padding: 6px 16px; border-radius: 20px; border: 1px solid #ccc;
        background: white; cursor: pointer; font-size: 14px;
    }
    .tab-btn.active { background: #ff7a00; color: white; border-color: #ff7a00; }

    .badge {
        position: absolute; top: -8px; right: -8px;
        background: #6a1bd1; color: white; border-radius: 50%;
        font-size: 11px; width: 18px; height: 18px;
        display: flex; align-items: center; justify-content: center;
    }

    table { width: 100%; border-collapse: collapse; font-size: 13px; }
    th { text-align: left; border-bottom: 2px solid #333; padding: 6px 4px; }
    td { border-bottom: 1px solid #eee; padding: 8px 4px; }

    .today-date { color: #ff5a1f; font-weight: bold; }

    .post-list { display: none; }
    .post-list.active { display: block; }
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>
	<div class="dashbord-wrap">
		<!-- 전체 게시글 등록 현황 -->
	    <div class="status-header">
	        <h3>전체 게시글 등록 현황</h3>
	        <a href="/admin/community/communityManage/manageDetails">세부 현황 →</a>
	        <span style="flex:1;"></span>
	        <span class="total-count">총 ${totalCount}개</span>
	    </div>
	
	    <div class="status-box">
	        <div class="status-item">
	            <div class="label">Q&amp;A</div>
	            <div class="count">${categoryCounts['Q&A']}개</div>
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

	
	 <div class="panel-row">

	     <!-- 게시글 관리 -->
	     <div class="panel">
	         <div class="panel-header">
	             <h4>게시글 관리</h4>
	             <a href="/community/commList">커뮤니티 바로가기</a>
	         </div>
	
	         <div class="tab-group">
	             <c:forEach var="type" items="['Q&A','라운지','콘텐츠']">
	             </c:forEach>
	
	             <button type="button" class="tab-btn manage-tab active" data-type="Q&amp;A" onclick="switchTab(this, 'manage')">
	                 Q&amp;A
	                 <c:if test="${todayCounts['Q&A'] > 0}"><span class="badge">${todayCounts['Q&A']}</span></c:if>
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
                <a href="/community/commList">커뮤니티 바로가기</a>
            </div>

            <div class="tab-group">
                <button type="button" class="tab-btn top-tab active" data-type="Q&amp;A" onclick="switchTab(this, 'top')">Q&amp;A</button>
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
                                <td>${item.comm_type}</td>
                                <td><a href="/community/commView?comm_no=${item.comm_no}">${item.comm_title}</a></td>
                                <td>${item.comm_writer}</td>
                                <td>${item.comm_good}</td>
                                <td>${item.comm_view}
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </c:forEach>
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