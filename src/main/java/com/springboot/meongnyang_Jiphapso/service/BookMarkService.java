package com.springboot.meongnyang_Jiphapso.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.meongnyang_Jiphapso.dao.IBookMarkDAO;
import com.springboot.meongnyang_Jiphapso.dto.BookmarkDTO;
import com.springboot.meongnyang_Jiphapso.dto.CommunityDTO;

@Service
public class BookMarkService {
	@Autowired
    IBookMarkDAO dao;

	public String toggleBookmark(int comm_no, int m_no) {
        int count = dao.checkBookMark(comm_no, m_no);
        
        if (count > 0) {
            dao.deleteBookMark(comm_no, m_no);
            return "DELETED";
        } else {
            BookmarkDTO dto = new BookmarkDTO();
            dto.setComm_no(comm_no);
            dto.setM_no(m_no);
            dao.insertBookMark(dto);
            return "ADDED";
        }
    }
	
	public boolean isBookmarked(int comm_no, int m_no) {
        return dao.checkBookMark(comm_no, m_no) > 0;
    }
	
	public List<CommunityDTO> getBookmarksByMemberNo(int m_no) {
        return dao.selectBookmarksByMemberNo(m_no);
    }
}
