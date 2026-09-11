package com.springboot.meongnyang_Jiphapso.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.springboot.meongnyang_Jiphapso.dto.PaymentDTO;

@Mapper
public interface IPaymentDAO {

	// 결제요청 등록 
	int insertPayment(PaymentDTO dto);

	// 포트원 웹훅/콜백에서 결제완료 처리 (payTno, payAt, payStatus 갱신)
	int updatePaymentComplete(@Param("payNo") Long payNo, @Param("payTno") String payTno,
			@Param("payStatus") String payStatus);

	// 결제 취소/환불 처리 
	int updatePaymentStatus(@Param("payNo") Long payNo, @Param("payStatus") String payStatus);

	// 단건 조회 (결제 상세, 웹훅 처리 시 조회)
	PaymentDTO selectPaymentOne(@Param("payNo") Long payNo);

	// 주문번호 기준 조회 (주문상세 페이지에서 결제상태 표시용)
	PaymentDTO selectPaymentByOrder(@Param("orNo") Long orNo);

	// 회원 기준 결제 목록 (마이페이지 결제내역)
	List<PaymentDTO> selectPaymentListByMember(@Param("mNo") Long mNo);

	// 관리자 - 전체 결제 목록
	List<PaymentDTO> selectPaymentListAll();

	// 삭제 (관리자 전용)
	int deletePayment(@Param("payNo") Long payNo);
	
	// 주문번호 기준 결제내역 일괄삭제 (관리자 - 주문 전체 삭제 시 자식 레코드 정리용)
	int deletePaymentByOrder(@Param("orNo") Long orNo);
}
