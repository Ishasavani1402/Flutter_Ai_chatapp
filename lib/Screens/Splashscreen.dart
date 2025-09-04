// A single Flutter file for a splash screen and a chat screen.
// This file can be run directly.

import 'dart:async';
import 'package:chatapp/Screens/ChatBot.dart';
import 'package:chatapp/UserAuth/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../UserAuth/RegisterScreen.dart';
// The SplashScreen widget, which is a stateful widget to manage its state.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  // An AnimationController to manage the animation.
  late AnimationController _controller;
  // An Animation<double> for the scaling effect.
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController with a duration.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Create a Tween for the scaling animation.
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // Start the animation and make it repeat.
    _controller.repeat(reverse: true);

    // Set up a timer to navigate to the ChatScreen after a delay.
    Timer(const Duration(seconds: 3), () {
     final user = FirebaseAuth.instance.currentUser;
      if(user != null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Chatbot()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800], // Dark blue background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // An animated builder to apply the scaling animation to the icon.
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: const Icon(
                    Icons.chat_bubble_rounded, // Chat icon
                    size: 100.0,
                    color: Colors.white,
                  ),
                );
              },
            ),
            const SizedBox(height: 24.0),
            // The app's name text.
            Text(
              'ConnectNow',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12.0),
            // A tagline.
            const Text(
              'Your Conversations, Instantly.',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
