package com.springboot.meongnyang_Jiphapso.service;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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

	@Autowired
	private OrderService orderService; // 주문 전체 상태(or_status)를 CANCELED로 갱신하기 위함

	// 취소/반품/교환 신청 등록
	// (insert + 주문 전체취소 여부 재확인을 한 트랜잭션으로 묶음)
	@Transactional
	public int insertOrderCancel(OrderCancelDTO dto) {

		// 신청일시는 서버 시간 기준으로 고정 (클라이언트값 신뢰 안 함)
		dto.setOcRe(new Date());

		// oc_status가 not null이라 값 없으면 기본값 세팅.
		// 관리자페이지(admin/OrderCancel/list.jsp)가 REQUESTED/APPROVED/REFUNDED/REJECTED
		// 영문 코드값 기준으로 탭 필터링/select 옵션을 만들고 있어서, 여기 기본값도 반드시
		// 그 코드값과 맞춰야 함 (예전에 "신청"이라는 한글값을 기본으로 넣고 있었는데,
		// 그러면 관리자페이지 상태 select랑 탭 필터에서 안 걸려서 화면에 "REQUESTED" 상태로 안 잡히는 문제가 있었음)
		if (dto.getOcStatus() == null || dto.getOcStatus().isEmpty()) {
			dto.setOcStatus("REQUESTED");
		}

		// 환불예정금액(oc_ramount) = 주문상세 단가(od_price) x 신청 수량(oc_quantity)
		// 예전엔 무조건 0으로 넣고 있어서 관리자 목록에서 "환불예정금액"이 항상 0원으로 뜨던 버그였음.
		// 주문상세를 다시 조회해서 단가 가져온 다음 신청 수량만큼 곱해서 채워줌.
		OrderDetailDTO detail = orderDetailDAO.selectOrderDetailOne(dto.getOdDetailNo());
		if (detail != null && detail.getOdPrice() != null && dto.getOcQuantity() != null) {
			dto.setOcRamount(detail.getOdPrice() * dto.getOcQuantity());
		} else if (dto.getOcRamount() == null) {
			dto.setOcRamount(0L);
		}

		// oc_turn(반품 배송비)/oc_point/oc_coupon 은
		// 관리자가 실제로 승인/처리할 때 확정되는 값이라 신청 시점엔 아직 없음 -> 기본값 0
		if (dto.getOcTurn() == null) dto.setOcTurn(0L);
		if (dto.getOcPoint() == null) dto.setOcPoint(0L);
		if (dto.getOcCoupon() == null) dto.setOcCoupon(0L);

		int result = orderCancelDAO.insertOrderCancel(dto);

		// 이 신청으로 인해 주문에 속한 상품 라인이 전부 취소상태가 됐으면
		// 주문(dc_order) 자체 상태도 CANCELED로 바꿔줌 -> 주문내역 목록의 "취소" 탭에 표시되게 하기 위함.
		// (라인이 하나뿐인 주문이면 이번 신청 한 번으로 바로 전체취소로 잡힘)
		if (result > 0 && detail != null && detail.getOrNo() != null) {
			updateOrderStatusIfFullyCancelled(detail.getOrNo());
		}

		return result;
	}

	// 처리상태 변경 (관리자)
	@Transactional
	public int updateOrderCancelStatus(Long ocOutNo, String ocStatus, Date ocPr) {

		int result = orderCancelDAO.updateOrderCancelStatus(ocOutNo, ocStatus, ocPr);

		// 관리자가 개별 취소건 상태를 바꾼 뒤에도(승인/거절 등) 마찬가지로 주문 전체취소 여부를 재확인
		if (result > 0) {
			OrderCancelDTO cancel = orderCancelDAO.selectOrderCancelOne(ocOutNo);
			if (cancel != null && cancel.getOrNo() != null) {
				updateOrderStatusIfFullyCancelled(cancel.getOrNo());
			}
		}

		return result;
	}

	// 주문에 속한 모든 상세 라인이 취소상태(REJECTED 제외, REQUESTED/APPROVED/REFUNDED 등)면
	// 주문 전체 상태를 CANCELED로 변경.
	// 상세 라인 중 하나라도 취소 이력이 없거나(ocStatus == null) 거절(REJECTED)된 상태면 전체취소로 보지 않음.
	private void updateOrderStatusIfFullyCancelled(Long orNo) {

		List<OrderDetailDTO> details = orderDetailDAO.selectOrderDetailListByOrder(orNo);
		if (details == null || details.isEmpty()) {
			return;
		}

		boolean allCancelled = true;
		for (OrderDetailDTO d : details) {
			String st = d.getOcStatus();
			if (st == null || "REJECTED".equals(st)) {
				allCancelled = false;
				break;
			}
		}

		if (allCancelled) {
			orderService.updateOrderStatus(orNo, "CANCELED");
		}
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
