package com.springboot.meongnyang_Jiphapso.auth;

import jakarta.servlet.http.HttpServletRequest;

import org.springframework.context.ApplicationListener;
import org.springframework.security.authentication.event.InteractiveAuthenticationSuccessEvent;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.springboot.meongnyang_Jiphapso.common.GuestTokenUtil;
import com.springboot.meongnyang_Jiphapso.dao.IMemberLookupDAO;
import com.springboot.meongnyang_Jiphapso.dto.MemberDTO;
import com.springboot.meongnyang_Jiphapso.service.CartService;

@Component
public class CartMergeLoginListener implements ApplicationListener<InteractiveAuthenticationSuccessEvent> {

    private final CartService cartService;
    private final IMemberLookupDAO memberLookupDAO;

    public CartMergeLoginListener(CartService cartService, IMemberLookupDAO memberLookupDAO) {
        this.cartService = cartService;
        this.memberLookupDAO = memberLookupDAO;
    }

    @Override
    public void onApplicationEvent(InteractiveAuthenticationSuccessEvent event) {
        try {
            ServletRequestAttributes attrs =
                    (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attrs == null) return;

            HttpServletRequest request = attrs.getRequest();
            String guestToken = GuestTokenUtil.readGuestToken(request);
            if (guestToken == null) return; // 게스트 토큰 자체가 없으면 병합할 것도 없음

            String mId = event.getAuthentication().getName(); // 로그인 아이디
            MemberDTO member = memberLookupDAO.selectMemberByLoginId(mId);
            if (member != null) {
                cartService.mergeGuestCartIntoMember(guestToken, (long) member.getM_no());
            }
        } catch (Exception e) {
            // 병합 실패해도 로그인 자체엔 영향 없게 함
            e.printStackTrace();
        }
    }
}