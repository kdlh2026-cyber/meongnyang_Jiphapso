<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="/css/etc/mainPopup.css">

<div id="popupWrap" class="popup-wrap">

	<div class="popup-item" id="popup1" data-popup-id="event1">
		<button class="popup-close" onclick="closePopup('event1')">×</button>
		<img src="/images/main/popup_event1.jpg" alt="라운지 인기글 이벤트">
		<label class="popup-hide-today">
			<input type="checkbox" onchange="hideToday('event1', this)"> 오늘 하루 보지 않기
		</label>
	</div>

	<div class="popup-item" id="popup2" data-popup-id="event2">
		<button class="popup-close" onclick="closePopup('event2')">×</button>
		<img src="/images/main/popup_event2.png" alt="회원가입 시 1000P 지급">
		<label class="popup-hide-today">
			<input type="checkbox" onchange="hideToday('event2', this)"> 오늘 하루 보지 않기
		</label>
	</div>

	<div class="popup-item" id="popup3" data-popup-id="event3">
		<button class="popup-close" onclick="closePopup('event3')">×</button>
		<img src="/images/main/popup_event3.png" alt="첫 리뷰 작성 시 1000P">
		<label class="popup-hide-today">
			<input type="checkbox" onchange="hideToday('event3', this)"> 오늘 하루 보지 않기
		</label>
	</div>

</div>

<script src="/js/mainPopup.js"></script>