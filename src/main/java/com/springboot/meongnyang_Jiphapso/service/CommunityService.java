package com.springboot.meongnyang_Jiphapso.service;

import java.io.File;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.springboot.meongnyang_Jiphapso.dao.ICommunityDAO;
import com.springboot.meongnyang_Jiphapso.dto.CommImageDTO;
import com.springboot.meongnyang_Jiphapso.dto.CommunityDTO;

@Service
public class CommunityService {
	@Autowired
	ICommunityDAO dao;
	
	@Autowired
	CommunityESService esService;
	
	
	public void write(CommunityDTO dto, MultipartFile[] uploadImages, MultipartFile[] uploadVideo) throws Exception {
	    
	    String uploadPath = "C:\\Users\\KH_BUSAN_B_15\\git\\meongnyang_Jiphapso\\src\\main\\resources\\static\\images\\community"; 
	    
	    // 폴더가 없으면 생성
	    File dir = new File(uploadPath);
	    if (!dir.exists()) {
	        dir.mkdirs();
	    }

	    // 1. 사진 파일 처리 (첫 번째 이미지를 대표 이미지로 설정)
	    if (uploadImages != null && uploadImages.length > 0) {
	        MultipartFile firstFile = uploadImages[0];
	        if (!firstFile.isEmpty()) {
	            String originalFileName = firstFile.getOriginalFilename();
	            String savedFileName = UUID.randomUUID().toString() + "_" + originalFileName;
	            
	            File target = new File(uploadPath, savedFileName);
	            firstFile.transferTo(target);
	            
	            dto.setComm_img(savedFileName); // DTO의 comm_img 필드와 연동
	        }
	    }
	    
	    // 2. 동영상 파일 처리
	    if (uploadVideo != null && uploadVideo.length > 0) {
	        MultipartFile videoFile = uploadVideo[0];
	        if (!videoFile.isEmpty()) {
	            String originalVideoName = videoFile.getOriginalFilename();
	            String savedVideoName = UUID.randomUUID().toString() + "_" + originalVideoName;
	            
	            File targetVideo = new File(uploadPath, savedVideoName);
	            videoFile.transferTo(targetVideo);
	            
	            dto.setComm_video(savedVideoName); // DTO의 comm_video 필드와 연동
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
	
	// 자동완성 + 하이라이트
	public List<Map<String,String>> autocomplete(String keyword) throws Exception{
		return esService.autocompleteHighlight(keyword);
	}
}
