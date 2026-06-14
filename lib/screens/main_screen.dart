// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'my_events_screen.dart';
import 'chat_list_screen.dart';
import 'profile_screen.dart';
<<<<<<< HEAD
import 'chat_list_screen.dart';
=======
import 'rsvp_registration_screen.dart';
>>>>>>> main

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

<<<<<<< HEAD
  final List<Widget> pages = const [
    HomeScreen(),
    ChatListScreen(),
    ProfileScreen(),
  ];
=======
  @override
  void initState() {
    super.initState();
    mainTabNotifier.value = 0;
    mainTabNotifier.addListener(_onTabNotification);
  }
>>>>>>> main

  @override
  void dispose() {
    mainTabNotifier.removeListener(_onTabNotification);
    super.dispose();
  }

  void _onTabNotification() {
    if (mounted && currentIndex != mainTabNotifier.value) {
      setState(() {
        currentIndex = mainTabNotifier.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Scaffold(
      body: pages[currentIndex],
=======
    final pages = [
      const HomeScreen(),       // Home feed (index 0)
      const MyEventsScreen(),   // My Events (index 1)
      const ChatListScreen(),   // Chat/Community (index 2)
      const ProfileScreen(),    // Profile (index 3)
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
>>>>>>> main
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
          mainTabNotifier.value = index;
        },
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
<<<<<<< HEAD
=======
        type: BottomNavigationBarType.fixed,
>>>>>>> main
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
<<<<<<< HEAD
            icon: Icon(Icons.chat_bubble_outline),
            label: "Chats",
=======
            icon: Icon(Icons.event),
            label: "My Events",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: "Community",
>>>>>>> main
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}