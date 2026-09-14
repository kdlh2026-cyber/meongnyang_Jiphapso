package com.springboot.meongnyang_Jiphapso.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.springboot.meongnyang_Jiphapso.common.ApiResponse;
import com.springboot.meongnyang_Jiphapso.common.SessionConst;
import com.springboot.meongnyang_Jiphapso.dao.IMemberDAO;
import com.springboot.meongnyang_Jiphapso.dto.MemberDTO;
import com.springboot.meongnyang_Jiphapso.dto.PointDTO;
import com.springboot.meongnyang_Jiphapso.service.PointService;

import jakarta.servlet.http.HttpSession;

@Controller
public class PointController {

	@Autowired
	private PointService pointService;

	@Autowired
	private IMemberDAO m_dao;

	private Long loginMemberNo(HttpSession session) {
		// 세션엔 MemberDTO.m_no 타입 그대로(Integer) 들어있어서 Integer로 꺼낸 다음 Long으로 변환
		Integer mNo = (Integer) session.getAttribute(SessionConst.LOGIN_MEMBER_NO);
		return (mNo != null) ? mNo.longValue() : null;
	}

	// ------------------------------------------------------------
	// 회원 화면 (마이페이지 - 포인트 조회)
	// ------------------------------------------------------------

	/** 포인트 조회 페이지 */
	@RequestMapping(value = "/point/list", method = RequestMethod.GET)
	public String pointListPage(HttpSession session) {
		Long mNo = loginMemberNo(session);
		if (mNo == null) {
			return "redirect:/member/login";
		}
		return "member/point/list"; // /WEB-INF/views/member/point/list.jsp
	}

	/** 포인트 요약 + 이력 데이터 (ajax) */
	@RequestMapping(value = "/point/list/data", method = RequestMethod.GET)
	@ResponseBody
	public ApiResponse<Map<String, Object>> pointListData(HttpSession session) {
		Long mNo = loginMemberNo(session);
		if (mNo == null) {
			return ApiResponse.fail("로그인이 필요합니다.");
		}

		Map<String, Object> summary = pointService.getPointSummary(mNo);
		List<PointDTO> list = pointService.getPointListByMember(mNo);
		summary.put("list", list);

		return ApiResponse.ok(summary);
	}

	// ------------------------------------------------------------
	// 관리자 화면
	// ------------------------------------------------------------

	/** 관리자 - 포인트 이력 전체 목록 페이지 */
	@RequestMapping(value = "/admin/point/list", method = RequestMethod.GET)
	public String adminPointListPage() {
		return "admin/point/list"; // /WEB-INF/views/admin/point/list.jsp
	}

	/** 관리자 - 포인트 이력 전체 목록 데이터 (ajax) */
	@RequestMapping(value = "/admin/point/list/data", method = RequestMethod.GET)
	@ResponseBody
	public ApiResponse<List<PointDTO>> adminPointListData() {
		return ApiResponse.ok(pointService.getPointListAll());
	}

	/** 관리자 - 특정 회원 포인트 수동 지급/차감 (회원아이디로 조회해서 회원번호 확인 후 처리) */
	@RequestMapping(value = "/admin/point/adjust", method = RequestMethod.POST)
	@ResponseBody
	public ApiResponse<Void> adjustPoint(@RequestBody Map<String, Object> body) {
		try {
			String mId = body.get("mId") != null ? String.valueOf(body.get("mId")) : null;
			if (mId == null || mId.isBlank()) {
				return ApiResponse.fail("회원아이디를 입력해주세요.");
			}

			MemberDTO member = m_dao.MemberView(mId);
			if (member == null) {
				return ApiResponse.fail("존재하지 않는 회원아이디입니다.");
			}
			Long mNo = (long) member.getM_no(); // MemberDTO.getM_no()는 int 반환 (MemberService에서도 이렇게 캐스팅해서 씀)

			long amount = Long.parseLong(String.valueOf(body.get("amount")));
			String reason = body.get("reason") != null ? String.valueOf(body.get("reason")) : null;

			pointService.adjustPointByAdmin(mNo, amount, reason);
			return ApiResponse.ok(null);
		} catch (IllegalArgumentException | IllegalStateException e) {
			return ApiResponse.fail(e.getMessage());
		}
	}

	/** 관리자 - 특정 이력 취소 (원본은 남기고 사유와 함께 반대 이력을 추가) */
	@RequestMapping(value = "/admin/point/cancel", method = RequestMethod.POST)
	@ResponseBody
	public ApiResponse<Void> cancelPoint(@RequestBody Map<String, Object> body) {
		try {
			Long poNo = Long.valueOf(String.valueOf(body.get("poNo")));
			String reason = body.get("reason") != null ? String.valueOf(body.get("reason")) : null;

			pointService.cancelPointEntry(poNo, reason);
			return ApiResponse.ok(null);
		} catch (IllegalArgumentException | IllegalStateException e) {
			return ApiResponse.fail(e.getMessage());
		}
	}

	/** 관리자 - 이력 삭제 (오기입 등 예외 상황) */
	@RequestMapping(value = "/admin/point/delete", method = RequestMethod.POST)
	@ResponseBody
	public ApiResponse<Void> deletePoint(@RequestBody Map<String, Object> body) {
		try {
			Long poNo = Long.valueOf(String.valueOf(body.get("poNo")));
			int result = pointService.deletePoint(poNo);
			if (result > 0) {
				return ApiResponse.ok(null);
			}
			return ApiResponse.fail("삭제에 실패했습니다.");
		} catch (IllegalArgumentException | IllegalStateException e) {
			return ApiResponse.fail(e.getMessage());
		}
	}
}