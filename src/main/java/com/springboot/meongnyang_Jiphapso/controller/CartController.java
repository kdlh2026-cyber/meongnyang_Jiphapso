package com.springboot.meongnyang_Jiphapso.controller;
import java.util.List;
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
import com.springboot.meongnyang_Jiphapso.common.GuestTokenUtil;
import com.springboot.meongnyang_Jiphapso.common.SessionConst;
import com.springboot.meongnyang_Jiphapso.dto.CartDTO;
import com.springboot.meongnyang_Jiphapso.service.CartService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@Controller
public class CartController {
    private final CartService cartService;
    @Autowired
    public CartController(CartService cartService) {
        this.cartService = cartService;
    }
    private Long loginMemberNo(HttpSession session) {
        // 세션엔 MemberDTO.m_no 타입 그대로(Integer) 들어있어서 Integer로 꺼낸 다음 Long으로 변환
        Integer mNo = (Integer) session.getAttribute(SessionConst.LOGIN_MEMBER_NO);
        return (mNo != null) ? mNo.longValue() : null;
    }
    // ------------------------------------------------------------
    // 회원/비회원 공용 화면
    // ------------------------------------------------------------
    /** 장바구니 페이지 */
    @RequestMapping(value = "/cart/list", method = RequestMethod.GET)
    public String cartList(HttpSession session,
                           HttpServletRequest request,
                           HttpServletResponse response,
                           Model model) {
        Long mNo = loginMemberNo(session);
        List<CartDTO> list = (mNo != null)
                ? cartService.getCartListByMember(mNo)
                : cartService.getCartListByToken(
                        GuestTokenUtil.resolveGuestToken(request, response));
        model.addAttribute("cartList", list);
        return "cart/list"; // /WEB-INF/views/cart/list.jsp (회원/비회원 공용)
    }
    /** 담기 (상품목록/상세 페이지의 장바구니 버튼에서 AJAX 호출) */
    @RequestMapping(value = "/cart/add", method = RequestMethod.POST)
    @ResponseBody
    public ApiResponse<CartDTO> addCart(@RequestBody Map<String, Object> body,
                                         HttpSession session, HttpServletRequest request, HttpServletResponse response) {
        Long mNo = loginMemberNo(session);
        Long pNo = Long.valueOf(String.valueOf(body.get("pNo")));
        Long oNo = body.get("oNo") != null ? Long.valueOf(String.valueOf(body.get("oNo"))) : null;
        int quantity = body.get("quantity") != null ? Integer.parseInt(String.valueOf(body.get("quantity"))) : 1;
        String guestToken = (mNo == null) ? GuestTokenUtil.resolveGuestToken(request, response) : null;
        CartDTO result = cartService.addCart(mNo, guestToken, pNo, oNo, quantity);
        return ApiResponse.ok("장바구니에 담았어요", result);
    }
    /** 수량 변경 (+/- 버튼) */
    @RequestMapping(value = "/cart/{caNo}/quantity", method = RequestMethod.PUT)
    @ResponseBody
    public ApiResponse<Void> updateQuantity(@PathVariable("caNo") Long caNo, @RequestBody Map<String, Integer> body,
                                             HttpSession session, HttpServletRequest request, HttpServletResponse response) {
        Long mNo = loginMemberNo(session);
        String guestToken = (mNo == null) ? GuestTokenUtil.resolveGuestToken(request, response) : null;
        cartService.updateQuantity(caNo, body.get("quantity"), mNo, guestToken); // 소유자 검증 후 수정
        return ApiResponse.ok(null);
    }
    /** 쇼핑백 추가구매 옵션 변경 */
    @RequestMapping(value = "/cart/{caNo}/bag", method = RequestMethod.PUT)
    @ResponseBody
    public ApiResponse<Void> updateBag(@PathVariable("caNo") Long caNo, @RequestBody Map<String, Object> body,
                                        HttpSession session, HttpServletRequest request, HttpServletResponse response) {
        Long mNo = loginMemberNo(session);
        String guestToken = (mNo == null) ? GuestTokenUtil.resolveGuestToken(request, response) : null;
        String bagYn = String.valueOf(body.get("bagYn"));
        int bagQty = Integer.parseInt(String.valueOf(body.get("bagQty")));
        cartService.updateBag(caNo, bagYn, bagQty, mNo, guestToken); // 소유자 검증 후 수정
        return ApiResponse.ok(null);
    }
    /** 단건 삭제 */
    @RequestMapping(value = "/cart/{caNo}", method = RequestMethod.DELETE)
    @ResponseBody
    public ApiResponse<Void> deleteCart(@PathVariable("caNo") Long caNo,
                                         HttpSession session, HttpServletRequest request, HttpServletResponse response) {
        Long mNo = loginMemberNo(session);
        String guestToken = (mNo == null) ? GuestTokenUtil.resolveGuestToken(request, response) : null;
        cartService.deleteCart(caNo, mNo, guestToken); // 소유자 검증 후 삭제
        return ApiResponse.ok(null);
    }
    /** 선택 삭제 */
    @RequestMapping(value = "/cart", method = RequestMethod.DELETE)
    @ResponseBody
    public ApiResponse<Void> deleteCartList(@RequestBody List<Long> caNoList,
                                             HttpSession session, HttpServletRequest request, HttpServletResponse response) {
        Long mNo = loginMemberNo(session);
        String guestToken = (mNo == null) ? GuestTokenUtil.resolveGuestToken(request, response) : null;
        cartService.deleteCartList(caNoList, mNo, guestToken); // 소유자 검증 후 일괄 삭제
        return ApiResponse.ok(null);
    }
    /** 장바구니 담긴 개수 (헤더 뱃지, 회원/비회원 모두 지원) */
    @RequestMapping(value = "/cart/count", method = RequestMethod.GET)
    @ResponseBody
    public ApiResponse<Integer> countCart(HttpSession session, HttpServletRequest request) {
        Long mNo = loginMemberNo(session);
        if (mNo != null) {
            return ApiResponse.ok(cartService.countCart(mNo));
        }
        String guestToken = GuestTokenUtil.readGuestToken(request);
        return ApiResponse.ok(cartService.countCartByToken(guestToken));
    }
    // ------------------------------------------------------------
    // 관리자 화면
    // ------------------------------------------------------------
    @RequestMapping(value = "/admin/cart", method = RequestMethod.GET)
    public String adminCartList(Model model) {
        model.addAttribute("cartList", cartService.getCartListAll());
        return "admin/cart/adminList"; // /WEB-INF/views/admin/cart/adminList.jsp
    }
    @RequestMapping(value = "/admin/cart/{caNo}", method = RequestMethod.DELETE)
    @ResponseBody
    public ApiResponse<Void> adminDeleteCart(@PathVariable("caNo") Long caNo) {
        cartService.deleteCart(caNo); // 관리자는 소유자 검증 없이 강제 삭제 (기존 1개짜리 메서드)
        return ApiResponse.ok(null);
    }
}
