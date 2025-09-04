import 'package:chatapp/Screens/ChatBot.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _stayLoggedOut = false;
  bool obcursed = true;


  Future<void> login()async{
    var email = _emailController.text;
    var password = _passwordController.text;
    print("Login Email : $email");
    print("Login Password : $password");
    try{
      if(email.isNotEmpty && password.isNotEmpty){
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).
        then((value)=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Chatbot())));


      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Enter Email and Password!!!"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating));
      }

    }on FirebaseAuthException catch(e){
      print("Error for login : ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error For login : ${e.toString()}"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating));
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
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration:  BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.blue],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding:  EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App title or logo
                  Text(
                    'ChatWave',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  // Login Form Container
                  Container(
                    width: screenWidth * 0.85,
                    padding:  EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset:  Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email Input Field
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            labelStyle: TextStyle(color: Colors.blueGrey.shade700),
                            prefixIcon:  Icon(Icons.email_outlined, color: Colors.blueAccent),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.blue.shade50,
                            contentPadding:  EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          ),
                        ),
                        SizedBox(height: 24),
                        // Password Input Field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: obcursed,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.blueGrey.shade700),
                            prefixIcon:  Icon(Icons.lock_outlined, color: Colors.blueAccent),
                            suffixIcon: IconButton(onPressed: (){
                              setState(() {
                                obcursed = !obcursed;
                              });
                            }, icon: obcursed
                                ?  Icon(Icons.visibility_off)
                                :  Icon(Icons.visibility)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.blue.shade50,
                            contentPadding:  EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                          ),
                        ),
                        SizedBox(height: 24),
                        // Login Button
                        ElevatedButton(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding:  EdgeInsets.symmetric(vertical: 16),
                            elevation: 5,
                          ),
                          child:  Text(
                            'LOGIN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        SizedBox(height: 25,),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.blueGrey,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                'OR',
                                style: GoogleFonts.poppins(
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.blueGrey,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        ElevatedButton.icon(
                          onPressed: () async {
                            // bool islogin = await googlelogin();
                            // if (islogin) {
                            //   Navigator.pushReplacement(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) =>  Homescreen()));
                            // } else {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //       SnackBar(content: Text("Error in Login")));
                            // }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            padding:  EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 8,
                          ),
                          icon:  Icon(FontAwesomeIcons.google),
                          label: Text(
                            "Continue with Google",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        SizedBox(height: 20,),

                        TextButton(onPressed: (){
                          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> Chatbot()));
                        }, child: Text("Stay LoggedOut"),)

                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  // "Don't have an account?" link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.white70),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> RegistrationScreen()));

                        },
                        child:  Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
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
        ],
      ),
    );
  }
}

