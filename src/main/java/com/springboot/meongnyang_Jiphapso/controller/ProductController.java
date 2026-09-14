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
	
	@Transactional(rollbackFor = Exception.class)
	@RequestMapping("/productWrite")	
	public String productWrite(
			ProductDto p_dto, ProductOptionDto o_dto, // img_dto 제거 (p_content가 p_dto에 자동 바인딩됨)
			@RequestParam(value="o_img", required = false) MultipartFile o_img, 
			@RequestParam(value="img_urls", required = false) List<MultipartFile> img_urls,
			@RequestParam(value="o_quantity", defaultValue="100") int o_quantity, 
			@RequestParam("o_price") int o_price,
			@RequestParam(value="o_default", required = false) String o_default,
			@RequestParam("p_title") String p_title, 
			@RequestParam(value="o_origin_price", required = false) Integer o_origin_price
	) throws Exception {
		
		ProductDto findtitle = p_dao.getProductByTitle(p_title);  
		int generatedPno;
		
		if (findtitle == null) {
			p_service.p_write(p_dto);
			generatedPno = p_dto.getP_no(); 
		} else {
			generatedPno = findtitle.getP_no(); 
		}
		  
		o_dto.setP_no(generatedPno);
		
		if (o_price == 0) {
			o_dto.setO_quantity(0);
		} else {
			o_dto.setO_quantity(o_quantity);
		}
		
		if (o_origin_price == null) {
			o_dto.setO_origin_price(o_price);
		}
		
		if (!"Y".equals(o_default)) {
			o_dto.setO_default("N");
		}
		
		if (o_img != null && !o_img.isEmpty()) {
			File mainDir = new File("C:\\SPRINGBOOT\\meongnyang_Jiphapso\\src\\main\\resources\\static\\images\\products\\main");
			if (!mainDir.exists()) {
				mainDir.mkdirs();
			}
			String o_main_img = o_img.getOriginalFilename();
			o_img.transferTo(new File(mainDir, o_main_img));
			o_dto.setO_main_img(o_main_img);
		} else {
			o_dto.setO_main_img(null);
		}
		
		p_dao.ProductOptionWrite(o_dto);
		
		if (img_urls != null && !img_urls.isEmpty()) {
			File infoDir = new File("C:\\SPRINGBOOT\\meongnyang_Jiphapso\\src\\main\\resources\\static\\images\\products\\info");
			if (!infoDir.exists()) {
				infoDir.mkdirs();
			}

			int sortOrder = 1;
			for (MultipartFile fname : img_urls) {
				if (!fname.isEmpty()) {
					String img_url = fname.getOriginalFilename();
					fname.transferTo(new File(infoDir, img_url));

					ProductDetailImageDto detailDto = new ProductDetailImageDto();
					detailDto.setImg_url(img_url);
					detailDto.setImg_sort(sortOrder++);
					detailDto.setP_no(generatedPno);

					p_dao.ProductDetailImageWrite(detailDto);
				}
			}
		}
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
	
	@Transactional(rollbackFor = Exception.class)
	@RequestMapping("/ProductUpdate")
	public String ProductUpdate(
			ProductDto p_dto, ProductOptionDto o_dto, // img_dto 제거 (p_content가 p_dto에 자동 바인딩됨)
			@RequestParam(value = "o_img", required = false) MultipartFile o_img, 
			@RequestParam(value = "img_urls", required = false) List<MultipartFile> img_urls,
			@RequestParam(value = "existing_o_img", required = false) String existing_o_img,
			@RequestParam(value = "delete_img_nos", required = false) List<Integer> delete_img_nos
	) throws Exception {

		p_dao.ProductUpdate(p_dto);
		
		int p_no = p_dto.getP_no();
		o_dto.setP_no(p_no);

		if (o_dto.getO_origin_price() == null || o_dto.getO_origin_price() == 0) {
			o_dto.setO_origin_price(o_dto.getO_price());
		}

		if ("Y".equals(o_dto.getO_default())) {
			p_dao.resetProductDefaultOption(p_no);
		} else {
			o_dto.setO_default("N");
		}

		if (o_img != null && !o_img.isEmpty()) {
			String o_main_img = o_img.getOriginalFilename();
			File uploadPath = new File("C:\\SPRINGBOOT\\meongnyang_Jiphapso\\src\\main\\resources\\static\\images\\products\\main");
			if (!uploadPath.exists()) uploadPath.mkdirs();

			o_img.transferTo(new File(uploadPath, o_main_img));
			o_dto.setO_main_img(o_main_img);
		} else {
			o_dto.setO_main_img(existing_o_img);
		}

		p_dao.ProductOptionUpdate(o_dto);

		File detailSaveDir = new File("C:\\SPRINGBOOT\\meongnyang_Jiphapso\\src\\main\\resources\\static\\images\\products\\info");
		if (!detailSaveDir.exists()) {
			detailSaveDir.mkdirs();
		}

		if (delete_img_nos != null && !delete_img_nos.isEmpty()) {
			List<String> deleteFiles = p_dao.getImageUrlsByNos(delete_img_nos);
			if (deleteFiles != null) {
				for (String fileName : deleteFiles) {
					File targetFile = new File(detailSaveDir, fileName);
					if (targetFile.exists()) {
						targetFile.delete();
					}
				}
			}
			p_dao.deleteImagesByNos(delete_img_nos);
			p_dao.reorderDetailImages(p_no);
		}

		if (img_urls != null && !img_urls.isEmpty()) {
			int sortOrder = p_dao.getMaxDetailSort(p_no) + 1;
			for (MultipartFile fname : img_urls) {
				if (!fname.isEmpty()) {
					String img_url = fname.getOriginalFilename();
					fname.transferTo(new File(detailSaveDir, img_url));

					ProductDetailImageDto detailDto = new ProductDetailImageDto();
					detailDto.setP_no(p_no);
					detailDto.setImg_url(img_url);
					detailDto.setImg_sort(sortOrder++);

					p_dao.ProductDetailImageWrite(detailDto);
				}
			}
		}

		return "redirect:/ProductListA";
	}
}