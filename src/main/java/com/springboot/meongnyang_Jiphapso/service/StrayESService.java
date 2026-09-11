package com.springboot.meongnyang_Jiphapso.service;

import java.util.HashMap;
import java.util.Map;

import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.meongnyang_Jiphapso.dao.IStrayAnimalDao;
import com.springboot.meongnyang_Jiphapso.dto.StrayAnimalDto;

@Service
public class StrayESService {
	@Autowired
	private RestHighLevelClient client; // 엘라스틱서치와 자동으로 연결
	@Autowired
	IStrayAnimalDao stray_dao;

	public void stray_save(StrayAnimalDto stray_dto) throws Exception{
		// 인덱스 no 검증(null값 체크)
		if(stray_dto.getStray_no()== null) {
			throw new IllegalStateException("stray_dto 인덱스가 null입니다.");
		}
		
		// 엘라스틱 서치에 저장할 문서 생성
		Map<String,Object> map=new HashMap<>();
		map.put("stray_name",stray_dto.getStray_name());
		map.put("stray_category",stray_dto.getStray_category());
		map.put("stray_gender",stray_dto.getStray_gender());
		map.put("stray_neuter",stray_dto.getStray_neuter());
		map.put("stray_shelter_addr",stray_dto.getStray_shelter_addr());
		
		// IndexRequest(인덱스 요청) 생성하여 저장
		 IndexRequest request = new IndexRequest("dc_stray_animal")
		            .id(String.valueOf(stray_dto.getStray_no()))
		            .source(map);
		
		// 엘라스틱 서치 인덱싱
		client.index(request, RequestOptions.DEFAULT);
		
		// 로그 파일 출력
		System.out.println("dc_stray_animal INDEX NO: "+stray_dto.getStray_no());
		System.out.println("dc_stray_animal INDEX 완료: "+stray_dto.getStray_name());
	}
	
}
