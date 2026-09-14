package com.springboot.meongnyang_Jiphapso.controller;

import java.security.Principal;

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
	public String eventList(Model model) {
		model.addAttribute("list", dao.eventList());
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
	public String eventManage(EventReportDTO er_dto,
							 Model model) {		
		model.addAttribute("report", dao.eventReportList());
		model.addAttribute("write", dao.eventList());
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
                
                // 파일을 저장할 서버 실제 경로 지정 (예시)
                String uploadDir = request.getServletContext().getRealPath("/resources/upload/event/");
                
                // 파일 중복 방지를 위한 파일명 변경 (선택 사항)
                String savedFileName = System.currentTimeMillis() + "_" + originalFilename;
                
                // 파일 저장 실행
                java.io.File serverFile = new java.io.File(uploadDir + savedFileName);
                if (!serverFile.getParentFile().exists()) {
                    serverFile.getParentFile().mkdirs(); // 폴더가 없으면 생성
                }
                thumbFile.transferTo(serverFile);
                
                // DTO에 썸네일 웹 접근 경로 세팅 (event_thumb 컬럼에 저장될 값)
                e_dto.setEvent_thumb("/resources/upload/event/" + savedFileName);
            }
            
            // 2. 서비스 호출하여 DB에 INSERT (CLOB 내용과 썸네일 경로 등 저장)
            int result = dao.eventWrite(e_dto);
            
        } catch (Exception e) {
            e.printStackTrace();
            // 예외 처리 로직
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
