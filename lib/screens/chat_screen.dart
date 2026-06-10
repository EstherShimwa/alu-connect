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
      reactions[emoji] = (reactions[emoji] ?? 0) + 1;
    });
  }

  void _showEmojiPicker(BuildContext context, String messageId) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "React to message",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _emojis
                  .map((emoji) => GestureDetector(
                        onTap: () {
                          _addReaction(messageId, emoji);
                          Navigator.pop(context);
                        },
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReactions(Map<String, int> reactions) {
    if (reactions.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 4,
      children: reactions.entries
          .map((e) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${e.key} ${e.value}",
                  style: const TextStyle(fontSize: 12),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildMessage(Map<String, dynamic> msg) {
    final isMe = msg["isMe"] as bool;
    final reactions = msg["reactions"] as Map<String, int>;
    final replyTo = msg["replyTo"];

    return GestureDetector(
      onLongPress: () => _showEmojiPicker(context, msg["id"]),
      child: Align(
        alignment:
            isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: isMe ? 0 : 12, right: isMe ? 12 : 0),
              child: Text(
                msg["sender"],
                style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                  vertical: 4, horizontal: 8),
              padding: const EdgeInsets.all(10),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              decoration: BoxDecoration(
                color: isMe ? Colors.deepPurple : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (replyTo != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isMe
                            ? Colors.deepPurple[700]
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                        border: const Border(
                          left: BorderSide(
                              color: Colors.white, width: 3),
                        ),
                      ),
                      child: Text(
                        "${replyTo["sender"]}: ${replyTo["text"]}",
                        style: TextStyle(
                            fontSize: 11,
                            color: isMe
                                ? Colors.white70
                                : Colors.black54),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  Text(
                    msg["text"],
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _buildReactions(reactions),
            ),
            TextButton(
              onPressed: () => setState(() => _replyingTo = msg),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                "Reply",
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomName),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
                    ),
                  );
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) =>
                  _buildMessage(_messages[index]),
            ),
          ),
          if (_replyingTo != null)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              color: Colors.grey[100],
              child: Row(
                children: [
                  const Icon(Icons.reply,
                      color: Colors.deepPurple, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Replying to ${_replyingTo!["sender"]}: ${_replyingTo!["text"]}",
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[700]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    onPressed: () =>
                        setState(() => _replyingTo = null),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}