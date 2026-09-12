package com.springboot.meongnyang_Jiphapso.service;

import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.meongnyang_Jiphapso.dao.IDailycheckDAO;
import com.springboot.meongnyang_Jiphapso.dto.DailycheckDTO;

@Service
public class DailycheckService {
	@Autowired
	IDailycheckDAO ch_dao;
	
	@Autowired
	DailycheckESService ch_service;

	@Autowired
	private PointService pointService;
	
	public void write(DailycheckDTO ch_dto) throws Exception{
		ch_dao.CheckWrite(ch_dto);
		ch_service.save(ch_dto);
	}
	
	public List<DailycheckDTO> list(){
		return ch_dao.CheckList();
	}
	
	public List<DailycheckDTO> search(String keyword) throws Exception{
		return ch_service.search(keyword);
	}
	
	public List<Map<String,String>> autocomplete(String keyword) throws Exception{
		return ch_service.autocompleteHighlight(keyword);
	}

	// 이번 달 첫 날짜(00:00:00) 반환
	private Date getMonthStart() {
		Calendar cal = Calendar.getInstance();
		cal.set(Calendar.DAY_OF_MONTH, 1);
		cal.set(Calendar.HOUR_OF_DAY, 0);
		cal.set(Calendar.MINUTE, 0);
		cal.set(Calendar.SECOND, 0);
		cal.set(Calendar.MILLISECOND, 0);
		return cal.getTime();
	}

	public DailycheckDTO viewByMemberMonth(int m_no, Date ch_year_month) {
		Map<String, Object> params = new HashMap<>();
		params.put("m_no", m_no);
		params.put("ch_year_month", ch_year_month);
		return ch_dao.CheckViewByMemberMonth(params);
	}

	// 같은 날짜인지 비교 (연/월/일만 비교)
	private boolean isSameDay(Date d1, Date d2) {
		if (d1 == null || d2 == null) return false;
		Calendar c1 = Calendar.getInstance();
		c1.setTime(d1);
		Calendar c2 = Calendar.getInstance();
		c2.setTime(d2);
		return c1.get(Calendar.YEAR) == c2.get(Calendar.YEAR)
			&& c1.get(Calendar.DAY_OF_YEAR) == c2.get(Calendar.DAY_OF_YEAR);
	}

	// 누적식 출석체크 처리
	public DailycheckDTO checkIn(int m_no) throws Exception {
		Date yearMonth = getMonthStart();
		Date today = new Date();

		DailycheckDTO existing = viewByMemberMonth(m_no, yearMonth);

		if (existing == null) {
			// 이번 달 첫 출석
			DailycheckDTO ch_dto = new DailycheckDTO();
			ch_dto.setCh_count(1);
			ch_dto.setCh_year_month(yearMonth);
			ch_dto.setCh_start_date(today);
			ch_dto.setCh_end_date(today);
			ch_dto.setCh_point_quantity(100); // 1회 출석당 100P
			ch_dto.setM_no(m_no);
			// TODO: pointService.earnDailyCheckBonus(m_no, ...) 호출 후 발급된 po_no 세팅
			write(ch_dto);
			return ch_dto;
		}

		if (isSameDay(existing.getCh_end_date(), today)) {
			throw new IllegalStateException("오늘은 이미 출석체크를 완료했습니다.");
		}

		existing.setCh_count(existing.getCh_count() + 1);
		existing.setCh_end_date(today);
		existing.setCh_point_quantity(existing.getCh_point_quantity() + 100);
		// TODO: pointService.earnDailyCheckBonus(m_no, existing.getCh_no()) 호출

		ch_dao.CheckUpdate(existing);
		ch_service.save(existing);
		return existing;
	}
}