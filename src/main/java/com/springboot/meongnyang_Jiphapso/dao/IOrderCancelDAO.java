package com.springboot.meongnyang_Jiphapso.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.springboot.meongnyang_Jiphapso.dto.OrderCancelDTO;

@Mapper
public interface IOrderCancelDAO {
	
	// 취소 / 반품 /교환 신청등록
	int insertOrderCancel(OrderCancelDTO dto);

    // 처리상태 변경 (관리자 승인/거절/환불완료)
    int updateOrderCancelStatus(@Param("ocOutNo") Long ocOutNo,
                                 @Param("ocStatus") String ocStatus,
                                 @Param("ocPr") java.util.Date ocPr);

    // 단건 조회
    OrderCancelDTO selectOrderCancelOne(@Param("ocOutNo") Long ocOutNo);

    // 주문상세 기준 취소이력 조회
    List<OrderCancelDTO> selectOrderCancelListByOrderDetail(@Param("odDetailNo") Long odDetailNo);

    // 회원 기준 취소/반품 목록
    List<OrderCancelDTO> selectOrderCancelListByMember(@Param("mNo") Long mNo);
    
	// 취소 승인/환불완료 시점에 확정된 몰수 포인트/쿠폰 금액 반영 (반환 안 됨 - 기록용)
	int updateOrderCancelForfeit(@Param("ocOutNo") Long ocOutNo,
			@Param("ocPoint") Long ocPoint, @Param("ocCoupon") Long ocCoupon);

    // 관리자 - 전체 취소 목록
    List<OrderCancelDTO> selectOrderCancelListAll();

    // 삭제 (관리자)
    int deleteOrderCancel(@Param("ocOutNo") Long ocOutNo);
    
    // 주문번호 기준 취소이력 일괄삭제 (관리자 - 주문 전체 삭제 시 자식 레코드 정리용)
    int deleteOrderCancelListByOrder(@Param("orNo") Long orNo);
	
}
