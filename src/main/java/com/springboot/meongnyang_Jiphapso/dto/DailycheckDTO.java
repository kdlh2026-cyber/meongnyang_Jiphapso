package com.springboot.meongnyang_Jiphapso.dto;

import lombok.Data;

@Data
public class DailycheckDTO {
	private int ch_no;
	private int ch_count;
	private String ch_year_month;
	private String ch_start_date;
	private String ch_end_date;
	private int ch_point_quentity;
	private int m_no;
	private int po_no;
	
	public int getCh_no() {
		return ch_no;
	}
}
