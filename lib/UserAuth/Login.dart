import 'package:chatapp/Screens/ChatBot.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'RegisterScreen.dart';
import '../theme_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool obcursed = true;

  Future<void> login() async {
    var email = _emailController.text;
    var password = _passwordController.text;
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then(
              (value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  Chatbot()),
          ),
        );
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
          content: Text("Error For login: ${e.message}"),
          backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<bool> googlelogin() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Sign in Success!!"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      if (googleUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Sign in error!!"),
            backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return false;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      return FirebaseAuth.instance.currentUser != null;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error For login: ${e.message}"),
          backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
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
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Welcome Back',
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
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: login,
                      style: Theme.of(context).elevatedButtonTheme.style,
                      child: Text(
                        'LOGIN',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'OR',
                            style: GoogleFonts.poppins(
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () async {
                        bool islogin = await googlelogin();
                        if (islogin) {
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => const Chatbot()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Error in Login"),
                              backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      style: Theme.of(context).elevatedButtonTheme.style,
                      icon: Icon(FontAwesomeIcons.google, color: Theme.of(context).brightness ==
                          Brightness.light ? Colors.white : Colors.white),
                      label: Text(
                        "Login with Google",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Chatbot(),
                          ),
                        );
                      },
                      style: Theme.of(context).textButtonTheme.style,
                      child: const Text("Stay LoggedOut"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistrationScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Sign Up',
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