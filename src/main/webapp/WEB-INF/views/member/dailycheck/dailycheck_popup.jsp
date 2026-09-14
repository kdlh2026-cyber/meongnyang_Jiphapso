<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<sec:authorize access="hasAnyRole('USER','CREATOR')">
<div id="dailycheckModal" class="dc-overlay">
  <div class="dc-box">
    <img src="/images/main/dailycheckboard.png" alt="출석체크" class="dc-img">
    <h3>오늘의 출석체크</h3>
    <p id="dailycheckInfo"></p>
    <button type="button" class="dc-btn-main" onclick="doDailyCheck()">출석체크 하기</button>
    <button type="button" class="dc-btn-sub" onclick="closeModal('dailycheckModal')">나중에</button>
  </div>
</div>

<div id="dailycheckResultModal" class="dc-overlay">
  <div class="dc-box">
    <img id="dc-result-img" src="/images/main/dailycheckboard.png" alt="결과" class="dc-img">
    <p id="dc-result-text" class="dc-result-text"></p>
    <button type="button" class="dc-btn-main" onclick="closeModal('dailycheckResultModal')">확인</button>
  </div>
</div>

<style>
.dc-overlay{
  display:none; position:fixed; top:0; left:0; width:100%; height:100%;
  background:rgba(0,0,0,0.5); z-index:9999;
}
.dc-box{
  background:#fff8ec; width:600px; margin:100px auto; padding:24px;
  border-radius:20px; text-align:center; box-shadow:0 8px 20px rgba(0,0,0,0.15);
}
.dc-img{ width:500px; margin-bottom:8px; }
.dc-result-text{ font-size:15px; margin:12px 0; }
.dc-btn-main{
  background:#5b5fa6; color:#fff; border:none; border-radius:10px;
  padding:10px 18px; margin:4px; cursor:pointer;
}
.dc-btn-sub{
  background:#eee; color:#555; border:none; border-radius:10px;
  padding:10px 18px; margin:4px; cursor:pointer;
}
</style>

<script>
document.addEventListener("DOMContentLoaded", function () {
    fetch("/dailycheckStatus")
        .then(function (res) { return res.json(); })
        .then(function (data) {
            if (data.needCheck) {
                document.getElementById("dailycheckInfo").innerText =
                    "누적 출석일수: " + data.ch_count + "일 / 누적 포인트: " + data.ch_point_quentity + "P";
                document.getElementById("dailycheckModal").style.display = "block";
            }
        });
});

function doDailyCheck() {
    fetch("/dailycheckDo", { method: "POST" })
        .then(function (res) { return res.text(); })
        .then(function (result) {
            closeModal('dailycheckModal');
            var img = document.getElementById("dc-result-img");
            var text = document.getElementById("dc-result-text");

            if (result === "success") {
           
                img.src = "/images/main/dailycheckboard.png";
                text.innerText = "출석체크가 완료되었습니다!";
            } else if (result === "already") {
                img.src = "/images/main/dailycheckboard.png";
                text.innerText = "오늘은 이미 출석체크를 완료했습니다.";
            } else {
                img.src = "/images/main/dailycheckboard.png";
                text.innerText = "출석체크 중 오류가 발생했습니다.";
            }

            document.getElementById("dailycheckResultModal").style.display = "block";
        });
}

function closeModal(id) {
    document.getElementById(id).style.display = "none";
    if (id === "dailycheckResultModal") location.reload();
}
</script>
</sec:authorize>