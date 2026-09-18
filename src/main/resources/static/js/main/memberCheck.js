function goPopup(){
	// 주소검색을 수행할 팝업 페이지를 호출합니다.
	// 호출된 페이지(jusopopup.jsp)에서 실제 주소검색URL(https://business.juso.go.kr/addrlink/addrLinkUrl.do)를 호출하게 됩니다.
	var pop = window.open("/jusoPopup","pop","width=570,height=420, scrollbars=yes, resizable=yes"); 
}


function jusoCallBack(m_addr, m_addr_detail, m_zipno){
    document.memberForm.m_addr.value = m_addr;
    document.memberForm.m_addr_detail.value = m_addr_detail;
    document.memberForm.m_zipno.value = m_zipno;
}

function agreePopup(type){
	window.open("/guest/etc/" + type, "agreePop_" + type, "width=520,height=560,scrollbars=yes,resizable=yes");
}

function agreeCallback(type){
	if(type === 'ToSPop'){
		document.getElementById('m_ser_agree').checked = true;
	}else if(type === 'PPPop'){
		document.getElementById('m_pub_agree').checked = true;
	}
}

var isIdChecked = false; // 중복확인 통과 여부

function checkIdDuplicate(){
    let m_id = document.memberForm.m_id;
    let expM_id = /^[a-z0-9]{8,12}$/;
    let resultSpan = document.getElementById('idCheckResult');

    if(!m_id.value){
        alert("아이디를 입력하시길 바랍니다.");
        m_id.focus();
        return;
    }
    if(!expM_id.test(m_id.value)){
        alert("아이디는 영문소문자와 숫자 8~12자리로 입력하시길 바랍니다.");
        m_id.focus();
        return;
    }

    fetch("/guest/memberIdCheck?m_id=" + encodeURIComponent(m_id.value))
        .then(function(res){ return res.json(); })
        .then(function(data){
            // data.isDuplicate: true(중복) / false(사용가능)
            if(data.isDuplicate){
                resultSpan.style.color = "red";
                resultSpan.innerText = "이미 사용 중인 아이디입니다.";
                isIdChecked = false;
            }else{
                resultSpan.style.color = "blue";
                resultSpan.innerText = "사용 가능한 아이디입니다.";
                isIdChecked = true;
            }
        })
        .catch(function(err){
            console.error(err);
            alert("중복확인 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
            isIdChecked = false;
        });
}

function mInsertcheck(){
	let m_id=document.memberForm.m_id;
	let m_pw=document.memberForm.m_passwd;
	let m_pw1=document.memberForm.m_passwd1;
	let m_name=document.memberForm.m_name;
	let m_tel=document.memberForm.m_tel;
	let m_addr=document.memberForm.m_addr;
	let m_addr_detail=document.memberForm.m_addr_detail;
	let m_zipno=document.memberForm.m_zipno;
	let m_ser_agree=document.memberForm.m_ser_agree;
	let m_pub_agree=document.memberForm.m_pub_agree;
	
	let validCount = 0;
	let expM_id=/^[a-z0-9]{8,12}$/; // 영문소문자/숫자 4~12자리
	let expM_pw=/^[a-zA-Z0-9~`!@#$%^&*_\-={}\[\]|;:<>,.?\/]{8,16}$/; // 영문대소문자/숫자/특수문자 8~16자리
	let expM_tel=/^[0-9]{10,13}$/;
	if (/[a-zA-Z]/.test(m_pw.value)) validCount++; // 영문 대소문자
	if (/[0-9]/.test(m_pw.value)) validCount++; // 숫자
	if (/[~`!@#$%^&*_\-={}\[\]|;:<>,.?\/]/.test(m_pw.value)) validCount++;
	
	if(!m_id.value){
		alert("아이디를 입력하시길 바랍니다.");
		m_id.focus();
		return false;
	}
	if(!expM_id.test(m_id.value)){
		alert("아이디는 영문소문자와 숫자 8~12자리로 입력하시길 바랍니다.");
		m_id.value="";
		m_id.focus();
		return false;
	}
	
	if(!isIdChecked){
		alert("아이디 중복확인을 해주시길 바랍니다.");
		m_id.focus();
		return false;
	}
	if(!m_pw.value){
		alert("비밀번호를 입력하시길 바랍니다.");
		m_pw.focus();
		return false;
	}
	if(m_pw.value.search(/\s/)!==-1){
		alert("비밀번호에 공백(틔어쓰기)은 포함할 수 없습니다.");
		m_pw.value="";
		m_pw.focus();
		return false;
	}
	if(!expM_pw.test(m_pw.value)){
		alert("비밀번호는 영문대소문자와 숫자, 특수기호 8~16자리까지 가능합니다.");
		m_pw.value="";
		m_pw.focus();
		return false;
	}
	
	// 2개 이상 조합
	
	if(validCount<2){
		alert("비밀번호는 영문대소문자, 숫자, 특수문자 중 2가지 이상 포함해야 합니다.");
		m_pw.value="";
		m_pw.focus();
		return false;
	}
	
	// 비밀번호에 아이디 포함 여부 검사
	if(m_pw.value.indexOf(m_id.value)>-1){
		alert("비밀번호에 아이디를 포함할 수 없습니다.");
		m_pw.value="";
		m_pw.focus();
		return false;
	}
	
	// 동일 숫자 연속사용 검사
	let count1=0; // 연속카운트 ++
	let count2=0; // 연속카운트 --
	let count3=0;
	
	for (let i=0; i<m_pw.value.length; i++){
		let char0;
		let char1;
		let char2;
		
		if(i>=2){
			char0=m_pw.value.charCodeAt(i-2); // a-->97
			char1=m_pw.value.charCodeAt(i-1); // b-->98
			char2=m_pw.value.charCodeAt(i); // c-->99
			
			// 연속 카운트 증가
			if(char0-char1==-1 && char1-char2 ==-1){
				count1++;
			}else{
				count1=0;
			}
			
			// 연속 카운트 감소
			if(char0-char1==1 && char1-char2==1){
				count2++;
			}else{
				count2=0;	
			}
			
			// 동일 문자 카운트
			if(char0-char1==0 && char1-char2==0){
				count3++;
			}else{
				count3=0;
			}
			if(count1>0 || count2>0){
				alert("영문, 숫자는 3글자 이상 연속으로 입력할 수 없습니다.");
				m_pw.value="";
				return false;
			}
			if(count3>0){
				alert("동일한 문자는 3번 이상 입력할 수 없습니다.");
				m_pw.value="";
				return false;
			}
		}
	}
	if(!m_pw1.value){
			alert("비밀번호 확인란에 비밀번호를 입력하시길 바랍니다.");
			m_pw1.focus();
			return false;
		}
	if(m_pw.value!=m_pw1.value){
		alert("비밀번호가 맞지 않습니다.");
		m_pw.value="";
		m_pw1.value="";
		m_pw.focus();
		return false;
	}
	
	if(!m_name.value){
		alert("이름을 입력하시길 바랍니다.")
		m_name.focus();
		return false;
	}
	if(!m_tel.value){
		alert("전화번호를 입력하시길 바랍니다.");
		m_tel.focus();
		return false;
	}
	if(!expM_tel.test(m_tel.value)){
		alert("연락처는 숫자만 사용하여 13자 이상 입력하시길 바랍니다.");
		m_tel.value="";
		m_tel.focus();
		return false;
	}
	if(!m_addr.value){
		alert("주소를 입력하시길 바랍니다.");
		return false;
	}
	if(!m_addr_detail.value){
		alert("상세주소를 입력하시길 바랍니다.");
		m_addr_detail.focus();
		return false;
	}
	if(!m_zipno.value){
		alert("우편번호를 입력하시길 바랍니다.");
		m_zipno.focus();
		return false;
	}
	if(!m_ser_agree.checked){
		alert("서비스 이용약관에 동의해주셔야 가입이 가능합니다.");
		m_ser_agree.focus();
		return false;
	}
		if(!m_pub_agree.checked){
			alert("개인정보 수집 및 이용약관에 동의해주셔야 가입이 가능합니다.");
			m_pub_agree.focus();
			return false;
		}
	
	return true;
}