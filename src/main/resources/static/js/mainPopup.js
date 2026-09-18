// 쿠키를 오늘 자정까지만 유효하게 설정
function setCookieUntilMidnight(name, value){
	let now = new Date();
	let midnight = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1, 0, 0, 0);
	document.cookie = name + "=" + value + "; expires=" + midnight.toUTCString() + "; path=/";
}

function getCookie(name){
	let match = document.cookie.match(new RegExp('(^| )' + name + '=([^;]+)'));
	return match ? match[2] : null;
}

// 페이지 로드 시, 쿠키가 있는 팝업은 숨김
document.addEventListener("DOMContentLoaded", function(){
	document.querySelectorAll(".popup-item").forEach(function(el){
		let id = el.getAttribute("data-popup-id");
		if(getCookie("hidePopup_" + id) === "true"){
			el.style.display = "none";
		}
	});
});

function closePopup(id){
	let el = document.querySelector('.popup-item[data-popup-id="' + id + '"]');
	if(el) el.style.display = "none";
}

function hideToday(id, checkboxEl){
	if(checkboxEl.checked){
		setCookieUntilMidnight("hidePopup_" + id, "true");
		closePopup(id);
	}
}