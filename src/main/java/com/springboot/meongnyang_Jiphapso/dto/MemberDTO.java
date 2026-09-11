package com.springboot.meongnyang_Jiphapso.dto;

import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class MemberDTO {
	private int m_no;
	private String m_id;
	private String m_passwd;
	private String m_name;
	private String m_tel;
	private String m_addr;
	private String m_addr_detail;
	private int m_zipno;
	private String m_email;
	private String m_introduce;
	private Date m_birth;
	private Date m_date;
	private String m_age_upper;
	private String m_sns;
	private String m_authority;
	private MultipartFile m_upload;
	private String m_img;
	private String m_cre_sub;
	
	public String getM_id(){
		return m_id;
	};
}


