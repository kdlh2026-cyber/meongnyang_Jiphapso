package com.springboot.meongnyang_Jiphapso.dto;

import java.util.Date;

import lombok.Data;

@Data
public class CommentDTO {
	private Integer cmt_no;
	private Integer cmt_answer_no;
	private String cmt_writer;
	private String cmt_type;
	private Integer  cmt_type_no;
	private String cmt_content;
	private Integer  cmt_good;
	private String cmt_choice;
	private String cmt_img;
	private Date cmt_date;
	private Integer m_no;
	
	private String comm_img;
	private String comm_title;
	private Integer comment_count;
	private String comm_type;
}
