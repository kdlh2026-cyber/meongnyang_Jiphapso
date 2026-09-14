package com.springboot.meongnyang_Jiphapso.dao;


import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.springboot.meongnyang_Jiphapso.dto.StrayAnimalDto;

@Mapper
public interface IStrayAnimalDao {
	public List<StrayAnimalDto> StrayAnimalPageList(@Param("offset") int offset, @Param("pageSize") int pageSize);
	public int StrayAnimalCount();
	
	//상세보기
	public StrayAnimalDto StrayView(Long stray_no);
	
	//등록
	public int StrayAnimalWrite(StrayAnimalDto stray_dto);
	
	//수정
	public int StrayAnimalUpdate(StrayAnimalDto stray_dto);
	
	//삭제
	public int StrayAnimalDelete(Long stray_no);
	
	public List<StrayAnimalDto> stray_list();
}
