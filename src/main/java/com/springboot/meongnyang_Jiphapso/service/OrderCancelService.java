package com.springboot.meongnyang_Jiphapso.service;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.springboot.meongnyang_Jiphapso.dao.IOrderCancelDAO;
import com.springboot.meongnyang_Jiphapso.dao.IOrderDetailDAO;
import com.springboot.meongnyang_Jiphapso.dao.IPaymentDAO;
import com.springboot.meongnyang_Jiphapso.dao.IProductDao;
import com.springboot.meongnyang_Jiphapso.dto.OrderCancelDTO;
import com.springboot.meongnyang_Jiphapso.dto.OrderDetailDTO;
import com.springboot.meongnyang_Jiphapso.dto.PaymentDTO;

@Service
public class OrderCancelService {

	@Autowired
	private IOrderCancelDAO orderCancelDAO;

	@Autowired
	private IOrderDetailDAO orderDetailDAO; // 환불예정금액(oc_ramount) 계산용 - 주문상세 단가 조회

	@Autowired
	private OrderService orderService; // 주문 전체 상태(or_status)를 CANCELED로 갱신하기 위함

	@Autowired
	private IPaymentDAO paymentDAO; // 주문 전체 결제내역(포인트/쿠폰 사용액) 조회용 - 몰수액 계산에 사용

	@Autowired
	private IProductDao productDao; // 취소 승인 시 옵션 재고 복구용

	// 취소/반품/교환 신청 등록
	@Transactional
	public int insertOrderCancel(OrderCancelDTO dto) {
	dto.setOcRe(new Date());
		if (dto.getOcStatus() == null || dto.getOcStatus().isEmpty()) {
			dto.setOcStatus("REQUESTED");
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

		int result = orderCancelDAO.insertOrderCancel(dto);
		if (result > 0 && detail != null && detail.getOrNo() != null) {
			updateOrderStatusIfFullyCancelled(detail.getOrNo());
		}

		return result;
	}

	// 처리상태 변경 (관리자)
	@Transactional
	public int updateOrderCancelStatus(Long ocOutNo, String ocStatus, Date ocPr) {

		// 재고 복구 여부 판단을 위해 상태 변경 "전" 상태를 먼저 조회해둠
		OrderCancelDTO before = orderCancelDAO.selectOrderCancelOne(ocOutNo);

		if ("APPROVED".equals(ocStatus) || "REFUNDED".equals(ocStatus)) {
			if (before != null) {
				calculateForfeitedPointAndCoupon(before);
			}
		}

		// 재고 복구: REQUESTED -> APPROVED 로 "처음" 승인되는 순간에만 1회 실행
		// (이미 APPROVED/REFUNDED 상태인 건에 대해 상태변경 API가 다시 호출돼도
		//  재고가 중복으로 늘어나지 않도록, 이전 상태가 REQUESTED일 때만 복구한다)
		boolean alreadyProcessed = before != null
				&& ("APPROVED".equals(before.getOcStatus()) || "REFUNDED".equals(before.getOcStatus()));

		if (!alreadyProcessed && "APPROVED".equals(ocStatus) && before != null) {
			restoreStockForCancel(before);
		}

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

	// 취소 승인된 라인아이템의 옵션(o_no) 재고를 취소수량(oc_quantity)만큼 되돌림
	private void restoreStockForCancel(OrderCancelDTO cancel) {

		OrderDetailDTO detail = orderDetailDAO.selectOrderDetailOne(cancel.getOdDetailNo());
		if (detail == null || detail.getONo() == null || cancel.getOcQuantity() == null) {
			return;
		}

		productDao.increaseOptionStock(detail.getONo(), cancel.getOcQuantity().intValue());
	}

	private void calculateForfeitedPointAndCoupon(OrderCancelDTO cancel) {

		// 이미 몰수액이 확정돼서 0이 아닌 값으로 들어가 있으면 재계산하지 않음 (같은 건에 대해 중복 승인 호출되는 경우 방지)
		if ((cancel.getOcPoint() != null && cancel.getOcPoint().longValue() != 0)
				|| (cancel.getOcCoupon() != null && cancel.getOcCoupon().longValue() != 0)) {
			return;
		}

		OrderDetailDTO detail = orderDetailDAO.selectOrderDetailOne(cancel.getOdDetailNo());
		if (detail == null || detail.getOrNo() == null) {
			return;
		}

		PaymentDTO payment = paymentDAO.selectPaymentByOrder(detail.getOrNo());
		if (payment == null || payment.getPayAmount() == null || payment.getPayAmount() == 0) {
			return; // 결제내역이 없거나 상품금액이 0이면 비율 계산 불가 -> 0으로 둔 채 종료
		}

		long totalProductAmount = payment.getPayAmount();  // 주문 전체 상품금액 (분모)
		long totalPointUsed = (payment.getPayUsed() != null) ? payment.getPayUsed() : 0L;
		long totalCouponUsed = (payment.getPayDiscount() != null) ? payment.getPayDiscount() : 0L;
		long cancelAmount = (cancel.getOcRamount() != null) ? cancel.getOcRamount() : 0L;

		// 이번 취소 라인 금액 비율만큼 포인트/쿠폰도 비례 몰수 (반올림)
		long forfeitedPoint = Math.round(totalPointUsed * (double) cancelAmount / totalProductAmount);
		long forfeitedCoupon = Math.round(totalCouponUsed * (double) cancelAmount / totalProductAmount);

		orderCancelDAO.updateOrderCancelForfeit(cancel.getOcOutNo(), forfeitedPoint, forfeitedCoupon);
	}

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