package com.springboot.meongnyang_Jiphapso.dto;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.time.LocalDate;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class StrayAnimalDto {
	 private BigInteger stray_no;
	 private String stray_category;
	 private String stray_name;
	 private String stray_age;
	 private String stray_gender;   
	 private String stray_neuter;
	 private BigDecimal stray_weight;  
	 private String stray_character;
	 private String stray_memo;
	 private String stray_status;
	 private String stray_notice_no;  
	 private LocalDate stray_notice_start;
	 private LocalDate stray_notice_end;
	 private String stray_found_place;
	 private String stray_shelter_name;
	 private String stray_shelter_tel;
	 private String stray_shelter_addr;
	 private MultipartFile main_img;
	 private String stray_img;
}
