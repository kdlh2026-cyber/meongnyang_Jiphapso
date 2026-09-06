package com.springboot.meongnyang_Jiphapso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.meongnyang_Jiphapso.dao.IPetDAO;
import com.springboot.meongnyang_Jiphapso.dto.PetDTO;

@Service
public class PetService {
	@Autowired
	IPetDAO pet_dao;
	
	@Autowired
	PetESService pet_service;
	
	public void write(PetDTO pet_dto) throws Exception{
		pet_dao.PetWrite(pet_dto);  // 오라클 DB에 저장
		pet_service.save(pet_dto);  // 엘라스틱서치에 색인
	}
	
	public List<PetDTO> list(){
		return pet_dao.PetList();
	}
	
	public List<PetDTO> search(String keyword) throws Exception{
		return pet_service.search(keyword);
	}
	
	// 자동완성 + 하이라이트
	public List<Map<String,String>> autocomplete(String keyword) throws Exception{
		return pet_service.autocompleteHighlight(keyword);
	}
}
