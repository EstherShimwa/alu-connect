import 'package:flutter/material.dart';
import 'home_feed_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Scaffold(
      appBar: AppBar(
        title: const Text("The ALU Connect"),
        backgroundColor: Colors.deepPurple,
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),

          children: [
            const Text(
              "Discover Opportunities 🎓",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Events, workshops, internships & more",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            ...events.asMap().entries.map((entry) {
              int index = entry.key;
              var event = entry.value;
              bool isRegistered = registered[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),

                child: ListTile(
                  leading: const Icon(Icons.event, color: Colors.deepPurple),

                  title: Text(event["title"]!),

                  subtitle: Text(
                    "${event["type"]} • ${event["date"]}",
                  ),

                  trailing: ElevatedButton(
                    onPressed: () => toggleRSVP(index),

                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isRegistered ? Colors.green : Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),

                    child: Text(
                      isRegistered ? "Registered ✓" : "RSVP",
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
=======
    return const HomeFeedScreen();
>>>>>>> main
  }
}