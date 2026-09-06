package com.springboot.meongnyang_Jiphapso.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.springboot.meongnyang_Jiphapso.dto.PetDTO;

@Mapper
public interface IPetDAO {
	// 반려동물 목록
	public List<PetDTO> PetList();
	// 펫 개별 정보 조회
	public PetDTO PetView(int pet_no);
	// 펫 정보 입력
	public int PetWrite(PetDTO pet_dto);
	// 펫 정보 수정
	public int PetUpdate(PetDTO pet_dto);
	// 펫 정보 삭제
	public int PetDelete(int pet_no);
}
