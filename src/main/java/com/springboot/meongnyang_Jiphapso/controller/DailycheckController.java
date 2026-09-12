package com.springboot.meongnyang_Jiphapso.controller;

import java.security.Principal;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.springboot.meongnyang_Jiphapso.dao.IMemberDAO;
import com.springboot.meongnyang_Jiphapso.dto.DailycheckDTO;
import com.springboot.meongnyang_Jiphapso.dto.MemberDTO;
import com.springboot.meongnyang_Jiphapso.service.DailycheckService;

@Controller
public class DailycheckController {
	@Autowired
	IMemberDAO m_dao;

	@Autowired
	DailycheckService ch_serv;
	
	@ResponseBody
	@RequestMapping("/dailycheckStatus")
	public Map<String, Object> dailycheckStatus(Principal principal) {
	    Map<String, Object> result = new HashMap<>();

	    if (principal == null) {
	        result.put("needCheck", false);
	        return result;
	    }

	    String m_id = principal.getName();
	    MemberDTO m_dto = m_dao.MemberFindId(m_id);

	    Calendar cal = Calendar.getInstance();
	    cal.set(Calendar.DAY_OF_MONTH, 1);
	    cal.set(Calendar.HOUR_OF_DAY, 0);
	    cal.set(Calendar.MINUTE, 0);
	    cal.set(Calendar.SECOND, 0);
	    cal.set(Calendar.MILLISECOND, 0);
	    Date yearMonth = cal.getTime();

	    DailycheckDTO myCheck = ch_serv.viewByMemberMonth(m_dto.getM_no(), yearMonth);

	    boolean checkedToday = false;
	    if (myCheck != null && myCheck.getCh_end_date() != null) {
	        Calendar today = Calendar.getInstance();
	        Calendar last = Calendar.getInstance();
	        last.setTime(myCheck.getCh_end_date());

	        checkedToday = today.get(Calendar.YEAR) == last.get(Calendar.YEAR)
	                && today.get(Calendar.DAY_OF_YEAR) == last.get(Calendar.DAY_OF_YEAR);
	    }

	    result.put("needCheck", !checkedToday);
	    result.put("ch_count", myCheck != null ? myCheck.getCh_count() : 0);
	    result.put("ch_point_quentity", myCheck != null ? myCheck.getCh_point_quantity() : 0);
	    return result;
	}

	@RequestMapping("/dailycheck")
	public String dailycheck(Principal principal, Model model) {
		String m_id = principal.getName();
		MemberDTO m_dto = m_dao.MemberFindId(m_id);

		Calendar cal = Calendar.getInstance();
		cal.set(Calendar.DAY_OF_MONTH, 1);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);
		Date yearMonth = cal.getTime();

		DailycheckDTO myCheck = ch_serv.viewByMemberMonth(m_dto.getM_no(), yearMonth);
		model.addAttribute("myCheck", myCheck);

		return "member/dailycheck/dailycheck";
	}

	@ResponseBody
	@RequestMapping("/dailycheckDo")
	public String dailycheckDo(Principal principal) {
	    try {
	        String m_id = principal.getName();
	        MemberDTO m_dto = m_dao.MemberFindId(m_id);
	        ch_serv.checkIn(m_dto.getM_no());
	        return "success";
	    } catch (IllegalStateException e) {
	        return "already";
	    } catch (Exception e) {
	        e.printStackTrace();   // ← 이 한 줄만 추가하시면 됩니다
	        return "error";
	    }
	}
}