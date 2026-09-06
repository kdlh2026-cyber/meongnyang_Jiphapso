package com.springboot.meongnyang_Jiphapso.dto;

import lombok.Data;

@Data
public class PetDTO {
	private int pet_no;
	private String pet_name;
	private String pet_birth;
	private String pet_type;
	private String pet_breed;
	private String pet_gender;
	private String pet_neuter;
	private float pet_weight;
	private String pet_image;
	private int m_no;
	
	public int getPet_no() {
		return pet_no;
	}
}
