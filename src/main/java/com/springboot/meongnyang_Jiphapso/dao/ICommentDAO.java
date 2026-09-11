package com.springboot.meongnyang_Jiphapso.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.springboot.meongnyang_Jiphapso.dto.CommentDTO;

@Mapper
public interface ICommentDAO {
	// 댓글 조회
	public List<CommentDTO> CommentList(@Param("comm_no") Integer comm_no);
	
	// 댓글 작성(insert)
	public int CommentWrite(CommentDTO cmtDto);
	
	// 댓글 삭제(delete) -> 본인이 쓴 댓글만 삭제 가능
	public int CommentDelete(@Param("cmt_no") int cmt_no, @Param("m_no") int m_no);
	
	// 댓글 수정(update) -> 본인이 쓴 댓글만 수정 가능
	public int CommentUpdate(CommentDTO cmtDto);
	
	// 내가 쓴 댓글 조회
	public List<CommentDTO> myComment(@Param("m_no") Integer m_no);

}
