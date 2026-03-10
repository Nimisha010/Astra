import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Splash duration
    Timer(const Duration(seconds: 3), () {
      final user = FirebaseAuth.instance.currentUser;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              user != null ? const HomeScreen() : const LoginScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF90CAF9),
              Colors.white,
              Color(0xFF90CAF9),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/madeastralogo.png',
              width: 250,
              height: 250,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 20),

            // ASTRA Text
            // const Text(
            //   "ASTRA",
            //   style: TextStyle(
            //     fontSize: 34,
            //     fontWeight: FontWeight.bold,
            //     letterSpacing: 2,
            //     color: Color(0xFF1565C0),
            //   ),
            // ),

            const SizedBox(height: 12),

            // Tagline
            const Text(
              "AI Safety and Protection",
              style: TextStyle(
                fontSize: 20,
                letterSpacing: 1,
                color: const Color.fromARGB(255, 11, 41, 161),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
