import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Material Design theme configuration for DevPropertyHub
/// Based on the Property Developer Marketplace Design System
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // Brand Colors
  static const Color primaryNavy = Color(0xFF1B2B4D);
  static const Color primaryNavyLight = Color(0xFF2A3B5D);
  static const Color primaryNavyDark = Color(0xFF0F1B35);
  
  static const Color secondaryGold = Color(0xFFD4A574);
  static const Color secondaryGoldLight = Color(0xFFE2B884);
  static const Color secondaryGoldDark = Color(0xFFC29764);
  
  static const Color accentTeal = Color(0xFF2D7D7D);
  static const Color accentTealLight = Color(0xFF3D8D8D);
  static const Color accentTealDark = Color(0xFF1D6D6D);
  
  // Supporting Colors
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundWhite = Colors.white;
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textLight = Color(0xFFADB5BD);
  
  // Status Colors
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFD7E14);
  static const Color error = Color(0xFFDC3545);
  static const Color info = Color(0xFF17A2B8);
  
  // Spacing Scale
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 48.0;
  
  // Border Radius
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;

  // Elevation
  static List<BoxShadow> get elevation1 => [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      offset: const Offset(0, 1),
      blurRadius: 3,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.24),
      offset: const Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  static List<BoxShadow> get elevation2 => [
    BoxShadow(
      color: Colors.black.withOpacity(0.16),
      offset: const Offset(0, 3),
      blurRadius: 6,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.23),
      offset: const Offset(0, 3),
      blurRadius: 6,
    ),
  ];

  static List<BoxShadow> get elevation3 => [
    BoxShadow(
      color: Colors.black.withOpacity(0.19),
      offset: const Offset(0, 10),
      blurRadius: 20,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.23),
      offset: const Offset(0, 6),
      blurRadius: 6,
    ),
  ];

  static List<BoxShadow> get elevation4 => [
    BoxShadow(
      color: Colors.black.withOpacity(0.25),
      offset: const Offset(0, 14),
      blurRadius: 28,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.22),
      offset: const Offset(0, 10),
      blurRadius: 10,
    ),
  ];

  // Light theme
  static ThemeData get lightTheme {
    // Create the base theme without CardTheme
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primaryNavy,
        primaryContainer: primaryNavyLight,
        onPrimary: Colors.white,
        secondary: secondaryGold,
        secondaryContainer: secondaryGoldLight,
        onSecondary: primaryNavy,
        error: error,
        background: backgroundLight,
        surface: backgroundWhite,
        onBackground: textPrimary,
        onSurface: textPrimary,
        tertiary: accentTeal,
        tertiaryContainer: accentTealLight,
        onTertiary: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme.copyWith(
          displayLarge: const TextStyle(
            color: textPrimary,
            fontSize: 32,
            fontWeight: FontWeight.w700, // Bold
            height: 1.2,
          ),
          displayMedium: const TextStyle(
            color: textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w600, // SemiBold
            height: 1.3,
          ),
          displaySmall: const TextStyle(
            color: textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w600, // SemiBold
            height: 1.3,
          ),
          headlineMedium: const TextStyle(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w500, // Medium
            height: 1.4,
          ),
          headlineSmall: const TextStyle(
            color: textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w500, // Medium
            height: 1.4,
          ),
          titleLarge: const TextStyle(
            color: textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w500, // Medium
            height: 1.4,
          ),
          bodyLarge: const TextStyle(
            color: textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w400, // Regular
            height: 1.5,
          ),
          bodyMedium: const TextStyle(
            color: textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w400, // Regular
            height: 1.5,
          ),
          bodySmall: const TextStyle(
            color: textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w400, // Regular
            height: 1.4,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryNavy,
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryNavy,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          minimumSize: const Size(0, 44),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryNavy,
          side: const BorderSide(color: primaryNavy, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          minimumSize: const Size(0, 44),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryNavy,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minimumSize: const Size(0, 44),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      // Card theme configuration is applied separately below
      // to avoid type conflicts between Flutter versions
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: Color(0xFFE9ECEF), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: Color(0xFFE9ECEF), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: accentTeal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: textSecondary,
        ),
        helperStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: textSecondary,
        ),
        errorStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: error,
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: primaryNavyDark,
        contentTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: Colors.white,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFE9ECEF),
        selectedColor: accentTealLight,
        labelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: textPrimary,
        ),
        secondaryLabelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE9ECEF),
        thickness: 1,
        space: 1,
      ),
      tabBarTheme: const TabBarThemeData(
        indicatorColor: accentTeal,
        labelColor: primaryNavy,
        unselectedLabelColor: textSecondary,
        labelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: primaryNavy.withOpacity(0.9),
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: Colors.white,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: backgroundWhite,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
      ),
    );
    
    // Return theme without using cardTheme to avoid conflicts between Flutter SDK versions
    return theme;
  }

  // Dark theme
  static ThemeData get darkTheme {
    // Create the base theme without CardTheme
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: primaryNavyLight,
        primaryContainer: primaryNavy,
        onPrimary: Colors.white,
        secondary: secondaryGoldLight,
        secondaryContainer: secondaryGold,
        onSecondary: Colors.black,
        error: Color(0xFFEF9A9A),
        background: Color(0xFF121212),
        surface: Color(0xFF1E1E1E),
        onBackground: Colors.white,
        onSurface: Colors.white,
        tertiary: accentTealLight,
        tertiaryContainer: accentTeal,
        onTertiary: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme.copyWith(
          displayLarge: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
          displayMedium: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
          displaySmall: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
          headlineMedium: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
          headlineSmall: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
          titleLarge: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
          bodyLarge: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
          bodyMedium: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
          bodySmall: const TextStyle(
            color: Color(0xFFADB5BD),
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryNavy,
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: primaryNavy,
          backgroundColor: secondaryGoldLight,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          minimumSize: const Size(0, 44),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: secondaryGoldLight,
          side: const BorderSide(color: secondaryGoldLight, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          minimumSize: const Size(0, 44),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: secondaryGoldLight,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minimumSize: const Size(0, 44),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: Color(0xFF444444), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: Color(0xFF444444), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: accentTealLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: Color(0xFFEF9A9A), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: Color(0xFF8E8E8E),
        ),
        helperStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: Color(0xFF8E8E8E),
        ),
        errorStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: Color(0xFFEF9A9A),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF333333),
        contentTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: Colors.white,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF333333),
        selectedColor: accentTealLight,
        labelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: Colors.white,
        ),
        secondaryLabelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: Colors.black,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF444444),
        thickness: 1,
        space: 1,
      ),
      tabBarTheme: const TabBarThemeData(
        indicatorColor: accentTealLight,
        labelColor: Colors.white,
        unselectedLabelColor: Color(0xFF8E8E8E),
        labelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: const Color(0xFF333333),
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: Colors.white,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
      ),
    );
    
    // Return theme without using cardTheme to avoid conflicts between Flutter SDK versions
    return theme;
  }

  // Helper methods for use in the app
  
  // Card styling to use directly in Card widgets instead of through theme
  static BoxDecoration get cardDecoration {
    return BoxDecoration(
      color: backgroundWhite,
      borderRadius: BorderRadius.circular(radiusLarge),
      boxShadow: elevation1,
    );
  }
  
  // Card elevation levels
  static BoxDecoration get cardElevation1 {
    return BoxDecoration(
      color: backgroundWhite,
      borderRadius: BorderRadius.circular(radiusLarge),
      boxShadow: elevation1,
    );
  }
  
  static BoxDecoration get cardElevation2 {
    return BoxDecoration(
      color: backgroundWhite,
      borderRadius: BorderRadius.circular(radiusLarge),
      boxShadow: elevation2,
    );
  }
  
  static BoxDecoration get cardElevation3 {
    return BoxDecoration(
      color: backgroundWhite,
      borderRadius: BorderRadius.circular(radiusLarge),
      boxShadow: elevation3,
    );
  }
  
  // Status styles
  static BoxDecoration statusSuccess({Color? textColor}) {
    return BoxDecoration(
      color: success.withOpacity(0.1),
      borderRadius: BorderRadius.circular(radiusMedium),
      border: Border.all(
        color: success.withOpacity(0.2),
        width: 1,
      ),
    );
  }
  
  static BoxDecoration statusWarning({Color? textColor}) {
    return BoxDecoration(
      color: warning.withOpacity(0.1),
      borderRadius: BorderRadius.circular(radiusMedium),
      border: Border.all(
        color: warning.withOpacity(0.2),
        width: 1,
      ),
    );
  }
  
  static BoxDecoration statusError({Color? textColor}) {
    return BoxDecoration(
      color: error.withOpacity(0.1),
      borderRadius: BorderRadius.circular(radiusMedium),
      border: Border.all(
        color: error.withOpacity(0.2),
        width: 1,
      ),
    );
  }
  
  static BoxDecoration statusInfo({Color? textColor}) {
    return BoxDecoration(
      color: info.withOpacity(0.1),
      borderRadius: BorderRadius.circular(radiusMedium),
      border: Border.all(
        color: info.withOpacity(0.2),
        width: 1,
      ),
    );
  }
  
  // Button styles that can be applied directly
  static ButtonStyle get primaryButtonStyle {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) {
          return primaryNavy.withOpacity(0.5);
        }
        if (states.contains(MaterialState.hovered) || 
            states.contains(MaterialState.focused)) {
          return primaryNavyLight;
        }
        return primaryNavy;
      }),
      foregroundColor: MaterialStateProperty.all(Colors.white),
      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
        horizontal: 24, 
        vertical: 12,
      )),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
      )),
      minimumSize: MaterialStateProperty.all(const Size(0, 44)),
      textStyle: MaterialStateProperty.all(const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w500,
      )),
    );
  }
  
  static ButtonStyle get secondaryButtonStyle {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) {
          return secondaryGold.withOpacity(0.5);
        }
        if (states.contains(MaterialState.hovered) || 
            states.contains(MaterialState.focused)) {
          return secondaryGoldLight;
        }
        return secondaryGold;
      }),
      foregroundColor: MaterialStateProperty.all(primaryNavy),
      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
        horizontal: 24, 
        vertical: 12,
      )),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
      )),
      minimumSize: MaterialStateProperty.all(const Size(0, 44)),
      textStyle: MaterialStateProperty.all(const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w500,
      )),
    );
  }
  
  // Progress indicator styles
  static LinearProgressIndicator progressIndicator(double value, {Color? color}) {
    return LinearProgressIndicator(
      value: value,
      backgroundColor: const Color(0xFFE9ECEF),
      valueColor: AlwaysStoppedAnimation<Color>(color ?? accentTeal),
      borderRadius: BorderRadius.circular(radiusSmall),
    );
  }
  
  // Text styles for status indicators
  static TextStyle get successTextStyle => const TextStyle(
    color: success,
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  
  static TextStyle get warningTextStyle => const TextStyle(
    color: warning,
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  
  static TextStyle get errorTextStyle => const TextStyle(
    color: error,
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  
  static TextStyle get infoTextStyle => const TextStyle(
    color: info,
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  
  // Dark mode card styling
  static BoxDecoration get darkCardDecoration {
    return BoxDecoration(
      color: const Color(0xFF2A2A2A),
      borderRadius: BorderRadius.circular(radiusMedium),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
  
  // Get a color based on the development status
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return secondaryGold;
      case 'scheduled':
        return primaryNavy;
      case 'completed':
        return Colors.grey;
      case 'on hold':
        return warning;
      default:
        return Colors.grey;
    }
  }
  
  // Get a color for a lead status
  static Color getLeadStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return warning;
      case 'contacted':
        return primaryNavy;
      case 'interested':
        return secondaryGold;
      case 'converted':
        return accentTeal;
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
