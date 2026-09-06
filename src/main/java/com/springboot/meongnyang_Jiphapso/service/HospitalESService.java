package com.springboot.meongnyang_Jiphapso.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.meongnyang_Jiphapso.dto.HospitalDTO;

@Service
public class HospitalESService {
	@Autowired
	private RestHighLevelClient client;  // 엘라스틱서치와 자동으로 연결
	
	public void save(HospitalDTO hp_dto) throws Exception{
		// 인덱스 id 검증(null값 체크)
		if(hp_dto.getHp_no()==0) {
			throw new IllegalStateException("dc_hspital 인덱스가 null입니다.");
		}
		
		// 엘라스틱 서치에 저장할 문서 생성
		Map<String,Object> map=new HashMap<>();
		map.put("hp_name",hp_dto.getHp_name());
		map.put("hp_addr",hp_dto.getHp_addr());
		map.put("hp_land_addr",hp_dto.getHp_land_addr());
		map.put("hp_sp_clinic",hp_dto.getHp_sp_clinic());
		map.put("hp_keyword",hp_dto.getHp_keyword());
		
		// IndexRequest(인덱스 요청) 생성하여 저장
		IndexRequest request=new IndexRequest("dc_hospital").id(String.valueOf(hp_dto.getHp_no())).source(map);
		
		// 엘라스틱 서치 인덱싱
		client.index(request, RequestOptions.DEFAULT);
		
		// 로그 파일 출력
		System.out.println("dc_hospital INDEX NO: "+ hp_dto.getHp_no());
		System.out.println("dc_hospital INDEX 완료: "+ hp_dto.getHp_name());
	}
	
	public List<HospitalDTO> search(String keyword) throws Exception{
		SearchRequest request=new SearchRequest("dc_hospital");
		
		// 엘라스틱 서치에서 검색 요청의 본문을 만드는 객체 생성(SQL의 select문)
		SearchSourceBuilder builder=new SearchSourceBuilder();
				
		// 키워드를 필드에서 검색
		builder.query(QueryBuilders.multiMatchQuery(keyword, "hp_name","hp_addr","hp_land_addr","hp_sp_clinic","hp_keyword"));
		request.source(builder);
		
		// 엘라스틱 서치에서 검색한 결과를 받아옴
		SearchResponse response=client.search(request, RequestOptions.DEFAULT);
				
		// 검색한 결과 객체를 생성
		List<HospitalDTO> list=new ArrayList<>();
		
		for(SearchHit hit:response.getHits().getHits()) {
			Map<String,Object> map=hit.getSourceAsMap();
			HospitalDTO hp_dto=new HospitalDTO();
			hp_dto.setHp_no(Integer.parseInt(hit.getId()));
			hp_dto.setHp_name(map.get("hp_name").toString());
			hp_dto.setHp_addr(map.get("hp_addr").toString());
			hp_dto.setHp_land_addr(map.get("hp_land_addr").toString());
			hp_dto.setHp_sp_clinic(map.get("hp_sp_clinic").toString());
			hp_dto.setHp_keyword(map.get("hp_keyword").toString());
			list.add(hp_dto);
	}
		return list;
}
	
	// 자동완성 + 화면 하이라이트 기능
		public List<Map<String,String>> autocompleteHighlight(String keyword) throws Exception{
			SearchRequest request=new SearchRequest("dc_hospital");
			
			// 엘라스틱 서치에서 검색 요청의 본문을 만드는 객체 생성(SQL의 select문)
			SearchSourceBuilder source=new SearchSourceBuilder();
			source.size(10);
			
			// prefix(접두어) 검색(스 -> 스프 -> 스프링)
			source.query(QueryBuilders.matchPhrasePrefixQuery("hp_name",keyword));
			
			HighlightBuilder highlight=new HighlightBuilder();
			highlight.field(new HighlightBuilder.Field("hp_name")
							.highlightQuery(QueryBuilders.matchPhrasePrefixQuery("hp_name",keyword))
							);
			highlight.preTags("<em>");
			highlight.postTags("</em>");
			
			source.highlighter(highlight);
			request.source(source);
			
			// 엘라스틱 서치에서 검색한 결과를 받아오기
			SearchResponse response=client.search(request, RequestOptions.DEFAULT);
			
			List<Map<String,String>> result=new ArrayList<>();
			
			for(SearchHit hit:response.getHits().getHits()) {
				String hp_name=hit.getSourceAsMap().get("hp_name").toString();
				String highlighted=hp_name;
				
				if(hit.getHighlightFields().get("hp_name")!=null) {
					highlighted=hit.getHighlightFields().get("hp_name").fragments()[0].string();
				}
				
				Map<String,String> map=new HashMap<>();
				map.put("hp_name", hp_name);
				map.put("highlight", highlighted);
				result.add(map);
			}
			
			return result;
		}
		
	}