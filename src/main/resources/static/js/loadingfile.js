// common/loadingfile.js
// 모든 페이지에 공통 로드
document.addEventListener('DOMContentLoaded', function() {
  const overlay = document.getElementById('pageLoadingOverlay');
  const WAIT_MS = 1000; // 로딩화면 보여주고 3초 뒤 실제 이동

  // data-loading 속성 붙은 링크 클릭 시: 바로 이동하지 않고 로딩화면을 WAIT_MS만큼 보여준 뒤 이동
  document.addEventListener('click', function(e) {
    const link = e.target.closest('a[data-loading]');
    if (!link) return;
    e.preventDefault();
    overlay.style.display = 'flex';
    setTimeout(function() {
      window.location.href = link.href;
    }, WAIT_MS);
  });

  // data-loading 속성 붙은 폼 제출 시: 바로 제출하지 않고 로딩화면을 WAIT_MS만큼 보여준 뒤 실제 제출
  document.addEventListener('submit', function(e) {
    const form = e.target;
    if (!form.matches('form[data-loading]')) return;
    if (form.dataset.loadingDone) return; // 이미 지연을 거쳐 실제 제출하는 경우는 그냥 통과

    e.preventDefault();
    overlay.style.display = 'flex';
    setTimeout(function() {
      form.dataset.loadingDone = 'true';
      form.submit(); // 이벤트 리스너를 다시 타지 않으므로 무한루프 없음
    }, WAIT_MS);
  });

  // jQuery ajax 등에서 직접 제어할 때 (예: showLoading(); $.ajax({ complete: hideLoading });)
  window.showLoading = function() { overlay.style.display = 'flex'; };
  window.hideLoading = function() { overlay.style.display = 'none'; };
});