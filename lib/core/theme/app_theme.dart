import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Material Design theme configuration for DevPropertyHub
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Colors
  static const Color _primaryColor = Color(0xFF1976D2);
  static const Color _primaryLightColor = Color(0xFF63A4FF);
  static const Color _primaryDarkColor = Color(0xFF004BA0);
  
  static const Color _secondaryColor = Color(0xFF388E3C);
  static const Color _secondaryLightColor = Color(0xFF6ABF69);
  static const Color _secondaryDarkColor = Color(0xFF00600F);
  
  static const Color _errorColor = Color(0xFFD32F2F);
  static const Color _surfaceColor = Colors.white;
  static const Color _backgroundColor = Color(0xFFF5F7FA);
  
  // Text colors
  static const Color _textPrimaryColor = Color(0xDE000000); // 87% opacity
  static const Color _textSecondaryColor = Color(0x99000000); // 60% opacity
  static const Color _textDisabledColor = Color(0x61000000); // 38% opacity

  // Light theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: _primaryColor,
        primaryContainer: _primaryLightColor,
        onPrimary: Colors.white,
        secondary: _secondaryColor,
        secondaryContainer: _secondaryLightColor,
        onSecondary: Colors.white,
        error: _errorColor,
        background: _backgroundColor,
        surface: _surfaceColor,
        onBackground: _textPrimaryColor,
        onSurface: _textPrimaryColor,
      ),
      textTheme: GoogleFonts.robotoTextTheme(
        ThemeData.light().textTheme.copyWith(
          displayLarge: const TextStyle(
            color: _textPrimaryColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: const TextStyle(
            color: _textPrimaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: const TextStyle(
            color: _textPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          headlineMedium: const TextStyle(
            color: _textPrimaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: const TextStyle(
            color: _textPrimaryColor,
            fontSize: 16,
          ),
          bodyMedium: const TextStyle(
            color: _textPrimaryColor,
            fontSize: 14,
          ),
          bodySmall: const TextStyle(
            color: _textSecondaryColor,
            fontSize: 12,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: _primaryColor,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryColor,
          side: const BorderSide(color: _primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: _errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: _primaryDarkColor,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey.shade200,
        selectedColor: _primaryLightColor,
        labelStyle: const TextStyle(color: _textPrimaryColor),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE0E0E0),
        thickness: 1,
        space: 1,
      ),
    );
  }

  // Dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: _primaryLightColor,
        primaryContainer: _primaryColor,
        onPrimary: Colors.black,
        secondary: _secondaryLightColor,
        secondaryContainer: _secondaryColor,
        onSecondary: Colors.black,
        error: Color(0xFFEF9A9A),
        background: Color(0xFF121212),
        surface: Color(0xFF1E1E1E),
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),
      // Dark theme configuration would be expanded here
      // For the MVP, we'll focus on the light theme since that's the primary use case
    );
  }

  // Helper methods for use in the app
  
  // Get a color based on the development status
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return _secondaryColor;
      case 'scheduled':
        return _primaryColor;
      case 'completed':
        return Colors.grey;
      case 'on hold':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
  
  // Get a color for a lead status
  static Color getLeadStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return Colors.orange;
      case 'contacted':
        return _primaryColor;
      case 'interested':
        return _secondaryColor;
      case 'converted':
        return Colors.purple;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
  
  // Get card elevation based on bandwidth mode
  static double getCardElevation(bool isLowBandwidth) {
    return isLowBandwidth ? 0 : 1;
  }
  
  // Get box shadow based on bandwidth mode
  static List<BoxShadow>? getBoxShadow(bool isLowBandwidth) {
    if (isLowBandwidth) {
      return null;
    }
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ];
  }
}
