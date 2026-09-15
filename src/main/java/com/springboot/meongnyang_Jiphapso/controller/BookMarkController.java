package com.springboot.meongnyang_Jiphapso.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.springboot.meongnyang_Jiphapso.dao.IMemberDAO;
import com.springboot.meongnyang_Jiphapso.dto.CommunityDTO;
import com.springboot.meongnyang_Jiphapso.dto.MemberDTO;
import com.springboot.meongnyang_Jiphapso.service.BookMarkService;

@Controller
public class BookMarkController {
	@Autowired
    BookMarkService bookmarkService;

    @Autowired
    IMemberDAO m_dao;
    
    @PostMapping("/community/bookmark")
    @ResponseBody
    public String toggleBookmark(@RequestParam("comm_no") int comm_no,
    							 Authentication authentication) {
    	
    	if(authentication == null || authentication.getPrincipal() == null) {
    		return "LOGIN_REQUIRED";
    	}
    	
    	String username = authentication.getName();
    	MemberDTO member = m_dao.MemberFindId(username);
    	if(member == null) {
    		return "LOGIN_REQUIRED";
    	}
    	
    	return bookmarkService.toggleBookmark(comm_no, member.getM_no());
    }
    
    @GetMapping("/member/myBookmarks")
    public String myBookmarks(Authentication authentication, Model model) {
    		
    	if (authentication == null || authentication.getPrincipal() == null) {
            return "redirect:/loginForm";
        }
    	
    	String username = authentication.getName();
        MemberDTO member = m_dao.MemberFindId(username);
        
        List<CommunityDTO> bookmarkList = bookmarkService.getBookmarksByMemberNo(member.getM_no());
        model.addAttribute("bookmarkList", bookmarkList);
    	return "member/bookmark/myBookmarks";
    }
}
