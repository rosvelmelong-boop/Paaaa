import 'package:flutter/material.dart';

class PropveilTheme {
  // Brand Colors
  static const Color canvasNavy = Color(0xFF0A1628);
  static const Color surfaceNavy = Color(0xFF1A2B45);
  static const Color surface2 = Color(0xFF142239);
  static const Color borderSubtle = Color(0xFF1E293B);
  
  static const Color tealAccent = Color(0xFF1D9A8A);
  static const Color tealHover = Color(0xFF17806F);
  static const Color tealGlow = Color(0x261D9A8A); // 15% opacity
  static const Color goldAccent = Color(0xFFD4A24C);
  static const Color coralAccent = Color(0xFFFF7A5A);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textTertiary = Color(0xFF64748B);
  
  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: canvasNavy,
      primaryColor: tealAccent,
      cardColor: surfaceNavy,
      dividerColor: borderSubtle,
      fontFamily: 'Inter',
      useMaterial3: true,
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w900, color: textPrimary),
        headlineLarge: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w900, color: textPrimary, fontSize: 32),
        headlineMedium: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, color: textPrimary, fontSize: 24),
        headlineSmall: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, color: textPrimary, fontSize: 20),
        bodyLarge: TextStyle(fontFamily: 'Inter', fontSize: 16, color: textPrimary, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 14, color: textSecondary, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(fontFamily: 'Inter', fontSize: 12, color: textTertiary, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: textSecondary, letterSpacing: 0.08),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: tealAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: surface2,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: borderSubtle, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: borderSubtle, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: tealAccent, width: 1.0),
        ),
      ),
    );
  }
}
