import 'package:flutter/material.dart';

/// Utility functions for responsive design
class ResponsiveUtils {
  /// Screen size breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  
  /// Check if the current screen size is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }
  
  /// Check if the current screen size is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }
  
  /// Check if the current screen size is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }
  
  /// Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24.0);
    } else {
      return const EdgeInsets.all(32.0);
    }
  }
  
  /// Get responsive horizontal padding based on screen size
  static EdgeInsets getResponsiveHorizontalPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 16.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 24.0);
    } else {
      return const EdgeInsets.symmetric(horizontal: 32.0);
    }
  }
  
  /// Get responsive vertical padding based on screen size
  static EdgeInsets getResponsiveVerticalPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(vertical: 12.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(vertical: 16.0);
    } else {
      return const EdgeInsets.symmetric(vertical: 24.0);
    }
  }
  
  /// Get responsive font size based on screen size
  static double getResponsiveFontSize(BuildContext context, {required double base}) {
    if (isMobile(context)) {
      return base * 0.8;
    } else if (isTablet(context)) {
      return base * 0.9;
    } else {
      return base;
    }
  }
  
  /// Get responsive grid count based on screen size
  static int getResponsiveGridCount(BuildContext context) {
    if (isMobile(context)) {
      return 1;
    } else if (isTablet(context)) {
      return 2;
    } else {
      return 3;
    }
  }
  
  /// Get responsive card width for horizontal scrolling lists
  static double getResponsiveCardWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      // For very small mobile screens
      return width * 0.8;
    } else if (width < tabletBreakpoint) {
      // For larger mobile and small tablet screens
      return width * 0.7;
    } else {
      // For larger tablets and desktop
      return width * 0.4;
    }
  }
  
  /// Get responsive spacing
  static double getResponsiveSpacing(BuildContext context, {double multiplier = 1.0}) {
    if (isMobile(context)) {
      return 8.0 * multiplier;
    } else if (isTablet(context)) {
      return 12.0 * multiplier;
    } else {
      return 16.0 * multiplier;
    }
  }
  
  /// Get responsive border radius
  static double getResponsiveBorderRadius(BuildContext context) {
    if (isMobile(context)) {
      return 8.0;
    } else if (isTablet(context)) {
      return 12.0;
    } else {
      return 16.0;
    }
  }
  
  /// Get responsive icon size
  static double getResponsiveIconSize(BuildContext context) {
    if (isMobile(context)) {
      return 18.0;
    } else if (isTablet(context)) {
      return 22.0;
    } else {
      return 24.0;
    }
  }
}
