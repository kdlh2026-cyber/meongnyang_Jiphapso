package com.springboot.meongnyang_Jiphapso.dao;


import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.springboot.meongnyang_Jiphapso.dto.StrayAnimalDto;
import com.springboot.meongnyang_Jiphapso.dto.StraySearchDto;

@Mapper
public interface IStrayAnimalDao {
	public List<String> getListCategory(String stray_category);
	
	public List<StrayAnimalDto> StrayAnimalPageList(StraySearchDto search_dto);
	
	public int StrayAnimalCount(StraySearchDto search_dto);
	
	//상세보기
	public StrayAnimalDto StrayView(Long stray_no);
	public List<StrayAnimalDto> StrayRandomView(String stray_category);
	
	//등록
	public int StrayAnimalWrite(StrayAnimalDto stray_dto);
	
	//수정
	public int StrayAnimalUpdate(StrayAnimalDto stray_dto);
	
	//삭제
	public int StrayAnimalDelete(Long stray_no);
	
	public List<StrayAnimalDto> stray_list();
	
}
