package com.springboot.meongnyang_Jiphapso.service;

import java.util.HashMap;
import java.util.Map;

import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.meongnyang_Jiphapso.dto.CommentDTO;

@Service
public class CommentESService {
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
		
	public void save(CommentDTO dto) throws Exception{
	    // 인덱스 no 검증 (null 체크)
	    if(dto.getCmt_no() == null) {
	        throw new IllegalStateException("Comment 인덱스가 null입니다.");
	    }
		    
		// 엘라스틱 서치에 저장할 문서 생성
	    Map<String, Object> map = new HashMap<>();
	    map.put("cmt_no", dto.getCmt_no());
	    map.put("cmt_answer_no", dto.getCmt_answer_no());
	    map.put("cmt_type", dto.getCmt_type());
	    map.put("cmt_type_no", dto.getCmt_type_no());
	    map.put("cmt_writer", dto.getCmt_writer());
	    map.put("cmt_content", dto.getCmt_content());
	    map.put("cmt_date", dto.getCmt_date());
	    map.put("m_no", dto.getM_no());
	    
	    // IndexReqeust 생성해서 저장 [핵심]
	    IndexRequest request = new IndexRequest("dc_comment").id(dto.getCmt_no().toString()).source(map);
		    
		// 엘라스틱 서치 인덱싱 [핵심]
		client.index(request, RequestOptions.DEFAULT);
		    
		// 로그
		String cmt_no = dto.getCmt_no().toString();
		System.out.println("ES INDEX 게시글 번호 : " + cmt_no);
		System.out.println("ES INDEX 완료 : " + dto.getCmt_answer_no());
	}
}
