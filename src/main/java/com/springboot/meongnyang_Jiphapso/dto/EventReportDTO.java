package com.springboot.meongnyang_Jiphapso.dto;

import java.util.Date;

import lombok.Data;

@Data
public class EventReportDTO {
	private int report_no;
	private String report_link;
	private String report_content;
	private int m_no;
	private Date report_date;
	
	private String m_id;
}
