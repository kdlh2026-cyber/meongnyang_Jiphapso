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

import com.springboot.meongnyang_Jiphapso.dto.DailycheckDTO;

@Service
public class DailycheckESService {
	@Autowired
	private RestHighLevelClient client;  // 엘라스틱 서치와 자동으로 연결
	
	public void save(DailycheckDTO ch_dto) throws Exception{
		// 인덱스 id 검증(null값 체크)
		if(ch_dto.getCh_no()==0) {
			throw new IllegalStateException("dc_dailycheck 인덱스가 없습니다.");
		}
		
		// 엘라스틱서치에 저장할 문서 생성
		Map<String,Object> map=new HashMap<>();
		map.put("ch_count", ch_dto.getCh_count());
		map.put("ch_year_month",ch_dto.getCh_year_month());
		map.put("ch_point_quentity",ch_dto.getCh_point_quentity());
		
		// IndexRequest(인덱스 요청) 생성하여 저장
		IndexRequest request=new IndexRequest("dc_dailycheck").id(String.valueOf(ch_dto.getCh_no())).source(map);
		
		// 엘라스틱 서치 인덱싱
		client.index(request, RequestOptions.DEFAULT);
		
		// 로그 파일 출력
		System.out.println("dc_dailycheck INDEX NO: "+ch_dto.getCh_no());
		System.out.println("dc_dailycheck INDEX 완료: "+ ch_dto.getCh_year_month());
	}
	
	public List<DailycheckDTO> search(String keyword) throws Exception{
		SearchRequest request=new SearchRequest("dc_dailycheck");
		
		// 엘라스틱 서치에서 검색 요청의 본문을 만드는 객체 생성(SQL의 select문)
		SearchSourceBuilder builder=new SearchSourceBuilder();
				
		// 키워드를 title 또는(OR) content 필드에서 검색
		builder.query(QueryBuilders.multiMatchQuery(keyword,"ch_count","ch_year_month","ch_point_quentity"));
		request.source(builder);
		
		// 엘라스틱서치에서 검색한 결과를 받아옴
		SearchResponse response=client.search(request, RequestOptions.DEFAULT);
		
		// 검색한 결과 객체 생성
		List<DailycheckDTO> list=new ArrayList<>();
		
		for(SearchHit hit:response.getHits().getHits()) {
			Map<String,Object> map=hit.getSourceAsMap();
			DailycheckDTO ch_dto=new DailycheckDTO();
			ch_dto.setCh_no(Integer.parseInt(hit.getId()));
			ch_dto.setCh_count(Integer.parseInt(map.get("ch_count").toString()));
			ch_dto.setCh_year_month(map.get("ch_year_month").toString());
			ch_dto.setCh_point_quentity(Integer.parseInt(map.get("ch_point_quentity").toString()));
			list.add(ch_dto);
	}
		return list;
}
	
	// 자동완성 + 화면 하이라이트 기능
		public List<Map<String,String>> autocompleteHighlight(String keyword) throws Exception{
			SearchRequest request=new SearchRequest("dc_dailycheck");
			
			// 엘라스틱 서치에서 검색 요청의 본문을 만드는 객체 생성(SQL의 select문)
			SearchSourceBuilder source=new SearchSourceBuilder();
			source.size(10);
			
			// prefix(접두어) 검색(스 -> 스프 -> 스프링)
			source.query(QueryBuilders.matchPhrasePrefixQuery("ch_count",keyword));
			
			HighlightBuilder highlight=new HighlightBuilder();
			highlight.field(new HighlightBuilder.Field("ch_count")
							.highlightQuery(QueryBuilders.matchPhrasePrefixQuery("ch_count",keyword))
							);
			highlight.preTags("<em>");
			highlight.postTags("</em>");
			
			source.highlighter(highlight);
			request.source(source);
			
			// 엘라스틱 서치에서 검색한 결과를 받아오기
			SearchResponse response=client.search(request, RequestOptions.DEFAULT);
			
			List<Map<String,String>> result=new ArrayList<>();
			
			for(SearchHit hit:response.getHits().getHits()) {
				String ch_count=hit.getSourceAsMap().get("ch_count").toString();
				String highlighted=ch_count;
				
				if(hit.getHighlightFields().get("ch_count")!=null) {
					highlighted=hit.getHighlightFields().get("ch_count").fragments()[0].string();
				}
				
				Map<String,String> map=new HashMap<>();
				map.put("ch_count",ch_count);
				map.put("highlight", highlighted);
				result.add(map);
			}
			
			return result;
		}
		
	}	
