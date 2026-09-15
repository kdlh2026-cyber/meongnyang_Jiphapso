package com.springboot.meongnyang_Jiphapso.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.springboot.meongnyang_Jiphapso.dto.CommentDTO;

@Mapper
public interface ICommentDAO {
	// 댓글 조회
	public List<CommentDTO> CommentList(@Param("comm_no") Integer comm_no);
	
	// 댓글 개수 조회 (신규)
	public int CommentCount(@Param("comm_no") Integer comm_no);
	
	// 댓글 작성(insert)
	public int CommentWrite(CommentDTO cmtDto);
	
	// 댓글 삭제(delete) -> 본인이 쓴 댓글만 삭제 가능
	public int CommentDelete(@Param("cmt_no") int cmt_no,
							 @Param("m_no") int m_no);
	
	// 내 댓글에 달린 답글 수
	public int CountReplies(int cmt_no);
	
	// 내 댓글 삭제
	public int CommentHardDelete(@Param("cmt_no") int cmt_no, @Param("m_no") int m_no);
	
	// 댓글 수정(update) -> 본인이 쓴 댓글만 수정 가능
	public int CommentUpdate(@Param("cmt_no") int cmt_no,
							 @Param("m_no") int m_no,
							 @Param("cmt_content") String cmt_content);
	
	// 내가 쓴 댓글 조회
	public List<CommentDTO> myComment(@Param("m_no") Integer m_no);
	
	List <CommentDTO> FindCommentById(int cmt_no);
	
	public int ParentHardDelete(int cmt_no);
	
	// 이벤트용 댓글
	public List<CommentDTO> EventCommentList(@Param("event_no") Integer event_no);
    public int EventCommentCount(@Param("event_no") Integer event_no);
    
    // 상품 리뷰 작성
    public int ReviewWrite(CommentDTO cmtDto);
    
    // 내가 쓴 특정 상품 리뷰 조회
    public CommentDTO selectReviewByDetailNo(@Param("odDetailNo") Long odDetailNo);
    
    // 내가 쓴 모든 리뷰
    public List<CommentDTO> selectReviewsByMemberNo(Integer m_no);
    
    // 내가 쓴 리뷰 삭제
    public int reviewDelete(@Param("cmt_no") Integer cmt_no,
			 				@Param("m_no") Integer m_no);
    
    // 리뷰 수정(update)
    public int reviewUpdate(@Param("cmt_no") int cmt_no, 
    						@Param("m_no") int m_no, 
    						@Param("cmt_content") String cmt_content, 
    						@Param("cmt_score") int cmt_score);
    
    // 상품에 해당하는 리뷰 조회
    public List<CommentDTO> selectReviewListByProductNo(int p_no);
}
