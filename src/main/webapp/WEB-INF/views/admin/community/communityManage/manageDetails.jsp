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

        if (tab === "콘텐츠") {
            return KIBANA_HOST + "/app/dashboards#/view/" + DASHBOARD_ID_CONTENT + "?" + baseParams;
        }
        if (tab === "all") {
            return KIBANA_HOST + "/app/dashboards#/view/" + DASHBOARD_ID_GENERAL + "?" + baseParams;
        }
        if (tab === "QNA") {
            return KIBANA_HOST + "/app/dashboards#/view/" + DASHBOARD_ID_QNA + "?" + qnaParams;
        }
        if (tab === "라운지") {
            return KIBANA_HOST + "/app/dashboards#/view/" + DASHBOARD_ID_LOOUNGE + "?" + qnaParams;
        }

        var filter = encodeURIComponent(
            "(filters:!((meta:(alias:!n,disabled:!f,negate:!f),query:(match_phrase:(comm_type:'" + tab + "')))))"
        );
        return KIBANA_HOST + "/app/dashboards#/view/" + DASHBOARD_ID_GENERAL + "?" + baseParams + "&_a=" + filter;
    }

    // 로딩 타이머를 전역 변수로 관리하여 중첩 실행 방지
    let loadingTimer = null;

    function switchTab(tab, btnEl) {
        // 1. 버튼 활성화 상태 변경
        document.querySelectorAll('.tab-btn').forEach(function(b) { b.classList.remove('active'); });
        if (btnEl) btnEl.classList.add('active');

        // 2. 로딩 오버레이 강제 표시
        const overlay = document.getElementById('loadingOverlay');
        overlay.style.display = 'flex';

        // 3. 아이프레임 주소 변경 (데이터 로드 시작)
        document.getElementById('kibanaFrame').src = buildUrl(tab);
        
        // 4. 기존에 돌던 타이머가 있다면 취소
        if (loadingTimer) clearTimeout(loadingTimer);

        // 5. 2.5초(2500ms) 뒤에 로딩창 강제 숨김 (필요에 따라 시간 조절 가능)
        loadingTimer = setTimeout(function() {
            overlay.style.display = 'none';
        }, 2500);
    }

    // 이벤트 리스너 연결
    document.querySelectorAll('.tab-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            switchTab(this.dataset.tab, this);
        });
    });

    // 페이지 최초 진입 시 초기 탭 설정 및 실행
    var initialTab = "${empty param.comm_type ? 'all' : param.comm_type}";
    
    // 초기 진입 시에 해당하는 버튼 찾아 active 클래스 부여
    document.querySelectorAll('.tab-btn').forEach(function(btn) {
        if (btn.dataset.tab === initialTab || (initialTab === 'all' && btn.dataset.tab === 'all')) {
            btn.classList.add('active');
        } else {
            // Jsp 기본 렌더링에 따라 active가 다를 수 있으므로 매칭
            if ("${activeQnA}" && btn.dataset.tab === 'QNA') btn.classList.add('active');
            else if ("${activeLounge}" && btn.dataset.tab === '라운지') btn.classList.add('active');
            else if ("${activeContent}" && btn.dataset.tab === '콘텐츠') btn.classList.add('active');
        }
    });

    // 최초 로딩 실행
    switchTab(initialTab, null);
</script>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>