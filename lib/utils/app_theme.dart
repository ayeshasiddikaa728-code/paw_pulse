import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFFB6C1), // Baby Pink
        primary: const Color(0xFFFF8DA1),   // Cute Soft Pink
        secondary: const Color(0xFFFFB7B2), // Pastel Coral
        surface: const Color(0xFFFFF0F5),   // Lavender Blush background
      ),
      scaffoldBackgroundColor: const Color(0xFFFFF5F7),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFF8DA1),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFFF8DA1),
        foregroundColor: Colors.white,
      ),
    );
  }
}