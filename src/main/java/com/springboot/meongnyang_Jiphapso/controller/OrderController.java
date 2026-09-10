package com.springboot.meongnyang_Jiphapso.controller;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.springboot.meongnyang_Jiphapso.common.ApiResponse;
import com.springboot.meongnyang_Jiphapso.common.SessionConst;
import com.springboot.meongnyang_Jiphapso.dao.IMemberLookupDAO;
import com.springboot.meongnyang_Jiphapso.dto.CartDTO;
import com.springboot.meongnyang_Jiphapso.dto.MemberDTO;
import com.springboot.meongnyang_Jiphapso.dto.OrderDTO;
import com.springboot.meongnyang_Jiphapso.service.CartService;
import com.springboot.meongnyang_Jiphapso.service.OrderDetailService;
import com.springboot.meongnyang_Jiphapso.service.OrderService;

@Controller
public class OrderController {

    private final OrderService orderService;
    private final CartService cartService;
    private final OrderDetailService orderDetailService; // 주문상세 페이지에서 라인아이템(취소버튼 포함) 목록 뿌려주려고 추가
    private final IMemberLookupDAO memberLookupDAO; // 주문/결제 페이지 주문자정보/배송정보 자동입력용 (회원 파트 건드리지 않고 조회 전용으로 분리)

    @Autowired
    public OrderController(OrderService orderService, CartService cartService,
                           OrderDetailService orderDetailService, IMemberLookupDAO memberLookupDAO) {
        this.orderService = orderService;
        this.cartService = cartService;
        this.orderDetailService = orderDetailService;
        this.memberLookupDAO = memberLookupDAO;
    }

    private Long requireLogin(HttpSession session) {
        // 세션엔 MemberDTO.m_no 타입 그대로(Integer) 들어있어서 Integer로 꺼낸 다음 Long으로 변환
        Integer mNo = (Integer) session.getAttribute(SessionConst.LOGIN_MEMBER_NO);

        if (mNo == null) {
            throw new IllegalStateException("로그인이 필요합니다.");
        }
        return mNo.longValue();
    }

    // ------------------------------------------------------------
    // 회원 화면 - /member/order/**
    // ------------------------------------------------------------

    // 주문/결제 페이지
    @RequestMapping(value = "/member/order/checkout", method = RequestMethod.GET)
    public String checkout(@RequestParam(value = "caNo", required = false) String caNoParam,
                           HttpSession session,
                           Model model) {

        Long mNo = requireLogin(session);

        // caNo 없이 들어온 경우 장바구니로 돌려보냄
        if (caNoParam == null || caNoParam.isBlank()) {
            return "redirect:/cart/list";
        }

        List<Long> caNoList = Arrays.stream(caNoParam.split(","))
                .map(Long::valueOf)
                .collect(Collectors.toList());

        List<CartDTO> allCart = cartService.getCartListByMember(mNo);

        List<CartDTO> selected = allCart.stream()
                .filter(c -> caNoList.contains(c.getCaNo()))
                .collect(Collectors.toList());

        long productAmount = selected.stream()
                .mapToLong(c -> (c.getOPrice() == null ? 0L : c.getOPrice()) * c.getCaQuantity())
                .sum();

        // 주문자 정보(이름/연락처) + 배송 정보(주소) 자동입력용 - 로그인 회원 정보 조회
        MemberDTO member = memberLookupDAO.selectMemberOne(mNo);

        model.addAttribute("cartList", selected);
        model.addAttribute("productAmount", productAmount);
        model.addAttribute("member", member);

        return "member/order/checkout";
    }

    // 주문 생성
    @RequestMapping(value = "/member/order", method = RequestMethod.POST)
    @ResponseBody
    @SuppressWarnings("unchecked")
    public ApiResponse<Long> createOrder(@RequestBody Map<String, Object> body,
                                         HttpSession session) {

        Long mNo = requireLogin(session);

        List<Long> caNoList = ((List<Object>) body.get("caNoList")).stream()
                .map(v -> Long.valueOf(String.valueOf(v)))
                .collect(Collectors.toList());

        OrderDTO orderInfo = new OrderDTO();
        orderInfo.setOrName(String.valueOf(body.get("orName")));
        orderInfo.setOrPhone(String.valueOf(body.get("orPhone")));
        orderInfo.setOrAddress(String.valueOf(body.get("orAddress")));
        orderInfo.setOrAddrdetail(String.valueOf(body.get("orAddrdetail")));
        orderInfo.setOrMemo(body.get("orMemo") != null ? String.valueOf(body.get("orMemo")) : null);
        orderInfo.setOrYn(body.get("orYn") != null ? String.valueOf(body.get("orYn")) : "N");
        orderInfo.setOrQty(body.get("orQty") != null ? Integer.parseInt(String.valueOf(body.get("orQty"))) : 0);
        orderInfo.setOrMethod(String.valueOf(body.get("orMethod")));

        Long orNo = orderService.createOrder(mNo, caNoList, orderInfo);

        return ApiResponse.ok("주문이 생성되었어요", orNo);
    }

    // 주문 목록
    @RequestMapping(value = "/member/order/list", method = RequestMethod.GET)
    public String orderList(@RequestParam(value = "status", required = false) String status,
                            HttpSession session,
                            Model model) {

        Long mNo = requireLogin(session);

        List<OrderDTO> list = (status == null || status.isEmpty())
                ? orderService.getOrderListByMember(mNo)
                : orderService.getOrderListByMemberAndStatus(mNo, status);

        model.addAttribute("orderList", list);

        return "member/order/list";
    }

    // 주문 상세 - TODO: orderService.getOrderOne(orNo)의 mNo가 로그인 회원과 같은지 검증 필요
    @RequestMapping(value = "/member/order/{orNo}", method = RequestMethod.GET)
    public String orderDetail(@PathVariable("orNo") Long orNo, HttpSession session, Model model) {

        requireLogin(session);

        model.addAttribute("order", orderService.getOrderOne(orNo));


        model.addAttribute("orderDetailList", orderDetailService.getListByOrder(orNo));

        return "member/order/detail";
    }

    // 배송지/메모 수정 - 마찬가지로 본인 주문인지 확인 필요
    @RequestMapping(value = "/member/order/{orNo}", method = RequestMethod.PUT)
    @ResponseBody
    public ApiResponse<Void> updateOrder(@PathVariable("orNo") Long orNo,
                                         @RequestBody OrderDTO orderInfo,
                                         HttpSession session) {

        requireLogin(session);

        orderInfo.setOrNo(orNo);
        orderService.updateOrderInfo(orderInfo);

        return ApiResponse.ok(null);
    }

    // ------------------------------------------------------------
    // 관리자 화면 - /admin/order/**
    // 관리자 권한 체크는 WebSecurityConfig에서 /admin/** -> hasAnyRole("ADMIN")으로 이미 처리됨
    // ------------------------------------------------------------

    @RequestMapping(value = "/admin/order", method = RequestMethod.GET)
    public String adminOrderList(Model model) {

        model.addAttribute("orderList", orderService.getAllForAdmin());

        return "admin/order/adminList";
    }

    @RequestMapping(value = "/admin/order/{orNo}", method = RequestMethod.GET)
    public String adminOrderDetail(@PathVariable("orNo") Long orNo, Model model) {

        model.addAttribute("order", orderService.getOrderOne(orNo));
        // 관리자 주문상세 화면에도 라인아이템 목록이 필요하면 동일하게 내려줌
        model.addAttribute("orderDetailList", orderDetailService.getListByOrder(orNo));

        return "admin/order/adminDetail";
    }

    @RequestMapping(value = "/admin/order/{orNo}/status", method = RequestMethod.PUT)
    @ResponseBody
    public ApiResponse<Void> adminUpdateStatus(@PathVariable("orNo") Long orNo,
                                               @RequestBody Map<String, String> body) {

        orderService.updateOrderStatus(orNo, body.get("orStatus"));

        return ApiResponse.ok(null);
    }

    @RequestMapping(value = "/admin/order/{orNo}", method = RequestMethod.DELETE)
    @ResponseBody
    public ApiResponse<Void> adminDeleteOrder(@PathVariable("orNo") Long orNo) {

        orderService.deleteOrder(orNo);

        return ApiResponse.ok(null);
    }

    // ------------------------------------------------------------
    // 로그인 안 된 상태로 접근하면 500 대신 로그인 페이지로 리다이렉트
    // ------------------------------------------------------------

    @ExceptionHandler(IllegalStateException.class)
    public String handleNotLoggedIn(IllegalStateException e, RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        // WebSecurityConfig 기준 실제 로그인 페이지 경로
        return "redirect:/loginForm";
    }
}
