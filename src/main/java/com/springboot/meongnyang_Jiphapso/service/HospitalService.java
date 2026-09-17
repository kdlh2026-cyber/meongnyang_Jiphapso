package com.springboot.meongnyang_Jiphapso.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.LinkedHashMap;
import java.util.Map.Entry;
import java.util.TreeMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.meongnyang_Jiphapso.dao.IHospitalDAO;
import com.springboot.meongnyang_Jiphapso.dto.HospitalDTO;

@Service
public class HospitalService {
	@Autowired
	IHospitalDAO hp_dao;
	
	@Autowired
	HospitalESService hp_service;
	
	public void write(HospitalDTO hp_dto) throws Exception{
		hp_dao.HospitalWrite(hp_dto);  // 오라클 DB에 저장
		hp_service.save(hp_dto);       // 엘라스틱서치에 색인
	}
	
	public List<HospitalDTO> list(){
		return hp_dao.HospitalList();
	}
	
	public HospitalDTO view(Integer hp_no) {
		return hp_dao.HospitalView(hp_no);
	}
	
	public void update(HospitalDTO hp_dto) throws Exception{
		hp_dao.HospitalUpdate(hp_dto);  // 오라클 DB 수정
		hp_service.save(hp_dto);        // 엘라스틱서치 재색인(같은 id면 덮어씀)
	}
	
	public void delete(Integer hp_no) {
		hp_dao.HospitalDelete(hp_no);
	}
	
	public List<HospitalDTO> search(String keyword) throws Exception{
		return hp_service.search(keyword);
	}
	
	// 자동완성 + 하이라이트
	public List<Map<String,String>> autocomplete(String keyword) throws Exception{
		return hp_service.autocompleteHighlight(keyword);
	}
	
	public List<HospitalDTO> selectList(String keyword, int startRow, int endRow) {
		Map<String, Object> params = new HashMap<>();
		params.put("keyword", keyword);
		params.put("startRow", startRow);
		params.put("endRow", endRow);
		return hp_dao.HospitalSelectList(params);
	}

	public int getTotalCount(String keyword) {
		return hp_dao.HospitalTotalCount(keyword);
	}

	private static final Pattern GU_PATTERN = Pattern.compile("(\\S+?구)\\s");
	private static final Pattern DONG_PATTERN = Pattern.compile("구\\s+(\\S+?동)\\s");

	private String extractGu(String addr) {
		if (addr == null) return "기타";
		Matcher m = GU_PATTERN.matcher(addr + " ");
		return m.find() ? m.group(1) : "기타";
	}

	private String extractDong(String addr) {
		if (addr == null) return "기타";
		Matcher m = DONG_PATTERN.matcher(addr + " ");
		return m.find() ? m.group(1) : "기타";
	}

	// 구 -> 동 -> 병원리스트
	public Map<String, Map<String, List<HospitalDTO>>> groupByRegion() {
		List<HospitalDTO> all = list();
		Map<String, Map<String, List<HospitalDTO>>> grouped = new TreeMap<>();

		for (HospitalDTO hp : all) {
			String gu = extractGu(hp.getHp_addr());
			String dong = extractDong(hp.getHp_addr());

			grouped.computeIfAbsent(gu, k -> new TreeMap<>())
				   .computeIfAbsent(dong, k -> new ArrayList<>())
				   .add(hp);
		}
		return grouped;
	}

	// 구별 병원 수 랭킹 (내림차순)
	public List<Entry<String, Integer>> guRanking() {
		Map<String, Map<String, List<HospitalDTO>>> grouped = groupByRegion();
		Map<String, Integer> guCounts = new LinkedHashMap<>();

		grouped.forEach((gu, dongMap) -> {
			int cnt = dongMap.values().stream().mapToInt(List::size).sum();
			guCounts.put(gu, cnt);
		});

		return guCounts.entrySet().stream()
			.sorted((a, b) -> b.getValue() - a.getValue())
			.collect(Collectors.toList());
	}
	
	public Map<String, Integer> guTotalCount() {
		Map<String, Map<String, List<HospitalDTO>>> grouped = groupByRegion();
		Map<String, Integer> result = new LinkedHashMap<>();

		grouped.forEach((gu, dongMap) -> {
			int cnt = dongMap.values().stream().mapToInt(List::size).sum();
			result.put(gu, cnt);
		});

		return result;
	}
}