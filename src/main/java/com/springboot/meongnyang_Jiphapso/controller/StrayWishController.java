package com.springboot.meongnyang_Jiphapso.controller;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.springboot.meongnyang_Jiphapso.dto.MemberDTO;
import com.springboot.meongnyang_Jiphapso.dto.StrayAnimalDto;
import com.springboot.meongnyang_Jiphapso.dto.StrayWishDto;
import com.springboot.meongnyang_Jiphapso.service.StrayWishService;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class StrayWishController {

    @Autowired
    private StrayWishService wish_Service;
    
    private Integer getLoginMemberNo(HttpSession session, HttpServletRequest request) {
        // 이미 세션에 m_no가 있으면 그대로 사용
        Integer m_no = (Integer) session.getAttribute("m_no");
        if (m_no != null) {
            return m_no;
        }

        // 스프링 시큐리티에서 로그인 상태 확인
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !(auth instanceof AnonymousAuthenticationToken)) {
            String m_id = auth.getName(); 
            
            //DB에서 m_id로 m_no 조회
            m_no = wish_Service.getMemberNoById(m_id);
            if (m_no != null) {
                session.setAttribute("m_no", m_no); // 세션에 저장
                
                // 비회원 쿠키가 남아있다면 회원 찜으로 자동 이전
                String guestId = getGuestCookie(request);
                if (guestId != null) {
                    wish_Service.transferGuestToMember(guestId, m_no);
                }
                return m_no;
            }
        }

        return null; // 비로그인 상태
    }
    
    @PostMapping("/api/wish/toggle")
    @ResponseBody
    public Map<String, String> toggleWish(
            @RequestBody StrayWishDto dto,
            HttpSession session,
            HttpServletRequest request,
            HttpServletResponse response) {

        Map<String, String> resultMap = new HashMap<>();
        Integer loginMemberNo = getLoginMemberNo(session, request);

        if (loginMemberNo != null) {
            dto.setM_no(loginMemberNo);
            dto.setWish_guest_id(null); // 회원 찜
        } else {
            String guestId = getOrCreateGuestCookie(request, response);
            dto.setWish_guest_id(guestId);
            dto.setM_no(null); // 비회원 찜
        }

        boolean isAdded = wish_Service.toggleWish(dto);
        resultMap.put("status", isAdded ? "added" : "removed");
        return resultMap;
    }
    
    // 하트 켜기
    @GetMapping("/api/wish/my-ids")
    @ResponseBody
    public List<Long> getMyWishAnimalIds(HttpSession session, HttpServletRequest request) {
        Integer loginMemberNo = getLoginMemberNo(session, request);
        
        if (loginMemberNo != null) {
            return wish_Service.getWishHeartByMember(loginMemberNo);
        } else {
            String guestId = getGuestCookie(request);
            if (guestId == null) return Collections.emptyList();
            return wish_Service.getWishHeartByGuest(guestId);
        }
    }

    // 관심동물 목록 페이지
    @GetMapping("/stray/StrayWishList")
    public String strayWishList(HttpSession session, HttpServletRequest request, Model model) {
        Integer loginMemberNo = getLoginMemberNo(session, request);
        List<StrayAnimalDto> wishList;

        if (loginMemberNo != null) {
            wishList = wish_Service.getWishListByMember(loginMemberNo);
        } else {
            String guestId = getGuestCookie(request);
            wishList = wish_Service.getWishListByGuest(guestId);
        }

        model.addAttribute("WishList", wishList);
        return "stray/StrayWishList"; 
    }

    private String getOrCreateGuestCookie(HttpServletRequest request, HttpServletResponse response) {
        String guestId = getGuestCookie(request);
        if (guestId == null) {
            guestId = UUID.randomUUID().toString();
            Cookie cookie = new Cookie("wish_guest_id", guestId);
            cookie.setPath("/");
            cookie.setMaxAge(60 * 60 * 24 * 30);
            response.addCookie(cookie);
        }
        return guestId;
    }
    
    private String getGuestCookie(HttpServletRequest request) {
        if (request.getCookies() != null) {
            for (Cookie c : request.getCookies()) {
                if ("wish_guest_id".equals(c.getName())) {
                    return c.getValue();
                }
            }
        }
        return null;
    }
}
