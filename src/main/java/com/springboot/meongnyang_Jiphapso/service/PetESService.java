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

import com.springboot.meongnyang_Jiphapso.dto.PetDTO;

@Service
public class PetESService {
	@Autowired
	private RestHighLevelClient client; // 엘라스틱서치와 자동으로 연결

	public void save(PetDTO pet_dto) throws Exception{
		// 인덱스 no 검증(null값 체크)
		if(pet_dto.getPet_no()==0) {
			throw new IllegalStateException("dc_pet 인덱스가 null입니다.");
		}
		
		// 엘라스틱 서치에 저장할 문서 생성
		Map<String,Object> map=new HashMap<>();
		map.put("pet_name",pet_dto.getPet_name());
		map.put("pet_type",pet_dto.getPet_type());
		map.put("pet_breed",pet_dto.getPet_breed());
		map.put("pet_gender",pet_dto.getPet_gender());
		map.put("pet_neuter",pet_dto.getPet_neuter());
		map.put("pet_weight",pet_dto.getPet_weight());
		
		// IndexRequest(인덱스 요청) 생성하여 저장
		 IndexRequest request = new IndexRequest("dc_pet")
		            .id(String.valueOf(pet_dto.getPet_no()))
		            .source(map);
		
		// 엘라스틱 서치 인덱싱
		client.index(request, RequestOptions.DEFAULT);
		
		// 로그 파일 출력
		System.out.println("dc_pet INDEX NO: "+pet_dto.getPet_no());
		System.out.println("dc_pet INDEX 완료: "+pet_dto.getPet_name());
	}
	
	public List<PetDTO> search(String keyword) throws Exception{
		SearchRequest request=new SearchRequest("dc_pet");
		
		// 엘라스틱 서치에서 검색 요청의 본문을 만드는 객체 생성(SQL의 select문)
		SearchSourceBuilder builder=new SearchSourceBuilder();
		
		// 키워드를 pet_type 필드에서 검색
		builder.query(QueryBuilders.multiMatchQuery(keyword, "pet_type"));
		request.source(builder);
		
		// 엘라스틱 서치에서 검색한 결과를 받아옴
		SearchResponse response=client.search(request, RequestOptions.DEFAULT);
		
		// 검색한 결과 객체를 생성
		List<PetDTO> list=new ArrayList<>();
		
		for(SearchHit hit:response.getHits().getHits()) {
			Map<String,Object> map=hit.getSourceAsMap();
			PetDTO pet_dto=new PetDTO();
			pet_dto.setPet_no(Integer.parseInt(hit.getId()));
			pet_dto.setPet_name(map.get("pet_name").toString());
			pet_dto.setPet_type(map.get("pet_type").toString());
			pet_dto.setPet_breed(map.get("pet_breed").toString());
			pet_dto.setPet_gender(map.get("pet_gender").toString());
			pet_dto.setPet_neuter(map.get("pet_neuter").toString());
			pet_dto.setPet_weight(Float.parseFloat(map.get("pet_weight").toString()));
			list.add(pet_dto);
	}
		return list;
}

	//자동완성 + 화면 하이라이트 기능
	public List<Map<String,String>> autocompleteHighlight(String keyword) throws Exception{
		SearchRequest request=new SearchRequest("dc_pet");
		
		// 엘라스틱 서치에서 검색 요청의 본문을 만드는 객체 생성(SQL의 select문)
		SearchSourceBuilder source=new SearchSourceBuilder();
		source.size(10);
		
		// prefix(접두어) 검색(스 -> 스프 -> 스프링)
		source.query(QueryBuilders.matchPhrasePrefixQuery("pet_name",keyword));
		
		HighlightBuilder highlight=new HighlightBuilder();
		highlight.field(new HighlightBuilder.Field("pet_name")
						.highlightQuery(QueryBuilders.matchPhrasePrefixQuery("pet_name",keyword))
						);
		highlight.preTags("<em>");
		highlight.postTags("</em>");
		
		source.highlighter(highlight);
		request.source(source);
		
		// 엘라스틱 서치에서 검색한 결과를 받아오기
				SearchResponse response=client.search(request, RequestOptions.DEFAULT);
				
				List<Map<String,String>> result=new ArrayList<>();
				
				for(SearchHit hit:response.getHits().getHits()) {
					String pet_name=hit.getSourceAsMap().get("pet_name").toString();
					String highlighted=pet_name;
					
					if(hit.getHighlightFields().get("pet_name")!=null) {
						highlighted=hit.getHighlightFields().get("pet_name").fragments()[0].string();
					}
					
					Map<String,String> map=new HashMap<>();
					map.put("pet_name", pet_name);
					map.put("highlight", highlighted);
					result.add(map);
				}
				
				return result;
			}
			
		}