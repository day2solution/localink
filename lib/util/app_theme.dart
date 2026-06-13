import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- 1. BRAND COLORS ---
  static const Color primary = Color(0xFF2563EB);
  static const Color accent = Color(0xFF3B82F6);

  // --- 2. LIGHT MODE PALETTE ---
  static const Color lightScaffold = Color(0xFFF8FAFC);
  static const Color lightCard = Colors.white;
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightInputFill = Color(0xFFF1F5F9);

  // --- 3. DARK MODE PALETTE ---
  static const Color darkScaffold = Color(0xFF0F172A);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkBorder = Colors.white10;
  static const Color darkInputFill = Color(0xFF0F172A);

  // --- 4. SYSTEM THEME GENERATORS ---

  // Light Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: lightScaffold,
      cardColor: lightCard,
      dividerColor: lightBorder,
      textTheme: GoogleFonts.plusJakartaSansTextTheme().apply(
        bodyColor: lightTextPrimary,
        displayColor: lightTextPrimary,
      ),
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: accent,
        surface: lightCard,
      ),
    );
  }

  // Dark Theme Data
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: darkScaffold,
      cardColor: darkCard,
      dividerColor: darkBorder,
      textTheme: GoogleFonts.plusJakartaSansTextTheme().apply(
        bodyColor: darkTextPrimary,
        displayColor: darkTextPrimary,
      ),
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: accent,
        surface: darkCard,
      ),
    );
  }

  // --- 5. CONVENIENCE GETTER FOR IN-WIDGET COLORS ---
  static AppColors getColors(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return AppColors(
      primary: primary,
      scaffold: isDarkMode ? darkScaffold : lightScaffold,
      card: isDarkMode ? darkCard : lightCard,
      text: isDarkMode ? darkTextPrimary : lightTextPrimary,
      subText: isDarkMode ? darkTextSecondary : lightTextSecondary,
      border: isDarkMode ? darkBorder : lightBorder,
      input: isDarkMode ? darkInputFill : lightInputFill,
      isDarkMode: isDarkMode,
    );
  }
}

class AppColors {
  final Color primary;
  final Color scaffold;
  final Color card;
  final Color text;
  final Color subText;
  final Color border;
  final Color input;
  final bool isDarkMode;

  AppColors({
    required this.primary,
    required this.scaffold,
    required this.card,
    required this.text,
    required this.subText,
    required this.border,
    required this.input,
    required this.isDarkMode,
  });
}
