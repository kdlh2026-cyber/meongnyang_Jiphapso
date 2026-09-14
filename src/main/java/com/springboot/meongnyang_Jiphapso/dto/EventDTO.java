package com.springboot.meongnyang_Jiphapso.dto;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class EventDTO {
	private int event_no;
	private String event_title;
	private String event_content;
	private String event_pet_type;
	private String event_onoff;
	
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date event_start;
	
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date event_end;
	
	private String event_all;
	private String event_loc;
	private Date event_date;
	private Integer m_no;
	private String event_thumb;
}
