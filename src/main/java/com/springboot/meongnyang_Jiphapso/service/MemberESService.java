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
import org.elasticsearch.index.query.MultiMatchQueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.meongnyang_Jiphapso.dto.MemberDTO;

@Service
public class MemberESService {
	@Autowired
	private RestHighLevelClient client;  // 엘라스틱서치와 자동으로 연결
	
	public void save(MemberDTO m_dto) throws Exception{
		// 인덱스 id 검증(null값 체크)
		if(m_dto.getM_id()==null) {
			throw new IllegalStateException("dc_member 인덱스가 null입니다.");
		}
		// 엘라스틱 서치에 저장할 문서 생성
		Map<String,Object> map=new HashMap<>();
		map.put("m_id", m_dto.getM_id());
		map.put("m_name", m_dto.getM_name());
		map.put("m_addr", m_dto.getM_addr());
		map.put("m_email", m_dto.getM_email());
		map.put("m_age_upper", m_dto.getM_age_upper());
		map.put("m_sns", m_dto.getM_sns());
		map.put("m_authority", m_dto.getM_authority());
		
		// IndexRequest(인덱스 요청) 생성하여 저장
		IndexRequest request=new IndexRequest("dc_member").id(m_dto.getM_id().toString()).source(map);
		
		// 엘라스틱 서치 인덱싱
		client.index(request, RequestOptions.DEFAULT);
		
		// 로그 파일 출력
		String id=m_dto.getM_id().toString();
		System.out.println("ES INDEX ID: "+id);
		System.out.println("ES INDEX 완료: "+m_dto.getM_name());
	}
	
	public List<MemberDTO> search(String keyword) throws Exception{
	    SearchRequest request=new SearchRequest("dc_member");
	    
	    SearchSourceBuilder builder=new SearchSourceBuilder();
	    builder.query(QueryBuilders.multiMatchQuery(keyword,"m_id","m_name","m_addr","m_email","m_age_upper","m_sns","m_authority"));
	    request.source(builder);
	    
	    SearchResponse response=client.search(request, RequestOptions.DEFAULT);
	    
	    List<MemberDTO> list=new ArrayList<>();
	    
	    for(SearchHit hit:response.getHits().getHits()) {
	        Map<String,Object> map=hit.getSourceAsMap();
	        MemberDTO m_dto=new MemberDTO();
	        m_dto.setM_id(toStringOrNull(map.get("m_id")));
	        m_dto.setM_name(toStringOrNull(map.get("m_name")));
	        m_dto.setM_addr(toStringOrNull(map.get("m_addr")));
	        m_dto.setM_email(toStringOrNull(map.get("m_email")));
	        m_dto.setM_age_upper(toStringOrNull(map.get("m_age_upper")));
	        m_dto.setM_sns(toStringOrNull(map.get("m_sns")));
	        m_dto.setM_authority(toStringOrNull(map.get("m_authority")));
	        list.add(m_dto);
	    }
	    return list;
	}

	// null이면 null 그대로, 아니면 문자열로 변환하는 헬퍼
	private String toStringOrNull(Object obj) {
	    return obj == null ? null : obj.toString();
	}
	
	// 자동완성 + 화면 하이라이트 기능
	public List<Map<String,String>> autocompleteHighlight(String keyword) throws Exception{
		SearchRequest request=new SearchRequest("dc_member");
		
		// 엘라스틱 서치에서 검색 요청의 본문을 만드는 객체 생성(SQL의 select문)
		SearchSourceBuilder source=new SearchSourceBuilder();
		source.size(10);
		
		// prefix(접두어) 검색(스 -> 스프 -> 스프링)
		source.query(QueryBuilders.multiMatchQuery(keyword, "m_id", "m_name")
                .type(MultiMatchQueryBuilder.Type.PHRASE_PREFIX));
		
		// HighlightBuilder highlight=new HighlightBuilder();
		// highlight.field(new HighlightBuilder.Field("m_id")
		//				.highlightQuery(QueryBuilders.matchPhrasePrefixQuery("m_id",keyword))
		//				);
		// highlight.field("m_name");
		// highlight.preTags("<em>");
		// highlight.postTags("</em>");
		
		// source.highlighter(highlight);
		request.source(source);
		
		// 엘라스틱 서치에서 검색한 결과를 받아오기
		SearchResponse response=client.search(request, RequestOptions.DEFAULT);
		
		List<Map<String,String>> result=new ArrayList<>();
		
		for(SearchHit hit:response.getHits().getHits()) {
			String m_id=hit.getSourceAsMap().get("m_id").toString();
			String m_name=hit.getSourceAsMap().get("m_name").toString();
			String highlighted=m_id;
			
			if(hit.getHighlightFields().get("m_id")!=null) {
				highlighted=hit.getHighlightFields().get("m_id").fragments()[0].string();
			}
			
			else if(hit.getHighlightFields().get("m_name")!=null) {
				highlighted=hit.getHighlightFields().get("m_name").fragments()[0].string();
			}
			
			Map<String,String> map=new HashMap<>();
			map.put("m_id", m_id);
			map.put("m_name", m_name);
			map.put("highlight", highlighted);
			result.add(map);
		}
		
		return result;
	}
}
