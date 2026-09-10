package com.springboot.meongnyang_Jiphapso.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.springboot.meongnyang_Jiphapso.dto.StrayAnimalDto;

@Mapper
public interface IStrayAnimalDao {
	public List<StrayAnimalDto> StrayAnimalList();
	
	//판매목록 상세보기
	public StrayAnimalDto ProductView(int stray_no);
	
	//등록
	public int StrayAnimalWrite(StrayAnimalDto stray_dto);
	
	//수정
	public int StrayAnimalUpdate(StrayAnimalDto stray_dto);
	
	//삭제
	public int StrayAnimalDelete(int stray_no);
}
