import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:devpropertyhub/features/auth/screens/additional_setup/developer/subscription_selection.dart';

void main() {
  group('SubscriptionSelectionScreen', () {
    testWidgets('should display all subscription plans',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: SubscriptionSelectionScreen(),
      ));

      // Verify screen title and description
      expect(find.text('Select Subscription Plan'), findsOneWidget);
      expect(find.text('Choose Your Plan'), findsOneWidget);
      expect(
          find.text('Select the subscription plan that best suits your needs'),
          findsOneWidget);

      // Verify all plan types are displayed
      expect(find.text('Basic'), findsOneWidget);
      expect(find.text('Premium'), findsOneWidget);
      expect(find.text('Enterprise'), findsOneWidget);

      // Verify pricing is displayed
      expect(find.text('NGN 50,000/month'), findsOneWidget);
      expect(find.text('NGN 100,000/month'), findsOneWidget);
      expect(find.text('NGN 250,000/month'), findsOneWidget);

      // Verify the recommended badge is displayed for Premium plan
      expect(find.text('RECOMMENDED'), findsOneWidget);

      // Verify buttons are displayed
      expect(find.text('Continue to Payment'), findsOneWidget);
      expect(find.text('Skip for now'), findsOneWidget);
    });

    testWidgets('should allow selecting a different plan',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: SubscriptionSelectionScreen(),
      ));

      // Premium should be selected by default (check indicator is visible)
      expect(
          find.descendant(
            of: find.widgetWithText(Card, 'Premium'),
            matching: find.byIcon(Icons.check),
          ),
          findsOneWidget);

      // Tap on Basic plan
      await tester.tap(find.widgetWithText(Card, 'Basic'));
      await tester.pump();

      // Basic should now be selected
      expect(
          find.descendant(
            of: find.widgetWithText(Card, 'Basic'),
            matching: find.byIcon(Icons.check),
          ),
          findsOneWidget);

      // Premium should no longer be selected
      expect(
          find.descendant(
            of: find.widgetWithText(Card, 'Premium'),
            matching: find.byIcon(Icons.check),
          ),
          findsNothing);
    });

    testWidgets('should show snackbar when proceeding to payment',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: SubscriptionSelectionScreen(),
      ));

      // Tap the continue button
      await tester.tap(find.text('Continue to Payment'));
      await tester.pump();

      // Verify snackbar is shown (this is a stub implementation for the test)
      expect(
          find.text('Proceeding to payment for premium plan'), findsOneWidget);
    });

    testWidgets('should show snackbar when skipping subscription',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: SubscriptionSelectionScreen(),
      ));

      // Tap the skip button
      await tester.tap(find.text('Skip for now'));
      await tester.pump();

      // Verify snackbar is shown
      expect(find.text('Subscription selection skipped'), findsOneWidget);
    });
  });
}
