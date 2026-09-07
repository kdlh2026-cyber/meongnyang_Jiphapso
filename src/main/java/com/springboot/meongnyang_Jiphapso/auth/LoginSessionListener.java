package com.springboot.meongnyang_Jiphapso.auth;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.security.authentication.event.AuthenticationSuccessEvent;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.springboot.meongnyang_Jiphapso.common.SessionConst;
import com.springboot.meongnyang_Jiphapso.dao.IMemberDAO;
import com.springboot.meongnyang_Jiphapso.dto.MemberDTO;

import jakarta.servlet.http.HttpSession;

// 로그인 성공 이벤트를 감지해서 세션에 회원번호(m_no)를 저장함
// WebSecurityConfig의 formLogin(defaultSuccessUrl 등) 설정은 그대로 둬도 됨 - 얘랑 안 겹침
@Component
public class LoginSessionListener implements ApplicationListener<AuthenticationSuccessEvent> {

    @Autowired
    private IMemberDAO m_dao;

    @Override
    public void onApplicationEvent(AuthenticationSuccessEvent event) {
        String mId = event.getAuthentication().getName(); // 로그인한 m_id

        MemberDTO member = m_dao.MemberView(mId); // m_id로 회원 1건 조회 (IMemberDAO 기준)

        if (member != null) {
            ServletRequestAttributes attrs =
                    (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
            HttpSession session = attrs.getRequest().getSession();
            // MemberDTO.m_no 타입(Integer)을 그대로 세션에 저장 - 다른 파트 코드가 이 타입 기준으로 짜여있을 수 있어서 강제 변환 안 함
            session.setAttribute(SessionConst.LOGIN_MEMBER_NO, member.getM_no());
        }
    }
}
