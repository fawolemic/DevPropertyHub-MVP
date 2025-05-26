import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:devpropertyhub/features/auth/widgets/components/validation/password_validator.dart';

void main() {
  group('PasswordValidator', () {
    group('validate()', () {
      test('should return error for empty password', () {
        expect(PasswordValidator.validate(''), 'Password is required');
      });
      
      test('should return error for null password', () {
        expect(PasswordValidator.validate(null), 'Password is required');
      });
      
      test('should return error for short password', () {
        expect(PasswordValidator.validate('abc123'), 
          'Password must be at least 8 characters long');
      });
      
      test('should return error for password without uppercase', () {
        expect(PasswordValidator.validate('abcdefg123'), 
          'Password must contain at least one uppercase letter');
      });
      
      test('should return error for password without numbers', () {
        expect(PasswordValidator.validate('AbcdefgH'), 
          'Password must contain at least one number');
      });
      
      test('should return null for valid password', () {
        expect(PasswordValidator.validate('Abcdefg123'), null);
      });
    });
    
    group('calculateStrength()', () {
      test('should return 0 for very weak password', () {
        expect(PasswordValidator.calculateStrength('ab'), 0);
      });
      
      test('should return 1 for weak password with only length', () {
        expect(PasswordValidator.calculateStrength('abcdefgh'), 1);
      });
      
      test('should return 2 for medium password', () {
        expect(PasswordValidator.calculateStrength('Abcdefgh'), 2);
      });
      
      test('should return 3 for strong password', () {
        expect(PasswordValidator.calculateStrength('Abcdefg1'), 3);
      });
      
      test('should return 4 for very strong password', () {
        expect(PasswordValidator.calculateStrength('Abcdefg1!'), 4);
      });
      
      test('should return 4 for extremely strong password', () {
        expect(PasswordValidator.calculateStrength('Abcdefg1!23456$'), 4);
      });
    });
    
    group('getStrengthColor()', () {
      test('should return red for weak passwords', () {
        expect(PasswordValidator.getStrengthColor(0), Colors.red);
        expect(PasswordValidator.getStrengthColor(1), Colors.red);
      });
      
      test('should return orange for medium passwords', () {
        expect(PasswordValidator.getStrengthColor(2), Colors.orange);
      });
      
      test('should return yellow for strong passwords', () {
        expect(PasswordValidator.getStrengthColor(3), Colors.yellow);
      });
      
      test('should return green for very strong passwords', () {
        expect(PasswordValidator.getStrengthColor(4), Colors.green);
      });
    });
    
    group('getStrengthText()', () {
      test('should return correct text for each strength level', () {
        expect(PasswordValidator.getStrengthText(0), 'Very Weak');
        expect(PasswordValidator.getStrengthText(1), 'Weak');
        expect(PasswordValidator.getStrengthText(2), 'Medium');
        expect(PasswordValidator.getStrengthText(3), 'Strong');
        expect(PasswordValidator.getStrengthText(4), 'Very Strong');
      });
    });
  });
}
