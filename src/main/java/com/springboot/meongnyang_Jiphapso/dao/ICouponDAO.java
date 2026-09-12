package com.springboot.meongnyang_Jiphapso.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.springboot.meongnyang_Jiphapso.dto.CouponDTO;

@Mapper
public interface ICouponDAO {

	// 관리자 - 쿠폰 등록
	int insertCoupon(CouponDTO dto);

	// 관리자 - 쿠폰 수정
	int updateCoupon(CouponDTO dto);

	// 관리자 - 쿠폰 삭제
	int deleteCoupon(@Param("coNo") Long coNo);

	// 쿠폰 단건 조회
	CouponDTO selectCouponOne(@Param("coNo") Long coNo);

	// 관리자 - 전체 쿠폰 목록 (최신순)
	List<CouponDTO> selectCouponListAll();

	// 회원 - 현재 다운로드 가능한 쿠폰 목록
	// (coStart <= sysdate <= coEnd) AND dc_member_coupon 에 해당 회원이 아직 다운로드하지 않은 쿠폰만
	List<CouponDTO> selectDownloadableCouponList(@Param("mNo") Long mNo);

	// 관리자 - 쿠폰 등록폼에서 "대상 상품" 검색 (상품명으로 검색, 최대 20건)
	List<Map<String, Object>> searchProducts(@Param("keyword") String keyword);
}
