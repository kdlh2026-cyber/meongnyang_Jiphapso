package com.springboot.meongnyang_Jiphapso.dto;

import lombok.Data;

@Data
public class StraySearchDto {
	private int page = 1;
    private int pageSize = 15;
    private int offset = 0;
    
    private String stray_category;
    private String stray_name;
    private String sido;
    private String gungu;
    private String stray_status;
    private String age_range;
    private String stray_gender;
    private String stray_neuter;

    public int getOffset() {
        return (this.page - 1) * this.pageSize;
    }
}
