package com.springboot.meongnyang_Jiphapso.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.springboot.meongnyang_Jiphapso.dto.MemberDTO;

@Mapper
public interface IMemberDAO {
	// 회원 목록
	public List<MemberDTO> MemberList();
	// 회원 정보 조회
	public MemberDTO MemberView(String m_id);
	// 회원 가입
	public int MemberWrite(MemberDTO m_dto);
	// 회원 정보 수정
	public int MemberUpdate(MemberDTO m_dto);
	// 회원 탈퇴
	public int MemberDelete(String m_id);
	
	public MemberDTO MemberFindId(String m_id);
	// 관리자용 멤버리스트 조회
	public List<MemberDTO> MemberListView(String m_authority);
}
