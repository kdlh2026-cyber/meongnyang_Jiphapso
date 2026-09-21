package com.springboot.meongnyang_Jiphapso.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.springboot.meongnyang_Jiphapso.dto.StrayAnimalDto;
import com.springboot.meongnyang_Jiphapso.dto.StrayWishDto;

@Mapper
public interface IStrayWishDao {
	int insertWish(StrayWishDto dto);

    int deleteWish(StrayWishDto dto);

    int checkWishExists(StrayWishDto dto);

    List<StrayAnimalDto> selectWishListByMember(@Param("m_no") int m_no);

    List<StrayAnimalDto> selectWishListByGuest(@Param("guestId") String guestId);
    
    List<Long> selectWishHeartByMember(@Param("m_no") int m_no);

    List<Long> selectWishHeartByGuest(@Param("guestId") String guestId);
    
    void updateGuestWishToMember(@Param("guestId") String guestId, @Param("m_no") int m_no);
    
    // m_no로 m_id가져오기
    Integer selectMemberNoById(@Param("m_id") String m_id);
}
