package com.springboot.meongnyang_Jiphapso.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.springboot.meongnyang_Jiphapso.dao.IMemberDAO;
import com.springboot.meongnyang_Jiphapso.dto.MemberDTO;
import com.springboot.meongnyang_Jiphapso.service.MemberService;

@Controller
public class AdminController {
	@Autowired
	IMemberDAO m_dao;
	
	@Autowired
	MemberService mem_serv;
	
	@RequestMapping("/admin/adminPage")
	public String adminPage() {
		return "admin/adminPage";
	}
	
	@RequestMapping("/admin/mem/memberList")
	public String memberList(Model model) {
	    model.addAttribute("memberList", m_dao.MemberListView("USER"));
	    return "admin/mem/memberList";
	}
	
	@RequestMapping("/admin/mem/AmemDetail")
	public String AmemDetail(@RequestParam("m_id") String m_id,Model model) {
		model.addAttribute("memDetail",m_dao.MemberView(m_id));
		return "admin/mem/AmemDetail";
	}
	
	@RequestMapping("/memSearch")
	public String memSearch(@RequestParam("keyword") String keyword,Model model) throws Exception{
		List<MemberDTO> list=mem_serv.search(keyword);
		model.addAttribute("list",list);
		return "admin/mem/memberList";
	}
	
	//자동완성 -> 화면 출력(파일 따로 생성 X)
	@ResponseBody
	@RequestMapping("/admin/mem_autocomplete")
	public List<Map<String,String>> autocomplete(@RequestParam("keyword") String keyword) throws Exception{
		return mem_serv.autocomplete(keyword);
	}
	
	@ResponseBody
	@RequestMapping("/memSearchAjax")
	public List<MemberDTO> memSearchAjax(@RequestParam("keyword") String keyword) throws Exception{
	    return mem_serv.search(keyword);
	}
	
	@RequestMapping("/AmemberDelete")
	public String AmemDelte(@RequestParam("m_id") String m_id) {
		m_dao.MemberDelete(m_id);
		
		return "redirect:admin/mem/memberList";
	}
}
