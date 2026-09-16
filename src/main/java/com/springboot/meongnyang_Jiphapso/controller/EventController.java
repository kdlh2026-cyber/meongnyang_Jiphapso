package com.springboot.meongnyang_Jiphapso.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.springboot.meongnyang_Jiphapso.dao.ICommentDAO;
import com.springboot.meongnyang_Jiphapso.dao.IEventDAO;
import com.springboot.meongnyang_Jiphapso.dao.IMemberDAO;
import com.springboot.meongnyang_Jiphapso.dto.CommentDTO;
import com.springboot.meongnyang_Jiphapso.dto.EventDTO;
import com.springboot.meongnyang_Jiphapso.dto.EventReportDTO;
import com.springboot.meongnyang_Jiphapso.dto.MemberDTO;
import com.springboot.meongnyang_Jiphapso.service.CommentService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class EventController {
	@Autowired
	IEventDAO dao;
	
	@Autowired
	IMemberDAO m_dao;
	
	@Autowired
	ICommentDAO cmt_dao;
	
	@Autowired
	CommentService service;
	
	@RequestMapping("/event/eventList")
	public String eventList(
	        @RequestParam(value = "event_onoff", required = false) String eventOnoff,
	        @RequestParam(value = "event_pet_type", required = false) String eventPetType,
	        Model model) {
	    
	    // 1. 전달받은 필터 조건을 Map에 담기
	    Map<String, Object> params = new HashMap<>();
	    params.put("event_onoff", eventOnoff);
	    params.put("event_pet_type", eventPetType);
	    
	    // 2. Map을 파라미터로 DAO에 전달하여 필터링된 목록 조회
	    model.addAttribute("list", dao.eventList(params));
	    
	    return "event/eventList";
	}
	
	@RequestMapping("/event/eventReport")
	public String eventReport(EventReportDTO er_dto,
							 Principal principal,
							 RedirectAttributes rttr) {
		
		if(principal == null) {
			return "redirct:/loginForm";
		}
		String m_id = principal.getName();
		MemberDTO member = m_dao.MemberView(m_id);
		
		if(member != null) {
			er_dto.setM_no(member.getM_no());
		}else {
			return "redirct:/loginForm";
		}
		
		dao.eventReport(er_dto);
		rttr.addFlashAttribute("msg", "행사 제보 신청이 완료되었습니다.");
		return "redirect:/event/eventList";
	}
	
	@RequestMapping("/admin/eventManage")
	public String eventManage(@RequestParam(value = "event_onoff", required = false) String eventOnoff,
							 @RequestParam(value = "event_pet_type", required = false) String eventPetType,
							 Model model) {		
	    
	    // 1. 제보 목록 조회
	    model.addAttribute("report", dao.eventReportList());
	    
	    // 2. 필터 파라미터를 Map에 담기
	    Map<String, Object> params = new HashMap<>();
	    params.put("event_onoff", eventOnoff);
	    params.put("event_pet_type", eventPetType);
	    
	    // 3. 조건에 맞는 이벤트 목록 조회 후 전달
	    model.addAttribute("write", dao.eventList(params));
	    
	    return "admin/community/event/eventManage";
	}
	
	@RequestMapping("/admin/eventWriteForm")
	public String eventWriteForm() {
		return "admin/community/event/eventWriteForm";
	}
	
	@RequestMapping("/event/eventWrite")
	public String eventWrite(EventDTO e_dto,
	                         @RequestParam("thumbFile") MultipartFile thumbFile,
	                         HttpServletRequest request,
	                         Model model) {
	    try {
	        // 1. 썸네일 파일 업로드 처리
	        if (thumbFile != null && !thumbFile.isEmpty()) {
	            String originalFilename = thumbFile.getOriginalFilename();
	            
	            // 프로젝트 원본 소스 폴더 경로 지정
	            String uploadDirPath = "C:\\Users\\KH_BUSAN_B_15\\git\\meongnyang_Jiphapso\\src\\main\\resources\\static\\images\\event";
	            
	            // 파일 중복 방지를 위한 고유 파일명 생성
	            String savedFileName = System.currentTimeMillis() + "_" + originalFilename;
	            
	            // 폴더 객체 생성 후 존재하지 않으면 생성
	            java.io.File uploadDir = new java.io.File(uploadDirPath);
	            if (!uploadDir.exists()) {
	                uploadDir.mkdirs(); // 디렉토리 전체 생성
	            }
	            
	            // 최종 파일 객체 생성 및 저장
	            java.io.File serverFile = new java.io.File(uploadDir, savedFileName);
	            thumbFile.transferTo(serverFile);
	            
	            // DB에 저장될 웹 접근 경로 세팅
	            e_dto.setEvent_thumb("/images/event/" + savedFileName);
	        }
	        
	        // 2. 서비스 호출하여 DB에 INSERT
	        int result = dao.eventWrite(e_dto);
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	    }    
	    
	    return "redirect:/admin/eventManage";
	}
	
	@RequestMapping("/event/eventView")
	public String eventView(@RequestParam("event_no") int event_no,
							Model model) {
	    
		// 이벤트 상세 정보
	    model.addAttribute("view", dao.eventDetail(event_no));
	    
	    // 이벤트 전용 댓글 목록 및 개수 조회
	    model.addAttribute("cmt", cmt_dao.EventCommentList(event_no));
	    model.addAttribute("commentCount", cmt_dao.EventCommentCount(event_no)); 
	    
	    return "event/eventView";
	}
	
	// [추가] 이벤트 댓글 달기
	@PostMapping("/eventCommentWrite")
	public String eventCommentWrite(CommentDTO dto,
	                                HttpSession session,
	                                Authentication authentication
	                                ) throws Exception {
	    
	    if(authentication != null && authentication.getPrincipal() != null) {
	        String username = authentication.getName();
	        MemberDTO member = m_dao.MemberFindId(username);
	        dto.setM_no(member.getM_no()); 
	        dto.setCmt_writer(username);// 혹은 cmt_writer
	    }
	    
	    // 이벤트 폼에서 넘긴 cmt_type과 cmt_type_no가 dto에 자동으로 바인딩됩니다.
	    dto.setCmt_type("이벤트"); // 혹은 폼에서 넘어온 값 그대로 사용
	    
	    if (dto.getCmt_answer_no() != null && dto.getCmt_answer_no() == 0) {
	        dto.setCmt_answer_no(null);
	    }
	    
	    service.write(dto);   
	    
	    // 이벤트 상세 페이지로 리다이렉트 (event_no 전달)
	    return "redirect:/event/eventView?event_no=" + dto.getCmt_type_no();
	}
	
	// 이벤트 수정 폼 페이지 요청
	@GetMapping("/admin/eventUpdateForm")
	public String eventUpdateForm(@RequestParam("event_no") int event_no, Model model) {
	    EventDTO event = dao.eventDetail(event_no); 
	    model.addAttribute("event", event);
	    return "admin/community/event/eventUpdateForm";
	}

    // 2. 이벤트 수정 완료 처리 (POST)
    @PostMapping("/admin/eventUpdate")
    public String eventUpdate(EventDTO eventDTO) {
    	dao.eventUpdate(eventDTO);
        return "redirect:/admin/eventManage"; 
    }

    // 3. 이벤트 삭제 처리
    @GetMapping("/admin/eventDelete")
    public String eventDelete(@RequestParam("event_no") int event_no) {
    	dao.eventDelete(event_no);
        return "redirect:/admin/eventManage";
    }
}
