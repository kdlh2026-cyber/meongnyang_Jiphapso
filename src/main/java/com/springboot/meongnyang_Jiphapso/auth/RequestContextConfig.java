package com.springboot.meongnyang_Jiphapso.auth;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.context.request.RequestContextListener;

@Configuration
public class RequestContextConfig {

    // 시큐리티 필터 단계에서도 RequestContextHolder로 현재 요청을 꺼낼 수 있게 등록
    // (CartMergeLoginListener에서 게스트 토큰 쿠키를 읽기 위해 필요)
    @Bean
    public RequestContextListener requestContextListener() {
        return new RequestContextListener();
    }
}