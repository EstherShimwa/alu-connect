// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'my_events_screen.dart';
import 'profile_screen.dart';
import 'rsvp_registration_screen.dart'; // To access mainTabNotifier

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    mainTabNotifier.value = 0; // Reset index to 0 at start
    mainTabNotifier.addListener(_onTabNotification);
  }

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
    final pages = [
      const HomeScreen(),      // Your feed (index 0)
      const MyEventsScreen(),  // My Events (index 1)
      // TODO: Person 4 - Chat/Community (index 2 in future)
      const ProfileScreen(),   // Profile (index 2 currently)
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          mainTabNotifier.value = index;
        },
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "My Events"),
          // TODO: Person 4 - BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Community"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}