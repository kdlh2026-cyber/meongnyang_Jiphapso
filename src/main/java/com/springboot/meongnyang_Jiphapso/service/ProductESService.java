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

import com.springboot.meongnyang_Jiphapso.dao.IProductDao;
import com.springboot.meongnyang_Jiphapso.dto.ProductDto;
import com.springboot.meongnyang_Jiphapso.dto.ShoppingListDto;

@Service
public class ProductESService {
	@Autowired
	private RestHighLevelClient client; // 엘라스틱서치와 자동으로 연결
	@Autowired
	IProductDao p_dao;
	

	public void save(ProductDto p_dto) throws Exception{
		// 인덱스 no 검증(null값 체크)
		if(p_dto.getP_no()==0) {
			throw new IllegalStateException("dc_product 인덱스가 null입니다.");
		}
		
		// 엘라스틱 서치에 저장할 문서 생성
		Map<String,Object> map=new HashMap<>();
		map.put("p_title",p_dto.getP_title());
		map.put("p_brand",p_dto.getP_brand());
		map.put("p_category",p_dto.getP_category());
		
		// IndexRequest(인덱스 요청) 생성하여 저장
		 IndexRequest request = new IndexRequest("dc_product")
		            .id(String.valueOf(p_dto.getP_no()))
		            .source(map);
		
		// 엘라스틱 서치 인덱싱
		client.index(request, RequestOptions.DEFAULT);
		
		// 로그 파일 출력
		System.out.println("dc_product INDEX NO: "+p_dto.getP_no());
		System.out.println("dc_product INDEX 완료: "+p_dto.getP_title());
	}
	
	public List<ShoppingListDto> search(String keyword) throws Exception{
		SearchRequest request=new SearchRequest("dc_product");
		
		// 엘라스틱 서치에서 검색 요청의 본문을 만드는 객체 생성(SQL의 select문)
		SearchSourceBuilder builder=new SearchSourceBuilder();
		
		// 키워드를 p_title 필드에서 검색
		builder.query(QueryBuilders.multiMatchQuery(keyword, "p_title"));
		request.source(builder);
		
		// 엘라스틱 서치에서 검색한 결과를 받아옴
		SearchResponse response=client.search(request, RequestOptions.DEFAULT);
		
		// 검색한 결과 객체를 생성
		List<Integer> pnoList = new ArrayList<>();
	    
	    for (SearchHit hit : response.getHits().getHits()) {
	        pnoList.add(Integer.parseInt(hit.getId())); 
	    }
	    
	    if (pnoList.isEmpty()) {
	        return new ArrayList<>();
	    }
	    
	    // 3. DB에 pno 리스트를 던져서 상품의 모든 상세 정보를 가져옴
	    return p_dao.searchList(pnoList);
	}

	//자동완성 + 화면 하이라이트 기능
	public List<Map<String,String>> autocompleteHighlight(String keyword) throws Exception{
		SearchRequest request=new SearchRequest("dc_product");
		
		// 엘라스틱 서치에서 검색 요청의 본문을 만드는 객체 생성(SQL의 select문)
		SearchSourceBuilder source=new SearchSourceBuilder();
		source.size(10);
		
		// prefix(접두어) 검색(스 -> 스프 -> 스프링)
		source.query(QueryBuilders.matchPhrasePrefixQuery("p_title",keyword));
		
		HighlightBuilder highlight=new HighlightBuilder();
		highlight.field(new HighlightBuilder.Field("p_title")
						.highlightQuery(QueryBuilders.matchPhrasePrefixQuery("p_title",keyword))
						);
		highlight.preTags("<em>");
		highlight.postTags("</em>");
		
		source.highlighter(highlight);
		request.source(source);
		
		// 엘라스틱 서치에서 검색한 결과를 받아오기
		SearchResponse response=client.search(request, RequestOptions.DEFAULT);
				
		List<Map<String,String>> result=new ArrayList<>();
				
		for(SearchHit hit:response.getHits().getHits()) {
			String p_title=hit.getSourceAsMap().get("p_title").toString();
			String highlighted=p_title;
					
			if(hit.getHighlightFields().get("p_title")!=null) {
				highlighted=hit.getHighlightFields().get("p_title").fragments()[0].string();
			}
					
			Map<String,String> map=new HashMap<>();
			map.put("p_title", p_title);
			map.put("highlight", highlighted);
			result.add(map);
			}
				
			return result;
	}	
}