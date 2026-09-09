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
	private List<ProductOptionDto> option;
	private List<ProductDetailImageDto> detailImages;
}
