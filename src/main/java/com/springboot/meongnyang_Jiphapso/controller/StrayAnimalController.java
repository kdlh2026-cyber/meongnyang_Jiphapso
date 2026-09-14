package com.springboot.meongnyang_Jiphapso.controller;

import java.io.File;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.springboot.meongnyang_Jiphapso.dao.IStrayAnimalDao;
import com.springboot.meongnyang_Jiphapso.dto.StrayAnimalDto;
import com.springboot.meongnyang_Jiphapso.service.StrayService;

@Controller
public class StrayAnimalController {
	@Autowired
	IStrayAnimalDao stray_dao;
	@Autowired
	private StrayService stray_service;
	
	@RequestMapping("/strayWriteForm")
	public String strayWriteForm() {
		return "admin/stray/strayWriteForm";
	}
	
	@RequestMapping("/StrayAnimalWrite")
	public String StrayAnimalWrite(StrayAnimalDto stray_dto,
			@RequestParam("main_img") MultipartFile main_img) throws Exception {
		
		String uploadFolder = "C:/upload/stray/";
	    
	    File uploadDir = new File(uploadFolder);
	    if(!uploadDir.exists()) {
	        uploadDir.mkdirs();
	    }
	    
	    String stray_img = main_img.getOriginalFilename();
	    
	    // 다른곳 저장
	    main_img.transferTo(new File(uploadFolder + stray_img));
	    
	    stray_dto.setStray_img(stray_img);
	    stray_service.stray_write(stray_dto);
		
		return "redirect:main";
	}
	
	@RequestMapping("/admin/stray/StrayListA")
	public String StrayListA(Model model,
	        @RequestParam(value = "page", defaultValue = "1") int page) {
	    
	    int pageSize = 15; // 한 페이지에 보여줄 데이터 수
	    int blockSize = 5; // 하단에 보여줄 페이지 버튼 개수
	    int offset = (page - 1) * pageSize;

	    List<StrayAnimalDto> strayList = stray_dao.StrayAnimalPageList(offset, pageSize);
	    
	    int totalCount = stray_dao.StrayAnimalCount();
	    int totalPages = (int) Math.ceil((double) totalCount / pageSize);

	    // 페이지 제한
	    int startPage = ((page - 1) / blockSize) * blockSize + 1;
	    int endPage = startPage + blockSize - 1;
	    
	    // 끝 페이지가 실제 총 페이지 수보다 커지지 않도록 처리
	    if (endPage > totalPages) {
	        endPage = totalPages;
	    }
	    
	    // 이전/다음 화살표 활성화 여부
	    boolean hasPrev = startPage > 1;
	    boolean hasNext = endPage < totalPages;

	    model.addAttribute("StrayAnimalList", strayList);
	    model.addAttribute("currentPage", page);
	    model.addAttribute("totalPages", totalPages);
	    
	    model.addAttribute("startPage", startPage);
	    model.addAttribute("endPage", endPage);
	    model.addAttribute("hasPrev", hasPrev);
	    model.addAttribute("hasNext", hasNext);
	    
	    return "admin/stray/StrayListA";
	}
	
	@RequestMapping("/StrayAnimalDelete")
	public String StrayAnimalDelete(@RequestParam("stray_no") Long stray_no) {
		stray_dao.StrayAnimalDelete(stray_no);
		return "redirect:/admin/stray/StrayListA";
	}
	
	@RequestMapping("/guest/StrayList")
	public String StrayList(Model model,
	        @RequestParam(value = "page", defaultValue = "1") int page) {
	    
	    int pageSize = 15; // 한 페이지에 보여줄 데이터 수
	    int blockSize = 5; // 하단에 보여줄 페이지 버튼 개수
	    int offset = (page - 1) * pageSize;

	    List<StrayAnimalDto> strayList = stray_dao.StrayAnimalPageList(offset, pageSize);
	    
	    int totalCount = stray_dao.StrayAnimalCount();
	    int totalPages = (int) Math.ceil((double) totalCount / pageSize);

	    // 페이지 제한
	    int startPage = ((page - 1) / blockSize) * blockSize + 1;
	    int endPage = startPage + blockSize - 1;
	    
	    // 끝 페이지가 실제 총 페이지 수보다 커지지 않도록 처리
	    if (endPage > totalPages) {
	        endPage = totalPages;
	    }
	    
	    // 이전/다음 화살표 활성화 여부
	    boolean hasPrev = startPage > 1;
	    boolean hasNext = endPage < totalPages;

	    model.addAttribute("StrayAnimalList", strayList);
	    model.addAttribute("currentPage", page);
	    model.addAttribute("totalPages", totalPages);
	    
	    model.addAttribute("startPage", startPage);
	    model.addAttribute("endPage", endPage);
	    model.addAttribute("hasPrev", hasPrev);
	    model.addAttribute("hasNext", hasNext);
	    
	    return "guest/StrayList";
	}
	
	@RequestMapping("/guest/StrayView")
	public String StrayView(@RequestParam("stray_no") Long stray_no, Model model) {
		model.addAttribute("StrayView", stray_dao.StrayView(stray_no));
		return "guest/StrayView";
	}
	
}
