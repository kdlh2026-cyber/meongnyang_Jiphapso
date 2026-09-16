package com.springboot.meongnyang_Jiphapso.service;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.stereotype.Service;

@Service
public class ChatbotService {
	public ChatClient chatclient;
	
	public ChatbotService(ChatClient chatclient) {
		this.chatclient=chatclient;
	}
	
	public String ask(String question) {
        return chatclient.prompt()
                .user(question)
                .call()
                .content();
    }
}
