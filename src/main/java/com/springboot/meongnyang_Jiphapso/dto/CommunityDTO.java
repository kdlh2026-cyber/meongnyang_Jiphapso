package com.springboot.meongnyang_Jiphapso.dto;

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class CommunityDTO {
	private Integer comm_no;
	private String comm_type;
	private String comm_title;
	private String comm_writer;
	private String comm_content;
	private String comm_category;
	private String comm_pet_type;
	private Integer comm_score;
	private String comm_breed;
	private String comm_img;
	private String comm_video;
	
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date comm_date;
	
	private Integer comm_count;
	private Integer comm_view;
	private Integer comm_good;
	private Integer comm_well;
	private String comm_tag;
	private Integer m_no;
	private Integer p_no;
	private Integer pet_no;
	
	//이미지 테이블과 연동
	private String img_url;
	
	private List<String> img_url_list;
	
	private Integer reply_count;
	
}
