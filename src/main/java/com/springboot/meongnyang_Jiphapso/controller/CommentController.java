package com.springboot.meongnyang_Jiphapso.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

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
	
}
