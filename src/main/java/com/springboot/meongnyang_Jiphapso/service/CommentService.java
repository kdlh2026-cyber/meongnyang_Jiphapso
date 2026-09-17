package com.springboot.meongnyang_Jiphapso.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.springboot.meongnyang_Jiphapso.dao.ICommentDAO;
import com.springboot.meongnyang_Jiphapso.dto.CommentDTO;

@Service
public class CommentService {
	@Autowired
	ICommentDAO dao;
	
	@Autowired
	CommentESService esService;

	@Autowired
	private PointService pointService; 
	
	public void write(CommentDTO dto) throws Exception{
		dao.CommentWrite(dto);
		esService.save(dto);
	}
	
	// 댓글 조회
	public List<CommentDTO> cmtList(int comm_no){
		return dao.CommentList(comm_no);
	}
	
    // 댓글 개수 조회 (신규)
    public int countComments(int comm_no) {
        return dao.CommentCount(comm_no);
    }

    // 댓글 수정
    public int updateComment(int cmt_no, int m_no, String cmt_content) {
        return dao.CommentUpdate(cmt_no, m_no, cmt_content);
    }
    
    @Transactional
    public boolean deleteComment(int cmt_no, int m_no) {
        // 1. 단건 조회 메서드가 List를 반환하므로 첫 번째 요소를 가져옴
        List<CommentDTO> targetList = dao.FindCommentById(cmt_no);
        if (targetList == null || targetList.isEmpty()) return false;
        CommentDTO target = targetList.get(0);

        Integer parentNo = target.getCmt_answer_no(); // 부모 번호
        int replyCount = dao.CountReplies(cmt_no); // 남은 답글 개수

        boolean result = false;

        // 2. 삭제 처리 (답글 없으면 완전 삭제, 있으면 '삭제된 댓글입니다'로 변경)
        if (replyCount == 0 && parentNo == null) {
            result = dao.CommentHardDelete(cmt_no, m_no) > 0;
        } else if (replyCount > 0) {
            result = dao.CommentDelete(cmt_no, m_no) > 0;
        } else {
            result = dao.CommentHardDelete(cmt_no, m_no) > 0;
        }

        // 3. 부모가 존재하고, 부모도 이미 삭제된 상태이며, 남은 자식이 없다면 부모도 완전 삭제
        if (parentNo != null) {
            List<CommentDTO> parentList = dao.FindCommentById(parentNo);
            if (parentList != null && !parentList.isEmpty()) {
                CommentDTO parent = parentList.get(0);
                
                if ("Y".equals(parent.getCmt_deleted()) && dao.CountReplies(parentNo) == 0) {
                	dao.ParentHardDelete(parentNo);
                }
            }
        }

        return result;
    }
    
    // 상품 리뷰 작성
    public void ReviewWrite(CommentDTO dto) throws Exception{
		dao.ReviewWrite(dto);
		esService.save(dto);
	}
    
    // 내가 쓴 특정 상품 리뷰 조회
    public CommentDTO getReviewByDetailNo(Long odDetailNo) {
        return dao.selectReviewByDetailNo(odDetailNo);
    }

    // 내가 쓴 상품 리뷰 삭제
    public int reviewDelete(Integer cmt_no, Integer m_no) {
    	return dao.reviewDelete(cmt_no, m_no);
    }
    
    // 내가 쓴 모든 리뷰
    public List<CommentDTO> getReviewsByMemberNo(Integer m_no) {
        return dao.selectReviewsByMemberNo(m_no);
    }
    
    public void reviewUpdate(int cmt_no, int m_no, String cmt_content, int cmt_score) {
        dao.reviewUpdate(cmt_no, m_no, cmt_content, cmt_score);
    }
    
    public List<CommentDTO> selectReviewListByProductNo(int p_no) {
        return dao.selectReviewListByProductNo(p_no);
    }
    
    @Transactional
    public String processRecommend(int cmt_no, int m_no) {
        // 1. 해당 유저가 이 댓글에 이미 도움돼요를 눌렀는지 이력 조회
        // (댓글 추천 이력을 관리하는 DAO 메서드가 필요합니다)
        String votedType = dao.getRecommendType(cmt_no, m_no);
        
        if (votedType != null) {
            // [토글] 이미 눌렀던 상태에서 다시 누름 -> 추천 취소 처리
        	dao.deleteRecommend(cmt_no, m_no);
        	dao.decreaseCmtGood(cmt_no); // 댓글 추천수 감소
            return "CANCELED";
        }

        // 2. 투표 이력이 없는 경우 -> 신규 등록
        dao.insertRecommend(cmt_no, m_no);
        dao.increaseCmtGood(cmt_no); // 댓글 추천수 증가

        return "SUCCESS";
    }
    
	// ① 이 회원의 첫 리뷰면 1000P (이미 지급됐으면 내부에서 자동으로 무시됨)
	// pointService.earnFirstReviewBonus(mNo);
	
	// ② 리뷰가 달린 상품의 구매금액(od_amount) 3% 적립
	// pointService.earnPurchaseReviewBonus(mNo, odAmount, orNo);
}
