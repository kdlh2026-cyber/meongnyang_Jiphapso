package com.springboot.meongnyang_Jiphapso.service;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.meongnyang_Jiphapso.dao.ICommentDAO;
import com.springboot.meongnyang_Jiphapso.dto.CommentDTO;

@Service
public class CommentService {
	@Autowired
	ICommentDAO dao;
	
	@Autowired
	CommentESService esService;

	@Autowired
	private PointService pointService; 
	
	public void write(CommentDTO dto) throws Exception{
		dao.CommentWrite(dto);
		esService.save(dto);
	}
}
