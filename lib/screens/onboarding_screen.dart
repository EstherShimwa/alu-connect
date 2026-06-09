import 'package:flutter/material.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.groups,
              size: 100,
              color: Colors.deepPurple,
            ),

            const SizedBox(height: 30),

            const Text(
              'Discover Opportunities',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'Find workshops, hackathons, clubs, internships and exciting campus activities.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const LoginScreen(),
                  ),
                );
              },

              style: ElevatedButton.styleFrom(
                minimumSize: const Size(
                  double.infinity,
                  55,
                ),
              ),

              child: const Text(
                'Get Started',
              ),
            ),
          ],
        ),
      ),
    );
  }
}