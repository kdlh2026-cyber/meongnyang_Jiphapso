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

function mInsertcheck(){
	let m_id=document.memberForm.m_id;
	let m_pw=document.memberForm.m_passwd;
	let m_pw1=document.memberForm.m_passwd1;
	let m_name=document.memberForm.m_name;
	let m_tel=document.memberForm.m_tel;
	let m_addr=document.memberForm.m_addr;
	let m_addr_detail=document.memberForm.m_addr_detail;
	let m_zipno=document.memberForm.m_zipno;
	
	if(!m_id.value){
		alert("아이디를 입력하시길 바랍니다.");
		m_id.focus();
		return false;
	}
	if(!m_pw.value){
		alert("비밀번호를 입력하시길 바랍니다.");
		m_pw.focus();
		return false;
	}
	if(!m_pw1.value){
		alert("비밀번호를 다시 입력해주시길 바랍니다.");
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
	
	return true;
}