package com.springboot.meongnyang_Jiphapso.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.springboot.meongnyang_Jiphapso.common.SessionConst;
import com.springboot.meongnyang_Jiphapso.dto.OrderCancelDTO;
import com.springboot.meongnyang_Jiphapso.service.OrderCancelService;

import jakarta.servlet.http.HttpSession;

@Controller
public class OrderCancelController {

	@Autowired
	private OrderCancelService orderCancelService;

	private Long loginMemberNo(HttpSession session) {
		Integer mNo = (Integer) session.getAttribute(SessionConst.LOGIN_MEMBER_NO);
		return (mNo != null) ? mNo.longValue() : null;
	}

	// ================= 페이지 이동 (JSP 포워딩) =================

	// 회원 - 취소/반품 목록 페이지 (member 폴더, 데이터는 /list/data 를 ajax로 호출해서 채움)
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public String orderCancelListPage(HttpSession session) {

		// 비로그인이면 로그인페이지로 (주문취소는 회원 전용 기능)
		Long loginNo = loginMemberNo(session);
		if (loginNo == null) {
			return "redirect:/member/login";
		}

		return "member/OrderCancel/list"; // /WEB-INF/views/member/OrderCancel/list.jsp
	}

	// 관리자 - 전체 취소 목록 페이지 (admin 폴더)
	@RequestMapping(value = "/admin/list", method = RequestMethod.GET)
	public String orderCancelAdminListPage() {
		return "admin/OrderCancel/list"; // /WEB-INF/views/admin/OrderCancel/list.jsp
	}

	// ================= 데이터 처리 (ajax, JSON) =================

	// 취소/반품/교환 신청 등록 (회원 - 주문상세페이지에서 취소버튼 클릭 시 ajax)
	@ResponseBody
	@RequestMapping(value = "/insert", method = RequestMethod.POST)
	public Map<String, Object> insertOrderCancel(OrderCancelDTO dto, HttpSession session) {

		Map<String, Object> map = new HashMap<String, Object>();

		// 비로그인이면 실패 응답
		Long loginNo = loginMemberNo(session);
		if (loginNo == null) {
			map.put("success", false);
			map.put("message", "로그인이 필요합니다.");
			return map;
		}

		// 신청일시 세팅, 상태값 기본세팅(신청)은 Service 쪽에서 처리
		int result = orderCancelService.insertOrderCancel(dto);

		if (result > 0) {
			map.put("success", true);
			map.put("message", "취소/반품/교환 신청이 등록되었습니다.");
		} else {
			map.put("success", false);
			map.put("message", "신청 등록에 실패했습니다.");
		}

		return map;
	}

	// 처리상태 변경 (관리자 - 승인/거절/환불완료, ajax)
	@ResponseBody
	@RequestMapping(value = "/admin/updateStatus", method = RequestMethod.POST)
	public Map<String, Object> updateOrderCancelStatus(@RequestParam("ocOutNo") Long ocOutNo,
			@RequestParam("ocStatus") String ocStatus) {

		Map<String, Object> map = new HashMap<String, Object>();

		// 처리완료일시는 현재시간으로 세팅
		int result = orderCancelService.updateOrderCancelStatus(ocOutNo, ocStatus, new Date());

		if (result > 0) {
			map.put("success", true);
			map.put("message", "처리상태가 변경되었습니다.");
		} else {
			map.put("success", false);
			map.put("message", "처리상태 변경에 실패했습니다.");
		}

		return map;
	}

	// 단건 조회 (취소 상세보기, ajax)
	@ResponseBody
	@RequestMapping(value = "/detail", method = RequestMethod.GET)
	public Map<String, Object> selectOrderCancelOne(@RequestParam("ocOutNo") Long ocOutNo) {

		Map<String, Object> map = new HashMap<String, Object>();

		OrderCancelDTO dto = orderCancelService.selectOrderCancelOne(ocOutNo);

		if (dto != null) {
			map.put("success", true);
			map.put("data", dto);
		} else {
			map.put("success", false);
			map.put("message", "취소 내역을 찾을 수 없습니다.");
		}

		return map;
	}

	// 주문상세 기준 취소이력 조회 (ajax)
	@ResponseBody
	@RequestMapping(value = "/listByDetail", method = RequestMethod.GET)
	public Map<String, Object> selectOrderCancelListByOrderDetail(@RequestParam("odDetailNo") Long odDetailNo) {

		Map<String, Object> map = new HashMap<String, Object>();

		List<OrderCancelDTO> list = orderCancelService.selectOrderCancelListByOrderDetail(odDetailNo);

		map.put("success", true);
		map.put("data", list);

		return map;
	}

	// 회원 기준 취소/반품 목록 데이터 (마이페이지, ajax) - /list 페이지에서 호출
	@ResponseBody
	@RequestMapping(value = "/list/data", method = RequestMethod.GET)
	public Map<String, Object> selectOrderCancelListByMember(HttpSession session) {

		Map<String, Object> map = new HashMap<String, Object>();

		Long mNo = loginMemberNo(session);
		if (mNo == null) {
			map.put("success", false);
			map.put("message", "로그인이 필요합니다.");
			return map;
		}

		List<OrderCancelDTO> list = orderCancelService.selectOrderCancelListByMember(mNo);

		map.put("success", true);
		map.put("data", list);

		return map;
	}

	// 관리자 - 전체 취소 목록 데이터 (ajax) - /admin/list 페이지에서 호출
	@ResponseBody
	@RequestMapping(value = "/admin/list/data", method = RequestMethod.GET)
	public Map<String, Object> selectOrderCancelListAll() {

		Map<String, Object> map = new HashMap<String, Object>();

		List<OrderCancelDTO> list = orderCancelService.selectOrderCancelListAll();

		map.put("success", true);
		map.put("data", list);

		return map;
	}

	// 삭제 (관리자, ajax)
	@ResponseBody
	@RequestMapping(value = "/admin/delete", method = RequestMethod.POST)
	public Map<String, Object> deleteOrderCancel(@RequestParam("ocOutNo") Long ocOutNo) {

		Map<String, Object> map = new HashMap<String, Object>();

		int result = orderCancelService.deleteOrderCancel(ocOutNo);

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
