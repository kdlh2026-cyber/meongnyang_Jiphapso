package com.springboot.meongnyang_Jiphapso.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springboot.meongnyang_Jiphapso.dao.IStrayAnimalDao;
import com.springboot.meongnyang_Jiphapso.dto.StrayAnimalDto;

@Service
public class StrayService {
    @Autowired
    private IStrayAnimalDao stray_dao;
    
    @Autowired
    private StrayESService stray_esservice;
    
    public void stray_write(StrayAnimalDto stray_dto) throws Exception {
        stray_dao.StrayAnimalWrite(stray_dto);
        stray_esservice.stray_save(stray_dto); // 엘라스틱서치 색인
    }
    public void stray_update(StrayAnimalDto stray_dto) throws Exception {
        stray_dao.StrayAnimalUpdate(stray_dto);
        stray_esservice.stray_update(stray_dto); // 엘라스틱서치 색인
    }
    public void stray_delete(Long stray_no) throws Exception {
    	stray_dao.StrayAnimalDelete(stray_no);
        stray_esservice.stray_delete(stray_no); // 엘라스틱서치 색인
    }
    
    public List<StrayAnimalDto> stray_list() {
        return stray_dao.stray_list();
    }
    
    public List<String> getListCategory(String stray_category) {
        return stray_dao.getListCategory(stray_category);
    }
}