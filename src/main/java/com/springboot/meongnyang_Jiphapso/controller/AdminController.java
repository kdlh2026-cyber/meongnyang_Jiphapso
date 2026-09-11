package com.springboot.meongnyang_Jiphapso.controller;

import java.io.File;
import java.security.Principal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.springboot.meongnyang_Jiphapso.dao.IBreedDAO;
import com.springboot.meongnyang_Jiphapso.dao.IMemberDAO;
import com.springboot.meongnyang_Jiphapso.dto.BreedDTO;
import com.springboot.meongnyang_Jiphapso.dto.MemberDTO;
import com.springboot.meongnyang_Jiphapso.service.MemberService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class AdminController {
	@Autowired
	IMemberDAO m_dao;
	
	@Autowired
	MemberService mem_serv;
	
	@Autowired
	IBreedDAO b_dao;
	
	@RequestMapping("/admin/adminPage")
	public String adminPage() {
		return "admin/adminPage";
	}
	
	@RequestMapping("/admin/mem/memberList")
	public String memberList(Model model) {
		 List<MemberDTO> userList = m_dao.MemberListView("USER");
		 List<MemberDTO> creatorList = m_dao.MemberListView("CREATOR");
	    
	    List<MemberDTO> users = new ArrayList<>();
	    users.addAll(userList);
	    users.addAll(creatorList);

	    model.addAttribute("memberList", users);
	    return "admin/mem/memberList";
	}
	
	@RequestMapping("/admin/mem/AmemDetail")
	public String AmemDetail(@RequestParam("m_id") String m_id,Model model) {
		model.addAttribute("memDetail",m_dao.MemberView(m_id));
		return "admin/mem/AmemDetail";
	}
	
	@RequestMapping("/AmemUpdateForm")
	public String AmemUpdateForm(@RequestParam("m_id") String m_id,Model model) {
		MemberDTO m_dto=m_dao.MemberFindId(m_id);
		model.addAttribute("AmemUpdate",m_dto);
		
		return "admin/mem/AmemUpdateForm";
	}

	//자동완성 -> 화면 출력(파일 따로 생성 X)
	@ResponseBody
	@RequestMapping("/mem/mem_autocomplete")
	public List<Map<String,String>> autocomplete(@RequestParam("keyword") String keyword) throws Exception{
		return mem_serv.autocomplete(keyword);
	}
	
	@ResponseBody
	@RequestMapping("/memSearchAjax")
	public List<MemberDTO> memSearchAjax(@RequestParam("keyword") String keyword) throws Exception{
	    return mem_serv.search(keyword);
	}
	
	@RequestMapping("/AmemUpdate")
	public String AmemUpdate(@RequestParam("m_upload") MultipartFile m_upload,
	                            HttpServletRequest request,
	                            MemberDTO m_dto) throws Exception{

	    // 1. 수정 전 기존 회원 정보 조회
	    MemberDTO existing = m_dao.MemberView(m_dto.getM_id());
	    // 2. 이미지: 새로 업로드했을 때만 교체, 아니면 기존 파일명 유지
	    if (!m_upload.isEmpty()) {
	        String originalName = m_upload.getOriginalFilename();
	        String ext = originalName.substring(originalName.lastIndexOf("."));
	        String savedName = UUID.randomUUID().toString() + ext;

	        String projectPath = System.getProperty("user.dir");
	        File dir = new File(projectPath + "/src/main/resources/static/images/myProfile/");
	        if (!dir.exists()) dir.mkdirs();

	        m_upload.transferTo(new File(dir, savedName));

	        // 기존 이미지 파일 삭제 (있었다면)
	        if (existing.getM_img() != null && !existing.getM_img().isBlank()) {
	            File oldFile = new File(dir, existing.getM_img());
	            if (oldFile.exists()) {
	                oldFile.delete();
	            }
	        }

	        m_dto.setM_img(savedName);
	    } else {
	        // 새 이미지 업로드 안 했으면 기존 이미지 파일명 그대로 유지
	        m_dto.setM_img(existing.getM_img());
	    }

	    m_dao.AMemUpdate(m_dto);

	    return "redirect:/admin/mem/memberList";
	}

	
	@RequestMapping("/AmemberDelete")
	public String AmemDelte(@RequestParam("m_id") String m_id) {
		m_dao.MemberDelete(m_id);
		
		return "redirect:admin/mem/memberList";
	}
	
	// ------------------ 커뮤니티 ------------------ //
	@RequestMapping("/breedInfo")
	public String breedInfo(Model model) {
		
		model.addAttribute("dogbreed", b_dao.BreedList("강아지"));
		model.addAttribute("catbreed", b_dao.BreedList("고양이"));
		return "admin/community/breedInfo";
	}
	
	@PostMapping("/admin/breedInsert")
	public String breedInsert(@RequestParam("pet_type") String pet_type,
							  BreedDTO bdto,
							  Model model) {
		
		b_dao.breedInsert(bdto);
		model.addAttribute("dogbreed", b_dao.BreedList("강아지"));
		model.addAttribute("catbreed", b_dao.BreedList("고양이"));
		
		return "admin/community/breedInfo";
	}
	
	@RequestMapping("/admin/breedUpdate")
	public String breedUpdate(BreedDTO bdto,
							  Model model) {
		b_dao.breedUpdate(bdto);
		model.addAttribute("dogbreed", b_dao.BreedList("강아지"));
		model.addAttribute("catbreed", b_dao.BreedList("고양이"));
		
		return "admin/community/breedInfo";
	}
	
	@RequestMapping("/admin/breedDelete")
	public String breedDelete(@RequestParam("breed_id") int breed_id,
							  Model model) {
		b_dao.breedDelete(breed_id);
		model.addAttribute("dogbreed", b_dao.BreedList("강아지"));
		model.addAttribute("catbreed", b_dao.BreedList("고양이"));
		return "admin/community/breedInfo";
	}
}
