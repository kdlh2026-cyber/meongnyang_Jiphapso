package com.springboot.meongnyang_Jiphapso.dto;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class BreedDTO {
	private Integer breed_id;
	private String breed_name;
	private String pet_type;
	private String icon_url;
	
	private MultipartFile icon_file;
}
