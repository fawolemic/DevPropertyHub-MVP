import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:devpropertyhub/features/auth/widgets/components/terms_and_conditions.dart';

void main() {
  group('TermsAndConditionsCheckbox', () {
    testWidgets('should render checkbox and terms text',
        (WidgetTester tester) async {
      bool checkboxValue = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TermsAndConditionsCheckbox(
            value: checkboxValue,
            onChanged: (value) {
              checkboxValue = value ?? false;
            },
          ),
        ),
      ));

      // Verify checkbox is rendered
      expect(find.byType(Checkbox), findsOneWidget);

      // Verify text is rendered
      expect(find.text('I agree to the '), findsOneWidget);
      expect(find.text('Terms of Service'), findsOneWidget);
      expect(find.text(' and '), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
    });

    testWidgets('should display error text when provided',
        (WidgetTester tester) async {
      const errorText = 'You must accept the terms and conditions';

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: const TermsAndConditionsCheckbox(
            value: false,
            onChanged: null,
            errorText: errorText,
          ),
        ),
      ));

      // Verify error text is displayed
      expect(find.text(errorText), findsOneWidget);
    });

    testWidgets('should call onChanged when checkbox is tapped',
        (WidgetTester tester) async {
      bool checkboxValue = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return TermsAndConditionsCheckbox(
                value: checkboxValue,
                onChanged: (value) {
                  setState(() {
                    checkboxValue = value ?? false;
                  });
                },
              );
            },
          ),
        ),
      ));

      // Verify initial state
      expect(checkboxValue, false);

      // Tap the checkbox
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Verify value changed
      expect(checkboxValue, true);
    });
  });
}
