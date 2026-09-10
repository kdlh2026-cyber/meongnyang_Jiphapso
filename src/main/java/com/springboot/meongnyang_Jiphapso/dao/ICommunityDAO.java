package com.springboot.meongnyang_Jiphapso.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.springboot.meongnyang_Jiphapso.dto.BreedDTO;
import com.springboot.meongnyang_Jiphapso.dto.CommImageDTO;
import com.springboot.meongnyang_Jiphapso.dto.CommunityDTO;

@Mapper
public interface ICommunityDAO {
	// 게시글 전체 조회(select)
	public List<CommunityDTO> CommunityAllList();

	
	// 목록에서 게시글 필터(카테고리와 펫 타입)하여 조회(select)
	public List<CommunityDTO> CommunitySelectList(@Param("comm_type") String comm_type,
												  @Param("comm_pet_type") String comm_pet_type,
												  @Param("comm_category") String comm_category,
												  @Param("sort") String sort,
												  @Param("startRow") int startRow,
												  @Param("endRow") int endRow
												  );
	
	public int getTotalCount(@Param("comm_type") String comm_type,
							 @Param("comm_pet_type") String comm_pet_type,
							 @Param("comm_category") String comm_category);
	
	
	// 게시글 상세보기 조회(select)
	public CommunityDTO CommunityView(int comm_no);
	
	// 게시글 조회 수 업데이트
	public int CommunityHit(int comm_no);
	
	// 게시글 작성하기(insert)
	public int CommunityWrite(CommunityDTO commDto);
	
	// 게시글 수정하기(update) -> 본인이 쓴 글만 수정 가능
	public int CommunityUpdate(CommunityDTO commDto);
	
	// 게시글 삭제하기(delete) -> 본인이 쓴 글만 삭제 가능 / 관리자는 모든 글 삭제 가능
	public int CommunityDelete(int comm_no);
	
	// 게시글 이미지 테이블에 저장(insert)
	public void CommunityImageWrite(CommImageDTO imgDto) throws Exception;
}