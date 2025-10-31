import 'package:flutter/material.dart';

/// CleanBite App Theme - Flat Design with Liquid Glass Effects
/// Color Palette:
/// - Main Background: #FFF2E0 (Warm cream)
/// - Primary Button: #C9935D (Warm brown)
/// - Secondary Button: #ABBB4F (Olive green)
class AppTheme {
  // Core Colors
  static const Color background = Color(0xFFFFF2E0);
  static const Color primaryButton = Color(0xFFC9935D);
  static const Color secondaryButton = Color(0xFFABBB4F);
  
  // Text Colors (Flat Design - high contrast)
  static const Color textPrimary = Color(0xFF2C2416);
  static const Color textSecondary = Color(0xFF5C4A3A);
  static const Color textLight = Color(0xFF8C7A6A);
  static const Color textWhite = Color(0xFFFFFFFF);
  
  // Surface Colors (Flat Design)
  static const Color surface = Color(0xFFF5E6D3);
  static const Color surfaceLight = Color(0xFFFAF0E0);
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  // Accent Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF42A5F5);
  
  // Gradients for backgrounds (subtle)
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFF8F0),
      Color(0xFFFFF2E0),
    ],
  );
  
  // Text Styles (San Francisco-like font)
  static const String fontFamily = 'SF Pro Display';
  
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    letterSpacing: -0.5,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    letterSpacing: -0.3,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: -0.2,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.4,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textLight,
    height: 1.3,
  );
  
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
  
  // Spacing (8px grid system)
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 48.0;
  
  // Border Radius (Flat Design with rounded corners)
  static const double radiusSmall = 12.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 20.0;
  static const double radiusXLarge = 24.0;
  
  // Liquid Glass Button Properties
  static const double glassBlur = 10.0;
  static const double glassOpacity = 0.15;
  
  // Material Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      fontFamily: fontFamily,
      colorScheme: const ColorScheme.light(
        primary: primaryButton,
        secondary: secondaryButton,
        surface: surface,
        error: error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: heading3,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryButton,
          foregroundColor: textWhite,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLarge),
          ),
          textStyle: buttonText,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryButton,
          textStyle: buttonText,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: primaryButton, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
      ),
    );
  }
}
