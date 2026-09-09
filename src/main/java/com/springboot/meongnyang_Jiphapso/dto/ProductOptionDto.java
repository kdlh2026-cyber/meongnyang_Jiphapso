package com.springboot.meongnyang_Jiphapso.dto;

import java.time.LocalDateTime;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class ProductOptionDto {
	private int o_no;
	private int o_price;
	private Integer o_origin_price;
	private String o_main_img;
	private MultipartFile o_img;
	private LocalDateTime o_date;
	private Integer o_quantity;
	private String o_type_size;
	private String o_color;
	private String o_default;
	private int	p_no;
}
