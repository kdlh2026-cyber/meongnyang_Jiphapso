package com.springboot.meongnyang_Jiphapso.config;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@MapperScan(basePackages = "com.springboot.meongnyang_Jiphapso.dao")
public class MyBatisMapperScanConfig {
}
