package com.springboot.meongnyang_Jiphapso.controller;

import java.io.File;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.security.Principal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
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
	
	@Autowired
	CommunityService com_service;
	
	@Autowired
	ICommunityDAO comm_dao;
	
	@RequestMapping("/admin/adminPage")
	public String adminPage() {
		return "admin/adminPage";
	}
	
	@RequestMapping("/admin/clone/main")
	public String clonepage() {
		return "admin/clone/main";
	}
	
	@RequestMapping("/admin/clone/adminIPage")
	public String AIP() {
		return "admin/clone/adminIPage";
	}
	
	// ------------------ 회원 관리 ------------------ //
	
	@RequestMapping("/admin/mem/memberList")
	public String memberList(Model model) {
		 List<MemberDTO> userList = m_dao.MemberListView("USER");
		 List<MemberDTO> creatorList = m_dao.MemberListView("CREATOR");
		 List<MemberDTO> badList = m_dao.MemberListView("BADMAN");
	    
	    List<MemberDTO> users = new ArrayList<>();
	    users.addAll(userList);
	    users.addAll(creatorList);
	    users.addAll(badList);

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
	
	@RequestMapping("/creatorApprove")
	public String creapp(MemberDTO m_dto) {
		m_dao.MemberCreatorApprove(m_dto);
		
		return "redirect:/admin/mem/memberList";
	}
	
	@RequestMapping("/creatorRefuse")
	public String crefuse(MemberDTO m_dto) {
		m_dao.MemberCreatorRefuse(m_dto);
		
		return "redirect:/admin/mem/memberList";
	}

	
	@RequestMapping("/AmemberDelete")
	public String AmemDelte(@RequestParam("m_id") String m_id) {
		m_dao.MemberWithout(m_id);
		
		return "redirect:/admin/mem/memberList";
	}
	
	// ------------------ 커뮤니티 ------------------ //
	@RequestMapping("/admin/breedInfo")
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
	
	@RequestMapping("/admin/communityManage")
	public String communityManage(Model model) {
	    
	    List<String> commTypes = Arrays.asList("QNA", "라운지", "콘텐츠");
	    model.addAttribute("commTypes", commTypes);

	    String todayStr = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
	    model.addAttribute("todayStr", todayStr);

	    // 전체 총합 개수 (전체 통계는 기존 메서드 유지 혹은 전체 count 쿼리 활용)
	    int totalCount = com_service.getTotalCount(null, null, null);
	    model.addAttribute("totalCount", totalCount);

	    Map<String, Integer> categoryCounts = new HashMap<>();
	    Map<String, Integer> todayCounts = new HashMap<>();
	    Map<String, List<CommunityDTO>> latestByType = new HashMap<>();
	    Map<String, List<CommunityDTO>> topByType = new HashMap<>();

	    // ⭐️ 1. 통계 데이터를 단 1번의 쿼리로 조회해옴 (DB 접근 최소화)
	    List<Map<String, Object>> statsList = com_service.getAllCategoryStats();
	    
	    // 조회해온 리스트를 루프를 돌며 Map에 매핑 (DB 접근이 아니라 자바 메모리 연산이므로 매우 빠름)
	    for (Map<String, Object> stat : statsList) {
	        String type = (String) stat.get("COMM_TYPE"); // 오라클은 대문자로 반환될 수 있음 ("COMM_TYPE" 또는 "comm_type")
	        
	        // BigDecimal 또는 Number 형태로 올 수 있으므로 안전하게 형변환
	        int tCount = stat.get("TOTAL_COUNT") != null ? ((Number) stat.get("TOTAL_COUNT")).intValue() : 0;
	        int dCount = stat.get("TODAY_COUNT") != null ? ((Number) stat.get("TODAY_COUNT")).intValue() : 0;
	        
	        categoryCounts.put(type, tCount);
	        todayCounts.put(type, dCount);
	    }

	    // ⭐️ 2. 게시글 목록(최신순, 인기순)은 각 타입별로 가져와야 하므로 유지하되, 
	    //        각각 최적화된 쿼리(ROWNUM <= 10 등)를 타도록 구성
	    for (String type : commTypes) {
	        // 게시글 관리 영역: 최신순 1~10개 고정
	        latestByType.put(type, com_service.selectList(type, null, null, "latest", 1, 10));

	        // 인기 Top 10 영역: 인기순 1~10개 고정
	        Map<String, Object> params = new HashMap<>();
	        params.put("comm_type", type);
	        topByType.put(type, com_service.getPopularList(params));
	    }

	    model.addAttribute("categoryCounts", categoryCounts);
	    model.addAttribute("todayCounts", todayCounts);
	    model.addAttribute("latestByType", latestByType);
	    model.addAttribute("topByType", topByType);
	    
	    return "admin/community/communityManage/communityManage";
	}
	
	@GetMapping("/admin/community/communityManage/manageDetails")
    public String communityManageDetails(
            @RequestParam(value = "comm_type", required = false, defaultValue = "QNA") String commType,
            Model model) throws Exception {
        
        // 1. 방금 만든 서비스 메서드를 호출하여 통계 데이터를 Map으로 받아옴
        Map<String, Object> statsData = com_service.getCommunityStatsByJava(commType);
        
        // 2. Map에 담긴 모든 데이터(totalCount, petRatioList, monthlyCounts 등)를 Model에 일괄 등록
        model.addAllAttributes(statsData);
        // 뷰에서 쓰기 편하게 현재 타입 전달
        model.addAttribute("commType", commType);
        
        // 탭별 active 여부를 명시적으로 판별해서 전달 (이 방법이 제일 안전합니다)
        model.addAttribute("activeQnA", "QNA".equals(commType) ? "active" : "");
        model.addAttribute("activeLounge", "라운지".equals(commType) ? "active" : "");
        model.addAttribute("activeContent", "콘텐츠".equals(commType) ? "active" : "");
        
        // 3. 기존 JSP 경로 반환
        return "admin/community/communityManage/manageDetails";
    }
	
	@RequestMapping("/admin/communityUpdate")
    public String communityUpdate(@RequestParam(value = "comm_type", required = false) String comm_type,
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
        List<CommunityDTO> list = com_service.selectList(comm_type, comm_pet_type, comm_category, sort, startRow, endRow);
        
        // 4. 전체 게시글 개수 구하기 (페이징 바를 그리기 위해 필요)
        int totalCount = com_service.getTotalCount(comm_type, comm_pet_type, comm_category);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        if (totalPages == 0) totalPages = 1; // 데이터가 없을 때 방어 코드

        // ★ 5. 10단위 블록 페이징 계산 로직 추가
        int blockSize = 10; // 한 화면에 보여줄 페이지 번호 개수
        int endPage = (int) (Math.ceil(page / (double) blockSize) * blockSize);
        int startPage = (endPage - blockSize) + 1;
        
        if (endPage > totalPages) {
            endPage = totalPages; // 마지막 블록이 총 페이지 수보다 크면 보정
        }
        
        boolean prev = startPage > 1;                  // 이전 블록 존재 여부
        boolean next = endPage < totalPages;           // 다음 블록 존재 여부

        // 6. 모델에 데이터 담기
        model.addAttribute("list", list);
        model.addAttribute("pageNum", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalCount", totalCount);
        
        // JSP로 넘길 페이징 블록 관련 속성들
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        model.addAttribute("prev", prev);
        model.addAttribute("next", next);
        
        return "admin/community/communityManage/communityUpdate";
    }
	
	@GetMapping("/admin/community/delete")
	public String adminCommunityDelete(
	        @RequestParam("comm_no") int comm_no,
	        @RequestParam(value = "comm_type", required = false) String comm_type,
	        @RequestParam(value = "page", defaultValue = "1") int page) {

	    // 삭제 실행
		com_service.adminCommunityDelete(comm_no); // 또는 communityDao.adminCommunityDelete(comm_no)

	    // 삭제 후 기존 보고 있던 탭과 페이지 상태를 유지하며 목록으로 리다이렉트
	    return "redirect:/admin/communityUpdate?comm_type=" + (comm_type != null ? comm_type : "") + "&page=" + page;
	}
	
	@GetMapping("/admin/community/pickToggle")
	public String pickToggle(
	        @RequestParam("comm_no") int comm_no,
	        @RequestParam(value = "comm_type", required = false) String comm_type,
	        @RequestParam(value = "page", defaultValue = "1") int page) {

	    // PICK 상태 토글 실행
		com_service.updateAdPick(comm_no);

	    // 기존 페이지 및 필터 상태 유지하며 리다이렉트
	    return "redirect:/admin/communityUpdate?comm_type=" + (comm_type != null ? comm_type : "") + "&page=" + page;
	}
}