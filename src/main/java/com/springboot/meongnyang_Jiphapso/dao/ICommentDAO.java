package com.springboot.meongnyang_Jiphapso.dao;

import org.apache.ibatis.annotations.Mapper;

import com.springboot.meongnyang_Jiphapso.dto.CommentDTO;

@Mapper
public interface ICommentDAO {
	// 댓글 조회
	
	// 댓글 작성(insert)
	public int CommentWrite(CommentDTO cmtDto);
	
	// 댓글 삭제(delete) -> 본인이 쓴 댓글만 삭제 가능
	
	// 댓글 수정(update) -> 본인이 쓴 댓글만 수정 가능
	
}
