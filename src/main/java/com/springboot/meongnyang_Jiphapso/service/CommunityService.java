package com.springboot.meongnyang_Jiphapso.service;

import java.io.File;
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

	//@Autowired
	//private PointService pointService; 
	
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
	    
	    // 2. 동영상 파일 처리, comm_video는 dc_community 컬럼
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
	}
	
		
	// 크롤링 데이터 업로드 용
	public void writeCrawling(CommunityDTO dto, String contentImg) throws Exception {
		
		dao.CommunityWrite(dto);
		
		Integer commNo = dto.getComm_no();
		
		
		if(contentImg != null && !contentImg.isEmpty()) {
			String[] imgUrls = contentImg.split(",");
			for(int i = 0; i < imgUrls.length; i++) {
				CommImageDTO imgDto = new CommImageDTO();
				imgDto.setComm_no(commNo);
				imgDto.setImg_url(imgUrls[i].trim());
				imgDto.setImg_order(i+1);
				
				dao.CommunityImageWrite(imgDto);
			}
		}
		esService.save(dto);
	}
	
	public List<CommunityDTO> list(){
		return dao.CommunityAllList();
	}
	
	public List<CommunityDTO> selectList(String comm_type, String comm_pet_type, String comm_category, String sort, int startRow, int endRow){
		return dao.CommunitySelectList(comm_type, comm_pet_type, comm_category, sort, startRow, endRow);
	}
	
	// 전체 게시글 개수 조회 (페이징 바 계산용)
	public int getTotalCount(String comm_type, String comm_pet_type, String comm_category) {
		return dao.getTotalCount(comm_type, comm_pet_type, comm_category);
	}
	
	public CommunityDTO viewList(int comm_no) {
		return dao.CommunityView(comm_no);
	}
	
	public List<CommunityDTO> search(String keyword) throws Exception{
		return esService.search(keyword);
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

	    // 1. 해당 탭(commType)의 모든 게시글 목록을 가져옴 (필요시 commType 조건만 파라미터로 전달)
	    // 기존에 있는 Dao 메서드나 별도의 전체 조회 메서드 활용
	    List<CommunityDTO> list = dao.getCommunityListForStats(commType);
	    
	    // 1-1. 총 개수
	    int totalCount = list.size();
	    result.put("totalCount", totalCount);

	    // 2. 펫 유형별 비율 계산 (Map을 이용한 그룹바이 집계)
	    Map<String, Long> petCountMap = list.stream()
	        .filter(c -> c.getComm_pet_type() != null)
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
	        if (c.getComm_date() != null) {
	            // 날짜 형식에 맞춰 월 추출 (java.sql.Date 또는 LocalDate 기준)
	            Calendar cal = Calendar.getInstance();
	            cal.setTime(c.getComm_date());
	            int month = cal.get(Calendar.MONTH); // 0(1월) ~ 11(12월)
	            monthlyCounts[month]++;
	        }
	    }
	    result.put("monthlyCounts", monthlyCounts);

	    // 4. 반응 비율 (도움돼요 / 글쎄요 합산)
	    int totalHelpful = list.stream().mapToInt(CommunityDTO::getComm_good).sum();
	    int totalUseless = list.stream().mapToInt(CommunityDTO::getComm_well).sum();
	    Map<String, Object> reactionRatio = new HashMap<>();
	    reactionRatio.put("HELPFUL", totalHelpful);
	    reactionRatio.put("USELESS", totalUseless);
	    result.put("reactionRatio", reactionRatio);

	    // 5. 태그 Top 5 추출 (comm_tag 컬럼이 콤마로 구분되어 있는 경우 자바에서 완벽하게 파싱!)
	    Map<String, Integer> tagCountMap = new HashMap<>();
	    for (CommunityDTO c : list) {
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
	
	// 커뮤니티 글(리뷰) insert 성공 직후, 대상 금액의 3% 적립
	// pointService.earnCommunityBonus(mNo, baseAmount);

	
	
}
