import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  final List<Map<String, dynamic>> notifications = const [
    {
      "title": "ALU Hackathon 2026",
      "message": "You have successfully registered!",
      "time": "2 mins ago",
      "icon": Icons.event,
      "read": false,
    },
    {
      "title": "Entrepreneurship Club",
      "message": "New message in your community",
      "time": "10 mins ago",
      "icon": Icons.chat_bubble_outline,
      "read": false,
    },
    {
      "title": "Leadership Program",
      "message": "Applications close in 2 days",
      "time": "1 hour ago",
      "icon": Icons.notifications_active,
      "read": true,
    },
    {
      "title": "Campus Announcement",
      "message": "Library will close at 6pm today",
      "time": "3 hours ago",
      "icon": Icons.campaign,
      "read": true,
    },
    {
      "title": "Study Group - Flutter",
      "message": "Session starts in 30 minutes",
      "time": "Yesterday",
      "icon": Icons.group,
      "read": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return Container(
            color: notif["read"] ? Colors.white : Colors.deepPurple[50],
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.deepPurple,
                child: Icon(
                  notif["icon"] as IconData,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              title: Text(
                notif["title"],
                style: TextStyle(
                  fontWeight: notif["read"]
                      ? FontWeight.normal
                      : FontWeight.bold,
                ),
              ),
              subtitle: Text(notif["message"]),
              trailing: Text(
                notif["time"],
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
