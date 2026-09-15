package com.springboot.meongnyang_Jiphapso.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.springboot.meongnyang_Jiphapso.common.SessionConst;
import com.springboot.meongnyang_Jiphapso.dao.ICommentDAO;
import com.springboot.meongnyang_Jiphapso.dao.IMemberDAO;
import com.springboot.meongnyang_Jiphapso.dto.CommentDTO;
import com.springboot.meongnyang_Jiphapso.dto.MemberDTO;
import com.springboot.meongnyang_Jiphapso.service.CommentService;

import jakarta.servlet.http.HttpSession;

@Controller
public class CommentController {
	@Autowired
	CommentService service;
	
	@Autowired
	ICommentDAO cmt_dao;
	
	@Autowired
	IMemberDAO m_dao;
	
	// 댓글 달기
	@PostMapping("/commentWrite")
	public String commentwrite(CommentDTO dto,
							@RequestParam(value="comm_no", required=false) Integer comm_no,
							@RequestParam(value="comm_type", required=false) String comm_type,
							HttpSession session,
							Authentication authentication
							) throws Exception {
		
		if(authentication != null && authentication.getPrincipal() != null) {
			String username = authentication.getName();
			MemberDTO member = m_dao.MemberFindId(username);
			dto.setM_no(member.getM_no()); 
			dto.setCmt_writer(username);
		}
		
		dto.setCmt_type_no(comm_no);
		dto.setCmt_type(comm_type);
		
		if (dto.getCmt_answer_no() != null && dto.getCmt_answer_no() == 0) {
			dto.setCmt_answer_no(null);
		}
		
		service.write(dto);	
		
		return "redirect:/community/commView?comm_no=" + comm_no;
	}
	
	// 답글 달기
	@PostMapping("/community/replyWrite")
	public String replyWrite(CommentDTO dto,
							 @RequestParam(value="cmt_answer_no", required=false) Integer cmt_answer_no,
							 @RequestParam(value="comm_no", required=false) Integer comm_no,
							 @RequestParam(value="comm_type", required=false) String comm_type,
							 Authentication authentication
							 ) throws Exception {
		
		if(authentication != null && authentication.getPrincipal() != null) {
			String username = authentication.getName();
			MemberDTO member = m_dao.MemberFindId(username);
			dto.setM_no(member.getM_no()); 
			dto.setCmt_writer(username);
		}
		
		dto.setCmt_answer_no(cmt_answer_no);
		dto.setCmt_type_no(comm_no);
		dto.setCmt_type(comm_type);
		
		service.write(dto);
		
		return "redirect:/community/commView?comm_no=" + comm_no;
	}
	
	// 내가 쓴 댓글 삭제
	@RequestMapping("/comment/delete")
	public String commentDelete(@RequestParam("cmt_no") int cmt_no,
								HttpSession session,
								@RequestHeader(value = "Referer", required = false) String referer
								) {

		Integer m_no = (Integer) session.getAttribute(SessionConst.LOGIN_MEMBER_NO);

		if (m_no == null) {
			return "redirect:/loginForm";
		}

		service.deleteComment(cmt_no, m_no);
		
		if (referer != null && !referer.isEmpty()) {
			return "redirect:" + referer;
		}

		return "redirect:/community/myCommunity";
	}
	
	// 댓글 수정
	@PostMapping("/comment/update")
	public String commentUpdate(@RequestParam("cmt_no") int cmt_no,
								@RequestParam("comm_no") int comm_no,
								@RequestParam("cmt_content") String cmt_content,
								HttpSession session) {

		Integer m_no = (Integer) session.getAttribute(SessionConst.LOGIN_MEMBER_NO);

		if (m_no == null) {
			return "redirect:/loginForm";
		}

		service.updateComment(cmt_no, m_no, cmt_content);

		return "redirect:/community/commView?comm_no=" + comm_no;
	}
	
	// 상품 리뷰 작성
	@PostMapping("/review/register")
	public String reviewRegister(CommentDTO dto,
							   @RequestParam("orNo") Long orNo,
							   @RequestParam("odDetailNo") Integer odDetailNo,
							   @RequestParam("p_no") Long p_no,
							   @RequestParam("cmt_content") String cmt_content, // ★ reviewContent 가 아니라 cmt_content로 맞춤
							   @RequestParam("cmt_score") Integer cmt_score,     // 별점 평점 파라미터
							   Authentication authentication
							   ) throws Exception {
		
		if(authentication != null && authentication.getPrincipal() != null) {
			String username = authentication.getName();
			MemberDTO member = m_dao.MemberFindId(username);
			dto.setM_no(member.getM_no()); 
			dto.setCmt_writer(username);
		}
		
		dto.setCmt_type("REVIEW");            
		dto.setCmt_type_no(odDetailNo);       
		dto.setCmt_content(cmt_content);       // ★ JSP의 cmt_content와 일치시킴
		dto.setCmt_score(cmt_score);           
		dto.setCmt_deleted("N");   
		dto.setP_no(p_no);
		
		if (dto.getCmt_answer_no() != null && dto.getCmt_answer_no() == 0) {
			dto.setCmt_answer_no(null);
		}
		
		service.ReviewWrite(dto);
		
		return "redirect:/member/order/" + orNo;
	}
	
	// 상품 리뷰 삭제
	@RequestMapping("/review/delete")
	public String reviewDelete(@RequestParam(value = "cmt_no", required = false) Integer cmt_no, 
							   @RequestParam("orNo") Long orNo, 
							   HttpSession session,
							   Authentication authentication) {
		if (cmt_no == null) {
			return "redirect:/member/order/" + orNo;
		}
		
		int m_no = 0;
		
		if (authentication != null && authentication.getPrincipal() != null) {
			String username = authentication.getName();
			MemberDTO member = m_dao.MemberFindId(username);
			if (member != null) {
				m_no = member.getM_no();
			}
		}
		
		if (m_no == 0) {
			Integer sessionMNo = (Integer) session.getAttribute(SessionConst.LOGIN_MEMBER_NO);
			if (sessionMNo == null) {
				return "redirect:/loginForm";
			}
			m_no = sessionMNo;
		}
		
		service.reviewDelete(cmt_no, m_no);
		
		return "redirect:/member/order/" + orNo; 
	}
	
	// 마이페이지 전용 상품 리뷰 삭제
	@RequestMapping("/community/reviewDelete")
	public String communityReviewDelete(@RequestParam("cmt_no") Integer cmt_no, 
									    HttpSession session,
									    Authentication authentication) {
		int m_no = 0;
		
		if (authentication != null && authentication.getPrincipal() != null) {
			String username = authentication.getName();
			MemberDTO member = m_dao.MemberFindId(username);
			if (member != null) {
				m_no = member.getM_no();
			}
		}
		
		if (m_no == 0) {
			Integer sessionMNo = (Integer) session.getAttribute(SessionConst.LOGIN_MEMBER_NO);
			if (sessionMNo == null) {
				return "redirect:/loginForm";
			}
			m_no = sessionMNo;
		}
		
		service.reviewDelete(cmt_no, m_no);
		
		return "redirect:/community/myCommunity?comm_type=REVIEW";
	}
	
	// 상품 리뷰 수정
	@PostMapping("/review/update")
	public String reviewUpdate(@RequestParam("cmt_no") Integer cmt_no,
							   @RequestParam("orNo") Long orNo,
							   @RequestParam("cmt_content") String cmt_content,
							   @RequestParam("cmt_score") Integer cmt_score, // ★ [추가] 수정할 별점 받기
							   HttpSession session,
							   Authentication authentication) {
		
		int m_no = 0;
		
		if (authentication != null && authentication.getPrincipal() != null) {
			String username = authentication.getName();
			MemberDTO member = m_dao.MemberFindId(username);
			if (member != null) {
				m_no = member.getM_no();
			}
		}
		
		if (m_no == 0) {
			Integer sessionMNo = (Integer) session.getAttribute(SessionConst.LOGIN_MEMBER_NO);
			if (sessionMNo == null) {
				return "redirect:/loginForm";
			}
			m_no = sessionMNo;
		}
		
		service.reviewUpdate(cmt_no, m_no, cmt_content, cmt_score);
		
		return "redirect:/member/order/" + orNo;
	}
}