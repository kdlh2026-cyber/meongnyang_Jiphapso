package com.springboot.meongnyang_Jiphapso.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.springboot.meongnyang_Jiphapso.dto.EventDTO;
import com.springboot.meongnyang_Jiphapso.dto.EventReportDTO;

@Mapper
public interface IEventDAO {
	// 이벤트 조회
	public List<EventDTO> eventList();
	
	// 이벤트 상세보기
	public EventDTO eventDetail(int event_no);
	
	// 이벤트 신청(사용자)
	public int eventReport(EventReportDTO er_dto);
	
	// 이벤트 신청 조회(관리자)
	public List<EventReportDTO> eventReportList();
	
	// 이벤트 등록(관리자)
	public int eventWrite(EventDTO e_dto);
	
	// 이벤트 수정(관리자)
	public int eventUpdate(EventDTO eventDTO);

	// 이벤트 삭제(관리자)
	public int eventDelete(int event_no);
}
