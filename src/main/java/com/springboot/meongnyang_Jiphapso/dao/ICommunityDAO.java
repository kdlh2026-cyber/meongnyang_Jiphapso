package com.springboot.meongnyang_Jiphapso.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.springboot.meongnyang_Jiphapso.dto.CommImageDTO;
import com.springboot.meongnyang_Jiphapso.dto.CommunityDTO;
import com.springboot.meongnyang_Jiphapso.dto.CommunityRecommendDTO;

@Mapper
public interface ICommunityDAO {
	// 게시글 전체 조회(select)
	public List<CommunityDTO> CommunityAllList();

	// 메인 추천 게시글 상위 8개 조회
    public List<CommunityDTO> recommendContentList();
	
	// 목록에서 게시글 필터(카테고리와 펫 타입)하여 조회(select)
	public List<CommunityDTO> CommunitySelectList(@Param("comm_type") String comm_type,
												  @Param("comm_pet_type") String comm_pet_type,
												  @Param("comm_category") String comm_category,
												  @Param("sort") String sort,
												  @Param("startRow") int startRow,
												  @Param("endRow") int endRow
												  );
	
	// top10 조회
	public List<CommunityDTO> selectPopular(Map<String, Object> params);
	
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
	public int CommunityDelete(@Param("comm_no") int comm_no, @Param("m_no") int m_no);
	
	// 게시글 이미지 테이블에 저장(insert)
	public void CommunityImageWrite(CommImageDTO imgDto) throws Exception;
	
	// 내가 쓴 글 조회
	public List<CommunityDTO> myList(@Param("m_no") Integer m_no,
									 @Param("comm_type") String comm_type);
	
	// 가장 최신글 하나만 조회
	public CommunityDTO getLatestByType(@Param("m_no") Integer m_no,
										@Param("comm_type") String comm_type);
	
	// 이미 투표했는지 확인 (count 결과값을 받기 위해 int 반환)
	public int checkRecommend(@Param("comm_no") int comm_no, @Param("m_no") int m_no);

    // 투표 이력 저장 (삽입된 행의 개수나 성공 여부를 확인하기 위해 int 반환 가능)
    public int insertRecommend(@Param("comm_no") int comm_no,
    						   @Param("m_no") int m_no,
    						   @Param("rec_type") String rec_type);
    
    public String getRecommendType(@Param("comm_no") int comm_no, @Param("m_no") int m_no);

    // 게시글 도움돼요(good) 수 증가
    public int updateCommGood(int comm_no);

    // 게시글 글쎄요(well) 수 증가
    public int updateCommWell(int comm_no);
    
    // 투표 이력 삭제 (취소)
    public int deleteRecommend(@Param("comm_no") int comm_no,
    						   @Param("m_no") int m_no);

    // 게시글 도움돼요(good) 수 감소
    public int decreaseCommGood(int comm_no);

    // 게시글 글쎄요(well) 수 감소
    public int decreaseCommWell(int comm_no);
    
    // 관리자용
    public int getTodayCountByType(@Param("comm_type") String comm_type);
    
    // 관리자용 지우기
    public int adminCommunityDelete(int comm_no);
    
    // 관리자 픽
    public int updateAdPick(int comm_no);
    
    // 관리자 게시글 관리 접속시(최적화)
    public List<Map<String, Object>> getAllCategoryStats();
    
    // 통계용
    List<CommunityDTO> getCommunityListForStats(@Param("comm_type") String comm_type);
}