package com.springboot.meongnyang_Jiphapso.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.springboot.meongnyang_Jiphapso.dao.IProductDao;
import com.springboot.meongnyang_Jiphapso.dto.ProductDetailImageDto;
import com.springboot.meongnyang_Jiphapso.dto.ProductDto;
import com.springboot.meongnyang_Jiphapso.dto.ProductOptionDto;
import com.springboot.meongnyang_Jiphapso.dto.ShoppingListDto;
import com.springboot.meongnyang_Jiphapso.service.ProductService;

@Controller
public class ProductController {
	@Autowired
	private IProductDao p_dao;
	@Autowired
	private ProductService p_service;
	
	@RequestMapping("/productWriteForm")
	public String productWriteForm() {
		return "admin/product/productWriteForm";
	}
	
	@RequestMapping("/productWrite")
	public String productWrite(ProductDto p_dto, ProductDetailImageDto img_dto, ProductOptionDto o_dto,
			 @RequestParam("o_img") MultipartFile o_img, @RequestParam("img_urls") List<MultipartFile> img_urls,
			 @RequestParam(value="o_quantity", defaultValue="100") int o_quantity, @RequestParam("o_price") int o_price,
			 @RequestParam(value="o_default", required = false) String o_default,
			 @RequestParam("p_title") String p_title, @RequestParam(value="o_origin_price", required = false) Integer o_origin_price
			 ) throws Exception{
		
		ProductDto findtitle = p_dao.getProductByTitle(p_title);
		  
		int generatedPno;
		
		if(findtitle == null) {
			p_service.p_write(p_dto);	
			generatedPno = p_dto.getP_no(); 
		} 
		else {
			generatedPno = findtitle.getP_no(); 
		}
		  
		o_dto.setP_no(generatedPno);
		
		//
		
	    if(o_price == 0) {
	    	o_dto.setO_quantity(0);
	    }
	    else {
	    	o_dto.setO_quantity(o_quantity);
	    }
	    
	    if(o_origin_price == null) {
	    	o_dto.setO_origin_price(o_price);
	    }
	    
	    if(!"Y".equals(o_default)) {
	        o_dto.setO_default("N");
	    }
	    
		if(!o_img.isEmpty()) {
			String o_main_img = o_img.getOriginalFilename();
			o_img.transferTo(new File("C:\\SPRINGBOOT\\meongnyang_Jiphapso\\src\\main\\resources\\static\\images\\products\\main\\"+o_main_img));
			o_dto.setO_main_img(o_main_img);
		}
		else {
			o_dto.setO_main_img(null);
		}
		
		o_dto.setP_no(generatedPno);
		
		p_dao.ProductOptionWrite(o_dto);
		
		int sortOrder = 1;

		for (MultipartFile fname : img_urls) {
		    if (!fname.isEmpty()) {
		        String img_url = fname.getOriginalFilename();
		        fname.transferTo(new File("C:\\SPRINGBOOT\\meongnyang_Jiphapso\\src\\main\\resources\\static\\images\\products\\info\\"+img_url));
		        
		        ProductDetailImageDto detailDto = new ProductDetailImageDto();
		        
		        detailDto.setImg_url(img_url);
		        detailDto.setImg_sort(sortOrder);
		        detailDto.setP_no(generatedPno);
		        
		        if (sortOrder == 1) {
		            detailDto.setImg_content(img_dto.getImg_content());
		        }
		        else {
		        	detailDto.setImg_content(null);
		        }
		        
		        sortOrder++;
		        
		        p_dao.ProductDetailImageWrite(detailDto);
		    }
		}		
		return "redirect:main";
	}
	
	@RequestMapping("/products/ShoppingList")
	public String ShoppingList(
	        @RequestParam(value = "p_type", defaultValue = "강아지") String p_type,
	        @RequestParam(value = "mode", required = false) String p_category,
	        Model model) {

	    if (!"고양이".equals(p_type)) {
	        p_type = "강아지";
	    }
	    
	    ShoppingListDto paramDto = new ShoppingListDto();
	    paramDto.setPtype(p_type);
	    paramDto.setPcategory(p_category); // 카테고리(mode)가 없으면 null 혹은 빈값

	    List<ShoppingListDto> allList = p_dao.ShoppingList(paramDto);
	    
	    model.addAttribute("ShoppingList", allList);
	    
	    return "products/ShoppingList";
	}
	
	@RequestMapping("/ProductListA")
	public String ProductListA(ShoppingListDto s_dto, Model model,
			@RequestParam(value = "p_type", defaultValue = "강아지") String p_type,
			@RequestParam(value = "mode", required = false) String p_category) {
		
		if (!"고양이".equals(p_type)) {
	        p_type = "강아지";
	    }
		
		ShoppingListDto paramDto = new ShoppingListDto();
	    paramDto.setPtype(p_type);
	    paramDto.setPcategory(p_category); // 카테고리(mode)가 없으면 null 혹은 빈값

	    List<ShoppingListDto> allList = p_dao.ShoppingList(paramDto);
	    
	    model.addAttribute("ShoppingList", allList);
		
		return "admin/product/ProductListA";
	}
	
	@RequestMapping("/products/ShoppingView")
	public String ShoppingView(@RequestParam("p_no") int p_no, Model model) {
		model.addAttribute("ShoppingView", p_dao.ShoppingView(p_no));
		return "products/ShoppingView";
	}
	
	@RequestMapping("/productDelete")
	public String ProductDelete(@RequestParam("p_no") int p_no) {
		p_dao.ProductDelete(p_no);
		return "redirect:/productList";
	}
	
	@RequestMapping("/products/search")
	public String p_search(@RequestParam("keyword") String keyword, Model model) throws Exception {
		List<ShoppingListDto> p_list = p_service.p_search(keyword);
		model.addAttribute("ShoppingList", p_list);
		return "products/ShoppingList";
	}
	
	@ResponseBody
	@RequestMapping("/products/autocomplete")
	public List<Map<String, String>> p_autocomplete(@RequestParam("keyword") String keyword, Model model) throws Exception{
		return p_service.p_autocomplete(keyword);
	}
}