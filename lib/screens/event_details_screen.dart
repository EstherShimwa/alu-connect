// lib/screens/event_details_screen.dart
import 'package:flutter/material.dart';

class EventDetailsScreen extends StatelessWidget {
  final Map<String, String> opportunity;

  const EventDetailsScreen({super.key, required this.opportunity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opportunity Details'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                opportunity['category']!.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),
            
            // Title
            Text(
              opportunity['title']!,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            // Host Information
            Text(
              'Hosted by: ${opportunity['organizer']}',
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.black87),
            ),
            const Divider(height: 30, thickness: 1),
            
            // Logistics info box
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.deepPurple),
                const SizedBox(width: 10),
                Text(opportunity['date']!, style: const TextStyle(fontSize: 15)),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.deepPurple),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(opportunity['location']!, style: const TextStyle(fontSize: 15)),
                ),
              ],
            ),
            const Divider(height: 30, thickness: 1),
            
            // Description Header
            const Text(
              'About this Opportunity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            // Body Description
            Text(
              opportunity['description']!,
              style: const TextStyle(fontSize: 15, height: 1.5, color: Colors.black54),
            ),
            const SizedBox(height: 40),

            // RSVP Action Area Placeholder (for Person 3)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Basic Alert Dialog to satisfy interaction requirements for now
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('RSVP Triggered'),
                      content: const Text('This button hook will be fully configured by Person 3 to handle user RSVP statuses!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        )
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('RSVP / Register', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}