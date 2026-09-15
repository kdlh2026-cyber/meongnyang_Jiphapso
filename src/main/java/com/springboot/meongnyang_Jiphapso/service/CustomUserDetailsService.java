package com.springboot.meongnyang_Jiphapso.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.springboot.meongnyang_Jiphapso.dao.IMemberDAO;
import com.springboot.meongnyang_Jiphapso.dto.MemberDTO;

@Service
public class CustomUserDetailsService implements UserDetailsService{
	@Autowired
	private IMemberDAO m_dao;
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException{
		MemberDTO m_dto = m_dao.MemberFindId(username);
		
		if(m_dto==null) {
			throw new UsernameNotFoundException("사용자가 없습니다");
		}
		
		if("WITHDRAWN".equals(m_dto.getM_authority())) {
			throw new UsernameNotFoundException("탈퇴한 회원입니다.");
		}
		
		return User.builder()
				   .username(m_dto.getM_id())
				   .password(m_dto.getM_passwd())
				   .roles(m_dto.getM_authority())
				   .build();
	}
}
