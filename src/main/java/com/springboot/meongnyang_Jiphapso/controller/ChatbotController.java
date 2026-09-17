package com.springboot.meongnyang_Jiphapso.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.springboot.meongnyang_Jiphapso.service.ChatbotService;

@RestController
@RequestMapping("/guest/etc/chatBot")
public class ChatbotController {
	private final ChatbotService chatbotService;

    public ChatbotController(ChatbotService chatbotService) {
        this.chatbotService = chatbotService;
    }

    @PostMapping("/ask")
    public ChatResponse ask(@RequestBody ChatRequest request) {
        String answer = chatbotService.ask(request.getMessage());
        return new ChatResponse(answer);
    }

    // 간단한 요청/응답 DTO (원하면 별도 파일로 분리하셔도 됩니다)
    public static class ChatRequest {
        private String message;
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
    }

    public static class ChatResponse {
        private String reply;
        public ChatResponse(String reply) { this.reply = reply; }
        public String getReply() { return reply; }
        public void setReply(String reply) { this.reply = reply; }
    }
}