package com.springboot.meongnyang_Jiphapso.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.springboot.meongnyang_Jiphapso.dao.IBreedDAO;
import com.springboot.meongnyang_Jiphapso.dao.ICommunityDAO;
import com.springboot.meongnyang_Jiphapso.dao.IMemberDAO;
import com.springboot.meongnyang_Jiphapso.dto.BreedDTO;
import com.springboot.meongnyang_Jiphapso.dto.CommunityDTO;
import com.springboot.meongnyang_Jiphapso.dto.MemberDTO;
import com.springboot.meongnyang_Jiphapso.service.CommunityService;

import jakarta.servlet.http.HttpSession;

@Controller
public class CommunityController {
	@Autowired
	CommunityService service;
	
	@Autowired
	ICommunityDAO comm_dao;
	
	@Autowired
	IMemberDAO m_dao;
	
	@Autowired
	IBreedDAO breed_dao;
	
	
	// 로그인을 해야 글쓰기로 넘어감(WebSecurity 설정하면 됨)
	@GetMapping("/commWriteForm")
	public String commWriteForm(Model model) {
		
		List<BreedDTO> breedList = breed_dao.BreedList();
		model.addAttribute("breed", breedList);
		
		return "community/communityWriteForm";
	}
	
	// 크롤링 용 글쓰기로 넘어가기
	@GetMapping("/communityCrawlingWriteForm")
	public String communityCrawlingWriteForm() {
		return "admin/community/communityCrawlingWriteForm";
	}
	

	// 게시글 글쓰기 등록하기
	@RequestMapping("/commWrite")
	public String commWrite(CommunityDTO dto,
							@RequestParam(value="uploadImages", required = false) MultipartFile[] uploadImages,
							@RequestParam(value = "uploadVideo", required = false) MultipartFile[] uploadVideo,
							HttpSession session)
							throws Exception{
		
		 Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		
		 if (authentication != null && authentication.isAuthenticated()
		            && !"anonymousUser".equals(authentication.getPrincipal())) {

			 String mId = authentication.getName(); // 로그인한 m_id
		     MemberDTO loginUser = m_dao.MemberView(mId); // 기존 메서드 그대로 재사용

		     if (loginUser != null) {
		         dto.setM_no(loginUser.getM_no());
		         dto.setComm_writer(loginUser.getM_name());
		     }
		}

		
		if (dto.getPet_no() == null || dto.getPet_no() == 0) {
		    dto.setPet_no(null); // 반려동물 번호가 없으면 확실하게 null 처리
		}
		
		service.write(dto, uploadImages, uploadVideo);
		return "redirect:/community/commList";
	}

	
	// 크롤링한 데이터 업로드 용
	@RequestMapping("/commWriteCrawling")
	public String commWriteCrawling(
	        CommunityDTO dto,
	        @RequestParam(value = "img_url", required = false) String comm_content_img
	) throws Exception {

		 System.out.println();
		    System.out.println("==========================================");
		    System.out.println("Crawling Controller DTO 확인");
		    System.out.println("==========================================");

		    System.out.println("comm_type    = " + dto.getComm_type());
		    System.out.println("comm_title   = " + dto.getComm_title());
		    System.out.println("comm_writer  = " + dto.getComm_writer());
		    System.out.println("comm_date    = " + dto.getComm_date());
		    System.out.println("comm_content = " + dto.getComm_content());
		    System.out.println("comm_pet_type = " + dto.getComm_pet_type());
		    System.out.println("comm_breed   = " + dto.getComm_breed());
		    System.out.println("comm_tag     = " + dto.getComm_tag());
		    System.out.println("comm_view    = " + dto.getComm_view());
		    System.out.println("comm_good    = " + dto.getComm_good());
		    System.out.println("comm_well    = " + dto.getComm_well());
		    System.out.println("img_url      = " + comm_content_img);

		    System.out.println("==========================================");

	    service.writeCrawling(dto, comm_content_img);

	    return "redirect:/community/commList";
	}
	
	// 게시글 목록으로 이동
	@RequestMapping("/community/commList") 
	public String commList(@RequestParam(value = "comm_type", required = false) String comm_type,
					       @RequestParam(value = "comm_pet_type", required = false) String comm_pet_type,
					       @RequestParam(value = "comm_category", required = false) String comm_category,
					       @RequestParam(value = "sort", required = false, defaultValue = "latest") String sort,
					       @RequestParam(value = "page", defaultValue = "1") int page,
					       Model model) {
		
	    // 1. 한 페이지에 보여줄 게시글 개수
	    int pageSize = 10; 
	    
	    // 2. 페이징 계산을 위한 시작/끝 행 번호 구하기 (오라클 ROWNUM 기준 예시)
	    int startRow = (page - 1) * pageSize + 1;
	    int endRow = page * pageSize;

	    // 3. 목록 조회 (파라미터에 페이징 정보 추가 전달)
	    List<CommunityDTO> list = service.selectList(comm_type, comm_pet_type, comm_category, sort, startRow, endRow);
	    
	    // 4. 전체 게시글 개수 구하기 (페이징 바를 그리기 위해 필요)
	    int totalCount = service.getTotalCount(comm_type, comm_pet_type, comm_category);
	    int totalPages = (int) Math.ceil((double) totalCount / pageSize);

	    model.addAttribute("list", list);
	    model.addAttribute("pageNum", page);
	    model.addAttribute("totalPages", totalPages);
	    model.addAttribute("totalCount", totalCount);
	    
	    return "community/commList";
	}
	
	// 자동 완성
	@ResponseBody
	@RequestMapping("/autocomplete")
	public List<Map<String,String>> autocomplete(@RequestParam("keyword") String keyword) throws Exception{
		return service.autocomplete(keyword);
	}
	
	
	// 서치 리스트 불러오기
	@RequestMapping("/comm_search")
	public String search(@RequestParam("keyword") String keyword,
						 Model model) throws Exception{
		
		List<CommunityDTO> list = service.search(keyword);
		model.addAttribute("list", list);
		
		return "community/comm_searchList";
	}
	
	// 게시글 내용 상세보기
	@RequestMapping("/communityView")
	public String communityView(@RequestParam("comm_no") Integer comm_no,
								Model model) {
		
		model.addAttribute("view",service.viewList(comm_no));
		comm_dao.CommunityHit(comm_no);
		
		return "community/commView";
	}
}
