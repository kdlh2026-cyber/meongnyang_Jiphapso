package com.springboot.meongnyang_Jiphapso.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.springboot.meongnyang_Jiphapso.dao.IMemberDAO;

@Controller
public class MainController {
	@Autowired
	IMemberDAO m_dao;
	
    @RequestMapping("/")
	public String root() {
		
		return "redirect:/main";
	}
    
    @RequestMapping("/main")
    public String main() {
    	return "main";
    }
	
	@RequestMapping("/loginForm")
	public String loginForm() {
		return "loginForm";
	}
	
	@RequestMapping("/memberInsertForm")
	public String insertForm() {
		return "memberInsertForm";
	}
	
	
}
