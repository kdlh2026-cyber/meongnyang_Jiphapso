package com.springboot.meongnyang_Jiphapso.service;

import java.util.HashMap;
import java.util.Map;

import org.elasticsearch.ElasticsearchException;
import org.elasticsearch.action.delete.DeleteRequest;
import org.elasticsearch.action.delete.DeleteResponse;
import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.action.update.UpdateRequest;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.rest.RestStatus;
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
	
	public void stray_update(StrayAnimalDto stray_dto) throws Exception{
		if (stray_dto.getStray_no() == 0) {
	        throw new IllegalStateException("stray_dto 인덱스가 null입니다.");
	    }

	    Map<String, Object> map = new HashMap<>();
	    if (stray_dto.getStray_name() != null) map.put("stray_name", stray_dto.getStray_name());
	    if (stray_dto.getStray_category() != null) map.put("stray_category", stray_dto.getStray_category());
	    if (stray_dto.getStray_gender() != null) map.put("stray_gender", stray_dto.getStray_gender());
	    if (stray_dto.getStray_neuter() != null) map.put("stray_neuter", stray_dto.getStray_neuter());
	    if (stray_dto.getStray_shelter_addr() != null) map.put("stray_shelter_addr", stray_dto.getStray_shelter_addr());

	    // UpdateRequest 생성
	    UpdateRequest request = new UpdateRequest("dc_stray_animal", String.valueOf(stray_dto.getStray_no()))
	            .doc(map)
	            .docAsUpsert(true); // 만약 문서가 없으면 새로 insert

	    // 업데이트 요청 실행
	    client.update(request, RequestOptions.DEFAULT);

	    System.out.println("dc_stray_animal UPDATE 완료 " + stray_dto.getStray_no());
	}
	
	public void stray_delete(Long stray_no) throws Exception{
		if (stray_no == 0) {
	        throw new IllegalStateException("삭제할 dc_stray_animal 번호가 올바르지 않습니다.");
	    }

	    try {
	        DeleteRequest request = new DeleteRequest("dc_stray_animal", String.valueOf(stray_no));
	        //  엘라스틱 서치 삭제 요청 실행
	        DeleteResponse response = client.delete(request, RequestOptions.DEFAULT);

	        // 결과 확인 및 로그 출력
	        if (response.getResult() == org.elasticsearch.action.DocWriteResponse.Result.DELETED) {
	            System.out.println("dc_stray_animal DELETE 완료 " + stray_no);
	        } else if (response.getResult() == org.elasticsearch.action.DocWriteResponse.Result.NOT_FOUND) {
	            System.out.println("dc_stray_animal 해당 ID가 존재하지 않아 삭제되지 않았습니다 " + stray_no);
	        }

	    } catch (ElasticsearchException e) {
	        // 인덱스가 없거나 404 상태코드 등 에러 발생 시 처리
	        if (e.status() == RestStatus.NOT_FOUND) {
	            System.out.println("dc_stray_animal 문서가 존재하지 않습니다 " + stray_no);
	        } else {
	            throw e;
	        }
	    }
	}
	
}
