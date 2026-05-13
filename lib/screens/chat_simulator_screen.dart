import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ChatSimulatorScreen extends StatefulWidget {
  const ChatSimulatorScreen({super.key});

  @override
  State<ChatSimulatorScreen> createState() => _ChatSimulatorScreenState();
}

class _ChatSimulatorScreenState extends State<ChatSimulatorScreen> {
  final TextEditingController _messageController = TextEditingController();

  // Chat messages (temporary – UI only)
  final List<Map<String, dynamic>> _messages = [];

  // ✅ Bullying emojis list
  final List<String> bullyingEmojis = [
    "🤡",
    "💩",
    "🖕",
    "🤬",
    "👎",
    "🐷",
    "🐍"
  ];

  // ✅ Emoji detection
  bool _containsBullyingEmoji(String text) {
    for (final emoji in bullyingEmojis) {
      if (text.contains(emoji)) {
        return true;
      }
    }
    return false;
  }

  // 🔍 Cyberbullying detection
  bool _isHarmful(String message) {
    final msg = message.toLowerCase();

    // Check for bullying emojis
    if (_containsBullyingEmoji(message)) {
      return true;
    }

    return msg.contains("hate") ||
        msg.contains("stupid") ||
        msg.contains("idiot") ||
        msg.contains("kill") ||
        msg.contains("loser") ||
        msg.contains("dumb");
  }

  // 🤖 AI-style reply generator (rule-based)
  String _generateAIReply(String userMessage, bool isHarmful) {
    final msg = userMessage.toLowerCase();

    if (isHarmful) {
      return "⚠ Let's keep the conversation respectful. Bullying language or emojis can hurt others.";
    }

    if (msg.contains("hi") || msg.contains("hello") || msg.contains("hey")) {
      return "Hello! How are you today?";
    }

    if (msg.contains("how are you")) {
      return "I'm doing well, thank you! How about you?";
    }

    if (msg.contains("i am fine") ||
        msg.contains("i'm fine") ||
        msg.contains("doing good")) {
      return "That's great to hear! Is there anything you'd like to talk about?";
    }

    if (msg.contains("thank")) {
      return "You're welcome! I'm happy to help.";
    }

    if (msg.contains("sorry")) {
      return "No worries. It's okay, we all make mistakes.";
    }

    if (msg.contains("who are you")) {
      return "I'm an AI assistant designed to help detect cyberbullying and promote respectful communication.";
    }

    if (msg.contains("what do you do") || msg.contains("cyberbullying")) {
      return "This app analyzes messages and detects harmful language to promote safer online communication.";
    }

    return "I understand. Could you tell me a little more?";
  }

  // 📤 Send message + detection + AI reply
  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final bool isHarmful = _isHarmful(text);

    setState(() {
      _messages.add({
        "text": text,
        "isUser": true,
        "isHarmful": isHarmful,
      });
    });

    _messageController.clear();

    // 🤖 Simulated AI reply
    Future.delayed(const Duration(milliseconds: 700), () {
      final aiReply = _generateAIReply(text, isHarmful);

      setState(() {
        _messages.add({
          "text": aiReply,
          "isUser": false,
          "isHarmful": false,
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Chat Simulator"),
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];

                return _chatBubble(
                  text: msg["text"],
                  isUser: msg["isUser"],
                  isHarmful: msg["isHarmful"] ?? false,
                );
              },
            ),
          ),

          // Input area
          _inputBar(),
        ],
      ),
    );
  }

  // 💬 Chat bubble widget
  Widget _chatBubble({
    required String text,
    required bool isUser,
    bool isHarmful = false,
  }) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: const BoxConstraints(maxWidth: 260),
            decoration: BoxDecoration(
              color: isUser ? AppColors.primary : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black87,
                fontSize: 15,
              ),
            ),
          ),

          // 🚨 Show warning ONLY for harmful user messages
          if (isUser && isHarmful)
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Text(
                "⚠ Cyberbullying detected",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ⌨ Input bar
  Widget _inputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: "Type a message...",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: AppColors.primary),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
