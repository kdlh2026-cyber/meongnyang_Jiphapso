package com.springboot.meongnyang_Jiphapso.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.meongnyang_Jiphapso.dao.IHospitalDAO;
import com.springboot.meongnyang_Jiphapso.dto.HospitalDTO;

@Service
public class HospitalService {
	@Autowired
	IHospitalDAO hp_dao;
	
	@Autowired
	HospitalESService hp_service;
	
	public void write(HospitalDTO hp_dto) throws Exception{
		hp_dao.HospitalWrite(hp_dto);  // 오라클 DB에 저장
		hp_service.save(hp_dto);       // 엘라스틱서치에 색인
	}
	
	public List<HospitalDTO> list(){
		return hp_dao.HospitalList();
	}
	
	public HospitalDTO view(int hp_no) {
		return hp_dao.HospitalView(hp_no);
	}
	
	public void update(HospitalDTO hp_dto) throws Exception{
		hp_dao.HospitalUpdate(hp_dto);  // 오라클 DB 수정
		hp_service.save(hp_dto);        // 엘라스틱서치 재색인(같은 id면 덮어씀)
	}
	
	public void delete(int hp_no) {
		hp_dao.HospitalDelete(hp_no);
	}
	
	public List<HospitalDTO> search(String keyword) throws Exception{
		return hp_service.search(keyword);
	}
	
	// 자동완성 + 하이라이트
	public List<Map<String,String>> autocomplete(String keyword) throws Exception{
		return hp_service.autocompleteHighlight(keyword);
	}
	
	public List<HospitalDTO> selectList(String keyword, int startRow, int endRow) {
		Map<String, Object> params = new HashMap<>();
		params.put("keyword", keyword);
		params.put("startRow", startRow);
		params.put("endRow", endRow);
		return hp_dao.HospitalSelectList(params);
	}

	public int getTotalCount(String keyword) {
		return hp_dao.HospitalTotalCount(keyword);
	}
}