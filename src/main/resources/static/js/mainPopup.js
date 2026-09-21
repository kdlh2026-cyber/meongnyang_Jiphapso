(function () {
    // ▼ 이벤트 팝업 목록 (왼쪽 → 오른쪽 순서). 이미지나 제목을 바꿀 땐 여기만 수정
    var EVENTS = [
        { id: "event1", src: "/images/main/popup_event1.jpg", title: "회원가입 시 1000P 지급" },
        { id: "event2", src: "/images/main/popup_event2.png", title: "첫 리뷰 작성 시 1000P" },
        { id: "event3", src: "/images/main/popup_event3.png", title: "라운지 인기글 이벤트" }
    ];
    var POPUP_URL = "/guest/popup/eventPopup";   // 컨트롤러 매핑 주소와 같아야 함

    // ▼ 크기/간격 조절
    var IMG_H = 400;                    // 이벤트 이미지 표시 높이 (폭은 이미지 비율대로 자동)
    var BAR_H = 44;                     // '오늘 하루 보지 않기' 영역 높이 (eventPopup.jsp의 .hide-today 높이와 같아야 함)
    var DC_W = 360, DC_H = 460;         // 출석체크 팝업 내부 크기
    var CHROME_W = 16, CHROME_H = 90;   // 창 테두리 + 제목줄 + 주소줄 대략 크기
    var GAP = 12, MARGIN = 20;

    function getCookie(name) {
        var match = document.cookie.match(new RegExp("(^| )" + name + "=([^;]+)"));
        return match ? match[2] : null;
    }

    // 현재 메인 브라우저 창의 위치/크기
    function mainRect() {
        return {
            x: (window.screenX !== undefined) ? window.screenX : window.screenLeft,
            y: (window.screenY !== undefined) ? window.screenY : window.screenTop,
            w: window.outerWidth,
            h: window.outerHeight
        };
    }

    // 이미지의 가로/세로 비율(폭 ÷ 높이) 구하기. 실패하면 3:4로 가정
    function loadRatio(src) {
        return new Promise(function (resolve) {
            var img = new Image();
            img.onload = function () { resolve(img.naturalWidth / img.naturalHeight); };
            img.onerror = function () { resolve(3 / 4); };
            img.src = src;
        });
    }

    // 이벤트 팝업을 이미지 비율대로, 메인 창 안에서 나란히 열기
    function openEventPopups() {
        var list = EVENTS.filter(function (e) {
            return getCookie("hidePopup_" + e.id) !== "true";   // 오늘 하루 보지 않기 처리된 건 제외
        });
        var n = list.length;
        if (n === 0) return Promise.resolve();

        return Promise.all(list.map(function (e) { return loadRatio(e.src); }))
            .then(function (ratios) {
                var r = mainRect();
                var sumRatio = ratios.reduce(function (a, b) { return a + b; }, 0);

                // 메인 창 안에 들어오도록 이미지 높이 결정
                var maxByH = r.h - MARGIN * 2 - CHROME_H - BAR_H;
                var maxByW = Math.floor((r.w - MARGIN * 2 - GAP * (n - 1) - CHROME_W * n) / sumRatio);
                var imgH = Math.max(150, Math.min(IMG_H, maxByH, maxByW));
                var innerH = imgH + BAR_H;

                var widths = ratios.map(function (ratio) { return Math.round(imgH * ratio); });
                var totalW = widths.reduce(function (a, w) { return a + w + CHROME_W; }, 0) + GAP * (n - 1);

                var x = r.x + Math.round((r.w - totalW) / 2);
                var top = r.y + Math.max(MARGIN, Math.round((r.h - (innerH + CHROME_H)) / 2));

                list.forEach(function (e, i) {
                    var url = POPUP_URL + "?id=" + e.id +
                              "&img=" + encodeURIComponent(e.src) +
                              "&title=" + encodeURIComponent(e.title);
                    var features = "width=" + widths[i] + ",height=" + innerH +
                                   ",left=" + x + ",top=" + top +
                                   ",resizable=no,scrollbars=no";
                    window.open(url, "eventPopup_" + e.id, features);
                    x += widths[i] + CHROME_W + GAP;
                });
            });
    }

    // 출석체크 팝업: 메인 창 중앙, 가장 마지막에 열어서 맨 앞에 표시
    function openDailyCheck() {
        var r = mainRect();
        var left = r.x + Math.round((r.w - (DC_W + CHROME_W)) / 2);
        var top = r.y + Math.max(MARGIN, Math.round((r.h - (DC_H + CHROME_H)) / 2));

        var win = window.open("/dailycheckPopup", "dailycheckPopup",
            "width=" + DC_W + ",height=" + DC_H +
            ",left=" + left + ",top=" + top +
            ",resizable=no,scrollbars=no");
        if (win) win.focus();
    }

    document.addEventListener("DOMContentLoaded", function () {
        // 1) 이벤트 팝업 먼저 → 2) 그다음 출석체크 팝업
        openEventPopups().then(function () {
            if (window.DC_LOGGED_IN !== true) return;

            var today = new Date().toISOString().slice(0, 10);
            if (localStorage.getItem(DC_STORAGE_KEY) === today) return;

            return fetch("/dailycheckStatus")
                .then(function (res) { return res.json(); })
                .then(function (data) {
                    if (data.needCheck) openDailyCheck();
                });
        });
    });
})();