import 'package:flutter/material.dart';

class AppTheme {
  static const Color bgDeep = Color(0xFF0B0B0B);
  static const Color bgDark = Color(0xFF121212);
  static const Color bgCard = Color(0xB3141414); 
  static const Color accentColor = Color(0xFFC97822);
  static const Color accentPurple = Color(0xFF8A2BE2);
  static const Color accentGold = Color(0xFFC97822);
  
  static const Color textPrimary = Color(0xFFF2F2F2);
  static const Color textSecondary = Color(0xFFA0A0A0);

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: accentColor,
    scaffoldBackgroundColor: bgDeep,
    colorScheme: const ColorScheme.dark(
      primary: accentColor,
      secondary: accentPurple,
      surface: bgCard,
      background: bgDeep,
    ),
    useMaterial3: true,
  );
}
