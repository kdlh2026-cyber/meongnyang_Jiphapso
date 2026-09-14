package com.springboot.meongnyang_Jiphapso.dao;
import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.springboot.meongnyang_Jiphapso.dto.FavoriteDTO;
import java.util.Map;
@Mapper
public interface IFavoriteDAO {
	
	// 찜 등록
	int insertFavorite(FavoriteDTO dto);
	
	// 단건 삭제 (찜 해제)
	int deleteFavorite (@Param("faNo") Long faNo);
	
	// 선택 삭제 
	int deletrFavoriteList(@Param("faNoList") List<Long> faNoList);
	
	// 회원 전체삭제
    int deleteFavoriteAllByMember(@Param("mNo") Long mNo);
    
    // 단건 조회 (상세페이지)
    FavoriteDTO selectFavoriteOne(@Param("faNo") Long faNo);
    
    // 회원 관심상품 목록 (상품 조인)
    List<FavoriteDTO> selectFavoriteListByMember(@Param("mNo") Long mNo);
    
    // 비회원 관심상품 목록
    List<FavoriteDTO> selectFavoriteListByToken(@Param("faToken") String faToken);
    
    // 회원 - 이미 찜한 건지 여부 확인
    int checkFavoriteExists(@Param("mNo") Long mNo, @Param("pNo") Long pNo);
    
    // 비회원 - 이미 찜한 건지 여부 확인
    int checkFavoriteExistsByToken(@Param("faToken") String faToken, @Param("pNo") Long pNo);
    
    // 관리자 - 전체 관심상품 목록
    List<FavoriteDTO> selectFavoriteListAll();
    
	// 관리자 - 회원별 관심상품 요약 (회원아이디 + 개수)
	List<Map<String, Object>> selectFavoriteMemberSummaryAll();
}