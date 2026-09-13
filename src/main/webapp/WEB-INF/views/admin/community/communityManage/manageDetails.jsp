<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 - 커뮤니티 세부 현황</title>
<!-- Chart.js CDN -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
    body { background-color: #f8f9fa; font-family: 'Noto Sans KR', sans-serif; margin: 0; padding: 20px; }
    .dashboard-wrapper { max-width: 1200px; margin: 0 auto; }
    
    .header-section { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; border-bottom: 2px solid #ddd; padding-bottom: 15px; }
    .tab-menu a { font-size: 24px; font-weight: bold; text-decoration: none; color: #bbb; margin-right: 20px; }
    .tab-menu a.active { color: #ff7a00; border-bottom: 3px solid #ff7a00; padding-bottom: 10px; }
    .back-btn { text-decoration: none; color: #333; font-weight: 600; background: #fff; padding: 8px 15px; border: 1px solid #ccc; border-radius: 5px; }

    .row { display: flex; gap: 20px; margin-bottom: 20px; }
    .card { background: #fff; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); padding: 20px; flex: 1; box-sizing: border-box; }
    .card h3 { font-size: 16px; color: #555; margin-top: 0; margin-bottom: 15px; }
    
    .big-number { font-size: 38px; font-weight: bold; color: #222; text-align: center; margin: 10px 0 20px 0; }
    .sub-title { font-size: 13px; color: #777; margin-bottom: 8px; display: flex; justify-content: space-between; }
    
    .pet-bar-container { display: flex; height: 25px; border-radius: 4px; overflow: hidden; border: 1px solid #ccc; margin-top: 5px; }
    .pet-bar-item { display: flex; align-items: center; justify-content: center; font-size: 11px; color: #fff; font-weight: bold; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }

    .bottom-section { background-color: #e9ecef; border-radius: 8px; padding: 25px; margin-top: 20px; box-shadow: inset 0 2px 4px rgba(0,0,0,0.03); }
    .tag-card-wrapper { display: flex; gap: 15px; justify-content: space-between; }
    .tag-card { background: #fff; border: 1px solid #ccc; border-radius: 6px; padding: 15px; flex: 1; text-align: center; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
    .tag-rank { font-size: 12px; color: #888; font-weight: bold; margin-bottom: 5px; }
    .tag-name { font-size: 18px; font-weight: bold; color: #333; margin: 8px 0; }
    .tag-count { font-size: 13px; color: #555; }
</style>
</head>
<body>
<div class="dashboard-wrapper">

    <!-- 상단 탭 -->
  	<div class="header-section">
        <div class="tab-menu">
            <a href="${pageContext.request.contextPath}/admin/community/communityManage/manageDetails?comm_type=Q%26A" class="${activeQnA}">Q&A</a>
            <a href="${pageContext.request.contextPath}/admin/community/communityManage/manageDetails?comm_type=라운지" class="${activeLounge}">라운지</a>
            <a href="${pageContext.request.contextPath}/admin/community/communityManage/manageDetails?comm_type=콘텐츠" class="${activeContent}">콘텐츠</a>
        </div>
        <a href="${pageContext.request.contextPath}/admin/communityManage" class="back-btn">← 게시글 관리로 이동</a>
    </div>

    <!-- 1단: 총 개수 & 펫 유형 비율 바 + 월별 막대 그래프 -->
    <div class="row">
        <div class="card" style="flex: 0.9; display: flex; flex-direction: column; justify-content: space-between;">
            <div>
                <h3>게시글 총 개수</h3>
                <div class="big-number">${totalCount}개</div>
            </div>
            <div>
                <div class="sub-title">
                    <span>펫 유형별 게시글 비율</span>
                    <span style="font-size: 11px;">(강아지, 고양이, 소동물, 기타)</span>
                </div>
                <div class="pet-bar-container">
                    <c:forEach var="pet" items="${petRatioList}">
                        <div class="pet-bar-item" 
                             style="width: ${pet.PERCENT}%; background-color: ${pet.COLOR};" 
                             title="${pet.PET_NAME}: ${pet.COUNT}개 (${pet.PERCENT}%)">
                             <c:if test="${pet.PERCENT >= 10}">
                                 ${pet.PET_NAME} 
                             </c:if>
                             ${pet.PERCENT}%
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
        <div class="card" style="flex: 1.5;">
            <h3>월별 게시글 등록 현황</h3>
            <canvas id="monthlyChart" height="95"></canvas>
        </div>
    </div>

    <!-- 2단: 반응 비율 & Q&A 해결 현황 도넛/파이 차트 -->
    <div class="row">
        <div class="card">
            <h3>도움돼요 VS 글쎄요 반응 비율</h3>
            <div style="width: 210px; margin: 0 auto;">
                <canvas id="reactionChart"></canvas>
            </div>
        </div>
        <div class="card">
            <h3>Q&A 해결 현황 (채택률)</h3>
            <div style="width: 210px; margin: 0 auto;">
                <canvas id="qnaStatusChart"></canvas>
            </div>
        </div>
    </div>

    <!-- 3단: 하단 태그 Top 5 카드 배율 -->
    <div class="bottom-section">
        <h3 style="margin-top: 0; color: #444; margin-bottom: 15px;">사용된 태그 현황 (Top 5)</h3>
        <div class="tag-card-wrapper">
            <c:choose>
                <c:when test="${not empty tagRankList}">
                    <c:forEach var="tag" items="${tagRankList}" varStatus="status">
                        <div class="tag-card">
                            <div class="tag-rank">${status.index + 1}</div>
                            <div class="tag-name">#${tag.TAG_NAME}</div>
                            <div class="tag-count">${tag.TAG_COUNT}회</div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div style="width: 100%; text-align: center; color: #777; padding: 20px;">등록된 태그 데이터가 없습니다.</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

</div>

<script>
    // 1. 월별 게시글 등록 현황 (Controller에서 넘긴 데이터 배열 매핑)
    const monthlyData = [
        <c:forEach var="cnt" items="${monthlyCounts}" varStatus="status">
            ${cnt}<C:if test="${!status.last}">,</C:if>
        </c:forEach>
    ];

    const monthlyCtx = document.getElementById('monthlyChart').getContext('2d');
    new Chart(monthlyCtx, {
        type: 'bar',
        data: {
            labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
            datasets: [{
                label: '등록 수',
                data: monthlyData,
                backgroundColor: 'rgba(255, 122, 0, 0.6)',
                borderColor: 'rgba(255, 122, 0, 1)',
                borderWidth: 1
            }]
        },
        options: { responsive: true, scales: { y: { beginAtZero: true } } }
    });

    // 2. 도움돼요 vs 글쎄요 비율
    const reactionCtx = document.getElementById('reactionChart').getContext('2d');
    new Chart(reactionCtx, {
        type: 'doughnut',
        data: {
            labels: ['도움돼요', '글쎄요'],
            datasets: [{
                data: [ ${reactionRatio.HELPFUL}, ${reactionRatio.USELESS} ], 
                backgroundColor: ['#36a2eb', '#ff6384']
            }]
        }
    });

    // 3. Q&A 해결 현황
    const qnaStatusCtx = document.getElementById('qnaStatusChart').getContext('2d');
    new Chart(qnaStatusCtx, {
        type: 'pie',
        data: {
            labels: ['해결(채택완료)', '미해결'],
            datasets: [{
                data: [ ${qnaStatusRatio.RESOLVED}, ${qnaStatusRatio.UNRESOLVED} ], 
                backgroundColor: ['#4bc0c0', '#ff9f40']
            }]
        }
    });
</script>

</body>
</html>