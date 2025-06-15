import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:devpropertyhub/core/theme/app_theme.dart';

// Unit tests for AppTheme utility methods only, avoiding GoogleFonts issues
void main() {
  group('AppTheme Utility Methods Tests', () {
    test('getStatusColor returns appropriate colors for different statuses',
        () {
      // Test active status returns a green shade
      final activeColor = AppTheme.getStatusColor('active');
      expect(activeColor, isA<Color>());
      expect(activeColor.value, equals(const Color(0xFF388E3C).value));

      // Test scheduled status returns a blue shade
      final scheduledColor = AppTheme.getStatusColor('scheduled');
      expect(scheduledColor, isA<Color>());
      expect(scheduledColor.value, equals(const Color(0xFF1976D2).value));

      // Test completed status returns grey
      final completedColor = AppTheme.getStatusColor('completed');
      expect(completedColor, isA<Color>());
      expect(completedColor.value, equals(Colors.grey.value));

      // Test default case
      final unknownColor = AppTheme.getStatusColor('unknown');
      expect(unknownColor, isA<Color>());
    });

    test('getLeadStatusColor returns appropriate colors for different statuses',
        () {
      // Test new lead status
      final newColor = AppTheme.getLeadStatusColor('new');
      expect(newColor, isA<Color>());

      // Test contacted lead status
      final contactedColor = AppTheme.getLeadStatusColor('contacted');
      expect(contactedColor, isA<Color>());

      // Test unknown status (default case)
      final unknownColor = AppTheme.getLeadStatusColor('unknown');
      expect(unknownColor, isA<Color>());
    });

    test('cardDecoration provides expected box decoration properties', () {
      final decoration = AppTheme.cardDecoration;

      // Verify properties
      expect(decoration, isA<BoxDecoration>());
      expect(decoration.color, equals(Colors.white));
      expect(decoration.borderRadius, isNotNull);
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.length, greaterThan(0));
    });

    test('darkCardDecoration provides expected dark mode properties', () {
      final darkDecoration = AppTheme.darkCardDecoration;

      // Verify properties
      expect(darkDecoration, isA<BoxDecoration>());
      expect(darkDecoration.color, isNotNull); // Should be a dark color
      expect(darkDecoration.borderRadius, isNotNull);
      expect(darkDecoration.boxShadow, isNotNull);
    });
  });
}
