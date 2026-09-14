package com.springboot.meongnyang_Jiphapso.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.springboot.meongnyang_Jiphapso.dto.PointDTO;

@Mapper
public interface IPointDAO {

    // 포인트 이력 1건 등록 (적립/사용/소멸/복원 공통)
    int insertPoint(PointDTO dto);

    // 회원 기준 포인트 이력 전체 조회 (마이페이지 - 최신순)
    List<PointDTO> selectPointListByMember(@Param("mNo") Long mNo);

    // 회원의 현재 보유 포인트 (가장 최근 이력의 포인트값)
    Long selectCurrentBalance(@Param("mNo") Long mNo);

    // 회원의 소멸예정 포인트 합계 (7일 이내, FIFO 잔여 계산ㄷ)
    Long selectExpireSoonAmount(@Param("mNo") Long mNo, @Param("days") int days);

    // 회원의 이미 기한이 지났지만 아직 소멸 처리되지 않은 포인트 합계 (배치용)
    Long selectExpiredAmount(@Param("mNo") Long mNo);

    // 적립 이력이 있고 기한이 지난 회원번호 후보 목록 (배치 대상 조회)
    List<Long> selectMemberNosWithExpiredEarn();

    // 관리자 - 전체 포인트 이력 조회
    List<PointDTO> selectPointListAll();

    // 단건 조회
    PointDTO selectPointOne(@Param("poNo") Long poNo);

    // 관리자 - 이력 삭제 (오기입 등 예외적인 경우)
    int deletePoint(@Param("poNo") Long poNo);

    // 특정 사유의 적립 이력이 이미 있는지 확인 (회원가입/첫리뷰 등 1회성 적립 중복 방지)
    int countByMemberAndReason(@Param("mNo") Long mNo, @Param("poReason") String poReason);
    
    // 주문 삭제 시 포인트 이력 자체는 보존하고 주문 연결만 끊음 (회계기록 보존, FK만 NULL 처리)
    int detachPointFromOrder(@Param("orNo") Long orNo);
}

