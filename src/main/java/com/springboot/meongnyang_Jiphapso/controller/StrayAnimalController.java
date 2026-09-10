package com.springboot.meongnyang_Jiphapso.controller;

import java.io.File;
import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.springboot.meongnyang_Jiphapso.dao.IStrayAnimalDao;
import com.springboot.meongnyang_Jiphapso.dto.StrayAnimalDto;

@Controller
public class StrayAnimalController {
	@Autowired
	IStrayAnimalDao stray_dao;
	
	@RequestMapping("/strayWriteForm")
	public String strayWriteForm() {
		return "admin/stray/strayWriteForm";
	}
	
	@RequestMapping("/StrayAnimalWrite")
	public String StrayAnimalWrite(StrayAnimalDto stray_dto,
			@RequestParam("main_img") MultipartFile main_img) throws IOException{
		
		String uploadFolder = "C:/upload/stray/";
	    
	    File uploadDir = new File(uploadFolder);
	    if(!uploadDir.exists()) {
	        uploadDir.mkdirs();
	    }
	    
	    String stray_img = main_img.getOriginalFilename();
	    
	    // 다른곳 저장
	    main_img.transferTo(new File(uploadFolder + stray_img));
	    
	    stray_dto.setStray_img(stray_img);
	    stray_dao.StrayAnimalWrite(stray_dto);
		
		return "redirect:main";
	}
	
}
