package com.springboot.meongnyang_Jiphapso.controller;

import java.io.File;
import java.security.Principal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.springboot.meongnyang_Jiphapso.common.SessionConst;
import com.springboot.meongnyang_Jiphapso.dao.IBreedDAO;
import com.springboot.meongnyang_Jiphapso.dao.ICommentDAO;
import com.springboot.meongnyang_Jiphapso.dao.ICommunityDAO;
import com.springboot.meongnyang_Jiphapso.dao.IMemberDAO;
import com.springboot.meongnyang_Jiphapso.dto.CommentDTO;
import com.springboot.meongnyang_Jiphapso.dto.CommunityDTO;
import com.springboot.meongnyang_Jiphapso.dto.MemberDTO;
import com.springboot.meongnyang_Jiphapso.service.BookMarkService;
import com.springboot.meongnyang_Jiphapso.service.CommentService;
import com.springboot.meongnyang_Jiphapso.service.CommunityESService;
import com.springboot.meongnyang_Jiphapso.service.CommunityService;

import jakarta.servlet.http.HttpSession;

@Controller
public class CommunityController {
	@Autowired
	CommunityService com_service;
	
	@Autowired
	CommentService cmt_service;
	
	@Autowired
	BookMarkService bookmarkService;
	
	@Autowired
	ICommunityDAO comm_dao;
	
	@Autowired
	IMemberDAO m_dao;
	
	@Autowired
	IBreedDAO breed_dao;
	
	@Autowired
	ICommentDAO cmt_dao;
	
	@Autowired
	CommunityESService esService;
	
	
	// 로그인을 해야 글쓰기로 넘어감
	@GetMapping("/commWriteForm")
	public String commWriteForm(Model model) {
		
		model.addAttribute("dogBreed", breed_dao.BreedList("강아지"));
	    model.addAttribute("catBreed", breed_dao.BreedList("고양이"));
		
		return "community/communityWriteForm";
	}
	
	// 로그인을 해야 댓글을 사용할 수 있음(안전장치, 메인으로 튀기면 다시 게시글 번호로 리아디렉트)
	@GetMapping("/community/comment/write-auth")
	public String commentAuthRedirect(@RequestParam(value = "comm_no", required = false) String comm_no) {
		return "redirect:/community/commView?comm_no=" + comm_no;
	}
	
	// 로그인을 해야 답글을 사용할 수 있음(안전장치, 메인으로 튀기면 다시 게시글 번호로 리아디렉트)
	@GetMapping("/community/comment/reply-auth")
	public String commentReplyRedirect(@RequestParam(value = "comm_no", required = false) String comm_no,
									   @RequestParam(value = "cmt_no", required = false) String cmt_no) {
		
		return "redirect:/community/commView?comm_no=" + comm_no;
	}
	
	// 게시글 글쓰기 등록하기
	@RequestMapping("/commWrite")
	public String commWrite(CommunityDTO dto,
							@RequestParam(value="uploadImages", required = false) MultipartFile[] uploadImages,
							@RequestParam(value = "uploadVideo", required = false) MultipartFile[] uploadVideo,
							HttpSession session,
							Authentication authentication)
							throws Exception{
	
		 if (authentication != null && authentication.isAuthenticated()
		            && !"anonymousUser".equals(authentication.getPrincipal())) {

			 String mId = authentication.getName();
		     MemberDTO loginUser = m_dao.MemberView(mId);

		     if (loginUser != null) {
		         dto.setM_no(loginUser.getM_no());
		         dto.setM_id(mId);         
		         dto.setComm_writer(loginUser.getM_name());
		     }
		}
		
		if (dto.getPet_no() == null || dto.getPet_no() == 0) {
		    dto.setPet_no(null); // 반려동물 번호가 없으면 확실하게 null 처리
		}
		
		com_service.write(dto, uploadImages, uploadVideo);
		return "redirect:/community/commList";
	}

	// 게시글 목록으로 이동
	@RequestMapping("/community/commList") 
	public String commList(@RequestParam(value = "comm_type", required = false) String comm_type,
	                        @RequestParam(value = "comm_no", required = false) Integer comm_no,
	                        @RequestParam(value = "comm_pet_type", required = false) String comm_pet_type,
	                        @RequestParam(value = "comm_category", required = false) String comm_category,
	                        @RequestParam(value = "sort", required = false, defaultValue = "latest") String sort,
	                        @RequestParam(value = "page", defaultValue = "1") int page,
	                        Model model) {
	    
	    int pageSize = 10; 
	    int startRow = (page - 1) * pageSize + 1;
	    int endRow = page * pageSize;

	    // 1. 기존에 쓰시던 selectList 그대로 호출 (DAO, XML 수정 불필요!)
	    List<CommunityDTO> list = com_service.selectList(comm_type, comm_pet_type, comm_category, sort, startRow, endRow);
	    
	    // 2. 페이징 계산은 서비스에게 위임
	    Map<String, Object> pagingMap = com_service.getPagingInfo(comm_type, comm_pet_type, comm_category, page);
	    
	    // 3. 모델에 담기
	    model.addAttribute("list", list);
	    model.addAllAttributes(pagingMap);
	    
	    return "community/commList";
	}
	
	//------------------- 검색 ------------------------ // 
	
	// 자동 완성
	@ResponseBody
	@RequestMapping("/community/autocomplete")
	public List<Map<String,String>> autocomplete(@RequestParam("keyword") String keyword) throws Exception{
		return com_service.autocomplete(keyword);
	}

	// 서치 리스트 불러오기
	@RequestMapping("/community/commsearch")
	public String search(@RequestParam("keyword") String keyword,
	                     @RequestParam(value = "page", defaultValue = "1") int page,
	                     Model model) throws Exception {

	    Map<String, Object> result = com_service.searchWithPaging(keyword, page);
	    model.addAllAttributes(result);
	    model.addAttribute("keyword", keyword);

	    // 인기글/추천글은 검색 조건과 무관하게 항상 상단에 고정 노출되는 영역이므로 별도로 채움
	    Map<String, Object> sideInfo = com_service.getPagingInfo(null, null, null, 1);
	    model.addAttribute("popularList", sideInfo.get("popularList"));
	    model.addAttribute("recommendList", sideInfo.get("recommendList"));

	    return "community/comm_searchList";
	}
	
	// 관리자용 검색 및 목록 조회
	@RequestMapping("/admin/community/searchList")
	public String adminCommunityList(
	        @RequestParam(value = "comm_type", required = false) String comm_type,
	        @RequestParam(value = "comm_pet_type", required = false) String comm_pet_type,
	        @RequestParam(value = "comm_category", required = false) String comm_category,
	        @RequestParam(value = "searchType", required = false) String searchType, // 👈 추가
	        @RequestParam(value = "keyword", required = false) String keyword,       // 👈 추가
	        @RequestParam(value = "sort", required = false, defaultValue = "latest") String sort,
	        @RequestParam(value = "page", defaultValue = "1") int page,
	        Model model) throws Exception {
	    		
		int totalCount = 0; // 전체 개수를 담을 변수
	    int size = 10;
	    
	    // 키워드가 존재할 때는 엘라스틱서치 검색 메서드 호출
	    if (keyword != null && !keyword.trim().isEmpty()) {
	        Map<String, Object> result = com_service.adminSearchCommunity(comm_type, comm_pet_type, comm_category, searchType, keyword, sort, page, 10);
	        model.addAllAttributes(result);
	        totalCount = ((Long) result.get("totalCount")).intValue();
	    } else {
	        Map<String, Object> pagingMap = com_service.getPagingInfo(comm_type, comm_pet_type, comm_category, page);
	        List<CommunityDTO> list = com_service.selectList(comm_type, comm_pet_type, comm_category, sort,
	                                                          (page - 1) * size + 1, page * size);
	        model.addAttribute("list", list);
	        totalCount = (int) pagingMap.get("totalCount");
	    }
	    
	    // 검색 조건 및 파라미터 유지용 모델 담기
	    model.addAttribute("searchType", searchType);
	    model.addAttribute("keyword", keyword);
	    model.addAttribute("sort", sort);
	    model.addAttribute("pageNum", page);
	    model.addAttribute("totalCount", totalCount);
	    
	    return "admin/community/communityManage/communityUpdateSearch";
	}
	
	
	// 게시글 내용 상세보기
	@RequestMapping("/community/commView")
	public String communityView(@RequestParam(value = "keyword", required = false) String keyword,
								@RequestParam(value = "comm_type", required = false) String comm_type,
								@RequestParam(value = "comm_pet_type", required = false) String comm_pet_type,
								@RequestParam(value = "comm_category", required = false) String comm_category,
								@RequestParam(value = "sort", required = false, defaultValue = "latest") String sort,
								@RequestParam(value = "page", defaultValue = "1") int page,
								@RequestParam("comm_no") Integer comm_no,
								Model model, HttpSession session) {
		
		// 1. 로그인 회원 및 북마크 여부 확인
		Integer loginMno = (Integer) session.getAttribute(SessionConst.LOGIN_MEMBER_NO);
	    if (loginMno != null) {
	        boolean isBookmarked = bookmarkService.isBookmarked(comm_no, loginMno);
	        model.addAttribute("isBookmarked", isBookmarked);
	    }

		// 2. 페이징 계산 (목록으로 돌아갈 때 대비)
		int pageSize = 10; 
	    int startRow = (page - 1) * pageSize + 1;
	    int endRow = page * pageSize;
		
	    // 3. 조회수 증가 및 본문/댓글 데이터 조회
	    comm_dao.CommunityHit(comm_no);
	    CommunityDTO view = com_service.viewList(comm_no);

	    // 4. 우측 사이드바 데이터 불러오기 (commList 구조 참고)
	    // 인기글 목록 조회 (예: sort를 "popular" 고정하거나 기존 서비스 메서드 활용)
	    List<CommunityDTO> popularList = com_service.selectList(comm_type, comm_pet_type, comm_category, "popular", 1, 5);
	    
	    // 좋은 정보 / 추천 콘텐츠 목록 조회 (필요한 서비스/메서드 호출)
	    List<CommunityDTO> recommendList = com_service.getRecommendList();    

	    // 5. 모델에 데이터 담기
	    model.addAttribute("view", view);
	    model.addAttribute("cmt", cmt_service.cmtList(comm_no));
	    model.addAttribute("reply_count", cmt_service.countComments(comm_no));
	    model.addAttribute("popularList", popularList);
	    model.addAttribute("recommendList", recommendList);
	    model.addAttribute("loginMno", loginMno);
	    
	    // 목록으로 돌아갈 때 필터/페이지 조건 유지를 위해 전달
	    model.addAttribute("keyword", keyword);
	    model.addAttribute("pageNum", page);
	    model.addAttribute("sort", sort);
	    
	    return "community/commView";
		}

	// 내 게시글 수정폼으로 이동
	@RequestMapping("/community/updateForm")
	public String communityUpdateForm(@RequestParam("comm_no") int comm_no,
									  Model model) {
		model.addAttribute("update", comm_dao.CommunityView(comm_no));
		return "community/updateForm";
	}
	
	// 수정하기
	@RequestMapping("/community/update")
    public String communityUpdate(
            @RequestParam(value="uploadImages", required=false) MultipartFile uploadImage,
            @RequestParam(value="uploadVideo", required=false) MultipartFile uploadVideo,
            CommunityDTO dto,
            HttpSession session) throws Exception {

        // 1. 보안을 위해 현재 로그인한 회원의 정보(번호/이름)를 세션에서 안전하게 가져와서 주입
        Integer m_no = (Integer) session.getAttribute(SessionConst.LOGIN_MEMBER_NO);
        
        if (m_no == null) {
            return "redirect:/loginForm"; // 로그인 안 되어 있으면 로그인 페이지로
        }
        
        dto.setM_no(m_no);

        // 2. 새로운 이미지 파일이 업로드된 경우에만 처리
        if (uploadImage != null && !uploadImage.isEmpty()) {
            String comm_img = uploadImage.getOriginalFilename();
            String uploadPath = "C:\\SPRINGBOOT\\meongnyang_Jiphapso\\src\\main\\resources\\static\\images\\community/";
            
            // 디렉토리가 없으면 생성하는 안전장치
            File folder = new File(uploadPath);
            if (!folder.exists()) {
                folder.mkdirs();
            }
            
            uploadImage.transferTo(new File(uploadPath + comm_img));
            dto.setComm_img(comm_img); // DTO에 새 이미지명 세팅
        }

        // 3. 새로운 동영상 파일이 업로드된 경우에만 처리
        if (uploadVideo != null && !uploadVideo.isEmpty()) {
            String comm_video = uploadVideo.getOriginalFilename();
            String uploadPath = "C:\\SPRINGBOOT\\meongnyang_Jiphapso\\src\\main\\resources\\static\\video\\community/";
            
            File folder = new File(uploadPath);
            if (!folder.exists()) {
                folder.mkdirs();
            }
            
            uploadVideo.transferTo(new File(uploadPath + comm_video));
            dto.setComm_video(comm_video); // DTO에 새 동영상명 세팅
        }

        // 4. 서비스 호출 (DB 업데이트 실행)
        com_service.CommunityUpdate(dto);

        // 5. 수정 완료 후 해당 글의 상세 페이지로 리다이렉트
        return "redirect:/community/commView?comm_no=" + dto.getComm_no();
    }
	
	// 게시글 도움돼요.
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/community/recommend")
	@ResponseBody
	public String recommendCommunity(@RequestParam("comm_no") int comm_no,
	                                 @RequestParam("type") String type,
	                                 Principal principal) {
	    
	    if (principal == null) {
	        return "LOGIN_REQUIRED";
	    }
	    
	    String username = principal.getName();
	    
	    // MemberFindId로 회원 정보 조회 후 m_no 꺼내기
	    MemberDTO member = m_dao.MemberFindId(username);
	    if (member == null) {
	        return "LOGIN_REQUIRED";
	    }
	    int m_no = member.getM_no();
	    
	    // 2. 중복 체크 + 이력 삽입 + 카운트 증가
	    return com_service.processRecommend(comm_no, m_no, type);
	}
	
	// 댓글 '도움돼요'
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/comment/recommend")
	@ResponseBody
	public String recommendComment(@RequestParam("cmt_no") int cmt_no,
	                               Principal principal) {
	    
	    if (principal == null) {
	        return "LOGIN_REQUIRED";
	    }
	    
	    String username = principal.getName();
	    
	    // 회원 정보 조회 후 m_no 꺼내기
	    MemberDTO member = m_dao.MemberFindId(username);
	    if (member == null) {
	        return "LOGIN_REQUIRED";
	    }
	    int m_no = member.getM_no();
	    
	    // 댓글 추천 중복 체크 및 처리 서비스 호출
	    return cmt_service.processRecommend(cmt_no, m_no);
	}
	
	
	
	// ------------- 마이프로필 ----------------- //
	@RequestMapping("/community/myCommunity")
	public String myCommunity(HttpSession session,
							  @RequestParam(value = "comm_type", required = false) String comm_type,
							  Model model) {
		
		Integer m_no = (Integer) session.getAttribute(SessionConst.LOGIN_MEMBER_NO);

		if(m_no == null) {
			return "redirect:/loginForm";
		}
		
		model.addAttribute("m_no", m_no);
		List<CommunityDTO> list = com_service.myList(m_no, comm_type);
		List<CommentDTO> myList = cmt_dao.myComment(m_no);
		List<CommentDTO> reviewList = cmt_dao.selectReviewsByMemberNo(m_no);
		
		if (comm_type == null || comm_type.isEmpty()) {
		    // 1. Q&A 카테고리: 개수와 최신글 1개 추출
		    List<CommunityDTO> qnaList = list.stream().filter(b -> "QNA".equals(b.getComm_type())).toList();
		    model.addAttribute("qnaCount", qnaList.size());
		    model.addAttribute("latestQna", qnaList.isEmpty() ? null : qnaList.get(0)); // 첫 번째가 가장 최신글!

		    // 2. 라운지 카테고리: 개수와 최신글 1개 추출
		    List<CommunityDTO> loungeList = list.stream().filter(b -> "라운지".equals(b.getComm_type())).toList();
		    model.addAttribute("loungeCount", loungeList.size());
		    model.addAttribute("latestLounge", loungeList.isEmpty() ? null : loungeList.get(0));
		    
		    // 3. 콘텐츠 카테고리: 개수와 최신글 1개 추출
		    List<CommunityDTO> contentsList = list.stream().filter(b -> "콘텐츠".equals(b.getComm_type())).toList();
		    model.addAttribute("contentCount", contentsList.size());
		    model.addAttribute("latestContent", contentsList.isEmpty() ? null : contentsList.get(0));
		
		    // 4. 댓글 카테고리 : 개수와 최신글 1개 추출
		    model.addAttribute("commentCount", myList.size());
		    model.addAttribute("latestComment", myList.isEmpty() ? null : myList.get(0));
		    
		    // 5. 리뷰 카테고리 : 개수와 최신글 1개 추출
		    model.addAttribute("reviewAll", reviewList.size());
		    model.addAttribute("latestReview", reviewList.isEmpty() ? null : reviewList.get(0));
		    
		} else if ("댓글".equals(comm_type)) {
	        model.addAttribute("list", myList);
	    } else if ("리뷰".equals(comm_type)) {
	        model.addAttribute("list", reviewList);
	    } else {
	        model.addAttribute("list", list);
	    }
		
		return "member/community/myCommunityMain";
	}
		
	@RequestMapping("/community/delete")
	public String communityDelete(@RequestParam("comm_no") int comm_no,
	                              @RequestParam(value = "comm_type", required = false) String comm_type,
	                              HttpSession session,
	                              Authentication authentication) {

	    Integer m_no = (Integer) session.getAttribute(SessionConst.LOGIN_MEMBER_NO);
	    

	    if (m_no == null) {
	        System.out.println("m_no가 null -> 로그인 페이지로 리다이렉트");
	        return "redirect:/loginForm";
	    }
	    
	    String mId = authentication.getName();  

	    com_service.CommunityDelete(comm_no, m_no, mId);

	    String target;
	    if (comm_type != null && !comm_type.isEmpty()) {
	        target = "redirect:/member/myPage/myPage?comm_type=" + java.net.URLEncoder.encode(comm_type, java.nio.charset.StandardCharsets.UTF_8);
	    } else {
	        target = "redirect:/member/myPage/myPage";
	    }
	    
	    return target;
	}
	
	@RequestMapping("/communityList/delete")
	public String communitycommunityList(@RequestParam("comm_no") int comm_no,
	                              @RequestParam(value = "comm_type", required = false) String comm_type,
	                              HttpSession session) {

		Integer m_no = (Integer) session.getAttribute(SessionConst.LOGIN_MEMBER_NO);

	    if (m_no == null) {
	        System.out.println("m_no가 null -> 로그인 페이지로 리다이렉트");
	        return "redirect:/loginForm";
	    }

	    com_service.CommunityDelete(comm_no, m_no);

	    // 수정된 부분: 전체 커뮤니티 목록 페이지로 이동
	    // 필요에 따라 comm_type을 파라미터로 같이 넘겨서 해당 탭이 유지되게 할 수 있습니다.
	    String target;
	    if (comm_type != null && !comm_type.isEmpty()) {
	        target = "redirect:/community/commList?comm_type=" + java.net.URLEncoder.encode(comm_type, java.nio.charset.StandardCharsets.UTF_8);
	    } else {
	        target = "redirect:/community/commList";
	    }

	    return target;
	}
	
	
	//----------------------------- 관리자 ------------------------ //
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
	
//	@GetMapping("/admin/community/communityManage/manageDetails")
//    public String communityManageDetails(
//            @RequestParam(value = "comm_type", required = false, defaultValue = "QNA") String commType,
//            Model model) throws Exception {
//        
//        // 1. 방금 만든 서비스 메서드를 호출하여 통계 데이터를 Map으로 받아옴
//        Map<String, Object> statsData = com_service.getCommunityStatsByJava(commType);
//        
//        // 2. Map에 담긴 모든 데이터(totalCount, petRatioList, monthlyCounts 등)를 Model에 일괄 등록
//        model.addAllAttributes(statsData);
//        // 뷰에서 쓰기 편하게 현재 타입 전달
//        model.addAttribute("commType", commType);
//        
//        // 탭별 active 여부를 명시적으로 판별해서 전달 (이 방법이 제일 안전합니다)
//        model.addAttribute("activeQnA", "QNA".equals(commType) ? "active" : "");
//        model.addAttribute("activeLounge", "라운지".equals(commType) ? "active" : "");
//        model.addAttribute("activeContent", "콘텐츠".equals(commType) ? "active" : "");
//        
//        // 3. 기존 JSP 경로 반환
//        return "admin/community/communityManage/manageDetails";
//    }
	
	@GetMapping("/admin/community/communityManage/manageDetails")
	public String communityManageDetails(
	        @RequestParam(value = "comm_type", required = false) String commType,
	        Model model) {

	    // 탭 초기 활성화 여부만 전달 (Kibana 자체 탭 전환은 JS에서 처리하므로 필수는 아니지만, 
	    // 서버 렌더링 시 초기 활성 탭 표시에 쓰려면 유지)
	    model.addAttribute("commType", commType);
	    model.addAttribute("activeQnA", "QNA".equals(commType) ? "active" : "");
	    model.addAttribute("activeLounge", "라운지".equals(commType) ? "active" : "");
	    model.addAttribute("activeContent", "콘텐츠".equals(commType) ? "active" : "");

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
	
	@GetMapping("/admin/community/reindexAll")
	@ResponseBody
	public String reindexAll() throws Exception {
	    List<CommunityDTO> allList = com_service.list();
	    esService.bulkSave(allList);
	    return "재색인 완료: " + allList.size() + "건";
	}

}