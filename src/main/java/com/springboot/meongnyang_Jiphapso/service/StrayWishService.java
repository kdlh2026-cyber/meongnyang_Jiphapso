package com.springboot.meongnyang_Jiphapso.service;

import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.meongnyang_Jiphapso.dao.IStrayWishDao;
import com.springboot.meongnyang_Jiphapso.dto.StrayAnimalDto;
import com.springboot.meongnyang_Jiphapso.dto.StrayWishDto;

@Service
public class StrayWishService {
	@Autowired
	private IStrayWishDao wish_dao;

    // 찜 토글 (있으면 삭제, 없으면 추가)
    public boolean toggleWish(StrayWishDto dto) {
        int count = wish_dao.checkWishExists(dto);
        if (count > 0) {
            wish_dao.deleteWish(dto);
            return false; // 삭제됨
        } else {
            wish_dao.insertWish(dto);
            return true;  // 추가됨
        }
    }

    // 회원 찜 목록 조회
    public List<StrayAnimalDto> getWishListByMember(Integer m_no) {
        if (m_no == null) return Collections.emptyList();
        return wish_dao.selectWishListByMember(m_no);
    }

    // 비회원 찜 목록 조회
    public List<StrayAnimalDto> getWishListByGuest(String guestId) {
        if (guestId == null || guestId.trim().isEmpty()) return Collections.emptyList();
        return wish_dao.selectWishListByGuest(guestId);
    }
    
    // 회원 찜 번호 목록 조회
    public List<Long> getWishHeartByMember(Integer m_no) {
        if (m_no == null) return Collections.emptyList();
        return wish_dao.selectWishHeartByMember(m_no);
    }

    // 비회원 찜 번호 목록 조회
    public List<Long> getWishHeartByGuest(String guestId) {
        if (guestId == null || guestId.trim().isEmpty()) return Collections.emptyList();
        return wish_dao.selectWishHeartByGuest(guestId);
    }
    
    public void transferGuestToMember(String guestId, int m_no) {
        if (guestId != null && !guestId.trim().isEmpty()) {
            wish_dao.updateGuestWishToMember(guestId, m_no);
        }
    }
    
    public Integer getMemberNoById(String m_id) {
        if (m_id == null || m_id.trim().isEmpty()) return null;
        return wish_dao.selectMemberNoById(m_id);
    }
}
