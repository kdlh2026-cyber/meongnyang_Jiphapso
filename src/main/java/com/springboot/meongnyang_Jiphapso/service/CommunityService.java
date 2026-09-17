package com.springboot.meongnyang_Jiphapso.service;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.springboot.meongnyang_Jiphapso.dao.ICommentDAO;
import com.springboot.meongnyang_Jiphapso.dao.ICommunityDAO;
import com.springboot.meongnyang_Jiphapso.dto.CommImageDTO;
import com.springboot.meongnyang_Jiphapso.dto.CommunityDTO;

@Service
public class CommunityService {
	@Autowired
	ICommunityDAO dao;
	
	@Autowired
	CommunityESService esService;
	
	@Autowired
	ICommentDAO cmt_dao;

	@Autowired
	private PointService pointService;
	
	public void write(CommunityDTO dto, MultipartFile[] uploadImages, MultipartFile[] uploadVideo) throws Exception {
	    String uploadPath = "C:\\Users\\KH_BUSAN_B_15\\git\\meongnyang_Jiphapso\\src\\main\\resources\\static\\images\\community"; 
	    
	    // 폴더가 없으면 생성
	    File dir = new File(uploadPath);
	    if (!dir.exists()) {
	        dir.mkdirs();
	    }
	    
	    List<String> savedImagePaths = new ArrayList<>();

	    // 1. 사진 파일 처리 (첫 번째 이미지를 대표 이미지로 설정)
	    if (uploadImages != null && uploadImages.length > 0) {
	        for (MultipartFile file : uploadImages) {
	            if (file != null && !file.isEmpty()) {
	                String originalFileName = file.getOriginalFilename();
	                String savedFileName = UUID.randomUUID().toString() + "_" + originalFileName;

	                File target = new File(uploadPath, savedFileName);
	                file.transferTo(target);

	                // 웹에서 접근할 경로 (정적 리소스 매핑 기준)
	                String webPath = "/images/community/" + savedFileName;
	                savedImagePaths.add(webPath);
	            }
	        }

	        if (!savedImagePaths.isEmpty()) {
	            // 첫 번째 이미지를 대표 썸네일로 지정
	            dto.setComm_img(savedImagePaths.get(0));
	        }
	    }
	    
	    // 2. 동영상 파일 처리 부분
	    if (uploadVideo != null && uploadVideo.length > 0) {
	        MultipartFile videoFile = uploadVideo[0];
	        if (!videoFile.isEmpty()) {
	            String originalVideoName = videoFile.getOriginalFilename();
	            
	            // 확장자 추출 (.mp4 등)
	            String extension = "";
	            if (originalVideoName != null && originalVideoName.contains(".")) {
	                extension = originalVideoName.substring(originalVideoName.lastIndexOf("."));
	            } else {
	                extension = ".mp4"; // 기본값
	            }
	            
	            // UUID + 확장자 조합으로 안전한 파일명 생성 (한글/공백 원천 차단)
	            String savedVideoName = UUID.randomUUID().toString() + extension;
	            
	            File targetVideo = new File(uploadPath, savedVideoName);
	            videoFile.transferTo(targetVideo);
	            
	            dto.setComm_video(savedVideoName); // 정제된 파일명 세팅
	        }
	    }
	    
	    if (dto.getComm_view() == null) {
	        dto.setComm_view(0);
	    }
	    if (dto.getComm_good() == null) {
	        dto.setComm_good(0);
	    }
	    if (dto.getComm_well() == null) {
	        dto.setComm_well(0);
	    }
	    if (dto.getComm_count() == null) {
	        dto.setComm_count(0);
	    }
	    
	    // 3. DAO 호출하여 DB에 커뮤니티 글 Insert
	    dao.CommunityWrite(dto);
	
	    // 4. 전체 이미지를 이미지 테이블에 순서대로 저장
	    Integer commNo = dto.getComm_no();
	    
	    for(int i=0; i<savedImagePaths.size(); i++) {
	    	CommImageDTO imgDto = new CommImageDTO();
	    	imgDto.setComm_no(commNo);
	    	imgDto.setImg_url(savedImagePaths.get(i));
	    	imgDto.setImg_order(i+1);
	    	
	    	System.out.println("저장할 이미지 - comm_no: " + imgDto.getComm_no()
            + ", cmt_no: " + imgDto.getCmt_no()
            + ", img_url: " + imgDto.getImg_url());
	    	
	    	dao.CommunityImageWrite(imgDto);
	    }
	    
	    esService.save(dto);
	}
	
	public List<CommunityDTO> list(){
		return dao.CommunityAllList();
	}
	
	// 메인
	public List<CommunityDTO> getRecommendList() {
        return dao.recommendContentList();
    }
	
	public List<CommunityDTO> selectList(String comm_type, String comm_pet_type, String comm_category, String sort, int startRow, int endRow){
        return dao.CommunitySelectList(comm_type, comm_pet_type, comm_category, sort, startRow, endRow);
    }

	public Map<String, Object> searchWithPaging(String keyword, int page) throws Exception {
	    int pageSize = 10;
	    int blockSize = 10;

	    Map<String, Object> esResult = esService.search(keyword, page, pageSize);
	    List<CommunityDTO> list = (List<CommunityDTO>) esResult.get("list");
	    long totalCount = (long) esResult.get("totalCount");
	    int totalPages = (int) Math.ceil((double) totalCount / pageSize);
	    if (totalPages == 0) totalPages = 1;

	    int startPage = ((page - 1) / blockSize) * blockSize + 1;
	    int endPage = Math.min(startPage + blockSize - 1, totalPages);

	    Map<String, Object> result = new HashMap<>();
	    result.put("list", list);
	    result.put("pageNum", page);
	    result.put("totalCount", totalCount);
	    result.put("totalPages", totalPages);
	    result.put("startPage", startPage);
	    result.put("endPage", endPage);
	    result.put("prev", startPage > 1);
	    result.put("next", endPage < totalPages);
	    return result;
	}
	
	// 비검색용 페이징 정보 (일반 목록, 관리자 목록에서 사용)
	public Map<String, Object> getPagingInfo(String comm_type, String comm_pet_type, String comm_category, int page) {
	    int pageSize = 10;
	    int blockSize = 10;

	    int totalCount = dao.getTotalCount(comm_type, comm_pet_type, comm_category);
	    int totalPages = (int) Math.ceil((double) totalCount / pageSize);
	    if (totalPages == 0) totalPages = 1;

	    int startPage = ((page - 1) / blockSize) * blockSize + 1;
	    int endPage = Math.min(startPage + blockSize - 1, totalPages);

	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("comm_type", comm_type);
	    paramMap.put("comm_pet_type", comm_pet_type);

	    Map<String, Object> pagingMap = new HashMap<>();
	    pagingMap.put("pageNum", page);
	    pagingMap.put("totalPages", totalPages);
	    pagingMap.put("totalCount", totalCount);
	    pagingMap.put("startPage", startPage);
	    pagingMap.put("endPage", endPage);
	    pagingMap.put("popularList", dao.selectPopular(paramMap));
	    pagingMap.put("recommendList", dao.recommendContentTen());
	    pagingMap.put("prev", startPage > 1);
	    pagingMap.put("next", endPage < totalPages);
	    return pagingMap;
	}
	
	// 전체 게시글 개수 조회 (페이징 바 계산용)
	public int getTotalCount(String comm_type, String comm_pet_type, String comm_category) {
		return dao.getTotalCount(comm_type, comm_pet_type, comm_category);
	}
	
	
	public int getSearchTotalCount(String keyword, String comm_type, String comm_pet_type, String comm_category) {
	    return dao.getSearchTotalCount(keyword, comm_type, comm_pet_type, comm_category);
	}
	
	public CommunityDTO viewList(int comm_no) {
		return dao.CommunityView(comm_no);
	}
	
	// 내 게시글 삭제
	public int CommunityDelete(int comm_no, int m_no) {
	    return dao.CommunityDelete(comm_no, m_no);
	}
	
	// 내 게시글 업데이트
	public int CommunityUpdate(CommunityDTO dto) {
		return dao.CommunityUpdate(dto);
	}
	
	// 자동완성 + 하이라이트
	public List<Map<String,String>> autocomplete(String keyword) throws Exception{
		return esService.autocompleteHighlight(keyword);
	}
	
	// 관리자 게시글 접속시 메소드
	public List<Map<String, Object>> getAllCategoryStats() {
        return dao.getAllCategoryStats();
    }
	
	// 관리자용 게시글 검색 및 목록 조회 (필터, 정렬, 페이징 지원)
	public Map<String, Object> adminSearchCommunity(String searchType,
													String keyword, String sort,
													Integer page, Integer size,
													String comm_type, 
													String comm_pet_type,
													String comm_category) throws Exception {
		
	    int pageNum = (page == null || page <= 0) ? 1 : page;
	    int pageSize = (size == null || size <= 0) ? 10 : size;
	    int blockSize = 10;
	    String sortOption = (sort == null || sort.trim().isEmpty()) ? "latest" : sort;

	    Map<String, Object> esResult = esService.adminSearchCommunity(searchType, keyword, sortOption, pageNum, pageSize);
	    List<Map<String, Object>> searchList = (List<Map<String, Object>>) esResult.get("list");
	    
	    // 3. ⭐️ 엘라스틱서치에서 문자열로 넘어온 날짜(comm_date)를 java.util.Date 객체로 변환
	    if (searchList != null && !searchList.isEmpty()) {
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); // 날짜 포맷에 맞게 설정
	        
	        for (Map<String, Object> item : searchList) {
	            Object dateObj = item.get("comm_date");
	            if (dateObj instanceof String) {
	                try {
	                    String dateStr = (String) dateObj;
	                    // "2026-08-12T15:00:00.000Z" 형태라면 앞 10자리(yyyy-MM-dd)만 끊어서 파싱
	                    if (dateStr.length() >= 10) {
	                        item.put("comm_date", sdf.parse(dateStr.substring(0, 10)));
	                    }
	                } catch (Exception e) {
	                    // 파싱 실패 시 예외 처리 (로그 또는 무시)
	                    e.printStackTrace();
	                }
	            }
	        }
	    }
	    
	    // ⭐️ 페이징 계산 추가
	    long totalCount = (long) esResult.get("totalCount");
	    int totalPages = (int) Math.ceil((double) totalCount / pageSize);
	    if (totalPages == 0) totalPages = 1;

	    int startPage = ((pageNum - 1) / blockSize) * blockSize + 1;
	    int endPage = Math.min(startPage + blockSize - 1, totalPages);

	    esResult.put("list", searchList);
	    esResult.put("totalPages", totalPages);
	    esResult.put("startPage", startPage);
	    esResult.put("endPage", endPage);
	    esResult.put("prev", startPage > 1);
	    esResult.put("next", endPage < totalPages);
	    return esResult;
	}
	
	// 목록 조회
	public List<CommunityDTO> myList(Integer m_no, String comm_type) {
	    return dao.myList(m_no, comm_type);
	}

	// 최신글 1개 조회
	public CommunityDTO getLatestByType(Integer m_no, String comm_type) {
	    return dao.getLatestByType(m_no, comm_type);
	}
	
	@Transactional
	public String processRecommend(int comm_no, int m_no, String type) {
	    // 1. 기존 투표 타입 조회
	    String votedType = dao.getRecommendType(comm_no, m_no);
	    
	    if (votedType != null) {
	        // 이미 투표한 이력이 있는 경우
	        if (votedType.equals(type)) {
	            // [토글] 내가 이미 눌렀던 그 버튼을 다시 누름 -> 취소 처리
	            dao.deleteRecommend(comm_no, m_no);
	            
	            if ("GOOD".equals(type)) {
	                dao.decreaseCommGood(comm_no);
	            } else if ("WELL".equals(type)) {
	                dao.decreaseCommWell(comm_no);
	            }
	            return "CANCELED";
	        } else {
	            // [차단] 반대쪽 버튼을 누르려 함 -> 이미 평가함 리턴
	            return "ALREADY_VOTED";
	        }
	    }

	    // 2. 투표 이력이 아예 없는 경우 -> 신규 등록
	    dao.insertRecommend(comm_no, m_no, type);

	    if ("GOOD".equals(type)) {
	        dao.updateCommGood(comm_no);
	    } else if ("WELL".equals(type)) {
	        dao.updateCommWell(comm_no);
	    }

	    return "SUCCESS";
	}
	
	public int getTodayCountByType(String comm_type) {
		return dao.getTodayCountByType(comm_type);
	}
	
	public Map<String, Object> getCommunityStatsByJava(String commType) {
	    Map<String, Object> result = new HashMap<>();

	    // 1. 해당 탭(commType)의 모든 게시글 목록을 가져옴 (null 방어)
	    List<CommunityDTO> list = dao.getCommunityListForStats(commType);
	    if (list == null) {
	        list = new ArrayList<>();
	    }
	    
	    // 1-1. 총 개수
	    int totalCount = list.size();
	    result.put("totalCount", totalCount);

	    // 2. 펫 유형별 비율 계산 (Map을 이용한 그룹바이 집계)
	    Map<String, Long> petCountMap = list.stream()
	        .filter(c -> c != null && c.getComm_pet_type() != null) // c가 null인 경우 방어
	        .collect(Collectors.groupingBy(CommunityDTO::getComm_pet_type, Collectors.counting()));

	    List<Map<String, Object>> petRatioList = new ArrayList<>();
	    for (Map.Entry<String, Long> entry : petCountMap.entrySet()) {
	        String petName = entry.getKey();
	        long count = entry.getValue();
	        // 퍼센트 계산 (0으로 나누기 방지)
	        double percent = totalCount == 0 ? 0.0 : Math.round((count * 100.0 / totalCount) * 10.0) / 10.0;

	        Map<String, Object> petMap = new HashMap<>();
	        petMap.put("PET_NAME", petName);
	        petMap.put("COUNT", count);
	        petMap.put("PERCENT", percent);
	        
	        // 색상 지정
	        if ("강아지".equals(petName)) petMap.put("COLOR", "#ff7a00");
	        else if ("고양이".equals(petName)) petMap.put("COLOR", "#36a2eb");
	        else if ("소동물".equals(petName)) petMap.put("COLOR", "#ffce56");
	        else petMap.put("COLOR", "#4bc0c0");

	        petRatioList.add(petMap);
	    }
	    // 건수 많은 순으로 정렬
	    petRatioList.sort((a, b) -> Long.compare((Long)b.get("COUNT"), (Long)a.get("COUNT")));
	    result.put("petRatioList", petRatioList);

	    // 3. 월별 등록 현황 (1월~12월 배열 만들기)
	    int[] monthlyCounts = new int[12];
	    for (CommunityDTO c : list) {
	        if (c != null && c.getComm_date() != null) {
	            Calendar cal = Calendar.getInstance();
	            cal.setTime(c.getComm_date());
	            int month = cal.get(Calendar.MONTH); // 0(1월) ~ 11(12월)
	            monthlyCounts[month]++;
	        }
	    }
	    result.put("monthlyCounts", monthlyCounts);

	    // 4. 반응 비율 (도움돼요 / 글쎄요 합산) - [Null 방어 추가]
	    int totalHelpful = list.stream()
	            .filter(c -> c != null)
	            .mapToInt(c -> c.getComm_good() != null ? c.getComm_good() : 0)
	            .sum();
	            
	    int totalUseless = list.stream()
	            .filter(c -> c != null)
	            .mapToInt(c -> c.getComm_well() != null ? c.getComm_well() : 0)
	            .sum();

	    Map<String, Object> reactionRatio = new HashMap<>();
	    reactionRatio.put("HELPFUL", totalHelpful);
	    reactionRatio.put("USELESS", totalUseless);
	    result.put("reactionRatio", reactionRatio);

	    // 5. 태그 Top 5 추출 (comm_tag 컬럼 파싱)
	    Map<String, Integer> tagCountMap = new HashMap<>();
	    for (CommunityDTO c : list) {
	        if (c != null) {
	            String tags = c.getComm_tag();
	            if (tags != null && !tags.trim().isEmpty()) {
	                String[] tagArray = tags.split(",");
	                for (String tag : tagArray) {
	                    String cleanTag = tag.trim();
	                    if (!cleanTag.isEmpty()) {
	                        tagCountMap.put(cleanTag, tagCountMap.getOrDefault(cleanTag, 0) + 1);
	                    }
	                }
	            }
	        }
	    }

	    // 빈도수 높은 순으로 정렬 후 상위 5개 추출
	    List<Map.Entry<String, Integer>> sortedTags = new ArrayList<>(tagCountMap.entrySet());
	    sortedTags.sort((a, b) -> b.getValue().compareTo(a.getValue()));

	    List<Map<String, Object>> tagRankList = new ArrayList<>();
	    int limit = Math.min(5, sortedTags.size());
	    for (int i = 0; i < limit; i++) {
	        Map.Entry<String, Integer> entry = sortedTags.get(i);
	        Map<String, Object> tagMap = new HashMap<>();
	        tagMap.put("TAG_NAME", entry.getKey());
	        tagMap.put("TAG_COUNT", entry.getValue());
	        tagRankList.add(tagMap);
	    }
	    result.put("tagRankList", tagRankList);
	    result.put("comm_type", commType);

	    return result;
	}
	
	// 인기 Top 10 목록 가져오기 (comm_type: Q&A, 라운지 등 탭 분류)
	public List<CommunityDTO> getPopularList(Map<String, Object> params) {
	    // 1. DAO를 통해 SQL 조건에 맞는 전체 목록을 조회 (ROWNUM 제거된 상태)
	    List<CommunityDTO> fullList = dao.selectPopular(params);
	    
	    // 2. 데이터가 null일 경우를 대비한 방어 코드
	    if (fullList == null) {
	        fullList = new ArrayList<>();
	    }
	    
	    // 3. 자바 Stream을 이용해 상위 10개만 추출 (.limit(10))
	    List<CommunityDTO> top10List = fullList.stream()
	                                         .limit(10)
	                                         .collect(Collectors.toList());
	                                         
	    return top10List;
	}
	
	public int adminCommunityDelete(int comm_no) {
        // 만약 게시글 삭제 시 연관된 이미지 파일이나 댓글 등을 같이 지워야 한다면 여기서 추가 로직 수행 가능
        return dao.adminCommunityDelete(comm_no);
    }
	
	public int updateAdPick(int comm_no) {
        return dao.updateAdPick(comm_no);
    }
	
	
	// 커뮤니티 글(리뷰) insert 성공 직후, 대상 금액의 3% 적립
	// pointService.earnCommunityBonus(mNo, baseAmount);

	
	
}
