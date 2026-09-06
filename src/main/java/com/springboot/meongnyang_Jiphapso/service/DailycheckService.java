package com.springboot.meongnyang_Jiphapso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.meongnyang_Jiphapso.dao.IDailycheckDAO;
import com.springboot.meongnyang_Jiphapso.dto.DailycheckDTO;

@Service
public class DailycheckService {
	@Autowired
	IDailycheckDAO ch_dao;
	
	@Autowired
	DailycheckESService ch_service;
	
	public void write(DailycheckDTO ch_dto) throws Exception{
		ch_dao.CheckWrite(ch_dto);  // 오라클 DB에 저장
		ch_service.save(ch_dto);    // 엘라스틱서치에 색인
	}
	
	public List<DailycheckDTO> list(){
		return ch_dao.CheckList();
	}
	
	public List<DailycheckDTO> search(String keyword) throws Exception{
		return ch_service.search(keyword);
	}
	
	// 자동완성 + 하이라이트
	public List<Map<String,String>> autocomplete(String keyword) throws Exception{
		return ch_service.autocompleteHighlight(keyword);
	}
}
