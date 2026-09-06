package com.springboot.meongnyang_Jiphapso.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.springboot.meongnyang_Jiphapso.dto.DailycheckDTO;

@Mapper
public interface IDailycheckDAO {
	// 출석체크판 목록
	public List<DailycheckDTO> CheckList();
	// 개별 출석체크판 조회
	public DailycheckDTO CheckView(int ch_no);
	// 출석체크판 정보 입력
	public int CheckWrite(DailycheckDTO ch_dto);
	// 출석체크판 정보 수정
	public int CheckUpdate(DailycheckDTO ch_dto);
	// 츨석체크판 삭제
	public int CheckDelete(int ch_no);
}
