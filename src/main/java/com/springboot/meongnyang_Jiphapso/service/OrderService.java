package com.springboot.meongnyang_Jiphapso.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.springboot.meongnyang_Jiphapso.dao.ICartDAO;
import com.springboot.meongnyang_Jiphapso.dao.IOrderCancelDAO;
import com.springboot.meongnyang_Jiphapso.dao.IOrderDAO;
import com.springboot.meongnyang_Jiphapso.dao.IOrderDetailDAO;
import com.springboot.meongnyang_Jiphapso.dao.IPaymentDAO;
import com.springboot.meongnyang_Jiphapso.dao.IPointDAO;
import com.springboot.meongnyang_Jiphapso.dto.CartDTO;
import com.springboot.meongnyang_Jiphapso.dto.OrderDTO;
import com.springboot.meongnyang_Jiphapso.dto.OrderDetailDTO;

@Service
public class OrderService {

	private final IOrderDAO orderDAO;
    private final IOrderDetailDAO orderDetailDAO;
    private final ICartDAO cartDAO;
    private final IOrderCancelDAO orderCancelDAO; // 주문 삭제 시 취소이력 정리용
    private final IPaymentDAO paymentDAO;         // 주문 삭제 시 결제내역 정리용
    private final IPointDAO pointDAO;             // 주문 삭제 시 포인트 이력 연결 해제용 (이력 자체는 보존)

	@Autowired
	public OrderService (IOrderDAO orderDAO, IOrderDetailDAO orderDetailDAO, ICartDAO cartDAO,
			IOrderCancelDAO orderCancelDAO, IPaymentDAO paymentDAO, IPointDAO pointDAO) {
        this.orderDAO = orderDAO;
        this.orderDetailDAO = orderDetailDAO;
        this.cartDAO = cartDAO;
        this.orderCancelDAO = orderCancelDAO;
        this.paymentDAO = paymentDAO;
        this.pointDAO = pointDAO;
    }

	@Transactional
	public Long createOrder(Long mNo, List<Long> caNoList, OrderDTO orderInfo) {
        if (caNoList == null || caNoList.isEmpty()) {
            throw new IllegalArgumentException("주문할 상품을 선택해주세요.");
        }
        List<OrderDetailDTO> detailList = new ArrayList<>();
        List<CartDTO> cartItems = new ArrayList<>();
        for (Long caNo : caNoList) {
            CartDTO cart = cartDAO.selectCartOne(caNo);
            if (cart == null) continue;
            cartItems.add(cart);

            OrderDetailDTO detail = new OrderDetailDTO();
            detail.setPNo(cart.getPNo());
            detail.setONo(cart.getONo());
            detail.setOdOptionName(cart.getOName());
            detail.setOdProductName(cart.getPName());
            detail.setOdPrice(cart.getOPrice());
            detail.setOdQuantity(cart.getCaQuantity());
            long amount = (cart.getOPrice() == null ? 0L : cart.getOPrice()) * cart.getCaQuantity();
            detail.setOdAmount(amount);
            detailList.add(detail);
        }
        if (detailList.isEmpty()) {
            throw new IllegalStateException("유효한 장바구니 항목이 없습니다.");
        }

        orderInfo.setMNo(mNo);
        orderDAO.insertOrder(orderInfo);
        Long orNo = orderInfo.getOrNo();

        for (OrderDetailDTO detail : detailList) {
            detail.setOrNo(orNo);
            orderDetailDAO.insertOrderDetail(detail);
        }

        return orNo;
    }

    /** 주문 상세 조회 (주문상세 목록 포함) */
    public OrderDTO getOrderOne(Long orNo) {
        OrderDTO order = orderDAO.selectOrderOne(orNo);
        if (order != null) {
            order.setOrderDetailList(orderDetailDAO.selectOrderDetailListByOrder(orNo));
        }
        return order;
    }

    public List<OrderDTO> getOrderListByMember(Long mNo) {
        return orderDAO.selectOrderListByMember(mNo);
    }

    public List<OrderDTO> getOrderListByMemberAndStatus(Long mNo, String orStatus) {
        return orderDAO.selectOrderListByMemberAndStatus(mNo, orStatus);
    }

    /** 배송지/메모 등 주문정보 수정 (결제 전에만 허용) */
    @Transactional
    public void updateOrderInfo(OrderDTO orderInfo) {
        orderDAO.updateOrder(orderInfo);
    }

    @Transactional
    public void updateOrderStatus(Long orNo, String orStatus) {
        orderDAO.updateOrderStatus(orNo, orStatus);
    }

    /** 관리자 - 주문 삭제 */
    @Transactional
    public void deleteOrder(Long orNo) {
        orderCancelDAO.deleteOrderCancelListByOrder(orNo);
        paymentDAO.deletePaymentByOrder(orNo);
        pointDAO.detachPointFromOrder(orNo);
        orderDetailDAO.deleteOrderDetailListByOrder(orNo);
        orderDAO.deleteOrder(orNo);
    }

    /** 관리자 - 전체 주문 목록 */
    public List<OrderDTO> getAllForAdmin() {
        return orderDAO.selectOrderListAll();
    }


}