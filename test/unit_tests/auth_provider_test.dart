import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:devpropertyhub/core/providers/auth_provider.dart';

void main() {
  late AuthProvider authProvider;
  
  setUp(() {
    // Initialize SharedPreferences
    SharedPreferences.setMockInitialValues({});
    
    // Create instance of AuthProvider
    authProvider = AuthProvider();
  });

  group('AuthProvider Tests', () {
    test('Initial state should be unauthenticated', () {
      // Verify initial state
      expect(authProvider.isLoggedIn, false);
      expect(authProvider.userRole, UserRole.viewer);
    });

    test('Admin role check works correctly', () {
      // Directly test the getters without authentication
      expect(authProvider.isAdmin, false);
      expect(authProvider.isStandard, false);
      expect(authProvider.isViewer, true); // Default is viewer
    });
    
    test('Permission check methods work correctly', () {
      // Test canEdit (should be false for viewer)
      expect(authProvider.canEdit, false);
    });
  });
}
