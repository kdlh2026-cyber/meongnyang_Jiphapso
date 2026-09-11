package com.springboot.meongnyang_Jiphapso.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.springboot.meongnyang_Jiphapso.dto.BreedDTO;

@Mapper
public interface IBreedDAO {
	// 견종 가져오기
	public List<BreedDTO> BreedList(String pet_type);
	
	// 견종 입력
	public int breedInsert(BreedDTO dto);
	
	// 견종 삭제
	public int breedDelete(int breed_id);
	
	// 견종 업데이트
	public int breedUpdate(BreedDTO dto);
}
