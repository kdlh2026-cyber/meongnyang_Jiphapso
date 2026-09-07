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

import com.springboot.meongnyang_Jiphapso.dto.CommunityDTO;

@Service
public class CommunityESService {
	@Autowired
	private RestHighLevelClient client;
	
	public void save(CommunityDTO dto) throws Exception{
		// 인덱스 no 검증 (null 체크)
		if(dto.getComm_no() == null) {
			throw new IllegalStateException("Community 인덱스가 null입니다.");
		}
		
		// 엘라스틱 서치에 저장할 문서 생성
		Map<String, Object> map = new HashMap<>();
		map.put("comm_no",dto.getComm_no());
		map.put("comm_type", dto.getComm_type());
		map.put("comm_title", dto.getComm_title());
		map.put("comm_writer", dto.getComm_writer());
		map.put("comm_content", dto.getComm_content());
		map.put("comm_category", dto.getComm_category());
		map.put("comm_pet_type", dto.getComm_pet_type());
		map.put("comm_score", dto.getComm_score());
		map.put("comm_breed", dto.getComm_breed());
		map.put("comm_img", dto.getComm_img());
		map.put("comm_date", dto.getComm_date());
		map.put("comm_count", dto.getComm_count());
		map.put("comm_view", dto.getComm_view());
		map.put("comm_good", dto.getComm_good());
		map.put("comm_well", dto.getComm_well());
		map.put("comm_tag", dto.getComm_tag());
		map.put("m_no", dto.getM_no());
		map.put("p_no", dto.getP_no());
		map.put("pet_no", dto.getPet_no());
		
		// IndexReqeust 생성해서 저장 [핵심]
		IndexRequest request = new IndexRequest("dc_community").id(dto.getComm_no().toString()).source(map);
		
		// 엘라스틱 서치 인덱싱 [핵심]
		client.index(request, RequestOptions.DEFAULT);
		
		// 로그
		String comm_no = dto.getComm_no().toString();
		System.out.println("ES INDEX 게시글 번호 : " + comm_no);
		System.out.println("ES INDEX 완료 : " + dto.getComm_title());
	}
	
	public List<CommunityDTO> search(String keyword) throws Exception{
		SearchRequest request = new SearchRequest("dc_community");
		
		// 엘라스틱 서치에서 검색 요청의 본문을 만드는 객체 생성 (SQL의 select 문)
		SearchSourceBuilder builder = new SearchSourceBuilder();
		
		// 키워드를 title 또는 content 필드에서 검색
		//builder.query(QueryBuilders.multiMatchQuery(keyword, "title","content").operator(Operator.AND));
		//builder.query(QueryBuilders.multiMatchQuery(keyword, "title","content").operator(Operator.OR));
		builder.query(QueryBuilders.multiMatchQuery(keyword, "comm_title","comm_content"));
		request.source(builder);
		
		// 엘라스틱 서치에서 검색한 결과를 받아온다.
		SearchResponse response = client.search(request, RequestOptions.DEFAULT);
		
		// 검색한 결과 객체를 생성
		List<CommunityDTO> list = new ArrayList<>();
		
		// 출력
		for(SearchHit hit:response.getHits().getHits()) {
			Map<String, Object> map = hit.getSourceAsMap();
			CommunityDTO dto = new CommunityDTO();
			dto.setComm_no(Integer.parseInt(map.get("comm_no").toString()));
			dto.setComm_title(map.get("comm_title").toString());
			dto.setComm_content(map.get("comm_content").toString());
			dto.setComm_writer(map.get("comm_writer").toString());
			dto.setComm_type(map.get("comm_type").toString());
			dto.setComm_pet_type(map.get("comm_pet_type").toString());
			dto.setComm_breed(map.get("comm_breed").toString());
			dto.setComm_count(Integer.parseInt(map.get("comm_count").toString()));
			dto.setComm_tag(map.get("comm_tag").toString());
			dto.setComm_img(map.get("comm_img").toString());
			list.add(dto);
		}
		
		return list;
	}
	
	// 자동완성 + 하이라이트
	public List<Map<String,String>> autocompleteHighlight(String keyword) throws Exception{
		SearchRequest request = new SearchRequest("dc_community");
		
		// 엘라스틱 서치에서 검색 요청의 본문을 만드는 객체 생성 (SQL의 select 문)
		SearchSourceBuilder source = new SearchSourceBuilder();
		source.size(10);
		
		// prefix(접두어)로 검색 ('스' -> 스프 -> 스프링)
		source.query(QueryBuilders.matchPhrasePrefixQuery("comm_title", keyword));
		
		HighlightBuilder highlight = new HighlightBuilder();
		highlight.field(new HighlightBuilder.Field("comm_title")
							.highlightQuery(QueryBuilders.matchPhrasePrefixQuery("comm_title", keyword))
						);
		highlight.preTags("<em>");
		highlight.postTags("</em>");
		
		source.highlighter(highlight);
		request.source(source);
		
		// 엘라스틱 서치에서 검색한 결과를 받아온다.
		SearchResponse response = client.search(request, RequestOptions.DEFAULT);
		
		List<Map<String,String>> result = new ArrayList<>();
		
		for(SearchHit hit:response.getHits().getHits()) {
			String title = hit.getSourceAsMap().get("comm_title").toString();
			String highlighted = title;
			
			if(hit.getHighlightFields().get("comm_title") != null) {
				highlighted = hit.getHighlightFields().get("comm_title").fragments()[0].string();
			}
			
			Map<String,String> map = new HashMap<>();
			map.put("title", title);
			map.put("highlight", highlighted);
			result.add(map);
		}
		
		return result;
	}
}

