package com.springboot.meongnyang_Jiphapso.dao;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.springboot.meongnyang_Jiphapso.dto.OrderDetailDTO;

@Mapper
public interface IOrderDetailDAO {

    // 주문상세 1건 등록
    int insertOrderDetail(OrderDetailDTO dto);

    // 주문상세 여러건 일괄 등록 (장바구니 -> 주문 전환 시)
    int insertOrderDetailList(@Param("list") List<OrderDetailDTO> list);

    // 단건 조회
    OrderDetailDTO selectOrderDetailOne(@Param("odDetailNo") Long odDetailNo);

    // 주문번호로 상세 목록 조회 (동일 상품/옵션은 서비스단에서 수량 합산 처리)
    List<OrderDetailDTO> selectOrderDetailListByOrder(@Param("orNo") Long orNo);

    // 수량/옵션 수정 (배송 시작 전에만 허용)
    int updateOrderDetail(OrderDetailDTO dto);

    // 삭제
    int deleteOrderDetail(@Param("odDetailNo") Long odDetailNo);

    // 관리자 - 전체 주문상세 목록
    List<OrderDetailDTO> selectOrderDetailListAll();
    
    // 주문번호 기준 주문상세 일괄삭제 (관리자 - 주문 전체 삭제 시 자식 레코드 정리용)
    int deleteOrderDetailListByOrder(@Param("orNo") Long orNo);
    
	// 회원이 특정 상품을 구매(결제완료 이후)한 주문상세 중 가장 최근 것 1건 조회 - 리뷰 작성 시 구매 검증 + 구매금액 조회용
	OrderDetailDTO selectPurchasedDetailByMemberAndProduct(@Param("mNo") Long mNo, @Param("pNo") Long pNo);
}
