package com.springboot.meongnyang_Jiphapso.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.springboot.meongnyang_Jiphapso.dao.IMemberDAO;
import com.springboot.meongnyang_Jiphapso.dao.IProductDao;
import com.springboot.meongnyang_Jiphapso.dto.CommunityDTO;
import com.springboot.meongnyang_Jiphapso.dto.ShoppingListDto;
import com.springboot.meongnyang_Jiphapso.service.CommunityService;
import com.springboot.meongnyang_Jiphapso.service.ProductService;

@Controller
public class MainController {
	@Autowired
	IMemberDAO m_dao;
	
	@Autowired
	IProductDao p_dao;
	
	@Autowired
	CommunityService comm_serv;
	
	@Autowired
	ProductService pd_serv;
	
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
	
	@RequestMapping("/loginError")
	public String loginError() {
		return "/main";
	}
	
	@RequestMapping("/memberInsertForm")
	public String insertForm() {
		return "memberInsertForm";
	}
	
	@RequestMapping("/allSearch")
	public String allSearch(@RequestParam("keyword") String keyword, Model model) throws Exception {
	    List<CommunityDTO> CMList = comm_serv.search(keyword);
	    List<ShoppingListDto> PDList = pd_serv.p_search(keyword);

	    model.addAttribute("keyword", keyword);
	    model.addAttribute("CMList", CMList);
	    model.addAttribute("PDList", PDList);
	    model.addAttribute("cmTotal", CMList.size());
	    model.addAttribute("pdTotal", PDList.size());

	    return "guest/mainSearchList";
	}
	
	@RequestMapping("/guest/mainSearchList")
	public String mainSearchList() {
		return "guest/mainSearchList";
	}
	
	//자동완성 -> 화면 출력(파일 따로 생성 X)
	@ResponseBody
	@RequestMapping("/main_autocomplete")
	public List<Map<String,String>> autocomplete(@RequestParam("keyword") String keyword) throws Exception{
		return comm_serv.autocomplete(keyword);
	}
	
	@RequestMapping("/guest/etc/companyIntroduce")
	public String companyI() {
		return "guest/etc/companeyIntroduce";
	}
	
	@RequestMapping("/guest/etc/ToS")
	public String ToSI() {
		return "guest/etc/ToS";
	}
	
	@RequestMapping("/guest/etc/privacyPolicy")
	public String pp() {
		return "guest/etc/privacyPolicy";
	}
	
	@RequestMapping("/loading_animal")
	public String loading() {
		return "loading_animal";
	}
	
}
