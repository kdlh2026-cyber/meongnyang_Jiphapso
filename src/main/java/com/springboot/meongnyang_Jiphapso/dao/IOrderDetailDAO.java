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
}
