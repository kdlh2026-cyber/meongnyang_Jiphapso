package com.springboot.meongnyang_Jiphapso.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.springboot.meongnyang_Jiphapso.dto.MemberCouponDTO;

@Mapper
public interface IMemberCouponDAO {

	// 쿠폰 다운로드 (보유쿠폰 등록)
	int insertMemberCoupon(MemberCouponDTO dto);

	// 이미 다운로드했는지 중복 체크용 카운트
	int countDownloaded(@Param("mNo") Long mNo, @Param("coNo") Long coNo);

	// 회원보유쿠폰 단건 조회 (쿠폰정보 조인)
	MemberCouponDTO selectMemberCouponOne(@Param("mcNo") Long mcNo);

	// 회원 - 보유쿠폰함 전체 목록 (사용가능 + 사용완료 + 만료 전부, 최신순)
	List<MemberCouponDTO> selectMemberCouponListByMember(@Param("mNo") Long mNo);

	// 회원 - 결제 시 실제 사용 가능한 쿠폰만 (status=UNUSED, 만료 전)
	List<MemberCouponDTO> selectUsableMemberCouponListByMember(@Param("mNo") Long mNo);

	// 관리자 - 전체 회원 보유쿠폰 목록
	List<MemberCouponDTO> selectMemberCouponListAll();

	// 쿠폰 사용 처리 (주문 결제 시 status -> USED, mcUsed, usedOrderNo 세팅)
	int updateUseStatus(@Param("mcNo") Long mcNo, @Param("usedOrderNo") Long usedOrderNo);

	// 만료 처리 배치용 - mcExpired 가 지났는데 아직 UNUSED 인 건들 EXPIRED 로 일괄 변경
	int updateExpiredStatusBatch();

	// 관리자 - 보유쿠폰 강제 삭제
	int deleteMemberCoupon(@Param("mcNo") Long mcNo);
}
