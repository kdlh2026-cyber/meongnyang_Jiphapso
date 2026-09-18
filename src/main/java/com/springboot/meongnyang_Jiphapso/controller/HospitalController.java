package com.springboot.meongnyang_Jiphapso.controller;

import java.beans.PropertyEditorSupport;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.springboot.meongnyang_Jiphapso.dao.IHospitalDAO;
import com.springboot.meongnyang_Jiphapso.dto.HospitalDTO;
import com.springboot.meongnyang_Jiphapso.service.HospitalService;

@Controller
public class HospitalController {
	@Autowired
	IHospitalDAO hp_dao;

	@Autowired
	HospitalService hp_serv;
	
	@InitBinder
	public void initBinder(WebDataBinder binder) {
	    binder.registerCustomEditor(Double.class, new PropertyEditorSupport() {
	        @Override
	        public void setAsText(String text) {
	            if (text == null || text.trim().isEmpty()) {
	                setValue(null);
	            } else {
	                setValue(Double.valueOf(text));
	            }
	        }
	    });
	}

	@RequestMapping("/admin/hospital/hospitalInsertForm")
	public String hp_insertForm() {
		return "admin/hospital/hospitalInsertForm";
	}

	@RequestMapping("/hp_insert")
	public String hp_insert(HospitalDTO hp_dto) throws Exception {
		hp_serv.write(hp_dto);
		return "redirect:/admin/hospital/hospitalList";
	}

	@RequestMapping("/guest/hospital/hospitalList")
	public String hp_list(@RequestParam(value = "keyword", required = false) String keyword,
	                       @RequestParam(value = "page", defaultValue = "1") int page,
	                       Model model) throws Exception {

	    int pageSize = 10;
	    int startRow = (page - 1) * pageSize + 1;
	    int endRow = page * pageSize;

	    List<HospitalDTO> list = hp_serv.selectList(keyword, startRow, endRow);
	    int totalCount = hp_serv.getTotalCount(keyword);
	    int totalPages = (int) Math.ceil((double) totalCount / pageSize);

	    model.addAttribute("hospitalList", list);
	    model.addAttribute("pageNum", page);
	    model.addAttribute("totalPages", totalPages);
	    model.addAttribute("totalCount", totalCount);

	    return "guest/hospital/hospitalList";
	}
	
	@RequestMapping("/guest/hospital/hospitalView")
	public String hp_view(@RequestParam("hp_no") int hp_no, Model model) {
		model.addAttribute("hospital", hp_serv.view(hp_no));
		return "guest/hospital/hospitalView";
	}

	@RequestMapping("/admin/hospital/hospitalUpdateForm")
	public String hp_updateForm(@RequestParam("hp_no") int hp_no, Model model) {
		model.addAttribute("hospitalUpdate", hp_serv.view(hp_no));
		return "admin/hospital/hospitalUpdateForm";
	}

	@RequestMapping("/hp_update")
	public String hp_update(HospitalDTO hp_dto) throws Exception {
		hp_serv.update(hp_dto);
		return "redirect:/admin/hospital/hospitalList";
	}

	@RequestMapping("/hp_delete")
	public String hp_delete(@RequestParam("hp_no") int hp_no) {
		hp_serv.delete(hp_no);
		return "redirect:/admin/hospital/hospitalList";
	}

	//자동완성 -> 화면 출력
	@org.springframework.web.bind.annotation.ResponseBody
	@RequestMapping("/hospital/autocomplete")
	public java.util.List<java.util.Map<String,String>> autocomplete(@RequestParam("keyword") String keyword) throws Exception{
		return hp_serv.autocomplete(keyword);
	}

	@RequestMapping("/hospital_search")
	public String hp_search(@RequestParam("keyword") String keyword, Model model) throws Exception {
		model.addAttribute("hospitalList", hp_serv.search(keyword));
		return "guest/hospital/hospitalList";
	}
	
	// Controller
	@RequestMapping("/admin/hospital/hospitalList")
	public String hp_Alist(Model model) throws Exception {
		Map<String, Map<String, List<HospitalDTO>>> grouped = hp_serv.groupByRegion();
		List<Entry<String, Integer>> guRanking = hp_serv.guRanking();
		Map<String, Integer> guTotalCount = hp_serv.guTotalCount();
		int totalCount = hp_serv.list().size();

		model.addAttribute("grouped", grouped);
		model.addAttribute("guRanking", guRanking);
		model.addAttribute("guTotalCount", guTotalCount);
		model.addAttribute("totalCount", totalCount);

		return "admin/hospital/hospitalList";
	}
}