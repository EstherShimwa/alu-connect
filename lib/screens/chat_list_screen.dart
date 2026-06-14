import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'notifications_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final List<Map<String, dynamic>> chatRooms = [
    {
      "name": "ALU Hackathon 2026",
      "last": "See you all there!",
      "unread": 3,
      "online": true,
      "category": "Event",
    },
    {
      "name": "Entrepreneurship Club",
      "last": "Meeting at 3pm today",
      "unread": 1,
      "online": true,
      "category": "Club",
    },
    {
      "name": "Study Group - Flutter",
      "last": "Anyone done question 3?",
      "unread": 0,
      "online": false,
      "category": "Academic",
    },
    {
      "name": "Campus Announcements",
      "last": "Library closes at 8pm",
      "unread": 5,
      "online": true,
      "category": "Announcement",
    },
    {
      "name": "Leadership Program 2026",
      "last": "Applications are open!",
      "unread": 2,
      "online": false,
      "category": "Program",
    },
  ];

  String selectedCategory = "All";
  final List<String> categories = [
    "All",
    "Event",
    "Club",
    "Academic",
    "Announcement",
    "Program",
  ];

  List<Map<String, dynamic>> get filteredRooms {
    if (selectedCategory == "All") return chatRooms;
    return chatRooms
        .where((r) => r["category"] == selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Communities & Chats"),
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
          // Category filter chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = selectedCategory == cat;
                return GestureDetector(
                  onTap: () => setState(() => selectedCategory = cat),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.deepPurple
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredRooms.length,
              itemBuilder: (context, index) {
                final room = filteredRooms[index];
                return ListTile(
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: Text(
                          room["name"][0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: room["online"]
                                ? Colors.greenAccent
                                : Colors.grey,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    room["name"],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    room["last"],
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: room["unread"] > 0
                      ? CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.deepPurple,
                          child: Text(
                            room["unread"].toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11),
                          ),
                        )
                      : const Text(
                          "Now",
                          style: TextStyle(
                              color: Colors.grey, fontSize: 12),
                        ),
                  onTap: () {
                    setState(() => room["unread"] = 0);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(roomName: room["name"]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
