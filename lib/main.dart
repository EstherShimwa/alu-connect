import 'screens/onboarding_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const TheALUConnect());
}

class TheALUConnect extends StatelessWidget {
  const TheALUConnect({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The ALU Connect',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const OnboardingScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.school,
              size: 90,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'The ALU Connect',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Connecting ALU students to opportunities',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}