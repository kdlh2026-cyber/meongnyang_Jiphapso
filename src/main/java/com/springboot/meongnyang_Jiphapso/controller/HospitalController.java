package com.springboot.meongnyang_Jiphapso.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.springboot.meongnyang_Jiphapso.dao.IHospitalDAO;
import com.springboot.meongnyang_Jiphapso.service.HospitalService;

@Controller
public class HospitalController {
	@Autowired
	IHospitalDAO hp_dao;
	
	@Autowired
	HospitalService hp_serv;
	
	@RequestMapping("/adimn/hospital/hospitalInsertForm")
	public String hp_insertForm() {
		return "admin/hospital/hospitalInsertForm";
	}
	
	@RequestMapping("/guest/hospital/hospitalList")
	public String hp_list() {
		return "guest/hospital/hospitalList";
	}
	
	@RequestMapping("/admin/hospital/hospitalList")
	public String hp_Alist() {
		return "admin/hospital/hospitalList";
	}
	
	@RequestMapping("/admin/hospital/hospitalUpdateForm")
	public String hp_updateForm() {
		return "admin/hospital/hospitalUpdateForm";
	}
}
