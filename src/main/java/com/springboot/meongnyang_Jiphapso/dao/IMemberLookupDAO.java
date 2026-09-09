package com.springboot.meongnyang_Jiphapso.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.springboot.meongnyang_Jiphapso.dto.MemberDTO;

@Mapper
public interface IMemberLookupDAO {
	MemberDTO selectMemberOne(@Param("mNo") Long mNo);
}
