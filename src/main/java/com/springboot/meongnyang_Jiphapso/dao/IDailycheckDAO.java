package com.springboot.meongnyang_Jiphapso.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.springboot.meongnyang_Jiphapso.dto.DailycheckDTO;

@Mapper
public interface IDailycheckDAO {
	public List<DailycheckDTO> CheckList();
	public DailycheckDTO CheckView(int ch_no);
	// 이번 달 내 출석 기록 조회 (회원+연월 기준)
	public DailycheckDTO CheckViewByMemberMonth(Map<String, Object> params);
	public int CheckWrite(DailycheckDTO ch_dto);
	public int CheckUpdate(DailycheckDTO ch_dto);
	public int CheckDelete(int ch_no);
}