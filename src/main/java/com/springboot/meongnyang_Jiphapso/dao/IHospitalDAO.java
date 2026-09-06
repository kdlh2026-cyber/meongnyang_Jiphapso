package com.springboot.meongnyang_Jiphapso.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.springboot.meongnyang_Jiphapso.dto.HospitalDTO;

@Mapper
public interface IHospitalDAO {
	// 병원 목록
	public List<HospitalDTO> HospitalList();
	// 병원 상세 조회
	public HospitalDTO HospitalView(int hp_no);
	// 병원 정보 입력
	public int HospitalWrite(HospitalDTO hp_dto);
	// 병원 정보 수정
	public int HospitalUpdate(HospitalDTO hp_dto);
	// 병원 정보 삭제
	public int HospitalDelete(int hp_no);
}
