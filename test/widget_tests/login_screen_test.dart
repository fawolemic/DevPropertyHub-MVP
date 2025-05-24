import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:devpropertyhub/core/providers/auth_provider.dart';
import 'package:devpropertyhub/core/providers/bandwidth_provider.dart';
import 'package:devpropertyhub/features/auth/screens/login_screen.dart';

// Create testable auth provider
class TestableAuthProvider extends AuthProvider {
  bool _isCallbackCalled = false;
  String? _lastEmail;
  String? _lastPassword;
  
  bool get isCallbackCalled => _isCallbackCalled;
  String? get lastEmail => _lastEmail;
  String? get lastPassword => _lastPassword;
  
  @override
  Future<bool> signIn(String email, String password) async {
    _isCallbackCalled = true;
    _lastEmail = email;
    _lastPassword = password;
    return true; // Return success for tests
  }
  
  void reset() {
    _isCallbackCalled = false;
    _lastEmail = null;
    _lastPassword = null;
  }
}

// Create mock bandwidth provider
class MockBandwidthProvider extends BandwidthProvider {
  @override
  bool get isLowBandwidth => false;
}

void main() {
  // Initialize Flutter binding
  TestWidgetsFlutterBinding.ensureInitialized();
  
  late TestableAuthProvider authProvider;
  late MockBandwidthProvider bandwidthProvider;

  setUp(() {
    authProvider = TestableAuthProvider();
    bandwidthProvider = MockBandwidthProvider();
    authProvider.reset();
  });

  Widget createTestApp() {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
          ChangeNotifierProvider<BandwidthProvider>.value(value: bandwidthProvider),
        ],
        child: const LoginScreen(),
      ),
    );
  }

  testWidgets('Login screen displays correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle();

    // Verify application title appears
    expect(find.text('DevPropertyHub'), findsOneWidget);
    expect(find.text('Property Developer Portal'), findsOneWidget);
    
    // Verify sign in title appears in the form
    expect(find.text('Sign In'), findsAtLeast(1));
    
    // Verify input fields exist
    expect(find.byType(TextFormField), findsAtLeast(2)); // Email and password fields
    
    // Verify login button exists
    final signInButton = find.ancestor(
      of: find.text('Sign In'),
      matching: find.byType(ElevatedButton),
    );
    expect(signInButton, findsOneWidget);
    
    // Verify demo access section exists
    expect(find.text('Demo Access'), findsOneWidget);
  });

  testWidgets('Form validation works correctly', (WidgetTester tester) async {
    // Build the login screen
    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle();

    // Find and tap the login button without entering credentials
    final loginButton = find.ancestor(
      of: find.text('Sign In'),
      matching: find.byType(ElevatedButton),
    ).first;
    
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Verify validation error messages appear
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('Login with valid credentials calls signIn', (WidgetTester tester) async {
    // Build the login screen
    await tester.pumpWidget(createTestApp());
    await tester.pumpAndSettle();

    // Find the TextFormField widgets by their decoration labels
    final emailField = find.descendant(
      of: find.byType(TextFormField),
      matching: find.descendant(
        of: find.byType(InputDecoration),
        matching: find.text('Email'),
      ),
    ).first;
    
    final passwordField = find.descendant(
      of: find.byType(TextFormField),
      matching: find.descendant(
        of: find.byType(InputDecoration),
        matching: find.text('Password'),
      ),
    ).first;
    
    // If the above finders don't work, try this simpler approach:
    // We know the email field is the first TextFormField
    final emailFieldByIndex = find.byType(TextFormField).first;
    final passwordFieldByIndex = find.byType(TextFormField).at(1);
    
    // Enter credentials
    await tester.enterText(emailFieldByIndex, 'admin@example.com');
    await tester.enterText(passwordFieldByIndex, 'password');
    
    // Verify provider not called yet
    expect(authProvider.isCallbackCalled, false);
    
    // Find login button
    final loginButton = find.ancestor(
      of: find.text('Sign In'),
      matching: find.byType(ElevatedButton),
    ).first;
    
    // Tap the login button
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    
    // Verify signIn was called with correct parameters
    expect(authProvider.isCallbackCalled, true);
    expect(authProvider.lastEmail, 'admin@example.com');
    expect(authProvider.lastPassword, 'password');
  });
}
