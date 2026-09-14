package com.springboot.meongnyang_Jiphapso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.springboot.meongnyang_Jiphapso.dao.IFavoriteDAO;
import com.springboot.meongnyang_Jiphapso.dto.FavoriteDTO;

@Service
public class FavoriteService {
	private final IFavoriteDAO favoriteDAO;
	
	@Autowired
	public FavoriteService(IFavoriteDAO favoriteDAO) {
		this.favoriteDAO = favoriteDAO;
	}
	
	@Transactional
	public boolean toggleFavorite(Long mNo,String guestToken, Long pNo) {
		if(mNo != null && favoriteDAO.checkFavoriteExists(mNo, pNo) > 0) {
			List<FavoriteDTO> list = favoriteDAO.selectFavoriteListByMember(mNo);
			list.stream()
            .filter(f -> f.getPNo().equals(pNo))
            .findFirst()
            .ifPresent(f -> favoriteDAO.deleteFavorite(f.getFaNo()));
    return false;
		}
		FavoriteDTO dto = new FavoriteDTO();
        dto.setMNo(mNo);
        dto.setFaToken(mNo == null ? guestToken : null);
        dto.setPNo(pNo);
        favoriteDAO.insertFavorite(dto);
        return true;
	}
	
	/** 관리자용 - 소유자 검증 없이 강제 삭제 */
	@Transactional
	public void  deleteFavorite(Long faNo) {
		favoriteDAO.deleteFavorite(faNo);
	}
	
	/** 사용자용 - 소유자 검증 후 삭제 */
	@Transactional
	public void deleteFavorite(Long faNo, Long mNo, String guestToken) {
		FavoriteDTO favorite = favoriteDAO.selectFavoriteOne(faNo);
		checkOwner(favorite, mNo, guestToken);
		favoriteDAO.deleteFavorite(faNo);
	}
	
	/** 관리자용 - 소유자 검증 없이 일괄 삭제 */
	@Transactional
	public void deleteFavoriteList(List<Long>faNoList) {
		if(faNoList == null || faNoList.isEmpty()) return;
			favoriteDAO.deletrFavoriteList(faNoList);
	}
	
	/** 사용자용 - 소유자 검증 후 일괄 삭제 */
	@Transactional
	public void deleteFavoriteList(List<Long> faNoList, Long mNo, String guestToken) {
		if(faNoList == null || faNoList.isEmpty()) return;
		for(Long faNo : faNoList) {
			FavoriteDTO favorite = favoriteDAO.selectFavoriteOne(faNo);
			checkOwner(favorite, mNo, guestToken);
		}
		favoriteDAO.deletrFavoriteList(faNoList);
	}
	
	/** 요청자가 이 관심상품의 소유자(회원 or 게스트 토큰)인지 검증 */
	public void checkOwner(FavoriteDTO favorite, Long mNo, String guestToken) {
		boolean isMemberOwner = (mNo != null && mNo.equals(favorite.getMNo()));
		boolean isGuestOwner = (guestToken != null && guestToken.equals(favorite.getFaToken()));
		if (!isMemberOwner && !isGuestOwner) {
			throw new IllegalStateException("본인 관심상품만 접근할 수 있습니다"); // 프로젝트 공용 예외 있으면 그걸로 교체
		}
	}
	
	public FavoriteDTO getFavoriteOne(Long faNo) {
        return favoriteDAO.selectFavoriteOne(faNo);
    }
    public List<FavoriteDTO> getFavoriteListByMember(Long mNo) {
        return favoriteDAO.selectFavoriteListByMember(mNo);
    }
    public List<FavoriteDTO> getFavoriteListByToken(String guestToken) {
        return favoriteDAO.selectFavoriteListByToken(guestToken);
    }
    public boolean isFavorite(Long mNo, Long pNo) {
        if (mNo == null) return false;
        return favoriteDAO.checkFavoriteExists(mNo, pNo) > 0;
    }
    /** 관리자 - 전체 목록 */
    public List<FavoriteDTO> getFavoriteListAll() {
        return favoriteDAO.selectFavoriteListAll();
    }
    /** 관리자 - 회원별 관심상품 요약 목록 */
    public List<Map<String, Object>> getFavoriteMemberSummaryAll() {
        return favoriteDAO.selectFavoriteMemberSummaryAll();
    }
}