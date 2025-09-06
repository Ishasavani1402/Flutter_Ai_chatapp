import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarktheme = false;
  static const String _themeKey = 'isDarkTheme'; // Key for SharedPreferences

  ThemeProvider() {
    _loadTheme();
  }

  bool get isDarkTheme => _isDarktheme;

  ThemeData get themedata => _isDarktheme ? darkTheme : lightTheme;

  final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blueAccent,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.blue.shade50,
      labelStyle: TextStyle(color: Colors.blueGrey.shade700),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
      ),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.black87),
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white70),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.red,
      contentTextStyle: TextStyle(color: Colors.white),
    ),
  );

  final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.grey.shade900,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blueGrey.shade800,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey.shade700,
        foregroundColor: Colors.white,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.blueGrey.shade800,
      labelStyle: TextStyle(color: Colors.white70),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade600),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blueAccent, width: 2),
      ),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white70),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.red,
      contentTextStyle: TextStyle(color: Colors.white),
    ),
  );

  void toggleTheme() async {
    _isDarktheme = !_isDarktheme;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarktheme);
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarktheme = prefs.getBool(_themeKey) ?? false;
    notifyListeners();
  }
}
