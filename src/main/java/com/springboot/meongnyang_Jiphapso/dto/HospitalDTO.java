package com.springboot.meongnyang_Jiphapso.dto;

import lombok.Data;

@Data
public class HospitalDTO {
	private int hp_no;
	private String hp_name;
	private String hp_addr;
	private String hp_land_addr;
	private String hp_tel;
	private String hp_url;
	private String hp_hour;
	private String hp_sp_clinic;
	private String hp_keyword;
	
	public int getHp_no() {
		return hp_no;
	}
}
