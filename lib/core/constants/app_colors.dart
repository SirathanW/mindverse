import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryGold = Color(0xFFDAA520);
  static const Color secondaryGold = Color(0xFFFFD700);
  static const Color darkGold = Color(0xFFB8860B);
  
  // Background Colors
  static const Color backgroundDark = Color(0xFF0A0A0A);
  static const Color surfaceDark = Color(0xFF1A1A1A);
  static const Color surfaceLight = Color(0xFF2A2A2A);
  
  // Text Colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF666666);
  static const Color textOnGold = Colors.black;
  
  // Gradient Colors
  static const List<Color> primaryGradient = [primaryGold, secondaryGold];
  static const List<Color> backgroundGradient = [surfaceDark, backgroundDark];
  static const List<Color> surfaceGradient = [surfaceDark, surfaceLight];
  static const List<Color> radialGradient = [surfaceDark, backgroundDark];
}

