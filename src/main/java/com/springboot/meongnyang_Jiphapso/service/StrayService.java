package com.springboot.meongnyang_Jiphapso.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.meongnyang_Jiphapso.dao.IStrayAnimalDao;
import com.springboot.meongnyang_Jiphapso.dto.StrayAnimalDto;

@Service
public class StrayService {
	@Autowired
	IStrayAnimalDao stray_dao;
	
	@Autowired
	StrayESService stray_esservice;
	
	public void stray_write(StrayAnimalDto stray_dto) throws Exception{
		stray_dao.StrayAnimalWrite(stray_dto); 
		stray_esservice.stray_save(stray_dto);      // 엘라스틱 서치에 색인(저장)
	}
	
	public List<StrayAnimalDto> stray_list(){
		return stray_dao.stray_list();
	}
}
