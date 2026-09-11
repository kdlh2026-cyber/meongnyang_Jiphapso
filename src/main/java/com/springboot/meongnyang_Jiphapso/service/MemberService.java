package com.springboot.meongnyang_Jiphapso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.meongnyang_Jiphapso.dao.IMemberDAO;
import com.springboot.meongnyang_Jiphapso.dto.MemberDTO;

@Service
public class MemberService {
	@Autowired
	IMemberDAO m_dao;
	
	@Autowired
	MemberESService m_service;

	@Autowired
	private PointService pointService; 
	
	public void write(MemberDTO m_dto) throws Exception{
		m_dao.MemberWrite(m_dto);   // 오라클 DB에 저장
		m_service.save(m_dto);      // 엘라스틱 서치에 색인(저장)
	}
	
	public List<MemberDTO> m_list(){
		return m_dao.MemberList();
	}
	
	public List<MemberDTO> search(String keyword) throws Exception{
		return m_service.search(keyword);
	}
	
	// 자동완성 + 하이라이트
	public List<Map<String,String>> autocomplete(String keyword) throws Exception{
		return m_service.autocompleteHighlight(keyword);
	}

	// insertMember() 성공 직후, 신규 회원가입 축하 포인트 1000P 지급
	pointService.earnSignupBonus(mNo)
}
