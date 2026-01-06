<!DOCTYPE html>
<html>
<head>
  <title>Spreading App Chatbot</title>
  <style>
    /* Modern Chatbot Widget */
    * { box-sizing: border-box; margin: 0; padding: 0; }
    
    .chatbot-container {
      position: fixed;
      bottom: 20px;
      right: 20px;
      z-index: 10000;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    }

    /* Toggle Button */
    .chat-toggle {
      width: 60px;
      height: 60px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      border-radius: 50%;
      cursor: pointer;
      box-shadow: 0 8px 32px rgba(102, 126, 234, 0.4);
      transition: all 0.3s ease;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 24px;
      font-weight: bold;
      animation: pulse 2s infinite;
    }

    .chat-toggle:hover {
      transform: scale(1.05);
      box-shadow: 0 12px 40px rgba(102, 126, 234, 0.6);
    }

    @keyframes pulse {
      0% { box-shadow: 0 8px 32px rgba(102, 126, 234, 0.4); }
      50% { box-shadow: 0 8px 32px rgba(102, 126, 234, 0.8); }
      100% { box-shadow: 0 8px 32px rgba(102, 126, 234, 0.4); }
    }

    /* Chat Window */
    .chat-window {
      width: 360px;
      height: 500px;
      background: white;
      border-radius: 20px;
      box-shadow: 0 20px 60px rgba(0,0,0,0.3);
      transform: translateY(100%) scale(0.9);
      opacity: 0;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      display: flex;
      flex-direction: column;
      overflow: hidden;
    }

    .chat-window.open {
      transform: translateY(0) scale(1);
      opacity: 1;
    }

    /* Header */
    .chat-header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 20px;
      display: flex;
      align-items: center;
      gap: 12px;
    }

    .bot-avatar {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      background: rgba(255,255,255,0.2);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 18px;
      font-weight: bold;
    }

    .header-info h3 {
      font-size: 16px;
      margin: 0;
    }

    .header-info p {
      font-size: 12px;
      opacity: 0.8;
      margin: 0;
    }

    .close-btn {
      margin-left: auto;
      background: none;
      border: none;
      color: white;
      font-size: 20px;
      cursor: pointer;
      padding: 4px;
      border-radius: 4px;
      transition: background 0.2s;
    }

    .close-btn:hover { background: rgba(255,255,255,0.1); }

    /* Messages */
    .messages {
      flex: 1;
      padding: 20px;
      overflow-y: auto;
      background: #f8fafc;
      max-height: 340px;
    }

    .message {
      margin-bottom: 16px;
      display: flex;
      animation: slideIn 0.3s ease;
    }

    @keyframes slideIn {
      from { opacity: 0; transform: translateY(10px); }
      to { opacity: 1; transform: translateY(0); }
    }

    .message.user {
      justify-content: flex-end;
    }

    .message-bubble {
      max-width: 70%;
      padding: 12px 16px;
      border-radius: 18px;
      font-size: 14px;
      line-height: 1.4;
      position: relative;
    }

    .message.user .message-bubble {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border-bottom-right-radius: 4px;
    }

    .message.bot .message-bubble {
      background: white;
      color: #374151;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      border-bottom-left-radius: 4px;
    }

    .typing {
      display: none;
      padding: 12px 16px;
      color: #6b7280;
      font-style: italic;
    }

    .typing-dots {
      display: inline-flex;
      gap: 4px;
    }

    .typing-dots span {
      width: 8px;
      height: 8px;
      border-radius: 50%;
      background: #9ca3af;
      animation: typing 1.4s infinite;
    }

    .typing-dots span:nth-child(2) { animation-delay: 0.2s; }
    .typing-dots span:nth-child(3) { animation-delay: 0.4s; }

    @keyframes typing {
      0%, 60%, 100% { transform: scale(1); opacity: 0.4; }
      30% { transform: scale(1.2); opacity: 1; }
    }

    /* Input */
    .input-container {
      padding: 20px;
      background: white;
      border-top: 1px solid #e5e7eb;
      display: flex;
      gap: 12px;
    }

    .message-input {
      flex: 1;
      border: 1px solid #d1d5db;
      border-radius: 25px;
      padding: 12px 20px;
      font-size: 14px;
      outline: none;
      resize: none;
      max-height: 100px;
      transition: border-color 0.2s;
    }

    .message-input:focus {
      border-color: #667eea;
      box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }

    .send-btn {
      width: 44px;
      height: 44px;
      border: none;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      border-radius: 50%;
      color: white;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 18px;
      transition: transform 0.2s;
    }

    .send-btn:hover { transform: scale(1.05); }
    .send-btn:disabled { opacity: 0.5; cursor: not-allowed; }

    /* Responsive */
    @media (max-width: 768px) {
      .chat-window { 
        width: calc(100vw - 40px); 
        height: 80vh;
        right: 20px;
        bottom: 20px;
      }
    }

    /* Scrollbar */
    .messages::-webkit-scrollbar {
      width: 4px;
    }

    .messages::-webkit-scrollbar-track {
      background: transparent;
    }

    .messages::-webkit-scrollbar-thumb {
      background: #d1d5db;
      border-radius: 2px;
    }
  </style>
</head>
<body>

<div class="chatbot-container">
  <!-- Toggle Button -->
  <div class="chat-toggle" id="chatToggle">
    💬
  </div>

  <!-- Chat Window -->
  <div class="chat-window" id="chatWindow">
    <!-- Header -->
    <div class="chat-header">
      <div class="bot-avatar">🤖</div>
      <div class="header-info">
        <h3>Spreading Assistant</h3>
        <p>Help with financial spreading</p>
      </div>
      <button class="close-btn" id="closeBtn">×</button>
    </div>

    <!-- Messages -->
    <div class="messages" id="messages">
      <div class="message bot">
        <div class="message-bubble">
          Hi! I'm here to help with spreading analysis, financial data, and documentation. Ask me anything! 😊
        </div>
      </div>
    </div>

    <!-- Typing indicator -->
    <div class="typing" id="typing">
      <span>AI is typing</span>
      <div class="typing-dots">
        <span></span><span></span><span></span>
      </div>
    </div>

    <!-- Input -->
    <div class="input-container">
      <textarea 
        class="message-input" 
        id="messageInput" 
        placeholder="Ask about spreads, ratios, or documentation..."
        rows="1"
      ></textarea>
      <button class="send-btn" id="sendBtn" disabled>➤</button>
    </div>
  </div>
</div>

<script>
  const toggleBtn = document.getElementById('chatToggle');
  const chatWindow = document.getElementById('chatWindow');
  const closeBtn = document.getElementById('closeBtn');
  const messageInput = document.getElementById('messageInput');
  const sendBtn = document.getElementById('sendBtn');
  const messages = document.getElementById('messages');
  const typing = document.getElementById('typing');

  let chatHistory = '';

  // Toggle chat window
  toggleBtn.onclick = () => chatWindow.classList.toggle('open');
  closeBtn.onclick = () => chatWindow.classList.remove('open');

  // Auto-resize textarea
  messageInput.oninput = () => {
    messageInput.style.height = 'auto';
    messageInput.style.height = Math.min(messageInput.scrollHeight, 100) + 'px';
    sendBtn.disabled = !messageInput.value.trim();
  };

  // Send message
  async function sendMessage() {
    const message = messageInput.value.trim();
    if (!message) return;

    // Add user message
    appendMessage('user', message);
    const userMessage = message;
    messageInput.value = '';
    messageInput.style.height = 'auto';
    sendBtn.disabled = true;

    // Show typing
    typing.style.display = 'block';
    messages.scrollTop = messages.scrollHeight;

    try {
      // Call your ASP.NET API (proxies to Python RAG)
      const response = await fetch('/api/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ 
          message: userMessage, 
          history: chatHistory 
        })
      });

      const data = await response.json();
      
      // Hide typing
      typing.style.display = 'none';
      
      // Add AI response
      appendMessage('bot', data.answer);
      chatHistory = data.history;

    } catch (error) {
      typing.style.display = 'none';
      appendMessage('bot', 'Sorry, something went wrong. Please try again.');
    }
  }

  function appendMessage(sender, text) {
    const messageDiv = document.createElement('div');
    messageDiv.className = `message ${sender}`;
    messageDiv.innerHTML = `
      <div class="message-bubble">${text}</div>
    `;
    messages.appendChild(messageDiv);
    messages.scrollTop = messages.scrollHeight;
  }

  // Event listeners
  sendBtn.onclick = sendMessage;
  messageInput.onkeydown = (e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      sendMessage();
    }
  };
</script>

</body>
</html>
