import 'package:flutter/material.dart';
import 'notifications_screen.dart';

class ChatScreen extends StatefulWidget {
  final String roomName;
  const ChatScreen({super.key, required this.roomName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Map<String, dynamic>? _replyingTo;

  final List<Map<String, dynamic>> _messages = [
    {
      "id": "1",
      "text": "Hey everyone! Excited for the hackathon!",
      "isMe": false,
      "sender": "Amina",
      "reactions": <String, int>{},
    },
    {
      "id": "2",
      "text": "Same here! What time does it start?",
      "isMe": true,
      "sender": "You",
      "reactions": <String, int>{},
    },
    {
      "id": "3",
      "text": "It starts at 9am tomorrow at the main hall.",
      "isMe": false,
      "sender": "Kwame",
      "reactions": <String, int>{},
    },
  ];

  final List<String> _emojis = ["👍", "❤️", "😂", "😮", "😢", "🔥"];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add({
        "id": DateTime.now().millisecondsSinceEpoch.toString(),
        "text": _controller.text.trim(),
        "isMe": true,
        "sender": "You",
        "reactions": <String, int>{},
        "replyTo": _replyingTo,
      });
      _controller.clear();
      _replyingTo = null;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _addReaction(String messageId, String emoji) {
    setState(() {
      final msg = _messages.firstWhere((m) => m["id"] == messageId);
      final reactions = msg["reactions"] as Map<String, int>;
      reactions