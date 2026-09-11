package com.springboot.meongnyang_Jiphapso.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.springboot.meongnyang_Jiphapso.common.SessionConst;
import com.springboot.meongnyang_Jiphapso.dto.PaymentDTO;
import com.springboot.meongnyang_Jiphapso.service.PaymentService;
import com.springboot.meongnyang_Jiphapso.service.PointService;

@Controller
@RequestMapping("/payment")
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private PointService pointService; // 결제요청 등록 시 포인트 잔액 검증용

    // =====================================================
    // 세션 로그인 회원번호 가져오기 (OrderController와 동일 방식)
    // =====================================================
    private Long loginMemberNo(HttpSession session) {

        Integer loginNo = (Integer) session.getAttribute(SessionConst.LOGIN_MEMBER_NO);

        if (loginNo == null) {
            return null;
        }

        return loginNo.longValue();
    }

    // =====================================================
    // 페이지 이동
    // =====================================================

    // 결제 페이지
    @RequestMapping(value = "/page", method = RequestMethod.GET)
    public String paymentPage(@RequestParam("orNo") Long orNo,
                              HttpSession session,
                              Model model) {

        Long mNo = loginMemberNo(session);

        if (mNo == null) {
            return "redirect:/loginForm";
        }

        model.addAttribute("orNo", orNo);

        return "member/payment/pay";
    }

    // 회원 결제목록 페이지
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String paymentListPage(HttpSession session) {

        Long mNo = loginMemberNo(session);

        if (mNo == null) {
            return "redirect:/loginForm";
        }

        return "member/payment/list";
    }

    // 결제취소 페이지
    @RequestMapping(value = "/cancelPage", method = RequestMethod.GET)
    public String paymentCancelPage(@RequestParam("payNo") Long payNo,
                                    HttpSession session,
                                    Model model) {

        Long mNo = loginMemberNo(session);

        if (mNo == null) {
            return "redirect:/loginForm";
        }

        model.addAttribute("payNo", payNo);

        return "member/payment/cancelForm";
    }

    // 관리자 결제목록 페이지
    @RequestMapping(value = "/admin/list", method = RequestMethod.GET)
    public String paymentAdminListPage() {

        return "admin/payment/list";
    }

    // =====================================================
    // AJAX(JSON)
    // =====================================================

    // 결제요청 등록
    @ResponseBody
    @RequestMapping(value = "/request", method = RequestMethod.POST)
    public Map<String, Object> requestPayment(PaymentDTO dto,
                                              HttpSession session) {

        Map<String, Object> map = new HashMap<>();

        Long mNo = loginMemberNo(session);

        if (mNo == null) {
            map.put("success", false);
            map.put("message", "로그인이 필요합니다.");
            return map;
        }

        try {

            dto.setMNo(mNo);

            if (dto.getPayUsed() != null && dto.getPayUsed() > 0) {
                Long balance = pointService.getCurrentBalance(mNo);
                if (balance == null || dto.getPayUsed() > balance) {
                    map.put("success", false);
                    map.put("message", "보유 포인트가 부족합니다.");
                    return map;
                }
            }

            paymentService.bindChannelKey(dto);

            PaymentDTO result = paymentService.requestPayment(dto);

            map.put("success", true);
            map.put("payNo", result.getPayNo());
            map.put("channelKey", result.getChannelKey());
            map.put("orderName", result.getOrderName());
            map.put("payRealAmt", result.getPayRealAmt());

        } catch (IllegalArgumentException e) {

            map.put("success", false);
            map.put("message", e.getMessage());
        }

        return map;
    }

    // 결제 승인/검증
    @ResponseBody
    @RequestMapping(value = "/confirm", method = RequestMethod.POST)
    public Map<String, Object> confirmPayment(@RequestParam("payNo") Long payNo,
                                              @RequestParam("paymentId") String paymentId) {

        Map<String, Object> map = new HashMap<>();

        boolean success = paymentService.confirmPayment(payNo, paymentId);

        if (success) {
            map.put("success", true);
            map.put("message", "결제가 완료되었습니다.");
        } else {
            map.put("success", false);
            map.put("message", "결제 승인에 실패했습니다.");
        }

        return map;
    }

    // 웹훅
    @ResponseBody
    @RequestMapping(value = "/webhook", method = RequestMethod.POST)
    public Map<String, Object> receiveWebhook(@RequestParam("paymentId") String paymentId) {

        Map<String, Object> map = new HashMap<>();

        paymentService.handleWebhook(paymentId);

        map.put("success", true);

        return map;
    }

    // 결제취소
    @ResponseBody
    @RequestMapping(value = "/cancel", method = RequestMethod.POST)
    public Map<String, Object> cancelPayment(@RequestParam("payNo") Long payNo,
                                             @RequestParam("reason") String reason,
                                             HttpSession session) {

        Map<String, Object> map = new HashMap<>();

        Long mNo = loginMemberNo(session);

        if (mNo == null) {
            map.put("success", false);
            map.put("message", "로그인이 필요합니다.");
            return map;
        }

        boolean success = paymentService.cancelPayment(payNo, reason);

        if (success) {
            map.put("success", true);
            map.put("message", "결제가 취소되었습니다.");
        } else {
            map.put("success", false);
            map.put("message", "결제 취소에 실패했습니다.");
        }

        return map;
    }

    // 결제 상세
    @ResponseBody
    @RequestMapping(value = "/detail", method = RequestMethod.GET)
    public Map<String, Object> selectPaymentOne(@RequestParam("payNo") Long payNo) {

        Map<String, Object> map = new HashMap<>();

        PaymentDTO dto = paymentService.getPaymentOne(payNo);

        if (dto != null) {
            map.put("success", true);
            map.put("data", dto);
        } else {
            map.put("success", false);
            map.put("message", "결제 내역을 찾을 수 없습니다.");
        }

        return map;
    }

    // 주문번호 기준 조회
    @ResponseBody
    @RequestMapping(value = "/byOrder", method = RequestMethod.GET)
    public Map<String, Object> selectPaymentByOrder(@RequestParam("orNo") Long orNo) {

        Map<String, Object> map = new HashMap<>();

        PaymentDTO dto = paymentService.getPaymentByOrder(orNo);

        map.put("success", true);
        map.put("data", dto);

        return map;
    }

    // 회원 결제목록 데이터
    @ResponseBody
    @RequestMapping(value = "/list/data", method = RequestMethod.GET)
    public Map<String, Object> selectPaymentListByMember(HttpSession session) {

        Map<String, Object> map = new HashMap<>();

        Long mNo = loginMemberNo(session);

        if (mNo == null) {
            map.put("success", false);
            map.put("message", "로그인이 필요합니다.");
            return map;
        }

        List<PaymentDTO> list = paymentService.getPaymentListByMember(mNo);

        map.put("success", true);
        map.put("data", list);

        return map;
    }

    // 관리자 결제목록 데이터
    @ResponseBody
    @RequestMapping(value = "/admin/list/data", method = RequestMethod.GET)
    public Map<String, Object> selectPaymentListAll() {

        Map<String, Object> map = new HashMap<>();

        List<PaymentDTO> list = paymentService.getPaymentListAll();

        map.put("success", true);
        map.put("data", list);

        return map;
    }

    // 관리자 상태변경
    @ResponseBody
    @RequestMapping(value = "/admin/updateStatus", method = RequestMethod.POST)
    public Map<String, Object> updatePaymentStatus(@RequestParam("payNo") Long payNo,
                                                   @RequestParam("payStatus") String payStatus) {

        Map<String, Object> map = new HashMap<>();

        int result = paymentService.updatePaymentStatus(payNo, payStatus);

        if (result > 0) {
            map.put("success", true);
            map.put("message", "처리상태가 변경되었습니다.");
        } else {
            map.put("success", false);
            map.put("message", "처리상태 변경에 실패했습니다.");
        }

        return map;
    }

    // 관리자 삭제
    @ResponseBody
    @RequestMapping(value = "/admin/delete", method = RequestMethod.POST)
    public Map<String, Object> deletePayment(@RequestParam("payNo") Long payNo) {

        Map<String, Object> map = new HashMap<>();

        int result = paymentService.deletePayment(payNo);

        if (result > 0) {
            map.put("success", true);
            map.put("message", "삭제되었습니다.");
        } else {
            map.put("success", false);
            map.put("message", "삭제에 실패했습니다.");
        }

        return map;
    }
}
