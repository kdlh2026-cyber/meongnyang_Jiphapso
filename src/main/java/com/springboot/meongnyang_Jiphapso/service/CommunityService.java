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
	
	
	public void write(CommunityDTO dto, MultipartFile[] uploadFiles) throws Exception{
		// 1. 파일이 업로드된 경우 처리
	    if (uploadFiles != null && uploadFiles.length > 0) {
	        // 파일을 저장할 서버 경로 설정 (예시 경로)
	        String uploadPath = "C:\\upload\\community\\"; 
	        
	        // 만약 첫 번째 이미지를 대표 이미지(comm_img)로 저장한다면:
	        MultipartFile firstFile = uploadFiles[0];
	        if (!firstFile.isEmpty()) {
	            String originalFileName = firstFile.getOriginalFilename();
	            // 파일 중복 방지를 위한 UUID 조합
	            String savedFileName = UUID.randomUUID().toString() + "_" + originalFileName;
	            
	            // 파일 저장
	            File target = new File(uploadPath, savedFileName);
	            firstFile.transferTo(target);
	            
	            // DTO에 이미지 경로 또는 파일명 세팅 (DB의 comm_img 컬럼에 들어갈 값)
	            dto.setComm_img(savedFileName); 
	        }
	        
	        // 만약 다중 파일을 별도의 이미지 테이블에 각각 저장해야 한다면 
	        // 여기서 반복문을 돌며 개별 파일 저장 로직을 추가하시면 됩니다!
	    }
		
		
		dao.CommunityWrite(dto);
		esService.save(dto);
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
