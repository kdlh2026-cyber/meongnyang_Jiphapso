<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>멍냥집합소</title>
<style>
    body {
        margin: 0;
        font-family: 'Malgun Gothic', sans-serif;
        background: #f0f0f0;
    }

    /* 챗봇 카드만 감싸는 래퍼 */
    .chatbot-page-wrapper {
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 40px 0;
        min-height: 70vh;
    }

    /* 스마트폰 형태 카드 */
    #chatWidget {
        width: 380px;
        height: 780px;
        max-height: 92vh;
        background: #fff;
        border-radius: 28px;
        box-shadow: 0 12px 32px rgba(0,0,0,0.15);
        display: flex;
        flex-direction: column;
        overflow: hidden;
    }

    .chat-header {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 20px 18px;
        border-bottom: 1px solid #eee;
    }
    .chat-header img {
        width: 40px; height: 40px; border-radius: 50%;
        background: #FFD400;
        object-fit: cover;
    }
    .chat-header .title { font-weight: bold; font-size: 17px; }
    .chat-header .sub { font-size: 12px; color: #999; margin-top: 2px; }

    .chat-body {
        flex: 1;
        padding: 16px;
        overflow-y: auto;
        display: flex;
        flex-direction: column;
        gap: 12px;
        background: #fafafa;
    }

    .msg {
        max-width: 75%;
        padding: 11px 15px;
        border-radius: 16px;
        font-size: 14.5px;
        line-height: 1.5;
        word-break: break-word;
    }
    .msg.bot {
        align-self: flex-start;
        background: #fff;
        border: 1px solid #eee;
    }
    .msg.user {
        align-self: flex-end;
        background: #FFD400;
        color: #222;
    }

    .chat-input {
        display: flex;
        border-top: 1px solid #eee;
        padding: 12px;
        gap: 10px;
    }
    .chat-input input {
        flex: 1;
        border: 1px solid #ddd;
        border-radius: 22px;
        padding: 11px 16px;
        font-size: 14px;
        outline: none;
    }
    .chat-input button {
        background: #FFD400;
        border: none;
        border-radius: 50%;
        width: 42px;
        height: 42px;
        cursor: pointer;
        font-size: 16px;
        flex-shrink: 0;
    }
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/hamburger_menu.jsp" %>

<div class="chatbot-page-wrapper">
    <!-- 챗봇 카드 -->
    <div id="chatWidget">
        <div class="chat-header">
            <img src="/images/bot_icon.png" onerror="this.style.display='none'">
            <div>
                <div class="title">멍냥집합소 상담사</div>
                <div class="sub">문의 남겨주시면 답변드릴게요</div>
            </div>
        </div>

        <div class="chat-body" id="chatBody">
            <div class="msg bot">안녕하세요! 멍냥집합소 이용 중 궁금한 점을 남겨주세요 🐾</div>
        </div>

        <div class="chat-input">
            <input type="text" id="chatInput" placeholder="메시지를 입력하세요"
                   onkeydown="if(event.key==='Enter') sendMessage();">
            <button onclick="sendMessage()">➤</button>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
<script>
    function appendMessage(text, type) {
        const body = document.getElementById('chatBody');
        const div = document.createElement('div');
        div.className = 'msg ' + type;
        div.innerText = text;
        body.appendChild(div);
        body.scrollTop = body.scrollHeight;
    }

    function sendMessage() {
        const input = document.getElementById('chatInput');
        const message = input.value.trim();
        if (!message) return;

        appendMessage(message, 'user');
        input.value = '';

        fetch('/guest/etc/chatBot/ask', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ message: message })
        })
        .then(res => {
            if (!res.ok) {
                return res.text().then(text => { throw new Error(text); });
            }
            return res.json();
        })
        .then(data => {
            appendMessage(data.reply, 'bot');
        })
        .catch(err => {
            appendMessage('죄송해요, 답변을 가져오지 못했어요.', 'bot');
            console.error('챗봇 에러 상세:', err);
        });
    }
</script>

</body>
</html>