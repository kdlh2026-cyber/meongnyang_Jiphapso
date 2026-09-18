function hpFormCheck(){
	let hp_name = document.hospitalForm.hp_name;
	let hp_addr = document.hospitalForm.hp_addr;

	if(!hp_name.value.trim()){
		alert("병원 이름을 입력하시길 바랍니다.");
		hp_name.focus();
		return false;
	}
	if(!hp_addr.value.trim()){
		alert("병원 주소를 입력하시길 바랍니다.");
		hp_addr.focus();
		return false;
	}

	// 위도/경도가 숫자 형식인지 확인
	let hp_lat = document.hospitalForm.hp_lat;
	let hp_lng = document.hospitalForm.hp_lng;
	let expNum = /^-?\d+(\.\d+)?$/;

	if(hp_lat.value.trim() && !expNum.test(hp_lat.value.trim())){
		alert("위도는 숫자 형식으로 입력하시길 바랍니다. (예: 37.5665)");
		hp_lat.focus();
		return false;
	}
	if(hp_lng.value.trim() && !expNum.test(hp_lng.value.trim())){
		alert("경도는 숫자 형식으로 입력하시길 바랍니다. (예: 126.9780)");
		hp_lng.focus();
		return false;
	}

	return true;
}