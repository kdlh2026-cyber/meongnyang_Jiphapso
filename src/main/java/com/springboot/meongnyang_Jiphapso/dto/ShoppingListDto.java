package com.springboot.meongnyang_Jiphapso.dto;

import lombok.Data;

@Data
public class ShoppingListDto {
	private int pno;
	private String ptitle;
	private String pbrand;
	private String pcategory;
	private String ptype;
	private String omainimg;
	private int oprice;
	private String odefault;
}