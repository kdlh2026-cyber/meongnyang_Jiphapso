package com.springboot.meongnyang_Jiphapso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.meongnyang_Jiphapso.dao.IProductDao;
import com.springboot.meongnyang_Jiphapso.dto.ProductDto;
import com.springboot.meongnyang_Jiphapso.dto.ShoppingListDto;

@Service
public class ProductService {
	@Autowired
	IProductDao p_dao;
	
	@Autowired
	ProductESService p_esservice;
	
	public void p_write(ProductDto p_dto) throws Exception{
		p_dao.ProductWrite(p_dto); 
		p_esservice.p_save(p_dto);      // 엘라스틱 서치에 색인(저장)
	}
	
	public List<ProductDto> p_list(){
		return p_dao.p_list();
	}
	
	public List<ShoppingListDto> p_search(String keyword) throws Exception{
		return p_esservice.p_search(keyword);	
	}
	// 자동완성 + 하이라이트
	public List<Map<String, String>> p_autocomplete(String keyword) throws Exception{
		return p_esservice.p_autocompleteHighlight(keyword);
	}
	
	
}