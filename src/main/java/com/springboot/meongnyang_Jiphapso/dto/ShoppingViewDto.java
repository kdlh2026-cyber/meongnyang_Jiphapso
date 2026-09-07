package com.springboot.meongnyang_Jiphapso.dto;

import java.util.List;

import lombok.Data;

@Data
public class ShoppingViewDto {
	private int pno;
	private String ptitle;
	private String pbrand;
	private String pcategory;
	private String ptype;
	private String omainimg;
	private int oprice;
	private int ooriginprice;
	private int oquantity;
	private String otypesize;
	private String ocolor;
	private String odefault;
	
	private List<ProductDetailImageDto> detailImages;
}
