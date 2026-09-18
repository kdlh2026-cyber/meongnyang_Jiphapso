<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 - 게시글 상세 현황</title>
<link rel="stylesheet" href="/css/community/communityDetailSearch.css">
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>

<div class="dashboard-wrapper">

	<!-- 전체 게시글 등록 현황 -->
    <div class="status-header">
        <div class="status-header-left">
            <h3>게시글 세부 현황</h3>
        </div>
        
        <div class="status-header-right">
            <a href="/admin/communityManage" class="move-btn">게시글 관리로 이동</a>
        </div>
    </div>

    <!-- ⭐️ 좌우 배치를 위한 감싸는 영역 추가 -->
    <div class="dashboard-content-area">
        <div class="side-tab">
            <button type="button" class="tab-btn ${activeQnA == '' && activeLounge == '' && activeContent == '' ? 'active' : ''}" data-tab="all">전체</button>
            <button type="button" class="tab-btn ${activeQnA}" data-tab="QNA">Q&amp;A</button>
            <button type="button" class="tab-btn ${activeLounge}" data-tab="라운지">라운지</button>
            <button type="button" class="tab-btn ${activeContent}" data-tab="콘텐츠">콘텐츠</button>
        </div>

        <div class="kibana-area">
            <div class="loading-overlay" id="loadingOverlay">불러오는 중...</div>
            <iframe id="kibanaFrame" src="" onload="hideLoading()"></iframe>
        </div>
    </div>

</div>

<script>
    const KIBANA_HOST = "http://192.168.10.107:5601";
    const DASHBOARD_ID_GENERAL = "26efc4f0-b2f7-11f1-b97f-73e15fe45a55";
    const DASHBOARD_ID_QNA = "2b6d0650-b310-11f1-b97f-73e15fe45a55";
    const DASHBOARD_ID_LOOUNGE = "865e61d0-b31a-11f1-b97f-73e15fe45a55";
    const DASHBOARD_ID_CONTENT = "18b76a20-b313-11f1-b97f-73e15fe45a55";

    function buildUrl(tab) {
        var baseParams = "embed=true&_g=(filters:!(),refreshInterval:(pause:!f,value:10000),time:(from:'2000-01-01T00:00:00.000Z',to:now))";
        var qnaParams = "embed=true&_g=(filters:!(),refreshInterval:(pause:!f,value:10000),time:(from:now-1M,to:now))";
        var loungeParams = "embed=true&_g=(filters:!(),refreshInterval:(pause:!f,value:10000),time:(from:now-1M,to:now))";

        if (tab === "콘텐츠") {
            return KIBANA_HOST + "/app/dashboards#/view/" + DASHBOARD_ID_CONTENT + "?" + baseParams;
        }
        if (tab === "all") {
            return KIBANA_HOST + "/app/dashboards#/view/" + DASHBOARD_ID_GENERAL + "?" + baseParams;
        }
        if(tab === "QNA"){
        	return KIBANA_HOST + "/app/dashboards#/view/" + DASHBOARD_ID_QNA + "?" + qnaParams;
        }
        if(tab === "라운지"){
        	return KIBANA_HOST + "/app/dashboards#/view/" + DASHBOARD_ID_LOOUNGE + "?" + loungeParams;
        }

        var filter = encodeURIComponent(
            "(filters:!((meta:(alias:!n,disabled:!f,negate:!f),query:(match_phrase:(comm_type:'" + tab + "')))))"
        );
        return KIBANA_HOST + "/app/dashboards#/view/" + DASHBOARD_ID_GENERAL + "?" + baseParams + "&_a=" + filter;
    }

    function switchTab(tab, btnEl) {
        document.querySelectorAll('.tab-btn').forEach(function(b) { b.classList.remove('active'); });
        btnEl.classList.add('active');
        document.getElementById('loadingOverlay').style.display = 'flex';
        document.getElementById('kibanaFrame').src = buildUrl(tab);
    }

    function hideLoading() {
        document.getElementById('loadingOverlay').style.display = 'none';
    }

    document.querySelectorAll('.tab-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            switchTab(this.dataset.tab, this);
        });
    });

    var initialTab = "${empty param.comm_type ? 'all' : param.comm_type}";
    document.getElementById('kibanaFrame').src = buildUrl(initialTab);
</script>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>