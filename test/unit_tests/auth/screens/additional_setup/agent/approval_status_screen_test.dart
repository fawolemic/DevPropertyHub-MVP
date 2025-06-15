import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:devpropertyhub/features/auth/screens/additional_setup/agent/approval_status_screen.dart';

void main() {
  group('ApprovalStatusScreen', () {
    testWidgets('displays all approval status components correctly',
        (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: ApprovalStatusScreen(agentName: 'Test Agent'),
        ),
      );

      // Verify the app bar
      expect(find.text('Application Status'), findsOneWidget);

      // Verify the status card
      expect(find.byIcon(Icons.find_in_page), findsOneWidget);
      expect(find.text('Under Review'), findsOneWidget);

      // Verify the timeline
      expect(find.text('Approval Timeline'), findsOneWidget);
      expect(find.text('Application Submitted'), findsOneWidget);
      expect(find.text('Document Review'), findsOneWidget);
      expect(find.text('Background Verification'), findsOneWidget);
      expect(find.text('Approval Decision'), findsOneWidget);

      // Verify help section
      expect(find.text('Need Help?'), findsOneWidget);
      expect(find.text('Contact Support'), findsOneWidget);
      expect(find.text('Submit Documents'), findsOneWidget);
    });

    testWidgets('shows contact support dialog when button is tapped',
        (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: ApprovalStatusScreen(agentName: 'Test Agent'),
        ),
      );

      // Tap the contact support button
      await tester.tap(find.text('Contact Support'));
      await tester.pumpAndSettle();

      // Verify the dialog appears with correct content
      expect(find.text('Contact Support'), findsWidgets); // Title + button
      expect(
          find.text(
              'Our support team is available to help you with any questions about your agent application.'),
          findsOneWidget);
      expect(find.text('Email: support@devpropertyhub.com'), findsOneWidget);
      expect(find.text('Phone: +234 800 123 4567'), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Verify dialog is dismissed
      expect(
          find.text(
              'Our support team is available to help you with any questions about your agent application.'),
          findsNothing);
    });

    testWidgets('shows upload documents dialog when button is tapped',
        (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: ApprovalStatusScreen(agentName: 'Test Agent'),
        ),
      );

      // Tap the submit documents button
      await tester.tap(find.text('Submit Documents'));
      await tester.pumpAndSettle();

      // Verify the dialog appears with correct content
      expect(find.text('Submit Additional Documents'), findsOneWidget);
      expect(
          find.text(
              'If you\'ve been asked to provide additional documentation for your application, you can upload it here.'),
          findsOneWidget);
      expect(find.text('Select File'), findsOneWidget);

      // Tap the select file button which should close the dialog in our mock implementation
      await tester.tap(find.text('Select File'));
      await tester.pumpAndSettle();

      // Verify snackbar appears
      expect(find.text('Document uploaded successfully'), findsOneWidget);
    });
  });
}
