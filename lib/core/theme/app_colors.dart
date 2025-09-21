import 'package:flutter/material.dart';

/// Serene AI Color Palette
/// Based on calm, clean, minimalist design philosophy
class AppColors {
  // Light mode colors
  static const Color primaryBackground = Color(0xFFF5F5F5); // Almost white
  static const Color primaryText = Color(0xFF333333);
  static const Color secondaryElement = Color(0xFFFFFFFF); // Card backgrounds

  // Dark mode colors
  static const Color primaryBackgroundDark = Color(0xFF121212); // True black
  static const Color primaryTextDark = Color(0xFFE0E0E0);
  static const Color secondaryElementDark = Color(0xFF1E1E1E);

  // Accent colors (same for both themes)
  static const Color accentPrimary = Color(0xFF82A0D8); // Calming blue
  static const Color accentPositive = Color(0xFF7DCEA0); // Soft green
  static const Color accentAction = Color(0xFFF7B7A3); // Muted coral

  // Additional semantic colors
  static const Color divider = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF2E2E2E);

  static const Color shadow = Color(0x1A000000);
  static const Color shadowDark = Color(0x4D000000);

  // Mood colors
  static const Color moodHappy = Color(0xFFFFE066);
  static const Color moodCalm = Color(0xFF82A0D8);
  static const Color moodSad = Color(0xFF87CEEB);
  static const Color moodAnxious = Color(0xFFDDA0DD);
  static const Color moodEnergetic = Color(0xFFFF6B6B);
}
