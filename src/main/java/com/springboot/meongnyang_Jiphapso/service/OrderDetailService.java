package com.springboot.meongnyang_Jiphapso.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.springboot.meongnyang_Jiphapso.dao.IOrderDetailDAO;
import com.springboot.meongnyang_Jiphapso.dto.OrderDetailDTO;

@Service
public class OrderDetailService {

    private final IOrderDetailDAO orderDetailDAO;

    @Autowired
    public OrderDetailService(IOrderDetailDAO orderDetailDAO) {
        this.orderDetailDAO = orderDetailDAO;
    }

    public OrderDetailDTO getOne(Long odDetailNo) {
        return orderDetailDAO.selectOrderDetailOne(odDetailNo);
    }

    public List<OrderDetailDTO> getListByOrder(Long orNo) {
        return orderDetailDAO.selectOrderDetailListByOrder(orNo);
    }

    /** 배송 시작 전 수량 수정 (금액 재계산 포함) */
    @Transactional
    public void updateQuantity(Long odDetailNo, int quantity) {
        if (quantity < 1) {
            throw new IllegalArgumentException("수량은 1개 이상이어야 합니다.");
        }
        OrderDetailDTO dto = orderDetailDAO.selectOrderDetailOne(odDetailNo);
        if (dto == null) {
            throw new IllegalArgumentException("존재하지 않는 주문상세입니다.");
        }
        if (!"PAYMENT_PENDING".equals(dto.getOrStatus())) {
            throw new IllegalStateException("결제 완료된 주문은 수량을 수정할 수 없습니다.");
        }
        dto.setOdQuantity(quantity);
        dto.setOdAmount(dto.getOdPrice() * quantity);
        orderDetailDAO.updateOrderDetail(dto);
    }

    @Transactional
    public void deleteOrderDetail(Long odDetailNo) {
        orderDetailDAO.deleteOrderDetail(odDetailNo);
    }

    /** 관리자 - 전체 목록 */
    public List<OrderDetailDTO> getAllForAdmin() {
        return orderDetailDAO.selectOrderDetailListAll();
    }
}
