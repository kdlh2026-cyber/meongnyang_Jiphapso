package com.springboot.meongnyang_Jiphapso.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

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

    // 1. 찜 토글 API
    @PostMapping("/api/wish/toggle")
    @ResponseBody
    public Map<String, String> toggleWish(
            @RequestBody StrayWishDto dto,
            HttpSession session,
            HttpServletRequest request,
            HttpServletResponse response) {

        Map<String, String> resultMap = new HashMap<>();
        Integer loginMemberNo = (Integer) session.getAttribute("m_no");

        if (loginMemberNo != null) {
            dto.setM_no(loginMemberNo);
        } else {
            String guestId = getOrCreateGuestCookie(request, response);
            dto.setWish_guest_id(guestId);
        }

        boolean isAdded = wish_Service.toggleWish(dto);
        resultMap.put("status", isAdded ? "added" : "removed");
        return resultMap;
    }

    @GetMapping("/api/wish/my-ids")
    @ResponseBody
    public List<Long> getMyWishAnimalIds(HttpSession session, HttpServletRequest request) {
        Integer loginMemberNo = (Integer) session.getAttribute("m_no");
        if (loginMemberNo != null) {
            return wish_Service.getWishHeartByMember(loginMemberNo);
        } else {
            String guestId = getGuestCookie(request);
            return wish_Service.getWishHeartByGuest(guestId);
        }
    }

    // 3. 관심동물 목록 페이지
    @GetMapping("/stray/StrayWishList")
    public String strayWishList(HttpSession session, HttpServletRequest request, Model model) {
        Integer loginMemberNo = (Integer) session.getAttribute("m_no");
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
