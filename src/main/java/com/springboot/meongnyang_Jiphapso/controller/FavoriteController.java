package com.springboot.meongnyang_Jiphapso.controller;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.springboot.meongnyang_Jiphapso.common.ApiResponse;
import com.springboot.meongnyang_Jiphapso.common.GuestTokenUtil;
import com.springboot.meongnyang_Jiphapso.common.SessionConst;
import com.springboot.meongnyang_Jiphapso.dto.FavoriteDTO;
import com.springboot.meongnyang_Jiphapso.service.FavoriteService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@Controller
public class FavoriteController {
    private final FavoriteService favoriteService;
    @Autowired
    public FavoriteController(FavoriteService favoriteService) {
        this.favoriteService = favoriteService;
    }
    private Long loginMemberNo(HttpSession session) {
        // 세션엔 MemberDTO.m_no 타입 그대로(Integer) 들어있어서 Integer로 꺼낸 다음 Long으로 변환
        Integer mNo = (Integer) session.getAttribute(SessionConst.LOGIN_MEMBER_NO);
        return (mNo != null) ? mNo.longValue() : null;
    }
    // ------------------------------------------------------------
    // 사용자 화면
    // ------------------------------------------------------------
    /** 관심상품 목록 페이지 */
    @RequestMapping(value = "/favorite/list", method = RequestMethod.GET)
    public String favoriteList(HttpSession session, HttpServletRequest request, HttpServletResponse response, Model model) {
        Long mNo = loginMemberNo(session);
        List<FavoriteDTO> list = (mNo != null)
                ? favoriteService.getFavoriteListByMember(mNo)
                : favoriteService.getFavoriteListByToken(GuestTokenUtil.resolveGuestToken(request, response));
        model.addAttribute("favoriteList", list);
        return "favorite/list";
    }
    /** 관심상품 상세 페이지 */
    @RequestMapping(value = "/favorite/{faNo}", method = RequestMethod.GET)
    public String favoriteDetail(@PathVariable("faNo") Long faNo, HttpSession session,
                                  HttpServletRequest request, HttpServletResponse response, Model model) {
        Long mNo = loginMemberNo(session);
        String guestToken = (mNo == null) ? GuestTokenUtil.resolveGuestToken(request, response) : null;
        FavoriteDTO favorite = favoriteService.getFavoriteOne(faNo);
        favoriteService.checkOwner(favorite, mNo, guestToken); // 본인 소유 아니면 예외 발생 -> 아래 handleOwnerCheckFail 에서 처리
        model.addAttribute("favorite", favorite);
        return "favorite/detail";
    }
    /** 하트버튼 토글 (상품목록/상세에서 AJAX 호출) */
    @RequestMapping(value = "/favorite/toggle", method = RequestMethod.POST)
    @ResponseBody
    public ApiResponse<Boolean> toggleFavorite(@RequestBody Map<String, Object> body,
                                                HttpSession session, HttpServletRequest request, HttpServletResponse response) {
        try {
            Long mNo = loginMemberNo(session);
            Long pNo = Long.valueOf(String.valueOf(body.get("pNo")));
            String guestToken = (mNo == null) ? GuestTokenUtil.resolveGuestToken(request, response) : null;
            boolean nowFavorite = favoriteService.toggleFavorite(mNo, guestToken, pNo);
            return ApiResponse.ok(nowFavorite ? "관심상품에 등록했어요" : "관심상품에서 삭제했어요", nowFavorite);
        } catch (IllegalArgumentException | IllegalStateException e) {
            return ApiResponse.fail(e.getMessage());
        }
    }
    /** 단건 삭제 */
    @RequestMapping(value = "/favorite/{faNo}", method = RequestMethod.DELETE)
    @ResponseBody
    public ApiResponse<Void> deleteFavorite(@PathVariable("faNo") Long faNo, HttpSession session,
                                             HttpServletRequest request, HttpServletResponse response) {
        try {
            Long mNo = loginMemberNo(session);
            String guestToken = (mNo == null) ? GuestTokenUtil.resolveGuestToken(request, response) : null;
            favoriteService.deleteFavorite(faNo, mNo, guestToken); // 소유자 검증 후 삭제
            return ApiResponse.ok(null);
        } catch (IllegalArgumentException | IllegalStateException e) {
            return ApiResponse.fail(e.getMessage());
        }
    }
    /** 선택 삭제 */
    @RequestMapping(value = "/favorite", method = RequestMethod.DELETE)
    @ResponseBody
    public ApiResponse<Void> deleteFavoriteList(@RequestBody List<Long> faNoList,
                                                 HttpSession session, HttpServletRequest request, HttpServletResponse response) {
        try {
            Long mNo = loginMemberNo(session);
            String guestToken = (mNo == null) ? GuestTokenUtil.resolveGuestToken(request, response) : null;
            favoriteService.deleteFavoriteList(faNoList, mNo, guestToken); // 소유자 검증 후 일괄 삭제
            return ApiResponse.ok(null);
        } catch (IllegalArgumentException | IllegalStateException e) {
            return ApiResponse.fail(e.getMessage());
        }
    }
    // ------------------------------------------------------------
    // 관리자 화면
    // ------------------------------------------------------------
    @RequestMapping(value = "/admin/favorite", method = RequestMethod.GET)
    public String adminFavoriteList(Model model) {
        model.addAttribute("favoriteList", favoriteService.getFavoriteListAll());
        return "admin/favorite/adminList";
    }
    @RequestMapping(value = "/admin/favorite/{faNo}", method = RequestMethod.DELETE)
    @ResponseBody
    public ApiResponse<Void> adminDeleteFavorite(@PathVariable("faNo") Long faNo) {
        try {
            favoriteService.deleteFavorite(faNo); // 관리자는 소유자 검증 없이 강제 삭제 (기존 1개짜리 메서드)
            return ApiResponse.ok(null);
        } catch (IllegalArgumentException | IllegalStateException e) {
            return ApiResponse.fail(e.getMessage());
        }
    }
    @ExceptionHandler({IllegalArgumentException.class, IllegalStateException.class})
    public String handleOwnerCheckFail(RuntimeException e, RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        return "redirect:/favorite/list";
    }
}
