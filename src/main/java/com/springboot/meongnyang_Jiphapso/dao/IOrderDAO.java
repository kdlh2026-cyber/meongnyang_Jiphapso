package com.springboot.meongnyang_Jiphapso.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.springboot.meongnyang_Jiphapso.dto.OrderDTO;

@Mapper
public interface IOrderDAO {
	 
	// 주문 생성
	int insertOrder(OrderDTO dto);
	
	// 주문 상태 변경
	int updateOrderStatus(@Param("orNo") Long orNo,
						  @Param("orStatus") String orStatus);
	
	// 주문 정보(배송지/ 메모) 수정
	int updateOrder (OrderDTO dto);
	
	// 주문삭제 (관리자)
	int deleteOrder(@Param("orNo") Long orNo);

    // 주문 단건 조회 (상세페이지 - 주문상세 목록 포함 조인)
    OrderDTO selectOrderOne(@Param("orNo") Long orNo);

    // 회원별 주문 목록 (최신순)
    List<OrderDTO> selectOrderListByMember(@Param("mNo") Long mNo);

    // 회원별 주문 목록 - 상태별 필터 (결제대기 / 배송중 등)
    List<OrderDTO> selectOrderListByMemberAndStatus(@Param("mNo") Long mNo, @Param("orStatus") String orStatus);

    // 관리자 - 전체 주문 목록
    List<OrderDTO> selectOrderListAll();

    // 회원 주문 건수
    int countOrderByMember(@Param("mNo") Long mNo);
	
}
