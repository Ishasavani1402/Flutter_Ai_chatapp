import 'package:chatapp/Screens/ChatBot.dart';
import 'package:chatapp/UserAuth/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool obcursed = true;

  Future<void> registeruser() async {
    var email = _emailController.text;
    var password = _passwordController.text;
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Chatbot()),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Please Enter Email and Password!!!"),
            backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registration failed: ${e.message}"),
          backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.blueAccent : Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ChatWave',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Create Your Account',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Container(
                width: screenWidth * 0.85,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                        filled: Theme.of(context).inputDecorationTheme.filled,
                        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                        labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                        border: Theme.of(context).inputDecorationTheme.border,
                        enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
                        focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: obcursed,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(
                          Icons.lock_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obcursed = !obcursed;
                            });
                          },
                          icon: obcursed
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),
                        hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                        filled: Theme.of(context).inputDecorationTheme.filled,
                        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                        labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                        border: Theme.of(context).inputDecorationTheme.border,
                        enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
                        focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: registeruser,
                      style: Theme.of(context).elevatedButtonTheme.style,
                      child: Text(
                        'REGISTER',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    child: Text(
                      'Login',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}