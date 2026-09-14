package com.springboot.meongnyang_Jiphapso.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.springboot.meongnyang_Jiphapso.dto.MemberDTO;

@Mapper
public interface IMemberLookupDAO {
	MemberDTO selectMemberOne(@Param("mNo") Long mNo);
	// 로그인 아이디(m_id)로 회원 조회 - Principal 기반 로그인 처리용으로 추가
		MemberDTO selectMemberByLoginId(@Param("mId") String mId);
}
