import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> events = [
    {"title": "AI Workshop", "type": "Workshop", "date": "12 June"},
    {"title": "Startup Pitch Night", "type": "Entrepreneurship", "date": "15 June"},
    {"title": "Hackathon 2026", "type": "Competition", "date": "20 June"},
    {"title": "Leadership Bootcamp", "type": "Training", "date": "25 June"},
  ];

  List<bool> registered = [false, false, false, false];

  void toggleRSVP(int index) {
    setState(() {
      registered[index] = !registered[index];
    });
  }

  @override
  Widget build(BuildContext context) {
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
  }
}