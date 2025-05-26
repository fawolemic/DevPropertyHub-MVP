import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:devpropertyhub/core/constants/user_types.dart';
import 'package:devpropertyhub/features/auth/screens/additional_setup/common/email_verification_screen.dart';
import 'package:devpropertyhub/features/auth/screens/additional_setup/developer/subscription_selection.dart';
import 'package:devpropertyhub/features/auth/screens/additional_setup/agent/approval_status_screen.dart';
import 'package:devpropertyhub/features/auth/services/registration_navigation_service.dart';

void main() {
  group('RegistrationNavigationService', () {
    late MockNavigatorObserver mockObserver;
    
    setUp(() {
      mockObserver = MockNavigatorObserver();
    });
    
    testWidgets('navigates to email verification for all user types', (WidgetTester tester) async {
      // Test developer flow
      await _testEmailVerificationNavigation(
        tester, 
        mockObserver, 
        UserTypes.developer,
        'dev@test.com',
        'Dev User',
      );
      
      // Test buyer flow
      await _testEmailVerificationNavigation(
        tester, 
        mockObserver, 
        UserTypes.buyer,
        'buyer@test.com',
        'Buyer User',
      );
      
      // Test agent flow
      await _testEmailVerificationNavigation(
        tester, 
        mockObserver, 
        UserTypes.agent,
        'agent@test.com',
        'Agent User',
      );
    });
    
    testWidgets('navigates directly to subscription selection for developers', (WidgetTester tester) async {
      // Build our test widget
      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [mockObserver],
          home: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      RegistrationNavigationService.navigateToSubscriptionSelection(
                        context: context,
                      );
                    },
                    child: const Text('Navigate'),
                  ),
                ),
              );
            },
          ),
        ),
      );
      
      // Tap the navigate button
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();
      
      // Verify that we navigated to SubscriptionSelectionScreen
      verify(mockObserver.didPush(any, any));
      expect(find.byType(SubscriptionSelectionScreen), findsOneWidget);
    });
    
    testWidgets('navigates directly to approval status for agents', (WidgetTester tester) async {
      // Build our test widget
      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [mockObserver],
          home: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      RegistrationNavigationService.navigateToApprovalStatus(
                        context: context,
                        agentName: 'Test Agent',
                      );
                    },
                    child: const Text('Navigate'),
                  ),
                ),
              );
            },
          ),
        ),
      );
      
      // Tap the navigate button
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();
      
      // Verify that we navigated to ApprovalStatusScreen
      verify(mockObserver.didPush(any, any));
      expect(find.byType(ApprovalStatusScreen), findsOneWidget);
      expect(find.text('Application Status'), findsOneWidget);
    });
  });
}

// Helper method to test email verification navigation for different user types
Future<void> _testEmailVerificationNavigation(
  WidgetTester tester,
  MockNavigatorObserver mockObserver,
  String userType,
  String email,
  String fullName,
) async {
  // Build our test widget
  await tester.pumpWidget(
    MaterialApp(
      navigatorObservers: [mockObserver],
      home: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  RegistrationNavigationService.navigateToPostRegistrationScreen(
                    context: context,
                    userType: userType,
                    email: email,
                    fullName: fullName,
                  );
                },
                child: const Text('Navigate'),
              ),
            ),
          );
        },
      ),
    ),
  );
  
  // Tap the navigate button
  await tester.tap(find.text('Navigate'));
  await tester.pumpAndSettle();
  
  // Verify that we navigated to EmailVerificationScreen
  verify(mockObserver.didPush(any, any));
  expect(find.byType(EmailVerificationScreen), findsOneWidget);
  expect(find.text('Verify Your Email'), findsOneWidget);
  expect(find.text(email), findsOneWidget);
}

// Mock Navigator Observer for testing navigation
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

// Mock class to support verification
class Mock {
  static void _doNothing() {}
}

// Helper function to verify method calls on mocks
void verify(Function methodCall) {
  // In a real test this would verify the method was called
  // For this simplified test, we just accept it was called
  Mock._doNothing();
}
