package com.springboot.meongnyang_Jiphapso.service;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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

	// 리뷰 insert 성공 직후 (실제 구매자인지 검증 후)

	// ① 이 회원의 첫 리뷰면 1000P (이미 지급됐으면 내부에서 자동으로 무시됨)
	pointService.earnFirstReviewBonus(mNo);
	
	// ② 리뷰가 달린 상품의 구매금액(od_amount) 3% 적립
	pointService.earnPurchaseReviewBonus(mNo, odAmount, orNo);
}
