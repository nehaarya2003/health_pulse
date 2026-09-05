import 'package:flutter/material.dart';

class AppTheme {
  // Brand colors — health/wellness feel
  static const Color primary = Color(0xFF00C896);      // Teal green
  static const Color primaryDark = Color(0xFF00A87E);
  static const Color background = Color(0xFF0D1117);   // Dark navy
  static const Color surface = Color(0xFF161B22);
  static const Color cardColor = Color(0xFF1C2128);
  static const Color heartRate = Color(0xFFFF5C5C);    // Red
  static const Color spo2 = Color(0xFF5B9BD5);         // Blue
  static const Color hrv = Color(0xFFFFB347);           // Amber
  static const Color steps = Color(0xFF7ED321);        // Green

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F7FA),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
      background: background,
      surface: surface,
    ),
    scaffoldBackgroundColor: background,
    cardColor: cardColor,
    cardTheme: CardTheme(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      centerTitle: false,
    ),
  );
}