<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>출석체크</title>
<style>
  body{ margin:0; font-family:sans-serif; text-align:center; background:#fff8ec; }
  .dc-wrap{ padding:24px; }
  .dc-img{ width:100%; max-width:280px; margin-bottom:8px; }
  .dc-btn-main, .dc-btn-sub{
    display:block; width:85%; margin:8px auto; padding:12px;
    border:none; border-radius:10px; cursor:pointer; font-size:15px;
  }
  .dc-btn-main{ background:#5b5fa6; color:#fff; }
  .dc-btn-sub{ background:#eee; color:#555; }
  .dc-info{ font-size:14px; margin:10px 0; min-height:20px; }
</style>
</head>
<body>
<div class="dc-wrap">
  <img src="/images/main/dailycheckboard.png" alt="출석체크" class="dc-img">
  <h3>오늘의 출석체크</h3>
  <p class="dc-info" id="dc-info">아래 버튼으로 출석체크를 진행해주세요.</p>

  <button type="button" class="dc-btn-main" onclick="doCheck()">출석체크 하기</button>
  <button type="button" class="dc-btn-sub" onclick="goPage()">출석체크 페이지로 이동</button>
</div>

<script>
function doCheck() {
    var info = document.getElementById("dc-info");

    fetch("/dailycheckDo", { method: "POST" })
        .then(function (res) { return res.text(); })
        .then(function (result) {
            if (result === "success") {
                info.innerText = "출석체크가 완료되었습니다!";
                if (window.opener && !window.opener.closed) {
                    var today = new Date().toISOString().slice(0, 10);
                    var key = window.opener.DC_STORAGE_KEY || "dailycheckDismissed";
                    window.opener.localStorage.setItem(key, today);
                    window.opener.location.reload();
                }
                setTimeout(function () { window.close(); }, 1200);
            } else if (result === "already") {
                info.innerText = "오늘은 이미 출석체크를 완료했습니다.";
            } else {
                info.innerText = "출석체크 중 오류가 발생했습니다.";
            }
        });
}

function goPage() {
    if (window.opener && !window.opener.closed) {
        window.opener.location.href = "/dailycheck";
        window.opener.focus();
    } else {
        window.location.href = "/dailycheck";
    }
    window.close();
}
</script>
</body>
</html>