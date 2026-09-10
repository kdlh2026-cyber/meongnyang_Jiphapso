package com.springboot.meongnyang_Jiphapso.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.springboot.meongnyang_Jiphapso.dto.ProductDetailImageDto;
import com.springboot.meongnyang_Jiphapso.dto.ProductDto;
import com.springboot.meongnyang_Jiphapso.dto.ProductOptionDto;
import com.springboot.meongnyang_Jiphapso.dto.ShoppingListDto;
import com.springboot.meongnyang_Jiphapso.dto.ShoppingViewDto;

@Mapper
public interface IProductDao {
	//판매목록
	public List<ShoppingListDto> ShoppingList(ShoppingListDto p_dto);
	
	//판매목록, 목록상세보기
	public ShoppingListDto ShoppingViewList(int p_no);
	public ShoppingViewDto ShoppingView(int p_no);
	
	//등록
	public int ProductWrite(ProductDto p_dto);
	public int ProductDetailImageWrite(ProductDetailImageDto img_dto);
	public int ProductOptionWrite(ProductOptionDto o_dto);
	
	//수정
	public int ProductUpdate(ProductDto p_dto);
	
	//삭제
	public int ProductDelete(int p_no);
	
	// 동일타이틀 있는지 체크 후 ProductWrite 실행
	public ProductDto getProductByTitle(String p_title);
	
	// 엘라스틱 보낼 리스트, 검색한 리스트 저장
	public List<ProductDto> p_list();
	public List<ShoppingListDto> productSearchList(List<Integer> p_no);
}