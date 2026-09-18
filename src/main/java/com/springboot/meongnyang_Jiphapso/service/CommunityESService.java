package com.springboot.meongnyang_Jiphapso.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.elasticsearch.action.bulk.BulkRequest;
import org.elasticsearch.action.delete.DeleteRequest;
import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.index.query.BoolQueryBuilder;
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
	
	// map에서 문자열 필드를 안전하게 꺼낸다. 값이 없으면 빈 문자열.
	private String getStr(Map<String, Object> map, String key) {
	    Object value = map.get(key);
	    return (value == null) ? "" : value.toString();
	}

	// map에서 숫자 필드를 안전하게 꺼낸다. 값이 없거나 파싱 실패하면 기본값.
	private int getInt(Map<String, Object> map, String key, int defaultValue) {
	    Object value = map.get(key);
	    if (value == null) {
	        return defaultValue;
	    }
	    try {
	        return Integer.parseInt(value.toString());
	    } catch (NumberFormatException e) {
	        return defaultValue;
	    }
	}
	
	public void save(CommunityDTO dto) throws Exception{
	    // 인덱스 no 검증 (null 체크)
	    if(dto.getComm_no() == null) {
	        throw new IllegalStateException("Community 인덱스가 null입니다.");
	    }
	    
	    // 엘라스틱 서치에 저장할 문서 생성
	    Map<String, Object> map = new HashMap<>();
	    map.put("comm_no", dto.getComm_no());
	    map.put("comm_type", nullToEmpty(dto.getComm_type()));
	    map.put("comm_title", nullToEmpty(dto.getComm_title()));
	    map.put("comm_writer", nullToEmpty(dto.getComm_writer()));
	    map.put("comm_content", nullToEmpty(dto.getComm_content()));
	    map.put("comm_category", nullToEmpty(dto.getComm_category()));
	    map.put("comm_pet_type", nullToEmpty(dto.getComm_pet_type()));
	    map.put("comm_score", dto.getComm_score() != null ? dto.getComm_score() : 0f);
	    map.put("comm_breed", nullToEmpty(dto.getComm_breed()));
	    map.put("comm_img", nullToEmpty(dto.getComm_img()));
	    map.put("comm_video", nullToEmpty(dto.getComm_video())); 
	    map.put("comm_adpick", nullToEmpty(dto.getComm_adpick()));    
	    map.put("comm_detail", nullToEmpty(dto.getComm_detail()));
	    map.put("comm_date", dto.getComm_date());
	    map.put("comm_count", dto.getComm_count() != null ? dto.getComm_count() : 0);
	    map.put("comm_view", dto.getComm_view() != null ? dto.getComm_view() : 0);
	    map.put("comm_good", dto.getComm_good() != null ? dto.getComm_good() : 0);
	    map.put("comm_well", dto.getComm_well() != null ? dto.getComm_well() : 0);
	    map.put("comm_tag", nullToEmpty(dto.getComm_tag()));
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

	// null이면 빈 문자열로 치환
	private String nullToEmpty(String value) {
	    return (value == null) ? "" : value;
	}
	
	// 검색
	public Map<String, Object> search(String keyword, int page, int pageSize) throws Exception {
	    SearchRequest request = new SearchRequest("dc_community");
	    SearchSourceBuilder builder = new SearchSourceBuilder();

	    builder.query(QueryBuilders.multiMatchQuery(keyword, "comm_title", "comm_content"));
	    builder.from((page - 1) * pageSize);
	    builder.size(pageSize);
	    builder.trackTotalHits(true); // 10,000건 넘어가도 정확한 카운트 필요하면 필수

	    request.source(builder);
	    SearchResponse response = client.search(request, RequestOptions.DEFAULT);

	    List<CommunityDTO> list = new ArrayList<>();
		
		// 출력
		for(SearchHit hit:response.getHits().getHits()) {
		    Map<String, Object> map = hit.getSourceAsMap();
		    CommunityDTO dto = new CommunityDTO();
		    dto.setComm_no(getInt(map, "comm_no", 0));
		    dto.setComm_title(getStr(map, "comm_title"));
		    dto.setComm_content(getStr(map, "comm_content"));
		    dto.setComm_writer(getStr(map, "comm_writer"));
		    dto.setComm_type(getStr(map, "comm_type"));
		    dto.setComm_pet_type(getStr(map, "comm_pet_type"));
		    dto.setComm_breed(getStr(map, "comm_breed"));
		    dto.setComm_count(getInt(map, "comm_count", 0));
		    dto.setComm_tag(getStr(map, "comm_tag"));
		    dto.setComm_img(getStr(map, "comm_img"));
		    list.add(dto);
		}
		
		Map<String, Object> result = new HashMap<>();
	    result.put("list", list);
	    result.put("totalCount", response.getHits().getTotalHits().value);
	    return result;
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
	
	// CommunityESService
	public Map<String, Object> adminSearchCommunity(String comm_type, String comm_pet_type, String comm_category,
										            String searchType, String keyword, String sort,
										            int page, int size) throws Exception {
	    SearchRequest request = new SearchRequest("dc_community");
	    SearchSourceBuilder source = new SearchSourceBuilder();
	    
	    source.from((page - 1) * size);
	    source.size(size);
	    source.trackTotalHits(true);
	    
	    // 2. 검색 조건(Query) 설정
	    if (keyword != null && !keyword.trim().isEmpty()) {
	        if ("title".equals(searchType)) {
	            source.query(QueryBuilders.matchQuery("comm_title", keyword));
	        } else if ("writer".equals(searchType)) {
	            source.query(QueryBuilders.matchQuery("comm_writer", keyword));
	        } else if ("category".equals(searchType)) {
	            // 콘텐츠는 comm_category, 그 외(Q&A/라운지)는 comm_pet_type을 완전일치로 검색
	            BoolQueryBuilder categoryQuery = QueryBuilders.boolQuery()
	                .should(QueryBuilders.boolQuery()
	                    .must(QueryBuilders.termQuery("comm_type", "콘텐츠"))
	                    .must(QueryBuilders.termQuery("comm_category.keyword", keyword)))
	                .should(QueryBuilders.boolQuery()
	                    .mustNot(QueryBuilders.termQuery("comm_type", "콘텐츠"))
	                    .must(QueryBuilders.termQuery("comm_pet_type", keyword)));
	            source.query(categoryQuery);
	        } else {
	            // 통합검색(else): 제목, 내용, 작성자
	            source.query(QueryBuilders.multiMatchQuery(keyword, "comm_title", "comm_content", "comm_writer"));
	        }
	    }
	    
	    // 3. 정렬 설정 (최신순 vs 인기순)
	    if ("popular".equals(sort)) {
	        source.sort("comm_good", org.elasticsearch.search.sort.SortOrder.DESC);
	        source.sort("comm_view", org.elasticsearch.search.sort.SortOrder.DESC);
	    } else {
	        source.sort("comm_date", org.elasticsearch.search.sort.SortOrder.DESC);
	    }
	    
	    // 4. 하이라이트 기능 필요시 유지
	    HighlightBuilder highlight = new HighlightBuilder();
	    highlight.field(new HighlightBuilder.Field("comm_title"));
	    highlight.preTags("<span style='color:red;'>");
	    highlight.postTags("</span>");
	    source.highlighter(highlight);
	    
	    request.source(source);
	    SearchResponse response = client.search(request, RequestOptions.DEFAULT);
	    
	    List<Map<String, Object>> list = new ArrayList<>();
	    
	    for (SearchHit hit : response.getHits().getHits()) {
	        Map<String, Object> sourceMap = hit.getSourceAsMap();
	        
	        // 필요한 경우 하이라이트 결과 덮어쓰기
	        if (hit.getHighlightFields().get("comm_title") != null) {
	            String highlightedTitle = hit.getHighlightFields().get("comm_title").fragments()[0].string();
	            sourceMap.put("comm_title_hl", highlightedTitle); // 하이라이트된 제목 별도 저장
	        }
	        
	        list.add(sourceMap);
	    }
	    
	    Map<String, Object> result = new HashMap<>();
	    result.put("list", list);
	    result.put("totalCount", response.getHits().getTotalHits().value);
	    return result;
	}
	
	// 삭제 메서드 추가
	public void delete(int comm_no) throws Exception {
	    DeleteRequest request = new DeleteRequest("dc_community", String.valueOf(comm_no));
	    client.delete(request, RequestOptions.DEFAULT);
	}
	
	// 업데이트
	public void update(CommunityDTO dto) throws Exception {
	    save(dto); // ES는 IndexRequest.id()로 upsert 동작하므로 save 재사용으로 충분
	}
	
	//재색인
	public void bulkSave(List<CommunityDTO> list) throws Exception {
	    BulkRequest bulkRequest = new BulkRequest();

	    for (CommunityDTO dto : list) {
	        if (dto.getComm_no() == null) continue;

	        Map<String, Object> map = new HashMap<>();
	        map.put("comm_no", dto.getComm_no());
	        map.put("comm_type", nullToEmpty(dto.getComm_type()));
	        map.put("comm_title", nullToEmpty(dto.getComm_title()));
	        map.put("comm_writer", nullToEmpty(dto.getComm_writer()));
	        map.put("comm_content", nullToEmpty(dto.getComm_content()));
	        map.put("comm_category", nullToEmpty(dto.getComm_category()));
	        map.put("comm_pet_type", nullToEmpty(dto.getComm_pet_type()));
	        map.put("comm_score", dto.getComm_score() != null ? dto.getComm_score() : 0f);
	        map.put("comm_breed", nullToEmpty(dto.getComm_breed()));
	        map.put("comm_img", nullToEmpty(dto.getComm_img()));
	        map.put("comm_video", nullToEmpty(dto.getComm_video()));
	        map.put("comm_adpick", nullToEmpty(dto.getComm_adpick()));
	        map.put("comm_detail", nullToEmpty(dto.getComm_detail()));
	        map.put("comm_date", dto.getComm_date());
	        map.put("comm_count", dto.getComm_count() != null ? dto.getComm_count() : 0);
	        map.put("comm_view", dto.getComm_view() != null ? dto.getComm_view() : 0);
	        map.put("comm_good", dto.getComm_good() != null ? dto.getComm_good() : 0);
	        map.put("comm_well", dto.getComm_well() != null ? dto.getComm_well() : 0);
	        map.put("comm_tag", nullToEmpty(dto.getComm_tag()));
	        map.put("m_no", dto.getM_no());
	        map.put("p_no", dto.getP_no());
	        map.put("pet_no", dto.getPet_no());

	        bulkRequest.add(new IndexRequest("dc_community")
	                .id(dto.getComm_no().toString())
	                .source(map));
	    }

	    client.bulk(bulkRequest, RequestOptions.DEFAULT);
	}
}