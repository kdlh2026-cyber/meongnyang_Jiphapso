package com.springboot.meongnyang_Jiphapso.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class ProductDto {
	private int p_no;
	private String p_title;
	private String p_brand;
	private String p_category;
	private String p_type;
	private String p_content;
	private LocalDateTime p_date;
}
