import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:devpropertyhub/core/providers/auth_provider.dart';
import 'package:devpropertyhub/core/providers/bandwidth_provider.dart';
import 'package:devpropertyhub/core/routes/app_router.dart';
import 'package:devpropertyhub/features/auth/screens/login_screen.dart';
import 'package:devpropertyhub/features/dashboard/screens/dashboard_screen.dart';
import 'package:go_router/go_router.dart';

// Create more complete mock for AuthProvider
class TestAuthProvider extends AuthProvider {
  bool _isLoggedIn = false;
  UserRole _userRole = UserRole.viewer;

  @override
  bool get isLoggedIn => _isLoggedIn;

  @override
  UserRole get userRole => _userRole;

  // Expose setters for testing
  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  void setUserRole(UserRole role) {
    _userRole = role;
    notifyListeners();
  }
}

class MockBandwidthProvider extends Mock implements BandwidthProvider {
  @override
  bool get isLowBandwidth => false;
}

void main() {
  // Initialize Flutter binding
  TestWidgetsFlutterBinding.ensureInitialized();

  late TestAuthProvider authProvider;
  late MockBandwidthProvider bandwidthProvider;

  setUp(() {
    authProvider = TestAuthProvider();
    bandwidthProvider = MockBandwidthProvider();
  });

  group('Authentication Flow Tests', () {
    testWidgets('Unauthenticated user is redirected to login screen',
        (WidgetTester tester) async {
      // Set up to return unauthenticated
      authProvider.setLoggedIn(false);

      // Create app with router
      final router = AppRouter.router(authProvider);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
            ChangeNotifierProvider<BandwidthProvider>.value(
                value: bandwidthProvider),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      // Wait for redirects to complete
      await tester.pumpAndSettle();

      // Verify we're on the login screen
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('Authenticated user with viewer role can access dashboard',
        (WidgetTester tester) async {
      // Set up to return authenticated with viewer role
      authProvider.setLoggedIn(true);
      authProvider.setUserRole(UserRole.viewer);

      // Create app with router
      final router = AppRouter.router(authProvider);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
            ChangeNotifierProvider<BandwidthProvider>.value(
                value: bandwidthProvider),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      // Wait for redirects to complete
      await tester.pumpAndSettle();

      // Verify we're on the dashboard
      expect(find.byType(DashboardScreen), findsOneWidget);
    });
  });
}
