import 'package:chatapp/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'Screens/Splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print("Firebase Connection sucess!!");
  await dotenv.load(fileName: "Api_Key.env");
  runApp(
    ChangeNotifierProvider(create: (_)=> ThemeProvider(),
    child: const MyApp(),)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'ChatWave',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.themedata,
          home: SplashScreen(),
        );
      },
    );
  }
}