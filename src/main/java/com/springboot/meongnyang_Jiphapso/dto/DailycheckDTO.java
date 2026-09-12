package com.springboot.meongnyang_Jiphapso.dto;

import java.util.Date;
import lombok.Data;

@Data
public class DailycheckDTO {
	private int ch_no;
	private int ch_count;
	private Date ch_year_month;
	private Date ch_start_date;
	private Date ch_end_date;
	private int ch_point_quantity;
	private int m_no;
	private int po_no;
}