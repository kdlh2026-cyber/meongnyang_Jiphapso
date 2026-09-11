package com.springboot.meongnyang_Jiphapso.controller;
import java.io.File;
import java.security.Principal;
import java.text.SimpleDateFormat;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.springboot.meongnyang_Jiphapso.dao.IMemberDAO;
import com.springboot.meongnyang_Jiphapso.dao.IPetDAO;
import com.springboot.meongnyang_Jiphapso.dto.MemberDTO;
import com.springboot.meongnyang_Jiphapso.dto.PetDTO;
import com.springboot.meongnyang_Jiphapso.service.MemberService;
import com.springboot.meongnyang_Jiphapso.service.PetService;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class MemberController {
	@Autowired
	IMemberDAO m_dao;
	
	@Autowired
	IPetDAO pet_dao;
	
	@Autowired
	MemberService mem_serv;
	
	@Autowired
	PetService pet_serv;
	
    private final PasswordEncoder passwordEncoder;

    MemberController(PasswordEncoder passwordEncoder) {
        this.passwordEncoder = passwordEncoder;
    }
    
    @InitBinder
    public void initBinder(WebDataBinder binder) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        dateFormat.setLenient(false);
        binder.registerCustomEditor(java.util.Date.class, new CustomDateEditor(dateFormat, true));
    }
    
    @RequestMapping("/member/myPage/myPage")
    public String myPage(Model model,Principal principal) {
    	String m_id=principal.getName();          // 로그인한 ID
    	MemberDTO m_dto=m_dao.MemberFindId(m_id); // 로그인한 ID로 정보 조회
    	model.addAttribute("myId",m_dao.MemberFindId(m_id));
    	
    	return "member/myPage/myPage";
    }
    
    @RequestMapping("/member/myPage/myProfile")
    public String myProfile(Model model,Principal principal) {
    	String m_id=principal.getName();
    	MemberDTO m_dto=m_dao.MemberFindId(m_id);
    	model.addAttribute("myId",m_dao.MemberFindId(m_id));
    	
    	return "member/myPage/myProfile";
    }
    
    @ControllerAdvice
    public class GlobalModelAdvice {

        @Autowired
        IMemberDAO m_dao;

        @ModelAttribute
        public void addLoginMember(Principal principal, Model model) {
            if (principal != null) {
                model.addAttribute("loginMember", m_dao.MemberFindId(principal.getName()));
            }
        }
    }
    
    @RequestMapping("/member/myPage/myProfileUpdateForm")
    public String memberUpdateForm(Authentication auth, HttpServletRequest request, Model model) {
        String m_id = auth.getName();
        MemberDTO m_dto = m_dao.MemberFindId(m_id);
        model.addAttribute("memberUpdate", m_dto);
        
        return "member/myPage/myProfileUpdateForm";
    }
    
    @RequestMapping("/member/myPage/myPetList")
    public String myPetList(Authentication authentication,Model model) {
    	String m_id=authentication.getName();
    	MemberDTO m_dto=m_dao.MemberFindId(m_id);
    	model.addAttribute("myId",m_dao.MemberFindId(m_id));
    	model.addAttribute("myPetList", pet_dao.PetMemberList(m_dto.getM_no()));
    	
    	return "member/myPage/myPetList";
    }
    
    @RequestMapping("/member/myPage/myPetPage")
    public String myPetPage(@RequestParam("pet_no") int pet_no,Model model) {
    	model.addAttribute("myPetPage",pet_dao.PetView(pet_no));
    	
    	return "member/myPage/myPetPage";
    }
    
    @RequestMapping("/member/myPage/myPetInsertForm")
    public String myPetInsertForm() {
    	return "member/myPage/myPetInsertForm";
    }
    
    @RequestMapping("/myPetUpdateForm")
    public String petUpdateForm(@RequestParam("pet_no") int pet_no, Model model) {
        model.addAttribute("petUpdate", pet_dao.PetView(pet_no));
        return "member/myPage/myPetUpdateForm";
    }
    
    @RequestMapping("/myPetInsert")
	public String petInsert(@RequestParam("pet_upload") MultipartFile pet_upload, PetDTO pet_dto,Principal principal) throws Exception {
		String m_id=principal.getName();          // 로그인한 멤버 아이디
		MemberDTO m_dto=m_dao.MemberFindId(m_id); // 멤버 정보 조회
		pet_dto.setM_no(m_dto.getM_no());         // 반려동물 등록자 번호 자동 세팅
		
		pet_dto.setPet_neuter(pet_dto.getPet_neuter() != null && pet_dto.getPet_neuter().equals("on") ? "T" : "F");
		
		if (!pet_upload.isEmpty()) {
		    String originalName = pet_upload.getOriginalFilename();
		    String ext = originalName.substring(originalName.lastIndexOf("."));
		    String savedName = UUID.randomUUID().toString() + ext;  // ← 여기서 생성됨

		    String projectPath = System.getProperty("user.dir");
		    File dir = new File(projectPath + "/src/main/resources/static/images/myPet/");
		    if (!dir.exists()) dir.mkdirs();

		    pet_upload.transferTo(new File(dir, savedName));
		    pet_dto.setPet_image(savedName);
		}
		
		pet_serv.write(pet_dto);
		
		return "redirect:/main";
	}
    
    @RequestMapping("/myPetUpdate")
    public String PetUpdate(@RequestParam("pet_upload") MultipartFile pet_upload, PetDTO pet_dto, Principal principal) throws Exception{
        String m_id = principal.getName();
        MemberDTO m_dto = m_dao.MemberFindId(m_id);

        // 1. 수정 전 기존 반려동물 정보 조회 (소유자 검증 + 이미지 유지용)
        PetDTO existing = pet_dao.PetView(pet_dto.getPet_no());

        // 2. 소유자 검증: 로그인한 회원의 반려동물이 맞는지 확인
        if (existing == null || existing.getM_no() != m_dto.getM_no()) {
            throw new IllegalStateException("본인의 반려동물만 수정할 수 있습니다.");
        }

        pet_dto.setPet_neuter(pet_dto.getPet_neuter() != null && pet_dto.getPet_neuter().equals("on") ? "T" : "F");

        // 3. 이미지: 새로 업로드했을 때만 교체, 아니면 기존 파일명 유지
        if (!pet_upload.isEmpty()) {
            String originalName = pet_upload.getOriginalFilename();
            String ext = originalName.substring(originalName.lastIndexOf("."));
            String savedName = UUID.randomUUID().toString() + ext;

            String projectPath = System.getProperty("user.dir");
            File dir = new File(projectPath + "/src/main/resources/static/images/myPet/");
            if (!dir.exists()) dir.mkdirs();

            pet_upload.transferTo(new File(dir, savedName));

            if (existing.getPet_image() != null && !existing.getPet_image().isBlank()) {
                File oldFile = new File(dir, existing.getPet_image());
                if (oldFile.exists()) {
                    oldFile.delete();
                }
            }

            pet_dto.setPet_image(savedName);
        } else {
            pet_dto.setPet_image(existing.getPet_image());
        }

        pet_dao.PetUpdate(pet_dto);

        return "redirect:/main";
    }
	
	@RequestMapping("/myPetDelete")
	public String petDelete(@RequestParam("pet_no") int pet_no) {
		pet_dao.PetDelete(pet_no);
		
		return "redirect:main";
	}
	
	@RequestMapping("/memberInsert")
	public String login(@RequestParam("m_upload") MultipartFile m_upload,MemberDTO m_dto,Principal principal) throws Exception {
		m_dto.setM_passwd(passwordEncoder.encode(m_dto.getM_passwd()));
		
		m_dto.setM_age_upper(m_dto.getM_age_upper() != null && m_dto.getM_age_upper().equals("on") ? "T":"F");
		
		m_dto.setM_sns(m_dto.getM_sns() != null && m_dto.getM_sns().equals("on") ? "T":"F");
		
		if(m_dto.getM_sns()==null) {
			m_dto.setM_sns("F");
		}
		
		m_dto.setM_authority("USER");
		
		if(!m_upload.isEmpty()) {
			String originalName=m_upload.getOriginalFilename();
			String ext=originalName.substring(originalName.lastIndexOf("."));
			String savedName=UUID.randomUUID().toString()+ext;
			
			String projectPath=System.getProperty("user.dir");
			File dir=new File(projectPath+"/src/main/resources/static/images/myProfile/");
			if(!dir.exists()) dir.mkdirs();
			
			m_upload.transferTo(new File(dir,savedName));
			m_dto.setM_img(savedName);
		}
		mem_serv.write(m_dto);
		
		return "redirect:/main";
	}
	
	@RequestMapping("/memberUpdate")
	public String memberUpdate(@RequestParam("m_upload") MultipartFile m_upload,
	                            HttpServletRequest request,
	                            MemberDTO m_dto) throws Exception {

	    // 1. 수정 전 기존 회원 정보 조회 (m_no 또는 m_id 기준 - 프로젝트에 맞는 키 사용)
	    MemberDTO existing = m_dao.MemberView(m_dto.getM_id());

	    // 2. 비밀번호: 폼에서 값이 넘어온 경우에만 재암호화, 비어있으면 기존 값 유지
	    if (m_dto.getM_passwd() != null && !m_dto.getM_passwd().isBlank()) {
	        m_dto.setM_passwd(passwordEncoder.encode(m_dto.getM_passwd()));
	    } else {
	        m_dto.setM_passwd(existing.getM_passwd());
	    }
	    
	    m_dto.setM_sns(m_dto.getM_sns() != null && m_dto.getM_sns().equals("T") ? "T" : "F");

	    // 3. 이미지: 새로 업로드했을 때만 교체, 아니면 기존 파일명 유지
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

	    m_dao.MemberUpdate(m_dto);

	    return "redirect:main";
	}
	
	@RequestMapping("/memberDelete")
	public String memDelete(@RequestParam("m_id") String m_id) {
		m_dao.MemberDelete(m_id);
		
		return "redirect:logout";
		
	}
	
}
