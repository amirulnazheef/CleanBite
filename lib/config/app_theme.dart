import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette
  static const Color background = Color(0xFFFFF2E0); // #fff2e0 - Warm cream background
  static const Color primaryBrown = Color(0xFFC9935D); // #c9935d - Warm brown for primary elements
  static const Color accentGreen = Color(0xFFABBB4F); // #abbb4f - Olive green for accents
  
  // Derived colors for better UI
  static const Color textPrimary = Color(0xFF4A3728); // Dark brown for primary text
  static const Color textSecondary = Color(0xFF8B7355); // Medium brown for secondary text
  static const Color textLight = Color(0xFFA89080); // Light brown for hints
  
  // Status colors (derived from palette)
  static const Color success = accentGreen;
  static const Color warning = Color(0xFFD4A574); // Lighter brown
  static const Color error = Color(0xFFB85C50); // Muted red-brown
  static const Color info = primaryBrown;
  
  // Surface colors
  static const Color surface = Color(0xFFFFF8F0); // Lighter than background
  static const Color surfaceDark = Color(0xFFF5E6D3); // Darker than background
  
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Color Scheme
    colorScheme: ColorScheme.light(
      primary: primaryBrown,
      secondary: accentGreen,
      surface: background,
      error: error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimary,
      onError: Colors.white,
    ),
    
    // Scaffold
    scaffoldBackgroundColor: background,
    
    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: primaryBrown),
    ),
    
    // Card
    cardTheme: CardThemeData(
      color: surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    
    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBrown,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    
    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryBrown,
      ),
    ),
    
    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryBrown,
        side: BorderSide(color: primaryBrown, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    
    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: surfaceDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: surfaceDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryBrown, width: 2),
      ),
      labelStyle: TextStyle(color: textSecondary),
      hintStyle: TextStyle(color: textLight),
    ),
    
    // Icon Theme
    iconTheme: IconThemeData(
      color: primaryBrown,
    ),
    
    // Text Theme
    textTheme: TextTheme(
      displayLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(color: textSecondary, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: textPrimary),
      bodyMedium: TextStyle(color: textPrimary),
      bodySmall: TextStyle(color: textSecondary),
      labelLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w500),
      labelMedium: TextStyle(color: textSecondary),
      labelSmall: TextStyle(color: textLight),
    ),
    
    // Floating Action Button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accentGreen,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    
    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: surface,
      selectedColor: primaryBrown,
      labelStyle: TextStyle(color: textPrimary),
      secondaryLabelStyle: TextStyle(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    
    // Divider
    dividerTheme: DividerThemeData(
      color: surfaceDark,
      thickness: 1,
    ),
    
    // Bottom Navigation Bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: primaryBrown,
      unselectedItemColor: textLight,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );
  
  // Dark Theme (optional, using same palette with adjustments)
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    colorScheme: ColorScheme.dark(
      primary: primaryBrown,
      secondary: accentGreen,
      surface: Color(0xFF2A2520),
      error: error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFFF5E6D3),
      onError: Colors.white,
    ),
    
    scaffoldBackgroundColor: Color(0xFF1A1612),
  );
  
  // Helper method to get color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
  
  // Gradient helpers
  static LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBrown, Color(0xFFB8844D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static LinearGradient accentGradient = LinearGradient(
    colors: [accentGreen, Color(0xFF98A842)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
