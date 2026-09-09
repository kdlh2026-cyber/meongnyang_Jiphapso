package com.springboot.meongnyang_Jiphapso.config;

import org.apache.http.HttpHost;
import org.elasticsearch.client.RestHighLevelClient;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.elasticsearch.client.RestClient;

@Configuration
public class DogCatConfig {
	@Bean
	public RestHighLevelClient client() {
		return new RestHighLevelClient(
				RestClient.builder(new HttpHost("192.168.10.107",9200,"http"))
		);
	}
}
