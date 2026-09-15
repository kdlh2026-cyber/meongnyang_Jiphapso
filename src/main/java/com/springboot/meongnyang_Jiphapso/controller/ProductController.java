package com.springboot.meongnyang_Jiphapso.controller;

import java.io.File;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.springboot.meongnyang_Jiphapso.dao.IProductDao;
import com.springboot.meongnyang_Jiphapso.dto.CommentDTO;
import com.springboot.meongnyang_Jiphapso.dto.ProductDetailImageDto;
import com.springboot.meongnyang_Jiphapso.dto.ProductDto;
import com.springboot.meongnyang_Jiphapso.dto.ProductOptionDto;
import com.springboot.meongnyang_Jiphapso.dto.ShoppingListDto;
import com.springboot.meongnyang_Jiphapso.service.CommentService;
import com.springboot.meongnyang_Jiphapso.service.ProductService;

@Controller
public class ProductController {
	@Autowired
	private IProductDao p_dao;
	@Autowired
	private ProductService p_service;
	@Autowired
	private CommentService cmt_service;
	
	@RequestMapping("/productWriteForm")
	public String productWriteForm() {
		return "admin/product/productWriteForm";
	}
	
	@RequestMapping("/productWrite")	
	public String productWrite(
	        ProductDto p_dto, ProductOptionDto o_dto,
	        @RequestParam(value="o_img", required = false) MultipartFile o_img, 
	        @RequestParam(value="img_urls", required = false) List<MultipartFile> img_urls,
	        @RequestParam(value="o_quantity", defaultValue="100") int o_quantity, 
	        @RequestParam("o_price") int o_price,
	        @RequestParam(value="o_default", required = false) String o_default,
	        @RequestParam("p_title") String p_title, 
	        @RequestParam(value="o_origin_price", required = false) Integer o_origin_price
	) throws Exception {

	    p_service.productWrite(p_dto, o_dto, o_img, img_urls, o_quantity, o_price, o_default, p_title, o_origin_price);
	    
	    return "redirect:/ProductListA";
	}
	
	@RequestMapping("/products/ShoppingList")
	public String ShoppingList(
			@RequestParam(value = "p_type", defaultValue = "강아지") String p_type,
			@RequestParam(value = "mode", required = false) String p_category,
			@RequestParam(value = "keyword", required = false) String keyword,
			Model model) throws Exception {
		
		List<ShoppingListDto> p_list;
		
		if (keyword != null && !keyword.trim().isEmpty()) {
			p_list = p_service.p_search(keyword);
		} else {
			if (!"고양이".equals(p_type)) {
				p_type = "강아지";
			}
			
			ShoppingListDto paramDto = new ShoppingListDto();
			paramDto.setPtype(p_type);
			paramDto.setPcategory(p_category);

			p_list = p_dao.ShoppingList(paramDto);
		}
		
		model.addAttribute("ShoppingList", p_list);
		return "products/ShoppingList";
	}
	
	@RequestMapping("/ProductListA")
	public String ProductListA(
			Model model,
			@RequestParam(value = "p_type", defaultValue = "강아지") String p_type,
			@RequestParam(value = "mode", required = false) String p_category) {
		
		if (!"고양이".equals(p_type)) {
			p_type = "강아지";
		}
		
		ShoppingListDto paramDto = new ShoppingListDto();
		paramDto.setPtype(p_type);
		paramDto.setPcategory(p_category);

		List<ShoppingListDto> allList = p_dao.ShoppingList(paramDto);
		model.addAttribute("ShoppingList", allList);
		
		return "admin/product/ProductListA";
	}
	
	@RequestMapping("/products/ShoppingView")
	public String ShoppingView(@RequestParam("p_no") int p_no, Model model) {
		model.addAttribute("ShoppingView", p_dao.ShoppingView(p_no));
		
		//상품 리뷰 조회
		List<CommentDTO> reviewList = cmt_service.selectReviewListByProductNo(p_no);
	    model.addAttribute("reviewList", reviewList);
		return "products/ShoppingView";
	}
	
	@RequestMapping("/productDelete")
	public String ProductDelete(@RequestParam("p_no") int p_no) {
		p_dao.ProductDelete(p_no);
		return "redirect:/ProductListA";
	}
	
	@ResponseBody
	@RequestMapping("/products/autocomplete")
	public List<Map<String, String>> p_autocomplete(@RequestParam("keyword") String keyword) throws Exception {
		return p_service.p_autocomplete(keyword);
	}
	
	@RequestMapping("/ProductUpdateForm")
	public String ProductUpdateForm(Model model, @RequestParam("p_no") int p_no,
			@RequestParam("o_no") int o_no) {	
		model.addAttribute("ProductUpdate", p_dao.ProductViewUpdate(p_no, o_no));
		return "admin/product/ProductUpdateForm";
	}
	
	@RequestMapping("/products/ProductViewA")
	public String ProductViewA(@RequestParam("p_no") int p_no, Model model) {
		model.addAttribute("ProductView", p_dao.ShoppingView(p_no));
		return "admin/product/ProductViewA";
	}
	
	@RequestMapping("/ProductUpdate")
	public String ProductUpdate(
	        ProductDto p_dto, ProductOptionDto o_dto,
	        @RequestParam(value = "o_img", required = false) MultipartFile o_img, 
	        @RequestParam(value = "img_urls", required = false) List<MultipartFile> img_urls,
	        @RequestParam(value = "existing_o_img", required = false) String existing_o_img,
	        @RequestParam(value = "delete_img_nos", required = false) List<Integer> delete_img_nos
	) throws Exception {

	    p_service.productUpdate(p_dto, o_dto, o_img, img_urls, existing_o_img, delete_img_nos);

	    return "redirect:/ProductListA";
	}
}