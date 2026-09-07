package com.springboot.meongnyang_Jiphapso.dto;

import java.util.Date;

import lombok.Data;

@Data
public class CommentDTO {
	private int cmt_no;
	private int cmt_answer_no;
	private String cmt_writer;
	private String cmt_type;
	private int cmt_type_no;
	private String cmt_content;
	private int cmt_good;
	private String cmt_choice;
	private String cmt_img;
	private Date cmt_date;
	private int m_no;
}
