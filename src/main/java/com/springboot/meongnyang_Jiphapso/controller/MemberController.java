package com.springboot.meongnyang_Jiphapso.controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.springboot.meongnyang_Jiphapso.dao.IMemberDAO;
import com.springboot.meongnyang_Jiphapso.dto.MemberDTO;

@Controller
public class MemberController {
	@Autowired
	IMemberDAO m_dao;
	
    private final PasswordEncoder passwordEncoder;

    MemberController(PasswordEncoder passwordEncoder) {
        this.passwordEncoder = passwordEncoder;
    }
    
    @RequestMapping("/member/dc_mem/myPage")
    public String myPage() {
    	return "member/dc_mem/myPage";
    }
    
    @RequestMapping("/member/dc_mem/myPetPage")
    public String myPetPage() {
    	return "member/dc_mem/myPetPage";
    }
    
    @RequestMapping("/member/dc_mem/myPetInsertForm")
    public String myPetInsertForm() {
    	return "member/dc_mem/myPetInsertForm";
    }
	
	@RequestMapping("/loginError")
	public String loginError() {
		return "loginError";
	}
	
	@RequestMapping("/memberInsert")
	public String login(MemberDTO m_dto) {
		m_dto.setM_passwd(passwordEncoder.encode(m_dto.getM_passwd()));
		m_dto.setM_authority("USER");
		m_dao.MemberWrite(m_dto);
		
		return "redirect:/main";
	}
	
}
