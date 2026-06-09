import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.deepPurple,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [

          const SizedBox(height: 20),

          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.deepPurple,
            child: Icon(
              Icons.person,
              size: 60,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 20),

          const Center(
            child: Text(
              "Student Name",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 5),

          const Center(
            child: Text(
              "ALU Student • Software Engineering",
              style: TextStyle(color: Colors.grey),
            ),
          ),

          const SizedBox(height: 30),

          Card(
            child: ListTile(
              leading: const Icon(Icons.email),
              title: const Text("Email"),
              subtitle: const Text("student@alustudent.com"),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.event),
              title: const Text("Events Joined"),
              subtitle: const Text("3 Active Registrations"),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.groups),
              title: const Text("Clubs"),
              subtitle: const Text("Tech Club, AI Society"),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}