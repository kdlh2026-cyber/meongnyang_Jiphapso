package com.springboot.meongnyang_Jiphapso.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.springboot.meongnyang_Jiphapso.dto.BookmarkDTO;
import com.springboot.meongnyang_Jiphapso.dto.CommunityDTO;

@Mapper
public interface IBookMarkDAO {
	// 북마크 저장
	public int insertBookMark(BookmarkDTO dto);
	
	// 북마크 조회
	public List<CommunityDTO> selectBookmarksByMemberNo(@Param("m_no") int m_no);
	
	// 북마크 확인(내가 북마크한 게시글에 상태 표시를 위해)
	public int checkBookMark(@Param("comm_no") int comm_no,
							 @Param("m_no") int m_no);		
	
	// 북마크 삭제
	public int deleteBookMark(@Param("comm_no") int comm_no,
			 				  @Param("m_no") int m_no);
}
