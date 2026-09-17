package com.springboot.meongnyang_Jiphapso.controller;

import java.io.File;
import java.security.Principal;
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
import com.springboot.meongnyang_Jiphapso.dto.CommunityRecommendDTO;
import com.springboot.meongnyang_Jiphapso.dto.MemberDTO;
import com.springboot.meongnyang_Jiphapso.service.BookMarkService;
import com.springboot.meongnyang_Jiphapso.service.CommentService;
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
	
	// 자동 완성
	@ResponseBody
	@RequestMapping("/community/autocomplete")
	public List<Map<String,String>> autocomplete(@RequestParam("keyword") String keyword) throws Exception{
		return com_service.autocomplete(keyword);
	}

	// 서치 리스트 불러오기
	@RequestMapping("/community/search")
	public String search(@RequestParam("keyword") String keyword,
	                     @RequestParam(value = "comm_type", required = false) String comm_type,
	                     @RequestParam(value = "comm_pet_type", required = false) String comm_pet_type,
	                     @RequestParam(value = "comm_category", required = false) String comm_category,
	                     @RequestParam(value = "sort", required = false, defaultValue = "latest") String sort,
	                     @RequestParam(value = "page", defaultValue = "1") int page,
	                     Model model) throws Exception {

	    List<CommunityDTO> list = com_service.search(keyword);  
	    Map<String, Object> pagingMap = com_service.getPagingInfo(comm_type, comm_pet_type, comm_category, page, keyword);
	    
	    model.addAttribute("list", list);
	    model.addAllAttributes(pagingMap);
	    model.addAttribute("pageNum", page);
	    model.addAttribute("keyword", keyword);
	    
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
	        List<Map<String, Object>> searchList = com_service.adminSearchCommunity(searchType, keyword, sort, page, 10);
	        model.addAttribute("list", searchList);
	       
	    } else {
	    	// 수정 권장 (마지막 인자를 고정 크기 값인 10 등으로 변경)
	    	List<CommunityDTO> list = com_service.search(keyword);
	        model.addAttribute("list", list);
	        totalCount = com_service.getTotalCount(comm_type, comm_pet_type, comm_category);
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
	                              HttpSession session) {

	    Integer m_no = (Integer) session.getAttribute(SessionConst.LOGIN_MEMBER_NO);

	    if (m_no == null) {
	        System.out.println("m_no가 null -> 로그인 페이지로 리다이렉트");
	        return "redirect:/loginForm";
	    }

	    com_service.CommunityDelete(comm_no, m_no);

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

}