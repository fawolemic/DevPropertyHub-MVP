import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:devpropertyhub/features/auth/screens/additional_setup/common/email_verification_screen.dart';

void main() {
  group('EmailVerificationScreen', () {
    testWidgets('should display email address and verification fields',
        (WidgetTester tester) async {
      bool verificationComplete = false;
      const testEmail = 'test@example.com';

      await tester.pumpWidget(MaterialApp(
        home: EmailVerificationScreen(
          email: testEmail,
          onVerificationComplete: (success) {
            verificationComplete = success;
          },
        ),
      ));

      // Verify screen title
      expect(find.text('Email Verification'), findsOneWidget);
      expect(find.text('Verify Your Email'), findsOneWidget);

      // Verify email is displayed
      expect(find.text('We\'ve sent a verification code to:'), findsOneWidget);
      expect(find.text(testEmail), findsOneWidget);

      // Verify input fields
      expect(find.byType(TextField), findsNWidgets(6));

      // Verify buttons
      expect(find.text('Verify Email'), findsOneWidget);
      expect(find.text('Resend Code'), findsOneWidget);
    });

    testWidgets('should show error when incomplete code is submitted',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: EmailVerificationScreen(
          email: 'test@example.com',
          onVerificationComplete: (_) {},
        ),
      ));

      // Only fill in first 3 digits
      for (int i = 0; i < 3; i++) {
        await tester.enterText(find.byType(TextField).at(i), '$i');
      }

      // Try to verify
      await tester.tap(find.text('Verify Email'));
      await tester.pump();

      // Verify error message is shown
      expect(
          find.text('Please enter the complete 6-digit code'), findsOneWidget);
    });

    testWidgets('should auto-advance focus when digit is entered',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: EmailVerificationScreen(
          email: 'test@example.com',
          onVerificationComplete: (_) {},
        ),
      ));

      // Enter digit in first field
      await tester.enterText(find.byType(TextField).first, '1');
      await tester.pump();

      // Verify focus moved to second field
      expect(
          tester
              .widget<TextField>(find.byType(TextField).at(1))
              .focusNode
              ?.hasFocus,
          isTrue);
    });

    testWidgets('should handle resend code button state',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: EmailVerificationScreen(
          email: 'test@example.com',
          onVerificationComplete: (_) {},
        ),
      ));

      // Tap resend code
      await tester.tap(find.text('Resend Code'));
      await tester.pump();

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for resend operation
      await tester.pump(const Duration(seconds: 2));

      // Should show countdown
      expect(find.textContaining('Resend in'), findsOneWidget);
    });

    testWidgets(
        'should call onVerificationComplete when correct code is entered',
        (WidgetTester tester) async {
      bool verificationComplete = false;

      await tester.pumpWidget(MaterialApp(
        home: EmailVerificationScreen(
          email: 'test@example.com',
          onVerificationComplete: (success) {
            verificationComplete = success;
          },
        ),
      ));

      // Enter the correct code (123456)
      for (int i = 0; i < 6; i++) {
        await tester.enterText(
            find.byType(TextField).at(i),
            i == 0
                ? '1'
                : (i == 1
                    ? '2'
                    : (i == 2 ? '3' : (i == 3 ? '4' : (i == 4 ? '5' : '6')))));
      }

      // Verify
      await tester.tap(find.text('Verify Email'));
      await tester.pump();

      // Loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for verification
      await tester.pump(const Duration(seconds: 2));

      // Callback should have been called
      expect(verificationComplete, isTrue);
    });
  });
}
