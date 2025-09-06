import 'dart:async';
import 'package:chatapp/Screens/ChatBot.dart';
import 'package:chatapp/UserAuth/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.repeat(reverse: true);

    Timer(const Duration(seconds: 3), () {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  Chatbot()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
      backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.blueAccent : Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Icon(
                    FontAwesomeIcons.message,
                    size: 100.0,
                    color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.white,
                  ),
                );
              },
            ),
            const SizedBox(height: 24.0),
            Text(
              'ConnectNow',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
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
            Text(
              'Your Conversations, Instantly.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


