function autoHyphenTel(target) {
    let raw = target.value.replace(/[^0-9]/g, '');
    let result = '';

    if (raw.startsWith('02')) {
        if (raw.length < 3) {
            result = raw;
        } else if (raw.length < 6) {
            result = raw.substr(0, 2) + '-' + raw.substr(2);
        } else if (raw.length < 10) {
            result = raw.substr(0, 2) + '-' + raw.substr(2, 3) + '-' + raw.substr(5);
        } else {
            result = raw.substr(0, 2) + '-' + raw.substr(2, 4) + '-' + raw.substr(6, 4);
        }
    } 
    else {
        if (raw.length < 4) {
            result = raw;
        } else if (raw.length < 7) {
            result = raw.substr(0, 3) + '-' + raw.substr(3);
        } else if (raw.length < 11) {
            result = raw.substr(0, 3) + '-' + raw.substr(3, 3) + '-' + raw.substr(6);
        } else {
            result = raw.substr(0, 3) + '-' + raw.substr(3, 4) + '-' + raw.substr(7, 4);
        }
    }

    target.value = result;
}


function strayCheck(){
	let stray_age = document.strayWriteForm.stray_age;
	let stray_weight = document.strayWriteForm.stray_weight;
	let stray_notice_start = document.strayWriteForm.stray_notice_start;
	let stray_notice_end = document.strayWriteForm.stray_notice_end;
	let stray_shelter_tel = document.strayWriteForm.stray_shelter_tel;
	let birthYear = parseInt(stray_age.value.trim(), 10);

	let expYear = /^[0-9]{4}$/;
	let expTelWithHyphen = /^(02-\d{3,4}-\d{4}|\d{3}-\d{3,4}-\d{4})$/;
	let expWeight = /^\d+(\.\d{1,2})?$/;

	let currentYear = new Date().getFullYear();

	if (!stray_age.value.trim()) {
	    alert("출생연도를 입력하시길 바랍니다.");
	    stray_age.focus();
	    return false;
	}

	if (!expYear.test(stray_age.value.trim())) {
	    alert("출생연도는 4자리 숫자로만 입력해주세요. (예: 2025)");
	    stray_age.focus();
	    return false;
	}
	
	if (birthYear < 1990 || birthYear > currentYear) {
	    alert("올바른 출생연도를 입력해주세요. (1990년 ~ " + currentYear + "년 사이)");
	    stray_age.focus();
	    return false;
	}

	if (!stray_weight.value.trim()) {
	    alert("몸무게를 입력하시길 바랍니다.");
	    stray_weight.focus();
	    return false;
	}

	if (parseFloat(stray_weight.value) <= 0) {
	    alert("몸무게는 0보다 큰 값이어야 합니다.");
	    stray_weight.focus();
	    return false;
	}

	if (!expWeight.test(stray_weight.value.trim())) {
	    alert("몸무게는 소수점 둘째 자리까지만 입력 가능합니다. (예: 5.5 또는 5.25)");
	    stray_weight.focus();
	    return false;
	}
	
	if (!stray_notice_start.value) {
	    alert("공고 시작일을 선택해주세요.");
	    stray_notice_start.focus();
	    return false;
	}

	if (!stray_notice_end.value) {
	    alert("공고 마감일을 선택해주세요.");
	    stray_notice_end.focus();
	    return false;
	}

	if (stray_notice_start.value > stray_notice_end.value) {
	    alert("공고 마감일은 공고 시작일보다 빠를 수 없습니다.");
	    stray_notice_end.focus();
	    return false;
	}

	if (!stray_shelter_tel.value.trim()) {
	    alert("전화번호를 입력하시길 바랍니다.");
	    stray_shelter_tel.focus();
	    return false;
	}

	if (!expTelWithHyphen.test(stray_shelter_tel.value.trim())) {
		    alert("올바른 전화번호 형식이 아닙니다.");
		    stray_shelter_tel.focus();
		    return false;
	}
	
	return true;
}
