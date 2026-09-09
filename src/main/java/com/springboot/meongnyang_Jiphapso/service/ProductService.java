package com.springboot.meongnyang_Jiphapso.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.meongnyang_Jiphapso.dao.IProductDao;
import com.springboot.meongnyang_Jiphapso.dto.ProductDto;

@Service
public class ProductService {
	@Autowired
	IProductDao p_dao;
	
	@Autowired
	ProductESService p_service;
	
	public void write(ProductDto p_dto) throws Exception{
		p_dao.ProductWrite(p_dto); 
		p_service.save(p_dto);      // 엘라스틱 서치에 색인(저장)
	}
	
	
}
