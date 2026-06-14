import 'package:flutter/material.dart';
import '../services/rsvp_service.dart';
import '../services/auth_service.dart';
import '../services/post_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: AuthService.instance,
        builder: (context, _) {
          final user = AuthService.instance.currentUser;
          if (user == null) return const SizedBox.shrink();
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: user.isStaff ? Colors.orange : Colors.deepPurple,
                child: const Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(user.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 6),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: user.isStaff
                        ? Colors.orange.withValues(alpha: 0.1)
                        : Colors.deepPurple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    user.isStaff ? 'Staff Member' : 'Student',
                    style: TextStyle(
                      color: user.isStaff ? Colors.orange : Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Email'),
                  subtitle: Text(user.email),
                ),
              ),
              if (!user.isStaff) ...[
                Card(
                  child: AnimatedBuilder(
                    animation: RsvpService.instance,
                    builder: (context, _) {
                      final count = RsvpService.instance.registrations.length;
                      return ListTile(
                        leading: const Icon(Icons.event),
                        title: const Text('Events Joined'),
                        subtitle: Text('$count Active ${count == 1 ? 'Registration' : 'Registrations'}'),
                      );
                    },
                  ),
                ),
                AnimatedBuilder(
                  animation: PostService.instance,
                  builder: (context, _) {
                    final myPosts = PostService.instance.myPosts(user.id);
                    final approved = myPosts.where((p) => p.status == 'approved').length;
                    final pending = myPosts.where((p) => p.status == 'pending').length;
                    final rejected = myPosts.where((p) => p.status == 'rejected').length;
                    if (myPosts.isEmpty) return const SizedBox.shrink();
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('My Posts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _statChip('Approved', approved, Colors.green),
                                _statChip('Pending', pending, Colors.orange),
                                _statChip('Rejected', rejected, Colors.red),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
              const SizedBox(height: 30),
              OutlinedButton.icon(
                onPressed: () async {
                  await AuthService.instance.logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Logout', style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _statChip(String label, int count, Color color) {
    return Column(
      children: [
        Text('$count', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
