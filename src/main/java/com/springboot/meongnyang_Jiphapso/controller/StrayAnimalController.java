package com.springboot.meongnyang_Jiphapso.controller;

import java.io.File;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.springboot.meongnyang_Jiphapso.dao.ICommunityDAO;
import com.springboot.meongnyang_Jiphapso.dao.IStrayAnimalDao;
import com.springboot.meongnyang_Jiphapso.dto.CommunityDTO;
import com.springboot.meongnyang_Jiphapso.dto.StrayAnimalDto;
import com.springboot.meongnyang_Jiphapso.dto.StraySearchDto;
import com.springboot.meongnyang_Jiphapso.service.StrayService;

@Controller
public class StrayAnimalController {
	@Autowired
	IStrayAnimalDao stray_dao;
	@Autowired
	private StrayService stray_service;
	
	@Autowired
	ICommunityDAO comm_dao;
	
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
	public String strayListA(@ModelAttribute("searchDto") StraySearchDto searchDto, Model model) {

	    if (searchDto.getStray_category() == null || searchDto.getStray_category().trim().isEmpty()) {
	        searchDto.setStray_category("DOG");
	    }

	    int blockSize = 5;
	    int totalCount = stray_dao.StrayAnimalCount(searchDto); 
	    int totalPages = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / searchDto.getPageSize());

	    List<StrayAnimalDto> strayList = stray_dao.StrayAnimalPageList(searchDto);

	    int startPage = ((searchDto.getPage() - 1) / blockSize) * blockSize + 1;
	    int endPage = startPage + blockSize - 1;
	    if (endPage > totalPages) endPage = totalPages;

	    model.addAttribute("StrayAnimalList", strayList);
	    model.addAttribute("totalCount", totalCount);
	    model.addAttribute("totalPages", totalPages);
	    model.addAttribute("startPage", startPage);
	    model.addAttribute("endPage", endPage);
	    model.addAttribute("hasPrev", startPage > 1);
	    model.addAttribute("hasNext", endPage < totalPages);
	    model.addAttribute("currentPage", searchDto.getPage());
	    
	    return "admin/stray/StrayListA";
	}
	
	@GetMapping("/api/breeds")
	@ResponseBody
	public List<String> getBreeds(@RequestParam(value = "stray_category", required = false) String stray_category) {
	    return stray_service.getListCategory(stray_category); 
	}
	
	@RequestMapping("/StrayAnimalDelete")
	public String StrayAnimalDelete(@RequestParam("stray_no") Long stray_no) {
		stray_dao.StrayAnimalDelete(stray_no);
		return "redirect:/admin/stray/StrayListA";
	}
	
	@RequestMapping("/guest/StrayList")
	public String StrayList(@ModelAttribute("searchDto") StraySearchDto searchDto, Model model) {
	    
	    // 기본값 강아지 설정
	    if (searchDto.getStray_category() == null || searchDto.getStray_category().trim().isEmpty()) {
	        searchDto.setStray_category("DOG");
	    }

	    int blockSize = 5;
	    int totalCount = stray_dao.StrayAnimalCount(searchDto); 
	    int totalPages = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / searchDto.getPageSize());

	    List<StrayAnimalDto> strayList = stray_dao.StrayAnimalPageList(searchDto);

	    int startPage = ((searchDto.getPage() - 1) / blockSize) * blockSize + 1;
	    int endPage = startPage + blockSize - 1;
	    if (endPage > totalPages) endPage = totalPages;

	    model.addAttribute("StrayAnimalList", strayList);
	    model.addAttribute("totalCount", totalCount);
	    model.addAttribute("totalPages", totalPages);
	    model.addAttribute("startPage", startPage);
	    model.addAttribute("endPage", endPage);
	    model.addAttribute("hasPrev", startPage > 1);
	    model.addAttribute("hasNext", endPage < totalPages);
	    model.addAttribute("currentPage", searchDto.getPage());
	    
	    return "guest/StrayList";
	}
	
	@RequestMapping("/guest/StrayView")
	public String StrayView(@RequestParam("stray_no") Long stray_no,
			CommunityDTO comm_dto,
			Model model) {
		StrayAnimalDto strayView = stray_dao.StrayView(stray_no);
		String stray_category = (strayView != null) ? strayView.getStray_category() : null;
		String pet_type = "";
		if(stray_category.equals("DOG")) {
			pet_type = "강아지";
		}
		else if(stray_category.equals("CAT")) {
			pet_type = "고양이";	
		}
		
		List<CommunityDTO> contentList = comm_dao.strayContentView(comm_dto, pet_type);
		List<StrayAnimalDto> randomList = stray_dao.StrayRandomView(stray_category);
		model.addAttribute("ContentList", contentList);
		model.addAttribute("StrayRandomView", randomList);
		model.addAttribute("StrayView", strayView);
		return "guest/StrayView";
	}
	
	@RequestMapping("/strayUpdateForm")
	public String strayUpdateForm(@RequestParam("stray_no") Long stray_no, Model model) {
		model.addAttribute("StrayUpdate", stray_dao.StrayView(stray_no));
		return "admin/stray/strayUpdateForm";
	}
	
	@RequestMapping("/StrayAnimalUpdate")
	public String StrayAnimalUpdate(StrayAnimalDto stray_dto,
			@RequestParam(value = "main_img", required = false) MultipartFile main_img,
			@RequestParam(value = "existing_stray_img", required = false) String existing_stray_img)
			throws Exception {
			
		if (main_img != null && !main_img.isEmpty()) {
	        String originalFilename = main_img.getOriginalFilename();
	        String savedFilename = UUID.randomUUID().toString() + "_" + originalFilename;

	        String uploadFolder = "C:/upload/stray/";
	        File uploadPath = new File(uploadFolder);
	        if (!uploadPath.exists()) {
	            uploadPath.mkdirs();
	        }

	        main_img.transferTo(new File(uploadPath, savedFilename));
	        stray_dto.setStray_img(savedFilename);
	    } else {
	        stray_dto.setStray_img(existing_stray_img);
	    }

	    stray_dao.StrayAnimalUpdate(stray_dto);
		
		return "redirect:/admin/stray/StrayListA";
	}
}
