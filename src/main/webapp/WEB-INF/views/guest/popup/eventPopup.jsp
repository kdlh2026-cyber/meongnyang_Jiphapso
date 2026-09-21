<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>이벤트</title>
<style>
    html, body { margin: 0; padding: 0; height: 100%; overflow: hidden; }
    body {
        display: flex;
        flex-direction: column;
        background: #FFF3D8;
        font-family: 'Noto Sans KR', sans-serif;
    }
    #eventImg {
        flex: 1;
        min-height: 0;
        width: 100%;
        object-fit: contain;
        display: block;
    }
    .hide-today {
        flex: 0 0 44px;            /* mainPopup.js 의 BAR_H 와 같은 값 */
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 6px;
        font-size: 13px;
        color: #4A3226;
        cursor: pointer;
    }
</style>
</head>
<body>
    <img id="eventImg" alt="">
    <label class="hide-today">
        <input type="checkbox" id="hideToday"> 오늘 하루 보지 않기
    </label>

<script>
    var params = new URLSearchParams(location.search);
    var id = params.get("id");
    var src = params.get("img");
    var title = params.get("title");

    // 우리 서버의 이미지 경로만 허용
    if (!id || !src || src.indexOf("/images/") !== 0) {
        window.close();
    } else {
        document.title = title || "이벤트";
        var img = document.getElementById("eventImg");
        img.src = src;
        img.alt = title || "";
    }

    // 쿠키를 오늘 자정까지만 유효하게 설정 (메인 창과 path=/ 로 공유됨)
    function setCookieUntilMidnight(name, value) {
        var now = new Date();
        var midnight = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1, 0, 0, 0);
        document.cookie = name + "=" + value + "; expires=" + midnight.toUTCString() + "; path=/";
    }

    document.getElementById("hideToday").addEventListener("change", function () {
        if (this.checked) {
            setCookieUntilMidnight("hidePopup_" + id, "true");
            window.close();
        }
    });
</script>
</body>
</html>