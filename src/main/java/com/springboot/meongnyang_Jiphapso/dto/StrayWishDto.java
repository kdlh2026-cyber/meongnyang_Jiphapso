package com.springboot.meongnyang_Jiphapso.dto;

import lombok.Data;

@Data
public class StrayWishDto {
	private Long wish_no;
	private Integer m_no;
    private String wish_guest_id;
    private Long stray_no;
    
    private int is_wished;

}
