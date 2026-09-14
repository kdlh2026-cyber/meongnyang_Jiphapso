package com.springboot.meongnyang_Jiphapso.service;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.meongnyang_Jiphapso.dao.ICouponDAO;
import com.springboot.meongnyang_Jiphapso.dto.CouponDTO;

@Service
public class CouponService {

	@Autowired
	private ICouponDAO couponDAO;

	// 할인율은 10/20/30/40/50 5단계만 허용
	private static final List<Integer> ALLOWED_VAL = Arrays.asList(10, 20, 30, 40, 50);

	/** 할인율(coVal) 기준으로 쿠폰 디자인 이미지 파일명 결정 (coupon_10.png ~ coupon_50.png) */
	public static String imageNameFor(Integer coVal) {
		if (coVal == null) {
			return null;
		}
		return "coupon_" + coVal + ".png";
	}

	/** 할인율별 기본 유효기간(일) - 관리자가 coDays 를 직접 안 넣었을 때만 자동 적용, 생일쿠폰(coReason에 "생일" 포함)은 무제한 */
	private Integer defaultDays(Integer coVal, String coReason) {
		if (coReason != null && coReason.contains("생일")) {
			return null; // 생일쿠폰은 기간제한 없음
		}
		if (coVal == null) {
			return null;
		}
		if (coVal == 50) {
			return 30;
		} else if (coVal == 40 || coVal == 30) {
			return 60;
		} else if (coVal == 20 || coVal == 10) {
			return 90;
		}
		return null;
	}

	// 관리자 - 전체 쿠폰 목록
	public List<CouponDTO> getCouponListAll() {
		List<CouponDTO> list = couponDAO.selectCouponListAll();
		for (CouponDTO dto : list) {
			dto.setImageName(imageNameFor(dto.getCoVal()));
		}
		return list;
	}

	// 쿠폰 단건 조회
	public CouponDTO getCouponOne(Long coNo) {
		CouponDTO dto = couponDAO.selectCouponOne(coNo);
		if (dto != null) {
			dto.setImageName(imageNameFor(dto.getCoVal()));
		}
		return dto;
	}

	// 회원 - 다운로드 가능한 쿠폰 목록
	public List<CouponDTO> getDownloadableCouponList(Long mNo) {
		if (mNo == null) {
			throw new IllegalStateException("로그인이 필요합니다");
		}
		List<CouponDTO> list = couponDAO.selectDownloadableCouponList(mNo);
		for (CouponDTO dto : list) {
			dto.setImageName(imageNameFor(dto.getCoVal()));
		}
		return list;
	}

	// 관리자 - 쿠폰 등록
	public int insertCoupon(CouponDTO dto) {
		if (dto.getCoVal() == null || !ALLOWED_VAL.contains(dto.getCoVal())) {
			throw new IllegalArgumentException("할인율은 10/20/30/40/50 중 하나여야 합니다");
		}
		if (dto.getCoType() == null || dto.getCoType().isBlank()) {
			dto.setCoType("PERCENT"); // 정액쿠폰은 사용하지 않으므로 기본 PERCENT 고정
		}
		if (dto.getCoScope() == null || dto.getCoScope().isBlank()) {
			dto.setCoScope("ALL");
		}
		if ("PRODUCT".equals(dto.getCoScope()) && dto.getPNo() == null) {
			throw new IllegalArgumentException("특정상품 할인쿠폰은 대상 상품을 지정해야 합니다");
		}
		if (dto.getCoMinAmt() == null) {
			dto.setCoMinAmt(0);
		}
		if (dto.getCoDays() == null) {
			dto.setCoDays(defaultDays(dto.getCoVal(), dto.getCoReason())); // 관리자가 안 넣으면 정책값 자동 적용
		}
		if (dto.getCoStart() == null || dto.getCoEnd() == null) {
			throw new IllegalArgumentException("다운로드 가능 기간(시작일/종료일)을 입력해야 합니다");
		}
		return couponDAO.insertCoupon(dto);
	}

	// 관리자 - 쿠폰 수정
	public int updateCoupon(CouponDTO dto) {
		if (dto.getCoVal() != null && !ALLOWED_VAL.contains(dto.getCoVal())) {
			throw new IllegalArgumentException("할인율은 10/20/30/40/50 중 하나여야 합니다");
		}
		return couponDAO.updateCoupon(dto);
	}

	// 관리자 - 쿠폰 삭제
	public int deleteCoupon(Long coNo) {
		return couponDAO.deleteCoupon(coNo);
	}

	// 관리자 - 쿠폰 등록폼 "대상 상품" 검색 (상품명으로 검색)
	public List<Map<String, Object>> searchProducts(String keyword) {
		if (keyword == null || keyword.isBlank()) {
			return List.of();
		}
		return couponDAO.searchProducts(keyword.trim());
	}
}