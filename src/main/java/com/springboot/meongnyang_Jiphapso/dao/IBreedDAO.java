package com.springboot.meongnyang_Jiphapso.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.springboot.meongnyang_Jiphapso.dto.BreedDTO;

@Mapper
public interface IBreedDAO {
	// 견종 가져오기
	public List<BreedDTO> BreedList();
	
	// 견종 입력
	
	// 견종 삭제
	
}
