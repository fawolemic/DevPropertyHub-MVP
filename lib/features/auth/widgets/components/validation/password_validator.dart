import 'package:flutter/material.dart';

/// PasswordValidator
/// 
/// Provides validation rules for password fields in authentication forms.
/// Contains methods for strength checking and requirement verification.
/// 
/// SEARCH TAGS: #auth #validation #password #security
class PasswordValidator {
  /// Validates a password against security requirements
  /// 
  /// Returns null if valid, or an error message if invalid
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    
    if (!_containsUppercase(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    
    if (!_containsDigit(value)) {
      return 'Password must contain at least one number';
    }
    
    return null;
  }
  
  /// Calculates password strength on a scale of 0-4
  /// 
  /// 0: Very Weak, 1: Weak, 2: Medium, 3: Strong, 4: Very Strong
  static int calculateStrength(String password) {
    int strength = 0;
    
    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;
    if (_containsUppercase(password)) strength++;
    if (_containsDigit(password)) strength++;
    if (_containsSpecialChar(password)) strength++;
    
    return strength > 4 ? 4 : strength;
  }
  
  /// Returns a color representing password strength
  static Color getStrengthColor(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
  
  /// Returns a text description of password strength
  static String getStrengthText(int strength) {
    switch (strength) {
      case 0:
        return 'Very Weak';
      case 1:
        return 'Weak';
      case 2:
        return 'Medium';
      case 3:
        return 'Strong';
      case 4:
        return 'Very Strong';
      default:
        return '';
    }
  }
  
  /// Checks if password contains at least one uppercase letter
  static bool _containsUppercase(String value) => 
      value.contains(RegExp(r'[A-Z]'));
  
  /// Checks if password contains at least one digit
  static bool _containsDigit(String value) => 
      value.contains(RegExp(r'[0-9]'));
  
  /// Checks if password contains at least one special character
  static bool _containsSpecialChar(String value) => 
      value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
}
