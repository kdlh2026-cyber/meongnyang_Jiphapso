package com.springboot.meongnyang_Jiphapso.service;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.meongnyang_Jiphapso.dao.IOrderCancelDAO;
import com.springboot.meongnyang_Jiphapso.dao.IOrderDetailDAO;
import com.springboot.meongnyang_Jiphapso.dto.OrderCancelDTO;
import com.springboot.meongnyang_Jiphapso.dto.OrderDetailDTO;

@Service
public class OrderCancelService {

	@Autowired
	private IOrderCancelDAO orderCancelDAO;

	@Autowired
	private IOrderDetailDAO orderDetailDAO; // 환불예정금액(oc_ramount) 계산용 - 주문상세 단가 조회

	// 취소/반품/교환 신청 등록
	public int insertOrderCancel(OrderCancelDTO dto) {

		// 신청일시는 서버 시간 기준으로 고정 (클라이언트값 신뢰 안 함)
		dto.setOcRe(new Date());

		// oc_status가 not null이라 값 없으면 기본값 세팅 (한글 상태값 사용)
		if (dto.getOcStatus() == null || dto.getOcStatus().isEmpty()) {
			dto.setOcStatus("신청");
		}

		OrderDetailDTO detail = orderDetailDAO.selectOrderDetailOne(dto.getOdDetailNo());
		if (detail != null && detail.getOdPrice() != null && dto.getOcQuantity() != null) {
			dto.setOcRamount(detail.getOdPrice() * dto.getOcQuantity());
		} else if (dto.getOcRamount() == null) {
			dto.setOcRamount(0L);
		}

		if (dto.getOcTurn() == null) dto.setOcTurn(0L);
		if (dto.getOcPoint() == null) dto.setOcPoint(0L);
		if (dto.getOcCoupon() == null) dto.setOcCoupon(0L);

		return orderCancelDAO.insertOrderCancel(dto);
	}

	// 처리상태 변경 (관리자)
	public int updateOrderCancelStatus(Long ocOutNo, String ocStatus, Date ocPr) {
		return orderCancelDAO.updateOrderCancelStatus(ocOutNo, ocStatus, ocPr);
	}

	// 단건 조회
	public OrderCancelDTO selectOrderCancelOne(Long ocOutNo) {
		return orderCancelDAO.selectOrderCancelOne(ocOutNo);
	}

	// 주문상세 기준 취소이력 조회
	public List<OrderCancelDTO> selectOrderCancelListByOrderDetail(Long odDetailNo) {
		return orderCancelDAO.selectOrderCancelListByOrderDetail(odDetailNo);
	}

	// 회원 기준 취소/반품 목록
	public List<OrderCancelDTO> selectOrderCancelListByMember(Long mNo) {
		return orderCancelDAO.selectOrderCancelListByMember(mNo);
	}

	// 관리자 - 전체 취소 목록
	public List<OrderCancelDTO> selectOrderCancelListAll() {
		return orderCancelDAO.selectOrderCancelListAll();
	}

	// 삭제 (관리자)
	public int deleteOrderCancel(Long ocOutNo) {
		return orderCancelDAO.deleteOrderCancel(ocOutNo);
	}

}
