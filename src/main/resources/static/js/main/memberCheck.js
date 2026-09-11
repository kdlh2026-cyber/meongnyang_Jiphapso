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