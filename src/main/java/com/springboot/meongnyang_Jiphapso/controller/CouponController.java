package com.springboot.meongnyang_Jiphapso.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.springboot.meongnyang_Jiphapso.common.ApiResponse;
import com.springboot.meongnyang_Jiphapso.common.SessionConst;
import com.springboot.meongnyang_Jiphapso.dto.CouponDTO;
import com.springboot.meongnyang_Jiphapso.dto.MemberCouponDTO;
import com.springboot.meongnyang_Jiphapso.service.CouponService;
import com.springboot.meongnyang_Jiphapso.service.MemberCouponService;

import jakarta.servlet.http.HttpSession;

@Controller
public class CouponController {

	private final CouponService couponService;
	private final MemberCouponService memberCouponService;

	@Autowired
	public CouponController(CouponService couponService, MemberCouponService memberCouponService) {
		this.couponService = couponService;
		this.memberCouponService = memberCouponService;
	}

	private Long loginMemberNo(HttpSession session) {
		// 세션엔 MemberDTO.m_no 타입 그대로(Integer) 들어있어서 Integer로 꺼낸 다음 Long으로 변환
		Integer mNo = (Integer) session.getAttribute(SessionConst.LOGIN_MEMBER_NO);
		return (mNo != null) ? mNo.longValue() : null;
	}

	// ------------------------------------------------------------
	// 회원 화면 (로그인 필요)
	// ------------------------------------------------------------

	/** 쿠폰함 페이지 - 다운로드 가능한 쿠폰 + 내 보유쿠폰함을 한 화면에서 보여줌 */
	@RequestMapping(value = "/coupon/list", method = RequestMethod.GET)
	public String couponListPage(HttpSession session) {
		if (loginMemberNo(session) == null) {
			return "redirect:/member/login";
		}
		return "member/coupon/list"; // /WEB-INF/views/member/coupon/list.jsp
	}

	/** 다운로드 가능한 쿠폰 목록 (ajax) */
	@RequestMapping(value = "/coupon/downloadable", method = RequestMethod.GET)
	@ResponseBody
	public ApiResponse<List<CouponDTO>> downloadableList(HttpSession session) {
		try {
			Long mNo = loginMemberNo(session);
			return ApiResponse.ok(couponService.getDownloadableCouponList(mNo));
		} catch (IllegalStateException e) {
			return ApiResponse.fail(e.getMessage());
		}
	}

	/** 내 보유쿠폰함 목록 (ajax) */
	@RequestMapping(value = "/coupon/my", method = RequestMethod.GET)
	@ResponseBody
	public ApiResponse<List<MemberCouponDTO>> myCouponList(HttpSession session) {
		try {
			Long mNo = loginMemberNo(session);
			return ApiResponse.ok(memberCouponService.getMyCouponList(mNo));
		} catch (IllegalStateException e) {
			return ApiResponse.fail(e.getMessage());
		}
	}

	/** 결제화면에서 실제 사용 가능한(미사용+만료전) 보유쿠폰 목록 (ajax, checkout.jsp에서 호출) */
	@RequestMapping(value = "/coupon/usable", method = RequestMethod.GET)
	@ResponseBody
	public ApiResponse<List<MemberCouponDTO>> usableCouponList(HttpSession session) {
		try {
			Long mNo = loginMemberNo(session);
			return ApiResponse.ok(memberCouponService.getUsableCouponList(mNo));
		} catch (IllegalStateException e) {
			return ApiResponse.fail(e.getMessage());
		}
	}

	/** 쿠폰 사용 처리 (결제화면에서 주문 생성 직후 ajax 호출, mcNo/orNo) */
	@RequestMapping(value = "/coupon/use", method = RequestMethod.POST)
	@ResponseBody
	public ApiResponse<Void> useCoupon(@RequestParam("mcNo") Long mcNo, @RequestParam("orNo") Long orNo) {
		try {
			memberCouponService.useCoupon(mcNo, orNo);
			return ApiResponse.ok(null);
		} catch (IllegalArgumentException | IllegalStateException e) {
			return ApiResponse.fail(e.getMessage());
		}
	}

	/** 쿠폰 다운로드 (쿠폰함 -> 보유쿠폰함으로 이동, ajax) */
	@RequestMapping(value = "/coupon/download", method = RequestMethod.POST)
	@ResponseBody
	public ApiResponse<MemberCouponDTO> downloadCoupon(@RequestBody Map<String, Object> body, HttpSession session) {
		try {
			Long mNo = loginMemberNo(session);
			Long coNo = Long.valueOf(String.valueOf(body.get("coNo")));
			MemberCouponDTO result = memberCouponService.downloadCoupon(mNo, coNo);
			return ApiResponse.ok("쿠폰을 다운로드했어요", result);
		} catch (IllegalArgumentException | IllegalStateException e) {
			return ApiResponse.fail(e.getMessage());
		}
	}

	// ------------------------------------------------------------
	// 관리자 화면
	// ------------------------------------------------------------

	/** 쿠폰 관리 페이지 (등록폼 + 쿠폰 템플릿 목록, 데이터는 /admin/coupon/list/data 를 ajax로 호출해서 채움) */
	@RequestMapping(value = "/admin/coupon", method = RequestMethod.GET)
	public String adminCouponPage() {
		return "admin/coupon/list"; // /WEB-INF/views/admin/coupon/list.jsp
	}

	/** 쿠폰 템플릿 전체 목록 (ajax) */
	@RequestMapping(value = "/admin/coupon/list/data", method = RequestMethod.GET)
	@ResponseBody
	public ApiResponse<List<CouponDTO>> adminCouponListData() {
		return ApiResponse.ok(couponService.getCouponListAll());
	}

	/** 쿠폰 등록폼 - 대상 상품 검색 (ajax, 상품명 부분일치) */
	@RequestMapping(value = "/admin/coupon/products", method = RequestMethod.GET)
	@ResponseBody
	public ApiResponse<List<Map<String, Object>>> searchProducts(@RequestParam("keyword") String keyword) {
		return ApiResponse.ok(couponService.searchProducts(keyword));
	}

	/** 쿠폰 등록 (ajax) */
	@RequestMapping(value = "/admin/coupon/insert", method = RequestMethod.POST)
	@ResponseBody
	public ApiResponse<Void> adminInsertCoupon(CouponDTO dto) {
		try {
			couponService.insertCoupon(dto);
			return ApiResponse.ok("쿠폰이 등록되었습니다", null);
		} catch (IllegalArgumentException e) {
			return ApiResponse.fail(e.getMessage());
		}
	}

	/** 쿠폰 삭제 (ajax) */
	@RequestMapping(value = "/admin/coupon/{coNo}", method = RequestMethod.DELETE)
	@ResponseBody
	public ApiResponse<Void> adminDeleteCoupon(@PathVariable("coNo") Long coNo) {
		couponService.deleteCoupon(coNo);
		return ApiResponse.ok(null);
	}

	/** 회원별 쿠폰 발급현황 목록 (ajax, 관리자 페이지 하단 탭에서 호출) */
	@RequestMapping(value = "/admin/coupon/member/list", method = RequestMethod.GET)
	@ResponseBody
	public ApiResponse<List<MemberCouponDTO>> adminMemberCouponList() {
		return ApiResponse.ok(memberCouponService.getMemberCouponListAll());
	}

	/** 발급된 회원쿠폰 강제 삭제 (ajax) */
	@RequestMapping(value = "/admin/coupon/member/{mcNo}", method = RequestMethod.DELETE)
	@ResponseBody
	public ApiResponse<Void> adminDeleteMemberCoupon(@PathVariable("mcNo") Long mcNo) {
		memberCouponService.deleteMemberCoupon(mcNo);
		return ApiResponse.ok(null);
	}
}
