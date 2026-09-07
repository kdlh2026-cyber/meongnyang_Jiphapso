package com.springboot.meongnyang_Jiphapso.controller;

import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import com.springboot.meongnyang_Jiphapso.common.ApiResponse;
import com.springboot.meongnyang_Jiphapso.service.OrderDetailService;

@Controller
public class OrderDetailController {

    private final OrderDetailService orderDetailService;

    @Autowired
    public OrderDetailController(OrderDetailService orderDetailService) {
        this.orderDetailService = orderDetailService;
    }

    /** 주문상세 단건 조회 (주문상세 페이지에서 개별 라인아이템 확인용) */
    @RequestMapping(value = "/order-detail/{odDetailNo}", method = RequestMethod.GET)
    @ResponseBody
    public ApiResponse<?> getOne(@PathVariable("odDetailNo") Long odDetailNo) {
        return ApiResponse.ok(orderDetailService.getOne(odDetailNo));
    }

    /** 결제 전 수량 수정 */
    @RequestMapping(value = "/order-detail/{odDetailNo}/quantity", method = RequestMethod.PUT)
    @ResponseBody
    public ApiResponse<Void> updateQuantity(@PathVariable("odDetailNo") Long odDetailNo, @RequestBody Map<String, Integer> body) {
        orderDetailService.updateQuantity(odDetailNo, body.get("quantity"));
        return ApiResponse.ok(null);
    }

    // ------------------------------------------------------------
    // 관리자 화면
    // ------------------------------------------------------------

    @RequestMapping(value = "/admin/order-detail", method = RequestMethod.GET)
    public String adminList(Model model) {
        model.addAttribute("orderDetailList", orderDetailService.getAllForAdmin());
        return "admin/orderDetail/adminList";
    }

    @RequestMapping(value = "/admin/order-detail/{odDetailNo}", method = RequestMethod.DELETE)
    @ResponseBody
    public ApiResponse<Void> adminDelete(@PathVariable("odDetailNo") Long odDetailNo) {
        orderDetailService.deleteOrderDetail(odDetailNo);
        return ApiResponse.ok(null);
    }
}